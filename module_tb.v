`timescale 1ns / 1ps
module test;

    reg clk;
    reg [31:0] Inputdata = 32'h00000000;
    reg ld;
    reg [1:0] Chip_select;

    wire serial_databit;
    wire serial_clk;
    wire serial_att_cs;
    wire serial_del_cs;

    initial begin
        clk = 0;
        ld  = 0;
        Chip_select = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        #1 Chip_select = 2'b01;
        #9 ld = 1;
        #2 ld = 0;
        #1190 Chip_select = 2'b10;
        #1199 ld = 1;
        #2 ld = 0;
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
.DelAttSelect(Chip_select),
.SPI_clk(serial_clk),
.Att_CS(serial_att_cs),
.Del_CS(serial_del_cs));

    initial begin
        #5000 $finish;
    end

    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
    end
endmodule
