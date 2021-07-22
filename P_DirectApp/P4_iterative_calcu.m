% ======================================= P4_iterative_calcu ===========================================
% 与えられたξに対してx(t), p(t)を求める.
% 求まったx(t), p(t)はそれぞれxpnsum(n = 0..k：近似回数)に格納する.
% 
% 更新により解軌道毎の変数定義を廃止．ALL_TXP_DATAに解軌道とHamiltonian・入力を格納する 
% 
% ver5更新者  :2021/2/22 竹田 賢矢
% 最終更新者  :2021/2/25 竹田 賢矢
% =======================================================================================================
global txp
global xp_sp time_g
%% === 解軌道格納用セル定義 ===
ALL_TXP_DATA=cell(ini_row+1,4);
ALL_TXP_DATA(1,1:end)=[{'Name'},{'Data'},{'Ham Num'},{'Ham&Input'}];
txpname1='txp';
txpname2='_';
txpname3='T';
tHAMK_nameR='tHAMKinput_';
txpsumt=[];
%%
txp0sum  = zeros(1,dim*2+1); % - 0次近似
xi_Tneg = [];
ini_sum = [];
ini_sumT = [];
NN = 0;
eval(['txp' num2str(knum) 'sum = [];' ])
eval(['txp' num2str(knum) 'sumT = [];' ])
tHAMKinputsum = [];

