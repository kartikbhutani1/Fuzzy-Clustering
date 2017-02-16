function Comparison = DistanceComparison(data)

%Kmeans----------------------------------------------
Kmeans_Distance = zeros(2,9);
for i=2:1:10
    Kmeans_Distance(1,i-1) = kmeans_dist(data,i);
    Kmeans_Distance(2,i-1) = i;
end
Kmeans_Distance

%FCM-------------------------------------------------
FCM_Distance = zeros(2,9);
for i=2:1:10
    FCM_Distance(1,i-1) = fkmeans_dist(data,i);
    FCM_Distance(2,i-1) = i;
end
FCM_Distance

%PCM----------------------------------------------
PCM_Distance = zeros(2,9);
for i=2:1:10
    PCM_Distance(1,i-1) = pcm_dist(data,i);
    PCM_Distance(2,i-1) = i;
end
PCM_Distance

Comparison = [Kmeans_Distance(1,:);FCM_Distance(1,:);PCM_Distance];











%Plotting Comparison Graphs

hold off
plot(Kmeans_Distance(2,:),Kmeans_Distance(1,:),'color','red');
hold on
plot(FCM_Distance(2,:),FCM_Distance(1,:),'color','blue');
hold on
plot(PCM_Distance(2,:),PCM_Distance(1,:),'color','green');
hold on
plot(Kmeans_Distance(2,:),Kmeans_Distance(1,:),'o','color','red');
hold on
plot(FCM_Distance(2,:),FCM_Distance(1,:),'o','color','blue');
hold on
plot(PCM_Distance(2,:),PCM_Distance(1,:),'o','color','green');


xlabel('Number of centers');
ylabel('Average Distance');
title('Distance Analysis');
legend('K-Means','FCM','PCM');















