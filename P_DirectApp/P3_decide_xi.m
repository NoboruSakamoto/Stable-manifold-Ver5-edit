% ==================================================================
% x(t), p(t)�����߂邽�߂̏����l�̂̌��̌���
%
% �����ɉ����ĉ�]�����̕����������߂�.
% - 1�����F���荀�ڂȂ�
% - 2�����Ftheta1
% - 3�����Ftheta1, theta2
% - 4�����Ftheta1, theta2, theta3
%
% generalized for any dimension : Hamaguchi  2013.07.02    
% adopted from 2021/7/21 Sakamoto
% with modification of interchanging cos and sin and removing redundancy.
% =========================================================================

OKNG = 1;

while( OKNG2 ~= 1 )
    
    init_sum = [];
    xi_sum = [];
    
    if iniFlag == 0 % xi's will be computed
        %theta(k)�̃N���A�͉����Ɉړ�
        if xiTHFlag == 0 % Division for xi's is requested in command window
            if dim == 1
            elseif dim >= 2
                span_th1  = input('Divide theta1(0 to 2*pi) : ( Default : 12 ) > ');
                while(isempty(span_th1) == 1)
                    span_th1  = input('Divide theta1(0 to 2*pi) : ( Default : 12 ) > ');
                end
                theta1 = [0,linspace(0,2*pi-(2*pi/span_th1),span_th1)]; 
                if dim >=3
                    for k = 2:dim-1
                        span_tmp=[];
                        txt=['Divide theta',int2str(k),'(0 to pi) : ( Default : 6 ) > '];
                        span_tmp = input(txt);
                        while( isempty(span_tmp) == 1 )
                            span_tmp = input(txt);
                        end
                        eval(['theta',int2str(k),' = linspace(0,pi-(pi/span_tmp),span_tmp);']);
                    end
                end
            end
        end
        
        % Give theta1,2,3,4...
        
        if dim == 1
            init_sum = [radi;-radi];
            xi_sum = [0;0];
        end
        
        if dim > 1 % = 2�����ȏ� =
            init_sum_xp=[];
            xi_sum_tmp=[];
            eval(['it_temp=length(theta',int2str(1),');']); %it_temp=length(theta_{dim-1});
            for it = 1:it_temp
                eval(['theta_tmp=theta',int2str(1),'(it);']); %theta_tmp=theta_{dim-1}(it);
                z1 = cos(theta_tmp);
                z2 = sin(theta_tmp);
                init_sum_xp =horzcat(init_sum_xp,[z1;z2]); % ( x-p��� )
                xi_sum = [ xi_sum; theta_tmp ];
            end
            
            if dim > 2  % = 3�����ȏ� =
                for k = 2:dim-1
                    eval(['it_temp=length(theta',int2str(k),');']); %it_temp=length(theta_{k});
                    z1=[];
                    z2=[];
                    init_sum_tmp=[];
                    xi_sum_tmp=[];
                    [~,ini_col] = size(init_sum_xp);
                    for it = 1:it_temp
                        eval(['theta_tmp=theta',int2str(k),'(it);']); %theta_tmp=theta_{dim-k+1}(it);
                        z1 = init_sum_xp .* sin(theta_tmp);
                        z2 = cos(theta_tmp).*ones(1,ini_col);
                        init_sum_tmp = horzcat(init_sum_tmp,vertcat(z1,z2));
                        xi_sum_tmp = vertcat(xi_sum_tmp,horzcat(xi_sum,theta_tmp.*ones(ini_col,1)));
                    end
                    init_sum_xp=init_sum_tmp;% Sample vectors in unit sphere 
                    xi_sum=xi_sum_tmp;
                end
            end
            init_sum_xp = uniquetol(init_sum_xp','ByRows',true); % remove redundancy 
            init_sum_xp = init_sum_xp';
            init_sum_xp=radi.*init_sum_xp;
            
            [~,ini_col] = size(init_sum_xp);
            
            for it=1:ini_col
                init_sum = [init_sum;(Trs*init_sum_xp(:,it))'];% This includes eigenvectors of F
            end
        end
        
    elseif iniFlag == 1 % xi's are given in Dcide_xi.m
        
        Decide_xi
        xi_sum = init_sum;
    end
    
    [ini_row,ini_col] = size(init_sum);
    total = ini_row*(knum+1);
    
    if xiTHFlag == 0 % % Division for xi's is given in command window
        fprintf('\n')
        fprintf('Total calculation times : %d\n' ,total)
        if dim >= 2
            OKNG2 = input('OK ? NG ? : OK = 1, NG = 2 > ');
            fprintf('\n')
        else
            OKNG2 = 1;
        end
        
        if OKNG2~=1 %%���͂�蒼��������ꍇ
            for k=1:dim-1
                eval(['theta',num2str(k),'=[];']); %theta(k)�̃N���A
            end
        end
        
        if isempty(OKNG2)
            OKNG2 = 0;
        end
    else
        OKNG2 = 1;
    end
end
