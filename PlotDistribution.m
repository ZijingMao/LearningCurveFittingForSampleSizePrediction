function [p_value, handles] = PlotDistribution( data, pred_basenum, CurrentSample, handles, Simulated )

% clear current axes
cla(handles.axes_Distribution);
set(handles.axes_Distribution, 'FontSize', 8);
box(handles.axes_Distribution,'on');
hold(handles.axes_Distribution,'all');

% get the upper and lower bound of current data distribution   
max_xlim = max(data);
min_xlim = min(data);
step_resolution = 1; 

% get the x values for the axes to build non-parametric distribution
x_values = min_xlim : 0.1 : max_xlim;
pd = fitdist(data,'Kernel','Kernel','normal');
Y = pdf(pd,x_values);   % get y for current plot
% Set the tolerance sample for an accurate prediction
handles.ToleranceSample = round(mean(pd) * handles.StepSize);

% hard code the sample size step
sample_step =handles.StepSize;
CurrentSample = CurrentSample * sample_step;

if Simulated
    % draw the histogram
    [N, X] = hist(data, min_xlim:step_resolution:max_xlim, ...
                    'Parent',handles.axes_Distribution);
    dist_sample = N / length(data);
    X = sample_step * X;
    % draw the distribution
    bar(X, dist_sample, 'DisplayName','Sample Dist.', ...
        'Parent',handles.axes_Distribution, ...
        'EdgeColor','none');
    % calculate p-value
    p_value = 1-cdf(pd,CurrentSample / sample_step);
else
    % if no prediction could reach the base line
    if pred_basenum == -1
        if CurrentSample > handles.ToleranceSample
            CurrentSample = max_xlim * sample_step;
            p_value = 0;
        else
            p_value = -1;
        end
    else
        % calculate p-value
        p_value = 1-cdf(pd, pred_basenum);
    end
end


X = sample_step * x_values;
% draw the distribution of fitted curve
plot(X ,Y, 'DisplayName','Sample Dist.', ...
    'LineWidth',4,'Color',[0 0 1], ...
    'Parent',handles.axes_Distribution);

line([pred_basenum*sample_step pred_basenum*sample_step],get(handles.axes_Distribution,'YLim'), ...
      'LineWidth',2,'Color',[1 0 0], ...
      'DisplayName','Curr. Sample #', ...
      'Parent',handles.axes_Distribution);

% Create title
TitleStr = ['Sample Distribution For' ...
            num2str(CurrentSample) ' Samples'];
title({TitleStr},'FontSize',8, 'Parent',handles.axes_Distribution);
  
% Create xlabel
% xlabel('Sample Size', 'Parent',handles.axes_Distribution);

% Create ylabel
% ylabel('Sample Distribution', 'Parent',handles.axes_Distribution);

% Create legend
% legend(handles.axes_Distribution,'show');

end

