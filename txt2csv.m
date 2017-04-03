clear all; close all; clc;

%READ ME: Read in raw txt fcs data file and convert to csv file

tStart1 = tic;   


% Import FCS txt data files
% data_root_path = 'J:\Informatics\MQian\Denmark_CCIT\Lab106\lab106_TXTfiles_out\';
% dir_name = 'J:\Informatics\MQian\Denmark_CCIT\Lab106\lab106_TXTfiles_out\*.txt';
data_root_path = 'J:\Informatics\MQian\CompositeAMLvsNormal\Normal\Panel_6\';
dir_name = 'J:\Informatics\MQian\CompositeAMLvsNormal\Normal\Panel_6\*.txt';
data_dir = dir(dir_name);

disp(['Reading files from directory: ', dir_name])


file_num = 1;
for file_ind = 1:length(data_dir)
    disp(['Reading file No. ', num2str(file_num)])
    data_file_name = data_dir(file_ind).name;
    data_file = strcat(data_root_path, data_file_name);
    data_struct = importdata(data_file, '\t');
    
    data_all = data_struct.data(:, :);
    
    header_all = cell(data_struct.colheaders); 
    
    % Export data ino .csv file
    fid = fopen(strcat(data_root_path, data_file_name(1:end-4),'.csv'), 'wt');
    fprintf(fid,'%s,', header_all{1:end});
    fclose(fid);
    dlmwrite(strcat(data_root_path, data_file_name(1:end-4),'.csv'), data_all, 'roffset',1,'-append');
    file_num = file_num + 1;

end

tElapsed = toc(tStart1)