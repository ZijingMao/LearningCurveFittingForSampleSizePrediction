function [Az_WS_LDA, Az_WS_SVM] = SimpleAlgorithm(X, Y, n_folds, cutoff, TestingSetSize)

addpath(genpath(pwd));

% training LDA
[ Az_WS_LDA ] = TaskTestLDA(X, Y, n_folds, cutoff, TestingSetSize);
% training SVM
[ Az_WS_SVM ] = TaskTestSVM(X, Y, n_folds, cutoff, TestingSetSize);

end