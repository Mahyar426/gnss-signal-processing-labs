function codeOut = generateLocalCode(codeIn, samplingFreq, chipRate)
SpC=samplingFreq/chipRate;
codeOut=rectpulse(codeIn,SpC);
end