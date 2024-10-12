A = [0 1;-15.3 -0.3312];
B = [0; 5.218];
C = [1 0];
D = [0];
As = [A [D;D];-C D];
Bs =[B;D];
planta = ss(As, Bs, [C D], D)
Q = [4 0 0;0 4 0; 0 0 30];
R = 6;
[Ks S E] = lqr(planta, Q,R);
K=Ks(:,1:2)
Ki=-Ks(:,3)

