% i have a csv file that has two columns the first one is the data and the second one is the price vector

% i only need this vector be saved as .mat

% Load the data from the CSV file

% data = readmatrix('Filtered_Price_15min.csv');  % Replace 'your_file.csv' with the actual file name
data = readmatrix('filtered_solar_radiation_15min_April2023_MArch2024.csv');  % Replace 'your_file.csv' with the actual file name

% Extract the  vector (assuming it's in the second column)

% c = data(:, 2);
P_solar = data(:, 3);


% Save the vector to a .mat file
% save('price_vector.mat', 'c');
save('solar_radiation.mat', 'P_solar');
