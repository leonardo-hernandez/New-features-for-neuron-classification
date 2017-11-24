clear all
clc
disp('                                                                    ')
disp('            NEW FEATURES FOR NEURON CLASSIFICATION                  ')
disp('                                                                    ')
disp(' Example scripts to reproduce partially the classification process')
disp(' Some parts of the process need to be done manually, this  will be')
disp(' indicated previously.')
disp('                                                                    ')
disp('                  PRESS RETURN TO CONTINUE.                         ')
pause
%%
clc
disp('                                                                    ')
disp('                          FIRST STEP                                ')
disp('                                                                    ')
disp(' Use the function “cellcelloftree.m” to obtain the “.mtr” file')
disp(' with the neurons trees separated in two groups.')
disp(' Type "gtrees = cellcelloftree" to run this step')
disp(' We use the “AlzheimerLocal.mtr" file created previously')
disp('                                                                    ')
disp('                  PRESS RETURN TO CONTINUE.                         ')
pause
clc
%%
disp('                                                                    ')
disp('                        SECOND STEP                                 ')
disp('                                                                    ')
disp(' Run the functions cs_wj.m, cs_woj.m, ss_wj.m and ss_woj.m  to obtain')
disp(' the time series.')
disp(' In this example we only calculate the time series for the SS-WOJ dataset')
disp('                                                                    ')
disp('                  PRESS RETURN TO CONTINUE.                         ')
disp('                                                                    ')
pause
clc
disp('                                                                    ')
disp('                   STARTING TREES TOOLBOX                           ')
trees_path = uigetdir(pwd,'Select the path to Tress Toolbox');
addpath(trees_path);
disp('                                                                    ')
start_trees
mkdir(trees_path,'TimeSeries');
disp('                                                                    ')
disp('              CREATING TIME SERIES, PLEASE WAIT                     ')
disp('                                                                    ')
ss_woj('AlzheimerLocal.mtr',[trees_path '\TimeSeries']);
disp('                                                                    ')
disp([' Time series created in ' trees_path '\TimeSeries'])
disp('                                                                    ')
disp('                  PRESS RETURN TO CONTINUE.                         ')
pause
clc
%%
disp('                                                                    ')
disp('                        THIRD STEP                                  ')
disp('                                                                    ')
disp(' Obtain the features dataset  using Measures of Analysis of Time')
disp(' Series toolkit (MATS). In MATS all operations should be activated')
disp(' manually from the graphical user interface (GUI).')
disp(' We use “AlzheimerLocal_MORPHO.arff" and "AlzheimerLocal_SS-WOJ.arff"')
disp(' files created previously')
disp('                                                                    ')
disp('                  PRESS RETURN TO CONTINUE.                         ')
pause
clc
%%
disp('                                                                    ')
disp('                           FOURTH STEP                              ')
disp('                                                                    ')
disp(' Feature selection and classification using the interface matla2weka') 
disp('                                                                    ')
disp('                        FOR SS-WOJ DATASET                          ')
disp('                                                                    ')
disp('Code  for  Alzheimer (Local  projection)  SS-WOJ  dataset           ') 
disp('                                                                    ')
disp(' ft_train_weka = load_data(''AlzheimerLocal_SS-WOJ.arff'');')
disp(' groups = eval_classif({''ChiSquaredAttributeEval'';...')
disp(' ''FilteredAttributeEval''},{''trees''}, [128 64 32 16 8 4 3 2 1]);')
disp(' select_class_experimenter(ft_train_weka,groups,...')
disp(' ''Class_AlzheimerLocal_SS-WOJ.csv'',3);')
disp('                                                                    ')
disp('                      PRESS RETURN TO CONTINUE.                     ')
pause
clc
if strcmp(filesep, '\')% Windows    
    DefaultName = 'C:\';
elseif strcmp(filesep, '/')% Linux OS X
    DefaultName = filesep;
end

addpath([pwd filesep 'matlab2weka']);
[weka_jar_filename, weka_jar_filepath] = uigetfile('weka.jar',...
    'Select path to weka.jar file (For example: C:\Program Files,\Weka-3-6\weka.jar)',DefaultName);
javaaddpath([weka_jar_filepath weka_jar_filename]);
dir_m2w = fullfile(matlabroot,'toolbox','matlab2weka');
addpath(genpath(dir_m2w));

ft_train_weka = load_data('AlzheimerLocal_SS-WOJ.arff');
groups = eval_classif({'ChiSquaredAttributeEval';'FilteredAttributeEval'},{'trees'}, [128 64 32 16 8 4 3 2 1]);
select_class_experimenter(ft_train_weka,groups,'Class_AlzheimerLocal_SS-WOJ.csv',3);

clear all
disp('                                                                    ')
disp('           CLASSIFICATION FINISHED PRESS RETURN TO CONTINUE.        ')
disp('                                                                    ')
pause
clc
%%
disp('                                                                    ')
disp('                     FOR MORPHO DATASET                             ')
disp('                                                                    ')
disp(' Code for Alzheimer (Local projection) MORPHO dataset') 
disp('                                                                    ')
disp(' ft_train_weka = load_data(''AlzheimerLocal_MORPHO.arff'');')
disp(' groups = eval_classif({''ChiSquaredAttributeEval'';...')
disp(' ''FilteredAttributeEval''},{''trees''}, [64 32 16 8 4 3 2 1]);')
disp(' select_class_experimenter(ft_train_weka,groups,...')
disp(' ''Class_AlzheimerLocal_MORPHO.csv'',3);')
disp('                                                                    ')
disp('                  PRESS RETURN TO CONTINUE.                         ')
pause
clc

ft_train_weka = load_data('AlzheimerLocal_MORPHO.arff');
groups = eval_classif({'ChiSquaredAttributeEval';'FilteredAttributeEval'},{'trees'}, [64 32 16 8 4 3 2 1]);
select_class_experimenter(ft_train_weka,groups,'Class_AlzheimerLocal_MORPHO.csv',3);

disp('                                                                    ')
disp('           CLASSIFICATION FINISHED PRESS RETURN TO CONTINUE.        ')
disp('                                                                    ')
disp('                                                                    ')
pause
clc
%%
disp('                  THE CLASSIFICATION RESULTS                        ')
disp('                                                                    ')
disp(' Inside the current directory you can find the classification results')
disp(' saved in the files:                                                ')
disp(' Class_AlzheimerLocal_SS-WOJ.csv  and Class_AlzheimerLocal_MORPHO.csv') 
disp('                                                                    ')
disp('           THE GRAPHIC RESULT WILL BE SHOWN IN TWO FIGURES          ')
disp('                                                                    ')
disp('                   PRESS RETURN TO CONTINUE.                        ')
pause
clc
%% Dataset MORPHO
fid = fopen('Class_AlzheimerLocal_MORPHO.csv');
C = textscan(fid, '%*s %*s %*s %*s %*s %s %*[^\n]',...
    'delimiter', ',','EmptyValue', -Inf);
fclose(fid);
CCIM = [];
DTSM = [];
for l = 2:size(C{1},1)
    store = str2double(cell2mat(C{1}(l,1)));
    if store
        CCIM = [CCIM; store];
        DTSM = [DTSM; 'MORPHO'];
    end
end
%% Dataset SS-WOJ
fid = fopen('Class_AlzheimerLocal_SS-WOJ.csv');
C = textscan(fid, '%*s %*s %*s %*s %*s %s %*[^\n]',...
    'delimiter', ',','EmptyValue', -Inf);
fclose(fid);
CCIS = [];
DTSS = [];
for l = 2:size(C{1},1)
    store = str2double(cell2mat(C{1}(l,1)));
    if store
        CCIS = [CCIS; store];
        DTSS = [DTSS; 'SS-WOJ'];
    end
end
%%
data = [CCIM; CCIS];
textdata = [DTSM;DTSS];
%% For boxplot
fig = figure(1);
set(fig, 'Position', [200, 100, 650, 500]);
h = boxplot(data(:,1), textdata(:,1:end), 'notch','on');
% h = boxplot(data(:,1), textdata(:,1), 'plotstyle','compact');
% set(gca, 'Position', [.1, .1, .92, .88]);
set(gca,'fontsize',12, 'FontName','Times New Roman','fontweight','b');
set(findobj('Type','line'),'LineWidth',2);
xlabel ('DATASETS  ','fontweight','b','fontsize',12,'FontName','Times New Roman') %,'FontName','Calibri'
% Para % Classification
ymin = min(data)-3;
ymax = max(data)+3;
ylim([ymin ymax]); % Para % Class
% grid on
set(gca,'XGrid','on');
set(gca, 'XTickLabelMode', 'auto');
set(gca, 'XTickLabel', ' ');
title(['ALZHEIMER (LOCAL PROJECTION) SET'] , 'fontweight','b','fontsize',12,'FontName','Times New Roman') %,'FontName','Times New Roman'
ylabel('% CLASSIFICATION','fontweight','b','fontsize',12, 'FontName','Times New Roman'); % ,'FontName','Times New Roman'
YText = ymin +1;
text(1.85,YText,'SS-WOJ','fontsize',12,'fontweight','b','FontName','Times New Roman');   %U-SERIES  XYZ-CS    XYZ-SS   ESP-CS   ESP-SS   MORFO')
text(0.8,YText,'MORPHO','fontsize',12,'fontweight','b','FontName','Times New Roman');   %U-SERIES  XYZ-CS    XYZ-SS   ESP-CS   ESP-SS   MORFO')
%% For Multcompare
longdata = size(data(:,1),1);
[p,table,stats] = friedman(reshape(data(:,1),longdata/2,2));
[c,m,h,nms] = multcompare(stats,'display','on'); % , 'ctype','scheffe'
set(gcf, 'Position', [200, 100, 650, 500]);
% set(gca, 'Position', [.06, .1, .92, .85]);
set(gca, 'YTickLabel', []);
set(gca,'fontsize',12, 'FontName','Times New Roman');
set(findobj('Type','line'),'LineWidth',2)
% axis([1 8 0 8])
title({['CLASSIFICATION COMPARISON - ALZHEIMER (LOCAL PROJECTION) SET']; ['FRIEDMAN TEST (p = ', num2str(p),')']}, 'fontweight','b','FontName','Times New Roman','fontsize',11) %,'FontName','Times New Roman'
xlabel ('MEANRANKS','fontweight','b','FontName','Times New Roman','fontsize',12) 
ylabel('DATASETS','fontweight','b','FontName','Times New Roman','fontsize',12); 
text(stats.meanranks(2) ,0.9,'SS-WOJ','fontsize',12,'fontweight','b','FontName','Times New Roman');  
text(stats.meanranks(1) ,1.9,'MORPHO','fontsize',12,'fontweight','b','FontName','Times New Roman');
clc