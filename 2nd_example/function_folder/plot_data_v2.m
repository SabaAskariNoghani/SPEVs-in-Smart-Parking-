function plot_data_v2(P_charg, P_discharg, P_c, P_grid, P_solar,P_solar_spv,P_cspv, E, H,...
    num,Emin,Emax,simulation_time)

time_slots = 1:simulation_time;
time_slots_soc = 1:simulation_time+1;

% Define the size of the figure (in inches)
%figure('Position', [20 20 1420 220]); % Adjust the width and height as needed
figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed

% Define mild colors
mild_red = [0.8500, 0.3250, 0.0980];  % Mild Red
mild_blue = [0, 0.4470, 0.7410];      % Mild Blue
mild_green = [0.4660, 0.6740, 0.1880]; % Mild Green

% Plot your data with different line styles and specify labels
stairs(time_slots, P_c, 'LineWidth', 1.5, 'DisplayName', 'P_c','LineStyle', ':','Color', mild_blue);
hold on;
stairs(time_slots, P_grid, 'LineWidth', 1.5, 'DisplayName', 'P_grid','LineStyle', '-.','Color', mild_red);
hold on;
stairs(time_slots, P_solar(time_slots), 'LineWidth', 1.5, 'DisplayName', 'P_solar','LineStyle', '-','Color', mild_green);

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

% Add legend
legend('P_c', 'P_g', 'P_{sl}', 'Orientation', 'horizontal', 'FontSize', 13, 'FontName', 'Times New Roman');

% Add legend
legend('Location', 'Best');

% Save the figure as an EPS file
%saveas(gcf, 'fig1.eps', 'epsc');

% Close the figure (optional)
% close(gcf);

% Define dark colors
dark_red = [0.6350, 0.0780, 0.1840];  % Dark Red
dark_blue = [0, 0.4470, 0.7410];      % Dark Blue
color = [0.4940 0.1840 0.5560]	;

for i = num:num
    % for i = 1:N

    % Plot charge and discharge only
   % figure('Position', [20 20 1420 220]); % Adjust the width and height as needed
   figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed

    stairs(time_slots, P_charg(:,i),'LineWidth', 1.5,'Color', dark_blue); hold on
    stairs(time_slots, P_discharg(:,i),'LineWidth', 1.5,'LineStyle', '-.','Color', dark_red); hold on
    legend('c', 'd','Orientation', 'horizontal', 'FontSize', 13, 'FontName', 'Times New Roman');
    legend('Location', 'Best');

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

    % Add legend
    legend('Location', 'Best');

    %%
    % Plot SOC
    EE=E(:,i);
    Ee=E(:,i);
    EE(EE == 0) = NaN;
    Ee(Ee == 0) = -10;

    %figure('Position', [20 20 1420 220]); % Adjust the width and height as needed
    figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed

    stairs(time_slots_soc, EE,'LineWidth', 1.5,'Color', color);hold on
    stairs(time_slots_soc, Emax*ones(1,time_slots_soc(end)),'LineWidth', 1,'Color', 'k','LineStyle', '--');hold on
    stairs(time_slots_soc, Emin*ones(1,time_slots_soc(end)),'LineWidth', 1,'Color', 'k','LineStyle', '--');
    % stairs(time_slots, 10*Ee,'LineWidth', 1,'Color', [0.5 0.5 0.5],'LineStyle', '--');hold on

    legend('SOC', 'Orientation', 'horizontal');
    legend('Location', 'Best');

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

    %%
    % Plot constraint
    %figure('Position', [20 20 1420 220]); % Adjust the width and height as needed
    figure('Position', [20 20 820*2 220]); % Adjust the width and height as needed

    stairs(time_slots, P_solar_spv(i,time_slots)','LineWidth', 1.5,'Color','g'); hold on
    stairs(time_slots, P_cspv(time_slots,i),'LineWidth', 1.5,'LineStyle','-.'); hold on
    % stairs(time_slots, P_discharg(:,i)+P_solar_spv(i,:)'-P_cspv(:,i),'LineWidth', 1.5,'LineStyle',':'); hold on
    % stairs(time_slots, Pmax_inverter*ones(1,H),'LineWidth', 1,'Color', 'k','LineStyle', '--');hold on
    legend('P_{sv}','P_{cv}','Orientation', 'horizontal', 'FontSize', 13, 'FontName', 'Times New Roman');
    legend('Location', 'Best');

    % Adjust the x-axis limit to be at the maximum value of H
    xlim([1, time_slots(end)]);
    % ylim([0, 1.5]);

    % Set the x-axis and y-axis to increase one by one
    % xticks(1:H);
    % yticks(1:1:max(P_c)); % You can adjust the range as needed

    % Set the font size for the axes
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);

    % Add labels and title
    xlabel('Time Slots (hour)', 'FontName', 'Times New Roman', 'FontSize', 14);
    ylabel('Power (kW)', 'FontName', 'Times New Roman', 'FontSize', 14);
    % title('Power Consumption and Generation', 'FontName', 'Times New Roman', 'FontSize', 12);

    % %%
    %     % Plot constraint
    %     figure('Position', [20 20 800 200]); % Adjust the width and height as needed
    %
    %     stairs(time_slots, P_solar_spv(i,:)'-P_cspv(:,i),'LineWidth', 1.5,'Color','g'); hold on
    %     stairs(time_slots, P_cspv(:,i),'LineWidth', 1.5,'LineStyle','-.'); hold on
    %     % Adjust the x-axis limit to be at the maximum value of H
    %     xlim([1, H]);
    %
    %     % Set the x-axis and y-axis to increase one by one
    %     xticks(1:H);
    %     % yticks(1:1:max(P_c)); % You can adjust the range as needed
    %
    %     % Set the font size for the axes
    %     set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
    %
    %     % Add labels and title
    %     xlabel('Time Slots (hour)', 'FontName', 'Times New Roman', 'FontSize', 14);
    %     ylabel('Power (kW)', 'FontName', 'Times New Roman', 'FontSize', 14);
    %     % title('Power Consumption and Generation', 'FontName', 'Times New Roman', 'FontSize', 12);
    %
    %     % You can further customize the plot as needed.
end

end
