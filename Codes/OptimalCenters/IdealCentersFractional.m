function [algoUsed,optimalCenters] = IdealCentersFractional(data,mink,maxk,Tp,Dp)

algoUsed = 0;
optimalCenters = 0;

if maxk<=0||maxk<=mink||mink<=0||Tp<0||Dp<0||(Tp==0&&Dp==0)
    'Invalid parameters'
    algoUsed = 'Invalid';
    optimalCenters = 'Invalid';

else 
    Tr = Tp/(Tp+Dp);
    Dr = Dp/(Tp+Dp);
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~TIME TABLE~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    %Kmeans----------------------------------------------
    Kmeans_Time = zeros(1,maxk-mink+1);
    for i=mink:1:maxk
        tStart = tic;
        kmeans(data,i);   %Running Algo
        Kmeans_Time(1,i-(mink-1)) = toc(tStart);
        %Kmeans_Time(2,i-1) = i;
    end
    Kmeans_Time
    %FCM--------------------------------------------------
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
       % PCM_Time(2,i-1) = i;
    end
    PCM_Time
    
    TimeTable = [Kmeans_Time;FCM_Time;PCM_Time];
    
    %for i=mink:1:maxk
     %   TimeTable(4,i-(mink-1)) = i;
    %end
    TimeTable
    
    %~~~~~~~~~~~~~~~~~~DISTANCE TABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
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
    PCM_Distance = zeros(1,maxk-mink+1);        % WITHOUT K's
    for i=mink:1:maxk
        PCM_Distance(1,i-(mink-1)) = pcm_dist(data,i);
       % PCM_Distance(2,i-(mink-1)) = i;       
    end
    PCM_Distance
    
    DistanceTable = [Kmeans_Distance;FCM_Distance;PCM_Distance];
    
    DistanceTable
    
    
    
   %~~~~~~~~~~~~~~~~~~~~NORMALIZATION~~~~~~~~~~~~~~~~~~~~~~~~~ 
   %TIME------------------------------------------
   
   minT = min(min(TimeTable));
   maxT = max(max(TimeTable));
   diffT = maxT - minT;
   
   for i=1:1:3
       for j=1:1:(maxk-mink+1)
           TimeTable(i,j) = (TimeTable(i,j) - minT)/diffT;
       end
   end
   
   TimeTable     %Normalized
   %DISTANCE---------------------------------------
   
   minD = min(min(DistanceTable));
   maxD = max(max(DistanceTable));
   diffD = maxD - minD;
   
   for i=1:1:3
       for j=1:1:(maxk-mink+1)
           DistanceTable(i,j) = (DistanceTable(i,j) - minD)/diffD;
       end
   end
   DistanceTable   %Normalized
   
   %~~~~~~~~~~~~~~~~~~~~MIXED TABLE~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
   
    MixedTable = (Tr*TimeTable)+(Dr*DistanceTable);
   % MixedTable = zeros(4,maxk-mink+1);
    
  %  TimeTable
   % DistanceTable
    MixedTable   
    for i=mink:1:maxk
        MixedTable(4,i-(mink-1)) = i;
    end
    
    
    minElement = 1000;
    for i=1:1:3
        for j=mink:1:maxk
            if(minElement>MixedTable(i,j-(mink-1)))
                minElement = MixedTable(i,j-(mink-1));
                algoUsed = i;
                optimalCenters = j;
            end
        end
    end
    minElement
    
    hold off
    if algoUsed==1
        algoUsed = 'K-Means Algorithm';
        kmeans(data,optimalCenters);
    elseif algoUsed==2
        algoUsed = 'FCM Algorithm';
        fkmeans(data,optimalCenters);
    elseif algoUsed==3
        algoUsed = 'PCM Algorithm';
        pcm(data,optimalCenters);
    end

end