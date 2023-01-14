`timescale 1ns/1ps

module RAM(
    input wire clk,we,
    input wire[7:0] addr,
    input wire[7:0] d_in,
    output reg[7:0] d_out
    );
reg[7:0] memory[0:255];
initial
$readmemh("mem_init_file.txt", memory);
always@(posedge clk)
    d_out <= memory[addr];
endmodule