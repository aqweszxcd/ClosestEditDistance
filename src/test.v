`timescale 1ns / 1ps

module test(

);

reg clk;
reg rst;

always #5 begin
	clk=~clk;
end

initial begin
clk=0;
#10 rst=0;
#10 rst=1;
#10 rst=0;
end


////////////////////////////////rom////////////////////////////////
wire [31:0]addr_rom_0;
wire [1:0]data_o_0;
wire [31:0]addr_rom_1;
wire [1:0]data_o_1;
//data0.coe
blk_mem_gen_0 rom_0(
	.addra(addr_rom_0),
	.clka(clk),
	.douta(data_o_0)
);
// data1.coe
blk_mem_gen_1 rom_1(
	.addra(addr_rom_1),
	.clka(clk),
	.douta(data_o_1)
);

wire result_en;
wire [31:0]result_addr;
wire [31:0]result;
EditDistance EditDistance_0(
.addr_rom_0(addr_rom_0),
.data_o_0(data_o_0),

.addr_rom_1(addr_rom_1),
.data_o_1(data_o_1),

.clk(clk),
.rst(rst),

.result_en(result_en),
.result_addr(result_addr),
.result(result)
);


endmodule
