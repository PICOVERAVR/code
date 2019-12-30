/*

arithmetic functional units, to mix and match in the final design.
currently only supporting unsigned 24-bit arithmetic.

*/

`timescale 1ns / 1ns

module u24add(
    input clk,
    input [23:0] opa,
    input [23:0] opb,
    output reg [23:0] result
    //output reg [23:0] status
);
    
    //wire ov, z;
    //assign ov = {1'b0, opa} + {1'b0, opb} > 25'hFFFFFF ? 1'h1 : 1'h0;
    //assign z = opa + opb == 24'h0 ? 1'h1 : 1'h0;
    
    always @(posedge clk) begin
        result <= opa + opb;
        //status <= {22'h0, z, ov};
    end
endmodule

module u24sub(
    input clk,
    input [23:0] opa,
    input [23:0] opb,
    output reg [23:0] result
    //output reg [23:0] status
);

    //wire uv, z;
    //assign uv = {1'b0, opa} - {1'b0, opb} > 25'hFFFFFF ? 1'h1 : 1'h0;
    //assign z = opa - opb == 24'h0 ? 1'h1 : 1'h0;
    
    always @(posedge clk) begin
        result <= opa - opb;
        //status <= {22'h0, z, uv};
    end
endmodule

module shift24(
    input clk,
    input [23:0] opa,
    input [23:0] dir, // direction to shift
    input [23:0] shift, // number of places to shift
    output reg [23:0] result
);
    parameter lshift = 24'h0;
    parameter rshift = 24'h1;
    
    always @(posedge clk) begin
        case (dir)
            lshift: begin
                result <= opa << shift;
            end
            rshift: begin
                result <= opa >> shift;
            end
            default: begin
                $display("invalid shift direction, doing nothing");
            end
        endcase
    end
endmodule

module umul24(
    input clk,
    input [23:0] opa,
    input [23:0] opb,
    output reg [23:0] resultl,
    output reg [23:0] resulth
);
    always @(posedge clk) begin
        { resultl, resulth } <= opa * opb;
    end
endmodule

// logical and div later