function du = i_directforp(t,u)
% ==================================================================
% pを求めるための被積分関数                                         
%                                                                   
% ode関数の引数として使用するため, 単体での使用は不可               
%                                                                   
% created : Y.Umemura                                               
% ==================================================================

global Ft dim knum_i
global xp_sp time_g

if knum_i == 0
	du = zeros(dim,1);
else
	xpt = transpose(interp1(time_g,xp_sp,t));
	du = -Ft*u + i_highg(xpt);
end
