%% Constructs graph
% nodes: number of nodes in this structure
% con: connections which are meant to be deleted

% Define connectivity/distances between vertices
Dist(1,:)=[0 1 2 1 2 3 2 3 4 3 4 5];
Dist(2,:)=[1 0 1 2 1 2 3 2 3 4 3 4];
Dist(3,:)=[2 1 0 3 2 1 4 3 2 5 4 3];
Dist(4,:)=[1 2 3 0 1 2 1 2 3 2 3 4];
Dist(5,:)=[2 1 2 1 0 1 2 1 2 3 2 3];
Dist(6,:)=[3 2 1 2 1 0 3 2 1 4 3 2];
Dist(7,:)=[2 3 4 1 2 3 0 1 2 1 2 3];
Dist(8,:)=[3 2 3 2 1 2 1 0 1 2 1 2];
Dist(9,:)=[4 3 2 3 2 1 2 1 0 3 2 1];
Dist(10,:)=[3 4 5 2 3 4 1 2 3 0 1 2];
Dist(11,:)=[4 3 4 3 2 3 2 1 2 1 0 1];
Dist(12,:)=[5 4 3 4 3 2 3 2 1 2 1 0];

Dist(5,8) = 3; Dist(8,5) = 3;
Dist(5,11)= 4; Dist(11,5)= 4;
Dist(8,2) = 4; Dist(2,8) = 4;
Dist(2,11)= 5; Dist(11,2)= 5;

%% All possible connections
% forward connections (1>2)
for i = 1:12
    vertex{i}.p      = find(Dist(i,:) == 1);
end

% Connections
vertex{1}.con=[1 3];
vertex{2}.con=[1 2 4];
vertex{3}.con=[2 5];
vertex{4}.con=[3 6 8];
vertex{5}.con=[4 6 7];
vertex{6}.con=[5 7 10];
vertex{7}.con=[8 11 13];
vertex{8}.con=[11 12 14];
vertex{9}.con=[10 12 15];
vertex{10}.con=[13 16];
vertex{11}.con=[14 16 17];
vertex{12}.con=[15 17];


%% Sequence

for start = 1:12
    seq{start}  = [];
    edg{start} = [];
    for num = 1:10000
        s  = start;
        count   = 0;
        for i = 2:12
            el          = randi(length(vertex{s(1,i-1)}.p));
            s(1,i)      = vertex{s(1,i-1)}.p(el);
            while ~isempty(find(s(1,1:i-1) == s(1,i))) & count < 100 % repetition of the same item
                el          = randi(length(vertex{s(1,i-1)}.p));
                s(1,i)  = vertex{s(1,i-1)}.p(el);
                count   = count+1;
            end
            s(2,i) = vertex{s(1,i-1)}.con(el);
            if count == 100
                break
            end
        end
        if count ~=100
            seq{start}(num,:) = s(1,:); 
            edg{start}(num,:) = s(2,:);
        end
    end
    seq{start}      = unique(seq{start},'rows');
    edg{start}      = unique(edg{start},'rows');
    if ~isempty(seq{start})
        seq{start}(1,:) = [];
        edg{start}(1,:) = [];
    end
end


    
e = figure;
c = figure;
el          = zeros(1,2*nodes);
sequenz     = randi(2*nodes);
el(sequenz) = 1;
ub          = zeros(1,3*nodes);
for i = 1:241
    ixMinUB = ub(vertex{sequenz(end)}.con) == min(ub(vertex{sequenz(end)}.con));
    ixMinEL = el(vertex{sequenz(end)}.p) == min(el(vertex{sequenz(end)}.p));
    b       = randi(length(ixMinUB & ixMinEL)) ;
    while ixMin(b)~=1
        b = randi(length(ixMinUB & ixMinEL));
    end
    sequenz(end+1)  = vertex{sequenz(end)}.p(b);
    el(sequenz(end)) = el(sequenz(end))+1;
    ub(vertex{sequenz(end-1)}.con(b)) = ub(vertex{sequenz(end-1)}.con(b)) + 1;
    
    figure (e), bar(el)    
    figure (c), bar(ub)
%     pause
    
end
        
        
