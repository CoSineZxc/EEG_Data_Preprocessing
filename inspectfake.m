for subjectIdx=1:24
    EEG = pop_loadset(['D:\Project\Data\preprocess\sample\J\AO_Exp1_', num2str(subjectIdx), '_inspected.set']);
    badcl=EEG.badChannels;
    EEG = pop_loadset(['D:\Project\Data\preprocess\3DetectBadChannels\AO_Exp1_', num2str(subjectIdx), '_badChannelsDetected.set']);
    EEG.badChannels=badcl;
    pop_saveset(EEG, ['D:\Project\Data\preprocess\4Inspected\AO_Exp1_', num2str(subjectIdx), '_inspected.set']);
end