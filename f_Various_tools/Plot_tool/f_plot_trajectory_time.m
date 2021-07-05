function []=f_plot_trajectory_time(txpdata,pltobject,PLToption)
% ========================= f_plot_trajectory_time ==================================
% グラフプロットで利用(時系列プロット)
% 与えられた解軌道データ，Lineオブジェクト，プロット設定を読み込んで
% 時系列のグラフプロットを行う
% 作成者　    :2021/3/1 竹田 賢矢
% 最終更新者  :2021/3/1 竹田 賢矢
% ===================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global dim
plt_T=pltobject;
txpsize=size(txpdata);
if txpsize(1,2)==2*dim+1
    txpdata=transpose(txpdata);
end
Plf=fix(dim/2)+1;
for i_plot=1:Plf
    %%
    plt_T(i_plot)=plot(txpdata(1,:),txpdata(i_plot+1,:));
    grid on; hold on;
    plt_T(i_plot).LineStyle = PLToption{1,2};
    plt_T(i_plot).Marker = PLToption{2,2};
    plt_T(i_plot).MarkerFaceColor=PLToption{3,2};
    plt_T(i_plot).MarkerEdgeColor=PLToption{4,2};
    plt_T(i_plot).DisplayName =['q_',num2str(i_plot),PLToption{5,2}]; %凡例の名前をここで定義する
    xlabel(PLToption{6,2});
    ylabel( PLToption{7,2});
    if PLToption{8,2}==1
        yticks([-3*pi -2*pi -pi -pi/2 0 pi/2 pi 2*pi 3*pi,4*pi])
        yticklabels({'-3\pi','-2\pi','-\pi','-\pi/2','0','\pi/2','\pi','2\pi','3\pi','4\pi'})
    end
    xlim([0,txpdata(1,end)])
    set(gca,'FontSize',15)
    axis square
    if i_plot==Plf-1 && 2*fix(dim/2)==dim
        legend
        break
    end
    legend
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

