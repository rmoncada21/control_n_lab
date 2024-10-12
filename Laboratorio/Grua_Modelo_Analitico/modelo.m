%definir variables
masa_carro = 1000;
masa_carga = 2700;
longitud_brazo = 100;
g = 9.8;
%pos_carro = ;
%pos_carga = ;
%distancia_carro_carga = ;
%angulo = ;
%fuerza = ;

cte1 = (masa_carga * g)/masa_carro;
cte2 = ((masa_carga + masa_carro)*g)/(masa_carro*longitud_brazo);

cte3 = 1/masa_carro;
cte4 = 1/(masa_carro*longitud_brazo);

% Espacio de estados
MA = [0 1 0 0 ; 0 0 -cte1 0 ; 0 0 0 1 ; 0 0 -cte2 0];
MB = [0 ; cte3 ; 0 ; cte4];


% Obtención de la función de transferencia de posisción
MC1 = [1 0 0 0 ];
MD = [0];

[num, den] = ss2tf(MA, MB, MC1, MD);
sys_pos = tf(num, den);

% Respuesta al escalón
[y, t] = step(sys_pos);
figure;
plot(t, y, 'linewidth', 5);
title('Respuesta al escalón de la función de transferencia de posición');
xlabel('Tiempo (s)');
ylabel('Amplitud');
set(gca, 'fontsize', 27); % Establecer el tamaño de la fuente
legend('sys posición');
grid on;

% Respuesta al impulso
[ya, ta] = impulse(sys_pos);
figure;
plot(ta, ya, 'linewidth', 5);
title('Respuesta al impulso de la función de transferencia de posición');
xlabel('Tiempo (s)');
ylabel('Amplitud');
set(gca, 'fontsize', 27); % Establecer el tamaño de la fuente
legend('sys posición');
grid on;


% Obtención de la función de trasnferencia del ángulo
MC2 = [0 0 1 0 ];
MD = [0];

[num, den] = ss2tf(MA, MB, MC2, MD);
sys_angulo = tf(num, den);

% Respuesta al impulso 
[y2, t2] = step(sys_angulo);
figure;
plot(t2, y2, 'linewidth', 5);
title('Respuesta al escalón de la función de transferencia del ángulo');
xlabel('Tiempo (s)');
ylabel('Amplitud');
set(gca, 'fontsize', 27); % Establecer el tamaño de la fuente
legend('sys ángulo');


% Respuesta al impulso
[y2a, t2a] = impulse(sys_angulo);
figure;
plot(t2a, y2a, 'linewidth', 5);
title('Respuesta al impulso de la función de transferencia del ángulo');
xlabel('Tiempo (s)');
ylabel('Amplitud');
set(gca, 'fontsize', 27); % Establecer el tamaño de la fuente
legend('sys ángulo');
grid on;




% Coeficientes del polinomio característico
p = [1 0 0.392 0 0];

% Calcular el arreglo de Routh-Hurwitz
r = routh(p);

% Visualizar el arreglo resultante
disp('Arreglo de Routh-Hurwitz:');
disp(r);

% Verificar la estabilidad del sistema
if all(sign(r(:,1)) == sign(r(1,1)))
    disp('El sistema es estable según el criterio de Routh-Hurwitz.');
else
    disp('El sistema es inestable según el criterio de Routh-Hurwitz.');
end



%----------------------------------------------------------------------
% Obteniendo las funciones de transferencia a partir de 
% álgebra de matrices con la ecuación matricial

%sys_angulo = tf(num, den);


%MC = [1 0 0 0 ; 0 0 1 0];
%MD = [0 ; 0];

%[num, den] = ss2tf(MA, MB, MC, MD);
%sys_tf = tf(num, den);

%s=tf('s');
% G = C(Is -A)^-1*B + D

%MS = [1*s 0 0 0 ; 0 1*s 0 0 ; 0 0 1*s 0; 0 0 0 1*s];
%dentro = inv(MS - MA);

%G = MC*dentro*MB + MD
