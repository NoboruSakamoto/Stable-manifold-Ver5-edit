% ======================================== Main_BVP_calcu ==============================================
% 二点境界値問題求解による解軌道算出を行う
% bvpの繰り返し計算で軌道を連続的に遷移させる
% ver4におけるMAIN_LoopBVPの改良版
% 基準軌道(sh_Base)と遷移用軌道(sh_risou)周りの処理を実装, 多様体面(mfold)の形成もここで行う
%
% 二点境界値問題による求解は2020年度時点において非線形最適制御器設計工程の大半を占めるため
% 大半の機能をMainファイル内で記述している
% 初期推定データは横長配列（[t;x;p]）;データ名前はSxint2_2
%
% Created : Fujimoto, Umemura, Yamaguchi
% ver5更新者  :2021/2/22 竹田 賢矢
% 最終更新者  :2021/3/2 竹田 賢矢
% =======================================================================================================
close all
clc
global BC1 BC2 
%% === パスの設定 ===
%==========%
SP_Path_set
%==========%
%% === 変数初期化 ===
%==========================%
SP_BVP_Initialize_Variables
%==========================%
%% === BVPソルバ周りの設定 ===
options = bvpset('RelTol',1e-12,'AbsTol',1e-12);
it = 15;                                           % イタレーション回数上限
sampling_t = 1e-3;                                 % 離散時間幅
HAMK_n_max_juddge  = 1e-5;                         % Hamiltonian 上限
HAMK_error = 1e9;                                  % Hamiltonian 発散判断
%% === 目標初期値と境界条件設定 ===
% 目標の初期値/手動で設定する際はここに手打ち
% BC1_p=[pi-(10)*pi/180,0];
% BC1_p=[0,4*pi,0,0];
% BC1_p=[2*pi,0,0,0];
BC2_p=[0,pi,0,0];%初期条件と同じ座標
dth =1;                                          %軌道遷移の分割数
%% === Please check ===
Trajectory_Num=2;
%===========================%
SP_BVP_Decide_Use_Trajectory
%===========================%
%% === 境界条件設定 ===
%========================%
SP_BVP_Boundary_Condition
%========================%
%% === BVP遷移loop計算 ===
Manifold=cell(dth+2,5);
Manifold(1,1:5)=[{'解軌道'},{'初期条件'},{'終端条件'},{'Ham'},{'Index'}];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for ii = 1:length(BC1_mat(:,1))
    disp([num2str(dth),'分割の内現在',num2str(ii-1),'分割目']);
    %% === 境界条件の更新 ===
    BC1 = BC1_mat(ii,:)';                              %初期条件
    BC2 = BC2_mat(ii,:)';                              %終端条件
    %% === BVPの計算; Sxint2_2を読み込んでSxint2_2を吐き出す ===
    %===========%
    SP_BVP_Calcu
    %===========%
    if  it_loop==it || HAM_ch>HAMK_error
        fprintf('\n !!!!!!!!!Error!!!!!!!!!! \n');
        errorflag=1;
        break
    end
    %% 解軌道保存
    Manifold(ii+1,1:end)=[{Sxint2_2},{BC1},{BC2},{HAM_ch},{ii-1}];
    errorflag=0;
end
toc;                                                 % 計算時間計測終了
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% === 解軌道データの保存と多様体面の形成 ===
%================%
SP_BVP_Data_Store
%================%
%% === 二点境界値求解結果確認 ===
%==========%
SP_BVP_Plot
%==========%
[Input_Sxint,cost_Nth_S]=f_ch_cost_cal(Sxint2_2,'遷移後');
%% === 基準軌道の決定 ===
if errorflag==0
    shflag = input('遷移後の軌道を次回試行で用いる: OK = 1, NO = 0:');
    if shflag==1
        sh_risou = Sxint2_2;
    end
end
%
if errorflag==0
    shflag = input('遷移後の軌道を基準軌道とする: OK = 1, NO = 0:');
    if shflag==1
        sh_Base = Sxint2_2;
    elseif isempty(sh_Base)==1
        disp('基準軌道が未定義のため,得た軌道を基準軌道とします');
        sh_Base = Sxint2_2;
    end
end
%% === 基準軌道・多様体面プロット ===
[Input_T,cost_Nth_T]=f_ch_cost_cal(sh_Base,'基準');
%=========================%
SP_BVP_Plot_StableManifold
%=========================%
%% === 不要な変数削除 ===
clear sh_flag Maniflag Tnum i_B i_store i_plot PlotSxint BVP_trajectry
clear sh_use sh_useB m_use ch_B1 ch_B2 chB chB2 chB chB2 ch_BS1 ch_BS2 DelCell Length_BVP_ALL_T