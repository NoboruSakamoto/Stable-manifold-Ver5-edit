% ============================================ Plot_Setting ==============================================
% グラフプロットで利用
% スクリーンサイズに応じた大きさのグラフ画面を出力する
% SP_BVP_Plot_StableManifold.mとSP_Simulation_Result_Plot.mで利用
%
% 作成者　    :2021/2/22 竹田 賢矢
% 最終更新者  :2021/3/1 竹田 賢矢
% =======================================================================================================
%% === スクリーンサイズの取得 ===
close all;
scrsz = get(groot,'ScreenSize');
maxW = scrsz(3);
maxH = scrsz(4);
%% === グラフの定義 ===
figure(1);
posit = get(gcf,'Position');
nw=2.5;                               %横幅を微調整する(研究室内で利用するディスプレイならこれでよい)
nh=1.5;                               %縦幅を微調整する
dw = posit(3)-min(nw*posit(3),maxW);
dh = posit(4)-min(nh*posit(4),maxH);
set(gcf,'Position',[posit(1)+dw/2  posit(2)+dh  min(nw*posit(3),maxW)  min(nh*posit(4),maxH)])
%% === ラベルの設定 ===
% === systemdataでラベルが未定義の場合空の単位でラベルを作成 ===
if exist('statename','var')==0
    statename='';
end
if exist('inputname','var')==0
    inputname='';
end
% === ラベルの生成 ===
% YTlabel_は時系列プロットで用いる
% PTlabelx,PTlabeldxは多様体面等のプロットで用いる
% ラベルの単位が定義されていれば[]付きでラベルを生成
if isempty(statename)
    YTlabelx=append('Response',statename);
else
    YTlabelx=append('Response','[',statename,']');
    PTlabelx=append('[',statename,']');
    PTlabeldx=append('[',statename,'/s',']');
end
if isempty(inputname)
    YTlabeli=append('Input',inputname);
else
    YTlabeli=append('Input','[',inputname,']');
end
%% === プロットの詳細設定 ===
PL1=(': Stable Manifold');
PL2=(': Base Trajectory');
PL3=(': Transited Trajectory');
PLToption_LABEL=[{'LineStyle'},{'Marker'},{'MarkerFaceColor'},...
    {'MarkerEdgeColor'},{'DisplayName'},{'xlabelName'},{'ylabelName'},{'axisflag'}];
%================================================================================
PLToption_P5=cell(8,2);
PLToption_P5(1:end,1)=PLToption_LABEL;
PLToption_P5(1:end,2)=[{'none'},{'.'},{'auto'},...
    {'auto'},{'HJ equation solution trajectories'},{PTlabelx},{PTlabeldx},{1}];
%================================================================================
PLToption_mfold=cell(8,2);
PLToption_mfold(1:end,1)=PLToption_LABEL;
PLToption_mfold(1:end,2)=[{'none'},{'.'},{'k'},{'k'},{PL1},{PTlabelx},{PTlabeldx},{1}];
%================================================================================
PLToption_sh_Base=cell(8,2);
PLToption_sh_Base(1:end,1)=PLToption_LABEL;
PLToption_sh_Base(1:end,2)=[{'none'},{'o'},{'g'},{'g'},{PL2},{PTlabelx},{PTlabeldx},{1}];
%================================================================================
PLToption_Sxint=cell(8,2);
PLToption_Sxint(1:end,1)=PLToption_LABEL;
PLToption_Sxint(1:end,2)=[{'none'},{'.'},{'r'},{'r'},{PL3},{PTlabelx},{PTlabeldx},{1}];
%================================================================================
PLToption_tsh_Base=cell(8,2);
PLToption_tsh_Base(1:end,1)=PLToption_LABEL;
PLToption_tsh_Base(1:end,2)=[{'-'},{'.'},{'auto'},{'auto'},{PL2},{'Time[s]'},{YTlabelx},{1}];
%================================================================================
PLToption_tish_Base=cell(8,2);
PLToption_tish_Base(1:end,1)=PLToption_LABEL;
PLToption_tish_Base(1:end,2)=[{'-'},{'.'},{'auto'},{'auto'},{PL2},{'Time[s]'},{YTlabeli},{1}];
%================================================================================
PLToption_tSxint=cell(8,2);
PLToption_tSxint(1:end,1)=PLToption_LABEL;
PLToption_tSxint(1:end,2)=[{'-'},{'.'},{'auto'},{'auto'},{PL3},{'Time[s]'},{YTlabelx},{1}];
%================================================================================
PLToption_tiSxint=cell(8,2);
PLToption_tiSxint(1:end,1)=PLToption_LABEL;
PLToption_tiSxint(1:end,2)=[{'-'},{'.'},{'auto'},{'auto'},{PL3},{'Time[s]'},{YTlabeli},{1}];
%================================================================================
PLToption_fx=cell(8,2);
PLToption_fx(1:end,1)=PLToption_LABEL;
PLToption_fx(1:end,2)=[{'none'},{'.'},{'b'},{'b'},{': Simulation Result'},{PTlabelx},{PTlabeldx},{1}];
%================================================================================
PLToption_tfx=cell(8,2);
PLToption_tfx(1:end,1)=PLToption_LABEL;
PLToption_tfx(1:end,2)=[{'-'},{'.'},{'auto'},{'auto'},{': Simulation Result'},{'Time[s]'},{YTlabelx},{1}];
%================================================================================
PLToption_tfxi=cell(8,2);
PLToption_tfxi(1:end,1)=PLToption_LABEL;
PLToption_tfxi(1:end,2)=[{'-'},{'.'},{'auto'},{'auto'},{': Simulation Result'},{'Time[s]'},{YTlabeli},{1}];