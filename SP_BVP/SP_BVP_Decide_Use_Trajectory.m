% ======================== SP_BVP_Decide_Use_Trajectory =================================
% Main_BVP_calcuで使用
% 使用する解軌道の決定を行う補助プログラム
% 使用したい解軌道番号を入力・遷移用軌道，基準軌道利用の選択・多様体面の利用の決定
% 二点境界値ソルバに与える軌道決定の対話機能を実装
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/25 竹田 賢矢
% =======================================================================================
%% === 使用する解軌道の決定 ===

%%%%DirectAppから得た軌道番号を入力する%%%%
if isempty(Trajectory_Num)==1
    if isempty(sh_risou)==1
        while(1)
            Tnum = input('使う軌道の番号:');
            if Tnum > 0
                break
            end
        end
        BVP_trajectry=ALL_TXP_DATA{Tnum+1,2};
    end
else
    BVP_trajectry=ALL_TXP_DATA{Trajectory_Num+1,2};
end
Sxint2_2 = transpose(BVP_trajectry);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%基準軌道とその多様体面を使うか%%%%
%目標初期値に遷移させた解軌道を得た後に，多様体面等を作る際に利用する
%DirectAppから得た軌道を目標初期値に遷移させたい場合は0を押せ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(sh_risou)==0
    sh_use = input('遷移用軌道を利用する: OK = 1, NO = 0:');
    if sh_use==1
        Sxint2_2 = sh_risou;
    end
else
    sh_use=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(sh_Base)==0 && sh_use==0
    sh_useB = input('基準軌道（初期軌道）を利用する: OK = 1, NO = 0:');
    if sh_useB==1
        Sxint2_2 = sh_Base;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(mfold)==0
    m_use = input('これまでの多様体データを蓄積する: OK = 1, NO = 0:');
    if m_use==0
        mfold=[];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temptemp = Sxint2_2;