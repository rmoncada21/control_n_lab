deltaT = Tiempo(2) - Tiempo(1)

% Objetos de datos
MotorCD_obj = iddata([Velocidad, Corriente], [Entrada], deltaT);
MotorCD_obj.inputname = {'Entrada'};
MotorCD_obj.outputname = {'Velocidad';'Corriente'};

% para obtener los modelos de verificación
systemIdentification
% tf1 se obtuvo se la herramiento de systemIdent
Modelo = zpk(tf1)
modeloVelocidad = Modelo(1,1)

% generar los impulsos de entrada
step(modeloVelocidad)