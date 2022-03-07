function EEG = insertEvents(EEG, markerOnsets, markerTypes)
    % Iterate along all new events / markers and add them to the existing ones
    for newEventIdx = 1 : length(markerOnsets)
        newEvent = [];
        newEvent.type = markerTypes{newEventIdx};
        newEvent.latency = markerOnsets(newEventIdx);
        newEvent.value = [];
        newEvent.duration = 500;
        newEvent.codes = [];
        newEvent.init_index = [];
        newEvent.init_time = [];
        newEvent.urevent = [];
        
        EEG.event(end+1) = newEvent;
    end
    
    % Check all events for consistency
    EEG = eeg_checkset(EEG, 'eventconsistency');
end
    
    
    
    


