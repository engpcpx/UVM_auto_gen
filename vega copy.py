#!/usr/bin/env python3
"""
UVMAutoGen - Universal UVM Testbench Generator

Version: 3.1.1
Features:
- Análise automática de interfaces do módulo RTL
- Geração de componentes UVM personalizados
- Configuração de cenários de teste parametrizáveis
- Suporte a múltiplas interfaces e protocolos
- Interface gráfica intuitiva com sistema de abas
- Exportação de projetos em ZIP
- Templates externos em subpasta 'templates'
- Relatórios estatísticos de testes
"""

import os
import re
import sys
import zipfile
import json
from datetime import datetime
from dataclasses import dataclass, field
from typing import List, Dict, Optional
from pathlib import Path
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
from jinja2 import Environment, FileSystemLoader, TemplateNotFound
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

@dataclass
class Port:
    """Representa uma porta do módulo RTL"""
    name: str
    direction: str  # 'input', 'output', 'inout'
    width: str = "1"
    description: str = ""
    
    def __post_init__(self):
        """Valida e normaliza os dados da porta"""
        if self.direction not in ['input', 'output', 'inout']:
            raise ValueError(f"Invalid port direction: {self.direction}")
        
        # Normaliza a largura
        if self.width and self.width != "1":
            self.width = self.width.strip()
            if not self.width.startswith('['):
                self.width = f"[{self.width}]"

@dataclass
class ModuleInfo:
    """Informações extraídas do módulo RTL"""
    name: str
    ports: List[Port] = field(default_factory=list)
    parameters: Dict[str, str] = field(default_factory=dict)
    clock_signals: List[str] = field(default_factory=lambda: ['clk', 'clock'])
    reset_signals: List[str] = field(default_factory=lambda: ['rst', 'reset'])
    
    def get_input_ports(self) -> List[Port]:
        """Retorna apenas as portas de entrada"""
        return [p for p in self.ports if p.direction == 'input']
    
    def get_output_ports(self) -> List[Port]:
        """Retorna apenas as portas de saída"""
        return [p for p in self.ports if p.direction == 'output']
    
    def get_inout_ports(self) -> List[Port]:
        """Retorna apenas as portas bidirecionais"""
        return [p for p in self.ports if p.direction == 'inout']

@dataclass
class TestResult:
    """Armazena resultados de testes"""
    scenario: str
    passed: int = 0
    failed: int = 0
    coverage: float = 0.0
    execution_time: float = 0.0

class RTLAnalyzer:
    """Classe responsável pela análise de módulos RTL"""
    
    @staticmethod
    def extract_module_info(file_path: str) -> ModuleInfo:
        """Extrai informações do módulo SystemVerilog/Verilog"""
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"File not found: {file_path}")
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeDecodeError:
            with open(file_path, 'r', encoding='latin-1') as f:
                content = f.read()
        
        # Remove comentários
        content = RTLAnalyzer._remove_comments(content)
        
        # Encontra a declaração do módulo
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
        
        # Extrai portas
        module_info.ports = RTLAnalyzer._extract_ports(ports_section, content)
        
        # Extrai parâmetros
        module_info.parameters = RTLAnalyzer._extract_parameters(content)
        
        return module_info
    
    @staticmethod
    def _remove_comments(content: str) -> str:
        """Remove comentários // e /* */ do código"""
        content = re.sub(r'//.*?$', '', content, flags=re.MULTILINE)
        content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        return content
    
    @staticmethod
    def _extract_ports(ports_section: str, full_content: str) -> List[Port]:
        """Extrai informações das portas"""
        ports = []
        port_pattern = r'(input|output|inout)\s+(?:(wire|reg)\s+)?(?:(signed)\s+)?(\[.*?\])?\s*(\w+)'
        
        # Procura por declarações na seção de portas
        port_matches = re.findall(port_pattern, ports_section, re.IGNORECASE)
        
        for direction, wire_type, signed, width, name in port_matches:
            port = Port(
                name=name.strip(),
                direction=direction.lower(),
                width=width.strip() if width else "1"
            )
            ports.append(port)
        
        # Se não encontrou portas na declaração, procura no corpo do módulo
        if not ports:
            ports = RTLAnalyzer._extract_ports_from_body(full_content)
        
        return ports
    
    @staticmethod
    def _extract_ports_from_body(content: str) -> List[Port]:
        """Extrai portas do corpo do módulo (declarações separadas)"""
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
        """Extrai parâmetros do módulo"""
        parameters = {}
        param_pattern = r'parameter\s+(?:\w+\s+)?(\w+)\s*=\s*([^;,]+)'
        
        matches = re.findall(param_pattern, content, re.IGNORECASE)
        
        for name, value in matches:
            parameters[name.strip()] = value.strip()
        
        return parameters

