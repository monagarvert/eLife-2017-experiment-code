global test
global root 
 
graph_hexagon

%% Critical link - distance 2
t = 1;
test{1}{t}.vertex = 4;
test{1}{t}.space = 8;
test{1}{t}.control = 6;

t = t+1;
test{1}{t}.vertex = 8;
test{1}{t}.space = 4;
test{1}{t}.control = 10;

%% Critical link - distance 3
t = t+1;
test{1}{t}.vertex = 1;
test{1}{t}.space = 8;
test{1}{t}.control = [9 11];

t = t+1;
test{1}{t}.vertex = 12;
test{1}{t}.space = 4;
test{1}{t}.control = [2 3];

%% Distance 2
t = 1;
test{2}{t}.vertex = 1;
test{2}{t}.space = 6;
test{2}{t}.control = [5 7];

t = t+1;
test{2}{t}.vertex = 2;
test{2}{t}.space = [7 9];
test{2}{t}.control = [3 8];

t = t+1;
test{2}{t}.vertex = 3;
test{2}{t}.space = [5 11];
test{2}{t}.control = [2 10];

t = t+1;
test{2}{t}.vertex = 4;
test{2}{t}.space = 10;
test{2}{t}.control = [6 9 11];

t = t+1;
test{2}{t}.vertex = 5;
test{2}{t}.space = [3 11];
test{2}{t}.control = [1 7 12];

t = t+1;
test{2}{t}.vertex = 6;
test{2}{t}.space = [1 8];
test{2}{t}.control = [4 11];

t = t+1;
test{2}{t}.vertex = 7;
test{2}{t}.space = [2 9];
test{2}{t}.control = [1 5 12];

t = t+1;
test{2}{t}.vertex = 8;
test{2}{t}.space = 6;
test{2}{t}.control = [2 3 10];

t = t+1;
test{2}{t}.vertex = 9;
test{2}{t}.space = [2 7];
test{2}{t}.control = [4 11];

t = t+1;
test{2}{t}.vertex = 10;
test{2}{t}.space = [4 12];
test{2}{t}.control = [3 8];

t = t+1;
test{2}{t}.vertex = 11;
test{2}{t}.space = [3 5];
test{2}{t}.control = [4 6 9];

t = t+1;
test{2}{t}.vertex = 12;
test{2}{t}.space = 10;
test{2}{t}.control = [5 7];

%% Distance 3
t = 1;
test{3}{t}.vertex = 10;
test{3}{t}.space = 2;
test{3}{t}.control = [1 5 9];

t = t+1;
test{3}{t}.vertex = 2;
test{3}{t}.space = 10;
test{3}{t}.control = [6 11 12];

t = t+1;
test{3}{t}.vertex = 6;
test{3}{t}.space = 9;
test{3}{t}.control = [2 5 12];

t = t+1;
test{3}{t}.vertex = 9;
test{3}{t}.space = 6;
test{3}{t}.control = [1 3 10];

%% Triangle
t = 1;
test{4}{t}.vertex = 1;
test{4}{t}.space = 8;
test{4}{t}.control = 6;

t=t+1;
test{4}{t}.vertex = 4;
test{4}{t}.space = 12;
test{4}{t}.control = 10;

t=t+1;
test{4}{t}.vertex = 8;
test{4}{t}.space = 1;
test{4}{t}.control = 6;

t=t+1;
test{4}{t}.vertex = 12;
test{4}{t}.space = 4;
test{4}{t}.control = 10;

%% Corner line
t = 1;
test{5}{t}.vertex = 8;
test{5}{t}.space = 3;
test{5}{t}.control = 1;

t=t+1;
test{5}{t}.vertex = 8;
test{5}{t}.space = 2;
test{5}{t}.control = 1;

t=t+1;
test{5}{t}.vertex = 4;
test{5}{t}.space = 11;
test{5}{t}.control = 12;

t=t+1;
test{5}{t}.vertex = 4;
test{5}{t}.space = 9;
test{5}{t}.control = 12;



