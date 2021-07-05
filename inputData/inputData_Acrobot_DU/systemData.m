% ===============================================
% �e�v�Z�ɕK�v�ȃf�[�^�̐ݒ� / Data settings
%
% 1. �V�X�e���̏�ԕ������p�����[�^ / Parameters in system equation
%   - A�s�� / B�s�� / A-matrix, B-matrix
%   - �]���֐���Q�AR / Wights Q, R in cost function
% 2. Design parameters
%   -Number of iterations
%   -x(t),p(t)�����߂邽�߂�t�̕������ւ̐ϕ� / Negative direction integration
%   - �ϕ����I�����邽�߂̏���(x,p�̑傫��) / Time interval of positive integration
%   - �ϕ����I�����邽�߂̏���(Hamiltonian�̑傫��) / Termination condition w.r.t. the value of Hamiltonian
% 4. ���������� / Response verification
%   - �����lx0 / initial value x0
%   - ���Ԕ͈� / Time interval
%
% ===============================================
global A B
global R Q
global aa1 aa2 aa3 bb1 bb2 n Kdc mu2 mu1
global target1 target2 target3 target4 target5 target6
global HAMK_n_max_juddge knum dim
global top_btm satFlag meshFlag
% ===============================================
% �e��t���O�ݒ� / Option flags
% ===============================================

satFlag  = 0;  % �O�a���܂ތn���ǂ���(0:�O�a���܂܂Ȃ�, 1:�O�a���܂�, 2:���x�O�a���܂�)
% Saturation option (0:no saturation, 1:saturation present, 2:rate limit present)

dbFlag   = 0;  % �f�o�b�O�p�̃O���t�\�������邩�ǂ���(0:�O���t�\�����Ȃ�, 1:�O���t�\������)
% Figure option for debuging (0:no figs, 1:figure shown)

meshFlag = 0;  % p(x)�����b�V���ŕ\�����邩�ǂ���(0:���ϐ��������ߎ�, 1�F���b�V��)

kFlag    = 1;  % K��systemdata.m�ŗ^���邩�ǂ���(0:Matlab��ŗ^����, 1:systemData.m�ŗ^����)
% Iteration number K (0:give in the M-window, 1:give in systemData.m)

xiRFlag  = 1;  % xi�̑傫����systemdata.m�ŗ^���邩�ǂ���(0:Matlab��ŗ^����, 1:systemData.m�ŗ^����)
% Radius of convergence (0:give in the M-window, 0:give in systemData.m)

xiTHFlag = 1;  % xi�̕�����systemdata.m�ŗ^���邩�ǂ���(0:Matlab��ŗ^����, 1:systemData.m�ŗ^����)
% Samples in circumferential direction (0:give in the M-window, 0:give in systemData.m)

iniFlag  = 0; % The set of xi's (0:give in systemData.m, 1:give in Decide_xi.m)

calcuFlag = 0; % Shooting��_�����_�ɓ��B����܂Ōv�Z�����邩�ǂ���.(0:��l�ɕۑ�, 1:�_�����_�̂ݕۑ�)

% ==============================================================
% �V�X�e���̏�Ԃ�\���p�����[�^ / Parameters in system equation
% ==============================================================

% === ��ԕ�������A�s��AB�s�� / A-matrix, B-matrix ===

%% Acrobot parameter, �s���`
global m1 m2 L1 L2 Lc1 Lc2 J1 J2 g0
%% �ŐV
m1 = 0.850; % [kg]
m2 = 0.420; % [kg]
L1 = 0.154; % [m]
L2 = 0.210; % [m]
Lc1 = -0.0189; % [m] -0.017
Lc2 =  0.0743; % [m]  0.076
J1 = 6.25e-3; % [kg]
J2 = 4.48e-3; % [kg]
n = 48/14; % �M�A��
mu1=0;
mu2 = 0.015; % �����N�Ԃ̔S�����C�W��
Kdc = 0.016; % �t�N�d�͒萔
g0 = 9.80665;

aa1 = m2 * L1 ^ 2 + m1 * Lc1 ^ 2 + J1;
aa2 = m2 * Lc2 ^ 2 + J2;
aa3 = m2 * L1 * Lc2;
bb1 = (m2 * L1 + m1 * Lc1) * g0;
bb2 = m2 * Lc2 * g0;
%down/down
A = [0 0 1 0; 0 0 0 1; -(aa2 * bb1 - aa3 * bb2) / (aa1 * aa2 - aa3 ^ 2) bb2 * aa3 / (aa1 * aa2 - aa3 ^ 2) -aa2 * mu1 / (aa1 * aa2 - aa3 ^ 2) mu2 * (aa2 - aa3) / (aa1 * aa2 - aa3 ^ 2); (aa1 * bb2 + aa2 * bb1 - aa3 * bb1 - aa3 * bb2) / (aa1 * aa2 - aa3 ^ 2) bb2 * (aa1 - aa3) / (aa1 * aa2 - aa3 ^ 2) mu1 * (aa2 - aa3) / (aa1 * aa2 - aa3 ^ 2) -mu2 * (aa1 + aa2 - 2 * aa3) / (aa1 * aa2 - aa3 ^ 2);];
B = [0; 0; -(aa2 - aa3) * n * Kdc / (aa1 * aa2 - aa3 ^ 2); (aa1 + aa2 - 2 * aa3) * n * Kdc / (aa1 * aa2 - aa3 ^ 2);];


% === �]���֐���Q�AR (�]���֐���1/2�����Ȃ��`�ŗ^����B) / Q, R in cost function ===
%% 2016 12/13 Nominal Swing_up
Q = diag([2.5000    0.1000    0.05000    0.0100]);
R = 1;
% === �V�X�e���̎���(�ҏW���Ȃ��R�g) / System dimension (do not touch) ===
global dim
dim = length(A);
% ===============================================
%           �݌v�p�p�����[�^ / Design parameters
% ===============================================
% === �ߎ���(kFlag = 1�̏ꍇ�ɒ�`����)
%   / Iteration number (necessary when kFlag = 1) ===
knum = 3;
% === �̂̍ő�l(xiRFlag = 1�̏ꍇ�ɒ�`����)
%   radi > 1�Ƃ���ꍇ, Hamiltonian�̒l���悭�m�F���邱��.
%   / Radius of convergence (necessary when kFlag = 1) ===
radi=0.6;
radi = 1;
% === �͈̂̔�(xiTHFlag = 1�̏ꍇ�ɒ�`����)
span_th4 =6; % ( Default : 12 )
theta4 = linspace(0 , 2*pi - (2*pi/span_th4) ,span_th4);

span_th3 =6; % ( Default : 12 )
theta3 = linspace(0 , pi - (pi / span_th3),span_th3);

span_th2 = 6; % ( Default : 12 )
theta2 = linspace(0,  pi - (pi / span_th2),span_th2);
% === When kFlag = 1 & xiRFlag = 1 & xiTHFlag = 1 ===
% === Tneg�̍ő�l / Maximum Tneg ===
Tneg_max = -3;
% === �������ւ̐ϕ����I�������邽�߂�Hamiltonian�̏���
%   / Terminate condition for negative direc. integration ===
HAMK_n_max_juddge  = 1e-3;
% === �ϕ����Ԃ����߂邽�߂̋Ɍ����f�p�p�����[�^ / Parameters for integration interval (pos. direction)
tol = 1e-10;    % - �Ɍ����f�̂��߂�臒l / Threshold value of 0-limit

% === ode�֐��p�̐ݒ� / ode options ===
options_pos = odeset('RelTol',1e-6, 'AbsTol',1e-6,'Events',@termination,'Refine',50,'InitialStep',1e-12);
options_neg = odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12);

% === �v�Z���ʂ̃f�[�^�Ԉ�����(>=1�̐���) / Frequency of thing out data (integer) ===
param_cull_neg = 300; % 1 means no thining out, 2 means 1 data is removed for every 2 data
param_cull_pos = 200; % 1 means no thining out, 2 means 1 data is removed for every 2 data


% === �C���f�b�N�X�֐���臒l / Value of cut-off function for nonlinearities === %

%% calcuFlag = 1 �̎��Ɏg�p����. termination 5�Ŏg�p����
global num_shooting shooting_lim nnn
shooting_lim = 10; %% �ۑ�������O���̏�� > 0
num_shooting = 0; %%
nnn = [];

%    global w1 w2 w3 w4 gaptol target
global gaptol target w
%     w1 = 5.0e1; %% x1�Ɋւ���d��
%     w2 = 5.0e1; %% x2�Ɋւ���d��
%     w3 = 2e-1;  %% x3�Ɋւ���d��
%     w4 = 2e-1;  %% x4�Ɋւ���d��
w1 = 2.5e0; %% x1�Ɋւ���d��
w2 = 2.5e0; %% x2�Ɋւ���d��
w3 = 5e-1;  %% x3�Ɋւ���d��
w4 = 5e-1;  %% x4�Ɋւ���d��

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
u_lim =20; %% termination4�Ŏg�p����.
stoptime_lim = 15;
stoptime_check=[];
% ===============================================
% ���������ؗp�p�����[�^
% ===============================================
% === ������������Ƃ��̏����l ===
Initial_State=[pi,-pi,0,0];      %UUtoDU pmp
Initial_State=[pi,pi,0,0];       %UUtoDU pp
Initial_State=[-pi,0,0,0];       %UDtoDU
% === �ϕ����Ԃ̒�` ===
Time_int = [ 0 , 10 ];
% === �O���t�̃��x�� ===
statename='rad';
inputname='V';