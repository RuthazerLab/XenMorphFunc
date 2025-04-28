%{

Code to generate scatterplots, binned histograms, and
compute histogram intersection match values for Figure 3

Histogram intersection is calculated as defined by Swain & Ballard (1991)
https://link.springer.com/article/10.1007/BF00130487

%}

clearvars;

dataname = 'nplusdDat_Xiaolongbao-2337.mat';



addpath('exampledata');

color_earlyfull = [0,0.7,0.9];
color_latefull = [0.4,0.2,0.8];
color_earlylite = [0.5843    0.8392    0.9294];
color_latelite = [0.8235    0.6588    0.9294];
color_earlydex = [0,0,0];
color_latedex = [0,0,0];

imgwidth=256;
imgheight = imgwidth;

Xedges = linspace(-pi,0,50);
Yedges = linspace(-pi,0,50);

%% load data

load(dataname);
%data fields: 'linmapAzi_early','linmapEle_early','lindexAzi_early','lindexEle_early',
%'linmapAzi_late','linmapEle_late','lindexAzi_late','lindexEle_late','snrthres','dextranthres'


%% plot scatterplots

%find centroids
azicentroidE = mean(linmapAzi_early);
elecentroidE = mean(linmapEle_early);

azicentroidL = mean(linmapAzi_late);
elecentroidL = mean(linmapEle_late);

centroidEarly = [azicentroidE elecentroidE];
centroidLate = [azicentroidL elecentroidL];

centroiddist = centroidEarly - centroidLate;

%align Late clouds to Early
linmapAzi_lateAlign = linmapAzi_late + centroiddist(1);
linmapEle_lateAlign = linmapEle_late + centroiddist(2);


img1 = figure(1);
set(gcf, 'Position',  [400, 150, 800, 600]);
subplot(2,2,1)
[AziRand,EleRand,colorlist] = randomizeScatter(linmapAzi_early,linmapEle_early,linmapAzi_late,linmapEle_late,color_earlyfull,color_latefull);
s1 = scatter(AziRand,EleRand,2,colorlist,"filled");
s1.MarkerFaceAlpha = 0.05;
hold on;
scatter(azicentroidE,elecentroidE,10,'black','o');
scatter(azicentroidL,elecentroidL,12,'black','x');

%make legend
scatter(-3, -0.35, 20, color_earlyfull,"filled");
text(-2.9, -0.35, 'Early','FontSize',9)
scatter(-3, -0.65, 20, color_latefull,"filled");
text(-2.9, -0.65, 'Late','FontSize',9)

hold off;
xlim([-pi,0]);
ylim([-pi,0]);
title('Neuropil phase');
pbaspect([6.5,4,1]);
set(gca,'Xtick',[]);
set(gca,'Ytick',[]);
box on;


subplot(2,2,2)
[AziRand,EleRand,colorlist] = randomizeScatter(linmapAzi_early,linmapEle_early,linmapAzi_lateAlign,linmapEle_lateAlign,color_earlyfull,color_latefull);
s1 = scatter(AziRand,EleRand,2,colorlist,"filled");
s1.MarkerFaceAlpha = 0.05;
hold on;
scatter(azicentroidE,elecentroidE,10,'black','o');
scatter(azicentroidE,elecentroidE,12,'black','x');
hold off;
xlim([-pi,0]);
ylim([-pi,0]);
title('Neuropil phase (align centroids)');
pbaspect([6.5,4,1]);
set(gca,'Xtick',[]);
set(gca,'Ytick',[]);
box on;

subplot(2,2,3)
%s1 = scatter(linmapAzi_early,linmapEle_early,2,color_earlylite,"filled");
s1 = scatter(linmapAzi_early,linmapEle_early,2,color_earlyfull,"filled");
s1.MarkerFaceAlpha = 0.05;
hold on;
s2 = scatter(lindexAzi_early,lindexEle_early,2,color_earlydex,"filled");
s2.MarkerFaceAlpha = 0.05;
s2.MarkerFaceAlpha = 0.2;

%make legend
scatter(-3, -0.35, 20, color_earlyfull,"filled");
text(-2.9, -0.35, 'Neuropil','FontSize',9)
scatter(-3, -0.65, 20, 'k',"filled");
text(-2.9, -0.65, 'Dextran','FontSize',9)

