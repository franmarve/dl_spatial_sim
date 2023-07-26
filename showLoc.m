% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% Shows locations of the UEs associated with the BS whose id is id_BSs. 
% INPUTS:
% - loc: Cell array of structs with the information about locations and
% associations between UEs and BSs. 
% - id_BS: the ID of the probe BS whose UEs are being drawn
% - color: string that selects the color to draw such UEs associated with
% the BS id_BS. It must follow the MATLAB short format, e.g., 'b' for blue,
% 'r' for red, 'k' for black, etc.
% *************************************************************************

function [hf, loc_nUEs, loc_BS] = showLoc(loc, id_BS, color)

if nargin < 3
    color = 'r';
end

% Sanity check: the id_BS should be one of the probe set (avoiding border 
% effects) and should not be empty
if sum(id_BS == loc.niProbeBSs) ~= 1 
    disp(['niProbeBSs: ' num2str(loc.niProbeBSs)]);
    error(['showLoc: The chose BS does not belong to the probe set. ' ...
        'Check niProbeBSs avobe.']);
end

hf = voronoi(loc.PhiBS(:, 1), loc.PhiBS(:, 2)); hold on;

for i = 1:length(hf)
    hf(i).LineWidth = 3;
end

for iBS = 1:loc.nBSs
    % Draw the BS
    if iBS == id_BS
        this_color_UE = color;
        this_color_BS = color;
        loc_nUEs = loc.PhiMT(loc.asocBS2MT{iBS}, :);
        loc_BS = loc.PhiBS(iBS, :);
    else
        this_color_UE = 'k';
        this_color_BS = 'b';
    end
    plot(loc.PhiBS(iBS, 1), loc.PhiBS(iBS, 2), 'LineStyle', 'none', ...
        'Color', this_color_BS, 'Marker', '^', 'LineWidth', 3); hold on;

    % Draw the UEs
    plot(loc.PhiMT(loc.asocBS2MT{iBS}, 1), ...
        loc.PhiMT(loc.asocBS2MT{iBS}, 2), 'LineStyle', 'none', ...
        'Color', this_color_UE, 'Marker', 'x'); hold on;
end
