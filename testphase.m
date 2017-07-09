% Start
global tbl
global blocklength_test
global data
global test

% Specify buttons
keymap      = getkeymap;
option(1)   = 6;            % F
option(2)   = 10;           % J   

cgalign('c','c')
cgflip(0.5,0.5,0.5)
cgpencol(1,1,1)
cgfont('Arial', 50)
cgtext('Start of block.',0,100)
cgfont('Arial', 30)
cgtext('Press any button to start.',0,0)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

t1  =  time;
logstring(sprintf('Start test block %u: %u',tbl,t1));

% Load correspondingstimuli
for i = 1:length(data.stimuli)
    cgloadbmp(i,[root,sprintf('/stimuli/%u.bmp',data.stimuli(i))],200,200);
end

data.test{tbl}.when_start     = datestr(now,0);

cgpencol(1,1,1)
cgfont('Arial', 50)
cgtext('+',0,0)
cgflip(0.5,0.5,0.5);

% load ([root,sprintf('/Code/testsequences/seq_%u_l%u',tbl,blocklength_test)])
seq = testsequence(blocklength_test,testel);
data.test{tbl}.seq  = seq; 

for i = 1:testel
    cgloadbmp(i,[root,sprintf('/Code/stimuli/%u.bmp',imix(i))],150,150);
end
cgloadbmp(10,[root,'/Code/stimuli/correct.bmp'],0,0);
cgloadbmp(20,[root,'/Code/stimuli/incorrect.bmp'],0,0);
              
    
for trial = 1:blocklength_test
    cgdrawsprite(seq(1,trial),0,0)
    t = cgflip(0.5,0.5,0.5);
    [key, keyt, n] = waitkeydown(700, option);

    if isempty(key) 
        if (seq(1,trial) == 4)%2 || seq(1,trial) == 6)
            cgdrawsprite(seq(1,trial),0,0)
            cgfont('Arial', 50)
            cgtext('Too late!',0,-150)
            
            cgflip(0.5,0.5,0.5)
            
            data.test{bl}.RT(trial)        = 0;
            data.test{tbl}.choice(trial)    = -1;   % missed
            
        end
    else
        data.test{tbl}.RT(trial)        = keyt(1) - t*1000;
    
        cgpencol(1,1,1)
        cgrect (0,0,165,165,[0.8 0.8 0.8])
        
        cgdrawsprite(seq(1,trial),0,0)
        
        if seq(1,trial) == 4%2 || seq(1,trial) == 6
            cgtrncol(10,'w')
            cgdrawsprite(10,0,-200)
            data.test{tbl}.choice(trial)    = 1;   % correct 
        elseif seq(1,trial) ~= 4%2 && seq(1,trial) ~= 6
            cgtrncol(20,'w')
            cgdrawsprite(20,0,-200)
            data.test{tbl}.choice(trial)    = 2;   % wrong other
        end
    
        cgflip(0.5,0.5,0.5)
        
    end
    waituntil(t*1000+900)
    save ([root,sprintf('/Datafiles/data_%u',str2num(data.subject))],'data');  
end

data.test{tbl}.missed   = sum(data.test{tbl}.choice == -1);
data.test{tbl}.toomuch  = sum(data.test{tbl}.choice == 2);
data.test{tbl}.ok       = sum(data.test{tbl}.choice == 1);

data.test{tbl}.correct = (data.test{tbl}.ok - data.test{tbl}.toomuch)/(data.test{tbl}.missed + data.test{tbl}.ok)*100;
data.test{tbl}.meanRT   = [mean(data.test{tbl}.RT(data.test{tbl}.choice == 1)), std(data.test{tbl}.RT(data.test{tbl}.choice == 1))];

cgfont('Arial', 50)
cgtext('End of block',0,100)
cgfont('Arial', 30)
cgtext(sprintf('Correct button presses: %u%%',ceil(data.test{tbl}.correct)),0,30)
cgtext(sprintf('Average reaction time: %0.f ms',data.test{tbl}.meanRT(1)),0,0)
cgtext('Please take a break.',0,-70)
cgtext('Press any button when you are ready to continue.',0,-100)
cgflip(0.5,0.5,0.5);
waitkeydown(inf)

t1  =  time;
logstring(sprintf('End test block %u: %u',tbl,t1));

data.test{tbl}.when_end     = datestr(now,0);

try
    save(sprintf('//asia/DeletedDaily/mg/%s',data.fname(3:end)),'data');
catch
    disp('Error')
end
