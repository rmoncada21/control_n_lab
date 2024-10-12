num = [1];
den = [1 2 2];
G = tf(num, den)
step(G)
hold on
step(feedback(G,1))

% Segunda forma
s = tf('s')
C = 4+4*s
step(feedback(G,1))
step(feedback(C*G,1))
C = 4+4*s
C2 = 8+4*s+(6.05/s)
step(feedback(G*C2,1))