function interpolateBadChannels(allSubjects, subjectNumbers,ifsingle)

    allSubjects=24;
    subjectNumbers=1;
    ifsingle=0;

% Interpolate bad channels
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx = subjectNumbers:allSubjects
        disp(subjectIdx); 
        %status= 'Attended';
        
        EEG = pop_loadset(['D:\Project\Data\preprocess\8RejectBadTrial\AO_Exp1_', num2str(subjectIdx), '_pruned.set']);
        EEG = interpolateChannels(EEG);
        pop_saveset(EEG, ['D:\Project\Data\preprocess\9interpolateBadChannel\AO_Exp1_', num2str(subjectIdx), '_channels_interpolated.set']);
        
        
    end
    
    function EEG = interpolateChannels(EEG)
        % Get the bad channels from chaninfo
        badChannels = EEG.badChannels;

        % Interpolate bad channels (spherical)
        EEG = pop_interp(EEG, badChannels, 'spherical');
    end
end