num_steps_vec = 8:2:24;
bounds = zeros(4,length(num_steps_vec));

for ii = 1:length(num_steps_vec)
    num_steps = num_steps_vec(ii);
    filename = sprintf('CI_stepping_num_steps_%d', num_steps);
    load(fullfile('Data', [filename, '.mat']), 'prob_succ', 'prob_vec', 'CI_UB_range', 'CI_LB_range');
    num_out = sum(CI_LB_range(:,1)>0);
    num_in =  num_steps+1 - num_out*2;
    bounds(:, ii) = [num_out-1, num_out, num_out+num_in-1, num_steps+1 - num_out]';
end
%%
figure('Color', 'w', 'Position', [50, 100, 1440, 800]);
h_ax = axes('Box', 'Off', 'TickLabelInterpreter', 'Latex', 'FontSize', 20, 'LineWidth', 1, 'NextPlot', 'Add', 'XLim', [min(num_steps_vec)-0.05, max(num_steps_vec)+0.05], 'YLim', [0,1], 'XTick', num_steps_vec, 'TickDir', 'out', 'Position', [0.1, 0.125, 0.85, 0.825]);
xlabel(h_ax, 'Number of pulses, $N$', 'Interpreter', 'Latex', 'FontSize', 24);
ylabel(h_ax, 'Response probability, $p$', 'Interpreter', 'Latex', 'FontSize', 24);

for kk = 1 : length(h_ax.YTick)
    h_ax.YTickLabel{kk} = sprintf('%d\\%%', round(h_ax.YTick(kk)*100));
end

patch(h_ax, 'XData', [num_steps_vec, flip(num_steps_vec)], 'YData', [mean(bounds(1:2, :), 1)./num_steps_vec, zeros(size(num_steps_vec))], 'FaceColor', 'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');
patch(h_ax, 'XData', [num_steps_vec, flip(num_steps_vec)], 'YData', [mean(bounds(1:2, :), 1)./num_steps_vec, flip(mean(bounds(3:4, :), 1)./num_steps_vec)], 'FaceColor', 'b', 'FaceAlpha', 0.15, 'EdgeColor', 'none');
patch(h_ax, 'XData', [num_steps_vec, flip(num_steps_vec)], 'YData', [mean(bounds(3:4, :), 1)./num_steps_vec, ones(size(num_steps_vec))], 'FaceColor', 'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');


for ii = 1:length(num_steps_vec)
    plot(h_ax, num_steps_vec(ii), (0:bounds(1, ii))./num_steps_vec(ii), 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'LineStyle', 'none');
    plot(h_ax, num_steps_vec(ii), (bounds(2, ii):bounds(3, ii))./num_steps_vec(ii), 'Marker', 'o', 'Color', 'b', 'MarkerSize', 8, 'MarkerFaceColor', 'b', 'LineStyle', 'none');
    plot(h_ax, num_steps_vec(ii), (bounds(4, ii): num_steps_vec(ii))./num_steps_vec(ii), 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'LineStyle', 'none');
    
    text(h_ax, num_steps_vec(ii) + 0.1, (bounds(1, ii)+0.25)./num_steps_vec(ii), sprintf('%d/%d', bounds(1, ii), num_steps_vec(ii)), 'Interpreter', 'Latex', 'FontSize', 16, 'Color', [0.7, 0, 0], 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'top');
    text(h_ax, num_steps_vec(ii) + 0.1, (bounds(2, ii)-0.25)./num_steps_vec(ii), sprintf('%d/%d', bounds(2, ii), num_steps_vec(ii)), 'Interpreter', 'Latex', 'FontSize', 16, 'Color', [0, 0, 0.7], 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'bottom');
    text(h_ax, num_steps_vec(ii) + 0.1, (bounds(3, ii)+0.25)./num_steps_vec(ii), sprintf('%d/%d', bounds(3, ii), num_steps_vec(ii)), 'Interpreter', 'Latex', 'FontSize', 16, 'Color', [0, 0, 0.7], 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'top');
    text(h_ax, num_steps_vec(ii) + 0.1, (bounds(4, ii)-0.25)./num_steps_vec(ii), sprintf('%d/%d', bounds(4, ii), num_steps_vec(ii)), 'Interpreter', 'Latex', 'FontSize', 16, 'Color', [0.7, 0, 0], 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'bottom');
end

plot(h_ax, num_steps_vec, 0.5*ones(size(num_steps_vec)), 'b--');

figure_name = 'ranges';
saveas(gcf, fullfile('Figures',[figure_name,'.fig']));
im = frame2im(getframe(gcf));
imwrite(im, fullfile('Figures',[figure_name,'.tif']), 'tif', 'WriteMode', 'overwrite', 'Resolution', 500);