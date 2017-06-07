# MT LIP GLM

This Repo provides MATLAB code for the analyses in Yates et al. (2017)

## Getting started / installation

### Installing the code

Create a local copy of mtlipglm by cloning or downloading a zip

```
	git clone https://github.com/jcbyts/mtlipglm
```

You will also need the `classy` branch of neuroGLM code

```
	git clone https://github.com/jcbyts/neuroGLM
	git checkout classy
```

### Getting the data
The code will not run without local copies of the data. To quickly reproduce figures from the manuscript requires both the data and the fitted GLMs. Because all the data and fits takes up a fair amount of disk space, there are a number of options.

1. [neurons, stimulus (with eye position)](https://www.dropbox.com/s/ix7vtrid2rlfuyx/mtlipglm_data_full.zip?dl=0)
2. [neurons, stimulus (no eye position data)](https://www.dropbox.com/s/0myzjnh5xy014pi/mtlipglm_data_small.zip?dl=0)
3. [LIP fits](https://www.dropbox.com/s/xc5n2wh02wsjhzg/mtlipglm_lip_fits.zip?dl=0)

You can download the data through #1 or #2 and then refit yourself, or download #3 as well for a quick reproduction of figure 5.

If you downloaded the fits, move main_fits and lip_trunc_fits to the directory where neurons and stim are. The mtlipglm code will assume that they are all in the same base directory.

### Before running
Note: this code has only been tested on MATLAB 2015b and newer.


### setup paths
Open Matlab. Change directories to mtlipglm. You need to set up the specific paths for your machine.

```matlab
edit addMTLIPpaths
```

Find the lines

```matlab
% this is where your data live
dataPath = '';
```

and

```matlab
% neuroGLM - must be downloaded from https://github.com/jcbyts/neuroGLM 
neuroGLMpath = '';
```

and enter the appropriate path locations for the base data directory and the neuroGLM repository.

run `addMTLIPpaths` and if setup correctly, then 

```matlab
ls(getpref('mtlipglm', 'dataPath'))
```
should show you the `neurons`, `stim`, `main_fits`, and `lip_trunc_fits` directories.

## Running the code

This repository can reproduce figure 5. It has all the fitting code for fixed hyperparameters. It also has an example script for exploring the data and creating new GLMs.

### Figure 5 b-f
If you have downloaded the fits, either run `figure05` or open it and run cell by cell. This will reproduce figure 5, panels b-f from the manuscript.

If you have not downloaded the fits, you will need to run `cmdFitLIP`. This will probably take some time (30min+) to refit all the required models with a fixed hyperparameter. Once this is completed running, you can run `figure05` to plot the results.

### Figure 5 g,h
To reproduce the effects of elongating the acausal portion of the pre-saccadic covariates, run `cmdFitLIPtrunc`. If you downloaded the fits, this will re-analyze them and produce the required data for plotting results. Otherwise, if will refit each model. You can adjust the number of truncation steps to make this faster.

### Example

To explore the data / try alternate GLM parameterizations,
```matlab
edit cmdExample.m
```

## Basic Overview

There are a few classes that govern the analyses in mtlipglm. 

Try running
```matlab
dataPath = getpref('mtlipglm', 'dataPath');
neurons = getNeurons('p20140304', dataPath)
```

You'll notice that `neurons` is an array of `neuro` objects. This is the most memory efficient way to access the neuron data. Each neuron file is an [hdf5](https://www.google.com/search?q=hdf5) file that includes many attributes about the unit under study (e.g., receptive field maps, waveform properties). Rather than load all of these files and atributes into memory, the `neuro` object can access each attribute when needed. To get the full struct for a neuron, just run

```matlab
n = neurons(1).getStruct;
```
or load the file directly. However, as mentioned, the code is going to use the `neuro` class, both because of its lazy access properties, but also because it has a number of useful methods for getting more info about the neuron. The `neuro` class has a property `stim` that similarly accesses the stimulus properties when needed.

The rest of the code revolves around two classes: `mtlipglm` and `glmspike` 

`glmspike` is an inherits `neuroGLM` and can be used the same way. It contains additional methods for setting up particular parameterizations of the basis functions, compiling the design matrix, and performing the fitting.

`mtlipglm` is the workhorse. It creates a `trial` structure that is required by `neuroGLM`. It sets up the specific `glmspike` objects for each GLM and fits them. It also has model comparison code to analyze the data.










