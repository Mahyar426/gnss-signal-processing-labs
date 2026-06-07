%%% Function which handles a single iteration of the WLMS algorithm
%%% The parameter to be passed are expected to be already pre-processed,
%%% hence without any Nan or other misalignment in the dimensions

function [x_est]= Single_Iteration_WLMS(Sat_Pos,PRN,Init_x,Weights)
% Define H matrix
H=zeros(size(Sat_Pos,1),4);
H(:,end)=1;
rho_est=zeros(size(PRN));
% Fill H matrix
for i=1:size(H,1)
    r=sqrt((Sat_Pos(i,1)-Init_x(1))^2+(Sat_Pos(i,2)-Init_x(2))^2+(Sat_Pos(i,3)-Init_x(3))^2);
    rho_est(i)=r-Init_x(4);
    for j=1:size(H,2)-1
        a=(Sat_Pos(i,j)-Init_x(j))/r;
        H(i,j)=a;
    end
end
% State estimation
delta_rho=rho_est-PRN;
G=inv(H'*Weights*H);
delta_x=(G*H'*Weights)*delta_rho;
% Variable update for next iteration
x_est=Init_x+delta_x;
end