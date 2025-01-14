function plot_data_v_small2(P_charg, P_discharg, P_c, P_grid, P_solar, P_solar_spv, P_cspv, E,...
    num, Emin, Emax, time_length)
% Define start and end date (April to March)
startDate = datetime('2023-04-01');  % Starting date (April 1st)
endDate = datetime('2024-03-31');   % Ending date (March 31st)
% Create the date range corresponding to time slots (assuming time_length is number of hours)
time_slots = linspace(startDate, endDate, time_length);  % Create a date range with 'time_length' entries
% Define the size of the figure (in inches)
    figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed
% Define mild colors
mild_red = [0.8500, 0.3250, 0.0980];  % Mild Red
mild_blue = [0, 0.4470, 0.7410];      % Mild Blue
mild_green = [0.4660, 0.6740, 0.1880]; % Mild Green
% Plot your data with different line styles and specify labels
% stairs(time_slots, P_c, 'LineWidth', 1.5, 'DisplayName', 'P_c', 'LineStyle', ':', 'Color', mild_blue);
% hold on;
stairs(time_slots, P_grid, 'LineWidth', 1.5, 'DisplayName', 'P_grid', 'LineStyle', '-.', 'Color', mild_red);
% hold on;
% stairs(time_slots, P_solar(1:time_length), 'LineWidth', 1.5, 'DisplayName', 'P_solar', 'LineStyle', '-', 'Color', mild_green);
% Adjust the x-axis limit to be at the maximum value of time_slots
xlim([time_slots(1), time_slots(end)]);
% Set the font size for the axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
% Add labels and title
xlabel('Date (April - March)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('Power (kW)', 'FontName', 'Times New Roman', 'FontSize', 14);
% Add legend
% legend('P_c', 'P_grid', 'P_{solar}', 'Orientation', 'horizontal', 'FontSize', 13, 'FontName', 'Times New Roman');
% legend('Location', 'Best');
% Save the figure as an EPS file
saveas(gcf, 'fig1.eps', 'epsc');
% Close the figure (optional)
% close(gcf);
% Plot charge and discharge only
for i = num:num
    figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed
    stairs(time_slots, P_charg(:,i), 'LineWidth', 1.5, 'Color', mild_blue); hold on;
    stairs(time_slots, P_discharg(:,i), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', mild_red); hold on;
    legend('Charging', 'Discharging', 'Orientation', 'horizontal', 'FontSize', 13, 'FontName', 'Times New Roman');
    legend('Location', 'Best');
    
    % Adjust the x-axis limit
    xlim([time_slots(1), time_slots(end)]);
    
    % Set the font size for the axes
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
    % Add labels
    xlabel('Date (April - March)', 'FontName', 'Times New Roman', 'FontSize', 14);
    ylabel('Power (kW)', 'FontName', 'Times New Roman', 'FontSize', 14);
    % Plot SOC
    EE = E(:,i);
    EE(EE == 0) = NaN;
    figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed
    stairs(time_slots, EE, 'LineWidth', 1.5, 'Color', [0.4940 0.1840 0.5560]); hold on;
    stairs(time_slots, Emax * ones(1, time_length), 'LineWidth', 1, 'Color', 'k', 'LineStyle', '--'); hold on;
    stairs(time_slots, Emin * ones(1, time_length), 'LineWidth', 1, 'Color', 'k', 'LineStyle', '--');
    
    legend('SOC', 'Orientation', 'horizontal');
    legend('Location', 'Best');
    
    % Adjust the x-axis limit
    xlim([time_slots(1), time_slots(end)]);
    ylim([0, 50]);
    
    % Set the font size for the axes
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
    % Add labels
    xlabel('Date (April - March)', 'FontName', 'Times New Roman', 'FontSize', 14);
    ylabel('SOC (kWh)', 'FontName', 'Times New Roman', 'FontSize', 14);
end
end