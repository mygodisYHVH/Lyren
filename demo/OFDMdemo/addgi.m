function [y] = addgi(x,guardIntervalCoeff)
% ADDGI: Add guard interval 
% Example:[y] = ADDGI(x,guardIntCoeff)
% INPUT£º
% 'x'£ºThe sequence need to add guard interval.
% 'guardIntervalCoeff'£ºThe ratio of Guard interval length to the input sequence length.                                                                                          
% OUTPUT£º
% 'y'£ºThe sequence have added guard interval.

% Call:None.
% Refrences:None.
% Author: Lilin
% E-mail: lilin@hrbeu.edu.cn

    frameLength = length(x);                                               % Length of input sequence
    guardIntNum = frameLength*guardIntervalCoeff;
    cyclicPrefix=x(frameLength - guardIntNum + 1:frameLength);             % Cyclic prefix initialization   
    y = [cyclicPrefix;x];  
    
end                                                                        % End of function