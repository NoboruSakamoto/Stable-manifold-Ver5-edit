% ======================================= SP_Simulation_Multipoly ========================================
% 最適入力uの多変数多項式近似
% Main_Simulation.mで使用
% ver4の同プログラムの再作成版
% 多項式近似自動化に伴う機能を追加+近似前のデータ処理の汎用化
% 手動で近似次数を決定する場合このプログラム内で次数を入力する
% 手動の際は，近似多項式の入力値と最適入力値の比較を行う
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/28 竹田 賢矢
% =======================================================================================================
global C xc
%% === 近似次数の組が一定以上の場合1000組で停止判断を提案 ===
ichecker=0;
breakflag=0;
if round(mod(i_forpoly+1,1000),3,'significant')==0
    while(1)
        fprintf('近似次数が%d組となりました\n',i_forpoly)
        ichecker=input('多項式近似自動化シミュレーションを停止しますか: OK = 1, NO = 0:');
        if isempty(ichecker)==1
        elseif ichecker==0 
            break
        elseif ichecker==1
            breakflag=1;
            return
        end
    end
end
%% === 近似次数設定 ===
Nx=ones(dim,1);
for i_apd=1:dim
    if approximationflag==0
        fprintf('x%d ',i_apd);
        xctemp=input('の最大次数(5以下を推奨):');
        eval(['xc' num2str(i_apd)  '='  num2str(xctemp) ';' ])
    elseif approximationflag==1 || approximationflag==2
        eval(['xc' num2str(i_apd)  '='  num2str(combination(i_forpoly,i_apd)) ';' ])
    end
    Nx(i_apd)=eval(['xc' num2str(i_apd)]);
end
%% === データの取得 ===
xpsumTC = txpsumTC(:,2:dim*2+1);                      %解軌道データ(多様体面)読み込み
Xtemp=xpsumTC(:,1:dim);                               %入力算出用配列に解軌道データ(x)読み込み
Ptemp=xpsumTC(:,dim+1:2*dim);                         %入力算出用配列に解軌道データ(p)読み込み
input_tmp = f_inputcalcu(Xtemp,Ptemp,R);              %最適入力算出
K = -lqr(A,B,2*Q,2*R);                                %原点近傍用の安定化解算出
%% === 多項式近似 ===
% 解軌道をフィードバック関数に多項式近似する
% ver5への更新により多項式近似関数を汎用化
[Cinput,xc] = f_poly_apprN_up2N_fast_ver5(input_tmp,Xtemp,Nx,[0;transpose(K)]);
C = double(Cinput.c);                                 %近似係数取得
%% === 近似精度の確認 ===
% 自動探索offの際に近似前後の入力値とその差(絶対値表記)をプロットする
if approximationflag==0
    optP_u =zeros(length(txpsumTC(:,1)),Bdim);
    for i_Input = 1:length(optP_u(:,1))
        optP_u(i_Input,:) =  prod(((transpose(txpsumTC(i_Input,2:dim+1))*ones(1,size(xc,2))).^xc)) * C ;
    end
    optP_u=[optP_u,input_tmp];
    PL_L=cell(2*dim,1);
    for iPL=1:Bdim
        PL_L{1}=': Optimal Input';
        PL_L{Bdim+iPL}=': Controller Input';
    end
    % === プロット設定 ===
    %===========%
    Plot_Setting
    %===========%
    plt_PI=line(1,2*Bdim);
    plt_PIN=line(1,Bdim);
    subplot(1,2,1)
    % === 入力値比較 ===
    for i_plot=1:2*Bdim
        eval(['plt_PI(' num2str(i_plot) ')=plot(' 'optP_u(:,' num2str(i_plot) ')' ');' ]);
        grid on; hold on;
        plt_PI(i_plot).LineStyle = 'none';
        if i_plot<=Bdim
            plt_PI(i_plot).Marker = 'o';
            i_bd=i_plot;
        else
            plt_PI(i_plot).Marker = '.';
            i_bd=i_plot-Bdim;
        end
        plt_PI(i_plot).DisplayName = ['Input_',num2str(i_bd),PL_L{i_plot}]; %凡例の名前をここで定義する
        axis square
    end
    legend
    xlabel('Data Index');
    ylabel(YTlabeli)
    subplot(1,2,2)
    % === 誤差の絶対値表示 ===
    for i_plot=1:Bdim
        eval(['plt_PIN(' num2str(i_plot) ')=plot(' 'abs(optP_u(:,' num2str(i_plot) ')-optP_u(:,' num2str(i_plot+Bdim) '))' ');' ]);
        grid on; hold on;
        plt_PIN(i_plot).LineStyle = 'none';
        plt_PIN(i_plot).Marker = 'o';
        plt_PIN(i_plot).MarkerFaceColor='none';
        plt_PIN(i_plot).MarkerEdgeColor='b';
        plt_PIN(i_plot).DisplayName = ['Abs of optInput-polyInput: ','Input_',num2str(i_bd)]; %凡例の名前をここで定義する
        axis square
    end
    legend
    xlabel('Data Index');
    ylabel('Abs of approximation error')
    %% === フォント等の設定 ===
    set_plot_style_v03(15,15,2);
    disp('Press Enter key to continue >>')
    pause
end
close all