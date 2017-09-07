myFolder = 'D:\Thesis\BiometricProgram\Dataset\stare\';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.ppm');
imageFiles = dir(filePattern);

inputSize = 106050;
feat_segmentasi = zeros(inputSize,length(imageFiles));
%feat_bifurfikasi = zeros(inputSize,numel(imageFiles));

target = zeros(length(imageFiles));


for k = 1:length(imageFiles)
  baseFileName = imageFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  
  imageArray = imread(fullFileName);
  segimageArray = segmentation_v2(imageArray);
  
  scale_segmen_img = imresize(segimageArray,0.5);
  %scale_bifurfication_img = bifurfication(scale_segmen_img);
  
  %scale_bifurfikasi_vec = reshape(scale_bifurfication_img,[],1);
  scale_segmen_vec = reshape(scale_segmen_img,[],1);
  
  feat_segmentasi(:,k) = scale_segmen_vec;
  
  %feat_segmentasi = horzcat(feat_segmentasi,scale_segmen_vec);
  %feat_bifurfikasi = horzcat(feat_bifurfikasi,scale_bifurfikasi_vec);
 
  target(k,k) = 1;
  
  %scaledarr{1,k} = scale_img;
  %imshow(scale_img);  % Display image.
  %drawnow; % Force display to update immediately.
end

%feat = vertcat(feat_segmentasi,feat_bifurfikasi);
feat = feat_segmentasi;

save 'D:\Thesis\BiometricProgram\data.mat' feat target;