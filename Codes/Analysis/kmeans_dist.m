function avg_var = kmeans_dist(data,k)
hold off
[maxrow,maxcol]=size(data);
%begin=[28 40;30 42; 32 45];
%A = min(data);
%B = max(data);
%C = (B + A)/2;
%begin = [A; B; C]
begin = data(1:k,:);
col = [1 0 0; 0 0 1; 0 1 0; 1 1 0; 1 0.6 0; 0.5 0.5 1; 0.5 0 0.9; 0.8 0.5 0; 1 0.5 1];
% red blue green black, dark yellow, purple, pink, orange, brown 

distance=zeros(maxrow,k);  % 140 X 3
membership = zeros(maxrow,1);

while(1)
cluster_num=zeros(1,k);           % 1 X 3
centers=zeros(k,maxcol); % 3 X 2

    for i=1:1:maxrow
        for j=1:1:k
        distance(i,j)=sqrt(sum([(data(i,:))-(begin(j,:))].^2));  %Finding dist of every point to every cluster;
        end  
    end
    
    for i=1:1:maxrow
       for j=1:1:k
           if distance(i,j)==min(distance(i,:))  % Specifying cluster membership
              % data(i,maxcol+1)=j;
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
         centers(j,t)= centers(j,t)+data(i,t);   % Finding mean - Step 1 ( See line 46 for step2)
       end
      end 
    end
    for t=1:1:maxcol
    centers(j,t)=centers(j,t)/cluster_num(1,j);   % Finding mean step 2
    end
   end
   
 %Termination condition  
 if begin~=centers 
 begin=centers ;
 continue
 end
 
 break % while ends.
 
end

%Plotting graph

for j=1:1:k
    %new_col = rand(1,3);
    % random removed coz of similar colors.
    new_col = col(mod(j,9)+1,:);
    for i=1:1:maxrow
       if membership(i,1)==j
           plot(data(i,1),data(i,2),'o','color',new_col);
           hold on
       end
    end
end
   
%centers

%Variance

var = zeros(1,k);
for j=1:1:k
    for i=1:1:maxrow
        if membership(i,1)==j
            var(1,j)=var(1,j)+distance(i,j);
        end
    end
end

avg_var = sum(var)/sum(cluster_num);

%for j=1:1:k
 %   var(1,j)=var(1,j)/num(1,j);
%end
  