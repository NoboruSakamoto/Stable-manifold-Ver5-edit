function Jcul = f_costopt(t,x,u,Q,R,Tf)
% ==================================================================
% Jcal = f_costopt(t,x,u,Q,R,Tf)                                    
%                                                                   
% F_COSTOPT  �]���֐��̌v�Z                                         
%                                                                   
% input                                                             
%  - t  : �����v�Z�œ����鎞�ԃx�N�g��                            
%  - x  : �����v�Z�œ������ԃx�N�g��(�s��̌`�ł���)            
%  - u  : �œK�������                                              
%  - Q  : �]���֐���Q                                               
%  - R  : �]���֐���R                                               
%  - Tf : �]���֐��̌v�Z�͈�                                        
%                                                                   
% output                                                            
%  - Jcul : �]���֐��̌v�Z����                                      
%                                                                   
% created : Y.Yuasa                                                 
% ==================================================================

% t�̎���
[trow,tcol]=size(t);

L(1)=x(1,:)*Q*x(1,:)'+u(1,:)*R*u(1,:)'; % �����l
J(1)=0;

if nargin==5
	Tf=t(trow);
end

for i=1:trow-1
	if t(i)>Tf
		break   % Tf�Őϕ��͈͂�؂鑀��
	else
	end

	% �ϕ��v�f
	L(i+1)=x(i+1,:)*Q*x(i+1,:)'+u(i+1,:)*R*u(i+1,:)';
	dt(i+1)=t(i+1)-t(i);
	dJ(i+1)=(L(i+1)+L(i))*dt(i+1)/2; % ��`�� 
	J(i+1)=J(i)+dJ(i+1);
	Jcul=J(i+1);

end