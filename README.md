# FSM-Based Hybrid Memory Testing Using Verilog HDL

##  Project Overview

This project focuses on the design and implementation of an FSM-based hybrid memory testing system using Verilog HDL. The system combines the **March C– algorithm and the Checkerboard algorithm** to detect memory faults in a modeled memory architecture.

The project uses Finite State Machines (FSMs) to control memory test operations, generate read/write sequences, and evaluate memory responses. A parameterized memory model is used to simulate memory behavior and investigate fault detection, including stuck-at faults, transition faults, and coupling faults.

##  Objectives

- Design an FSM-based memory testing architecture using Verilog HDL.
- Implement the March C– memory testing algorithm.
- Implement the Checkerboard memory testing algorithm.
- Integrate both algorithms into a hybrid memory testing controller.
- Develop a memory model with configurable fault injection.
- Detect and analyze stuck-at, transition, and coupling faults.
- Verify the design using Verilog testbenches.
- Evaluate the functionality of the hybrid testing system through simulation.

## Tools and Technologies

- **Verilog HDL**
- **Xilinx Vivado Design Suite**
- Finite State Machine (FSM) design
- Memory Built-In Self-Test (MBIST)
- Behavioral memory modeling
- RTL simulation and verification
- FPGA-based digital system design

## System Architecture

The project consists of the following major modules:

- **March C– FSM:** Executes the March C– algorithm using predefined read and write operations across memory addresses.
- **Checkerboard FSM:** Writes and reads alternating data patterns to detect pattern-sensitive and related memory faults.
- **Hybrid FSM Controller:** Coordinates the March C– and Checkerboard testing phases.
- **Memory Model:** Simulates memory read and write operations using address and data signals.
- **Fault-Injection Memory Model:** Introduces configurable memory faults to evaluate the fault detection capability of the testing algorithms.
- **Address Counter:** Generates memory addresses for sequential testing.
- **Testbench:** Applies test scenarios, monitors memory operations, and verifies the overall system behavior.

The architecture is designed to evaluate memory testing through a combination of complementary test algorithms.

## Simulation Workflow

1. Define the memory architecture, address range, and data width.
2. Implement the March C– FSM and its required read/write sequences.
3. Implement the Checkerboard FSM to test alternating data patterns.
4. Develop the hybrid controller to coordinate both testing algorithms.
5. Create the memory model and configure the required fault models.
6. Integrate the controllers, memory model, address counter, and testbench.
7. Simulate the design using Vivado to verify the FSM transitions and memory operations.
8. Analyze the simulation waveforms and fault detection responses.
9. Perform synthesis and evaluate FPGA resource utilization when required.

## Repository Structure

```text
FSM-Based-Hybrid-Memory-Testing-using-Verilog-HDL/
├── README.md
├── addr_counter.v
├── mem_model.v
├── mem_model_faults.v
├── marchc_fsm.v
├── checkerboard_fsm.v
├── hybrid_fsm.v
├── hybrid_top.v
└── testbench.v
```

*Note: The filenames shown above are representative. Update the repository structure to match the actual files included in your project.*

## Expected Analysis

After successful simulation and verification, the project can be used to analyze:

- Memory fault detection capability.
- March C– and Checkerboard algorithm behavior.
- FSM state transitions and test sequencing.
- Memory read/write operations across different addresses.
- Detection of stuck-at faults.
- Detection of transition faults.
- Detection of coupling faults supported by the implemented fault model.
- Simulation waveforms and test completion status.
- FPGA synthesis resource utilization, including LUTs, flip-flops, and other reported resources.

*Note: Fault coverage, simulation results, and synthesis statistics should be reported only after the corresponding tests have been executed and verified.*

## Current Status

**FSM-based hybrid memory testing design and verification development**

The project is structured around the integration of March C– and Checkerboard testing algorithms using Verilog HDL. The design includes memory modeling, FSM-based test control, and provisions for fault injection and simulation-based verification.

Successful fault detection, complete simulation verification, and FPGA implementation results should be documented after validating the corresponding design files and test outputs.

## Author- Vakiti Manohar

Project developed as part of digital system design, Verilog HDL, FPGA-based memory testing, and semiconductor testing studies.
