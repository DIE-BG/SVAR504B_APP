%% Modelo y setparam
MODEL.mod_file_name = 'SVAR50L.mod';
MODEL.param_file_name = 'setparam.m';

%% Configuración del corrimento
MODEL.CORR_VER = 'v0';

MODEL.CORR_DATE = '2021-11';
MODEL.CORR_DATE_ANT = '2021-11';

MODEL.leg_act = 'Noviembre 2021';  
MODEL.leg_ant = 'Noviembre 2021'; 

% Fechas de fin de historia
MODEL.DATES.hist_end_ant = qq(2021, 3);
MODEL.DATES.hist_end = qq(2021, 3);
MODEL.DATES.hist_end_mm = mm(2021, 10);

%% Otros elementos y fechas
MODEL.data_file_name = fullfile( ...
    'data','corrimientos', MODEL.CORR_DATE, MODEL.CORR_VER, 'data_corr.csv');

MODEL.FULLDATANAME_ACT = fullfile( ...
    'data', 'fulldata', MODEL.CORR_DATE, ...
    sprintf('fulldata_%s_%s.csv', MODEL.CORR_DATE,MODEL.CORR_VER));

MODEL.FULLDATANAME_ANT = fullfile( ...
    'data', 'fulldata', MODEL.CORR_DATE_ANT,...
    sprintf("MODEL-%s.mat", MODEL.CORR_DATE_ANT));

% Configuración de estructura DATES

MODEL.DATES.hist_start = qq(2005, 1);
MODEL.DATES.pred_start = MODEL.DATES.hist_end + 1;
MODEL.DATES.pred_end = MODEL.DATES.hist_end + 30;
MODEL.DATES.hist_end_estimation = qq(2023,1);

% Rango de tablas para gráficos de simulación
tab_range = [MODEL.DATES.hist_end, MODEL.DATES.pred_start:MODEL.DATES.pred_start+3, qq(2024,4), qq(2025,4)];

% Rango de tablas para gráficos de Pre - procesamiento
% Trimestral
tab_range_source_data = MODEL.DATES.hist_end-8:MODEL.DATES.hist_end;
% Mensual
MODEL.DATES.hist_start_mm = mm(2005,1);
tab_range_mm = MODEL.DATES.hist_end_mm-8:MODEL.DATES.hist_end_mm;

%% Nombres de escenarios
MODEL.esc_names = {'Escenario Libre',...
                   'Escenario IPEI',...
                   'Escenario Tasa Líder',...
                   'Escenario Combinado',...
                   'Escenario Dif. Histórica máxima',...
                   'Escenario Dif. Máxima + Trayectoria Tasa'};
               
%% Carga de info mes previo
MODEL_ANT = load(sprintf('MODEL-%s.mat',MODEL.CORR_DATE_ANT));
MODEL_ANT = MODEL_ANT.MODEL;

%% Listas adicionales

% Variables con shock estructural (Estructura Endogena del SVAR)
MODEL.ExoVar = { ...
                'd4_ln_y_star', ...1
                'd4_ln_ipei', ...2
                'i_star', ...3
                'd4_ln_cpi_nosub',...4    
                'd4_ln_y', ...5    
                'd4_ln_cpi_sub', ...6
                'd4_ln_s',...7
                'd4_ln_bm', ...8 
                'i'}; %9

%% Lista de variables para post-procesamiento
% Logaritmos desestacionalizados, tendencias y brechas
pp_list = {'ln_y_star', 'ln_ipei', 'ln_z','ln_s','ln_cpi_sub','ln_ipei_q','ln_y','ln_bm','ln_v'};
% Niveles desestacinoalizados y tendencias
list_nivel = {'ln_y','ln_s','ln_bm'};

% Variables y titulos para gráficas de reconstrucción de nivel
% (PostPrLevels)
list_lev = {'y','s','bm'};
tit_lev ={{'Producto Interno Bruto','Millones de Quetzales'},{'Tipo de Cambio Nominal (GTQ/USD)'},...
        {'Base Monetaria (Millones de Quetzales)'}};

% Lista de gráficas de brechas
list_gaps = {'ln_y_star','ln_ipei','ln_z', 'ln_y', 'ln_bm', 'ln_v', 'ln_ipei_q'};
