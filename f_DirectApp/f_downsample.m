function output = f_downsample(data,sampling)

[row,col] = size(data);
sr = [1;zeros(sampling-1,1)];

sum_siz = round(row/sampling)+1;  %% �ł��߂��l�ւ̊ۂ� [data�̍s��/sampling + 1]

sr_sum = repmat(sr,sum_siz,col);  %% repmat(A,n,m) �s��A���R�s�[��,n�sm��Ɋi�[
                                   % [(sr�̍s���~sum_siz)�s, col��̔z��]
sr_sum = sr_sum(1:row,:);         

tmp_data = data.*sr_sum;          %% data��sr_sum��v�f���Ƃɏ�Z(5�s�Ɉ�x�l������)
output = unique(tmp_data,'rows');  %% tmp_data�̊e�s�̗B��ȃ��m�����o���i�[����
pickup = sum(output==0,2)==col;  %% 
output(pickup,:) = [];
if nnz(sum(data==0,2)==col) >0
    output = [zeros(1,col);output];
end