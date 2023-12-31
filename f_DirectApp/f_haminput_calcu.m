function du = f_haminput_calcu(x,p,Q,R)
% ==================================================================
% du = f_haminput_calcu(x,p,Q,R)                                          
%                                                                   
% F_HAMINPUT_CALCU  Hamiltonianおよび最適入力の計算                
%                                                                   
% input                                                             
%  - x  : 繰り返し演算で求められるx(次元は問わず)                   
%  - p  : 繰り返し演算で求められるp(xの次元, 行数と一致していること)
%  - Q  : 評価関数のQ                                               
%  - R  : 評価関数のR                                               
%                                                                   
% output                                                            
%  - du : [Hamiltonian, optimal_input']                                               
%                                                                   
% created : K.Ueno                                               
% ==================================================================
global umin umax satFlag dim B

[row,col] = size(x);
du = zeros(row,1+size(B,2)); %% row行, (1+Bの列数)のduができる.

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
