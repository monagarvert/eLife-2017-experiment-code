close all
blocklength = 44;
detail = 0;

graph_hexagon
options.day = 'day1';
options.nodes = 12;

plotDevelopment = 1;
plotLeftRight   = 0;
plotSeparateStimuli = 0;
plotMRT         = 0;
plotDistance    = 1;
plotNback       = 0;

%% Training
if plotDevelopment
    h = figure('Position',[100,100,500,1000]);
    for i = 1:size(data.train,2)
        train.blRT(i) = data.train{i}.meanRT(1);
        train.blcr(i) = data.train{i}.correct;

        subplot(2,1,1)
        hold on 
        bar(i, data.train{i}.correct,'FaceColor',[0,0,0])
        xlabel('Block'), ylabel('Percent correct')
        subplot(2,1,2)
        hold on
        bar(i,data.train{i}.meanRT(1),'FaceColor',[0,0,0])
        hold on
        errorbar(i, data.train{i}.meanRT(1), data.train{i}.meanRT(2)/sqrt(blocklength), 'k', 'linestyle', 'none', 'linewidth', 1);
        xlabel('Block'), ylabel('Mean Reaction time')
    end
    set(gcf,'PaperPositionMode','auto')

    % print (h, [root,sprintf('/Datafiles/train_%u.png',str2num(data.subject))],'-dpng');
end

%% Reaction time/% correct for left vs. right button press
if plotLeftRight
    h = figure('Position',[100,100,500,1000]);
    clear crtp RTtp
    for i = 1:size(data.train,2)

        totalY = sum(data.train{i}.seq(2,:) == 0);
        totalN = sum(data.train{i}.seq(2,:) == 1);

        crtp(i,:) = [sum(data.train{i}.cr(data.train{i}.seq(2,:) == 0)==1)/totalY sum(data.train{i}.cr(data.train{i}.seq(2,:) == 1)==1)/totalN];
        RTtp(i,:) = [mean(data.train{i}.RT(data.train{i}.seq(2,:) == 0)) mean(data.train{i}.RT(data.train{i}.seq(2,:) == 1))];
    end

    subplot(2,1,1)
    hold on 
    bar(1:2,mean(crtp) ,'FaceColor',[0,0,0])
    xlabel('Left/right'), ylabel('Percent correct')
    hold on
    errorbar(1:2, mean(crtp), std(crtp)/length(mean(crtp)), 'k', 'linestyle', 'none', 'linewidth', 1);
    ylim([0.5 1])
    subplot(2,1,2)
    bar(1:2,mean(RTtp) ,'FaceColor',[0,0,0])
    hold on
    errorbar(1:2, mean(RTtp), std(RTtp)/length(mean(RTtp)), 'k', 'linestyle', 'none', 'linewidth', 1);
    xlabel('Left/right'), ylabel('Mean Reaction time')

    set(gcf,'PaperPositionMode','auto')
end

