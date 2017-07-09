%% randomSequence
% Generates a sequence in which each transition is probed exactly once
function seq = randomSequence(options)

ct = 1;
for i = 1:options.nodes
    for j = 1:options.nodes
        if i~=j
            totry(ct,:) = [i j ct];
            ct = ct+1;
        end
    end
end

for c = 10:50
    seq = []; 
    while length(seq) < length(totry)
        totry(:,4) = 0;
        start = randi(length(totry),1);
        totry(start,4) = 1;
        seq = []; seq(1,1:2) = totry(start,1:2);
        seq(3,2)    = totry(start,3);
        for trial = 3:length(totry)+1
            which   = find(totry(:,1) == seq(1,end) & totry(:,4) ==0);
            try
                if trial == 3
                    which        = find(totry(:,1) == seq(1,end)  & totry(:,4) ==0 & ~ismember(totry(:,2),seq(1,end-1:end))); 
                elseif trial == 4
                    which       = find(totry(:,1) == seq(1,end) & totry(:,4) ==0 & ~ismember(totry(:,2),seq(1,end-2:end))); 
                else
                    which       = find(totry(:,1) == seq(1,end) & totry(:,4) ==0 & ~ismember(totry(:,2),seq(1,end-3:end))); 
                end
                next    = which(randi(length(which)));

                seq(1,trial) = totry(next,2);
                seq(3,trial) = totry(next,3);
                totry(next,4) = 2;
            catch
                disp(length(seq))
            end
        end
    end
    save (sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/randomWalks/133/random/%u.mat',c),'seq')
end        
