clc
clearvars

% close all

% Save the result
load('PG_comtime_4.mat', "CompTime", "PG");
figure('Position', [20 20 820 220]); % Adjust the width and height as needed
scatter(6:24, PG,50, 'o', 'filled'); % 50 specifies marker size, 'o' is the circle
hold on;
plot(6:24, PG, 'LineWidth', 1.5, 'LineStyle', '-', 'Color', 'b');
% Set the font size for the axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
box on;

% Add labels and title
xlabel('H', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('P_g (kW)', 'FontName', 'Times New Roman', 'FontSize', 14);


figure;
plot(6:24, CompTime);

color1 = [0.4940 0.1840 0.5560]	;
color2 = [0.3250, 0.4470, 0.7410];

load ("MPC_H6.mat")
j=1;
plot_SOC(E_whole,simulation_time,Emax,Emin, color1,j)
load ("MPC_H24.mat")
j=2; hold on
plot_SOC(E_whole,simulation_time,Emax,Emin, color2,j)

load ("MPC_H6.mat")
j=1;
plot_pg(P_grid_whole,simulation_time, color1,j)
load ("MPC_H24.mat")
j=2; hold on
plot_pg(P_grid_whole,simulation_time, color2,j)



function []= plot_SOC(E_whole,simulation_time,Emax,Emin, color,j)
E=E_whole';
i=5;
time_slots = 1:simulation_time;
time_slots_soc = 1:simulation_time+1;
%%
% Plot SOC
EE=E(:,i);
Ee=E(:,i);
EE(EE == 0) = NaN;
Ee(Ee == 0) = -10;

if j==1
%figure('Position', [20 20 1420 220]); % Adjust the width and height as needed
figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed
else
    hold on
end
if j==1
    stairs(time_slots_soc, EE,'LineWidth', 1.5,'Color', color);hold on
else
    stairs(time_slots_soc, EE,'LineWidth', 1.5,'LineStyle', '-.','Color', color);hold on
end
% stairs(time_slots, 10*Ee,'LineWidth', 1,'Color', [0.5 0.5 0.5],'LineStyle', '--');hold on
hold on
if j==2
legend('H=6', 'H=24', 'Orientation', 'horizontal');
legend('Location', 'Best');
stairs(time_slots_soc, Emax*ones(1,time_slots_soc(end)),'LineWidth', 1,'Color', 'k','LineStyle', '--');hold on
stairs(time_slots_soc, Emin*ones(1,time_slots_soc(end)),'LineWidth', 1,'Color', 'k','LineStyle', '--');
end
% Adjust the x-axis limit to be at the maximum value of H
xlim([1, time_slots(end)]);
ylim([0, 30]);

% Set the x-axis and y-axis to increase one by one
% xticks(time_slots);
% yticks(1:1:max(P_c)); % You can adjust the range as needed

% Set the font size for the axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);

% Add labels and title
xlabel('Time Slots (hour)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('SOC (kWh)', 'FontName', 'Times New Roman', 'FontSize', 14);
% title('Power Consumption and Generation', 'FontName', 'Times New Roman', 'FontSize', 12);
% grid on
% You can further customize the plot as needed.
end

function []= plot_pg(P_grid,simulation_time, color,j)
% E=E_whole';
i=5;
time_slots = 1:simulation_time;
time_slots_soc = 1:simulation_time+1;
%%
% Plot SOC

if j==1
%figure('Position', [20 20 1420 220]); % Adjust the width and height as needed
figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed
else
    hold on
end
if j==2
stairs(time_slots, P_grid, 'LineWidth', 1.5, 'DisplayName', 'P_grid','LineStyle', '-.','Color', color);
else
    stairs(time_slots, P_grid, 'LineWidth', 1.5, 'DisplayName', 'P_grid','LineStyle', '-','Color', color);
end
% stairs(time_slots, 10*Ee,'LineWidth', 1,'Color', [0.5 0.5 0.5],'LineStyle', '--');hold on
hold on
if j==2
legend('H=6', 'H=24', 'Orientation', 'horizontal');
legend('Location', 'Best');
end

% Adjust the x-axis limit to be at the maximum value of H
xlim([1, time_slots(end)]);

% Set the x-axis and y-axis to increase one by one
% xticks(time_slots);
% yticks(1:1:max(P_c)); % You can adjust the range as needed

% Set the font size for the axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);

% Add labels and title
xlabel('Time Slots (hour)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('Power (kW)', 'FontName', 'Times New Roman', 'FontSize', 14);
% title('Power Consumption and Generation', 'FontName', 'Times New Roman', 'FontSize', 12);

% You can further customize the plot as needed.

end


