/*
    Program counter - async. load and clear.
*/
module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
    always @(posedge clk && en) begin
        pc <= pc + 1;
    end
    
    //PC will always be loaded with something, either 1+pc or a literal
    always @(negedge load_count) begin //count = 1, load = 0
        pc <= load;
    end
    
    always @(posedge rst) begin
        pc <= 16'h00;
    end
endmodule