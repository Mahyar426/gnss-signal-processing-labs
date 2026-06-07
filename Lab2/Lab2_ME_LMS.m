% SatNavSys Lab2

% Clear workspace
clc,clear,close all;
% Add to path the folder for the data matrices
addpath("Data\data\NominalUERE\");
% Load a dataset of choice
load dataset_1_20180328T122038.mat;

%% Multi-Epoch (Multi-Constellation)
AvailSat_GPS=0;
AvailSat_GLO=0;
AvailSat_BEI=0;
AvailSat_GAL=0;
% Counting the number of non-empty entries of each fields' structure
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
% Finding the indexes of the valid satellites (LoS condition)
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
% Filling array with the respective pseudoranges
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
% Check for Nan in pseudoranges
Non_NAN_GPS=zeros(1,size(RHO_GPS,2));
Non_NAN_GLO=zeros(1,size(RHO_GLO,2));
Non_NAN_BEI=zeros(1,size(RHO_BEI,2));
Non_NAN_GAL=zeros(1,size(RHO_GAL,2));
for i=1:size(RHO_GPS,2)
    Non_NAN_GPS(1,i)=sum(~isnan(RHO_GPS(:,i)));
end
for i=1:size(RHO_GLO,2)
    Non_NAN_GLO(1,i)=sum(~isnan(RHO_GLO(:,i)));
end
for i=1:size(RHO_BEI,2)
    Non_NAN_BEI(1,i)=sum(~isnan(RHO_BEI(:,i)));
end
for i=1:size(RHO_GAL,2)
    Non_NAN_GAL(1,i)=sum(~isnan(RHO_GAL(:,i)));
end
%% Plot respective pseudoranges and number of satellites over time
% GPS
title('GPS constellation','Interpreter','latex');
for i = 1:size(RHO_GPS,1)
    subplot(2,1,1);
    plot(1:size(RHO_GPS,2),RHO_GPS(i,:),'-.','LineWidth',2,'DisplayName',['Sat #' num2str(i)]);
    hold on;
end
hold off;
xlim([0 size(RHO_GPS,2)]);
xlabel('Epochs','Interpreter','latex');
title('GPS - Pseudoranges','Interpreter','latex');
%legend();
subplot(2,1,2);
plot(1:size(RHO_GPS,2),Non_NAN_GPS,'-.','LineWidth',2);
xlim([0 size(RHO_GPS,2)]);
xlabel('Epochs','Interpreter','latex');
title('GPS - Number of satellites','Interpreter','latex');
% GLO
figure;
title('GLO constellation','Interpreter','latex');
for i = 1:size(RHO_GLO,1)
    subplot(2,1,1);
    plot(1:size(RHO_GLO,2),RHO_GLO(i,:),'-.','LineWidth',2,'DisplayName',['Sat #' num2str(i)]);
    hold on;
end
hold off;
xlim([0 size(RHO_GLO,2)]);
xlabel('Epochs','Interpreter','latex');
title('GLO - Pseudoranges','Interpreter','latex');
%legend();
subplot(2,1,2);
plot(1:size(RHO_GLO,2),Non_NAN_GLO,'-.','LineWidth',2);
xlim([0 size(RHO_GLO,2)]);
xlabel('Epochs','Interpreter','latex');
title('GLO - Number of satellites','Interpreter','latex');
% BEI
figure;
title('BEI constellation','Interpreter','latex');
for i = 1:size(RHO_BEI,1)
    subplot(2,1,1);
    plot(1:size(RHO_BEI,2),RHO_BEI(i,:),'-.','LineWidth',2,'DisplayName',['Sat #' num2str(i)]);
    hold on;
end
hold off;
xlim([0 size(RHO_BEI,2)]);
xlabel('Epochs','Interpreter','latex');
title('BEI - Pseudoranges','Interpreter','latex');
%legend();
subplot(2,1,2);
plot(1:size(RHO_BEI,2),Non_NAN_BEI,'-.','LineWidth',2);
xlim([0 size(RHO_BEI,2)]);
xlabel('Epochs','Interpreter','latex');
title('BEI - Number of satellites','Interpreter','latex');
% GAL
figure;
title('GAL constellation','Interpreter','latex');
for i = 1:size(RHO_GAL,1)
    subplot(2,1,1);
    plot(1:size(RHO_GAL,2),RHO_GAL(i,:),'-.','LineWidth',2,'DisplayName',['Sat #' num2str(i)]);
    hold on;
end
hold off;
xlim([0 size(RHO_GAL,2)]);
xlabel('Epochs','Interpreter','latex');
title('GAL - Pseudoranges','Interpreter','latex');
%legend();
subplot(2,1,2);
plot(1:size(RHO_GAL,2),Non_NAN_GAL,'-.','LineWidth',2);
xlim([0 size(RHO_GAL,2)]);
xlabel('Epochs','Interpreter','latex');
title('GAL - Number of satellites','Interpreter','latex');
% Extract satellites position
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
% Create a Tensor with dimension (x,y,z) = (satNum,epochs,satPos)
% and replacing zeros with Nans
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
SAT_POS_GPS_MAT(SAT_POS_GPS_MAT==0)=nan;
for i=1:length(SAT_POS_GLO)
    s=(SAT_POS_GLO(i).pos);
    for j=1:size(s,1)
        SAT_POS_GLO_MAT(i,j,:)=s(j,:);
    end
end
SAT_POS_GLO_MAT(SAT_POS_GLO_MAT==0)=nan;
for i=1:length(SAT_POS_BEI)
    s=(SAT_POS_BEI(i).pos);
    for j=1:size(s,1)
        SAT_POS_BEI_MAT(i,j,:)=s(j,:);
    end
end
SAT_POS_BEI_MAT(SAT_POS_BEI_MAT==0)=nan;
for i=1:length(SAT_POS_GAL)
    s=(SAT_POS_GAL(i).pos);
    for j=1:size(s,1)
        SAT_POS_GAL_MAT(i,j,:)=s(j,:);
    end
end
SAT_POS_GAL_MAT(SAT_POS_GAL_MAT==0)=nan;
% Correction of both RHO_[SAT_NAME] and SAT_POS_[SAT_NAME]_MAT by finding
% the interruption point over time, when a satellite either becomes
% unvavailable or its pseudoranges become corrupted
Counter_GPS=1;
for i=1:length(Non_NAN_GPS)-1
    if(Non_NAN_GPS(i)~=Non_NAN_GPS(i+1))
        Breakpoint_GPS(Counter_GPS)=i;
        Counter_GPS=Counter_GPS+1;
    end
end
Counter_GLO=1;
for i=1:length(Non_NAN_GLO)-1
    if(Non_NAN_GLO(i)~=Non_NAN_GLO(i+1))
        Breakpoint_GLO(Counter_GLO)=i;
        Counter_GLO=Counter_GLO+1;
    end
end
Counter_BEI=1;
for i=1:length(Non_NAN_BEI)-1
    if(Non_NAN_BEI(i)~=Non_NAN_BEI(i+1))
        Breakpoint_BEI(Counter_BEI)=i;
        Counter_BEI=Counter_BEI+1;
    end
end
Counter_GAL=1;
for i=1:length(Non_NAN_GAL)-1
    if(Non_NAN_GAL(i)~=Non_NAN_GAL(i+1))
        Breakpoint_GAL(Counter_GAL)=i;
        Counter_GAL=Counter_GAL+1;
    end
end
%% Sub-optimal solution:
%  Creating as many matrices as the continuity regions, to be able to pass
%  to our LMS function consistent matrices
%%% IMPROVEMENTS: One matrix which changes over time (adding/replacing) %%%
SAT_POS_GPS_MAT_1 = SAT_POS_GPS_MAT(1:5,1:Breakpoint_GPS(1),:);
SAT_POS_GPS_MAT_2 = SAT_POS_GPS_MAT([1,3:5],(Breakpoint_GPS(1)+1):Breakpoint_GPS(2),:);
SAT_POS_GPS_MAT_3 = SAT_POS_GPS_MAT([1,3:6],Breakpoint_GPS(2)+1:Breakpoint_GPS(3),:);
SAT_POS_GPS_MAT_4 = SAT_POS_GPS_MAT([1,3:7],Breakpoint_GPS(3)+1:size(SAT_POS_GPS_MAT,2),:);
RHO_GPS_1 = RHO_GPS(1:5,1:Breakpoint_GPS(1));
RHO_GPS_2 = RHO_GPS([1,3:5],(Breakpoint_GPS(1)+1):Breakpoint_GPS(2));
RHO_GPS_3 = RHO_GPS([1,3:6],Breakpoint_GPS(2)+1:Breakpoint_GPS(3));
RHO_GPS_4 = RHO_GPS([1,3:7],Breakpoint_GPS(3)+1:end);

SAT_POS_GLO_MAT_1 = SAT_POS_GLO_MAT(:,1:Breakpoint_GLO(1),:);
SAT_POS_GLO_MAT_2 = SAT_POS_GLO_MAT([1:5,7],(Breakpoint_GLO(1)+1):end,:);
RHO_GLO_1 = RHO_GLO(:,1:Breakpoint_GLO(1),:);
RHO_GLO_2 = RHO_GLO([1:5,7],(Breakpoint_GLO(1)+1):end,:);


SAT_POS_BEI_MAT_1 = SAT_POS_BEI_MAT(:,1:Breakpoint_BEI(1),:);
SAT_POS_BEI_MAT_2 = SAT_POS_BEI_MAT([1:2,4:7],(Breakpoint_BEI(1)+1):Breakpoint_BEI(2),:);
SAT_POS_BEI_MAT_3 = SAT_POS_BEI_MAT([1:2,4:6],Breakpoint_BEI(2)+1:end,:);
RHO_BEI_1 = RHO_BEI(:,1:Breakpoint_BEI(1));
RHO_BEI_2 = RHO_BEI([1:2,4:7],(Breakpoint_BEI(1)+1):Breakpoint_BEI(2),:);
RHO_BEI_3 = RHO_BEI([1:2,4:6],Breakpoint_BEI(2)+1:end,:);

SAT_POS_GAL_MAT_1 = SAT_POS_GAL_MAT(:,1:Breakpoint_GAL(1),:);
SAT_POS_GAL_MAT_2 = SAT_POS_GAL_MAT([1:2,4:7],(Breakpoint_GAL(1)+1):end,:);
RHO_GAL_1 = RHO_GAL(:,1:Breakpoint_GAL(1),:);
RHO_GAL_2 = RHO_GAL([1:2,4:7],(Breakpoint_GAL(1)+1):end,:);

% Initializing Estimations
x_est_GPS=zeros(size(RHO_GPS,2),4);
x_est_GLO=zeros(size(RHO_GLO,2),4);
x_est_BEI=zeros(size(RHO_BEI,2),4);
x_est_GAL=zeros(size(RHO_GAL,2),4);

% Running the LMS algorithm for k=8 iterations, with specific matrices
% GPS
for i=1:size(SAT_POS_GPS_MAT,2)
    if(i<292)
        k=0;
        while(k<8)
            x_est_GPS(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GPS_MAT_1(:,i,:)),RHO_GPS_1(:,i),x_est_GPS(i,:)');
            k=k+1;
        end
    end
    if(i>=292 && i<985)
        k=0;
        while(k<8)
            x_est_GPS(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GPS_MAT_2(:,i-Breakpoint_GPS(1),:)),RHO_GPS_2(:,i-Breakpoint_GPS(1)),x_est_GPS(i,:)');
            k=k+1;
        end
    end
    if(i>=985 && i<3054)
        k=0;
        while(k<8)
            x_est_GPS(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GPS_MAT_3(:,i-Breakpoint_GPS(2),:)),RHO_GPS_3(:,i-Breakpoint_GPS(2)),x_est_GPS(i,:)');
            k=k+1;
        end
    end
    if(i>=3054)
        k=0;
        while(k<8)
            x_est_GPS(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GPS_MAT_4(:,i-Breakpoint_GPS(3),:)),RHO_GPS_4(:,i-Breakpoint_GPS(3)),x_est_GPS(i,:)');
            k=k+1;
        end
    end
end
% GLO
for i=1:size(SAT_POS_GLO_MAT,2)
    if(i<2194)
        k=0;
        while(k<8)
            x_est_GLO(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GLO_MAT_1(:,i,:)),RHO_GLO_1(:,i),x_est_GLO(i,:)');
            k=k+1;
        end
    end
    if(i>=2194)
        k=0;
        while(k<8)
            x_est_GLO(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GLO_MAT_2(:,i-Breakpoint_GLO(1),:)),RHO_GLO_2(:,i-Breakpoint_GLO(1)),x_est_GLO(i,:)');
            k=k+1;
        end
    end
end
% BEI
for i=1:size(SAT_POS_BEI_MAT,2)
    if(i<791)
        k=0;
        while(k<8)
            x_est_BEI(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_BEI_MAT_1(:,i,:)),RHO_BEI_1(:,i),x_est_BEI(i,:)');
            k=k+1;
        end
    end
    if(i>=791 && i<3304)
        k=0;
        while(k<8)
            x_est_BEI(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_BEI_MAT_2(:,i-Breakpoint_BEI(1),:)),RHO_BEI_2(:,i-Breakpoint_BEI(1)),x_est_BEI(i,:)');
            k=k+1;
        end
    end
    if(i>=3304)
        k=0;
        while(k<8)
            x_est_BEI(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_BEI_MAT_3(:,i-Breakpoint_BEI(2),:)),RHO_BEI_3(:,i-Breakpoint_BEI(2)),x_est_BEI(i,:)');
            k=k+1;
        end
    end
end
% GAL
for i=1:size(SAT_POS_GAL_MAT,2)
    if(i<3220)
        k=0;
        while(k<8)
            x_est_GAL(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GAL_MAT_1(:,i,:)),RHO_GAL_1(:,i),x_est_GAL(i,:)');
            k=k+1;
        end
    end
    if(i>=3220)
        k=0;
        while(k<8)
            x_est_GAL(i,:)=Single_Iteration_LMS(squeeze(SAT_POS_GAL_MAT_2(:,i-Breakpoint_GAL(1),:)),RHO_GAL_2(:,i-Breakpoint_GAL(1)),x_est_GAL(i,:)');
            k=k+1;
        end
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
