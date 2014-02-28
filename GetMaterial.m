function s = GetMaterial(material, T)
% GetMaterial
%   Get specified material parameters at given temperature T in °C.
%
% Syntax
%   c = GetMaterial('material', T)
%
% Parameters
%   T = Temperature in °C
%
% Materials Available - parameter 'material' must be one of the following:
%   'SiC'   4H Silicon Carbide
%   'Si'    Silicon
%   'SiO2'  Silicon Dioxide
%   'Al2O3' Aluminum Oxide
%   'Ni'    Nickel
%
% Copyright (c) 2013 Dallas T. Morisette (morisett@purdue.edu).
% Released under the terms of the FreeBSD License. 
% See LICENSE file for details.
%

    c = GetConstants(T);
    s.T = T;
    T = T+c.T0;
    
    switch lower(material)
        % 4H Silicon Carbide (4H-SiC)
        case 'sic'
            s.k       = 10.03;                      % SiC dielectric constant parallel to c-axis
            s.chi_s   = 3.30;                       % SiC electron affinity (eV)
            s.Mc      = 3;                      
            s.Mv      = 1;                
            s.mte     = 0.42*c.m0;                  % transverse electron mass (kg)
            s.mle     = 0.29*c.m0;                  % longetudinal electron mass (kg)
            s.mde     = (s.mte^2*s.mle)^(1/3);      % DOS effective mass (electrons) (kg)
            s.mth     = 0.66*c.m0;                  % transverse hole mass (kg)
            s.mlh     = 1.75*c.m0;                  % longetudinal hole mass (kg)
            s.mdh     = (s.mth^2*s.mlh)^(1/3);      % DOS effective mass (holes) (kg)
            %             H     C   -- lattice site (hexagonal vs cubic)
            s.Ed      = [0.047 0.096];              % Ec - Ed, donor state (eV)
            s.Ed_ratio= [0.35 0.65];                % Average fraction of donor on H- or C-site
            s.gd      = [2    2   ];                % Degeneracy factor for donor states
            s.Ea      = 0.18;                       % Ea - Ev, acceptor state (eV)
            s.ga      = 4;                          % Degeneracy factor for acceptor states
            s.Eg0     = 3.23;                       % Bandgap at 296 K (eV)
            s.vth     = sqrt(3*c.kb*T/s.mde)*100;   % Thermal velocity in cm/s

            s.Nc = 1e-6*2*s.Mc*(2*pi*s.mde*c.kb*T/(c.h^2)).^(3/2);% (cm^-3)
            s.Nv = 1e-6*2*s.Mv*(2*pi*s.mdh*c.kb*T/(c.h^2)).^(3/2);% (cm^-3)
            s.Eg = s.Eg0 - 0.00034*(T-296);                       % (eV)
            s.ni = sqrt(s.Nc*s.Nv)*exp(-s.Eg/(2*c.kT));           % (cm^-3)
            s.Ec_Ei = s.Eg/2 - c.kT*log(s.Nv/s.Nc);               % (eV)
            
        % Silicon (Si)
        case 'si'
            s.k        = 11.7;
            s.chi_s    = 4.05;
            s.Mc       = 6;
            s.Mv       = 1;
            s.mte      = 0.19*c.m0;
            s.mle      = 0.98*c.m0;
            s.mde      = (s.mte^2*s.mle)^(1/3);
            s.mhh      = 0.79*c.m0;    %0.49*c.m0;
            s.mlh      = 0.14*c.m0;    %0.16*c.m0;
            s.msoh     = 0.25*c.m0;    %0.29*c.m0;
            s.mdh      = s.mhh;
            s.Eg0      = 1.12;
            s.vth      = sqrt(3*c.kb*T/s.mde)*100;    

            s.Nc = 1e-6*2*s.Mc*(2*pi*s.mde*c.kb*T/(c.h^2)).^(3/2); % (cm^-3)
            s.Nv = 1e-6*2*s.Mv*(2*pi*s.mdh*c.kb*T/(c.h^2)).^(3/2); % (cm^-3)
            s.Eg = 1.17 - 4.73e-4 * T^2/(T+636);
            s.ni = sqrt(s.Nc*s.Nv)*exp(-s.Eg/(2*c.kT));           % (cm^-3)
            s.Ec_Ei = s.Eg/2 - c.kT*log(s.Nv/s.Nc);               % (eV)
        
        % Silicon Dioxide (SiO2)
        case 'sio2'
            s.k = 3.9;
            
        % Aluminum Oxide (Al2O3)
        case 'al2o3'
            s.k = 8.0;
            
        % Nickel (Ni)
        case 'ni'
            s.phi_m = 4.97;
            
        % Unrecognized material    
        otherwise
            assert(false, ['Unrecognized material: ' material]);
    end
end
