% Ejemplo 9.3
clear all;
close all;

s = tf ('s');
G = (1)/((s)*(s+4)*(s+6));
K = 43.35;
figure
step(feedback(G*K,1))
hold on 

% colocar el compensador
C = (S+3.006);
K = 47.45
step(feedback(G*K*C, 1))