close all
detail = 0;

graph_hexagon
options.day = 'day2';
options.nodes = 12;
maxSubj = 6;

plotNback = 0;

%% Training
h = figure('Position',[100,100,500,1000]);
count = 0;
for subj = 1:maxSubj
    load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))
    count = count+1;
    for i = 1:size(data.train,2)
        blRT(count,i) = data.train{i}.meanRT(1);
        blcr(count,i) = data.train{i}.correct;
    end
end

subplot(2,1,1)
hold on 
bar(mean(blcr),'FaceColor',[0,0,0])

errorbar(1:size(blcr,2),mean(blcr),std(blcr)./sqrt(size(blcr,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
xlabel('Block'), ylabel('Percent correct')
ylim([50 100])
subplot(2,1,2)
hold on
bar(mean(blRT),'FaceColor',[0,0,0])
errorbar(1:size(blcr,2),mean(blRT),std(blRT)./sqrt(size(blRT,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
ylim([min(mean(blRT)-std(blRT)./sqrt(size(blRT,1)))-10 max(mean(blRT)+std(blRT)./sqrt(size(blRT,1)))+10])
xlabel('Block'), ylabel('Mean Reaction time')
set(gcf,'PaperPositionMode','auto')

% anova1(blRT(:,6:9))
% print (h, [root,sprintf('/Datafiles/train_%u.png',str2num(data.subject))],'-dpng');

%% Reaction time/% correct for left vs. right button press
% h = figure('Position',[100,100,500,1000]);
clear crtp RTtp
count = 0;
for subj = 1:maxSubj
    load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))
    count = count+1;
    for i = 1:size(data.train,2)

        totalY = sum(data.train{i}.seq(2,:) == 0);
        totalN = sum(data.train{i}.seq(2,:) == 1);

        crtp(count,i,:) = [sum(data.train{i}.cr(data.train{i}.seq(2,:) == 0)==1)/totalY sum(data.train{i}.cr(data.train{i}.seq(2,:) == 1)==1)/totalN];
        RTtp(count,i,:) = [mean(data.train{i}.RT(data.train{i}.seq(2,:) == 0)) mean(data.train{i}.RT(data.train{i}.seq(2,:) == 1))];
    end
end

meancrtp = squeeze(mean(crtp,2));
meanRTtp = squeeze(mean(RTtp,2));

% subplot(2,1,1)
% hold on 
% bar(1:2,mean(meancrtp) ,'FaceColor',[0,0,0])
% xlabel('Left/right'), ylabel('Percent correct')
% hold on
% errorbar(1:2, mean(meancrtp), std(meancrtp)/length(mean(meancrtp)), 'k', 'linestyle', 'none', 'linewidth', 1);
% ylim([min(mean(meancrtp)- std(meancrtp)/length(mean(meancrtp)))-0.05 1])
% 
% subplot(2,1,2)
% bar(1:2,mean(meanRTtp) ,'FaceColor',[0,0,0])
% hold on
% errorbar(1:2, mean(meanRTtp), std(meanRTtp)/length(mean(meanRTtp)), 'k', 'linestyle', 'none', 'linewidth', 1);
% xlabel('Left/right'), ylabel('Mean Reaction time')
% ylim([min(mean(meanRTtp)- std(meanRTtp)/length(mean(meanRTtp)))-10 max(mean(meanRTtp)+ std(meanRTtp)/length(mean(meanRTtp)))+10])
% 
% set(gcf,'PaperPositionMode','auto')

%% Separate stimuli
clear correct RT
count = 0;
for subj = 1:maxSubj
    load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))
    count = count+1;
    for i = 1:12
        for b = 1:size(data.train,2)
            ix = data.train{b}.seq(1,:) == i;
            correct(count,i,b)    = sum(data.train{b}.cr(ix) == 1)/sum(ix);
            RT(count,i,b)         = mean(data.train{b}.RT(ix));
        end
    end
end
figure; 
subplot(2,1,1)
bar(mean(squeeze(mean(correct,3))),'FaceColor',[0,0,0])
hold on
errorbar(1:12, mean(squeeze(mean(correct,3))), std(squeeze(mean(correct,3)))./sqrt(maxSubj), 'k', 'linestyle', 'none', 'linewidth', 1);
xlabel('Stimulus type'), ylabel('Percent correct')
ylim([min(mean(squeeze(mean(correct,3)))- std(squeeze(mean(correct,3)))./sqrt(maxSubj))-0.05 1])
subplot(2,1,2)
bar(mean(squeeze(mean(RT,3))),'FaceColor',[0,0,0])
hold on
errorbar(1:12, mean(squeeze(mean(RT,3))), std(squeeze(mean(RT,3)))./sqrt(maxSubj), 'k', 'linestyle', 'none', 'linewidth', 1);
xlabel('Stimulus type'), ylabel('Mean Reaction time')
ylim([min(mean(squeeze(mean(RT,3)))- std(squeeze(mean(RT,3)))./sqrt(maxSubj))-10 max(mean(squeeze(mean(RT,3)))+ std(squeeze(mean(RT,3)))./sqrt(maxSubj))+10])

% anova1(squeeze(mean(correct,3)))
% anova1(squeeze(mean(RT,3)))

%% MDS
count = 0;
clear M M_rt M_cr
rt=figure;cr=figure;
for subj = 1:maxSubj
    load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))
    count = count+1;

    M(count,:,:) = zeros(options.nodes);
    M_rt(count,:,:) = zeros(options.nodes);
    M_cr(count,:,:) = zeros(options.nodes);
    for b = 1:8
    if b~=7
        for trial = 2:length(data.train{b}.seq)
            M(count,data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial)) = M(count,data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial))+1;
            M_rt(count,data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial)) = M_rt(count,data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial)) + ...
                data.train{b}.RT(trial);
            M_cr(count,data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial)) = M_cr(count,data.train{b}.seq(1,trial-1),data.train{b}.seq(1,trial)) + ...
                data.train{b}.cr(trial);
