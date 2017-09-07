myFolder = 'D:\Thesis\BiometricProgram\Dataset\vessel\';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.png');
imageFiles = dir(filePattern);
feat_segmentasi = zeros();
feat_bifurfikasi = zeros();


for k = 1:length(imageFiles)
  baseFileName = imageFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  
  imageArray = imread(fullFileName);
  
  scale_segmen_img = imresize(imageArray,0.5);
  scale_bifurfication_img = bifurfication(scale_segmen_img);
  
  scale_bifurfikasi_vec = reshape(scale_bifurfication_img,[],1);
  scale_segmen_vec = reshape(scale_segmen_img,[],1);
  
  feat_segmentasi = horzcat(feat_segmentasi,scale_segmen_vec);
  feat_bifurfikasi = horzcat(feat_bifurfikasi,scale_bifurfikasi_vec);
  
  %scaledarr{1,k} = scale_img;
  %imshow(scale_img);  % Display image.
  %drawnow; % Force display to update immediately.
end

feat = vertcat(feat_segmentasi,feat_bifurfikasi);

target = [1 0 0 0 0 0 0 0 0 0;
          0 1 0 0 0 0 0 0 0 0;
          0 0 1 0 0 0 0 0 0 0;
          0 0 0 1 0 0 0 0 0 0;
          0 0 0 0 1 0 0 0 0 0;
          0 0 0 0 0 1 0 0 0 0;
          0 0 0 0 0 0 1 0 0 0;
          0 0 0 0 0 0 0 1 0 0;
          0 0 0 0 0 0 0 0 1 0;
          0 0 0 0 0 0 0 0 0 1];

save 'D:\Thesis\BiometricProgram\data.mat' feat target;