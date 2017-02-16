function avg_var = pcm_dist(data,k)
%k is the kind you want to divide
%data is the data you need to divide

%FCM INITIALIZATION
[maxrow,maxcol]=size(data);
centers=rand(k,maxcol);
newcenters = zeros(k,maxcol);
oldmembership=zeros(maxrow,k);
newmembership=zeros(maxrow,k);
count = 0;
eps = 0.00001;
hard_membership = zeros(maxrow,1);
col = [1 0 0; 0 0 1; 0 1 0; 1 1 0; 1 0.6 0; 0.5 0.5 1; 0.5 0 0.9; 0.8 0.5 0; 1 0.5 1];
% red blue green black, dark yellow, purple, pink, orange, brown 
distance = zeros(maxrow,k);

hold off
while(1)
    count = count+1;
    %count
    
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
%plot(newcenters(:,1),newcenters(:,2),'o','color','red');

%PCM INITIALIZATION
oldmembership_pcm = newmembership;
m = 1.5;
eps_pcm = 0.0000000001;
distance_pcm = distance;
count_pcm = 0;

while(1)
    count_pcm = count_pcm+1;

    oldmembership_pcm_m = oldmembership_pcm.^m;
    den_pcm = zeros(1,k);
    num_pcm = zeros(1,k);
    eta = zeros(1,k);
    typicality = zeros(maxrow,k);
    newmembership_pcm = zeros(maxrow,k);
    newcenters_pcm = zeros(k,maxcol);
    
    
    %eta numerator and denominator
    product = oldmembership_pcm_m.*distance_pcm;
    for j=1:1:k
        for i=1:1:maxrow
           den_pcm(1,j) = den_pcm(1,j) + oldmembership_pcm_m(i,j);
           num_pcm(1,j) = num_pcm(1,j) + product(i,j);
        end
    end
    
    
    %eta
    for j=1:1:k
        eta(1,j) = num_pcm(1,j)/den_pcm(1,j);
    end
    
    
    %typicality
    for i=1:1:maxrow
        for j=1:1:k
            typicality(i,j) = 1/((distance_pcm(i,j)/eta(1,j)).^2 + 1);
        end
    end
    
    
    %new centers
    for j=1:1:k
        centers_num_pcm = zeros(1,maxcol);
        centers_den_pcm = zeros(1,1);
        for i=1:1:maxrow
            centers_den_pcm = centers_den_pcm + typicality(i,j).^m;
        end
        for x = 1:1:maxcol
            for i = 1:1:maxrow
                centers_num_pcm(1,x) = centers_num_pcm(1,x) + (typicality(i,j).^m)*data(i,x);
            end
        end
        
        for x = 1:1:maxcol
            newcenters_pcm(j,x) = centers_num_pcm(1,x)/centers_den_pcm;
        end
    end
    
    
    %DISTANCE AND MEMBERSHIP
    for i=1:1:maxrow
        for j=1:1:k
            distance_pcm(i,j) = sum((data(i,:) - newcenters_pcm(j,:)).^2);
            if distance_pcm(i,j)==0
                distance_pcm(i,j)=0.00000001;
            end
        end
        denominator_pcm = zeros(1,1);
        for j = 1:1:k
            denominator_pcm = denominator_pcm + 1/distance_pcm(i,j) ;
        end
        
        for j = 1:1:k
            newmembership_pcm(i,j) = 1/(distance_pcm(i,j)*denominator_pcm);
        end 
    end
    
    %MEMBERSHIP DIFFERENCE
    difference_pcm = newmembership_pcm - oldmembership_pcm;
    maxdiff_pcm = 0;
    for i=1:1:maxrow
        for j=1:1:k
            if maxdiff_pcm < difference_pcm(i,j)
                maxdiff_pcm = difference_pcm(i,j);
            end
        end
    end
    
    
    %TERMINATING CONDITION
    if maxdiff_pcm>eps_pcm
        oldmembership_pcm = newmembership_pcm;
        continue
    end
    break
end

% Graph Plotting

for i=1:1:maxrow
    for j=1:1:k
        if newmembership_pcm(i,j) == max(newmembership_pcm(i,:))
            hard_membership(i,1) = j;
            break;
        end
    end
end
%hard_membership
%cluster_num
for j=1:1:k
    new_col = col(mod(j,9)+1,:);
    for i=1:1:maxrow
       if hard_membership(i,1)==j
           plot(data(i,1),data(i,2),'o','color',new_col);
           hold on
       end
    end
end

%newmembership_pcm
%plot(newcenters_pcm(:,1),newcenters_pcm(:,2),'kx','color','blue');
%hold off
%newcenters_pcm

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`

cluster_num = zeros(1,k);
for j=1:1:k
    for i=1:1:maxrow
      if hard_membership(i,1)==j
        cluster_num(1,j)=cluster_num(1,j)+1;
      end
    end
end
%cluster_num
%Variance
var = zeros(1,k);
for j=1:1:k
    for i=1:1:maxrow
        if hard_membership(i,1)==j
            var(1,j)=var(1,j)+sqrt(distance(i,j));
        end
    end
end

avg_var = sum(var)/sum(cluster_num);
%newcenters
