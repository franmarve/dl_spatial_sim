% *************************************************************************
% Francisco J. Martin-Vega, frmvega@gmail.com
% Lab 1.3.5., Dpto. of Ingenieria de Comunicaciones. University of Malaga
% *************************************************************************
% DESCRIPTION:
% This function save figures related to key performance metrics
% *************************************************************************

function savePerformanceFig(p, vR)

hf = figure;
strLegend = cell(p.nVal, 1);
for iVal = 1:p.nVal
    plot(p.TdB, vR.Pc_MT0{iVal});
    hold on
    strLegend{iVal} = ['iVal=' num2str(iVal)];
end
ylabel('ccdf SINR')
xlabel(p.xLabel)
grid
legend(strLegend);
saveas(hf, [p.folderName '\ccdfSINR.fig'])
close(hf)

hf = figure;
plot(p.xVtc, vR.amc.avSE_MT0);
title('Average SE with AMC')
ylabel('E[SE]')
xlabel(p.xLabel)
grid
saveas(hf, [p.folderName '\avSE_amc.fig'])
close(hf)

hf = figure;
plot(p.xVtc, vR.shann.avSE_MT0);
title('Average SE with Shannon')
ylabel('E[SE]')
xlabel(p.xLabel)
grid
saveas(hf, [p.folderName '\avSE_shann.fig'])
close(hf)



