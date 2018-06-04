module pc(input clk, input en, input rst, input load_count, input [15:0] load, output reg [15:0] pc);
    always @(posedge clk && en) begin
        if (load_count) begin
            pc <= load;
        end else begin
            pc <= pc + 1;
        end
    end
    
    always @(rst) begin
        pc <= 0;
    end

endmodule