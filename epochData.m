function epochData(allSubjects, subjectNumbers,ifsingle)
    % Iterate along all subjects and create epochs
    
    allSubjects=24;
    subjectNumbers=1;
    ifsingle=0;
    
    %allSubjects = 34
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    load('LengthSentence.mat');
    
    for subjectIdx = subjectNumbers:allSubjects
        

        % Load file
        %FOR 1:28 ONLY
        EEG = pop_loadset(['D:\Project\Data\preprocess\6ICA_remove\AO_Exp1_', num2str(subjectIdx), '_ICA_remove.set']);
        
        % 5) Epoch for attended and unattended sentences separately

        fprintf('\nFinding event indices of attended and unattended sentences separately.\n');
        
        attendedEventIndices=[];
        
        for eventIdx = 1 : size(EEG.event,2)
            if regexp(EEG.event(eventIdx).type,'[A-D][0-9][0-9][0-9]$')==1
                attendedEventIndices = [attendedEventIndices, eventIdx];
%                 num=searchfilenumber(FileName, EEG.event(eventIdx).type);
%                 EEGAttended = pop_epoch(EEG,{}, [-0.2, TimeLength(num)], 'eventindices', [eventIdx]);
%                 pop_saveset(EEGAttended, ['D:\Project\Data\preprocess\6Epoched\AO_Exp1_', num2str(subjectIdx), '_epoched_',EEG.event(eventIdx).type,'.set']);
                % break;
            end
        end
        % Epoch the data for attended sentences and save epoched data
        fprintf('\nEpoching to all attended sentences.\n');
        EEGAttended = pop_epoch(EEG,{}, [-0.2, 2.8], 'eventindices', attendedEventIndices);

        fprintf('\nSaving epoched data with EEG data related to attended sentences.\n');
        pop_saveset(EEGAttended, ['D:\Project\Data\preprocess\7Epoched\AO_Exp1_', num2str(subjectIdx), '_epoched_Samelength.set']);

    end
end
