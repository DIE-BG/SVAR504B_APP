%% Descomposición de choques
%{
    Script genera la descomposición de choques para las variables
    seleccionadas (list), en dos diferentes rangos. 
%}

% Generación de datos
MODEL = SimTools.sim.shd_dsc(MODEL);
% Lista de variables a graficar
list = [MODEL.ExoVar(4:end), 'd4_ln_cpi', 'd4_ln_z', 'd4_ln_v', 'r', 'd4_ln_s', 'd4_ln_cpi_sub', 'd4_ln_cpi_nosub',...
        'd4_ln_y', 'd4_ln_bm', 'd4_ln_v'];

%% Gráficas
% Rango Completo
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\long');
scripts.plot_shd_dsc(MODEL, 'SavePath', temp_path,...
                             'Rng', {},...
                             'Variables',list);
% Rango corto
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\short');
scripts.plot_shd_dsc(MODEL, 'SavePath', temp_path,...
                             'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
                             'Variables',list); 
                         
%% Primera diferencia
MODEL = SimTools.sim.diff_shd_dsc(MODEL);

% Gráficas
% Rango corto
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\diff');
scripts.plot_diff_shd_dsc(MODEL, 'SavePath', temp_path,...
                  'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
                  'Variables', list);

%% Descomposición de shocks SVAR504B
% Generación de datos
MODEL_ANT = SimTools.sim.shd_dsc(MODEL_ANT);

% Gráficas
% Rango Completo
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\long\SVAR504B');
scripts.plot_shd_dsc(MODEL_ANT, 'SavePath', temp_path,...
                             'Rng', {},...
                             'Variables',list);
% Rango corto
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\short\SVAR504B');
scripts.plot_shd_dsc(MODEL_ANT, 'SavePath', temp_path,...
                             'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
                             'Variables',list);
                         
%% Primera diferencia
MODEL_ANT = SimTools.sim.diff_shd_dsc(MODEL_ANT);

% Gráficas
% Rango corto
temp_path = fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,'Shock_dec\diff\SVAR504B');
scripts.plot_diff_shd_dsc(MODEL_ANT, 'SavePath', temp_path,...
                  'Rng', MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
                  'Variables', list);
              
