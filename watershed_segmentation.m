clear 
Dir = '/home/bill/matlab/imageseries';
S = dir(fullfile(Dir,'*.jpg'));
for k = 1:10:numel(S)
	RGB = fullfile(Dir,S(k).name);
    RGB = imread(RGB);
    BW = rgb2gray(RGB);
    BW = imbinarize(BW);
    se = strel('disk',5); %structuring element with radius 5
    erodedBW = imerode(BW,se);
    BW = imdilate(erodedBW,se);
    
    D = -bwdist(~BW);
    Ld = watershed(D);
    %imshow(D,[])
    bw2 = BW;
    bw2(Ld == 0) = 0;
    %imshow(bw2)
    mask = imextendedmin(D,2);
    imshowpair(BW,mask,'blend')
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = BW;
    bw3(Ld2 == 0) = 0;
    imshow(bw3)
    [B,L] = bwboundaries(bw3,'noholes');
    hold on
    for k1 = 1:length(B)
        boundary = B{k1};
        plot(boundary(:,2),boundary(:,1),'r','LineWidth',2)
    end

    fname = '/home/bill/matlab/imageseries2';
    saveas(gca, fullfile(fname, string(k)), 'jpg');
    %most credit goes to https://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/
end

%Additional plan:
%Fit ellipse to boundaries
%Find two principal radii of ellipses
%Capillary pressure/force = c*(1/r1 + 1/r2)
%Find method to track ellipses