if plotSeparateStimuli
    %% Separate stimuli
    clear correct RT
    for i = 1:12
        for b = 1:size(data.train,2)
            ix = data.train{b}.seq(1,:) == i;
            correct(i,b)    = sum(data.train{b}.cr(ix) == 1)/sum(ix);
            RT(i,b)         = mean(data.train{b}.RT(ix));
        end
    end
    figure; 
    subplot(2,1,1)
    bar(mean(correct,2),'FaceColor',[0,0,0])
    xlabel('Stimulus type'), ylabel('Percent correct')
    hold on
    subplot(2,1,2)
    hold on
    bar(1:12,mean(RT,2),'FaceColor',[0,0,0])
    hold on
    errorbar(1:12, mean(RT,2), std(RT'), 'k', 'linestyle', 'none', 'linewidth', 1);
    xlabel('Stimulus type'), ylabel('Mean Reaction time')
end
%% MDS
% M = Dist;
% for b = 1:8
%     if b~=7
%         for trial = 2:length(data.train{b}.seq)
%             M(data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial)) = M(data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial))+1;
%             M(data.train{b}.seq(1,trial),data.train{b}.seq(1,trial-1)) = M(data.train{b}.seq(1,trial),data.train{b}.seq(1,trial-1))+1;
%         end
%     end
% end
% M(M >5) =  1./M(M>5);
% 
% for i = 1:length(Dist)
%     onedist{i} = find(Dist(i,:)<=1 & Dist(i,:)>0);
%     twodist{i} = find(Dist(i,:)==2);
%     thrdist{i} = find(Dist(i,:)==3);
%     foudist{i} = find(Dist(i,:)==4);
% end
% 
% for ix = 1:length(Dist)
%     for h1 = 1:length(onedist{ix})
%         isit = ismember(twodist{ix},onedist{onedist{ix}(h1)});
%         for y = twodist{ix}(isit)
%             if M(ix,y)==2
%                 M(ix,y) = M(ix,onedist{ix}(h1)) + M(onedist{ix}(h1),y);
%             else
%                 M(ix,y) = min([M(ix,y),M(ix,onedist{ix}(h1)) + M(onedist{ix}(h1),y)]);
%             end
%         end
%         for h2 = 1:length(onedist{onedist{ix}(h1)})
%             isit = ismember(thrdist{ix},onedist{onedist{onedist{ix}(h1)}(h2)});
%             for y = thrdist{ix}(isit)
%                 if DistOrg(ix,y)== 3 && M(ix,y)== 3
%                     M(ix,y) = M(ix,onedist{ix}(h1)) + M(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + M(onedist{onedist{ix}(h1)}(h2),y);
%                 elseif DistOrg(ix,y)== 3 
%                     M(ix,y) = min([M(ix,y),M(ix,onedist{ix}(h1)) + M(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + M(onedist{onedist{ix}(h1)}(h2),y)]);
%                 end
%             end
%             for h3 = 1:length(onedist{onedist{onedist{ix}(h1)}(h2)})
%                 isit = ismember(foudist{ix},onedist{onedist{onedist{onedist{ix}(h1)}(h2)}(h3)});
%                 for y = foudist{ix}(isit)
%                     if DistOrg(ix,y)== 4 && M(ix,y)== 4
%                         M(ix,y) = M(ix,onedist{ix}(h1)) + M(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + M(onedist{onedist{ix}(h1)}(h2),onedist{onedist{onedist{ix}(h1)}(h2)}(h3))+ M(onedist{onedist{onedist{ix}(h1)}(h2)}(h3),y);
%                     elseif DistOrg(ix,y)== 3 
%                         M(ix,y) = min([M(ix,y),M(ix,onedist{ix}(h1)) + M(onedist{ix}(h1),onedist{onedist{ix}(h1)}(h2)) + M(onedist{onedist{ix}(h1)}(h2),onedist{onedist{onedist{ix}(h1)}(h2)}(h3))+ M(onedist{onedist{onedist{ix}(h1)}(h2)}(h3),y)]);
%                     end
%                 end
%             end
%         end
%     end
% end        

if ~strcmp(options.day,'day1')
    clear MRT Mrate
    for b = 1:7%size(data.test.(options.day))
        for trial = 1:length(data.test.(options.day){b}.rate)
            MRT(data.test.(options.day){tbl}.seq(trial,1), data.test.(options.day){tbl}.seq(trial,2)) = data.test.(options.day){tbl}.RT(trial);
            Mrate(data.test.(options.day){tbl}.seq(trial,1), data.test.(options.day){tbl}.seq(trial,2)) = data.test.(options.day){tbl}.rate(trial);
        end
    end
    % figure; imagesc(Mrate)
    % figure; imagesc(MRT)

    for i = 1:options.nodes
        for j = 1:options.nodes
            MRT(i,j) = mean([MRT(i,j), MRT(j,i)]);
            MRT(j,i) = MRT(i,j);
            Mrate(i,j) = mean([Mrate(i,j), Mrate(j,i)]);
            Mrate(j,i) = Mrate(i,j);
            if i == j
                MRT(i,i) = 0;
                Mrate(i,i) = 0;
            end
        end
    end
    figure; imagesc(Mrate)
    Y=mdscale(Dist,2);

    h = figure;
    subplot(3,1,1)
    Y=mdscale(M,2);
    plot(Y(:,1),Y(:,2),'.','markersize',10)
    text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))

    [i,j]=find(DistOrg==1);
    l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
    set(l,'color','b');

    subplot(3,1,2)
    Y=mdscale(Mrate,2);
    plot(Y(:,1),Y(:,2),'.','markersize',10)
    text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))

    [i,j]=find(DistOrg==1);
    l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
    set(l,'color','b');

    subplot(3,1,3)
    Y=mdscale(MRT,2);
    plot(Y(:,1),Y(:,2),'.','markersize',10)
    text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))

    [i,j]=find(DistOrg==1);
    l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
    set(l,'color','b');   
