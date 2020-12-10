function anim_plot(M)
% v = VideoWriter('test1.avi');
% open(v)
figure
ma = max(M(:));
mi = min(M(:));
for i = 1 : size(M, 2)
    plot( M(:, i))
    ylim([mi/1, ma/1])
    [~, loc] = max(M(:, i));
    hold on
    scatter(loc, M(loc, i), '*')
    hold off
    drawnow
%     frame = getframe(gcf);
%     writeVideo(v,frame);
end
% close(v)
