function du = f_inputcalcu(x,p,R)
% ==================================================================
% du = f_inputcalcu(x,p,R)                                          
%                                                                   
% F_INPUTCALCU  Å“K“ü—Í‚ÌŒvZ                                     
%                                                                   
% - 1/2*R^(-1)*g(x)'p‚ğŒvZ‚·‚é.            
%                                                                   
% input                                                             
%  - x  : ŒJ‚è•Ô‚µ‰‰Z‚Å‹‚ß‚ç‚ê‚éx(ŸŒ³‚Í–â‚í‚¸)                   
%  - p  : ŒJ‚è•Ô‚µ‰‰Z‚Å‹‚ß‚ç‚ê‚ép(x‚ÌŸŒ³, s”‚Æˆê’v‚µ‚Ä‚¢‚é‚±‚Æ)
%  - R  : •]‰¿ŠÖ”‚ÌR                                               
%                                                                   
% output                                                            
%  - du : Å“K“ü—Í u                                               
%                                                                   
% created : K.Ueno                                               
% ==================================================================
global umin umax satFlag dim B

[row,col] = size(x);
du = zeros(row,size(B,2));

for i = 1:row

	tmp_x = x(i,:)';
	
	tmp_p = p(i,:)';

	if satFlag == 0

		du(i,:) =( - (1/2) * R^(-1) * g(tmp_x)' * tmp_p)';

	elseif satFlag == 1

		du(i,:) = ( f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin,umax))';
        
    elseif satFlag ==2
        
        du(i,:) = ( f_Sat(-1/2*R^(-1)*g(tmp_x)'*tmp_p,umin+tmp_x(dim,1),umax+tmp_x(dim,1)))';

    
	end
end
