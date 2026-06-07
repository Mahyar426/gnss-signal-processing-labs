% SatNavSys Lab5

% Clear workspace
clc,clear,close all;
% Load needed codes
load GalileoCodes.mat;
load GPS_Codes.mat;

%% Step 1
% Parameters - GPS
fs=16.368e6;
chip_rate=1.023e6;
IntermediateFreq=4.092e6;
SignalLength=1e-3;
N=length(generateLocalCode(Generated_Code(1,:), fs, chip_rate));
% GPS signal imported
p=N;
fileName='SignalRX_1.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick only one period
samplesToRead=N;
[rawData, cntData]=fread(fid, samplesToRead, 'double');
rawData=rawData';
fclose(fid);
% Search Space (SS) definition
Tcoh=N/fs;
Delta_f=2/(3*Tcoh);
DopplerBins=-5000:Delta_f:5000;
DelayBins=N;
Nc=1;
tic;
% Add for loop for iterating over differnt PRNs
for i=1:size(Generated_Code,1)
    Acquisition_Signal=Generated_Code(i,:);
    Acquisition_Signal=generateLocalCode(Acquisition_Signal, fs, chip_rate);
    % for loop over the rows to create all the needed ones
    for j=1:length(DopplerBins)
        % Local Carrier + Doppler creation
        carrierOut_Doppler=generateLocalIIF_Doppler(fs,IntermediateFreq,DopplerBins(j),SignalLength,Nc);
        % Local signal creation
        localSignal=Acquisition_Signal.*carrierOut_Doppler;
        CCCF_GPS(j,:)=ifft((fft(localSignal).*conj(fft(rawData))));
        % Normalize CCCF for current Doppler value wrt length
        CCCF_GPS(j,:)=CCCF_GPS(j,:)/p;
    end
    % CAF computation and plot
    CAF_GPS=abs(CCCF_GPS).^2;
    % Store maximum value and corresponing index
    [Max_FFT(i),Delay_Check(i)]=max(max(CAF_GPS));
end
toc;
% Plot final and correct CAF - REDO for [max,index]=max(Max_FFT) PRN
[maxPeak,index]=max(Max_FFT);
Acquisition_Signal=Generated_Code(index,:);
Acquisition_Signal=generateLocalCode(Acquisition_Signal, fs, chip_rate);
% for loop over the rows to create all the needed ones
for j=1:length(DopplerBins)
    % Local Carrier + Doppler creation
    carrierOut_Doppler=generateLocalIIF_Doppler(fs,IntermediateFreq,DopplerBins(j),SignalLength,Nc);
    % Local signal creation
    localSignal=Acquisition_Signal.*carrierOut_Doppler;
    CCCF_GPS(j,:)=ifft((fft(localSignal).*conj(fft(rawData))));
    % Normalize CCCF for current Doppler value wrt length
    CCCF_GPS(j,:)=CCCF_GPS(j,:)/p;
end
% CAF computation
CAF_GPS=abs(CCCF_GPS).^2;
x = 0:16367;
y = DopplerBins;
[X,Y] = meshgrid(x,y);
figure,surf(X,Y,CAF_GPS);
xlabel('Code Delay (samples)','Interpreter','latex');
ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('Cross-Ambiguity Function | GPS','Interpreter','latex');

% Parameters - GAL
fs=16.368e6;
chip_rate=1.023e6;
IntermediateFreq=4.092e6;
SignalLength=4e-3;
N=length(generateLocalCode(GalE1b(1,:), fs, chip_rate));
% GAL signal imported
p=N;
fileName='SignalRX_2.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick only one period
samplesToRead=N;
[rawData, cntData]=fread(fid, samplesToRead, 'double');
rawData=rawData';
fclose(fid);
% Search Space (SS) definition
Tcoh=N/fs;
Delta_f=2/(3*Tcoh);
DopplerBins=-5000:Delta_f:5000;
DelayBins=N;
Nc=1;
tic;
% Add for loop for iterating over differnt PRNs
for i=1:size(GalE1b,1)
    Acquisition_Signal=GalE1b(i,:);
    Acquisition_Signal=generateLocalCode(Acquisition_Signal, fs, chip_rate);
    % for loop over the rows to create all the needed ones
    for j=1:length(DopplerBins)
        % Local Carrier + Doppler creation
        carrierOut_Doppler=generateLocalIIF_Doppler(fs,IntermediateFreq,DopplerBins(j),SignalLength,Nc);
        % Local signal creation
        localSignal=Acquisition_Signal.*carrierOut_Doppler;
        CCCF_GAL(j,:)=ifft((fft(localSignal).*conj(fft(rawData))));
        % Normalize CCCF for current Doppler value wrt length
        CCCF_GAL(j,:)=CCCF_GAL(j,:)/p;
    end
    % CAF computation and plot
    CAF_GAL=abs(CCCF_GAL).^2;
    % Store maximum value and corresponing index
    [Max_FFT(i),Delay_Check(i)]=max(max(CAF_GAL));
end
toc;
% Plot final and correct CAF - REDO for [max,index]=max(Max_FFT) PRN
[maxPeak,index]=max(Max_FFT);
Acquisition_Signal=GalE1b(index,:);
Acquisition_Signal=generateLocalCode(Acquisition_Signal, fs, chip_rate);
% for loop over the rows to create all the needed ones
for j=1:length(DopplerBins)
    % Local Carrier + Doppler creation
    carrierOut_Doppler=generateLocalIIF_Doppler(fs,IntermediateFreq,DopplerBins(j),SignalLength,Nc);
    % Local signal creation
    localSignal=Acquisition_Signal.*carrierOut_Doppler;
    CCCF_GAL(j,:)=ifft((fft(localSignal).*conj(fft(rawData))));
    % Normalize CCCF for current Doppler value wrt length
    CCCF_GAL(j,:)=CCCF_GAL(j,:)/p;
