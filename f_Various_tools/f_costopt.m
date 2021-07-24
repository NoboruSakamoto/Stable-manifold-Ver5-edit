function Jcul = f_costopt(t,x,u,Q,R,Tf)
% ==================================================================
% Jcal = f_costopt(t,x,u,Q,R,Tf)                                    
%                                                                   
% F_COSTOPT  評価関数の計算                                         
%                                                                   
% input                                                             
%  - t  : 応答計算で得られる時間ベクトル                            
%  - x  : 応答計算で得られる状態ベクトル(行列の形でも可)            
%  - u  : 最適制御入力                                              
%  - Q  : 評価関数のQ                                               
%  - R  : 評価関数のR                                               
%  - Tf : 評価関数の計算範囲                                        
%                                                                   
% output                                                            
%  - Jcul : 評価関数の計算結果                                      
%                                                                   
% created : Y.Yuasa                                                 
% ==================================================================

% tの次元
[trow,tcol]=size(t);

L(1)=x(1,:)*Q*x(1,:)'+u(1,:)*R*u(1,:)'; % 初期値
J(1)=0;

if nargin==5
	Tf=t(trow);
end

for i=1:trow-1
	if t(i)>Tf
		break   % Tfで積分範囲を切る操作
	else
	end

	% 積分要素
	L(i+1)=x(i+1,:)*Q*x(i+1,:)'+u(i+1,:)*R*u(i+1,:)';
	dt(i+1)=t(i+1)-t(i);
	dJ(i+1)=(L(i+1)+L(i))*dt(i+1)/2; % 台形則 
	J(i+1)=J(i)+dJ(i+1);
	Jcul=J(i+1);

end