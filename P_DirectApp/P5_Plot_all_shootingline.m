% ======================== P5_Plot_all_shootingline =================================
% DirectAppで使用
% P4_iterative_calcu.mで求めた解軌道をプロット表示
% ver4のPlot_sh.mの再作成版
% システムが偶数次元かつ状態量が[x1 x2...xn dotx1 dotx2...dotxn]^Tの形式であることが必須
% 縦軸を横軸の速度成分とするため横軸のみxticklabelを実装(回転機械系向き)
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/3/1 竹田 賢矢
% ===================================================================================
%% === プロットの設定 === 
global dim
Plot_Setting
pltS=line(1,fix(dim/2));
pltS_ch=line(1,dim/2);
%% 全軌道のプロット
f_plot_trajectory_state(txpsumt,pltS,PLToption_P5);
%% 得た軌道を一本ずつ順にハイライト
ch_num = 1;
choose_num_mat = zeros(1,ini_row);
init_sum_save = [];
xi_sum_save = [];
while(ch_num <= ini_row)
    for i_plot_ch=1:fix(dim/2)
        subplot(1,dim/2,i_plot_ch)
        eval(['pltS_ch(' num2str(i_plot_ch) ')=plot(ALL_TXP_DATA{' num2str(ch_num+1),',2}' '(:,' num2str(i_plot_ch+1) ')' ',ALL_TXP_DATA{' num2str(ch_num+1),',2}' '(:,' num2str(i_plot_ch+1+dim/2) '))' ';' ]);
        pltS_ch(i_plot_ch).LineStyle = 'none';
        pltS_ch(i_plot_ch).Marker = 'o';
        pltS_ch(i_plot_ch).MarkerFaceColor='r';
        pltS_ch(i_plot_ch).MarkerEdgeColor='r';
        pltS_ch(i_plot_ch).DisplayName='Selected trajectory';
    end
    com_in = input(['num = ',num2str(ch_num),' || no need:0 or enter, need : 1, back : 2, choose num : 3 >> ']);
    if isempty(com_in) == 1
        com_in = 0;
    end
    if com_in == 1
        %%%%
        init_sum_save = [init_sum_save ; init_sum(ch_num,:)];
        xi_sum_save = [xi_sum_save ; xi_sum(ch_num,:)];
        %%%%
        choose_num_mat(ch_num) = 1;  
    elseif com_in == 2
        ch_num = ch_num - 2  ;
    elseif com_in == 3
        ch_num = input('number you want >> ') - 1;
    end
    figure(1)
    delete(pltS_ch);
    ch_num = ch_num + 1;
end

clc