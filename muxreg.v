module reg_mux(rst,clk,ce,sel,in,out);
parameter reg_size=18;
parameter RSTTYPE="SYNC";
input [reg_size-1:0]in;
input rst,clk,ce,sel;
output [reg_size-1:0]out;
reg [reg_size-1:0] ff;
generate if (RSTTYPE=="SYNC") begin
always@(posedge clk)begin
	if(rst)
	ff<=0;
	else if(ce) 
		ff<=in;
	end
end
else if(RSTTYPE=="ASYNC") begin
	always@(posedge clk or posedge rst)begin
	if(rst)
	ff<=0;
	else if(ce) 
		ff<=in;
end
end
endgenerate
assign out=(sel)?ff:in;
endmodule
