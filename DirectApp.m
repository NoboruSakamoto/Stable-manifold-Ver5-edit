% ========================================= DirectApp====================================================
% Hamilton-Jacobi解軌道算出プログラム
% 安定多様体論を適用し, 漸化式を直接計算で解いてx(t),p(t)を求める.
%
% ver4以前のDirectApp.mとP1-P4プログラムに対応
% ※P5をプロットプログラムとしたためver4のP5_solution_check.mとの混同に注意
%
% global宣言箇所を各プログラムファイルに変更
% ※評価関数 J には1/2を付けない形でQ,Rを与える.
% ver5更新者  :2021/2/22 竹田 賢矢
% 最終更新者  :2021/3/2 竹田 賢矢
% =======================================================================================================
clear all
close all 

clc
%% === パスの追加 ===
%==========%
SP_Path_set
%==========%
% addpath('inputData/inputData_2DOF_Pendulum')
%addpath('inputData/inputData_Acrobot_DU')
addpath('inputData/inputData_2DOF_Pendulum') 
%% === 安定多様体アルゴリズム ===
%===================%
P1_data_setting                       % プログラム1 : 共通のパラメータの設定
P2_hamiltonian_check                  % プログラム2 : 与えるξに対する収束半径の確認
P3_decide_xi                          % プログラム3 : x(t), p(t)を求めるための初期値ξの個数の決定
%===================%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n')
strknum = strcat('knum = ',num2str(knum),',');
strradi = strcat('radi = ',num2str(radi),',');
strtotalxi = strcat('total num of xis = ',num2str(ini_row),',');
strtotalcomp = strcat('total number of comp = ',num2str(total),',');
fprintf(strknum),fprintf('\t'), fprintf(strradi), fprintf('\t'), fprintf(strtotalxi), fprintf('\n')
fprintf(strtotalcomp),fprintf('\n')
fprintf('Option for positive direc.: '),fprintf(str_op_pos),fprintf('\n')
fprintf('Option for negative direc.: '),fprintf(str_op_neg),fprintf('\n')
fprintf('Press any key to continue')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;                                  % 繰り返し計算の計算時間計測開始
P4_iterative_calcu                    % プログラム4 :ξに対してx(t), p(t)を求める繰り返し演算
toc                                   % 繰り返し計算の計算時間計測終了
%% === イタレーション結果プロット ===
P5_Plot_all_shootingline