hold off;
% [AziRand,EleRand,colorlist] = randomizeScatter(linmapAzi_early,linmapEle_early,lindexAzi_early,lindexEle_early,color_earlyfull,color_earlydex);
% s1 = scatter(AziRand,EleRand,2,colorlist,"filled");
% s1.MarkerFaceAlpha = 0.05;
xlim([-pi,0]);
ylim([-pi,0]);
title('Early');
pbaspect([6.5,4,1]);
set(gca,'Xtick',[]);
set(gca,'Ytick',[]);
box on;

subplot(2,2,4)
%s1 = scatter(linmapAzi_late,linmapEle_late,2,color_latelite,"filled");
s1 = scatter(linmapAzi_late,linmapEle_late,2,color_latefull,"filled");
s1.MarkerFaceAlpha = 0.05;
hold on;
s2 = scatter(lindexAzi_late,lindexEle_late,2,color_latedex,"filled");
s2.MarkerFaceAlpha = 0.05;
s2.MarkerFaceAlpha = 0.2;

%make legend
scatter(-3, -0.35, 20, color_latefull,"filled");
text(-2.9, -0.35, 'Neuropil','FontSize',9)
scatter(-3, -0.65, 20, 'k',"filled");
text(-2.9, -0.65, 'Dextran','FontSize',9)

hold off;
% [AziRand,EleRand,colorlist] = randomizeScatter(linmapAzi_late,linmapEle_late,lindexAzi_late,lindexEle_late,color_latefull,color_latedex);
% s1 = scatter(AziRand,EleRand,2,colorlist,"filled");
% s1.MarkerFaceAlpha = 0.05;
xlim([-pi,0]);
ylim([-pi,0]);
title('Late');
pbaspect([6.5,4,1]);
set(gca,'Xtick',[]);
set(gca,'Ytick',[]);
box on;

titletext = "RF phase values";
sgtitle(titletext);



%% plot binned histograms

Xdex2d_Early = histcounts2(lindexAzi_early,lindexEle_early, Xedges,Yedges,'Normalization','probability');
Xnp2d_Early = histcounts2(linmapAzi_early,linmapEle_early, Xedges,Yedges,'Normalization','probability');
Xdex2d_Late = histcounts2(lindexAzi_late,lindexEle_late, Xedges,Yedges,'Normalization','probability');
Xnp2d_Late = histcounts2(linmapAzi_late,linmapEle_late, Xedges,Yedges,'Normalization','probability');


Xdex_Early = reshape(Xdex2d_Early,1,[]);
Xnp_Early = reshape(Xnp2d_Early,1,[]);
Xdex_Late = reshape(Xdex2d_Late,1,[]);
Xnp_Late = reshape(Xnp2d_Late,1,[]);


%plot binned histograms
img2 = figure(2);
set(gcf, 'Position',  [700, 100, 800, 600]);
subplot(2,2,1)
plothistbins(Xnp2d_Early);
title('Early Neuropil');

subplot(2,2,2)
plothistbins(Xdex2d_Early);
title('Early Dextran');

subplot(2,2,3)
plothistbins(Xnp2d_Late);
title('Late Neuropil');

subplot(2,2,4)
plothistbins(Xdex2d_Late);
title('Late Dextran');

titletext = 'Binned histograms';
sgtitle(titletext);



%% calculate histogram intersection match value


mEarly = histintersect_orig(Xdex_Early,Xnp_Early);
mLate = histintersect_orig(Xdex_Late,Xnp_Late);

disp(['Match value for Early is ' num2str(mEarly)]);

disp(['Match value for Late is ' num2str(mLate)]);




%% support functions

function m = histintersect_orig(XI,XJ)
%histogram intersection (original definition, returns value indicating
%match instead of distance (higher is better match, max 1)
m = sum(min(XI, XJ)) / sum(XI);
end


function [AziRand,EleRand,colorlist] = randomizeScatter(AziA,EleA,AziB,EleB,color1,color2)
%overlay scatterplot of 2 histograms

AziConcat = [AziA;AziB];
EleConcat = [EleA;EleB];

IDlist = [zeros(length(AziA),1);ones(length(AziB),1)];

indexlist = randperm(length(AziConcat));

IDlist_perm = IDlist(indexlist);
AziRand = AziConcat(indexlist);
EleRand = EleConcat(indexlist);

colorlist = zeros(length(AziRand),3); % List of rgb colors for every data point.
for i = 1:length(IDlist_perm)
    if ~IDlist_perm(i)
        colorlist(i,:) = color1;
    else
        colorlist(i,:) = color2;
    end
end
end



function plothistbins(histogram)

imagesc(transpose(histogram),[0 0.01]);
colormap(hot);
set(gca, 'YDir','normal');
pbaspect([6.5 4 1]);
axis off;
%colorbar;

end

