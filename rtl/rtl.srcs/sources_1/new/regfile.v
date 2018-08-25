/*
    register file for doing stuff and things
*/

module regfile(input clk, input en, input rst, input [3:0] sel_a, input [3:0] sel_b, input rw, output reg [15:0] reg_a, output reg [15:0] reg_b, input [3:0] write, input [15:0] write_val);
    
    reg [3:0] int_regfile[15:0];
    
    always @(posedge clk && en) begin
        if (rw) begin // 1 for writing to regfile
            int_regfile[write] <= write_val;
        end
        reg_a <= int_regfile[sel_a];
        reg_b <= int_regfile[sel_b];
        
    end
endmodule