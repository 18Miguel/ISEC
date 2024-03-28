function [result] = testImagesGUI(network,dataset)
    [~, fType,~] = fileparts(dataset);
    
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
    accuracy_overall_stack = [];
    targetToText = ["circle" "kite" "parallelogram" "square" "trapezoid" "triangle"];
    imgres = [25 25];
    inputs = [];
    k = 0;

     for i = 1:length(targetToText)
        Directory = strcat(dataset + "\", targetToText(i));
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

    load(network); %carrega a rede neuronal
    y = sim(net, inputs); % Simula

    r=0;
        for i=1:size(y,2)             % Para cada classificacao
            [a b] = max(y(:,i));      %b guarda a linha onde encontrou valor mais alto da saida obtida
            [c d] = max(target(:,i)); %d guarda a linha onde encontrou valor mais alto da saida desejada
            if b == d                 % se estao na mesma linha, a classificacao foi correta (incrementa 1)
                r = r+1;
            end
        end
    
        accuracy = r/size(y,2)*100;
        fprintf('Precisao total %f\n', accuracy);
        result = accuracy;

end






