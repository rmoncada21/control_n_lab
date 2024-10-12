delta = Tiempo(2)-Tiempo(1);

pamh = iddata([ANGULO], [ESTIMULO], delta);
pamh.inputname = {'ESTIMULO'};
pamh.outputname = {'ANGULO'};

%systemIdentification

%%% verificar el modelo graficamente
%%% gráfica para obtener los datos de la ecuación canonica

%plot(Tiempo, ANGULO)


%%% Comparación gráfica 
%%% comparar ANGULO con modelo_tf2
y2 = lsim(tf2, ESTIMULO, Tiempo);
y7 = lsim(tf7, ESTIMULO, Tiempo);


%figure;
plot(Tiempo, ANGULO, Tiempo, y2, Tiempo, y7)
h = findobj(gca, 'Type', 'line');
% Grosor de la línea
set(h, 'LineWidth', 3);
% Ajustar el tamaño de las etiquetas
title('Lugar de las raices de la función de transferencia G', 'FontSize', 16);
xlabel('Eje x', 'FontSize', 16);
ylabel('Eje y', 'FontSize', 16);
set(gca, 'FontSize', 40); 
legend('ANGULO','modelo tf2', 'modelo tf7')


% Gráfica usada para la comprobación escrita del modelo
figure;
plot(Tiempo, y2)
h = findobj(gca, 'Type', 'line');
% Grosor de la línea
set(h, 'LineWidth', 3);
% Ajustar el tamaño de las etiquetas
title('Modelo Empírico', 'FontSize', 16);
xlabel('Tiempo', 'FontSize', 16);
ylabel('Posición', 'FontSize', 16);
set(gca, 'FontSize', 35); 
legend('angulo')



