clear
clc
%initial module
WIDTH=2;
ADDRESS_RADIX='UNS';
DATA_RADIX='UNS';
ALTERA=1;%title of altera (for learning use only)

%input module
data_in=fopen('data_in_0.txt','r');  %打开文本文件
% ATGG AGAC AGTA TCAC
% TAAT AACT ATAC TAGT
% AGTA GCAA CAGT AAGC
% AATG CAGA TAAG ATCT
% GCAT CG total 70
% AGCT  65  71  67  84
% AGCT	0   1   2   3
data = fread(data_in);
data1 = data;
%挑选，赋值，赋值为负进行保护
for i1=1:length(data1)
    if(data(i1)==65)
        data(i1)=-1;%0
    end
    if(data(i1)==71)
        data(i1)=-2;%1
    end
    if(data(i1)==67)
        data(i1)=-3;%2
    end
    if(data(i1)==84)
        data(i1)=-4;%3
    end
end
fclose(data_in);
%删除数组中的非0123
Locate=find(data>=0);
data(Locate)=[];
%反转
for i2=1:length(data)
    if(data(i2)==-1)
        data(i2)=0;%0
    end
    if(data(i2)==-2)
        data(i2)=1;%1
    end
    if(data(i2)==-3)
        data(i2)=2;%2
    end
    if(data(i2)==-4)
        data(i2)=3;%3
    end
end

%output module
number=(0:length(data)-1);
for i=1:length(data)
number(i)=i-1;
end
fasta_value=(0:length(data)-1);
for i=1:length(data)
fasta_value(i)=data(i);
end
comer=(0:length(data)-1);
for i=1:length(data)
comer(i)=':';
end
semi=(0:length(data)-1);
for i=1:length(data)
semi(i)=';';
end
fid=fopen('data_0.mif','w');
if ALTERA
fprintf(fid, '-- Copyright (C) 2018  Intel Corporation. All rights reserved.\n');
fprintf(fid, '-- Your use of Intel Corporation''s design tools, logic functions \n');
fprintf(fid, '-- and other software and tools, and its AMPP partner logic \n');
fprintf(fid, '-- functions, and any output files from any of the foregoing \n');
fprintf(fid, '-- (including device programming or simulation files), and any \n');
fprintf(fid, '-- associated documentation or information are expressly subject \n');
fprintf(fid, '-- to the terms and conditions of the Intel Program License \n');
fprintf(fid, '-- Subscription Agreement, the Intel Quartus Prime License Agreement,\n');
fprintf(fid, '-- the Intel FPGA IP License Agreement, or other applicable license\n');
fprintf(fid, '-- agreement, including, without limitation, that your use is for\n');
fprintf(fid, '-- the sole purpose of programming logic devices manufactured by\n');
fprintf(fid, '-- Intel and sold by Intel or its authorized distributors.  Please\n');
fprintf(fid, '-- refer to the applicable agreement for further details.\n');
fprintf(fid, '\n');
fprintf(fid, '-- Quartus Prime generated Memory Initialization File (.mif)\n');
fprintf(fid, '\n');
end
DEPTH=length(data);
fprintf(fid, (['WIDTH=' num2str(WIDTH) ';\n']));
fprintf(fid, (['DEPTH=' num2str(DEPTH) ';\n']));
fprintf(fid, '\n');
fprintf(fid, (['ADDRESS_RADIX=' ADDRESS_RADIX ';\n']));
fprintf(fid, (['DATA_RADIX=' DATA_RADIX ';\n']));
fprintf(fid, '\n');
fprintf(fid, 'CONTENT BEGIN\n');
data=[number;comer;fasta_value;semi];
fprintf(fid, '\t%d  %c   %d%c\n', data);
fprintf(fid, 'END;\n');
fclose(fid);

fid = fopen('data_0.coe', 'w'); %创建COE文件
fprintf(fid, 'memory_initialization_radix=16;\n');
fprintf(fid, 'memory_initialization_vector=\n');
%output module
for i=1:length(data)
    fprintf(fid, '%01X,\n',fasta_value(i));
end
fseek(fid, -2, 1); % 将最后一个逗号用分号覆盖
fprintf(fid, ';');

