% obtener el modelo de posicion de P1_pos
modelo_pos = zpk(P1_pos(2))

% segudno modelo de posiscion
%modelo_pos2 = zpk(P1I_pos(2))

% obtener el modelo de angulo de tf1_ang
modelo_ang = zpk(tf1_ang(1))

%% Modelado en el espacio de estados

MA = [0 1 ; 0 -9.242]
MB = [0 ; 0.22619]
MC = [1 0]
MD = 0;

modelo_pos_ss = ss(MA, MB, MC, MD)


