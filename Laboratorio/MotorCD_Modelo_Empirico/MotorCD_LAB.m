delta_tiempo = Tiempo(2)-Tiempo(1);


% para llamar el toolbox de system identification de 
% necesita crear un objeto de datos
MotorCD = iddata([VelocidadF, CorrienteF], [EntradaF], delta_tiempo);
MotorCD.inputname = {'ENTRADA'};
MotorCD.outputname = {'VELOCIDAD';'CORRIENTE'};

%systemIdentification

% Los modelos obtenidos se puede apreciar en PM1 y tf1 del
% workspace (archivo: workspace_variables.mat)

% transfer function
M_tf1 = zpk(tf1);
% Process models
M_P1 = zpk(P1);

% obtener el modelo de velocidad de process model PM1
modelo_velocidad_tf1 = M_tf1(1,1);
modelo_velocidad_P1 = M_P1(1,1);


% verificar el modelo graficamente

%y = lsim(modelo_velocidad_P1, EntradaF, Tiempo);
%plot(Tiempo, EntradaF, Tiempo, VelocidadF, Tiempo,  y);
%grid;
%title('Verificación de la respuesta del modelo de Velocidad')
%xlabel('Tiempo [s]')
%ylabel('Velocidad')
%legend('Entrada','Velocidad','Modelo')


% Diseñar regulador PI (compensador) usando Sisotool
%sisotool('rlocus', modelo_velocidad_P1)


% Una vez diseñaso el regulador; obtener los valores de Kp, Ki
% Descomposición en parelelo
% Obtener 
C;
a = [1.1926 16.1001]
b = [1 0]
[ki,kd,kp] = residue(b,a)

% segunda forma 
%n1=kp n2=ki no hay kd
[n,d] = tfdata(C, 'v')