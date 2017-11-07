function ft_train_weka = load_data(dataset)

% LOAD_DATA Function to load .arff file with dataset of features
% 
% DATASET String with name of dataset to load. load_data function without
% input parameter, open a window to select the .arff file to load.
% 
% FT_TRAIN_WEKA Weka object with the features dataset.
% 
% Example 1
% ft_train_weka = load_data
% 
% Example 2
% dataset = load_data('AlzheimerLocal_SS-WOJ.arff')


global file
if ~exist('dataset','var')
    %Load from disk 
    [file, path] = uigetfile( ...
    {  '*.arff','arff-files (*.arff)'; ...
       '*.*',  'All Files (*.*)'}, ...
       'Pick a file', ...
       'MultiSelect', 'off');
        datos = [path file];
        ft_train_weka = loadARFF(datos);
else
        ft_train_weka = loadARFF(dataset);
end
