% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This script evaluates the performance of power setting
% *************************************************************************

function ranSim(p, vP)

vR = [];

% CONSTANT VALUES - CQI TABLE
% *************************************************************************
p.gammaTh = [0 0.4315    0.6918    1.0000    1.6780    2.3710    ...
    2.9850   7.9433   11.2202   17.1791   34.6737   52.2396   76.7361 ...
    117.4898  251.1886  316.2278 +Inf].';
p.SEi_bpSymb = [0 0.1523 0.2344 0.3770 0.6016 0.8770 1.1758 1.4766 ...
    1.9141 2.4063 2.7305 3.3223 3.9023 4.5234 5.1152 5.5547].';
p.SEi_bpspHz = p.SEi_bpSymb/15e3/(1e-3/14);

% ANONYMUS FUNCTION DEFINITION
% *************************************************************************
func.dt = @(x) sqrt(x(:,1).^2 + x(:,2).^2); 
func.cqiTable = @(sinr)  find(sinr >= p.gammaTh, 1, 'last') - 1;
func.i1i = @(x) double(x);

% VECTORIAL PARAMETERS
% *************************************************************************
vP = vectParams(p, vP);

% DEPENDENT PARAMETERS
% *************************************************************************
% *) Noise power
p.pWattsperHz = db2pow(p.thermaldBmHz + p.NFdB - 30); 

% CREATION OF A RESULT FOLDER
% *************************************************************************
p = createResultsFolder(p);

% MAIN BODY
% *************************************************************************
hwin = waitbar(0, 'Running simulation points...');
count = 0;
nIters = p.nVal;

t0 = clock;

for iVal = 1:p.nVal
    % OBTAINING SCALAR VALUES
    % *********************************************************************
    sP = scalarParams(vP, iVal);

    % OBTAINING METRICS
    % *********************************************************************
    [sR, sF] = ranSimMetrics(p, sP, func);

    % SAVE CURRENT RESULTS AND FILL RESULTS STRUCT
    % *********************************************************************
    vR = resultStruc(p, sR, vR, iVal);

    save([p.folderName '\sR_' num2str(iVal) '.mat'], 'p', 'vR', 'sR')

    count = count + 1;
    waitbar(count/nIters, hwin);
end

% SAVING RESULTS AND KEY PERFORMANCE FIGURES
% *********************************************************************
% Elapsed time
t1 = clock; % 4th hours, 5th minutes
t0min = t0(4)*60 + t0(5);
t1min = t1(4)*60 + t1(5);
vR.eHours = (t1min - t0min)/60;
% Saving results
save([p.folderName '\results.mat'], 'vR', 'p', 'vP')

savePerformanceFig(p, vR);

close(hwin);


