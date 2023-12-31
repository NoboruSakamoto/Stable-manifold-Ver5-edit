function du = f_inputcalcu(x,p,R)
% ==================================================================
% du = f_inputcalcu(x,p,R)                                          
%                                                                   
% F_INPUTCALCU  最適入力の計算                                     
%                                                                   
% - 1/2*R^(-1)*g(x)'pを計算する.            
%                                                                   
% input                                                             
%  - x  : 繰り返し演算で求められるx(次元は問わず)                   
%  - p  : 繰り返し演算で求められるp(xの次元, 行数と一致していること)
%  - R  : 評価関数のR                                               
%                                                                   
% output                                                            
%  - du : 最適入力 u                                               
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
