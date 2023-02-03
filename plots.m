%% This script plots results for the Massoud et al., 2023



% % % % Error of mean BMA
% % % % Create model
% % % b_mean_BMA_lik = A*mean_posterior_BMA_combo_lik';
% % % res_mean_lik = b_mean_BMA_lik - b;
% % % ssr_mean_lik = sum( res_mean_lik.^2 );
% % % rmse_mean_BMA_lik = sqrt( ssr_mean_lik / length(b) );


%% Test distribution of BMA samples

% % Fit Gamma distribution
% pd_BMA = fitdist( b_post_BMA_lik' , 'gamma' ); 
% % Make test plots of the gamma pdf
% ECS_pd_BMA = pdf('gam', b_post_BMA_lik , pd_BMA.a,pd_BMA.b);
% ECS_pd_BMA_norm = ECS_pd_BMA / max(ECS_pd_BMA) ;
% 



%% Plots


%% Plot for presentation

close all

figure(3)
for i = 1
    
    
%     t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    t = tiledlayout(3,1,'TileSpacing','Compact','Padding','Compact');
    
%     % Each Model's ECS - histogram
%     ax1 = nexttile
%     histogram( model_ECS , 20 )
%     ylabel('Model Count')
%     xlabel('ECS')
%     title('CMIP6 ECS - histogram','fontsize', 18)
%     set(gca,'fontsize', 16)
    
    
    % Each Model's ECS - barplot
    ax2 = nexttile
    bar( model_ECS ); hold on
    yline(3,'r','Linewidth',2)
    axis([0 16.5 0 6])
    ylabel('ECS')
    title('ECS - Target and CMIP6 Models','fontsize', 18)
    set(gca,'xtick',[1:16],'xticklabel',model_string,'fontsize', 16)
    legend('CMIP6 Model ECS','Target ECS')
    
    
    
    % BMA distributions
    ax3 = nexttile   
    boxplot( posterior_BMA_combo_lik , 'boxstyle','filled','symbol',''); hold on;
    
%     plot(best_BMA_combo,'kx','MarkerSize',20)
%     plot(mean_posterior_BMA_combo,'rx','MarkerSize',20,'Linewidth',2)
    plot(mean_posterior_BMA_combo_lik,'r*','MarkerSize',20,'Linewidth',2)
    
% %     plot(best_BMA_combo,'ko','MarkerSize',20)
% %     plot(mean_posterior_BMA_combo,'ro','MarkerSize',20,'Linewidth',2)
%     plot(mean_posterior_BMA_combo_lik,'ro','MarkerSize',20,'Linewidth',2)

    title('BMA Weights','fontsize', 18)
    ylabel('Model Weight','fontsize', 18)
    set(gca,'xtick',[1:16],'xticklabel',model_string,'fontsize', 16)
    % set(gca,'fontsize', 16)
%     legend('BMA best','BMA mean'); %,'Sanderson-h','Sanderson-c','Skill')
    legend('BMA mean'); %,'Sanderson-h','Sanderson-c','Skill')
    axis([0 16.5 0 0.3])
%     xtickangle(90)



    % Gmma distribution with target truth and each model
    %     ECS_pd_synthetic = pdf('gam', truth_data_synthetic , pd.a,pd.b);
    ax4 = nexttile
    % Add original ensemble distribution 
%     histogram( b_BMA, 'Normalization','pdf'); hold on
    [ plot_hist , edges_plot ] = histcounts( b_BMA, 'Normalization','pdf');
    plot_hist_norm = plot_hist/max(plot_hist);
%     plot( edges_plot(1:end-1), plot_hist_norm ,'b--','Linewidth',3); hold on
    bar( edges_plot(1:end-1), plot_hist_norm , 'c' ) ; hold on   % ,'b--','Linewidth',3); hold on
    % Gmma distribution with target truth
    plot(truth_data_synthetic, ECS_pd_synthetic_norm ,'k--','Linewidth',3); hold on
    % Throw in BMA
    plot(b_post_BMA_lik, ECS_pd_BMA_norm ,'r|','Markersize',5,'Linewidth',2)
    % Throw in BMA mean
    plot( b_mean_BMA_lik , 1.15 ,'r*','Markersize',20,'Linewidth',2)
    % Throw in Ensemble mean
    plot( mean(A) , 1.15 ,'b*','Markersize',20,'Linewidth',2)
    % Throw in Models
    plot( model_ECS , 1 ,'bx', 'Markersize',15,'Linewidth',2)
    
    
%     % Mark the Ensemble mean
%     plot( mean(A) , 0.95 ,'b+','Markersize',20,'Linewidth',2)
%     % Mark the BMA mean
%     plot( b_mean_BMA_lik , 0.95 ,'k+','Markersize',20,'Linewidth',2)

    title('ECS Distribution','fontsize', 18)
    xlabel('ECS')
    ylabel('Probability')
    legend('Full CMIP6 Distribution','Target Distribution','BMA Distribution','BMA mean','CMIP6 Ensemble Mean','Individual CMIP6 Models')
    axis([1 6 0 1.25])
    set(gca,'fontsize', 16)




end






%% Plots
  
% Create matrix for scatter plot figures
data(:,1) = model_ECS'; % CMIP6 model ECS
data(:,2) = mean_posterior_BMA_combo_lik'; % CMIP6 model BMA weight
data(:,3) = I_BMA_samples' ; % CMIP6 model Independence score

% Plot scatter plots of all results
figure(101)
subplot(3,1,1)
plot(data(:,1),data(:,2),'b+','Markersize',10,'Linewidth',2)
xlabel('ECS'); ylabel('BMA Weight')
legend('Individual CMIP6 Models')
 set(gca,'fontsize', 20)
subplot(3,1,2)
plot(data(:,2),data(:,3),'b+','Markersize',10,'Linewidth',2)
xlabel('BMA Weight'); ylabel('Dependence')
 set(gca,'fontsize', 20)
subplot(3,1,3)
plot(data(:,1),data(:,3),'b+','Markersize',10,'Linewidth',2)
xlabel('ECS'); ylabel('Dependence')
 set(gca,'fontsize', 20)
  
