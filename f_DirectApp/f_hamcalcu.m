function du = f_hamcalcu(x,p,Q,R)
% ==================================================================
% du = f_hamcalcu(x,p,Q,R)                                          
%                                                                   
% F_HAMCALCU  Hamiltonian�̌v�Z                                     
%                                                                   
% p'*f(x) - 1/4*p'*g(x)*R^(-1)*g(x)' + x'*Q*x���v�Z����.            
%                                                                   
% input                                                             
%  - x  : �J��Ԃ����Z�ŋ��߂���x(�����͖�킸)                   
%  - p  : �J��Ԃ����Z�ŋ��߂���p(x�̎���, �s���ƈ�v���Ă��邱��)
%  - Q  : �]���֐���Q                                               
%  - R  : �]���֐���R                                               
%                                                                   
% output                                                            
%  - du : hamiltonian                                               
%                                                                   
% created : Y.Umemura                                               
% ==================================================================
global umin umax satFlag dim

[row,col] = size(x);
du = zeros(row,1);

for i = 1:row

	tmp_x = x(i,:)';
	
	tmp_p = p(i,:)';

	if satFlag == 0

		du(i) = tmp_p' * f(tmp_x) - (1/4) * tmp_p' * g(tmp_x) * R^(-1) * g(tmp_x)' * tmp_p + tmp_x' * Q * tmp_x;

	elseif satFlag == 1

		du(i) =  tmp_p' * f(tmp_x) + tmp_x' * Q * tmp_x - (1/4) * tmp_p' * g(tmp_x) * R^(-1) * g(tmp_x)' * tmp_p ...
               + (f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin,umax) + 1/2*R^(-1)*g(tmp_x)'*tmp_p)'*R*(f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin,umax)+1/2*R^(-1)*g(tmp_x)'*tmp_p);

    elseif satFlag ==2
        
        du(i) =  tmp_p' * f(tmp_x) + tmp_x' * Q * tmp_x - (1/4) * tmp_p' * g(tmp_x) * R^(-1) * g(tmp_x)' * tmp_p ...
               + (f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin+tmp_x(dim,1),umax+tmp_x(dim,1)) + 1/2*R^(-1)*g(tmp_x)'*tmp_p)'*R*(f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin+tmp_x(dim,1),umax+tmp_x(dim,1))+1/2*R^(-1)*g(tmp_x)'*tmp_p);

    
	end
end
