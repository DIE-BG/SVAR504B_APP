    %% Descomposición de choques
%{
    Script genera la descomposición de choques para las variables
    seleccionadas (list), en dos diferentes rangos. 
%}

% Generación de datos
MODEL = SimTools.sim.shd_dsc(MODEL);
% Lista de variables a graficar
list = [MODEL.ExoVar(4:end), 'd4_ln_cpi', 'd4_ln_z', 'd4_ln_v', 'r'];

%% Gráficas
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
                         
%% Primera diferencia
MODEL = SimTools.sim.diff_shd_dsc(MODEL);

% Gráficas
% Rango corto
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\diff');
SimTools.scripts.plot_diff_shd_dsc(MODEL, 'SavePath', temp_path,...
                  'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
                  'Variables', list);
