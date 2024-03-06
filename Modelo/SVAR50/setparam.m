% ASIGNACION DE PARAMETROS -- Modelo con variables añadidas.
% MODELO: SVAR50-4B

%% Carga de parámetros estimados procedentes de eviews

MODEL.GAMMA_0 = readmatrix(fullfile('parametrizacion','gamma0_2005Q1-2023Q1.csv'));
MODEL.PHI     = readmatrix(fullfile('parametrizacion','phi_2005Q1-2023Q1.csv'));
CONST_EST = MODEL.PHI(:,end);
MODEL.PHI     = MODEL.PHI(:,1:end-1);
MODEL.COV_MAT = readmatrix(fullfile('parametrizacion','covmat_2005Q1-2023Q1.csv'));

% Estados Estacionarios
MODEL.SS =  readmatrix(fullfile('parametrizacion','SteadyState.csv'));

%% ESTADOS ESTACIONARIOS A IMPONER (MUESTRA COMPLETA)
s.d4_ln_y_star_ss = MODEL.SS(1);
s.d4_ln_ipei_ss = MODEL.SS(2);
s.i_star_ss = MODEL.SS(3);
s.d4_ln_cpi_nosub_ss = MODEL.SS(4);
s.d4_ln_y_ss = MODEL.SS(5);
s.d4_ln_cpi_sub_ss = MODEL.SS(6);
s.d4_ln_s_ss = MODEL.SS(7);
s.d4_ln_bm_ss = MODEL.SS(8); 
s.i_ss = MODEL.SS(9);
s.d4_ln_cpi_ss = s.d4_ln_cpi_sub_ss + s.d4_ln_cpi_nosub_ss;
s.d4_ln_z_ss = s.d4_ln_s_ss + s.d4_ln_ipei_ss - s.d4_ln_cpi_sub_ss;
s.d4_ln_v_ss = s.d4_ln_cpi_sub_ss + s.d4_ln_y_ss - s.d4_ln_bm_ss;
s.r_ss = s.i_ss - s.d4_ln_cpi_sub_ss;

% Reajuste de Constantes del modelo para tendencia a Ss impuesto
MODEL.C = (eye(size(MODEL.PHI)) - MODEL.PHI) * [MODEL.SS];

%% Calculos restantes SVAR
% Gamma1
MODEL.GAMMA_1 = MODEL.GAMMA_0 * MODEL.PHI;
% Constantes del modelo en forma estructural
MODEL.K = MODEL.GAMMA_0 * MODEL.C;

%% Asignación de parámetros a estructura s con nomenclatura del .mod
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
    s.(sprintf('std_s_v%i', i)) = sqrt(MODEL.COV_MAT(i, i));
end
 