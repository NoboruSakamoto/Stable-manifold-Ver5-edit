function du = i_directforx(t,u)
% ==================================================================
% x�����߂邽�߂̔�ϕ��֐�                                         
%                                                                   
% ode�֐��̈����Ƃ��Ďg�p���邽��, �P�̂ł̎g�p�͕s��               
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
