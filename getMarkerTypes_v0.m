% Get Marker Types --> gets called from addMarkers script
%
% getMarkerTypes returns the markerOnsets and markerTypes in SAMPLES for
% all presented audio sentences based on the trial onset events (which are
% the event indices of 'BGIN'-marker of each separate trial in the EEG
% recording) and based on the specific stimulus order for the subject.
%
% Input:
%   * EEG - EEG recording in EEGLAB format
%   * signalInfoPath - The path to the folder containing the signal
%       information of the presented audio sentences
%   * trialOnsetEventIndices - Indices of the 'BLST'-events in the EEG
%       recording, marking the onset of each separate trial
%   * subjectStimulusOrder - The order of trials as they were presented to
%       the subject during the experiment
%   * attended - whether or not the subejct attended to the stimulus.
%       Either 'attended' or 'unattended'
%
% Output:
%   * markerOnsets - A vector of size (16 * 60) with the event latency (in
%   samples) for all markers to be inserted
%   * markerTypes - A cell of size (16 * 60) with the event type (string)
%   for all markers to be inserted
function [SentenceMarkerOnsets, SentenceMarkerTypes, WordMarkerOnsets, WordMarkerTypes] = getMarkerTypes_delete(EEG, signalInfoPath, WordAlignerPath, subjectStimulusOrder)
    % Set attended or unattended
    % And set the trial to start adding markers:
    % Trial 1 for attended and trial 3 for unattended, since first 2 trials
    % were always attended
    SentenceMarkerOnsets = [];
    SentenceMarkerTypes = {};
    WordMarkerOnsets=[];
    WordMarkerTypes={};
%     
%     PredictOnset=[];
%     PredictType={};
    
    trialPointer = 1;
    for trialIdx=1:16
        if ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1coyote'))
            condition = 'A1';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1hyena'))
            condition = 'B1';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1Apea'))
            condition = 'C1';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1sun'))
            condition = 'D1';
     
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2coyote'))
            condition = 'A2';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2hyena'))
            condition = 'B2';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2Apea'))
            condition = 'C2';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2sun'))
            condition = 'D2';
            
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1ivan'))
            condition = 'A3';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1women'))
            condition = 'B3';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1Aprince'))
            condition = 'C3';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '1match'))
            condition = 'D3';
           
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2ivan'))
            condition = 'A4';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2women'))
            condition = 'B4';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2Aprince'))
            condition = 'C4';
        elseif ~isempty(strfind(subjectStimulusOrder{trialIdx}, '2match'))
            condition = 'D4';
        end
        
%         if strcmp(condition, 'C1')
%             fprintf(condition);
%         end
        
        firstDINlatency = 0;
        while firstDINlatency == 0
            if strcmp(EEG.event(trialPointer).type, 'DIN2')
                % Get the latency associated with the first DIN-event
                firstDINlatency = EEG.event(trialPointer).latency;
            else
                trialPointer = trialPointer + 1;
            end
        end
        
        % Iterate along all sentences and insert markers at right positions
        for sentenceIdx = 1 : 60
            % Compute next marker onset (in ms)
            % Marker onset = previous marker onset + signalLength + 300 ms
            if sentenceIdx < 10
                % Add a zero in front of the small numbers
                sentenceIdxStr = ['0', num2str(sentenceIdx)];
                sentenceIdxStrMinus1=['0', num2str(sentenceIdx-1)];
            elseif sentenceIdx==10
                sentenceIdxStr = num2str(sentenceIdx);
                sentenceIdxStrMinus1=['0', num2str(sentenceIdx-1)];
            else
                sentenceIdxStr = num2str(sentenceIdx);
                sentenceIdxStrMinus1=num2str(sentenceIdx-1);
            end
            
