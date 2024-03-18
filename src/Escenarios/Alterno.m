%% Escenarios Alternativos
%{
    Escenarios de riesgo alrededor de variables externas o que no son
    instrumentos de Política Monetaria.

    Se "endogeniza" el choque propio de las variables ancladas.
%}

%% 1. JCCF: Anclaje de IPEI proveniente de QPM en horizonte de pronóstico
% (8 Trimestres)

% Base de datos
alt1 = databank.fromCSV(...
        fullfile('data', 'corrimientos',MODEL.CORR_DATE,...
                 'v1', 'fulldata_QPM.csv')); 
             
% Trimestres de anclaje
MODEL.DATES.E1_dates = MODEL.DATES.pred_start:MODEL.DATES.pred_start+7;

%% %%%%%%%%%%%%%%%% Creación de escenario alternativo %%%%%%%%%%%%%%%%%%%%%%
% Shocks del escenario base
shocks = MODEL.F_pred*get(MODEL.MF, 'elist');
% Concatenación de bd con condiciones iniciales (MODEL.F) y shocks Esc.
% Libre
MODEL.Alt1.dbi = dboverlay(MODEL.F,shocks);

% Imposición de anclajes provenientes del QPM en base de datos
MODEL.Alt1.dbi.d4_ln_ipei(MODEL.DATES.E1_dates) = alt1.D4L_CPI_RW(MODEL.DATES.E1_dates);

% Plan de simulación
MODEL.Alt1.planE1 = plan(MODEL.MF,MODEL.DATES.pred_start:MODEL.DATES.pred_end);
% Variable a endogenizar (shock propio?? No necesariamente)
MODEL.Alt1.planE1 = endogenize(MODEL.Alt1.planE1,{'s_d4_ln_ipei'},MODEL.DATES.E1_dates); 
% Variable a exogenizar (Anclaje)
MODEL.Alt1.planE1 = exogenize(MODEL.Alt1.planE1,{'d4_ln_ipei'},MODEL.DATES.E1_dates);

% Simulación.

MODEL.Alt1.pred = simulate(MODEL.MF,...
                  MODEL.Alt1.dbi,...
                  MODEL.DATES.pred_start:MODEL.DATES.pred_end,...
                  'plan',MODEL.Alt1.planE1,...
                  'anticipate',false,...
                  'DbOverlay=', true);

