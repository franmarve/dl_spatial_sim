% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This function sets the default values of the simulation parameters
% *************************************************************************

function [p, vP] = defaultParms()

% ESTIMATION OF STATISTICS
% *************************************************************************
% *) Minimum average number of Base Stations (BSs) in the simulated area
p.nAverBSs = 100;
% *) Minimum average number of MTs
p.nAverMTs = 2.5e3;
% *) Bandwidth of the RAN in Hz
p.bsHz = 9e6;
% *) SINR theshold for coverage probability
p.TdB = -40:+40;

% POINT PROCESS DENSITIES
% *************************************************************************
% *) Density of Macro Base Stations (MBSs). Points/m2
vP.lambdaMBSs = 2e-6;
% *) Density of Small cell Base Stations (SBSs). Points/m2
vP.lambdaSBSs = 0e-6;
% *) Density of Mobile Terminals (MTs). Points/m2
vP.lambdaMTs = 150e-6;

% POWER 
% *************************************************************************
% *) Transmit power for MBSs
vP.pmaxMBSdBmpHz = -20;
% *) Transmit power for SBSs
vP.pmaxSBSdBmpHz = -32;

% PATH LOSS
% *************************************************************************
% STANDARD PARAMETERS
% *) Slope of the path loss for MBS
vP.tauMBS = 2.6;
% *) Slope of the path loss for SBS
vP.tauSBS = 2.6;
% *) Exponent of the path loss for MBS
vP.alphaMBS = 3.8;
% *) Exponent of the path loss for SBS
vP.alphaSBS = 3.8;

% NOISE
% *************************************************************************
% *) (dBm/Hz) Thermal noise spectral density
p.thermaldBmHz = -174; 
% *) Noise figure
p.NFdB = 10; 

% ASSOCIATION
% *************************************************************************
% *) Bias for SBS association
vP.dl.pSBSbiasdB = 0;




