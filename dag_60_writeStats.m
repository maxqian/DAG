function  [sErr, params]  = dag_60_writeStats  (params, mNorm, mID)
sErr                        = [];
try
  [s,mess,messid]         = mkdir(params.sWkDir,'filteredStats');  
  if                        (s==1) && (params.bLinux==1); 
    params.sDirStatData   = [params.sWkDir  'filteredStats/'];  
  end
  if                        (s==1) && (params.bLinux==0); 
    params.sDirStatData   = [params.sWkDir  'filteredStats\'];  
  end
  params.sFNOutStat1        = [params.sDirStatData params.sFNFCS(1:end-4) '-stat.txt'];
 
  fid                       = fopen(params.sFNOutStat1, 'w'); 
  fprintf                     (fid, '%s\t%s\t%s\t%s\t%s\n', 'NCellsTotal', 'PopName', 'NCellsParent', 'NCellsPop', 'PercentParent'); 
  sNCellsTotal              = num2str(size(mNorm,1));
  for                     j = 1:params.iNPops
        sPopName            = params.cPopName{j};
        iNCellsPop          = length(find(mID(:,j) > 0));       sNCellsPop=num2str(iNCellsPop);
        if                    (j==1); 
          iNCellsPar        = size(mID,1); 
        else
          iNCellsPar        = length(find(mID(:, params.vIMIDParent(j))>0)); 
        end; 
        sNCellsPar          = num2str(iNCellsPar);
        sPercentOfParent    = num2str(round((iNCellsPop/iNCellsPar)*1000)/10);
        fprintf               (fid, '%s\t%s\t%s\t%s\t%s\n', sNCellsTotal, sPopName, sNCellsPar, sNCellsPop, sPercentOfParent); 
  end
  fclose(fid);
catch
  sErr                      = 'Error: writing stats';
end