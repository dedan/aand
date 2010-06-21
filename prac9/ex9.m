% AAND Sheet 9

%% exercise 1
load erp_hexVPsag.mat

class1 = mrk.pos(logical(mrk.y(1,:)));
class2 = mrk.pos(logical(mrk.y(2,:)));

intervals = [120 140; 200 220; 230 260; 260 290; 300 320; 330 370; 380 430; 460 490];

c1_mean = zeros(8,55);
c2_mean = zeros(8,55);

baseline = zeros(1,55);

for i = 1:length(mrk.y)
   
    baseline = baseline + mean(cnt.x(mrk.pos(i)-10: mrk.pos(i),:));
    
end

baseline = baseline/length(mrk.y);


r_c = zeros(8,55);
for i = 1:8
    start = intervals(i,1);
    stop  = intervals(i,2);
    
    ca = zeros((stop-start)/10 + 1, 55, length(class(1)));
    for j = 1:length(class1)
        c1_mean(i,:) = c1_mean(i,:) + mean(cnt.x(class1(j)+start/10:class1(j)+stop/10,:));
        ca(:,:,j) = cnt.x(class1(j)+start/10:class1(j)+stop/10,:);
    end
    
    cb = zeros((stop-start)/10 + 1, 55, length(class(2)));
    for j = 1:length(class2)
       c2_mean(i,:) = c2_mean(i,:) + mean(cnt.x(class2(j)+start/10:class2(j)+stop/10,:));
       cb(:,:,j) = cnt.x(class2(j)+start/10:class2(j)+stop/10,:);
    end
    
    for k = 1:55
        for j = 1:(stop-start)/10 + 1
            r_c(i,k) = r_c(i,k) + r_squared(squeeze(ca(j,k,:)),squeeze(cb(j,k,:)));
        end
    end
    r_c(i,:) = r_c(i,:)./((stop-start)/10 + 1);
end



c1_mean = c1_mean/length(class1) - ones(8,1)*baseline;
c2_mean = c2_mean/length(class2) - ones(8,1)*baseline;

figure(1)
set(gcf, 'Position', [100 100 1100 700])
for i = 1:8
    subplot(2,8,i)
    scalpmap(mnt, c1_mean(i,:))
    subplot(2,8,i+8)
    scalpmap(mnt,c2_mean(i,:))
end

%% exercise 2

interval = [-100 600];

c1 = zeros(71,55,length(class1));
c2 = zeros(71,55,length(class2));

for i = 1:length(class1)   
    c1(:,:,i) = cnt.x(class1(i)+interval(1)/10:class1(i)+interval(2)/10,:);
end

c1 = c1/length(class1);

for i = 1:length(class2)
    c2(:,:,i) = cnt.x(class2(i)+interval(1)/10:class2(i)+interval(2)/10,:);
end

c2 = c2/length(class2);

r_quadrat = zeros(71,55);

for i = 1:55
    for j = 1:71
        r_quadrat(j,i) = r_squared(squeeze(c1(j,i,:)),squeeze(c2(j,i,:)));
    end
end
figure
imagesc(r_quadrat')

figure(2)
set(gcf, 'Position', [100 100 1100 200])
for i = 1:8
    subplot(1,8,i)
    scalpmap(mnt, r_c(i,:))
end

%% task 3
range = logspace(1,3,100);
dist = randn(200,100);
for i = 1:length(range)
    dist(:,i) = dist(:,i) * range(1,i);
end

[v,d] = eig(cov(dist));
figure
plot(diag(d),'-o')
hold on
plot(range(1,:).^2,'r')
legend('empirical variance','true variance')