a = [1 10];
count = 0;
count0 = 0;
count5 = 0;
while count < 100000
    clear total a
    count = count+1;
    if mod(count,100) == 0
        disp(count)
    end
    seq.order      = randperm(35);
    seq.vertex = [];
    seq.partner = [];
    seq.control = [];

    for trial = 1:4
        seq.vertex(seq.order == trial)  = test{1}{trial}.vertex;
        total = [seq.vertex seq.partner seq.control];
        a = histc(total,1:12);
        poss = find(a<floor(mean(a)));

        whichel = test{1}{trial}.space;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == trial)  = poss(randi(length(poss)));
        else
            seq.partner(seq.order == trial) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.control];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));

        whichel = test{1}{trial}.control;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.control(seq.order == trial)  = poss(randi(length(poss)));
        else
            seq.control(seq.order == trial)  = whichel(randi(length(whichel)));   
        end
    end
        
    %% ADDED!
    whichTrial = randi(4,2,1); while whichTrial(1) == whichTrial(2), whichTrial = randi(4,2,1); end
    for trial = 32:33
        
        seq.vertex(seq.order == trial)  = test{4}{whichTrial(trial-31)}.vertex;
        seq.partner(seq.order == trial)  = test{4}{whichTrial(trial-31)}.space;
        seq.control(seq.order == trial)  = test{4}{whichTrial(trial-31)}.control;
    end
    
    whichTrial = randi(4,2,1); while whichTrial(1) == whichTrial(2), whichTrial = randi(4,2,1); end
    for trial = 34:35
        
        seq.vertex(seq.order == trial)  = test{5}{whichTrial(trial-33)}.vertex;
        seq.partner(seq.order == trial)  = test{5}{whichTrial(trial-33)}.space;
        seq.control(seq.order == trial)  = test{5}{whichTrial(trial-33)}.control;
    end
    
    total = [seq.vertex seq.partner seq.control];
    a = histc(total,1:12);    
    %%
    
    whichDist2 = randi(12,2,1); while whichDist2(1) == whichDist2(2), whichDist2 = randi(12,2,1); end
    for trial = 5:6
        
        seq.vertex(seq.order == trial)  = test{2}{whichDist2(trial-4)}.vertex;
        total = [seq.vertex seq.partner seq.control];
        a = histc(total,1:12);
        poss = find(a<floor(mean(a)));
        poss = poss(~ismember(poss,[4 7 8]));
            
        whichel = test{2}{whichDist2(trial-4)}.space;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == trial)  = poss(randi(length(poss)));
        else
            poss = find(a<floor(mean(a)));
            if ismember(whichel,poss)       
                poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
                seq.partner(seq.order == trial)  = poss(randi(length(poss)));
            else
                seq.partner(seq.order == trial) = whichel(randi(length(whichel)));    
            end
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.control];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));
        poss = poss(~ismember(poss,[4 7 8]));
        
        whichel = test{2}{whichDist2(trial-4)}.control;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.control(seq.order == trial)  = poss(randi(length(poss)));
        else
            poss = find(a<floor(mean(a)));
            if ismember(whichel,poss)
                poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
                seq.control(seq.order == trial)  = poss(randi(length(poss)));
            else
                seq.control(seq.order == trial)  = whichel(randi(length(whichel)));   
            end
        end
    end
    total = [ seq.vertex seq.partner seq.control];
    a = histc(total,1:12);    

    whichDist3 = randi(4,2,1); while whichDist3(1) == whichDist3(2), whichDist3 = randi(4,2,1); end
    for trial = 7:8
        
        seq.vertex(seq.order == trial)  = test{3}{whichDist3(trial-6)}.vertex;
        total = [seq.vertex seq.partner seq.control];
        a = histc(total,1:12);
        poss = find(a<floor(mean(a)));

        whichel = test{3}{whichDist3(trial-6)}.space;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == trial)  = poss(randi(length(poss)));
        else
            seq.partner(seq.order == trial) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.control];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));

        whichel = test{3}{whichDist3(trial-6)}.control;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.control(seq.order == trial)  = poss(randi(length(poss)));
        else
            seq.control(seq.order == trial)  = whichel(randi(length(whichel)));   
        end
    end
    
    total = [ seq.vertex seq.partner seq.control];
    a = histc(total,1:12);    

    orderOfObjects = randi(2,23,1);
    for trial = 9:8+size(edge,2)/2       %% Trials for which the control stimulus is distance 3 away

        % Find elements that are the least common
        seq.vertex(seq.order == trial) = edge{trial-8 + size(edge,2)/2*(orderOfObjects(trial-8)-1)}.vertex;    
        seq.partner(seq.order == trial) = edge{trial-8 + size(edge,2)/2*(orderOfObjects(trial-8)-1)}.partner;     
        
        % Update the numbers
        total = [ seq.vertex seq.partner seq.control];
        a = histc(total,1:12);   
        
        % Find elements that are the least common
        [~,poss] = find(a == min(a));
        
%         % Find possible controls
        whichel = edge{trial-8 + size(edge,2)/2*(orderOfObjects(trial-8)-1)}.controls;

       % Is one of those  elements one of the non-common elements?
        if sum(ismember(whichel,poss))>0
            poss = whichel(ismember(whichel,poss));  % if so, pick one of these as the partner
            poss = poss(~ismember(poss,[4 7 8]));
            if ~isempty(poss)
                seq.control(seq.order == trial) = poss(randi(length(poss)));    
            else
                [~,poss] = find(a < mean(a));
                poss = whichel(ismember(whichel, poss));  % if so, pick one of these as the partner
                seq.control(seq.order == trial) = poss(randi(length(poss)));    
            end
         
        else
            poss = find(a<floor(mean(a)));
            poss = poss(~ismember(poss,[4 7 8]));
            if sum(ismember(whichel,poss))>0
                poss = whichel(ismember(whichel,poss));  % if so, pick one of these as the partner
                seq.control(seq.order == trial) = poss(randi(length(poss)));    
            else
                [~,poss] = find(a < mean(a));
                seq.control(seq.order == trial) = whichel(randi(length(whichel)));   
            end
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.control];
        a = histc(total,1:12);   
    end

    alla(count) = var(a);
    
%     if var(a) == 0
%         count0 = count0+1;
%         save([root sprintf('/var0/seq_vers3_%u.mat',count0)],'seq')
%     elseif var(a) < 0.5
        count5 = count5+1;
        save([root sprintf('/var5/seq_vers3_%u.mat',count5)],'seq')
%     end
    if var(a) < rememberVar
        rememberVar = var(a);
        rememberSeq = seq;
        figure; bar(a)
         count0 = count0+1;
        save([root sprintf('/var5/seq_vers3_%u.mat',count5)],'seq')
    end
end

