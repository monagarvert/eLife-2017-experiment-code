function waitrecord
% WAITRECORD wait for recording to finish
%
% Description:
%    Wait for recording to finish.
%
% Usage:
%    WAITRECORD
%
% Arguments:
%    NONE
%
% See also:
%     PREPARERECORDING, GETRECORDING, RECORDSOUND
%
% Cogent 2000 function.
%
% $Rev: 218 $ $Date: 2010-10-27 12:06:55 +0100 (Wed, 27 Oct 2010) $


while( CogCapture('recording') )
end