function computeIca(allSubjects, subjectNumbers,ifsingle)
    % ICA parameters
    if ~exist('icatype','var') || isempty(icatype)
        icatype = 'runica';
    end

    if (strcmp(icatype,'runica') || strcmp(icatype,'binica') || strcmp(icatype,'mybinica')) && ...
        (~exist('pcacheck','var') || isempty(pcacheck))
        pcacheck = true;
    end
    
    allSubjects=6;
    subjectNumbers=1;
    ifsingle=1;
    
    % Iterate along all subjects
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx = subjectNumbers:allSubjects
       
        
        disp(subjectIdx); 
        
        % Load subject EEG data
        EEG = pop_loadset(['D:\Project\Data\preprocess\4Inspected\AO_Exp1_', num2str(subjectIdx), '_inspected.set']);
        % EEG = pop_loadset(['D:\Project\Data\preprocess\5.5ICAremove\AO_Exp1_', num2str(subjectIdx), '_ICA_remove.set']);
        EEG = runICA(EEG, icatype, pcacheck);
        pop_saveset(EEG, ['D:\Project\Data\preprocess\5ICA\AO_Exp1_', num2str(subjectIdx), '_ICA.set']);
%         pop_saveset(EEG, ['D:\Project\Data\preprocess\5.6ICAagain\AO_Exp1_', num2str(subjectIdx), '_ICA.set']);
        
    end

    function EEG = runICA(EEG, icatype, pcacheck)
        badChannels = EEG.badChannels;

        if strcmp(icatype,'runica') || strcmp(icatype,'binica') || strcmp(icatype,'mybinica')
            if pcacheck
                kfactor = 60;
                pcadim = round(sqrt(EEG.pnts*EEG.trials/kfactor));
                if EEG.nbchan > pcadim
                    fprintf('Too many channels for stable ICA. Data will be reduced to %d dimensions using PCA.\n',pcadim);
                    icaopts = {'extended' 1 'pca' pcadim};
                else
                    icaopts = {'extended' 1};
                end
            else
                icaopts = {'extended' 1};
            end
        else
            icaopts = {};
        end

        if strcmp(icatype,'mybinica')
            EEG = mybinica(EEG);
        else
            if EEG.nbchan > pcadim && icaopts{4} > size(setdiff(1:EEG.nbchan,badChannels),2)
                icaopts{4} = size(setdiff(1:EEG.nbchan,badChannels),2);
            end
            % Run ICA on down-sampeld signal to speed up, then put the ica
            % weights back in original signal
            %EEGTemp = pop_resample(EEG, 200);
            EEG = pop_runica(EEG, 'icatype',icatype,'dataset',1,'chanind',setdiff(1:EEG.nbchan,badChannels),'options',icaopts);
            
            % Store ICA weights in original SignalInfo
%             EEG.icawinv = EEGTemp.icawinv;
%             EEG.icasphere = EEGTemp.icasphere;
%             EEG.icaweights = EEGTemp.icaweights;
%             EEG.icachansind = EEGTemp.icachansind;
        end
    end
end