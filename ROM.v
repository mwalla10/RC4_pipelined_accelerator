`timescale 1ns / 1ps

module ROM(
    input wire[7:0] addr,
    output wire[7:0] dout
    );
reg[7:0] memory[0:255];
initial  
$readmemh("mem_init_file.txt", memory);
assign dout = memory[addr];
endmodule