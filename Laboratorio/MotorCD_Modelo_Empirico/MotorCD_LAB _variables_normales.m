delta_tiempo = Tiempo(2)-Tiempo(1);


% para llamar el toolbox de system identification de 
% necesita crear un objeto de datos
MotorCD = iddata([velocidadf, corrientef], [entradaf], delta_tiempo);
MotorCD.inputname = {'ENTRADA'};
MotorCD.outputname = {'Velocidad';'CORRIENTE'};

%systemIdentification

% Los modelos obtenidos se puede apreciar en PM1 y tf1 del
% workspace (archivo: workspace_variables.mat)

% transfer function
M_tf1 = zpk(tf1);
% Process models
M_PM1 = zpk(P11);

% obtener el modelo de velocidad de process model PM1
modelo_velocidad_tf1 = tf1(1,1);
modelo_velocidad_PM1 = PM1(1,1);
% nuevo modelos con 95% 
modelo_velocidad_P11 = P11(1,1);




% verificar el modelo graficamente

%y = lsim(modelo_velocidad_PM1, ENTRADA, Tiempo);
%plot(Tiempo, ENTRADA, Tiempo, VELOCIDAD, Tiempo,  y);
%grid;
%title('Verificación de la respuesta del modelo de Velocidad')
%xlabel('Tiempo [s]')
%ylabel('Velocidad')
%legend('Entrada','Velocidad','Modelo')


% Diseñar regulador PI (compensador) usando Sisotool
sisotool('rlocus', modelo_velocidad_P11)