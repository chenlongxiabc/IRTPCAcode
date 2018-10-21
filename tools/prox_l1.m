function x = prox_l1(b,lambda)

% The proximal operator of the l1 norm
% The function refered to the code in https://github.com/canyilu/LibADMM.

x = max(0,b-lambda)+min(0,b+lambda);