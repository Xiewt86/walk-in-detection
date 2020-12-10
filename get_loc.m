function result = get_loc (Md, M_std, th)
% Get target's locations from CIRs
% Params:
% Md: CIR matrix after background subtraction
% M_std: standard deviations of each CIR
% th: threshold of the standard deviation
% Return:
% result: locations
fs  = 48e3;
k   = find(M_std > th);
rec = [];
for i = 1 : length(k)
    cir1      = Md(:, k(i));
    [~, locs] = findpeaks(abs(cir1), 'MinPeakDistance', 200, 'MinPeakHeight', median(abs(cir1))*5);
    if ~isempty(locs)
        rec = [rec; [k(i), 340/fs*locs(1)/2]];
    end
end

result            = zeros(1, size(Md, 2));
result(rec(:, 1)) = rec(:, 2);
end