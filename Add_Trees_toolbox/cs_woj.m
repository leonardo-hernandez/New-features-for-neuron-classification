function cs_woj(tg, cc, fn)

% CS_WOJ Compute coordinates series without jumps from neuron trees 
% TG (string)trees group of neuron reconstructed in .mtr format created
% previously with cellcelloftree function.
% CC = Coordinates to obtain default ['X'; 'Y'; 'Z'].
% FN = Folder Name to save the time series obtained, default
% current working directory. 
%
% Example 1
% cs_woj('trees.mtr') % trees.mtr is current working directory. 
% 
% Example 2
% cs_woj('trees.mtr', ['X'; 'Y'], 'C:\Users\username\Documents\MATLAB')
% 
% Example 3
% cs_woj('C:\Users\username\Documents\MATLAB\trees.mtr', ['Y'])


if ~exist('tg','var')
    tg = load_tree; % Trees group of neuron reconstructed in .mtr format
else
    tg = load_tree(tg);
end

if ~exist('cc','var')
    series = ['X'; 'Y'; 'Z'];
else
    series = cc;
end


if ~exist('fn','var')
    folder_name = pwd;
else
    folder_name = fn;
end

an = size(tg,2);
stgrama = {1:an}; 

for l = 1:size(series,1)
serie = series(l);

for g = 1:an
    grama = cell(size(tg{g}));
    for k = 1:size(tg{g},2)
        
%         cell_sort = cell2mat(tg{g}(k));
        ipt = ipar_tree(sort_tree(tg{g}{k},'-LO'));
        prt = ipt(:,1:2);
        clear ipt
        cell_n = sort_tree(tg{g}{k}, '-LO');
        
        switch serie
            case 'X'
                serie_n = cell_n.X;
            case 'Y'
                serie_n = cell_n.Y;
            case 'Z'
                serie_n = cell_n.X;
        end
      
        sz = size(serie_n,1)-1;
        tgt = zeros(sz,1); 
        for t = 1 : sz
            tgt(t,1) = serie_n(prt(t+1,1)) - serie_n(prt(t+1,2));
        end
        grama(k) = {tgt};
       
    end
    stgrama(g) = {grama};
end

for i = 1:size(stgrama,2)
    for k = 1:size(stgrama{i},2)
        
        switch serie
            case 'X'
                X = stgrama{i}{k};
                nameX = strcat('X_Group',num2str(i),'_Serie',num2str(k),'.dat'); 
                save(strcat(folder_name,'\',nameX),'-ascii','X') 
            case 'Y'
                Y = stgrama{i}{k};
                nameY = strcat('Y_Group',num2str(i),'_Serie',num2str(k),'.dat');
                save(strcat(folder_name,'\',nameY),'-ascii','Y')
            case 'Z'
                 Z = stgrama{i}{k};
                 nameZ = strcat('Z_Group',num2str(i),'_Serie',num2str(k),'.dat');
                 save(strcat(folder_name,'\',nameZ),'-ascii','Z')
        end
        
    end
end
end



