function y=f_shift(parameter_a,parameter_b,number_of_partitions,direction)
% ========================================== f_shift ====================================================
% Main_Simulation.m�ŗ��p
% �ߎ������̍ŏ��l�ƍő�l���w�肵���������ŋ�؂�(1-n���܂�1������؂�)
% 
% created : T.Suzuki
% ver5�X�V��  :2021/2/21 �|�c ����
% �ŏI�X�V��  :2021/2/21 �|�c ����
% =======================================================================================================
l = length(parameter_a);
x = parameter_a;%             ����: �l(�s��)
v = parameter_b;%        ����: ���̒l�܂ł��炷(�s��)
p = number_of_partitions;%  ����: ������(�X�J���[)
s = (v - x) ./ p;%�T���v����
d = direction;%             ����: 0:�����������ɂ��炷�@1:�������݂̂ɂ��炷(�X�J���[)
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