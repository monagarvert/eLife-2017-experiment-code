global test
global nodes
global root 
 
graph_hexagon

%% Critical link - distance 2
t = 1;
test{t}.vertex = 4;
test{t}.straight = 8;
test{t}.curve = 6;

t = t+1;
test{t}.vertex = 8;
test{t}.straight = 4;
test{t}.curve = 10;

%% Critical link - distance 3
t = t+1;
test{t}.vertex = 1;
test{t}.straight = 8;
test{t}.curve = [9 11];

t = t+1;
test{t}.vertex = 12;
test{t}.straight = 4;
test{t}.curve = [2 3];

%% Distance 2
t = t+1;
test{t}.vertex = 1;
test{t}.straight = 6;
test{t}.curve = [5 7];

t = t+1;
test{t}.vertex = 2;
test{t}.straight = [7 9];
test{t}.curve = [3 8];

t = t+1;
test{t}.vertex = 3;
test{t}.straight = [5 11];
test{t}.curve = [2 10];

t = t+1;
test{t}.vertex = 4;
test{t}.straight = 10;
test{t}.curve = [6 9 11];

t = t+1;
test{t}.vertex = 5;
test{t}.straight = [3 11];
test{t}.curve = [1 7 12];

t = t+1;
test{t}.vertex = 6;
test{t}.straight = [1 8];
test{t}.curve = [4 11];

t = t+1;
test{t}.vertex = 7;
test{t}.straight = [2 9];
test{t}.curve = [1 5 12];

t = t+1;
test{t}.vertex = 8;
test{t}.straight = 6;
test{t}.curve = [2 3 10];

t = t+1;
test{t}.vertex = 9;
test{t}.straight = [2 7];
test{t}.curve = [4 11];

t = t+1;
test{t}.vertex = 10;
test{t}.straight = [4 12];
test{t}.curve = [3 8];

t = t+1;
test{t}.vertex = 11;
test{t}.straight = [3 5];
test{t}.curve = [4 6 9];

t = t+1;
test{t}.vertex = 12;
test{t}.straight = 10;
test{t}.curve = [5 7];

%% Distance 3
t = t+1;
test{t}.vertex = 10;
test{t}.straight = 2;
test{t}.curve = [1 5 9];

t = t+1;
test{t}.vertex = 2;
test{t}.straight = 10;
test{t}.curve = [6 11 12];

t = t+1;
test{t}.vertex = 6;
test{t}.straight = 9;
test{t}.curve = [2 5 12];