%             if sentenceIdx==60
%                 fprintf(num2str(sentenceIdx));
%             end
%             fprintf(sentenceIdxStr);
            
            if sentenceIdx == 1
                % Add baseline marker for NO SOUND for current trial
                % Formula: firstDINlatency (first sound) - 3 s * sampling
                % frequency
                SentenceMarkerOnsets(end+1)=firstDINlatency - (3 * EEG.srate);
                
                % Convert trialIdx to string
                if trialIdx < 10
                    % Add a zero in front of the small numbers
                    trialIdxStr = ['0', num2str(trialIdx)];
                else
                    trialIdxStr = num2str(trialIdx);
                end
                SentenceMarkerTypes{end+1}=['BL', trialIdxStr];
                
                % Insert the first sound marker of the trial based on
                % latency of the first DIN2-marker of the trial
                SentenceMarkerOnsets(end+1)=firstDINlatency;
                SentenceMarkerTypes{end+1}=[condition, '01'];
            else
                % Insert all other markers, based on latency counting from
                % the first marker of the trial
                % Formula: latency of previous trial + 300 ms + length of
                % the presented audio signal.
                
                % Load the signal length of the PREVIOUS audio signal
                % Convert sentenceIdx of to be loaded signal to string
                
                % Filename for signalInfo for PREVIOUS audio signal
                filename = [signalInfoPath, subjectStimulusOrder{trialIdx}, sentenceIdxStrMinus1, 'LC_signalInfo.mat'];
                loadedVariables = load(filename, 'signalLength');

                % Get signalLength (in ms)
                signalLength = loadedVariables.signalLength;
                
                % Note that latency is in SAMPLES, so multiply by sampling
                % frequency (EEG.srate)
                ProbableSentenceMarkerOnset=SentenceMarkerOnsets(end) + ((0.3 + signalLength) * EEG.srate);
                DistancePointer2Onset=abs(EEG.event(trialPointer).latency-ProbableSentenceMarkerOnset);
                
%                 PredictOnset(end+1)=ProbableSentenceMarkerOnset;
%                 PredictType{end+1}='Predict';
                
                while 1
                    trialPointer=trialPointer+1;
                    if ~strcmp(EEG.event(trialPointer).type, 'DIN2')
                        continue;
                    end
                    DistanceNow=abs(EEG.event(trialPointer).latency-ProbableSentenceMarkerOnset);
                    if DistancePointer2Onset>DistanceNow
                        DistancePointer2Onset=DistanceNow;
                    elseif DistancePointer2Onset<DistanceNow
                        trialPointer=trialPointer-1;
                        while ~strcmp(EEG.event(trialPointer).type, 'DIN2')
                            trialPointer=trialPointer-1;
                        end
                        SentenceMarkerOnsets(end+1)=EEG.event(trialPointer).latency;
                       break;
                    else
                        display(['wrong: ',subjectStimulusOrder{trialIdx}])
                    end
                end
                % Convert sentenceIdx of current sentence number
                SentenceMarkerTypes{end+1}=[condition, sentenceIdxStr];
                if sentenceIdx==60 && trialIdx~=16
                    while ~strcmp(EEG.event(trialPointer).type, 'BGIN')
                        trialPointer=trialPointer+1;
                    end
                end
            end
            % insert word markers
            filename=[WordAlignerPath, subjectStimulusOrder{trialIdx},sentenceIdxStr,'_WordTimeAligner.mat' ];
            LoadV=load(filename);
            for wordIdx=1:size(LoadV.timelist,1)
                WordMarkerOnsets(end+1)=SentenceMarkerOnsets(end)+LoadV.timelist(wordIdx,1)*EEG.srate;
                WordMarkerTypes{end+1}=[condition,sentenceIdxStr,num2str(wordIdx),'B_',LoadV.wordlist(wordIdx)];
                WordMarkerOnsets(end+1)=SentenceMarkerOnsets(end)+LoadV.timelist(wordIdx,2)*EEG.srate;
                WordMarkerTypes{end+1}=[condition,sentenceIdxStr,num2str(wordIdx),'E_',LoadV.wordlist(wordIdx)];
            end
        end
        fprintf([condition,' finish\n']);
    end
end

