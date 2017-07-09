function seq = testseq_simple(blocklength_test)

%% Test phase
% =========================================================================

%% Define sequence
M = [1 2; 1 3; 1 4; 1 5; 1 6; 2 3; 2 4; 2 5; 2 6; 3 4; 3 5; 3 6; 4 5; 4 6; 5 6];
M = [M; M(:,[2 1])];

% Generate a random sequence without repetition
seq(1:2) = M(randi(30,1,1),:);
for i = 1:blocklength_test-1
    nextno = randi([1 6],1,1);
    while nextno == seq(i)
        nextno = randi([1 6],1,1);
    end
    seq(end+1) = nextno;
end
 
% Count how often each transition occurs
% trans   = zeros(30,1);                     % Set to 0, this is where the occurrences of each transition type is counted
% for trial = 2:blocklength_test                       % Go through the whole sequence and quantify the occurence of each transition (SS/SL/SI/...)
%    trans(ismember(M,[seq(trial-1), seq(trial)],'rows')) = trans(ismember(M,[seq(trial-1), seq(trial)],'rows'))+1;   % add this transition to the counter
% end     
% 
% % Genetic algorithm: Pick random locations and change their value, count
% % number of transitions again. If this one is better then stick to it, else
% % go back to the old sequence.
% seqA = seq;                 % Set the current sequence to seqA
% Var0 = var(trans);          % Determine variance of this sequence (Goal: minimization of this variance)
% % 
% while Var0>4
%     
%     loc = randi(blocklength_test-2,50,1);    % determine 30 positions randomly and replace these numbers by random elements
%     for i = 1:30
%         seq(loc(i)+1)  = randi(6,1,1);           % make sure it's not the first or last element
%         while seq(loc(i)+1) == seq(loc(i)+2) || seq(loc(i)+1) == seq(loc(i))
%             seq(loc(i)+1)  = randi(6,1,1);           % make sure it's not the first or last element
%         end
%     end
%     
%     transA   = zeros(30,1);                     % Set to 0, this is where the occurrences of each transition type is counted
%     for trial = 2:blocklength_test                       % Go through the whole sequence and quantify the occurence of each transition (SS/SL/SI/...)
%        transA(ismember(M,[seq(trial-1), seq(trial)],'rows')) = transA(ismember(M,[seq(trial-1), seq(trial)],'rows'))+1;   % add this transition to the counter
%     end     
%     VarA = var(transA);    % Determine variance of this sequence (Goal: minimization of this variance)
%     
%     if VarA<Var0                        % If this new variance is smaller than the initial variance (i.e. the new sequence is closer to the goal)
%         figure; bar(transA)
%         seq = seqA;             % Set this sequence as the new reference sequence
%         trans = transA;                 
%         Var0 = VarA;                    % Set this variance as the reference variance
%     end
% end
% disp(trans)                             % When done: display sequence    