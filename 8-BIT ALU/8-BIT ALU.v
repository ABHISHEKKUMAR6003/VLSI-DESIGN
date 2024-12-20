`timescale 1ns / 1ps


module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
    );
    assign sum = a^b^cin;
    assign cout = a&b | b&cin | cin&a;
endmodule

module eight_bit_adder(
    input [7:0] A,
    input [7:0] B,
    input Bin,
    output [7:0] D,
    output Bout
    );
    
    wire c1,c2,c3,c4,c5,c6,c7;
    full_adder m0(A[0],B[0],Bin,D[0],c1);
    full_adder m1(A[1],B[1],c1,D[1],c2);
    full_adder m2(A[2],B[2],c2,D[2],c3);
    full_adder m3(A[3],B[3],c3,D[3],c4);
    full_adder m4(A[4],B[4],c4,D[4],c5);
    full_adder m5(A[5],B[5],c5,D[5],c6);
    full_adder m6(A[6],B[6],c6,D[6],c7);
    full_adder m7(A[7],B[7],c7,D[7],Bout);
endmodule
    
module full_sub(
    input a,
    input b,
    input bin,
    output d,
    output borrow
    );
    assign d = a^b^bin;
    assign borrow =  (~a)&b | b&bin | (~a)&bin;
endmodule 

module eight_bit_sub(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
    );
    
    wire c1,c2,c3,c4,c5,c6,c7;
    full_sub m0(A[0],B[0],Cin,S[0],c1);
    full_sub m1(A[1],B[1],c1,S[1],c2);
    full_sub m2(A[2],B[2],c2,S[2],c3);
    full_sub m3(A[3],B[3],c3,S[3],c4);
    full_sub m4(A[4],B[4],c4,S[4],c5);
    full_sub m5(A[5],B[5],c5,S[5],c6);
    full_sub m6(A[6],B[6],c6,S[6],c7);
    full_sub m7(A[7],B[7],c7,S[7],Cout);
endmodule

module eight_bit_multiplier(
    input [7:0] a,
    input [7:0] b,
    output [15:0] o
    );
    assign o = a * b;
endmodule

module EIGHT_BIT_ALU(
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [2:0] Op,
    output reg [15:0] OUT,
    output reg cb
    );
    wire [7:0] add; wire [7:0] sub; wire [15:0] mul;
    wire [7:0] ls; wire [7:0] rs;
    wire carry, borrow;
    eight_bit_adder ADDER(A, B, 0, add, carry);
    eight_bit_sub SUBTRACTOR(A, B, 0, sub, borrow);
    eight_bit_multiplier MULTIPLIER(A, B, mul);
    assign ls = A<<B; 
    assign rs = A>>B;
    
    always @(Op or A or B)
      begin
      case (Op)
        3'b000 : begin OUT = add; cb = carry; end
        3'b001 : begin OUT = sub; cb = borrow; end
        3'b010 : OUT = mul;
        3'b011 : OUT = ls;
        3'b100 : OUT = rs;
        3'b101 : OUT = A & B;
        3'b110 : OUT = A | B;
        3'b111 : OUT = A ^ B;
      endcase
      end
 endmodule
        
 



