function readimage()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

clc;
clear all;
close all;

aux = 1;
targetToText = ["circle" "kite" "parallelogram" "square" "trapezoid" "triangle"];
imgres = [25 25];
inputs = [];

nrEpochs = 2;%30;
accuracy_overall_stack = [];
accuracy_teste_stack = [];


target = zeros(6, 30);
k = 0;

for i = 1:length(targetToText)
    Directory = '.\NN_Tema1_images\start\' + targetToText(i);
    % Read images from Images folder
    images = dir(fullfile(Directory, '*.png'));
    

    for k = (k+1):length(images)*i
        target(i, k) = 1;

    end

    for j = 1:length(images)
        image = imread(fullfile(Directory, images(j).name));  % Read image
        image = imresize(image, imgres);
        binarizedImg = imbinarize(image);

        imageVector1 = (binarizedImg( : ));

        inputs( : , aux) = imageVector1;
        aux = aux + 1;
    end


end



for epoch = 1 : nrEpochs
    %net = feedforwardnet([10 10]);
    net = feedforwardnet(10);
    net.layers{1:end-1}.transferFcn = 'logsig';
    net.layers{end}.transferFcn = 'purelin';

    net.trainFcn = 'trainlm';
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio = 0.15;


    % TREINAR
    [net,tr] = train(net, inputs, target);
    %view(net);
    %disp(tr);
    % SIMULAR
    out = sim(net, inputs);

    %VISUALIZAR DESEMPENHO

    plotconfusion(target, out) % Matriz de confusao

    % plotperf(tr)         % Grafico com o desempenho da rede nos 3 conjuntos

    %erro = perform(net, out,irisTargets);
    %fprintf('Erro na classificação dos 150 exemplos %f\n', erro)
    %Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
    r=0;
    for i=1:size(out,2)               % Para cada classificacao
        [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
        [c d] = max(target(:,i));               %d guarda a linha onde encontrou valor mais alto da saida desejada
        if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
            r = r+1;
        end
    end

    accuracy = r/size(out,2)*100;
    fprintf('Precisao total %f\n', accuracy);
    accuracy_overall_stack = [accuracy_overall_stack accuracy];

    % SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
    TInput = inputs(:, tr.testInd);
    TTargets = target(:, tr.testInd);

    out = sim(net, TInput);

    %erro = perform(net, out,TTargets);
    %fprintf('Erro na classificação do conjunto de teste %f\n', erro)

    %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
    r=0;
    for i=1:size(tr.testInd,2)       % Para cada classificacao
        [a b] = max(out(:,i));       % b guarda a linha onde encontrou valor mais alto da saida obtida
        [c d] = max(TTargets(:,i));  % d guarda a linha onde encontrou valor mais alto da saida desejada
        if b == d                    % se estao na mesma linha, a classificacao foi correta (incrementa 1)
            r = r+1;
        end

    end
    accuracy = r/size(tr.testInd,2)*100;
    fprintf('Precisao teste %f\n', accuracy);

    accuracy_teste_stack = [accuracy_teste_stack accuracy];

end

round(mean(accuracy_overall_stack));
round(mean(accuracy_teste_stack));

save('Teste.mat', 'net');
end