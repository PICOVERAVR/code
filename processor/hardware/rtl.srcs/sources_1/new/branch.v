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