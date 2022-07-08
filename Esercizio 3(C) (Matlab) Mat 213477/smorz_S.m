function delta = smorz_S( S )
% Calcola lo smorzamento corrispondente ad una data sovraelongazione

delta = 1/sqrt(1+(pi/log(S))^2);

end

