function []=f_plot_trajectory_input(tidata,pltobject,PLToption)
% ========================= f_plot_trajectory_input =================================
% グラフプロットで利用(時系列プロット)
% 与えられた最適入力，Lineオブジェクト，プロット設定を読み込んで
% 最適入力の時系列のグラフプロットを行う
% 作成者　    :2021/3/1 竹田 賢矢
% 最終更新者  :2021/3/1 竹田 賢矢
% ===================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Bdim
plt_T=pltobject;
for i_plot=1:Bdim
    plt_T(i_plot)=plot(tidata(:,1),tidata(:,i_plot+1));
    grid on; hold on;
    plt_T(i_plot).LineStyle = PLToption{1,2};
    plt_T(i_plot).Marker = PLToption{2,2};
    plt_T(i_plot).MarkerFaceColor=PLToption{3,2};
    plt_T(i_plot).MarkerEdgeColor=PLToption{4,2};
    plt_T(i_plot).DisplayName=['Optimal Input_',num2str(i_plot),PLToption{5,2}]; %凡例の名前をここで定義する
    xlabel(PLToption{6,2});
    ylabel( PLToption{7,2});
    xlim([0,tidata(end,1)])
    if PLToption{8,2}==1
    end
    set(gca,'FontSize',15)
    axis square
    legend
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end