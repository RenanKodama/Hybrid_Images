% Universidade Tecnológica Federal do Paraná
% Renan Kodama Rodrigues 1602098
% Visão Computacional (Hybrid Images)


#carregando pacote image
pkg load image;



#Fora do Dominio da Frequencia
  #carregando imagens
  image_cat = imread("Data/cat.bmp");
  image_dog = imread("Data/dog.bmp");

  %figure('name','Cat Original','numbertitle','off'), imshow(image_cat);  #exibição
  %figure('name','Dog Original','numbertitle','off'), imshow(image_dog);  #exibição

  image_lowPassCat = imsmooth(image_cat,"gaussian", 15);
  image_highPassCat = image_cat - image_lowPassCat;

  image_lowPassDog = imsmooth(image_dog,"gaussian", 4);
  image_highPassDog = image_dog - image_lowPassDog;

  image_final = image_lowPassDog + image_highPassCat;

  figure, imshow(image_final);

  
%Dominio da Frenquencia
  %carregando imagen
  image_catFreq = imread("Data/cat.bmp");
  image_dogFreq = imread("Data/dog.bmp");
  
  %covertendo para grayScale
  image_catFreq_GrayS = rgb2gray (image_catFreq);
  
  figure, imshow(image_catFreq_GrayS);
  
  %padding da imagem
  image_catFreq_GrayS = padarray(image_catFreq_GrayS, size(image_catFreq_GrayS), "zeros", "post");

  %convertendo para doube
  image_catFreq_GrayS_Double = im2double(image_catFreq_GrayS);
  
  %tranformada de fourier e centralização
  image_CatFourier = fft2(image_catFreq_GrayS_Double);
  image_CatFourier = fftshift(image_CatFourier);
  
  figure, imshow(uint8(abs(image_CatFourier)));
   
  %filtro
  [image_X,image_Y] = size(image_catFreq_GrayS_Double);
  filtro = ones(image_X,image_Y);
  
  for i= ((image_X/2)-10 : (image_X/2)+10)
    for j= ((image_Y/2)-10 : (image_Y/2)+10)
      filtro(i,j) = 0;
    endfor
  endfor
  
  low_pass_Spectre = image_CatFourier .* filtro;
  
  figure, imshow(uint8(abs(low_pass_Spectre)));
  
  low_pass_Image = ifftshift(low_pass_Spectre);
  low_pass_Image = ifft2(low_pass_Image);
  low_pass_Image = abs(low_pass_Image);
  
  #remover padding
  figure, imshow(im2uint8(low_pass_Image));

  
  
  
  
  
