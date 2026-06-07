function carrierOut=generateLocalIIF(SamplingFreq,IntermediateFreq,SignalLength)
Ts=1/SamplingFreq;
SamplingInterval=0:Ts:SignalLength-Ts;
carrierOut=sqrt(2)*exp(2*pi*1i*(IntermediateFreq).*SamplingInterval);
end