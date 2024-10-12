%% 1-El script deberá contener como entradas la planta del sistema, 
% las condiciones de sobreimpulso máximo y tiempo de estabilización

% Agregar los valores de vectores con espacios en vez comas
disp('Agregar la función de transferencia en forma de vectores, numerador y denominador');
disp('Ingrese los numeros separados por espacios. Use parentesis cuadrados ejemplo; [a b]');
disp('Para el denominador agregar los valores en forma de ecuación caracteristica a*s^2+b*s+c');

num = input('Ingrese el vector numerador: ');
den = input('Ingrese el vector denominador: ');

% Generar la función de transferencia
G = tf(num, den);
disp('La función de transferencia es: ');
display(G);

disp('Ingrese los requerimientos del sistema ');
sobreimpulso = input('Ingrese el valor del sobreimpulso en formato 100% (sin el signo): ');
tiempo_estabilizacion = input('Ingrese el valor del tiempo de estabilización: ');

%% 2-El script deberá calcular: Los ángulos de salida, el factor de 
% amortiguamiento, la frecuencia natural del sistema y graficarlos 
% en el lugar de las raíces para determinar el área donde ubicar 
% el punto para la estimaci´osn del compensador

% Calcular el factor de amortiguamiento
factor_amortiguamiento = calcular_factor_amortiguamiento(sobreimpulso);
disp('El factor de amortiguamiento es: ');
disp(factor_amortiguamiento);
% Calcular ángulo de salida
angulo_salida = calcular_angulo_salida(factor_amortiguamiento);
disp('El ángulo de salida (grados) es de: ');
disp(angulo_salida);

% Calcular la frecuencia natural
frecuencia_natural = calcular_frecuncia_natural(tiempo_estabilizacion, angulo_salida);
disp('La frecuencia natural del sistema es de: ');
disp(frecuencia_natural);

% Graficar los resultados del LGR 
disp('Graficando el lugar de las raices: ')
rlocus(G);
plot_angulo_salida(180, angulo_salida);
plot_angulo_salida(180, -angulo_salida);

% Ajustar el grosor de la línea
% Obtener el objeto de línea
h = findobj(gca, 'Type', 'line');
% Grosor de la línea
set(h, 'LineWidth', 3);

% Ajustar el tamaño de las etiquetas
title('Lugar de las raices de la función de transferencia G', 'FontSize', 16);
xlabel('Eje x', 'FontSize', 16);
ylabel('Eje y', 'FontSize', 16);
set(gca, 'FontSize', 14); 

% graficar linea vertical
%plot(-5);

% Trabajar con el punto de operacion seleccionado 
% Pedir los datos al usuario para obtener el punto de operacion
disp('Observe el gráfica y defina un punto de operacion válido ');
punto_operacion_real = input('Ingrese la parte real del punto de operacion ');
punto_operacion_imaginario = input('Ingrese la parte imaginaria del punto de operacion ');

punto_operacion = punto_operacion_real + 1i*punto_operacion_imaginario;

%% 3-Dada la selección de un punto de operación deseado, que será una entrada en el script, calcular:
% a) Angulo de salida ´
% b) Angulo por compensar

% Calcular la ganancia K
polos = pole(G);
zeros = zero(G);

valor_k_polos = calcular_ganancia_k_polos(polos, punto_operacion);
valor_k_zeros = calcular_ganancia_k_zeros(zeros);
K = valor_k_polos/valor_k_zeros;
disp('La ganancia es de ');
display(K);

% 4. Basado en el método de cancelación de polos (que deberá ser una entrada del script
% también), deberá calcular:
% a. El polo y cero del compensador de adelanto
% b. La ganancia estándar del compensador.

% Ángulo por compensar
% angulo_compensado es un vector de 2 posiciones (180+angulo, -180+angulo)
angulo_compensado = calcular_angulo_compensado(K, G, punto_operacion);
disp('El ángulo compensado es de: ');
display(angulo_compensado);

% Calcular el nuevo polo usando el angulo compensado y el punto de operacion
agregar_polo = (punto_operacion_imaginario/tand(angulo_compensado(1))) + punto_operacion_real;
disp('El polo del compensador se ubica en: ');
display(agregar_polo);


% Pedir un cero que cancele un polo
agregar_zero = input('Ingresar el zero que desea agregar para cancelar el polo (s + zero=0 -> s=-zero): ');
indice = find(agregar_zero);
% se borra el polo
polos(indice) = [];
nuevo_numG = poly(zeros);
nuevo_denG = poly(polos);


