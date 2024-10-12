%% Crear objeto Grua con iddata
% salida, entrada, tiempo
delta_tiempo = Tiempo(2)-Tiempo(1);

Grua = iddata([ANGULO,POSICION], Entrada, delta_tiempo);
Grua.inputname = {'Entrada'};
Grua.outputname = {'ANGULO';'POSICION'};

%% Usar systemIdentification para obtener modelos SISO

% systemIdentification;

% obtener el modelo de posicion de P1_pos
modelo_pos = zpk(P1_pos(2));

% segudno modelo de posiscion
modelo_pos2 = zpk(P1I_pos(2));

% obtener el modelo de angulo de tf1_ang
modelo_ang = zpk(tf1_ang(1));

%% Graficar el sistema

% Graficar el sistema Posición
yp = lsim(modelo_pos, Entrada, Tiempo);
plot_function(Tiempo, yp , 3,'Modelo de posición' ,16 ,'modelo posición');

% Graficar el sistema Angulo
ya = lsim(modelo_ang, Entrada, Tiempo);
plot_function(Tiempo, ya , 3,'Modelo de angulo' ,16 ,'modelo angulo');


%% Obtener el modelo SISO del sistema

%% Modelado SISO Posición

% Matrices obtenidas de la FT modelo_pos
MAP = [0 1 ; 0 -9.242];
MBP = [0 ; 0.22619];
MCP = [1 0];
MDP = [0];

modelo_pos_ss = ss(MAP, MBP, MCP, MDP);
% comprobación de modelo
modelo_pos;
zpk(modelo_pos_ss);

%% Modelo SISO Ángulo

% Matrices obtenidas de la FT modelo_ang
MAA = [0 1 ; -35.33 -0.009013];
MBA = [0 ; 1];
MCA = [(-0.31073*1.546) -0.31073];
MDA = [0];

modelo_ang_ss = ss(MAA, MBA, MCA, MDA);

% comprobación de modelo
modelo_ang;
zpk(modelo_ang_ss);

% la salida de posición del péndulo no es exactamente ninguna variable de estado por
% lo que se debe realizar la transformación de este modelo SISO a FCC

%% Obtener la funcion canonica observable del angulo

modelo_ang_FCO = canon(modelo_ang_ss, 'companion');

modelo_ang_FCC = modelo_ang_ss;

modelo_ang_FCC.A = modelo_ang_FCO.A';
modelo_ang_FCC.B = modelo_ang_FCO.C';
modelo_ang_FCC.C = modelo_ang_FCO.B';

modelo_ang_FCC;


%% Obtener la función SIMO del sistema

MAG = [0 0 1 0 ; 0 0 0 1 ; 0 0 -9.242 0 ; 0 -35.33 0 -0.009013];
MBG = [0 ; -0.3107 ; 0.22619 ; -0.4776];
MCG = [1 0 0 0 ; 0 1 0 0];
MDG = [0];
% MCG = [1 0 0 0];
% MCG = [0 1 0 0];

grua_simo = ss(MAG, MBG, MCG, MDG);











