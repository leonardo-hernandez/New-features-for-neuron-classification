function [Correctly_Classified_Instances, Total_Number_of_Instances, Correct_Intances, Incorrect_Intances, ROC_Area, F_Measure] = wekaClassification(ft_train_weka, classifgroup, classif, rseed, nfold)

% Perform classifier in the WEKA package
% ///////////// INPUTS ////////////////
% rseed = 1; %random
% nfold = 10; %crossvalid
% % % classif = 'J48';
% % % classifgroup = 'trees';
% ///////////// OUTPUTS ////////////////
% actual        - A CELL vector representing the values of the actual label 
%                 of the test dataset. It implies that this vector should  
%                 be equal to "classTest" input. 
%
% predicted     - A CELL vector representing the values of the predicted 
%                 class of the test dataset. 
%
% probDistr     - A NUMERIC vector that represents the class probability of
%                 the predictions. Each column represents the probability
%                 of an instance (row) belonging to that specific class. 



import matlab2weka.*;
%% Converting to WEKA data  
% display('    Converting Data into WEKA format...');
% convert2wekaObj = convert2weka('selectedData', featName, feat_num', class_nom, true); 
% selectedData = convert2wekaObj.getInstances();
% clear convert2wekaObj;
selectedData = ft_train_weka;
% display('    Converting Completed!');

%% include jar libraries to matlab environment:
% % % Initializing 
% % % adding the path to matlab2weka codes
% % addpath([pwd filesep 'matlab2weka']);
% % % adding Weka Jar file
% % javaaddpath('C:\Program Files\Weka-3-6\weka.jar');
% % % adding matlab2weka JAR file that converts the matlab matrices (and cells)
% % % to Weka instances.
% % javaaddpath([pwd filesep 'matlab2weka' filesep 'matlab2weka.jar']);
%%
%   ==import funtions==
% import java.util.Enumeration
% import java.lang.String
% import weka.classifiers.Classifier
% import weka.classifiers.Evaluation
% import weka.classifiers.*
%%
%clasifica = weka.classifiers.trees.J48();
%import weka.classifiers.trees.J48.*
%eval(['clc']);
eval(['import ', 'weka.classifiers.', classifgroup, '.', classif, '.*']); %Ejenmplo  import weka.classifiers.trees.J48.*
%create an java object     
clasifica = eval(['weka.classifiers.',classifgroup, '.', classif, '()']);  
      
%%    
%prepara opciones de crossvalidatemodel

% import java.util.Enumeration
% import java.lang.String
% import weka.classifiers.Classifier
% import weka.classifiers.Evaluation
% import weka.classifiers.trees.J48
% import java.io.FileReader               
% import weka.core.Instances
% import weka.core.Instance
% import weka.core.Utils
% import weka.core.Attribute
% import java.lang.System
% import matlab2weka.*;
% import weka.core.range.*
% import weka.classifiers.*;
% import java.util.*
% import weka.classifiers.Evaluation.numInstances.*
% import weka.classifiers.trees.J48.*
% import weka.core.range.*
% import weka.classifiers.*;
% import weka.classifiers.Evaluation.numInstances.*
% import weka.classifiers.evaluation.*
% import weka.classifiers.evaluation.output.prediction.*
% import weka.classifiers.trees.J48.*
% Random = javaObject('java.util.Random');

import java.util.*
buffer = javaObject('java.lang.StringBuffer');
range = javaObject('weka.core.Range','1');
bool = javaObject('java.lang.Boolean',false);
array = javaArray('java.lang.Object',3);
array(1) = buffer;
array(2) = range;
array(3) = bool;
if  rseed == 1;  
    myrand = Random; %para aleatorio siempre
elseif rseed == 0 
    myrand = Random(1); % con seed resultado siempre el mismo 
end
eval1 = weka.classifiers.Evaluation(selectedData);
eval1.crossValidateModel(clasifica,selectedData,nfold,myrand,array);
%eval1.crossValidateModel(clasifica,Datos,10,myrand,array);
%== Summary ==
Correctly_Classified_Instances = eval1.pctCorrect();
Incorrectly_Classified_Instances = eval1.pctIncorrect();
Kappa_statistic  = eval1.kappa();
Mean_absolute_error  = eval1.meanAbsoluteError();
Root_mean_squared_error	= eval1.rootMeanSquaredError();
Total_Number_of_Instances  = eval1.numInstances();
Correct_Intances = eval1.correct();
Incorrect_Intances = eval1.incorrect();
% === Detailed Accuracy By Class ===
TP_Rate = eval1.weightedTruePositiveRate();
FP_Rate = eval1.weightedFalsePositiveRate();
Precision = eval1.weightedPrecision();
Recall = eval1.weightedRecall();
F_Measure = eval1.weightedFMeasure();
ROC_Area = eval1.weightedAreaUnderROC();
%Detailed_Accuracy_By_Class_OnJavaString = eval1.toClassDetailsString();
% === Confusion Matrix ===
%DatosdeconfMatrix = eval1.confusionMatrix();

% % display('    Classification Completed!');
end