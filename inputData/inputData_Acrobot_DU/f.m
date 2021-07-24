function du = f(x)
% ======================================================================
% du = f(x)                                                             
%                                                                       
% システムの方程式の記述                                                
%                                                                       
% dot(x) = f(x) + g(x) * u                                              
%                                                                       
% システムの次元数分のxおよびpを与える。                                
% 与えられたシステムの方程式のうち、f(x)を入力する。                    
%                                                                       
% ======================================================================
global aa1 aa2 aa3 bb1 bb2 mu2 mu1
% global m1 m2 L1 L2 Lc1 Lc2 J1 J2 g0 mu2

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);

du = [x3; x4; aa2 / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (aa3 * x4 * sin(x2) * x3 + aa3 * (x3 + x4) * sin(x2) * x4 + bb1 * sin(x1) - bb2 * sin(x1 + x2) + mu1 * x3) + (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (-aa3 * x3 ^ 2 * sin(x2) - bb2 * sin(x1 + x2) + mu2 * x4); (aa3 * cos(x2) - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (aa3 * x4 * sin(x2) * x3 + aa3 * (x3 + x4) * sin(x2) * x4 + bb1 * sin(x1) - bb2 * sin(x1 + x2) + mu1 * x3) - (0.2e1 * aa3 * cos(x2) - aa1 - aa2) / (cos(x2) ^ 2 * aa3 ^ 2 - aa1 * aa2) * (-aa3 * x3 ^ 2 * sin(x2) - bb2 * sin(x1 + x2) + mu2 * x4);];




