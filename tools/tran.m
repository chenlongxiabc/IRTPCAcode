function Xt = tran(X)

% conjugate transpose of a 3 way tensor 
% X  - n1*n2*n3 tensor
% Xt - n2*n1*n3  tensor
% The function refered to the code in https://github.com/canyilu/LibADMM.

[n1,n2,n3] = size(X);
Xt = zeros(n2,n1,n3);
Xt(:,:,1) = X(:,:,1)';
if n3 > 1
    for i = 2 : n3
        Xt(:,:,i) = X(:,:,n3-i+2)';
    end
end