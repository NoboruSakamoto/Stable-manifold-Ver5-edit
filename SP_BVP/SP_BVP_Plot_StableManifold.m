% ==================================== SP_BVP_Plot_StableManifold ========================================
% Main_BVP_Calcuで使用
% 多様体面と基準軌道をプロット
% システムが偶数次元かつ状態量が[x1 x2...xn dotx1 dotx2...dotxn]^Tの形式であることが必須
% 多項式近似プログラムが多入力系向きかは不明だがグラフプロットは多入力系にも対応
% ticklabelを実装(回転機械系向き)
%
% 作成者　    :2021/2/22 竹田 賢矢
% 最終更新者  :2021/2/25 竹田 賢矢
% ========================================================================================================
Plot_Setting
%% === プロットの初期化 ===
plt_Mfold=line(1,fix(dim/2));
plt_Base=line(1,fix(dim/2));
plt_Sxint=line(1,fix(dim/2));
%% === 多様体面と基準軌道のプロット ===
f_plot_trajectory_state(mfold,plt_Mfold,PLToption_mfold);
f_plot_trajectory_state(sh_Base,plt_Base,PLToption_sh_Base);
%% === 遷移後軌道のプロット ===
%==========================================================================
minle=min(length(sh_Base(1,:)),length(Sxint2_2(1,:)));
if round(norm(Sxint2_2(:,1:minle)-sh_Base(:,1:minle)),6)>0 && errorflag==0
    disp('遷移後軌道と基準軌道が異なります')
    while(1)
        PlotSxint=input('遷移後軌道を 1:プロットする / 0:プロットしない >>');
        if isempty(PlotSxint)==1
        elseif PlotSxint==0 || PlotSxint==1
            break
        end
    end
    if PlotSxint==1
        f_plot_trajectory_state(Sxint2_2,plt_Sxint,PLToption_Sxint);
    end
else
    PlotSxint=0;
end
%==========================================================================
%% === 時系列データと最適入力 ===
figure('name','Time Response')
set(gcf,'windowstyle','docked')
plt_T=line(1,fix(dim/2)+1);
plt_TI=line(1,Bdim);
plt_Sx=line(1,fix(dim/2)+1);
plt_Sxi=line(1,Bdim);
% === 基準軌道 ===
subplot(1,2,1)
f_plot_trajectory_time(sh_Base,plt_T,PLToption_tsh_Base);
subplot(1,2,2)
f_plot_trajectory_input([transpose(sh_Base(1,:)),Input_T],plt_TI,PLToption_tish_Base);
% === 遷移後軌道 ===
if PlotSxint==1
    subplot(1,2,1)
    f_plot_trajectory_time(Sxint2_2,plt_Sx,PLToption_tSxint);
    subplot(1,2,2)
    f_plot_trajectory_input([transpose(Sxint2_2(1,:)),Input_Sxint],plt_Sxi,PLToption_tiSxint);
end
%% === フォント等の設定 ===
figure(1)
set(gcf,'windowstyle','docked')
figure(2)
set_plot_style_v03(20,20,5);