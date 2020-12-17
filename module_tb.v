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
        Inputdata = 32'b00000000_100111100_01101100_10001101;

        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        #10 ld = 1;
        #15 ld = 0;
    end

    SPI_Serializer inst1 
(.clk (clk), 
.Data_Register(Inputdata),
.ld(ld),
.DataBit(serial_databit),
.SPI_clk(serial_clk),
.CS(serial_cs));

    initial begin
        #500000 $finish;
    end

    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
    end
endmodule
