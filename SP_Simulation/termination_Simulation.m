function [value,isterminal,direction] = termination_Simulation(t,fout)
% =======================================================================================================
% [value,isterminal,direction] = TERMINATION_SIMULATION(T,FOUT)
% 状態量・入力の値がある一定値以上になった場合, 積分の計算を停止する.
% SP_response_calcu.m で使用
% ※tがある程度大きくならないと積分停止機能が動作しないためそれまで必ずイベント検知を行わない処理を実装
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
global C xc Input_check State_check 
value=1;
Input_V = prod((fout*ones(1,size(xc,2))).^xc) * C ;       %最適入力の計算
%
if norm(Input_V) > Input_check || norm(fout) > State_check 
    value=-1;%検出したらvalueの符号を変える(符号が確実に変わるため検出漏れを回避)
    if t<1e-3 %tが極端に小さい場合イベント検知後の積分計算停止が行われないため，停止する際は1e-3[s]まで計算を行う
       value=1;%t<1e-3[s]までは必ず0crossingしない→イベントを発生させない
    end
end   
isterminal=1;   %積分計算の停止(tが極端に小さい場合動作しないため上述の処理を実装)
direction=-1;   %イベント発生時valueは1→-1へ変化するためイベント検知方向は-1
