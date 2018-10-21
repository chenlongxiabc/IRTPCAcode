clc; clear; close all;
load('Hall.mat');
% load('Advertisement.mat')
D = im2double(Data);
% initialization
mu = 0.06;
tol = 6e-3;
[n1, n2, n3] = size(D);
n12 = min(n1,n2);
lambda1 = 1/sqrt(max(n12,n3));
lambda2 = 1/sqrt(n3*max(n1,n2));

L = zeros(size(D));
S = zeros(size(D));
Y = zeros(size(D));
err = zeros(size(D));

niter = 10;
figure(1),imshow3(D(:,:,1:40),[],[4,10]);

for it = 1:niter
    % update L
    L = prox_tnn(D - S + Y/mu, mu, lambda1);
    lambda1 = 1.2*lambda1;
    mu = 0.6*mu; 
    % show background
    figure(2),imshow3(L(:,:,1:40),[],[4,10]),titlef(it);
    drawnow
    % update S
    S = prox_l1(D - L + Y/mu, lambda2/mu);
    % update Y
    Y = Y + mu * (D - L - S);
    
    if(it ~= 1 && norm(L(:)- err(:))/norm(err(:)) < tol)
        break;
    end
    
    err = L;
end