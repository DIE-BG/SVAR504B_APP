% SVAR50-4B
clear all;
clc;
%% Carga Modelo
read_SVAR50L;

%% Datos
obs = databank.fromCSV('SVAR50\observables.csv');
data = databank.fromCSV('SVAR50\data_corr.csv');

list = fieldnames(obs);
for i = 1:length(list)
    obs.(strcat('obs_',list{i})) = obs.(list{i});
end

%% Filtrado con kalman para recuperar variables no observables
% En el caso del SVAR50: solo los choques estructurales s_vx

% Período inicial de filtrado
sdate = qq(2005,1);

% Período final de filtrado (fin de historia)
edate = qq(2023,4);

% proceso de filtrado (ModelingLegacy\@model)
[m_kf, g] = filter(MODEL.M,obs,sdate:edate);
h = g.mean;


%% Corrimiento
%% libre
fcstrng = qq(2024,1):qq(2030,4);
db = databank.clip(h, qq(2005,1),fcstrng(1)-1);
sl = simulate(MODEL.M, db, fcstrng, 'anticipate', false, 'DbOverlay=', true);

%%


p = plot([sl.d4_ln_cpi, h.d4_ln_cpi], 'LineWidth', 1.5);
legend({'Pronóstico','Filtrado'})
% title('Tipo de Cambio Real');
set(p(end), 'Color','k', 'linewidth',2);
vline(fcstrng(1)-1);

p = plot([h.d4_ln_cpi, data.v10], 'LineWidth', 1.5);
legend({'Filtrado','Observado'})
% title('Tipo de Cambio Real');
set(p(end), 'Color','k', 'linewidth',2);
vline(fcstrng(1)-1);

