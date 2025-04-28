%{

Plot cumulative distribution for Fig. 3b

%}


clearvars;

addpath('exampledata');
dataname = 'fig3b_cumDexDS.mat';


load(dataname);

img1 = figure(1);

set(gcf, 'Position',  [700, 100, 800, 300]);

subplot(1,2,1)
p = plotgroupcdf(concatAziEarly,concatAziLate,n,samplesize,'Azimuth',titletext);


subplot(1,2,2)
p = plotgroupcdf(concatEleEarly,concatEleLate,n,samplesize,'Elevation',titletext);






function p = plotgroupcdf(concatEarly,concatLate,nAnimals,samplesize,stimaxis,titletext)

color_earlypool = [0,0.7,0.9];
color_latepool = [0.4,0.2,0.8];
color_earlydata = [0,0.7,0.9,0.2];
color_latedata = [0.4,0.2,0.8,0.2];

toplot = linspace(-2,2,40);%plot invisible line to generate axis
h = cdfplot(toplot);
set( h, 'LineStyle','none');
hold on;

%first plot individual data
for i=1:nAnimals
    startIndex = (i-1)*samplesize+1;
    endIndex = i*samplesize;
    h = cdfplot(concatEarly(startIndex:endIndex));
    set( h, 'Color', color_earlydata,'LineWidth',1);
    h = cdfplot(concatLate(startIndex:endIndex));
    set( h, 'Color', color_latedata,'LineWidth',1);
end

%plot pooled lines
h = cdfplot(concatEarly);
set( h, 'Color', color_earlypool,'LineWidth',4);
h = cdfplot(concatLate);
set( h, 'Color', color_latepool,'LineWidth',4);
hold off;
title([titletext ' - ' stimaxis]);

xlim([-1,1]);
[~,p] = kstest2(concatEarly,concatLate);

end