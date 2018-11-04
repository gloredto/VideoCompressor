%Coding Input Image
img = imread('KateandMike.jpg');
figure, imshow(img), title('IMAGE_INPUT');

[img_size_x,img_size_y,img_size_z] = size(img);
if ((mod(img_size_x,8) ~= 0) || (mod(img_size_y,8) ~= 0))
    img_size_x = img_size_x + mod(img_size_x,8);
    img_size_y = img_size_y + mod(img_size_y,8);
end

img = imresize(img,[img_size_x img_size_y]);


%Coding Memisahkan Matriks R,G&B
red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
a = zeros(size(img, 1), size(img, 2));

%Coding Show Image R
just_red = cat(3, red, a, a);
figure, imshow(just_red), title('RED');

%Coding Show Image G
just_green = cat(3, a, green, a);
figure, imshow(just_green), title('GREEN');

%Coding Show Image B
just_blue = cat(3, a, a, blue);
figure, imshow(just_blue), title('BLUE');

%Coding Nilai RGB Matriks 1 Channel
R = img(:,:,1); % Red channel
G = img(:,:,2); % Green channel
B = img(:,:,3); % Blue channel

% A Standard Quantization Matrix
q_mtx =     [16 11 10 16 24 40 51 61; 
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56; 
            14 17 22 29 51 87 80 62;
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];

Y = 0.299 * R + 0.587 * G + 0.114 * B;
figure,imshow(Y),title('Luminance');

I = im2double(Y);

dct_mtx = dctmtx(8);
figure,imshow(dct_mtx),title('Matriks_DCT');

f_dct = @(block_struct) dct_mtx * block_struct.data * dct_mtx';
I_DCT = blockproc(I,[8 8],f_dct);
%I_DCT = im2uint8(I_DCT);
figure,imshow(I_DCT),title('Image_DCT');
%I_DCT = im2double(I_DCT);

quantization = @(block_struct) (block_struct.data) ./ q_mtx;        
I_Q = blockproc(I_DCT,[8 8],quantization);
figure,imshow(I_Q),title('Image_Quantization')

Z = im2uint8(I_Q);
uintZ = round(Z);
IQ = im2double(uintZ);

dequantization = @(block_struct) (block_struct.data) .* q_mtx;
I_IQ = blockproc(IQ,[8 8],dequantization);
figure,imshow(I_IQ),title('Image_IQuantization')

f_idct = @(block_struct) dct_mtx' * block_struct.data * dct_mtx;
I_IDCT = blockproc(I_IQ,[8 8],f_idct);
figure,imshow(I_IDCT),title('Image_IDCT')








