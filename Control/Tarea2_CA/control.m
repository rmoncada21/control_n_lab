%% Funcion en denominador y numerador

G_num = [1.0309];
G_den = [1 0.6247 1.0309];

% Obtener las matrices del espacio de estado
[A, B, C, D] = tf2ss(G_num, G_den);

% Otener 
G_tf = tf(G_num, G_den);
info = stepinfo(G_tf);

% Obtener el error de estado estacionario
Kp = dcgain(G_tf);
ess_original = 1 / (1 + Kp);
disp(['Error de estado estacionario original: ', num2str(ess_original)]);

%% Especificaciones deseadas
zeta = 0.5912;  % Amortiguamiento para un sobreimpulso del 10%
ts_original = info.SettlingTime;
ts_deseado = ts_original / 2;  % Reducir el tiempo de estabilización a la mitad
ess_deseado = ess_original / 10;  % Reducir el error de estado estacionario a una décima parte

% Frecuencia natural deseada
wn_deseado = 4 / (zeta * ts_deseado);  % Aproximación: ts ≈ 4 / (zeta * wn)

%% Parámetros del compensador de adelanto
alpha_lead = 0.1;  % Factor de adelanto (puede ajustarse)
phi_m_deseado = atan2(2*zeta, sqrt(1 - 2*zeta^2));  % Margen de fase deseado
w_max = wn_deseado / sqrt(1 - 2*zeta^2);  % Frecuencia de cruce de ganancia deseada

% Zeros y Polos del compensador de adelanto
tau_lead = 1 / (w_max * sqrt(alpha_lead));
z_lead = 1 / tau_lead;
p_lead = 1 / (alpha_lead * tau_lead);

% Crear el compensador de adelanto
C_lead = tf([tau_lead 1], [alpha_lead*tau_lead 1]);

%% Parámetros del compensador de atraso
beta_lag = 10;  % Factor de atraso (debe ser grande)
tau_lag = 10;  % Puede ajustarse

% Zeros y Polos del compensador de atraso
z_lag = 1 / tau_lag;
p_lag = 1 / (beta_lag * tau_lag);

% Crear el compensador de atraso
C_lag = tf([beta_lag*tau_lag 1], [tau_lag 1]);

%% Combinar los compensadores de adelanto y atraso
C_compensator = C_lead * C_lag;

% Sistema compensado
G_compensated = C_compensator * G_tf;


%% Realizar realimentación unitaria
G_closed_loop = feedback(G_compensated, 1);

% Obtener las características del sistema compensado
info_compensated = stepinfo(G_closed_loop);
disp(info_compensated);

% Obtener el error de estado estacionario compensado
Kp_compensated = dcgain(G_closed_loop);
ess_compensated = 1 / (1 + Kp_compensated);
disp(['Error de estado estacionario compensado: ', num2str(ess_compensated)]);

% Mostrar la respuesta escalón del sistema original y compensado
figure;
step(G_tf, 'r--', G_closed_loop, 'b');
legend('Sistema Original', 'Sistema Compensado');
title('Respuesta Escalón');

% Mostrar el diagrama de Bode del sistema original y compensado
figure;
bode(G_tf, 'r--', G_compensated, 'b');
legend('Sistema Original', 'Sistema Compensado');
title('Diagrama de Bode');
