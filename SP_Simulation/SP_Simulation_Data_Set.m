% ============================== SP_Simulation_Data_Set =================================================
% 多項式近似・シミュレーション用データ設定プログラム
% Main_Simulation.mで利用する各変数や配列を定義
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/28 竹田 賢矢
% =======================================================================================================
%% === 解軌道周りの設定 ===
cut_time=2;                                             %間引く時間(cut_time以降のデータを使用しない)
[InputB,costch]=f_ch_cost_cal(sh_Base,'基準');          %基準軌道の評価関数値を用いてシミュレーション結果を評価する
txpCsumT=[mfold;[mfold(:,1),-1*mfold(:,2:2*dim+1)]];    %倒立振子など対称性を考慮するシステムは両符号の初期値からの軌道を多様体面とする
%% === 基準軌道と多様体面(txpCsumT)のプロット ===
%===========%
Plot_Setting
%===========%
plt_Mfold=line(1,fix(dim/2));
plt_Base=line(1,fix(dim/2));
f_plot_trajectory_state(txpCsumT,plt_Mfold,PLToption_mfold)
f_plot_trajectory_state(sh_Base,plt_Base,PLToption_sh_Base)
disp('Press any key to continue')
pause
%% === 多項式近似次数設定 ===
global Polyflag
Polyflag=0;                                             %多項式近似における次数の最大値制限を解除する(2021/02/28時点非推奨)
Bdim=length(B(1,:));                                    %入力の次数
ApproxD=5;                                              %近似に用いる最大次数
para_a=ones(dim,1);                                     %システムの次元だけ近似次数を用意する(最小次数)
para_b=ApproxD*ones(dim,1);                             %システムの次元だけ近似次数を用意する(最大次数)
partition=ApproxD-1;                                    %f_shiftで与える次数の分割数
direction_A=1;                                          %昇順に近似次数の順列を考える
parameters=f_shift(para_a,para_b,partition,direction_A);%1次からApproxD次まで1次ずつ分割する
combination = f_combo(parameters);                      %重複順列計算による近似次数リスト作成
%% === フラグ設定 ===
i_forpoly=1;
if exist('ALL_Controller_Dim','var')==0
    ALL_Controller_Dim=[];
end
%==========================================================================
if isempty(ALL_Controller_Dim)==0
    while(1)
        u_flag = input('成功近似次数を保持する: OK = 1, NO = 0:');
        if isempty(u_flag)==1
        elseif u_flag==0 || u_flag==1
            break
        end
    end
    if u_flag==0
        ALL_Controller_Dim=[];
    end
end
%==========================================================================
while(1)
    approximationflag = input('多項式近似次数を自動探索する: OK = 1, NO = 0:');
    if isempty(approximationflag)==1
    elseif approximationflag==0 || approximationflag==1
        break
    end
end
if approximationflag==1 && norm(ALL_Controller_Dim)>0
    while(1)
        approximationflag = 1+input('成功次数だけでシミュレーションする: OK = 1, NO = 0:');
        if approximationflag==2
            combination=ALL_Controller_Dim(:,1:dim);
            ALL_Controller_Dim2=[];
            break
        elseif approximationflag==1
            break
        end
    end
elseif approximationflag==0
    combination=ones(1,dim);
else
end
%==========================================================================
%% === 多項式近似プログラム内で用いる変数定義 ===
for i_setD=1:dim
    eval(['X' num2str(i_setD)  'tmp' ' ='  '[]' ';' ])
    eval(['P' num2str(i_setD)  'tmp' ' ='  '[]' ';' ])
end
%% === 制御器格納用セル配列定義 ===
if exist('ALL_Controller','var')==0
    ALL_Controller=cell(1,4);                               %コントローラ格納用配列
    ALL_Controller(1,1:4)=[{'多項式'},{'近似次数'},{'評価関数値'},{'Approxflag'}];
end
%% === シミュレーション条件設定 ===
% ==============================================
% 応答性検証用パラメータ
% ===============================================
close all
global Input_check State_check
Input_check=15;
State_check=50;
tE_data=[];
fE_data=[];
iE_data=[];
% === 初期条件の定義 ===
Ini_Simu=Initial_State;
%Ini_Simu=[pi+(5)*pi/180,0];