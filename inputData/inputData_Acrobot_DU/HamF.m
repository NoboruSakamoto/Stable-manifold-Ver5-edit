function du = HamF(x,p)
% ======================================================================
% du = HamF(x,p)                                                        
%                                                                       
% 正準方程式の非線形項の設定                                            
%                                                                       
% dot(x) =  ∂H/∂p                                                     
% dot(p) = -∂H/∂x                                                     
%                                                                       
% システムの次元数分のxおよびpを与える。                                
% 手計算またはMapleを用いて、Fx(x,p)を求め、その式を入力する。          
% それぞれ対角化されていない数式を入力する。                            
% ======================================================================
global top btm
global R
global aa1 aa2 aa3 bb1 bb2 n Kdc mu2 mu1 
% global m1 m2 L1 L2 Lc1 Lc2 J1 J2 g0 mu2 n Kdc

xp = [ x ;
       p ];

x1 = xp(1);
x2 = xp(2);
x3 = xp(3);
x4 = xp(4);
p1 = xp(5);
p2 = xp(6);
p3 = xp(7);
p4 = xp(8);


 du= [0 0 aa2 / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (aa3 * x4 * sin(x2) * x3 + aa3 * (x3 + x4) * sin(x2) * x4 + bb1 * sin(x1) - bb2 * sin(x1 + x2) + mu1 * x3) + (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (-aa3 * x3 ^ 2 * sin(x2) - bb2 * sin(x1 + x2) + mu2 * x4) - (aa3 * cos(x2) - aa2) ^ 2 / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * p3 / 0.4e1 + (-p3 * (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * n * Kdc / 0.2e1 + p4 * (0.2e1 * aa3 * cos(x2) - aa1 - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * n * Kdc / 0.2e1) / R * (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * n * Kdc / 0.2e1 + (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * (0.2e1 * aa3 * cos(x2) - aa1 - aa2) * p4 / 0.4e1 - (aa2 / (-aa1 * aa2 + aa3 ^ 2) * (bb1 - bb2) - (aa3 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * bb2) * x1 - (-aa2 / (-aa1 * aa2 + aa3 ^ 2) * bb2 - (aa3 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * bb2) * x2 - aa2 * mu1 / (-aa1 * aa2 + aa3 ^ 2) * x3 - (aa3 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * mu2 * x4 + (aa3 - aa2) ^ 2 / (-aa1 * aa2 + aa3 ^ 2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * p3 / 0.2e1 - (0.2e1 * aa3 - aa1 - aa2) / (-aa1 * aa2 + aa3 ^ 2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * (aa3 - aa2) * p4 / 0.2e1 (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (aa3 * x4 * sin(x2) * x3 + aa3 * (x3 + x4) * sin(x2) * x4 + bb1 * sin(x1) - bb2 * sin(x1 + x2) + mu1 * x3) - (0.2e1 * aa3 * cos(x2) - aa1 - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (-aa3 * x3 ^ 2 * sin(x2) - bb2 * sin(x1 + x2) + mu2 * x4) + (0.2e1 * aa3 * cos(x2) - aa1 - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * (aa3 * cos(x2) - aa2) * p3 / 0.4e1 - (0.2e1 * aa3 * cos(x2) - aa1 - aa2) ^ 2 / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * p4 / 0.4e1 - (-p3 * (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * n * Kdc / 0.2e1 + p4 * (0.2e1 * aa3 * cos(x2) - aa1 - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * n * Kdc / 0.2e1) / R * (0.2e1 * aa3 * cos(x2) - aa1 - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * n * Kdc / 0.2e1 - ((aa3 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * (bb1 - bb2) + (0.2e1 * aa3 - aa1 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * bb2) * x1 - (-(aa3 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * bb2 + (0.2e1 * aa3 - aa1 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * bb2) * x2 - (aa3 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * mu1 * x3 + (0.2e1 * aa3 - aa1 - aa2) / (-aa1 * aa2 + aa3 ^ 2) * mu2 * x4 - (0.2e1 * aa3 - aa1 - aa2) / (-aa1 * aa2 + aa3 ^ 2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * (aa3 - aa2) * p3 / 0.2e1 + (0.2e1 * aa3 - aa1 - aa2) ^ 2 / (-aa1 * aa2 + aa3 ^ 2) ^ 2 * n ^ 2 * Kdc ^ 2 / R * p4 / 0.2e1]';

