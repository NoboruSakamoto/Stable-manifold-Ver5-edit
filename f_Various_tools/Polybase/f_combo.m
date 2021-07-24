function y = f_combo(parameters)
% ========================================== f_combo ====================================================
% Main_Simulation.mで利用
% 多項式近似次数リストを重複順列によって生成する
% 
% created : T.Suzuki
% ver5更新者  :2021/2/21 竹田 賢矢
% 最終更新者  :2021/2/21 竹田 賢矢
% =======================================================================================================
p = parameters;
[m,n] = size(p);
olddata = [];
newdata = [];
j = 0;

while n > j
    newdata = zeros(m^(j+1),j+1);
    for i =1:m
        newdata(m^j*(i-1)+1:(m^j)*i,:) = [olddata , p(i,j+1) * ones(m^j,1)];
    end    
    olddata = newdata;       
    j = j+1;
end

y = newdata;