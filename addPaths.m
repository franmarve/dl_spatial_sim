% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This script adds paths to code folders. 
% OUTPUTs:
% +) currentDir: It is the set of working paths including the added paths
% +) oldPath: It is the set of working paths before adding those of the
% project. 
% *************************************************************************

function [currentDir, oldPath] = addPaths()
oldPath = path;
currentDir = cd;
path([currentDir '\Code\Utilities'   ], path);
path([currentDir '\Code\Simulation'   ], path);
cd(currentDir);