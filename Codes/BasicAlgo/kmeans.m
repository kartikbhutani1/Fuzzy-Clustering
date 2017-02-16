function count = kmeans(data,k)
%Here k = Number of centers User wants to Enter.
hold off  %Clearing Graph.

[maxrow,maxcol]=size(data);

begin = data(1:k,:);  %Random Values of centers.

col = [1 0 0; 0 1 0; 1 0.6 0; 0.5 0.5 1; 0.5 0 0.9; 0.8 0.5 0; 1 0.5 1];
% red, green, dark yellow, purple, pink, orange, brown 

distance=zeros(maxrow,k);     %For each and every point from every center
membership = zeros(maxrow,1); %For each and every point, just one value (because hard clustering)
count = 0; % Number of Iterations

while(1)
    
    count = count + 1;        
    cluster_num=zeros(1,k);  % Number of points in each cluster
    centers=zeros(k,maxcol); % Updated value of centers after each iteration

    %Finding distance from every point to every cluster;
    for i=1:1:maxrow
        for j=1:1:k
        distance(i,j)=sqrt(sum([(data(i,:))-(begin(j,:))].^2)); 
        end  
    end
    
    %Assigning membership to each point according to minimum Distance
    for i=1:1:maxrow
       for j=1:1:k
           if distance(i,j)==min(distance(i,:))
               membership(i,1) = j;
               break;
           end
       end       
    end
    
    %Calculating new centers
    for j=1:1:k
        for i=1:1:maxrow
            if membership(i,1)==j
                cluster_num(1,j)=cluster_num(1,j)+1;
                for t=1:1:maxcol
                    centers(j,t)= centers(j,t)+data(i,t);   % Finding mean - Step 1 (i.e. Sum)
                end
            end 
        end
        for t=1:1:maxcol
            centers(j,t)=centers(j,t)/cluster_num(1,j);   % Finding mean Step 2 (i.e. Divide by total Number)
        end
    end
   
 %Termination condition  
 if begin~=centers 
 begin=centers ;
 continue
 end
 
 break  %While ends.
 
end

centers
%Plotting Graph

for j=1:1:k
    new_col = col(mod(j,7)+1,:);   %Picking new color for each cluster.
    for i=1:1:maxrow
       if membership(i,1)==j
           plot(data(i,1),data(i,2),'o','color',new_col);
           hold on
       end
    end
end

%Plotting Centers

h= plot(centers(:,1),centers(:,2),'o');
set(h(1),'MarkerFaceColor','black');
hold on

%Labels
xlabel('Chest Width');
ylabel('Length');
title('Shirts Size Distribution');
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


















