function []=f_plot_trajectory_state(txpdata,pltobject,PLToption)
% ========================= f_plot_trajectory_state =================================
% グラフプロットで利用
% 与えられた解軌道データ，Lineオブジェクト，プロット設定を読み込んで
% システムの自由度(状態量に微分値を含む)の数だけサブプロットを用意して解軌道をプロットする
% 作成者　    :2021/3/1 竹田 賢矢
% 最終更新者  :2021/3/1 竹田 賢矢
% ===================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global dim
plt_Mfold=pltobject;
txpsize=size(txpdata);
if txpsize(1,1)==2*dim+1
    txpdata=transpose(txpdata);
end
for i_plot=1:fix(dim/2)                    %自由度に応じてサブプロットを用意
    subplot(1,dim/2,i_plot)
    plt_Mfold(i_plot)=plot(txpdata(:,i_plot+1),txpdata(:,i_plot+1+dim/2));
    grid on; hold on;
    plt_Mfold(i_plot).LineStyle = PLToption{1,2};
    plt_Mfold(i_plot).Marker = PLToption{2,2};
    plt_Mfold(i_plot).MarkerFaceColor=PLToption{3,2};
    plt_Mfold(i_plot).MarkerEdgeColor=PLToption{4,2};
    plt_Mfold(i_plot).DisplayName =PLToption{5,2}; %凡例の名前をここで定義する
    xlabel(['q_',num2str(i_plot),PLToption{6,2}]);
    ylabel(['dot q_',num2str(i_plot), PLToption{7,2}]);
    if PLToption{8,2}==1
        xticks([-3*pi -2*pi -pi -pi/2 0 pi/2 pi 2*pi 3*pi,4*pi])
        xticklabels({'-3\pi','-2\pi','-\pi','-\pi/2','0','\pi/2','\pi','2\pi','3\pi','4\pi'})
    end
    set(gca,'FontSize',15)
    axis square
    legend
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end