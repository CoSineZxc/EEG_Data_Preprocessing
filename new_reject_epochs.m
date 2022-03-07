function new_reject_epochs(allSubjects, subjectNumbers,ifsingle)
 
    allSubjects=24;
    subjectNumbers=3;
    ifsingle=1;
    
    %allSubjects = 34
    if ifsingle==1
        allSubjects=subjectNumbers;
    end 
    
    data = 'D:\Project\Data\preprocess\';
    source = '7Epoched';
    destination = '8RejectBadTrial';
    thresh = 3;
    sd = num2str(thresh);
    
    
%     cd (data)
    
    for subjectIdx = subjectNumbers:allSubjects
         

        % Load subject EEG data
        EEG = pop_loadset([data,source,'\AO_Exp1_', num2str(subjectIdx), '_epoched_Samelength','.set']);
        
    
        %This is how I reject and interpolate channels in the whole data set
        % Regect + Interpolate Via Probability and Kertosis
        [EEG2,indelec] = pop_rejchan(EEG,'elec',[1:92],'threshold',thresh,'norm','on','measure','prob');
        [EEG3,indelec2] = pop_rejchan(EEG, 'elec',[1:92] ,'threshold',thresh,'norm','on','measure','kurt');
        % this code collates the channels id-ed by the 2 rejection criteria
        rej=[indelec,indelec2];
        rej=sort(rej);
        rej=unique(rej);
        % interpolates the channels id-ed by the 2 rejection criteria
        EEG = eeg_interp(EEG, rej);
   
        % This is how I reject channels per epoch NB CREATE A LOOP
       %% %% Reject bad channels in epoch
        for i = 1:size(EEG.epoch,2);
            %EEGS = EEG.epoch(i);
            EEGS = pop_select(EEG,'trial',i);
            [EEG2,indelec] = pop_rejchan(EEGS, 'elec',[1:92] ,'threshold',thresh,'norm','on','measure','prob');
            [EEG3,indelec2] = pop_rejchan(EEGS, 'elec',[1:92] ,'threshold',thresh,'norm','on','measure','kurt');
            % this code collates the channels id-ed by the 2 rejection criteria
            rej=[indelec,indelec2];
%             rej=[indelec2];
            rej=sort(rej);
            rej=unique(rej);
            EEGS = eeg_interp(EEGS, rej);
            EEGS.data(:,:) = EEG.data(:,:,i);
        end
        % This is how I reject epochs after the above channel interpolation per epoch
        if EEG.trials>1%autoreject epoch dosen't work if only one epoch available
            EEG = pop_autorej(EEG, 'nogui','on','threshold',thresh,'startprob',thresh,'electrodes',[1:92] ,'eegplot','off');
        else
        end
                
        EEG = eeg_checkset( EEG );
   
        % Save the EEG data
        %EEG = set_combine(condition_A,condition_B)
        pop_saveset(EEG, [strcat(data,destination,'\AO_Exp1_',num2str(subjectIdx), '_pruned_v6','.set')]);
    
    end     