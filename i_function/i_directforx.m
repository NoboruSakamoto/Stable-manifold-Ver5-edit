function du = i_directforx(t,u)
% ==================================================================
% xを求めるための被積分関数                                         
%                                                                   
% ode関数の引数として使用するため, 単体での使用は不可               
%                                                                   
% created : Y.Umemura                                               
% ==================================================================
global F knum_i
global xp_sp time_g

if knum_i == 0
	du = F*u;
else
	xpt = transpose(interp1(time_g,xp_sp,t));
	du = F*u + i_highf(xpt);
end
