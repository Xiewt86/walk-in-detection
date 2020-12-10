% Generate OFDM signals
clear

% Specifications
fs        = 48e3;
n_null    = 48;
n_carrier = 16;
n_encode  = 2*(n_null + n_carrier);
n_symbol  = n_encode;

% % OFDM frame rate
% Fs        = fs / (4*n_symbol);

% OFDM subcarriers design (inaudible)
X_orig    = [zeros(1, 48*2), [1,-1,-1,-1,-1,1,1,-1,1,-1,-1,-1,1,1,-1,-1,-1,1,1,1,-1,1,1,-1,-1,-1,1,-1,1,-1,1,-1]];

% Derive the time-domain signal
X         = X_orig;
x_orig    = ifft(X, 128*2);
x         = x_orig;

% Add hanning window
s_frame   = real(x) .* hanning(length(x))';

% Frame rate
T         = 0.1*fs;

% A frame of signal (left/right track)
s_seg1    = [s_frame, zeros(1, T - length(s_frame))];
s_seg2    = [zeros(1, T/2), s_frame, zeros(1, T/2 - length(s_frame))];

% # of frames on each track
N_rep     = round(40 / (length(s_seg1)/fs));

% Transmitted signals of left/right tracks
s1        = repmat(s_seg1, 1, N_rep);
s2        = repmat(s_seg2, 1, N_rep);

% An audible OFDM preamble, used for synchronization
load('preamble.mat')

% The complete transmitted signal (with preamble and dual track)
s_tran1   = [zeros(1, 5*fs), 20*preamble, zeros(1, 0.5*fs), 10*s1];
s_tran2   = [zeros(1, 5*fs), 20*preamble, zeros(1, 0.5*fs), 10*s2];
s_tran    = [s_tran1', s_tran2'];
