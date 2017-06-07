
experiments=getExperimentsAnd({'MT', 'simultaneous'});

regenerateModelComparisonFiles=true;
% experiments = {'n20150306c'};
parfor kExperiment=1:numel(experiments)
    exname=experiments{kExperiment};
    mstruct=mtlipglm();
    mstruct.overwrite=false;
    mstruct.nFolds=5;
    mstruct.regressionMode='RidgeGroupCV';
    mstruct.binSize=10;
    mstruct.modelDir=fullfile('data','glmFitsMain5');
    mstruct.getExperiment(exname)
	mstruct.buildTrialStruct('IncludeContrast', true, 'MotionEpoch', true, 'MTsim', false);
    for k=1:numel(mstruct.trial)
        mstruct.trial(k).gaborContrast=mstruct.trial(k).contrasts;
    end
    
    for kNeuron=1:numel(mstruct.neurons)
        if ~mstruct.neurons(kNeuron).isMT % skip
            continue
        end
        fname=fullfile(mstruct.modelDir, [mstruct.neurons(kNeuron).getName 'modelComparison.mat']);
        
        if exist(fname, 'file')&&~mstruct.overwrite&&~regenerateModelComparisonFiles
            fprintf('\n\n\nSkipping [%s] \n\n\n\n\n', fname)
            continue
        else
            g=fitAllModels(mstruct,kNeuron,true,1:4,'instantaneousCoupling', true, 'rho', [.8 1 2 5 10 20]);
            P=mstruct.modelComparisonToo(g);
            parsave(fname, P,'-v7')
        end
        
    end
end

pushMessage('Done running cmdFitModels.m')
