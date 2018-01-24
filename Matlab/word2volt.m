function [v1,v2] = word2volt(word)
%function volt = word2volt(word) calculates two voltages [v1, v2] given a
%3-byte word.

%D. Rudnick 01/06/05

i2m = floor(double(word(:,2))/16);
N1 = double(word(:,1))*16 + i2m;
N2 = (double(word(:,2)) - i2m*16)*256 + double(word(:,3));

v1 = 5 .* (1 - N1 ./ 4095);
v2 = 5 .* (1 - N2 ./ 4095);
