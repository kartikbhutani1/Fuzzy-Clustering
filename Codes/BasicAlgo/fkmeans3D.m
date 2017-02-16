function fkmeans3D(data,k)
hold off
[maxrow,maxcol]=size(data);
centers=rand(k,maxcol);  %CHOOSING RANDOM NUMBERS
newcenters = zeros(k,maxcol);
oldmembership=zeros(maxrow,k);
newmembership=zeros(maxrow,k);
count = 0;
eps = 0.00000001;
hard_membership = zeros(maxrow,1);
col = [1 1 0; 0 1 0; 0 0 1; 1 0.78 0.80];
%dark yellow, green, blue, pink 
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

%COUNT VALUE - 
%count

%ASSIGN MEMBERSHIP

for i=1:1:maxrow
    for j=1:1:k
        if newmembership(i,j) == max(newmembership(i,:))
            hard_membership(i,1) = j;
            break;
        end
    end
end

newcenters

% 3D GRAPH PLOTTING
X = transpose(data(:,1));
Y = transpose(data(:,2));
Z = transpose(data(:,3));
CX = transpose(centers(:,1));
CY = transpose(centers(:,2));
CZ = transpose(centers(:,3));

for j=1:1:k
    new_col = col(mod(j,4)+1,:);
    for i=1:1:maxrow
       if hard_membership(i,1)==j
           stem3(X(1,i),Y(1,i),Z(1,i),'MarkerFaceColor',new_col,'Linestyle','none');
           hold on
       end
    end
end

for j=1:1:k
    stem3(CX(1,j),CY(1,j),CZ(1,j),'MarkerFaceColor','black','Linestyle','--');
    hold on
end











