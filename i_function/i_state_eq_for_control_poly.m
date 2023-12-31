function df = i_state_eq_for_control_poly(t,fout)
% ============================== i_state_eq_for_control_poly =============================================
% k ＞ 0における最適制御入力に対する時間応答を求めるための被積分関数
% ver4におけるi_state_eq_for_controlの再作成版(厳密には堀部版の改良)
% 更新に伴いメッシュ近似及び飽和系を削除(更新の際はこの文章を書き換えること)
%
% ode45()の中で使用されており、単体での使用は不可
% 多項式近似による制御器を含んだ被積分関数
% イベント関数によって監視されているが状態量・入力が発散した際出力を0ベクトルとする
%
% created : Y.Umemura
% ver5更新者  :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
global A dim
global C xc
%% === 入力の算出 ===
tmp = prod((fout*ones(1,size(xc,2))).^xc) * C ;
%% === 状態に非線形を持つ系の状態方程式 ===
if norm(tmp) > 20 || norm(fout(1)) > 5
    df = zeros(dim,1);
else
    df = A * fout + i_nonlinear_term(fout) + g(fout) * tmp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