for xi_i = 1:ini_row
    
    ini = init_sum(xi_i,1:dim)';
    
    normFt = tol*100;
    t = 0;
    while( abs(normFt) >= tol )
        normFt = norm(expm(F*t)*ini);
        t = t+1;
    end
    stoptime = t;
    
    knum_i = 0;
    
    
    %% === t > 0 におけるN次近似計算 ===
    while( knum_i <= knum )
        xstopFlag = 0;
        pstopFlag = 0;
        
        time_ini_x = 0;
        time_ini_p = stoptime;
        
        tmp_time_x_p = [];
        tmp_forx_p = [];
        tmp_time_p_p = [];
        tmp_forp_tmp_p = [];
        
        options = options_pos;
        options.Events = @termination1 ;
        %% t >= 0 に関して, dot_x = F*x + f(t,xk(t),pk(t))の微分方程式の初期値問題を解く
        while xstopFlag == 0
            [time_x_p, forx_p,tE,fE,iE] = ode15s(@i_directforx, [time_ini_x, stoptime], ini, options);
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
        
        %% t >= 0 に関して, dot_p = Ft*p + g(t,xk(t),pk(t))の微分方程式の初期値問題を解く
        while pstopFlag == 0
            [time_p_p, forp_tmp_p] = ode15s(@i_directforp, [time_ini_p 0], zeros(dim,1), options);
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
        
        %% === 高速1次元線形補間(interp1q)を使うために時間ベクトルを単調増加に変換する.  ===
        tmp_data = [time_p_p,forp_tmp_p];
        tmp_data = sortrows(tmp_data,1);
        time_p_p = tmp_data(:,1);
        forp_tmp_p = tmp_data(:,2:dim+1);
        forp_p = interp1(time_p_p,forp_tmp_p,time_x_p);    %次元一致
        
        time_g = time_x_p;
        xp_sp = [ forx_p , forp_p]; % 対角空間　ｘ－ｐのみ、ｔなし
        xp_spT = (Diagonalize * xp_sp')'; %元の空間
        
        %% === 計算時間表示 ===
        ratio = (NN/total)*100;
        ratio = round(ratio);
        clc
        fprintf('calculation( t > 0 ) : k = %d : %d[%%] (%d/%d)' ,knum_i,ratio,NN,total )
        fprintf('\n')
        
        knum_i = knum_i + 1;
        NN = NN + 1;
        
    end % while( knum_i <= knum ) に対するend
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    txp = [time_g,xp_sp];   % 対角空間
    txpT = [time_g,xp_spT];     %元の空間　　時間を追加　ｔ－ｘ－ｐになった
    xptmp_pls = f_downsample(txp,param_cull_pos);
    xpTtmp_pls = f_downsample(txpT,param_cull_pos);
    
    
    %% === t < 0 計算 ===  元の空間
    Tneg = Tneg_max;
    
    Tneg_ini_xpT = xp_spT(1,:);
    Time_s = 0;
    
    stopFlag = 0;
    tmpTime = [];
    tmp_xpT = [];
    EVENTDATA = [];
    
    options = options_neg;
    options.Events = @termination3 ;
    
    
    while stopFlag == 0 % stopFlag = 0 の間以下の計算をくりかえす.
        [time_xpT_m, forxpT_m,tE,fE,iE] = ode45(@i_canonical_eq, [Time_s Tneg], Tneg_ini_xpT, options);
        
        EVENTDATA = [EVENTDATA;tE,fE,iE];
        
        if isempty(iE) == 0
            if satFlag > 0
                if max(iE) <= len_dc % 2011.03.22
                    Time_s = time_xpT_m(end);
                    Tneg_ini_xpT = forxpT_m(end,:);
                    tmpTime = [ tmpTime ; time_xpT_m];
                    tmp_xpT   = [ tmp_xpT ; forxpT_m ];
                    
                elseif max(iE) > len_dc || time_xpT_m(end) == Tneg % 2011.03.22
                    stopFlag = 1;
                else
                    error('something wrong!')
                end
            else
                stopFlag = 1;
            end % if satFlag > 0
        else % if isempty(iE) == 0
            stopFlag = 1;
        end % if isempty(iE) == 0
        
    end % while stopFlag == 0
    %% === 解軌道データ格納 ===
    time_xpT_m = [ tmpTime ; time_xpT_m ];
    forxpT_m   = [ tmp_xpT ; forxpT_m ];
    
    txpT = [time_xpT_m,forxpT_m];
    txpT = sortrows(txpT,1);
    txpcullT = f_downsample(txpT,param_cull_neg);
    
    xpTtmp_mns = txpcullT;
    xpTtmp_mp = [xpTtmp_mns;xpTtmp_pls]; %データ集める　txp neg-pos
    xpTtmp_mp = unique(xpTtmp_mp,'rows');
    eval(['txp' num2str(knum) 'sumT = [txp' num2str(knum) 'sumT; xpTtmp_mp];'])
    txpsumt=[txpsumt;xpTtmp_mp];
    %% === Hamiltonian・制御入力の計算 ===
    HAMKinput = f_haminput_calcu(xpTtmp_mp(:,2:dim+1),xpTtmp_mp(:,dim+2:dim*2+1),Q,R);
    tHAMKinputsum = [tHAMKinputsum;xpTtmp_mp(:,1),HAMKinput];
    HAMK_max = max(abs(HAMKinput(:,2)));
    xi_Tneg = [ xi_Tneg ; xi_sum(xi_i), time_xpT_m(end), HAMK_max];
    ini_sum = [ini_sum ; xptmp_pls(1,2:dim*2+1) ];
    ini_sumT = [ini_sumT ; xpTtmp_pls(1,2:dim*2+1) ];
    txpname=[txpname1,num2str(knum),txpname2,num2str(xi_i),txpname3];
    tHAMK_name=[tHAMK_nameR, num2str(xi_i)];
    ALL_TXP_DATA(xi_i+1,1:4)=eval('[{txpname},{xpTtmp_mp},{tHAMK_name},{[xpTtmp_mp(:,1),HAMKinput]}]');
    %%
    clc
    fprintf('calculation( t < 0 ) : k = %d : %d[%%] (%d/%d)' ,knum,ratio,NN,total )
    fprintf('\n')
    
end
%% Save data up to now 
fprintf('Do you want to save all the computational result up to now?')
fprintf('\n')
OKNG_saveP4 = input('Yes =1, No = 0')
fprintf('\n')
if OKNG_saveP4 == 1
	Today = clock;
    TY = Today(1); Ty = num2str(TY);
    TM = Today(2); Tm = num2str(TM);
    TD = Today(3); Td = num2str(TD);
    TT = Today(4); Tt = num2str(TT);
    TMI = Today(5); Tmi = num2str(TMI);

    Dchar = num2str(dim);          DD = strcat('dim=',Dchar);
    Kchar = num2str(knum);         KK = strcat('k=',Kchar);
    Radichar = num2str(radi);      RR = strcat('radi=',Radichar);
    FileName1 = strcat(Ty,'_',Tm,'_',Td,'_',Tt,Tmi,'_',DD,'_',KK,'_',RR,'_','P4','.mat');

    cd result
    eval(['save '  FileName1])
    cd ../
end