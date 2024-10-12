clear

%% función de transferencia
s = tf('s');

f_num = [1.031];
f_den = [1 0.6247 1.0301];
f = tf(f_num, f_den);

%%

gs = ((407)*(s+0.916))/((s+1.27)*(s+2.69));
zpk(gs);
gs_ss = ss(gs);

%% 

gs1_num = [407, 372.8]; 
gs1_den = [1, 3.96, 3.416];
gs1 = tf(gs1_num, gs1_den);

[a, b, c, d] = tf2ss(gs1_num, gs1_den);

%% matriz de controlabilidad
OM = [c, c*a]';


%% matrices 

T = (105.69)/(s^3 + 101.2492*s^2 + 125.9769*s + 105.69);

%% graficas

step(f);

hold on; % Mantener la gráfica actual

% Ajustar el grosor de la línea
h = findobj(gca, 'Type', 'line'); % Obtener el objeto de línea
set(h, 'LineWidth', 5); % Grosor de la línea

% Ajustar el tamaño de las etiquetas
title('Respuesta al escalón del sistema sin compensar ', 'FontSize', 30); % Tamaño del título
xlabel('Tiempo', 'FontSize', 30); % Tamaño de la etiqueta del eje x
ylabel('Respuesta', 'FontSize', 30); % Tamaño de la etiqueta del eje y
set(gca, 'FontSize', 30); % Tamaño de las etiquetas del eje

figure;
f = feedback(f, 1);
step(f);

hold on; % Mantener la gráfica actual

% Ajustar el grosor de la línea
h = findobj(gca, 'Type', 'line'); % Obtener el objeto de línea
set(h, 'LineWidth', 5); % Grosor de la línea

% Ajustar el tamaño de las etiquetas
title('Respuesta del sistema no compensando retroalimentado', 'FontSize', 30); % Tamaño del título
xlabel('Tiempo', 'FontSize', 30); % Tamaño de la etiqueta del eje x
ylabel('Respuesta', 'FontSize', 30); % Tamaño de la etiqueta del eje y
set(gca, 'FontSize', 30); % Tamaño de las etiquetas del eje


%% compensado

step(T);

hold on; % Mantener la gráfica actual

% Ajustar el grosor de la línea
h = findobj(gca, 'Type', 'line'); % Obtener el objeto de línea
set(h, 'LineWidth', 5); % Grosor de la línea

% Ajustar el tamaño de las etiquetas
title('Respuesta al escalón del sistema compensado', 'FontSize', 30); % Tamaño del título
xlabel('Tiempo', 'FontSize', 30); % Tamaño de la etiqueta del eje x
ylabel('Respuesta', 'FontSize', 30); % Tamaño de la etiqueta del eje y
set(gca, 'FontSize', 30); % Tamaño de las etiquetas del eje


figure;
T = feedback(T, 1);
step(T);

hold on; % Mantener la gráfica actual

% Ajustar el grosor de la línea
h = findobj(gca, 'Type', 'line'); % Obtener el objeto de línea
set(h, 'LineWidth', 5); % Grosor de la línea

% Ajustar el tamaño de las etiquetas
title('Respuesta al escalón del sistema compensando retroalimentado', 'FontSize', 30); % Tamaño del título
xlabel('Tiempo', 'FontSize', 30); % Tamaño de la etiqueta del eje x
ylabel('Respuesta', 'FontSize', 30); % Tamaño de la etiqueta del eje y
set(gca, 'FontSize', 30); % Tamaño de las etiquetas del eje


%% informacion 

stepinfo(f)
ff = feedback(f, 1);
stepinfo(ff)

stepinfo(T)
Tf = feedback(T, 1);
stepinfo(Tf)

%% 
d = (s+4)/((s+1)*(s+2)*(s+5))
d = zpk(d)
ss(d)