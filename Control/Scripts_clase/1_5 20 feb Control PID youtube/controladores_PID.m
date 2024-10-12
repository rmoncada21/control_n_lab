s = tf('s');

% Función de transferencia
G = (3*s)/(4*s^2+3*s+2)
step(G)
hold on 

% Añadiendo retroalimentación/lazo cerrado
modelo = feedback(G,1)
step(modelo)

% sintonizador
%descomentar de ser neceserio
%pidTuner;
compensador = C
F = C *G
L =  feedback(F, 1)
step(L)
hold on 
step(G)
sisotool('rlocus', G)