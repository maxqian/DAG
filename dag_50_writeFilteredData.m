function  sErr         = dag_50_writeFilteredData  (params, mNorm, mID)
sErr                      = [];
try
  
  % Remove filtered markers
  vINewOutChn = [];
  ChannelToKeep = params.cChannelToReturn;
  for i=1:length(params.vIOutChn)
    member = find(ismember(ChannelToKeep, params.cColHdrs{params.vIOutChn(i)}));
    if ~isempty(member)
        vINewOutChn = [vINewOutChn, params.vIOutChn(i)];
    end
  end
  
  for                   j = 1:length(params.vIMIDOut);                                                                      % For j = 1:Num of output populations
            
      [s,mess,messid]         = mkdir(params.sWkDir,strcat('filteredData_',params.cPopName{params.vIMIDOut(j)})); 
      if                        (params.bLinux==1); 
          params.sDirFiltData   = [params.sWkDir  strcat('filteredData_',params.cPopName{params.vIMIDOut(j)},'/')];         
      end
      if                        (params.bLinux==0); 
          params.sDirFiltData   = [params.sWkDir  strcat('filteredData_',params.cPopName{params.vIMIDOut(j)},'\')];         
      end
      vI                    = [];  
      sFNOutData            = [params.sDirFiltData params.sFNFCS(1:end-4) '_' params.cPopName{params.vIMIDOut(j)} '-filt.txt'];                                  
      vITmp                 = find(mID(:,params.vIMIDOut(j))== 1);    
      vI                    = [vI; vITmp];
      vIUniq                = unique(vI);
      iNTmp                 = length(vIUniq); 
      mF                    = mNorm(vIUniq, vINewOutChn);                                                                     % Write data for markers (excluding those in ChannelToRemove) for only those cells that are contained in the output populations
      fid                   = fopen(sFNOutData,'w');   
      sFmtHdr               = [repmat('%s\t',1,size(mF,2)-1),'%s\n']; 
      fprintf               (fid,sFmtHdr,params.cColHdrs{vINewOutChn});
      sFmtData              = [repmat('%i\t',1,size(mF,2)-1),'%i\n'];
      fprintf               (fid, sFmtData, mF');
      fclose(fid);
  end
  iDebug = 1;
      
catch e
  sErr                    = 'Error: writing data';
  disp(e)
  e.throw
end