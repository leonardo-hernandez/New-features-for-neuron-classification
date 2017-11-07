function gtrees = cellcelloftree 
% CELLCELLOFTREE Function for create 2 or more group of neuron trees
% in a .mtr file.
% 
% In the first dialog box you can define the number of groups.
% 
% The second and third dialog boxes are to select the trees in 
% format .swc of every set.
% 
% The last dialog box is for select the directory to save the .mtr
% file with the neurons trees. 

% Example
% cellcelloftree


prompt = {'Number of groups'};
dlg_title = 'Data In';
% num_lines = 1;
numlines=1;
defaultanswer = {''};
options.Resize = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer = inputdlg(prompt, dlg_title, numlines, defaultanswer, options);
an = str2double(cell2mat(answer));
gtrees = {1,an};
for g = 1:an
    [FileName,PathName] = uigetfile('*.swc','Select the SWC code file', 'MultiSelect', 'on');
    l = size(FileName,2);
    trees = cell(size(FileName));
    for i = 1:l
        file_mat =  cell2mat(FileName(i));
        path_file = strcat(PathName,file_mat);
        tree = load_tree(path_file);
        trees(i) = {tree};
        
    end
    gtrees(g) = {trees};
end
save_tree(gtrees);