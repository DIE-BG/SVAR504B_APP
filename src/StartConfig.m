%% Modelo y setparam
MODEL.mod_file_name = 'SVAR50L.mod';
MODEL.param_file_name = 'setparam.m';

%% Configuración del corrimento
MODEL.CORR_VER = 'v0';

MODEL.CORR_DATE = '2024-02';
MODEL.CORR_DATE_ANT = '2023-11';

MODEL.leg_act = 'Febrero 2024';  
MODEL.leg_ant = 'Noviembre 2023'; 

MODEL.data_file_name = fullfile( ...
    'data','corrimientos', MODEL.CORR_DATE, MODEL.CORR_VER, 'data_corr.csv');

MODEL.FULLDATANAME_ACT = fullfile( ...
    'data', 'fulldata', MODEL.CORR_DATE, ...
    sprintf('fulldata_%s_%s.csv', MODEL.CORR_DATE,MODEL.CORR_VER));

MODEL.FULLDATANAME_ANT = fullfile( ...
    'data', 'fulldata', MODEL.CORR_DATE_ANT,...
    sprintf("MODEL-%s.mat", MODEL.CORR_DATE_ANT));

%% Configuración de estructura DATES
MODEL.DATES.hist_start = qq(2005, 1);
MODEL.DATES.hist_end = qq(2023, 4);
MODEL.DATES.pred_start = MODEL.DATES.hist_end + 1;
MODEL.DATES.pred_end = MODEL.DATES.hist_end + 30;
MODEL.DATES.hist_end_ant = qq(2023 ,3);
MODEL.DATES.hist_end_estimation = qq(2023,1);

% Rango de tablas para gráficos de simulación
tab_range = [MODEL.DATES.hist_end, MODEL.DATES.pred_start:MODEL.DATES.pred_start+3, qq(2025,4), qq(2026,4)];

% Rango de tablas para gráficos de Pre - procesamiento
% Trimestral
tab_range_source_data = MODEL.DATES.hist_end-8:MODEL.DATES.hist_end;
% Mensual
MODEL.DATES.hist_end_mm = mm(2023, 12);
MODEL.DATES.hist_start_mm = mm(2005,1);
tab_range_mm = MODEL.DATES.hist_end_mm-8:MODEL.DATES.hist_end_mm;


%% Variables con shock estructural (Estructura Endogena del SVAR)
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
            
%% FullDataAnt
% Corrimiento anterior
MODEL_ANT = load(MODEL.FULLDATANAME_ANT);
