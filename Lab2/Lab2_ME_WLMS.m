% SatNavSys Lab2

% Clear workspace
clc,clear,close all;
% Add to path the folder for the data matrices
addpath("Data\data\RealisticUERE\");
% Load a dataset of choice
load dataset_1_20180329T160947.mat;

%% Multi-Epoch (Multi-Constellation)
AvailSat_GPS=0;
AvailSat_GLO=0;
AvailSat_BEI=0;
AvailSat_GAL=0;

for i=1:size(SAT_POS_ECEF.GPS,2)
    AvailSat_GPS=AvailSat_GPS+(~isempty(SAT_POS_ECEF.GPS(i).pos));
end
for i=1:size(SAT_POS_ECEF.GLO,2)
    AvailSat_GLO=AvailSat_GLO+(~isempty(SAT_POS_ECEF.GLO(i).pos));
end
for i=1:size(SAT_POS_ECEF.BEI,2)
    AvailSat_BEI=AvailSat_BEI+(~isempty(SAT_POS_ECEF.BEI(i).pos));
end
for i=1:size(SAT_POS_ECEF.GAL,2)
    AvailSat_GAL=AvailSat_GAL+(~isempty(SAT_POS_ECEF.GAL(i).pos));
end

IndexGPS=zeros(1,AvailSat_GPS);
IndexGLO=zeros(1,AvailSat_GLO);
IndexBEI=zeros(1,AvailSat_BEI);
IndexGAL=zeros(1,AvailSat_GAL);

cntGPS=1;
cntGLO=1;
cntBEI=1;
cntGAL=1;

for i=1:size(SAT_POS_ECEF.GPS,2)
    if(~isempty(SAT_POS_ECEF.GPS(i).pos))
        IndexGPS(cntGPS)=i; 
        cntGPS=cntGPS+1;
    end
end
for i=1:size(SAT_POS_ECEF.GLO,2)
    if(~isempty(SAT_POS_ECEF.GLO(i).pos))
        IndexGLO(cntGLO)=i;
        cntGLO=cntGLO+1;
    end
end
for i=1:size(SAT_POS_ECEF.BEI,2)
    if(~isempty(SAT_POS_ECEF.BEI(i).pos))
        IndexBEI(cntBEI)=i;
        cntBEI=cntBEI+1;
    end
end
for i=1:size(SAT_POS_ECEF.GAL,2)
    if(~isempty(SAT_POS_ECEF.GAL(i).pos))
        IndexGAL(cntGAL)=i;
        cntGAL=cntGAL+1;
    end
end

% Filling our array with the respective pseudoranges
Counter_nan_GPS=1;
Counter_nan_GLO=1;
Counter_nan_BEI=1;
Counter_nan_GAL=1;

RHO_GPS=zeros(AvailSat_GPS,size(RHO.GPS,2));
RHO_GLO=zeros(AvailSat_GLO,size(RHO.GLO,2));
RHO_BEI=zeros(AvailSat_BEI,size(RHO.BEI,2));
RHO_GAL=zeros(AvailSat_GAL,size(RHO.GAL,2));

for i=1:AvailSat_GPS
    RHO_GPS(i,:)=RHO.GPS(IndexGPS(i),:);
end
for i=1:AvailSat_GLO
    RHO_GLO(i,:)=RHO.GLO(IndexGLO(i),:);
end
for i=1:AvailSat_BEI
    RHO_BEI(i,:)=RHO.BEI(IndexBEI(i),:);
end
for i=1:AvailSat_GAL
    RHO_GAL(i,:)=RHO.GAL(IndexGAL(i),:);
end

RHO_GPS_REF=RHO_GPS(9,:);
RHO_GLO_REF=RHO_GLO(7,:);
RHO_BEI_REF=RHO_BEI(5,:);
RHO_GAL_REF=RHO_GAL(1,:);

for i=1:size(RHO_GPS,1)
        if ~isnan(RHO_GPS(i,1))
            Index_RHO_GPS_NotNan(Counter_nan_GPS)=i;
            Counter_nan_GPS=Counter_nan_GPS+1;
        end
end
for i=1:size(RHO_GLO,1)
        if ~isnan(RHO_GLO(i,1))
            Index_RHO_GLO_NotNan(Counter_nan_GLO)=i;
            Counter_nan_GLO=Counter_nan_GLO+1;
        end
end
for i=1:size(RHO_BEI,1)
        if ~isnan(RHO_BEI(i,1))
            Index_RHO_BEI_NotNan(Counter_nan_BEI)=i;
            Counter_nan_BEI=Counter_nan_BEI+1;
        end
end
for i=1:size(RHO_GAL,1)
        if ~isnan(RHO_GAL(i,1))
            Index_RHO_GAL_NotNan(Counter_nan_GAL)=i;
            Counter_nan_GAL=Counter_nan_GAL+1;
        end
end
Index_RHO_GPS_NotNan1=sum(~isnan(RHO_GPS),2);
Index_RHO_GLO_NotNan1=sum(~isnan(RHO_GLO),2);
Index_RHO_BEI_NotNan1=sum(~isnan(RHO_BEI),2);
Index_RHO_GAL_NotNan1=sum(~isnan(RHO_GAL),2);

for i=1:length(Index_RHO_GPS_NotNan)
    RHO_GPS_Without_NaN(i,:)=RHO_GPS(Index_RHO_GPS_NotNan(i),:);
end
for i=1:length(Index_RHO_GLO_NotNan)
    RHO_GLO_Without_NaN(i,:)=RHO_GLO(Index_RHO_GLO_NotNan(i),:);
end
for i=1:length(Index_RHO_BEI_NotNan)
    RHO_BEI_Without_NaN(i,:)=RHO_BEI(Index_RHO_BEI_NotNan(i),:);
end
for i=1:length(Index_RHO_GAL_NotNan)
    RHO_GAL_Without_NaN(i,:)=RHO_GAL(Index_RHO_GAL_NotNan(i),:);
end
%% Pseudorange trends
figure,plot(1:size(RHO_GPS_REF,2),RHO_GPS_REF),grid on;
xlim([0 3600]);
xlabel('epochs (s)','Interpreter','latex');
ylabel('(m)','Interpreter','latex');
title('$${\rho}$$','Interpreter','latex');
figure,plot(1:size(RHO_GPS_REF,2)-1,diff(RHO_GPS_REF,1)),grid on;
xlim([0 3600]);
xlabel('epochs (s)','Interpreter','latex');
ylabel('(m)','Interpreter','latex');
title('$$\frac{\partial{\rho}}{\partial{t}}$$','Interpreter','latex');
figure,stem(1:size(RHO_GPS_REF,2)-2,diff(RHO_GPS_REF,2)),grid on;
xlim([0 3600]);
xlabel('epochs (s)','Interpreter','latex');
ylabel('(m)','Interpreter','latex');
title('$$\frac{\partial^2{\rho}}{\partial{t}}$$','Interpreter','latex');
% figure;
% plot(1:size(RHO_GLO_REF,2),RHO_GLO_REF);
% figure;
% plot(1:size(RHO_GLO_REF,2)-1,diff(RHO_GLO_REF,1));
% figure;
% stem(1:size(RHO_GLO_REF,2)-2,diff(RHO_GLO_REF,2));
% figure;
% plot(1:size(RHO_BEI_REF,2),RHO_BEI_REF);
% figure;
% plot(1:size(RHO_BEI_REF,2)-1,diff(RHO_BEI_REF,1));
% figure;
% stem(1:size(RHO_BEI_REF,2)-2,diff(RHO_BEI_REF,2));
% figure;
% plot(1:size(RHO_GAL_REF,2),RHO_GAL_REF);
% figure;
% plot(1:size(RHO_GAL_REF,2)-1,diff(RHO_GAL_REF,1));
% figure;
% stem(1:size(RHO_GAL_REF,2)-2,diff(RHO_GAL_REF,2));
%% R and W matrices definition
% Correction of both RHO_[SAT_NAME] and SAT_POS_[SAT_NAME]_MAT by finding
% the interruption point over time, when a satellite either becomes
% unvavailable or its pseudoranges become corrupted
for i=1:length(IndexGPS)
    SAT_POS_GPS(i)=SAT_POS_ECEF.GPS(IndexGPS(i));
end
for i=1:length(IndexGLO)
    SAT_POS_GLO(i)=SAT_POS_ECEF.GLO(IndexGLO(i));
end
for i=1:length(IndexBEI)
    SAT_POS_BEI(i)=SAT_POS_ECEF.BEI(IndexBEI(i));
end
for i=1:length(IndexGAL)
    SAT_POS_GAL(i)=SAT_POS_ECEF.GAL(IndexGAL(i));
end
SAT_POS_GPS_MAT=nan(size(RHO_GPS,1),size(RHO_GPS,2),3);
SAT_POS_GLO_MAT=nan(size(RHO_GLO,1),size(RHO_GLO,2),3);
SAT_POS_BEI_MAT=nan(size(RHO_BEI,1),size(RHO_BEI,2),3);
SAT_POS_GAL_MAT=nan(size(RHO_GAL,1),size(RHO_GAL,2),3);

for i=1:length(SAT_POS_GPS)
    s=(SAT_POS_GPS(i).pos);
    for j=1:size(s,1)
        SAT_POS_GPS_MAT(i,j,:)=s(j,:);
    end
end

for i=1:length(SAT_POS_GLO)
    s=(SAT_POS_GLO(i).pos);
    for j=1:size(s,1)
        SAT_POS_GLO_MAT(i,j,:)=s(j,:);
    end
end

for i=1:length(SAT_POS_BEI)
    s=(SAT_POS_BEI(i).pos);
    for j=1:size(s,1)
        SAT_POS_BEI_MAT(i,j,:)=s(j,:);
    end
end

for i=1:length(SAT_POS_GAL)
    s=(SAT_POS_GAL(i).pos);
    for j=1:size(s,1)
        SAT_POS_GAL_MAT(i,j,:)=s(j,:);
    end
end
% at first we replace the zeros with nan, and then we chack in which epochs
% both rho and sat_pos are available
SAT_POS_GPS_MAT(SAT_POS_GPS_MAT==0)=nan;
SAT_POS_GLO_MAT(SAT_POS_GLO_MAT==0)=nan;
SAT_POS_BEI_MAT(SAT_POS_BEI_MAT==0)=nan;
SAT_POS_GAL_MAT(SAT_POS_GAL_MAT==0)=nan;

Non_NAN_GPS=sum(~isnan(SAT_POS_GPS_MAT(:,:,1)));
Non_NAN_GLO=sum(~isnan(SAT_POS_GLO_MAT(:,:,1)));
Non_NAN_BEI=sum(~isnan(SAT_POS_BEI_MAT(:,:,1)));
Non_NAN_GAL=sum(~isnan(SAT_POS_GAL_MAT(:,:,1)));

Index_SAT_POS_GPS_NotNan=sum(~isnan(SAT_POS_GPS_MAT(:,:,1)),2);
Index_SAT_POS_GLO_NotNan=sum(~isnan(SAT_POS_GLO_MAT(:,:,1)),2);
Index_SAT_POS_BEI_NotNan=sum(~isnan(SAT_POS_BEI_MAT(:,:,1)),2);
Index_SAT_POS_GAL_NotNan=sum(~isnan(SAT_POS_GAL_MAT(:,:,1)),2);

Available_SATS_prod_GPS=Index_SAT_POS_GPS_NotNan.*Index_RHO_GPS_NotNan1;
Available_SATS_prod_GLO=Index_SAT_POS_GLO_NotNan.*Index_RHO_GLO_NotNan1;
Available_SATS_prod_BEI=Index_SAT_POS_BEI_NotNan.*Index_RHO_BEI_NotNan1;
Available_SATS_prod_GAL=Index_SAT_POS_GAL_NotNan.*Index_RHO_GAL_NotNan1;

Avail_POS_RHO_GPS=find(Available_SATS_prod_GPS>0);
Avail_POS_RHO_GLO=find(Available_SATS_prod_GLO>0);
Avail_POS_RHO_BEI=find(Available_SATS_prod_BEI>0);
Avail_POS_RHO_GAL=find(Available_SATS_prod_GAL>0);

Counter_GPS=1;
Counter_GLO=1;
Counter_BEI=1;
Counter_GAL=1;

for i=1:length(Non_NAN_GPS)-1
    if(Non_NAN_GPS(i)~=Non_NAN_GPS(i+1))
        Breakpoint_GPS_POS(Counter_GPS)=i;
        Counter_GPS=Counter_GPS+1;
    end
end
for i=1:length(Non_NAN_GLO)-1
    if(Non_NAN_GLO(i)~=Non_NAN_GLO(i+1))
        Breakpoint_GLO_POS(Counter_GLO)=i;
        Counter_GLO=Counter_GLO+1;
    end
end
for i=1:length(Non_NAN_BEI)-1
    if(Non_NAN_BEI(i)~=Non_NAN_BEI(i+1))
        Breakpoint_BEI_POS(Counter_BEI)=i;
        Counter_BEI=Counter_BEI+1;
    end
end
for i=1:length(Non_NAN_GAL)-1
    if(Non_NAN_GAL(i)~=Non_NAN_GAL(i+1))
        Breakpoint_GAL_POS(Counter_GAL)=i;
        Counter_GAL=Counter_GAL+1;
    end
end
Std_RHO_GPS=std(diff(RHO_GPS_Without_NaN',2));
Std_RHO_GLO=std(diff(RHO_GLO_Without_NaN',2));
Std_RHO_BEI=std(diff(RHO_BEI_Without_NaN',2));
Std_RHO_GAL=std(diff(RHO_GAL_Without_NaN',2));

Cov_Mat_GPS=eye(length(Index_RHO_GPS_NotNan)).*Std_RHO_GPS;
Cov_Mat_GLO=eye(length(Index_RHO_GLO_NotNan)).*Std_RHO_GLO;
Cov_Mat_BEI=eye(length(Index_RHO_BEI_NotNan)).*Std_RHO_BEI;
Cov_Mat_GAL=eye(length(Index_RHO_GAL_NotNan)).*Std_RHO_GAL;

W_GPS=inv(Cov_Mat_GPS);
W_GLO=inv(Cov_Mat_GLO);
W_BEI=inv(Cov_Mat_BEI);
W_GAL=inv(Cov_Mat_GAL);

% From here we found out that we don't need breakpoints
RHO_GPS_Modified=RHO_GPS(Avail_POS_RHO_GPS',:);
RHO_GLO_Modified=RHO_GLO(Avail_POS_RHO_GLO',:);
RHO_BEI_Modified=RHO_BEI(Avail_POS_RHO_BEI',:);
RHO_GAL_Modified=RHO_GAL(Avail_POS_RHO_GAL',:);

SAT_POS_GPS_Modified=SAT_POS_GPS_MAT(Avail_POS_RHO_GPS',:,:);
SAT_POS_GLO_Modified=SAT_POS_GLO_MAT(Avail_POS_RHO_GLO',:,:);
SAT_POS_BEI_Modified=SAT_POS_BEI_MAT(Avail_POS_RHO_BEI',:,:);
SAT_POS_GAL_Modified=SAT_POS_GAL_MAT(Avail_POS_RHO_GAL',:,:);

x_est_GPS=zeros(size(RHO_GPS_Modified,2),4);
x_est_GLO=zeros(size(RHO_GLO_Modified,2),4);
x_est_BEI=zeros(size(RHO_BEI_Modified,2),4);
x_est_GAL=zeros(size(RHO_GAL_Modified,2),4);

for i=1:size(SAT_POS_GPS_Modified,2)
    k=0;
    while(k<8)
        x_est_GPS(i,:)=Single_Iteration_WLMS(squeeze(SAT_POS_GPS_Modified(:,i,:)),RHO_GPS_Modified(:,i),x_est_GPS(i,:)',W_GPS);
        k=k+1;
    end
end

for i=1:size(SAT_POS_GLO_Modified,2)
    k=0;
    while(k<8)
        x_est_GLO(i,:)=Single_Iteration_WLMS(squeeze(SAT_POS_GLO_Modified(:,i,:)),RHO_GLO_Modified(:,i),x_est_GLO(i,:)',W_GLO);
        k=k+1;
    end
end

for i=1:size(SAT_POS_BEI_Modified,2)
    k=0;
    while(k<8)
        x_est_BEI(i,:)=Single_Iteration_WLMS(squeeze(SAT_POS_BEI_Modified(:,i,:)),RHO_BEI_Modified(:,i),x_est_BEI(i,:)',W_BEI);
        k=k+1;
    end
end

for i=1:size(SAT_POS_GAL_Modified,2)
    k=0;
    while(k<8)
        x_est_GAL(i,:)=Single_Iteration_WLMS(squeeze(SAT_POS_GAL_Modified(:,i,:)),RHO_GAL_Modified(:,i),x_est_GAL(i,:)',W_GAL);
        k=k+1;
    end
end
%% Error computations and comparison
Average_Position_GPS=sum(x_est_GPS(:,1:3))/size(x_est_GPS,1);
Position_Error_GPS=x_est_GPS(:,1:3)-Average_Position_GPS;
Position_Error_STD_GPS=std(Position_Error_GPS);

Average_Position_GLO=sum(x_est_GLO(:,1:3))/size(x_est_GLO,1);
Position_Error_GLO=x_est_GLO(:,1:3)-Average_Position_GLO;
Position_Error_STD_GLO=std(Position_Error_GLO);

Average_Position_BEI=sum(x_est_BEI(:,1:3))/size(x_est_BEI,1);
Position_Error_BEI=x_est_BEI(:,1:3)-Average_Position_BEI;
Position_Error_STD_BEI=std(Position_Error_BEI);

Average_Position_GAL=sum(x_est_GAL(:,1:3))/size(x_est_GAL,1);
Position_Error_GAL=x_est_GAL(:,1:3)-Average_Position_GAL;
Position_Error_STD_GAL=std(Position_Error_GAL);
%%
xplot=1:12;
yplot=[Position_Error_STD_GPS,Position_Error_STD_GLO,Position_Error_STD_BEI,Position_Error_STD_GAL];
colors='grbk';
figure;
xtlbls={'xGPS','yGPS','zGPS','xGLO','yGLO','zGLO','xBEI','yBEI','zBEI','xGAL','yGAL','zGAL'};
for i=1:4
stem(xplot(3*i-2:3*i),yplot(3*i-2:3*i),'Color',colors(i));hold on
end
title('$\sigma$ of Position Error | Multi-Constellation','Interpreter','latex');
ylabel('Meters','Interpreter','latex');
legend('GPS','GLO','BEI','GAL')
xticks(xplot);
xticklabels(xtlbls);
hAxes.TickLabelInterpreter = 'latex';
grid on
axis('padded');
%% Plotting: Convert this figure to a geoplot
figure;
position_GPS=ecef2lla_noToolBox(Average_Position_GPS(1:3));
geoplot(position_GPS(1),position_GPS(2),'g-*');
hold on
position_GLO=ecef2lla_noToolBox(Average_Position_GLO(1:3));
geoplot(position_GLO(1),position_GLO(2),'r-*');
hold on
position_BEI=ecef2lla_noToolBox(Average_Position_BEI(1:3));
geoplot(position_BEI(1),position_BEI(2),'b-*');
hold on
position_GAL=ecef2lla_noToolBox(Average_Position_GAL(1:3));
geoplot(position_GAL(1),position_GAL(2),'k-*');
legend('GPS','GLO','BEI','GAL')
title('State Estimation | Multi Epoch','Interpreter','latex');