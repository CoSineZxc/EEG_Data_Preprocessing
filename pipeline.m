% Pre-processing pipeline

allSubjects=24;
subjectNumbers=1;
ifsingle=1;

% 1. Insert a marker for every sentence and every word (only attended)
addMarkers_Words(allSubjects, subjectNumbers, ifsingle);

% 2. Detect bad channels, do not remove them
% Bad channel detection uses 1) kurtosis +-5 SD's from average kurtosis of
% al channels. 2) power spectrum (spectopo) +- 3 SD's from average power
% spectrum of all channels
detectBadChannels(allSubjects, subjectNumbers, ifsingle);

% 3. Visually inspect the signals to confirm all bad channel are out, this
% can only be used to ADD more channels, not remove once that have been set
% as bad automatically
inspectSignals(allSubjects, subjectNumbers, ifsingle);

% 4. Run ICA
computeIca(allSubjects, subjectNumbers, ifsingle);

% 5. Remove bad ICA components MANUALLY through EEGLAB GUI!
% Only uncomment code below when you have removed bad independent
% components through the EEGLAB GUI for all subjects.

% 6. Epoch data for attended and unattended separately
epochData(allSubjects, subjectNumbers, ifsingle);

% 7. Reject bad trials
rejectEpochs(allSubjects, subjectNumbers, ifsingle); % DONT FORGET to put value to 60 when rejecting trials

% 8. Interpolate previously detected bad channels
interpolateBadChannels(allSubjects, subjectNumbers, ifsingle);

% 9. Rereference to average reference
referenceSignal(allSubjects, subjectNumbers, ifsingle);

% 10. Resample to 100hz
resampleAll_sentences(allSubjects, subjectNumbers, ifsingle); 