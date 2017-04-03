function [sErr, mNorm, mID, params] = dag_42_includePops_ManualAdjust  (j, params, mNorm, mID,m2DHist, m2DHistS, vXA, vYA, vIParentPopRows)

sErr                                              = [];
try
  if                                              ~ isempty(vIParentPopRows)
    vIPopsIn                                      = find(params.vIPlotPop==j);    
    iNPopsToInclude                               = length(vIPopsIn);   
    vContourLevels                                = params.vContourLevels;    
    for                                        ii = 1:iNPopsToInclude    
      vMinX(ii)                                   = params.mPopMinX(vIPopsIn(ii));  
      vMaxX(ii)                                   = params.mPopMaxX(vIPopsIn(ii));
      vMinY(ii)                                   = params.mPopMinY(vIPopsIn(ii));
      vMaxY(ii)                                   = params.mPopMaxY(vIPopsIn(ii));
    end
    vPopNCells                                    = zeros(iNPopsToInclude,1);   
    mPopBlob                                      = zeros(params.iNHistBins,params.iNHistBins,iNPopsToInclude);  
   
    vXY = zeros(size(mNorm,1), 2);
    for i=1:length(vIParentPopRows)
        if (vMinX(1) <= vXA(vIParentPopRows(i))) && (vXA(vIParentPopRows(i)) <= vMaxX(1));
            vXY(vIParentPopRows(i),1) = 1;
        end
        if(vMinY(1) <= vYA(vIParentPopRows(i))) && (vYA(vIParentPopRows(i)) <= vMaxY(1));
            vXY(vIParentPopRows(i),2) = 1;
        end
    end
    
    vXY_sum = sum(vXY, 2);
    iXY = find(vXY_sum == 2);
    mID(iXY,vIPopsIn(1))= 1;
    vITmp = find(mID(:,vIPopsIn(1))==1);
    iNEventsInPop = length(vITmp);
    

    iDebug = 1;
    end


catch e
    sErr                        = 'Error: filter function'; 
    disp(e)
    e.throw
end
  
