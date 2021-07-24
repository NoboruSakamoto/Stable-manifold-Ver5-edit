% ==================================== SP_Simulation_Result_Plot =========================================
% SP_response_calcuで使用
% SP_response_calcu.mでのシミュレーション結果をプロット
% システムが偶数次元かつ状態量が[x1 x2...xn dotx1 dotx2...dotxn]^Tの形式であることが必須
% 多項式近似プログラムが多入力系向きかは不明だがグラフプロットは多入力系にも対応
% 横軸のみyticklabelを実装(回転機械系向き)
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/3/1 竹田 賢矢
% ========================================================================================================
close all
%%
figure('name','Response ALL')
plot(t,fx,t,opt_u,'--')
grid on
legend
%% === プロット設定 ===
%===========%
Plot_Setting
%===========%
%% === 多様体面・基準軌道比較用プロット === 
% 多様体面・基準軌道比較用プロットの初期化
plt_Mfold=line(1,dim/2);
plt_Base=line(1,dim/2);
plt_Simu=line(1,dim/2);
%=== 多様体面・基準軌道のプロット ===%
f_plot_trajectory_state(txpCsumT,plt_Mfold,PLToption_mfold);
f_plot_trajectory_state(sh_Base,plt_Base,PLToption_sh_Base);
%======= 基準軌道のプロット ========%
f_plot_trajectory_state([t,fx],plt_Simu,PLToption_fx);
%% === カラーコード指定 ===
% 3自由度のプロットまではカラーコードを直接指定する補助を行う
% blue1～yellow1はデフォルトで順番にプロットされるカラーコード:シミュレーション結果用
% Collor3Bは適当に指定したカラーコード:基準軌道用
blue1  = [0      0.4470 0.7410];
orange1= [0.8500 0.3250 0.0980];
yellow1= [0.4940 0.1840 0.5560];
Collor3=[blue1;orange1;yellow1];
Collor3B=['b';'r';'y'];
%% === 時系列データと最適入力 ===
% === 状態量のプロット ===
figure('name','Time Response')
plt_T=line(1,fix(dim/2)+1);
plt_TI=line(1,Bdim);
plt_F=line(1,fix(dim/2)+1);
plt_FI=line(1,Bdim);
set(gcf,'windowstyle','docked')
% === 基準軌道 ===
subplot(1,2,1)
PLToption_tsh_Base(1,2)={':'};
f_plot_trajectory_time_simu(sh_Base,plt_T,PLToption_tsh_Base,Collor3B);
subplot(1,2,2)
f_plot_trajectory_input([transpose(sh_Base(1,:)),InputB],plt_TI,PLToption_tish_Base);
subplot(1,2,1)
f_plot_trajectory_time_simu(transpose([t,fx]),plt_F,PLToption_tfx,Collor3);
subplot(1,2,2)
f_plot_trajectory_input([t,opt_u],plt_FI,PLToption_tfxi);
%% === フォント等の設定 ===
figure(1)
set(gcf,'windowstyle','docked')
figure(2)
set_plot_style_v03(20,20,3);