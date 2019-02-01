function [y] = iqdemod(x,fs,b,fc)
% IQDEMOD: An IQ demodulator,this function can demodulate the passband
% signal to the baseband¡£
% y = IQDEMOD(x,fs,b,fc)
% INPUT£º
% 'x' £ºThe sequence need to be demodulated.
% 'fs'£ºSystem sampling rate.                                              /Hz
% 'b' £ºThe band of the signal.                                            /Hz
% 'fc'£ºThe carrier frequency.                                             /Hz 
% OUTPUT£º
% 'y' £ºThe signal demodulated to baseband.

% Call:None.
% Refrences:None.
% Author: Lilin
% E-mail: lilin@hrbeu.edu.cn

    N = fs/b;                                                              % Downsampling points
    t = 0:1/fs:(length(x)-1)/fs;
    rCos=cos(2*pi*fc*t);
    rSin=sin(2*pi*fc*t);
    xI = x.*rCos;                                                          % Channel I
    xQ = x.*(-rSin);                                                       % Channel Q
    outI = zeros(1,length(x)/N);
    outQ = zeros(1,length(x)/N);

    for i = 1:length(x)/N                                                  % IQ demodulate
        outI(i) = sum(xI((i-1)*N+1:i*N));
        outQ(i) = sum(xQ((i-1)*N+1:i*N)); 
    end                                                                    % End of for i = 1:length(x)/N 

    y = outI + 1i*outQ;                                                    
    y = y.'/max(abs(y));                                                   % Return a nomalized column vector

end                                                                        % End of function