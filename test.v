module test ();
reg [17:0]A,B,D,BCIN;
reg [47:0]C,PCIN;
reg [7:0]opmode;
reg carryin,clk,CEA,CEB,CEC,CECARRYIN,CEOPMODE,CED,CEP,CEM,RSTA,RSTP,
RSTC,RSTM,RSTopmode,RSTB,RSCARRYIN,RSTD;
wire [35:0]M;
wire [47:0]P,Pcout;
wire carryout,carryoutf;
wire [17:0] BCOUT;
dsb dut (A,B,C,D,carryin,clk,opmode,BCIN,CEA,CEB,CEC,CECARRYIN,CED,CEM,
	CEOPMODE,CEP,RSTA,RSTB,RSTC,RSCARRYIN,RSTD,RSTM,RSTopmode,RSTP,BCOUT,
	PCIN,Pcout,M,P,carryout,carryoutf);
integer i=0;
initial begin
	clk=0;
	forever 
	#2 clk=~clk;
end
initial begin
RSTA=1;RSTB=1;RSTC=1;RSCARRYIN=1;RSTD=1;RSTM=1;RSTopmode=1;RSTP=1;PCIN=0;
for(i=0;i<10;i=i+1)begin
@(negedge clk);
	A=$random;B=$random;C=$random;D=$random;carryin=$random;opmode=$random;
	BCIN=$random;CEA=$random;CEB=$random;CEC=$random;CECARRYIN=$random;CED=$random;CEM=$random;
	CEOPMODE=$random;CEP=$random;
	#5;
end
RSTA=0;RSTB=0;RSTC=0;RSCARRYIN=0;RSTD=0;RSTM=0;RSTopmode=0;RSTP=0;CEA=0;CEB=0;CEC=0;
CECARRYIN=0;CED=0;CEM=0;CEOPMODE=0;CEP=0;
for(i=0;i<10;i=i+1)begin
@(negedge clk);
	A=$random;B=$random;C=$random;D=$random;carryin=$random;opmode=$random;
	BCIN=$random;
	#5;
end
@(negedge clk);
CEA=1;CEB=1;CEC=1;CECARRYIN=1;CED=1;CEM=1;CEOPMODE=1;CEP=1;
A=0;B=2;C=5;D=7;carryin=0;opmode=8'b00111101;BCIN=9;
for(i=0;i<10;i=i+1)begin
@(negedge clk);end
opmode=8'b00000011;carryin=1;
for(i=0;i<10;i=i+1)begin
@(negedge clk);end
opmode='b10011010;carryin=0;
for(i=0;i<10;i=i+1)begin
@(negedge clk);end
opmode='b10100101; PCIN =75;
for(i=0;i<10;i=i+1)begin
@(negedge clk);end
$stop;
end
endmodule

