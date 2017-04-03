function   [sErr, mNorm, mID, params] = dag_30_importData(params)
  sErr                                          = [];
  cColHdrs                                      = {};
  try
    sD                                    = importdata(params.sFNInputData);                  % struct of Data
%     cColHdrs                             = sD.colheaders;      
    if isfield(sD, 'colheaders')                                                              % If colheader array available  
        cColHdrs                              = strrep(sD.colheaders, '"', '');                  
    elseif ~isfield(sD, 'colheaders')
        delimiter                              = strfind(sD.textdata{1},',');                     
        ind                                    = length(delimiter);
        cColHdrs{1} = sD.textdata{1}(1   : delimiter(1)-1);
        for i=1:ind-1
            cColHdrs{i+1} = sD.textdata{1}(delimiter(i)+1   : delimiter(i+1)-1);
        end
    end
    
    mNorm                                 = sD.data;                                          % matrix of numerical Data
    clear sD;
    mID                                   = zeros(size(mNorm,1), params.iNPops);              % matrix to hold boolean pop id membership where cols coorespond to pop index col
    
    if min(mNorm(:)) < 0                                                                      % Shift mNorm values so that all are positive
        mNorm = mNorm + abs(min(mNorm(:)));                                                   % Using bi-exponential transform will generate negative values, logicle transform will not 
    end
    
    if ismember('Time', cColHdrs)                                                             % Natasja's data includes Time values so need to discard these when calculating the max intensity to normalize the data
        indTime = find(ismember(cColHdrs,'Time'));
        indColHdrs = linspace(1,size(mNorm,2), size(mNorm,2));
        indColHdrs = indColHdrs(indColHdrs~= indTime);
        mNorm_tmp = mNorm(1:end,indColHdrs);
        params.iIntensityMax                      = max(mNorm_tmp(:));      
    else
        params.iIntensityMax                      = max(mNorm(:));
    end    
    
    params.vIMkrX                         = zeros(1, length(params.cMkrDyePlotX) );
    params.vIMkrY                         = zeros(1, length(params.cMkrDyePlotX) );
    params.vIOutChn                       = zeros(1, length(params.cOutputChannel));            
    
    for                                 i = 1:length(params.cMkrDyePlotX) 
      cMkrDye                             = [];      
      sMkrDye                             = params.cMkrDyePlotX{i};
      vI                                  = strfind(sMkrDye, '|');
      iNPipe                              = length(vI);
      if                                    (iNPipe==0)
        cMkrDye{1}                        = sMkrDye;
      end
      if                                    (iNPipe==1)  
        cMkrDye{1}                        = sMkrDye(1    : vI-1);
        cMkrDye{2}                        = sMkrDye(vI+1 : end );
      end
      if                                    (iNPipe>1)  
        cMkrDye{1}                        = sMkrDye(1    : vI-1);
        for                             k = 1:iNPipe-1
          cMkrDye{k+1}                    = sMkrDye(vI(k)+1 : vI(k+1)-1);
        end
        cMkrDye{k+2}                      = sMkrDye(vI(iNPipe)+1 : end);
      end
      params.sMkrPlotLabelX{i}            = cMkrDye{1};                                         % by convention, the marker name preceeds the dye name alias
      bMatch                              = 0;
      for                               l = 1:length(cMkrDye)
        for                             m = 1:length(cColHdrs)
          if                                (strcmpi(cMkrDye{l}, cColHdrs{m} )) && (bMatch==0)
            bMatch                        = 1;
            params.vIMkrX(i)              = m;
          end
        end
      end
    end
      
    for                                 i = 1:length(params.cMkrDyePlotY) 
      cMkrDye                             = [];      
      sMkrDye                             = params.cMkrDyePlotY{i};
      vI                                  = strfind(sMkrDye, '|');
      iNPipe                              = length(vI);
      if                                    (iNPipe==0)
        cMkrDye{1}                        = sMkrDye;
      end
      if                                    (iNPipe==1)  
        cMkrDye{1}                        = sMkrDye(1    : vI-1);
        cMkrDye{2}                        = sMkrDye(vI+1 : end );
      end
      if                                    (iNPipe>1)  
        cMkrDye{1}                        = sMkrDye(1    : vI-1);
        for                             k = 1:iNPipe-1
          cMkrDye{k+1}                    = sMkrDye(vI(k)+1 : vI(k+1)-1);
        end
        cMkrDye{k+2}                      = sMkrDye(vI(iNPipe)+1 : end);
      end
      params.sMkrPlotLabelY{i}            = cMkrDye{1};
      bMatch                              = 0;
      for                               l = 1:length(cMkrDye)
        for                             m = 1:length(cColHdrs)
          if                                (strcmpi(cMkrDye{l}, cColHdrs{m})) && (bMatch==0)
            bMatch                        = 1;
            params.vIMkrY(i)              = m;
          end
        end
      end
    end

    for                                 i = 1:length(params.cOutputChannel) 
      cOutChn                             = [];      
      sOutChn                             = params.cOutputChannel{i};
      vI                                  = strfind(sOutChn, '|');
      iNPipe                              = length(vI);
      if                                    (iNPipe==0)
        cOutChn{1}                        = sOutChn;
      end
      if                                    (iNPipe==1)  
        cOutChn{1}                        = sOutChn(1    : vI-1);
        cOutChn{2}                        = sOutChn(vI+1 : end );
      end
      if                                    (iNPipe>1)  
        cOutChn{1}                        = sOutChn(1    : vI-1);
        for                             k = 1:iNPipe-1
          cOutChn{k+1}                    = sOutChn(vI(k)+1 : vI(k+1)-1);
        end
        cOutChn{k+2}                      = sOutChn(vI(iNPipe)+1 : end);
      end
      for                               l = 1:length(cColHdrs)
        for                             m = 1:length(cOutChn)
          if                                (strcmpi(strtrim(cColHdrs{l}), strtrim(cOutChn{m})))
            params.vIOutChn(i)            = l; 
          end
        end
      end
    end
    
    params.cColHdrs                       = cColHdrs;
    
    zero_vIMkrX = find(params.vIMkrX ==0);
    zero_vIMkrY = find(params.vIMkrY ==0);
    
    assert(isempty(zero_vIMkrX) && isempty(zero_vIMkrY == 0), 'Column headers do not match')
    
    iDebug=1;
      
      
    
  catch e
    sErr                                        = 'Error: importing data'; 
    disp(e)
    e.throw
  end