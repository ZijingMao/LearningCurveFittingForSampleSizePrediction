function Visualization
%VISUALIZATION Summary of this function goes here

%% plot figure 1
% axes_handle = axes;
% GFig1Visual( axes_handle,  60);
for i = 1:3
    for j = 1:3
        axes_handle = subplot(3, 3, (i-1)*3+j);
        GFig1Visual( axes_handle, mean(All{(i-1)*3+j}, 2), LowerBound((i-1)*3+j), UpperBound((i-1)*3+j), 1, 0.5, name{(i-1)*3+j});
    end
end
% axes_Plot_Boost = axes;
% GFig1Visual( axes_Plot_Boost, mean(Driving_Boost, 2), 16, 115, 0.8, 0.6);

%% plot figure 2
for i = 1:2
    for j = 1:2
        axes_handle = subplot(2, 2, (i-1)*2+j);
        GFig2Visual( axes_handle,  5*2^((i-1)*2+j-1));
    end
end

%% plot figure 3
for i = 1:3
    for j = 1:3
        axes_handle = subplot(3, 3, (i-1)*3+j);
        GFig3Visual( axes_handle, mean(All{(i-1)*3+j}, 2), LowerBound((i-1)*3+j), UpperBound((i-1)*3+j), 500, 0, name{(i-1)*3+j});
    end
end

%% plot figure 4
for i = 1:3
    for j = 1:3
        axes_handle = subplot(3, 3, (i-1)*3+j);
        GFig2Visual( axes_handle, mean(All{(i-1)*3+j}, 2), LowerBound((i-1)*3+j), UpperBound((i-1)*3+j), 0.1, 0, name{(i-1)*3+j});
    end
end

%% plot figure 4.1
for i = 1:3
    for j = 1:3
        axes_handle = subplot(3, 3, (i-1)*3+j);
        GFig2_1Visual( axes_handle, mean(All{(i-1)*3+j}, 2), LowerBound((i-1)*3+j), UpperBound((i-1)*3+j), 0.2, 0, name{(i-1)*3+j});
    end
end

%% plot figure 5
for i = 1:3
    for j = 1:3
        axes_handle = subplot(3, 3, (i-1)*3+j);
        GFig5Visual( axes_handle, mean(All{(i-1)*3+j}, 2), LowerBound((i-1)*3+j), UpperBound((i-1)*3+j), ...
            500, 0, Performance(i), name{(i-1)*3+j}, 0.01933);
    end
end

%% plot figure 6
axes_Plot = subplot(3, 2, 1);
axes_Distribution = subplot(3, 2, 2);
Az_mean = [];
load('simulated_result.mat')
GFig7Visual( Az_mean,  axes_Plot, axes_Distribution,  16, 0.9, 5, [0 600], 27);
axes_Plot = subplot(3, 2, 3);
axes_Distribution = subplot(3, 2, 4);
GFig7Visual( Az_mean, axes_Plot, axes_Distribution,  55, 0.95, 6, [0 600], 55);
axes_Plot = subplot(3, 2, 5);
axes_Distribution = subplot(3, 2, 6);
Az_mean = [];
load('simulated_result2.mat')
GFig7Visual( Az_mean, axes_Plot, axes_Distribution,  55, 0.95, 6, [0 1500], 55);

%% plot < 0.85 > 0.75
A=[];
for j = 1:16
    Az = Az_WS_LDA{j};
[A{j}, ~] = find(Az>=0.80&Az<0.81);
end

B = [];
for i = 1:16
    B = [A{i}; B];
end

%% plot > 0.9
A = zeros(300, 16);
for j = 1:16
    Az = Az_WS_LDA{j};
    for idx = 1:300
        tmp = find(Az(:, idx)>0.95, 1);
        if ~isempty(tmp)
            [A(idx, j)] = tmp;
        end
    end
end
for i = 1:4
    for j = 1:4
        subplot(4, 4, (i-1)*4+j)
        hist(A(:, (i-1)*4+j), 1:1:60);
    end
end

C = reshape(A, [300*16, 1]);
hist(C, 1:1:60);
for j = 1:16
    Az = Az_WS_LDA{j};
    for idx = 1:300
        tmp = find(Az(:, idx)>0.9, 1);
        if ~isempty(tmp)
            [A(idx, j)] = tmp;
        end
    end
end

%% plot two
[bar_LT90, ~] = hist(C, 1:1:60);
[bar_BT8081, ~] = hist(B, 1:1:60);
bar(bar_LT90/length(C));
hold on
bar(bar_BT8081/length(B));

%% plot CI

for i = 1:4
    for j = 1:4
        subplot(4, 4, (i-1)*4+j)
        Az = Az_WS_LDA{(i-1)*4+j};
        Az_mean = mean(Az');
        y = Az_mean;
        x = 10:10:600;
        
        [fitresult, gof] = FitLearningCurve(x(1:30), y(1:30));
        pi = predint(fitresult,x);
        ci = zeros(60, 2);
        ci(:, 1) = max(Az');
        ci(:, 2) = min(Az');
        plot(fitresult,x,y); legend('location', 'southeast');
        hold on, plot(x,ci,'g:'), plot(x, pi, 'm--');
    end
end

%% LDA
Az = Az_WS_LDA;
for i = 1:16
    Az_WS_LDA{i} = cat(2, Az_WS_LDA{i}, Az{i});
end

for i = 1:4
    for j = 1:4
        subplot(4, 4, (i-1)*4+j)
        plot(mean(Az_WS_LDA{(i-1)*4+j}, 2));
    end
end

%% SVM
for i = 1:16
    Az_WS_SVM{i} = cat(2, Az_WS_SVM{i}, Az{i});
end

for i = 1:4
    for j = 1:4
        subplot(4, 4, (i-1)*4+j)
        plot(mean(Az_WS_SVM{(i-1)*4+j}, 2));
    end
end



end

