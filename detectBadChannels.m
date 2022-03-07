function detectBadChannels(allSubjects, subjectNumbers, ifsingle)
    % Iterate along all subjects and detect bad channels
    
    allSubjects=24;
    subjectNumbers=1;
    ifsingle=1;
    
    dataPath='D:\Project\Data\preprocess\2MarkersInserted_EEG\';
    
%     cd (dataPath)
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx = subjectNumbers:allSubjects

        % Load subject EEG data
        %EEG = pop_loadset(['/Users/jackie/Dropbox (Cambridge University)/Jackie PhD/Preprocessing/Data/MarkersInserted/Jpexp1_', num2str(subjectNumbers(subjectIdx)), '_markersInserted.set']);
%         files = dir(strcat(markers,'*.set'));
%         folder = markers;
        Fname = strcat(dataPath, 'AO_Exp1_', num2str(subjectIdx), '_markersInserted.set');
%         Fname = 'D:\Project\Data\preprocess\sample\AO_Exp1_2_markersInserted.set';
        EEG = pop_loadset(Fname);
        
        
        % Detect bad channels using kurtosis (+- 5 SD's) and based on power
        % spectrum (+- 3 SD's)
        [~, ind] = pop_rejchan(EEG, 'elec',[1:92] ,'threshold',[-5 5] ,'norm','on','measure','kurt');
        electrodes = setdiff(1:EEG.nbchan, ind);
        [~, rejIndices] = pop_rejchan(EEG, 'elec', electrodes ,'threshold',[-3 3],'norm','on','measure','spec','freqrange',[1 100] );    
        
        EEG.badChannels = union(ind, rejIndices);
        disp(EEG.badChannels);

        % Save the EEG data
        % pop_saveset(EEG, ['/Volumes/rfs-mb383-brainlang/JackiePhelps/Andrea_Exp1_preprocessed_v2/Bad_Channels_AOExp1/AO_Exp1_', num2str(subjectIdx), '_badChannelsDetected.set']);
        pop_saveset(EEG, ['D:\Project\Data\preprocess\3DetectBadChannels\AO_Exp1_', num2str(subjectIdx), '_badChannelsDetected.set']);
    end
end