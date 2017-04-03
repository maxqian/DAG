function [sErr, mNorm, mID, params] = dag_42_includePops_bisect  (j, params, mNorm, mID,m2DHist, m2DHistS, mXYBins, vXA, vYA, vIParentPopRows)

sErr                                              = [];
try
  if                                              ~ isempty(vIParentPopRows)
    vIPopsIn                                      = find(params.vIPlotPop==j);   
    iNPopsToInclude                               = length(vIPopsIn);   
    vContourLevels                                = params.vContourLevels;     
    for                                        ii = 1:iNPopsToInclude    
      vMinX(ii)                                   = params.mPopMinX(vIPopsIn(ii));                                  % Gating specified by user in config file
      vMaxX(ii)                                   = params.mPopMaxX(vIPopsIn(ii));
      vMinY(ii)                                   = params.mPopMinY(vIPopsIn(ii));
      vMaxY(ii)                                   = params.mPopMaxY(vIPopsIn(ii));
    end
    vPopNCells                                    = zeros(iNPopsToInclude,1);   
    mPopBlob                                      = zeros(params.iNHistBins,params.iNHistBins,iNPopsToInclude);     % 200 x 200 x 1 array
    for                                         k = 1:length(vContourLevels)                                        % For each contour level
      m2DHistThres                                = m2DHistS > vContourLevels(k);                                   % Select data points that exceed contour level AND are to the right of the intersecting x gate = object
      [row,col]                                   = find(m2DHistThres);
      indCell                                     = col < vMinX(1);
%       for i=1:length(row)                                                                                         % Diagonal boundary
%           if 1.7*col(i) - 90 < row(i)
%               m2DHistThres(row(i),col(i)) = 0;
%           end
%       end
      m2DHistThres(row(indCell),col(indCell))     = 0;
      [mBWLabel,iNBlobs]                          = bwlabel(m2DHistThres,4);                                        % Blob = At least 4 connected objects
                                                                                                                    % Blob = High density areas
      stats                                       = regionprops(mBWLabel, 'area', 'centroid', 'boundingbox', 'extrema');
      
      if ~isempty(mBWLabel) 
          for                                       l = 1:iNBlobs                                                   % Loop through each blob and find centroid and draw box around it
            mBlobToBeEval                             = double(mBWLabel==l);                                        % note:  mBlob is logical (either 0 or 1)
            iNewBlobNCells                            = sum(sum(m2DHist.*mBlobToBeEval));
            iNewBlobCentX                             = round(stats(l).Centroid(1));
            iNewBlobCentY                             = round(stats(l).Centroid(2)); 
            iNewBlobBBoxMinX                          = round(stats(l).BoundingBox(1));  
            iNewBlobBBoxMaxX                          = round(stats(l).BoundingBox(1) + stats(l).BoundingBox(3));  
            iNewBlobBBoxMinY                          = round(stats(l).BoundingBox(2));  
            iNewBlobBBoxMaxY                          = round(stats(l).BoundingBox(2) + stats(l).BoundingBox(4));  
            iNewBlobBArea                             = round(stats(l).Area);
            if j==3
              iDebug=1;
            end

            for                                     m = 1:iNPopsToInclude                                           % For each blob, determine if blob is within the range specified by config file
              %if ((vMinX(m) <= iNewBlobBBoxMinX) && (iNewBlobBBoxMaxX  <= vMaxX(m))) && ((vMinY(m) <= iNewBlobBBoxMinY) && (iNewBlobBBoxMaxY  <= vMaxY(m)))
              if ((iNewBlobBBoxMaxX  <= vMaxX(m))) && ((vMinY(m) <= iNewBlobBBoxMinY) && (iNewBlobBBoxMaxY  <= vMaxY(m)))
                  mPopBlob(:,:,m)                       = mPopBlob(:,:,m) + mBlobToBeEval;
                  vPopNCells(m)                         = iNewBlobNCells;
                  vPopBBoxMinX(m)                       = iNewBlobBBoxMinX;
                  vPopBBoxMaxX(m)                       = iNewBlobBBoxMaxX;
                  vPopBBoxMinY(m)                       = iNewBlobBBoxMinY;
                  vPopBBoxMaxY(m)                       = iNewBlobBBoxMaxY;
                  vPopArea(m)                           = iNewBlobBArea;
                  params.vResolveThres(vIPopsIn(m))     = vContourLevels(k);
              else
                iDebug=1;
              end

            end
        end
      end
    end
    vX                                            = floor(vXA(vIParentPopRows));
    vY                                            = floor(vYA(vIParentPopRows));

    for                                         m = 1:iNPopsToInclude                             % For those Blobs included, update mID to mark events within Blob
      mPopMemb                                    = mPopBlob(:,:,m);
      vI2                                         = sub2ind(size(mPopMemb), vY, vX);              % create 1D index into 2D matrix, note YX = rowCol order
      vPop                                        = (mPopMemb(vI2)>=0.5);
      vIPop                                       = find(vPop==1);
      mID(vIParentPopRows(vIPop),vIPopsIn(m))     = 1;
      vITmp                                       = find(mID(:,vIPopsIn(m))==1);
      iNEventsInPop                               = length(vITmp);
      iDebug=1;
    end
    iDebug=1;
  end
catch e
    sErr                        = 'Error: filter function'; 
    disp(e)
    e.throw
end
  
