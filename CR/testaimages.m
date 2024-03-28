imgres = [25 25];
targetToText = ["circle" "kite" "parallelogram" "square" "trapezoid" "triangle"];
load('TrainAll.mat');

for i = 1:length(targetToText)
    Directory = '.\NN_Tema1_images\test\' + targetToText(i);
    % Read images from Images folder
    images = dir(fullfile(Directory, '*.png'));

    for j = 1:length(images)
        image = imread(fullfile(Directory, images(j).name));  % Read image
        image = imresize(image, imgres);
        binarizedImg = imbinarize(image);

        imageVector1 = (binarizedImg( : ));

        
        y = sim(net, imageVector1);
        maxY = max(y);
        if maxY >= 0.5
            MaxT = find(y == maxY);
            fprintf("%s %d     Image: %s\n", targetToText(i), j, targetToText(MaxT));
        else
            MaxT = 0;
            fprintf("%s %d     Image: NULLLLLLLLL\n", targetToText(i), j);
        end
        
%         y = y>=0.5;
%         t = find(y == 1);
        
    end
end