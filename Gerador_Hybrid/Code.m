% Universidade Tecnológica Federal do Paraná
% Renan Kodama Rodrigues 1602098
% Visão Computacional (Hybrid Images)


#carregando pacote image
pkg load image;


%fora do domino da frequência
function Fora_Da_Frequencia(local01, local02, alpha01, alpha02)
  #carregando imagens
  image_01 = imread(local01);
  image_02 = imread(local02);
  
  #aplicando filtro smooth e contornos na imagem 01
  image_lowPass01 = imsmooth(image_01,"gaussian", alpha01);    
  image_highPass01 = image_01 - image_lowPass01;

  #aplicando filtro smooth e contornos na imagem 02
  image_lowPass02 = imsmooth(image_02,"gaussian", alpha02);    
  image_highPass02 = image_02 - image_lowPass02;

  #unindo baixas e altas frequências das imagens 01 e 02
  image_final = image_lowPass02 + image_highPass01;
  
  #apresentação dos resultados
  figure('name','Passa Baixa 01 espacial','numbertitle','off'), imshow(image_lowPass01);
  figure('name','Passa Alta 01 espacial','numbertitle','off'), imshow(image_highPass01);  
  figure('name','Passa Baixa 02 espacial','numbertitle','off'), imshow(image_lowPass02); 
  figure('name','Passa Alta 02 espacial','numbertitle','off'), imshow(image_highPass02);
  figure('name','Imagem Final Fora do Dominio da Freq.','numbertitle','off'), imshow(image_final);
  
  imwrite (image_lowPass02, "Saida/PassaBaixa 02 Nofft.jpg") 
  imwrite (image_highPass01, "Saida/PassaAlta 01 Nofft.jpg");
  imwrite (image_final, "Saida/Imagem Final Fora do Dominio da Freq.jpg");
endfunction
 
 
%funções no dominio da frequência
function res = D(u,v,s)
  res = sqrt((u-s(1)/2)^2+(v-s(2)/2)^2); #distancia entre pontos
endfunction

function res = H(u,v,s,d0)
  res = e^-((D(u,v,s))^2/(2*d0^2));   #gaussiana
endfunction 
  
function [final_LowPassImage, final_HighPassImage] = Processar_Imagem(image)
  image_01 = rgb2gray(image);
  
  #padding da imagem
  image_padd = padarray(image_01, size(image_01),"zeros","post");
  
  #convertendo para double
  image_double = im2double(image_padd);
  
  #transformada de fourier e centralização do resultado
  image_Fourier = fft2(image_double);
  image_Fourier = fftshift(image_Fourier);
  
  #alocando filtro
  [image_Y_Padd, image_X_Padd, image_Z_Padd] = size(image_double);
  filtro = zeros([image_Y_Padd, image_X_Padd, image_Z_Padd]);
  
  #criando filtro
  for i = (1:image_Y_Padd)
    for j = (1:image_X_Padd)
      filtro(i,j) =  H(i,j,size(image_double), 20);
    endfor
  endfor
  
  #aplicando filtro na imagem transformada
  low_pass_Spectre = image_Fourier .* filtro;
  
  #removendo do spectro da frequencia 
  low_pass_Image = ifftshift(low_pass_Spectre);
  low_pass_Image = ifft2(low_pass_Image);
  
  figure('name','Espectro de Fourier','numbertitle','off'), imshow(uint8(abs(image_Fourier))); 
  figure('name','Filtro Low Pass','numbertitle','off'), imshow(im2uint8(abs(filtro)));
  
  #remover padding
  [tam_Y_Original, tam_X_Original, tam_Z_Original] = size(image_01);
  final_LowPassImage = zeros(tam_Y_Original,tam_X_Original);
  
  for i = (1: tam_Y_Original)
    for j = (1: tam_X_Original)
      final_LowPassImage(i,j) = low_pass_Image(i+2,j+2);
    endfor
  endfor 
  
  #obtendo as altas(bordas) e baixas(esboço) frequências
  final_HighPassImage = image_01 - im2uint8(abs(final_LowPassImage));
  final_LowPassImage =  im2uint8(abs(final_LowPassImage));
endfunction 
 
function Dominio_Da_Frequencia(local01, local02)
  #carregando imagens
  image_01 = imread(local01);
  image_02 = imread(local02);
  
  [low_pass_01, high_pass_01] = Processar_Imagem(image_01);
  [low_pass_02, high_pass_02] = Processar_Imagem(image_02);
  
  #unindo as altas e baixas frequências
  image_final = low_pass_02 + high_pass_01;
  
  #apresentação dos resultados
  figure('name','Passa Baixa 01 FFT','numbertitle','off'), imshow(low_pass_01);
  figure('name','Passa Alta 01 FFT','numbertitle','off'), imshow(high_pass_01);
  figure('name','Passa Baixa 01 FFT','numbertitle','off'), imshow(low_pass_02);
  figure('name','Passa Alta 01 FFT','numbertitle','off'), imshow(high_pass_02);
  figure('name','Imagem Final no Dominio da Freq.','numbertitle','off'), imshow(image_final);
  
  imwrite (low_pass_02, "Saida/PassaBaixa 02 FFT.jpg");
  imwrite (low_pass_01, "Saida/PassaBaixa 01 FFT.jpg");
  imwrite (high_pass_01, "Saida/PassaAlta 01 FFT.jpg");
  imwrite (high_pass_02, "Saida/PassaAlta 02 FFT.jpg");
  imwrite (image_final, "Saida/Imagem no Dominio da Freq.jpg");
endfunction
  
  
  ################## MAIN ##################
  
  #Fora_Da_Frequencia("Data/cat.bmp", "Data/dog.bmp", 04, 06);
  Fora_Da_Frequencia("Data/bru.bmp", "Data/re.bmp", 1.7, 7);
  
  #Dominio_Da_Frequencia("Data/cat.bmp","Data/dog.bmp");
  Dominio_Da_Frequencia("Data/bru.bmp", "Data/re.bmp");
  
  ################## MAIN ##################
  
  
  
  
  
  %Atividade Question 02
  #filtro = [0,0,0;-1,1,0;0,0,0];
  #filtro2 = [0,0,0;0,1,0;0,-1,0];
  #image_01 = imread("Data/re.bmp");
  #image_01 = rgb2gray(image_01);
   
  #image_final_conv = conv2(image_01,filtro);
  #image_final_corr = conv2(image_01,filtro2);
  
  #figure, imshow(image_final_conv);
  #figure, imshow(image_final_corr);
  
  #imwrite(image_final_conv,"Saida/image_final_conv.jpg");
  #imwrite(image_final_corr,"Saida/image_final_corr.jpg");



  

  

  

  


  

  