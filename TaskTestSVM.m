function [ Az ] = TaskTestSVM(X, Y, n_folds, cutoff, TestingSetSize, KernelFunc)
% TaskTestLDA
% n_folds:  How many fold for training and testing
% cutoff:   How many data used for training and testing
% KernelFunc: set kernel function, default linear
if nargin == 5
    KernelFunc = 'linear';
end

rand('state',sum(clock)*100000);

% load x and y
x = X;
y = Y;

% downsample and reshape hard code here
% x = x(:, 1:4:end, :);
% s = size(x, 3);
% x = reshape(x, [64*128, s])';
% we change this code to data after downsampled
s = size(x, 1);

Az = zeros(n_folds, 1);

for id_fold = 1:n_folds
    % rand permute dataset
    kk = randperm(s);
    x = x(kk, :);
    y = y(kk, :);
    
    % Get training and testing samples
    validate_x = x(TestingSetSize+1:end, :);
    validate_y = y(TestingSetSize+1:end, :);
    train_x = x(1:cutoff, :);
    train_y = y(1:cutoff, :);
    
    % SVM prediction and ROC
    SVMModel = fitcsvm(train_x, train_y(:, 1),'KernelFunction',KernelFunc,'Standardize', true, 'ClassNames',[0 1]);
    [~, pred] = predict(SVMModel,validate_x);
    [~, ~, ~, Az(id_fold) ] = perfcurve(validate_y(:, 1), 1 - pred(:, 1), 1);
    if mod(id_fold,10) == 0
        disp(['SVM fold ' num2str(id_fold) ' finished.']);
    end
end

% display the mean of current sample size
disp(['Current sample: ' num2str(cutoff) ', Current mean: ' num2str(mean(Az))]);


