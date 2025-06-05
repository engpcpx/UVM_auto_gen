#!/usr/bin/env python3
"""
VEGA - Verification Environment Generator Assembler
Version: 5.0.0 (Unified) with UVM Macros Integration

Features:
- Integrated support for unit and system tests using UVM macros
- Automatic hierarchical analysis
- Configurable verification plan
- Adaptable templates for RISC-V and generic designs
- Full integration with uvm_macro.svh
"""

import os
import re
import sys
import math
import json
import zipfile
from datetime import datetime
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple
from pathlib import Path
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
from jinja2 import Environment, FileSystemLoader, TemplateNotFound
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from collections import defaultdict
import traceback

# ---------------------------------------------------------------
# Extended Data Structures
# ---------------------------------------------------------------
@dataclass
class VerificationPlan:
    """Complete verification plan configuration"""
    unit_tests: Dict[str, bool] = field(default_factory=lambda: {
        'functional': True,
        'edge_cases': True,
        'reset_tests': True
    })
    system_tests: Dict[str, bool] = field(default_factory=lambda: {
        'interface_consistency': True,
        'dataflow': True,
        'performance': False,
        'concurrency': False
    })
    coverage_goals: Dict[str, int] = field(default_factory=lambda: {
        'line': 90,
        'toggle': 80,
        'fsm': 95,
        'assertion': 85
    })
    test_weights: Dict[str, int] = field(default_factory=lambda: {
        'smoke': 30,
        'random': 50,
        'stress': 20
    })
    custom_checks: List[str] = field(default_factory=list)

@dataclass
class Port:
    """Represents an RTL module port"""
    name: str
    direction: str  # 'input', 'output', 'inout'
    width: str = "1"
    description: str = ""
    connected_to: str = ""  # Added to store connections
    
    def __post_init__(self):
        """Validates and normalizes port data"""
        if self.direction not in ['input', 'output', 'inout']:
            raise ValueError(f"Invalid port direction: {self.direction}")
        
        # Normalize width
        if self.width and self.width != "1":
            self.width = self.width.strip()
            if not self.width.startswith('['):
                self.width = f"[{self.width}]"

@dataclass
class ModuleInfo:
    """Information extracted from RTL module"""
    name: str
    ports: List[Port] = field(default_factory=list)
    parameters: Dict[str, str] = field(default_factory=dict)
    clock_signals: List[str] = field(default_factory=lambda: ['clk', 'clock'])
    reset_signals: List[str] = field(default_factory=lambda: ['rst', 'reset'])
    instances: Dict[str, str] = field(default_factory=dict)  # Submodule instances

    def get_input_ports(self) -> List[Port]:
        """Returns only input ports"""
        return [p for p in self.ports if p.direction == 'input']
    
    def get_output_ports(self) -> List[Port]:
        """Returns only output ports"""
        return [p for p in self.ports if p.direction == 'output']
    
    def get_inout_ports(self) -> List[Port]:
        """Returns only inout ports"""
        return [p for p in self.ports if p.direction == 'inout']

@dataclass
class ModuleHierarchy:
    """Represents the complete design hierarchy"""
    top_level: ModuleInfo
    submodules: Dict[str, ModuleInfo]  # Instance name -> ModuleInfo
    connections: List[Tuple[str, str, str, str]]  # (src_mod, src_port, dest_mod, dest_port)
    file_mapping: Dict[str, str]  # Module name -> source file

@dataclass
class SystemTestConfig:
    """Configuration for system tests"""
    enable_pipeline_verification: bool = True
    check_interfaces: bool = True
    generate_cross_coverage: bool = True
    monitor_performance: bool = False

@dataclass
class TestResult:
    scenario: str
    passed: int = 0
    failed: int = 0
    coverage: float = 0.0
    execution_time: float = 0.0
    subsystem_results: Dict[str, Dict[str, float]] = field(default_factory=dict)  # Results by subsystem