%             M(count,data.train{b}.seq(1,trial),data.train{b}.seq(1,trial-1)) = M(count,data.train{b}.seq(1,trial),data.train{b}.seq(1,trial-1))+1;
        end
    end
    end
    M_rt(count,:,:) = M_rt(count,:,:)./M(count,:,:);
    M_cr(count,:,:) = M_cr(count,:,:)./M(count,:,:);
    figure (rt)
    subplot(3,3,count)
    scatter(M(:),M_cr(:),'filled')
    [r,p] = corrcoef(M(M~=0),M_cr(M~=0));
    title( sprintf('r: %.2f, p: %.2f',r(1,2),p(1,2)))
    figure (cr)
    subplot(3,3,count)
    scatter(M(:),M_rt(:),'filled')
    [r,p] = corrcoef(M(M~=0),M_rt(M~=0));
    title( sprintf('r: %.2f, p: %.2f',r(1,2),p(1,2)))
    
end
M = squeeze(squeeze(sum(M)));
M_rt = squeeze(sum(M_rt))./M;
M_cr = squeeze(sum(M_cr))./M;

figure; subplot(2,1,1), imagesc(M), colorbar
M = 1-M./(max(max(M))+1);
subplot(2,1,2), imagesc(M), colorbar

M = M(M~=0); M_rt = M_rt(~isnan(M_rt)); M_cr = M_cr(~isnan(M_cr));
% figure; scatter(M,M_rt), [r,p] = corrcoef(M,M_rt)
% figure; scatter(M,M_cr), [r,p] = corrcoef(M,M_cr)
% figure; scatter(M_cr,M_rt)

for i = 1:length(Dist)
    onedist{i} = find(Dist(i,:)<=1 & Dist(i,:)>0);
    twodist{i} = find(Dist(i,:)==2);
    thrdist{i} = find(Dist(i,:)==3);
    foudist{i} = find(Dist(i,:)==4);
