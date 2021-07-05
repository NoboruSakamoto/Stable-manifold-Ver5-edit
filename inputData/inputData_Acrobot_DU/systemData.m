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
global R Q
global aa1 aa2 aa3 bb1 bb2 n Kdc mu2 mu1
global target1 target2 target3 target4 target5 target6
global HAMK_n_max_juddge knum dim
global top_btm satFlag meshFlag
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

xiRFlag  = 1;  % xiの大きさをsystemdata.mで与えるかどうか(0:Matlab上で与える, 1:systemData.mで与える)
% Radius of convergence (0:give in the M-window, 0:give in systemData.m)

xiTHFlag = 1;  % xiの分割をsystemdata.mで与えるかどうか(0:Matlab上で与える, 1:systemData.mで与える)
% Samples in circumferential direction (0:give in the M-window, 0:give in systemData.m)

iniFlag  = 0; % The set of xi's (0:give in systemData.m, 1:give in Decide_xi.m)

calcuFlag = 0; % Shootingを狙った点に到達するまで計算させるかどうか.(0:一様に保存, 1:狙った点のみ保存)

% ==============================================================
% システムの状態を表すパラメータ / Parameters in system equation
% ==============================================================

% === 状態方程式のA行列、B行列 / A-matrix, B-matrix ===

%% Acrobot parameter, 行列定義
global m1 m2 L1 L2 Lc1 Lc2 J1 J2 g0
%% 最新
m1 = 0.850; % [kg]
m2 = 0.420; % [kg]
L1 = 0.154; % [m]
L2 = 0.210; % [m]
Lc1 = -0.0189; % [m] -0.017
Lc2 =  0.0743; % [m]  0.076
J1 = 6.25e-3; % [kg]
J2 = 4.48e-3; % [kg]
n = 48/14; % ギア比
mu1=0;
mu2 = 0.015; % リンク間の粘性摩擦係数
Kdc = 0.016; % 逆起電力定数
g0 = 9.80665;

aa1 = m2 * L1 ^ 2 + m1 * Lc1 ^ 2 + J1;
aa2 = m2 * Lc2 ^ 2 + J2;
aa3 = m2 * L1 * Lc2;
bb1 = (m2 * L1 + m1 * Lc1) * g0;
bb2 = m2 * Lc2 * g0;
%down/down
A = [0 0 1 0; 0 0 0 1; -(aa2 * bb1 - aa3 * bb2) / (aa1 * aa2 - aa3 ^ 2) bb2 * aa3 / (aa1 * aa2 - aa3 ^ 2) -aa2 * mu1 / (aa1 * aa2 - aa3 ^ 2) mu2 * (aa2 - aa3) / (aa1 * aa2 - aa3 ^ 2); (aa1 * bb2 + aa2 * bb1 - aa3 * bb1 - aa3 * bb2) / (aa1 * aa2 - aa3 ^ 2) bb2 * (aa1 - aa3) / (aa1 * aa2 - aa3 ^ 2) mu1 * (aa2 - aa3) / (aa1 * aa2 - aa3 ^ 2) -mu2 * (aa1 + aa2 - 2 * aa3) / (aa1 * aa2 - aa3 ^ 2);];
B = [0; 0; -(aa2 - aa3) * n * Kdc / (aa1 * aa2 - aa3 ^ 2); (aa1 + aa2 - 2 * aa3) * n * Kdc / (aa1 * aa2 - aa3 ^ 2);];


% === 評価関数のQ、R (評価関数に1/2がつかない形で与える。) / Q, R in cost function ===
%% 2016 12/13 Nominal Swing_up
Q = diag([2.5000    0.1000    0.05000    0.0100]);
R = 1;
% === システムの次元(編集しないコト) / System dimension (do not touch) ===
global dim
dim = length(A);
% ===============================================
%           設計用パラメータ / Design parameters
% ===============================================
% === 近似回数(kFlag = 1の場合に定義する)
%   / Iteration number (necessary when kFlag = 1) ===
knum = 3;
% === ξの最大値(xiRFlag = 1の場合に定義する)
%   radi > 1とする場合, Hamiltonianの値をよく確認すること.
%   / Radius of convergence (necessary when kFlag = 1) ===
radi=0.6;
radi = 1;
% === ξの範囲(xiTHFlag = 1の場合に定義する)
span_th4 =6; % ( Default : 12 )
theta4 = linspace(0 , 2*pi - (2*pi/span_th4) ,span_th4);

span_th3 =6; % ( Default : 12 )
theta3 = linspace(0 , pi - (pi / span_th3),span_th3);

span_th2 = 6; % ( Default : 12 )
theta2 = linspace(0,  pi - (pi / span_th2),span_th2);
% === When kFlag = 1 & xiRFlag = 1 & xiTHFlag = 1 ===
% === Tnegの最大値 / Maximum Tneg ===
Tneg_max = -3;
% === 負方向への積分を終了させるためのHamiltonianの条件
%   / Terminate condition for negative direc. integration ===
HAMK_n_max_juddge  = 1e-3;
% === 積分時間を決めるための極限判断用パラメータ / Parameters for integration interval (pos. direction)
tol = 1e-10;    % - 極限判断のための閾値 / Threshold value of 0-limit

% === ode関数用の設定 / ode options ===
options_pos = odeset('RelTol',1e-6, 'AbsTol',1e-6,'Events',@termination,'Refine',50,'InitialStep',1e-12);
options_neg = odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12);

% === 計算結果のデータ間引き数(>=1の整数) / Frequency of thing out data (integer) ===
param_cull_neg = 300; % 1 means no thining out, 2 means 1 data is removed for every 2 data
param_cull_pos = 200; % 1 means no thining out, 2 means 1 data is removed for every 2 data


% === インデックス関数の閾値 / Value of cut-off function for nonlinearities === %

%% calcuFlag = 1 の時に使用する. termination 5で使用する
global num_shooting shooting_lim nnn
shooting_lim = 10; %% 保存する解軌道の上限 > 0
num_shooting = 0; %%
nnn = [];

%    global w1 w2 w3 w4 gaptol target
global gaptol target w
%     w1 = 5.0e1; %% x1に関する重み
%     w2 = 5.0e1; %% x2に関する重み
%     w3 = 2e-1;  %% x3に関する重み
%     w4 = 2e-1;  %% x4に関する重み
w1 = 2.5e0; %% x1に関する重み
w2 = 2.5e0; %% x2に関する重み
w3 = 5e-1;  %% x3に関する重み
w4 = 5e-1;  %% x4に関する重み

w = [w1, w2,w3, w4];
gaptol = 1;
%    target = [pi , 0 , 0 , 0]';
%upup
target1 = [pi , pi , 0 , 0];
target2 = [-pi , -pi , 0 , 0];
target3 = [pi , -pi , 0 , 0];
target4 = [-pi , pi , 0 , 0];
%updown
target5 = [pi , 0 , 0 , 0];
target6 = [-pi , 0 , 0 , 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


top_btm = 1e3;
global x_lim u_lim
x_lim = [1.5 * pi 1.5*pi 25 25]';
u_lim =20; %% termination4で使用する.
stoptime_lim = 15;
stoptime_check=[];
% ===============================================
% 応答性検証用パラメータ
% ===============================================
% === 応答性を見るときの初期値 ===
Initial_State=[pi,-pi,0,0];      %UUtoDU pmp
Initial_State=[pi,pi,0,0];       %UUtoDU pp
Initial_State=[-pi,0,0,0];       %UDtoDU
% === 積分時間の定義 ===
Time_int = [ 0 , 10 ];
% === グラフのラベル ===
statename='rad';
inputname='V';