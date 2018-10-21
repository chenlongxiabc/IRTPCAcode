%%
% In our paper, there are some writing errors for RSEs in the group of experiments in
% synthetic data. I'm sorry for the errors. The RSEs are about 0.0066, 0.0216,
% 0.0642.
%%

clc; clear; close all;
Img = phantom('Modified Shepp-Logan',200);
maxP = max(abs(Img(:)));
figure(1); imshow(Img);
% set the number of images
N = 50;
NoiseImg = repmat(Img,1,1,N);
[n1, n2, n3] = size(NoiseImg);
% add sparse noise
rhos = 0.1;
ind = find(rand(n1*n2*n3,1)<rhos);
NoiseImg(ind) = rand(length(ind),1);
% initialization
n12 = min(n1,n2);
lambda1 = 1/sqrt(max(n12,n3));
lambda2 = 2/(sqrt(n3*max(n1,n2)));

mu = 0.2;
niter = 50;
tol = 5e-3;

S = zeros(size(NoiseImg));
L = zeros(size(NoiseImg));
Y = zeros(size(NoiseImg));

for it = 1:niter
    Lk = L;
    L = prox_tnn(NoiseImg - S + Y/mu, mu, lambda1);
    S = prox_l1(NoiseImg - L + Y/mu, lambda2/mu);
    Y = Y + mu * (NoiseImg - L - S);
    err = max(abs(L(:) - Lk(:)));
    
    if err < tol
        break;
    end
    
end

figure(2);
subplot(1,3,1);imshow(NoiseImg(:,:,2));
subplot(1,3,2);imshow(S(:,:,2));
subplot(1,3,3);imshow(L(:,:,2));
save([num2str(rhos) '_irtpca_phantom.mat'],'rhos','NoiseImg','L','S');