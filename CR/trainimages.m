function trainimages()
    
    aux = 1;
    targetToText = ["circle" "kite" "parallelogram" "square" "trapezoid" "triangle"]; %Vetor com o nome das pastas de cada figura geométrica´
    imgres = [25 25]; %Tamanho para redimensionar a imagem
    inputs = []; %Dados das imagens
    
    nrEpochs = 10; %Número de repetições de cada combinação
    accuracy_overall_stack = []; %Precisão total
    accuracy_teste_stack = []; %Precisão de teste
    
    target = zeros(6, 30); %Inicialização da matriz dos targets a zeros(varia consoante a pasta 'start','test','train')
    %'start' --> target = zeros(6, 30); 6 = numeros de formas 30 = numeros de formas * numero de imagens por pasta
    %'test'  --> target = zeros(6, 60);
    %'train' --> target = zeros(6, 300);
    %'all'   --> target = zeros(6, 390); (todas as imagens das pastas 'start','test' e 'train')
    
    k = 0;
    
    for i = 1:length(targetToText)                          
        Directory = '.\NN_Tema1_images\start\' + targetToText(i); %Directoria de cada pasta
        images = dir(fullfile(Directory, '*.png')); %Lê imagens(.png) da pasta
        
        for k = (k+1):length(images)*i %Ciclo para a construção dos targets
            target(i, k) = 1; 
        end
    
        for j = 1:length(images)
            image = imread(fullfile(Directory, images(j).name)); %Lê imagem
            image = imresize(image, imgres); %Redimensiona imagem
            binarizedImg = imbinarize(image); %Binariza imagem (0/1)
    
            imageVector1 = (binarizedImg( : )); 
    
            inputs( : , aux) = imageVector1; %Adiciona ao vetor dos inputs(Informação das imagens)
            aux = aux + 1;
        end
    end
    
    for epoch = 1 : nrEpochs
        net = feedforwardnet([10 10]); %Criação da rede neuronal 
        net.layers{1:end-1}.transferFcn = 'logsig'; %função ativação 
        net.layers{end}.transferFcn = 'tansig'; %função de saida
        net.trainFcn = 'trainlm'; %função de treino
        net.divideFcn = 'dividerand'; %função de divisão
        %parametros da função de divisão
        net.divideParam.trainRatio = 0.7;
        net.divideParam.valRatio = 0.15;
        net.divideParam.testRatio = 0.15;
    
        [net,tr] = train(net, inputs, target); %treina a rede
        view(net); %Visualizar a rede
        out = sim(net, inputs); %simula a rede
       
        plotconfusion(target, out) % Matriz de confusao
    
        % plotperf(tr) % Grafico com o desempenho da rede nos 3 conjuntos
    
        %Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
        r=0;
        for i=1:size(out,2)           % Para cada classificacao
            [a b] = max(out(:,i));    %b guarda a linha onde encontrou valor mais alto da saida obtida
            [c d] = max(target(:,i)); %d guarda a linha onde encontrou valor mais alto da saida desejada
            if b == d                 % se estao na mesma linha, a classificacao foi correta (incrementa 1)
                r = r+1;
            end
        end
    
        accuracy = r/size(out,2)*100;
        fprintf('epoch: %d Precisao total %f\n', epoch, accuracy);
        accuracy_overall_stack = [accuracy_overall_stack accuracy];
    
        % simula a rede no conjunto teste
        TInput = inputs(:, tr.testInd);
        TTargets = target(:, tr.testInd);
        out = sim(net, TInput);
        %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
        r=0;
        for i=1:size(tr.testInd,2)      % Para cada classificacao
            [a b] = max(out(:,i));      % b guarda a linha onde encontrou valor mais alto da saida obtida
            [c d] = max(TTargets(:,i)); % d guarda a linha onde encontrou valor mais alto da saida desejada
            if b == d                   % se estao na mesma linha, a classificacao foi correta (incrementa 1)
                r = r+1;
            end
    
        end
        accuracy = r/size(tr.testInd,2)*100;
        fprintf('epoch: %d Precisao teste %f\n\n', epoch, accuracy);
    
        accuracy_teste_stack = [accuracy_teste_stack accuracy];
    
    end
    
    round(mean(accuracy_overall_stack));
    round(mean(accuracy_teste_stack));
    
    save('start.mat', 'net'); %guarda a rede treinada com o nome escolhido
end