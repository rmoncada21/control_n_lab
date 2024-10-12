clear
% Datos del sistema original
G_num = [1.0309];
G_den = [1, 0.6247, 1.0309];

G_tf1 = tf(G_num, G_den);

% Representación en espacio de estados
[A, B, C, D] = tf2ss(G_num, G_den);

% Parámetros de desempeño
M_p = 0.10;
T_s_original = 4 / (0.8 * sqrt(1 - 0.8^2));  % Estimación inicial del tiempo de estabilización original
T_s_desired = T_s_original / 2;  % Nuevo tiempo de estabilización deseado

% Resolver para zeta
solve_zeta = @(M_p) fzero(@(zeta) exp(-zeta * pi / sqrt(1 - zeta^2)) - M_p, 0.6);
zeta = solve_zeta(M_p);

% Calcular omega_n deseado
omega_n_desired = 4 / (zeta * T_s_desired);

% Polos deseados para el controlador
poles_controlador = [-zeta * omega_n_desired + 1j * omega_n_desired * sqrt(1 - zeta^2), ...
                     -zeta * omega_n_desired - 1j * omega_n_desired * sqrt(1 - zeta^2)];

% Ganancias del controlador
K = acker(A, B, poles_controlador);

% Polos del observador (más rápidos que los del controlador)
poles_observador = 2 * poles_controlador;
L = acker(A', C', poles_observador)';

% Nuevo sistema en espa  cio de estados con compensador y observador
A_aug = [A - B * K, B * K; zeros(size(A)), A - L * C];
B_aug = [B; zeros(size(B))];
C_aug = [C, zeros(size(C))];
D_aug = D;

% Simulación de la respuesta del sistema
sys_aug = ss(A_aug, B_aug, C_aug, D_aug);

% Respuesta al escalón
t = 0:0.01:10;
[y, t] = step(sys_aug, t);

% Graficar la respuesta
plot(t, y)
title("Respuesta al Escalón del Sistema Compensado")
xlabel("Tiempo (s)")
ylabel("Amplitud")
grid on

% Verificar el error en estado estacionario
ess = abs(1 - y(end))