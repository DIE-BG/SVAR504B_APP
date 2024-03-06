%% ASIGNACION DE PARAMETROS
% Promedios históricos de cada una de las variables en el período
% 2005Q1-2023Q1.

% ESTADOS ESTACIONARIOS (Promedios historicos)
MODEL.SS = csvread('SteadyState.csv');

%%
% Carga de matriz de coeficientes

MODEL.GAMMA_0 = csvread(MODEL.GAMMA_0_NAME);

MODEL.PHI     = csvread(MODEL.PHI_NAME);
MODEL.PHI     = MODEL.PHI(:, 1:end-1);

MODEL.C = (eye(size(MODEL.PHI)) - MODEL.PHI) * MODEL.SS;

MODEL.COV_MAT = csvread(MODEL.COV_MAT_NAME);

MODEL.GAMMA_1 = MODEL.GAMMA_0 * MODEL.PHI;

MODEL.K = MODEL.GAMMA_0 * MODEL.C;


% Asignacion de estados estacionarios.
for i = 1:length(MODEL.SS)
    s.(strcat(char(MODEL.ExoVar(i)),'_ss')) = MODEL.SS(i);
end
% Asignacion de constantes.
for i = 1:length(MODEL.K)
    s.(sprintf('k%i', i)) = MODEL.K(i);
end
% Asignacion de GAMMA_0.
for row = 1:size(MODEL.GAMMA_0, 1)
    for col = 1:size(MODEL.GAMMA_0, 2)
        s.(sprintf('g_0_%i%i', row, col)) = MODEL.GAMMA_0(row, col);
    end
end

% Asginacion de GAMMA_1.
for row = 1:size(MODEL.GAMMA_1, 1)
    for col = 1:size(MODEL.GAMMA_1, 2)
        s.(sprintf('g_1_%i%i', row, col)) = MODEL.GAMMA_1(row, col);
    end
end
% -----STD ERRORS OF SHOCKS (only matter for ACF)-----
for i = 1:length(MODEL.K)
    s.(strcat('std_s_',char(MODEL.ExoVar(i)))) = sqrt(MODEL.COV_MAT(i, i));
end

%% ----- Seccion para la asignacion de parametros adicionales. -----

s.d4_ln_cpi_ss = s.d4_ln_cpi_nosub_ss + s.d4_ln_cpi_sub_ss;
s.d4_ln_z_ss = s.d4_ln_s_ss + s.d4_ln_ipei_ss - s.d4_ln_cpi_sub_ss;
s.d4_ln_v_ss = s.d4_ln_cpi_sub_ss + s.d4_ln_y_ss - s.d4_ln_bm_ss;
s.r_ss = s.i_ss - s.d4_ln_cpi_sub_ss;
