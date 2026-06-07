function carrierOut=generateLocalIIF_Doppler(SamplingFreq,IntermediateFreq,Doppler,SignalLength,Nc)
Ts=1/SamplingFreq;
SamplingInterval=0:Ts:SignalLength-Ts;
carrierOut=sqrt(2)*exp(2*pi*1i*(IntermediateFreq+Doppler).*SamplingInterval);
end