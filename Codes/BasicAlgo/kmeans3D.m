function kmeans3D(data,k)
hold off
[maxrow,maxcol]=size(data);
%begin=[28 40;30 42; 32 45];
%A = min(data);
%B = max(data);
%C = (B + A)/2;
%begin = [A; B; C]
begin = data(1:k,:);
col = [1 0 0; 0 1 0; 1 0.6 0; 1 1 0; 0.5 0.5 1; 0.5 0 0.9; 0.8 0.5 0; 1 0.5 1];
% red green dark yellow black purple, pink, orange, brown 

distance=zeros(maxrow,k);  % 140 X 3
membership = zeros(maxrow,1);
count = 0;
while(1)
    
count = count + 1;
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

%Plotting 3D graph
X = transpose(data(:,1));
Y = transpose(data(:,2));
Z = transpose(data(:,3));
CX = transpose(centers(:,1));
CY = transpose(centers(:,2));
CZ = transpose(centers(:,3));

for j=1:1:k
    %new_col = rand(1,3);
    % random removed coz of similar colors.
    new_col = col(mod(j,8)+1,:);
    for i=1:1:maxrow
       if membership(i,1)==j
           %plot(data(i,1),data(i,2),'o','color',new_col);
           stem3(X(1,i),Y(1,i),Z(1,i),'MarkerFaceColor',new_col,'Linestyle','none');
           hold on
       end
    end
end

for j=1:1:k
    stem3(CX(1,j),CY(1,j),CZ(1,j),'MarkerFaceColor','black','Linestyle','--');
    hold on
end