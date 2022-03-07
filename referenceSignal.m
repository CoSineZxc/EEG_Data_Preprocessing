function referenceSignal(allSubjects, subjectNumbers,ifsingle)
    % rereference all subjects in attended and unattended
    
%     data = '/Volumes/rfs-mb383-brainlang/JackiePhelps/Andrea_Exp1_preprocessed_v2/';
%    
%     
%     cd (data)

    allSubjects=24;
    subjectNumbers=1;
    ifsingle=0;

    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx = subjectNumbers:allSubjects
        disp(subjectIdx); 
        
        EEG = pop_loadset(['D:\Project\Data\preprocess\9interpolateBadChannel\AO_Exp1_', num2str(subjectIdx), '_channels_interpolated.set']);
        EEG = pop_reref(EEG, []);
        pop_saveset(EEG, ['D:\Project\Data\preprocess\10rereferenced\AO_Exp1_', num2str(subjectIdx), '_rereferenced.set']);
        
        
    end
end