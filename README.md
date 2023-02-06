# BMA_ECS
Code to apply BMA on CMIP6 model estimates of ECS

This folder contains code (.m) used to run the analysis from Massoud et al., 2023. "Bayesian weighting of climate models based on climate sensitivity"

The code name is ECS_BMA_test.m and it performs the following things:
% Define CMIP6 ECS Values
% Load ECS Target Distribution
% Fit Gamma distribution to synthetic ECS data
% Loads BMA settings
% Apply BMA to estimate model weights 
    % Estimate BMA likelihood
    % Determine what model weights produce maximum likelihood
    % Extract Posterior information
% Using correlation of posterior samples, estimate Independence information 

The desired metrics will be stored under:
% Mean BMA posterior weights = 'mean_posterior_BMA_combo_lik'
% BMA posterior weights = 'posterior_BMA_combo_lik'
% Independence information = 'I_BMA_samples'