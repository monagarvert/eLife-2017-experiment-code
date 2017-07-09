%% Define graph
% =========================================================================
clear Dist Dist_org
plotthis = 0;
% Define connectivity/distances between vertices
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

Dist_spatial = Dist;

%% Break link between 4 and 8
Dist(8,4)=2; Dist(4,8)=2;
Dist(12,4)=3; Dist(4,12)=3;
Dist(1,8)=3; Dist(8,1)=3;
Dist(12,1)=4; Dist(1,12)=4;

Dist_org = Dist;

[I(:,1),I(:,2)] = find(Dist==1);

%% Define edges
for i = 1:length(I)
    edge{i}.vertex = I(i,1);
    edge{i}.partner = I(i,2);
    edge{i}.controls = find(Dist(I(i,1),:)>1);
end


if plotthis
    figure;
    subplot(2,1,1)
    Y=mdscale(Dist_org,2);
    plot(Y(:,1),Y(:,2),'.','markersize',10)
    text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))

    [i,j]=find(Dist_org==1);
    l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
    set(l,'color','k');
    
    subplot(2,1,2)
    Y=mdscale(Dist_spatial,2);
    plot(Y(:,1),Y(:,2),'.','markersize',10)
    text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))

    [i,j]=find(Dist_spatial==1);
    l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
    set(l,'color','k');
end

ActualDist = Dist;
ActualDist(2,6) = 2.5; ActualDist(6,2) = 2.5;
ActualDist(2,8) = 1.5; ActualDist(8,2) = 1.5;
ActualDist(4,6) = 1.5; ActualDist(6,4) = 1.5;
ActualDist(4,9) = 1.5; ActualDist(9,4) = 1.5;
ActualDist(8,10) = 1.5; ActualDist(10,8) = 1.5;
ActualDist(9,10) = 2.5; ActualDist(10,9) = 2.5;
ActualDist(4,8) = 4; ActualDist(8,4) = 4;
ActualDist(10,8) = 5; ActualDist(6,4) = 5;
% 
% subplot(2,1,2)
% Y=mdscale(ActualDist,2);
% plot(Y(:,1),Y(:,2),'.','markersize',10)
% text(Y(:,1),Y(:,2),num2str((1:length(Dist))'))
% 
% [i,j]=find(ActualDist==1);
% l=line([Y(i,1),Y(j,1)]',[Y(i,2),Y(j,2)]');
% set(l,'color','k');
