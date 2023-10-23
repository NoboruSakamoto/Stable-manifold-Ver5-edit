function [value,isterminal,direction] = termination1(t,u)
% ============================================================
% [value,isterminal,direction] = TERMINATION1(T,U)            
%                                                             
% k < kmax�̂Ƃ��̐ϕ��v�Z�̃I�v�V����                        
% x��p�̒l��������l�ȏ�ɂȂ����ꍇ, �ϕ��̌v�Z���~����. 
% ============================================================
global dim top_btm

value = abs(u) - abs(top_btm);
isterminal = ones(dim*2,1);   % Stop the integration
direction = zeros(dim*2,1);   % Negative direction only