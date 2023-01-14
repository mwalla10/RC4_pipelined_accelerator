//Testbench code

`timescale 1ns / 1ps
module RC4_tb;
    reg clk;
    reg nxt_key;
    wire key_valid;
    wire [7:0] Dout;

    RC4Design uut (
        .clk(clk), 
        .nxt_key(nxt_key), 
        .key_valid(key_valid), 
        .Dout(Dout)
    );

    initial begin
        // Initialize Inputs
        clk = 1'b0;
        nxt_key = 1'b0;
    end
   
    always #10 clk = ~clk;
    
    always@* begin
        if(key_valid)
            begin
                nxt_key <= 1'b1;
                #20;
            end
        else
            nxt_key <= 1'b0;
        

        #200000 $finish;
    end
    initial begin
    $dumpfile("RC4_tb.vcd");
    $dumpvars(0, RC4_tb);
  end
endmodule

