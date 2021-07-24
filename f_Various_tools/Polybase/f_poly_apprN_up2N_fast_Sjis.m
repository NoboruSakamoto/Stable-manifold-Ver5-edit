function [p,xc] = f_poly_apprN_up2N_fast_Sjis(varargin)
% ============================================================================
% ********** �����o�[�W�����i�������s�����Ӂj ************ %
% [p,xc] = f_poly_apprN_up2N_fast( varargin )
%
% F_POLY_APPR  ���ϐ��������ߎ�
%
% 1�ϐ��`5�ϐ��܂ł̃f�[�^�ɑ΂��đ������ߎ������{���A
% ���ꂼ��̍��̌W�������߂�B
%
%	- varargin(1) : �X�J���֐��l�C
%	- varargin(2:n+1) : ���̒l��^��������̒l�C
%	- varargin(n+2:2n+1) : �ߎ��������̎����̎w��l�C
%	- varargin(end) : �萔��(0����)�y�ѐ��`��(1����)�̌W�������m�̏ꍇ�ɒ�`,
%                     ��������`����ꍇ�͊e�ߎ������͑S�ē����Ƃ���D
%                     %%% �ύX�_ (01/15) %%%
%                      2�����̏ꍇ��(x1+x2+x3+...)*(x1+x2+x3+...)=(x1)^2+x1*x2+x1
%                      *x3+...�̏��Œ�`
%                     %%%%%%%%%%%%%%%%%%%%%%
%                     ��`���Ȃ��ꍇ�͋�s��([])�Œ�`
%
%	- p : �\���̂ł̏o��. p.c���W���Cp.n���ߎ������D
%
%	- �W���ɂ��đΉ����鑽�����̍���polycomb�ɂ�鎟���C���f�b�N�X�Ɋ�Â��D
%	- *�᎟�W���w��̏ꍇ�C������������0:N(N>1)�Ƃ��Ē�`����Ɖ���
%	- (<i,e> y=c1x+c2x^2+c4x^4+...�̂悤�Ȓ�`�͂��Ȃ����̂Ƃ���)
%	- (<i,e> �w��W���ȊO�ɖ��m�W�����K�v)
%	- *�x���p�v���O�����Ƃ���"polycomb"���g�p���Ă���*
%
% created : Y.Yamato
% 2012/10/18 edited : K.Ueno
% ============================================================================


N = (length(varargin)-2)/2; %---�����̐�---%
given = varargin{end}(:); %given %---���m�̐��`�p�����[�^---%

if( N == 1 ) % 1�����V�X�e���̏ꍇ
    
    str = ['p.n=varargin{3};'];
    
else % 1�����ȏ�̃V�X�e���̏ꍇ
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

%---�e�ߎ��������`---%
for i = 1:N
    str = ['Nx',int2str(i),'=varargin{',int2str(1+N+i),'};'];
    eval(str)
end

if( N == 1 ) %1�����̏ꍇ
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
else % �������̏ꍇ
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
    
    %---�e�����ł̍ő�l�ȏ��xc��neg��---%
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
    
    
    % ********** �����o�[�W�����i�������s�����Ӂj ************ %
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
        %---�w�肳��Ă���ő原�������߂�---%
        order=0;comb=0;
        while comb<numel(given)
            comb=comb+round(factorial(N+order-1)/factorial(order)/factorial(N-1));
            order=order+1;
        end
        if comb~=numel(given),error('the number of given coefficients are inappropriate'),end
        order=order-1;%�w�莟��
        
        total = sum(xc);%�����C���f�b�N�X
        neg_total=[];
        for i=0:order
            str=['index=find(total==',int2str(i),');'];eval(str);%i���̌W���C���f�b�N�X
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
        %         if numel(given)>N+1 %2���ȏオ�w�肳��Ă���ꍇ
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
        
        % ********** �ύX�_ ************ %
        C(val,1) = D(:);
        C(neg_total,1) = given(:);
        % ****************************** %
        
        p.c = C;
        str=['fprintf(''coefficients for the terms up to ',int2str(order),'th are given.\n'')'];
        eval(str)
        p.index=xc;
    end
end