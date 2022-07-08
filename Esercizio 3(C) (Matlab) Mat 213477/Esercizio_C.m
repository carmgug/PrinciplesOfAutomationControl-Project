clear;close all;
s=zpk('s');

G=1/((0.2*s+1)^3)


%----Precisione Statica---%
%C_s deve essere di struttura semplice e G non presenta effetti integrali%
%e_p,infinity=1/1+kp<0.30 ove kp=costante di posizione%

%Il soddisfacimento della richiesta è possibile senza l'aggiunta di effetti
%integrali?%

C_s=3

L=series(C_s,G)


margin(L)

[Gm,phim,wpi,wc]=margin(L)

[modulo,argomento]=bode(L,wc)

%Vale Il Crierio Di bode,quindi il soddisfacimento della richiesta statica
%è possibile senza ulteriori aggiunte.


%----Precisione Dinamica---%
%Ipotizziamo che il sistema si approssimi come un sistema del II ordine in 
%media frequenza allora:

%Determiniamo il Delta_Cr in funzione della massima Sovraelongazione%
Delta_cr=smorz_S(0.2)
%Attenzione : Smorzamento e Massima sovraelongazione sono inversamente
%proporzionali%

%Il margine di fase è approssimabile al valore
MPhi_Cr=100*(Delta_cr)

%Ricorda: T_s=3/Delta*Pulsazione_Naturale
%è richiesta un T_s<=1
Wn_cr=3/Delta_cr*1

%il rapporto banda-passante,Pulsazione naturale -> Dipende da
%Delta(Smorzamento)

Wbw_cr=Wn_cr*wBwn(Delta_cr)

%La pulsazione di attraversamento è minore o uguale della banda passante
%Quindi imponiamo una pulsazione di attraversamento maggiore 8.68
Wc_new_cr=9 %(rad/s)

%Ricordiamo che il margine di fase deve essere maggiore di Mphi_Cr=45.59

%In corrispondenza della nuova pulsazione di attraversamento cosa
%otteniamo?%


[modulo_new,argomento_new]=bode(L,Wc_new_cr)

tiporete(L,Wc_new_cr,MPhi_Cr)

%Abbiamo bisogno di una rete anticipatrice, per riuscire, nell'intorno
%della pulsazione di attraversamento di progetto ,ad amplificare sul modulo
%e anticipare sulla fase


gamma=MPhi_Cr-(180-abs(argomento_new))+20;

[alpha,T_costante]=anticipo(Wc_new_cr,(1/modulo_new),gamma);

tau1=T_costante
tau2=alpha*T_costante


C_lead=(1+s*tau1)/(1+s*tau2)

%Inseriamo in Cascara C_lead%
C=series(C_s,C_lead)

%La nuova funzione d'anello sarà:%
L_new=series(C,G)

close all;
figure('Name','Comparazione Funzione di Anello Compensata/Non Compensata','NumberTitle','off');
    legend('show');
    hold on;
    margin(L)
    margin(L_new)
    hold off;

[gainL,phaseL]=bode(L_new,Wc_new_cr)

phimpotenziale=180-abs(phaseL)

%Siamo giunti a una rete che rispetta le specifiche%
%modulo pari ad 1 e margine di fase potenziale 65>45.59
%Obbiettivo raggiunto%

T=feedback(L_new,1)

figure('Name','Risposta al gradino del sistema retroazionato','NumberTitle','off');
    step(T)

parametri_risposta = stepinfo(T)

%Massima Sovraelongazione del 20.2% e tempo di assestamento pari a 0.67 sec

figure('Name','Mappa Poli/Zeri','NumberTitle','off');
    pzmap(T)








