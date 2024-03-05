%{
Transformación de las variables desde su estado inicial (variables en 
frecuencia mensual) hasta variaciones logaritmicas interanuales.

Las principales fuentes son:
    1) FRED (Variables externas)
    2) Banguat (Variables Internas)
%}

%% Datos en forma primigenia
% VARIALBES EXTERNAS
% Producto de EEUU
% Quarterly/billions
y_star = databank.fromFred('GDP');

% Precios de importaciones
% index/all commodities
% Monthly
imp_indx = databank.fromFred('IR');

% Precios de exportaciones
% index/all commodities
% Monthly
exp_indx = databank.fromFred('IQ');

% Parametro alpha
% uso para la construcción del IPEI
% Monthly
a = databank.fromCSV(fullfile('raw', '2 IPEI', 'alpha.csv'));

% Tasa de fondos federales
% Monthly
i_star = databank.fromFred('DFF', 'Frequency=', 'M');

% VARIABLES INTERNAS
% Producto
% Quarterly
y = databank.fromCSV(fullfile('raw', '5 Y', 'PIB.csv'));

% CPI_sub, s, bm, i, cpi
% Monthly
levels = databank.fromCSV(fullfile('raw', 'levels.csv'));

% Union de datos mensuales y trimestrales
levels.y_star = y_star.GDP;
levels.imp_indx = imp_indx.IR;
levels.exp_indx = exp_indx.IQ;
levels.a = a.alpha;

%% Transformaciones
% logaritmos




