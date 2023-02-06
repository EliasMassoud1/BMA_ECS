%% This script tests the ECS BMA test for the work shown in Massoud et al., 2023
clearvars; close all; clc

%  model names
model_string = {'ACCESS-CM2','ACCESS-ESM1-5','BCC-CSM2-MR','CanESM5', 'EC-Earth3','FGOALS-g3','GFDL-ESM4','INM-CM4-8' ,...
                'INM-CM5-0','IPSL-CM6A-LR','MIROC6','MPI-ESM1-2-HR' , 'MPI-ESM1-2-LR','MRI-ESM2-0','NorESM2-LM','NorESM2-MM'} ;
            
% Define CMIP6 ECS Values
model_ECS = [4.66    3.88    3.02    5.64    4.26    2.87    3.89    1.8300    1.9200    4.7    2.6    2.9800    3.02    3.13    2.56    2.49];

% What is the target ECS
target_ECS = 3.0 ; 

% Load ECS Target Distribution
load ECS_Target_Values.mat
truth_data_synthetic = ECS_Target_Values;

% Fit Gamma distribution to synthetic ECS data - need distribution information for later 
pd = fitdist( truth_data_synthetic' , 'gamma' ); % Provides gamma distribution paramters a and b (pd.a and pd.b)

% Generate gamma pdf for target ECS
ECS_pd_synthetic = pdf('gam', truth_data_synthetic , pd.a,pd.b);
ECS_pd_synthetic_norm = ECS_pd_synthetic / max( ECS_pd_synthetic);

%% BMA settings

% Load information in A*x=b setup
A = model_ECS;
b = target_ECS;

% Parameters?
n_sample = 15000;
n_posterior = n_sample*(2/3); % 66% Represents the 'Likely' value of ECS

% Save or load model weight samples

% Option 1: Generate sample of weights and normalize, and save if needed
% x = rand(n_sample, length(model_string) ).^8;
% x_pars = x./sum(x,2);
% save x_pars.mat x_pars

% Option 2: Load previously generated samples for reproducibility
load x_pars_15000.mat  % load x_pars.mat 

% pre-allocate
b_BMA = nan( length(b) , n_sample ) ; % This will be the estimated ECS from the BMA average
ECS_lik_BMA = nan( 1 , n_sample ); % This will be the likelihood value of the estimated ECS from the BMA average

%% Apply BMA to estimate model weights 

% Estimate BMA likelihood
for i = 1:n_sample    
    % Create model
    b_BMA(:,i) = A*x_pars(i,:)';    
    % Get likelihood of BMA sample
    ECS_lik_BMA(i) = pdf('gam', b_BMA(:,i) , pd.a,pd.b);  
end

% What is maximum likelihood?
lik_best_bma = max(ECS_lik_BMA);

% What model weights produce maximum likelihood?
id_best_bma_lik = find( ECS_lik_BMA == lik_best_bma);
best_BMA_combo_lik = x_pars(id_best_bma_lik,:);

% Sort likelihood values
sort_lik_BMA = sort(ECS_lik_BMA,'descend');

% Pre-allocate Posterior matrix
id_post_bma_lik = nan( 1 , n_sample ) ;
post_BMA_combo_lik = nan( n_sample , length(A) );

% Extract Posterior information
for i = 1:n_sample
    % Locate next posterior value
    id_post_bma_lik(i) = find( ECS_lik_BMA == sort_lik_BMA(i));
    % Load next posterior value
    post_BMA_combo_lik(i,:) = x_pars(id_post_bma_lik(i),:);
end

% What are posterior weights
posterior_BMA_combo_lik = post_BMA_combo_lik(1:n_posterior,:); 
% Create posterior BMA model
b_post_BMA_lik = A*posterior_BMA_combo_lik';

% What are mean of posterior weights
mean_posterior_BMA_combo_lik = mean(posterior_BMA_combo_lik);

%% Independence information 

% Using correlation of posterior samples 
corr_BMA_samples = corr(posterior_BMA_combo_lik) ; % Correlation of posterior samples
sum_corr_BMA_samples = sum( corr_BMA_samples ); 
% Independence = -(sum(correlation_values))
I_BMA_samples = sum_corr_BMA_samples*-1;   