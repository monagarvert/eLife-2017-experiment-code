%% Define graph
% =========================================================================

Define connectivity/distances between vertices
Dist(1,:)=[0 1 1 1 2 2 2 2 3 3 3 3];
Dist(2,:)=[1 0 2 1 1 3 2 2 2 3 3 3];
Dist(3,:)=[1 2 0 1 2 1 1 2 3 2 2 3];
Dist(4,:)=[1 1 1 0 1 2 1 1 2 2 2 2];
Dist(5,:)=[2 1 2 1 0 3 2 1 1 3 2 2];
Dist(6,:)=[2 3 1 2 3 0 1 2 3 1 2 3];
Dist(7,:)=[2 2 1 1 2 1 0 1 2 1 1 2];
Dist(8,:)=[2 2 2 1 1 2 1 0 1 2 1 1];
Dist(9,:)=[3 2 3 2 1 3 2 1 0 3 2 1];
Dist(10,:)=[3 3 2 2 3 1 1 2 3 0 1 2];
Dist(11,:)=[3 3 2 2 2 2 1 1 2 1 0 1];
Dist(12,:)=[3 3 3 2 2 3 2 1 1 2 1 0];

%% Break link between 4 and 8
Dist(8,4)=2; Dist(4,8)=2;
Dist(12,4)=3; Dist(4,12)=3;
Dist(1,8)=3; Dist(8,1)=3;
Dist(12,1)=4; Dist(1,12)=4;

DistOrg = Dist;

clear I
[I(:,1),I(:,2)] = find(Dist==1);
%% MDS
Y=mdscale(Dist,2);

figure
plot(Y(:,1),Y(:,2),'.','markersize',10)
text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))
 
[i,j]=find(Dist==1);
l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
set(l,'color','b');


%% Define edges
for i = 1:length(I)
    edge{i}.vertex = I(i,1);
    edge{i}.partner = I(i,2);
    edge{i}.controls = find(Dist(I(i,1),:)>1);
end

%% Generate random sequence
varC = 10;
ct=0;
% for i = 1:1000
%     Dist    = DistOrg;
%     c       = zeros(length(I),1);   % to count occurrences 
%     counter = zeros(length(I),1); 
%     
%     start   = randi(46,1);
%     seq     = 0;
%     seq(1:2) = [I(start,1), I(start,2)];
% 
%     for i = 1:131
%         try
%             if i == 1
%                 start       = find(I(:,1) == seq(end) & ~ismember(I(:,2),seq(end-1:end))); 
%             elseif i == 2
%                 start       = find(I(:,1) == seq(end) & ~ismember(I(:,2),seq(end-2:end))); 
%             else
%                 start       = find(I(:,1) == seq(end) & ~ismember(I(:,2),seq(end-3:end))); 
%             end
%             start       = start(randi(length(start),1));
%         
%         catch
%             start       = find(I(:,1) == seq(end) & ~ismember(I(:,2),seq(end-2:end))); 
%             start       = start(randi(length(start),1));
%         
%         end
%         seq(end+1)  = I(start,2);
%         c(start)    = c(start)+1;
%     end
% 
%     % Count occurrences of each link
%     I(:,3)=0;
%     for i = 1:length(I)
%         pool = find(sum(ismember(I(:,1:2),I(i,1:2))') == 2);
%         if I(i,3)==0
%             I(pool,3) = i;
%             counter(i) = sum(c(pool));
%         else
%             counter(i) = counter(pool(1));
%         end
%     end
% %     counter = 1./counter;
% 
%     for i = 1:length(I)
%         Dist(I(i,1),I(i,2)) = 1-counter(i)/(max(counter)+1);    
%     end
% 
%     if var(counter)<2
%         ct = ct+1;
%         varC(ct) = var(counter);
%         
% %         Dist(Dist~=0) = 1./Dist(Dist~=0);
%         
%         for i = 1:length(Dist)
%             onedist{i} = find(Dist(i,:)<=1 & Dist(i,:)>0);
%             twodist{i} = find(Dist(i,:)==2);
%             thrdist{i} = find(Dist(i,:)==3);
%             foudist{i} = find(Dist(i,:)==4);
%         end
% 
%         for ix = 1:length(Dist)
%             for h1 = 1:length(onedist{ix})
%                 isit = ismember(twodist{ix},onedist{onedist{ix}(h1)});
%                 for y = twodist{ix}(isit)
%                     if Dist(ix,y)==2
%                         Dist(ix,y) = Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),y);
%                     else
%                         Dist(ix,y) = min([Dist(ix,y),Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),y)]);
%                     end
%                 end
%                 for h2 = 1:length(onedist{onedist{ix}(h1)})
%                     isit = ismember(thrdist{ix},onedist{onedist{onedist{ix}(h1)}(h2)});
%                     for y = thrdist{ix}(isit)
%                         if DistOrg(ix,y)== 3 && Dist(ix,y)== 3
%                             Dist(ix,y) = Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),y);
%                         elseif DistOrg(ix,y)== 3 
%                             Dist(ix,y) = min([Dist(ix,y),Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),y)]);
%                         end
%                     end
%                     for h3 = 1:length(onedist{onedist{onedist{ix}(h1)}(h2)})
%                         isit = ismember(foudist{ix},onedist{onedist{onedist{onedist{ix}(h1)}(h2)}(h3)});
%                         for y = foudist{ix}(isit)
%                             if DistOrg(ix,y)== 4 && Dist(ix,y)== 4
%                                 Dist(ix,y) = Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),onedist{onedist{onedist{ix}(h1)}(h2)}(h3))+ Dist(onedist{onedist{onedist{ix}(h1)}(h2)}(h3),y);
%                             elseif DistOrg(ix,y)== 3 
%                                 Dist(ix,y) = min([Dist(ix,y),Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),onedist{onedist{onedist{ix}(h1)}(h2)}(h3))+ Dist(onedist{onedist{onedist{ix}(h1)}(h2)}(h3),y)]);
%                             end
%                         end
%                     end
%                 end
%             end
%         end              
% 
%         %% MDS
%         Y=mdscale(Dist,2);
% 
%         h = figure;
%         plot(Y(:,1),Y(:,2),'.','markersize',10)
%         text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))
% 
%         [i,j]=find(DistOrg==1);
%         l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
%         set(l,'color','b');
% 
%         set(findobj(gcf, 'type','axes'), 'Visible','off')
%         print (h, sprintf('D:/mgarvert/Peas/Code_4/randomWalks/133/%u.png',ct),'-dpng');
%         save (sprintf('D:/mgarvert/Peas/Code_4/randomWalks/133/%u.mat',ct),'seq','Dist','counter')
%         close (h)
%     end
% end

