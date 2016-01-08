function GFig2Visual( axes_Plot,  current_data)
%GFIG1VISUAL Summary of this function goes here
%   Detailed explanation goes here
StepSize = 10;
% NewData, currently hard coded
Az_mean = [];
load('simulated_result.mat')
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

XLimit = [0 800];
YLimit = [0.5 1];
% define the prediction steps
PredSteps = StepSize*(1 : XLimit(2)/StepSize);
x_pred  = PredSteps(PointsNum:end);
pi_pred = predint(FitResult,PredSteps);
pi_pred = pi_pred(PointsNum:end, :);

% evaluate fit result
PredVal = feval(FitResult,PredSteps);

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
DotPlotHandle = plot(1:10:600, Az_mean);
set(DotPlotHandle, 'Parent', axes_Plot, ...
    'MarkerFaceColor',[0 0 1],'MarkerSize',4,'Marker','o',...
    'LineStyle','none',...
    'Color',[0.078 0.17 0.55],...
    'DisplayName','Ground Truth Performance');

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

% Create xlabel
xlabel('Sample Size','FontSize',16);

% Create ylabel
YLabelStr = ['Performance ' '(Az-score)'];
ylabel(YLabelStr,'FontSize',16);

% Create title
TitleStr = ['Fitting Based On ' ...
            num2str(PointsNum) ' Points'];
title({TitleStr},'FontSize',16);

% Create legend
CurveLegendHandle = legend([DotPlotHandle, CurvePlotHandle, ...
                           PIHandle_Pred(1)]);
set(CurveLegendHandle,'Location','SouthEast');

end

