# VEGA - Verification Environment Generator Assembler  
## Automated UVM Testbench Generation Tool  

![VEGA Logo](https://via.placeholder.com/150x50?text=VEGA+Logo)  
*Version 5.0.0 | June 2024*  

## Introduction  
VEGA is an intelligent UVM testbench generator that accelerates verification for both unit-level (individual modules) and system-level (complete subsystems) testing. Key capabilities include automatic UVM component generation, smart test scenario creation, coverage-driven verification, and hierarchical testbench assembly.  

## Features  
**Unit Test Support**  
✅ Interface detection & generation  
✅ Transaction modeling  
✅ Constrained-random sequence generation  
✅ Functional coverage collection  
✅ Scoreboard integration  
✅ Register abstraction layer (RAL) support  

**System Test Support**  
🌐 Hierarchical connectivity analysis  
🔄 Pipeline verification  
🔗 Cross-module interface checking  
📊 System-level coverage  
⚙️ Performance monitoring  

## Installation  
```bash
# Clone repository
git clone https://github.com/your-org/vega.git
cd vega
# Install dependencies
pip install -r requirements.txt
# Launch VEGA
python vega_gui.py

Quick Start

    Load your RTL: Single file for unit testing or entire project for system verification

    Configure verification:

python

config = {
    "test_type": "unit",  # or "system"
    "coverage": {
        "enable": True,
        "goals": {"line": 95, "toggle": 85}
    },
    "scenarios": ["smoke", "random", "corner"]
}

    Generate & Run:

bash

python vega_cli.py -c config.json -o output_dir
cd output_dir
make simulate

Unit Testing with VEGA - ALU Example

RTL Module (alu.sv)
systemverilog

module alu #(parameter WIDTH=32) (
    input  [WIDTH-1:0] a, b,
    input  [2:0]       opcode,
    output [WIDTH-1:0] result,
    output             zero
);
    // Supported operations: 000:AND, 001:OR, 010:ADD, 110:SUB, 111:SLT
endmodule

Testbench Generation Flow
Diagram
Code

graph LR
    A[Load alu.sv] --> B[Analyze Interfaces]
    B --> C[Generate UVM Components]
    C --> D[Create Test Scenarios]

Generated Structure
text

alu_tb/
├── alu_interface.sv
├── alu_pkg.sv
├── sequences/
│   ├── alu_base_seq.sv
│   └── alu_corner_seq.sv
└── tests/
    └── alu_smoke_test.sv

Example Test
systemverilog

class alu_smoke_test extends uvm_test;
    `uvm_component_utils(alu_smoke_test)
    task run_phase(uvm_phase phase);
        alu_sequence seq = alu_sequence::type_id::create("seq");
        `uvm_do_with(seq, {
            opcode inside {3'b010, 3'b110};
            a dist {0 := 20, [1:100] := 80};
            b dist {0 := 20, [1:100] := 80};
        })
    endtask
endclass

System Testing with VEGA - RISC-V Core Example

Top-Level Module (riscv_core.sv)
systemverilog

module riscv_core (
    input  logic        clk, reset,
    output logic [31:0] pc,
    input  logic [31:0] instr,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    input  logic [31:0] mem_rdata,
    output logic        mem_we
);
    // 5-stage pipeline
endmodule

System Verification Flow
Diagram
Code

graph TB
    A[Load all RTL files] --> B[Analyze Hierarchy]
    B --> C[Identify Subsystems]
    C --> D[Generate System TB]
    D --> E[Create Pipeline Tests]

System Environment
systemverilog

class riscv_system_env extends uvm_env;
    fetch_agent    fetch;
    decode_agent   decode;
    execute_agent  execute;
    riscv_scoreboard scbd;
    function void connect_phase(uvm_phase phase);
        fetch.monitor.ap.connect(scbd.fetch_imp);
        decode.monitor.ap.connect(scbd.decode_imp);
    endfunction
endclass

Pipeline Test
systemverilog

class pipeline_hazard_test extends riscv_base_test;
    task run_phase(uvm_phase phase);
        `uvm_do_with(fetch_seq, {instr == ADD_X0_X1_X2;})
        `uvm_do_with(fetch_seq, {instr == SUB_X3_X0_X1;})
        `uvm_do_with(fetch_seq, {instr == JALR_X1_X2_0;})
        scbd.check_hazard_resolution();
    endtask
endclass

Advanced Usage

Custom Sequence
systemverilog

class riscv_custom_seq extends uvm_sequence;
    constraint valid_instructions {
        instr[6:0] inside {7'b0110011, 7'b0010011};
        if (instr[6:0] == 7'b1100011) {
            instr[14:12] != 3'b010;
        }
    }
endclass

Coverage Config
yaml

coverage:
  enable: true
  goals:
    line: 95%
    toggle: 90%
    fsm: 85%
  custom:
    - name: "alu_ops"
      bins: ["AND", "OR", "ADD", "SUB"]

Simulation Control
bash

make simulate UVM_VERBOSITY=UVM_HIGH SEED=12345 TEST=alu_smoke_test

Troubleshooting
Symptom	Solution
UVM errors	Verify UVM_HOME path
Interface issues	Check port mappings
Randomization fails	Review constraints
FAQ

Clock/Reset Handling: Automatically detected and constrained
Test Extension: All components designed for inheritance
Batch Mode: python vega_cli.py -c config.json -o output_dir
Protocol Verification:
yaml

protocols:
  axi:
    version: 4
    checks: [outstanding_transactions, interleaving]

📝 For detailed API docs see docs/
🐞 Report issues here
text


This single continuous Markdown document maintains:  
1. All technical content without section breaks  
2. Original Mermaid diagrams and code blocks  
3. Complete flow from installation to advanced usage  
4. Consistent formatting for GitHub README rendering  
5. Practical examples for both ALU and RISC-V verification  
6. Troubleshooting and FAQ references  

The document is optimized for GitHub's Markdown parser while preserving all diagrams and code syntax highlighting.