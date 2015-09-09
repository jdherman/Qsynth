% Verify autocorrelation at each site
% Given historical and synthetic (real-space) streamflows

clc; clear all;
inflow_files = {'falls-lake', 'jordan-lake', 'little-river', 'michie', 'owasa'}; 

for k=1:length(inflow_files)
	subplot(2,5,k);
    Qh = load(['inflow-data/' inflow_files{k} '.csv']);
    Yh = log(Qh);
    for i=1:52
        Zh(:,i) = (Yh(:,i) - mean(Yh(:,i)))/std(Yh(:,i));
    end
    imagesc(corr(Zh));
    set(gca, 'ydir', 'normal');
    colormap(flipud(hot));
    caxis([0 1]);
    set(gca, 'xtick', [], 'ytick', []);
    title(inflow_files{k});
    axis square;
    
    Qs = load(['inflow-synthetic/' inflow_files{k} '.csv']);
    Ys = log(reshape(Qs(1,:),52,[])'); % pick one row for example
    for i=1:52
        Zs(:,i) = (Ys(:,i) - mean(Ys(:,i)))/std(Ys(:,i));
    end
     
    subplot(2,5,5+k);
    imagesc(corr(Zs));
    set(gca, 'ydir', 'normal');
    set(gca, 'xtick', [], 'ytick', []);
    colormap(flipud(hot));
    caxis([0 1]);
    axis square;
     
end
