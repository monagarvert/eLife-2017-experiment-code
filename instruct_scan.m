addpath('C:\Users\mgarvert\Cogent2000v1.32\Toolbox')

%% Load subj data
data.subjNo     = input('Subject ID?    '); 
data.subject    = ['scan_',num2str(data.subjNo)]; 
data.fname      = ['datafiles/',data.subject];
load (['\\asia\DeletedDaily\mg\' data.fname,'.mat']);

%% Specs
options.root        = 'C:\Users\mgarvert\Desktop\Peas\Code_9';
bg                  = [0.5 0.5 0.5];  % background colour (optional)
fontcol             = [1 1 1];        % foreground colour (optional)
fontName            = 'Arial'; 
fontSize            = 20;
screenMode          = 1;              % 0 for small window, 1 for full screen, 2 for second screen if attached
screenRes           = 3;              % 1=640x480; 2=800x600; 3=1024x768 - use 3 for projector
number_of_buffers   = 9;              % how many offscreen buffers to create- FOR ACCURATE TIMING OF STIM PRESENTATION

config_keyboard;    
config_display(screenMode, screenRes, bg ,fontcol, fontName, fontSize, number_of_buffers,0);   % open graphics window

data.when_start     = datestr(now,0);
start_cogent;

%% Stimuli   
PossStim = 1:31;
NoStim = PossStim(~ismember(PossStim,data.stimuli));
NoStim = NoStim(randperm(length(NoStim)));

for i = 1:6
    cgloadbmp(i,[options.root,sprintf('/stimuli/%u.bmp',NoStim(i))]);
end

option = [22 2];
if mod(data.subjNo,2)==0
    option = [2 22];
end

%% Instructions
cgflip(0.5,0.5,0.5);
cgfont('Arial', 50)
cgtext('Welcome back for session 2 of the experiment',0,100)
cgfont('Arial', 30)
cgtext('Press any button to start',0,0)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

cgflip(0.5,0.5,0.5);
cgfont('Arial', 40)
cgtext('You will now see the instructions for the task in the scanner.',0,100)
cgfont('Arial', 20)
cgtext('Press any button to continue',0,-250)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

cgfont('Arial', 30)
cgtext('Just like yesterday, you will be presented with sequences of objects.',0,180)
cgtext('Today, there will occasionally be grey patches on or around the object,',0,140)
cgtext('like here:',0,100)
cgloadbmp(10,[options.root,'/stimuli/13.bmp']);
cgdrawsprite(10,0,-40)
cgrect(-50,-110,15,15,[0.7 0.7 0.7])
cgtext('The location of the patch can change.',0,-200)
cgfont('Arial', 20)
cgtext('Press any button to see an example object sequence.',0,-250)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

key = 25;
order = randperm(6);
while key == 25
    for i = 1:6
        cgfont('Arial', 30)
        cgtext('This is an example sequence.',0,180)
        cgtext('Please note that the interval between objects can vary.',0,140)
        cgdrawsprite(i,0,-120)
        if sum(ismember(order(1:3),i))
            ix1 = randi(3)*30-60; ix2 = randi(3)*30-60;
            cgrect(ix1,ix2-120,15,15,[0.7 0.7 0.7]);
        end
        cgflip(0.5,0.5,0.5);
        wait(1000)
        cgfont('Arial', 30)
        cgtext('This is an example sequence.',0,180)
        cgtext('Please note that the interval between objects can vary.',0,140)
        cgfont('Arial', 50)
        cgtext('+',0,-120)
        cgflip(0.5,0.5,0.5);
        wait(randi(3)*1000)   
    end
    cgfont('Arial', 30)
    cgtext('Would you like to repeat the sequence? (y/n)',0,180)
    cgflip(0.5,0.5,0.5);
    key = waitkeydown(inf,[25 14]);
end

cgfont('Arial', 30)
cgtext('Please pay careful attention to the grey patch!',0,180)
cgtext('Your task will be to occasionally report whether you saw it or not:',0,140)
cgtext('If the cross after an object is white you do not need to do anything.',0,100)
cgfont('Arial', 50), cgtext('+',0,40)
cgfont('Arial', 30), cgpencol(1,1,1),
cgtext('If it is green, you need to indicate whether the preceding object had a patch or not.',0,-20)
cgfont('Arial', 50), cgpencol(0, 0.5, 0), cgtext('+',0,-80)
cgfont('Arial', 30), cgpencol(1,1,1),
cgfont('Arial', 20)
cgtext('Press any button to continue',0,-250)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

cgfont('Arial', 30)
if mod(data.subjNo,2)==1
    if sum(ismember(NoStim,27))
        cgloadbmp(10,[options.root,'/stimuli/27.bmp']);
        cgdrawsprite(10,0,95)
        cgdrawsprite(10,0,-135)
    else
        cgloadbmp(10,[options.root,'/stimuli/4.bmp']);
        cgdrawsprite(10,0,95)
        cgdrawsprite(10,0,-135)
    end
    cgrect(0,60,15,15,[0.7 0.7 0.7])
    
    cgtext('If you see a green cross and the previous object HAD A PATCH somewhere',0,250)
    cgtext('Please press the ''V'' with your right index finger.',0,210)
    
    cgtext('If you see a green cross and the previous object HAD NO PATCH',0,0)
    cgtext('Please press the ''B'' with your right middle finger.',0,-40)
else
    if sum(ismember(NoStim,27))
        cgloadbmp(10,[options.root,'/stimuli/27.bmp']);
        cgdrawsprite(10,0,95)
        cgdrawsprite(10,0,-135)
    else
        cgloadbmp(10,[options.root,'/stimuli/4.bmp']);
        cgdrawsprite(10,0,95)
        cgdrawsprite(10,0,-135)
    end
    cgrect(0,-170,15,15,[0.7 0.7 0.7])
    
    cgtext('If you see a green cross and the previous object HAD NO PATCH',0,250)
    cgtext('Please press the ''V'' with your right index finger.',0,210)
    
    cgtext('If you see a green cross and the previous object HAD A PATCH somewhere',0,0)
    cgtext('Please press the ''B'' with your right middle finger.',0,-40)
end
cgfont('Arial', 20)
cgtext('Press any button to continue',0,-250)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

key = 25;
cgfont('Arial', 30), cgpencol(1,1,1),
cgtext('Remember: Only press a button if the cross is green.',0,220)
cgfont('Arial', 60), cgpencol(0, 0.5, 0), cgtext('+',0,160)

cgfont('Arial', 30), cgpencol(1,1,1),
cgtext('Don''t do anything if the cross is white.',0,100)
cgfont('Arial', 60), cgtext('+',0,40)
cgfont('Arial', 30), 
cgtext('You will receive money relative to the number of correct button presses (£12 max).',0,-20)
cgtext('If you incorrectly press a button, this will be subtracted.',0,-60)
cgtext('Press any button for a short practice block.',0,-250)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

key = 25; 
while key == 25
    ct = 0;
    iti = [1 2 3];
    jitter = iti(randi(3,12,1))*1000;
    order = randperm(12);
    green = randperm(12);
    for i = [1:6 1:6]
        ct = ct+1;
        cgdrawsprite(i,0,0)
        if sum(ismember(order(1:6),ct))
            ix1 = randi(3)*30-60; ix2 = randi(3)*30-60;
            cgrect(ix1,ix2,15,15,[0.7 0.7 0.7]);
        end
        cgflip(0.5,0.5,0.5);
        tcue = time;
        key = waitkeydown(1000);
        if ~isempty(key)
            cgdrawsprite(i,0,0)
            if sum(ismember(order(1:6),ct))
                ix1 = randi(3)*30-60; ix2 = randi(3)*30-60;
                cgrect(ix1,ix2,15,15,[0.7 0.7 0.7]);
            end
            cgfont('Arial', 50), cgpencol(1,1,1)
            cgtext('Too early!',0,-120)
            cgflip(0.5,0.5,0.5);
        end
        waituntil(tcue+1000)
        cgfont('Arial', 60)
        if sum(ismember(green(1:6),ct))
            cgpencol(0,0.5,0)
        else cgpencol(1,1,1)
        end
        cgtext('+',0,0)
        cgflip(0.5,0.5,0.5);
        tcross = time;
        key = waitkeydown(jitter(ct));
        
        if isempty(key) 
            if sum(ismember(green(1:6),ct)) % you sould have pressed a button
                cgfont('Arial', 60)
                cgpencol(0,0.5,0)
                cgtext('+',0,0)
                cgfont('Arial', 50)
                cgfont('Arial', 50), cgpencol(1,1,1)
                cgtext('Missed!',0,-120)
                cgflip(0.5,0.5,0.5);
                wait(1000)
            end
        else
            if ~sum(ismember(green(1:6),ct))          
                cgfont('Arial', 60)
                cgpencol(1,1,1)
                cgtext('+',0,0)
                cgfont('Arial', 50)
                cgtext('White! Do not press a button!',0,-120)
            else
                cgfont('Arial', 60)
                cgpencol(0,0.5,0)
                cgtext('+',0,0)
                cgfont('Arial', 50)
                if (key(1) == option(1) && sum(ismember(order(1:6),ct))) ||  (key(1) == option(2) && ~sum(ismember(order(1:6),ct)))
                    cgtext('Correct!',0,-120)
                    disp('Correct')
                else
                    cgtext('Wrong!',0,-120)
                end
            end
            cgflip(0.5,0.5,0.5);
            wait(1000)
        end
        waituntil(tcross+jitter)
        
    end
    cgfont('Arial', 30), cgpencol(1,1,1)
    cgtext('Would you like to repeat the practice block? (y/n)',0,0)
    cgflip(0.5,0.5,0.5);
    key = waitkeydown(inf,[25 14]);
end

cgflip(0.5,0.5,0.5);
cgfont('Arial', 30)
cgtext('Please note that in the experiment you will not get feedback ',0,150)
cgtext('after you pressed a button!',0,100)
cgfont('Arial', 50)
cgtext('Good luck!',0,0)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

stop_cogent