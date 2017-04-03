function dag_main_cmd(configFile, dataDirPath, numCol)
%% Read Me
% DAG is a filtering algorithm, which performs hierarchal gating to pull out the cell populations to input into FLOCK

tStart1 = tic;   

dataDirName = strcat(dataDirPath, '*.csv');
dataDir = dir(dataDirName);

% args
fprintf(1, '%s\n',['Reading ' num2str(length(dataDir)) ' files from directory: ' dataDirName]);
fprintf(1, '%s\n\n',['Using configuration file: ' configFile]);

iter = 1;
fileSkip = {};
for fileInd = 1:length(dataDir)
    dataFileName = dataDir(fileInd).name;
    dataFile = strcat(dataDirPath, dataFileName);
    fprintf(1, '%s\n', ['Reading File No. ' num2str(iter) ' ------- File Name: ', dataFileName]);
    [sErr,params] = dag(configFile, dataFile);
    if strcmpi(sErr, 'Error: No cells found within gate - skip file');
      fileSkip{end+1} = params.sFNFCS;
    end
    iter = iter + 1;
    
end

[s,mess,messid] = mkdir(params.sWkDir,'flaggedFiles');
writeFlagged(params, fileSkip)

mkdir(dataDirPath, 'filteredPlotsComposites')
if (params.bLinux==1);                                         
    filteredInputPath = strcat(dataDirPath, 'filteredPlots');
    filteredCompPath = strcat(dataDirPath, 'filteredPlotsComposites/'); 
    f = figure('visible','off');
    colormap jet;
    c = colorbar('eastoutside');
    caxis([1 64]);
    %set(c,'YTick',[7:7:63],'YTickLabels',{'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9'});
    set(c,'Ticks',[7:7:63],'TickLabels',{'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9'});
    children = get(f, 'children');
    set(children(2), 'visible', 'off')
    saveas(children(1),strcat(filteredCompPath, '/colorbar.png'),'png'); 
end
if (params.bLinux==0);                                       
    filteredInputPath = strcat(dataDirPath, 'filteredPlots');
    filteredCompPath = strcat(dataDirPath, 'filteredPlotsComposites\');
    f = figure('visible','off');
    colormap jet;
    c = colorbar('eastoutside');
    caxis([1 64]);
    %set(c,'YTick',[7:7:63],'YTickLabels',{'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9'});
    set(c,'Ticks',[7:7:63],'TickLabels',{'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9'});
    children = get(f, 'children');
    set(children(2), 'visible', 'off')
    saveas(children(1),strcat(filteredCompPath, '\colorbar.png'),'png'); 
end

for i = 1:length(params.cPopName);
    uCreateCompImage(filteredInputPath, strcat(filteredCompPath, 'comp_', params.cPopName{i}, '.png'),  numCol, strcat('-filt-', num2str(i), '.png'), params);
end

tElapsed = toc(tStart1)

end
