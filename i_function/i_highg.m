function dx = i_highg(xp)
% ==================================================================
% p�����߂邽�߂̔�ϕ��֐�                                         
%                                                                   
% �����������̑Ίp�����ꂽ����`��G(x,p)�̎�.                       
% i_derectforp(��ϕ��֐�)�̒��Ŏg�p����Ă���A�P�̂ł̎g�p�͕s��  
%                                                                   
% ���jxp�͑Ίp������Ă��Ȃ�.                                       
%                                                                   
% created : Y.Umemura
% 2021/07/15 Sakamoto, Diagonalize \ is replaced with Diag_inv *.
% ==================================================================
global Diagonalize dim Diag_inv

xpt = Diagonalize * xp;
tmpF = HamF(xpt(1:dim),xpt(dim+1:dim*2));
tmpG = HamG(xpt(1:dim),xpt(dim+1:dim*2));
tmp = [tmpF;tmpG];

dx = Diag_inv * tmp;
dx = dx(dim+1:dim*2);