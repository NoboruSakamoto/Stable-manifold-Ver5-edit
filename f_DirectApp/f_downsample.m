function output = f_downsample(data,sampling)

[row,col] = size(data);
sr = [1;zeros(sampling-1,1)];

sum_siz = round(row/sampling)+1;  %% 最も近い値への丸め [dataの行数/sampling + 1]

sr_sum = repmat(sr,sum_siz,col);  %% repmat(A,n,m) 行列Aをコピーし,n行m列に格納
                                   % [(srの行数×sum_siz)行, col列の配列]
sr_sum = sr_sum(1:row,:);         

tmp_data = data.*sr_sum;          %% dataとsr_sumを要素ごとに乗算(5行に一度値が入る)
output = unique(tmp_data,'rows');  %% tmp_dataの各行の唯一なモノを取り出し格納する
pickup = sum(output==0,2)==col;  %% 
output(pickup,:) = [];
if nnz(sum(data==0,2)==col) >0
    output = [zeros(1,col);output];
end