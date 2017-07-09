function seq = GenerateRandomSubGridSeq(options)

count = 1;
for i = 1:100000
    top = 0;
    clear seq
    seq(1,1:2) = randi(length(options.testelements),1,2);
    M(seq(1,1),seq(1,2)) = 1;
    M = zeros(length(options.testelements),length(options.testelements));
    for i = 3:options.testBlocklength

        seq(1,i) = randi(length(options.testelements));
        while seq(1,i)>7 || seq(1,i) == seq(1,i-1) || seq(1,i) == seq(1,i-2) || M(seq(1,i-1),seq(1,i)) >2
            seq(1,i) = randi(length(options.testelements));
            top=top+1;
            if top > 10000
                break
            end
        end
        M(seq(1,i-1),seq(1,i)) = M(seq(1,i-1),seq(1,i))+1;
        seq(3,i) = sub2ind([7,7],seq(1,i-1),seq(1,i));
    end
    if sum(max(M)==3) == 7
        disp(M)
        break
    end        
end
disp(seq)

for i = length(options.testelements):-1:1
    seq(1,seq(1,:)==i) = options.testelements(i);
end