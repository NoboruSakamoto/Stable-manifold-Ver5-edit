function output = f_downsample(data,sampling)

[row,col] = size(data);
sr = [1;zeros(sampling-1,1)];

sum_siz = round(row/sampling)+1;  %% Å‚à‹ß‚¢’l‚Ö‚ÌŠÛ‚ß [data‚Ìs”/sampling + 1]

sr_sum = repmat(sr,sum_siz,col);  %% repmat(A,n,m) s—ñA‚ğƒRƒs[‚µ,nsm—ñ‚ÉŠi”[
                                   % [(sr‚Ìs”~sum_siz)s, col—ñ‚Ì”z—ñ]
sr_sum = sr_sum(1:row,:);         

tmp_data = data.*sr_sum;          %% data‚Æsr_sum‚ğ—v‘f‚²‚Æ‚ÉæZ(5s‚Éˆê“x’l‚ª“ü‚é)
output = unique(tmp_data,'rows');  %% tmp_data‚ÌŠes‚Ì—Bˆê‚Èƒ‚ƒm‚ğæ‚èo‚µŠi”[‚·‚é
pickup = sum(output==0,2)==col;  %% 
output(pickup,:) = [];
if nnz(sum(data==0,2)==col) >0
    output = [zeros(1,col);output];
end