`timescale 1ns / 1ns
`define REGFILE_LOAD 1'b0
`define REGFILE_READ 1'b1

`define WORD_SIZE 4
`define WORD_BITS (8 * `WORD_SIZE) - 1

`define NUM_REGS 16
`define REGS_BITS 3 //hard coded, fix
//module main(input sysclk, input [3:0] in, output reg [3:0] out);
    
//endmodule

/*
    Harvard architecture.
    64K address space.
*/
module processor(input clk, input rst, output reg [15:0] ir_addr, input [`WORD_BITS:0] ir_data, output reg [15:0] data_addr, input [15:0] data_data, input data_rw);
    
    reg en_regfile = 0;
    reg en_alu = 0;
    reg en_pc = 0;
    
    reg rst_alu = 0;
    reg rst_pc = 0;
    reg rst_regfile = 0;
    
    reg load_store = `REGFILE_READ;
    reg [3:0] sel_a = 0;
    reg [3:0] sel_b = 0;
    reg [15:0] reg_in = 0;
    wire [15:0] out_a;
    wire [15:0] out_b;
    
    wire [15:0] out;
    reg [2:0] op = 1;
    
    reg [2:0] cond = 0;
    wire branch;
    
    reg load_count = 0;
    reg [15:0] load = 0;
    wire [15:0] pc;
    
    reg [`WORD_BITS:0] ir = 0;
    
    //0 for data read, 1 for data write
   
    //module regfile(input clk, input en, input load_store, input [2:0] sel_a, input [2:0] sel_b, input [15:0] reg_in, output reg [15:0] out_a, reg [15:0] out_b);
    //module alu(input clk, input en, input rst, input [15:0] reg_a, input [15:0] reg_b, output reg [15:0] out, input [2:0] op);
    //module branch(input [2:0] cond, input [15:0] op_a, input [15:0] op_b, output branch);
    //module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
   
    regfile r(.clk(clk), .en(en_regfile), .rst(rst_regfile), .load_store(load_store), .sel_a(sel_a), .sel_b(sel_b), .reg_in(reg_in), .out_a(out_a), .out_b(out_b));
    alu a(.clk(clk), .en(en_alu), .rst(rst_alu), .reg_a(out_a), .reg_b(out_b), .out(out), .op(op));
    branch b(.cond(cond), .op_a(out_a), .op_b(out_b), .branch(branch));
    pc p(.clk(clk), .en(en_pc), .rst(rst_pc), .load_count(load_count), .load(load), .pc(pc));
    
    /*
        Instruction decodings:
        
        16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1
        |      11-bit imm              |     opcode   |  jr x (jump relative to pc)
        |xxxxx|  dest  |  srcB  | srcA |     opcode   |  add r0, r1, r2
        |xxxxxxxxxxxxxx|  dest  | srcA |     opcode   |  mv r0, r1
        |xxxxxxxxxxxxxxxxxxxxxxx| srcA |     opcode   |  push r0
       
    */
    always @(posedge rst) begin
        ir <= 0;
        rst_pc <= 1;
        rst_alu <= 1;
        rst_regfile <= 1;
        @(posedge clk);
        rst_pc <= 0;
        rst_alu <= 0;
        rst_regfile <= 0;
        
        load_count <= 1;
        en_pc <= 1;
        
        data_addr <= 0;
    end
    
    always @(posedge clk) begin
        ir_addr <= pc;
        ir <= ir_data;
        case (ir[5:0])
            6'h0: ; // nop
            6'h1: begin   // mv reg, reg
                    reg_in <= ir_data[31:15];
                    load_store <= `REGFILE_LOAD;
                    en_regfile <= 1;
                    @(posedge clk);
                    // track the opcode as it goes through the pipeline, instead of having a weird buffer thing
                    @(posedge clk);
                    //...
                end
                
                
                
        endcase
    end
endmodule

/*
    To add
        Hazard detection and resolution unit
            Use nops in between instructions until this is built
        Branch prediction?
        More instructions - multiply/divide support?
        Sign extension
        PC follow-through for jump instructions
        
        
        
    To optimize
        Instruction decoding - wasting 50% of word if no immediate is used... not a good use of space
*/

/*
    Program counter - async. load and clear.
*/
module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
    always @(posedge clk && en) begin
        pc <= pc + 1;
    end
    
    //PC will always be loaded with something, either 4+pc or a literal
    always @(negedge load_count) begin //count = 1, load = 0
        pc <= load;
    end
    
    always @(posedge rst) begin
        pc <= 16'h00;
    end
endmodule

/*
    Register file - sync. load/store.
*/
module regfile(input clk, input en, input rst, input load_store, input [`REGS_BITS:0] sel_a, input [`REGS_BITS:0] sel_b, input [15:0] reg_in, output reg [15:0] out_a, output reg [15:0] out_b);
    reg [15:0] regfile [2:0];
    always @(posedge clk && en) begin
        if (load_store) begin
            out_a <= regfile[sel_a];
            out_b <= regfile[sel_b];
        end else begin
            regfile[sel_a] <= reg_in;
            out_a <= 16'h0000;
            out_b <= 16'h0000;
        end
    end
    
    always @(posedge rst) begin
        integer i;
        for (i = 0; i < `NUM_REGS; i += 1) begin
            regfile[i] <= 0;
        end
    end
endmodule

/*
    ALU - async. clear.  Especially simple since no status bits based on results are set.
*/
module alu(input clk, input en, input rst, input [15:0] reg_a, input [15:0] reg_b, output reg [15:0] out, input [2:0] op);
    always @(posedge clk && en) begin
        out <= op == 1 ? reg_a + reg_b : reg_a - reg_b;
    end
    
    always @(posedge rst) begin
        out <= 16'h00;
    end
endmodule

/*
    Conditional branch decision - strictly combo since this happens in parallel with ALU usage and no state needs to be kept
*/
module branch(input [2:0] cond, input [15:0] op_a, input [15:0] op_b, output branch);
    wire [2:0] branch_cond_set;
    
    assign branch_cond_set[0] = (op_a >= op_b) ? 1 : 0; //GE
    assign branch_cond_set[1] = (op_a > op_b) ? 1 : 0; //G
    assign branch_cond_set[2] = (op_a <= op_b) ? 1 : 0; //LE
    assign branch_cond_set[3] = ~branch_cond_set[1]; //L
    assign branch_cond_set[4] = (op_a == op_b) ? 1 : 0; //E
    assign branch_cond_set[5] = ~branch_cond_set[4]; //NE
    assign branch_cond_set[6] = (op_a == 0) ? 1 : 0; //Z
    assign branch_cond_set[7] = ~branch_cond_set[6]; //NZ
    
    assign branch = branch_cond_set[cond];
endmodule