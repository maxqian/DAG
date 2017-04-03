function [sErr, params] = dag( sFNProcParams, sFNInputData)
  sErr = [];
  iNRowsOut = 0;
  if  (isempty(sErr)); 
      [sErr, cCSV] = dag_10_csvReadIntoCellArray( sFNProcParams );                          % 'err reading filter params' 
  end            
  if  (isempty(sErr)); 
      [sErr, params] = dag_20_parseParams(cCSV, sFNInputData);                              % 'err parsing filter params'
  end                  
  if  (isempty(sErr)); 
      [sErr, mNorm, mID, params] = dag_30_importData(params);                               % 'err importing data'
  end                                
  if  (isempty(sErr)); 
      [sErr, mNorm, mID, iNRowsOut] = dag_40_filterAndCreatePNGs(params, mNorm, mID);       % 'err filterAndCreatePNGs'
  end           
  if  ((isempty(sErr))&&(iNRowsOut>0));                    
      sErr = dag_50_writeFilteredData(params, mNorm, mID);                                  % 'err write data'
  end           
  if  (isempty(sErr));                            
      [sErr, params] = dag_60_writeStats(params, mNorm, mID); 
  end    
  
  if  (isempty(sErr));                    
    sErr = 'success';
    fprintf (1,'%s\n', ['NCellsIn: ' num2str(size(mNorm,1)) ', NCellsOut: ' num2str(iNRowsOut)]);
    fprintf (2,'%s\n', sErr);  
  else
    fprintf (1,'%s\n', sErr);
    fprintf (2,'%s\n', sErr); 
  end
end

