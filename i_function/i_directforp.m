function du = i_directforp(t,u)
% ==================================================================
% p�����߂邽�߂̔�ϕ��֐�                                         
%                                                                   
% ode�֐��̈����Ƃ��Ďg�p���邽��, �P�̂ł̎g�p�͕s��               
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
