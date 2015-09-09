clc; clear all;

inflow_dir = 'inflow-data';
inflow_files = {'falls-lake', 'jordan-lake', 'little-river', 'michie', 'owasa'};               

num_realizations = 10;
num_years = 100;
timesteps_per_year = 52;

for k=1:length(inflow_files)
    Qh{k} = load([inflow_dir '/' inflow_files{k} '.csv']);
    output{k} = zeros(num_realizations, num_years*timesteps_per_year);
end

p = 0.20; % fixed quantile flow
n = 3; % times more likely (can be floating point value)

% generate realizations
for r=1:num_realizations
    Qs = Qsynth(Qh, num_years, p, n);

    for k=1:length(inflow_files)
        output{k}(r,:) = reshape(Qs{k}',1,[]);
    end
end


for k=1:length(inflow_files)
    dlmwrite(['inflow-synthetic/' inflow_files{k} '.csv'], output{k});
end