%% Pick a number of sequences for optimal layout
ct = 1;
varC2 = [];
for j = 1:100000
    
    
    c = [];
    whichOnes = randi(40,10,1); while length(unique(whichOnes))<1, whichOnes = randi(40,10,1); end
    for i = 1:length(whichOnes)
        load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/randomWalks/133/%u.mat',whichOnes(i)));
        c(i,:) = counter;
    end

    counter = 1-sum(c)./(max(sum(c))+1);
    if mod(j,100) == 0
        disp(var(counter))
    end
    if var(counter) < 0.007% varC2(end)
        ct = ct+1;
        disp(j)
        wO = whichOnes;
        varC2(1,ct) = var(sum(c));
        varC2(2,ct) = var(counter);
    
        Dist = DistOrg;
        
        for i = 1:length(I)
            Dist(I(i,1),I(i,2)) = counter(i);    
        end
    
        for i = 1:length(Dist)
            onedist{i} = find(Dist(i,:)<=1 & Dist(i,:)>0);
            twodist{i} = find(Dist(i,:)==2);
            thrdist{i} = find(Dist(i,:)==3);
            foudist{i} = find(Dist(i,:)==4);
        end

        for ix = 1:length(Dist)
            for h1 = 1:length(onedist{ix})
                isit = ismember(twodist{ix},onedist{onedist{ix}(h1)});
                for y = twodist{ix}(isit)
                    if Dist(ix,y)==2
                        Dist(ix,y) = Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),y);
                    else
                        Dist(ix,y) = min([Dist(ix,y),Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),y)]);
                    end
                end
                for h2 = 1:length(onedist{onedist{ix}(h1)})
                    isit = ismember(thrdist{ix},onedist{onedist{onedist{ix}(h1)}(h2)});
                    for y = thrdist{ix}(isit)
                        if DistOrg(ix,y)== 3 && Dist(ix,y)== 3
                            Dist(ix,y) = Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),y);
                        elseif DistOrg(ix,y)== 3 
                            Dist(ix,y) = min([Dist(ix,y),Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),y)]);
                        end
                    end
                    for h3 = 1:length(onedist{onedist{onedist{ix}(h1)}(h2)})
                        isit = ismember(foudist{ix},onedist{onedist{onedist{onedist{ix}(h1)}(h2)}(h3)});
                        for y = foudist{ix}(isit)
                            if DistOrg(ix,y)== 4 && Dist(ix,y)== 4
                                Dist(ix,y) = Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),onedist{onedist{onedist{ix}(h1)}(h2)}(h3))+ Dist(onedist{onedist{onedist{ix}(h1)}(h2)}(h3),y);
                            elseif DistOrg(ix,y)== 3 
                                Dist(ix,y) = min([Dist(ix,y),Dist(ix,onedist{ix}(h1)) + Dist(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + Dist(onedist{onedist{ix}(h1)}(h2),onedist{onedist{onedist{ix}(h1)}(h2)}(h3))+ Dist(onedist{onedist{onedist{ix}(h1)}(h2)}(h3),y)]);
                            end
                        end
                    end
                end
            end
        end              

        %% MDS
        Y=mdscale(Dist,2);

        h = figure;
        plot(Y(:,1),Y(:,2),'.','markersize',10)
        text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))

        [i,j]=find(DistOrg==1);
        l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
        set(l,'color','b');

        set(findobj(gcf, 'type','axes'), 'Visible','off')
        print (h, sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/randomWalks/133/combined_10/%u.png',ct),'-dpng');
        
        save (sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/randomWalks/133/combined_10/%u.mat',ct),'Dist','counter','wO')
        close all
    end
end