function Demonetization(data,k)
hold off
iter = 0;
below = 0;
above = 0;
[maxrow,maxcol] = size(data);

%PARTITIONING OF DATA
for i=1:1:maxrow
    if(data(i,3)>=2.5&&data(i,3)<10)
        iter = iter+1;
        for j=1:1:maxcol
            actualData(iter,j)=data(i,j);
        end
    elseif(data(i,3)<2.5)
        below = below+1;
        for j=1:1:maxcol
            belowData(below,j)=data(i,j);
        end
    else
        above = above+1;
        for j=1:1:maxcol
            aboveData(above,j)=data(i,j);
        end
    end
end

%APPLYING CLUSTERING ALGO TO FILTERED DATA
fkmeans3D(actualData,k);

%PLOTTING INDIA MAP
hold on
India = xlsread('C:\Users\kartik1\Desktop\Project\Data\India.xlsx');
plot(India(:,1),India(:,2));
hold on
plot(belowData(:,1),belowData(:,2),'x','color','black');
hold on

%PLOTTING ABOVE DATA
X = transpose(aboveData(:,1));
Y = transpose(aboveData(:,2));
Z = transpose(aboveData(:,3));

for j=1:1:above
    stem3(X(1,j),Y(1,j),Z(1,j),'MarkerFaceColor','red','Linestyle','none');
    hold on
end


xlabel('LONGITUDE');
ylabel('LATITUDE');
zlabel('AMOUNT');
title('DEMONETIZATION DEFAULTERS');













    