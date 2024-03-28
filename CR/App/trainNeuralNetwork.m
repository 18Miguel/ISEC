function trainNeuralNetwork(DataSetDirectory, ArrayCamadas, FunctionActivationOut, FunctionTrain, TrainValue, ValValue, TestValue)
    [~, fType,~] = fileparts(DataSetDirectory);
    
    if fType == "start"
     target = zeros(6, 30);
    end
    if fType == "test"
     target = zeros(6, 60);
    end
    if fType == "train"
     target = zeros(6, 300);
    end    
    

    aux = 1;
    targetToText = ["circle" "kite" "parallelogram" "square" "trapezoid" "triangle"];
    imgres = [25 25];
    inputs = [];
    nrEpochs = 1;
    accuracy_overall_stack = [];
    accuracy_teste_stack = [];
    k = 0;
    
    for i = 1:length(targetToText)
        Directory = strcat(DataSetDirectory + "\", targetToText(i));
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
    
    %Camadas = [];
    Camadas = "";
    for i = 1:length(ArrayCamadas)
        %Camadas = [Camadas ArrayCamadas(i).Neuronios];
        Camadas = strcat(Camadas, num2str(ArrayCamadas(i).Neuronios), " ");
        net.layers{i}.transferFcn = ArrayCamadas(i).fAtiv;
    end
    
    
    for epoch = 1 : nrEpochs
        %% CRIAR E CONFIGURAR A REDE NEURONAL
        % INDICAR: N? camadas escondidas e nos por camada escondida
        % INDICAR: Funcao de treino: {'trainlm', 'trainbfg', traingd'}
        % INDICAR: Funcoes de ativacao das camadas escondidas e de saida: {'purelin', 'logsig', 'tansig'}
        % INDICAR: Divisao dos exemplos pelos conjuntos de treino, validacao e teste

        net = feedforwardnet([str2num(Camadas)]);
        for i = 1:length(ArrayCamadas)
            net.layers{i}.transferFcn = ArrayCamadas(i).fAtiv;
        end
        net.layers{end}.transferFcn = FunctionActivationOut;
        net.trainFcn = FunctionTrain;
        net.divideFcn = 'dividerand';
        net.divideParam.trainRatio = TrainValue;
        net.divideParam.valRatio = ValValue;
        net.divideParam.testRatio = TestValue;
    
    
        %% TREINAR
        [net, tr] = train(net, inputs, target);

        %% SIMULAR
        out = sim(net, inputs);
    
        %% VISUALIZAR DESEMPENHO
        plotconfusion(target, out)  % Matriz de confusao

       
        %% Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
        r=0;
        for i = 1:size(out, 2)          % Para cada classificacao
            [a b] = max(out(:,i));      % b guarda a linha onde encontrou valor mais alto da saida obtida
            [c d] = max(target(:,i));   % d guarda a linha onde encontrou valor mais alto da saida desejada
            if b == d                   % Se estao na mesma linha, a classificacao foi correta (incrementa 1)
                r = r+1;
            end
        end
    
        accuracy = r/size(out,2)*100;
        fprintf('epoch: %d Precisao total %f\n', epoch, accuracy);
        accuracy_overall_stack = [accuracy_overall_stack accuracy];
    
        %% SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
        TInput = inputs(:, tr.testInd);
        TTargets = target(:, tr.testInd);
    
        out = sim(net, TInput);

    
        %% Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
        r=0;
        for i=1:size(tr.testInd,2)       % Para cada classificacao
            [a b] = max(out(:,i));       % b guarda a linha onde encontrou valor mais alto da saida obtida
            [c d] = max(TTargets(:,i));  % d guarda a linha onde encontrou valor mais alto da saida desejada
            if b == d                    % se estao na mesma linha, a classificacao foi correta (incrementa 1)
                r = r+1;
            end
    
        end
        accuracy = r/size(tr.testInd,2)*100;
        fprintf('epoch: %d Precisao teste %f\n\n', epoch, accuracy);
    
        accuracy_teste_stack = [accuracy_teste_stack accuracy];
    
    end
    
    round(mean(accuracy_overall_stack));
    round(mean(accuracy_teste_stack));
    
    while 1
        [file, path] = uiputfile('*.mat');
        if ~isequal(file, 0) || ~isequal(path, 0)
            FileDirectory = strcat(path, file);
            fprintf("[DEBUG] Directory [ %s ]\n", FileDirectory);
            break;
        end
        warndlg('Insira um caminho e nome valido.','Warning');
    end
    
    save(FileDirectory, 'net');

end