#!/usr/bin/env python3
"""
UVMAutoGen - Universal UVM Testbench Generator

Version: 3.0
Features:
- Análise automática de interfaces do módulo RTL
- Geração de componentes UVM personalizados
- Configuração de cenários de teste parametrizáveis
- Suporte a múltiplas interfaces e protocolos
"""

import os
import re
import sys
import inspect
import zipfile
from dataclasses import dataclass, field
from typing import List, Dict
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
from jinja2 import Environment, FileSystemLoader

@dataclass
class Port:
    name: str
    direction: str  # 'input', 'output', 'inout'
    width: str = "1"
    description: str = ""

@dataclass
class ModuleInfo:
    name: str
    ports: List[Port] = field(default_factory=list)
    parameters: Dict[str, str] = field(default_factory=dict)
    clock_signals: List[str] = field(default_factory=lambda: ['clk', 'clock'])
    reset_signals: List[str] = field(default_factory=lambda: ['rst', 'reset'])

class UVMAutoGenerator:
    def __init__(self, root):
        self.root = root
        self.root.title("UVMAutoGen v3.0")
        self.root.geometry("1000x800")
        
        # Variáveis de estado
        self.dut_path = tk.StringVar()
        self.output_dir = tk.StringVar(value="uvm_tb")
        self.module_info = None
        self.custom_config = {
            'num_tests': tk.IntVar(value=100),
            'include_coverage': tk.BooleanVar(value=True),
            'include_scoreboard': tk.BooleanVar(value=True),
            'clock_period': tk.StringVar(value="10ns"),
            'reset_active_low': tk.BooleanVar(value=False),
            'test_scenarios': tk.StringVar(value="smoke,random,corner")
        }
        
        # Configurar interface
        self.setup_ui()
        
        # Configurar templates
        self.template_env = Environment(
            loader=FileSystemLoader('templates'),
            trim_blocks=True,
            lstrip_blocks=True
        ) 

        # Initialize UI pages
        self._init_start_screen()


    def _init_start_screen(self):
        """
        Create and configure the welcome/start screen tab.
        
        This screen provides an introduction to the application and allows
        users to navigate to the main generator interface.
        """
        # Create start screen frame
        start_frame = ttk.Frame(self.notebook)
        self.notebook.add(start_frame, text="Welcome")
        
        # Application title
        title_label = tk.Label(
            start_frame, 
            text="VEGA | Verification Environment Generator Assembler", 
            font=("Arial", 20, "bold"), 
            fg="gray"
        )
        title_label.pack(pady=30)
        
        # Application description
        description_text = (
            "Welcome! This application helps verification engineers "
            "generate complete UVM environments from a DUT and "
            "test requirements."
        )
        desc_label = tk.Label(
            start_frame, 
            text=description_text, 
            font=("Arial", 12), 
            fg="gray", 
            wraplength=500, 
            justify="center"
        )
        desc_label.pack(pady=20)
        
        # Start button - switches to main generator tab
        start_button = ttk.Button(
            start_frame, 
            text="Get Started", 
            command=lambda: self.notebook.select(1)
        )
        start_button.pack(pady=20)

    
    def setup_ui(self):
        """Configura a interface gráfica principal"""
        self.notebook = ttk.Notebook(self.root)
        
        # Abas principais
        self.setup_tab = ttk.Frame(self.notebook)
        self.config_tab = ttk.Frame(self.notebook)
        self.preview_tab = ttk.Frame(self.notebook)
        
        self.notebook.add(self.setup_tab, text="1. Setup")
        self.notebook.add(self.config_tab, text="2. Configuration")
        self.notebook.add(self.preview_tab, text="3. Generate & Preview")
        
        self.create_setup_tab()
        self.create_config_tab()
        self.create_preview_tab()
        
        self.notebook.pack(expand=True, fill='both')
    
    def create_setup_tab(self):
        """Cria a aba de configuração inicial"""
        frame = ttk.Frame(self.setup_tab, padding=10)
        frame.pack(fill='both', expand=True)
        
        # Seção do DUT
        dut_frame = ttk.LabelFrame(frame, text="Design Under Test (DUT)", padding=10)
        dut_frame.pack(fill='x', pady=5)
        
        ttk.Label(dut_frame, text="RTL Module Path:").pack(anchor='w')
        entry_frame = ttk.Frame(dut_frame)
        entry_frame.pack(fill='x', pady=5)
        
        ttk.Entry(entry_frame, textvariable=self.dut_path, width=70).pack(side='left', fill='x', expand=True)
        ttk.Button(entry_frame, text="Browse", command=self.browse_dut).pack(side='left', padx=5)
        
        # Seção de análise
        analyze_frame = ttk.Frame(dut_frame)
        analyze_frame.pack(fill='x', pady=5)
        
        ttk.Button(
            analyze_frame, 
            text="Analyze Module", 
            command=self.analyze_module,
            style='Accent.TButton'
        ).pack(side='left')
        
        # Seção de informações do módulo
        self.info_text = scrolledtext.ScrolledText(dut_frame, height=10, state='disabled')
        self.info_text.pack(fill='both', expand=True)
    
    def create_config_tab(self):
        """Cria a aba de configuração do TB"""
        frame = ttk.Frame(self.config_tab, padding=10)
        frame.pack(fill='both', expand=True)
        
        # Configurações gerais
        gen_frame = ttk.LabelFrame(frame, text="Testbench Configuration", padding=10)
        gen_frame.pack(fill='x', pady=5)
        
        ttk.Label(gen_frame, text="Number of Tests:").grid(row=0, column=0, sticky='w', padx=5, pady=2)
        ttk.Spinbox(gen_frame, from_=1, to=10000, textvariable=self.custom_config['num_tests'], width=10).grid(row=0, column=1, sticky='w', pady=2)
        
        ttk.Label(gen_frame, text="Clock Period:").grid(row=1, column=0, sticky='w', padx=5, pady=2)
        ttk.Entry(gen_frame, textvariable=self.custom_config['clock_period'], width=10).grid(row=1, column=1, sticky='w', pady=2)
        
        ttk.Checkbutton(
            gen_frame, 
            text="Active Low Reset", 
            variable=self.custom_config['reset_active_low']
        ).grid(row=2, column=0, columnspan=2, sticky='w', padx=5, pady=2)
        
        # Componentes
        comp_frame = ttk.LabelFrame(frame, text="UVM Components", padding=10)
        comp_frame.pack(fill='x', pady=5)
        
        ttk.Checkbutton(
            comp_frame, 
            text="Include Coverage Collector", 
            variable=self.custom_config['include_coverage']
        ).pack(anchor='w')
        
        ttk.Checkbutton(
            comp_frame, 
            text="Include Scoreboard", 
            variable=self.custom_config['include_scoreboard']
        ).pack(anchor='w')
        
        # Cenários de teste
        test_frame = ttk.LabelFrame(frame, text="Test Scenarios", padding=10)
        test_frame.pack(fill='x', pady=5)
        
        ttk.Label(test_frame, text="Enabled Scenarios (comma-separated):").pack(anchor='w')
        ttk.Entry(test_frame, textvariable=self.custom_config['test_scenarios'], width=50).pack(fill='x', pady=5)
        
        # Dica sobre cenários
        ttk.Label(
            test_frame, 
            text="Available scenarios: smoke, random, corner, reset, stress, error",
            font=('TkDefaultFont', 8)
        ).pack(anchor='w')
    
    def create_preview_tab(self):
        """Cria a aba de geração e visualização"""
        frame = ttk.Frame(self.preview_tab, padding=10)
        frame.pack(fill='both', expand=True)
        
        # Botões de ação
        btn_frame = ttk.Frame(frame)
        btn_frame.pack(fill='x', pady=5)
        
        ttk.Button(
            btn_frame, 
            text="Generate UVM Environment", 
            command=self.generate_uvm_env,
            style='Accent.TButton'
        ).pack(side='left', padx=5)
        
        ttk.Button(
            btn_frame, 
            text="Export as ZIP", 
            command=self.export_project
        ).pack(side='left', padx=5)
        
        # Visualização de arquivos
        file_frame = ttk.Frame(frame)
        file_frame.pack(fill='both', expand=True)
        
        # Lista de arquivos
        self.file_list = tk.Listbox(file_frame, height=15)
        scrollbar = ttk.Scrollbar(file_frame, orient='vertical', command=self.file_list.yview)
        self.file_list.configure(yscrollcommand=scrollbar.set)
        
        self.file_list.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')
        
        self.file_list.bind('<<ListboxSelect>>', self.preview_selected_file)
        
        # Visualização de conteúdo
        self.preview_text = scrolledtext.ScrolledText(frame, height=20, state='normal')
        self.preview_text.pack(fill='both', expand=True)
    
    def browse_dut(self):
        """Abre diálogo para selecionar arquivo RTL"""
        path = filedialog.askopenfilename(
            title="Select RTL Module",
            filetypes=[("SystemVerilog Files", "*.sv *.v"), ("All Files", "*.*")]
        )
        if path:
            self.dut_path.set(path)
    
    def analyze_module(self):
        """Analisa o módulo RTL para extrair informações"""
        dut_path = self.dut_path.get()
        if not os.path.exists(dut_path):
            messagebox.showerror("Error", "Please select a valid RTL file")
            return
        
        try:
            self.module_info = self.extract_module_info(dut_path)
            self.display_module_info()
        except Exception as e:
            messagebox.showerror("Analysis Error", f"Failed to analyze module: {str(e)}")
    
    def extract_module_info(self, file_path):
        """Extrai informações do módulo SystemVerilog"""
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Encontra a declaração do módulo
        module_match = re.search(
            r'module\s+(\w+)\s*#?\s*\(?([^)]*)\)?\s*\(?(.*?)\)?\s*;', 
            content, 
            re.DOTALL
        )
        
        if not module_match:
            raise ValueError("Module declaration not found")
        
        module_name = module_match.group(1)
        module_info = ModuleInfo(name=module_name)
        
        # Processa portas
        ports_section = module_match.group(3)
        port_declarations = re.findall(
            r'(input|output|inout)\s*(reg|wire)?\s*(signed)?\s*(\[.*?\])?\s*(\w+)', 
            ports_section
        )
        
        for direction, _, _, width, name in port_declarations:
            module_info.ports.append(
                Port(name=name, direction=direction, width=width or "1")
            )
        
        return module_info
    
    def display_module_info(self):
        """Exibe informações do módulo na UI"""
        if not self.module_info:
            return
        
        self.info_text.config(state='normal')
        self.info_text.delete(1.0, tk.END)
        
        info_str = f"Module: {self.module_info.name}\n\n"
        info_str += "Ports:\n"
        
        for port in self.module_info.ports:
            info_str += f"  {port.direction:6} {port.width:4} {port.name}\n"
        
        self.info_text.insert(tk.END, info_str)
        self.info_text.config(state='disabled')
    
    def generate_uvm_env(self):
        """Gera o ambiente UVM completo"""
        if not self.module_info:
            messagebox.showerror("Error", "Please analyze the module first")
            return
        
        output_dir = self.output_dir.get()
        os.makedirs(output_dir, exist_ok=True)
        
        context = {
            'module': self.module_info,
            'config': {k: v.get() for k, v in self.custom_config.items()},
            'timestamp': "2025-06-01"  # Usaria datetime.now() em produção
        }
        
        # Lista de templates para gerar
        templates = [
            'interface.sv.j2',
            'transaction.sv.j2',
            'sequence.sv.j2',
            'driver.sv.j2',
            'monitor.sv.j2',
            'agent.sv.j2',
            'env.sv.j2',
            'test.sv.j2',
            'top_tb.sv.j2'
        ]
        
        if context['config']['include_scoreboard']:
            templates.append('scoreboard.sv.j2')
        
        if context['config']['include_coverage']:
            templates.append('coverage.sv.j2')
        
        # Gera cada arquivo
        self.file_list.delete(0, tk.END)
        for template in templates:
            output_file = self.render_template(template, context, output_dir)
            if output_file:
                self.file_list.insert(tk.END, output_file)
        
        messagebox.showinfo("Success", f"UVM environment generated in {output_dir}")
    
    def render_template(self, template_name, context, output_dir):
        """Renderiza um template individual"""
        try:
            template = self.template_env.get_template(template_name)
            content = template.render(context)
            
            output_file = os.path.join(
                output_dir,
                template_name.replace('.j2', '').replace('_', '.')
            )
            
            with open(output_file, 'w') as f:
                f.write(content)
            
            return output_file
        
        except Exception as e:
            messagebox.showerror("Template Error", f"Error generating {template_name}: {str(e)}")
            return None
    
    def preview_selected_file(self, event):
        """Mostra o conteúdo do arquivo selecionado"""
        selection = self.file_list.curselection()
        if not selection:
            return
        
        file_path = self.file_list.get(selection[0])
        try:
            with open(file_path, 'r') as f:
                content = f.read()
            
            self.preview_text.config(state='normal')
            self.preview_text.delete(1.0, tk.END)
            self.preview_text.insert(tk.END, content)
            self.preview_text.config(state='disabled')
        
        except Exception as e:
            messagebox.showerror("Error", f"Could not read file: {str(e)}")
    
    def export_project(self):
        """Exporta o projeto como arquivo ZIP"""
        output_dir = self.output_dir.get()
        if not os.path.exists(output_dir):
            messagebox.showerror("Error", "Please generate the environment first")
            return
        
        zip_path = filedialog.asksaveasfilename(
            defaultextension=".zip",
            filetypes=[("ZIP Archive", "*.zip")],
            initialfile=f"{self.module_info.name}_uvm_tb.zip"
        )
        
        if not zip_path:
            return
        
        try:
            with zipfile.ZipFile(zip_path, 'w') as zipf:
                for root, _, files in os.walk(output_dir):
                    for file in files:
                        file_path = os.path.join(root, file)
                        arcname = os.path.relpath(file_path, output_dir)
                        zipf.write(file_path, arcname)
            
            messagebox.showinfo("Success", f"Project exported to {zip_path}")
        
        except Exception as e:
            messagebox.showerror("Export Error", f"Failed to create ZIP: {str(e)}")

def main():
    root = tk.Tk()
    
    # Configurar estilo
    style = ttk.Style()
    style.configure('Accent.TButton', foreground='white', background='#0078d7')
    
    app = UVMAutoGenerator(root)
    root.mainloop()

if __name__ == "__main__":
    main()