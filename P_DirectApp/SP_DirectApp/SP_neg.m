% ==========================================================================
% N���ߎ��v�Z�X�N���v�g(t<0)                                                
% k=1,..,n�ɂ�����x(t),p(t)�����߂�.                                        
% P4_iterative_calcu.m �Ŏg�p                                               
% ==========================================================================

	Tneg_ini_x = ini;
	Tneg_ini_p = transpose(eval(['Tneg_ini_p_' num2str(knum_i);]));
	Time_s = 0;

	options = options_neg;

	if knum_i == knum
		options.Events = @termination4 ;
	else
		options.Events = @termination2 ;
	end

	stopFlag = 0;
	tmpTime = [];
	tmpXP = [];
	EVENTDATA = [];

	while stopFlag == 0; % stopFlag = 0 �̊Ԉȉ��̌v�Z�����肩����.
		% t < 0 �Ɋւ���, dot_x = F*x + f(t,xk(t),pk(t))�̔����������̏����l��������
        if knum_i == knum
            [time_xp_m, forxp_m,tE,fE,iE] = ode45(@i_canonical_eq, [Time_s Tneg2], Diagonalize * [Tneg_ini_x;Tneg_ini_p], options);
            HAMK_n = f_hamcalcu(forxp_m(:,1:dim),forxp_m(:,dim+1:dim*2),Q,R);
            figure(88);plot(time_xp_m,HAMK_n,'r.');grid on;
            forxp_m = (Diagonalize \ forxp_m')';
        else
            [time_xp_m, forxp_m,tE,fE,iE] = ode15s(@i_directforxp, [Time_s Tneg2], [Tneg_ini_x,Tneg_ini_p], options);
        end

		EVENTDATA = [EVENTDATA;tE,fE,iE];

		if isempty(iE) == 0
			if satFlag > 0
				if max(iE) <= len_dc % 2011.03.22 
					Time_s = time_xp_m(end);
					Tneg_ini_x = forxp_m(end,1:dim);
					Tneg_ini_p = forxp_m(end,dim+1:2*dim);
					tmpTime = [ tmpTime ; time_xp_m];
					tmpXP   = [ tmpXP ; forxp_m ];

				end
				if max(iE) > len_dc ||...  % 2011.03.22 
				   time_xp_m(end) == Tneg2
					stopFlag = 1;
				end 
			else
				stopFlag = 1;
			end % if satFlag > 0 
		else % if isempty(iE) == 0
			stopFlag = 1;
		end % if isempty(iE) == 0

	end % while stopFlag == 0
	time_xp_m = [ tmpTime ; time_xp_m ];
	forxp_m   = [ tmpXP ; forxp_m ];

	if knum_i ~= knum
		
		if time_xp_m(end) ~= Tneg2
			time_xp_m = [ time_xp_m ; Tneg2 ];
			forxp_m   = [ forxp_m ; forxp_m(end,:)];
		end
	end

	time_xp = time_xp_m;
	txp = [time_xp,forxp_m];
	txp = sortrows(txp,1);
%     
    txp(end,:)=[];
%     
	time_g = txp(:,1);
	xp_sp = txp(:,2:2*dim+1);

	if knum_i == knum
		% === Hamiltonian�̌v�Z ===
		xp_for_ham = xp_sp;
		xp_for_ham_D = Diagonalize * xp_for_ham';
		xp_for_ham_D = xp_for_ham_D';
		HAMK_n = f_hamcalcu(xp_for_ham_D(:,1:dim),xp_for_ham_D(:,dim+1:dim*2),Q,R);
        figure(77);plot(time_g,HAMK_n,'.');grid on;
		HAMK_n_max = max(abs(HAMK_n));

	end % if knum_i == knum �ɑ΂���end

	Tneg_ini_x_tmp = xp_sp(end,1:dim);
	eval(['Tneg_ini_x_' num2str(knum_i)  '= Tneg_ini_x_tmp;' ])
	Tneg_ini_p_tmp = xp_sp(end,dim+1:dim*2);
	eval(['Tneg_ini_p_' num2str(knum_i)  '= Tneg_ini_p_tmp;' ])

	% === �f�o�b�O ===
	cFlag = 1;
	SP_debug;
	% === �f�o�b�O ===
