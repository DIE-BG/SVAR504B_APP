%{ 
SVAR50-4B - Corrimiento
SimTools: branch->  modelo-con-variables-de-medida.

Modelo: SVAR50-4B Redefinido con observables en niveles. La estructura
endogena principal (9 variables/ecuaciones) se mantiene.

Estructura:
 - PreProcessing: 
    - Carga de datos primitivos (en el nivel y frecuencia de la fuente). 
    - Cálculos y transformaciones de frecuencia para gráficas de preprocesamiento
      y generación de base de datos con variables observables (ver .mod).
  - Filtrado:
    - Con base en la base de datos de observables generadas en PreProcessing 
    se utiliza el filtro de Kalman para recuperar el resto de variables y 
    generar la base de datos de condiciones iniciales para la simulación.
 - Simulación: 
    - Utiliza la base de datos filtrada (kalman) para generar los pronósticos del
    modelo, los cuales incluyen:
            - Niveles (logaritmos)
            - Sumas móviles de de 4T los Productos interno y externo.
            - Tasas de variación intertrimestral anualizadas.
            - Tasas de variación interanual. 
 - PostProcessing:
    - Genera los cálculos posteriores que no es posible hacer dentro de la
    estructura del modelo para un subgrupo de variables:
            - Desestacionalización (X12)
            - Calculo de brechas y tendencias (HP, lambda=1600)

Posterior a los procesos de tratamiento de datos y simulación se generan
las descomposiciones de shocks, gráficas y presentación correspondientes.

Nota: Derivado del cambio en el planteamiento del modelo estado-espacio no
fue posible utilizar todas las funciones de SimTools en el proceso de
corrimiento

Departamento de Investigaciones Económicas - 2024.
MJGM/JGOR

%}

MODEL.NAME = 'SVAR_50_4B';

PATH.data = genpath('data');
PATH.src = genpath('src');
PATH.temp = genpath('temp');

structfun(@addpath, PATH)

%% Carga de configuraciones generales del corrimiento base (v0)
StartConfig;

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

%% Gráficas 
do_graphs = true;
SimTools.scripts.plot_pred_corr_compared



if do_graphs == true
    % datos fuente y Preprocesamiento
    PreProcPlots;
    % Simulación
    SimulationPlots;
    % Post Procesamiento
    PostProcPlots;
    
    % Otras Gráficas
    % Componentes Tipo de cambio real
    tc_real(MODEL,...
        'corr_ant', MODEL.CORR_DATE_ANT,...
        'tab_range', tab_range,...
        'pred_ant', qq(2023, 3));
    
    % Componentes Velocidad de Circulación de la Base Monetaria
    velocidad_subplot;
    
    % Descomposición de choques para variables seleccionadas
    Desc_shocks
end

%% Escenarios alternos
esc_alt = false;

if esc_alt == true
    Alterno;
    Contrafactual;
end
%% Presentación
presentacion;

%% Almacenamiento de datos de Pre y post procesamiento

pre_proc = MODEL.PreProc;
post_proc = MODEL.PostProc;
save(fullfile('data', 'fulldata',MODEL.CORR_DATE, sprintf("PreProcessing-%s.mat", MODEL.CORR_DATE)), 'pre_proc');
save(fullfile('data', 'fulldata',MODEL.CORR_DATE, sprintf("PostProcessing-%s.mat", MODEL.CORR_DATE)), 'post_proc');

save(fullfile('data','fulldata',MODEL.CORR_DATE, sprintf("MODEL-%s.mat", MODEL.CORR_DATE)), 'MODEL');

