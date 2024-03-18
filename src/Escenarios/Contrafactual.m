%% Contrafactual de PM

%{
    Escenarios contrafactuales utilizando instrumentos de PM:
                - Tasa de interes líder
                - Base Monetaria

    No necesariamente se "endogeniza" el choque correspondiente a la
    variable anclada, ni en los mismos períodos.
%}

% Trimestres de anclaje
MODEL.DATES.E1_dates = MODEL.DATES.pred_start:MODEL.DATES.pred_start+7;

%% Tasa de interés invariable en horizonte de pronóstico (8 Trimestres)

shocks = MODEL.F_pred*get(MODEL.MF, 'elist');
MODEL.CP1.dbi = dboverlay(MODEL.F,shocks);
% Mantener la tasa invariable
MODEL.CP1.dbi.i(MODEL.DATES.E1_dates) = MODEL.F.i(MODEL.DATES.hist_end);

% Plan de simulación
MODEL.CP1.planCP1 = plan(MODEL.MF,MODEL.DATES.pred_start:MODEL.DATES.pred_end);
% Variable a endogenizar (shock propio?? No necesariamente)
MODEL.CP1.planCP1 = endogenize(MODEL.CP1.planCP1,{'s_i'},MODEL.DATES.E1_dates); 
% Variable a exogenizar (Anclaje)
MODEL.CP1.planCP1 = exogenize(MODEL.CP1.planCP1,{'i'},MODEL.DATES.E1_dates);

% Simulación.
MODEL.CP1.pred = simulate(MODEL.MF,...
              MODEL.CP1.dbi,...
              MODEL.DATES.pred_start:MODEL.DATES.pred_end,...
              'plan',MODEL.CP1.planCP1,...
              'anticipate',false,...
              'DbOverlay=', true);
