function ss_woj(tg, fn)
% SS_WOJ Compute spatial series with jumps from neuron trees 
% TG (string)trees group of neuron reconstructed in .mtr format created
% previously with cellcelloftree function.
% FN = Folder Name to save the time series obtained, default
% current working directory. 
% 
% Example 1
% ss_woj('trees.mtr') % trees.mtr is current working directory. 
% 
% Example 2
% ss_woj('trees.mtr','C:\Users\username\Documents\MATLAB')
% 
% Example 3
% ss_woj('C:\Users\username\Documents\MATLAB\trees.mtr')

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
        ipt = ipar_tree(cell_n);
        prt = ipt(:,1:2);
        clear ipt        
        len_tgs = len_tree(cell_n);
        serie_n = cell_n.X; 
        sz = size(serie_n,1)-1;
        tgt = zeros(sz,1); 
        for t = 1 : sz
            tgt(t,1) = len_tgs(prt(t+1,1)) - len_tgs(prt(t+1,2));
        end
        grama(k) = {tgt};
    end
    stgrama(g) = {grama};
end    
for i = 1:size(stgrama,2)
    for k = 1:size(stgrama{i},2)
        cell_name = cell2mat(tg{i}(k));
        S = stgrama{i}{k}; % Serie
        nameC = strcat('Group',num2str(i),'_Serie',num2str(k),'.dat'); % Nombre de la serie
        save(strcat(folder_name,'\',nameC),'-ascii','S')        
    end
end



