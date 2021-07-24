% ===================================== Main_Simulation =================================================
% x(t), p(t)から多変数多項式近似によりp(x)を求める.
% p(x)を用いて応答性の検証をする.
% 応答性検証結果から評価関数の値を求める
% 多項式近似を重複順列を用いてオート化
% シューティングラインから導出される最適入力よりも大きく外れた入力を制御器が吐き出したらボツ
% 成績の良い(評価関数値が解軌道に近い)近似次数をALL_Controller_Dimに格納
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/3/2 竹田 賢矢
% =======================================================================================================
%% === パスの設定 ===
%==========%
SP_Path_set
%==========%
%% === データ設定 ===
%============================%
SP_Simulation_Data_Set
SP_Simulation_Data_cut
%============================%
%% === 多項式近似・シミュレーション実行部 ===
tic
for i_forpoly=1:size(combination,1)
    %% === 多変数多項式近似でp(x)を求める ===
    %=======================%
    SP_Simulation_Multipoly                            %スカラー入力 u を丸ごと多項式近似
    %=======================%
    %% === 停止判断 ===
    if breakflag==1
        break
    end
    %% === 最適制御入力の応答性 ===
    %===========================%
    SP_Simulation_Response_Calcu                       %シミュレーション
    %===========================%
    %% === 計算進捗確認 ===
    disp(['calculation:',num2str(i_forpoly),'/',num2str(length(combination(:,1)))]);
    disp(['cut_time=',num2str(cut_time)]);
end
%% === 計算時間の表示 ===
toc                        % 計算時間計測終了
%% ===成功近似次数ソート ===
switch approximationflag
    case 1
        if norm(ALL_Controller_Dim)>0
            ALL_Controller_Dim=sortrows(ALL_Controller_Dim,dim+1);
        end
    case 2
        if norm(ALL_Controller_Dim2)>0
            ALL_Controller_Dim2=sortrows(ALL_Controller_Dim2,dim+1);
        end
end
%% === 不要な変数削除 ===
clear i_forpoly i_setD i_polyC i_Input ichecker