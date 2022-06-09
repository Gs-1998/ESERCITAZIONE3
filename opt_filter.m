function [hopt,passedge] = opt_filter(N,nbands)
%  This function creates an "optimal" lowpass prototype filter for
%  a pseudo-QMF filter bank with nbands bands of length N.
%
stopedge = 1/nbands;
delta = 0.001;
passedge = 1/(4*nbands);
toll = 0.000001;
step = 0.1 * passedge;
tcost = 0;
mpc = 1;
way = -1;
pcost = 10;
flag = 0;
% s_time = cputime;
% s_flops = flops;
%
while flag == 0
   
    hopt = remez(N,[0,passedge,stopedge,1],[1,1,0,0],[5,1]);
    
%     n=1:N;
%     h1=sinc((n-((N+1)/2))*passedge)*(passedge);
%     w=kaiser(N,11.0);
%     hopt=h1.*w';
   
   H = fft(hopt,4096);
   HH = ovlp_ripple(H,nbands);
   [tcost] = max(abs(HH - ones(max(size(HH)),1)));
   if tcost > pcost
      step = step/2;
      way = -way;
   end
   if abs(pcost - tcost) < toll
      flag = 1;
   end
   pcost = tcost;
   passedge = passedge + way*step;
end
% final_time = cputime - s_time;
% total_flops = flops - s_flops;
% save hopt.mat hopt-ascii;
% save pass passedge -ascii;