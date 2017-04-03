function   [sErr, params] = Copy_of_dag_20_parseParams(cCSV, sFNInputData)

sErr                                        = [];
try
    iNFiles                                   = 1;                                                  % placeholder - will be augmented with zip file logic  
    for i = 1:size(cCSV,2)
        sStr = strtrim(cCSV{1,i});
        if (strcmp(sStr, 'MarkerX') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cMkrDyePlotX{j-1} = strtrim(cCSV{j,2});
                end
            end
        end
        if (strcmp(sStr, 'MarkerY') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cMkrDyePlotY{j-1} = strtrim(cCSV{j,3});
                end
            end
        end
        if (strcmp(sStr, 'Parent Population Name') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cParent{j-1} = strtrim(cCSV{j,4});
                end
            end
        end
        if (strcmp(sStr, 'Child Population Name') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cPopName{j-1} = strtrim(cCSV{j,5});
                end
            end
        end
        if (strcmp(sStr, 'Percent Threshold') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cutOff{j-1} = strtrim(cCSV{j,6});
                end
            end
        end
        if (strcmp(sStr, 'color') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cPopColor{j-1} = strtrim(cCSV{j,7});
                end
            end
        end
        if (strcmp(sStr, 'MinX') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.mPopMinX(j-1) = str2num(strtrim(cCSV{j,8}));
                end
            end
        end
        if (strcmp(sStr, 'MaxX') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.mPopMaxX(j-1) = str2num(strtrim(cCSV{j,9}));
                end
            end
        end
        if (strcmp(sStr, 'MinY') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.mPopMinY(j-1) = str2num(strtrim(cCSV{j,10}));
                end
            end
        end
        if (strcmp(sStr, 'MaxY') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.mPopMaxY(j-1) = str2num(strtrim(cCSV{j,11}));
                end
            end
        end
        if (strcmp(sStr, 'Output Channel') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cOutputChannel{j-1} = strtrim(cCSV{j,12});
                end
            end
        end
        if (strcmp(sStr, 'Channel to Return') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.cChannelToReturn{j-1} = strtrim(cCSV{j,13});
                end
            end
        end
        if (strcmp(sStr, 'Create Graphic PNGs') == 1); 
            for j = 2:size(cCSV,1)
                if ~isempty(strtrim(cCSV{j,i}))
                    params.bCreateGraphicPNGs = str2num(strtrim(cCSV{j,14}));
                end
            end
        end
        
    end
    
    last = params.cParent(length(params.cParent));
    if sum(strcmpi(last, params.cParent)) > 1
       ind = find(strcmpi(last, params.cParent));
       for i=1:length(ind)
           params.cOutputPop{i} = cCSV{ind(i)+1,5};
       end
    else
       params.cOutputPop{1}                      =cCSV{length(params.cParent)+ 1,5}; 
    end
    
    iNPops                                    = length(params.cMkrDyePlotX);
    params.vIPlotPop                          = linspace(1,iNPops,iNPops);
    params.iNPlots                            = iNPops;
    params.iNPops                             = iNPops;
    params.vResolveThres                      = ones(iNPops, 1) * 0.9;
    params.iNHistBins                         = 200;                                                        % just to keep parameter passing a bit easier as these params are very stable
    params.vFiltLenTmp                        = 20;  

    params.vContourLevels                     = [.9:-.05:.15     .1:-.005:.015  .01:-.0005:.001];          % Add additional contour levels to include more data points   
    %params.vContourLevels                     = [.9:-.0001:.15     .1:-.0001:.015  .01:-.0001:.001];
    params.vContourLevelsDsp                  = [.9:-.10:.15     .1:-.010:.015  .01:-.0010:.001];    

    params.dAxisBkgdColor                     = 0.6;
    iNPopColorRows                            = size(params.cPopColor,1);
    iNPopColorCols                            = size(params.cPopColor,2);
    params.mColor                             = zeros(params.iNPops,3);
    for                                     j = 1:params.iNPops
      if                                        (strcmp(params.cPopColor{j}, 'darkGray')); params.mColor(j,1:3)= [ 0.3 0.3 0.3]; end
      if                                        (strcmp(params.cPopColor{j}, 'medGray'));  params.mColor(j,1:3)= [ 0.5 0.5 0.5]; end
      if                                        (strcmp(params.cPopColor{j}, 'red'));      params.mColor(j,1:3)= [ 1.0 0.0 0.0]; end
      if                                        (strcmp(params.cPopColor{j}, 'green'));    params.mColor(j,1:3)= [ 0.0 1.0 0.0]; end
      if                                        (strcmp(params.cPopColor{j}, 'blue'));     params.mColor(j,1:3)= [ 0.0 0.0 1.0]; end
      if                                        (strcmp(params.cPopColor{j}, 'yellow'));   params.mColor(j,1:3)= [ 1.0 1.0 0.0]; end
      if                                        (strcmp(params.cPopColor{j}, 'cyan'));     params.mColor(j,1:3)= [ 0.0 1.0 1.0]; end
      if                                        (strcmp(params.cPopColor{j}, 'magenta'));  params.mColor(j,1:3)= [ 1.0 0.0 1.0]; end
      if                                        (strcmp(params.cPopColor{j}, 'orange'));   params.mColor(j,1:3)= [ 1.0 0.7 0.1]; end
      if                                        (strcmp(params.cPopColor{j}, 'black'));    params.mColor(j,1:3)= [ 0.0 0.0 0.0]; end
      if                                        (strcmp(params.cPopColor{j}, 'white'));    params.mColor(j,1:3)= [ 1.0 1.0 1.0]; end 
    end

    params.bLinux                             = 1;    
    params.sFNInputData                       = sFNInputData;
    vI                                        = strfind(sFNInputData, '/');
    if                                        ~ isempty(vI)
      params.bLinux                           = 1;    
      params.sWkDir                           = sFNInputData(1:vI(end));
      if                                        length(sFNInputData) > (vI(end)+1)
        params.sFNFCS                         = sFNInputData(vI(end)+1:end);
      end
    end
    vI                                        = strfind(sFNInputData, '\');
    if                                        ~ isempty(vI)
      params.bLinux                           = 0;
      params.sWkDir                           = sFNInputData(1:vI(end));
      if                                        length(sFNInputData) > (vI(end)+1)
        params.sFNFCS                         = sFNInputData(vI(end)+1:end);
      end
    end

    iNOutPop                              = 0;
    for                                 j = 1:length(params.cOutputPop) 
      for                               k = 1:params.iNPops
        if                                  (strcmpi(params.cOutputPop{j}, params.cPopName{k}))
          iNOutPop                        = iNOutPop+1;
          params.vIMIDOut(iNOutPop)       = k;
        end
      end
    end


    params.vIMIDParent                    = 0;
    for                                 j = 1:params.iNPlots
      for                               k = 1:params.iNPops
        if                                  (strcmpi(params.cParent{j}, params.cPopName{k}))
          iNPopsInThisPlot                = length(find(params.vIPlotPop==j));
          for                           l = 1:iNPopsInThisPlot
            params.vIMIDParent            = [params.vIMIDParent k];
          end
        end
      end
    end


catch e
    sErr                                      = 'Error: parsing filter params';
    disp(e)
    e.throw
end 

  
  
  
  
  