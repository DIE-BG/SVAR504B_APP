%{
Transformación de las variables desde su estado inicial (variables en
frecuencia mensual) hasta variaciones logaritmicas interanuales.

Las principales fuentes son:
    1) FRED (Variables externas)
    2) Banguat (Variables Internas)
%}
%% Datos primitivos
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

% Tasa de fondos federales
% Monthly
i_star = databank.fromFred('DFF', 'Frequency=', 'M');

% VARIABLES INTERNAS
% Producto
% Quarterly
y = databank.fromCSV(fullfile('data', 'raw', 'GDP_quarterly.csv'));

% CPI_sub, s, bm, i, cpi
% Monthly
levels = databank.fromCSV(fullfile('data', 'raw', 'monthly.csv'));

% Union de datos mensuales y trimestrales
levels.y_star_qq = y_star.GDPC1;
levels.imp_indx_mm = imp_indx.IR;
levels.exp_indx_mm = exp_indx.IQ;
levels.i_star_mm = i_star.DFF;
levels.y_qq = y.PIB;

%% Transformaciones
% construcción del IPEI
% Primero se recorta la serie de importaciones y exportaciones al rango del
% parametro alpha
levels.exp_indx_mm = levels.exp_indx_mm.clip(levels.a_prom_mm.Start, levels.a_prom_mm.End);
levels.imp_indx_mm = levels.imp_indx_mm.clip(levels.a_prom_mm.Start, levels.a_prom_mm.End);
levels.ipei_mm = levels.a_prom_mm*levels.exp_indx_mm + (1-levels.a_prom_mm)*levels.imp_indx_mm;

% Logaritmos
names = dbnames(levels);
% logaritmos
% excepciones
exc = {'i_star_mm', 'i_mm', 'a_mm', 'a_prom_mm', 'imp_indx_mm', 'exp_indx_mm'};

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
names = dbnames(levels);

%% separamos datos
% 1) variables con frecuencia mensual (niveles y logaritmos)

for i = 1:length(names)
    ind = regexp(names(i), '.*mm$', 'match');
    if ~isempty(ind{1})
        MODEL.PreProc.monthly.(names{i}) = levels.(names{i});
    end
end

% Tasas de variación intermensual anualizada e interanual para precios
% de importaciones y exportaciones
% Tasas intermensual anualizada
MODEL.PreProc.monthly.imp_dl_mm = MODEL.PreProc.monthly.imp_indx_mm.diff(-1)*12; %importaciones
MODEL.PreProc.monthly.exp_dl_mm = MODEL.PreProc.monthly.exp_indx_mm.diff(-1)*12; %exportaciones

% tasa interanual
MODEL.PreProc.monthly.imp_indx_dl12_mm = MODEL.PreProc.monthly.imp_indx_mm.diff(-12); %importaciones
MODEL.PreProc.monthly.exp_indx_dl12_mm = MODEL.PreProc.monthly.exp_indx_mm.diff(-12); %exportaciones

% Nombres
% importaciones
MODEL.PreProc.monthly.imp_indx_mm.Comment = 'Índice de Precios de Importaciones EEUU';
MODEL.PreProc.monthly.imp_indx_dl12_mm.Comment = 'Tasa de variación interanual Precio de Importaciones EEUU';
MODEL.PreProc.monthly.imp_dl_mm.Comment = 'Tasa intermensual anualizada Precio de Importaciones EEUU';

% exportaciones
MODEL.PreProc.monthly.exp_indx_mm.Comment = 'Índice de Precios de exportaciones EEUU';
MODEL.PreProc.monthly.exp_indx_dl12_mm.Comment = 'Tasa de variación interanual Precio de exportaciones EEUU';
MODEL.PreProc.monthly.exp_dl_mm.Comment = 'Tasa intermensual anualizada Precio de exportaciones EEUU';

% 2) varaibles con frecuencia trimestral (niveles y logaritmos)
for i = 1:length(names)
    ind = regexp(names(i), '.*qq$', 'match');
    if ~isempty(ind{1})
        MODEL.PreProc.quarterly.(names{i}) = levels.(names{i});
    end
end

MODEL.PreProc.monthly = databank.clip(MODEL.PreProc.monthly, MODEL.PreProc.monthly.a_mm.Start, MODEL.PreProc.monthly.a_mm.End);
MODEL.PreProc.quarterly = databank.clip(MODEL.PreProc.quarterly, MODEL.DATES.hist_start, MODEL.DATES.hist_end);

% variables observables
obs = {'ln_y_star', 'ln_ipei', 'i_star', 'ln_y', 'ln_cpi_sub', 'ln_s', 'ln_bm', 'i', 'ln_cpi'};
MODEL.PreProc.obs = levels*obs;
MODEL.PreProc.obs = databank.clip(MODEL.PreProc.obs, MODEL.DATES.hist_start, MODEL.DATES.hist_end);

for i = 1:length(obs)
    MODEL.PreProc.obs.(obs{i}).UserData.endhist = dat2char(MODEL.DATES.hist_end);
end

%% Exportamos datos
databank.toCSV(MODEL.PreProc.obs, MODEL.data_file_name, Inf, 'Decimals=', 5, 'UserDataFields=', 'endhist');
