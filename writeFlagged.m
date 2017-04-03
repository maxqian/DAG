function  writeFlagged  (params, fileSkip)
sErr                        = [];
try 
    if (params.bLinux == 1)
        sFNOutFlag = [params.sWkDir, 'flaggedFiles/flaggedFiles.txt'];
    end
    if (params.bLinux == 0)
        sFNOutFlag = [params.sWkDir, 'flaggedFiles\flaggedFiles.txt'];
    end

    fid = fopen(sFNOutFlag, 'w'); 
    fprintf (fid, '%s\t%s\n', 'File Name', 'Flag');

    for j = 1:size(fileSkip,2)
        fprintf (fid, '%s\t%s\n', fileSkip{j}(1:end-4), 'File skipped because no cells found within gate'); 
    end
    
    
    sDir = params.sDirStatData;
    
    if exist(sDir,'dir') == 7 
        sFileExtension = '-stat.txt';
        iLenFileExt = length(sFileExtension);

        j = 0;
        tDir = dir(sDir);
        for i = 1:length(tDir);
            iNBytes = tDir(i).bytes;
            sFilename = tDir(i).name;
            if (iNBytes > 100)
                if strcmp(sFilename(end-iLenFileExt+1:end), sFileExtension)
                    j = j + 1;
                if (params.bLinux == 1)
                    vsFileList{j} = [sDir sFilename]; 
                end
                if (params.bLinux == 0)
                    vsFileList{j} = [sDir sFilename];
                end
                end
            end
        end
        
        if ~isempty(vsFileList)
            for i = 1:length(vsFileList);    
                mStat= tdfread(vsFileList{i}, '\t');
                QC = false;
                cutoff_ind = find(~cellfun(@isempty, params.cutOff));
                for j=1:length(cutoff_ind)
                    pop_ind = strmatch(params.cPopName{cutoff_ind(j)}, mStat.PopName);
                    if mStat.PercentParent(pop_ind)/100 < str2num(params.cutOff{cutoff_ind(j)})
                        QC = true;
                    end                    
                end

                if (params.bLinux == 1)
                    fileName_tmp = regexp(vsFileList{i}, '/', 'split');
                    fileName = fileName_tmp(end);
                end
                if (params.bLinux == 0)
                    fileName_tmp = regexp(vsFileList{i}, '\', 'split');
                    fileName = fileName_tmp(end);
                end

                if QC == true
                    fprintf (fid, '%s\t%s\n', fileName{1}(1:end-9), 'Population percentage below specified threshold'); 
                end
            end
        end
    end
    
    fclose(fid);

catch
  sErr                      = 'Error: writing flagged files';
end