function [sErr, m2DHist, m2DHistS, mXYBins, vXA, vYA] = dag_41_get2DHist(j, params, mNorm, vIParentPopRows)

sErr                          = [];
try
  iNHistBins                  = params.iNHistBins;      % 200 (dag_20)                                                                                               
  vFiltLenTmp                 = params.vFiltLenTmp;     % 20 (dag_20)
  iIntensityMax               = params.iIntensityMax;   % varies (dag_30)
  
  vFiltX                      = sin(pi/vFiltLenTmp:pi/vFiltLenTmp:pi-pi/vFiltLenTmp);   % 20 data points ranging from 0-1.  Plot looks like the positive part of the sine curve  
  vFiltY                      = sin(pi/vFiltLenTmp:pi/vFiltLenTmp:pi-pi/vFiltLenTmp);   % 20 data points ranging from 0-1.  Plot looks like the positive part of the sine curve 
  mConvFilter                 = vFiltX'*vFiltY ;                                        % 20 different positive sine curves with different steepness
  
  if strcmpi(params.cColHdrs(params.vIMkrX(j)), 'Time') 
      vX                          = (mNorm(vIParentPopRows, params.vIMkrX(j))/max(mNorm(:,params.vIMkrX(j)))*iNHistBins);  
      vY                          = (mNorm(vIParentPopRows, params.vIMkrY(j))  / iIntensityMax) *iNHistBins  ;
      vXA                         = (mNorm(:,               params.vIMkrX(j))/max(mNorm(:,params.vIMkrX(j)))*iNHistBins); 
      vYA                         = (mNorm(:,               params.vIMkrY(j))  / iIntensityMax) *iNHistBins  ;
  elseif strcmpi(params.cColHdrs(params.vIMkrY(j)), 'Time') 
      vX                          = (mNorm(vIParentPopRows, params.vIMkrX(j))/ iIntensityMax) *iNHistBins;  
      vY                          = (mNorm(vIParentPopRows, params.vIMkrY(j))/max(mNorm(:,params.vIMkrX(j)))*iNHistBins);
      vXA                         = (mNorm(:,               params.vIMkrX(j))/ iIntensityMax) *iNHistBins; 
      vYA                         = (mNorm(:,               params.vIMkrY(j))/max(mNorm(:,params.vIMkrX(j)))*iNHistBins);
  else
      vX                          = (mNorm(vIParentPopRows, params.vIMkrX(j))  / iIntensityMax) *iNHistBins  ;      % Normalize only selected cell intensity values
      vY                          = (mNorm(vIParentPopRows, params.vIMkrY(j))  / iIntensityMax) *iNHistBins  ;
      vXA                         = (mNorm(:,               params.vIMkrX(j))  / iIntensityMax) *iNHistBins  ;      % Normalize all cell intensity values
      vYA                         = (mNorm(:,               params.vIMkrY(j))  / iIntensityMax) *iNHistBins  ;
  end
  
  vXA                         = ((vXA>=1).*vXA) + (vXA<1);                                  % If vXA >= 1 then return vXA, if vXA<1 then return 1.
  vYA                         = ((vYA>=1).*vYA) + (vYA<1);
    
  mXYBins                     = floor([vY  vX]);                                            % mXYBins is the normalized intensity values of selected cells rounded to the lowest integer
                                                                                            % mXYBins = 2 column matrix with floor values of vX, vY
                                                                                            % Note Y X order
  
  mXYBins                     = ((mXYBins>0).*mXYBins) + (mXYBins==0);                      % mXYBins are the subscripts into the m2DHist, so we prevent a 0 subscript
                                                                                            % If mXYBins positive then return mXYBins, if mXYBins is 0 then return 1.
  m2DHist                     = accumarray(mXYBins,1,[iNHistBins iNHistBins]);              % construct array counting the number of times that mXYBin values appear (histogram of intensity)

                                                                                  
  m2DHistS                    = conv2(m2DHist, mConvFilter, 'same');                        % Convolute data with sine filter
  m2DHistS                    = m2DHistS/max(m2DHistS(:));
  iDebug                      = 1;
  
catch e
  sErr                        = 'Error: creating histogram'; 
  disp(e)
  e.throw
end
