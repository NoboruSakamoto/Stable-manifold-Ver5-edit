function du = f_haminput_calcu(x,p,Q,R)
% ==================================================================
% du = f_haminput_calcu(x,p,Q,R)                                          
%                                                                   
% F_HAMINPUT_CALCU  Hamiltonian����эœK���͂̌v�Z                
%                                                                   
% input                                                             
%  - x  : �J��Ԃ����Z�ŋ��߂���x(�����͖�킸)                   
%  - p  : �J��Ԃ����Z�ŋ��߂���p(x�̎���, �s���ƈ�v���Ă��邱��)
%  - Q  : �]���֐���Q                                               
%  - R  : �]���֐���R                                               
%                                                                   
% output                                                            
%  - du : [Hamiltonian, optimal_input']                                               
%                                                                   
% created : K.Ueno                                               
% ==================================================================
global umin umax satFlag dim B

[row,col] = size(x);
du = zeros(row,1+size(B,2)); %% row�s, (1+B�̗�)��du���ł���.

for i = 1:row

	tmp_x = x(i,:)';
	
	tmp_p = p(i,:)';

    if satFlag == 0
        
        optimal_input = -1/2*R^(-1)*g(tmp_x)'*tmp_p;
        
	elseif satFlag == 1
        
        optimal_input = f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin,umax);
        
    elseif satFlag ==2
        
        optimal_input = f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin+tmp_x(dim,1),umax+tmp_x(dim,1));
    
    end
    
	Hamiltonian = tmp_p' * (f(tmp_x) + g(tmp_x) * optimal_input) + tmp_x' * Q * tmp_x + optimal_input' * R * optimal_input;
    
    du(i,:) = [Hamiltonian,optimal_input'];
end
