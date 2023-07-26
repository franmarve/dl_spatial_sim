% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Room C4.03, L2S, CNRS/SUPELEC
% *************************************************************************
% DESCRIPTION:
% It obtains the set of interfering (active) MTs considering random 
% scheduling. If a cell has a single active MT this MT is scheduled in all
% the bandwidth. Each element of niIntMTs corresponds with an element of 
% niIntBSs
% *************************************************************************

function niIntMTs = interfMTs(asocBS2MT, niIntBSs, activeMT)

nIntBSs = length(niIntBSs);
niIntMTs = zeros(nIntBSs, 1);

for iBS = 1:nIntBSs
    niBS = niIntBSs(iBS);
    niMTs = asocBS2MT{niBS};
    niActMTs = niMTs(activeMT(niMTs));
    niIntMTs(iBS) = niActMTs(randi(length(niActMTs)));
end