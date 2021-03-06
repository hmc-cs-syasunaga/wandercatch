function out = util(command,varargin)
    % hub for util functions. 
    % This is just to make it look nicer (otherwise, it get too messy with 
    % a lot of different files around)
    % TODO: input number sanity check
    if strcmp(command,'getBehaviorFiles') 
        out = getBehaviorFiles(varargin{1});
    elseif strcmp(command, 'getEEGFiles')
        out = getEEGFiles(varargin{1});
    elseif strcmp(command,'getProbeLabels')
        out = getProbeLabels(varargin{1});
    elseif strcmp(command,'getLabelFiles')
        out = getLabelFiles(varargin{1});
    elseif strcmp(command, 'constructPath')
        out = constructPath(char(varargin(1)),char(varargin(2)));
    else
        error('Function ''%s'' not defined',command)
    end
    
end


%% Actual functions called by util
%TODO: Clean it up
function filenames = getBehaviorFiles(behavior_path)
    filenames = getFiles(behavior_path);
    filenames = filenames(contains(filenames,'.mat'));
end

function filenames = getEEGFiles(eeg_path)
    filenames = getFiles(eeg_path);
    filenames = filenames(contains(filenames,'.set'));
end

function filenames = getLabelFiles(label_path)
    filenames = getFiles(label_path);
    filenames = filenames(contains(filenames,'.txt'));
end

function labels = getProbeLabels(behave_file)
    load(behave_file, 'all_probe_responses')
    labels = all_probe_responses(2:7:end,9);
end

function chan_locs = readChanLocs(chan_file)
    
end

function result_path = constructPath(parent,child)
    % construct path from the parent and child
    % this just takes care of / insertion
    % Caution! This only works with Mac
    if parent(end) == '/' || parent(end) == '\'
        result_path = [parent child];
    else
        result_path = [parent '/' child];
    end
   
end


%%
%%%%%%%%%%%%%%%%%%%
% Helper Function %
%%%%%%%%%%%%%%%%%%%
function filenames = getFiles(path)
    % grabs all of the files from the path
    files = dir(path);
    filenames ={};
    cell_ind = 1;
    for i=1:length(files)
        if files(i).name(1) ~= '.'
            filenames{cell_ind} = sprintf('%s/%s',files(i).folder,files(i).name);
            cell_ind = cell_ind + 1;
        end
    end 
end