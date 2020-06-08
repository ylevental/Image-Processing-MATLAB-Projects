clear 
D = '/home/bill/matlab/imageseries';
nameArray = {};
S = dir(fullfile(D,'*.jpg'));
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    % Read in image
    image = imread(F);
    % Show image you're working with 


    %threshold brightness
    BW = image > 200;
    se = strel('disk',17); %structuring element with radius 17
    erodedBW = imerode(BW,se);
    %dilate image, imerode
    s = regionprops(erodedBW,'centroid');
    centroids = cat(1,s.Centroid);
    imshow(image)
    hold on
    plot(centroids(:,1),centroids(:,2),'b*','MarkerSize',10)
    hold off
    
    %fname = '/home/bill/matlab/imageseries2';
    %saveas(gca, fullfile(fname, string(k)), 'jpg');
    
    nameArray = [nameArray, centroids(:,1:2)];
    a = size(nameArray{k});
    nameArray{k} = horzcat(nameArray{k},(k-1).* ones(a(1),1));
end
ca2 = [];
for k = 1 : numel(nameArray)
  ca2 = [ca2; nameArray{k}];
end
tracks = track(ca2,20);
tracks_2 = tracks(1:699,1:4);
%v = zeros(length(tracks_2)-1,2) ;
%for i = 1:length(tracks_2)-1
%    v(i,:) = (tracks_2(i+1,:)-tracks_2(i,:)) ;
%end
%v_fin = sqrt(abs(v(:,1).^2) + abs(v(:,2).^2));

%x = 1:150;
%x = 151:length(tracks_2);
f = tracks_2(:,2);

plot(f)

% Now smooth with a Savitzky-Golay sliding polynomial filter
f = tracks_2(:,2);
windowWidth = 37;
polynomialOrder = 3;
f = sgolayfilt(f, polynomialOrder, windowWidth);
plot(f);
f1 = movingslope(f);
f1 = sgolayfilt(f1, polynomialOrder, 37);
f2 = movingslope(f1);
[pks,locs] = findpeaks(abs(f2),'MinPeakProminence',0.1); %maximum peaks
plot(1:length(f),f,locs,f(locs),'*')
locs = vertcat(1,locs);
locs = vertcat(locs,length(f));

figure
for i = 1:length(locs)-1
    x = locs(i):locs(i+1);
    p = polyfit(x,f(locs(i):locs(i+1)),2);
    y1 = polyval(p,x);
    %plot(x,f(locs(i):locs(i+1)))
    hold on
    plot(x,y1)
end