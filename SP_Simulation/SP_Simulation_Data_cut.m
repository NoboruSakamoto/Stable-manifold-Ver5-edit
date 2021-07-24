% ==================================== SP_Simulation_Data_cut ===========================================
% データを不要な時刻で切る
% Main_Simulation.m で使用
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
tmpData = txpCsumT;

tmp_flag = ( txpCsumT(:,1) <= cut_time );
tmp_t_xp = bsxfun(@times,txpCsumT,tmp_flag);
tmp_t_xp = unique(tmp_t_xp,'rows');

txpsumTC = tmp_t_xp;



