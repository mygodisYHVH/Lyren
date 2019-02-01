clc
close all
clear all
%% Basic parameter setting
fs = 96000;
b = 6000; 
fc = 12000;
noiseVar = 1e-5;                                                                                                              
Nc = 1024;
numSymbol = 32;
pilotCoefficent = 1/2;                                                     % pilotCoefficent = Np/(Np+Nd) %
nullCoefficent = 1/32;                                                     % nullCoefficent %                                                                          
guardIntervalCoeff = 0.25;

%% Call config file
configFileOfdmComb                                                           

%% Load Data
[pilotIndex, dataIndex, nullIndex,pilotDataIndex] = genindex(Nc,...
    pilotCoefficent,nullCoefficent);                                       % Generate Indexes
Nd = length(dataIndex);
Np = length(pilotIndex);
dataSignal = randi([0 1],Nd,1);                                            % Generate random numbers for data and pilots
dataPilot = randi([0 1],Np,1);

%% Baseband modulation
encodedData = step(hConEnc,dataSignal);                                    % ConvolutionalEncode  Data 
modData = step(hMod,encodedData);                                          % QPSK modulate Date 
encodedPilot = step(hConEnc,dataPilot);                                    % ConvolutionalEncode  Pilot 
modPilot = step(hMod,encodedPilot);                                        % QPSK modulate Pilot
modSignal = zeros(Nc,1);
modSignal(pilotIndex,1) = modPilot;
modSignal(dataIndex,1) = modData;
modSignalIfft = ifft(modSignal,Nc);                                        % OFDM modulate

%% Add guard interval
modSignalIfftCp = addgi(modSignalIfft,guardIntervalCoeff);                 % Add guard interval,in this demo is
                                                                           % Cyclic prefix

%% IQ Modulation
iqmodSignal = iqmod(modSignalIfftCp.',fs,b,fc);
spectrogram(iqmodSignal,256,250,256,fs,'yaxis')                            % Plot time-frequency curve 

%% AWGN Channel
receivedSignalGuardInterval = rchan(iqmodSignal);     
     
%% IQ demodulation     
iqdemodSignalGuardInterval = iqdemod(receivedSignalGuardInterval.',fs,b,fc);

%% Base band demodulation
receivedSignal = removegi(iqdemodSignalGuardInterval,guardIntervalCoeff);  % Remove guard interval 

%% FFT
receivedSignalFft = fft(receivedSignal,Nc);

receivedData = receivedSignalFft(dataIndex,1);
scatterplot(receivedData);
receivedPilot = receivedSignalFft(pilotIndex,1);

%% LS Channel Estimation
estimatedHp = receivedPilot./modPilot;                                     % H means channel
estimatedRealHp = real(estimatedHp);
estimatedImagHp = imag(estimatedHp);
estimatedRealH = interp(estimatedRealHp,1/pilotCoefficent);                % Linear interpolation
estimatedImagH = interp(estimatedImagHp,1/pilotCoefficent);
estimatedH = complex(estimatedRealH,estimatedImagH);
plot(abs(ifft(estimatedH)))

%% Zero-forcing equilization
receivedPilotData = receivedSignalFft(pilotDataIndex,1);
esimatedReceivedPilotData = receivedPilotData./estimatedH;
scatterplot(esimatedReceivedPilotData)

esimatedReceivedMsg = zeros(Nc,1);
esimatedReceivedMsg(pilotDataIndex,1) = esimatedReceivedPilotData;
esimatedReceivedData = esimatedReceivedMsg(dataIndex,1); 

%% APP decoder 
%The APP decoder assumes a polarization of the soft inputs that is    %
% inverse to that of the demodulator soft outputs. Change the sign of %
% demodulated signal.                                                 %    
demodSignal = step(hDemod,esimatedReceivedData);
% demodSignal = step(hDemod,receivedData);    %
receivedSoftBits = step(hAPPDec,zeros(Nd,1),-demodSignal);
% Convert from soft-decision to hard-decision.%
receivedBits = double(receivedSoftBits > 0);
%% Count errors
errorStats = step(hError,dataSignal,receivedBits);
fprintf('Error rate = %f\nNumber of errors = %d\n',errorStats(1), errorStats(2))