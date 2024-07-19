%{
Transformación de las variables desde su estado inicial (variables en
frecuencia mensual o trimestral) hasta variaciones logaritmicas interanuales.

Las principales fuentes son:
    1) FRED (Variables externas)
    2) Banguat (Variables Internas)

Departamento de Investigaciones Económicas - 2024.
MJGM/JGOR

%}
% VARIABLES TRIMESTRALES
% Producto externo y domestico
% Quarterly
q = databank.fromCSV(fullfile('data', 'raw', MODEL.CORR_DATE, 'quarterly.csv'));

% VARIABLES MENSUALES
% a, a_prom, exp_indx, imp_indx, i_star, cpi_sub, s, bm, cpi
m = databank.fromCSV(fullfile('data', 'raw', MODEL.CORR_DATE, 'monthly.csv'));

%% Transformaciones
% CONSTRUCCION DEL IPEI
m.exp_indx_mm = m.exp_indx_mm.clip(m.a_prom_mm.Start, m.a_prom_mm.End);
m.imp_indx_mm = m.imp_indx_mm.clip(m.a_prom_mm.Start, m.a_prom_mm.End);
m.ipei_mm = m.a_prom_mm*m.exp_indx_mm + (1-m.a_prom_mm)*m.imp_indx_mm;

% TASAS DE VARIACION PRECIOS DE IMPORTACIONES Y EXPORTACIONES
% Tasas de variación intermensual anualizada e interanual para precios
% Tasas intermensual anualizada
m.imp_dl_mm = m.imp_indx_mm.pct(-1)*12; %importaciones
m.exp_dl_mm = m.exp_indx_mm.pct(-1)*12; %exportaciones

% tasa interanual
m.imp_indx_dl12_mm = m.imp_indx_mm.pct(-12); %importaciones
m.exp_indx_dl12_mm = m.exp_indx_mm.pct(-12); %exportaciones

% Nombres
% importaciones
m.imp_indx_mm.Comment = 'Índice de Precios de Importaciones EEUU';
m.imp_indx_dl12_mm.Comment = 'Tasa de variación interanual Precio de Importaciones EEUU';
m.imp_dl_mm.Comment = 'Tasa intermensual anualizada Precio de Importaciones EEUU';
% exportaciones
m.exp_indx_mm.Comment = 'Índice de Precios de exportaciones EEUU';
m.exp_indx_dl12_mm.Comment = 'Tasa de variación interanual Precio de exportaciones EEUU';
m.exp_dl_mm.Comment = 'Tasa intermensual anualizada Precio de exportaciones EEUU';

% LOGARITMOS
names = dbnames(m);
% excepciones
exc = {'i_star_mm', 'i_mm', 'a_mm', 'a_prom_mm', 'imp_indx_mm', 'exp_indx_mm'};
% mensuales
for i = 1:length(names)
    if isempty(strmatch(names{i},exc,'exact'))
        m.(['ln_' names{i}]) = 100*log(m.(names{i}));
    end
end

%trimestrales
names = dbnames(q);
for i = 1:length(names)
        q.(['ln_' names{i}]) = 100*log(q.(names{i}));
end

% TRIMESTRALIZACION
% Variaciones logaritmicas de varialbes mensuales
names = dbnames(m);
for i = 1:length(names)
    ind = regexp(names(i), 'ln_.*mm$', 'match');
    if ~isempty(ind{1})
        m_t.(names{i}(1:end-3)) = m.(names{i}).convert('Q', 'method=', @mean);
    end
end

% Variables mensuales no transformadas
% tasa de interes domestica y extranjera
names = dbnames(m);
list = {'i_mm', 'i_star_mm'};
for i = 1:length(names)
    if ~isempty(strmatch(names{i}, list, 'exact'))
        m_t.(names{i}(1:end-3)) = m.(names{i}).convert('Q', 'method=', @mean);
    end
end

%% CREACION DE ESTRUCTURA MODEL
MODEL.PreProc.monthly = m;
MODEL.PreProc.quarterly = q;
MODEL.PreProc.obs = m_t;
MODEL.PreProc.obs.ln_y = q.ln_y_qq;
MODEL.PreProc.obs.ln_y_star = q.ln_y_star_qq;

MODEL.PreProc.monthly = databank.clip(MODEL.PreProc.monthly, MODEL.DATES.hist_start_mm, MODEL.DATES.hist_end_mm);
MODEL.PreProc.quarterly = databank.clip(MODEL.PreProc.quarterly, MODEL.DATES.hist_start, MODEL.DATES.hist_end);
MODEL.PreProc.obs = databank.clip(MODEL.PreProc.obs, MODEL.DATES.hist_start, MODEL.DATES.hist_end);

% filtro de observables
obs = {'ln_y_star', 'ln_ipei', 'i_star', 'ln_y', 'ln_cpi_sub', 'ln_s', 'ln_bm', 'i', 'ln_cpi'};
MODEL.PreProc.obs = MODEL.PreProc.obs*obs;

for i = 1:length(obs)
    MODEL.PreProc.obs.(obs{i}).UserData.endhist = dat2char(MODEL.DATES.hist_end);
end
% Colocamos una m al inicio

for i = 1:length(obs)
    MODEL.PreProc.obs.(strcat('m_', obs{i})) = MODEL.PreProc.obs.(obs{i});
end

%% Exportamos datos
if ~isfolder(fullfile('data', 'corrimientos', MODEL.CORR_DATE, MODEL.CORR_VER))
    mkdir(fullfile('data', 'corrimientos', MODEL.CORR_DATE, MODEL.CORR_VER))
end  

databank.toCSV(MODEL.PreProc.obs, MODEL.data_file_name, Inf, 'Decimals=', 5, 'UserDataFields=', 'endhist');
