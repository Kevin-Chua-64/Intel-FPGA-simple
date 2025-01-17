module display_module
(
	CLK, Rstn, RX_Done_Sig, RX_Data, LED_Out,
);
	input CLK, Rstn;	 
	input RX_Done_Sig;
	input [7:0] RX_Data;
	
   output [7:0] LED_Out;
	
	reg [7:0] rLED_Out;

	always @ (posedge CLK, negedge Rstn)
		if (!Rstn)
			rLED_Out <= 0;
		else if (RX_Done_Sig)
			rLED_Out <= RX_Data;
		else
			rLED_Out <= rLED_Out;
			
	assign LED_Out = rLED_Out;
	
endmodule
