addpath(fullfile(pwd, 'code'))
addpath(fullfile(pwd, 'code', 'dependencies'))
addpath(fullfile(pwd, 'analysis_scripts'))

% this is where your data live
dataPath = '';
setpref('mtlipglm', 'dataPath', dataPath)

% neuroGLM - must be downloaded from https://github.com/jcbyts/neuroGLM
neuroGLMpath = '';
addpath(neuroGLMpath)

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