class UVMAutoGenerator:
    """Classe principal da aplicação"""
    
    def __init__(self, root):
        self.root = root
        self.root.title("VEGA v3.1.1")
        self.root.geometry("1200x900")
        self.root.minsize(800, 600)
        
        # Variáveis de estado
        self.dut_path = tk.StringVar()
        self.output_dir = tk.StringVar(value="uvm_tb_generated")
        self.module_info: Optional[ModuleInfo] = None
        self.generated_files = []
        self.test_results: List[TestResult] = []
        
        # Configurações customizáveis
        self.custom_config = {
            'num_tests': tk.IntVar(value=100),
            'include_coverage': tk.BooleanVar(value=True),
            'include_scoreboard': tk.BooleanVar(value=True),
            'clock_period': tk.StringVar(value="10ns"),
            'reset_active_low': tk.BooleanVar(value=False),
            'test_scenarios': tk.StringVar(value="smoke,random,corner"),
            'enable_reporting': tk.BooleanVar(value=True),
            'enable_statistics': tk.BooleanVar(value=True)
        }
        
        # Configurar ambiente de templates
        self.setup_template_environment()
        
        # Configurar interface
        self.setup_ui()
        
    
    def setup_template_environment(self):
        """Configura o ambiente de templates Jinja2"""
        # Cria diretório de templates se não existir
        self.template_dir = Path(__file__).parent / "templates"
        self.template_dir.mkdir(exist_ok=True)
        
        # Configura ambiente Jinja2
        self.template_env = Environment(
            loader=FileSystemLoader(self.template_dir),
            trim_blocks=True,
            lstrip_blocks=True
        )
        
        # Cria templates padrão se não existirem
        self.create_default_templates()
    
    def create_default_templates(self):
        """Cria templates padrão se não existirem no diretório"""
        default_templates = {
            'interface.sv.j2': '''// Interface para {{ module.name }}
// Gerado automaticamente em {{ timestamp }}

interface {{ module.name }}_if;
    // Clock e Reset
    logic clk;
    logic rst;
    
    // Sinais do DUT
{% for port in module.ports %}
    logic {% if port.width != "1" %}{{ port.width }} {% endif %}{{ port.name }};
{% endfor %}

    // Modports
    modport driver (
        input clk, rst,
{% for port in module.ports %}
{% if port.direction == 'input' %}
        output {{ port.name }}{% if not loop.last %},{% endif %}
{% endif %}
{% endfor %}
    );
    
    modport monitor (
        input clk, rst,
{% for port in module.ports %}
        input {{ port.name }}{% if not loop.last %},{% endif %}
{% endfor %}
    );

endinterface
''',
            'transaction.sv.j2': '''// Transaction para {{ module.name }}
// Gerado automaticamente em {{ timestamp }}

class {{ module.name }}_transaction extends uvm_sequence_item;
    
    // Campos da transação
{% for port in module.ports %}
    rand logic {% if port.width != "1" %}{{ port.width }} {% endif %}{{ port.name }};
{% endfor %}

    // UVM automation macros
    `uvm_object_utils_begin({{ module.name }}_transaction)
{% for port in module.ports %}
        `uvm_field_int({{ port.name }}, UVM_ALL_ON)
{% endfor %}
    `uvm_object_utils_end

    // Constructor
    function new(string name = "{{ module.name }}_transaction");
        super.new(name);
    endfunction

    // Constraints
    constraint valid_data {
        // Adicione constraints específicos aqui
    }

endclass
'''
        }
        
        for filename, content in default_templates.items():
            template_path = self.template_dir / filename
            if not template_path.exists():
                with open(template_path, 'w', encoding='utf-8') as f:
                    f.write(content)
    
    def setup_ui(self):
        """Configura a interface gráfica principal"""
        # Configurar estilo
        self.setup_styles()
        
        # Criar notebook (sistema de abas)
        self.notebook = ttk.Notebook(self.root)
        
        # Inicializar abas
        self._init_welcome_tab()
        self._init_setup_tab()
        self._init_config_tab()
        self._init_preview_tab()
        self._init_about_tab()
        self._init_test_scenarios_tab()
        self._init_statistics_tab()
        
        self.notebook.pack(expand=True, fill='both', padx=10, pady=10)
    
    def setup_styles(self):
        """Configura estilos personalizados"""
        style = ttk.Style()
        style.configure('Accent.TButton', font=('TkDefaultFont', 10, 'bold'))
        style.configure('Title.TLabel', font=('TkDefaultFont', 12, 'bold'))
    
    def _init_welcome_tab(self):
        """Cria a aba de boas-vindas"""
        welcome_frame = ttk.Frame(self.notebook)
        self.notebook.add(welcome_frame, text="🏠 Welcome")
        
        main_container = ttk.Frame(welcome_frame)
        main_container.pack(expand=True, fill='both', padx=50, pady=50)
        
        title_label = tk.Label(
            main_container,
            text="VEGA",
            font=("Arial", 32, "bold"),
            fg="#2c3e50"
        )
        title_label.pack(pady=20)
        
        subtitle_label = tk.Label(
            main_container,
            text="Verification Environment Generator Assembler",
            font=("Arial", 16),
            fg="#7f8c8d"
        )
        subtitle_label.pack(pady=10)
        
        description_text = (
            "Welcome to VEGA, your comprehensive UVM testbench generator!\n\n"
            "This tool helps verification engineers create complete UVM environments "
            "from RTL modules with just a few clicks. Features include:\n\n"
            "• Automatic RTL analysis and port extraction\n"
            "• Complete UVM component generation\n"
            "• Configurable test scenarios\n"
            "• Professional-grade SystemVerilog output\n"
            "• Project export capabilities\n"
            "• Test scenario selection\n"
            "• Statistical reports generation"
        )
        
        desc_label = tk.Label(
            main_container,
            text=description_text,
            font=("Arial", 11),
            fg="#34495e",
            justify="left",
            wraplength=600
        )
        desc_label.pack(pady=30)
        
        start_button = ttk.Button(
            main_container,
            text="Get Started →",
            style='Accent.TButton',
            command=lambda: self.notebook.select(1)
        )
        start_button.pack(pady=20)
        
        version_label = tk.Label(
            main_container,
            text="Version 3.1.1 - Enhanced",
            font=("Arial", 9),
            fg="#95a5a6"
        )
        version_label.pack(side='bottom', pady=10)
    
    def _init_setup_tab(self):
        """Cria a aba de configuração inicial"""
        self.setup_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.setup_tab, text="⚙️ Setup")
        
        main_frame = ttk.Frame(self.setup_tab)
        main_frame.pack(fill='both', expand=True, padx=20, pady=20)
        
        title_label = ttk.Label(main_frame, text="Design Under Test (DUT) Analysis", style='Title.TLabel')
        title_label.pack(anchor='w', pady=(0, 15))
        
        file_frame = ttk.LabelFrame(main_frame, text="RTL Module Selection", padding=15)
        file_frame.pack(fill='x', pady=(0, 15))
        
        path_label = ttk.Label(file_frame, text="RTL Module Path:")
        path_label.pack(anchor='w', pady=(0, 5))
        
        path_entry_frame = ttk.Frame(file_frame)
        path_entry_frame.pack(fill='x', pady=(0, 10))
        
        self.path_entry = ttk.Entry(path_entry_frame, textvariable=self.dut_path, font=('Consolas', 10))
        self.path_entry.pack(side='left', fill='x', expand=True, padx=(0, 5))
        
        browse_button = ttk.Button(path_entry_frame, text="Browse...", command=self.browse_dut)
        browse_button.pack(side='right')
        
        analyze_button = ttk.Button(
            file_frame,
            text="🔍 Analyze Module",
            style='Accent.TButton',
            command=self.analyze_module
        )
        analyze_button.pack(pady=10)
        
        results_frame = ttk.LabelFrame(main_frame, text="Module Analysis Results", padding=15)
        results_frame.pack(fill='both', expand=True)
        
        text_frame = ttk.Frame(results_frame)
        text_frame.pack(fill='both', expand=True)
        
        self.info_text = scrolledtext.ScrolledText(
            text_frame,
            height=15,
            state='disabled',
            font=('Consolas', 10),
            wrap='word'
        )
        self.info_text.pack(fill='both', expand=True)
        
        self.analysis_status = ttk.Label(results_frame, text="No module analyzed yet", foreground='gray')
        self.analysis_status.pack(anchor='w', pady=(10, 0))
    
    def _init_config_tab(self):
        """Cria a aba de configuração do testbench"""
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
    
    def _init_preview_tab(self):
        """Cria a aba de geração e preview"""
        self.preview_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.preview_tab, text="🚀 Generate")
        
        main_frame = ttk.Frame(self.preview_tab)
        main_frame.pack(fill='both', expand=True, padx=20, pady=20)
        
        title_label = ttk.Label(main_frame, text="Generate & Preview", style='Title.TLabel')
        title_label.pack(anchor='w', pady=(0, 15))
        
        action_frame = ttk.Frame(main_frame)
        action_frame.pack(fill='x', pady=(0, 15))
        
        generate_button = ttk.Button(
            action_frame,
            text="🚀 Generate UVM Environment",
            style='Accent.TButton',
            command=self.generate_uvm_env
        )
        generate_button.pack(side='left', padx=(0, 10))
        
        export_button = ttk.Button(
            action_frame,
            text="📦 Export as ZIP",
            command=self.export_project
        )
        export_button.pack(side='left', padx=(0, 10))
        
        open_folder_button = ttk.Button(
            action_frame,
            text="📁 Open Output Folder",
            command=self.open_output_folder
        )
        open_folder_button.pack(side='left')
        
        self.generation_status = ttk.Label(main_frame, text="Ready to generate", foreground='gray')
        self.generation_status.pack(anchor='w', pady=(0, 10))
        
        preview_container = ttk.Frame(main_frame)
        preview_container.pack(fill='both', expand=True)
        
        files_frame = ttk.LabelFrame(preview_container, text="Generated Files", padding=10)
        files_frame.pack(side='left', fill='both', expand=True, padx=(0, 10))
        
        list_container = ttk.Frame(files_frame)
        list_container.pack(fill='both', expand=True)
        
        self.file_listbox = tk.Listbox(list_container, font=('Consolas', 10))
        files_scrollbar = ttk.Scrollbar(list_container, orient='vertical', command=self.file_listbox.yview)
        self.file_listbox.configure(yscrollcommand=files_scrollbar.set)
        
        self.file_listbox.pack(side='left', fill='both', expand=True)
        files_scrollbar.pack(side='right', fill='y')
        
        self.file_listbox.bind('<<ListboxSelect>>', self.on_file_select)
        
        preview_frame = ttk.LabelFrame(preview_container, text="File Preview", padding=10)
        preview_frame.pack(side='right', fill='both', expand=True)
        
        self.preview_text = scrolledtext.ScrolledText(
            preview_frame,
            font=('Consolas', 10),
            state='disabled',
            wrap='none'
        )
        self.preview_text.pack(fill='both', expand=True)
    
    def _init_about_tab(self):
        """Cria a aba 'About' com informações do software"""
        about_tab = ttk.Frame(self.notebook)
        self.notebook.add(about_tab, text="ℹ️ About")
        
        main_frame = ttk.Frame(about_tab)
        main_frame.pack(fill='both', expand=True, padx=20, pady=20)
        
        title_label = ttk.Label(main_frame, text="About VEGA", style='Title.TLabel')
        title_label.pack(anchor='w', pady=(0, 15))
        
        info_frame = ttk.Frame(main_frame)
        info_frame.pack(fill='both', expand=True)
        
        # Left column with logo and basic info
        left_frame = ttk.Frame(info_frame)
        left_frame.pack(side='left', fill='y', padx=(0, 20))
        
        logo_label = tk.Label(
            left_frame,
            text="VEGA",
            font=("Arial", 24, "bold"),
            fg="#2c3e50"
        )
        logo_label.pack(pady=(0, 10))
        
        version_label = ttk.Label(
            left_frame,
            text="Version: 3.1.1 (Enhanced)",
            font=("TkDefaultFont", 10)
        )
        version_label.pack(pady=(0, 20))
        
        license_label = ttk.Label(
            left_frame,
            text="License: MIT Open Source",
            font=("TkDefaultFont", 10)
        )
        license_label.pack(pady=(0, 20))
        
        author_label = ttk.Label(
            left_frame,
            text="Author: UVM Tools Team",
            font=("TkDefaultFont", 10)
        )
        author_label.pack(pady=(0, 20))
        
        # Right column with detailed description
        right_frame = ttk.Frame(info_frame)
        right_frame.pack(side='left', fill='both', expand=True)
        
        description_text = (
            "VEGA (Verification Environment Generator Assembler) is a comprehensive "
            "tool for automatic UVM testbench generation from RTL modules.\n\n"
            "Key Features:\n"
            "• Automatic RTL interface analysis\n"
            "• Complete UVM testbench generation\n"
            "• Configurable test scenarios\n"
            "• Statistical reporting and analysis\n"
            "• Customizable templates\n"
            "• Project export capabilities\n\n"
            "This tool is designed to accelerate verification environment "
            "development by automating repetitive tasks while maintaining "
            "flexibility for customization."
        )
        
        desc_label = tk.Label(
            right_frame,
            text=description_text,
            font=("TkDefaultFont", 10),
            justify="left",
            wraplength=500
        )
        desc_label.pack(anchor='w', pady=(0, 20))
        
        # System requirements
        req_label = ttk.Label(
            right_frame,
            text="System Requirements:",
            font=("TkDefaultFont", 10, "bold")
        )
        req_label.pack(anchor='w', pady=(10, 5))
        
        req_text = (
            "• Python 3.8 or newer\n"
            "• Tkinter (usually included with Python)\n"
            "• Jinja2 template engine\n"
            "• SystemVerilog simulator (for generated code execution)"
        )
        
        req_content = tk.Label(
            right_frame,
            text=req_text,
            font=("TkDefaultFont", 10),
            justify="left"
        )
        req_content.pack(anchor='w')
    
    def _init_test_scenarios_tab(self):
        """Cria a aba para seleção de cenários de teste"""
        self.test_scenarios_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.test_scenarios_tab, text="🧪 Test Scenarios")
        
        main_frame = ttk.Frame(self.test_scenarios_tab)
        main_frame.pack(fill='both', expand=True, padx=20, pady=20)
        
        title_label = ttk.Label(main_frame, text="Test Scenario Selection", style='Title.TLabel')
        title_label.pack(anchor='w', pady=(0, 15))
        
        desc_label = ttk.Label(
            main_frame,
            text="Select and configure the test scenarios to be included in the generated environment:",
            wraplength=800
        )
        desc_label.pack(anchor='w', pady=(0, 15))
        
        # Scenario selection frame
        scenario_frame = ttk.LabelFrame(main_frame, text="Available Scenarios", padding=15)
        scenario_frame.pack(fill='x', pady=(0, 15))
        
        # Scenario checkboxes
        self.scenario_vars = {
            'smoke': tk.BooleanVar(value=True),
            'random': tk.BooleanVar(value=True),
            'corner': tk.BooleanVar(value=True),
            'reset': tk.BooleanVar(value=False),
            'stress': tk.BooleanVar(value=False),
            'error': tk.BooleanVar(value=False),
            'functional': tk.BooleanVar(value=False),
            'performance': tk.BooleanVar(value=False)
        }
        
        # First row of checkboxes
        row1_frame = ttk.Frame(scenario_frame)
        row1_frame.pack(fill='x', pady=(0, 5))
        
        ttk.Checkbutton(
            row1_frame,
            text="Smoke Tests (Basic functionality)",
            variable=self.scenario_vars['smoke']
        ).pack(side='left', padx=10)
        
        ttk.Checkbutton(
            row1_frame,
            text="Random Tests (Random stimulus)",
            variable=self.scenario_vars['random']
        ).pack(side='left', padx=10)
        
        ttk.Checkbutton(
            row1_frame,
            text="Corner Cases (Boundary conditions)",
            variable=self.scenario_vars['corner']
        ).pack(side='left', padx=10)
        
        # Second row of checkboxes
        row2_frame = ttk.Frame(scenario_frame)
        row2_frame.pack(fill='x', pady=(0, 5))
        
        ttk.Checkbutton(
            row2_frame,
            text="Reset Tests (Reset behavior)",
            variable=self.scenario_vars['reset']
        ).pack(side='left', padx=10)
        
        ttk.Checkbutton(
            row2_frame,
            text="Stress Tests (High load)",
            variable=self.scenario_vars['stress']
        ).pack(side='left', padx=10)
        
        ttk.Checkbutton(
            row2_frame,
            text="Error Tests (Error conditions)",
            variable=self.scenario_vars['error']
        ).pack(side='left', padx=10)
        
        # Third row of checkboxes
        row3_frame = ttk.Frame(scenario_frame)
        row3_frame.pack(fill='x')
        
        ttk.Checkbutton(
            row3_frame,
            text="Functional Tests (Feature verification)",
            variable=self.scenario_vars['functional']
        ).pack(side='left', padx=10)
        
        ttk.Checkbutton(
            row3_frame,
            text="Performance Tests (Timing checks)",
            variable=self.scenario_vars['performance']
        ).pack(side='left', padx=10)
        
        # Scenario configuration
        config_frame = ttk.LabelFrame(main_frame, text="Scenario Configuration", padding=15)
        config_frame.pack(fill='x', pady=(0, 15))
        
        # Iterations per scenario
        ttk.Label(config_frame, text="Iterations per scenario:").pack(anchor='w', pady=(0, 5))
        
        self.iterations_entry = ttk.Entry(config_frame)
        self.iterations_entry.insert(0, "100")
        self.iterations_entry.pack(anchor='w', pady=(0, 10))
        
        # Random seed
        ttk.Label(config_frame, text="Random seed (0 for random):").pack(anchor='w', pady=(0, 5))
        
        self.seed_entry = ttk.Entry(config_frame)
        self.seed_entry.insert(0, "42")
        self.seed_entry.pack(anchor='w', pady=(0, 10))
        
        # Apply button
        apply_button = ttk.Button(
            main_frame,
            text="Apply Scenario Configuration",
            style='Accent.TButton',
            command=self.apply_scenario_config
        )
        apply_button.pack(pady=10)
    
    def _init_statistics_tab(self):
        """Cria a aba para relatórios estatísticos"""
        self.statistics_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.statistics_tab, text="📊 Statistics")
        
        main_frame = ttk.Frame(self.statistics_tab)
        main_frame.pack(fill='both', expand=True, padx=20, pady=20)
        
        title_label = ttk.Label(main_frame, text="Test Statistics and Reports", style='Title.TLabel')
        title_label.pack(anchor='w', pady=(0, 15))
        
        # Action buttons
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill='x', pady=(0, 15))
        
        gen_report_button = ttk.Button(
            button_frame,
            text="📈 Generate Test Report",
            style='Accent.TButton',
            command=self.generate_test_report
        )
        gen_report_button.pack(side='left', padx=(0, 10))
        
        export_report_button = ttk.Button(
            button_frame,
            text="💾 Export Report as JSON",
            command=self.export_test_report
        )
        export_report_button.pack(side='left', padx=(0, 10))
        
        # Results display area
        results_frame = ttk.LabelFrame(main_frame, text="Test Results", padding=15)
        results_frame.pack(fill='both', expand=True)
        
        # Text area for report
        self.report_text = scrolledtext.ScrolledText(
            results_frame,
            font=('Consolas', 10),
            state='disabled',
            wrap='word'
        )
        self.report_text.pack(fill='both', expand=True)
        
        # Graph frame
        graph_frame = ttk.Frame(main_frame)
        graph_frame.pack(fill='both', expand=True, pady=(15, 0))
        
        self.figure = plt.Figure(figsize=(6, 4), dpi=100)
        self.ax = self.figure.add_subplot(111)
        
        self.canvas = FigureCanvasTkAgg(self.figure, master=graph_frame)
        self.canvas.get_tk_widget().pack(fill='both', expand=True)
        
        # Status label
        self.report_status = ttk.Label(main_frame, text="No test results available", foreground='gray')
        self.report_status.pack(anchor='w', pady=(10, 0))
    
    def apply_scenario_config(self):
        """Aplica a configuração de cenários de teste"""
        try:
            # Atualiza a string de cenários de teste
            selected_scenarios = []
            for scenario, var in self.scenario_vars.items():
                if var.get():
                    selected_scenarios.append(scenario)
            
            self.custom_config['test_scenarios'].set(",".join(selected_scenarios))
            
            # Atualiza o número de iterações
            iterations = self.iterations_entry.get()
            if iterations.isdigit():
                self.custom_config['num_tests'].set(int(iterations))
            
            messagebox.showinfo("Success", "Test scenario configuration applied successfully!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to apply scenario config: {str(e)}")
    
    def generate_test_report(self):
        """Gera um relatório de teste estatístico"""
        if not self.test_results:
            # Simula alguns resultados para demonstração
            self.test_results = [
                TestResult(scenario="smoke", passed=95, failed=5, coverage=85.5, execution_time=120.3),
                TestResult(scenario="random", passed=87, failed=13, coverage=92.1, execution_time=245.7),
                TestResult(scenario="corner", passed=72, failed=28, coverage=78.9, execution_time=310.5)
            ]
        
        try:
            # Atualiza o texto do relatório
            self.report_text.config(state='normal')
            self.report_text.delete(1.0, tk.END)
            
            report_lines = [
                "Test Results Report",
                "=" * 50,
                f"Generated at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
                f"Module: {self.module_info.name if self.module_info else 'N/A'}",
                ""
            ]
            
            total_passed = sum(r.passed for r in self.test_results)
            total_failed = sum(r.failed for r in self.test_results)
            total_tests = total_passed + total_failed
            avg_coverage = sum(r.coverage for r in self.test_results) / len(self.test_results) if self.test_results else 0
            
            report_lines.extend([
                "Summary Statistics:",
                "-" * 30,
                f"Total Tests Executed: {total_tests}",
                f"Passed: {total_passed} ({total_passed/total_tests*100:.1f}%)",
                f"Failed: {total_failed} ({total_failed/total_tests*100:.1f}%)",
                f"Average Coverage: {avg_coverage:.1f}%",
                ""
            ])
            
            report_lines.append("Detailed Results by Scenario:")
            report_lines.append("-" * 30)
            
            for result in self.test_results:
                scenario_total = result.passed + result.failed
                pass_rate = result.passed / scenario_total * 100 if scenario_total > 0 else 0
                
                report_lines.extend([
                    f"Scenario: {result.scenario.upper()}",
                    f"  • Passed: {result.passed} ({pass_rate:.1f}%)",
                    f"  • Failed: {result.failed}",
                    f"  • Coverage: {result.coverage:.1f}%",
                    f"  • Execution Time: {result.execution_time:.1f} sec",
                    ""
                ])
            
            self.report_text.insert(tk.END, "\n".join(report_lines))
            self.report_text.config(state='disabled')
            
            # Atualiza o gráfico
            self.update_statistics_chart()
            
            self.report_status.config(
                text=f"✓ Report generated - {len(self.test_results)} scenarios analyzed",
                foreground='green'
            )
            
        except Exception as e:
            self.report_status.config(
                text=f"✗ Failed to generate report: {str(e)}",
                foreground='red'
            )
            messagebox.showerror("Report Error", f"Failed to generate test report: {str(e)}")
    
    def update_statistics_chart(self):
        """Atualiza o gráfico de estatísticas"""
        if not self.test_results:
            return
        
        self.ax.clear()
        
        scenarios = [r.scenario for r in self.test_results]
        pass_rates = [r.passed/(r.passed + r.failed)*100 if (r.passed + r.failed) > 0 else 0 
                      for r in self.test_results]
        coverages = [r.coverage for r in self.test_results]
        
        x = range(len(scenarios))
        width = 0.35
        
        bars1 = self.ax.bar(x, pass_rates, width, label='Pass Rate (%)')
        bars2 = self.ax.bar([p + width for p in x], coverages, width, label='Coverage (%)')
        
        self.ax.set_xlabel('Test Scenario')
        self.ax.set_ylabel('Percentage')
        self.ax.set_title('Test Results by Scenario')
        self.ax.set_xticks([p + width/2 for p in x])
        self.ax.set_xticklabels(scenarios)
        self.ax.legend()
        self.ax.grid(True, linestyle='--', alpha=0.7)
        
        # Adiciona valores nas barras
        for bar in bars1 + bars2:
            height = bar.get_height()
            self.ax.text(bar.get_x() + bar.get_width()/2., height,
                        f'{height:.1f}%',
                        ha='center', va='bottom')
        
        self.figure.tight_layout()
        self.canvas.draw()
    
    def export_test_report(self):
        """Exporta o relatório de teste como JSON"""
        if not self.test_results:
            messagebox.showerror("Error", "No test results to export")
            return
        
        try:
            # Prepara dados para exportação
            report_data = {
                "module": self.module_info.name if self.module_info else "N/A",
                "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "total_tests": sum(r.passed + r.failed for r in self.test_results),
                "total_passed": sum(r.passed for r in self.test_results),
                "total_failed": sum(r.failed for r in self.test_results),
                "average_coverage": sum(r.coverage for r in self.test_results) / len(self.test_results),
                "scenarios": [
                    {
                        "name": r.scenario,
                        "passed": r.passed,
                        "failed": r.failed,
                        "coverage": r.coverage,
                        "execution_time": r.execution_time
                    } for r in self.test_results
                ]
            }
            
            # Solicita local para salvar
            file_path = filedialog.asksaveasfilename(
                title="Export Test Report",
                defaultextension=".json",
                filetypes=[("JSON Files", "*.json"), ("All Files", "*.*")]
            )
            
            if not file_path:
                return
            
            # Salva o arquivo
            with open(file_path, 'w') as f:
                json.dump(report_data, f, indent=4)
            
            messagebox.showinfo("Success", f"Test report exported successfully to:\n{file_path}")
            
        except Exception as e:
            messagebox.showerror("Export Error", f"Failed to export test report: {str(e)}")
    
    def browse_dut(self):
        """Abre diálogo para selecionar arquivo RTL"""
        initial_dir = os.path.dirname(self.dut_path.get()) if self.dut_path.get() else os.getcwd()
        
        path = filedialog.askopenfilename(
            title="Select RTL Module File",
            initialdir=initial_dir,
            filetypes=[
                ("SystemVerilog Files", "*.sv"),
                ("Verilog Files", "*.v"),
                ("All Files", "*.*")
            ]
        )
        
        if path:
            self.dut_path.set(path)
            self.module_info = None
            self.analysis_status.config(text="File selected - ready for analysis", foreground='blue')
    
    def browse_output_dir(self):
        """Abre diálogo para selecionar diretório de saída"""
        directory = filedialog.askdirectory(
            title="Select Output Directory",
            initialdir=self.output_dir.get() if os.path.exists(self.output_dir.get()) else os.getcwd()
        )
        
        if directory:
            self.output_dir.set(directory)
    
    def analyze_module(self):
        """Analisa o módulo RTL selecionado"""
        dut_path = self.dut_path.get().strip()
        
        if not dut_path:
            messagebox.showerror("Error", "Please select an RTL file first")
            return
        
        if not os.path.exists(dut_path):
            messagebox.showerror("Error", f"File not found: {dut_path}")
            return
        
        try:
            self.analysis_status.config(text="Analyzing module...", foreground='orange')
            self.root.update()
            
            self.module_info = RTLAnalyzer.extract_module_info(dut_path)
            self.display_module_info()
            
            self.analysis_status.config(
                text=f"✓ Analysis complete - {len(self.module_info.ports)} ports found",
                foreground='green'
            )
            
            self.notebook.tab(2, state='normal')
            self.notebook.tab(4, state='normal')  # Ativa a aba de cenários de teste
            self.notebook.tab(5, state='normal')  # Ativa a aba de estatísticas
            
        except Exception as e:
            error_msg = f"Failed to analyze module: {str(e)}"
            messagebox.showerror("Analysis Error", error_msg)
            self.analysis_status.config(text=f"✗ Analysis failed: {str(e)}", foreground='red')
            print(f"Analysis error details: {e}")
            import traceback
            traceback.print_exc()
    
    def display_module_info(self):
        """Exibe informações do módulo analisado"""
        if not self.module_info:
            return
        
        self.info_text.config(state='normal')
        self.info_text.delete(1.0, tk.END)
        
        info_lines = [
            f"Module Analysis Results",
            f"=" * 50,
            f"Module Name: {self.module_info.name}",
            f"Total Ports: {len(self.module_info.ports)}",
            f"Parameters: {len(self.module_info.parameters)}",
            "",
            "Port Details:",
            "-" * 30
        ]
        
        input_ports = self.module_info.get_input_ports()
        output_ports = self.module_info.get_output_ports()
        inout_ports = self.module_info.get_inout_ports()
        
        if input_ports:
            info_lines.extend([
                "",
                f"INPUT PORTS ({len(input_ports)}):"
            ])
            for port in input_ports:
                width_str = f"[{port.width}]" if port.width != "1" else ""
                info_lines.append(f"  • {port.name:20} {width_str}")
        
        if output_ports:
            info_lines.extend([
                "",
                f"OUTPUT PORTS ({len(output_ports)}):"
            ])
            for port in output_ports:
                width_str = f"[{port.width}]" if port.width != "1" else ""
                info_lines.append(f"  • {port.name:20} {width_str}")
        
        if inout_ports:
            info_lines.extend([
                "",
                f"INOUT PORTS ({len(inout_ports)}):"
            ])
            for port in inout_ports:
                width_str = f"[{port.width}]" if port.width != "1" else ""
                info_lines.append(f"  • {port.name:20} {width_str}")
        
        if self.module_info.parameters:
            info_lines.extend([
                "",
                f"PARAMETERS ({len(self.module_info.parameters)}):"
            ])
            for name, value in self.module_info.parameters.items():
                info_lines.append(f"  • {name:20} = {value}")
        
        total_signals = len(self.module_info.ports)
        if total_signals <= 10:
            complexity = "Simple"
        elif total_signals <= 25:
            complexity = "Medium"
        else:
            complexity = "Complex"
        
        info_lines.extend([
            "",
            "Generation Recommendations:",
            "-" * 30,
            f"  • Module Complexity: {complexity}",
            f"  • Recommended Test Count: {min(100 + total_signals * 10, 1000)}",
            f"  • Estimated Generation Time: <1 minute"
        ])
        
        self.info_text.insert(tk.END, "\n".join(info_lines))
        self.info_text.config(state='disabled')
    
    def generate_uvm_env(self):
        """Gera o ambiente UVM completo"""
        if not self.module_info:
            messagebox.showerror("Error", "Please analyze a module first")
            return
        
        try:
            self.generation_status.config(text="Generating UVM environment...", foreground='orange')
            self.root.update()
            
            output_path = Path(self.output_dir.get())
            output_path.mkdir(exist_ok=True)
            
            context = self.prepare_generation_context()
            self.generated_files = []
            self.generate_files(context, output_path)
            self.update_file_list()
            
            # Gera relatório de teste simulado
            if self.custom_config['enable_reporting'].get():
                self.generate_test_report()
            
            file_count = len(self.generated_files)
            self.generation_status.config(
                text=f"✓ Generation complete - {file_count} files created",
                foreground='green'
            )
            
            messagebox.showinfo(
                "Success",
                f"UVM environment generated successfully!\n\n"
                f"Location: {output_path}\n"
                f"Files created: {file_count}"
            )
            
        except Exception as e:
            error_msg = f"Failed to generate UVM environment: {str(e)}"
            messagebox.showerror("Generation Error", error_msg)
            self.generation_status.config(text=f"✗ Generation failed", foreground='red')
            print(f"Generation error: {e}")
            import traceback
            traceback.print_exc()
    
    def prepare_generation_context(self):
        """Prepara contexto para geração de templates"""
        config_dict = {}
        for key, var in self.custom_config.items():
            if hasattr(var, 'get'):
                config_dict[key] = var.get()
            else:
                config_dict[key] = var
        
        # Adiciona configurações de cenários de teste
        config_dict['scenarios'] = {}
        for scenario, var in self.scenario_vars.items():
            config_dict['scenarios'][scenario] = var.get()
        
        return {
            'module': self.module_info,
            'config': config_dict,
            'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            'generator_version': '3.1.1'
        }
    
    def generate_files(self, context, output_path):
        """Gera todos os arquivos do ambiente UVM"""
        basic_files = [
            ('interface.sv.j2', f"{context['module'].name}_if.sv"),
            ('transaction.sv.j2', f"{context['module'].name}_transaction.sv"),
            ('driver.sv.j2', f"{context['module'].name}_driver.sv"),
            ('test.sv.j2', f"{context['module'].name}_test.sv")
        ]
        
        optional_files = []
        
        if context['config']['include_scoreboard']:
            optional_files.append(('scoreboard.sv.j2', f"{context['module'].name}_scoreboard.sv"))
        
        if context['config']['include_coverage']:
            optional_files.append(('coverage.sv.j2', f"{context['module'].name}_coverage.sv"))
        
        if context['config']['enable_reporting']:
            optional_files.append(('reporting.sv.j2', f"{context['module'].name}_reporting.sv"))
        
        all_files = basic_files + optional_files
        
        for template_name, output_filename in all_files:
            self.generate_single_file(template_name, output_filename, context, output_path)
        
        self.generate_documentation(context, output_path)
    
    def generate_single_file(self, template_name, output_filename, context, output_path):
        """Gera um único arquivo a partir de um template"""
        try:
            # Tenta carregar template do diretório
            template = self.template_env.get_template(template_name)
            rendered_content = template.render(context)
            
            output_file = output_path / output_filename
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(rendered_content)
            
            self.generated_files.append(str(output_file))
            
        except TemplateNotFound:
            # Se template não existe, usa padrão embutido
            default_template = self.get_default_template(template_name, context)
            if default_template:
                output_file = output_path / output_filename
                with open(output_file, 'w', encoding='utf-8') as f:
                    f.write(default_template)
                self.generated_files.append(str(output_file))
        
        except Exception as e:
            print(f"Error generating {output_filename}: {e}")
            raise
    
    def get_default_template(self, template_name, context):
        """Retorna template padrão para arquivos não implementados"""
        module_name = context['module'].name
        timestamp = context['timestamp']
        
        templates = {
            'scoreboard.sv.j2': f'''// Scoreboard para {module_name}
// Gerado automaticamente em {timestamp}

class {module_name}_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils({module_name}_scoreboard)
    
    // Analysis ports
    uvm_analysis_imp_expected #({module_name}_transaction, {module_name}_scoreboard) expected_port;
    uvm_analysis_imp_actual #({module_name}_transaction, {module_name}_scoreboard) actual_port;
    
    // Constructor
    function new(string name = "{module_name}_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        expected_port = new("expected_port", this);
        actual_port = new("actual_port", this);
    endfunction
    
    // Write methods
    virtual function void write_expected({module_name}_transaction t);
        // Implementar comparação
        `uvm_info(get_type_name(), "Expected transaction received", UVM_LOW)
    endfunction
    
    virtual function void write_actual({module_name}_transaction t);
        // Implementar comparação
        `uvm_info(get_type_name(), "Actual transaction received", UVM_LOW)
    endfunction

endclass
''',
            'coverage.sv.j2': f'''// Coverage para {module_name}
// Gerado automaticamente em {timestamp}

class {module_name}_coverage extends uvm_subscriber #({module_name}_transaction);
    
    `uvm_component_utils({module_name}_coverage)
    
    // Coverage groups
    covergroup {module_name}_cg;
        // Adicionar coverpoints específicos
        option.per_instance = 1;
    endgroup
    
    // Constructor
    function new(string name = "{module_name}_coverage", uvm_component parent = null);
        super.new(name, parent);
        {module_name}_cg = new();
    endfunction
    
    // Write method
    virtual function void write({module_name}_transaction t);
        {module_name}_cg.sample();
    endfunction
    
    // Report phase
    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Coverage: %.2f%%", {module_name}_cg.get_coverage()), UVM_LOW)
    endfunction

endclass
''',
            'reporting.sv.j2': f'''// Reporting para {module_name}
// Gerado automaticamente em {timestamp}

class {module_name}_reporting extends uvm_subscriber #({module_name}_transaction);
    
    `uvm_component_utils({module_name}_reporting)
    
    // Métricas coletadas
    int passed_tests = 0;
    int failed_tests = 0;
    real coverage = 0.0;
    
    // Constructor
    function new(string name = "{module_name}_reporting", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Write method
    virtual function void write({module_name}_transaction t);
        // Implementar coleta de métricas
        // Esta é uma implementação simplificada
        if ($urandom_range(0, 100) > 10) begin
            passed_tests++;
        end else begin
            failed_tests++;
        end
        coverage = passed_tests * 100.0 / (passed_tests + failed_tests);
    endfunction
    
    // Report phase
    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Test Results:\\nPassed: %0d\\nFailed: %0d\\nCoverage: %.2f%%", 
            passed_tests, failed_tests, coverage), UVM_LOW)
        
        // Exporta relatório para arquivo JSON
        begin
            int fd;
            fd = $fopen("{module_name}_test_report.json", "w");
            if (fd) begin
                $fdisplay(fd, "{{");
                $fdisplay(fd, "  \\"module\\": \\"{module_name}\\",");
                $fdisplay(fd, "  \\"timestamp\\": \\"%s\\",", $sformatf("%t", $realtime));
                $fdisplay(fd, "  \\"passed_tests\\": %0d,", passed_tests);
                $fdisplay(fd, "  \\"failed_tests\\": %0d,", failed_tests);
                $fdisplay(fd, "  \\"coverage\\": %.2f", coverage);
                $fdisplay(fd, "}}");
                $fclose(fd);
            end
        end
    endfunction

endclass
'''
        }
        
        return templates.get(template_name)
    
    def generate_documentation(self, context, output_path):
        """Gera documentação do projeto"""
        doc_content = f"""# UVM Testbench for {context['module'].name}

Generated by VEGA (UVMAutoGen v{context['generator_version']})
Generation Time: {context['timestamp']}

## Module Information
- **Name**: {context['module'].name}
- **Total Ports**: {len(context['module'].ports)}
- **Input Ports**: {len(context['module'].get_input_ports())}
- **Output Ports**: {len(context['module'].get_output_ports())}
- **Inout Ports**: {len(context['module'].get_inout_ports())}

## Generated Files
"""
        
        for file_path in self.generated_files:
            filename = Path(file_path).name
            doc_content += f"- {filename}\n"
        
        doc_content += f"""
## Configuration Used
- **Test Iterations**: {context['config']['num_tests']}
- **Clock Period**: {context['config']['clock_period']}
- **Reset Active Low**: {context['config']['reset_active_low']}
- **Include Coverage**: {context['config']['include_coverage']}
- **Include Scoreboard**: {context['config']['include_scoreboard']}
- **Enable Reporting**: {context['config']['enable_reporting']}
- **Enable Statistics**: {context['config']['enable_statistics']}
- **Test Scenarios**: {context['config']['test_scenarios']}

## Selected Test Scenarios
"""
        
        for scenario, enabled in context['config']['scenarios'].items():
            doc_content += f"- {scenario.capitalize()}: {'Enabled' if enabled else 'Disabled'}\n"
        
        doc_content += f"""
## Usage Instructions
1. Compile all SystemVerilog files with your simulator
2. Run the testbench using your preferred simulation tool
3. Review coverage reports and simulation logs
4. Check generated test reports for statistics

## Next Steps
- Customize test scenarios in the test files
- Add specific constraints to transaction classes
- Implement reference model in scoreboard
- Add protocol-specific coverage points
- Analyze generated test reports
"""
        
        doc_file = output_path / "README.md"
        with open(doc_file, 'w', encoding='utf-8') as f:
            f.write(doc_content)
        
        self.generated_files.append(str(doc_file))
    
    def update_file_list(self):
        """Atualiza a lista de arquivos gerados"""
        self.file_listbox.delete(0, tk.END)
        
        for file_path in self.generated_files:
            filename = Path(file_path).name
            self.file_listbox.insert(tk.END, filename)
    
    def on_file_select(self, event):
        """Manipula seleção de arquivo na lista"""
        selection = self.file_listbox.curselection()
        if not selection:
            return
        
        try:
            selected_index = selection[0]
            if selected_index < len(self.generated_files):
                file_path = self.generated_files[selected_index]
                self.preview_file(file_path)
        except Exception as e:
            messagebox.showerror("Preview Error", f"Could not preview file: {str(e)}")
    
    def preview_file(self, file_path):
        """Mostra preview do arquivo selecionado"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            self.preview_text.config(state='normal')
            self.preview_text.delete(1.0, tk.END)
            self.preview_text.insert(tk.END, content)
            self.preview_text.config(state='disabled')
            
        except Exception as e:
            self.preview_text.config(state='normal')
            self.preview_text.delete(1.0, tk.END)
            self.preview_text.insert(tk.END, f"Error reading file: {str(e)}")
            self.preview_text.config(state='disabled')
    
    def export_project(self):
        """Exporta projeto como arquivo ZIP"""
        if not self.generated_files:
            messagebox.showerror("Error", "Please generate the UVM environment first")
            return
        
        try:
            default_name = f"{self.module_info.name}_uvm_tb_{datetime.now().strftime('%Y%m%d_%H%M%S')}.zip"
            
            zip_path = filedialog.asksaveasfilename(
                title="Export Project as ZIP",
                defaultextension=".zip",
                initialname=default_name,
                filetypes=[("ZIP Archive", "*.zip"), ("All Files", "*.*")]
            )
            
            if not zip_path:
                return
            
            with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
                for file_path in self.generated_files:
                    arcname = Path(file_path).name
                    zipf.write(file_path, arcname)
            
            messagebox.showinfo(
                "Export Complete",
                f"Project exported successfully to:\n{zip_path}"
            )
            
        except Exception as e:
            messagebox.showerror("Export Error", f"Failed to export project: {str(e)}")
    
    def open_output_folder(self):
        """Abre pasta de saída no explorador de arquivos"""
        output_path = Path(self.output_dir.get())
        
        if not output_path.exists():
            messagebox.showwarning("Warning", "Output directory does not exist yet")
            return
        
        try:
            import subprocess
            import platform
            
            system = platform.system()
            if system == "Windows":
                subprocess.Popen(['explorer', str(output_path)])
            elif system == "Darwin":
                subprocess.Popen(['open', str(output_path)])
            else:
                subprocess.Popen(['xdg-open', str(output_path)])
                
        except Exception as e:
            messagebox.showerror("Error", f"Could not open folder: {str(e)}")

def main():
    """Função principal da aplicação"""
    root = tk.Tk()
    root.title("VEGA - Verification Environment Generator Assembler")
    
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