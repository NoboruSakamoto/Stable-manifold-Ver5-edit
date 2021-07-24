function [InputT,dcostT] = f_ch_cost_cal(sh_get,chs)
% ==================================== f_ch_cost_cal ====================================================
% 求めた解軌道(sh_Base)の評価関数値とHamiltonianを計算
% Main_BVP_calcu.m Main_Simulation.mで使用
% 
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
global dim Q R
%% === 解軌道取得 ===
sh_BVP_plot =  sh_get.';
%% === 最適入力の算出 ===
Time=sh_BVP_plot(:,1);
x1=sh_BVP_plot(:,2:dim+1);
p1=sh_BVP_plot(:,dim+2:2*dim+1);
u1= f_inputcalcu(x1,p1,R);
FFF=x1;
%% === Hamiltonianと評価関数値表示 ===
hamT=max(abs(f_hamcalcu(x1(:,:),p1(:,:),Q,R)));
fprintf('%s軌道のHamiltonian: %d \n',chs,hamT);
costT = f_costopt(Time,FFF,u1,Q,R);
fprintf('%s軌道の評価関数値: %d \n',chs,costT)
%% === Main_Simulationの場合この値を基準にシミュレーション結果を評価する ===
InputT=u1;
dcostT=costT;