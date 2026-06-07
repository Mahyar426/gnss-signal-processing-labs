% SatNavSys Lab4

% Clear workspace
clc,clear,close all;
% Load needed codes
load codeReceived.mat;
load GalileoCodes.mat;
load GPS_Codes.mat;

%% Step 1: Generation of GNSS carrier
% GPS
fs=16.368e6;
chip_rate=1.023e6;
IntermediateFreq=4.092e6;
codeIn_GPS=Generated_Code(1,:);
codeOut_GPS = generateLocalCode(codeIn_GPS, fs, chip_rate);
% GAL
f_BOC=1e6;
codeIn_GAL=GalE1b(1,:);
codeOut_GAL = generateLocalCode(codeIn_GAL, fs, chip_rate);
Signal_GAL=modulate(codeOut_GAL,f_BOC,fs,'am');
SignalLength=1e-3;
carrierOut=generateLocalIIF(fs,IntermediateFreq,SignalLength);
%% Step 2: Signals in time and frequency
% Time - Domain GPS
figure;
plot(real(carrierOut(1:80)));
xlabel('[n]','Interpreter','latex');
%ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Real Part of Complex Carrier | Time Domain','Interpreter','latex');
figure;
stem(codeOut_GPS(1:800));
xlabel('[n]','Interpreter','latex');
%ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('GPS PRN1 Spreading Sequence | Time Domain','Interpreter','latex');
Down_CodeOut=carrierOut.*codeOut_GPS;
figure;
stem(real(Down_CodeOut(1:80)));
xlabel('[n]','Interpreter','latex');
%ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Product Between Code and IF Carrier | Time Domain','Interpreter','latex');
% Frequency - Domain GPS
N=length(carrierOut);
Nwel=ceil(N/10);            % Length of the window
h=ones(1,Nwel);             % Rectangular window to pre-filter
Noverlap=ceil(Nwel/2);      % Number of overlapping samples
Nfft=4096;                  % Number of FFT points per window
Fs=fs;             % Optimal sampling rate
[Px,f]=pwelch(real(carrierOut),h,Noverlap,Nfft,Fs,'centered');
figure,plot(f,Px),axis('tight'),grid on;
xlabel('Frequency [Hz]','Interpreter','latex');
%ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Real Part of Complex Carrier | Frequency Domain','Interpreter','latex');
N=length(codeOut_GPS);
Nwel=ceil(N/10);            % Length of the window
h=ones(1,Nwel);             % Rectangular window to pre-filter
Noverlap=ceil(Nwel/2);      % Number of overlapping samples
Nfft=4096;                  % Number of FFT points per window
Fs=fs;             % Optimal sampling rate
[Px,f]=pwelch(real(codeOut_GPS),h,Noverlap,Nfft,Fs,'centered');
figure,plot((f./1e+07).*10,pow2db(Px)),axis('tight'),grid on;
xlabel('Frequency [MHz]','Interpreter','latex');
%ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('GPS PRN1 Spreading Sequence | Frequency Domain','Interpreter','latex');
N=length(Down_CodeOut);
Nwel=ceil(N/10);            % Length of the window
h=ones(1,Nwel);             % Rectangular window to pre-filter
Noverlap=ceil(Nwel/2);      % Number of overlapping samples
Nfft=4096;                  % Number of FFT points per window
Fs=fs;             % Optimal sampling rate
[Px,f]=pwelch(real(Down_CodeOut),h,Noverlap,Nfft,Fs,'centered');
figure,plot((f./1e+07).*10,pow2db(Px)),axis('tight'),grid on;
xlabel('Frequency [MHz]','Interpreter','latex');
%ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Product Between Code and IF Carrier | Frequency Domain','Interpreter','latex');
xline(4.092,'LineWidth',1.5,'LineStyle','--','Color',[0.8500 0.3250 0.0980]);
xline(-4.092,'LineWidth',1.5,'LineStyle','--','Color',[0.8500 0.3250 0.0980]);
%% Step 3: Correlations
LocalSeq=generateLocalCode(Generated_Code(1,:), fs, chip_rate);
p=length(LocalSeq);
% Circular-based CCCF
for i=1:p
    CCCF_GPS(i)=sum(LocalSeq.*codeReceived);
    LocalSeq=circshift(LocalSeq,1);
