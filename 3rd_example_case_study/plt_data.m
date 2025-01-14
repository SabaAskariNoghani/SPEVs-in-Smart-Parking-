
clc
clear
close all

addpath('function_folder');

load important_results_0.mat
%% plot the results
plot_data_v_small2(P_charg_whole', P_discharg_whole', P_c_whole, P_grid_whole, P_solar,P_solar_spv,P_cspv_whole, E_whole',...
    num,Emin,Emax, time_length)

load important_results_100.mat
plot_data_v_small2(P_charg_whole', P_discharg_whole', P_c_whole, P_grid_whole, P_solar,P_solar_spv,P_cspv_whole, E_whole',...
    num,Emin,Emax, time_length)
