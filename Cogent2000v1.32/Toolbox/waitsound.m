function waitsound( bufnum )
% WAITSOUND waits until a sound buffer has stopped playing.
%
% Description:
%     Waits until a sound buffer has stopped playing
%
% Usage:
%     WAITSOUND( buff ) - wait until buffer 'buff' has stopped playing
%
% Arguments:
%     buff - buffer number
%
% Examples:
%
% See also:
%     CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, WAITSOUND,
%     SOUNDPOSITION, LOOPSOUND, STOPSOUND.
%
% Cogent 2000 function.
%
% $Rev: 218 $ $Date: 2010-10-27 12:06:55 +0100 (Wed, 27 Oct 2010) $

global cogent;

error( checksound(bufnum) );

while(  CogSound( 'playing', cogent.sound.buffer(bufnum) )  )
end