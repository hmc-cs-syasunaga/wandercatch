% spm2eeglab
% script to loop through spm files to eeglab files
% Created by Shota Yasunaga
% shotayasunaga1996@gmail.com

clear all

%%%%%%%%%%%%%
% Edit Here %
%%%%%%%%%%%%%
% Edit here (if needed, including Constant)
% Directory to the spm files
% *Do not put anything except the data 
spm_dir = '/Users/macbookpro/Documents/Tsuchiya_Lab_Data/Probes/spm';

% Look at convert_location_mat2eeglab if you don't have one
location_file_dir = ...
    '/Users/macbookpro/Dropbox/College/TsuchiyaLab/wandercatch/EEG/chan_loc.xyz';

saving_path = '/Users/macbookpro/Documents/Tsuchiya_Lab_Data/Probes/eeglab';
% Directory where you want to save the figure
% saving_dir = '/Users/macbookpro/Dropbox/College/TsuchiyaLab/Plots';


%%%%%%%%%%%%
% Constant %
%%%%%%%%%%%%
NUM_CHANNELS = 64;
% sampling Rate
Fs = 500;
%%%%%%%%%%%%%%%%%%%
% End of Editting %
%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%
% Script %
%%%%%%%%%%


files = dir(spm_dir);
files=files(~ismember({files.name},{'.','..'}));

cd(spm_dir)

eeglab

for i = 1:length(files)
    if isMat((files(i).name))
        file_name = files(i).name;
        name_wo_mat = file_name(1:end-4); 
        fprintf('Processing %s',char(file_name))
        load(files(i).name)
        D.data.fname = sprintf('%s%c%s%s',spm_dir,'/',name_wo_mat,'.dat');
        data = D.data(1:NUM_CHANNELS,:,:);
        EEG = pop_importdata('dataformat','array','nbchan',NUM_CHANNELS,'data','data',...
            'setname',name_wo_mat,'srate',Fs,'pnts',0,'xmin',0,'chanlocs',...
            location_file_dir);
        
        % Fix the radius value 
        % Please let me know if you find better way to do this
        
        for c = 1:NUM_CHANNELS
            x = EEG.chanlocs(c).X;
            y = EEG.chanlocs(c).Y;
            EEG.chanlocs(c).radius = euclid_dist(x,y)*0.50/0.660; %TODO
        end
        
        EEG = eeg_checkset( EEG );

        
        EEG = pop_saveset( EEG, 'filename',name_wo_mat,'filepath',saving_path); % Save the data
    end
end


function bool = isMat(str)
    % returns if str ends with .mat (if it contains .mat to be precise)
    bool =not(isempty(strfind(str,'.mat')));
end

    
function dist = euclid_dist(x,y)
    dist = sqrt(x^2+y^2);
end

