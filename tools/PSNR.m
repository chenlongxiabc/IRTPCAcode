function psnr = PSNR(Xfull,Xrecover,maxP)

Xrecover = max(0,Xrecover);
Xrecover = min(maxP,Xrecover);
[m,n,dim] = size(Xrecover);
MSE = norm(Xfull(:)-Xrecover(:))^2/(dim*m*n);
psnr = 10*log10(maxP^2/MSE);