end

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
% clear MRT Mrate
%         
% if ~strcmp(options.day,'day1')
%     count = 0;
%     for subj = 1:maxSubj
%         load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))
%         count = count+1;
%         
%         for b = 1
%             for trial = 1:length(data.test{b}.rate)
%                 MRT(count,data.test{b}.seq(trial,1), data.test{b}.seq(trial,2)) = data.test{b}.RT(trial);
%                 Mrate(count,data.test{b}.seq(trial,1), data.test{b}.seq(trial,2)) = data.test{b}.rate(trial);
%             end
%         end
%     end
% %     figure; subplot(2,1,1),imagesc(squeeze(mean(Mrate))), title ('Rating test block'), colorbar
% %     subplot(2,1,2), imagesc(squeeze(mean(MRT))), title('Reaction time test block'), colorbar
% 
%     for count = 1:maxSubj
%         for i = 1:options.nodes
%             for j = 1:options.nodes
%                 if ~(MRT(count,i,j)==0) && ~(MRT(count,j,i)==0)  && ~(MRT(count,j,i)>2000) && ~(MRT(count,i,j)>2000)
% 
%                     MRT(count,i,j) = mean([MRT(count,i,j), MRT(count,j,i)]);
%                 elseif (MRT(count,j,i)>3000) || (MRT(count,i,j)>3000)
%                     MRT(count,i,j) = min([MRT(count,i,j) MRT(count,j,i)]);
%                 elseif (MRT(count,i,j)==0) || (MRT(count,j,i)==0) 
%                     MRT(count,i,j) = MRT(count,i,j) + MRT(count,j,i);
%                 end
%                 MRT(count,j,i) = MRT(count,i,j);
%                 Mrate(count,i,j) = mean([Mrate(count,i,j), Mrate(count,j,i)]);
%                 Mrate(count,j,i) = Mrate(count,i,j);
%                 if i == j
%                     MRT(count,i,i) = 0;
%                     Mrate(count,i,i) = 0;
%                 end
%             end
%         end
%     end
% %     figure; subplot(2,1,1),imagesc(squeeze(mean(Mrate))), title ('Rating test block'), colorbar
% %     subplot(2,1,2), imagesc(squeeze(mean(MRT))), title('Reaction time test block'), colorbar
% %     
%     Y=mdscale(Dist,2);
% 
%     h = figure;
%     subplot(3,1,1)
%     Y=mdscale(M,2);
%     plot(Y(:,1),Y(:,2),'.','markersize',10)
%     text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))
% 
%     [i,j]=find(DistOrg==1);
%     l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
%     set(l,'color','b');
% % 
% %     subplot(3,1,2)
% %     Y=mdscale(squeeze(mean(Mrate,1)),2);
% %     plot(Y(:,1),Y(:,2),'.','markersize',10)
% %     text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))
% % 
% %     [i,j]=find(DistOrg==1);
% %     l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
% %     set(l,'color','b');
% % 
% %     subplot(3,1,3)
% %     Y=mdscale(squeeze(mean(MRT,1)),2);
% %     plot(Y(:,1),Y(:,2),'.','markersize',10)
% %     text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))
% % 
% %     [i,j]=find(DistOrg==1);
% %     l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
% %     set(l,'color','b');   
% end

%% RANDOM BLOCKS
M7RT = zeros(maxSubj,options.nodes,options.nodes); M7rate = zeros(maxSubj,options.nodes,options.nodes);
clear M7RT demeanM7RT demeanSym
totest = 11:20;
for subj = 1:maxSubj
    load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))
    for bl = 1:length(totest)
        count = count+1;

        for trial = 2:length(data.train{totest(bl)}.seq)
            M7RT{subj}(bl,data.train{totest(bl)}.seq(1,trial-1), data.train{totest(bl)}.seq(1,trial)) = data.train{totest(bl)}.RT(trial);
        end
        for i = 1:12
            M7RT{subj}(bl,i,i) = mean(M7RT{subj}(bl,:,i));
        end

        demeanM7RT{subj}(bl,:,:) = squeeze(M7RT{subj}(bl,:,:)) - repmat(squeeze(mean(M7RT{subj}(bl,:,:),2))',12,1);
        
    end
    meanM7RT(subj,:,:) = squeeze(mean(M7RT{subj}));
    demeanM7RT_mean(subj,:,:) = squeeze(mean(demeanM7RT{subj}));  
    for i = 1:12
        for j = 1:12
            demeanSym(subj,i,j) = mean([demeanM7RT_mean(subj,i,j) demeanM7RT_mean(subj,j,i)]);
            demeanSym(subj,j,i) = demeanM7RT_mean(subj,i,j);
            demeanSym(subj,i,i) = 0;
        end
    end
    bb=Dist(:);bb(bb==0)=[]; cc=squeeze(demeanSym(subj,:,:));cc(Dist==0)=[];
    corrcoef(bb,cc)
end

demeanAll = squeeze(mean(demeanSym));
bb=Dist(:);bb(bb==0)=[]; cc=demeanAll;cc(Dist==0)=[];
figure; scatter(bb,cc)
figure; imagesc(demeanAll), colorbar

M7RTtest = squeeze(mean(meanM7RT,1));
    for i = 1:12
        M7RTtest(i,i) = mean(M7RTtest(i,:));
    end
    figure; imagesc(M7RTtest),colorbar

demean = (squeeze(meanM7RT(subj,:,:)) -  repmat(squeeze(mean(meanM7RT(subj,:,:))),12,1))./repmat(std(M7RTtest),12,1);
for i = 1:12
    demean(i,i) = 0;
end
figure; imagesc(demean),colorbar

for i = 1:12
    for j = 1:12
        demeanSym(i,j) = mean([demean(i,j) demean(j,i)]);
        demeanSym(j,i) = demeanSym(i,j);
    end
end
figure; imagesc(demeanAll),colorbar

 
%% Analyze distance effect
count = 0;
clear mRT7 mC7 sRT7
for intrbl =11:20;
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

    for subj = 1:maxSubj
        load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))

        for trial = 2:length(data.train{intrbl}.seq)
            if sum(ismember(onedist{data.train{intrbl}.seq(1,trial-1)},data.train{intrbl}.seq(1,trial)))
                data.train{intrbl}.distV(trial) = 1;
            elseif sum(ismember(twodist{data.train{intrbl}.seq(1,trial-1)},data.train{intrbl}.seq(1,trial)))
               data.train{intrbl}.distV(trial) = 2;
            elseif sum(ismember(thrdist{data.train{intrbl}.seq(1,trial-1)},data.train{intrbl}.seq(1,trial)))
                data.train{intrbl}.distV(trial) = 3;
            end
        end
        %%DEMEAN
        data.train{intrbl}.RT = data.train{intrbl}.RT - mean(data.train{intrbl}.RT);
        for i = 1:3
            ix = data.train{intrbl}.distV==i;
            mRT7(subj,count,i)   = mean (data.train{intrbl}.RT(ix));
            sRT7(subj,count,i)   = std(data.train{intrbl}.RT(ix))./sqrt(sum(ix));
            mC7(subj,count,i)    = mean (data.train{intrbl}.cr(ix));
        end
    end
