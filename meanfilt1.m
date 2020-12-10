function s_out = meanfilt1(s, win)
% Mean filter
% Params:
% s: raw signal
% win: averaging window size
% return:
% s_out: signal after filtering

s_out = zeros(1, length(s)-win);
for i = 1 : length(s) - win
    seg = s(i:i+win);
    k   = seg ~= 0;
    if ~(sum(k)==0)
        s_out(i) = mean(seg(k));
    else
        s_out(i) = 0;
    end
end
end