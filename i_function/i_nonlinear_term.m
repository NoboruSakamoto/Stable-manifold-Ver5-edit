function du = i_nonlinear_term(x)
% ==============================================
% ��ԕ������̒��̔���`���̒�`                
%                                               
% i_state_eq_for_control.m�̒��Ŏg�p����Ă���  
% �P�̂ł̎g�p�͕s��                            
%                                               
% created : Y.Umemura                           
% ==============================================

global A

du = f(x) - A * x;
