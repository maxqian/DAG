function [sErr, cCSV] = dag_10_csvReadIntoCellArray( sFNProcParams )
sErr                        = [];
try
  iILine                    = 0;
  fid                       = fopen(sFNProcParams);
  sTextLine                 = fgetl(fid);
  while                       ischar(sTextLine)
    iILine                  = iILine+1;
    vI                      = strfind(sTextLine, ',');
    iNC                     = length(vI);               % iNumCommas
    if                        (iNC == 0)
      cCSV{iILine, 1}       = sTextLine;
    end
    
    if                        (iNC == 1)
      cCSV{iILine, 1}       = sTextLine(1         : vI(1)-1);
      cCSV{iILine, 2}       = sTextLine(vI(1)+1   : end);
    end
    
    if                        (iNC >= 2)
      cCSV{iILine, 1}       = sTextLine(1         : vI(1)-1);
      for                 i = 1:iNC-1
        cCSV{iILine,i+1}    = sTextLine(vI(i)+1   : vI(i+1)-1);
      end
      cCSV{iILine,iNC+1}    = sTextLine(vI(iNC)+1 : end);
    end
    sTextLine               = fgetl(fid);
  end 
catch e
  sErr                      = 'Error: reading filter params';
  disp(e)
  e.throw
end 
  
  