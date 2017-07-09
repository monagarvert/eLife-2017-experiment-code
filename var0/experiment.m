%% Pea experiment
% 
% saved as data_#.mat in ../datafiles
%
%
%  Mona Garvert 12-2013
%__________________________________________________________________________
% Copyright (C) 2013 Wellcome Trust Centre for Neuroimaging

%% Define variables
% =========================================================================
defineOptions;

%% Start cogent and setup experiment
% =========================================================================
setup

%% Load structure
graph_hexagon     % 12 vertices, 1 connection deleted

%% Passive exposure to each stimulus orientation
% =========================================================================

cgflip(0.5,0.5,0.5);
cgfont('Arial', 50)
cgtext('Welcome to the experiment',0,100)
cgfont('Arial', 30)
cgtext('Press any button to start',0,0)
cgflip(0.5,0.5,0.5);
if ~(options.testrun), waitkeydown(inf), end

if strcmp(options.day, 'day1')
    load ([options.root, sprintf('randomWalks/133/combined_10/%u.mat',data.subjNo)])
    seqOrder = wO(randperm(length(wO)));
    exposure
    bl = 1;    
else
    seqOrder = randi(50,10,1); while numel(seqOrder)<options.testblocks, seqOrder = randi(50,10,1);end
    bl = options.trainblocks + 1;
   
    cgpencol(1,1,1)
    cgfont('Arial', 30)
    cgtext('You probably remember yesterday''s task:',0,150)
    cgtext('You will see a sequence of stimuli. Each stimulus will be in one of two orientations.' ,0,110)
    cgtext('The orientations will be mirror images of each other.' ,0,70)
    cgtext('Your task is to press one button if a stimulus is in one orientation' ,0,30)
    cgtext('and another button if the stimulus is in a different orientation.' ,0,-10)
    cgtext('The buttons and orientations are the same as yesterday.' ,0,-50)
    cgtext('There will be ten blocks again.' ,0,-90)
    cgtext('Please try to be as ACCURATE and FAST as possible!' ,0,-130)
    cgflip(0.5,0.5,0.5)
    waitkeydown(inf)
end

%% Training phase
% =========================================================================
if strcmp(options.day, 'day1')
    limit = options.trainblocks;
else
    limit = options.trainblocks + options.testblocks;
end

while  bl <= limit


    if strcmp(options.day, 'day1')
        data.train{bl} = load([options.root sprintf('randomWalks/133/%u.mat',seqOrder(bl))]);
        data.train{bl}.ChosenSequence = seqOrder(bl);
    else
        data.train{bl} = load([options.root sprintf('/randomWalks/133/random/%u.mat',seqOrder(bl-options.trainblocks))]);
        data.train{bl}.ChosenSequence = seqOrder(bl-options.trainblocks);
    end
    
    % Pick 50% for orientation flip
    data.train{bl}.seq(2,:) = 0;
    for i = 1:12
        ix = find(data.train{bl}.seq(1,:) == i);
        swap = ix(randperm(length(ix)));
        data.train{bl}.seq(2,swap(1:length(swap)/2)) = 1;
    end

    training 

    pc  = data.train{bl}.correct;   % Percent correct
    mRT = data.train{bl}.meanRT;    % Mean Reaction time

    pc(bl)  = data.train{bl}.correct;   % Percent correct
    mRT(bl) = data.train{bl}.meanRT(1);    % Mean Reaction time

    bl = bl+1;
end

cgpencol(1,1,1)
cgfont('Arial', 50)
cgtext('End of the experiment',0,100)
cgfont('Arial', 30)
cgtext('Thank you very much for participating',0,-50)
cgflip(0,0,0);
if ~options.testrun
    waitkeydown(inf,1)
    waitkeydown(inf,3)
else
    wait(2000)
end

%% Analyze
analysis