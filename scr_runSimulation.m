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
[p, vP] = defaultParms();

% CUSTOMIZE PARAMETERS
% *************************************************************************
% *) Result folder
p.resultFolder = 'single_tier';
% *) Number of elements of the vectorial parameters. Number of points of
% graphs showing key performance metrics.
p.nVal = 10;
% *) Number of spatial realizations
p.nSpatReal = 1e2;
% *) x-label for the performance figures
p.xLabel = 'p_{MBS} (dBm/Hz)';
% *) x-axis for the performance figures
p.xVtc = linspace(-80, 0, p.nVal);
% *) Save locations: it saves the association between UE and BS, and 
% their locations 
p.saveLocations = true;

% SPECIFIC PARAMETERS
% *************************************************************************
% Modify here those parameters that will use a diferent value than the one
% stored in defaultParms
vP.pmaxMBSdBmpHz = p.xVtc;

% *) Density of Macro Base Stations (MBSs). Points/m2
vP.lambdaMBSs = 2e-6;
% *) Density of Small cell Base Stations (SBSs). Points/m2
vP.lambdaSBSs = 0e-6;
% *) Density of Mobile Terminals (MTs). Points/m2
vP.lambdaMTs = 150e-6;

% MAIN FUNCTION
% *************************************************************************
ranSim(p, vP);

% Restore search paths
% *************************************************************************
path(oldPath);
