`timescale 1ns / 1ps

//addr [(`addr-1):0]
`define addr 32
//data [(`data_width-1):0]
`define data_width 2

// 0-15
//Intermediate variables [3:0] 中间变量 //Guaranteed not to overflow 保证不溢出
//`define IV 3
//`define level 8
// 0-31
//Intermediate variables [4:0] 中间变量 //Guaranteed not to overflow 保证不溢出
`define IV 4
`define level 16

module EditDistance(
output reg [(`addr-1):0]addr_rom_0,
input wire [(`data_width-1):0]data_o_0,

output reg [(`addr-1):0]addr_rom_1,
input wire [(`data_width-1):0]data_o_1,

input wire clk,
input wire rst,

output reg result_en,
output reg [(`addr-1):0]result_addr,
output reg [(`addr-1):0]result
);

////////////////////////////////function////////////////////////////////
function [`IV:0]distance;
input wire [`IV:0] a;
input wire [`IV:0] b;
input wire [`IV:0] c;
input wire [(`data_width-1):0] x;
input wire [(`data_width-1):0] y;
reg [`IV:0] a1;
reg [`IV:0] b1;
reg [`IV:0] c1;
begin
    a1=a+1;
    b1=(x==y)?b:(b+2);
    c1=c+1;
    distance=
    (((a1<=b1)&&(a1<=c1))?(a1):(32'd0))|
    (((b1<=c1)&&(b1<=a1))?(b1):(32'd0))|
    (((c1<=a1)&&(c1<=b1))?(c1):(32'd0));
end
endfunction

////////////////////////////////declare////////////////////////////////
//for structure //have no meaning
int a,b,c;
genvar d,e,f;
reg [(`addr-1):0] state;

//rom delay
reg [(`addr-1):0] delay_addr_0,addr_rom_o_0;//long one
reg read_en_0,delay_en_0,read_en_o_0;//rom0
always@(posedge clk)begin
    delay_en_0<=read_en_0;   delay_addr_0<=addr_rom_0;
    read_en_o_0<=delay_en_0; addr_rom_o_0<=delay_addr_0;
end
reg [(`addr-1):0] delay_addr_1,addr_rom_o_1;//short one
reg read_en_1,delay_en_1,read_en_o_1;//rom1
always@(posedge clk)begin
    delay_en_1<=read_en_1;   delay_addr_1<=addr_rom_1;
    read_en_o_1<=delay_en_1; addr_rom_o_1<=delay_addr_1;
end
reg [(`addr-1):0] size_0=32'h668,size_1=32'h3a8;//const

//rom delay 2
reg delay2_en_0[0:(3*`level)];//result en
always@(posedge clk)begin
if ( rst ) begin
    delay2_en_0[0]<=0;
    for ( a=0 ; a<(3*`level); a=a+1) delay2_en_0[a+1]<=0;
end else begin
    delay2_en_0[0]<=read_en_0;
    for ( a=0 ; a<(3*`level); a=a+1) delay2_en_0[a+1]<=delay2_en_0[a];
    result_en<=delay2_en_0[3*`level]; 
end
end
reg [(`addr-1):0] delay2_addr_0[0:(2*`level+1)];//result addr
always@(posedge clk)begin
if ( rst ) begin
    delay2_addr_0[0]<=0;
    for ( a=0 ; a<(2*`level+1); a=a+1) delay2_addr_0[a+1]<=0;
end else begin
    delay2_addr_0[0]<=addr_rom_0;
    for ( a=0 ; a<(2*`level+1); a=a+1) delay2_addr_0[a+1]<=delay2_addr_0[a];
    result_addr<=delay2_addr_0[2*`level+1]; 
end
end

//data core
reg [(`data_width-1):0] fixed_data[0:(`level-1)];
always @(posedge clk) begin
if ( read_en_o_1 ) begin//write fixed data
    fixed_data[addr_rom_o_1]<=data_o_1;
end
end

reg [(`data_width-1):0] pipe_data[0:(`level-1)][0:(`level-1)];
always @(posedge clk) begin
if ( read_en_o_0 ) begin
    for ( a=0 ; a<(`level-1); a=a+1) begin
        pipe_data[a][a]<=pipe_data[a+1][a+1];
    end
    pipe_data[`level-1][`level-1]<=data_o_0;
end
    for ( b=0 ; b<(`level-1); b=b+1) begin
        for ( a=0 ; a<(b+1); a=a+1) begin
            pipe_data[b+1][a]<=pipe_data[b+1][a+1];
        end
    end
end

//compute core
reg [4:0] compute_matrix[0:`level][0:`level];
assign compute_matrix[0][0]=0;//boundary
for ( d=0 ; d<(`level); d=d+1) begin
    assign compute_matrix[d+1][0]=d+1;
    assign compute_matrix[0][d+1]=d+1;
end
always@(posedge clk)begin
    for ( b=1 ; b<(`level+1); b=b+1) begin
        for ( a=1 ; a<(`level+1); a=a+1) begin
            compute_matrix[b][a]<=distance(
                compute_matrix[b][a-1],compute_matrix[b-1][a-1],compute_matrix[b-1][a],
                pipe_data[b-1][0],fixed_data[a-1]
                );
        end
    end
end

//output result
always@(posedge clk)begin
    result<=compute_matrix[`level][`level];
end

////////////////////////////////step by step////////////////////////////////
//rst
always @(posedge clk)begin

if (rst) begin
    state<=0;

    result_en<=0;
    result_addr<=0;
end

//clear data
else if (state==0) begin
	/*for (b = 0; b<8; b=b+1) begin
		for (a = 0; a<8; a=a+1) begin
			pipe_data_en[b][a]<=0;
		end
	end*/
	state<=state+1;//next
    read_en_0<=0;
    addr_rom_0<=0;
    read_en_1<=0;
    addr_rom_1<=0;
end

//get fixed data
else if (state==1) begin//read fixed data from rom 1
    state<=state+1;//next
    read_en_0<=0;
    addr_rom_0<=0;
    read_en_1<=1;//read 1 en
    addr_rom_1<=0;
end
else if (state==2) begin//read fixed data from rom 1
	if ( addr_rom_1<(`level-1) ) begin
        state<=state;
        read_en_0<=0;
        addr_rom_0<=0;
        read_en_1<=1;//read 1 en
        addr_rom_1<=addr_rom_1+1;//read addr
    end else
    begin
    state<=state+1;//next
    read_en_0<=0;
    addr_rom_0<=0;
    read_en_1<=0;
    addr_rom_1<=0;
    end
end

//get pipe data
else if (state==3) begin//read pipe data from rom 0
    state<=state+1;//next
    read_en_0<=1;//read 0 en
    addr_rom_0<=0;
    read_en_1<=0;
    addr_rom_1<=0;
end
else if (state==4) begin//read pipe data from rom 0
	if ( addr_rom_0<(size_0-1) ) begin
        state<=state;
        read_en_0<=1;
        addr_rom_0<=addr_rom_0+1;
        read_en_1<=0;//read 1 en
        addr_rom_1<=0;//read addr
    end else
    begin
    state<=state+1;//next
    read_en_0<=0;
    addr_rom_0<=0;
    read_en_1<=0;
    addr_rom_1<=0;
    end
end

end





endmodule
