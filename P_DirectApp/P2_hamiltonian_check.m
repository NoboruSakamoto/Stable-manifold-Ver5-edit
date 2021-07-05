% ====================== P2_hamiltonian_check =======================
% 近似回数 k の決定                                                 
% あるξに対するhamiltonianチェックと収束半径の目処付けと,          
% 半径方向の値の決定                                                
%                                                                   
% systemData.mでξと振り幅(radi_def)を定義し, それぞれのξについて  
% x(t),p(t)を求め, Hamiltonianを計算する.                           
% 求めたHamiltonianから, ξに対する収束半径の目処をつけ, 半径方向の 
% 値を決める.  
% ver5更新者  :2021/2/25 竹田 賢矢
% 最終更新者  :2021/2/25 竹田 賢矢
% ==================================================================
% === initialize ===
OKNG = 255;
global knum_i
init_sum_P2 = [];

if and(iniFlag == 0,or(kFlag == 0,xiRFlag == 0)) % knumを決める 
    while( OKNG ~= 1 )
        radi = input('maximum value of xi > ');
		while( isempty(radi) == 1 )
			radi = input('maximum value of xi > ');
		end
		fprintf('\n')
        knum = input('approximate times : k =  ');
        while isempty(knum) == 1
            knum = input('approximate times : k =  ');
        end
        init_sum_P2 = Trs;
        for i_P2 = 1:size(init_sum_P2,2)
            ini = (init_sum_P2(:,i_P2) * radi);
					% === start : 0→∞の積分における極限を求める ===
					normFt = tol*100;
					t = 0;
					while( abs(normFt) >= tol )
						normFt = norm(expm(F*t)*ini);
						t = t+1;
					end
					stoptime = t;
					% === end : 0→∞の積分における極限を求める ===
					knum_i = 0;
                    color_P2 = [1:-1/(dim-1):0;zeros(1,dim);0:1/(dim-1):1];
					while( knum_i <= knum )
						SP_appNth; % N次近似計算用Mファイル呼び出し
                        xp_t0_D = transpose(Diagonalize * transpose(txp(1,2:dim*2+1))); % ( x'-p'空間 ⇒ x-p空間への変換 )
                        HamkN = f_hamcalcu(xp_t0_D(:,1:dim),xp_t0_D(:,dim+1:dim*2),Q,R);
                        figure(1);plot(knum_i,HamkN,'.','Color',color_P2(:,i_P2),,'MarkerSize',20);grid on;hold on;
                        xlabel('k');ylabel('Hamiltonian @t=0');
						knum_i = knum_i + 1;
					end % while( knum_i == knum )
        end
        fprintf('Parameter : k = %d, radi = %6.5f\n' ,knum,radi)
		OKNG = input(' OK : 1, Change k or radi : 2 > ');
        close all
    end
end
