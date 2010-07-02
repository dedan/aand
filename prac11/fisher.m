function [w, b] = fisher(data, classes)

class1 = data(:,logical(classes(1,:)));
class2 = data(:,logical(classes(2,:)));

u1 = mean(class1,2);
u2 = mean(class2,2);

s1 = zeros(size(class1,1));
s2 = zeros(size(class2,1));

for i = 1:size(class1,2)
    s1 = s1 + (class1(:,i) - u1) * (class1(:,i) - u1)'; 
end
    
for i = 1:size(class2,2)
    s2 = s2 + (class2(:,i) - u2) * (class2(:,i) - u2)'; 
end

w = inv(s1+s2)*(u1-u2);
b = -(w'*(u1+u2))/2;