function [ D ] = getDistances(image2search,EVS_DB,nfiles)
% Cette fonction retourne un tableau de struc avec le nom de chaque 
%image de la base de données (EVS) associé à la distance qui la separe de
%l'image selectionée (l'image à recherche "image2search").

%Traitement de l'image selectionnée

I = double(imread(image2search));

%Extraction des differant canaux de l'image selectionnée
I_R(1).data = I(:,:,1);
I_G(1).data = I(:,:,2);
I_B(1).data = I(:,:,3);

%Matrice qui contiendra les composants E V S de l'image selectionnée
matriceEVS = zeros(3:3);

%Calcule des composantes de l'image selectionnée
matriceEVS(1,1) = mean(I_R(1).data(:));
matriceEVS(1,2) = mean(I_G(1).data(:));
matriceEVS(1,3) = mean(I_B(1).data(:));

matriceEVS(2,1) = var(I_R(1).data(:));
matriceEVS(2,2) = var(I_G(1).data(:));
matriceEVS(2,3) = var(I_B(1).data(:));

matriceEVS(3,1) = moment(I_R(1).data(:),3);
matriceEVS(3,2) = moment(I_G(1).data(:),3);
matriceEVS(3,3) = moment(I_B(1).data(:),3);

%Calcule les distances et les sauvegardes dans une structure contenat la distance et le
%nom de chaque image
for k = 1:nfiles
    D(k).dist = distance(matriceEVS,EVS_DB(k).data);
    D(k).name = EVS_DB(k).name;
end

%Trie selon la distance et retourne un tableau de structure avec les nom des
%images et les distances
 [tmp ind]=sort([D.dist]);
 D=D(ind);

