`timescale 1ns/1ps
module RC4Design(
    input wire clk,
     input wire nxt_key,
     output reg key_valid,
    output reg[7:0] Dout
    );


reg[7:0] S[255:0];
reg[7:0] i;
reg[7:0] j;
reg[7:0] temp;
reg[7:0] S_din;
wire[7:0] S_dout;
reg[7:0] S_addr;
reg[7:0] key_addr;
wire[7:0] key_dout;
reg S_we;
reg[7:0] stage_1;
reg[7:0] stage_2;
reg[7:0] stage_3;
reg[7:0] stage_4;
parameter S0 = 0;
parameter S1 = 1;
parameter S2 = 2;
parameter S3 = 3;
parameter S4 = 4;
parameter S5 = 5;
parameter S6 = 6;
parameter S7 = 7;
reg[7:0]state;
initial state = S0;
initial i = 0;
initial j = 0;
wire [7:0] index;

RAM RAM (
    .clk(clk), 
    .we(S_we), 
    .addr(S_addr), 
    .d_in(S_din), 
    .d_out(S_dout)
    );


ROM ROM (
    .addr(key_addr), 
    .dout(key_dout)
    );
always@(posedge clk)
begin
key_valid <= 1'b0;
S_we   <= 1'b0;
case(state)
    // key schedual
    S0:
        begin
           S_addr   <= i;
            key_addr <= i;
            stage_1 <= key_addr;
            state <= S1;
        end
    S1: // S data is S[i]
        begin
            j <= j + S_dout + key_dout;
            temp <= S_dout;
            stage_2 <= S_din;
            state <= S2;
        end
   S2: // S data is S[i]
        begin
            S_addr <= j;
            S_din  <= S_dout;
            S_we   <= 1'b1;
            stage_3 <= S_din;
            state <= S3;
        end
    S3:
        begin
            S_addr <= i;
            S_din  <= S_dout;
            S_we   <= 1'b1;
            if(i==255)
                begin
                    i <= 1;
                    j <= 0;
                    state <= S4;
                end
            else
                begin
                    i <= i + 1;
                    state <= S0;
                end
            stage_4 <= temp;
        end
    // output generation
    S4:
        begin
            S_addr <= i;
            state <= S5;
        end
    S5:// in this state the output of the S_Ram is S[i]
       // S_dout is S[i]
        begin
           j <= j + S_dout;      // j = j + S[i]
            S_addr <= j + S_dout; // new j address
            S_din  <= S_dout;     // new S[j] value (S[i])
            temp   <= S_dout;     // keep S[i]
            S_we   <= 1'b1;
            state <= S6;
        end
    S6:// in this state the output of the S_Ram is S[j]
       // S_dout is S[i]
        begin
            S_addr <= i; // i address
            i <= i + 1; 
            S_din  <= S_dout;     // S[i] = S[j];
            Dout   <= temp + S_dout; // S[i] + S[j];
            S_we   <= 1'b1;
            state <= S7;
        end
    S7:
        begin
            key_valid <= 1'b1;
            if(nxt_key)
                state <= S4;
            else
                state <= S7;
        end
endcase
end 
endmodule