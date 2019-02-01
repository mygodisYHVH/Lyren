function [y] = iqmod(x,fs,b,fc)
% IQMOD: An IQ modulator,this function can modulate the baseband signal to
% the passband.
% Example:y = IQMOD(x,fs,b,fc)
% INPUT��
% 'x' ��The sequence need to be modulated.
% 'fs'��System sampling rate.                                              /Hz
% 'b' ��The band of the signal.                                            /Hz 
% 'fc'��The carrier frequency.                                             /Hz
% OUTPUT��
% 'y' ��The signal modulated to passband.

% Call:None.
% Refrences:None.
% Author: Lilin
% E-mail: lilin@hrbeu.edu.cn

    N = fs/b;                                                              % Upsampling points
    xUpsample = rectpulse(x,N);                                            % Upsampling the signal,Chip length = fs/b 
    t = 0:1/fs:(length(xUpsample)-1)/fs;
    % yCos=cos(2*pi*fc*t);    %
    % ySin=sin(2*pi*fc*t);    %
    % ynI = real(xUpsample);  %
    % ynQ = imag(xUpsample);  %
    % y = ynI.*yCos-ynQ.*ySin;%  
    y = real(xUpsample.*exp(1i*2*pi*fc*t));                                % Equivalent to these five lines before 
    y = y.'/max(abs(y));                                                   % Nomalized the signal and convert it into column vector

end                                                                        % End of function