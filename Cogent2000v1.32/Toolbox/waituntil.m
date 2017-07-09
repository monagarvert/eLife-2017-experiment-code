function waituntil( t )
% WAITUNTIL waits until specified time.
%
% Description:
%     Wait until specified time (as measured by function TIME)
%
% Usage:
%     WAITUNTIL( t )
%
% Arguments:
%     t - time in milliseconds measured by function TIME
%
% Examples:
%     WAITUNTIL( 10000 )     - wait until 10000 milliseconds after START_COGENT
%     WAITUNTIL( TIME+1000)  - wait for 1000 milliseconds
%
% See also:
%     TIME, WAIT, WAITUNTIL, START_COGENT
%
% Cogent 2000 function
%
% $Rev: 218 $ $Date: 2010-10-27 12:06:55 +0100 (Wed, 27 Oct 2010) $

while(time < t)
    pause(0.001)
end