end

meanRTOverBlocks    = squeeze(mean(mRT7,2));
meanCOverBlocks     = squeeze(mean(mC7,2));

figure; 
subplot(2,1,1)
bar(mean(meanCOverBlocks),'k')
hold on
errorbar(1:3,mean(meanCOverBlocks),std(meanCOverBlocks)./sqrt(size(meanCOverBlocks,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
ylim([min(mean(meanCOverBlocks)-std(meanCOverBlocks)./sqrt(size(meanCOverBlocks,1)))-0.05 1])
xlabel('Distance'), ylabel('Percent correct')
   
subplot(2,1,2)
bar(mean(meanRTOverBlocks),'k')
hold on
errorbar(1:3,mean(meanRTOverBlocks),std(meanRTOverBlocks)./sqrt(size(meanRTOverBlocks,1)), 'k', 'linestyle', 'none', 'linewidth', 1);
ylim([min(mean(meanRTOverBlocks)-std(meanRTOverBlocks)./sqrt(size(meanRTOverBlocks,1)))-10 max(mean(meanRTOverBlocks)+std(meanRTOverBlocks)./sqrt(size(meanRTOverBlocks,1)))+10])
xlabel('Distance'), ylabel('Reaction time')
    
if plotNback
    %% Analyze n-back
    bl = figure;
    RTDist = zeros(7,12,12);
    RTcount = zeros(7,12,12);
    for intrbl = 1:9
        count = 0;
        clear bwRT bwRTs bwC bwCs
        for subj = 1:maxSubj
            load(sprintf('C:/Users/mgarvert/Desktop/Peas/Code_5/datafiles/day 2/peas_%u.mat',subj))
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
        subplot(3,3,intrbl)
        scatter(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwRT_mean(:,bwRT_mean(1,:)>0)),'filled');
        xlim([0 15])
        lsline
        [r,p] = corrcoef(sum(~(bwRT_mean(3,:)>0))+1:length(bwRT_mean),mean(bwRT_mean(:,bwRT_mean(3,:)>0)));
        xlabel('Distance')
        ylabel(sprintf('Reaction Time'))
        title(sprintf('Bl %u\nr: %.2f, p: %.2f',intrbl, r(2,1),p(2,1)))

    end
    RTcount(RTcount == 0)=1;
    RTDistb = RTDist./RTcount;

    figure; 
    subplot(2,1,1)
    scatter(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwC(:,bwC(1,:)>0)),'filled')
    lsline
    [r,p] = corrcoef(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwC(:,bwC(1,:)>0)));
    xlabel('Distance')
    ylabel(sprintf('Percent correct'))
    title(sprintf('Bl %u\nr: %.2f, p: %.2f',intrbl, r(2,1),p(2,1)))
    subplot(2,1,2)
    scatter(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwRT(:,bwRT(1,:)>0)),'filled')
    lsline
    [r,p] = corrcoef(sum(~(bwRT_mean(1,:)>0))+1:length(bwRT_mean),mean(bwRT(:,bwRT(1,:)>0)));
    xlabel('Distance')
    ylabel(sprintf('Reaction Time'))
    title(sprintf('Bl %u\nr: %.2f, p: %.2f',intrbl, r(2,1),p(2,1)))
end