nuevoG = tf(nuevo_denG, K*nuevo_numG);
Kcompensador = evalfr(nuevoG, punto_operacion);
Kmagnitud = abs(Kcompensador);

disp('Ganancia del compensador ');
display(Kmagnitud);

num_compensador = [1 (-1*agregar_zero)];
den_compensador = [1 agregar_polo];
compensador = tf(num_compensador, den_compensador);
compensador = Kmagnitud*compensador;

disp('Compensador diseñado');
display(compensador);

%% Funciones para el script

function sigma = calcular_factor_amortiguamiento(percent_overshoot)
    sigma = -log(percent_overshoot/100) / sqrt(pi^2 + log(percent_overshoot/100)^2);
end

function cita_salida = calcular_angulo_salida(factor_amortiguamiento)
    cita_salida = atand(sqrt(1 - factor_amortiguamiento^2) / factor_amortiguamiento);
end

function omega_natural = calcular_frecuncia_natural(tiempo_estabilizacion, angulo_salida)
    omega_natural = 4/(angulo_salida*tiempo_estabilizacion);
end

function cita_compensado = calcular_angulo_compensado(K, funcion_transferencia, punto_operacion)
    nueva_funcion_transferencia = K*funcion_transferencia;
    valor_evaluado = evalfr(nueva_funcion_transferencia, punto_operacion);
    fase_rad = angle(valor_evaluado);
    cita_compensado = [180+rad2deg(fase_rad), -180+rad2deg(fase_rad)];
end

% Funciones para calcular la ganancia K
function valor_k_polos = calcular_ganancia_k_polos(polos1, punto_operacion)
    polos_actualizado = [polos1; punto_operacion];
    parte_real_polos = real(polos_actualizado);
    parte_img_polos = imag(polos_actualizado);
    
    for i = 1:(length(polos_actualizado)-1)
        valor_k_polos =+ sqrt(power((abs(parte_real_polos(i)) - abs(parte_real_polos(i+1))+ ...
            abs(parte_img_polos(i)) - abs(parte_img_polos(i+1))), 2));
    end
    % valor_k = valor_k_polos / valor_k_zeros;

end

function valor_k_zeros = calcular_ganancia_k_zeros(zeros)
    % parte real
    parte_real_zeros = real(zeros);
    parte_img_zeros = imag(zeros);
    
    if (length(zeros)>=2)
        for i = 1:(length(zeros)-1)
            valor_k_zeros =+ sqrt(power((abs(parte_real_zeros(i)) - abs(parte_real_zeros(i+1))+ ...
            abs(parte_img_zeros(i)) - abs(parte_img_zeros(i+1))), 2));
        end
    else 
        valor_k_zeros = abs(zeros);
    end
end

%% Funciones para graficar el lugar de las raices

function plot_angulo_salida(angulo_complemento, angulo_salida)
    % Definir el ángulo en grados
    angulo_deg = angulo_complemento - angulo_salida;

    % Convertir el ángulo a radianes
    angulo_rad = deg2rad(angulo_deg);

    % Definir el punto inicial y longitud de la línea
    x0 = 0;
    y0 = 0;
    longitud = 1;

    % Calcular las coordenadas del punto final de la línea
    x1 = x0 + 10*longitud*cos(angulo_rad);
    y1 = y0 + 10*longitud*sin(angulo_rad);

    % Graficar la línea
    %figure;
    hold on;
    quiver(x0, y0, x1-x0, y1-y0, 0); % Dibujar la línea con ángulo específico
    axis equal;
    xlabel('Eje X');
    ylabel('Eje Y');
    title('Línea con Ángulo Específico (en Grados)');
    grid on;

end

%function dibujar_recta_vertical(x_pos)
    % x_pos: Posición en el eje x donde se ubicará la recta vertical
    
    % Definir las coordenadas de los extremos de la recta vertical
    % valores random de inicio
 %   y_inicio = -5; 
 %   y_final = 5; 
    
    % Graficar la recta vertical
    % Dibujar la línea vertical en azul
  %  plot([x_pos, x_pos], [y_inicio, y_final], 'b--');
  %  hold on;
    
    % Etiquetas y título
   % xlabel('Eje X');
   % ylabel('Eje Y');
   % title('Recta Vertical');
   % grid on;
% end