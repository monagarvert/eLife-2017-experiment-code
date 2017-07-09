%% Stimulus presentation order / genetic algorithm

global bl
global data
global options

% Order of stimulus presentation
data.train{bl}.edge                         = randperm(options.blocklength);
data.train{bl}.edge(data.train{bl}.edge>size(edge,2)) = data.train{bl}.edge(data.train{bl}.edge>size(edge,2))-size(edge,2);

for i = 1:options.blocklength
    data.train{bl}.vertex(i)    = edge{data.train{bl}.edge(i)}.vertex;
    data.train{bl}.partner(i)   = edge{data.train{bl}.edge(i)}.partner;
end

for i = 1:options.blocklength
    which = randi(numel(edge{data.train{bl}.edge(i)}.controls),options.controlno,1);
    while numel(unique(which))~=options.controlno
        which = randi(numel(edge{data.train{bl}.edge(i)}.controls),options.controlno,1);
    end
    data.train{bl}.nonass(i)  = edge{data.train{bl}.edge(i)}.controls(which);   
end

%% Count the total number of times that each object appears (as vertex/partner or control)
for i = 1:options.nodes
    st0(i) = sum(sum(data.train{bl}.nonass==i)) + sum(data.train{bl}.vertex==i) + sum(data.train{bl}.partner == i);
end
ideal = (size(data.train{bl}.nonass,1)*size(data.train{bl}.nonass,2) + 2*length(data.train{bl}.vertex))/options.nodes;
Var0 = var(st0);

%% Optimize the selection of controls such that each object occurs equally often 
count = 0;
while (max(st0) > ceil(ideal) || min(st0) < floor(ideal)) && count<1000
    count = count+1;
    testseq     = data.train{bl}.nonass;
    typeSeqA    = randi([1 options.blocklength],1,10);
    for tp = 1:10
        i = typeSeqA(tp);
        which   = randi(numel(edge{data.train{bl}.edge(i)}.controls),options.controlno,1);
        while numel(unique(which))~=options.controlno
            which   = randi(numel(edge{data.train{bl}.edge(i)}.controls),options.controlno,1);
        end
        testseq(i)  = edge{data.train{bl}.edge(i)}.controls(which);  

    end
    for i = 1:options.nodes
        stA(i) = sum(sum(testseq==i)) + sum(data.train{bl}.vertex==i) + sum(data.train{bl}.partner == i);
    end
    VarA = var(stA);
    
    if  VarA<Var0
        disp(count)
        disp(VarA)
        data.train{bl}.nonass = testseq;
        Var0 = VarA;
        st0  = stA;
    end
end
    
    