fclose(fid); %关闭文件
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
%initial module
WIDTH=2;
ADDRESS_RADIX='UNS';
DATA_RADIX='UNS';
ALTERA=1;%title of altera (for learning use only)

%input module
data_in=fopen('data_in_1.txt','r');  %打开文本文件
% ATGG AGAC AGTA TCAC
% TAAT AACT ATAC TAGT
% AGTA GCAA CAGT AAGC
% AATG CAGA TAAG ATCT
% GCAT CG total 70
% AGCT  65  71  67  84
% AGCT	0   1   2   3
data = fread(data_in);
data1 = data;
%挑选，赋值，赋值为负进行保护
for i1=1:length(data1)
    if(data(i1)==65)
        data(i1)=-1;%0
    end
    if(data(i1)==71)
        data(i1)=-2;%1
    end
    if(data(i1)==67)
        data(i1)=-3;%2
    end
    if(data(i1)==84)
        data(i1)=-4;%3
    end
end
fclose(data_in);
%删除数组中的非0123
Locate=find(data>=0);
data(Locate)=[];
%反转
for i2=1:length(data)
    if(data(i2)==-1)
        data(i2)=0;%0
    end
    if(data(i2)==-2)
        data(i2)=1;%1
    end
    if(data(i2)==-3)
        data(i2)=2;%2
    end
    if(data(i2)==-4)
        data(i2)=3;%3
    end
end

%output module
number=(0:length(data)-1);
for i=1:length(data)
number(i)=i-1;
end
fasta_value=(0:length(data)-1);
for i=1:length(data)
fasta_value(i)=data(i);
end
comer=(0:length(data)-1);
for i=1:length(data)
comer(i)=':';
end
semi=(0:length(data)-1);
for i=1:length(data)
semi(i)=';';
end
fid=fopen('data_1.mif','w');
if ALTERA
fprintf(fid, '-- Copyright (C) 2018  Intel Corporation. All rights reserved.\n');
fprintf(fid, '-- Your use of Intel Corporation''s design tools, logic functions \n');
fprintf(fid, '-- and other software and tools, and its AMPP partner logic \n');
fprintf(fid, '-- functions, and any output files from any of the foregoing \n');
fprintf(fid, '-- (including device programming or simulation files), and any \n');
fprintf(fid, '-- associated documentation or information are expressly subject \n');
fprintf(fid, '-- to the terms and conditions of the Intel Program License \n');
fprintf(fid, '-- Subscription Agreement, the Intel Quartus Prime License Agreement,\n');
fprintf(fid, '-- the Intel FPGA IP License Agreement, or other applicable license\n');
fprintf(fid, '-- agreement, including, without limitation, that your use is for\n');
fprintf(fid, '-- the sole purpose of programming logic devices manufactured by\n');
fprintf(fid, '-- Intel and sold by Intel or its authorized distributors.  Please\n');
fprintf(fid, '-- refer to the applicable agreement for further details.\n');
fprintf(fid, '\n');
fprintf(fid, '-- Quartus Prime generated Memory Initialization File (.mif)\n');
fprintf(fid, '\n');
end
DEPTH=length(data);
fprintf(fid, (['WIDTH=' num2str(WIDTH) ';\n']));
fprintf(fid, (['DEPTH=' num2str(DEPTH) ';\n']));
fprintf(fid, '\n');
fprintf(fid, (['ADDRESS_RADIX=' ADDRESS_RADIX ';\n']));
fprintf(fid, (['DATA_RADIX=' DATA_RADIX ';\n']));
fprintf(fid, '\n');
fprintf(fid, 'CONTENT BEGIN\n');
data=[number;comer;fasta_value;semi];
fprintf(fid, '\t%d  %c   %d%c\n', data);
fprintf(fid, 'END;\n');
fclose(fid);

fid = fopen('data_1.coe', 'w'); %创建COE文件
fprintf(fid, 'memory_initialization_radix=16;\n');
fprintf(fid, 'memory_initialization_vector=\n');
%output module
for i=1:length(data)
    fprintf(fid, '%01X,\n',fasta_value(i));
end
fseek(fid, -2, 1); % 将最后一个逗号用分号覆盖
fprintf(fid, ';');

fclose(fid); %关闭文件