#!/usr/bin/env python3
"""
VEGA - Verification Environment Generator Assembler
Version: 5.0.0 (Unificado)

Features:
- Suporte integrado para testes unitários e sistêmicos
- Análise hierárquica automática
- Plano de verificação configurável
- Templates adaptáveis para RISC-V e designs genéricos
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

# ---------------------------------------------------------------
# Estruturas de Dados Estendidas
# ---------------------------------------------------------------
@dataclass
class VerificationPlan:
    """Configuração completa do plano de verificação"""
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
    """Porta RTL com extensões para análise sistêmica"""
    name: str
    direction: str
    width: str = "1"
    protocol: Optional[str] = None  # e.g., AXI, APB, etc.
    connected_to: Optional[str] = None
    timing: Optional[Dict] = None

@dataclass
class ModuleInfo:
    """Informações estendidas do módulo"""
    name: str
    ports: List[Port] = field(default_factory=list)
    parameters: Dict[str, str] = field(default_factory=dict)
    instances: Dict[str, str] = field(default_factory=dict)
    is_top: bool = False
    domain: Optional[str] = None  # cpu, mem, peripheral, etc.

@dataclass
class DesignHierarchy:
    """Hierarquia completa do design"""
    top_module: ModuleInfo
    submodules: Dict[str, ModuleInfo]
    connections: List[Tuple[str, str, str, str]]  # (mod1, port1, mod2, port2)
    clock_domains: Dict[str, List[str]]
    timing_constraints: Dict[str, Dict]

# ---------------------------------------------------------------
# Núcleo do Analisador RTL
# ---------------------------------------------------------------
class RTLAnalyzer:
    """Analisador estendido para suporte hierárquico"""
    
    PROTOCOLS = {
        'AXI': {'signals': ['valid', 'ready', 'data'], 'rules': [...]},
        'APB': {'signals': ['psel', 'penable', 'pwrite'], 'rules': [...]},
        'Wishbone': {'signals': ['cyc', 'stb', 'ack'], 'rules': [...]}
    }

    @classmethod
    def analyze_project(cls, project_path: str) -> DesignHierarchy:
        """Analisa um projeto completo"""
        modules = cls._discover_modules(project_path)
        top = cls._identify_top_module(modules)
        connections = cls._extract_connections(top, modules)
        clock_domains = cls._analyze_clock_domains(top, modules)
        
        return DesignHierarchy(
            top_module=top,
            submodules=modules,
            connections=connections,
            clock_domains=clock_domains,
            timing_constraints=cls._extract_timing_constraints(top)
        )

    @classmethod
    def _discover_modules(cls, project_path: str) -> Dict[str, ModuleInfo]:
        """Descobre todos os módulos no projeto"""
        modules = {}
        for file in Path(project_path).rglob('*.[svv]'):
            try:
                content = cls._read_file(file)
                module = cls._extract_module_info(content)
                modules[module.name] = module
            except ValueError as e:
                continue
        return modules

    @classmethod
    def _extract_module_info(cls, content: str) -> ModuleInfo:
        """Extrai informações detalhadas do módulo"""
        # Implementação similar à versão anterior, mas com:
        # - Detecção de protocolos
        # - Análise de domínios de clock
        # - Identificação de interfaces padrão
        pass

    @classmethod
    def _identify_top_module(cls, modules: Dict[str, ModuleInfo]) -> ModuleInfo:
        """Identifica o módulo top-level"""
        # Implementação similar à versão anterior
        pass

    @classmethod
    def _extract_connections(cls, top: ModuleInfo, modules: Dict[str, ModuleInfo]) -> List[Tuple]:
        """Extrai conexões hierárquicas"""
        connections = []
        for inst_name, mod_name in top.instances.items():
            if mod_name in modules:
                for port in modules[mod_name].ports:
                    if port.connected_to:
                        connections.append(
                            (mod_name, port.name, 
                             port.connected_to.split('.')[0], 
                             port.connected_to.split('.')[1])
        return connections

    @classmethod
    def _analyze_clock_domains(cls, top: ModuleInfo, modules: Dict[str, ModuleInfo]) -> Dict:
        """Identifica domínios de clock no design"""
        clock_domains = defaultdict(list)
        for inst_name, mod_name in top.instances.items():
            if mod_name in modules:
                mod = modules[mod_name]
                for port in mod.ports:
                    if 'clk' in port.name.lower():
                        clock_domains[port.connected_to].append(mod_name)
        return dict(clock_domains)

# ---------------------------------------------------------------
# Interface Gráfica Atualizada
# ---------------------------------------------------------------
class UVMAutoGenerator:
    def __init__(self, root):
        self.root = root
        self.root.title("VEGA v5.0.0")
        self.root.geometry("1400x900")
        
        # Estado do sistema
        self.design_hierarchy = None
        self.verification_plan = VerificationPlan()
        self.current_mode = tk.StringVar(value="unit")  # "unit" or "system"
        
        # Configuração da interface
        self._setup_menus()
        self._setup_main_interface()
        self._setup_verification_plan_tab()
        self._setup_template_environment()
        
    def _setup_menus(self):
        """Configura a barra de menus estendida"""
        menubar = tk.Menu(self.root)
        
        # Menu Arquivo
        file_menu = tk.Menu(menubar, tearoff=0)
        file_menu.add_command(label="Abrir Projeto", command=self.load_project)
        file_menu.add_command(label="Exportar Plano de Verificação", command=self.export_plan)
        file_menu.add_separator()
        file_menu.add_command(label="Sair", command=self.root.quit)
        menubar.add_cascade(label="Arquivo", menu=file_menu)
        
        # Menu Verificação
        verify_menu = tk.Menu(menubar, tearoff=0)
        verify_menu.add_radiobutton(label="Modo Unitário", variable=self.current_mode, value="unit")
        verify_menu.add_radiobutton(label="Modo Sistêmico", variable=self.current_mode, value="system")
        menubar.add_cascade(label="Verificação", menu=verify_menu)
        
        self.root.config(menu=menubar)
    
    def _setup_main_interface(self):
        """Configura a interface principal com notebook"""
        self.notebook = ttk.Notebook(self.root)
        
        # Abas principais
        self._init_welcome_tab()
        self._init_project_tab()
        self._init_verification_plan_tab()
        self._init_config_tab()
        self._init_results_tab()
        
        self.notebook.pack(expand=True, fill='both')
    
    def _setup_verification_plan_tab(self):
        """Nova aba para configuração do plano de verificação"""
        self.plan_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.plan_tab, text="📋 Plano de Verificação")
        
        # Frame de configuração
        config_frame = ttk.LabelFrame(self.plan_tab, text="Estratégia de Verificação", padding=10)
        config_frame.pack(fill='both', expand=True, padx=10, pady=10)
        
        # Seletor de modo
        mode_frame = ttk.Frame(config_frame)
        mode_frame.pack(fill='x', pady=5)
        ttk.Label(mode_frame, text="Tipo de Verificação:").pack(side='left')
        ttk.Combobox(mode_frame, textvariable=self.current_mode, 
                    values=["unit", "system"], state="readonly").pack(side='left', padx=10)
        
        # Notebook para configurações específicas
        plan_notebook = ttk.Notebook(config_frame)
        
        # Aba para testes unitários
        unit_tab = ttk.Frame(plan_notebook)
        self._setup_unit_test_plan(unit_tab)
        plan_notebook.add(unit_tab, text="Testes Unitários")
        
        # Aba para testes sistêmicos
        sys_tab = ttk.Frame(plan_notebook)
        self._setup_system_test_plan(sys_tab)
        plan_notebook.add(sys_tab, text="Testes Sistêmicos")
        
        # Aba para cobertura
        cov_tab = ttk.Frame(plan_notebook)
        self._setup_coverage_plan(cov_tab)
        plan_notebook.add(cov_tab, text="Metas de Cobertura")
        
        plan_notebook.pack(fill='both', expand=True)
    
    def _setup_unit_test_plan(self, parent):
        """Configura o painel de testes unitários"""
        checks = [
            ("Testes Funcionais Básicos", "unit_tests.functional"),
            ("Casos de Borda", "unit_tests.edge_cases"),
            ("Testes de Reset", "unit_tests.reset_tests"),
            ("Verificação de Parâmetros", "unit_tests.param_checks")
        ]
        
        for text, var_path in checks:
            var = self._get_nested_var(self.verification_plan, var_path)
            ttk.Checkbutton(parent, text=text, variable=var).pack(anchor='w', pady=2)
    
    def _setup_system_test_plan(self, parent):
        """Configura o painel de testes sistêmicos"""
        # Verificações de integração
        int_frame = ttk.LabelFrame(parent, text="Verificações de Integração", padding=10)
        int_frame.pack(fill='x', pady=5)
        
        int_checks = [
            ("Consistência de Interfaces", "system_tests.interface_consistency"),
            ("Fluxo de Dados", "system_tests.dataflow"),
            ("Acesso Concorrente", "system_tests.concurrency")
        ]
        
        for text, var_path in int_checks:
            var = self._get_nested_var(self.verification_plan, var_path)
            ttk.Checkbutton(int_frame, text=text, variable=var).pack(anchor='w', pady=2)
        
        # Verificações de desempenho
        perf_frame = ttk.LabelFrame(parent, text="Verificações de Desempenho", padding=10)
        perf_frame.pack(fill='x', pady=5)
        
        perf_checks = [
            ("Latência Máxima", "system_tests.performance"),
            ("Vazamento de Dados", "system_tests.data_integrity")
        ]
        
        for text, var_path in perf_checks:
            var = self._get_nested_var(self.verification_plan, var_path)
            ttk.Checkbutton(perf_frame, text=text, variable=var).pack(anchor='w', pady=2)
    
    def _setup_coverage_plan(self, parent):
        """Configura o painel de metas de cobertura"""
        metrics = [
            ("Cobertura de Linha", "coverage_goals.line"),
            ("Cobertura de Toggle", "coverage_goals.toggle"),
            ("Cobertura FSM", "coverage_goals.fsm"),
            ("Cobertura de Assertivas", "coverage_goals.assertion")
        ]
        
        for text, var_path in metrics:
            frame = ttk.Frame(parent)
            frame.pack(fill='x', pady=2)
            
            ttk.Label(frame, text=text, width=25).pack(side='left')
            var = self._get_nested_var(self.verification_plan, var_path)
            ttk.Spinbox(frame, from_=0, to=100, textvariable=var, width=5).pack(side='left')
            ttk.Label(frame, text="%").pack(side='left', padx=5)

# ---------------------------------------------------------------
# Templates Atualizados
# ---------------------------------------------------------------
"""
Os templates foram organizados em uma estrutura de diretórios:

