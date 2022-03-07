function inspectSignals(allSubjects, subjectNumbers,ifsingle)
    % Iterate along all subjects and insert markers at the right places
%     for subjectIdx = 1 : size(allSubjects, 1)
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx = subjectNumbers:allSubjects
        disp(subjectIdx);

        % Load file
        EEG = pop_loadset(['D:\Project\Data\preprocess\3DetectBadChannels\AO_Exp1_', num2str(subjectIdx), '_badChannelsDetected.set']);
        
        colors = cell(1, EEG.nbchan);
        
        % Set color of bad channels to red and color of good channels to
        % black
        for channelIdx = 1 : EEG.nbchan
            if ismember(channelIdx, EEG.badChannels)
                colors{channelIdx} = 'r';
            else
                colors{channelIdx} = 'k';
            end
        end
        
        assignin('base', 'EEG', EEG);
        evalin('base','BadChanDetectionComplete=0;');
        %evalin('base','BadChannels=[];');

        tmpcom = [ ...
            %'BadChannels = TMPREJELEC;' ...
            'BadChanDetectionComplete=1;' ...
            ] ;


        eegplot(EEG.data(1:EEG.nbchan,:,:), 'srate', EEG.srate,...
            'title', 'Scroll component activities -- eegplot()', ...
            'limits', [EEG.xmin EEG.xmax]*1000, 'color', colors, ...
            'winlength', 10, ...
            'dispchans', EEG.nbchan, ...
            'eloc_file', EEG.chanlocs, 'command', tmpcom, ...
            'butlabel','Done');

        %Wait until the user has finished reviewing.
        reviewFinished=0;
        while ~reviewFinished
            reviewFinished=evalin('base','BadChanDetectionComplete');
            %BadChannels =evalin('base','BadChannels');
            pause(0.01);
        end

        wrongInput = 1;
        while wrongInput
            try
                additionalBadChannels = input('Mark additional bad channels? (eg: [1, 2, 3]), otherwise just press Enter');
                if find(additionalBadChannels < 1) | find(additionalBadChannels > EEG.nbchan)
                    disp(['Specify channel numbers between 1 and ', num2str(EEG.nbchan)]);
                else
                    wrongInput = 0;
                end
            catch
                disp('Wrong input, input like the example: [1, 2, 3] or 45 or [18, 9]')
                wrongInput = 1;
            end
        end

        EEG.badChannels = union(EEG.badChannels, additionalBadChannels);

        % Save the EEG data
        pop_saveset(EEG, ['D:\Project\Data\preprocess\4Inspected\AO_Exp1_', num2str(subjectIdx), '_inspected.set']);
    end
end