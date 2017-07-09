
%% Subject-specific information
% =========================================================================
if strcmp(options.day,'day1')
    if exist(sprintf('%s.mat',data.fname),'file')~=0;
        disp('file for this subject exists already! aborting...')
        clear all; return;
    end 

    data.initials       = input('Subject initials?  ','s');
    data.age            = input('Subject age?    ', 's');
    data.gender         = input('Subject gender?    ', 's');
    data.hand           = input('Subject handedness?  ','s');
    data.logfile        = [ data.fname '.log'];
end
mkdir('\\asia\DeletedDaily\mg\datafiles')
save(sprintf('//asia/DeletedDaily/mg/%s',data.fname),'data');  


%% Start cogent
% =========================================================================
try
    foo = cgkeymap; % error if cgopen has not been called, and go to catch
    % if cgopen has already been called: use initials and subject from
    %arguments
    independent = 0; %script not running on its own
catch %if an error is thrown, i.e. no cogent window open
    independent = 1; %script running on its own

    bg                  = [0.5 0.5 0.5];  % background colour (optional)
    fontcol             = [1 1 1];        % foreground colour (optional)
    fontName            = 'Arial'; 
    fontSize            = 20;
    screenMode          = options.screensize;     % 0 for small window, 1 for full screen, 2 for second screen if attached
    screenRes           = 3;              % 1=640x480; 2=800x600; 3=1024x768 - use 3 for projector
    number_of_buffers   = 9;              % how many offscreen buffers to create- FOR ACCURATE TIMING OF STIM PRESENTATION

    config_keyboard; 
    config_display(screenMode, screenRes, bg ,fontcol, fontName, fontSize, number_of_buffers,0);   % open graphics window

    data.when_start     = datestr(now,0);
    start_cogent;
end

if strcmp(options.day,'day1')
    % Log participant information
    logstring('%=======================');
    logstring(['FILE: ' data.fname]);
    logstring(['Subj: ' data.subject]); 
    logstring(['Age:  ' data.age]);
    logstring('%=======================');

    %% Load stimuli
    % =====================================================================================================
    
    stims = load([options.root,'\stimuli\stim_',num2str(mod(data.subjNo,100))]); 
    data.stimuli    = stims.stimuli(randperm(12)); 
    
    while ismember(21,data.stimuli(options.testelements))
        data.stimuli    = stims.stimuli(randperm(12));
    end
end

