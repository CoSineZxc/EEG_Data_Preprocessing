

clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('D:\Project\Data\preprocess\8RejectBadTrial');
pathIn='D:\Project\Data\preprocess\8RejectBadTrial\';
pathOut= 'D:\Project\Data\preprocess\8RejectBadTrial\';
%% load files
ssList=dir([pathIn '*.set']); %Now using uipickfiles
list=[];
ssList= uipickfiles('FilterSpec', '*.set','Prompt','Select the preprossesed .set files');
nID=size(ssList,2); %number of files loaded

 
 
for i =1:nID
 	[filepath,name,ext] = fileparts(ssList{i});
	names{i,1}=name;%save the file names
	setName = [name ext];
	[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
	EEG = pop_loadset(setName,filepath);

	types={EEG.epoch.eventtype};
    typeslist=[types{:}];
    truetypeslist=unique(typeslist);


%     A1Aidx=strmatch('A1',truetypeslist);
%     A1A(i)=size(A1Aidx,1);
%     A1Aidx=regexp(truetypeslist,'[A-D][0-9][0-9][0-9]$');
    
    A1Aidx=CheckList(truetypeslist,'A1[0-9][0-9]$');
    A1A(i)=size(A1Aidx,2);
    
    A2Aidx=CheckList(truetypeslist,'A2[0-9][0-9]$');
    A2A(i)=size(A2Aidx,2);
    
    A3Aidx=CheckList(truetypeslist,'A3[0-9][0-9]$');
    A3A(i)=size(A3Aidx,2);
    
    A4Aidx=CheckList(truetypeslist,'A4[0-9][0-9]$');
    A4A(i)=size(A4Aidx,2);

    A1Bidx=CheckList(truetypeslist,'B1[0-9][0-9]$');
    A1B(i)=size(A1Bidx,2);

    A2Bidx=CheckList(truetypeslist,'B2[0-9][0-9]$');
    A2B(i)=size(A2Bidx,2);
    
    A3Bidx=CheckList(truetypeslist,'B3[0-9][0-9]$');
    A3B(i)=size(A3Bidx,2);
    
    A4Bidx=CheckList(truetypeslist,'B4[0-9][0-9]$');
    A4B(i)=size(A4Bidx,2);

    A1Cidx=CheckList(truetypeslist,'C1[0-9][0-9]$');
    A1C(i)=size(A1Cidx,2);

    A2Cidx=CheckList(truetypeslist,'C2[0-9][0-9]$');
    A2C(i)=size(A2Cidx,2);
    
    A3Cidx=CheckList(truetypeslist,'C3[0-9][0-9]$');
    A3C(i)=size(A3Cidx,2);
    
    A4Cidx=CheckList(truetypeslist,'C4[0-9][0-9]$');
    A4C(i)=size(A4Cidx,2);

    A1Didx=CheckList(truetypeslist,'D1[0-9][0-9]$');
    A1D(i)=size(A1Didx,2);

    A2Didx=CheckList(truetypeslist,'D2[0-9][0-9]$');
    A2D(i)=size(A2Didx,2);
    
    A3Didx=CheckList(truetypeslist,'D3[0-9][0-9]$');
    A3D(i)=size(A3Didx,2);
    
    A4Didx=CheckList(truetypeslist,'D4[0-9][0-9]$');
    A4D(i)=size(A4Didx,2);
    
    Epoch(i)=EEG.trials;


%     T=table(names(:),A1A(:),A2A(:),A3A(:),A4A(:),A1B(:),A2B(:),A3B(:),A4B(:),A1C(:),A2C(:),A3C(:),A4C(:),A1D(:),A2D(:),A3D(:),A4D(:),sum([A1A(:),A2A(:),A3A(:),A4A(:),A1B(:),A2B(:),A3B(:),A4B(:),A1C(:),A2C(:),A3C(:),A4C(:),A1D(:),A2D(:),A3D(:),A4D(:)]),Epoch(:), 'VariableNames',{'participant','A1','A2','A3','A4','B1','B2','B3','B4','C1','C2','C3','C4','D1','D2','D3','D4','sum','epoch'});
    T=table(names(:),A1A(:),A2A(:),A3A(:),A4A(:),A1B(:),A2B(:),A3B(:),A4B(:),A1C(:),A2C(:),A3C(:),A4C(:),A1D(:),A2D(:),A3D(:),A4D(:),Epoch(:), 'VariableNames',{'participant','A1','A2','A3','A4','B1','B2','B3','B4','C1','C2','C3','C4','D1','D2','D3','D4','epoch'});
%     T1=table(names(:),Epoch(:), 'VariableNames',{'participant','epoch'});

end

save threshold_3_phase_2_att_epochs.mat T
writetable(T,'threshold_3_phase_2_att_epochs_v2.xlsx')
% writetable(T1,'threshold_3_phase_2_att_epochs_real.xlsx')