# ---------------------------------------------------------------
# Hierarchical Analyzer 
# ---------------------------------------------------------------
class RTLAnalyzer:
    """Class responsible for RTL module analysis"""
    
    @staticmethod
    def extract_module_info(file_path: str) -> ModuleInfo:
        """Extracts information from SystemVerilog/Verilog module"""
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"File not found: {file_path}")
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeDecodeError:
            with open(file_path, 'r', encoding='latin-1') as f:
                content = f.read()
        
        # Remove comments
        content = RTLAnalyzer._remove_comments(content)
        
        # Find module declaration
        module_match = re.search(
            r'module\s+(\w+)\s*(?:#\s*\([^)]*\))?\s*\(\s*(.*?)\s*\)\s*;', 
            content, 
            re.DOTALL | re.IGNORECASE
        )
        
        if not module_match:
            raise ValueError("Module declaration not found")
        
        module_name = module_match.group(1)
        ports_section = module_match.group(2)
        
        module_info = ModuleInfo(name=module_name)
        
        # Extract ports
        module_info.ports = RTLAnalyzer._extract_ports(ports_section, content)
        
        # Extract parameters
        module_info.parameters = RTLAnalyzer._extract_parameters(content)
        
        # Extract instances and connections
        module_info.instances = RTLAnalyzer._extract_instances(content)
        
        # Extract port connections
        RTLAnalyzer._extract_port_connections(content, module_info)
        
        return module_info
    
    @staticmethod
    def _remove_comments(content: str) -> str:
        """Removes // and /* */ comments from code"""
        content = re.sub(r'//.*?$', '', content, flags=re.MULTILINE)
        content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        return content
    
    @staticmethod
    def _extract_ports(ports_section: str, full_content: str) -> List[Port]:
        """Extracts port information"""
        ports = []
        port_pattern = r'(input|output|inout)\s+(?:(wire|reg)\s+)?(?:(signed)\s+)?(\[.*?\])?\s*(\w+)'
        
        # Look for declarations in ports section
        port_matches = re.findall(port_pattern, ports_section, re.IGNORECASE)
        
        for direction, wire_type, signed, width, name in port_matches:
            port = Port(
                name=name.strip(),
                direction=direction.lower(),
                width=width.strip() if width else "1"
            )
            ports.append(port)
        
        # If no ports found in declaration, look in module body
        if not ports:
            ports = RTLAnalyzer._extract_ports_from_body(full_content)
        
        return ports
    
    @staticmethod
    def _extract_ports_from_body(content: str) -> List[Port]:
        """Extracts ports from module body (separate declarations)"""
        ports = []
        separate_pattern = r'(input|output|inout)\s+(?:(wire|reg)\s+)?(?:(signed)\s+)?(\[.*?\])?\s*(\w+(?:\s*,\s*\w+)*)\s*;'
        
        matches = re.findall(separate_pattern, content, re.IGNORECASE | re.MULTILINE)
        
        for direction, wire_type, signed, width, names in matches:
            name_list = [name.strip() for name in names.split(',')]
            
            for name in name_list:
                if name:
                    port = Port(
                        name=name,
                        direction=direction.lower(),
                        width=width.strip() if width else "1"
                    )
                    ports.append(port)
        
        return ports
    
    @staticmethod
    def _extract_parameters(content: str) -> Dict[str, str]:
        """Extracts module parameters"""
        parameters = {}
        param_pattern = r'parameter\s+(?:\w+\s+)?(\w+)\s*=\s*([^;,]+)'
        
        matches = re.findall(param_pattern, content, re.IGNORECASE)
        
        for name, value in matches:
            parameters[name.strip()] = value.strip()
        
        return parameters

    @staticmethod
    def _extract_instances(content: str) -> Dict[str, str]:
        """Extracts module instances"""
        instances = {}
        instance_pattern = r'\b(\w+)\s+(\w+)\s*\('
        
        matches = re.findall(instance_pattern, content)
        for module_name, instance_name in matches:
            instances[instance_name] = module_name
            
        return instances

    @staticmethod
    def _extract_port_connections(content: str, module_info: ModuleInfo):
        """Extracts port connections from module content"""
        port_connections = re.findall(r'\.(\w+)\s*\(\s*(\w+)\s*\)', content)
        for port_name, connection in port_connections:
            for port in module_info.ports:
                if port.name == port_name:
                    port.connected_to = connection
                    break

    @staticmethod
    def extract_hierarchy(project_dir: str) -> ModuleHierarchy:
        """Analyzes a complete project and extracts the hierarchy"""
        module_files = list(Path(project_dir).glob("**/*.[svv]"))
        modules = {}
        
        # Step 1: Extract all modules
        for file in module_files:
            try:
                module_info = RTLAnalyzer.extract_module_info(str(file))
                modules[module_info.name] = module_info
            except ValueError as e:
                continue
        
        # Step 2: Identify top-level (module not instantiated by others)
        top_level_candidates = set(modules.keys())
        for module in modules.values():
            for instance in module.instances.values():
                if instance in top_level_candidates:
                    top_level_candidates.remove(instance)
        
        if not top_level_candidates:
            raise ValueError("Could not identify top-level module")
        
        top_level_name = next(iter(top_level_candidates))
        top_level = modules[top_level_name]
        
        # Step 3: Map hierarchical connections
        connections = []
        for module in modules.values():
            for port in module.ports:
                if port.connected_to:
                    src_mod, src_port = port.connected_to.split('.')
                    connections.append((module.name, port.name, src_mod, src_port))
        
        # Step 4: Create file mapping
        file_mapping = {mod.name: str(file) for file, mod in zip(module_files, modules.values())}
        
        # Step 5: Filter submodules (all except top-level)
        submodules = {name: mod for name, mod in modules.items() if name != top_level_name}
        
        return ModuleHierarchy(
            top_level=top_level,
            submodules=submodules,
            connections=connections,
            file_mapping=file_mapping
        )

