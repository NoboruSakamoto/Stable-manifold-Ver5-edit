function dx = i_highf(xp)
% ==================================================================
% xを求めるための被積分関数                                         
%                                                                   
% 正準方程式の対角化された非線形項F(x,p)の式                        
% i_derectforx(被積分関数)の中で使用されており, 単体での使用は不可  
%                                                                   
% ※）xpは対角化されていない.                                       
%                                                                   
% created : Y.Umemura                                               
% ==================================================================
global Diagonalize dim

xpt = Diagonalize * xp;
tmpF = HamF(xpt(1:dim),xpt(dim+1:dim*2));
tmpG = HamG(xpt(1:dim),xpt(dim+1:dim*2));
tmp = [tmpF;tmpG];

dx = Diagonalize \ tmp;
dx = dx(1:dim);
