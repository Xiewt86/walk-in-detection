clear
close all

% Load the transmitted OFDM signals
sig_generation2

% Load the recorded signals
n_ch     = '02';
fileName = 'data/demo1';
data     = audioread([fileName '-', n_ch, '.wav']);

% High-pass filtering
[b, a]   = butter(5, 17000/(fs/2), 'high');

% Synchronization
corr     = conv(data, preamble);
[~, idx] = max(abs(corr));
start    = idx+0.5*fs;
data     = filter(b, a, data(start : start+length(s1)-1));

% Let CIR start with LOS path
T        = T/2;
cir0     = zeros(T+length(s_frame)-1, 1);
for m = 1 : 100
    y    = real(data((m-1)*T+1 : (m-1)*T+T));
    cir0 = cir0 + conv(y, s_frame);
end
[~, idx] = max(cir0);

% Compute CIRs frame by frame
CIRs_1   = zeros(size(cir0(idx:end), 1), N_rep);
CIRs_2   = CIRs_1;
cnt1     = 0;
cnt2     = 0;
for m = 1 : 2*N_rep  
    y   = data((m-1)*T+1 : (m-1)*T+T);
    cir = conv(y, s_frame);
    cir = cir(idx : end);
    if mod(m, 2) == 0
        cnt1            = cnt1 + 1;
        CIRs_1(:, cnt1) = cir;
    else
        cnt2            = cnt2 + 1;
        CIRs_2(:, cnt2) = cir;
    end
end

% Background subtraction
[M_d1, std1] = bgd_subtraction(CIRs_1, 1);
[M_d2, std2] = bgd_subtraction(CIRs_2, 1);

% Compute the 1-D location of the target user w.r.t. two speakers
locs1        = get_loc((M_d1), std1, 8e-4);
locs2        = get_loc((M_d2), std2, 8e-4);

% Fuse the 1-D locations from two speakers
d            = zeros(size(locs1));
ind_or       = locs1 | locs2;
ind_and      = locs1 & locs2;
d(ind_or)    = locs1(ind_or) + locs2(ind_or);
d(ind_and)   = (locs1(ind_and) + locs2(ind_and))/2;
d            = traj_interp(d);

% The orientation angle between two speakers
spk_angle    = pi/3;

% Compute the angle of the target user w.r.t. the transceivers
theta        = pi/3*tanh(log(std1./std2));

% Filtering the distance and angle measurements
d            = meanfilt1(d, 20);
theta        = meanfilt1(theta, 20);

% Compute the 2-D location
x            = d .* cos(theta(1:length(d)));
y            = d .* sin(theta(1:length(d)));

% Draw result
figure 
xx           = [1.75, 1.75, 2.25, 2.25, 1.75];
yy           = [-1.5, 1.5, 1.5, -1.5, -1.5];
for i = 1 : length(x)-10
    plot((x(i)), (y(i)), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 15)
    hold on
    plot(xx, yy, 'k')
    plot(0, 0, 'dr', 'markersize', 15, 'MarkerFaceColor', 'r')
    hold off
    axis equal
    xlim([0, 5])
    ylim([-2, 2])
    ylabel('Distance (m)')
    xlabel('Distance (m)')
    set(gca,'XDir','reverse');
    legend('Target location', 'Ground truth', 'Transceivers', 'Location', 'northwest')
    drawnow
end
