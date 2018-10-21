function [X] = prox_tnn(Y, mu,lambda1)
    % process improved tensor nuclear norm
    [n1,n2,n3] = size(Y);
    n12 = min(n1,n2);
    % get core matrix
    [U, S, V] = tsvd(Y);
    reshapeS = zeros(n12, n3);
    for i = 1:n12
        reshapeS(i,:) = S(i,i,:);
    end
  
    [A,D,B] = svd(reshapeS, 'econ');
    VT=B';
    D = diag(D);
    ind = find(D > lambda1);
    D = diag(D(ind) - lambda1);
    L = A(:,ind) * D * VT(ind,:);
    T = zeros(n12,n12,n3);
    for i = 1:n12
        T(i,i,:) = L(i,:);
    end
    T = tprod(tprod(U,T), tran(V));
    
    Y2 = fft(T,[],3);
    U = zeros(n1,n12,n3);
    V = zeros(n2,n12,n3);
    S = zeros(n12,n12,n3);
    trank = 0;
    for i = 1 : n3
        [U(:,:,i),s,V(:,:,i)] = svd(Y2(:,:,i),'econ');
        s = diag(s);
        s = max(s-2/mu,0);    
        S(:,:,i) = diag(s);
        tranki = length(find(s~=0));
        trank = max(tranki,trank);
    end
    U = U(:,1:trank,:);
    V = V(:,1:trank,:);
    S = S(1:trank,1:trank,:);

    U = ifft(U,[],3);
    S = ifft(S,[],3);
    V = ifft(V,[],3);
    X = tprod(tprod(U,S), tran(V));
end

