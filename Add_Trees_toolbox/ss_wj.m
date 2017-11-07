function ss_wj(tg, fn)

% SS_WJ Compute spatial series with jumps from neuron trees 
% TG (string)trees group of neuron reconstructed in .mtr format created
% previously with cellcelloftree function.
% FN = Folder Name to save the time series obtained, default
% current working directory. 
% 
% Example 1
% ss_wj('trees.mtr') % trees.mtr is current working directory. 
% 
% Example 2
% ss_wj('trees.mtr','C:\Users\username\Documents\MATLAB')
% 
% Example 3
% ss_wj('C:\Users\username\Documents\MATLAB\trees.mtr')
if ~exist('tg','var')
    tg = load_tree; % Trees group of neuron reconstructed in .mtr format
else
    tg = load_tree(tg);
end

if ~exist('fn','var')
    folder_name = pwd;
else
    folder_name = fn;
end

an = size(tg,2);
stgrama = {1:an}; 

for g = 1:an
    grama = cell(size(tg{g}));
    for k = 1:size(tg{g},2)
        [cell_n, order] = sort_tree(tg{g}{k}, '-LO'); 
        
        len_tgs = len_tree(cell_n);
        
        grama(k) = {len_tgs};
       
    end
    stgrama(g) = {grama};
end

for i = 1:size(stgrama,2)
    for k = 1:size(stgrama{i},2)
%         cell_name = cell2mat(tg{i}(k));
        S = stgrama{i}{k};
        nameC = strcat('Group',num2str(i),'_Serie',num2str(k),'.dat'); 
        save(strcat(folder_name,'\',nameC),'-ascii','S')        
    end
end



