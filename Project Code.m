% Read the image
input_image = imread('input image.png');

% Display the original image
figure;
imshow(input_image);
title('Original Image');

%% 
%1. Convert the image to grayscale
gray_image = rgb2gray(input_image);

% Display the grayscale image
figure;
imshow(gray_image);
title('Grayscale Image');

%% 
% 2.1 Apply Gaussian Blur
gaussian_blur = imgaussfilt(gray_image, 2);

% Display the Gaussian blurred image
figure;
imshow(gaussian_blur);
title('Gaussian Blurred Image');

%% 
% 2.2 Adjusting Gaussian Blur
% Apply Gaussian Blur
gaussian_blur = imgaussfilt(gray_image, 1);

% Display the Gaussian blurred image
figure;
imshow(gaussian_blur);
title('Gaussian Blurred Image - Adjusted');

%% 
%3. Apply sharpening filter
sharpened_image = imsharpen(gaussian_blur, 'Radius', 2, 'Amount', 2);

% Display the sharpened image
figure;
imshow(sharpened_image);
title('Sharpened Image');

%% 
%4. Apply Canny Edge Detection
edges = edge(sharpened_image, 'Canny');

% Display the edges
figure;
imshow(edges);
title('Edges Detected');

%% 
%5.1 Apply histogram equalization
equalized_image = histeq(sharpened_image);

% Display the histogram equalized image
figure;
imshow(equalized_image);
title('Histogram Equalized Image');

%% 
%5.2 Apply Histogram Equalization
hist_eq_image = histeq(sharpened_image);

% Adjust the image using imadjust to further refine the contrast
adjusted_image = imadjust(hist_eq_image, stretchlim(hist_eq_image, [0.01 0.80]), []);

% Combine the original image and the histogram equalized image
% to preserve details and enhance contrast
combined_image = imfuse(sharpened_image, adjusted_image, 'blend');

% Display the result
figure;
imshow(combined_image);
title('Combined Image with Enhanced Details');

%% 
%5.3 test 2nd time Apply Canny Edge Detection
edges = edge(combined_image, 'Canny');

% Display the edges
figure;
imshow(edges);
title('Edges Detected');

%% 
%6.1 Adjust brightness
alpha = 1.2; % Simple contrast control
beta = 20;   % Simple brightness control
brightness_adjusted = imadjust(combined_image, [], [], alpha);
brightness_adjusted = brightness_adjusted + beta;

% Display the brightness adjusted image
figure;
imshow(brightness_adjusted);
title('Brightness Adjusted Image');

%% 
%6.2 Adjust brightness and contrast
alpha = 1.2; % Slightly lower contrast control
beta = 30;  % Slightly higher brightness control
brightness_adjusted = imadjust(combined_image, [], [], alpha);
brightness_adjusted = brightness_adjusted + beta;

% Display the brightness adjusted image with new parameters
figure;
imshow(brightness_adjusted);
title('Brightness Adjusted Image (New Parameters)');

%% 
%7. Create a structuring element for morphological operations
se = strel('disk', 1);

% Apply Dilation
dilated_image = imdilate(brightness_adjusted, se);

figure;
imshow(dilated_image);
title('Dilated Image');

% Apply Erosion
eroded_image = imerode(dilated_image, se);

figure;
imshow(eroded_image);
title('Eroded Image');

%% 
%8. Apply CLAHE with adjusted parameters
clahe_image = adapthisteq(eroded_image, 'ClipLimit', 0.001, 'Distribution', 'uniform');

% Display the CLAHE image with adjusted parameters
figure;
imshow(clahe_image);
title('CLAHE Image (Adjusted)');

%% 
%9. Threshold the image to create a mask for black dots (artifacts)
% Adjust the threshold value as needed
threshold_value = 40; % This value can be adjusted based on the image
artifact_mask = clahe_image < threshold_value;

% Display the artifact mask
figure;
imshow(artifact_mask);
title('Artifact Mask');

% Apply regionfill to fill the artifacts
filled_image = regionfill(clahe_image, artifact_mask);

% Display the filled image
figure;
imshow(filled_image);
title('Image after Artifact Removal');

%% 
% Load the input image
input_image = imread('input image.png');

% Separate the color channels
Rchannel = input_image(:,:,1);
Gchannel = input_image(:,:,2);
Bchannel = input_image(:,:,3);

% Increase the saturation of the original color channels
saturation_factor = 1.5; % Adjust this factor to increase saturation

R_adjusted = imadjust(Rchannel, stretchlim(Rchannel), [], saturation_factor);
G_adjusted = imadjust(Gchannel, stretchlim(Gchannel), [], saturation_factor);
B_adjusted = imadjust(Bchannel, stretchlim(Bchannel), [], saturation_factor);

% Clip the values to [0, 255] range
R_adjusted = uint8(max(min(R_adjusted, 255), 0));
G_adjusted = uint8(max(min(G_adjusted, 255), 0));
B_adjusted = uint8(max(min(B_adjusted, 255), 0));

% Combine the adjusted channels to create the color-adjusted image
color_adjusted_image = cat(3, R_adjusted, G_adjusted, B_adjusted);

% Convert the color-adjusted image to LAB color space
lab_image = rgb2lab(color_adjusted_image);

% Replace the L channel with the processed grayscale image
lab_image(:,:,1) = double(filled_image) / 255 * 100; % Scale to [0, 100]

% Convert back to RGB color space
color_restored_image = lab2rgb(lab_image);

% Display the color restored image
figure;
imshow(color_restored_image);
title('Color Restored Image');
