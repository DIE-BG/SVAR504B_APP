%{
Transformación de las variables desde su estado inicial (variables en 
frecuencia mensual) hasta variaciones logaritmicas interanuales.

Las principales fuentes son:
    1) FRED (Variables externas)
    2) Banguat (Variables Internas)
%}
clear
clc
%% Datos en forma primigenia
% VARIALBES EXTERNAS
% Producto de EEUU
% Quarterly/billions
y_star = databank.fromFred('GDPC1');

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
levels.y_star_qq = y_star.GDPC1;
levels.imp_indx_mm = imp_indx.IR;
levels.exp_indx_mm = exp_indx.IQ;
levels.a_mm = a.alpha;
levels.i_star_mm = i_star.DFF;
levels.y_qq = y.PIB;

%% Transformaciones
% construcción del IPEI
% Primero se recorta la serie de importaciones y exportaciones al rango del
% parametro alpha
levels.exp_indx_mm = levels.exp_indx_mm.clip(levels.a_mm.Start, levels.a_mm.End);
levels.imp_indx_mm = levels.imp_indx_mm.clip(levels.a_mm.Start, levels.a_mm.End);
levels.ipei_mm = levels.a_mm*levels.exp_indx_mm + (1-levels.a_mm)*levels.imp_indx_mm;

% Logaritmos
names = dbnames(levels);
% logaritmos
% excepciones
exc = {'i_star_mm', 'i_mm', 'a_mm', 'imp_indx_mm', 'exp_indx_mm'};

for i = 1:length(names)
    if isempty(strmatch(names{i},exc,'exact'))
    levels.(['ln_' names{i}]) = 100*log(levels.(names{i}));
    end
end

%% Trimestralizacion
%Variaciones logaritmicas de varialbes mensuales
names = dbnames(levels);
for i = 1:length(names)
    ind = regexp(names(i), 'ln_.*mm$', 'match');
    if ~isempty(ind{1})
    levels.(names{i}(1:end-3)) = levels.(names{i}).convert('Q', 'method=', @mean);
    end
end
    
% Variables mensuales no transformadas
% tasa de interes domestica y extranjera
names = dbnames(levels);
list = {'i_mm', 'i_star_mm'};
for i = 1:length(names)
   if ~isempty(strmatch(names{i}, list, 'exact')) 
   levels.(names{i}(1:end-3)) = levels.(names{i}).convert('Q', 'method=', @mean);     
   end
end

levels.ln_y_star = levels.ln_y_star_qq;
levels.ln_y = levels.ln_y_qq;

%% exportamos
obs = {'ln_y_star', 'ln_ipei', 'i_star', 'ln_y', 'ln_cpi_sub', 'ln_s', 'ln_bm', 'i', 'ln_cpi'};
obs = levels*obs;

databank.toCSV(obs, 'data_corr.csv', Inf);


