
clear, clf
M=8; 
N=64;

[h,passedge] = opt_filter(N-1,M); %progetto del filtro prototipo
scrivi_dat('prototipoMC.dat',h);

delay=N-2; 

L=2*44100; % lunghezza del segnale di ingresso
Frame=128; % Frame del segnale

X_buf=zeros(M,N); %inizializzazione dei vettori di appoggio per le linee di ritardo
W_buf=zeros(M,N);

N=length(h); 

H = mod_cosh(h,N,M); % funzioni per la modulazione coseno
G = mod_cosp(h,N,M);

% x=rand(1,L)-0.5; % definizione del segnale di ingresso
% audiowrite('input.wav',x,48000);
x=audioread('input.wav').';

for i=0:1:floor(L/Frame)-1

    [y(1,1+Frame*i:Frame*(i+1)),X_buf,W_buf,H]=CM_filterbank_frame(h,...
        M,x(1,1+Frame*i:Frame*(i+1)),X_buf,W_buf,H,G); % Cosine-modlated filter bank

end
y=y*M; % solo nel caso del prototipo 2

subplot(411), nn=0:N-1; stem(nn,h,'k.')
subplot(412), f=[-1:0.001:1]; W=pi*f;
plot(f,abs(DTFT(h,W,0)),'k'), hold on
gss=['k:';'b:';'r:';'m:';'k.';'b.';'r.';'m.'];
for m=1:M,  plot(f,abs(DTFT(H(m,:),W,0)),gss(m,:));  end
axis([-1 1 0 1.5]), set(gca,'XTick',-1:1/M:1)
legend('H(f)','H_0(f)','H_1(f)','H_2(f)','H_3(f)')
subplot(413), %nn=0:L-1; stem(nn,x)
%hold on, stem(nn-delay,y(delay+1:end),'rx')
plot(x); hold on;plot(y(delay:end),'r')
legend('Input to the CMFB','Output from the CMFB'), shg