# ---------------------------------------------------------------
# Graphical Interface 
# ---------------------------------------------------------------
class UVMAutoGenerator:
    """Main application class with UVM macro integration"""
    
    def __init__(self, root):
        self.root = root
        self.root.title("VEGA v5.0.0 (UVM Macros)")
        self.root.geometry("1200x900")
        self.root.minsize(800, 600)
        
        # Initialize instance variables
        self.dut_path = tk.StringVar()
        self.output_dir = tk.StringVar(value="uvm_tb_generated")
        self.dark_mode = tk.BooleanVar(value=False)
        self.module_info = None
        self.module_hierarchy = None
        self.generated_files = []
        self.test_results = []
        self.system_test_config = SystemTestConfig()
        
        # Customizable settings with UVM-specific defaults
        self.custom_config = {
            'num_tests': tk.IntVar(value=100),
            'include_coverage': tk.BooleanVar(value=True),
            'include_scoreboard': tk.BooleanVar(value=True),
            'clock_period': tk.StringVar(value="10ns"),
            'reset_active_low': tk.BooleanVar(value=False),
            'test_scenarios': tk.StringVar(value="smoke,random,corner"),
            'enable_reporting': tk.BooleanVar(value=True),
            'enable_statistics': tk.BooleanVar(value=True),
            'uvm_macro_path': tk.StringVar(value="uvm_macro.svh")  # Path to UVM macros
        }
        
        # Initialize the interface
        self.setup_ui()
        self.setup_template_environment()
        self.toggle_theme()

    def setup_template_environment(self):
        """Sets up Jinja2 template environment with UVM macro integration"""
        # Create templates directory if it doesn't exist
        self.template_dir = Path(__file__).parent / "templates"
        self.template_dir.mkdir(exist_ok=True)
        
        # Configure Jinja2 environment
        self.template_env = Environment(
            loader=FileSystemLoader(self.template_dir),
            trim_blocks=True,
            lstrip_blocks=True
        )
        
        # Create default templates with UVM macro integration
        self.create_system_templates()

    def create_system_templates(self):
        """Creates system templates with UVM macro integration"""
        system_templates = {
            'system_tb.sv.j2': '''// System testbench for {top_name}
// Automatically generated on {timestamp}

`include "{uvm_macro_path}"

module {top_name}_system_tb;
    // Clock and reset
    logic clk;
    logic reset_n;
    
    // Interfaces for all submodules
    {% for mod in hierarchy.submodules.values() %}
    {mod.name}_if {mod.name}_if();
    {% endfor %}
    
    // DUT instance
    {top_name} dut (
        .clk(clk),
        .reset_n(reset_n),
        {% for conn in hierarchy.connections %}
        .{conn[1]}({conn[3]}),
        {% endfor %}
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // UVM environment
    initial begin
        // Configure interfaces
        `uvm_config_db_set(null, "*", "dut_vif", dut_if);
        {% for mod in hierarchy.submodules.values() %}
        `uvm_config_db_set(null, "*", "{mod.name}_vif", {mod.name}_if);
        {% endfor %}
        
        // Start test
        `uvm_run_test("{top_name}_system_test");
    end
endmodule
''',
            
            'system_env.sv.j2': '''// UVM system environment for {top_name}
// Automatically generated on {timestamp}

`include "{uvm_macro_path}"

class {top_name}_system_env extends uvm_env;
    // Agents for each submodule
    {% for mod in hierarchy.submodules.values() %}
    {mod.name}_agent {mod.name}_agent;
    {% endfor %}
    
    // System scoreboard
    {top_name}_system_scoreboard scoreboard;
    
    `uvm_component_param_utils({top_name}_system_env)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create agents
        {% for mod in hierarchy.submodules.values() %}
        `uvm_create_component({mod.name}_agent, "{mod.name}_agent")
        {% endfor %}
        
        // Create scoreboard
        `uvm_create_component({top_name}_system_scoreboard, "scoreboard")
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect agents to scoreboard
        {% for mod in hierarchy.submodules.values() %}
        `uvm_connect_analysis_port({mod.name}_agent.monitor.analysis_port, scoreboard.{mod.name}_export)
        {% endfor %}
    endfunction
endclass
''',
            
            'pipeline_seq.sv.j2': '''// Pipeline verification sequence for {top_name}
// Automatically generated on {timestamp}

`include "{uvm_macro_path}"

class {top_name}_pipeline_seq extends uvm_sequence;
    // Sequences for each stage
    fetch_seq fetch;
    decode_seq decode;
    execute_seq execute;
    
    `uvm_object_param_utils({top_name}_pipeline_seq)
    
    function new(string name = "{top_name}_pipeline_seq");
        super.new(name);
    endfunction
    
    task body();
        // Execute sequences in parallel to simulate pipeline
        fork
            `uvm_start_seq_on(fetch, fetch_agent.sequencer)
            `uvm_start_seq_on(decode, decode_agent.sequencer)
            `uvm_start_seq_on(execute, execute_agent.sequencer)
        join
    endtask
endclass
''',
            
            'interface.sv.j2': '''// Interface for {module.name}
// Automatically generated on {timestamp}

`include "{uvm_macro_path}"

interface {module.name}_if(input logic clk, input logic reset_n);
    // Interface signals
    {% for port in module.ports %}
    logic {% if port.width != "1" %}{port.width} {% endif %}{port.name};
    {% endfor %}
    
    // Clocking blocks
    clocking driver_cb @(posedge clk);
        default input #1step output #0;
        {% for port in module.get_input_ports() %}
        input {port.name};
        {% endfor %}
        {% for port in module.get_output_ports() %}
        output {port.name};
        {% endfor %}
    endclocking
    
    clocking monitor_cb @(posedge clk);
        default input #1step output #0;
        {% for port in module.ports %}
        input {port.name};
        {% endfor %}
    endclocking
    
    // Modports
    modport driver_mp(clocking driver_cb, input reset_n);
    modport monitor_mp(clocking monitor_cb, input reset_n);
    
    // Assertion properties
    // Add your interface assertions here
    
endinterface
''',
            
            'transaction.sv.j2': '''// Transaction for {module.name}
// Automatically generated on {timestamp}

`include "{uvm_macro_path}"

class {module.name}_transaction extends uvm_sequence_item;
    // Transaction fields
    {% for port in module.ports %}
    rand logic {% if port.width != "1" %}{port.width} {% endif %}{port.name};
    {% endfor %}
    
    // Constraints
    constraint reasonable {{
        // Add your constraints here
    }}
    
    `uvm_object_param_utils_begin({module.name}_transaction)
        {% for port in module.ports %}
        `uvm_field_int({port.name}, UVM_DEFAULT)
        {% endfor %}
    `uvm_object_utils_end
    
    function new(string name = "{module.name}_transaction");
        super.new(name);
    endfunction
    
    // Convert to string for printing
    virtual function string convert2string();
        return $sformatf({% for port in module.ports %}"{port.name}=%0h " + {% endfor %}"""", {% for port in module.ports %}{port.name}, {% endfor %});
    endfunction
endclass
'''
        }
        
        for filename, content in system_templates.items():
            template_path = self.template_dir / filename
            if not template_path.exists():
                with open(template_path, 'w', encoding='utf-8') as f:
                    f.write(content)

    def prepare_generation_context(self):
        """Prepares context for template generation with UVM macros"""
        config_dict = {}
        for key, var in self.custom_config.items():
            if hasattr(var, 'get'):
                config_dict[key] = var.get()
            else:
                config_dict[key] = var
        
        # Adds test scenario settings
        config_dict['scenarios'] = {}
        for scenario, var in self.scenario_vars.items():
            config_dict['scenarios'][scenario] = var.get()
        
        return {
            'module': self.module_info,
            'config': config_dict,
            'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            'generator_version': '5.0.0',
            'uvm_macro_path': self.custom_config['uvm_macro_path'].get()
        }

    def generate_system_tb(self):
        """Generates a complete system testbench with UVM macro integration"""
        if not self.module_hierarchy:
            messagebox.showerror("Error", "Please load a project first")
            return
        
        try:
            output_path = Path(self.output_dir.get())
            output_path.mkdir(exist_ok=True)
            
            context = {
                'hierarchy': self.module_hierarchy,
                'config': self.system_test_config,
                'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                'top_name': self.module_hierarchy.top_level.name,
                'uvm_macro_path': self.custom_config['uvm_macro_path'].get()
            }
            
            # Generate top-level testbench
            self._generate_file_from_template(
                'system_tb.sv.j2', 
                f"{context['top_name']}_system_tb.sv",
                context,
                output_path
            )
            
            # Generate system UVM environment
            self._generate_file_from_template(
                'system_env.sv.j2',
                f"{context['top_name']}_system_env.sv",
                context,
                output_path
            )
            
            # Generate system sequences
            if self.system_test_config.enable_pipeline_verification:
                self._generate_file_from_template(
                    'pipeline_seq.sv.j2',
                    f"{context['top_name']}_pipeline_seq.sv",
                    context,
                    output_path
                )
            
            # Copy uvm_macro.svh to output directory if it exists
            uvm_macro_src = Path(self.custom_config['uvm_macro_path'].get())
            if uvm_macro_src.exists():
                import shutil
                shutil.copy2(uvm_macro_src, output_path / "uvm_macro.svh")
                self.generated_files.append(str(output_path / "uvm_macro.svh"))
            
            messagebox.showinfo("Success", "System testbench generated with UVM macros!")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to generate system testbench: {str(e)}")

    # [Rest of the class methods remain the same as in the original code...]
    # Only the template-related methods and context preparation were modified
    # to support UVM macro integration

    def setup_ui(self):
        """Sets up the main GUI interface with UVM macro path option"""
        # Create menu bar first
        self.setup_menu()
        
        # Initialize all status variables before they might be accessed
        self.info_text = None
        self.preview_text = None
        self.report_text = None
        self.file_listbox = None
        self.hierarchy_tree = None
        self.analysis_status = None
        self.generation_status = None
        self.report_status = None
        
        # Create notebook (tab system)
        self.notebook = ttk.Notebook(self.root)
        
        # Initialize tabs in specified order
        self.init_welcome_tab()
        self.init_setup_tab()
        self.init_hierarchy_tab()
        self.init_config_tab()
        self.init_test_scenarios_tab()
        self.init_statistics_tab()
        self.init_preview_tab()
        self.init_about_tab()
        
        self.notebook.pack(expand=True, fill='both', padx=10, pady=10)
        
        # Apply initial theme
        self.toggle_theme()

    def init_config_tab(self):
        """Creates the testbench configuration tab with UVM macro path option"""
        self.config_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.config_tab, text="🔧 Configuration")
        
        canvas = tk.Canvas(self.config_tab)
        scrollbar = ttk.Scrollbar(self.config_tab, orient="vertical", command=canvas.yview)
        scrollable_frame = ttk.Frame(canvas)
        
        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )
        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        main_frame = ttk.Frame(scrollable_frame)
        main_frame.pack(fill='both', expand=True, padx=20, pady=20)
        
        title_label = ttk.Label(main_frame, text="Testbench Configuration", style='Title.TLabel')
        title_label.pack(anchor='w', pady=(0, 15))
        
        general_frame = ttk.LabelFrame(main_frame, text="General Settings", padding=15)
        general_frame.pack(fill='x', pady=(0, 15))
        
        ttk.Label(general_frame, text="Number of Test Iterations:").grid(row=0, column=0, sticky='w', padx=(0, 10), pady=5)
        ttk.Spinbox(
            general_frame,
            from_=1,
            to=10000,
            textvariable=self.custom_config['num_tests'],
            width=15
        ).grid(row=0, column=1, sticky='w', pady=5)
        
        ttk.Label(general_frame, text="Clock Period:").grid(row=1, column=0, sticky='w', padx=(0, 10), pady=5)
        ttk.Entry(
            general_frame,
            textvariable=self.custom_config['clock_period'],
            width=15
        ).grid(row=1, column=1, sticky='w', pady=5)
        
        # Add UVM macro path configuration
        ttk.Label(general_frame, text="UVM Macro Path:").grid(row=2, column=0, sticky='w', padx=(0, 10), pady=5)
        uvm_path_frame = ttk.Frame(general_frame)
        uvm_path_frame.grid(row=2, column=1, sticky='ew')
        
        ttk.Entry(
            uvm_path_frame,
            textvariable=self.custom_config['uvm_macro_path'],
            width=30
        ).pack(side='left', fill='x', expand=True, padx=(0, 5))
        
        ttk.Button(
            uvm_path_frame,
            text="Browse...",
            command=lambda: self.browse_file("Select UVM Macro File", self.custom_config['uvm_macro_path'], [("SystemVerilog Header", "*.svh"), ("All Files", "*.*")])
        ).pack(side='right')
        
        reset_frame = ttk.LabelFrame(main_frame, text="Reset Configuration", padding=15)
        reset_frame.pack(fill='x', pady=(0, 15))
        
        ttk.Checkbutton(
            reset_frame,
            text="Reset is Active Low",
            variable=self.custom_config['reset_active_low']
        ).pack(anchor='w')
        
        components_frame = ttk.LabelFrame(main_frame, text="UVM Components", padding=15)
        components_frame.pack(fill='x', pady=(0, 15))
        
        ttk.Checkbutton(
            components_frame,
            text="Include Functional Coverage Collector",
            variable=self.custom_config['include_coverage']
        ).pack(anchor='w', pady=2)
        
        ttk.Checkbutton(
            components_frame,
            text="Include Reference Model & Scoreboard",
            variable=self.custom_config['include_scoreboard']
        ).pack(anchor='w', pady=2)
        
        reporting_frame = ttk.LabelFrame(main_frame, text="Reporting Options", padding=15)
        reporting_frame.pack(fill='x', pady=(0, 15))
        
        ttk.Checkbutton(
            reporting_frame,
            text="Enable Test Reporting",
            variable=self.custom_config['enable_reporting']
        ).pack(anchor='w', pady=2)
        
        ttk.Checkbutton(
            reporting_frame,
            text="Enable Statistics Collection",
            variable=self.custom_config['enable_statistics']
        ).pack(anchor='w', pady=2)
        
        output_frame = ttk.LabelFrame(main_frame, text="Output Configuration", padding=15)
        output_frame.pack(fill='x')
        
        ttk.Label(output_frame, text="Output Directory:").pack(anchor='w', pady=(0, 5))
        output_entry_frame = ttk.Frame(output_frame)
        output_entry_frame.pack(fill='x')
        
        ttk.Entry(output_entry_frame, textvariable=self.output_dir).pack(side='left', fill='x', expand=True, padx=(0, 5))
        ttk.Button(output_entry_frame, text="Browse...", command=self.browse_output_dir).pack(side='right')
        
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")

    def browse_file(self, title, string_var, filetypes):
        """Opens dialog to select a file"""
        initial_dir = os.path.dirname(string_var.get()) if string_var.get() else os.getcwd()
        
        path = filedialog.askopenfilename(
            title=title,
            initialdir=initial_dir,
            filetypes=filetypes
        )
        
        if path:
            string_var.set(path)

    # [All other methods remain the same as in the original code...]

def main():
    """Main application function"""
    root = tk.Tk()
    root.title("VEGA - Verification Environment Generator Assembler (UVM Macros)")
    
    try:
        root.iconname("VEGA")
    except:
        pass
    
    app = UVMAutoGenerator(root)
    
    try:
        root.mainloop()
    except KeyboardInterrupt:
        print("\nApplication terminated by user")
    except Exception as e:
        print(f"Application error: {e}")
        messagebox.showerror("Application Error", f"An unexpected error occurred: {str(e)}")

if __name__ == "__main__":
    main()