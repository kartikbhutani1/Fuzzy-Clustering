function avg_dist = fkmeans_dist(data,k)
hold off
[maxrow,maxcol]=size(data);
centers=rand(k,maxcol);  %CHOOSING RANDOM NUMBERS
newcenters = zeros(k,maxcol);
oldmembership=zeros(maxrow,k);
newmembership=zeros(maxrow,k);
count = 0;
eps = 0.00000001;
hard_membership = zeros(maxrow,1);
col = [1 0 0; 0 0 1; 0 1 0; 1 1 0; 1 0.6 0; 0.5 0.5 1; 0.5 0 0.9; 0.8 0.5 0; 1 0.5 1];
% red blue green black, dark yellow, purple, pink, orange, brown 
distance = zeros(maxrow,k);     % 140 X 3

while(1)
    
count = count+1;
    
    %DISTANCE CALCULATION
    for i=1:1:maxrow
        for j=1:1:k
            distance(i,j) = sum((data(i,:) - centers(j,:)).^2);     % squared distance
            if distance(i,j)==0
                distance(i,j)=0.00000001;
            end
        end
        %MEMBERSHIP STEP 1
        denominator = zeros(1,1);
        for j = 1:1:k
            denominator = denominator + 1/distance(i,j) ;
        end
        %MEMBERSHIP STEP 2
        for j = 1:1:k
            newmembership(i,j) = 1/(distance(i,j)*denominator);
        end
    end
 
%NEW CENTERS CALCULATION

    for j=1:1:k
        num = zeros(1,maxcol);
        den = zeros(1,1);
        
        %DENOMINATOR 
        for i=1:1:maxrow
            den = den + newmembership(i,j).^2;
        end
        
        %NUMERATOR
        for i = 1:1:maxrow
            for x = 1:1:maxcol
                num(1,x) = num(1,x) + (newmembership(i,j).^2)*data(i,x);
            end
        end
        %CENTERS
        for x = 1:1:maxcol
            newcenters(j,x) = num(1,x)/den;
        end
    end

%TERMINATION CONDITION STEP - 1
    difference = newmembership - oldmembership;     % 140 X 3
    maxdiff = 0;  % MAXIMUM ELEMENT IN 140x3 MATRIX
    for i=1:1:maxrow
        for j=1:1:k
            if maxdiff < difference(i,j)
                maxdiff = difference(i,j);
            end
        end
    end
%TERMINATION CONDITION STEP - 2    
    if maxdiff>eps
        centers = newcenters;
        oldmembership = newmembership;
        continue
    end
    break
end

%ASSIGN MEMBERSHIP

for i=1:1:maxrow
    for j=1:1:k
        if newmembership(i,j) == max(newmembership(i,:))
            hard_membership(i,1) = j;
            break;
        end
    end
end

%GRAPH PLOTTING

for j=1:1:k
    %new_col = rand(1,3);
    % random removed coz of similar colors.
    new_col = col(mod(j,9)+1,:);
    for i=1:1:maxrow
       if hard_membership(i,1)==j
           plot(data(i,1),data(i,2),'o','color',new_col);
           hold on
       end
    end
end
%----------------------------------------------------------------------------------------

cluster_num = zeros(1,k);
for j=1:1:k
    for i=1:1:maxrow
      if hard_membership(i,1)==j
        cluster_num(1,j)=cluster_num(1,j)+1;
      end
    end
end

%Distance Comparison

dist = zeros(1,k);
for j=1:1:k
    for i=1:1:maxrow
        if hard_membership(i,1)==j
            dist(1,j)=dist(1,j)+sqrt(distance(i,j));
        end
    end
end

avg_dist = sum(dist)/sum(cluster_num);



















