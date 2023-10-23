% ========================== SP_Path_set ==================================
% 各サブプログラム及び関数へのパス設定
% ver5への更新により増大したサブプログラムと関数の管理にフォルダを用いたため
% パス設定を行うサブプログラムを用意．将来の更新で関数周りをクラス化することで
% プログラム構造の改善を期待
% 
% 作成者      :2021/3/2 竹田 賢矢
% 最終更新者  :2021/3/2 竹田 賢矢
% =========================================================================
%% === inputData ===
addpath('inputData')
%% === 共通ツールへのパス ===
addpath('i_function')
addpath('f_Various_tools')
addpath('f_Various_tools/Plot_tool')
addpath('f_Various_tools/Polybase')
%% === DirectApp周りのパス ===
addpath('f_DirectApp')
addpath('P_DirectApp')
addpath('P_DirectApp/SP_DirectApp')
%% === BVPへのパス ===
addpath('SP_BVP')
%% === Simulationへのパス ===
addpath('SP_Simulation')