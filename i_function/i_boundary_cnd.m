function res = i_boundary_cnd(ya,yb)
% ==================================
% RES = I_BOUNDARY_CND(ya,yb)       
%                                   
% ���E����                          
% ==================================

global BC1 BC2 dim

res = [ ya(1:dim) - BC1 ;
        yb(1:dim) - BC2 ];

% ��) ya,yb �� 2*dim���̃x�N�g��[x1, .. , xn, p1, .. , pn]^T�ł��邪,
%     ���E������x�݂̂ɑ��݂���̂�, dim���܂ł��v�Z����.