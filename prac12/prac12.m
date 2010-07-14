
% Exercise Sheet 12 of AAND_2010
% Solution of Stephan Gabler (329131)

clear
clc

load features_lecture_adaptiveBCI.mat

%% part 1

% select datapoints according to condition (training data)
train_left  = fv_train.x(:, logical(fv_train.y(1,:)));
train_foot  = fv_train.x(:, logical(fv_train.y(2,:)));

% train fisher discriminant (also for pooled data)
[w,b]                   = trainFD(fv_train.x, fv_train.y);
[w_pool, b_pool, vars]  = trainFDpool(fv_train.x, fv_train.y);


% plot data and discriminant
figure(1)
plot(train_left(1,:), train_left(2,:), '.b')
hold on  
plot(train_foot(1,:), train_foot(2,:), '.r')
yl = (-w(1)*xlim-b)/w(2);
plot(xlim, yl, 'k');

% show that the two discriminants point in the same direction (linearly dependent)
if rank([w w_pool]) == 1
    disp(['discriminants linearly dependend, prop. factor: ' num2str(b_pool/b)]);
else
    disp('discriminants NOT dependend');
end



%% part 2

% select datapoints according to condition (test data)
test_left  = fv_test.x(:, logical(fv_test.y(1,:)));
test_foot  = fv_test.x(:, logical(fv_test.y(2,:)));

% initialization of classifier from pooled FD
S       = vars.S3;
S_ext   = [1, vars.m3'; vars.m3 vars.S3*vars.m3*vars.m3'];
m       = vars.m3;
UC      = 0.01;
label   = NaN(1, length(fv_test.x));

% update classification (both types
for i=1:length(fv_test.x)
    label(i)            = sign(w'*fv_test.x(:,i)+b); 
    [ w, b, m, S]       = classify1(S, m, fv_test.x(:,i), vars.m1-vars.m2, UC);
    [ w2, b2, S_ext]    = classify2(S_ext, fv_test.x(:,i), vars.m1-vars.m2, UC);
end

% plot test data and final classification
plot(test_left(1,:), test_left(2,:), '.g')
plot(test_foot(1,:), test_foot(2,:), '.y')
yl = (-w(1)*xlim-b)/w(2);
plot(xlim, yl, 'm');
yl = (-w2(1)*xlim-b2)/w2(2);
plot(xlim, yl, 'c');

% plot settings
legend('train left', 'train foot', 'FD', 'test left', 'test foot',...
    'classify1 (updated)', 'classify2 (updated)')
hold off
axis equal

% check whether both classifiers give same results
angle_between_classifiers = acos((w./norm(w))' *w2./norm(w2)) * 360/2*pi;
if angle_between_classifiers < 2        % angle smaller than 2 degrees
    disp('both classifiers lead to almost same result');
    disp(['angle between classifiers (deg) is: ' num2str(angle_between_classifiers)]);
else
    disp('oh oh, classifiers dont give the same result');
end



%% part 3 (quantification of classification)
correct_label   = [1 -1]*fv_test.y;
perc_wrong      = sum(label~=correct_label)/length(label) *100;
disp(['missclassified test data (%): ' num2str(perc_wrong)]);



