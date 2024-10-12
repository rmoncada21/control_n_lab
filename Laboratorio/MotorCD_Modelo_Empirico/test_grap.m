%verificar el modelo graficamente

y = lsim(modelo_velocidad_P1,VELOCIDAD_final, Tiempo1);
plot(Tiempo1, REFERENCIA_final, Tiempo1, VELOCIDAD_final, Tiempo1,  y);
grid;
title('Verificación de la respuesta del modelo de Velocidad')
xlabel('Tiempo [s]')
ylabel('Velocidad')
legend('Entrada','Velocidad','Modelo')