for subjectIdx =1:24
    EEG = pop_loadset(['D:\Project\Data\preprocess\10rereferenced\AO_Exp1_', num2str(subjectIdx), '_rereferenced.set']);
    data=
    filename=['D:\Project\Data\preprocess\EEGFinalMat\EEG_',num2str(subjectIdx),'.mat'];
    save(filename,'EEG')
end