% ==========================================================================
% N次近似計算スクリプト(t>=0)                                               
% k=1,..,nにおけるx(t),p(t)を求める.                                        
% P4_iterative_calcu.m で使用                                               
% ==========================================================================
	options = options_pos;
	options.Events = @termination1 ;

	xstopFlag = 0;
	pstopFlag = 0;

	time_ini_x = 0;
	time_ini_p = stoptime;

	tmp_time_x_p = [];
	tmp_forx_p = [];
	tmp_time_p_p = [];
	tmp_forp_tmp_p = [];

	% t >= 0 に関して, dot_x = F*x + f(t,xk(t),pk(t))の微分方程式の初期値問題を解く
	while xstopFlag == 0
		[time_x_p, forx_p,tE,fE,iE] = ode45(@i_directforx, [time_ini_x, stoptime], [ini], options);
		if time_x_p(end) == stoptime
			xstopFlag = 1;
		else
			time_ini_x = time_x_p(end);
			ini = forx_p(end,:);
		end
		tmp_time_x_p = [tmp_time_x_p;time_x_p];
		tmp_forx_p = [tmp_forx_p;forx_p];
	end
	time_x_p = tmp_time_x_p;
	forx_p = tmp_forx_p;

	% t >= 0 に関して, dot_p = Ft*p + g(t,xk(t),pk(t))の微分方程式の初期値問題を解く
	while pstopFlag == 0
		[time_p_p, forp_tmp_p] = ode45(@i_directforp, [time_ini_p 0], [zeros(dim,1)], options);
		if time_p_p(end) == 0
			pstopFlag = 1;
		else
			time_ini_p = time_p_p(end);
			ini = forp_tmp_p(end,:);
		end
		tmp_time_p_p = [tmp_time_p_p;time_p_p];
		tmp_forp_tmp_p = [tmp_forp_tmp_p;forp_tmp_p];
	end

	time_p_p = tmp_time_p_p;
	forp_tmp_p = tmp_forp_tmp_p;

	% === 高速1次元線形補間(interp1)を使うために時間ベクトルを単調増加に変換する.  ===
	tmp_data = [time_p_p,forp_tmp_p];
	tmp_data = sortrows(tmp_data,1);
	time_p_p = tmp_data(:,1);
	forp_tmp_p = tmp_data(:,2:dim+1);
	forp_p = interp1(time_p_p,forp_tmp_p,time_x_p);

	time_x = time_x_p;
	time_g = time_x;
	xp_sp = [ forx_p , forp_p];
	txp = [time_x,xp_sp];

	% === デバッグ ===
	cFlag = 0;
	SP_debug;
	% === デバッグ ===
