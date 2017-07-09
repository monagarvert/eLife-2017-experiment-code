function [ keyout, t, n ] = waitkey( duration, keyin, event )
% WAITKEY Read and log previous keypresses.
%
% Wait for a specific key to be pressed after the call to waitkey.
% All key presses will be automatically read and logged.
%
% Cogent 2000 function
%
% $Rev: 218 $ $Date: 2010-10-27 12:06:55 +0100 (Wed, 27 Oct 2010) $

global cogent;

t0 = time;
keyout = [];
t = [];
n = 0;

% Handle any pending key presses from before waitkey call
readkeys;
logkeys;

while isempty(keyout)  &  time-t0 < duration
    
    readkeys;
    logkeys;
    
    if isempty(keyin)
        index = find( cogent.keyboard.value == event );
    else
        index = find( cogent.keyboard.value == event & ismember(cogent.keyboard.id,keyin) );
    end
    
    keyout = cogent.keyboard.id( index );
    t      = cogent.keyboard.time( index );
    n      = length( index );
    
    pause(0.001)
    
end