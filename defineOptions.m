
%
%  projectOptions is a nullary function which initialises a struct
%  containing the preferences and details for the experiment.
%  A new will be created for each session .
%
%  Mona Garvert 12-2013
%__________________________________________________________________________
% Copyright (C) 2013 Wellcome Trust Centre for Neuroimaging


addpath('C:\Users\mgarvert\Desktop\Peas\Cogent2000v1.32\Toolbox')
s = RandStream.create('mt19937ar','Seed',sum(100*clock));
RandStream.setDefaultStream(s);

%% Project details
% =========================================================================

data.subjNo     = input('Subject ID?    '); 
type            = input('Scan? (y/n)','s');
if strcmp(type,'y')
    data.subject    = ['scan_',num2str(data.subjNo)]; 
else data.subject    = ['peas_',num2str(data.subjNo)]; 
end

data.fname      = ['datafiles/',data.subject];
data.version    = 9;

% This name identifies a collection of files which all belong to the same run of a project.
options.root                = 'C:\Users\mgarvert\Desktop\Peas\Code_9\';
options.screensize          = 1;    % 0 for small window, 1 for full screen, 2 for second screen if attached
options.blocklength         = 133;   % Length of each block
options.nodes               = 12;
options.testrun             = 0;
options.controlno           = 1;    % Number of alternatives to the "partner stimulus"
options.trainblocks         = 12;
options.testblocks          = 10;
options.testelements        = [2 4 6 7 8 9 10];
options.testBlocklength     = 127;

if exist(['\\asia\DeletedDaily\mg\' data.fname,'.mat'],'file')~=0;
    load (['\\asia\DeletedDaily\mg\' data.fname,'.mat']);
       if isfield(data,'day2')
            disp('File for this subject exists already! aborting...')
            clear all; return;
       else
           fprintf('File for this subject already exists. Session 2?\n') 
           fprintf('________________________________________________\n')
       end
end 
options.day = ['day', input('Session? ','s')];
    
data.options = options;