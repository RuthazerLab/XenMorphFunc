%{

Code to read neuron reconstruction and use treestoolbox to calculate branch
len, spanning volume, Sholl analysis (data shown in Fig. 1 and Supplementary Fig. S1)

Requires TREES toolbox
https://www.treestoolbox.org/download.html

Neuron reconstructions shown in figure: 
'ns-bergamot-1-new.swc'
'ns-bergamot-2-new.swc'

%}

clearvars;

dataname = 'ns-bergamot-1-new.swc';




addpath('exampledata');

mytree = load_tree(dataname);


%cut off branches below 180um depth
%(skip if arbors do not go below 180um)

needspruning = false;
pruneZ = 75;

if needspruning
    mytree_pruned = pruneTreeAtDepth(mytree,pruneZ);
else
    mytree_pruned = mytree;
end

%microns per pixel (calibrated for microscope)
umpp_x = 0.481927711;
umpp_z = 2;


%convert pixel coords to um
mytree.X = mytree.X * umpp_x;
mytree.Y = mytree.Y * umpp_x;
mytree.Z = mytree.Z * umpp_z;


%calculate total branch length
treelen = sum(len_tree(mytree));

%calculate largest Euclidean distance in tree to perform Sholl analysis
eucl = eucl_tree (mytree);
treeEucl = max(eucl);
sholldd = linspace(0,2*(treeEucl+1),10);

shollvector_norm = sholl_tree(mytree,sholldd);
treesholl = sum(shollvector_norm);

shollvector = sholl_tree(mytree,20);

%calculate arbor field convex hull volume
%modified code from boundary_tree.m
c        = convexity_tree (mytree, '-3d');
S        = 1 - c; % Optimal shrink factor

X            = mytree.X;
Y            = mytree.Y;
Z            = mytree.Z;

[k, V]       = boundary (X, Y, Z, S);


disp(['Total branch length = ' num2str(treelen) ' μm']);
disp(['Dendrite spanning volume = ' num2str(V) ' μm^3']);
disp('Intersection counts for Sholl radius = 10μm');
disp(shollvector);


img1 = figure(1);
F            = gcf;
h            = trisurf (k, X, Y, Z);
rh           = reducepatch (h, 0.5);
rh.Vertices  = rh.vertices;
rh.Faces     = rh.faces;
bound        = rh;
bound.V      = V;

h.FaceAlpha = 0.5;
h.EdgeAlpha = 0;

hold on;

%plot the neuron tree
mytree.D = ones(length(mytree.D),1);
treeplot = plot_tree(mytree);

hold off;

set(gca,'DataAspectRatio',[1 1 1]);
set(gca,'XDir','reverse');
view(168,12);
view(180,90);
grid off






%support function to remove branches below specified depth

function mytree_pruned = pruneTreeAtDepth(mytree,pruneZ)

mytree_pruned = mytree;

if mytree.Z(1) > pruneZ
    disp "Warning: Root node is below prune depth! Abort pruning and return input tree"
end

pruneYN = 1;

while pruneYN

    nodesBelowCutoff = mytree_pruned.Z > pruneZ;
    nodeToPrune = find(nodesBelowCutoff,1);
    if isempty(nodeToPrune)
        pruneYN = 0;
        break
    end

    %prune tree at first node that's below cutoff depth
    %subtreeToPrune = sub_tree(mytree_pruned,nodeToPrune,'-s');
    subtreeToPrune = sub_tree(mytree_pruned,nodeToPrune);
    nodesToPruneIndices = find(subtreeToPrune);
    mytree_pruned = delete_tree(mytree_pruned,nodesToPruneIndices);

end

end

