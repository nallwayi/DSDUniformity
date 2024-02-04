% Function to calculate the mass autoconversion rate 
% 08/22/2023

% INPUTS
% From gamma-function assumption- shape and scale parameters
% Liquid water content -> gm/m^3
% cloud droplet number concentration -> #/cm^3


function [PL,gamCntrbn,auto_ts] = calculateAutoConversionRate(gammaParams,LWC,Nd)

% Constants
rho_w = 1; %density of water- 1 gm/cm^3
kl = 1.9e11; % cm^-3 s^-1
r_cr  = 10.3; % in microns

shapeParam = gammaParams(1);
scaleParam = gammaParams(2);


LWC = LWC *1e-6; % gm/m^3 -> gm/cm^3
x_cq = r_cr/scaleParam; 

% Mass Autoconversion rate

gamCntrbn =  gamma(shapeParam) / (gamma(shapeParam+3)) *...
    igamma(shapeParam+3,x_cq) /(gamma(shapeParam+3)) ...
    * igamma(shapeParam+6,x_cq) /(gamma(shapeParam+3));

PL = (3/(4*pi*rho_w))^2 * kl * gamma(shapeParam) / (gamma(shapeParam+3)) *...
    igamma(shapeParam+3,x_cq) /(gamma(shapeParam+3)) ...
    * igamma(shapeParam+6,x_cq) /(gamma(shapeParam+3)) ...
    * LWC^3 / Nd;
% PL =gamma(shapeParam) / (gamma(shapeParam+3)) *...
%     igamma(shapeParam+3,x_cq) /(gamma(shapeParam+3)) ...
%     * igamma(shapeParam+6,x_cq) /(gamma(shapeParam+3));

% PL = (3/(4*pi*rho_w))^2 * kl * gamma(shapeParam) * ...
%     upper_incomplete_gamma(shapeParam+3,x_cq) / ...
%     (gamma(shapeParam+3))^3* ...
%     upper_incomplete_gamma(shapeParam+6,x_cq) * LWC^3 / ...
%     Nd;


% cm^6* gm^-2 *  cm^-3 s^-1 * gm^3* cm^-9 / # * cm^3 = gm cm^-3 s^-1;


% Autoconversion time scale
auto_ts = LWC/PL;

end