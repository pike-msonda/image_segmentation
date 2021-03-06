function [Results]=ComputeFMeasureMultiSeg(DBpath,SegResultsSubPath,SysType)
%Compute the F-score for multi segments
%Syntax:
%       [Results]=ComputeFMeasure(DBpath,SegResultsSubPath,SysType)
%Input:
%       DBpath - The directory of the entire evaluation Database
%       SegResultsSubPath - The name of the sub-directory  in which the results of
%                           the algorithm to be evaluated  are placed.
%       SysType - The type of system in use, this determines the path
%                 separation char. There are two optional values  'win' or 'unix'
%                 if no value is specified the default is set to 'win'.
%
%Output:
%       Results - An 100X4 matrix where Results(i,1) holds the best f-score for a single segment.
%                 Results(i,2) and Results(i,3) holds the corresponding Recall and Precision scores.
%                 Results(i,4) holds the amount of fragmentation. 
%
%The evaluation function is given as is without any warranty. The Weizmann
%institute of science is not liable for any damage, lawsuits, 
%or other loss resulting from the use of the evaluation functions.
%Written by Sharon Alpert Department of Computer Science and Applied Mathematics
%The Weizmann Institute of Science 2007


Lpath={ '112255696146'...
    '113334665744'};

if (nargin==2)
    SysType='win';
end;

l=dir(DBpath);
C=1;
Results=zeros(length(Lpath),3);
switch lower(SysType)
    case 'win' 
        Sep='\';
    case 'unix' 
        Sep='/';
    otherwise 
        Sep='\';
end;      
for i=1:length(Lpath)
    fprintf('Working on image:%s\n',cell2mat(strcat(DBpath,Sep,Lpath(i),Sep,'human_seg',Sep)));  
    Hmask=GetHSeg(strcat(DBpath,Sep,Lpath(i),Sep,'human_seg',Sep));
    fprintf('Working on image:%s\n',cell2mat(Lpath(i)));    
    [Pmax Rmax Fmax Frag]=CalcCandScore(cell2mat(strcat(DBpath,Sep,Lpath(i),Sep,SegResultsSubPath,Sep)),Hmask);
    Results(i,1)=Fmax;
    Results(i,2)=Rmax;
    Results(i,3)=Pmax;
    Results(i,4)=Frag;
end;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Get the Human binary segmentation                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mask]=GetHSeg(Hpath)
% Get the human segmentation by considering the votes from each human
% subject
l=dir(cell2mat(Hpath));
for k=1:length(l)
    if (l(k).isdir)
        continue;
    end;
    im=im2double(imread(cell2mat(strcat(Hpath,l(k).name))));
    if (exist('mask','var'))
        mask=mask+double((im(:,:,1)==1)&(im(:,:,2)==0));
    else
        mask=double((im(:,:,1)==1)&(im(:,:,2)==0));
    end;
end;
if (~exist('mask') || max(mask(:))<2)
    error('Error reading human segmentations please check path.');
end;
mask=mask>=2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Calcuate the F-score                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p r f]=CalcPRPixel(GT,mask)
    if (sum(GT(:)&mask(:))==0)
        p=0;r=0;f=0;
        return;
    end;
    r=sum(GT(:)&mask(:))./sum(GT(:));
    c=sum(mask(:))-sum(GT(:)&mask(:));
    p=sum(GT(:)&mask(:))./(sum(GT(:)&mask(:))+c);
    f=(r*p)/(0.5*(r+p));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Calcuate the F-score of the evaluated method             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Pmax Rmax Fmax Frag]=CalcCandScore(SegPath,HumanSeg)
Fmax=0;
Pmax=0;
Rmax=0;
Frag=0;
k=dir(SegPath);
for i=1:length(k);
    if (k(i).isdir)
        continue;
    end;
 
   Segmap=imread(fullfile(SegPath, k(i).name));
   NumOfSegs=unique(Segmap(:)); %find out how many segments
   FragCounter=0;
   FragMap=logical(zeros(size(Segmap)));
   for j=1:length(NumOfSegs)
             t=(Segmap==NumOfSegs(j));
             if (sum(t(:)&HumanSeg(:))/sum(t(:))>0.5)%if a more then 50% of the pixels are in the foreground then 
                                               %it is considered as part of the total foreground. 
                 FragCounter=FragCounter+1;  %fragmentation counter
                 FragMap=FragMap|t;
             end; 
              
        end;%Go over all segments in the image

   [p r f]=CalcPRPixel(FragMap,HumanSeg);%Calculate the F-score
   if (f>Fmax)
          Fmax=f;
          Pmax=p;
          Rmax=r;
          Frag=FragCounter;
    end;
        
 end;%Go over all segmentations in the Dir
end


