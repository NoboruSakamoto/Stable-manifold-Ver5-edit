function [p,xc] = f_poly_apprN_up2N_fast_Sjis(varargin)
% ============================================================================
% ********** 高速バージョン（メモリ不足注意） ************ %
% [p,xc] = f_poly_apprN_up2N_fast( varargin )
%
% F_POLY_APPR  多変数多項式近似
%
% 1変数～5変数までのデータに対して多項式近似を実施し、
% それぞれの項の係数を求める。
%
%	- varargin(1) : スカラ関数値，
%	- varargin(2:n+1) : その値を与える引数の値，
%	- varargin(n+2:2n+1) : 近似多項式の次数の指定値，
%	- varargin(end) : 定数部(0次式)及び線形部(1次式)の係数が既知の場合に定義,
%                     ただし定義する場合は各近似次数は全て同じとする．
%                     %%% 変更点 (01/15) %%%
%                      2次式の場合は(x1+x2+x3+...)*(x1+x2+x3+...)=(x1)^2+x1*x2+x1
%                      *x3+...の順で定義
%                     %%%%%%%%%%%%%%%%%%%%%%
%                     定義しない場合は空行列([])で定義
%
%	- p : 構造体での出力. p.cが係数，p.nが近似次数．
%
%	- 係数について対応する多項式の項はpolycombによる次数インデックスに基づく．
%	- *低次係数指定の場合，多項式次数は0:N(N>1)として定義すると仮定
%	- (<i,e> y=c1x+c2x^2+c4x^4+...のような定義はしないものとする)
%	- (<i,e> 指定係数以外に未知係数が必要)
%	- *支援用プログラムとして"polycomb"を使用している*
%
% created : Y.Yamato
% 2012/10/18 edited : K.Ueno
% ============================================================================


N = (length(varargin)-2)/2; %---次元の数---%
given = varargin{end}(:); %given %---既知の線形パラメータ---%

if( N == 1 ) % 1次元システムの場合
    
    str = ['p.n=varargin{3};'];
    
else % 1次元以上のシステムの場合
    for i = 1:N
        if( i == 1 )
            str = ['p.n = [varargin{N+1+',int2str(i),'};'];
        elseif(( i ~= 1 ) &&...
                ( i ~= N ))
            str = [ str,'varargin{N+1+',int2str(i),'};' ];
        else
            str = [ str,'varargin{N+1+',int2str(i),'};];'];
        end
    end
end
eval(str);

%---各近似次数を定義---%
for i = 1:N
    str = ['Nx',int2str(i),'=varargin{',int2str(1+N+i),'};'];
    eval(str)
end

if( N == 1 ) %1次元の場合
    xc = [0:Nx1];
    [W,V] = meshgrid(0:Nx1,varargin{2});
    M = V.^W;
    is_it_ok =( length(varargin{2})>=rank(M) )
    
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
    for i = 1:N
        if( i == 1 )
            str = ['xc=polycomb(0:Nx1,'];
        elseif(( i ~= 1 ) &&...
                ( i ~= N ))
            str = [str,'0:Nx',int2str(i),','];
        else
            str = [str,'0:Nx',int2str(i),');'];
        end
    end
    
    eval(str);
    
    %---各次数での最大値以上のxcはnegる---%
    str = ['varargin{1+N+1}'];
    for i=2:N
        str=[str,',varargin{1+N+',int2str(i),'}'];
    end
    str2=['exceed_index=find(sum(xc)>max([',str,']));'];
    eval(str2);
    xc(:,exceed_index)=[];
    
    % 	for i = 1:N
    % 		if( i == 1 )
    % 			str = ['[varargin{2}(i);'];
    % 		elseif(( i ~= 1 )&&...
    %                ( i ~= N ))
    % 			str = [str,'varargin{',int2str(i+1),'}(i);'];
    % 		else
    % 			str = [str,'varargin{',int2str(i+1),'}(i)]'];
    % 		end
    % 	end
    %
    % 	P = [];
    % 	str = ['P=[P;prod( (',str,'*ones(1,size(xc,2))).^xc )];'];
    %
    % 	for i = 1:length(varargin{2}),
    % 		eval(str)
    % 	end
    
    
    % ********** 高速バージョン（メモリ不足注意） ************ %
    for i = 1:N
        if( i == 1 )
            str = ['[transpose(varargin{2});'];
        elseif(( i ~= 1 )&&...
                ( i ~= N ))
            str = [str,'transpose(varargin{',int2str(i+1),'});'];
        else
            str = [str,'transpose(varargin{',int2str(i+1),'})]'];
        end
    end
    % --- reservation ---
    COLUMNS = size(xc,2)*length(varargin{2});
    Memory_Saving = zeros(N,2*COLUMNS);
    P = zeros(length(varargin{2}),size(xc,2));
    % --------------------
    Memory_Saving(:,1:length(varargin{2})) = eval(str);
    Memory_Saving(:,1:COLUMNS) = repmat(Memory_Saving(:,1:length(varargin{2})),1,size(xc,2));
    Memory_Saving(:,COLUMNS+1:end) = repmat(xc,1,length(varargin{2}));
    Memory_Saving(:,COLUMNS+1:end) = sortrows(Memory_Saving(:,COLUMNS+1:end)',N:-1:1)';
    Memory_Saving = Memory_Saving(:,1:COLUMNS).^Memory_Saving(:,COLUMNS+1:end);
    P(:) = prod(Memory_Saving);
    clear Memory_Saving
    p.X = P;
    % ****************************************************** %
    
    if( isempty(given) )
        p.c = pinv(P)*varargin{1}(:);
        % 		is_it_ok = length(varargin{2})>=rank(P)
        
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
            term_sorted=(sortrows(term',[1:size(term,1)]))';
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
        %         if numel(given)>N+1 %2次以上が指定されている場合
        % 		   val = find(total~=0 & total~=1 & total~=2);
        %         else
        %            val = find(total~=0 & total~=1);
        %         end
        
        
        Y = varargin{1}(:)-P(:,neg_total)*given;
        P(:,neg_total) = [];
        D = pinv(P)*Y;
        % 		is_it_ok = length(varargin{2})-N>=rank(P)
        str = [];
        C = zeros(size(xc,2),1);
        
        % ********** 変更点 ************ %
        C(val,1) = D(:);
        C(neg_total,1) = given(:);
        % ****************************** %
        
        p.c = C;
        str=['fprintf(''coefficients for the terms up to ',int2str(order),'th are given.\n'')'];
        eval(str)
        p.index=xc;
    end
end