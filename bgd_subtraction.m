function [M_d, stds] = bgd_subtraction (M, d)
% Background subtraction
% Param:
% M: CIR matrix
% d: subtraction step
% Return:
% M_d: CIR matrix after background subtraction
% stds: standard deviation of CIRs

M_d  = zeros(size(M, 1), size(M, 2)-d);
stds = zeros(1, size(M, 2)-d);

for i = 1 : size(M, 2)-d
    cir_d     = (M(:, i+d) - M(:, i));
    M_d(:, i) = abs(cir_d);
    stds(i)   = std(cir_d);
end
