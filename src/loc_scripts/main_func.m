function out = main_func(dir_path, file_path)

ppath = '/home/rogerhh/butterfly_localization/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath([ppath, './utils']));
fprintf('Add path done !!\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dir_path, file_path, '.csv']

v = importdata([dir_path, file_path, '.csv']);

loc_v = importdata([ppath, 'loc/', file_path, '_loc.csv'])

time_unit = 15;    % Target sampling rate, default: 15 seconds
GMT = 0;           % Time zone for time stemps

light = v(:, 2);
temp = [];
time_light = datetime(v(:, 1), 'ConvertFrom', 'posixtime');
time_temp = [];

% Data pre-processing
data_cell = data_preprocessing(light, time_light, time_unit);

% Generate the inputs for Neural Networks
% -- We need to choose the locations to test. Here the test locations are
% generated in a square grid manner
% -- This block is related to the neural nets. So if our method is changed one
% day, I will update this test_generation function

center_long = round(loc_v(2) / 10) * 10;   % Center of longitude queries 
center_lat = round(loc_v(1) / 10) * 10;    % Center of latitude queries 
resolution = 0.5;     % Queries's resolution
range = 20;           % Coverage range

filename = ['./Testdata/', file_path];      % Save path

display(filename)

test_generation(data_cell, center_long, center_lat, resolution, range, GMT, filename)

clear all

end