%% Add markers and epoch data

% Participants heard stories in one ear, while ignoring a story/ noise /
% no interference presented to the other ear. I.E. two wav files were
% presented in each ear simultaneously with the exception of the first
% condition (first 4 trials - always first 4) in which only one wav file was presented.

% Data is not pre-processed, only imported and filtered. e.g. Trials
% separated because recording was stopped (e.g. Boundary marker)

% I want to add markers for onset of each sentence and each word, and then epoch each
% sentence [-200 2 seconds], for Attended wav files
%% Overall formats

% participants heard 60 sentences per trial that were concatenated by a
% 300ms gap. However, there were also gaps of +/- 300ms within sentences so we can't use the gap to mark.

% 24 subjects in the format Andrea_xnumber_filtered.set
% Each subject - 16 trials (stories)
% Each trial = 60 sentences

% CONDITIONS:
% Each condition = 4 consecutive trials.
% 1 2 3 4 or 3 4 1 2 = single talker
% 5 6 7 8 or 7 8 5 6 = Musical Rain
% 9 10 11 12 or 11 12 9 10 = English - English
% 13 14 15 16 or 15 16 13 14 = English - Unknown


% trials presented in a semi - randomised order (order saved in matfiles - 3
% variables: 'subj_ID', 'flipval' (either 1 or 0 - whether they attended right
% (1)or left (0)), 'blockids' (16x1 - order of trials 1-16). Info on
% wav files they attended to was pulled from an excel stimuli table,
% indicating blockid, and what wav files were presented on which side.

% Note: subjID in matfile doesn't correspond to dataset name - e.g. subjID 1 =
% participant 2bF. This can be changed to match SUBJ_ID

% STORIES / SENTENCES:

% Participant heard stories (dichotic task)
% stories made up of concatenated sentences 1-60 per trial
% Stories were called from an excel stimuli table e.g. 1hansel.wav,
% followed by 2hansel.wav. 1pea.wav followed by 2pea.wav WHILE
% dichotically presenting 1prince.wav and 2prince.wav.

% Sentences in stories:
% 1hansel.wav = made up of 60 sentences in the format 1hansel01LC.wav,
% 1hansel02LC.wav, and so on. 2hansel.wav = 2hansel01LC.wav,
% 2hansel02LC.wav.

%Stimtimes for each sentence saved in matfiles - variable: TotalTime
% matfile name: e.g. '1hansel47LC_signalInfo.mat'

%% In case for loop is not working, follow these steps:

% 1) add variable subjectIdx = # (subject ID)

% 2) evaluate everything up till first for loop (aka not including for
%subjectIDX ... etc

% 3) Evaluate "variables loaded" - check the correct order of blockids

% 4) Evaluate subjectStimulusOrder for Attended and Unattended, replacing
% "subjectIdx" by actual subject number NOT ID .e.g. if first participant
% is subj ID 2 , then insert 1. (lower 1 number)

% 5)EEG pop loadset - remove "subjectNumbers" 

% 6)Evaluate everything up till pop saveset

% 7) EEG pop savevest - remove "subjectNumbers"
%%
function addMarkers_Words(allSubjects, subjectNumbers, ifsingle)

    % set path of EEG data
    EEGPath='D:\Project\Data\preprocess\1FilteredEEGData\';
    % Set path where sentences are stored
    signalInfoPath = 'D:\Project\Data\preprocess\1_InsertMarkers\extract_wav_data\';
    % path of Word aligner
    WordAlignerPath='D:\Project\Data\preprocess\1_InsertMarkers\WordAligner\';
    % Load the stimulus order of all subjects for ATTENDED
    [~, stimulusOrderAllSubjectsAttended, ~] = xlsread('D:\Project\Data\preprocess\1_InsertMarkers\stimulusOrderAttended_AOExp1.xlsx',1, 'A2:AA17');
    % Remove underscores ('_')
    stimulusOrderAllSubjectsAttended = strrep(stimulusOrderAllSubjectsAttended, '_', '');
    
    allSubjects=24;
    subjectNumbers=1;
    ifsingle=1;
    
    if ifsingle==1
        allSubjects=subjectNumbers;
    end
    
    for subjectIdx= subjectNumbers:allSubjects
%     for subjectIdx= 1:1
        %subjectIdx = 1 : size(allSubjects, 1)
        disp(['subject:',num2str(subjectIdx)]);
        
        % Load subject stimulus order
        subjectStimulusOrder = stimulusOrderAllSubjectsAttended(:, subjectIdx); 
        
        % Load subject EEG data
        % EEG = pop_loadset([EEGPath, 'Andrea_', num2str(subjectNumbers(subjectIdx)), '_filtered.set']);
        EEG = pop_loadset([EEGPath, 'Andrea_', num2str((subjectIdx)), '_filtered.set']);
        
        % 3) Add a marker for the onset of each attended sentence
        % Marker / event type coding: AttendedConditionSentencenumber
        % Example: AB40 means 'Attended', 'Condition B', 'Sentence 40'
        % - Attended: attended (A) or unattended (U)
        % - Condition: A, B, C or D
        % - SentenceN: 01, 02, ..., 60

        % Determine marker onsets and marker types for ATTENDED and insert
        % markers into EEG recording (and add baseline marker for each trial)
        fprintf('\nComputing marker latencies and marker types for sentences and words.\n');
%         [SentenceMarkerOnsets, SentenceMarkerTypes, WordMarkerOnsets, WordMarkerTypes,PredictOnset,PredictType] = getMarkerTypes(EEG, signalInfoPath, WordAlignerPath, subjectStimulusOrder);
        [SentenceMarkerOnsets, SentenceMarkerTypes, WordMarkerOnsets, WordMarkerTypes] = getMarkerTypes(EEG, signalInfoPath, WordAlignerPath, subjectStimulusOrder);
        
        fprintf('\nInserting marker latencies and marker types for sentences.\n');
        EEG = insertEvents(EEG, SentenceMarkerOnsets, SentenceMarkerTypes);
        
        fprintf('\nInserting marker latencies and marker types for words.\n');
        EEG = insertEvents(EEG, WordMarkerOnsets, WordMarkerTypes);
        
%         EEG = insertEvents(EEG, PredictOnset, PredictType);
        
        % Save the EEG recording with inserted markers
        fprintf('\nSaving EEG data with markers inserted.\n');
        pop_saveset(EEG, ['D:\Project\Data\preprocess\2MarkersInserted_EEG\AO_Exp1_', num2str(subjectIdx), '_markersInserted.set']);
    end
    fprintf("Insert markers finish\n")
end

