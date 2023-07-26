% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This script evaluates the performance of DL of a HetNet with Macro BSs and
% small cell BSs. 
% *************************************************************************

clc; clear; 

% Add search path with the project files
% *************************************************************************
[~, oldPath] = addPaths();

% LOAD DEFAULT PARAMETERS
% *************************************************************************
defaultParms;

% CUSTOMIZE PARAMETERS
% *************************************************************************
% *) Result folder
p.resultFolder = 'prueba';
% *) Number of elements of the vectorial parameters. Number of points of
% graphs showing key performance metrics.
p.nVal = 1;
% *) Number of spatial realizations
p.nSpatReal = 1e1;
% *) x-label for the performance figures
p.xLabel = 'p_{MBS} (dBm/Hz)';
% *) x-axis for the performance figures
p.xVtc = linspace(-80, 0, p.nVal);
% *) Save locations: it saves the association between UE and BS, and 
% their locations 
p.saveLocations = true;

% SPECIFIC PARAMETERS
% *************************************************************************
vP.pmaxMBSdBmpHz = p.xVtc;

% MAIN FUNCTION
% *************************************************************************
ranSim(p, vP);

% Restore search paths
% *************************************************************************
path(oldPath);
