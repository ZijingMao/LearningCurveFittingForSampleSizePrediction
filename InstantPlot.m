function [CurrentPerformance, handles] = InstantPlot( handles, Simulated )

% selected the algorithm value
AlgorithmVal = get(handles.popupmenu_FittingAlgorithm,'Value');
% selected the baseline threshold
BaselineVal = str2double(getCurrentPopupString(handles.popupmenu_Baseline))/100;
% Step size, currently hard coded
StepSize = handles.StepSize;
% get current y
y = cell2mat(handles.Pref_Alg);
% if simulated data then we use the following code
if Simulated
    handles.Pref_AlgID = get(handles.popupmenu_TrainingAlgorithm,'Value');
    current_data = handles.current_data;
    % NewData, currently hard coded
    Az_mean = [];
    load('simulated_result.mat')
    % define x and y hardcoded
    y = Az_mean;
    y = y(1:current_data);
end
PointsNum = length(y);
% define step size with steps
Steps = StepSize*(1 : PointsNum);
x = Steps;
% fit the learning curve
[FitResult, GOF] = FitLearningCurve(x, y, AlgorithmVal);
pi_x = predint(FitResult,x);
% hard code x limit and y limit
if handles.xlimit_top <= (handles.current_data + 1) * handles.StepSize
    handles.xlimit_top = handles.current_data * handles.StepSize * 2;
end
XLimit = [0 handles.xlimit_top];
YLimit = [0.5 1];
% define the prediction steps
PredSteps = StepSize*(1 : XLimit(2)/StepSize);
x_pred  = PredSteps(PointsNum:end);
pi_pred = predint(FitResult,PredSteps);
pi_pred = pi_pred(PointsNum:end, :);

% evaluate fit result
PredVal = feval(FitResult,PredSteps);

% clear current axes
cla(handles.axes_Plot);
% Create axes
set(handles.axes_Plot,...
    'YGrid','on','XGrid','on',...
    'GridLineStyle','-.',...
    'FontSize',16,...
    'xlim', XLimit, 'ylim', YLimit);
box(handles.axes_Plot,'on');
hold(handles.axes_Plot,'all');

% Create plot
CurvePlotHandle = plot(PredSteps,PredVal);
set(CurvePlotHandle, 'Parent', handles.axes_Plot, ...
    'LineWidth',2,'Color',[1 0 0],...
    'DisplayName','Fitted Curve');

% Create baseline
BaselineHandle = line(XLimit, [BaselineVal BaselineVal]);
set(BaselineHandle, 'Parent', handles.axes_Plot, ...
    'LineWidth',2,'Color',[0.5 0 0],...
    'DisplayName','Baseline Performance');

% Create dot of true data
DotPlotHandle = plot(x,y);
set(DotPlotHandle, 'Parent', handles.axes_Plot, ...
    'MarkerFaceColor',[0 0 1],'MarkerSize',4,'Marker','o',...
    'LineStyle','none',...
    'Color',[0.078 0.17 0.55],...
    'DisplayName','Observed Data');

% Create multiple lines using matrix input to plot
PIHandle = plot(x,pi_x,'LineWidth',2,'LineStyle','--',...
    'Color',[0 0.5 0]);
set(PIHandle, 'Parent', handles.axes_Plot);
set(PIHandle(1),'DisplayName','95% Prediction Interval');

% Create multiple lines using pred matrix to plot
PIHandle_Pred = plot(x_pred,pi_pred,'LineWidth',2,'LineStyle','--',...
    'Color',[0.8 0.5 0]);
set(PIHandle_Pred, 'Parent', handles.axes_Plot);
set(PIHandle_Pred(1),'DisplayName','95% Prediction Interval');

% Create xlabel
xlabel('Sample Size','FontSize',16);

% Create ylabel
YLabelStr = ['Performance ' '(Az-score)'];
ylabel(YLabelStr,'FontSize',16);

% Create title
TitleStr = ['Learning Curve Fitting Based On ' ...
            num2str(PointsNum*StepSize) ' Samples'];
title({TitleStr},'FontSize',16);