end

if plotMRT
    %% Block 7!

    train.M7RT = zeros(options.nodes); M7rate = zeros(options.nodes);

    clear MRT Mrate
    for bl = 7
        for trial = 2:length(data.train{bl}.seq)
            train.M7RT(data.train{bl}.seq(1,trial-1), data.train{bl}.seq(1,trial)) = data.train{bl}.RT(trial);
        end
    end    

    for i = 1:options.nodes
        for j = 1:options.nodes
            train.M7RT(i,j) = mean([train.M7RT(i,j), train.M7RT(j,i)]);
            train.M7RT(j,i) = train.M7RT(i,j);
        end
    end

    h = figure;
    Y=mdscale(train.M7RT,2);
    plot(Y(:,1),Y(:,2),'.','markersize',10)
    text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))

    [i,j]=find(DistOrg==1);
    l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
    set(l,'color','b');
end

%% Analyze distance effect
if plotDistance
    count = 0;
    clear mRT7 mC7 sRT7
    for intrbl =11:length(data.train);
        count = count+1;
        data.train{intrbl}.distV = 0;
        mRT = [];
        mC = [];

        Dist = DistOrg;
        for i = 1:length(Dist)
            onedist{i} = find(Dist(i,:)<=1 & Dist(i,:)>0);
            twodist{i} = find(Dist(i,:)==2);
            thrdist{i} = find(Dist(i,:)==3);
            foudist{i} = find(Dist(i,:)==4);
        end

            for trial = 2:length(data.train{intrbl}.seq)
                if sum(ismember(onedist{data.train{intrbl}.seq(1,trial-1)},data.train{intrbl}.seq(1,trial)))
                    data.train{intrbl}.distV(trial) = 1;
                elseif sum(ismember(twodist{data.train{intrbl}.seq(1,trial-1)},data.train{intrbl}.seq(1,trial)))
                   data.train{intrbl}.distV(trial) = 2;
                elseif sum(ismember(thrdist{data.train{intrbl}.seq(1,trial-1)},data.train{intrbl}.seq(1,trial)))
                    data.train{intrbl}.distV(trial) = 3;
                end
            end
            %% DEMEAN
            data.train{intrbl}.RT = data.train{intrbl}.RT - mean(data.train{intrbl}.RT);

            for i = 1:3
                ix = data.train{intrbl}.distV==i;
                mRT7(count,i)   = mean (data.train{intrbl}.RT(ix));
                sRT7(count,i)   = std(data.train{intrbl}.RT(ix))./sqrt(sum(ix));
                mC7(count,i)    = mean (data.train{intrbl}.cr(ix));
            end
            meanRTWholeBlock(count,1) = mean(data.train{intrbl}.RT);
    end

    figure; 
    subplot(2,1,1)
    bar(mean(mC7),'k')
    hold on
    errorbar(1:3,mean(mC7),std(mC7)/sqrt(size(mC7,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
    ylim([min(mean(mC7))-0.05 1])
    xlabel('Distance'), ylabel('Percent correct')

    subplot(2,1,2)
    bar(mean(mRT7),'k')
    hold on
    errorbar(1:3,mean(mRT7),std(mRT7)./sqrt(size(mC7,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
    ylim([min(mean(mRT7)-std(mRT7)./sqrt(size(mC7,1)))-10 max(mean(mRT7)+std(mRT7)./sqrt(size(mC7,1)))+10])
    xlabel('Distance'), ylabel('Reaction time')
end

if plotNback
    %% Analyze n-back
    bl = figure;
    RTDist = zeros(7,12,12);
    RTcount = zeros(7,12,12);
    for intrbl = 1:8
        count = 0;
        clear bwRT bwRTs bwC bwCs
        for subj = 1:4
            load(sprintf('//asia/DeletedDaily/mg/datafiles/peas_%u.mat',subj))
            count = count+1;
            clear bw
            for trial = 1:length(data.train{intrbl}.seq)
                clear b
                [a,b] = find(data.train{intrbl}.seq(1,1:trial-1) == data.train{intrbl}.seq(1,trial));
                if ~isempty(b)
                    bw(trial) = trial - b(end);
                end

                if intrbl ==7 && trial~=1
                    if data.train{intrbl}.RT(trial) > 250
                        RTDist(count,data.train{intrbl}.seq(1,trial-1),data.train{intrbl}.seq(1,trial)) = RTDist(count,data.train{intrbl}.seq(1,trial-1),data.train{intrbl}.seq(1,trial)) +...
                            RTDist(count,data.train{intrbl}.seq(1,trial-1),data.train{intrbl}.seq(1,trial)) +data.train{intrbl}.RT(trial);
                        RTcount(count,data.train{intrbl}.seq(1,trial-1),data.train{intrbl}.seq(1,trial)) =RTcount(count,data.train{intrbl}.seq(1,trial-1),data.train{intrbl}.seq(1,trial)) + 1;
                    end
                end
            end

            for i = 1:14
                 bwRT(count,i) = mean (data.train{intrbl}.RT(bw==i));
                 bwRTs(count,i) = std (data.train{intrbl}.RT(bw==i))/sqrt(sum(bw==i));
                 bwC(count,i) = mean (data.train{intrbl}.cr(bw==i));
                 bwCs(count,i) = std (data.train{intrbl}.cr(bw==i))/sqrt(sum(bw==i));   
                 bwCount(count,i) = sum(bw==i);
            end


        end
        bwRT_mean = (bwRT);
        figure(bl); 
        hold on,
        subplot(2,4,intrbl)
        scatter(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwRT_mean(:,bwRT_mean(1,:)>0)),'filled');
        xlim([0 15])
        lsline
        [r,p] = corrcoef(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwRT_mean(:,bwRT_mean(1,:)>0)));
        xlabel('Distance')
        ylabel(sprintf('Reaction Time'))
        title(sprintf('Bl %u\nr: %.2f, p: %.2f',intrbl, r(2,1),p(2,1)))

    end
    RTcount(RTcount == 0)=1;
    RTDistb = RTDist./RTcount;

    figure; 
    subplot(2,1,1)
    bar(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwRT(:,bwRT(1,:)>0)),'k')
    hold on
    errorbar(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwRT(:,bwRT(1,:)>0)),std((bwRT(:,bwRT(1,:)>0)))./sqrt(size(bwC,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
    ylim([min(mean(bwRT(:,bwRT(1,:)>0))-std((bwRT(:,bwRT(1,:)>0)))./sqrt(size(bwC,1)))-10, max(mean(bwRT(:,bwRT(1,:)>0))+std((bwRT(:,bwRT(1,:)>0)))./sqrt(size(bwC,1)))+10])
    subplot(2,1,2)
    bar(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwC(:,bwC(1,:)>0)),'k')
    hold on
    errorbar(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwC(:,bwC(1,:)>0)),std((bwC(:,bwC(1,:)>0)))./sqrt(size(bwC,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
    ylim([min(mean(bwC(:,bwC(1,:)>0))-std((bwC(:,bwC(1,:)>0)))./sqrt(size(bwC,1)))-0.1, 1])
end