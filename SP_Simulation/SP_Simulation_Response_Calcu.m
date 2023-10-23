% =================================== SP_Simulation_Response_Calcu =======================================
% 最適入力に対する応答の計算
% Main_Simulation.m で使用
% ver4のSP_response_calcu.mの再作成版
% 多項式近似自動化に伴う機能を追加+汎用化
% 入力・あるいは状態量が発散する場合eventによって計算を停止
% eventで停止しなかった良いシミュレーション結果の最適入力を再計算し，評価関数値を取得
% 評価関数値が解軌道のそれと近ければ評価関数値と近似次数をALL_Controller_Dimに格納
% 手動で近似次数を選んだ際(成功時)はグラフを出力
% ※ode45のoption利用によって精度向上と引き換えに過去のシミュレーション結果と互換性喪失
%
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
%% === optionの定義 ===
options_Simulation = odeset('RelTol ',1e-12,'AbsTol ',1e-12,'Events ',@termination_Simulation ,'MaxStep ',1e-3);
%% === シミュレーション実行 ===
[t,fx,tE,fE,iE] = ode45(@i_state_eq_for_control_poly,Time_int,Ini_Simu,options_Simulation);
tE_data=[tE_data;tE];
fE_data=[fE_data;fE];
iE_data=[iE_data;iE];
%% === optionで停止しなかったシミュレーション結果の処理 ===
%=====================================================================================================
if isempty(iE)==1                                  %iEが空配列であればイベントで停止しなかったことになる
    %% === 最適入力の再度算出 ===
    opt_u = zeros(length(fx(:,1)),length(B(1,:)) );
    for i_Input = 1:size(fx,1)
        opt_u(i_Input,:) =  prod(((transpose(fx(i_Input,:))*ones(1,size(xc,2))).^xc)) * C ;
    end
    %% === 評価関数値によるシミュレーション結果評価 ===
    cost_Nth = f_costopt(t,fx,opt_u,Q,R);          %評価関数値計算
    if costch*0.8<cost_Nth && cost_Nth<costch*1.5
        %=== 手動で次数を選ぶ場合良いシミュレーション結果ならプロットする ===
        switch approximationflag
            case 0
                %================================%
                SP_Simulation_Result_Plot
                SP_Simulation_Controller_Generate
                %================================%
                %=== 多項式近似自動時は良い結果の近似次数と評価関数値を保存 ===
            case 1
                ALL_Controller_Dim=[ALL_Controller_Dim;transpose(Nx),cost_Nth];
            case 2
                ALL_Controller_Dim2=[ALL_Controller_Dim2;transpose(Nx),cost_Nth];
                %================================%
                SP_Simulation_Controller_Generate
                %================================%
            otherwise
                error('approximationflagの値が間違っています')
        end
%     else
%         fprintf('Cost is much larger (or smaller---strange!) than optimal value \n')
    end
end
%=====================================================================================================
%% === 成功次数発見時の動作 ===
switch approximationflag
    case {0,1}
        if norm(ALL_Controller_Dim)>0
            fprintf('I have %d controller(s)!! \n',length(ALL_Controller_Dim(:,1)))
        end
    case 2
        if norm(ALL_Controller_Dim2)>0
            fprintf('More good %d controller(s)!!\n',length(ALL_Controller_Dim2(:,1)));
        end
end