% ======================================== SP_BVP_Calcu ================================================
% Main_BVP_Calcuで使用
% 二点境界値問題求解による解軌道算出を行う
% bvpの繰り返し計算で軌道を連続的に遷移させる
% ver4におけるsolve_BVP,更新箇所は無し(コメントのみ)
%
% Created : Fujimoto, Umemura, Yamaguchi
% ver5更新者  :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
%% === iteration_setting ===
it_loop = 1; %
it_flag = 0; %1になったら終わり
opt_input=ones(1,length(time));
%% == Iteration Loop ===
while (it_flag == 0)
    
    fprintf(' it_loop    = %5.0f \n',it_loop);
    
    %% === 初期推定構造体solinit ===
    %時間t，xp，終了時間
    interp_yy = @(t)interp1q(Sxint2_2(1,:)',Sxint2_2(2:end,:)',t);
    yinit = @(t)transpose(interp_yy(t));
    solinit = bvpinit(time,yinit);
    %% === BVP求解 ===
    sol1 = bvp5c(@i_canonical_eq,@i_boundary_cnd,solinit,options);
    xint = time;
    Sxint = deval(sol1,xint);
    
    %% Hamiltonian check
    for i = 1:length(time)
        opt_input(:,i) = -1/2*R^(-1)*B'*Sxint(dim+1:2*dim,i);
    end
    
    HAMK = f_hamcalcu(Sxint(1:dim,:)',Sxint(dim+1:2*dim,:)',Q,R);
    HAM_ch = max(abs(HAMK));
    fprintf(' HAM_ch = %9.7f \n',HAM_ch);
    
    %% 終了設定
    if HAM_ch <= HAMK_n_max_juddge || HAM_ch > HAMK_error || it_loop == it
        it_flag = 1;
    end
    
    it_loop = it_loop + 1;
    Sxint2_2 = [time;Sxint];
end

