function y = f_combo(parameters)
% ========================================== f_combo ====================================================
% Main_Simulation.m�ŗ��p
% �������ߎ��������X�g���d������ɂ���Đ�������
% 
% created : T.Suzuki
% ver5�X�V��  :2021/2/21 �|�c ����
% �ŏI�X�V��  :2021/2/21 �|�c ����
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