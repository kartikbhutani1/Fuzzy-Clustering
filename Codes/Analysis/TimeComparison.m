function TimeComparison(data)

%Kmeans----------------------------------------------
Kmeans_Time = zeros(2,9);
for i=2:1:10
    tStart = tic;
    kmeans(data,i);
    Kmeans_Time(1,i-1) = toc(tStart);
    Kmeans_Time(2,i-1) = i;
end
Kmeans_Time
%FCM---------------------------------------------------
FCM_Time = zeros(2,9);
for i=2:1:10
    tStart = tic;
    fkmeans(data,i);
    FCM_Time(1,i-1) = toc(tStart);
    FCM_Time(2,i-1) = i;
end
FCM_Time
%PCM---------------------------------------------------
PCM_Time = zeros(2,9);
for i=2:1:10
    tStart = tic;
    pcm(data,i);
    PCM_Time(1,i-1) = toc(tStart);
    PCM_Time(2,i-1) = i;
end
PCM_Time






%Plotting Graph

hold off
plot(Kmeans_Time(2,:),Kmeans_Time(1,:),'color','red');
hold on
plot(FCM_Time(2,:),FCM_Time(1,:),'color','blue');
hold on
plot(PCM_Time(2,:),PCM_Time(1,:),'color','green');
hold on
plot(Kmeans_Time(2,:),Kmeans_Time(1,:),'o','color','red');
hold on
plot(FCM_Time(2,:),FCM_Time(1,:),'o','color','blue');
hold on
plot(PCM_Time(2,:),PCM_Time(1,:),'o','color','green');
hold on
%Labels and Legends
xlabel('Number of centers');
ylabel('Time(in seconds)');
title('Time Analysis');
legend('K-Means','FCM','PCM');