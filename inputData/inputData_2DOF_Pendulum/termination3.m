function [value,isterminal,direction] = termination3(t,u)
% ===================================================================
% [value,isterminal,direction] = TERMINATION3(T,U)                   
%                                                                    
% k = kmax�̂Ƃ��̐ϕ��v�Z�̃I�v�V����                               
% Hamiltonian�̒l��������l�ȏ�ɂȂ����ꍇ, �ϕ��̌v�Z���~����. 
% ===================================================================

% global dim Q R HAMK_n_max_juddge
% 
% 	xp_for_ham = transpose(u);
% 	HAMK_N = f_hamcalcu(xp_for_ham(:,1:dim),xp_for_ham(:,dim+1:dim*2),Q,R);
% 	value = -(abs(HAMK_N) - abs(HAMK_n_max_juddge));
%     
% 	isterminal = 1;   % Stop the integration
% 	direction =  0;   % Negative direction only

global dim Q R HAMK_n_max_juddge x_lim
	xp_for_ham = transpose(u);
	HAMK_N = f_hamcalcu(xp_for_ham(:,1:dim),xp_for_ham(:,dim+1:dim*2),Q,R);
	Ham_value = -(abs(HAMK_N) - abs(HAMK_n_max_juddge));
    Delta_x_lim = -max(abs(u(1:dim))-abs(x_lim));
    value = min(Ham_value,Delta_x_lim);
	isterminal = 1;   % Stop the integration
	direction =  0;   % Negative direction only