function [selectedData, selectedAttr] = wekaFeatureSelection(ft_train_weka, evaluador, search, filtergroup, filter, n_rank)
% Perform attribute selection in the WEKA package
%
% featTrain      - A NUMERIC matrix of training features (Ntr x M)
%
% classTrain     - A NUMERIC vector representing the values of the
%                  dependent variable of the training data (Ntr x 1)
%
% featTest      - A NUMERIC matrix of testing features (Nts x M)
%
% classTest     - A NUMERIC vector representing the values of the
%                  dependent variable of the testing data (Nts x 1)
%
% featName    - The CELL vector of string representing the label of each 
%                 features, (1 x M) cell
%
% selector    	- 1 = CfsSubsetEval
%
% Written by Sunghoon Ivan Lee, All copy rights reserved, 2/20/2015 
% http://www.sunghoonivanlee.com

import matlab2weka.*;

%% Converting to WEKA data  
% display('    Converting Data into WEKA format...');

%convert the training data to an Weka object
% convert2wekaObj = convert2weka('test',featName, featTest', classTest, true); 
% ft_test_weka = convert2wekaObj.getInstances();
% clear convert2wekaObj;

%convert the testing data to an Weka object
% convert2wekaObj = convert2weka('training', featName, feat_num', class_nom, true); 
% ft_train_weka = convert2wekaObj.getInstances();
% clear convert2wekaObj;
% display('    Converting Completed!');

%% Perform Attribute Selection
% display('    Selected Features...');
% if (selector == 1)
%     evaluador = 'WrapperSubsetEval';
%     search = 'GeneticSearch';
%     filtergroup = 'functions';
%     filter = 'Logistic';
    import weka.attributeSelection.AttributeSelection.*
    eval(['import ', 'weka.attributeSelection.', evaluador, '.*']);%     import weka.attributeSelection.WrapperSubsetEval.*  
    eval(['import ', 'weka.attributeSelection.', search, '.*']);%     import weka.attributeSelection.GeneticSearch.*
    %create an java object
    attrSelector = weka.attributeSelection.AttributeSelection();        
    %Eval#1. Evaluates the worth of a subset of attributes by considering the individual predictive ability of each feature along with the degree of redundancy between them.
    subsetEval = eval(['weka.attributeSelection.', evaluador, '()']);  
%     subsetEval = weka.attributeSelection.WrapperSubsetEval()
% isempty(filter)
    if ~isempty(filter)
        evalOpts(1) = java.lang.String('-B');
        evalOpts(2) = java.lang.String(strcat('weka.classifiers.',filtergroup, '.',filter)); % strcat('weka.classifiers.',filtergroup, '.',filter)
        subsetEval.setOptions(evalOpts); 
    end
     
% % %     evalOpts(3) = java.lang.String('-F');
% % %     evalOpts(4) = java.lang.String('5'); 
% % %     evalOpts(5) = java.lang.String('-T');
% % %     evalOpts(6) = java.lang.String('0.01');
% % %     evalOpts(7) = java.lang.String('-R');
% % %     evalOpts(8) = java.lang.String('1');
% % %     evalOpts(9) = java.lang.String('--');
% % %     evalOpts(10) = java.lang.String('-R');
% % %     evalOpts(11) = java.lang.String('1.0E-8'); 
% % %     evalOpts(12) = java.lang.String('-M');
% % %     evalOpts(13) = java.lang.String('-1');  
    
    %Search#1: WrapperSubsetEval
%     searchMethod = weka.attributeSelection.WrapperSubsetEval();
    searchMethod = eval(['weka.attributeSelection.', search, '()']);
   %%
   %duniel 
   
   if strcmp(search, 'Ranker')
      a= weka.core.Instances(ft_train_weka); 
%       numinst = a.numAttributes();   %numAttributes()   
%       b = round(numinst.*n_ranker);
      b = round(n_rank);
      strval = num2str(b);
      evalOptsss(1) = java.lang.String('-N');
      evalOptsss(2) = java.lang.String(strval);  
      searchMethod.setOptions(evalOptsss);
   end
    
 %%   
% % %     searchOpts(1) = java.lang.String('-Z');
% % %     searchOpts(2) = java.lang.String('20');
% % %     searchOpts(3) = java.lang.String('-G');
% % %     searchOpts(4) = java.lang.String('20');
% % %     searchOpts(5) = java.lang.String('-C');
% % %     searchOpts(6) = java.lang.String('0.6');
% % %     searchOpts(7) = java.lang.String('-M');
% % %     searchOpts(8) = java.lang.String('0.033');
% % %     searchOpts(9) = java.lang.String('-R');
% % %     searchOpts(10) = java.lang.String('20');
% % %     searchOpts(11) = java.lang.String('-S');
% % %     searchOpts(12) = java.lang.String('1');
% % %     searchMethod.setOptions(searchOpts);
    
    attrSelector.setEvaluator(subsetEval);
    attrSelector.setSearch(searchMethod);
%     attrSelector.setXval(1); % performing cross valuation?
    %Performing attribute selection
    attrSelector.SelectAttributes(ft_train_weka);
    %attrSelector.toResultsString() %printing summary
    

     
    tmpSelectedAttr = attrSelector.selectedAttributes(); %selected attributes
    selectedAttr = (tmpSelectedAttr(1:size(tmpSelectedAttr,1)-1,:) + 1)';
    clear tmpSelectedAttr;

    % Reducting the features for both TRAIN and TEST set
    %selectedData = matlab2weka('train',[featName(:,selectedAttr), 'class'], horzcat(num2cell(feat_num(:,selectedAttr)), class_nom) );
    %ft_test_weka = matlab2weka('test',[featName(:,selectedAttr), 'class'], horzcat(num2cell(featTest(:,selectedAttr)), classTest) );
selectedData = attrSelector.reduceDimensionality(ft_train_weka);   
%    saveARFF('C:\Users\duniel.delgado\Documents\data\mydata.arff',selectedData);
    % end
    clear attrSelector subsetEval searchMethod; 
    clear base;
%     display('    Feature Selection Completed!');
end

