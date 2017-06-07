dataPath = 'D:\mtlip_data_share\';

% get list of experiments to choose from
experimentList = getExperimentsAnd({'good', 'simultaneous'});
disp(experimentList(:))


%% Load up an experiment
exname='p20130611';

mstruct=mtlipglm(exname, dataPath);
mstruct.buildTrialStruct('IncludeContrast', true, 'MotionEpoch', true);

%% plot sample trials
figure(1); clf
mstruct.plotTrial

figure(2); clf
mstruct.neurons(1).plotTaskGeometry

%% Plot choice sorted PSTH for each neuron
figure(3); clf
sp = ceil(sqrt(numel(mstruct.neurons)));

for kNeuron = 1:numel(mstruct.neurons)
    subplot(sp,sp,kNeuron)
    neuronName = mstruct.neurons(kNeuron).getName(0);
    mstruct.plotChoPSTH(neuronName, 'motionon', 'smoothing', 100)
    title(sprintf('%d: %s', kNeuron, neuronName))
    xlim([-100 1e3])
end

%% Choose an example neuron to fit
kNeuron=1;

% initialize neuroGLM
n=glmspike('example');


g.setDesignOptions('binSize', mstruct.binSize, 'boxcarPulse', true);
% g.setDesignOptions('orthogonalizeBases', true)
% g.setDesignOptions('normalizeBases', false)
% g.setDesignOptions('boxcarPulse', false);
% g.setDesignOptions('MTsim', 1)
% g.setDesignOptions('includeChoice', true);
                
                
g.param=mstruct.trialParam;
g.fitNeuron=mstruct.neurons(kNeuron).getName(0);
params=[300 0 0 0];
g.buildDesignBoxcar(mstruct.trial, params(1), params(2), params(3), params(4));
% iix=90+(1:100);

iix=1:numel(mstruct.trial);
g.compileDesignMatrix(mstruct.trial(iix), 1:numel(iix))
g.zscoreDesignMatrix()
g.addBiasColumn('right')
g.model.regressionMode='RidgeFixed';
% g.model.regressionMode='grouplasso';
                
y=g.getBinnedSpikeTrain(mstruct.trial(iix), g.fitNeuron, 1:numel(iix));
labels={g.covar.label};
% regInds=strncmp(labels, 'Inter', 5) | strncmp(labels, 'MT', 2) | ...
% strncmp(labels, 'Same', 2) | strcmp(labels, 'Pulse') | strcmp(labels, 'Motion');
regInds=strncmp(labels, 'Inter', 5) | strncmp(labels, 'Intra', 5);
colInds=g.getDesignMatrixColIndices(labels(regInds));
% colInds=g.getDesignMatrixColIndices(labels);
kfit=regression.doRegressionPoisson(g.dm.X, y, g, [], .01, .8, colInds);


%%
close all
win=[-50 200]; % assuming 10ms bins


sm=10; % 50ms smoothing
smrate=smooth(full(y),sm)/.01;

[cohp, psthT]=computeCohPSTH(smrate, g, mstruct.trial(iix), win);

figure(20); clf
plot(psthT, cohp, '.'); hold on




% lambda=g.cvPredictRate(m.trial);
xproj=g.dm.X*kfit.khat;
lambda=kfit.fnlin(xproj);
figure(221); clf
try
plot(empiricalNonlinearity((y), xproj, 100))
end
figure(10); clf
smrateM=smooth(lambda,sm);
[cohpM, psthT]=computeCohPSTH(smrateM, g, mstruct.trial(iix), win);
plot(psthT, cohpM, '-')
rsquared(cohp, cohpM)
figure(21); clf
cf='motionon';
plot(computeChoPSTH(smrate, g, mstruct.trial(iix), cf, win*10), '.'); hold on
plot(computeChoPSTH(smrateM, g, mstruct.trial(iix), cf, win*10), '-')

g.plotWeights(kfit.khat)

figure(22); clf
subplot(131)
pta=computePTA(smrate, g, mstruct.trial(iix), 3, [-100 2000], 100);
plot(pta)
subplot(132)
ptaM=computePTA(smrateM, g, mstruct.trial(iix), 3, [-100 2000], 100);
plot(ptaM)
subplot(133)
plot(pta(:), '.'); hold on
plot(ptaM(:))

rsquared(pta,ptaM)
%%
% Mcohp=computeCohPSTH(smrate, g, m.trial, win);
% [pta, ptaT]=computePTA(smrate, g(kModel), obj.trial, 0, [-20 300], 100);
% ptaCorr=computePTA(smrate, g(kModel), obj.trial, 1, [-20 300], 100);
% ptaCho=computePTA(smrate, g(kModel), obj.trial, 2, [-20 300], 100);
                

figure(1); clf
set(gcf, 'DefaultAxesColorOrder', lines(8))
plot(Mcohp, '-')
hold on
plot(cohp, 'o')


g.plotWeights(g.modelfit(1))


