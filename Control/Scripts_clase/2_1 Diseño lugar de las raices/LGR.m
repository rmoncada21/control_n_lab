%Ejemplo Lugar de las raices 1
clc
close all
clear all
% Generar la función de transferencia
num = [1 0.2 ];
den = [1 0.04 0.0025];
G = tf(num, den);
rlocus(G);
hold on

% Dibujar el limite real del sistema
sigma_required = 0.23;
plot([-sigma_required -sigma_required], [-0.25 0.25], "r-", "LineWidth", 3)

% Dibujar los limites en la sección imaginaria
omega_required = 0.1;
plot([-0.8 0.1], [omega_required omega_required], "g-", "LineWidth", 3)
plot([-0.8 0.1], [-omega_required -omega_required], "g-", "LineWidth", 3)

%Dibujar las especificación del sobreimpulso del sistema
% por defecti MATLAB trabaja en radianes
theta_required = 66.9*pi/180;
plot([-0.8 0], [-tan(omega_required)*0.8 0], "b-", "LineWidth", 3)
plot([-0.8 0], [tan(omega_required)*0.8 0], "b-", "LineWidth", 3)