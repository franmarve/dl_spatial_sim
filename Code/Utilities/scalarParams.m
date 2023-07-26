% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This function fixes the length of the vectorial params
% *************************************************************************

function sP = scalarParams(vP, iVal)

vPFields = fieldnames(vP);

nFields = length(vPFields);

for iField = 1:nFields
    eval(['sP.' vPFields{iField} '= vP.' vPFields{iField} '(iVal);'])
end


