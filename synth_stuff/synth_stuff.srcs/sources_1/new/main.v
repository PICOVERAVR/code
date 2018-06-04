module main(input sysclk, input [3:0] in, output reg [3:0] out);
    initial begin
        out <= 0;
    end
    
    always @(posedge sysclk) begin
        out <= out + 1;
    end
endmodule
