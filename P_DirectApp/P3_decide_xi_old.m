% ======================= P3_decide_xi ==============================
% x(t), p(t)を求めるための初期値ξの個数の決定                      
%                                                                   
% 次数に応じて回転方向の分割数を決める.                             
% - 1次元：決定項目なし                                             
% - 2次元：theta4                                                   
% - 3次元：theta4, theta3                                           
% - 4次元：theta4, theta3, theta2                                   
% - 5次元：theta4, theta3, theta2, theta1 
% ver5更新者  :2021/2/25 竹田 賢矢
% 最終更新者  :2021/2/25 竹田 賢矢
% this will be replaced by Hamguchi's version (2021/7/16)
% ==================================================================

OKNG = 1;

while( OKNG2 ~= 1 )

	init_sum = [];
	xi_sum = [];

	if iniFlag == 0
		if dim == 1
			theta4 = [];
			theta3 = [];
			theta2 = [];
			theta1 = [];
		elseif dim == 2
			theta3 = [];
			theta2 = [];
			theta1 = [];
		elseif dim == 3
			theta2 = [];
			theta1 = [];
		elseif dim == 4
			theta1 = [];
		end

		if xiTHFlag == 0
			if dim == 1
			elseif dim >= 2
				span_th4  = input('Divide theta4(0 to 2*pi) : ( Default : 12 ) > ');
				while( isempty(span_th4) == 1 )
					span_th4  = input('Divide theta4(0 to 2*pi) : ( Default : 12 ) > ');
				end
				theta4 = linspace(0,2*pi-(2*pi/span_th4),span_th4);

				if dim >= 3
					span_th3  = input('Divide theta3(0 to pi) : ( Default : 6 ) > ');
					while( isempty(span_th3) == 1 )
						span_th3  = input('Divide theta3(0 to pi) : ( Default : 6 ) > ');
					end
					theta3 = linspace(0,pi-(pi/span_th3),span_th3);

					if dim >= 4
						span_th2  = input('Divide theta2(0 to pi) : ( Default : 6 ) > ');
						while( isempty(span_th2) == 1 )
							span_th2  = input('Divide theta2(0 to pi) : ( Default : 6 ) > ');
						end
						theta2 = linspace(0,pi-(pi/span_th2),span_th2);

						if dim >= 5
							span_th1  = input('Divide theta1(0 to pi) : ( Default : 6 ) > ');
							while( isempty(span_th1) == 1 )
								span_th1  = input('Divide theta1(0 to pi) : ( Default : 6 ) > ');
							end
							theta1 = linspace(0,pi-(pi/span_th1),span_th1);
						end
					end
				end
			end
		end
		
		% Give theta1,2,3,4 

		if dim == 1
			init_sum = radi;
			xi_sum = 0;
        end

        
		for it4 = 1:length(theta4)
			if dim == 2 % = 2次元システム = 
				z4 = radi * cos(theta4(it4));
				z5 = radi * sin(theta4(it4));
				init_sum =[ init_sum; transpose(Trs*[z4 , z5]')]; % ( x'-p'空間 )
				xi_sum = [ xi_sum; theta4(it4) ];
			end

			for it3 = 1:length(theta3)
				if dim == 3 % = 3次元システム = 
					z3 = radi * cos(theta3(it3)) * cos(theta4(it4));
					z4 = radi * sin(theta3(it3)) * cos(theta4(it4));
					z5 = radi * sin(theta4(it4));
					init_sum =[ init_sum; transpose(Trs*[z3, z4 , z5]')]; % ( x'-p'空間 )
					xi_sum = [ xi_sum; theta4(it4),theta3(it3) ];
				end

				for it2 = 1:length(theta2)
					if dim == 4 % = 4次元システム = 
						z2 = radi * cos(theta2(it2)) * cos(theta3(it3)) * cos(theta4(it4));
						z3 = radi * sin(theta2(it2)) * cos(theta3(it3)) * cos(theta4(it4));
						z4 = radi * sin(theta3(it3)) * cos(theta4(it4));
						z5 = radi * sin(theta4(it4));
						init_sum =[ init_sum; transpose(Trs*[z2, z3, z4 , z5]')]; % ( x'-p'空間 )
						xi_sum = [ xi_sum; theta4(it4),theta3(it3),theta2(it2) ];
					end

					for it1 = 1:length(theta1)
						if dim == 5 % = 5次元システム = 
							z1 = radi * cos(theta1(it1)) * cos(theta2(it2)) * cos(theta3(it3)) * cos(theta4(it4));
							z2 = radi * sin(theta1(it1)) * cos(theta2(it2)) * cos(theta3(it3)) * cos(theta4(it4));
							z3 = radi * sin(theta2(it2)) * cos(theta3(it3)) * cos(theta4(it4));
							z4 = radi * sin(theta3(it3)) * cos(theta4(it4));
							z5 = radi * sin(theta4(it4));
							init_sum = [ init_sum; transpose(Trs*[z1, z2, z3, z4 , z5]')]; % ( x'-p'空間 )
							xi_sum = [ xi_sum; theta4(it4),theta3(it3),theta2(it2),theta1(it1)  ];
						end
					end
				end
			end
		end
	elseif iniFlag == 1

		Decide_xi
		xi_sum = init_sum;
        fprintf('xi set from Decide_xi.m')
	end

	[ini_row,ini_col] = size(init_sum);
	total = ini_row*(knum+1);
	fprintf('\n')	
	fprintf('Total calculation times : %d\n' ,total)
    
	if xiTHFlag == 0
		if dim >= 2
			OKNG2 = input('OK ? NG ? : OK = 1, NG = 2 > ');
			fprintf('\n')
		else
			OKNG2 = 1;
		end

		if isempty(OKNG2)
			OKNG2 = 0;
		end
	else
		OKNG2 = 1;
	end
end
