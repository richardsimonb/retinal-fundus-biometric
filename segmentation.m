function segmented_img = segmentation(retina_img)
%Fungsi untuk melakukan segmentasi pembuluh darah pada retina
%   Input:
%       retina_img = citra dari retina yang akan diproses berupa gambar rgb
%   Output:
%       segmented_img = hasil segmentasi citra retina berupa gambar binary

%% RGB Fundus Image
%img = imread('D:\Thesis\BiometricProgram\Dataset\rgb\01_test.tif');
img = retina_img;
% figure; imshow(I);
% title('Citra Asli');
%% Green Channel Extraction
greenc = img(:,:,2);
% figure; imshow(greenc);
% title('Citra Green Channel');
%% CLAHE
ginc = imcomplement (greenc);
c_enhance = adapthisteq(ginc,'ClipLimit',0.01);
c_enhance = imadjust(c_enhance,[0.3 0.9],[]);
% figure; imshow(c_enhance);
% title('Citra Hasil Perataan Histogram');

%% Optic Disk Removal
se = strel('ball',8,8);
gopen = imopen(c_enhance,se);
goptic = c_enhance - gopen;

%% Filter and Noise Removal
% 2D Median Filter
medfilt = medfilt2(goptic);
medfilt = imsharpen(medfilt,'Radius',25,'Amount',2);
background = imopen(medfilt,strel('disk',15));
I2 = medfilt - background;                      
I3 = imadjust(I2);                              
levelMedFilt = graythresh(I3);                  
bwMedFilt = im2bw(I3,levelMedFilt);             
bwMedFilt = bwareaopen(bwMedFilt, 100);

%% Results
segmented_img = bwMedFilt;
