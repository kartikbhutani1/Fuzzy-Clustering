function [algoUsed,optimalCenters] = IdealCenters(data,mink,maxk,criteria)

algoUsed = 0;
optimalCenters = 0;

if maxk<=0||maxk<=mink||mink<=0
    'Invalid parameters'
    algoUsed = 'Invalid'
    optimalCenters = 'Invalid'

elseif criteria==1    
   %TimeTable = zeros(4,maxk-mink+1);
   %Kmeans----------------------------------------------
    Kmeans_Time = zeros(1,maxk-mink+1);
    for i=mink:1:maxk
        tStart = tic;
        kmeans(data,i);   %Running Algo
        Kmeans_Time(1,i-(mink-1)) = toc(tStart);
        %Kmeans_Time(2,i-1) = i;
    end
    Kmeans_Time
    %FCM---------------------------------------------------
    FCM_Time = zeros(1,maxk-mink+1);
    for i=mink:1:maxk
        tStart = tic;
        fkmeans(data,i);
        FCM_Time(1,i-(mink-1)) = toc(tStart);
        %FCM_Time(2,i-1) = i;
    end
    FCM_Time
    %PCM---------------------------------------------------
    PCM_Time = zeros(1,maxk-mink+1);
    for i=mink:1:maxk
        tStart = tic;
        pcm(data,i);
        PCM_Time(1,i-(mink-1)) = toc(tStart);
        PCM_Time(2,i-1) = i;
    end
    PCM_Time
    
    TimeTable = [Kmeans_Time;FCM_Time;PCM_Time];
    
    TimeTable
    minElement = 1000;
    for i=1:1:3
        for j=mink:1:maxk
            if(minElement>TimeTable(i,j-(mink-1)))
                minElement = TimeTable(i,j-(mink-1));
                algoUsed = i;
                optimalCenters = j;
            end
        end
    end
    minElement
    
elseif criteria==2    
    
    %DistanceTable = zeros(4,maxk-mink+1);
    %Kmeans----------------------------------------------
    Kmeans_Distance = zeros(1,maxk-mink+1);    % without K's
    for i=mink:1:maxk
        Kmeans_Distance(1,i-(mink-1)) = kmeans_dist(data,i);
       % Kmeans_Distance(2,i-(mink-1)) = i;
    end
    Kmeans_Distance

    %FCM-------------------------------------------------
    FCM_Distance = zeros(1,maxk-mink+1);       % without K's
    for i=mink:1:maxk
        FCM_Distance(1,i-(mink-1)) = fkmeans_dist(data,i);
       % FCM_Distance(2,i-(mink-1)) = i;
    end
    FCM_Distance

    %PCM----------------------------------------------
    PCM_Distance = zeros(2,maxk-mink+1);        % WITH K's
    for i=mink:1:maxk
        PCM_Distance(1,i-(mink-1)) = pcm_dist(data,i);
        PCM_Distance(2,i-(mink-1)) = i;       
    end
    PCM_Distance
    
    DistanceTable = [Kmeans_Distance;FCM_Distance;PCM_Distance];
    
    DistanceTable
    
    minElement = 1000;
    for i=1:1:3
        for j=mink:1:maxk
            if(minElement>DistanceTable(i,j-(mink-1)))
                minElement = DistanceTable(i,j-(mink-1));
                algoUsed = i;
                optimalCenters = j;
            end
        end
    end
    minElement
end

if algoUsed==1
    algoUsed = 'K-Means Algorithm';
elseif algoUsed==2
    algoUsed = 'FCM Algorithm';
elseif algoUsed==3
    algoUsed = 'PCM Algorithm';
end











