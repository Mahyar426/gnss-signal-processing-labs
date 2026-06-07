% SatNavSys Lab6

% Clear workspace
clc,clear,close all;
% Load needed codes
load GalileoCodes.mat;
load GPS_Codes.mat;

%% Step1
% Building the codes
Local_GPS=Generated_Code(1,:);
Local_GAL=GalE1b(1,:);
FilterFlag=1;
if FilterFlag==1
    wn=1/2;
    order=4;
    [Bf,Af]=butter(order,wn,'low');
    Filtered_Local_GPS=filter(Bf,Af,Local_GPS);
end
Delta=1;
fs=16.368e6;
chip_rate=1.023e6;
Ratio=fs/chip_rate*Delta/2; 
Received_Code_GPS = generateLocalCode(Local_GPS, fs, chip_rate);
Prompt_GPS=Received_Code_GPS;
Late_GPS=circshift(Received_Code_GPS,-Ratio);
Early_GPS=circshift(Received_Code_GPS,Ratio);
Reflected_Ray=0.4*circshift(Received_Code_GPS,-fs/chip_rate*0.25);
FlagMultipath=1; % If multipath is present just change the flag to 1.
Received_Signal=FlagMultipath*Reflected_Ray+Received_Code_GPS;
% Plot Correlations
p=length(Prompt_GPS);
R_Early=ifft((fft(Received_Signal).*conj(fft(Early_GPS))));
R_Early=fftshift(R_Early);
R_Early=R_Early/p;
R_Late=ifft((fft(Received_Signal).*conj(fft(Late_GPS))));
R_Late=fftshift(R_Late);
R_Late=R_Late/p;
R_Prompt=ifft((fft(Received_Signal).*conj(fft(Received_Code_GPS))));
R_Prompt=fftshift(R_Prompt);
R_Prompt=R_Prompt/p;
Discriminator=R_Early-R_Late;
plot_area=p/2-Ratio*Ratio:p/2+Ratio*Ratio;
figure,plot(R_Early(plot_area),'-.g');
hold on
plot(R_Prompt(plot_area),'-.b');
plot(R_Late(plot_area),'-.r');
hold off
grid on
%% Step2: Building Discriminators
S1=Discriminator;
S2=((R_Early-R_Late)./(R_Early+R_Late))*0.5;
S3=((R_Early.^2-R_Late.^2)./(R_Early.^2+R_Late.^2))*0.5;
figure,plot(S1(plot_area),'-.k'),grid on;
figure,plot(S2(plot_area),'-.k'),grid on;
figure,plot(S3(plot_area),'-.k'),grid on;