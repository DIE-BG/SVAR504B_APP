%{
    Se genera una gráfica con los componentes de la velocidad de
    circulación. Todas las variables son logaritmos naturales
    desestacionalizados.
%}
%% fulldata corrimiento anterior
corr_ant = databank.fromCSV(fullfile('data', 'fulldata', MODEL.CORR_DATE_ANT, sprintf("fulldata_%s_v0.csv", MODEL.CORR_DATE_ANT)));
load(fullfile('data', 'fulldata', MODEL.CORR_DATE_ANT, sprintf("PreProcessing-%s.mat", MODEL.CORR_DATE_ANT)));
load(fullfile('data', 'fulldata', MODEL.CORR_DATE_ANT, sprintf("PostProcessing-%s.mat", MODEL.CORR_DATE_ANT)));

%% Gráfica
toplot = {'ln_v_sa', 'ln_cpi_sub_sa', 'ln_y_sa', 'ln_bm_sa'};

MODEL.PostProc.l_sa.ln_v_sa
MODEL.PostProc.l_sa.ln_cpi_sub_sa
MODEL.PostProc.l_sa.ln_y_sa
MODEL.PostProc.l_sa.ln_bm_sa

for i = 1:length(toplot)
    
    set(gcf, ...
        'defaultaxesfontsize',12, ...
        'Position', [1 42.0182 1117.1 776.73]);
    
    subplot(2,2,i)
    
     h = plot(MODEL.DATES.hist_start:MODEL.DATES.pred_end,...
             [MODEL.PostProc.l_sa.(toplot{i}),... %corr actual
             post_proc.l_sa.(toplot{i}),... %corr anterior
             MODEL.PostProc.l_sa.(toplot{i}).clip(MODEL.DATES.hist_start, MODEL.DATES.hist_end)],... % historia
             'Marker', '.',...
             'MarkerSize', 7,...
             'LineWidth', 0.5); 
        
    % Colores
    % historia
    set(h(end), 'color', [0 0 1], 'LineWidth', 0.5);
    % Corr actual
    set(h(1), 'color', [0 0 1]);
    % Corr anterior
    set(h(2), 'color', [1 0 0]);    
    
    %linea vertical
    vline(MODEL.DATES.hist_end, ...
        'LineWidth', 1, ...
        'LineStyle', '-')
    
    %titulos
    title(regexprep(MODEL.PostProc.l_sa.(toplot{i}).Comment{1}, '\([^)]*\)', ''),...
        '(niveles)','Interpreter', 'none');
        
    % leyenda
    legend({MODEL.leg_act,...
        MODEL.leg_ant},...
        'Location','best', 'Interpreter', 'none',...
        'FontSize', 8);
    
     sgtitle('Componentes de la Velocidad de Circulación')
    
    if i == 4
       SimTools.scripts.pausaGuarda(fullfile('Plots',...
                                        'Velocidad (componentes).png'), ...
                                        'AutoSave', true) 
    end
       
end

