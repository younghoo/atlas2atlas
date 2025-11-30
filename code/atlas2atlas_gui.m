function atlas2atlas_gui()
% The function to create the GUI for atlas mapping
% Author: Alex / 2025-11-30 / free_learner@163.com / alexbrain.cn
% Version: 1.0

% Create the main figure
S.fig = figure('Position', [200 200 550 400], 'MenuBar', 'none', 'NumberTitle','off', 'Name', 'Atlas2Atlas (v1.0)', 'Resize', 'off');

% Create the button to select the source atlas file
S.SourceButton = uicontrol('Style', 'pushbutton', 'String', 'Select Source Atlas', 'Position', [50, 325, 200, 50]);
% Create the label to show the filename of the selected
S.SourceName = uicontrol('Style', 'text', 'Position', [300 325 230 40], 'String', '');
% Set the callback function
set(S.SourceButton, 'Callback', {@selectFile, S, 'Source'});

% Create the button to select the target atlas file
S.TargetButton = uicontrol('Style', 'pushbutton', 'String', 'Select Target Atlas', 'Position', [50, 250, 200, 50]);
% Create the label to show the filename of the selected
S.TargetName = uicontrol('Style', 'text', 'Position', [300 250 230 40], 'String', '');
% Set the callback function
set(S.TargetButton, 'Callback', {@selectFile, S, 'Target'});

% Create the button to select the output folder
S.OutputButton = uicontrol('Style', 'pushbutton', 'String', 'Select Output Folder', 'Position', [50, 175, 200, 50]);
% Create the label to show the foldername of the selected
S.OutputName = uicontrol('Style', 'text', 'Position', [300 175 230 40], 'String', '');
% Set the callback function
set(S.OutputButton, 'Callback', {@selectFolder, S});

% Create the edit box to set output prefix
S.PrefixBox = uicontrol('Style', 'edit', 'Position', [50 100 200 50], 'String', 'Source2Target');
% Create the label to show the output prefix
S.PrefixName = uicontrol('Style', 'text', 'Position', [300 100 230 35], 'String', 'Default Output Prefix', 'foregroundcolor','blue');
% Set the callback function
set(S.PrefixBox, 'Callback', {@setPrefix, S});

% Create the button to run the calculation
S.RunButton = uicontrol('Style', 'pushbutton', 'String', 'Run Calculation', 'Position', [50, 25, 200, 50]);
% Create the label to show the running status
S.RunStatus = uicontrol('Style', 'text', 'Position', [300 25 230 35], 'String', '');
% Set the callback function
set(S.RunButton, 'Callback', {@doCalc, S});

% Define the function to select input files
    function selectFile(~, ~, S, FileType)
        if strcmp(FileType, 'Source')
            [FileName, PathName] = uigetfile({'*.nii;*.nii.gz', 'NIfTI Files (*.nii, *.nii.gz)'}, 'Select Source Atlas File', 'MultiSelect', 'off');
            if ~isequal(FileName, '')
                SourceFile = fullfile(PathName, FileName);
                % Display only the first 20 characters of the filename
                DispName=FileName(1:min(20, length(FileName)));
                set(S.SourceName, 'String', ['Source Atlas: ' DispName], 'foregroundcolor','blue');
                set(S.SourceButton, 'userdata', SourceFile);
            end
        end
        if strcmp(FileType, 'Target')
            [FileName, PathName] = uigetfile({'*.nii;*.nii.gz', 'NIfTI Files (*.nii, *.nii.gz)'}, 'Select Target Atlas File', 'MultiSelect', 'off');
            if ~isequal(FileName, '')
                TargetFile = fullfile(PathName, FileName);
                DispName=FileName(1:min(20, length(FileName)));
                set(S.TargetName, 'String', ['Target Atlas: ' DispName], 'foregroundcolor','blue');
                set(S.TargetButton, 'userdata', TargetFile);
            end
        end
    end

% Define the function to select the output folder
    function selectFolder(~, ~, S)
        OutputFolder = uigetdir('', 'Select Output Folder');
        if ~isequal(OutputFolder, 0)
            % Display the last 15 characters of the output path
            if length(OutputFolder) > 15
                DispName = ['...', OutputFolder(end-14:end)];
            else
                DispName = OutputFolder;
            end
            set(S.OutputName, 'String', ['Output Folder: ' DispName], 'foregroundcolor','blue');
            set(S.OutputButton, 'userdata',OutputFolder);
        end
    end

% Define the function to set the output prefix
    function setPrefix(~, ~, S)
        OutputPrefix = get(S.PrefixBox, 'String');
        if ~isempty(OutputPrefix)
            DispName=OutputPrefix(1:min(20, length(OutputPrefix)));
            set(S.PrefixName, 'String', ['Output Prefix: ' DispName], 'foregroundcolor','blue');
        end
    end

% Define the function to do atlas mapping
    function doCalc(~, ~, S)
        SourceFile = get(S.SourceButton, 'userdata');
        TargetFile = get(S.TargetButton, 'userdata');
        OutputFolder = get(S.OutputButton, 'userdata');
        OutputPrefix = get(S.PrefixBox, 'String');
        %% Invoke the atlas2atlas_core to do the calculation
        atlas2atlas_core(SourceFile, TargetFile, OutputFolder, OutputPrefix);
        %% If finished?
        set(S.RunStatus, 'string','Finished', 'foregroundcolor','blue');
    end
end

