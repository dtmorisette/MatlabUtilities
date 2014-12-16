function dx = FindOffset(A,B)
% FINDOFFSET  Find the likely x-axis offset between two (x,y) data sets
    assert(size(A,2) == 2 && size(B,2) == 2, ...
           'Both arguments must have exactly two columns');
    
    [~, iA, ~] = unique(A(:,2));
    [~, iB, ~] = unique(B(:,2));
    fA = @(x)interp1(A(iA,2),A(iA,1),x);
    fB = @(x)interp1(B(iB,2),B(iB,1),x);
    x = linspace( max([min(A(iA,2)) min(B(iB,2))]), ...
                  min([max(A(iA,2)) max(B(iB,2))]), ...
                  max([size(A,1) size(B,1)]))';
    dx = mean(fA(x)-fB(x));
end