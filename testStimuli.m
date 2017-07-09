
addpath('C:\Users\mgarvert\Cogent2000v1.32\Toolbox')

options.root        = 'C:\Users\mgarvert\Dropbox\Peas\Code_9';
bg                  = [0.5 0.5 0.5];  % background colour (optional)
fontcol             = [1 1 1];        % foreground colour (optional)
fontName            = 'Arial'; 
fontSize            = 20;
screenMode          = 0;     % 0 for small window, 1 for full screen, 2 for second screen if attached
screenRes           = 3;              % 1=640x480; 2=800x600; 3=1024x768 - use 3 for projector
number_of_buffers   = 9;              % how many offscreen buffers to create- FOR ACCURATE TIMING OF STIM PRESENTATION

config_keyboard; 
config_display(screenMode, screenRes, bg ,fontcol, fontName, fontSize, number_of_buffers,0);   % open graphics window

data.when_start     = datestr(now,0);
start_cogent;

for i = 1:30
    cgloadbmp(1,[options.root,sprintf('/stimuli/%u_mirr.bmp',i)]);
    cgdrawsprite(1,0,-200)
    cgflip(0.5,0.5,0.5);
    pause
end

stimuli = [1 3 5 6 12 14 15 19 20 22 25 26];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_1','stimuli')

stimuli = [5 8 11 13 17 20 21 23 24 28 29 30];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_2','stimuli')

stimuli = [2 4 6 10 11 15 16 17 20 21 29 30];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_3','stimuli')

stimuli = [1 3 10 11 12 16 18 19 22 23 26 27];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_4','stimuli')

stimuli = [1 5 6 7 8 10 15 23 24 29 30 31];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_5','stimuli')

stimuli = [3 11 15 16 17 19 21 22 25 26 28 31];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_6','stimuli')

stimuli = [1 2 5 7 8 18 20 21 23 29 30 31];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_7','stimuli')

stimuli = [2 3 6 11 14 17 18 19 22 25 27 31];
save('C:\Users\mgarvert\Dropbox\Peas\Code_9\stimuli\stim_8','stimuli')
