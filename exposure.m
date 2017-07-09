%% Display each stimulus before training to faciliate learning

% Specify buttons
keymap      = getkeymap;
option(1) = 6;     % J
option(2) = 10;      % F

if mod(data.subjNo,2)==0
    option(1) = 10;     % J
    option(2) = 6;      % F
end

% Load corresponding stimuli
for i = 1:length(data.stimuli)
    data.sprite1(i) = i + (randi(2)-1)*20;
    if data.sprite1(i) < 20
        data.sprite2(i) = data.sprite1(i) + 20;
        cgloadbmp(data.sprite1(i),[options.root,sprintf('/stimuli/%u.bmp',data.stimuli(i))]);
        cgloadbmp(data.sprite2(i),[options.root,sprintf('/stimuli/%u_mirr.bmp',data.stimuli(i))]); 
    else
        data.sprite2(i) = data.sprite1(i) - 20;
        cgloadbmp(data.sprite1(i),[options.root,sprintf('/stimuli/%u_mirr.bmp',data.stimuli(i))]);
        cgloadbmp(data.sprite2(i),[options.root,sprintf('/stimuli/%u.bmp',data.stimuli(i))]);
    end  
end
    
cgpencol(1,1,1)
cgfont('Arial', 30)
cgtext('In this experiment you will see a sequence of objects.',0,150)
cgtext('Each object will be in one of two orientations.' ,0,110)
cgtext('The orientations will be mirror images of each other.' ,0,70)
cgtext('Your task will be to press one button if the object is in one orientation' ,0,30)
cgtext('and another button if the object is in a different orientation.' ,0,-10)
cgtext('Please place your left index finger on the "F"' ,0,-50)
cgtext('and your right index finger on the "J"' ,0,-90)
cgflip(0.5,0.5,0.5)
waitkeydown(inf)

cgpencol(1,1,1)
cgfont('Arial', 30)
cgtext('You will now see the objects in the two orientations and the corresponding buttons.',0,150)
cgtext('Please try to remember which button to press for which orientation.' ,0,110)
cgflip(0.5,0.5,0.5)
waitkeydown(inf)

order = randperm(length(data.stimuli));
cgflip(0.5,0.5,0.5)
% Display stimulus pairs until subjects press a button to continue
for trial = 1:length(data.stimuli)
    
    cgfont('Arial', 30)
    cgtext('If you see the object in the following orientation please press' ,0,180)
    cgfont('Arial', 50)
    if option(1) == 6, cgtext('F',0,100), else cgtext('J',0,100), end
    cgdrawsprite(data.sprite1(order(trial)),0,-100)
    cgflip(0.5,0.5,0.5)
    waitkeydown(inf)
    
    % Fixation cross
    cgfont('Arial', 30)
    cgtext('If you see the object in the following orientation please press' ,0,180)
    cgfont('Arial', 50)
    if option(1) == 10, cgtext('F',0,100), else cgtext('J',0,100), end
    cgdrawsprite(data.sprite2(order(trial)),0,-100)
    cgflip(0.5,0.5,0.5)
    
    waitkeydown(inf)
end

cgpencol(1,1,1)
cgfont('Arial', 30)
cgtext('Don''t worry if you feel like these are a lot of orientations to remember.',0,200)
cgtext('You will get feedback in the experiment which will help you learn.' ,0,160)
cgtext('Please try to be as ACCURATE and FAST as possible!',0,120)
cgtext('There will be twelve blocks in this experiment.' ,0,80)
cgtext('Please take a break in between blocks if you feel like.' ,0,40)
cgtext('Do you have any more questions?' ,0,0)
cgflip(0.5,0.5,0.5)
if ~options.testrun
    waitkeydown(inf,1)
    waitkeydown(inf,3)
else
    wait(2000)
end