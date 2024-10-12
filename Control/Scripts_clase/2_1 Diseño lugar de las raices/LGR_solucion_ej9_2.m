% Ejmplo 9.1 LGR clase 27 feb min 54
clear all;
close all;

s = tf ('s');
G = (1)/((s+1)*(s+2)*(s+10));
k = 164.6;
% Agregar compensador
C = (s+0.10)/(s);

% graficar
figure
step(feedback(G,1))
hold on 
%step(feedback(G*k,1))
step(feedback(G*k*C,1))

% Evitar el compensador ideal
k2 = 158.6;
%C2 = (s+0.111) /(s+0.01);
%step(feedback(G*k2*C2,1))

k3 = 158.1;
step(feedback(G*k3*C_lag,1))