clc; clear; close all;
% read images
fpath = sprintf('%s/*.jpg', 'images');
flist = dir(fpath);
images = [];
for imindex = 1:min(length(flist), 50)
    fname = sprintf('%s/%s', 'images',flist(imindex).name);
    im = imread(fname);
    images{length(images)+1} = im;
end
% process images one by one
for i = 1:length(images)
    Img = im2double(images{1,i});
    maxP = max(abs(Img(:)));
    figure(1); imshow(Img);
    
    [n1, n2, n3] = size(Img);
    NoiseImg = Img;
    rhos = 0.1;
    ind = find(rand(n1*n2*n3,1)<rhos);
    NoiseImg(ind) = rand(length(ind),1);
    n12 = min(n1,n2);
    % initialization
    lambda1 = 1/sqrt(max(n12,n3));
    lambda2 = 3/(sqrt(n3*max(n1,n2)));
    
    mu = 0.5;
    niter = 20;
    psnr=0;
    tol = 1e-2;
    
    S = zeros(size(NoiseImg));
    L = zeros(size(NoiseImg));
    Y = zeros(size(NoiseImg));


    for it = 1:niter
        Lk = L;
        L = prox_tnn(NoiseImg - S + Y/mu, mu, lambda1);
        figure(2); imshow(L);drawnow;
        % update S
        S = prox_l1(NoiseImg - L + Y/mu,lambda2/mu);
        Y = Y + mu * (NoiseImg- L - S);
        psnr = PSNR(Img,L,maxP);
        err = max(abs(L(:) - Lk(:)));
        
        if err < tol 
            break;
        end
        
    end
    psnr
    figure(3);
    subplot(1,3,1);imshow(Img);
    subplot(1,3,2);imshow(NoiseImg);
    subplot(1,3,3);imshow(L);
    pause(5);
end

