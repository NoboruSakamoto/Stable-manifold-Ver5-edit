function res = i_boundary_cnd(ya,yb)
% ==================================
% RES = I_BOUNDARY_CND(ya,yb)       
%                                   
% 境界条件                          
% ==================================

global BC1 BC2 dim

res = [ ya(1:dim) - BC1 ;
        yb(1:dim) - BC2 ];

% ※) ya,yb は 2*dim次のベクトル[x1, .. , xn, p1, .. , pn]^Tであるが,
%     境界条件はxのみに存在するので, dim次までを計算する.