end
CCCF_GPS=CCCF_GPS/p;
symmInterval=round(p/2-1);
tau=-symmInterval:1:symmInterval+1;
CCCF_GPS=circshift(CCCF_GPS,symmInterval);
figure,plot(tau,CCCF_GPS),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xy}(\tau)$','Interpreter','latex');
title('Normalized Circular Cross-Correlation | GPS','Interpreter','latex');
% FFT-based CCCF
LocalSeq=generateLocalCode(Generated_Code(1,:), fs, chip_rate);
R=ifft((fft(LocalSeq).*conj(fft(codeReceived))));
R_shifted=fftshift(R);
R_shifted=R_shifted/p;
bounded_int=round(p/2-1);
tau=-bounded_int:1:bounded_int+1;
figure,plot(tau,flip(R_shifted)),axis('padded'),grid on;
axx=xlabel('$\tau$');
axy=ylabel('$R(\tau)$');
set(axx,'Interpreter','Latex');
set(axy,'Interpreter','Latex');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xy}(\tau)$','Interpreter','latex');
title('Normalized FFT-Based Cross-Correlation | GPS','Interpreter','latex');
% Step 3 Task 2
for i=1:size(Generated_Code,1)
    CodeOut(i,:)=generateLocalCode(Generated_Code(i,:), fs, chip_rate);
end
Index_Revealed_CCF=0;
i=1;
tic;
while((i<33) && (Index_Revealed_CCF==0))
    LocalSeq=CodeOut(i,:);
    for j=1:p
        CCCF_GPS(i,j)=sum(LocalSeq.*codeReceived);
        LocalSeq=circshift(LocalSeq,-1);
    end
    [Max_CCCF,Delay_Check]=max(CCCF_GPS(i,:));
    if (Max_CCCF/p)>0.99
        Index_Revealed_CCF=i;
        Delay_CCF=Delay_Check;
        break;
    end
    i=i+1;
end
toc;
Index_Revealed_FFT=0;
i=1;
tic;
while((i<33))
    LocalSeq=CodeOut(i,:);
    R=ifft((fft(LocalSeq).*conj(fft(codeReceived))));
    R=R/p;
    [Max_FFT,Delay_Check]=max(R);
    if Max_FFT>0.99
        Index_Revealed_FFT=i;
        Delay_FFT=Delay_Check;
        break;
    end
    i=i+1;
end
toc;
%% Step 4: Serial Acquisition
fileName='SignalRX_1.bin';
[fid, message]=fopen(fileName, 'rb');
N=length(generateLocalCode(Generated_Code(1,:), fs, chip_rate));
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
tic;
% Add for loop for iterating over differnt PRNs
for i=1:size(Generated_Code,1)
    Acquisition_Signal=Generated_Code(i,:);
    Acquisition_Signal=generateLocalCode(Acquisition_Signal, fs, chip_rate);
    % for loop over the rows to create all the needed ones
    for j=1:length(DopplerBins)
        % Local Carrier + Doppler creation
        carrierOut_Doppler=generateLocalIIF_Doppler(fs,IntermediateFreq,DopplerBins(j),SignalLength);
        % Local signal creation
        localSignal=Acquisition_Signal.*carrierOut_Doppler;
        for k=1:length(localSignal)
            % CCCF computation
            CCCF_GPS(j,k)=sum(localSignal.*rawData);
            localSignal=circshift(localSignal,-1);
        end
        % Normalize CCCF for current Doppler value wrt length
        CCCF_GPS(j,:)=CCCF_GPS(j,:)/p;
    end
    % CAF computation
    CAF_GPS=abs(CCCF_GPS).^2;
    % Store maximum value and corresponing index
    [Max_FFT(i),Delay_Check(i)]=max(max(CAF_GPS));
end
toc;
[max,index]=max(Max_FFT);
%% CAF computation and plot for correct PRN
Acquisition_Signal=Generated_Code(index,:);
Acquisition_Signal=generateLocalCode(Acquisition_Signal, fs, chip_rate);
% for loop over the rows to create all the needed ones
for j=1:length(DopplerBins)
    % Local Carrier + Doppler creation
    carrierOut_Doppler=generateLocalIIF_Doppler(fs,IntermediateFreq,DopplerBins(j),SignalLength);
    % Local signal creation
    localSignal=Acquisition_Signal.*carrierOut_Doppler;
    for k=1:length(localSignal)
        % CCCF computation
        CCCF_GPS(j,k)=sum(localSignal.*rawData);
        localSignal=circshift(localSignal,-1);
    end
    % Normalize CCCF for current Doppler value wrt length
    CCCF_GPS(j,:)=CCCF_GPS(j,:)/p;
end
% CAF computation
CAF_GPS=abs(CCCF_GPS).^2;
% Plot
x = 0:16367;
y = DopplerBins;
[X,Y] = meshgrid(x,y);
figure,surf(X,Y,CAF_GPS);
xlabel('Code Delay (samples)','Interpreter','latex');
ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('Cross-Ambiguity Function | GPS','Interpreter','latex');
%% 1D CAF Plots
figure,plot(CAF_GPS(11,:))
xlabel('Code Delay (samples)','Interpreter','latex');
%ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('1D CAF | GPS','Interpreter','latex');
grid on
figure,plot(CAF_GPS(:,6548))
xlabel('Doppler Frequency (Hz)','Interpreter','latex');
%ylabel('Doppler Frequency (Hz)','Interpreter','latex');
title('1D CAF | GPS','Interpreter','latex');
grid on