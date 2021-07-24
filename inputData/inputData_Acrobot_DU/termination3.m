function [value,isterminal,direction] = termination3(t,u)
% ===================================================================
% [value,isterminal,direction] = TERMINATION4(T,U)                   
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
    
    %% 入力がu_limになったら計算を止める.
    global u_lim
    Input_tmp = f_inputcalcu(xp_for_ham(:,1:dim),xp_for_ham(:,dim+1:dim*2),R);
    Input_value = -(abs(Input_tmp) - u_lim);
    
    value1 = min(Ham_value,Delta_x_lim);
    value = min(value1, Input_value);
    
	isterminal = 1;   % Stop the integration
	direction =  0;   % Negative direction only