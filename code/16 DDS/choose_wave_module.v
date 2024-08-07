module choose_wave_module
(
	CLK, Rstn, SW_Sin_In, SW_Square_In, SW_Sawtooth_In, KW, Wave_Data
);
	input CLK, Rstn;
	input SW_Sin_In, SW_Square_In, SW_Sawtooth_In;
	input [7:0] KW;
	
	output [7:0] Wave_Data;	
	 
	reg [11:0] Cnt;
	wire [11:0] addr;	 
	 

	always @ (posedge CLK, negedge Rstn)
		begin
			if(!Rstn) 
				Cnt <= 12'd0;
			else if(Cnt == 12'd4095)
				Cnt <= 12'd0;	
			else	
				Cnt <= Cnt + KW;
		 end
		
	assign addr = Cnt;


	wire [7:0] Sin_Out, Square_Out, Sawtooth_Out;	
	reg [7:0] Wave_Out_r;
	 
	dds_sin_rom	Sin_Rom
	(
		.address ( addr ),	// input - from top
		.clock ( CLK ),		// input - from top
		.q ( Sin_Out )			// output - to top
	);
		
	dds_square_rom	Square_Rom
   (
	.address ( addr ),		// input - from top
	.clock ( CLK ),			// input - from top
	.q ( Square_Out )			// output - to top
	);	
	
	dds_sawtooth_rom	Sawtooth_Rom 
	(
	.address ( addr ),		// input - from top
	.clock ( CLK ),			// input - from top
	.q ( Sawtooth_Out )		// output - to top
	);

	always @ (posedge CLK, negedge Rstn)
		begin
			if(!Rstn)
				Wave_Out_r <= 0;
			else if(SW_Sin_In == 1)
				Wave_Out_r <= Sin_Out;
			else if(SW_Square_In == 1)
				Wave_Out_r <= Square_Out;	
			else if(SW_Sawtooth_In == 1)
				Wave_Out_r <= Sawtooth_Out;	
			else
				Wave_Out_r <= 0;
		end
		
	assign Wave_Data = Wave_Out_r;
				
endmodule