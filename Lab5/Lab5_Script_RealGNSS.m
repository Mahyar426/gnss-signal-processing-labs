% SatNavSys Lab5 - Real GNSS signals

% Clear workspace
clc,clear,close all;
% Load needed codes
load GalileoCodes.mat;
load GPS_Codes.mat;
fs=16.368e6;
chip_rate=1.023e6;
IntermediateFreq=4.092e6;
%% Step 3
% Reading
fileName='lab_a_01122023.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick one period for starters
N=length(generateLocalCode(Generated_Code(1,:), fs, chip_rate));
Nc=1;
samplesToRead=N*Nc;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'int8');
rawDataNoise=rawDataNoise';
fclose(fid);
% Do basic acquisition with both GPS-GAL
for i=1:size(Generated_Code,1)
    CAF=AcquisitionFunctionGPS(rawDataNoise,i,1);
    [Max_FFT_GPS(i),Delay_Check(i)]=max(CAF,[],'all');
end
figure,stem(Max_FFT_GPS),grid on;
xlabel('PRN codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable PRNs into received signal','Interpreter','latex');
% Reading
fileName='SignalRX_3.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick one period for starters
N=length(generateLocalCode(GalE1b(1,:), fs, chip_rate));
Nc=1;
samplesToRead=N*Nc;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'int8');
rawDataNoise=rawDataNoise';
fclose(fid);
for i=1:size(GalE1b,1)
    CAF=AcquisitionFunctionGAL(rawDataNoise,GalE1b(i,:),1);
    [Max_FFT_GAL(i),Delay_Check(i)]=max(CAF,[],'all');
end
figure,stem(Max_FFT_GAL),grid on;
xlabel('Codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable Codes into received signal','Interpreter','latex');
%% Try with coherent approach-----------------------------------------------
% Reading
fileName='lab_a_01122023.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick one period for starters
N=length(generateLocalCode(Generated_Code(1,:), fs, chip_rate));
Nc=3;
samplesToRead=N*Nc;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'int8');
rawDataNoise=rawDataNoise';
fclose(fid);
% Do basic acquisition with both GPS-GAL
for i=1:size(Generated_Code,1)
    CAF=AcquisitionFunctionGPS(rawDataNoise,i,Nc);
    [Max_FFT_GPS(i),Delay_Check(i)]=max(CAF,[],'all');
end
figure,stem(Max_FFT_GPS),grid on;
xlabel('PRN codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable PRNs into received signal','Interpreter','latex');
% Reading
fileName='SignalRX_3.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick one period for starters
N=length(generateLocalCode(GalE1b(1,:), fs, chip_rate));
Nc=3;
samplesToRead=N*Nc;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'int8');
rawDataNoise=rawDataNoise';
fclose(fid);
for i=1:size(GalE1b,1)
    CAF=AcquisitionFunctionGAL(rawDataNoise,GalE1b(i,:),Nc);
    [Max_FFT_GAL(i),Delay_Check(i)]=max(CAF,[],'all');
end
figure,stem(Max_FFT_GAL),grid on;
xlabel('Codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable Codes into received signal','Interpreter','latex');