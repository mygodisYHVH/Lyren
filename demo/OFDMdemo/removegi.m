function [y] = removegi(x,guardIntervalCoeff)
% REMOVEGI: Remove guard interval 
% Example:[y] = REMOVEGI(x,guardIntCoeff)
% INPUT£º
% 'x'£ºThe sequence need to remove guard interval.
% 'guardIntervalCoeff'£ºThe ratio of Guard interval length to the input sequence length.                                                                                          
% OUTPUT£º
% 'y'£ºThe sequence have removed guard interval.

% Call:None.
% Refrences:None.
% Author: Lilin
% E-mail: lilin@hrbeu.edu.cn

    frameLength = length(x)/(1+guardIntervalCoeff);
    guardIntvalNum = frameLength*guardIntervalCoeff;
    y = x(guardIntvalNum + 1:guardIntvalNum + frameLength);                % Remove guard interval
end                                                                        % End of function