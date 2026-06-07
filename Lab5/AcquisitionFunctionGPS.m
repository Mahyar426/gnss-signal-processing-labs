function CAF = AcquisitionFunctionGPS(RawData,PRN_Index,Nc)
fs=16.368e6;
chip_rate=1.023e6;
IntermediateFreq=4.092e6;
SignalLength=Nc*1e-3;
TestCode=PRN_Generator(PRN_Index,Nc);
LocalCodeReplica=generateLocalCode(TestCode,fs,chip_rate);
N=length(LocalCodeReplica);
Tcoh=N/fs;
Delta_f=2/(3*Tcoh);
DopplerBins=-5000:Delta_f:5000;
DelayBins=N;
for i=1:length(DopplerBins)
    % Local Carrier + Doppler creation
    carrierOut_Doppler=generateLocalIIF_Doppler(fs,IntermediateFreq,DopplerBins(i),SignalLength,Nc);
    % Local signal creation
    localSignal=LocalCodeReplica.*carrierOut_Doppler;
    CCCF_GPS(i,:)=ifft((fft(localSignal).*conj(fft(RawData))));
    % Normalize CCCF for current Doppler value wrt length
    CCCF_GPS(i,:)=CCCF_GPS(i,:)/DelayBins;
end
% CAF computation and plot
CAF=abs(CCCF_GPS).^2;
end