clc;
clearvars;

% Load the data
Pg_pl1 = load("Pg_pl1.mat");
Pg_pl3 = load("Pg_pl3.mat");

H = length(Pg_pl3.P_grid);
time_slots = 1:H;

% Figure 1
figure;
stairs(time_slots, Pg_pl1.P_grid, 'LineWidth', 1.5);
hold on;
stairs(time_slots, Pg_pl3.P_grid, 'LineWidth', 1.5);
xlim([1 24]); % Set x-axis limits
xlabel('Time Slots'); % Label for x-axis
ylabel('Power Grid (P)'); % Label for y-axis
legend('Pg\_pl1', 'Pg\_pl3', 'Location', 'best'); % Add legend
title('Power Grid Comparison'); % Title for figure

% Figure 2
figure;
stairs(time_slots, Pg_pl1.P_grid - Pg_pl3.P_grid, 'LineWidth', 1.5);
xlim([1 24]); % Set x-axis limits
ylim([0 3]); % Set y-axis limits
xlabel('Time Slots'); % Label for x-axis
ylabel('Difference in Power Grid (P)'); % Label for y-axis
legend('Pg\_pl1 - Pg\_pl3', 'Location', 'best'); % Add legend
title('Difference in Power Grid'); % Title for figure

