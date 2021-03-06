//////////////////////////////////////////////////////////////////////////////////
// The University of Arizona
// Engineer: Arash Roshanineshat
// 
// Design Name: SPI Serializer
// Module Name: SPI_Serializer
// Target Devices: ZCU111 Dev Board
// Description: 
//      This module is used to communicate with signal attenuators on a daughter
//      board connected to the ZCU111 development board.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module SPI_Serializer
#(
    parameter integer Register_Width = 32,
    parameter integer Shift_BitCount = 32
)
(input wire clk, 
input wire [Register_Width-1:0] Data_Register,
input wire ld,
input wire [1:0] DelAttSelect,
output wire DataBit,
output wire SPI_clk,
output wire Att_CS,
output wire Del_CS);


    //Configuring States--------------------------
    parameter STATE_BitC = 4;
    parameter [STATE_BitC-1:0] STATE_IDLE = 'd0;
    parameter [STATE_BitC-1:0] STATE_LOAD = 'd1;
    parameter [STATE_BitC-1:0] STATE_TRAN = 'd2;
    parameter [STATE_BitC-1:0] STATE_CS   = 'd3;

    reg [STATE_BitC-1:0] STATE_CURRENT;
    //--------------------------------------------

    reg [Register_Width-1:0] data_register_r;
    reg [31:0] clk_counter_r;
    reg [31:0] clk_divider_value = 20; //49152 / 2
    reg slow_clk_r;
    reg slow_clk_r_buf;
    reg SPI_clk_r;

    reg Att_CS_r;
    reg Del_CS_r;
    
    reg [31:0] Bitshift_counter;


    //Setting the initial value of all registers.
    //They all can be zero.
    initial begin 
        data_register_r = 0;
        slow_clk_r = 0;
        slow_clk_r_buf = 0;
        Att_CS_r = 0;
        Del_CS_r = 0;
        clk_counter_r = 0;
        SPI_clk_r = 0;
        Bitshift_counter = 0;
    end

    //The initial state is IDLE. 
    initial begin
        STATE_CURRENT = STATE_IDLE;
    end

    always @(posedge clk) begin

          
        if (clk_counter_r == clk_divider_value) begin
            slow_clk_r <= ~slow_clk_r;
        end else if (clk_counter_r == clk_divider_value/2) begin
            slow_clk_r <= ~slow_clk_r;
        end

        if (clk_counter_r == clk_divider_value) begin
            clk_counter_r <= 0;
        end else begin
            clk_counter_r <= clk_counter_r+1;
        end
    end


    always @(posedge clk) begin

        case (STATE_CURRENT)
            STATE_IDLE: begin
                if (ld == 1'b1) begin
                    data_register_r <= Data_Register; // load the new data into the register
                    STATE_CURRENT   <= STATE_LOAD;    // loading also starts transmitting
                end
                Att_CS_r <= 0;
                Del_CS_r <= 0;
            end
            STATE_LOAD:begin // This state waits till the LOAD pin is de-asserted
                if (ld == 1'b0) begin 
                    if (clk_counter_r == 0) begin
                        STATE_CURRENT <= STATE_TRAN;
                    end
                end else begin
                    data_register_r <= Data_Register; 
                    STATE_CURRENT <= STATE_LOAD;
                end
            end
            STATE_TRAN: begin
                if (Bitshift_counter != Shift_BitCount) begin
                    SPI_clk_r        <= slow_clk_r;
                end else begin
                    SPI_clk_r        <= 0;
                end
                if (clk_counter_r == clk_divider_value ) begin
                    data_register_r <= data_register_r >> 1;
                    if (Bitshift_counter != Shift_BitCount) begin
                        Bitshift_counter <= Bitshift_counter + 1;
                    end 
                end
                if (Bitshift_counter == Shift_BitCount) begin
                    Bitshift_counter <= 0;
                    STATE_CURRENT <= STATE_CS;
                    Att_CS_r <= DelAttSelect[0];
                    Del_CS_r <= DelAttSelect[1];
                end
            end
            STATE_CS: begin
                SPI_clk_r <= 0;
                if (clk_counter_r == clk_divider_value / 2) begin
                    STATE_CURRENT <= STATE_IDLE;
                end
            end
            default :begin
                
            end
        endcase
    end

    assign DataBit = data_register_r[0];
    assign SPI_clk = SPI_clk_r;
    assign Att_CS = Att_CS_r;
    assign Del_CS = Del_CS_r;

endmodule
