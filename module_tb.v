`timescale 1ns / 1ps
module test;

    reg clk;
    reg [31:0] Inputdata = 32'h00000000;
    reg ld;

    wire serial_databit;
    wire serial_clk;
    wire serial_cs;

    initial begin
        clk = 0;
        ld  = 0;

        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        #9 ld = 1;
        #1 ld = 0;
        #1199 ld = 1;
        #1 ld = 0;
    end

    initial begin
        #5      Inputdata = 32'b00000000_10011110_01101101_01010101;
        #1190   Inputdata = 32'b00000000_10000000_11110000_11111110;
    end

    SPI_Serializer inst1 
(.clk (clk), 
.Data_Register(Inputdata),
.ld(ld),
.DataBit(serial_databit),
.SPI_clk(serial_clk),
.CS(serial_cs));

    initial begin
        #5000 $finish;
    end

    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
    end
endmodule
