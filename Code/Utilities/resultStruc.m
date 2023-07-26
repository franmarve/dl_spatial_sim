% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This function fill the result struc for iVal
% *************************************************************************    

function vR = resultStruc(p, sR, vR, iVal)

vR.shann.avSE_MT0(iVal) = sR.shann.avSE_MT0;
vR.amc.avSE_MT0(iVal) = sR.amc.avSE_MT0;

vR.Pc_MT0{iVal} = sR.Pc_MT0;

vR.loc{iVal} = sR.loc;

