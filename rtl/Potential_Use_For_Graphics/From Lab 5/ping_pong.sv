module ping_pong #(parameter SAMPLES, WIDTH)
(
	input clk, //only because the RAM IP requires it
	input [9:0] hc,
	input [9:0] vc,
	input [7:0] updated_value_of_block,
	output logic [7:0] pixel_to_display
);

	wire  [7:0] intermediate_color_wire;
	logic [7:0] table_tennis1_data_write, table_tennis1_data_read;
	logic [7:0] table_tennis2_data_write, table_tennis2_data_read;
	logic [9:0] blockNumber, x, y;
	assign x = (hc/20);
	assign y = (vc/20);
	assign blockNumber = y * 32 + x;
	
	logic write_to_two = 0;
	
	reg [7:0] array1 [800:0];
	reg [7:0] array2 [800:0];
	
	/*
	PING_PONG_RAM_IP
    table_tennis1
    (
        blockNumber,
        clk,
        table_tennis1_data_write,
        ~write_to_two,
        table_tennis1_data_read
    );

    PING_PONG_RAM_IP 
    table_tennis2
    (
        blockNumber,
        clk,
        table_tennis2_data_write,
        write_to_two,
        table_tennis2_data_read
    );
	*/
	
	always @(posedge clk)
	begin
		if ((write_to_two))
			array2[blockNumber] <= updated_value_of_block;
		else
			array1[blockNumber] <= updated_value_of_block;

		if ((vc == 0) && (hc==0))
			begin
				write_to_two <= ~write_to_two;
			end
	end
	
	always_comb
	begin
		table_tennis1_data_read = array1[blockNumber];			
	   table_tennis2_data_read = array2[blockNumber];
	end
	
	assign intermediate_color_wire = (write_to_two) ? table_tennis1_data_read : table_tennis2_data_read;
	assign pixel_to_display = intermediate_color_wire;
	
endmodule