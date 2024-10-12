num_idem =  5.557 ;
den_idem=[1 0.2762 15.51];
G=tf(num_idem,den_idem);

s = tf('s');
%step(G);
%sisotool('rlocus',G);
[num,den] = tfdata(C_IMC_PAMH,'v');
syms KP KI KD N S;

%PID=KP+KI/S+S*N*KD/(S+N);

N = den(2);
KI=num(3)/N;
KP=(num(2)-KI)/N;
KD=(num(1)-KP)/N;
PID=tf(KP+KI/S+S*N*KD/(S+N));
PID1=tf(KP+KI/s+s*N*KD/(s+N));
collect(PID1);
%zpk(PID);
%zpk(G);
