%% Contrafactual de PM 2

%{
    Escenarios contrafactuales utilizando instrumentos de PM:
                - Tasa de interes líder
                - Base Monetaria

    En este escenario se "anclan" en el primer trimestre:
        - Incremento intertrimestral máximo observado de tasa de interés
          líder
        - Incremento intertrimestral máximo observado de Base Monetaria.

    Adicionalmente se ancla la inflación total en 4% ocho trimestres
    adelante, utilizando una trayectoria de choques de tasa de
    interés líder.
    

    El objetivo es generar un escenario que simule una acción de política
    monetaria "agresiva", pero dentro de los parámetros históricos y una 
    trayectoria de choques de política que haga que la inflación total esté
    en 4% en el trimestre establecido.
%}

shocks = MODEL.F_pred*get(MODEL.MF, 'elist');
MODEL.Esc.v5.dbi = dboverlay(MODEL.F,shocks);

% dif intertrimestrales máximas
d_i = max(abs(MODEL.F.i.diff(-1)));
d_bm = -1*max(abs(MODEL.F.d4_ln_bm.diff(-1)));
% Cambios para el primer período de pronóstico
MODEL.Esc.v5.dbi.i(MODEL.DATES.pred_start) = MODEL.Esc.v5.dbi.i(MODEL.DATES.hist_end) + d_i;  
MODEL.Esc.v5.dbi.d4_ln_bm(MODEL.DATES.pred_start) = MODEL.Esc.v5.dbi.d4_ln_bm(MODEL.DATES.hist_end) + d_bm;
% Inflación
MODEL.Esc.v5.dbi.d4_ln_cpi(MODEL.DATES.hist_end+8) = 4;


% Plan de simulación
MODEL.Esc.v5.planSim = plan(MODEL.MF,MODEL.DATES.pred_start:MODEL.DATES.pred_end);

% Choques en el primer trimestre de pronóstico
% Variable a endogenizar (shock propio?? No necesariamente)
MODEL.Esc.v5.planSim = endogenize(MODEL.Esc.v5.planSim,{'s_i'},MODEL.DATES.pred_start); 
MODEL.Esc.v5.planSim = endogenize(MODEL.Esc.v5.planSim,{'s_d4_ln_bm'},MODEL.DATES.pred_start); 
% Variable a exogenizar (Anclaje)
MODEL.Esc.v5.planSim = exogenize(MODEL.Esc.v5.planSim,{'i'},MODEL.DATES.pred_start);
MODEL.Esc.v5.planSim = exogenize(MODEL.Esc.v5.planSim,{'d4_ln_bm'},MODEL.DATES.pred_start);

% Trayectoria adicional para convergencia a 4% ocho trimestres adelante
MODEL.Esc.v5.planSim = exogenize(MODEL.Esc.v5.planSim, {'d4_ln_cpi'}, MODEL.DATES.hist_end+8);
MODEL.Esc.v5.planSim = endogenize(MODEL.Esc.v5.planSim, {'s_i'}, MODEL.DATES.pred_start+1:MODEL.DATES.hist_end+8);

% Simulación.
MODEL.Esc.v5.pred = simulate(MODEL.MF,...
              MODEL.Esc.v5.dbi,...
              MODEL.DATES.pred_start:MODEL.DATES.pred_end,...
              'plan',MODEL.Esc.v5.planSim,...
              'anticipate',false,...
              'DbOverlay=', true);

% Descomposición             
MODEL.Esc.v5.shd = simulate(MODEL.MF,...
                  MODEL.Esc.v5.dbi,...
                  MODEL.DATES.hist_start:MODEL.DATES.pred_end,...
                  'plan',MODEL.Esc.v5.planSim,...
                  'anticipate',false,...
                  'contributions',true);  
%% Post Procesamiento
MODEL = PostProcessing(MODEL,...
                       'list',pp_list,...
                       'list_niv', list_nivel,...
                       'Esc',{'v5', MODEL.Esc.v5.pred});
%% GRÁFICAS
if do_graphs == true
    % Preprocessing
    PreProcPlots(MODEL,...
        'Esc_add', {'v5', MODEL_ANT},...
        'tab_range', tab_range_source_data,...
        'tab_range_mm', tab_range_mm);
    
    % Variables del modelo
    simPlots(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v5','prediction_compared'),...}
        'Esc_add', {'v5', MODEL.Esc.v5.pred},...
        'PlotList', get(MODEL.MF, 'xlist'),...
        'LegendsNames',{MODEL.esc_names{6}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    
    % Postprocesamiento - Logaritmos desestacionalizados y tendencia
    PostPrLogsComp(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE,'v5', 'PostProcessing'),...
        'Esc',{'v0', MODEL.PostProc},...
        'Esc_add', {'v5', MODEL.PostProc.v5},...
        'PlotList', pp_list,...
        'LegendsNames',{MODEL.esc_names{6}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    
    % Postprocesamiento - Niveles
    PostPrLevels(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v5','PostProcessing'),...
        'Esc_add', {'v5', MODEL.PostProc.v5},...
        'PlotList', list_lev,...
        'Titles', tit_lev,...
        'LegendsNames',{MODEL.esc_names{6}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    
    % Postprocesamiento - Brechas
    PostPrGaps(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v5','PostProcessing'),...
        'Esc_add', {'v5', MODEL.PostProc.v5},...
        'PlotList', list_gaps,...
        'LegendsNames',{MODEL.esc_names{6}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    
    % Tipo de cambio real
    % Componentes Tipo de cambio real
    tc_real(MODEL,...
        'Esc_add', {'v5', MODEL.Esc.v5.pred},...
        'tab_range', tab_range,...
        'LegendsNames',{MODEL.esc_names{6}, MODEL.esc_names{1}});
    
    % Subplot tcr
    tcr_subplot(MODEL,...
        'Esc_add', {'v5', MODEL.PostProc},...
        'tab_range', tab_range,...
        'LegendsNames',{MODEL.esc_names{6}, MODEL.esc_names{1}});
    
    
    % Componentes Velocidad de Circulación de la Base Monetaria
    velocidad_subplot(MODEL,...
        'tab_range', tab_range,...
        'Esc_add', {'v5', MODEL.PostProc},...
        'LegendsNames',{MODEL.esc_names{6}, MODEL.esc_names{1}},...
        'tab_range', tab_range);
    
    % Descomposición de shocks
    % Rango completo
    list = [MODEL.ExoVar(4:end), 'd4_ln_cpi', 'd4_ln_z', 'd4_ln_v', 'r'];
    
    plot_shd_dsc(MODEL, MODEL.Esc.v5.pred, MODEL.Esc.v5.shd,...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v5','Shock_dec\long'),...
        'Rng', {},...
        'Variables',list)
    
    % Rango corto
    plot_shd_dsc(MODEL, MODEL.Esc.v5.pred, MODEL.Esc.v5.shd,...
        'SavePath', fullfile('plots',MODEL.CORR_DATE,'v5','Shock_dec\short'),...
        'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
        'Variables',list);
end
disp('Escenario 5: ok');