function GFig7Visual( Az_mean, axes_Plot, axes_Distribution,  current_data, BaselineVal, IDX, XLimit, tolerantBar)
%GFIG1VISUAL Summary of this function goes here
%   Detailed explanation goes here
StepSize = 10;
% NewData, currently hard coded

% define x and y hardcoded
y = Az_mean;
y = y(1:current_data);
PointsNum = length(y);
% define step size with steps
Steps = StepSize*(1 : PointsNum);
x = Steps;
% fit the learning curve
[FitResult, ~] = FitLearningCurve(x, y, 1);

pi_x = predint(FitResult,x);

% XLimit = [0 600];
YLimit = [0.5 1];
% define the prediction steps
PredSteps = StepSize*(1 : XLimit(2)/StepSize);
x_pred  = PredSteps(PointsNum:end);
pi_pred = predint(FitResult,PredSteps);
pi_pred = pi_pred(PointsNum:end, :);

% evaluate fit result
PredVal = feval(FitResult,PredSteps);

CurrentPerformance = y(current_data);
% Current Baseline Samples
FindBaselineSample = find(PredVal>BaselineVal);

% Create axes
set(axes_Plot,...
    'YGrid','on','XGrid','on',...
    'GridLineStyle','-.',...
    'FontSize',16,...
    'xlim', XLimit, 'ylim', YLimit);
box(axes_Plot,'on');
hold(axes_Plot,'all');

% Create plot
CurvePlotHandle = plot(PredSteps,PredVal);
set(CurvePlotHandle,  'Parent', axes_Plot, ...
    'LineWidth',2,'Color',[1 0 0],...
    'DisplayName','Fitted Curve');

% Create dot of true data

DotPlotHandle = plot(1:10:current_data*StepSize, Az_mean(1:current_data));
set(DotPlotHandle, 'Parent', axes_Plot, ...
    'MarkerFaceColor',[0 0 1],'MarkerSize',4,'Marker','o',...
    'LineStyle','none',...
    'Color',[0.078 0.17 0.55],...
    'DisplayName','Observed Data');

% Create multiple lines using matrix input to plot
PIHandle = plot(x,pi_x,'LineWidth',2,'LineStyle','--',...
    'Color',[0 0.5 0]);
set(PIHandle, 'Parent', axes_Plot);
set(PIHandle(1),'DisplayName','95% Prediction Interval');

% Create multiple lines using pred matrix to plot
PIHandle_Pred = plot(x_pred,pi_pred,'LineWidth',2,'LineStyle','--',...
    'Color',[0.8 0.5 0]);
set(PIHandle_Pred, 'Parent', axes_Plot);
set(PIHandle_Pred(1),'DisplayName','95% Prediction Interval');

BaselineHandle = line(XLimit, [BaselineVal BaselineVal]);
set(BaselineHandle, 'Parent', axes_Plot, ...
    'LineWidth',2,'Color',[0.5 0 0],...
    'DisplayName','Baseline Performance');


%% plot axe distribute plot
set(axes_Distribution,...
    'YGrid','on','XGrid','on',...
    'GridLineStyle','-.',...
    'FontSize',16);

load('LDA_distribution.mat');

data = DataDistribution{IDX};

max_xlim = max(data);
min_xlim = min(data);
step_resolution = 1; 

% get the x values for the axes to build non-parametric distribution
x_values = min_xlim : 0.1 : max_xlim;
pd = fitdist(data,'Kernel','Kernel','normal');
Y = pdf(pd,x_values);   % get y for current plot
% Set the tolerance sample for an accurate prediction
ToleranceSample = round(mean(pd) * StepSize);

% hard code the sample size step
sample_step =StepSize;
current_data = current_data * sample_step;
if isempty(FindBaselineSample)
    pred_basenum = 60;
else
    pred_basenum = FindBaselineSample(1);
end

X = sample_step * x_values;
% draw the distribution of fitted curve
plot(X ,Y, 'DisplayName','Sample Dist.', ...
    'LineWidth',4,'Color',[0 0 1], ...
    'Parent',axes_Distribution);

predictedLineHandle = line([pred_basenum*sample_step pred_basenum*sample_step],get(axes_Plot,'YLim'), ...
      'LineWidth',2,'Color',[0.1 0.1 0.5], ...
      'DisplayName',['Predict Sample Reach Baseline=' num2str(pred_basenum*sample_step)], ...
      'Parent',axes_Plot);
 
line([tolerantBar*sample_step tolerantBar*sample_step],get(axes_Distribution,'YLim'), ...
      'LineWidth',2,'Color',[1 0 0], ...
      'DisplayName',['Maximun Tolerate Sample='  num2str(tolerantBar*sample_step)], ...
      'Parent',axes_Distribution);
  
% Create title
TitleStr = ['Sample Distribution For' ...
            num2str(current_data) ' Samples'];
title({TitleStr},'FontSize',16, 'Parent',axes_Distribution);
  
% Create xlabel
xlabel('Sample Size', 'Parent',axes_Distribution);

% Create ylabel
ylabel('Sample Distribution', 'Parent',axes_Distribution);

% Create legend
legend(axes_Distribution,'show');

%% plot left column
% Create xlabel
xlabel('Sample Size','FontSize',16, 'Parent', axes_Plot);

% Create ylabel
YLabelStr = ['Performance ' '(Az-score)'];
ylabel(YLabelStr,'FontSize',16, 'Parent', axes_Plot);

% Create title
TitleStr = ['Fitting Based On ' ...
            num2str(PointsNum) ' Points'];
title({TitleStr},'FontSize',16, 'Parent', axes_Plot);

% Create legend
CurveLegendHandle = legend([DotPlotHandle, CurvePlotHandle, ...
                           PIHandle_Pred(1), predictedLineHandle]);
set(CurveLegendHandle,'Location','SouthEast');

end

