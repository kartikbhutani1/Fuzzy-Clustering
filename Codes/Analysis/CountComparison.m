function CountComparison(data)

%Kmeans----------------------------------------------
Kmeans_Count = zeros(2,9);
for i=2:1:10
    Kmeans_Count(1,i-1) = kmeans(data,i);
    Kmeans_Count(2,i-1) = i;
end
Kmeans_Count

%FCM-------------------------------------------------
FCM_Count = zeros(2,9);
for i=2:1:10
    FCM_Count(1,i-1) = fkmeans(data,i);
    FCM_Count(2,i-1) = i;
end
FCM_Count

%PCM----------------------------------------------
PCM_Count = zeros(2,9);
for i=2:1:10
    PCM_Count(1,i-1) = pcm(data,i);
    PCM_Count(2,i-1) = i;
end
PCM_Count





%Plotting Graphs

hold off
plot(Kmeans_Count(2,:),Kmeans_Count(1,:),'color','red');
hold on
plot(FCM_Count(2,:),FCM_Count(1,:),'color','blue');
hold on
plot(PCM_Count(2,:),PCM_Count(1,:),'color','green');
hold on
plot(Kmeans_Count(2,:),Kmeans_Count(1,:),'o','color','red');
hold on
plot(FCM_Count(2,:),FCM_Count(1,:),'o','color','blue');
hold on
plot(PCM_Count(2,:),PCM_Count(1,:),'o','color','green');
hold on

xlabel('Number of Centers');
ylabel('Number of Iterations');
title('Iteration Analysis');
legend('K-Means','FCM','PCM');












