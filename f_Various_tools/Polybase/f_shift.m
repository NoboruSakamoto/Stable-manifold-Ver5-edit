function y=f_shift(parameter_a,parameter_b,number_of_partitions,direction)
% ========================================== f_shift ====================================================
% Main_Simulation.mで利用
% 近似次数の最小値と最大値を指定した分割数で区切る(1-n次まで1次ずつ区切る)
% 
% created : T.Suzuki
% ver5更新者  :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
l = length(parameter_a);
x = parameter_a;%             入力: 値(行列)
v = parameter_b;%        入力: この値までずらす(行列)
p = number_of_partitions;%  入力: 分割数(スカラー)
s = (v - x) ./ p;%サンプル幅
d = direction;%             入力: 0:正負両方向にずらす　1:正方向のみにずらす(スカラー)
x_all = zeros(l,p+1);

if d == 0
    for i = 1:l
        xx = x(i);
        vv = v(i);
        ss = s(i);
        x_all(i,:) = [xx - (vv - xx):ss:xx - ss , xx:ss:vv];
    end
elseif d == 1 
    for i = 1:l
        xx = x(i);
        vv = v(i);
        ss = s(i);
        x_all(i,:) = [xx:ss:vv];
    end
end

y = transpose(x_all);