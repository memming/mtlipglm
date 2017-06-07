function neurons = getNeurons(exname, dataDir)
% GETNEURONS gets spike times and meta data for experiment <exname>
% INPUT: 
% 	exname   <char>  experiment name
%   dataDir  <path>  full path to data
% OUPUT:
% 	neurons <neuro>  array of neuron objects
%
% EXAMPLE CALL
% 	neurons = getNeurons('p20140304', './data');

fl = dir(fullfile(dataDir, 'neurons', [exname '*']));

if isempty(fl)
    neurons = [];
    return
end

for k = 1:numel(fl)
    neurons(k) = neuro(fullfile(dataDir, 'neurons', fl(k).name));
end