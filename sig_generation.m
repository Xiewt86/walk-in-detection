fs = 48e3;
T = 0.01;
N = T*fs;
n = 0:N-1;
t = n / fs;

s_frame = chirp(t, 18e3, T, 22e3);

T = 0.1*fs;

s_frame = s_frame .* hanning(length(s_frame))';

s_seg1 = [s_frame, zeros(1, T-length(s_frame))];

s_seg2 = [zeros(1, T/2), s_frame, zeros(1, T/2-length(s_frame))];

N_rep = round(40 / (length(s_seg1)/fs));

s1 = repmat(s_seg1, 1, N_rep);

s2 = repmat(s_seg2, 1, N_rep);

load('preamble.mat')

s_tran1 = [zeros(1, 5*fs), 20*preamble, zeros(1, 0.5*fs), s1];

s_tran2 = [zeros(1, 5*fs), 20*preamble, zeros(1, 0.5*fs), s2];

s_tran = [s_tran1', s_tran2'];
