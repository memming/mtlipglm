addpath(fullfile(pwd, 'code'))
addpath(fullfile(pwd, 'code', 'dependencies'))
addpath(fullfile(pwd, 'analysis_scripts'))

% this is where your data live
dataPath = ''; % EDIT THIS LINE %%%%%%%%%%%%%%%%%%
if isempty(dataPath)
    error('dataPath must be specified');
end
setpref('mtlipglm', 'dataPath', dataPath)

% set neuroGLM path
neuroGLMpath = ''; % EDIT THIS LINE %%%%%%%%%%%%%%%%%%
if isempty(neuroGLMpath)
    error('neuroGLM - must be downloaded from https://github.com/jcbyts/neuroGLM');
end
addpath(neuroGLMpath)
if exist('neuroGLM') ~= 2
    error('neuroGLM path invalid');
end

% --- setup directory structure
if isdir(dataPath)
    fit_dir = fullfile(dataPath, 'main_fits');
    if ~isdir(fit_dir)
        mkdir(fit_dir)
    end
    
    fit_dir = fullfile(dataPath, 'lip_trunc_fits');
    if ~isdir(fit_dir)
        mkdir(fit_dir)
    end
end