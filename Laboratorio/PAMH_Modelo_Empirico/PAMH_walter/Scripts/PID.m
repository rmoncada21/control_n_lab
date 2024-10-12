num_idem =  5.2185 ;
den_idem=[1 0.2142 15.3];
G=tf(num_idem,den_idem);
s = tf('s');
%%4 pruebas en tunning metods y la ganancia
%%CL=0.75, cl=0.9 , g=1.4,g=1.3
%Prueba Cl = 0.75
%C = (0.34067 *(s^2 + 0.2142*s + 15.3))/ (s *(s+2.667));
%Prueba g = 1.4
%C_siso = 0.20334 * (s^2 + 0.2142*s + 15.3)/ (s*(s+2.222)); %85 rev
%Prueba cl = 0.9 
%C_siso = (0.23658 * (s^2 + 0.2142*s + 15.3)) / (s*(s+2.222));
%Prueba g = 1.3
C_siso = (0.18882 * (s^2 + 0.2142*s + 15.3))/( s*(s+2.222));

PIDSYS=pid(C_siso);
Kp=PIDSYS.Kp;
Ki=PIDSYS.Ki;
Kd=PIDSYS.Kd;
N=9; %todos
pid1= Kp+Ki/s +Kd*N*s/(s+N);
%SE ABRE SIMULINK PID_IMC.slx
%Metodo I_PD

Modelo_idem=tf(num_idem,den_idem);

A = [0 1; -15.3 -0.2142];
B = [0;5.218];
C = [1 0];
As = [A [0;0]; -C 0 ];
Bs = [B;0];
N_IPD = 5;
P = [-2.5+2i -2.5-2i -0.8];
%P = P = [-2.5+2i -2.5-2i -0.75];
%P = [-2.5+2i -2.5-2i -0.7];

ks = acker(As,Bs,P);
Ki_IPD=-ks(3);
