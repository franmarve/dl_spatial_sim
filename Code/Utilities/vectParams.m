% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This function fixes the length of the vectorial params
% *************************************************************************

function vP = vectParams(p, vP)

vPFields = fieldnames(vP);
nFields = length(vPFields);

for iField = 1:nFields
    eval(['x = ' 'vP.' vPFields{iField} ';'])
    if length(x) == 1
        eval(['vP.' vPFields{iField} ' = repmat(x, 1, p.nVal);'])
    end
end