end
% CAF computation
CAF_GAL=abs(CCCF_GAL).^2;
x = 0:65471;
y = DopplerBins;
[X,Y] = meshgrid(x,y);
figure,surf(X,Y,CAF_GAL);
xlabel('Code Delay (samples)','Interpreter','latex');
ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('Cross-Ambiguity Function | GAL','Interpreter','latex');
%% Step2 Task1
% Reading
fileName='SignalRX_3.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick only one period
samplesToRead=N;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'double');
rawDataNoise=rawDataNoise';
fclose(fid);
% Code to be checked
Sat_Index=[6,18,21];
% General Acquisition
for i=1:size(Generated_Code,1)
    CAF=AcquisitionFunctionGPS(rawDataNoise,i,1);
    [Max_FFT(i),Delay_Check(i)]=max(CAF,[],'all');
end
figure,stem(Max_FFT),grid on;
xlabel('PRN codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable PRNs into received signal','Interpreter','latex');
%% Characterizing CAFs
% Plot recognized PRNs
CAF=AcquisitionFunctionGPS(rawDataNoise,6,1);
x = 0:16367;
y = DopplerBins;
[X,Y] = meshgrid(x,y);
figure,surf(X,Y,CAF);
xlabel('Code Delay (samples)','Interpreter','latex');
ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('Cross-Ambiguity Function | PRN6','Interpreter','latex');
CAF=AcquisitionFunctionGPS(rawDataNoise,18,1);
x = 0:16367;
y = DopplerBins;
[X,Y] = meshgrid(x,y);
figure,surf(X,Y,CAF);
xlabel('Code Delay (samples)','Interpreter','latex');
ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('Cross-Ambiguity Function | PRN18','Interpreter','latex');
% Plot unrecognized PRN
CAF=AcquisitionFunctionGPS(rawDataNoise,21,1);
x = 0:16367;
y = DopplerBins;
[X,Y] = meshgrid(x,y);
figure,surf(X,Y,CAF);
xlabel('Code Delay (samples)','Interpreter','latex');
ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('Cross-Ambiguity Function | PRN21','Interpreter','latex');
%% Step 2 Task 2
% Non-coherent integration-------------------------------------------------
% Reading
fileName='SignalRX_3.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick only one period
samplesToRead=N;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'double');
rawDataNoise=rawDataNoise';
fclose(fid);
% We average over 5 CAFs
Nnc=5;
for i=1:size(Generated_Code,1)
    SumCAF=0;
    for j=1:Nnc
        CAF=AcquisitionFunctionGPS(rawDataNoise,i,Nc);
        SumCAF=SumCAF+CAF;
    end
    nc_CAF=SumCAF/Nnc;
    [Max_FFT(i),Delay_Check(i)]=max(nc_CAF,[],'all');
end
figure,stem(Max_FFT),grid on;
xlabel('PRN codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable PRNs into received signal','Interpreter','latex');
% Coherent integration-----------------------------------------------------
% Reading
fileName='SignalRX_3.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick 10 periods
Nc=10;
samplesToRead=N*Nc;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'double');
rawDataNoise=rawDataNoise';
fclose(fid);
for i=1:size(Generated_Code,1)
    CAF=AcquisitionFunctionGPS(rawDataNoise,i,Nc);
    [Max_FFT(i),Delay_Check(i)]=max(CAF,[],'all');
end
figure,stem(Max_FFT),grid on;
xlabel('PRN codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable PRNs into received signal','Interpreter','latex');
% Hybrid approach----------------------------------------------------------
% Reading
fileName='SignalRX_3.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick 10 periods
Nc=10;
samplesToRead=N*Nc;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'double');
rawDataNoise=rawDataNoise';
fclose(fid);
% We average over 5 CAFs
Nnc=5;
for i=1:size(Generated_Code,1)
    SumCAF=0;
    for j=1:Nnc
        CAF=AcquisitionFunctionGPS(rawDataNoise,i,Nc);
        SumCAF=SumCAF+CAF;
    end
    nc_CAF=SumCAF/Nnc;
    [Max_FFT(i),Delay_Check(i)]=max(nc_CAF,[],'all');
end
figure,stem(Max_FFT),grid on;
xlabel('PRN codes','Interpreter','latex');
ylabel('Peak Magnitude','Interpreter','latex');
title('Recognizable PRNs into received signal','Interpreter','latex');
%% CAF computation for successful Acquisition
Sat_Index=[6,18,21];
% Reading
fileName='SignalRX_3.bin';
[fid, message]=fopen(fileName, 'rb');
% We pick 10 periods
Nc=10;
samplesToRead=N*Nc;
[rawDataNoise, cntData]=fread(fid, samplesToRead, 'double');
rawDataNoise=rawDataNoise';
fclose(fid);
DopplerBins=-5000:66.6667:5000+66.6667;
for i=1:length(Sat_Index)
    CAF=AcquisitionFunctionGPS(rawDataNoise,Sat_Index(i),Nc);
    plot_length=size(nc_CAF,2)/Nc;
    x = 0:plot_length-1;
    y = DopplerBins;
    [X,Y] = meshgrid(x,y);
    %figure,surf(X,Y,CAF);
    figure,surf(X,Y,CAF(:,1:plot_length)),grid on;
    xlabel('Code Delay (samples)','Interpreter','latex');
    ylabel('Doppler Frequency (Hz)','Interpreter','latex');
end