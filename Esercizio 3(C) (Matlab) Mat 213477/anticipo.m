function [alpha,T]=anticipo(wc,m,phi)
%
% Calcola i parametri della rete
% anticipatrice
% I parametri della funzione sono:
% wc  : pulsazione di attraversamento desiderata
% m   : reciproco del modulo della funzione di anello non-compensata |L(j wc)|
% phi : incremento sulla fase desiderato in gradi
%

mod=m;

alpha=(mod*cos(phi*pi/180)-1)/(mod*(mod-cos(phi*pi/180)));

if alpha<0 disp('Non puoi progettare la rete con i parametri proposti!');
           alpha=[];
           T=[];
           return;
else
    T=(1/wc)*sqrt((1-mod^2)/(alpha^2*mod^2-1));
end;