function du = f_haminput_calcu(x,p,Q,R)
% ==================================================================
% du = f_haminput_calcu(x,p,Q,R)                                          
%                                                                   
% F_HAMINPUT_CALCU  Hamiltonian‚¨‚æ‚ÑÅ“K“ü—Í‚ÌŒvZ                
%                                                                   
% input                                                             
%  - x  : ŒJ‚è•Ô‚µ‰‰Z‚Å‹‚ß‚ç‚ê‚éx(ŸŒ³‚Í–â‚í‚¸)                   
%  - p  : ŒJ‚è•Ô‚µ‰‰Z‚Å‹‚ß‚ç‚ê‚ép(x‚ÌŸŒ³, s”‚Æˆê’v‚µ‚Ä‚¢‚é‚±‚Æ)
%  - Q  : •]‰¿ŠÖ”‚ÌQ                                               
%  - R  : •]‰¿ŠÖ”‚ÌR                                               
%                                                                   
% output                                                            
%  - du : [Hamiltonian, optimal_input']                                               
%                                                                   
% created : K.Ueno                                               
% ==================================================================
global umin umax satFlag dim B

[row,col] = size(x);
du = zeros(row,1+size(B,2)); %% rows, (1+B‚Ì—ñ”)‚Ìdu‚ª‚Å‚«‚é.

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
