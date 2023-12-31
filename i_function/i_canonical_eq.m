function dx = i_canonical_eq(t,xp)
% ==============================
% DX = I_CANONICAL_EQ(t,xp)     
%                               
% Hamiltonの正準方程式          
% ==============================
global Ham dim

tx = xp(1:dim);
tp = xp(dim+1:dim*2);

dx = Ham * [tx;tp] + [HamF([tx],[tp]);HamG([tx],[tp])];
