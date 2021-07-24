% ============================= SP_Simulation_Controller_Generate ============================
% SP_response_calcuで使用
% 設定した多項式近似次数と得られた係数Cを用いて現実世界の計測制御環境が認識可能な制御器を生成する
% ver4のsltxt_n.mと対応
% symbolic math toolの利用により次元を問わない多項式生成，生成多項式の最適化を実装
%
% symbolic math toolの使用台数制限回避用に_test(文字列処理版)
% ver4の形式を利用した互換確認用に_old(2,4,6次のみ)
% _test,_oldの2種を利用する際はシミュレーションでの性能確認用途のみとすること
% 高次の多項式で近似する場合, 有効数字を大きくとる必要がある.
%
% 作成者　    :2021/2/26 竹田 賢矢
% 最終更新者  :2021/2/27 竹田 賢矢
% ============================================================================================
%% === 制御器データ定義 ===
[row,col] = size(xc);
sig_val =8;                                                   %係数の有効数字を決定する
PolyX=cell(dim,1);                                            %状態量のsymを格納するセル
Ctmp=round(C,sig_val,'significant');                          %多項式係数をsig_valの有効数字で表す
for i_x=1:dim                                                 %状態量のsym生成(システムの次数分つくる)
    PolyX(i_x,1)={append('x_c',num2str(i_x))};                %'x'ではなく'x_c'なのは変数の混同防止
    syms(PolyX{i_x,1});
end
%% === 近似多項式(制御器)生成 ===
xsym=cell2sym(PolyX(1:dim,1));                                %状態量のsym行列作成
Xsym=mat2cell(Ctmp,ones(length(Ctmp(:,1)),1));                %係数*1の項を項数分だけ用意
PolyController=0;                                             %多項式の初期化
% === 係数*x_c1^m*x_c2^n...の形式で項を生成し，項数分だけ結合する ===
for i_P=1:col
    for i_dx=1:dim                                            %i_P番目の項をシステムの次数だけ再帰して生成
        Xsym{i_P,1}=Xsym{i_P,1}*xsym(i_dx,1)^xc(i_dx,i_P);    %i_P番目の項(係数*x_c1^m*x_c2^n...)を生成
    end
    PolyController=PolyController+Xsym{i_P,1};                %項を結合
end
%% === Horner形式への変形 ===
% === 生成した多項式をHornerの入れ子形式へ変換 ===
% 係数を改めてsym宣言('d':小数)することで，16桁/16桁(規定の設定)の係数を有効数字sig_val桁の数値に変換
[cr,cx] = coeffs(PolyController,xsym);                        %係数の取り出し
dcr=double(cr);                                               %係数をsym→doubleへ変換
digitsOld = digits(sig_val);                                  %sym変換時の桁数指定
rdcr=sym(dcr,'d');                                            %係数を再びsymへ変換(桁数指定)
f_input_A=horner(rdcr*cx.');                                  %Horner形式の多項式生成(上記係数の変換により形式変換後の係数の桁数を固定可能に)
%形式の正確さに注意(Mapleの方が精度高?)
%% === 制御器格納 ===
ALL_Controller(length(ALL_Controller(:,1))+1,1:4)=[{f_input_A},{Nx},{cost_Nth},{approximationflag}];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%