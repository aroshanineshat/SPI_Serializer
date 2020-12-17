module SPI_Serializer
#(
    parameter integer Register_Width = 32,
    parameter integer Shift_BitCount = 24
)
(input wire clk, 
input wire [Register_Width-1:0] Data_Register,
input wire ld,
output wire DataBit,
output wire SPI_clk,
output wire CS);

    parameter STATE_BitC = 4;
    parameter [STATE_BitC-1:0] STATE_IDLE = 'd0;
    parameter [STATE_BitC-1:0] STATE_TRAN = 'd1;

    reg [STATE_BitC-1:0] STATE_CURRENT;

    reg [Register_Width-1:0] data_register_r;
    reg [31:0] clk_counter_r;
    reg [31:0] clk_divider_value = 49152;
    reg output_clk_r;
    reg CS_r;


    initial begin
        data_register_r = 0;
        output_clk_r = 0;
        CS_r = 0;
        clk_counter_r = 0;
        STATE_CURRENT = STATE_IDLE;
    end

    always @(posedge clk) begin
        
    end


    always @(posedge clk) begin
        if (ld == 1'b1) begin
            data_register_r <= Data_Register; // load the new data into the register
            STATE_CURRENT <= STATE_TRAN; // loading also starts transmitting
        end
        case (STATE_CURRENT)
            case STATE_IDLE: begin
                
            end
            case STATE_TRAN: begin
                
            end
        endcase
    end

endmodule
