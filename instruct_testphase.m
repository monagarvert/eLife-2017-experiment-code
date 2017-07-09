%% Presentation of instructions for the testphase
% =========================================================================

cgalign('c','c')
cgflip(0.3,0.3,0.3)

cgpencol(1,1,1)
cgfont('Arial', 50)
cgtext('Part 2',0,100)
cgfont('Arial', 30)
cgtext('Press any button to read the instructions.',0,0)
cgflip(0.3,0.3,0.3);

waitkeydown(inf)

cgtext('You will now be presented with a sequence of the objects.',0,200)
if testel == 6
    cgtext('Please press a button every time one of the following two objects appears:',0,150)
elseif testel == 4
    cgtext('Please press the ''J'' button every time the following object appears:',0,150)
end
cgtext('Make sure that you press as FAST and as ACCURATELY as possible.',0,-200)
cgtext('Press any button to start.',0,-250)

target  = [2 8];
stim = data.stimuli(target);
order   = randperm(2);

if testel == 6
    cgloadbmp(1,[root,sprintf('/Code/stimuli/%u.bmp',stim(order(1)))],150,150);
    cgdrawsprite(1,-90,0)

    cgloadbmp(1,[root,sprintf('/Code/stimuli/%u.bmp',stim(order(2)))],150,150);
    cgdrawsprite(1,90,0) 
elseif testel == 4
    cgloadbmp(1,[root,sprintf('/Code/stimuli/%u.bmp',data.stimuli(8))],150,150);
    cgdrawsprite(1,0,0)
end
cgflip(0.3,0.3,0.3);

waitkeydown(inf)