% Create legend
CurveLegendHandle = legend([DotPlotHandle, CurvePlotHandle, ...
                           BaselineHandle, ... PIHandle(1),
                           PIHandle_Pred(1)]);
set(CurveLegendHandle,'Location','SouthEast');

% Update text on Result panel (if gof not good, color red)
FitResultChar = cfit2str(FitResult);
% GofResultChar = evalc('GOF');
% Current Performance
CurrentPerformance = y(handles.current_data);
% Current Baseline Samples
FindBaselineSample = find(PredVal>BaselineVal);
if ~isempty(FindBaselineSample)
    if FindBaselineSample(1) <= handles.current_data
        RequiredSampleMsg = 'You have reached the baseline.';
    else
        RequiredSampleMsg = ['May require ' ...
            num2str((FindBaselineSample(1)-handles.current_data)*StepSize) ...
            ' to reach the baseline'];
    end
else
    FindBaselineSample = -1; % negative means no baseline predict available
    RequiredSampleMsg = ['Could not reach baseline within ' num2str(PredSteps(end)) 'samples'];
end

% Update the distribution axes
% if simulated use simulated data
% if Simulated
    % hard code data
%     load('simulated_distribution.mat');
%     if CurrentPerformance >= 0.7 && CurrentPerformance < 0.75
%         CurrentDistribution = Data70_75;
%     elseif CurrentPerformance >= 0.75 && CurrentPerformance < 0.8
%         CurrentDistribution = Data75_80;
%     elseif CurrentPerformance >= 0.8 && CurrentPerformance < 0.85
%         CurrentDistribution = Data80_85;
%     elseif CurrentPerformance >= 0.85 && CurrentPerformance < 0.9
%         CurrentDistribution = Data85_90;
%     elseif CurrentPerformance >= 0.90 && CurrentPerformance < 0.95
%         CurrentDistribution = Data90_95;
%     else
%         CurrentDistribution = Data95_100;
%     end
%     PlotDistribution(CurrentDistribution, handles.current_data, handles, true);
    
% else
    % hard code with loaded data
    DataDistribution = [];
    load('LDA_distribution.mat');
    SelectedDataIdx = get(handles.popupmenu_Baseline,'Value');
    [p_value, handles] = PlotDistribution( DataDistribution{SelectedDataIdx}, ...
        FindBaselineSample(1), handles.current_data, handles, false );
    % update the p-value of current data
    if p_value == -1
        CurrentPValueInfo = 'Not enough data, could not predict.';
    else
        CurrentPValueInfo = ['You beat ' num2str(round(p_value * 100)) ...
            '% of people to reach ' num2str(BaselineVal) '.'];
        if p_value <= 0.05
            if handles.ToleranceSample <= handles.current_data * handles.StepSize
                CurrentPValueInfo = [CurrentPValueInfo ...
                    ' Suggest stop.'];
            else
                CurrentPValueInfo = [CurrentPValueInfo ...
                    ' May not reach baseline in ' ...
                    num2str(handles.ToleranceSample) ' samples'];
            end
        end
    end
    
% end

% show current best algorithm
all_training_algorithm = get(handles.popupmenu_TrainingAlgorithm, 'string');
best_training_algorithm = all_training_algorithm{handles.Pref_AlgID};

set(handles.text_Result, 'string', {['f(x) = ' FitResultChar]; 
    ['Best Algorithm: ' best_training_algorithm]; ...
    ['Current Performance: ' num2str(CurrentPerformance)]; ...
    ['Current Sample: ' num2str(handles.current_data*StepSize)]; ...
    RequiredSampleMsg; ...
    CurrentPValueInfo});

% Update the Information table
FitType = type(FitResult);
handles.UItableData{1} = TitleStr;
handles.UItableData{2} = getCurrentPopupString(handles.popupmenu_XData);
handles.UItableData{3} = FitType;
handles.UItableData{4} = GOF.sse;
handles.UItableData{5} = GOF.rsquare;
handles.UItableData{6} = GOF.dfe;
handles.UItableData{7} = GOF.adjrsquare;
handles.UItableData{8} = GOF.rmse;
set(handles.uitable_Result, 'Data', handles.UItableData);

end

