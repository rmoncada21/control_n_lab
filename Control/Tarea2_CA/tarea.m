clear
%% función de transferencia
s = tf('s');

G_num = [1.0301];
G_den = [1 0.6247 1.0301];
G = tf(G_num, G_den);


%% espaccio de estados

[A, B, C, D] = tf2ss(G_num, G_den);
A = [0, 1 ; -1.031 , -0.6247];
B = [0 ; 1];
C = [1.031, 0]
D = 0
%% observabildiad

OMZ = [C ; C*A ]'
det(OMZ)

%% ecuacion caracteristica


