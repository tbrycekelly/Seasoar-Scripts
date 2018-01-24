function y=blocks(x,n)
%y=blocks(x,n) calculates the n-point block mean of x.
%If x is a matrix the block mean of each column is calculated.
%The length of y will be fix(length(x)/n).
%

nrow=size(x,1);
num=fix(nrow/n);
nums=(1:num);
nn=num*n;
i=zeros(1,nn);
for k=1:n
   i(k:n:nn)=nums;
end
j=(1:nn);
A=sparse(i,j,ones(1,nn)/n,num,nrow);
y=A*x;
