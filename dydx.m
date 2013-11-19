function d = dydx(x,y,varargin)
% DYDX  Calculates the derivative of an x-y dataset
%
% d = dydx(x,y)     calculates the derivative dy/dx of the given x-y data 
%                   at each point from the local slope of a linear fit to 
%                   the nearest 3 points.
%
% d = dydx(x,y,n)   uses the n closest data points for the linear fit.
%                   n must be odd
%
% d = dydx(x,y,n,o) uses a polynomial fit of order o to the nearest n data
%                   points. n must be odd, and must exceed o by at least 1
%
% Copyright (c) 2013 Dallas T. Morisette (morisett@purdue.edu).
% Released under the terms of the FreeBSD License. 
% See LICENSE file for details.
%

    p = inputParser;
    
    p.addRequired('x', @(x) isvector(x) && isnumeric(x));
    p.addRequired('y', @(x) isvector(x) && isnumeric(x));
    p.addOptional('n', 3, @(x) isscalar(x) && mod(x,2) ~= 0);
    p.addOptional('o', 1, @(x) isscalar(x) && x > 0);
    
    p.parse(x,y, varargin{:});
    
    n = p.Results.n;
    o = p.Results.o;
    
    if n < o+1
        error('n must exceed order by at least 1');
    end
    
    if size(x) ~= size(y)
        error('x and y must be vectors of same length and orientation');
    end
    
    m = length(x);
    d = zeros(size(x));
    for i = 1:m
        rng = i-floor(n/2):i+floor(n/2);
        if min(rng) < 1
            rng = 1:n;
        end
        if max(rng) > m
            rng = m-n+1:m;
        end
        fit = polyfit(x(rng),y(rng),o);
        p = fit(1:end-1).*linspace(o,1,o);
        d(i) = polyval(p,x(i));
    end
end


% p1 x^n + p2 x^n-1 ...  pn x + pn+1
% n p1 x^n-1 + (n-1) p2 x^n-2 ... 1 pn
