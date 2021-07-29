% ===============================================
% 各計算に必要なデータの設定 / Data settings
%
% 1. システムの状態方程式パラメータ / Parameters in system equation
%   - A行列 / B行列 / A-matrix, B-matrix
%   - 評価関数のQ、R / Wights Q, R in cost function
% 2. Design parameters
%   -Number of iterations
%   -x(t),p(t)を求めるためのtの負方向への積分 / Negative direction integration
%   - 積分を終了するための条件(x,pの大きさ) / Time interval of positive integration
%   - 積分を終了するための条件(Hamiltonianの大きさ) / Termination condition w.r.t. the value of Hamiltonian
% 4. 応答性検証 / Response verification
%   - 初期値x0 / initial value x0
%   - 時間範囲 / Time interval
%
% ===============================================
global A B
global m l g J Q R Tneg_max
global HAMK_n_max_juddge knum dim
global top_btm x_lim satFlag meshFlag
%%
% ===============================================
% 各種フラグ設定 / Option flags
% ===============================================

satFlag  = 0;  % 飽和を含む系かどうか(0:飽和を含まない, 1:飽和を含む, 2:速度飽和を含む)
% Saturation option (0:no saturation, 1:saturation present, 2:rate limit present)

dbFlag   = 0;  % デバッグ用のグラフ表示をするかどうか(0:グラフ表示しない, 1:グラフ表示する)
% Figure option for debuging (0:no figs, 1:figure shown)

meshFlag = 0;  % p(x)をメッシュで表現するかどうか(0:多変数多項式近似, 1：メッシュ)

kFlag    = 1;  % Kをsystemdata.mで与えるかどうか(0:Matlab上で与える, 1:systemData.mで与える)
% Iteration number K (0:give in the M-window, 1:give in systemData.m)

xiRFlag  = 0;  % xiの大きさをsystemdata.mで与えるかどうか(0:Matlab上で与える, 1:systemData.mで与える)
% Radius of convergence (0:give in the M-window, 0:give in systemData.m)

xiTHFlag = 0;  % xiの分割をsystemdata.mで与えるかどうか(0:Matlab上で与える, 1:systemData.mで与える)
% Samples in circumferential direction (0:give in the M-window, 0:give in systemData.m)

iniFlag  = 0;  % The set of xi's (0:give in systemData.m, 0:give in Decide_xi.m)

% ==============================================================
% システムの状態を表すパラメータ / Parameters in system equation
% ==============================================================
%%
% ===============================================
% システム定義 / State space
% ===============================================
m=0.181;%%%%%%%%%%%%%%%%%% 棒の質量（長）
l=0.297;%%%%%%%%%%%%%%%%%% 棒の長さ/2（長）
J=m*(2*l)^2/3;%%%%%%%%%%%%%%%%振子の慣性モーメント
g=9.81;
% === 状態方程式のA行列、B行列 / A-matrix, B-matrix ===
A = [ 0   1 ;
    m*g*l/J   0 ];
B = [ 0;
    -l/J];

% === 評価関数のQ、R (評価関数に1/2がつかない形で与える。) / Q, R in cost function ===
Q = diag([0.01 0]); % diag([10 0.01 100 0.01])
R = 1; % 0.1
% === システムの次元(編集しないコト) / System dimension (do not touch) ===
dim = length(A);
%%
% ===============================================
% 設計用パラメータ / Design parameters
% ===============================================

% === 近似回数(kFlag = 1の場合に定義する)
%   / Iteration number (necessary when kFlag = 1) ===
knum = 5;
% === ξの最大値(xiRFlag = 1の場合に定義する)
%   / Radius of convergence (necessary when kFlag = 1) ===
radi = 1;
% === ξの範囲(xiTHFlag = 1の場合に定義する) 
% This depends on dimension. For the first order, 0<= theta <2pi and for
% the rest 0<=theta<=pi. At theta=0, pi, there causes redundancy. 

% span_th3 =12; % ( Default : 12 )
% theta3 = linspace(0 , pi ,span_th3);
% 
% span_th2 =12; % ( Default : 12 )
% theta2 = linspace(0 , pi ,span_th2);

span_th1 = 12; % ( Default : 12 )
theta1 = linspace(0,  2*pi - (2*pi / span_th1),span_th1);
% === When kFlag = 1 & xiRFlag = 1 & xiTHFlag = 1 ===
% === Tnegの最大値 / Maximum Tneg ===
Tneg_max = -2;
% === 負方向への積分を終了させるためのHamiltonianの条件
%   / Terminate condition for negative direc. integration ===
HAMK_n_max_juddge  = 1e-1;

% === 積分時間を決めるための極限判断用パラメータ / Parameters for integration interval (pos. direction)
tol = 1e-10;                              % - 極限判断のための閾値 / Threshold value of 0-limit

% === ode関数用の設定 / ode options ===
options_pos = odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12);
str_op_pos = "odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12)";% copy above
options_neg = odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12);
str_op_neg = "odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12)";% copy above

% === 計算結果のデータ間引き数(>=1の整数) / Frequency of thing out data (integer)  ===
param_cull_neg = 5;                       % 1 means no thining out, 2 means 1 data is removed for every 2 data
param_cull_pos = 5;                       % 1 means no thining out, 2 means 1 data is removed for every 2 data

% === インデックス関数の閾値 / Value of cut-off function for nonlinearities ===
top_btm = 1e3;
x_lim = [1.5*pi 10]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Initial_State=[pi,0]; 
Time_int = [ 0 , 5 ];
statename='rad';
inputname='N';

