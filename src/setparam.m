%% ASIGNACION DE PARAMETROS
%% Nombre de matrices de coeficientes
MODEL.COV_MAT_NAME = 'COV_MAT.CSV';
MODEL.GAMMA_0_NAME = 'GAMMA_0.CSV';
MODEL.PHI_NAME = 'PHI.CSV';

% Promedios históricos de cada una de las variables en el período
% 2005Q1-2023Q1.

% ESTADOS ESTACIONARIOS (Promedios historicos)
MODEL.SS = csvread('SteadyState.csv');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Carga de matriz de coeficientes %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Coeficientes VAR en forma reducida
% Matriz de rezagos VAR en forma Reducida
MODEL.PHI     = csvread(MODEL.PHI_NAME);
MODEL.PHI     = MODEL.PHI(:, 1:end-1);
% Imposición de ss en constante de modelo en forma reducida
MODEL.C = (eye(size(MODEL.PHI)) - MODEL.PHI) * MODEL.SS;
% Matriz de covarianzas
MODEL.COV_MAT = csvread(MODEL.COV_MAT_NAME);

% Coeficientes VAR en forma estructural
% Matriz de efectos contemporaneos (cholesky) de VAR Estructural
MODEL.GAMMA_0 = csvread(MODEL.GAMMA_0_NAME);
% Cálculo de matriz de rezagos de VAR Estructural
MODEL.GAMMA_1 = MODEL.GAMMA_0 * MODEL.PHI;
% Matriz de constantes de VAR Estructural
MODEL.K = MODEL.GAMMA_0 * MODEL.C;

%% Asignación de parámetros con nomenclatura del .mod

% Estados estacionarios.
for i = 1:length(MODEL.SS)
    s.(strcat(char(MODEL.ExoVar(i)),'_ss')) = MODEL.SS(i);
end
% Constantes.
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
% Estados Estacionarios de identidades en .mod
s.dla_cpi_ss = s.dla_cpi_nosub_ss + s.dla_cpi_sub_ss;
s.dla_z_ss = s.dla_s_ss + s.dla_ipei_ss - s.dla_cpi_sub_ss;
s.dla_v_ss = s.dla_cpi_sub_ss + s.dla_y_ss - s.dla_bm_ss;
s.r_ss = s.i_ss - s.dla_cpi_sub_ss;
