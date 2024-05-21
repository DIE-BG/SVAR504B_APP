%% Contrafactual de PM

%{
    Escenarios contrafactuales utilizando instrumentos de PM:
                - Tasa de interes líder
                - Base Monetaria

    No necesariamente se "endogeniza" el choque correspondiente a la
    variable anclada, ni en los mismos períodos.
%}


%% 1. Tasa de interés invariable en el primer trimestre de pronóstico

shocks = MODEL.F_pred*get(MODEL.MF, 'elist');
MODEL.Esc.v2.dbi = dboverlay(MODEL.F,shocks);
% Mantener la tasa invariable
MODEL.Esc.v2.dbi.i(MODEL.DATES.pred_start) = MODEL.F.i(MODEL.DATES.hist_end);

% Plan de simulación
MODEL.Esc.v2.planSim = plan(MODEL.MF,MODEL.DATES.pred_start:MODEL.DATES.pred_end);
% Variable a endogenizar (shock propio?? No necesariamente)
MODEL.Esc.v2.planSim = endogenize(MODEL.Esc.v2.planSim,{'s_i'},MODEL.DATES.pred_start); 
% Variable a exogenizar (Anclaje)
MODEL.Esc.v2.planSim = exogenize(MODEL.Esc.v2.planSim,{'i'},MODEL.DATES.pred_start);

% Simulación.
MODEL.Esc.v2.pred = simulate(MODEL.MF,...
              MODEL.Esc.v2.dbi,...
              MODEL.DATES.pred_start:MODEL.DATES.pred_end,...
              'plan',MODEL.Esc.v2.planSim,...
              'anticipate',false,...
              'DbOverlay=', true);

% Descomposición             
MODEL.Esc.v2.shd = simulate(MODEL.MF,...
                  MODEL.Esc.v2.pred,...
                  MODEL.DATES.hist_start:MODEL.DATES.pred_end,...
                  'anticipate',false,...
                  'contributions',true);          

%% Post Procesamiento
MODEL = PostProcessing(MODEL,...
                       'list',pp_list,...
                       'list_niv', list_nivel,...
                       'Esc',{'v2', MODEL.Esc.v2.pred});
          
%% GRÁFICAS
if do_graphs == true
    % Preprocessing
    PreProcPlots(MODEL,...
        'Esc_add', {'v2', MODEL_ANT},...
        'tab_range', tab_range_source_data,...
        'tab_range_mm', tab_range_mm);
    
    % Variables del modelo
    simPlots(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v2','prediction_compared'),...}
        'Esc_add', {'v2', MODEL.Esc.v2.pred},...
        'PlotList', get(MODEL.MF, 'xlist'),...
        'LegendsNames',{MODEL.esc_names{3}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    % Postprocesamiento - Logaritmos desestacionalizados y tendencia
    PostPrLogsComp(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE,'v2', 'PostProcessing'),...
        'Esc',{'v0', MODEL.PostProc},...
        'Esc_add', {'v2', MODEL.PostProc.v2},...
        'PlotList', pp_list,...
        'LegendsNames',{MODEL.esc_names{3}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    % Postprocesamiento - Niveles
    PostPrLevels(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v2','PostProcessing'),...
        'Esc_add', {'v2', MODEL.PostProc.v2},...
        'PlotList', list_lev,...
        'Titles', tit_lev,...
        'LegendsNames',{MODEL.esc_names{3}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    % Postprocesamiento - Brechas
    PostPrGaps(MODEL,...
        'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
        'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v2','PostProcessing'),...
        'Esc_add', {'v2', MODEL.PostProc.v2},...
        'PlotList', list_gaps,...
        'LegendsNames',{MODEL.esc_names{3}, MODEL.esc_names{1}},...
        'TabRange', tab_range...
        );
    
    % Tipo de cambio real
    % Componentes Tipo de cambio real
    tc_real(MODEL,...
        'Esc_add', {'v2', MODEL.Esc.v2.pred},...
        'tab_range', tab_range,...
        'LegendsNames',{MODEL.esc_names{3}, MODEL.esc_names{1}});
    
    % Subplot tcr
    tcr_subplot(MODEL,...
        'Esc_add', {'v2', MODEL.PostProc},...
        'tab_range', tab_range,...
        'LegendsNames',{MODEL.esc_names{3}, MODEL.esc_names{1}})
    
    % Componentes Velocidad de Circulación de la Base Monetaria
    velocidad_subplot(MODEL,...
        'tab_range', tab_range,...
        'Esc_add', {'v2', MODEL.PostProc},...
        'LegendsNames',{MODEL.esc_names{3}, MODEL.esc_names{1}},...
        'tab_range', tab_range);
    
    % Descomposición de shocks
    % Rango completo
    list = [MODEL.ExoVar(4:end), 'd4_ln_cpi', 'd4_ln_z', 'd4_ln_v', 'r'];
    plot_shd_dsc(MODEL, MODEL.Esc.v2.pred, MODEL.Esc.v2.shd,...
        'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v2','Shock_dec\long'),...
        'Rng', {},...
        'Variables',list)
    
    % Rango corto
    plot_shd_dsc(MODEL, MODEL.Esc.v2.pred, MODEL.Esc.v2.shd,...
        'SavePath', fullfile('plots',MODEL.CORR_DATE,'v2','Shock_dec\short'),...
        'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
        'Variables',list);
    
    % Primera diferencia de la descomposicón de shocks
    % Rango corto
    plot_diff_shd_dsc(MODEL, MODEL.Esc.v2.pred, MODEL.Esc.v2.shd,...
                                       'SavePath', fullfile('plots',MODEL.CORR_DATE,'v2','Shock_dec\diff'),...
                                       'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
                                       'Variables', list);
                                   
    % Graficas de contribuciones
    contributions(MODEL,...
                  'SavePath',fullfile('plots', MODEL.CORR_DATE, 'v2', 'contributions'),...
                  'Esc_add', {'v2', MODEL.Esc.v2.pred});
              
    contributions(MODEL,...
                  'SavePath',fullfile('plots', MODEL.CORR_DATE, 'v2', 'diff contributions'),...
                  'Esc_add', {'v2', MODEL.Esc.v2.pred},...
                  'diff', true);
    
end
disp('Escenario 2: ok');