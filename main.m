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
tic
MODEL.NAME = 'SVAR_50_4B';

PATH.data = genpath('data');
PATH.src = genpath('src');
PATH.temp = genpath('temp');

structfun(@addpath, PATH)

%% Carga de configuraciones generales del corrimiento base (v0)
StartConfig;

%% PRE-PROCESSING
PreProcessing;
disp('Preprocesamiento: ok');
%% Lectura de Modelo, datos y proceso de filtrado
MODEL = SimTools.sim.read_model(MODEL);
% Lectura de datos con variables observables en data_corr.csv
MODEL = SimTools.scripts.read_data_corr(MODEL);
% Filtrado para obtención de no observables
MODEL = SimTools.sim.kalman_smth(MODEL);
disp('Filtrado: ok');
%%
MODEL = predictions(MODEL,...
    'SaveFullData', true);
disp('Simulación: ok');
%% POST-PROCESSING
MODEL = PostProcessing(MODEL,...
    'list',pp_list,...
    'list_niv', list_nivel,...
    'Esc',{MODEL.CORR_VER, MODEL.F_pred});
disp('Postprocesamiento: ok');

%% Gráficas
do_graphs = true;

if do_graphs == true
    % datos fuente y Preprocesamiento
    PreProcPlots(MODEL,...
        'Esc_add', {'v0', MODEL_ANT},...
        'tab_range', tab_range_source_data,...
        'tab_range_mm', tab_range_mm);
    
    % Plots de Simulación
    simPlots(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, MODEL.CORR_VER,'prediction_compared'),...}
        'Esc_add', {MODEL.CORR_DATE_ANT, MODEL_ANT.F_pred, []},...
        'PlotList', get(MODEL.MF, 'xlist'),...
        'LegendsNames',{MODEL.leg_ant, MODEL.leg_act},...
        'TabRange', tab_range...
        );
    % Post Procesamiento
    % Logaritmo/tendencia vs corr. Anterior
    PostPrLogsComp(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE,'v0', 'PostProcessing'),...
        'Esc',{'v0', MODEL.PostProc},...
        'Esc_add', {'v0', MODEL_ANT.PostProc.v0, []},...
        'PlotList', pp_list,...
        'LegendsNames',{MODEL.leg_ant, MODEL.leg_act},...
        'TabRange', tab_range...
        );
    
    PostPrLevels(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, MODEL.CORR_VER,'PostProcessing'),...
        'Esc_add', {MODEL.CORR_DATE_ANT, MODEL_ANT.PostProc.v0, []},...
        'PlotList', list_lev,...
        'Titles', tit_lev,...
        'LegendsNames',{MODEL.leg_ant, MODEL.leg_act},...
        'TabRange', tab_range...
        );
    
    PostPrGaps(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, MODEL.CORR_VER,'PostProcessing'),...
        'Esc_add', {MODEL.CORR_DATE_ANT, MODEL_ANT.PostProc.v0, []},...
        'PlotList', list_gaps,...
        'LegendsNames',{MODEL.leg_ant, MODEL.leg_act},...
        'TabRange', tab_range...
        );
    
    % Otras Gráficas
    % Subplot tcr
    tcr_subplot(MODEL,...
        'Esc_add', {'v0', MODEL_ANT.PostProc, []},...
        'tab_range', tab_range,...
        'LegendsNames',{MODEL.leg_ant, MODEL.leg_act})
    
    % Componentes Velocidad de Circulación de la Base Monetaria
    velocidad_subplot(MODEL,...
        'tab_range', tab_range,...
        'Esc_add', {'v0', MODEL_ANT.PostProc, []},...
        'tab_range', tab_range,...
        'LegendsNames',{MODEL.leg_ant, MODEL.leg_act});
    
    % Descomposición de choques para variables seleccionadas
    Desc_shocks;
    
    % Graficas de contribuciones
    contributions(MODEL,...
                  'SavePath',fullfile('plots', MODEL.CORR_DATE, MODEL.CORR_VER, 'contributions'),...
                  'Esc_add', {'v0', MODEL_ANT});
              
    contributions(MODEL,...
                  'SavePath',fullfile('plots', MODEL.CORR_DATE, MODEL.CORR_VER, 'diff contributions'),...
                  'Esc_add', {'v0', MODEL_ANT},...
                  'diff', true);
end

%% Escenarios alternos
esc_alt = true;

if esc_alt == true
    v1_IPEI;
    v2_CP1;
    v3_Comb1_2;
%     v4_CP2;
%     v5_CP3;
end

%% Presentación
prs = true;
if prs == true
    presentacion;
end
%% Almacenamiento de Estructura MODEL del mes corriente.
save(fullfile('data','fulldata',MODEL.CORR_DATE, sprintf("MODEL-%s.mat", MODEL.CORR_DATE)), 'MODEL');
disp('Almacenamiento estructura MODEL: ok');
disp('---- FIN ----');
toc