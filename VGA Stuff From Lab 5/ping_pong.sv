module ping_pong
(
	input clk, //only because the RAM IP requires it
	input [9:0] hc,
	input [9:0] vc,
	output [7:0] pixel_to_display,
	input write_to_two
);
	logic [7:0] updated_value_of_block;
	wire  [7:0] intermediate_color_wire;
	logic [7:0] table_tennis1_data_write, table_tennis1_data_read;
	logic [7:0] table_tennis2_data_write, table_tennis2_data_read;
	logic [9:0] blockNumber, x, y;
	assign x = (hc/20);
	assign y = (vc/20);
	assign blockNumber = y * 32 + x;
	
	reg [7:0] array1 [1200:0];
	reg [7:0] array2 [1200:0];
	
	simple_graphics_controller_for_demo
	getColor
	(
		.x_coord_of_current_block(x),
		.y_coord_of_current_block(y),
		.whichRAM(write_to_two),
		.pixelPacking(updated_value_of_block)
	);
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
			array2[blockNumber] <= updated_value_of_block; //This line isn't doing anything, even though updated_value_of_block contains the correct value
		else
			array1[blockNumber] <= updated_value_of_block; //This line isn't doing anything, even though updated_value_of_block contains the correct value
	end
	
	always_comb
	begin
		table_tennis1_data_read = array1[blockNumber];			
	   table_tennis2_data_read = array2[blockNumber];
	end
	
	assign intermediate_color_wire = (write_to_two) ? table_tennis1_data_read : table_tennis2_data_read;
	assign pixel_to_display = intermediate_color_wire;
	
endmodule