% Verify correlation between sites
% Given historical and synthetic (real-space) streamflows

clc; clear all;
inflow_files = {'falls-lake', 'jordan-lake', 'little-river', 'michie', 'owasa'};  

for k=1:length(inflow_files)
    Qh = load(['inflow-data/' inflow_files{k} '.csv']);
    Yh = log(Qh);
    for i=1:52
        Z(:,i) = (Yh(:,i) - mean(Yh(:,i)))/std(Yh(:,i));
    end
    Zh(:,k) = reshape(Z', 1, []);
    
    Qs = load(['inflow-synthetic/' inflow_files{k} '.csv']);
    Ys = log(reshape(Qs(1,:), 52, [])'); % pick one row
    for i=1:52
        Z2(:,i) = (Ys(:,i) - mean(Ys(:,i)))/std(Ys(:,i));
    end
    Zs(:,k) = reshape(Z2', 1, []);
    
    inflow_ticks{k} = strrep(inflow_files{k}, '-', ' ');
end

subplot(1,2,1);
[rho1,p1] = corr(Zh);

imagesc(rho1);
set(gca, 'ydir', 'normal');
set(gca, 'ytick', 1:length(inflow_files));
set(gca, 'yticklabel', inflow_ticks);
set(gca, 'xtick', 1:length(inflow_files));
set(gca, 'xticklabel', inflow_ticks);
colormap(flipud(hot));
caxis([0 1]);
axis square;

subplot(1,2,2);
[rho2,p2] = corr(Zs);

imagesc(rho2);
set(gca, 'ydir', 'normal');
set(gca, 'ytick', 1:length(inflow_files));
set(gca, 'yticklabel', inflow_ticks);
set(gca, 'xtick', 1:length(inflow_files));
set(gca, 'xticklabel', inflow_ticks);
colormap(flipud(hot));
caxis([0 1]);
axis square;
