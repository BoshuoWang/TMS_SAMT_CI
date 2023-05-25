tic
num_steps = 10;                                         % Number of steps for projecting the procedure
num_comb = (2^num_steps);                               % Total number of possible outcomes of the procedure

p_step = num_steps^-1;                                  % Steps of probabilities
prob_succ = [flip(0.5:-p_step:0),0.5+p_step:p_step:1]'; % All probabilities, from 0 to 1
num_prob = length(prob_succ);                           % Number of probabilities (num_step + 1)

bin_vec = (dec2bin((1 : num_comb)-1, num_steps)-48)';                   % Generate all 2^num_steps possible outcome sequence by converting decimal numbers to binary string, ...
                                                                        % then converting 0 and 1 characters (ASCII) to numbers. [num_steps, num_comb], each column is a sequence.
sign_vec = -(bin_vec*2-1);                                              % 0-1 logic to signed -1 & 1; [num_steps, num_comb],
num_succ = sum(bin_vec, 1);                                             % Number of suprathreshold response, [1, num_comb]
prob_vec = prob_succ.^num_succ .* (1-prob_succ).^(num_steps-num_succ);  % [num_prob, num_comb]
%%

harm_start_vec = num_steps:100;                                         % List of starting steps of harmonic sequence
num_harm = length(harm_start_vec);
CI_LB_range = zeros(num_prob, num_harm);                                % Preallocation of lower bound of confidence interval
CI_UB_range = zeros(num_harm, num_prob);

for hh = 1:num_harm
    harm_start = harm_start_vec(hh);
    fprintf('Starting value: %d\n', harm_start);
    
    harm_vec = (harm_start + (1:num_steps)).^-1;                        % Harmonic sequence

    sum_vec = harm_vec * sign_vec;                                      % Total stepping
    [sum_vec, ind] = sort(sum_vec);                                     % Sorting by amplitude
    sum_vec_pad_LB  = [min(sum_vec)*1.0001, sum_vec,          max(sum_vec)*1.0001];  % Padding for easier processing
    prob_vec_pad_LB = [zeros(num_prob, 1),  prob_vec(:, ind), zeros(num_prob, 1)];   % Padding and sorting probablities
    cdf_vec_LB = cumsum(prob_vec_pad_LB, 2);                            % Calculate cummulative probability distribution
    sum_vec_pad_UB = flip(sum_vec_pad_LB);                              % For upper bound, similar calculation on reversed distribution
    prob_vec_pad_UB = [zeros(num_prob, 1), prob_vec(:, fliplr(ind)), zeros(num_prob, 1)];
    cdf_vec_UB = cumsum(prob_vec_pad_UB, 2);
    
    for pp = 1 : length(prob_succ)
        ind_LCI = find(cdf_vec_LB(pp,:) < 0.025, 1, 'last');            % LB is at 2.5% on CDF
        LB = sum_vec_pad_LB(ind_LCI+1);
        CI_LB_range(pp, hh) = LB;

        ind_UCI = find(cdf_vec_UB(pp,:) < 0.025, 1, 'last');            % UB is at 2.5% on reversed CDF
        UB = sum_vec_pad_UB(ind_UCI+1);
        CI_UB_range(pp, hh) = UB;
    end
end
toc
%% Plotting
tic
num_plot = (num_prob+1)/2;
col = lines(num_prob);

num_out = sum(CI_LB_range(:,1)>0);
num_in =  num_prob - num_out*2;
num_col = max(num_out, num_in);

figure('Color', 'w', 'Position', [50, 100, 2100, 900]);

ind_h = 0;
h_ax = gobjects(1, num_prob);
for ii = 1 : num_out
    ind_h = ind_h + 1;
    h_ax(ind_h) = subplot(3, num_col, ii);
end
for ii = 1 : num_in
    ind_h = ind_h + 1;
    h_ax(ind_h) = subplot(3, num_col, num_col + ii + (num_col-num_in)/2);
    if ii == 1
        ylabel(h_ax(ind_h), '95\% CI', 'Interpreter', 'Latex', 'FontSize', 25);
    end
end
for ii = 1 : num_out
    ind_h = ind_h + 1;
    h_ax(ind_h) = subplot(3, num_col, num_col*3-num_out+ii);

    xlabel(h_ax(ind_h), 'At step No.', 'Interpreter', 'Latex', 'FontSize', 20);
end
set(h_ax, 'Box', 'Off', 'TickLabelInterpreter', 'Latex', 'FontSize', 12, 'LineWidth', 1, 'NextPlot', 'Add', 'XLim', [1, harm_start_vec(end)], 'YLim', [-1,1]*max(CI_UB_range, [], 'all'), 'XTick', [1, num_steps:num_steps:harm_start_vec(end)]);

for pp = 1 : num_prob
    plot(h_ax(pp), xlim,[0,0],'k--');
    patch(h_ax(pp), 'XData', [harm_start_vec,flip(harm_start_vec)], 'YData', [CI_LB_range(pp, :),flip(CI_UB_range(pp, :))], 'FaceColor', col(pp,:), 'FaceAlpha', 0.25, 'EdgeColor', col(pp,:));
    title(h_ax(pp),  sprintf('%d/%d: %.3g\\%%', pp-1, num_steps, (prob_succ(pp)*100)), 'Interpreter', 'Latex', 'FontSize', 14);
end


%% Saving data and figure
filename = sprintf('CI_stepping_num_steps_%d', num_steps);
im = frame2im(getframe(gcf));
imwrite( im, fullfile('Data', [filename,'.tif']), 'tif','WriteMode','overwrite', 'Resolution',300,'Compression','lzw');
saveas(gcf, fullfile('Data', [filename,'.fig']));

save(fullfile('Data', [filename, '.mat']), 'num_steps', 'prob_succ', 'prob_vec', 'harm_start_vec', 'CI_UB_range', 'CI_LB_range', '-v7.3');
toc
