function count_pcm=pcm(data,k)
%Here k = Number of centers/clusters User wants to Enter.
hold off %Clearing Graph.

%FCM INITIALIZATION
[maxrow,maxcol]=size(data);
centers=rand(k,maxcol);
newcenters = zeros(k,maxcol);
oldmembership=zeros(maxrow,k);
newmembership=zeros(maxrow,k);
count = 0;
eps = 0.0001;
hard_membership = zeros(maxrow,1);
col = [1 0 0; 0 1 0; 1 0.6 0; 0.5 0.5 1; 0.5 0 0.9; 0.8 0.5 0; 1 0.5 1];
% red, green, dark yellow, purple, pink, orange, brown 
distance = zeros(maxrow,k);

while(1)
    count = count+1;
    
    %DISTANCE AND MEMBERSHIP
    for i=1:1:maxrow
        for j=1:1:k
            distance(i,j) = sum((data(i,:) - centers(j,:)).^2);
            if distance(i,j)==0
                distance(i,j)=0.00000001;
            end
        end
        denominator = zeros(1,1);
        for j = 1:1:k
            denominator = denominator + 1/distance(i,j) ;
        end
        
        for j = 1:1:k
            newmembership(i,j) = 1/(distance(i,j)*denominator);
        end
    end
    
    %NEW CENTERS
    for j=1:1:k
        num = zeros(1,maxcol);
        den = zeros(1,1);
        for i=1:1:maxrow
            den = den + newmembership(i,j).^2;
        end
        for i = 1:1:maxrow
            for x = 1:1:maxcol
                num(1,x) = num(1,x) + (newmembership(i,j).^2)*data(i,x);
            end
        end
        
        for x = 1:1:maxcol
            newcenters(j,x) = num(1,x)/den;
        end
    end
    
    
    %DIFFERECE
    difference_pcm = newmembership - oldmembership;
    maxdiff_pcm = 0;
    for i=1:1:maxrow
        for j=1:1:k
            if maxdiff_pcm < difference_pcm(i,j)
                maxdiff_pcm = difference_pcm(i,j);
            end
        end
    end
    
    
    %TERMINATING CONDITION
    if maxdiff_pcm>eps
        centers = newcenters;
        oldmembership = newmembership;
        continue
    end
    break
end




%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%newmembership
%newcenters

%PCM INITIALIZATION
oldmembership_pcm = newmembership;   %Values obtained after running FCM Algorithm
m = 1.5;
eps_pcm = 0.0000000001;
distance_pcm = distance;
count_pcm = count;

while(1)
    
    count_pcm = count_pcm+1;

    oldmembership_pcm_m = oldmembership_pcm.^m;
    den_pcm = zeros(1,k);
    num_pcm = zeros(1,k);
    eta = zeros(1,k);
    typicality = zeros(maxrow,k);
    newmembership_pcm = zeros(maxrow,k);
    newcenters_pcm = zeros(k,maxcol);
    
    
    %Calculating Eta (Step - 1)
    product = oldmembership_pcm_m.*distance_pcm;
    for j=1:1:k
        for i=1:1:maxrow
           den_pcm(1,j) = den_pcm(1,j) + oldmembership_pcm_m(i,j);
           num_pcm(1,j) = num_pcm(1,j) + product(i,j);
        end
    end
    
    %Calculating Eta (Step - 2)
    for j=1:1:k
        eta(1,j) = num_pcm(1,j)/den_pcm(1,j);
    end
    
    % Updating Typicality
    for i=1:1:maxrow
        for j=1:1:k
            typicality(i,j) = 1/((distance_pcm(i,j)/eta(1,j)).^2 + 1);
        end
    end
    
    %Updating Centers
    for j=1:1:k
        centers_num_pcm = zeros(1,maxcol);
        centers_den_pcm = zeros(1,1);
        %Step 1(Denominator)
        for i=1:1:maxrow
            centers_den_pcm = centers_den_pcm + typicality(i,j).^m;
        end
        %Step 2(Numerator)
        for x = 1:1:maxcol
            for i = 1:1:maxrow
                centers_num_pcm(1,x) = centers_num_pcm(1,x) + (typicality(i,j).^m)*data(i,x);
            end
        end
        %Step 3(Num/Den)
        for x = 1:1:maxcol
            newcenters_pcm(j,x) = centers_num_pcm(1,x)/centers_den_pcm;
        end
    end
    
    for i=1:1:maxrow
        %Updating Distance for next Iteration
        for j=1:1:k
            distance_pcm(i,j) = sum((data(i,:) - newcenters_pcm(j,:)).^2);
            if distance_pcm(i,j)==0
                distance_pcm(i,j)=0.00000001;
            end
        end
        
        %Updating Membership for next Iteration(Step-1) 
        denominator_pcm = zeros(1,1);
        for j = 1:1:k
            denominator_pcm = denominator_pcm + 1/distance_pcm(i,j) ;
        end
        
        %Updating Membership for next Iteration(Step-2)
        for j = 1:1:k
            newmembership_pcm(i,j) = 1/(distance_pcm(i,j)*denominator_pcm);
        end 
    end
    
%Termination Condition (Step 1)
    difference_pcm = newmembership_pcm - oldmembership_pcm;
    maxdiff_pcm = 0;  % Maximum element in difference matrix.
    for i=1:1:maxrow
        for j=1:1:k
            if maxdiff_pcm < difference_pcm(i,j)
                maxdiff_pcm = difference_pcm(i,j);
            end
        end
    end
    
%Termination Condition (Step 2)
    if maxdiff_pcm>eps_pcm   % Terminate when this maximum value is less than epsilon.
        oldmembership_pcm = newmembership_pcm;
        continue
    end
    break
end

%Assigning hard memberships for Graph Plotting.

for i=1:1:maxrow
    for j=1:1:k
        if newmembership_pcm(i,j) == max(newmembership_pcm(i,:))
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

h= plot(newcenters_pcm(:,1),newcenters_pcm(:,2),'o');
set(h(1),'MarkerFaceColor','black');
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`