t = t+1;
test{t}.vertex = 9;
test{t}.straight = 6;
test{t}.curve = [1 3 10];


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
    seq.order      = randperm(40);
    seq.vertex = [];
    seq.partner = [];
    seq.control = [];

    for trial = 1:4
        seq.vertex(seq.order == trial)  = test{trial}.vertex;
        total = [seq.vertex seq.partner seq.control];
        a = histc(total,1:12);
        poss = find(a<floor(mean(a)));

        whichel = test{trial}.straight;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == trial)  = poss(randi(length(poss)));
        else
            seq.partner(seq.order == trial) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.order];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));

        whichel = test{trial}.curve;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.control(seq.order == trial)  = poss(randi(length(poss)));
        else
            seq.control(seq.order == trial)  = whichel(randi(length(whichel)));   
        end
    end
    total = [ seq.vertex seq.partner seq.control];
    a = histc(total,1:12);    

    whichDist2 = randi([5,16],2,1); while whichDist2(1) == whichDist2(2), whichDist2 = randi([5,16],2,1); end
    for trial = 5:6
        
        seq.vertex(seq.order == whichDist2(trial-4))  = test{whichDist2(trial-4)}.vertex;
        total = [seq.vertex seq.partner seq.control];
        a = histc(total,1:12);
        poss = find(a<floor(mean(a)));

        whichel = test{whichDist2(trial-4)}.straight;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == whichDist2(trial-4))  = poss(randi(length(poss)));
        else
            seq.partner(seq.order == whichDist2(trial-4)) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.order];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));

        whichel = test{whichDist2(trial-4)}.curve;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.control(seq.order == whichDist2(trial-4))  = poss(randi(length(poss)));
        else
            seq.control(seq.order == whichDist2(trial-4))  = whichel(randi(length(whichel)));   
        end
    end
    total = [ seq.vertex seq.partner seq.control];
    a = histc(total,1:12);    

    whichDist3 = randi([17,20],2,1); while whichDist3(1) == whichDist3(2), whichDist3 = randi([17,20],2,1); end
    for trial = 7:8:6
        
        seq.vertex(seq.order == whichDist3(trial-6))  = test{whichDist3(trial-6)}.vertex;
        total = [seq.vertex seq.partner seq.control];
        a = histc(total,1:12);
        poss = find(a<floor(mean(a)));

        whichel = test{whichDist3(trial-6)}.straight;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == whichDist3(trial-6))  = poss(randi(length(poss)));
        else
            seq.partner(seq.order == whichDist3(trial-6)) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.order];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));

        whichel = test{whichDist3(trial-6)}.curve;
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.control(seq.order == whichDist3(trial-6))  = poss(randi(length(poss)));
        else
            seq.control(seq.order == whichDist3(trial-6))  = whichel(randi(length(whichel)));   
        end
    end
    
    total = [ seq.vertex seq.partner seq.control];
    a = histc(total,1:12);    

    for trial = 21:30       %% Trials for which the control stimulus is distance 3 away

        % Find elements that are the least common
        poss = find(a<floor(mean(a)) & ~ismember(1:12,[4,7,8]));
        % Pick one of those as the target stimulus
        if isempty(poss)
            seq.vertex(seq.order == trial) = find(min(a(~ismember(1:12,[4,7,8]))));    
        else
            seq.vertex(seq.order == trial) = poss(randi(length(poss)));    
        end
        
        % Update the numbers
        total = [ seq.vertex seq.partner seq.order];
        a = histc(total,1:12);   

        % Find elements that are the least common
        poss = find(a<floor(mean(a)));

        % Find neighbouring elements
        whichel = find(Dist(seq.vertex(seq.order == trial),:)==1);

        % Is one of those neighboring elements one of the non-common elements?
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == trial) = poss(randi(length(poss)));   
        else                            % Else pick any partner
            seq.partner(seq.order == trial) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.order];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));

        % Find elements that are 2 links away
        whichel = find(Dist(seq.vertex(seq.order == trial),:)==3);

        % Is one of those  elements one of the non-common elements?
        if ismember(whichel,poss)
            poss = whichel(ismember(whichel,poss));  % if so, pick one of these as the partner
            seq.control(seq.order == trial) = poss(randi(length(poss)));    
        else
            seq.control(seq.order == trial) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.control];
        a = histc(total,1:12);   
    end

    for trial = 31:40       %% Trials for which the control stimulus is distance 2 away

        % Find elements that are the least common
        poss = find(a<floor(mean(a)));
        if isempty(poss) && min(a) ~= max(a)
            poss = find(a<mean(a));
        elseif isempty(poss) && min(a) == max(a)
            poss = 1:12;
        end
        
        
        % Pick one of those as the target stimulus
        if var(poss) == 0
            seq.vertex(seq.order == trial) = randi(nodes);
        else
            seq.vertex(seq.order == trial) = poss(randi(length(poss)));
        end
        
        % Update the numbers
        total = [ seq.vertex seq.partner seq.order];
        a = histc(total,1:12);   

        % Find elements that are the least common
        poss = find(a<floor(mean(a)));

        % Find neighbouring elements
        whichel = find(Dist(seq.vertex(seq.order == trial),:)==1);

        % Is one of those neighboring elements one of the non-common elements?
        if ismember(whichel,poss)       
            poss = whichel(ismember(whichel,poss)); % if so, pick one of these as the partner
            seq.partner(seq.order == trial) = poss(randi(length(poss)));   
        else                            % Else pick any partner
            seq.partner(seq.order == trial) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.order];
        a = histc(total,1:12);   
        poss = find(a<floor(mean(a)));

        % Find elements that are 2 links away
        whichel = find(Dist(seq.vertex(seq.order == trial),:)==2);

        % Is one of those  elements one of the non-common elements?
        if ismember(whichel,poss)
            poss = whichel(ismember(whichel,poss));  % if so, pick one of these as the partner
            seq.control(seq.order == trial) = poss(randi(length(poss)));    
        else
            seq.control(seq.order == trial) = whichel(randi(length(whichel)));    
        end

        % Update the numbers
        total = [ seq.vertex seq.partner seq.control];
        a = histc(total,1:12);   
    end
    alla(count) = var(a);
    
    if var(a) == 0
        count0 = count0+1;
        save([root sprintf('var5/seq_%u.mat',count0)],'seq')
    elseif var(a) < 0.5
        count5 = count5+1;
        save([root sprintf('var5/seq_%u.mat',count5)],'seq')
    end
end

