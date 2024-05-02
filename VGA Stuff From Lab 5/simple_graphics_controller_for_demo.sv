module simple_graphics_controller_for_demo
(
	input [9:0] x_coord_of_current_block,
	input [9:0] y_coord_of_current_block,
	input whichRAM,
	output [7:0] pixelPacking
);

	logic [7:0] pixelPacking_wire;
	logic [10:0] blockParity;
	
	assign blockParity = x_coord_of_current_block+y_coord_of_current_block;
	always_comb
	begin
		if (whichRAM)
		begin
			if(blockParity==2*(blockParity>>1))
				pixelPacking_wire = 7;
			else
				pixelPacking_wire = 0;
		
		end
		
		else
		begin
			if (y_coord_of_current_block > 12)
				pixelPacking_wire = 7<<3;
			else
				pixelPacking_wire = 2<<3;
		end
		
	end
	
	assign pixelPacking = pixelPacking_wire;

endmodule