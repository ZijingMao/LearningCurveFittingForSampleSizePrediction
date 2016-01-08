function DataDistribution = GenerateDistribution(Az_WS_LDA)
steps = 0.05;
from_perf = 0.7;
to_perf = 0.95;

total_size = (to_perf - from_perf)/steps + 1;
% read Az_WS_LDA as the input
DataDistribution = cell(1, total_size);
for threshold = from_perf:steps:to_perf
    A = zeros(300, 16);
    for j = 1:16
        Az = Az_WS_LDA{j};
        for idx = 1:300
            tmp = find(Az(:, idx)>threshold, 1);
            if ~isempty(tmp)
                [A(idx, j)] = tmp;
            end
        end
    end

    CurrentDataDistribution = reshape(A, [300*16, 1]);
    CurrentDataDistribution(CurrentDataDistribution == 0) = [];
    DataDistribution{int16((threshold-from_perf)/steps+1)} = CurrentDataDistribution;
    % hist(DataDistribution, 1:1:max(DataDistribution));
end
