function stat = uCreateCompImage(sDirIn, sFNOut, iNCols, sFileExtension, params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% = %%%%%%%%%%%%%%%%
  [vsFileList]                        = u_getFilesFromDir(sDirIn, sFileExtension, params);
  
  if ~isempty(vsFileList)
      iNFiles                             = length(vsFileList);

      iNRows                              = ceil(iNFiles/iNCols);
      iBorder                             = 3;
      for                               i = 1:length(vsFileList);
        mIm                               = imread(vsFileList{i}, 'png');
        if                                  (i==1)
          iNPR                            = size(mIm,1);                                  % NPix Resized image Rows
          iNPC                            = size(mIm,2);
          mComp                           = zeros(iNRows*(iNPR+iBorder), iNCols*(iNPC+iBorder), 3,'uint8');
        end
        iCol                              = mod(i-1,iNCols)+1;
        iRow                              = floor((i-1)/iNCols)+1;

        iURow                             = iBorder + (iRow    -1)*(iNPR+iBorder)+1;      % Upper Row
        iBRow                             = iURow + iNPR - 1;
        iLCol                             = iBorder + (iCol -1)*(iNPC+iBorder)+1;         % Left Col
        iRCol                             = iLCol + iNPC - 1;
        mImTmp                            = zeros(iNPR, iNPC, 3);
        if                                  (size(mIm,1) <= size(mImTmp,1)) && (size(mIm,2) <= size(mImTmp,2)) && (size(mIm,3) <= size(mImTmp,3))
          iNR                             = size(mIm,1);
          iNC                             = size(mIm,2);
          mImTmp(1:iNR,1:iNC,:)           = mIm;
          mComp(iURow:iBRow,iLCol:iRCol,:)  = mImTmp;
        end
      end
      imwrite                               (mComp, sFNOut, 'png');
  end
  stat=0;
  
