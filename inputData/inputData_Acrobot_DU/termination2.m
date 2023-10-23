function [value,isterminal,direction] = termination1(t,u)
% ============================================================
% [value,isterminal,direction] = TERMINATION1(T,U)            
%                                                             
% k < kmaxのときの積分計算のオプション                        
% xとpの値がある一定値以上になった場合, 積分の計算を停止する. 
% ============================================================
global dim top_btm

value = abs(u) - abs(top_btm);
isterminal = ones(dim*2,1);   % Stop the integration
direction = zeros(dim*2,1);   % Negative direction only