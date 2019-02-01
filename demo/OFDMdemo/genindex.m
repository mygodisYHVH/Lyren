function [pilotIndex, dataIndex, nullIndex,pilotDataIndex] = genindex(Nc,...
              pilotCoefficent,nullCoefficent)
% GENINDEX: Generate indexes for different kinds of subcarriers, include
%           data subcarrier,pilot subcarrier and null subcarrier. 
% Example:[pilotIndex, dataIndex, nullIndex,pilotDataIndex] = GENINDEX(Nc,
%             pilotCoefficent,nullCoefficent)
% INPUT��
% 'Nc' ��The number of subcarriers.
% 'pilotCoefficent'��Pilot subcarrier to total subcarrier ratio.  
% 'nullCoefficent'��Null subcarrier to total subcarrier ratio. 
% OUTPUT��
% 'pilotIndex'��Index of pilot subcarrier.
% 'dataIndex' ��Index of data subcarrier.
% 'nullIndex' ��Index of null subcarrier.
% 'pilotDataIndex' ��Index of pilot and data subcarrier.

% Call:None.
% Refrences:None.
% Author: Lilin
% E-mail: lilin@hrbeu.edu.cn

    Nn = nullCoefficent*Nc;
    Np = pilotCoefficent*(Nc-Nn);
    Nd = Nc-Np-Nn;
    
    nullIndex = zeros(Nn,1);                                               % Index of data
    for i = 1:Nn/2
        nullIndex(i) = i;
        nullIndex(Nn-i+1) = Nc - i + 1 ;
    end                                                                    % End of for i = 1:Nn/2
    
    pilotIndex = zeros(Np,1);                                              % Index of pilots                                     
    for i = 1:Np
        pilotIndex(i) = (i-1)/pilotCoefficent + 1 + Nn/2;
    end                                                                    % % End of for i = 1:Np
    
    dataIndex = zeros(Nd,1);                                               % Index of data
    for i = 1:Nd
        dataIndex(i) = floor((i-1)/(1/pilotCoefficent-1)) + i + 1 + Nn/2;
    end                                                                    % End of for i = 1:Nd
    
    pilotDataIndex = zeros(Np+Nd,1);
    pilotDataIndex(pilotIndex-Nn/2,1) = pilotIndex; 
    pilotDataIndex(dataIndex-Nn/2,1) = dataIndex; 
end                                                                        % End of function