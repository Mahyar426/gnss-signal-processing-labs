% SatNavSys Lab3

% CLear workspace
clc,clear,close all;

%% Step 1: Generation of GPS codes
m=10;
p=2^m-1;
C1=ones(1,m)*(-1);
C2=ones(1,m)*(-1);
Counter=1;
C_A_Code=zeros(1,p);
while (Counter<=p)
    % C1 Code
    Bit_3_C1=C1(3);
    Bit_10_C1=C1(10);
    Feed_Bit_C1=Bit_3_C1*Bit_10_C1;
    % C2 Code
    Bit_2_C2=C2(2);
    Bit_3_C2=C2(3);
    Bit_6_C2=C2(6);
    Bit_8_C2=C2(8);
    Bit_9_C2=C2(9);
    Bit_10_C2=C2(10);
    Feed_Bit_C2=Bit_2_C2*Bit_3_C2*Bit_6_C2*Bit_8_C2*Bit_9_C2*Bit_10_C2;
    % C/A Code
    C_A_Code(Counter)=Bit_2_C2*Bit_6_C2*Bit_10_C1;
    % Shifting operations
    C1=circshift(C1,1);
    C2=circshift(C2,1);
    % Placing feedback bits before new loop
    C1(1)=Feed_Bit_C1;
    C2(1)=Feed_Bit_C2;
    Counter=Counter+1;
end
% This function is working properly
Func_Code=PRN_Generator(1);
GeneratedCodeCheck=isequal(Func_Code,C_A_Code);
% Octal check on GPS 32 codes, based on: https://www.gps.gov/technical/icwg
for i=1:32
    Generated_Code(i,:)=PRN_Generator(i);
end
Octals=[1440;1620;1710;1744;1133;1455;1131;1454;1626;1504;1642;1750;1764;1772;1775;1776;1156;1467;1633;1715;1746;1763;1063;1706;1743;1761;1770;1774;1127;1453;1625;1712];
for i=1:32
    Binaries(i,:)=oct2poly(Octals(i));
