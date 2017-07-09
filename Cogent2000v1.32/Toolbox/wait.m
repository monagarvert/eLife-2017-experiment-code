function wait( duration )
% WAIT waits for a specified duration
%
% Description:
%     Wait for a specified duration (milliseconds)
%
% Usage:
%     WAIT( duration )
%
% Arguments:
%     duration - time in milliseconds to wait
%
% Examples:
%     WAIT( 1000 ) - wait for 1000 milliseconds
%
% See also:
%     TIME, WAIT, WAITUNTIL, START_COGENT
%
% Cogent 2000 function.
%
% $Rev: 218 $ $Date: 2010-10-27 12:06:55 +0100 (Wed, 27 Oct 2010) $

t=time+duration;
while( time < t )
    pause(0.001)
end