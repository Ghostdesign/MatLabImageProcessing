function [ d ] = distance(composantesA,composantesB)
%Cette fonction permet de calculer la distance qui separe de image à partir
%des parametres données qui sont chacune des matrices 3x3 qui representent
%les composantes E, V et S de chaque couleur (R G B) d'une image
%   
w1 = 0.2; %poids1
w2 = 0.3; %poids2
w3 = 0.5; %poids3

resultat = 0; 
%la distance se calcul par la somme des valeurs absolues de la diffence des
%deux matrices avec des poids affectés à chaque ligne
% D = ?_(i=1)^3(w_i1 |E_i-F_i |+w_i2 |?_i-?_i |+w_i3 |s_i-t_i |) 
for i = 1:3
   temp1 = abs(composantesA(1,i) - composantesB(1,i)); 
   temp2 = abs(composantesA(2,i) - composantesB(2,i));  
   temp3 = abs(composantesA(3,i) - composantesB(3,i));  
 
   resultat = resultat + (w1*temp1 + w2*temp2 + w3*temp3);
end

d = resultat; % retourne la distance