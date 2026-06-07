function CAF = AcquisitionFunctionGAL(RawData,GAL_Code,Nc)
fs=16.368e6;
chip_rate=1.023e6;
IntermediateFreq=4.092e6;
SignalLength=Nc*4e-3;
TestCode=GAL_Code;
if Nc>1
    for i=1:Nc-1
        TestCode=[TestCode,GAL_Code];
    end
end
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
    CCCF_GAL(i,:)=ifft((fft(localSignal).*conj(fft(RawData))));
    % Normalize CCCF for current Doppler value wrt length
    CCCF_GAL(i,:)=CCCF_GAL(i,:)/DelayBins;
end
% CAF computation and plot
CAF=abs(CCCF_GAL).^2;
end