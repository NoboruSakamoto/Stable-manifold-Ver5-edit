% ============================= SP_Simulation_Controller_Generate_test ============================
% SP_response_calcuで使用
% 設定した多項式近似次数と得られた係数Cを用いて現実世界の計測制御環境が認識可能な制御器を生成する
% ver4のsltxt_n.mと対応
% 更新に伴いシステムの次元を問わず利用可能
% old版,sltxt_n.m同様の文字列処理を応用したsymbolic不使用版
% symbolic不使用版は多項式構造の最適化を行わない点に注意
% ※実験環境実装用ではないためあくまでsymbolic math toolの使用可能台数が
% 限られる際のシミュレーションに用いること．
% 高次の多項式で近似する場合, 有効数字を大きくとる必要がある.
%
% Created by Y.Umemura 2011.11.09
% Updated by T.Horibe
% 作成者　    :2021/2/22 竹田 賢矢
% 最終更新者  :2021/2/26 竹田 賢矢
% ============================================================================================
%% === 制御器データ定義 ===
[row,col] = size(xc);
sig_val =8; %% 係数の有効数字を決定する
PolyX=cell(dim,1);
PolyXs=cell(dim,1);
PolyY='';
PolyZ=cell(col,1);
Ctmp=round(C,sig_val,'significant');
for i_x=1:dim
    PolyX(i_x,1)={append('*x_c',num2str(i_x),'^')};
    PolyXs(i_x,1)={append('x_c',num2str(i_x))};
    syms(PolyXs{i_x,1});
    %     PolyXs(i_x,2)={eval(['x_c',num2str(i_x)])};
end
%% === 近似多項式(制御器)生成 ===
for i_P=1:col
    for i_d=1:dim
        PolyY=append(PolyY,PolyX{i_d,1},num2str(xc(i_d,i_P)));
    end
    if C(i_P)<0 || i_P==1
        PolyZ(i_P,1)={append(num2str(Ctmp(i_P),sig_val),PolyY)};
    else
        PolyZ(i_P,1)={append('+',num2str(Ctmp(i_P),sig_val),PolyY)};
    end
    PolyY='';
end
f_input=strcat('u=',PolyZ{:});
%% === 制御器格納 ===
ALL_Controller(length(ALL_Controller(:,1))+1,1:4)=[{f_input},{Nx},{cost_Nth},{approximationflag}];