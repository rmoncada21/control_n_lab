%% Crear objeto Grua con iddata
% salida, entrada, tiempo
delta_tiempo = Tiempo(2)-Tiempo(1);

Grua = iddata([ANGULO,POSICION], Entrada, delta_tiempo);
Grua.inputname = {'Entrada'};
Grua.outputname = {'ANGULO';'POSICION'};

%% Usar systemIdentification para obtener modelos SISO

% systemIdentification;

% obtener el modelo de posicion de P1_pos
modelo_pos = zpk(P1_pos(2))

% obtener el modelo de angulo de tf1_ang
% modelo_ang = zpk(tf1_ang(1));
modelo_ang = zpk(P2ZU100(1))

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

modelo_pos_ss = ss(MAP, MBP, MCP, MDP)
% comprobación de modelo
modelo_pos
zpk(modelo_pos_ss)

%% Modelo SISO Ángulo

% Matrices obtenidas de la FT modelo_ang
MAA = [0 1 ; -35.3 -0.006019];
MBA = [0 ; 1];
MCA = [-0.03386 -0.48525];
MDA = [0];

modelo_ang_ss = ss(MAA, MBA, MCA, MDA)

% comprobación de modelo
modelo_ang
zpk(modelo_ang_ss)

% la salida de posición del péndulo no es exactamente ninguna variable de estado por
% lo que se debe realizar la transformación de este modelo SISO a FCC

%% Obtener la funcion canonica observable del angulo

modelo_ang_FCO = canon(modelo_ang_ss, 'companion')

modelo_ang_FCC = modelo_ang_ss;

modelo_ang_FCC.A = modelo_ang_FCO.A';
modelo_ang_FCC.B = modelo_ang_FCO.C';
modelo_ang_FCC.C = modelo_ang_FCO.B';

modelo_ang_FCC


%% Obtener la función SIMO del sistema

MAG = [0 0 1 0 ; 0 0 0 1 ; 0 0 -9.242 0 ; 0 -35.3 0 -0.006019];
% Agregar directo la variable
%MBG = [0 ; -0.48525; 0.22619 ; modelo_ang_FCC.B(2)];
MBG = [0 ; -0.48525; 0.22619 ; -0.03094];
MCG = [1 0 0 0 ; 0 1 0 0];
MDG = [0];
%MCGN = [1 0 0 0];

grua_simo = ss(MAG, MBG, MCG, MDG)
zpk_grua_simo = zpk(grua_simo);



%% Pasar a SISO para verificar 

% Obtener la función de transferencia de la posición
grua_pos = ss(MAG, MBG, MCG(1,:), MDG);
zpk_grua_pos = zpk(grua_pos);

% Obtener la función de transferencia del ángulo
grua_ang = ss(MAG, MBG, MCG(2,:), MDG);
zpk_grua_ang = zpk(grua_ang);

%% Estimación de la matriz As, Bs (matrices aumentadas) -> K s LQR(As,Bs,Q,R,N)  (ver imagen)
% Construir Matrices Aumentadas tomando MGC con una unica salida

% Cambiar el numero de fila dependiendo de la TF de salida
As_pos = [MAG [0; 0 ; 0; 0] ; -MCG(1,:) 0];
As_ang = [MAG [0; 0 ; 0; 0] ; -MCG(2,:) 0];

Bs = [MBG ; 0 ];

% Matriz Mx de controlabilidad
Mx = [MAG, MBG; MCG(1,:), MDG];
rank(Mx);

% Matrices inicialmente de UNO's (indican los pesos que se les quieren dar
% a las variables de estados posiscion, angulo, velocidad lineal, velocida angular, 
% integral del error) -> Ki
Q = eye(5);
R = 1;

% Encontrar LQR Ks: matriz K aumentada
[Ks, S, e] = lqr(As, Bs, Q, R);
K = Ks(1:4)
Ki = Ks(5);


% Obtener los valores propios
valores_propios_pos = eig(As_pos - Bs*Ks);

%% ubicacion de polos -> place (acker SIMO)


