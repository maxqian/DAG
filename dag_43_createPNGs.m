function sErr = dag_43_createPNGs(j, params, mNorm, mID, m2DHistS, vXA, vYA, vIParentPopRows)
sErr                          = [];
try
  vIPopsIn                                      = find(params.vIPlotPop==j);    
  iNPopsToInclude                               = length(vIPopsIn);
  vContourLevels                                = params.vContourLevels;    
  for                                        ii = 1:iNPopsToInclude
    vMinX(ii)                                   = params.mPopMinX(vIPopsIn(ii));
    vMaxX(ii)                                   = params.mPopMaxX(vIPopsIn(ii));
    vMinY(ii)                                   = params.mPopMinY(vIPopsIn(ii));
    vMaxY(ii)                                   = params.mPopMaxY(vIPopsIn(ii));
  end
  
  
  dMarkerSizePop                  = 1;
  iNHistBins                      = params.iNHistBins ; 
  dTextOffFNX                     =  0.05;
  dTextOffX1                      =  0.755;
  dTextOffX2                      =  0.45;
  dTextOffY                       =  0.95;
  dTextStrideY                    = -0.08;
  
  sMkrNameX                       = params.sMkrPlotLabelX{j};
  sMkrNameY                       = params.sMkrPlotLabelY{j};
  vContourLevelsDsp               = params.vContourLevelsDsp;    
 
  
  iNParents                       = length(vIParentPopRows);
  
  vIPopsToPlot                    = find(params.vIPlotPop==j);    
  iNPopsToPlot                    = length(vIPopsToPlot);  
  
  if (iNParents>0)
    vX                              = vXA(vIParentPopRows);
    vY                              = vYA(vIParentPopRows);
    hFig                            = figure('position', [200 200 400 400],'visible','off');                            % Turn on/off pop up window displaying dot plot
    % plot                              (vX ,vY, '.', 'color', [0.0  0.0 0.0], 'MarkerSize', dMarkerSizePop);           % Turn on/off displaying all dots        
    axis([0 iNHistBins 0 iNHistBins]); hold on; grid on;
    for                           k = 1:iNPopsToPlot
      iIPop                         = vIPopsToPlot(k);
      vIRows                        = find(mID(:,iIPop)== 1);                                                           % find(mNorm(:,end)==iIPop);
      iNPopRows                     = length(vIRows);
      plot                            (vXA(vIRows), vYA(vIRows), '.', 'color', params.mColor(iIPop,:), 'MarkerSize', dMarkerSizePop);
      dPopPercent                   = round((10000*iNPopRows)/iNParents) / 100;
      
      % Change Fontsize = 6 when using colorbar for each figure
      
      text                            (iNHistBins*dTextOffX1, iNHistBins*(dTextOffY+(dTextStrideY*k)), [num2str(iNPopRows) ',  ' num2str(dPopPercent) '%'], 'FontSize', 8);
      text                            (iNHistBins*dTextOffX2, iNHistBins*(dTextOffY+(dTextStrideY*k)+(-0.08)), params.cPopName{iIPop}, 'FontSize', 6);
      if ~strcmpi(sMkrNameX, 'Time') && ~strcmpi(sMkrNameY, 'Time')
          vContourLevelsDsp             = unique(sort([vContourLevelsDsp    params.vResolveThres(iIPop)], 'descend'));
          contour(m2DHistS, vContourLevelsDsp);
          c = colorbar;
      end
      
%       if strcmpi(sMkrNameX, 'FSC-A') && strcmpi(sMkrNameY, 'SSC-A')                                                                                % Plot diagonal boundary
%           x = linspace(0,iNHistBins);
%           plot                          (x, 1.7*x-90,         'linestyle', '--',  'color', params.mColor(iIPop,:));
%       else
%           plot                          ([vMinX(k) vMinX(k)], [0 iNHistBins],         'linestyle', '--',  'color', params.mColor(iIPop,:));
%       end
      plot                          ([vMinX(k) vMinX(k)], [vMinY(k) vMaxY(k)],         'linestyle', '--',  'color', params.mColor(iIPop,:));
      plot                          ([vMaxX(k) vMaxX(k)], [vMinY(k) vMaxY(k)],         'linestyle', '--',  'color', params.mColor(iIPop,:));
      plot                          ([vMinX(k) vMaxX(k)], [vMinY(k) vMinY(k)],          'linestyle', '--',  'color', params.mColor(iIPop,:));
      plot                          ([vMinX(k) vMaxX(k)], [vMaxY(k) vMaxY(k)],          'linestyle', '--',  'color', params.mColor(iIPop,:));
      iDebug=1;
    end
  else
    plot                              (0,0,'.k');
  end    
  text                                (iNHistBins*dTextOffX1, iNHistBins*dTextOffY, num2str(iNParents), 'FontSize', 6);
  sFNOrig                           = params.sFNFCS;
  vIUscore                          = strfind(sFNOrig, '_');
  sFNDisplay                        = sFNOrig;
  sFNDisplay(vIUscore)              = ' ';  
  text                                (iNHistBins*dTextOffFNX, iNHistBins*dTextOffY,                    sFNDisplay,                   'FontSize', 8);
  text                                (iNHistBins*dTextOffFNX, iNHistBins*(dTextOffY+(dTextStrideY*1)), [sMkrNameX ' vs ' sMkrNameY], 'FontSize', 8, 'interpreter', 'none');
    
  
  [s,mess,messid]                   = mkdir(params.sWkDir,'filteredPlots');  
  if                                  (s==1) && (params.bLinux==1); 
    params.sDirPlotData             = [params.sWkDir  'filteredPlots/'];  
  end
  if                                  (s==1) && (params.bLinux==0); 
    params.sDirPlotData             = [params.sWkDir  'filteredPlots\'];  
  end
  sFNOutImage                       = [params.sDirPlotData params.sFNFCS(1:end-4) '-filt-' num2str(j) '.png'];
    
  set                                 (gca, 'XTickLabel',[], 'YTickLabel', [], 'color', [params.dAxisBkgdColor params.dAxisBkgdColor params.dAxisBkgdColor]);
  set                                 (gca, 'units', 'normalized', 'Position', [0.0 0.0 1.0 1.0]);
  %set                                 (gca, 'units', 'normalized')                                  % Turn on/off if need to display colorbar on each individual figure
  set                                 (hFig, 'PaperPositionMode', 'auto');
  set                                 (hFig, 'InvertHardcopy', 'off');                              % keep bkgd color http://www.mathworks.com/matlabcentral/newsreader/view_thread/241209
  print                               (hFig, '-zbuffer', '-dpng', sFNOutImage);                     %  prior line was: saveas(gcf, sFNOutImage);  however, no openGL on gordon
  close                               (gcf);
catch e
  sErr                              = 'Error: creating PNGs';
  disp(e)
  e.throw
end