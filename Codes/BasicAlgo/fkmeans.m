function count = fkmeans(data,k)
%Here k = Number of centers/clusters User wants to Enter.
hold off %Clearing Graph.

[maxrow,maxcol]=size(data);

centers=rand(k,maxcol);  %Random Values of centers.

col = [1 0 0; 0 1 0; 1 0.6 0; 0.5 0.5 1; 0.5 0 0.9; 0.8 0.5 0; 1 0.5 1];
% red, green, dark yellow, purple, pink, orange, brown 

newcenters = zeros(k,maxcol);  %Expected answer of centers
oldmembership=zeros(maxrow,k); 
newmembership=zeros(maxrow,k); %Expected answer of membership
count = 0; % Number of Iterations
eps = 0.00000001;  %For terminating condition. Lesser the value of epsilon, more the accuracy.
hard_membership = zeros(maxrow,1);  %Needed to plot values on graph.
distance = zeros(maxrow,k);  

while(1)
    
count = count+1;
    
    
    for i=1:1:maxrow
        %Finding distance from every point to every cluster;
        for j=1:1:k
            distance(i,j) = sum((data(i,:) - centers(j,:)).^2);     % Squared Distance
            if distance(i,j)==0
                distance(i,j)=0.00000001;
            end
        end
        
        %Assigning fuzzy memberships to each point(Step 1)
        denominator = zeros(1,1);
        for j = 1:1:k
            denominator = denominator + 1/distance(i,j) ;
        end
        %(Step 2)
        for j = 1:1:k
            newmembership(i,j) = 1/(distance(i,j)*denominator);
        end
    end
 
    %Updating centers

    for j=1:1:k
        num = zeros(1,maxcol);
        den = zeros(1,1);
        
        %Step 1(Denominator) 
        for i=1:1:maxrow
            den = den + newmembership(i,j).^2;
        end
        
        %Step 2(Numerator)
        for i = 1:1:maxrow
            for x = 1:1:maxcol
                num(1,x) = num(1,x) + (newmembership(i,j).^2)*data(i,x);
            end
        end
        %Step 3(Num/Den)
        for x = 1:1:maxcol
            newcenters(j,x) = num(1,x)/den;
        end
    end

%Termination Condition (Step 1)
    difference = newmembership - oldmembership;    
    maxdiff = 0;  % Maximum element in difference matrix.
    for i=1:1:maxrow
        for j=1:1:k
            if maxdiff < difference(i,j)
                maxdiff = difference(i,j);
            end
        end
    end
%Termination Condition (Step 2)
    if maxdiff>eps    % Terminate when this maximum value is less than epsilon.
        centers = newcenters;
        oldmembership = newmembership;
        continue
    end
    break
end

%Assigning hard memberships for Graph Plotting.

for i=1:1:maxrow
    for j=1:1:k
        if newmembership(i,j) == max(newmembership(i,:))
            hard_membership(i,1) = j;
            break;
        end
    end
end


%Plotting Graph

for j=1:1:k
    new_col = col(mod(j,7)+1,:);
    for i=1:1:maxrow
       if hard_membership(i,1)==j
           plot(data(i,1),data(i,2),'o','color',new_col);
           hold on
       end
    end
end

%Plotting Centers

h= plot(newcenters(:,1),newcenters(:,2),'o');
set(h(1),'MarkerFaceColor','black');

