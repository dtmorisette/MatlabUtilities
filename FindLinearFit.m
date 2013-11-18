function [pf, rng] = FindLinearFit(x,y, varargin)
% FindLinearFit - Find a contiguous linear section of an x,y data set
%
% [pf, rng] = FindLinearFit(x,y,w,n) identifies the longest contiguous 
% linear section of the supplied data and returns the slope and intercept
% of the linear section, and the indices over which the fit is applied.
% x and y must be vectors of the same shape and size
%
%   Optional parameters:
%       w (default: 5)
%           The window width used in the local slope calculation
%
%       n (default: 10)
%           The number of bins used to determine the prevailing slope
%
% Copyright (c) 2013 Dallas T. Morisette.
%
    ip = inputParser;
    ip.addRequired('x', @isvector);
    ip.addRequired('y', @isvector);
    ip.addOptional('n', 10, @isscalar);
    ip.addOptional('w', 5,  @isscalar);
    ip.addParamValue('debug', false);
    ip.parse(x,y, varargin{:});
    
    n = ip.Results.n;
    w = ip.Results.w;
    
    % Identify the prevailing local slope
    d = dydx(x,y,w);            % Local deriative based on linear fit with window width = w
    % Filter out large areas with relatively small slope
    rng = find(abs(d)/mean(abs(d)) > 0.1);
    [cnt, bins] = hist(d(rng),n);      
    i = find(cnt == max(cnt));     
    m = bins(i);
    dm = abs(mean(diff(bins)));
    rng = find(abs(d-m) < dm);
    
    % Reduce to largest contiguous range
    p = find( [true; diff(rng)~=1; true] ); % Find beginnings of sequences.
    [ignore,q] = max(diff(p));              % Determine which sequence is longest
    rng = rng(p(q):p(q+1)-1);               % Reduce x to just that sequence
    
    % Perform fit over selected range
    pf = polyfit(x(rng),y(rng),1);
  
    % Plot result to allow user to verify
    if ip.Results.debug
        xp = linspace(min(x),max(x));
        plot(x,y,'ob', x(rng),y(rng),'og', xp, polyval(pf,xp), 'r');
    end
end