clear all; close all; clc;
%function test(config_file, data_file)

%disp(config_file)
%disp(data_file)

config_file = 'C:\Users\alee\Documents\RRPC Data Management\dag_Alex\Sample_data\Config\config_101.csv';
data_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\Sample_data\Data_101\R1-518-EBV.csv';
% config_file = 'J:\Informatics\MQian\HIPC_LIAI\config_Cecilia.csv';
% data_file = 'J:\Informatics\MQian\HIPC_LIAI\Cecilia_CSV\Specimen_001_TU22.csv';
% data_file = 'J:\Informatics\MQian\Denmark_CCIT\Lab106\lab106_TXTfiles_out\Outlier\R1-519-NEG.csv';
% config_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\TestBiexponential\Config\config_SEB.csv';
% data_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\TestBiexponential\Data\RPRC0530001_19_SEB_G03_w-511_f-1111.csv';
% config_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\RPRC Test\Config\config_SEB.csv';
% data_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\RPRC Test\Data\RPRC0530001_19_SEB_G03.csv';
% config_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\Denmark_CCIT\Config\config_102.csv';
% data_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\Denmark_CCIT\Data_Lab102\Lab ID 102_R1-518-EBV.csv';
% config_file = 'C:\Users\alee\Documents\RPRC Data Management\dag_Alex\Denmark_CCIT\Config\config_224_strict.csv';
% data_file = 'J:\Informatics\MQian\Denmark_CCIT\NewCCIT_MultimerData_05May2015\TXT\102_out\Lab ID 102_R1-518-EBV.csv';
numCol = 2;

tStart1 = tic; 
sErr = [];
  iNRowsOut = 0;
  if  (isempty(sErr)); 
      [sErr, cCSV] = dag_10_csvReadIntoCellArray(config_file);                          % 'err reading filter params' 
  end            
%   if  (isempty(sErr)); 
%       [sErr, params] = dag_20_parseParams(cCSV, data_file);                              % 'err parsing filter params'
%   end                  
%   if  (isempty(sErr)); 
%       [sErr, mNorm, mID, params] = dag_30_importData(params);                               % 'err importing data'
%   end                                
%   if  (isempty(sErr)); 
%       [sErr, mNorm, mID, iNRowsOut] = dag_40_filterAndCreatePNGs(params, mNorm, mID);       % 'err filterAndCreatePNGs'
%   end           
%   if  ((isempty(sErr))&&(iNRowsOut>0));                    
%       sErr = dag_50_writeFilteredData(params, mNorm, mID);                                  % 'err write data'
%   end           
%   if  (isempty(sErr));                            
%       [sErr, params] = dag_60_writeStats(params, mNorm, mID); 
%   end    
%   
%   if  (isempty(sErr));                    
%     sErr = 'success';
%     fprintf (1,'%s\n', ['NCellsIn: ' num2str(size(mNorm,1)) ', NCellsOut: ' num2str(iNRowsOut)]);
%     fprintf (2,'%s\n', sErr);  
%   else
%     fprintf (1,'%s\n', sErr);
%     fprintf (2,'%s\n', sErr); 
%   end

tElapsed = toc(tStart1)

% dataDirPath = 'J:\Informatics\MQian\Denmark_CCIT\NewCCIT_MultimerData_05May2015\TXT\128_out\';
% mkdir(dataDirPath, 'filteredPlotsComposites')
% filteredInputPath = strcat(dataDirPath, '\filteredPlots');
% filteredCompPath = strcat(dataDirPath, '\filteredPlotsComposites\'); 
% numCol = 1;
% 
% uCreateCompImage(filteredInputPath, strcat(filteredCompPath,'comp_FSC-A_SSC-A.png'),  numCol, '-filt-1.png');
% uCreateCompImage(filteredInputPath, strcat(filteredCompPath,'comp_SSC-A_LiveDead.png'),  numCol, '-filt-2.png');
% uCreateCompImage(filteredInputPath, strcat(filteredCompPath,'comp_FSC-A_FSC-H.png'),  numCol, '-filt-3.png');
% uCreateCompImage(filteredInputPath, strcat(filteredCompPath,'comp_CD4_CD8.png'),  numCol, '-filt-4.png');
% uCreateCompImage(filteredInputPath, strcat(filteredCompPath,'comp_Multimer_CD8.png'),  numCol, '-filt-5.png');
%end