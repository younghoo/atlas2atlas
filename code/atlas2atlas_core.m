function [] = atlas2atlas_core(SourceAtlas, TargetAtlas, OutputFolder, OutputPrefix)
% The function to calculate the mapping from the source atlas to the target atlas
% Author: Alex / 2025-11-30 / free_learner@163.com / alexbrain.cn

% Load source atlas data
sour_data = spm_read_vols(spm_vol(SourceAtlas));
% Find the unique IDs
sour_IDs = sort(unique(sour_data));
% Remove the background ID
sour_IDs = sour_IDs(2:end);
% Get the number of IDs
sour_num = length(sour_IDs);
% Load target atlas data
targ_data = spm_read_vols(spm_vol(TargetAtlas));
targ_IDs = sort(unique(targ_data));
targ_IDs = targ_IDs(2:end);
targ_num = length(targ_IDs);

% Loop each ID in the source atlas
overlap_dat = zeros(sour_num, targ_num);
for curr_sour_idx = 1:sour_num
    curr_sour_ID = sour_IDs(curr_sour_idx);
    % Loop each ID in the target atlas
    for curr_targ_idx = 1:targ_num
        curr_targ_ID = targ_IDs(curr_targ_idx);
        % Calculate the overlap between the current source and target ID
        curr_sour_data = sour_data == curr_sour_ID;
        curr_targ_data = targ_data == curr_targ_ID;
        curr_overlap = nnz(curr_sour_data & curr_targ_data);
        overlap_dat(curr_sour_idx, curr_targ_idx) = curr_overlap;
    end
end
% Map the source ID to the target ID with the max overlap. 
[max_overlap, max_targ_IDs] = max(overlap_dat, [], 2);
output_dat = [sour_IDs max_targ_IDs];
% Save output
out_fname = fullfile(OutputFolder, [OutputPrefix, '_mapping.txt']);
dlmwrite(out_fname, output_dat, 'delimiter', ' ');

