function rejectEpochs(allSubjects, subjectNumbers,ifsingle)

    allSubjects=24;
    subjectNumbers=20;
    ifsingle=1;
    
    data = 'D:\Project\Data\preprocess\7Epoched\';
    
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx = subjectNumbers:allSubjects
        
        threshold=0.5;
         
        Fname = strcat(data,'AO_Exp1_',num2str(subjectIdx), '_epoched_Samelength.set');
%         Fname = strcat(data,'AO_Exp1_2_epochedAttended.set');
        EEG = pop_loadset(Fname);
       
        
%This is how I reject channels per epoch
               %% %% Reject bad channels in epoch
%         [EEG2,indelec] = pop_rejchan(EEG, 'elec',[1:92] ,'threshold',3,'norm','on','measure','prob');
%         [EEG3,indelec2] = pop_rejchan(EEG, 'elec',[1:92] ,'threshold',3,'norm','on','measure','kurt');
        [EEG2,indelec] = pop_rejchan(EEG, 'elec',[1:92] ,'threshold',threshold,'norm','on','measure','prob');
        [EEG3,indelec2] = pop_rejchan(EEG, 'elec',[1:92] ,'threshold',threshold,'norm','on','measure','kurt');
%         this code collates the channels id-ed by the 2 rejection criteria
        rej=[indelec,indelec2];
%                 rej=[indelec2];
        rej=sort(rej);
        rej=unique(rej);
        % interpolates the channels id-ed by the 2 rejection criteria
        EEG = eeg_interp(EEG, rej);
                %This is how I reject epochs after the above channel interpolation per epoch
        if EEG.trials>1%autoreject epoch doesn't work if only one epoch available
%             EEG = pop_autorej(EEG, 'nogui','on','threshold',3,'startprob',3,'electrodes',[1:92] ,'eegplot','off');
            EEG = pop_autorej(EEG, 'nogui','on','threshold',threshold,'startprob',3,'electrodes',[1:92] ,'eegplot','off');
        else
        end
                %EEGS = pop_rmbase( EEGS, []);
        EEG = eeg_checkset( EEG );
   
        % Save the EEG data
        pop_saveset(EEG,strcat('D:\Project\Data\preprocess\8RejectBadTrial\AO_Exp1_',num2str(subjectIdx), '_pruned.set'));
    end
end