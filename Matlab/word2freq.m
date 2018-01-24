function freq = word2freq(word)
%function freq = word2freq(word) takes an NX3 array of unsigned characters
%and turns them into an N-vector of frequencies.
%

%D. Rudnick 01/06/05

freq=double(word(:,1))*256+double(word(:,2))+double(word(:,3))/256;
