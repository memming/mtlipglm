function S = loadUpFits(dataPath, tag)
% S = loadUpFits(dataPath, tag)

assert(isdir(dataPath), 'First argument must be the path to data')

nw = getAllNeurons(dataPath);

ixDprime = abs([nw(:).dPrimeSigned]) > .2;
ixLIP    = [nw(:).isLIP];

switch tag
    case 'MT'
        ix = ixDprime & ~ixLIP;
    case 'LIP'
        ix = ixDprime & ixLIP;
    otherwise
        ix = ixDprime;
end

nw(~ix) = [];

clear S
for k = 1:numel(nw)
    fname = fullfile(dataPath, 'main_fits', [nw(k).getName 'modelComparison.mat']);
    tmp = load(fname);
    S(k) = tmp.model;
end