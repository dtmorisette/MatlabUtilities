function n = FD_int_dinv(u)
% FD_INT_DINV  Calculates the derivative of the inverse of the 
%              Fermi-Dirac integral of order 1/2 
%
%		Uses an approximate model suggested by Nilsson
%		See Solid-State Electron, v24, p981 (1981)
%
%		Arguments:
%			u		-	Point at which to evaluate the derivative
%
%		Returns:
%			n       -   Derivative of the inverse Fermi-Dirac integral of 
%                       order 1/2 evaluated at u
%
	y = 1.0 - u.^2;
	k = (0.75*sqrt(pi)).^(2.0/3.0);
	x = k*(u.^(2.0/3.0));
	a = 0.24;
    b = 1.08;
	z = a + b*x;
	v = 1.0 + 1.0./(z.^2);
	
	n = (y./u + 2.0*u.*log(u))./(y.^2) + ...
        ((v + 2.0*b*x./(z.^3))./(v.^2)).*(2.0/3.0*k.*(u.^(-1.0/3.0)));
end
