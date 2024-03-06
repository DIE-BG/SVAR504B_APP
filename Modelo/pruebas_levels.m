% SVAR50-4B
clear all;
clc;
%% Carga Modelo
read_SVAR50L;

%% Datos
obs = databank.fromCSV('SVAR50\observables_23q4.csv');
data = databank.fromCSV('SVAR50\data_corr.csv');

list = fieldnames(obs);
for i = 1:length(list)
    obs.(strcat('m_',list{i})) = obs.(list{i});
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

return



%% Corrimientos
%% libre

db_nov = databank.clip(h, qq(2005,1),qq(2023,3));
fcstrng_nov = qq(2023,4):qq(2030,4);

% h.d4_ln_ipei(qq(2023,4)) = -2.74;
db_feb = databank.clip(h, qq(2005,1),qq(2023,4));
fcstrng_feb = qq(2024,1):qq(2030,4);

corr_nov = simulate(MODEL.M, db_nov, fcstrng_nov, 'anticipate', false, 'DbOverlay=', true);
corr_feb = simulate(MODEL.M, db_feb, fcstrng_feb, 'anticipate', false, 'DbOverlay=', true);


return
%%
pltrng = qq(2005,1):qq(2025,4);

p = plot([corr_nov.d4_ln_cpi{pltrng}, corr_feb.d4_ln_cpi{pltrng}, h.d4_ln_cpi], 'LineWidth', 1.5);
legend({'Noviembre','Febrero', 'Observado'})
% title('Tipo de Cambio Real');
set(p(end), 'Color','k', 'linewidth',2);
vline(fcstrng_feb(1)-1);

%%
[corr_nov.d4_ln_cpi_nosub{pltrng}, corr_feb.d4_ln_cpi_nosub{pltrng}, h.d4_ln_cpi_nosub]
[corr_nov.d4_ln_cpi_sub{pltrng}, corr_feb.d4_ln_cpi_sub{pltrng}, h.d4_ln_cpi_sub]
%%
p = plot([sl.d4_ln_cpi{pltrng}, h.d4_ln_cpi{pltrng}, data.v10{pltrng}], 'LineWidth', 1.5);
legend({'Forecast','Filtrado','Observado'})
% title('Tipo de Cambio Real');
set(p(end), 'Color','k', 'linewidth',2);
vline(fcstrng(1)-1);

