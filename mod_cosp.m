function [pout]=mod_cosp(p,N,M)
% questa funzione effettua la modulazione coseno per generare il banco di
% sintesi.
cos_matr=zeros(M,N);
for m=1:M
    for n=1:N
        cos_matr(m,n)=2*cos((pi/(M))*((m-1)+0.5)*((n-1)-((N-1)/2))-((-1)^(m-1))*(pi/4));
    end
end
for k=1:M
pout(k,:)=p.*cos_matr(k,:);
end
