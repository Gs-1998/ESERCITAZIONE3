function [y,X_buf,W_buf,H]=CM_filterbank_frame(h,M,x,X_buf,W_buf,H,G)
 N=length(h); 
 lx=length(x); 
 

for n=1:lx
   
  xn=repmat(x(n),M,1);  
  
  X_buf = [xn  X_buf(:,1:N-1)];
   
  Hx = sum(H.*X_buf,2); % Analysis filter bank outputs
  
  if mod(n-1,M)==0
     Wm=Hx; % Downsampling
    else   
     Wm=zeros(M,1); % Upsampling
   end
   
   W_buf = [Wm  W_buf(:,1:N-1)];
   Gw = sum(G.*W_buf,2); % Synthesis filter bank outputs
   y(n) = sum(Gw);
end
