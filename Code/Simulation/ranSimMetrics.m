% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This function obtains the key metric related to the DL of a cellular
% network
% *************************************************************************

function [sR, sF] = ranSimMetrics(p, sP, func)

% Struct for graphing pourposes
sF = [];

% Area where the BSs, and MTs are placed in order to compute SINR
if min(sP.lambdaMBSs,sP.lambdaSBSs) > 0
    lambdaBS = min(sP.lambdaMBSs,sP.lambdaSBSs);
    singleTier = false;
else
    lambdaBS = max(sP.lambdaMBSs,sP.lambdaSBSs);
    singleTier = true;
end
bsSideLengthm = max(sqrt(p.nAverBSs/lambdaBS), ...
    sqrt(p.nAverMTs/sP.lambdaMTs));

% Define the test region 
testLengthm = bsSideLengthm/5; 
testVertex = [testLengthm testLengthm; -testLengthm testLengthm; ... 
    -testLengthm -testLengthm; testLengthm -testLengthm]; 


pMaxMBSWpHz = db2pow(sP.pmaxMBSdBmpHz - 30);
pMaxSBSWpHz = db2pow(sP.pmaxSBSdBmpHz - 30);

% REALIZATIONS OF KEY PERFORMANCE METRICS
% *************************************************************************
SINR_MT0_perReal = [];
shann.SE_MT_perReal = [];
amc.SE_MT_perReal = [];

hwin = waitbar(0,'Spatial averaging...');
count = 0;
nIters = p.nSpatReal;

if p.saveLocations
    % Loc is a cell array of structs with the location and association
    % related to each spatial realization
    loc = cell(p.nSpatReal, 1);
else
    loc = [];
end

