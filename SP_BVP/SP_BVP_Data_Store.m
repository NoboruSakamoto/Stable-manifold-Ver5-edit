% ======================================== SP_BVP_Data_Store ============================================
% Main_BVP_Calcuで使用
% 二点境界値ソルバによる求解終了ごのデータ処理を行う
% 多様体面(mfold)・全解軌道(ALL_BVP_Trajectories)を保存する
%
% 作成者      :2021/2/21 竹田 賢矢
% 最終更新者  :2021/3/15 竹田 賢矢
% =======================================================================================================
%% === 多様体面の保存 ===
Maniflag=0;
if errorflag==1
    while(1)
        Maniflag=input('ここまでの計算結果をmfoldに格納する: OK = 1, NO = 0:');
        if Maniflag==1
            mfold=[mfold;[Manifold{3:ii,1}].'];
            break
        elseif Maniflag==0
            break
        end
    end
elseif errorflag==0
    mfold=[mfold;[Manifold{3:ii+1,1}].'];
end
%% === 全解軌道の保存 ===
DelCell = find(cellfun('isempty',Manifold)); % 空のセルを探す
if isempty(DelCell)==0
Manifold(DelCell(1):end,:) = []; % 空のセルを取り除く
end
Length_BVP_ALL_T=length(ALL_BVP_Trajectories(:,1));
ALL_BVP_Trajectories=[ALL_BVP_Trajectories;cell(length(Manifold(:,1))-1,length(Manifold(1,:)))];
for i_store=1:length(Manifold(:,1))-1
ALL_BVP_Trajectories(Length_BVP_ALL_T+i_store,1:end)=Manifold(i_store+1,1:end);
end