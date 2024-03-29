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
MODEL.CP1.dbi = dboverlay(MODEL.F,shocks);
% Mantener la tasa invariable
MODEL.CP1.dbi.i(MODEL.DATES.pred_start) = MODEL.F.i(MODEL.DATES.hist_end);

% Plan de simulación
MODEL.CP1.planSim = plan(MODEL.MF,MODEL.DATES.pred_start:MODEL.DATES.pred_end);
% Variable a endogenizar (shock propio?? No necesariamente)
MODEL.CP1.planSim = endogenize(MODEL.CP1.planSim,{'s_i'},MODEL.DATES.pred_start); 
% Variable a exogenizar (Anclaje)
MODEL.CP1.planSim = exogenize(MODEL.CP1.planSim,{'i'},MODEL.DATES.pred_start);

% Simulación.
MODEL.CP1.pred = simulate(MODEL.MF,...
              MODEL.CP1.dbi,...
              MODEL.DATES.pred_start:MODEL.DATES.pred_end,...
              'plan',MODEL.CP1.planSim,...
              'anticipate',false,...
              'DbOverlay=', true);

% Descomposición             
MODEL.CP1.shd = simulate(MODEL.MF,...
                  MODEL.CP1.pred,...
                  MODEL.DATES.hist_start:MODEL.DATES.pred_end,...
                  'anticipate',false,...
                  'contributions',true);          

%% Post Procesamiento
MODEL = PostProcessing(MODEL,...
                       'list',pp_list,...
                       'list_niv', list_nivel,...
                       'Esc',{'v2', MODEL.CP1.pred});
          
%% GRÁFICAS

PreProcPlots(MODEL,...
             'Esc_add', {'v2', MODEL_ANT},...
             'tab_range', tab_range_source_data,...
             'tab_range_mm', tab_range_mm);

% Variables del modelo
simPlots(MODEL,...
         'StartDate',{MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20},...
         'EndDatePlot', {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20},...
         'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v2','prediction_compared'),...}
         'Esc_add', {'v2', MODEL.CP1.pred},...
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
        'Esc_add', {'v2', MODEL.CP1.pred},...
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
plot_shd_dsc(MODEL, MODEL.CP1.pred, MODEL.CP1.shd,...
            'SavePath', fullfile(cd, 'plots', MODEL.CORR_DATE, 'v2','Shock_dec\long'),...
            'Rng', {},...
            'Variables',list)
        
% Rango corto
plot_shd_dsc(MODEL, MODEL.CP1.pred, MODEL.CP1.shd,...
             'SavePath', fullfile('plots',MODEL.CORR_DATE,'v2','Shock_dec\short'),...
             'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
             'Variables',list); 