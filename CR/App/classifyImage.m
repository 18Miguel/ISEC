function [result,clas] = classifyImage(network, imageToCheck)
    %%
    load(network);

    %%
    image = imread(imageToCheck);
    imgres = [25 25];
    image = imresize(image, imgres);
    binarizedImg = imbinarize(image);
    imageVector1 = (binarizedImg( : ));
    
    %%
    targetToText = ["circle" "kite" "parallelogram" "square" "trapezoid" "triangle"];
    y = sim(net, imageVector1);
    clas = y;
    MaxY = max(y);
    if MaxY >= 0.5
        MaxT = find(y == MaxY);
        result = targetToText(MaxT);
        %fprintf("%s %d     Image: %s\n", targetToText(i), j, targetToText(MaxT));
        return;
    else
        result = "A rede não conseguiu classificar a imagem.";
        %fprintf("%s %d     Image: NULLLLLLLLL\n", targetToText(i), j);
        return;        
    end
end