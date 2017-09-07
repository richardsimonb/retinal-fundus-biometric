function bifurfication_img = bifurfication(seg_img)
%Fungsi untuk mendeteksi bifurfikasi pada citra hasil segmentasi
%   Input:
%       seg_img = citra segmentasi retina
%   Output:
%       bifurfication_img

segimg = seg_img;

vesselMaskMedFilt = bwmorph(segimg,'skel',Inf);
% Remove spur from image
vesselMaskMedFilt = bwmorph(vesselMaskMedFilt,'spur',5);
%figure; imshow(vesselMaskMedFilt);

branchPointsMedFilt = bwmorph(vesselMaskMedFilt,'branch',1);
branchPointsMedFilt = imdilate(branchPointsMedFilt,strel('disk',1));

bifurfication_img = branchPointsMedFilt;
%figure; imshow(branchPointsMedFilt);

vesselMaskMedFilt = vesselMaskMedFilt & ~branchPointsMedFilt;
%figure; imshow(vesselMaskMedFilt);