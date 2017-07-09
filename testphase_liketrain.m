%% Training phase
% =========================================================================
global tbl

format short
scale = {'Guess'; 'Uncertain';'Somewhat certain';'Very certain'};

% Load correspondingstimuli
for i = 1:length(data.stimuli)
%     cgloadbmp(i,[options.root,sprintf('/stimuli/%u.bmp',data.stimuli(i))]);
    cgloadbmp(data.sprite1(i),[options.root,sprintf('/stimuli/%u.bmp',data.stimuli(i))]);
    cgloadbmp(data.sprite2(i),[options.root,sprintf('/stimuli/%u_mirr.bmp',data.stimuli(i))]);    
end

% Specify buttons
keymap      = getkeymap;
option(1)   = 28;            % F
option(2)   = 31;           % J   

rating      = 28:31;

% Start
cgalign('c','c')
cgflip(0.5,0.5,0.5)
cgpencol(1,1,1)
cgfont('Arial', 50)
cgtext(sprintf('Start of block %u',tbl),0,100)
cgfont('Arial', 30)
cgtext('Press any button to start.',0,0)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

t1  =  time;
logstring(sprintf('Start test block %u: %u',tbl,t1));
data.test{tbl}.when_start     = datestr(now,0);
    
for trial = 1:length(data.test{tbl}.seq)
    
    disp(trial)
    
    cgpencol(1,1,1);
    cgfont('Arial', 50)
    cgtext('How often have you seen this order?',0,200)
    cgdrawsprite(data.test{tbl}.seq(trial,1),0,0)
    cgflip(0.5,0.5,0.5)
    wait(1500)
    cgfont('Arial', 50)
    cgtext('How often have you seen this order?',0,200)
    cgflip(0.5,0.5,0.5)
    wait(100)
    cgpencol(1,1,1);
    cgfont('Arial', 50)
    cgtext('How often have you seen this order?',0,200)
    cgdrawsprite(data.test{tbl}.seq(trial,2),0,0)
    cgflip(0.5,0.5,0.5)
    wait(1500)
    
    
    %collect rating
    cgmouse;
    timelimit = Inf;
    tstart = time;               %get time in ms from first time call

    cgpencol(1,1,1);
    cgfont('Arial', 50)
    cgtext('How often have you seen this order?',0,200)
    cgfont('Arial', 30)
    cgtext('Often',250,40)
    cgtext('Never',-250,40)

    cgpencol(0.8,0.8,0.8)
    cgrect(0,0,500,5)
    cgflip(0.5,0.5,0.5);
    randstart = randi([-250,250]);
    cgmouse(0,-200); %mouse jumps to random location on line

    tcue = time;

    mp = 0;                                
    while (mp < 1) && time < tstart + timelimit;
        cgpencol(1,1,1);
        cgfont('Arial', 50)
        cgtext('How often have you seen this order?',0,200)
        cgfont('Arial', 30)
        cgtext('Often',250,40)
        cgtext('Never',-250,40)

        cgpencol(0.8,0.8,0.8)
        cgrect(0,0,500,5)

        % update mouse position
        [P(1), P(2), md, mp] = cgmouse;
        I = min(max(-250, P(1)),250);

        cgpencol(1,0,0); cgellipse(I,0,12,12,'f');

        if md == 25, return; end; %hold down ctl-shift-leftmouse to quit
        cgflip(0.5,0.5,0.5);
    end

    tstop = time;

    data.test{tbl}.RT(trial) = tstop-tcue;
    data.test{tbl}.rate(trial) = 1-(I-(-250))/500;

    wait (1500)
    save ([options.root,'datafiles/',data.subject],'data');

    if mod(trial,length(data.test{tbl}.seq)/4) == 0 && trial ~= length(data.test{tbl}.seq)
        save(sprintf('//asia/DeletedDaily/mg/%s',data.fname),'data');
    
        block = trial/(length(data.test{tbl}.seq)/4);
        data.test{tbl}.start_break{block}     = datestr(now,0);

        cgpencol(1,1,1);
        cgfont('Arial', 50)
        cgtext('End of block.',0,100)
        cgfont('Arial', 30)
        cgtext('Please take a break.',0,-50)
        cgtext('Press any button when you are ready to continue.',0,-100)
        cgflip(0.5,0.5,0.5);
        waitkeydown(inf)

        cgfont('Arial', 50)
        cgtext(sprintf('Start of block %u',block+1),0,100)
        cgfont('Arial', 30)
        cgtext('Press any button to start.',0,0)
        cgflip(0.5,0.5,0.5);
        waitkeydown(inf)
        data.test{tbl}.end_break{block}     = datestr(now,0);

    end
end



t1  =  time;
logstring(sprintf('End test block %u: %u',tbl,t1));

data.test{tbl}.when_end     = datestr(now,0);
try
    save(sprintf('//asia/DeletedDaily/mg/%s',data.fname),'data');
    save ([options.root,'/datafiles/',data.subject],'data');
catch
    disp('Error')
end