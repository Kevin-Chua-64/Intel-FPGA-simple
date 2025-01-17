module Adjust_module(CLK, Rstn, AddDuty, SubDuty, AddPeriod, SubPeriod, Duty, Count_P);
	
	input CLK, Rstn;
	input AddDuty, SubDuty, AddPeriod, SubPeriod;
	output reg [7:0] Duty;
	output reg [23:0] Count_P;
	
	wire negAddDuty, negSubDuty, negAddPeriod, negSubPeriod; // put down the button
	
	Jitter_Elimination_module U1
		(.CLK(CLK), .Rstn(Rstn), .Button_In(AddDuty), .Button_Out(negAddDuty));
		
	Jitter_Elimination_module U2
		(.CLK(CLK), .Rstn(Rstn), .Button_In(SubDuty), .Button_Out(negSubDuty));
		
	Jitter_Elimination_module U3
		(.CLK(CLK), .Rstn(Rstn), .Button_In(AddPeriod), .Button_Out(negAddPeriod));
		
	Jitter_Elimination_module U4
		(.CLK(CLK), .Rstn(Rstn), .Button_In(SubPeriod), .Button_Out(negSubPeriod));
		
	always @ (posedge CLK, negedge Rstn) // Aujust duty
		begin
			if (!Rstn)
				Duty <= 8'd50;
			else if (negAddDuty)
				begin
					if (Duty == 8'd100)
						Duty <= Duty;
					else
						Duty <= Duty + 8'd10;
				end
			else if (negSubDuty)
				begin
					if (Duty == 8'd0)
						Duty <= Duty;
					else
						Duty <= Duty - 8'd10;
				end
			else
				Duty <= Duty;
		end

	/* While Count_P = 500_000, Period of PWM = 10ms, Frequency of PWM = 100HZ ;
		While Count_P = 250_000, Period of PWM = 5ms, Frequency of PWM = 200HZ ;
		While Count_P = 50_000, Period of PWM = 1ms, Frequency of PWM = 1000HZ ;	*/
	
	always @ (posedge CLK, negedge Rstn) // Aujust period
		begin
			if (!Rstn)
				Count_P <= 24'd250_000;
			else if (negAddPeriod)
				begin
					if (Count_P == 24'd500_000)
						Count_P <= Count_P;
					else
						Count_P <= Count_P + 24'd50_000;
				end
			else if (negSubPeriod)
				begin
					if (Count_P == 24'd0)
						Count_P <= Count_P;
					else
						Count_P <= Count_P - 24'd50_000;
				end
			else
				Count_P <= Count_P;
		end

endmodule
