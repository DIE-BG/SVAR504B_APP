%% Modelo y setparam
MODEL.mod_file_name = MODEL.NAME;
MODEL.param_file_name = 'setparam.m';

%% Configuración del corrimento
MODEL.CORR_VER = 'v0';

MODEL.CORR_DATE = '2021-11';
MODEL.CORR_DATE_ANT = '2021-11';

MODEL.leg_act = 'SVAR50QQ Nov 2021';  
MODEL.leg_ant = 'SVAR504B Nov 2021'; 

% Fechas de fin de historia
MODEL.DATES.hist_end_ant = qq(2021, 4);
MODEL.DATES.hist_end = qq(2021, 4);
MODEL.DATES.hist_end_mm = mm(2021, 12);

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
MODEL.DATES.hist_end_estimation = qq(2023,4);

% Rango de tablas para gráficos de simulación
tab_range = [MODEL.DATES.hist_end, MODEL.DATES.pred_start:MODEL.DATES.pred_start+3, qq(2025,2), qq(2025,4)];

% Rango de tablas para gráficos de Pre - procesamiento
% Trimestral
tab_range_source_data = MODEL.DATES.hist_end-8:MODEL.DATES.hist_end;
% Mensual
MODEL.DATES.hist_start_mm = mm(2005,1);
tab_range_mm = MODEL.DATES.hist_end_mm-8:MODEL.DATES.hist_end_mm;

%% Nombres de escenarios
MODEL.esc_names = {'Escenario Libre',...v0
                   'Escenario IPEI',...v1
                   'Escenario Tasa Líder',...v2
                   'Escenario Combinado'};%,...v3
%                    'Escenario Dif. Histórica máxima',...v4
%                    'Escenario Dif. Máxima + Trayectoria Tasa'}; %v5

MODEL.Esc.v1.name = MODEL.esc_names{2};
MODEL.Esc.v2.name = MODEL.esc_names{3};
MODEL.Esc.v3.name = MODEL.esc_names{4};

% Colores para escenarios ALTERNOS
MODEL.esc_col = {[0.4660 0.6740 0.1880],...   v1
                 [0.8500 0.3250 0.0980],...    %v2           
                 [0.4940 0.1840 0.5560]}; %v3
               
%% Carga de info mes previo
MODEL_ANT = load(sprintf('MODEL-%s.mat',MODEL.CORR_DATE_ANT));
MODEL_ANT = MODEL_ANT.MODEL;

%% Listas adicionales
% Variables con shock estructural (Estructura Endogena del SVAR)
MODEL.ExoVar = { ...
                'dla_y_star', ...1
                'dla_ipei', ...2
                'i_star', ...3
                'dla_cpi_nosub',...4    
                'dla_y', ...5    
                'dla_cpi_sub', ...6
                'dla_s',...7
                'dla_bm', ...8 
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
