function [m,theta]=tiporete(L,wcprogetto,phimprogetto)
%
% Assegnata la funzione di anello, la pulsazione di attraversamento di
% progetto ed il margine di fase di progetto ti dice che tipo di rete
% correttrice ti serve e ti fornisce il guadagno (amplificazione o
% attenuazione) e lo sfasamento che la rete correttrice deve fornire in
% corrispondenza della pulsazione di attraversamento di progetto
%

% valuta la risposta in frequenza della funzione di anello in
% corrispondenza della pulsazione di attraversamento di progetto

[gainL,phaseL]=bode(L,wcprogetto);

% calcola il margine di fase potenziale

phimpotenziale=180-abs(phaseL);

if ((gainL < 1) && (phimprogetto < phimpotenziale)) disp('Ti basta un guadagno in amplificazione');
    m=1/gainL;
    theta=0;
elseif ((gainL < 1) && (phimprogetto > phimpotenziale)) disp('Ti serve una rete anticipatrice');
    m=1/gainL;
    theta=phimprogetto-phimpotenziale+5;  % margine di sicurezza di 5 gradi
elseif ((gainL > 1) && (phimprogetto < phimpotenziale)) disp('Ti serve una rete attenuatrice');    
    m=1/gainL;
    theta=-5;  % ritardo inevitabile ma piccolo
elseif ((gainL > 1) && (phimprogetto > phimpotenziale)) disp('Ti serve una rete a sella o una rete attenuatrice-anticipatrice');    
    m=1/gainL;
    theta=phimprogetto-phimpotenziale+5;  % ritardo inevitabile ma piccolo
end;

