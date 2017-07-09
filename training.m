%% Training phase
% =========================================================================
cgsound('open')

%% Load stimuli
% Load corresponding stimuli
for i = 1:length(data.stimuli)
    if data.sprite1(i) < 20
        cgloadbmp(data.sprite1(i),[options.root,sprintf('/stimuli/%u.bmp',data.stimuli(i))]);
        cgloadbmp(data.sprite2(i),[options.root,sprintf('/stimuli/%u_mirr.bmp',data.stimuli(i))]); 
    else
        cgloadbmp(data.sprite1(i),[options.root,sprintf('/stimuli/%u_mirr.bmp',data.stimuli(i))]);
        cgloadbmp(data.sprite2(i),[options.root,sprintf('/stimuli/%u.bmp',data.stimuli(i))]);
    end   
end

% Specify buttons
keymap      = getkeymap;
option(1) = 6;     % J
option(2) = 10;      % F

if mod(data.subjNo,2)==0
    option(1) = 10;     % J
    option(2) = 6;      % F
end

imix = data.stimuli;    % 12 randomly picked stimuli

if strcmp(options.day, 'day1')
    block = bl;
else 
    block = bl-options.trainblocks;
end
    
% Start
cgalign('c','c')
cgflip(0.5,0.5,0.5);
cgpencol(1,1,1)
cgfont('Arial', 50)
cgtext(sprintf('Start of block %u',block),0,100)
cgfont('Arial', 30)
cgtext('Press any button to start.',0,0)
cgflip(0.5,0.5,0.5);
if ~options.testrun, waitkeydown(inf), else wait(5000), end

cgfont('Arial', 30)
cgtext('Please press the following button if the image is in the first orientation you saw:',0,100)
cgfont('Arial', 50)
if option(1) == 6, cgtext('F',0,50), else cgtext('J',0,50), end
cgfont('Arial', 30),
cgtext('Please press the following button if the image is in the second orientation you saw:',0,-50)
cgfont('Arial', 50)
if option(1) == 6, cgtext('J',0,-100), else cgtext('F',0,-100), end
cgflip(0.5,0.5,0.5);
if ~options.testrun, waitkeydown(inf), else wait(5000), end

t1  =  time;
logstring(sprintf('Start training block %u: %u',bl,t1));
data.train{bl}.when_start     = datestr(now,0);
data.train{bl}.choice         = zeros(1,options.blocklength);

for trial = 1:length(data.train{bl}.seq)
    
    disp(trial)
    
    % Present choices
    if data.train{bl}.seq(2,trial) == 0
        cgdrawsprite(data.sprite1(data.train{bl}.seq(1,trial)),0,0)
        data.train{bl}.type = 1;
    else
        cgalign('c','c')
        cgdrawsprite(data.sprite2(data.train{bl}.seq(1,trial)),0,0)
        data.train{bl}.type = -1;
    end
    t = cgflip(0.5,0.5,0.5);      % Presentation of stimulus

    % Subject response
    if ~options.testrun, [key, keyt, n] = waitkeydown(1500, option);
    else key = option(randi(2)); keyt = t+ randi([200 500]); end
    
    % Response
    if isempty(key)
        if data.train{bl}.seq(2,trial) == 0
            cgdrawsprite(data.sprite1(data.train{bl}.seq(1,trial)),0,0)
        else
            cgdrawsprite(data.sprite2(data.train{bl}.seq(1,trial)),0,0)
        end
        
        data.train{bl}.RT(trial)          = 0;
        data.train{bl}.choice(trial)      = 0;
        data.train{bl}.cr(trial)          = 0;
        cgfont('Arial', 50)
        cgtext('Too late!',0,-200)
    else
        if data.train{bl}.seq(2,trial) == 0
            cgdrawsprite(data.sprite1(data.train{bl}.seq(1,trial)),0,0)
        else
            cgdrawsprite(data.sprite2(data.train{bl}.seq(1,trial)),0,0)
        end

        data.train{bl}.RT(trial)          = keyt(1) - t*1000;
        data.train{bl}.choice(trial)      = find(option == key(1));

        %% Feedback

        if data.train{bl}.seq(2,trial) == 0
            cgdrawsprite(data.sprite1(data.train{bl}.seq(1,trial)),0,0)
        else
            cgdrawsprite(data.sprite2(data.train{bl}.seq(1,trial)),0,0)
        end

    
        if (key(1) == option(1) && data.train{bl}.seq(2,trial) == 0) || (key(1) == option(2) && data.train{bl}.seq(2,trial) == 1)
            cgloadbmp(50,[options.root,'/stimuli/correct.bmp']);
            data.train{bl}.cr(trial) = 1;
        else
            cgloadbmp(50,[options.root,'/stimuli/incorrect.bmp']);
            data.train{bl}.cr(trial) = -1;
        end
        cgdrawsprite(50,0,-200)
    end
    
    cgflip(0.5,0.5,0.5);
    % ITI
    waituntil(t*1000+1800)
    save ([options.root,'/datafiles/',data.subject],'data');
end

data.train{bl}.correct  = sum(data.train{bl}.cr == 1)/numel(data.train{bl}.cr)*100;
data.train{bl}.meanRT   = [mean(data.train{bl}.RT(data.train{bl}.cr == 1)), std(data.train{bl}.RT(data.train{bl}.cr == 1))];

cgflip(0.5,0.5,0.5);

cgpencol(1,1,1)
cgfont('Arial', 50)
cgtext('End of block.',0,100)
cgfont('Arial', 30)
cgtext(sprintf('Correct choices in this block: %u%%',ceil(data.train{bl}.correct)),0,30)
cgtext(sprintf('Average reaction time: %0.f ms',data.train{bl}.meanRT(1)),0,0)
cgtext('Please take a break.',0,-70)
cgtext('Press any button when you are ready to continue.',0,-100)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

t1  =  time;
logstring(sprintf('End training block %u: %u',bl,t1));

data.train{bl}.when_end     = datestr(now,0);
try
    save(sprintf('//asia/DeletedDaily/mg/%s',data.fname),'data');
    save ([options.root,'/datafiles/',data.subject],'data');
catch
    disp('Error')
end