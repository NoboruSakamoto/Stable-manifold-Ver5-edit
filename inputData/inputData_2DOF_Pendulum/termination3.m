function [value,isterminal,direction] = termination3(t,u)
% ===================================================================
% [value,isterminal,direction] = TERMINATION3(T,U)                   
%                                                                    
% k = kmaxのときの積分計算のオプション                               
% Hamiltonianの値がある一定値以上になった場合, 積分の計算を停止する. 
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