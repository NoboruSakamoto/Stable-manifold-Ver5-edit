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
global m l g J Q R Tneg_max
global HAMK_n_max_juddge knum dim
global top_btm x_lim satFlag meshFlag
%%
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

xiRFlag  = 0;  % xi�̑傫����systemdata.m�ŗ^���邩�ǂ���(0:Matlab��ŗ^����, 1:systemData.m�ŗ^����)
% Radius of convergence (0:give in the M-window, 0:give in systemData.m)

xiTHFlag = 0;  % xi�̕�����systemdata.m�ŗ^���邩�ǂ���(0:Matlab��ŗ^����, 1:systemData.m�ŗ^����)
% Samples in circumferential direction (0:give in the M-window, 0:give in systemData.m)

iniFlag  = 0;  % The set of xi's (0:give in systemData.m, 0:give in Decide_xi.m)

% ==============================================================
% �V�X�e���̏�Ԃ�\���p�����[�^ / Parameters in system equation
% ==============================================================
%%
% ===============================================
% �V�X�e����` / State space
% ===============================================
m=0.181;%%%%%%%%%%%%%%%%%% �_�̎��ʁi���j
l=0.297;%%%%%%%%%%%%%%%%%% �_�̒���/2�i���j
J=m*(2*l)^2/3;%%%%%%%%%%%%%%%%�U�q�̊������[�����g
g=9.81;
% === ��ԕ�������A�s��AB�s�� / A-matrix, B-matrix ===
A = [ 0   1 ;
    m*g*l/J   0 ];
B = [ 0;
    -l/J];

% === �]���֐���Q�AR (�]���֐���1/2�����Ȃ��`�ŗ^����B) / Q, R in cost function ===
Q = diag([0.01 0]); % diag([10 0.01 100 0.01])
R = 1; % 0.1
% === �V�X�e���̎���(�ҏW���Ȃ��R�g) / System dimension (do not touch) ===
dim = length(A);
%%
% ===============================================
% �݌v�p�p�����[�^ / Design parameters
% ===============================================

% === �ߎ���(kFlag = 1�̏ꍇ�ɒ�`����)
%   / Iteration number (necessary when kFlag = 1) ===
knum = 5;
% === �̂̍ő�l(xiRFlag = 1�̏ꍇ�ɒ�`����)
%   / Radius of convergence (necessary when kFlag = 1) ===
radi = 1;
% === �͈̂̔�(xiTHFlag = 1�̏ꍇ�ɒ�`����) 
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
% === Tneg�̍ő�l / Maximum Tneg ===
Tneg_max = -2;
% === �������ւ̐ϕ����I�������邽�߂�Hamiltonian�̏���
%   / Terminate condition for negative direc. integration ===
HAMK_n_max_juddge  = 1e-1;

% === �ϕ����Ԃ����߂邽�߂̋Ɍ����f�p�p�����[�^ / Parameters for integration interval (pos. direction)
tol = 1e-10;                              % - �Ɍ����f�̂��߂�臒l / Threshold value of 0-limit

% === ode�֐��p�̐ݒ� / ode options ===
options_pos = odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12);
str_op_pos = "odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12)";% copy above
options_neg = odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12);
str_op_neg = "odeset('RelTol',1e-9, 'AbsTol',1e-9,'Events',@termination,'Refine',50,'InitialStep',1e-12)";% copy above

% === �v�Z���ʂ̃f�[�^�Ԉ�����(>=1�̐���) / Frequency of thing out data (integer)  ===
param_cull_neg = 5;                       % 1 means no thining out, 2 means 1 data is removed for every 2 data
param_cull_pos = 5;                       % 1 means no thining out, 2 means 1 data is removed for every 2 data

% === �C���f�b�N�X�֐���臒l / Value of cut-off function for nonlinearities ===
top_btm = 1e3;
x_lim = [1.5*pi 10]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Initial_State=[pi,0]; 
Time_int = [ 0 , 5 ];
statename='rad';
inputname='N';

