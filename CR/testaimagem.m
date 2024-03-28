imgres = [25 25];
image = imread('largeSquare.png');

image = imresize(image, imgres);
imshow(image)

binarizedImg = imbinarize(image);
imageVector1 = (binarizedImg( : ));

load('Treinos\TrainAll.mat'); %Carregamento da melhor rede


y = sim(net, imageVector1) %Simulação
y = y>=0.5