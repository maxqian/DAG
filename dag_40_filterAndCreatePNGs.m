function   [sErr, mNorm, mID, iNRowsOut] = dag_40_filterAndCreatePNGs(params, mNorm, mID)
  sErr                                                              = [];
  iNRowsOut                                                         = 0;
  try
    for                                                           j = 1:params.iNPlots                                      % Loop through the number of child populations
      if                                                              (params.vIMkrX(j) > 0) && (params.vIMkrY(j) > 0)      % If the markers for child populations match the marker in the input data
          if                                                              (j==1);                                             % For the first population 
          vIParentPopRows                                             = find(mID(:,1)== 0);                                 % Return indices within lymph pop col of mID with 0 value
                                                                                                                            % All cells have 0 at this point
        
        else
          vIParentPopRows                                             = find((mID(:,params.vIMIDParent(j))==1)); end;   
        
        if                                                            ~ isempty(vIParentPopRows)
          if (isempty(sErr)); 
              [sErr, m2DHist, m2DHistS, mXYBins, vXA, vYA]     = dag_41_get2DHist   (j, params, mNorm, vIParentPopRows); 
          end
          if (strcmpi(params.cColHdrs(params.vIMkrX(j)), 'Time')) || (strcmpi(params.cColHdrs(params.vIMkrY(j)), 'Time'))                 
              if (isempty(sErr)); 
                  [sErr, mNorm, mID, params]              = dag_42_includePops_strictBound (j, params, mNorm, mID, m2DHist, m2DHistS, vXA, vYA, vIParentPopRows);
              end   
          elseif (strcmpi(params.cColHdrs(params.vIMkrX(j)), 'FSC-A') && strcmpi(params.cColHdrs(params.vIMkrY(j)), 'SSC-A'))                                           
              if (isempty(sErr)); 
                  [sErr, mNorm, mID, params]              = dag_42_includePops_bisect (j, params, mNorm, mID, m2DHist, m2DHistS, mXYBins, vXA, vYA, vIParentPopRows);
              end
          else
              if (isempty(sErr)); 
                  [sErr, mNorm, mID, params]              = dag_42_includePops (j, params, mNorm, mID, m2DHist, m2DHistS, vXA, vYA, vIParentPopRows);
              end
          end
        else
            sErr = 'Error: No cells found within gate - skip file';
        end
        
        if  ((params.bCreateGraphicPNGs==1)&&(isempty(sErr))); sErr   = dag_43_createPNGs  (j, params, mNorm, mID, m2DHistS, vXA, vYA, vIParentPopRows); end
        iDebug=1;
      end
          
    end
    vI                                                              = [];  for j=1:length(params.vIMIDOut);  vI=[vI; find(mID(:,params.vIMIDOut(j))== 1);];  end;  
    iNRowsOut                                                       = length(unique(vI));
  catch e
    sErr                                                            = 'Error: filtering and creating PNGs';
    disp(e)
    e.throw
  end
