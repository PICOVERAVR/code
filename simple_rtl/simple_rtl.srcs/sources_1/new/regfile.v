`define NUM_REGS 16
`define REGS_BITS 2 //hard coded, fix [2:0]

/*
    Register file - sync. load/store.
    To change:
	Make a read happen on negedge, write happen on posedge.
	This resolves a structural hazard with the register file.
	Do the same thing with the memory code.
*/
module regfile(input clk, input en, input rst, input load_store, input [`REGS_BITS:0] sel_a, input [`REGS_BITS:0] sel_b, input [`REGS_BITS:0] sel_write, input [15:0] reg_in, output reg [15:0] out_a, output reg [15:0] out_b);
    reg [15:0] regfile [2:0];
    
    always @(posedge clk && en) begin
            out_a <= regfile[sel_a];
            out_b <= regfile[sel_b];
    end
    
    always @(negedge clk && en) begin
        if (!load_store) begin
            regfile[sel_write] <= reg_in;
        end
    end
    
    always @(clk) begin
        $monitor("regfile is %h %h %h %h", regfile[0], regfile[1], regfile[2], regfile[3]);
    end
    
    always @(posedge rst) begin
        
        
    end
endmodule