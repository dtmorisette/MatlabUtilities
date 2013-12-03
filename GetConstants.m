function c = GetConstants(T)
% GetConstants
%   Returns a structure containing fundamental physical constants.
%   Some constants may be temperature dependent, and are calculated at
%   temperature T in C.
%
% Syntax
%   c = GetConstants(T)
%
% Parameters
%   T = Temperature in C
%
%   T can be either a scalar or a vector. If T is a vector, any temperature
%   dependent constant will also be a vector (e.g. kT/q). 
%
%
% Copyright (c) 2013 Dallas T. Morisette (morisett@purdue.edu).
% Released under the terms of the FreeBSD License. 
% See LICENSE file for details.
%

    c.T0    = 273.15;               % 0 degrees C in Kelvin
    assert(all(T+c.T0) >= 0, 'Negative absolute temperature requested');
    
    c.q     = 1.602176565e-19;      % electron charge (C)
    c.kb    = 1.3806504e-23;        % Boltzmann constant (J/K)
    c.k     = 8.6173423e-5;         % Boltzmann constant (eV/K)
    c.m0    = 9.10938215e-31;       % free electron rest mass (kg)
    c.h     = 6.62606896e-34;       % Plank constant (J*s)
    c.hbar  = c.h/(2*pi);           
    c.eps0  = 8.85418782e-14;       % permittivity of free space (F/cm)

% Temperature dependent constants
    T = T + c.T0;    

    c.kTq   = c.kb*T/c.q;           % Thermal voltage (kT/q) (V) 
    c.kT    = c.kTq;                % Thermal voltage (kT) (eV)
end    