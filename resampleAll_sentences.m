
function resampleAll_sentences(allSubjects, subjectNumbers,ifsingle)
    % Iterate along all subjects and resample to 100Hz
    
    allSubjects=24;
    subjectNumbers=1;
    ifsingle=0;
    
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx = subjectNumbers:allSubjects
        disp(subjectIdx); 
        
        EEG = pop_loadset(['D:\Project\Data\preprocess\10rereferenced\AO_Exp1_', num2str(subjectIdx), '_rereferenced.set']);
%         EEG = pop_loadset(['D:\Project\Data\preprocess\6ICA_remove\AO_Exp1_1_ICA_remove.set']);
        EEG = mypop_resample(EEG, 100);
        pop_saveset(EEG, ['D:\Project\Data\preprocess\11resample\AO_Exp1_', num2str(subjectIdx), '_resampled.set']);
    end
