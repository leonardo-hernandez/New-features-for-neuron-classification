function [groups] = eval_classif(eval, classif_group, select_feat)

% EVAL_CLASSIF Function for defines evaluators, classifiers and the number 
% of features to rank by their individual evaluations. See “numToSelect” 
% parameter in weka.attributeSelection.Ranker help.

% EVAL Cell array of strings with the name of weka eluator. By default
% evaluator = {'ChiSquaredAttributeEval';'FilteredAttributeEval';'GainRatioAttributeEval';...
%              'InfoGainAttributeEval';'ReliefFAttributeEval';'SVMAttributeEval';...
%              'SymmetricalUncertAttributeEval'};

% CLASSIF_GROUP Cell array of strings with the name of weka classifier groups. 
% By default classif= {'bayes';'functions';'lazy';'meta';'misc';'rules';'trees'};

% SELECT_FEAT Decreasing vector with the number of features to rank by
% their individual evaluations “numToSelect” parameter in weka.attributeSelection.Ranker 
% The maximum number of this vector should be lower than the number of features. 
% We recommended suppress about the middle of features for every time.
% For example for 175 features select_class = [128 64 32 16 8 4 3 2 1]  

% Example 1
% eval_classif({'ChiSquaredAttributeEval';'FilteredAttributeEval'},...
% {'bayes';'functions';'lazy'}, [128 64 32 16 8 4 3 2 1]);

% Example 2
% eval_classif([],[], [128 64 32 16 8 4 3 2 1]);
% Define all evaluator and classifier groups for feature selection and
% clissifer proccess.

evaluator = eval;

if ~exist('eval','var')
    evaluator = {'ChiSquaredAttributeEval';'FilteredAttributeEval';'GainRatioAttributeEval';...
                'InfoGainAttributeEval';'ReliefFAttributeEval';'SVMAttributeEval';...
                'SymmetricalUncertAttributeEval'};
end

classifgroup = classif_group;

if ~exist('classif_group','var')
    classifgroup = {'bayes';'functions';'lazy';'meta';'misc';'rules';'trees'};
end

groups = {};
g = 1;
for k = 1: size(evaluator,1)
    for l = 1: size(classifgroup,1)
        switch cell2mat(classifgroup(l))
             case 'bayes'
                classif= {'BayesNet';'NaiveBayes';'NaiveBayesUpdateable'};
             case 'functions'
                classif = {'Logistic';'RBFNetwork';'SimpleLogistic';'SMO';'SPegasos';'VotedPerceptron'};
             case 'lazy'
                classif = {'LWL';'IB1';'IBk'}; 
             case 'meta'
                classif = {'Bagging';'ClassificationViaClustering';'ClassificationViaRegression';'CVParameterSelection';'Dagging';'Decorate';'END';'FilteredClassifier';'Grading';'LogitBoost';'MultiBoostAB';'MultiClassClassifier';'MultiScheme'};
             case 'mi'
                classif = {'ClassificationViaRegression';'MISMO';'MIWrapper';'SimpleMI'};
             case 'misc'
                classif = {'HyperPipes';'VFI'};
             case 'rules'
                classif = {'ZeroR';'ConjunctiveRule';'DecisionTable';'JRip';'NNge';'PART';'Ridor'}; %;'OneR';
             case 'trees'
                classif = {'J48';'ADTree';'BFTree';'DecisionStump';'FT';'J48graft';'LADTree';'LMT';'NBTree';'RandomForest';'RandomTree';'REPTree';'SimpleCart';}; %; 'UserClassifier';
        end
        group = cell(10,1);
        for m = 1: size(classif,1)
            group{1} = cell2mat(evaluator(k)); % Evaluador
            group{2} = 'Ranker'; % Algoritmo de busqueda
            group{3} = []; % Grupo de filtros (Ej. Functions, meta, lazy etc.)
            group{4} = []; % Selector de filtro (Cuando se utiliza wrapper)
            group{5} = cell2mat(classifgroup(l)); % Grupos de clasificadores
            group{6} = cell2mat(classif(m)); % Clasificador a utilizar 
%             group{7} = 11; % Numero de veces que se clasifica 
            group{8} = 10; % Validacion cruzada 
            group{9} = 0; % Semilla
            %--------------------------------------------------------------
            % Modificacion para cantidad de atributos
%            group{10} = 0.55; % Cantidad de rasgos que quedan despues del ranker
            group{10} = select_feat;
            group{7} = size(group{10},2); % Numero de veces que se clasifica
            %--------------------------------------------------------------
            groups(1,g) = {group};
            g = g +1;
        end
    end
end
    
    