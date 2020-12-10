function d = traj_interp(d)
% Interpolate the missing distance measurement
% Params:
% d: distance measurements
% Return:
% d: distance measurements with interpolation
int = find_blank(d);
for i = 1 : size(int, 1)
    N                          = int(i, 2) - int(i, 1) + 2;
    d(int(i, 1)-1:int(i, 2)+1) = interp1(d([int(i, 1)-1, int(i, 2)+1]), 1:1/N:2, 'pchip');
end
end