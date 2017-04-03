function [vsFileList] = u_getFilesFromDir(sDir, sFileExtension, params)    
  iLenFileExt                         = length(sFileExtension);
  j                                   = 0;
  tDir                                = dir(sDir);
  vsFileList = {};
  for                               i = 1:length(tDir);
      iNBytes                         = tDir(i).bytes;
      sFilename                       = tDir(i).name;
      if                                (iNBytes > 1000) && (~strcmp(tDir(i).name, 'Thumbs.db'))
        if                              strcmp(sFilename(end-iLenFileExt+1:end), sFileExtension)
          j                           = j + 1;
          if (params.bLinux == 1)
              vsFileList{j}               = [sDir '/' sFilename]; 
          end
          if (params.bLinux == 0)
              vsFileList{j}               = [sDir '\' sFilename];
          end
        end
      end
  end
  iDebug=1;
  

