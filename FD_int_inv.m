function n = FD_int_inv(u)
% FD_INT_INV  Calculates the inverse of the Fermi-Dirac integral, order 1/2 
%
% Uses an approximate model suggested by Nilsson
% See Solid-State Electron, v24, p981 (1981)
%
%   Arguments:
%       u		-	Value of Fermi-Dirac integral of which to find inverse
%
%   Returns:
%       n       -   Value of the reduced fermi energy that corresponds to 
%                   the given Fermi-Dirac integral of order 1/2
%
    a = (3.0*sqrt(pi)*u/4.0).^(2.0/3.0);
	n = log(u)./(1-u.^2) + a./(1.0 + (0.24 + 1.08*a).^(-2.0));
end
