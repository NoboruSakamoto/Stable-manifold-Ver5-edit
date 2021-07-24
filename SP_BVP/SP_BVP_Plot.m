% ============================================ SP_BVP_Plot ==============================================
% Main_BVP_calcuで使用
% 二点境界値ソルバで求めた解軌道をプロット表示
% ver4のPlotBVP.mの再作成版
% システムが偶数次元かつ状態量が[x1 x2...xn dotx1 dotx2...dotxn]^Tの形式であることが必須
% 縦軸を横軸の速度成分とするため縦軸のみxticklabelを実装(回転機械系向き)
%
% 作成者　    :2021/2/22 竹田 賢矢
% 最終更新者  :2021/2/26 竹田 賢矢
% =======================================================================================================
Plot_Setting
plt_BVP=line(1,dim/2);
%% 全軌道のプロット
for i_plot=1:dim/2                    %自由度に応じてサブプロットを用意
    subplot(1,dim/2,i_plot)
    for i_BVP=1:ii
        eval(['plt_BVP(' num2str(i_plot) ')=plot(Manifold{' num2str(i_BVP+1) ',1}(' num2str(i_plot+1) ',:),Manifold{' num2str(i_BVP+1) ',1}(' num2str(i_plot+1+dim/2) ',:));' ]);
        grid on; hold on;
        plt_BVP(i_plot).LineStyle = '-';
        plt_BVP(i_plot).Marker = '.';
    end
    xlabel(['q_',num2str(i_plot),PTlabelx]);
    ylabel(['dot q_',num2str(i_plot),PTlabeldx]);
    set(gca,'FontSize',15)
    axis square
end
xticks([-3*pi -2*pi -pi -pi/2 0 pi/2 pi 2*pi 3*pi,4*pi])
xticklabels({'-3\pi','-2\pi','-\pi','-\pi/2','0','\pi/2','\pi','2\pi','3\pi','4\pi'})
%%
ch_num = 1;
choose_num_mat = zeros(1,ii);
plt_BVP_ch=line(1,dim/2);
while(ch_num <= ii)
    %%
    for i_plot=1:dim/2                    %自由度に応じてサブプロットを用意
        subplot(1,dim/2,i_plot)
        eval(['plt_BVP_ch(' num2str(i_plot) ')=plot(Manifold{' num2str(ch_num+1) ',1}(' num2str(i_plot+1) ',:),Manifold{' num2str(ch_num+1) ',1}(' num2str(i_plot+1+dim/2) ',:));' ]);
        grid on; hold on;
        plt_BVP_ch(i_plot).LineStyle = 'none';
        plt_BVP_ch(i_plot).Marker = 'o';
        plt_BVP_ch(i_plot).MarkerFaceColor='r';
        plt_BVP_ch(i_plot).MarkerEdgeColor='r';
        axis square
    end
    %%
    com_in = input(['num = ',num2str(ch_num),' || no need:0 or enter, back : 2, choose num : 3 >> ']);
    if isempty(com_in) == 1
        com_in = 0;
    end
    
    if com_in == 2
        ch_num = ch_num - 2  ;
    elseif com_in == 3
        ch_num = input('number you want >> ') - 1;
    end
    %%
    figure(1)
    delete(plt_BVP_ch);
    hold on
    ch_num = ch_num + 1;
end