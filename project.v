module dsb(A,B,C,D,carryin,clk,opmode,BCIN,
	CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
	RSTA,RSTB,RSTC,RSCARRYIN,RSTD,RSTM,RSTopmode,RSTP,
	BCOUT,PCIN,Pcout,M,P,carryout,carryoutf);
parameter A0REG=0;
parameter A1REG=1;
parameter B0REG=0;
parameter B1REG=1;
parameter CREG=1;
parameter DREG=1;
parameter MREG=1;
parameter PREG=1;
parameter CARRYINREG=1;
parameter CARRYOUTREG=1;
parameter opmodeREG=1;
parameter CARRYINSEL="opcode5";
parameter B_input="DIRECT";
parameter RSTTYPE="SYNC";
input [17:0]A,B,D,BCIN;
input [47:0]C,PCIN;
input [7:0]opmode;
input carryin,clk,CEA,CEB,CEC,CECARRYIN,CEOPMODE,CED,CEP,CEM,RSTA,RSTP,
RSTC,RSTM,RSTopmode,RSTB,RSCARRYIN,RSTD;
output [35:0]M;
output [47:0]P,Pcout;
output carryout,carryoutf;
output [17:0] BCOUT;
wire [17:0]A0,B0,D0,A1,B1,pre1,B0_mux,B0_reg;
wire [35:0]mult;
reg [47:0]X,Z;
wire [47:0]P_reg,sum,C0;
wire carry_out,carry_in,cin;
wire [7:0]opmode_mux;
assign carry_in=(CARRYINSEL=="opcode5")?opmode_mux[5]:(CARRYINSEL=="carryin")?carryin:0;
assign B0_mux=(B_input=="DIRECT")?B:(B_input=="CASCADE")?BCIN:0;
assign pre1=(opmode_mux[6])?D0-B0:D0+B0;
assign B0_reg=(opmode_mux[4])?pre1:B0;
assign sum={D0[11:0],A1,B1};
assign mult=B1*A1;
assign BCOUT=B1;
assign {carry_out,P_reg}=(opmode_mux[7])?(Z-(X+cin)):(Z+X+cin);
assign Pcout=P;
assign carryoutf=carryout;
reg_mux  A_reg(RSTA,clk,CEA,A0RE,A,A0);
reg_mux  A1_reg(RSTA,clk,CEA,A1REG,A0,A1);
reg_mux B_reg(RSTB,clk,CEB,B0REG,B0_mux,B0);
reg_mux  B1_reg(RSTB,clk,CEB,B1REG,B0_reg,B1);
reg_mux  D_reg(RSTD,clk,CED,DREG,D,D0);
reg_mux #(.reg_size(48)) C_reg(RSTC,clk,CEC,CREG,C,C0);
reg_mux #(.reg_size(8)) sel_reg(RSTopmode,clk,CEOPMODE,opmodeREG,opmode,opmode_mux);
reg_mux #(.reg_size(36)) M_reg(RSTM,clk,CEM,MREG,mult,M);
reg_mux #(.reg_size(1)) cyi_reg(RSCARRYIN,clk,CECARRYIN,CARRYINREG,carry_in,cin);
reg_mux #(.reg_size(48)) p_reg(RSTP,clk,CEP,PREG,P_reg,P);
reg_mux #(.reg_size(1)) cyo_reg(RSCARRYIN,clk,CECARRYIN,CARRYOUTREG,carry_out,carryout);
always@(*)begin
	case({opmode_mux[1],opmode_mux[0]})
	2'b00:X<=0;
	2'b01:X<=M;
	2'b10:X<=P;
	2'b11:X<=sum;
	endcase
end
always@(*)begin
	case({opmode_mux[3],opmode_mux[2]})
	2'b00:Z<=0;
	2'b01:Z<=PCIN;
	2'b10:Z<=P;
	2'b11:Z<=C0;
	endcase
end
endmodule