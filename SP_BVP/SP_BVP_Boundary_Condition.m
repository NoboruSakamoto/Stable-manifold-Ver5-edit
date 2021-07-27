% ======================== SP_BVP_Boundary_Condition =================================
% Main_BVP_calcuで使用
% 境界条件の決定と時間配列設定を行う補助プログラム
% 境界条件(初期条件)を指定しない場合はsystemdata.mで定義した初期条件を利用する
% 境界条件(終端条件)を指定しない場合は原点(0ベクトル)を利用する
% ※基本的な制御問題において終端条件を遷移させる必要はない
% Main側で定めた境界条件に不備があった場合errorコマンドでエラーを出力する
%
% 作成者　    :2021/2/23 竹田 賢矢
% 更新　　　  :2021/2/23 竹田 賢矢
% 最終更新者　:2021/7/27 坂本登
% =======================================================================================
%% === 目標軌道初期値の決定 ===
ch_BS1=any(length(BC1_p(1,:))==length(Initial_State(1,:)));
if ch_BS1==1
    ch_B1=any(norm(Initial_State-BC1_p)==0);
    while(1)
        if ch_B1==0
            chB=input('目標軌道初期値に 1:Mainで設定した値を用いる / 0:Initial_Stateを用いる >>');
            if chB==0
                BC1_p=Initial_State;
                break
            elseif chB==1
                break
            end
        else
            break
        end
    end
else
    error('BC1_pのサイズが正しくありません');
end
%% === 終端値の決定 ===
if exist('BC2_p','var')==0
    BC2_p=zeros(1,dim);
else
    ch_BS2=any(length(BC2_p(1,:))==length(zeros(1,dim)));
    if ch_BS2==1
        ch_B2=any(norm(BC2_p-zeros(1,dim))==0);
        if ch_B2==0
            while(1)
                chB2=input('終端値を 1:Mainで設定した値とする / 0:原点とする ');
                if chB2==0
                    BC2_p=zeros(1,dim);
                    break
                elseif chB2==1
                    break
                end
            end
        end
    else
        error('BC2_pのサイズが正しくありません');
    end
end
%% === 境界条件を分割してイタレーション用の境界条件を設定 ===
% === 時間配列 ===
tend = Sxint2_2(1,end);
tini = abs(Sxint2_2(1,1));
if tini>0
    Sxint2_2(:,end+1)=[tend+tini;Sxint2_2(2:end,end)];
end
time = 0:sampling_t:tend+tini;
% === 初期構造体の初期値配列 ===
BC1_mat = [];
BC2_mat = [];
BC1_mat(1,:) = Sxint2_2(2:dim+1,1);
BC2_mat(1,:) = Sxint2_2(2:dim+1,end);
dBC_1 = (BC1_p - BC1_mat(1,:)) / dth;     % boundary condition for bvp calcu
dBC_2 = (BC2_p - BC2_mat(1,:)) / dth;
for i_B=1:dth
    BC1_mat(i_B+1,:) = BC1_mat(i_B,:) + dBC_1;
    BC2_mat(i_B+1,:) = BC2_mat(i_B,:) + dBC_2;
end
