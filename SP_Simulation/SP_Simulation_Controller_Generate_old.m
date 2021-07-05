% =========================== SP_Simulation_Controller_Generate_old ==========================
% SP_response_calcuで使用
% 設定した多項式近似次数と得られた係数Cを用いて現実世界の計測制御環境が認識可能な制御器を生成する
% ver4のsltxt_n.mと対応
% 更新に伴い2～6次までのプログラムを記述,ver4ベース
% old付きの本ファイルはver5作成時の互換確認用．汎用化はtest版,symbolic版(添え字無し)で実装
% 高次の多項式で近似する場合, 有効数字を大きくとる必要がある.
%
% Created by Y.Umemura 2011.11.09
% Updated by T.Horibe
% 作成者　    :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/23 竹田 賢矢
% ============================================================================================
%% === 制御器データ定義 ===
[row,col] = size(xc);
sig_val = 8; %% 係数の有効数字を決定する
%% === 近似多項式(制御器)生成 ===
for i_P = 1:col
    
    Ctmp = num2str(C(i_P),sig_val);
    for i_C=1:dim                                     %状態量に応じた配列にデータを格納
        eval(['x' num2str(i_C) 'tmp=' 'num2str(xc(' num2str(i_C) ',' num2str(i_P) '))' ';'])
    end
    %% === 多項式生成 ===
    % シミュレーションで用いた多項式係数から計測制御環境に適用可能な多項式を生成する
    % 2021/02/23時点で2次，4次，6次のシステムにのみ対応
    switch dim
        %=================================================================================================================%
        case 2
            if i_P == 1
                f_input = strcat('u = ',Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp);
            else
                if C(i_P) < 0
                    f_input = strcat(f_input,Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp);
                else
                    f_input = strcat(f_input,'+',Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp);
                end
            end
            %=============================================================================================================%
        case 4
            if i_P == 1
                f_input = strcat('u = ',Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp,'*x_c3^',x3tmp,'*x_c4^',x4tmp);
            else
                if C(i_P) < 0
                    f_input = strcat(f_input,Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp,'*x_c3^',x3tmp,'*x_c4^',x4tmp);
                else
                    f_input = strcat(f_input,'+',Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp,'*x_c3^',x3tmp,'*x_c4^',x4tmp);
                end
            end
            %=============================================================================================================%
        case 6
            if i_P == 1
                f_input = strcat('u = ',Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp,'*x_c3^',x3tmp,'*x_c4^',x4tmp,'*x_c5^',x5tmp,'*x_c6^',x6tmp);
            else
                if C(i_P) < 0
                    f_input = strcat(f_input,Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp,'*x_c3^',x3tmp,'*x_c4^',x4tmp,'*x_c5^',x5tmp,'*x_c6^',x6tmp);
                else
                    f_input = strcat(f_input,'+',Ctmp,'*x_c1^',x1tmp,'*x_c2^',x2tmp,'*x_c3^',x3tmp,'*x_c4^',x4tmp,'*x_c5^',x5tmp,'*x_c6^',x6tmp);
                end
            end
    end
end
%% === 制御器格納 ===
ALL_Controller(length(ALL_Controller(:,1))+1,1:4)=[{f_input},{Nx},{cost_Nth},{approximationflag}];