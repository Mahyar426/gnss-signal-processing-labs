% SatNavSys Lab2

% Clear workspace
clc,clear,close all;
% Add to path the folder for the data matrices
addpath("Data\data\single-epoch\");
% Add to path the folder for utility functions
addpath("Utilities\Utilities\");
% Load .mat files
load GAL_SAT_POS.mat;
load PSEUDORANGE.mat;

%% Single-Epoch
x_est=[0 0 0 0]';
k=0;
H=zeros(size(SAT_POS,1),4);
H(:,end)=1;
rho_est=zeros(size(RHO_));
% LMS algorithm recursion
while (k < 8)
    % H computation
    for i=1:size(H,1)
        r=sqrt((SAT_POS(i,1)-x_est(1))^2+(SAT_POS(i,2)-x_est(2))^2+(SAT_POS(i,3)-x_est(3))^2);
        rho_est(i)=r-x_est(4);
        for j=1:size(H,2)-1
            a=(SAT_POS(i,j)-x_est(j))/r;
            H(i,j)=a;
        end
    end
    % State estimation
    delta_rho=rho_est-RHO_;
    G=inv(H'*H);
    delta_x=(G*H')*delta_rho;
    % Variable update for next iteration
    x_est=x_est+delta_x;
    k=k+1;
end
% Check position on Google Earth with utility function
position=ecef2lla_noToolBox(x_est(1:3));
geoplot(position(1),position(2),'r-*');
title('State Estimation | Single Epoch','Interpreter','latex');