end
Binaries=Binaries*(-2)+1;
OctalCheck=isequal(Binaries,Generated_Code(:,1:10));
Expected_Number_of_Ones=(2^(m-1));
Expected_Number_of_Zeros=(2^(m-1))-1;
Number_of_ones=sum(Generated_Code<0,2);
Number_of_zeros=sum(Generated_Code>0,2);
%% Step 2: GPS Codes Properties
% Linear Auto Correlation implementation
Selected_Code=Generated_Code(1,:);
LCF_GPS=zeros(1,p);
Copy_Selected=zeros(1,p);
Copy_Selected(1,1)=Selected_Code(1,end);
for i=1:2*p-1
    if i<=p-1
        S=Copy_Selected.*Selected_Code;
        LCF_GPS(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=Selected_Code(1,p-i);
    else
        S=Copy_Selected.*Selected_Code;
        LCF_GPS(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=0;
    end
end
% Normalized wrt code length
LCF_GPS=LCF_GPS/p;
% Plot
symmInterval=round((2*p-1)/2-1);
tau=-symmInterval:1:symmInterval;
figure,plot(tau,LCF_GPS),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Normalized Linear Auto-Correlation | GPS','Interpreter','latex');
legend('PRN1 code','Interpreter','latex');
% Circular Auto Correlation implementation
Beta=(2^(floor((m+2)/2)))+1;
Expected_CCF_Values=[1,-1/p,(-1*Beta)/p,(Beta-2)/p];
Copy_Selected=Selected_Code;
for i=1:p
         CCF_GPS(i)=sum(Copy_Selected.*Selected_Code);
         Copy_Selected=circshift(Copy_Selected,1);
end
% Normalized wrt code length
CCF_GPS=CCF_GPS/p;
% Plot
symmInterval=round(p/2-1);
tau=-symmInterval:1:symmInterval;
CCF_GPS=circshift(CCF_GPS,symmInterval);
figure,plot(tau,CCF_GPS),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Normalized Circular Auto-Correlation | GPS','Interpreter','latex');
legend('PRN1 code','Interpreter','latex');
% Step 2.3: cross-correlations
Selected_Code_1=Generated_Code(1,:);
Selected_Code_2=Generated_Code(2,:);
LCCF_GPS=zeros(1,p);
Copy_Selected=zeros(1,p);
Copy_Selected(1,1)=Selected_Code_2(1,end);
for i=1:2*p-1
    if i<=p-1
        S=Copy_Selected.*Selected_Code_1;
        LCCF_GPS(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=Selected_Code_1(1,p-i);
    else
        S=Copy_Selected.*Selected_Code_1;
        LCCF_GPS(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=0;
    end
end
% Normalized wrt code length
LCCF_GPS=LCCF_GPS/p;
Expected_CCCF_Values=Expected_CCF_Values(2:end);
Copy_Selected=Selected_Code_2;
for i=1:p
         CCCF_GPS(i)=sum(Copy_Selected.*Selected_Code_1);
         Copy_Selected=circshift(Copy_Selected,1);
end
% Normalized wrt code length
CCCF_GPS=CCCF_GPS/p;
% Plot LCCF
symmInterval=round((2*p-1)/2-1);
tau=-symmInterval:1:symmInterval;
figure,plot(tau,LCCF_GPS),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xy}(\tau)$','Interpreter','latex');
title('Normalized Linear Cross-Correlation | GPS','Interpreter','latex');
% Plot CCCF
symmInterval=round(p/2-1);
tau=-symmInterval:1:symmInterval;
CCCF_GPS=circshift(CCCF_GPS,symmInterval);
figure,plot(tau,CCCF_GPS),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xy}(\tau)$','Interpreter','latex');
title('Normalized Circular Cross-Correlation | GPS','Interpreter','latex');
%% Step 3: Generation of Galileo codes
load GalileoCodes.mat;
p=size(GalE1b,2);
Selected_Code=GalE1b(1,:);
LCF_GAL=zeros(1,p);
Copy_Selected=zeros(1,p);
Copy_Selected(1,1)=Selected_Code(1,end);
% Linear Auto Correlation implementation
for i=1:2*p-1
    if i<=p-1
        S=Copy_Selected.*Selected_Code;
        LCF_GAL(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=Selected_Code(1,p-i);
    else
        S=Copy_Selected.*Selected_Code;
        LCF_GAL(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=0;
    end
end
% Normalization wrt code length
LCF_GAL=LCF_GAL/p;
% Plot
symmInterval=round((2*p-1)/2-1);
tau=-symmInterval:1:symmInterval;
figure,plot(tau,LCF_GAL),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Normalized Linear Auto-Correlation | GAL','Interpreter','latex');
legend('PRN1 code','Interpreter','latex');
% Circular Auto Correlation implementation
Copy_Selected=Selected_Code;
for i=1:p
         CCF_GAL(i)=sum(Copy_Selected.*Selected_Code);
         Copy_Selected=circshift(Copy_Selected,1);
end
% Normalization wrt code length
CCF_GAL=CCF_GAL/p;
% Plot
symmInterval=round(p/2);
tau=-symmInterval:1:symmInterval-1;
CCF_GAL=circshift(CCF_GAL,symmInterval);
figure,plot(tau,CCF_GAL),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Normalized Circular Auto-Correlation | GAL','Interpreter','latex');
legend('PRN1 code','Interpreter','latex');
% Step 3.3: cross-correlations
Selected_Code_1=GalE1b(1,:);
Selected_Code_2=GalE1b(2,:);
LCCF_GAL=zeros(1,p);
Copy_Selected=zeros(1,p);
Copy_Selected(1,1)=Selected_Code_2(1,end);
for i=1:2*p-1
    if i<=p-1
        S=Copy_Selected.*Selected_Code_1;
        LCCF_GAL(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=Selected_Code_1(1,p-i);
    else
        S=Copy_Selected.*Selected_Code_1;
        LCCF_GAL(1,i)=sum(S);
        Copy_Selected(1,2:end)=Copy_Selected(1,1:end-1);
        Copy_Selected(1,1)=0;
    end
end
LCCF_GAL=LCCF_GAL/p;
Copy_Selected=Selected_Code_2;
for i=1:p
         CCCF_GAL(i)=sum(Copy_Selected.*Selected_Code_1);
         Copy_Selected=circshift(Copy_Selected,1);
end
CCCF_GAL=CCCF_GAL/p;
% Plot LCCF
symmInterval=round((2*p-1)/2-1);
tau=-symmInterval:1:symmInterval;
figure,plot(tau,LCCF_GAL),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xy}(\tau)$','Interpreter','latex');
title('Normalized Linear Cross-Correlation | GAL','Interpreter','latex');
% Plot CCCF
symmInterval=round(p/2);
tau=-symmInterval:1:symmInterval-1;
CCCF_GAL=circshift(CCCF_GAL,symmInterval);
figure,plot(tau,CCCF_GAL),grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xy}(\tau)$','Interpreter','latex');
title('Normalized Circular Cross-Correlation | GAL','Interpreter','latex');
% Step 3.3: compute (maximum peak)/(side lobe) in dB
% GPS
peakValue_GPS=max(abs(CCF_GPS));
MPSL_GPS=max(abs(CCF_GPS(CCF_GPS<peakValue_GPS)));
Ratio_GPS=mag2db(peakValue_GPS/MPSL_GPS);
% GAL
peakValue_GAL=max(abs(CCF_GAL));
MPSL_GAL=max(abs(CCF_GAL(CCF_GAL<peakValue_GAL)));
Ratio_GAL=mag2db(peakValue_GAL/MPSL_GAL);
%% Step 4: Generation of code local replica
% GPS
fs=16.368e6;
chip_rate=1.023e6;
codeIn_GPS=Generated_Code(1,:);
codeOut_GPS=generateLocalCode(codeIn_GPS, fs, chip_rate);
% GAL
f_BOC=1e6;
codeIn_GAL=GalE1b(1,:);
codeOut_GAL=generateLocalCode(codeIn_GAL, fs, chip_rate);
Signal_GAL=modulate(codeOut_GAL,f_BOC,fs,'am');
%% Step 5: Codes in time and frequency
% Step 5.1
% GPS Time-Domain
discreteTimePlot=5*fs/chip_rate;
figure;
subplot(2,1,1),stem(codeIn_GPS(1:5)),grid on,axis('padded');
title('GPS Incoming Signal','Interpreter','latex');
xlabel('[n]','Interpreter','latex');
subplot(2,1,2),stem(codeOut_GPS(1:discreteTimePlot)),grid on,axis('padded');
title('GPS Local Replica','Interpreter','latex');
xlabel('[n]','Interpreter','latex');
% GPS Frequency-Domain
N=length(codeOut_GPS);
Nwel=ceil(N/10);                    % Length of the window
h=ones(1,Nwel);                     % Rectangular window to pre-filter
Noverlap=ceil(Nwel/2);              % Number of overlapping samples
Nfft=4096;                          % Number of FFT points per window
Fs=fs;                              % Optimal sampling rate at baseband
[Px_GPS,f_GPS]=pwelch(codeOut_GPS,h,Noverlap,Nfft,Fs,'centered');
figure,plot((f_GPS./1e+07).*10,pow2db(Px_GPS)),axis('tight'),grid on;
xline(0,'LineWidth',1.5,'LineStyle','--','Color','black');
xlabel('Frequency [MHz]','Interpreter','latex');
ylabel('Magnitude [dB]','Interpreter','latex');
title('Frequency domain | GPS signal','Interpreter','latex');
% GAL Time-Domain
figure;
subplot(2,1,1),stem(codeIn_GAL(1:5)),grid on,axis('padded');
title('GAL Incoming Signal','Interpreter','latex');
xlabel('[n]','Interpreter','latex');
subplot(2,1,2),stem(codeOut_GAL(1:discreteTimePlot)),grid on,axis('padded');
title('GAL Local Replica','Interpreter','latex');
xlabel('[n]','Interpreter','latex');
% GAL Frequency-Domain
N=length(Signal_GAL);
Nwel=ceil(N/10);                    % Length of the window
h=ones(1,Nwel);                     % Rectangular window to pre-filter
Noverlap=ceil(Nwel/2);              % Number of overlapping samples
Nfft=4096;                          % Number of FFT points per window
Fs=fs;                              % Optimal sampling rate
[Px_GAL,f_GAL]=pwelch(Signal_GAL,h,Noverlap,Nfft,Fs,'centered');
figure,plot((f_GAL./1e+07).*10,pow2db(Px_GAL)),axis('tight'),grid on;
xlim([-5 5]);
xline(0,'LineWidth',1.5,'LineStyle','--','Color','black');
xline(1,'LineWidth',1.5,'LineStyle','--','Color',[0.8500 0.3250 0.0980]);
xline(-1,'LineWidth',1.5,'LineStyle','--','Color',[0.8500 0.3250 0.0980]);
xlabel('Frequency [MHz]','Interpreter','latex');
ylabel('Magnitude [dB]','Interpreter','latex');
title('Frequency domain | BOC(1,1) signal','Interpreter','latex');
% Step 5.2
figure,plot((f_GPS./1e+07).*10,pow2db(Px_GPS),(f_GAL./1e+07).*10,pow2db(Px_GAL)),axis('tight'),grid on;
xline(0,'LineWidth',1.5,'LineStyle','--','Color','black');
%xline(1,'LineWidth',1.5,'LineStyle','--','Color',[0.8500 0.3250 0.0980]);
%xline(-1,'LineWidth',1.5,'LineStyle','--','Color',[0.8500 0.3250 0.0980]);
xlabel('Frequency [MHz]','Interpreter','latex');
ylabel('Magnitude [dB]','Interpreter','latex');
title('Frequency domain | Spectra comparison','Interpreter','latex');
legend('GPS','GAL BOC(1,1)','Interpreter','latex');
% Step 5.3
% GPS
Copy_Selected=codeOut_GPS;
for i=1:length(codeOut_GPS)
         CCF_GPS(i)=sum(Copy_Selected.*codeOut_GPS);
         Copy_Selected=circshift(Copy_Selected,1);
end
% Normalization wrt code length
CCF_GPS=CCF_GPS/length(codeOut_GPS);
% GAL
Copy_Selected=Signal_GAL;
for i=1:length(Signal_GAL)
         CCF_GAL(i)=sum(Copy_Selected.*Signal_GAL);
         Copy_Selected=circshift(Copy_Selected,1);
end
% Normalization wrt code length
CCF_GAL=CCF_GAL/length(Signal_GAL);
% Plot both in same figure
% GPS
symmInterval_GPS=round(length(codeOut_GPS)/2);
CCF_GPS=circshift(CCF_GPS,symmInterval_GPS);
% GAL
symmInterval_GAL=round(length(Signal_GAL)/2);
CCF_GAL=circshift(CCF_GAL,symmInterval_GAL);
tau=-16:1:15;
figure,plot(tau,CCF_GPS(symmInterval_GPS-15:symmInterval_GPS+16),'-ob', ...
    tau,CCF_GAL(symmInterval_GAL-15:symmInterval_GAL+16),'-or');
xline(0,'LineWidth',1,'LineStyle','--','Color','black');
grid on,axis('padded');
xlabel('$\tau$','Interpreter','latex');
ylabel('$R_{xx}(\tau)$','Interpreter','latex');
title('Normalized Circular Auto-Correlation (zoomed) | GPS vs. GAL','Interpreter','latex');
legend('GPS','GAL BOC(1,1)','Interpreter','latex');
