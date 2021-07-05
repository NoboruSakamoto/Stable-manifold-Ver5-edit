function du = i_nonlinear_term(x)
% ==============================================
% 状態方程式の中の非線形項の定義                
%                                               
% i_state_eq_for_control.mの中で使用されており  
% 単体での使用は不可                            
%                                               
% created : Y.Umemura                           
% ==============================================

global A

du = f(x) - A * x;
