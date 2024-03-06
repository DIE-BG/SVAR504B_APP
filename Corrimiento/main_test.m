%{ 
SimTools: branch->  modelo-con-variables-de-medida

DIE - 2024
MJGM
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
DATES.pred_end = DATES.hist_end + 60;
DATES.hist_end_ant = qq(2023 ,3);
DATES.hist_end_estimation = qq(2023,1);
MODEL.DATES = DATES;

tab_range = [qq(2023,2), qq(2023,3),qq(2023,4),qq(2024,4):4:qq(2028,4)]; %v8 Nov23


%% Configuración inicial del modelo
MODEL.mod_file_name = 'SVAR50L.mod';
MODEL.param_file_name = 'setparam.m';

MODEL.CORR_VER = 'v0';

MODEL.CORR_DATE = '2024-02';
MODEL.CORR_DATE_ANT = '2023-11';

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
    sprintf('fulldata_%s_%s.csv', MODEL.CORR_DATE,MODEL.CORR_VER) ...
);

MODEL.FULLDATANAME_ANT = fullfile( ...
    'data', ...
    'fulldata', ...
    sprintf('fulldata_%s.csv', MODEL.CORR_DATE_ANT) ...
);

%% 
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



%% Lectura de Modelo, datos y proceso de filtrado
MODEL = SimTools.sim.read_model(MODEL);
% Lectura de datos con variables observables en data_corr.csv
MODEL = SimTools.scripts.read_data_corr(MODEL);
% Filtrado para obtención de no observables 
MODEL = SimTools.sim.kalman_smth(MODEL);

%%

MODEL = SimTools.scripts.jprediction_mms_corr( ...
    MODEL, ...
    'DataBase', MODEL.F,...
    'SaveFullData', true);

%% Descomposición de choques
MODEL = SimTools.sim.shd_dsc(MODEL);
MODEL = SimTools.sim.diff_shd_dsc(MODEL);

%% POST-PROCESSING

