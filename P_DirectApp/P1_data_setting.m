% =========================== P1_data_setting =============================
% 共通パラメータの設定ファイル読み込み
% Riccati方程式Lyapunov方程式を解いて対角行列と対角化行列を求める.
% 評価関数を    \int_0^{\infty} x^T Q x + u^T R u dt，
% 線形最適制御におけるハミルトンヤコビの解を　　V = 1/2 x^T P x　　とする.
% ver4におけるP1_data_setting.m,SP_diag_inv.mを統合
% DirectAppで使用
% ver5更新者  :2021/2/25 竹田 賢矢
% 最終更新者  :2021/3/2 竹田 賢矢
% 2021/7/15 Sakamoto, Diagonalize^(-1) is replaced with Diag_inv
% ==========================================================================
global P F Ft Diagonalize Diag_inv Ham time_g xp_sp
systemData    % 状態方程式の各行列の定義
Rbar = B * (2*R)^(-1) * B';
%% === P * A + A' * P -1/2* P * B * R^-1 * B' * P + 2*Q = 0 の解 Pを求め, 対角行列を求める ===
P = care(A,B,2*Q,2*R);
F_tmp = [ A - Rbar * P,           zeros(dim);
    zeros(dim), -1*transpose((A - Rbar * P))  ];
F = F_tmp(1:dim,1:dim);
Ft = F';
%% === 求めたPを使ってLyapunov方程式の解を求め, 対角化行列を求める ===
L = lyap(A - Rbar*P,-Rbar);
%資料ではW
Diagonalize = [ eye(dim), L            ;
    P,        P*L+eye(dim)];
Diag_inv = [eye(dim)+L*P, -L; 
                -P, eye(dim)];  %Diagonalize^(-1); changed using simplectic property
Ham = [A,-Rbar;-2*Q,-A'];
%% === 各種行列表示 ===
% Trs consists of real eigenvectors v1,...,vn with
% Re(lambda1)<Re(lambda2)<...<Re(lambdan)<0 and the last column in Trs
% corresponds to the eigenvalue with weakest damping
fprintf('\n')
fprintf('Diagonalization check : \n Diagonalize^(-1) * Ham * Diagonalize=\n')
disp(Diag_inv * Ham * Diagonalize)
fprintf('\n')
%
[eigF,Trs] = ordblk(F,'real');
Trs = Trs*rot90(eye(dim));
%
fprintf('\n')
fprintf('Eigenvalues of F ordered accorging to distance from imaginary axis \n')
disp(diag(rot90(eye(dim))*eigF*rot90(eye(dim))))
fprintf('Real Jordan canonical form of F \n')
disp(rot90(eye(dim))*eigF*rot90(eye(dim)))
fprintf('\n Trs^(-1) * F * Trs \n')
disp(Trs\F*Trs)
%% === 計算に使用する各フラグのinit処理 ===
OKNG2 = 0;
Ham1Flag = 0;
negEndFlag = 0;
knum_old = 255;