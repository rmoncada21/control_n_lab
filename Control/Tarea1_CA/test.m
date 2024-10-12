s=tf('s')
G_feedback = feedback(G,1)
sys = G_feedback*compensador;

step(sys);
info = stepinfo(G_feedback*compensador)

hold on; % Mantener la gráfica actual

% Ajustar el grosor de la línea
h = findobj(gca, 'Type', 'line'); % Obtener el objeto de línea
set(h, 'LineWidth', 5); % Grosor de la línea

% Ajustar el tamaño de las etiquetas
title('Respuesta al escalón del sistema a lazo cerrado', 'FontSize', 25); % Tamaño del título
xlabel('Tiempo', 'FontSize', 25); % Tamaño de la etiqueta del eje x
ylabel('Respuesta', 'FontSize', 25); % Tamaño de la etiqueta del eje y
set(gca, 'FontSize', 25); % Tamaño de las etiquetas del eje