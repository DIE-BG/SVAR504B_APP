%{ 

SimTools: branch->  modelo-con-variables-de-medida

%}

MODEL.NAME = 'SVAR_50_4B';

PATH.data = genpath('data');
PATH.src = genpath('src');
PATH.temp = genpath('temp');

structfun(@addpath, PATH)

%% Configuración de fechas
DATES.hist_start = qq(2005, 1);
DATES.hist_end = qq(2023, 4);
DATES.pred_start = DATES.hist_end + 1;
DATES.pred_end = DATES.hist_end + 30;
DATES.hist_end_ant = qq(2023 ,3);
DATES.hist_end_estimation = qq(2023,1);
MODEL.DATES = DATES;

% tab range for simulations
tab_range = [MODEL.DATES.hist_end, MODEL.DATES.pred_start:MODEL.DATES.pred_start+3, qq(2025,4), qq(2026,4)];

% tab range for source data (quartely)
tab_range_source_data = [MODEL.DATES.hist_end-8:MODEL.DATES.hist_end];

% tab range for source data (monthly)
MODEL.DATES.hist_end_mm = mm(2023, 12);
MODEL.DATES.hist_start_mm = mm(2005,1);
tab_range_mm = [MODEL.DATES.hist_end_mm-8:MODEL.DATES.hist_end_mm];

%% Configuración inicial del modelo
MODEL.mod_file_name = 'SVAR50L.mod';
MODEL.param_file_name = 'setparam.m';

MODEL.CORR_VER = 'v0';

MODEL.CORR_DATE = '2024-02';
MODEL.CORR_DATE_ANT = '2023-11';

MODEL.leg_act = 'Febrero 2024';  
MODEL.leg_ant = 'Noviembre 2023'; 

MODEL.data_file_name = fullfile( ...
    'data', ...
    'corrimientos', ...
    MODEL.CORR_DATE, ...
    MODEL.CORR_VER, ...
    'data_corr.csv' ...
);

MODEL.FULLDATANAME_ACT = fullfile( ...
    'data', ...
    'fulldata', ...
    MODEL.CORR_DATE,...
    sprintf('fulldata_%s_%s.csv', MODEL.CORR_DATE,MODEL.CORR_VER) ...
);

MODEL.FULLDATANAME_ANT = fullfile( ...
    'data', ...
    'fulldata', ...
    MODEL.CORR_DATE_ANT,...
    sprintf('fulldata_%s_%s.csv', MODEL.CORR_DATE_ANT,MODEL.CORR_VER) ...
);


%% Nombre de matriz de coeficientes
MODEL.COV_MAT_NAME = 'COV_MAT.CSV';
MODEL.GAMMA_0_NAME = 'GAMMA_0.CSV';
MODEL.PHI_NAME = 'PHI.CSV';

%%
% Variables con shock estructural (Estructura Endogena del SVAR
MODEL.ExoVar = { ...
                'd4_ln_y_star', ...1
                'd4_ln_ipei', ...2
                'i_star', ...3
                'd4_ln_cpi_nosub',...4    
                'd4_ln_y', ...5    
                'd4_ln_cpi_sub', ...6
                'd4_ln_s',...7
                'd4_ln_bm', ...8 
                'i'};
            
%% PRE-PROCESSING
PreProcessing;

%% Lectura de Modelo, datos y proceso de filtrado
MODEL = SimTools.sim.read_model(MODEL);
% Lectura de datos con variables observables en data_corr.csv
MODEL = SimTools.scripts.read_data_corr(MODEL);
% Filtrado para obtención de no observables 
MODEL = SimTools.sim.kalman_smth(MODEL);

%%
MODEL = predictions(MODEL,...
                    'SaveFullData', true);

%% POST-PROCESSING
pp_list = {'ln_y_star', 'ln_ipei', 'ln_z','ln_s','ln_cpi_sub','ln_ipei_q','ln_y','ln_bm','ln_v'};
list_nivel = {'ln_y','ln_s','ln_bm'};

MODEL = PostProcessing(MODEL,...
                       'list',pp_list,...
                       'list_niv', list_nivel);

%% plots
% datos fuente y Preprocesamiento
PreProcPlots;
% Simulación
SimulationPlots;
% Post Procesamiento
PostProcPlots;
%% Otras Gráficas
% tipo de cambio real
tc_real(MODEL,...
        'corr_ant', MODEL.CORR_DATE_ANT,...
        'tab_range', tab_range,...
        'pred_ant', qq(2023, 3));

% Velocidad
velocidad_subplot;

%% Descomposición de choques

MODEL = SimTools.sim.shd_dsc(MODEL);
list = [MODEL.ExoVar(4:end), 'd4_ln_cpi', 'd4_ln_z', 'd4_ln_v', 'r'];
% Rango Completo
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\long');
SimTools.scripts.plot_shd_dsc(MODEL, 'SavePath', temp_path,...
                             'Rng', {},...
                             'Variables',list);
% Rango corto
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\short');
SimTools.scripts.plot_shd_dsc(MODEL, 'SavePath', temp_path,...
                             'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
                             'Variables',list);                         
                                                    
%% Presentación
presentacion;

%% Almacenamiento de datos de Pre y post procesamiento

pre_proc = MODEL.PreProc;
post_proc = MODEL.PostProc;
save(fullfile('data', 'fulldata',MODEL.CORR_DATE, sprintf("PreProcessing-%s.mat", MODEL.CORR_DATE)), 'pre_proc');
save(fullfile('data', 'fulldata',MODEL.CORR_DATE, sprintf("PostProcessing-%s.mat", MODEL.CORR_DATE)), 'post_proc');


