function [p,xc] = f_poly_apprN_up2N_fast_ver5(varargin)
% =========================　f_poly_apprN_up2N_fast_ver5　==================================
% [p,xc] = f_poly_apprN_up2N_fast_ver5( varargin )
%
% SP_Simulation_Multipolyで使用
% 解軌道の状態量とその最適入力に対して多項式近似を実施し，それぞれの項の係数を求める
% ver4におけるf_poly_apprN_up2N_fast.mに対応
% ver5への更新に伴い次数を問わない汎用化を実現
% 更新により入力引数の形式を次の形式へ変更
%	- varargin(1)   : 最適入力(単一入力システムのみで動作検証済)，
%	- varargin(2)   : 状態量
%	- varargin(3)   : 近似多項式の次数の指定値，
%	- varargin(4)   : 線形最適レギュレータのゲイン
% 文字配列からcell配列の利用によりループ処理を改善
%
%	- p : 構造体での出力. p.cが係数，p.nが近似次数．
%	- 係数について対応する多項式の項はpolycombによる次数インデックスに基づく．
%	- *低次係数指定の場合，多項式次数は0:N(N>1)として定義すると仮定
%	- (<i,e> y=c1x+c2x^2+c4x^4+...のような定義はしないものとする)
%	- (<i,e> 指定係数以外に未知係数が必要)
%	- *支援用プログラムとして"polycomb"を使用している*
%
% created : Y.Yamato
% 2012/10/18 edited : K.Ueno
% ver5作成者　:2021/2/28 竹田 賢矢
% 最終更新者  :2021/2/28 竹田 賢矢
% ==========================================================================================
global dim Polyflag
N= dim;
given = varargin{end}(:); %given %---既知の線形パラメータ---%
txplong=length(varargin{2}(:,1));
str = 'p.n=varargin{3};';
eval(str);

%---各近似次数を定義---%
for i = 1:N
    str = ['Nx',int2str(i),'=p.n(' int2str(i) ');'];
    eval(str)
end

if( N == 1 ) %1次元の場合
    xc = 0:Nx1;
    [W,V] = meshgrid(xc,Nx1);
    M = V.^W;
    is_it_ok =( length(Nx1)>=rank(M) )
    if( isempty(given) )
        p.c = M\varargin{1}(:);
    else
        Y = varargin{1}(:)-M(:,1:length(given))*given;
        M(:,1:2) = [];
        D = M\Y;
        p.c = [given;D(1:end)];
    end
else % 多次元の場合
    str = [];
    Polystr=cell(dim,1);
    for i = 1:N
        if( i == 1 )
            Polystr{1,1}='xc=polycomb(0:Nx1,';
        elseif(( i ~= 1 ) &&...
                ( i ~= N ))
            Polystr{i,1}=['0:Nx',int2str(i),','];
        else
            Polystr{i,1}=['0:Nx',int2str(i),');'];
        end
    end
    str=strcat(Polystr{:});
    eval(str);
    %---近似次数の最大値よりも大きな次数の和を持つ組み合わせを消す---%
    %例:最大5次で近似した際，[0,0,0,0]～[5,5,5,5](4次システムの場合)
    %の次数組([5,1,2,3]等)それぞれの組における次数の和([5,1,2,3]なら11)
    %が最大次数よりも大きい場合その次数組を近似に用いない([5,1,2,3]は使わない/[2,0,3,0]は使う)
    %※近似次数を下げる工夫(2012年以降)
    %ver5の更新によりPolyflag==1とすることで，次数組を全て用いることが可能(オーバーフィッティングに注意)
    if Polyflag==0
        str2='exceed_index=find(sum(xc)>max(varargin{3}));';
        eval(str2);
        xc(:,exceed_index)=[];
    end
    %% ********** 高速バージョン（メモリ不足注意） ************ %
    % --- reservation --- %
    COLUMNS = size(xc,2)*txplong;
    Memory_Saving = zeros(N,2*COLUMNS);
    P = zeros(txplong,size(xc,2));
    % -------- Memory_Savingの動作は多要素配列を用いるためメモリ・CPU使用率に注意 ------------
    Memory_Saving(:,1:txplong) = transpose(varargin{2});
    Memory_Saving(:,1:COLUMNS) = repmat(Memory_Saving(:,1:txplong),1,size(xc,2));
    Memory_Saving(:,COLUMNS+1:end) = repmat(xc,1,txplong);
    Memory_Saving(:,COLUMNS+1:end) = sortrows(Memory_Saving(:,COLUMNS+1:end)',N:-1:1)';
    Memory_Saving = Memory_Saving(:,1:COLUMNS).^Memory_Saving(:,COLUMNS+1:end);
    P(:) = prod(Memory_Saving);
    clear Memory_Saving
    p.X = P;
    % ****************************************************** %
    
    if( isempty(given) )
        p.c = pinv(P)*varargin{1}(:);        
    else
        %---指定されている最大次数を求める---%
        order=0;comb=0;
        while comb<numel(given)
            comb=comb+round(factorial(N+order-1)/factorial(order)/factorial(N-1));
            order=order+1;
        end
        if comb~=numel(given),error('the number of given coefficients are inappropriate'),end
        order=order-1;%指定次数
        total = sum(xc);%次数インデックス
        neg_total=[];
        for i=0:order
            str=['index=find(total==',int2str(i),');'];eval(str);%i次の係数インデックス
            term=[xc(:,index);index];
            term_sorted=(sortrows(term',1:size(term,1)))';
            index_sorted=term_sorted(end,:);
            str=['neg',int2str(i),'=index_sorted(end:-1:1);'];eval(str)
            str=['neg_total=[neg_total,neg',int2str(i),'];'];eval(str)
        end
        condition='total ~=0';
        if order~=0
            for i=1:order
                str=['condition=[condition,'' & total ~='',int2str(i)];'];eval(str);
            end
        end
        str=['val=find(',condition,');'];eval(str);
        Y = varargin{1}(:)-P(:,neg_total)*given;
        P(:,neg_total) = [];
        D = pinv(P)*Y;
        str = [];
        C = zeros(size(xc,2),1);
        C(val,1) = D(:);
        C(neg_total,1) = given(:);
        p.c = C;
        str=['fprintf(''coefficients for the terms up to ',int2str(order),'th are given.\n'')'];
        eval(str)
        p.index=xc;
    end
end