% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Room C4.03, L2S, CNRS/SUPELEC
% *************************************************************************
% DESCRIPTION:
% It returns the index the minimum element of a vector without considering
% the J-th element
% *************************************************************************

function [minVal, ind] = minWithoutJ(X, J)

Y = X(1:length(X) ~= J);

[minVal, ind] = min(Y);

if ind >= J
    ind = ind + 1;
end