for iSpatReal = 1:p.nSpatReal
    % Placement of PPPs: MBSs, SBSs, MTs
    % *********************************************************************
    bsArea = bsSideLengthm^2; % Simulation area 
        
    % PPP of MBSs
    nMBSs = poissrnd(sP.lambdaMBSs*bsArea);
    PhiMBS = bsSideLengthm*rand(nMBSs, 2) - bsSideLengthm/2;
    
    % PPP of SBSs
    nSBSs = poissrnd(sP.lambdaSBSs*bsArea);
    PhiSBS = bsSideLengthm*rand(nSBSs, 2) - bsSideLengthm/2;
    
    % PPP of MTs
    nMTs = poissrnd(sP.lambdaMTs*bsArea);
    PhiMT = bsSideLengthm*rand(nMTs, 2) - bsSideLengthm/2;
    
    % PPP of BSs
    PhiBS = [PhiMBS; PhiSBS];
    nBSs = nMBSs + nSBSs;
    
    % DEPENDENT VARIABLES
    % *********************************************************************
    % niAllBSs
    niAllBS = 1:nBSs;
    
    % Per tier parameters
    biasBS = [ones(nMBSs, 1); ...
        repmat(db2pow(sP.dl.pSBSbiasdB), nSBSs, 1)];
    alphaBS = [repmat(sP.alphaMBS, nMBSs, 1); ...
        repmat(sP.alphaSBS, nSBSs, 1)];
    tauBS = [repmat(sP.tauMBS, nMBSs, 1); ...
        repmat(sP.tauSBS, nSBSs, 1)];
    PtBSWpHz = [repmat(pMaxMBSWpHz, nMBSs, 1); ...
        repmat(pMaxSBSWpHz, nSBSs, 1)];
    
    % INITIALIZATION OF MAIN MATRICES
    % *********************************************************************
    % Association between each BS and its served MTs. It is a cell array
    % with the numerical indices of the MTs served by each BS
    asocBS2MT = cell(nBSs, 1);
    
    % Association between each MT and its serving BSs
    asocMT2BS = zeros(nMTs, 1);
       
    % Empty BS. It indicates whether the BS is empty or not
    emptyBS = true(nBSs, 1);
    
    % CHOSE MTs IN THE TEST SET
    % *********************************************************************
    liProbeBSs = inpolygon(PhiBS(:,1) ,PhiBS(:,2), testVertex(:,1), ...
        testVertex(:,2));
    niProbeBSs = niAllBS(liProbeBSs);
    
    % ASSOCIATION MT - BS
    % *********************************************************************
    for niMT = 1:nMTs
        % Distance from niMT to all the BSs
        Dx = func.dt(repmat(PhiMT(niMT,:), nBSs, 1) - PhiBS);

        % Obtain serving BS
        [~, niServBS] = max(PtBSWpHz.*biasBS.*(tauBS.*Dx).^-alphaBS);

        % Asociation between BS and MT
        asocBS2MT{niServBS} = [asocBS2MT{niServBS}; niMT];

        % Asociation between MT and BS
        asocMT2BS(niMT) = niServBS;
    end
    
    % Upgrade activeBS/emptyBS
    for niBS = 1:nBSs
        niAsocMTs = asocBS2MT{niBS};
        emptyBS(niBS) = isempty(niAsocMTs);
    end
    
    % CALCULATION OF MAIN PERFORMANCE METRICS FOR ONE REALIZATION
    % *********************************************************************
    nProbeBSs = length(niProbeBSs);

    % SAVE LOCATIONS (IF REQUIRED)
    % *********************************************************************
    if p.saveLocations
        loc{iSpatReal}.nBSs = nBSs;
        loc{iSpatReal}.PhiBS = PhiBS;
        loc{iSpatReal}.nMTs = nMTs;
        loc{iSpatReal}.PhiMT = PhiMT;

        loc{iSpatReal}.asocBS2MT = asocBS2MT;
        loc{iSpatReal}.asocMT2BS = asocMT2BS;
        loc{iSpatReal}.liProbeBSs = liProbeBSs;
        loc{iSpatReal}.niProbeBSs = niProbeBSs;
        loc{iSpatReal}.emptyBS = emptyBS;
    end
    
    % Metrics associated with BS0 and MT0 
    % *********************************************************************
    for iProbeBS = 1:nProbeBSs
        niBS = niProbeBSs(iProbeBS);
        
        % Active MTs associated with niBS
        niAsocMTs = asocBS2MT{niBS};
        
        % Number of associated MTs of this BS
        NBS = length(niAsocMTs);
        
        % Instanteneous SINR of each MT
        SINR = zeros(NBS, 1);
        
        % Obtain SINR for its MTs
        for iMT = 1:NBS
            % If niBS is empty this line is not reached
            niMT = niAsocMTs(iMT);
            
            % PER CELL SINR RAN
            % Distance for the desired link
            R0 = func.dt(PhiMT(niMT,:) - PhiBS(niBS,:));

            % Fast-fading for the desired link
            H0 = random('exp', 1, 1, 1);

            % Desired recieved power
            Ps = H0*((tauBS(niBS)*R0)^-alphaBS(niBS))*PtBSWpHz(niBS);

            % Interfering BSs
            liIntBSs = ~emptyBS;
            liIntBSs(niBS) = false;
            niIntBSs = 1:length(liIntBSs);
            niIntBSs = niIntBSs(liIntBSs);
            nInt = sum(liIntBSs);
                       
            % Fast fading for interfering links
            Hi = random('exp', 1, nInt, 1);

            % Distance from each interfering MT towards niBS
            Di = func.dt( repmat(PhiMT(niMT,:), nInt, 1) -  ...
                PhiBS(niIntBSs,:) );

            % Calculation of the interference
            I = sum(Hi.*((tauBS(niBS).*Di).^-alphaBS(niBS))...
                .*PtBSWpHz(niIntBSs));

            % SINR of niMT
            SINR(iMT) = Ps./(I + p.pWattsperHz);
                
        end % end for iMT
        
        % Metrics per realization
        SINR_MT0_perReal = [SINR_MT0_perReal; SINR];
        if NBS > 0        
            % Shannon formula
            % *************************************************************
            shann.SE_MT = log2(1 + SINR);
            shann.SE_MT_perReal = [shann.SE_MT_perReal; shann.SE_MT];
            
            % AMC
            % *************************************************************
            CQIip1 = arrayfun(func.cqiTable, SINR) + 1;
            amc.SE_MT = p.SEi_bpspHz(CQIip1);
            amc.SE_MT_perReal = [amc.SE_MT_perReal; amc.SE_MT];
            
        else
            shann.SE_MT_perReal = [shann.SE_MT_perReal; 0];
            amc.SE_MT_perReal = [amc.SE_MT_perReal; 0];
            
        end
    end % end for iProbeBS
    
    count = count + 1;
    waitbar(count/nIters, hwin);
end % end iSpatReal

close(hwin)

% CCDFs, CDFs and PDFs
% *************************************************************************
sR.loc = loc;
sR.Pc_MT0 = zeros(1, length(p.TdB));

sR.shann.avSE_MT0 = mean(shann.SE_MT_perReal);
sR.amc.avSE_MT0 = mean(amc.SE_MT_perReal);

for iT = 1:length(p.TdB) 
    t = db2pow(p.TdB(iT));
    sR.Pc_MT0(iT) = sum(SINR_MT0_perReal > t)/length(SINR_MT0_perReal);
end