templates/
├── unit/               # Testes unitários
│   ├── interface.sv.j2
│   ├── transaction.sv.j2
│   └── ...
├── system/            # Testes sistêmicos
│   ├── integration/
│   │   ├── interface_consistency.sv.j2
│   │   └── dataflow.sv.j2
│   ├── performance/
│   │   ├── latency_check.sv.j2
│   │   └── throughput.sv.j2
│   └── ...
└── common/            # Componentes compartilhados
    ├── coverage.sv.j2
    └── reporting.sv.j2
"""

# Template de exemplo para verificação sistêmica
SYSTEM_INTERFACE_TEMPLATE = """// Interface sistêmica para {{module.name}}
// Gerado automaticamente em {{timestamp}}

interface {{module.name}}_system_if;
    // Conexões para todos os submodules
    {% for submod in hierarchy.submodules.values() %}
    {{submod.name}}_if {{submod.name}}_if();
    {% endfor %}
    
    // Modports para diferentes agentes
    modport controller_mp(
        // Conexões de controle
    );
    
    modport monitor_mp(
        // Conexões de monitoramento
        {% for submod in hierarchy.submodules.values() %}
        .{{submod.name}}_monitor({{submod.name}}_if.monitor),
        {% endfor %}
    );
endinterface
"""

# Template de exemplo para scoreboard sistêmico
SYSTEM_SCOREBOARD_TEMPLATE = """// Scoreboard sistêmico para {{top_name}}
// Gerado automaticamente em {{timestamp}}

