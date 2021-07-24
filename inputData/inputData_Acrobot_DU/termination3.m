function [value,isterminal,direction] = termination3(t,u)
% ===================================================================
% [value,isterminal,direction] = TERMINATION4(T,U)                   
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
    
    %% ���͂�u_lim�ɂȂ�����v�Z���~�߂�.
    global u_lim
    Input_tmp = f_inputcalcu(xp_for_ham(:,1:dim),xp_for_ham(:,dim+1:dim*2),R);
    Input_value = -(abs(Input_tmp) - u_lim);
    
    value1 = min(Ham_value,Delta_x_lim);
    value = min(value1, Input_value);
    
	isterminal = 1;   % Stop the integration
	direction =  0;   % Negative direction only