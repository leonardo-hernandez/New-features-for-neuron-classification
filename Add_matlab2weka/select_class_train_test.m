function select_class_train_test(ft_train_weka, groups, file, percent, split)

% SELECT_CLASS_EXPERIMENTER Function to select and classifier the dataset
% store in the java object ft_train_weka.

% FT_TRAIN_WEKA java object with the dataset.

% FILE String with the name of file to save the result of clasification

% PERCENT Integer positive, number the features to start the classification.

% Example
% SELECT_CLASS_EXPERIMENTER(ft_train_weka,'Alzheimer dataset SS-WOJ',4);

train_weka = ft_train_weka;

diez_percent = percent; % !!!!!! CAMBIAR ESTO !!!!!!!!!

fod = fopen(file, 'wt'); % para guardar los resultados en fichero .txt
tree = ' CONJUNTO, EVALUADOR, BUSQUEDA, CLASIFICADOR, FEAT, CCI, TNI, NCCI, NICI, ROC, F-Measure, MEAN, MIN,  MAX, SD, MAX-MIN, FEAT1, FEAT2, FEAT3, FEAT4, FEAT5, FEAT6, FEAT7, FEAT8, FEAT9, FEAT10';
fprintf(fod,'%s\n',tree);
% file = 'Conjunto Alzheimer Local SS-WOJ';


for l = 1 : size(groups,2)
    evaluador = groups{l}{1};
    search = groups{l}{2};
    filtergroup = groups{l}{3};
    filter = groups{l}{4};
    classifgroup = groups{l}{5};
    classif = groups{l}{6};
    ntimes = groups{l}{7};
    nfold = groups{l}{8};
    rseed = groups{l}{9};
    n_ranker = groups{l}{10};
    
    if rseed
        NClass = 10; % Numero de veces que se clasificara por cada selecci�n
    else
        NClass = 1;
    end
    result = zeros(ntimes,NClass+11); % Almacena los resultados 
    feat_result = cell(ntimes,1);
    % Cant de attr selecc, class1, Class2 ... NClass, Media, Min, Max, SD
    first = ['Conjunto de datos:, ' file];
    second = ['Evaluador:, '  evaluador ',' 'Busqueda:, ' search ',' 'Clasificador:, ' classif];
%     tree = 'ATTR, %ICC, NTI, ICC, ICI, ROC, F-STAT, PROM, MIN,  MAX, SD, MAX-MIN, FEAT1, FEAT2, FEAT3, FEAT4, FEAT5';
    empty = '';
        %% Feature selection
    for k = 1:ntimes
        n_rank = n_ranker(k);
        [selectedData, selectedAttr] = wekaFeatureSelection(train_weka, evaluador, search, filtergroup, filter, n_rank);
        [~, ~ ,~, featName] = weka2matlab(selectedData);
        %% Classification
    if size(featName,2) <= diez_percent;
        for h = 1:NClass
            
            train  = wekaApplyFilter(train_weka, 'supervised.instance.StratifiedRemoveFolds', ['-N',num2str(split),'-F 1 -S 1998 -V']);
            test = wekaApplyFilter(train_weka, 'supervised.instance.StratifiedRemoveFolds', ['-N ',num2str(split), ' -F 1 -S 1998']);
            % Train model
            model = wekaTrainModel(train, [classifgroup,'.',classif]);
            % Cassif with test
            [Correctly_Classified_Instances, Total_Number_of_Instances, Correct_Intances, Incorrect_Intances, ROC_Area, F_Measure, predicted, probabilities, confusionMatrix] = wekaClassifymodel(test, model, classifgroup, classif, rseed, nfold);

            result(k,1) = size(selectedAttr,2);
            result(k,h+1) = Correctly_Classified_Instances;
            result(k,h+2) = Total_Number_of_Instances;
            result(k,h+3) = Correct_Intances;
            result(k,h+4) = Incorrect_Intances;
            result(k,h+5) = ROC_Area;
            result(k,h+6) = F_Measure;
            result(k,h+7) = mean(result(k,2:NClass+1));
            result(k,h+8) = min(result(k,2:NClass+1));
            result(k,h+9) = max(result(k,2:NClass+1));
            result(k,h+10) = std(result(k,2:NClass+1));
            result(k,h+11) = max(result(k,2:NClass+1)) - min(result(k,2:NClass+1));
%             feat_result(k,1) = featName(1);
%             result
        end
    end
        train_weka = selectedData;

%% To save result
sz = size(featName,2);
featlist = cell(1,10);
for g = 1:size(featlist,2);
    if g <= sz;
        featlist(g) = featName(g);
    else 
        featlist(g) = {' '};
    end
end
        
    result2 =  [file ',' evaluador ',' search ',' classif ',' num2str(result(k,1)) ',' num2str(result(k,end-10)) ',' num2str(result(k,end-9)) ',' ...
            num2str(result(k,end-8)) ',' num2str(result(k,end-7)) ',' num2str(result(k,end-6)) ','...
            num2str(result(k,end-5)) ',' num2str(result(k,end-4)) ',' num2str(result(k,end-3)) ','...
            num2str(result(k,end-2)) ',' num2str(result(k,end-1)) ',' num2str(result(k,end)) ','...
            mat2str(cell2mat(featlist(1))) ',' mat2str(cell2mat(featlist(2))) ',' mat2str(cell2mat(featlist(3))) ','...
            mat2str(cell2mat(featlist(4))) ',' mat2str(cell2mat(featlist(5))) ',' mat2str(cell2mat(featlist(6))) ','...
            mat2str(cell2mat(featlist(7))) ',' mat2str(cell2mat(featlist(8))) ',' mat2str(cell2mat(featlist(9))) ','...
            mat2str(cell2mat(featlist(10)))];
    fprintf(fod,'%s\n',result2);      




    end 
    fprintf(fod,'%s\n',empty);
    fprintf(fod,'%s\n',empty);
    
    train_weka = ft_train_weka;
            disp(['Conjunto de datos: ' file])
            disp([   'Evaluador: ' evaluador '  B�squeda: ' search '  Clasificador: ' classif]) 
            disp('    ATTR       CCI       TNI      NCCI       NICI       ROC      F-Mearure     MEAN      MIN       MAX        SD     MAX-MIN');
            disp ([result(:,1) result(:,end-10) result(:,end-9) result(:,end-8) result(:,end-7) result(:,end-6) result(:,end-5) result(:,end-4) result(:,end-3) result(:,end-2) result(:,end-1) result(:,end)])
end

fclose(fod);