class {{top_name}}_system_scoreboard extends uvm_scoreboard;
    // Análise de subsistemas
    {% for submod in hierarchy.submodules.values() %}
    {{submod.name}}_analyzer {{submod.name}}_analyzer;
    {% endfor %}
    
    // Verificações cruzadas
    function void check_cross_module_consistency();
        {% if plan.system_tests.interface_consistency %}
        // Verificação de protocolos entre módulos
        check_interface_protocols();
        {% endif %}
        
        {% if plan.system_tests.dataflow %}
        // Verificação de fluxo de dados
        check_data_integrity();
        {% endif %}
    endfunction
    
    {% if plan.system_tests.performance %}
    // Análise de desempenho
    function void check_performance();
        // Implementação das verificações
    endfunction
    {% endif %}
endclass
"""

# ---------------------------------------------------------------
# Geração de Código Atualizada
# ---------------------------------------------------------------
class UVMGenerator:
    """Classe unificada para geração de código"""
    
    def generate_environment(self, hierarchy, plan, mode):
        """Gera o ambiente completo baseado no modo selecionado"""
        if mode == "unit":
            self._generate_unit_test_env(hierarchy, plan)
        else:
            self._generate_system_test_env(hierarchy, plan)
    
    def _generate_unit_test_env(self, hierarchy, plan):
        """Gera ambiente para testes unitários"""
        # Implementação similar à versão anterior, mas usando:
        # - templates/unit/
        # - Configurações do plano de verificação
        pass
    
    def _generate_system_test_env(self, hierarchy, plan):
        """Gera ambiente para testes sistêmicos"""
        context = {
            "hierarchy": hierarchy,
            "plan": plan,
            "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "top_name": hierarchy.top_module.name
        }
        
        # 1. Gera interfaces sistêmicas
        self._render_template(
            "system/integration/system_interface.sv.j2",
            f"{context['top_name']}_system_if.sv",
            context
        )
        
        # 2. Gera ambiente UVM
        self._render_template(
            "system/system_env.sv.j2",
            f"{context['top_name']}_system_env.sv",
            context
        )
        
        # 3. Gera verificações específicas
        if plan.system_tests.interface_consistency:
            self._generate_interface_checks(context)
            
        if plan.system_tests.dataflow:
            self._generate_dataflow_checks(context)
            
        if plan.system_tests.performance:
            self._generate_performance_checks(context)
    
    def _generate_interface_checks(self, context):
        """Gera verificações de consistência de interfaces"""
        # Implementação específica para verificação de protocolos
        pass
    
    def _generate_dataflow_checks(self, context):
        """Gera verificações de fluxo de dados"""
        # Implementação para verificação de fluxo através do sistema
        pass

# ---------------------------------------------------------------
# Função Principal
# ---------------------------------------------------------------
def main():
    root = tk.Tk()
    app = UVMAutoGenerator(root)
    root.mainloop()

if __name__ == "__main__":
    main()