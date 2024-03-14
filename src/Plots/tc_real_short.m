function tc_real(MODEL, varargin)
%{
    Genera las graficas relacionadas al tipo de cambio real
        Tipo de cambio real por componentes (corrimiento actual)
        subplot tipo de cambio real (corrimiento actual y anterior)
%}

p = inputParser;
    addParameter(p, 'corr_ant', {});
    addParameter(p, 'tab_range', {});
    addParameter(p, 'pred_ant', {});

parse(p, varargin{:});
params = p.Results; 

%%

if ~isfolder(fullfile('plots',...
            MODEL.CORR_DATE, MODEL.CORR_VER,...
            'otras'))
    mkdir(fullfile('plots',...
            MODEL.CORR_DATE, MODEL.CORR_VER,...
            'otras'))
end

%% fulldata corrimiento anterior
corr_ant = databank.fromCSV(fullfile('data', 'fulldata', params.corr_ant, sprintf("fulldata_%s_v0.csv", params.corr_ant)));
load(fullfile('data', 'fulldata', params.corr_ant, sprintf("PreProcessing-%s.mat", params.corr_ant)));
load(fullfile('data', 'fulldata', params.corr_ant, sprintf("PostProcessing-%s.mat", params.corr_ant)));

% recorte
MODEL.F_pred = dbclip(MODEL.F_pred, MODEL.DATES.hist_end-20,...
                      MODEL.DATES.hist_end+20);

MODEL.PostProc = dbclip(MODEL.PostProc, MODEL.DATES.hist_end-20,...
                      MODEL.DATES.hist_end+20);
                  
corr_ant = dbclip(corr_ant, MODEL.DATES.hist_end-20,...
                      MODEL.DATES.hist_end+20);                 
post_proc = dbclip(post_proc, MODEL.DATES.hist_end-20,...
                      MODEL.DATES.hist_end+20);

%% Tipo de cambio real por componentes

% Corrimiento actual
colors = [[0.4940 0.1840 0.5560]; [0 0.498 0]; [0.667 0 0]; [0 0 0]];

figure;
  set( ...
  gcf, ...
  'defaultaxesfontsize',12, ...
  'Position', [1 42.0182 1717.1 906.73]);

main_p = uipanel('Units','normalized');

% ----- Panel de grafica -----
plot_p = uipanel( ...
         main_p, ...
        'Position', [0, 1 - 0.8, 1, 0.8], ...
        'BackgroundColor', [1, 1, 1]);

ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);

    plot(MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
        [MODEL.F_pred.d4_ln_s, MODEL.F_pred.d4_ln_ipei,...
          MODEL.F_pred.d4_ln_cpi_sub, MODEL.F_pred.d4_ln_z],...
          'Marker', 'none', 'MarkerSize', 17,...
          'LineWidth', 2);

    ax = gca;
    ax.ColorOrder = colors;

    legend('Tipo de Cambio Nominal', 'Inflación Externa',...
           'Inflación Interna', 'Tipo de Cambio Real',...
           'Location','best', 'Fontsize', 13);

    grid off;

        % Titulo
    title('Tasa de Variación del Tipo de Cambio Real (Porcentajes)',...
          {strcat("Corrimiento ",MODEL.leg_act),...
          strcat(dat2char(MODEL.DATES.hist_end -20), '-',...
            dat2char(MODEL.DATES.hist_end + 20))},...
            'Fontsize', 13);

    % Linea vertical (inicio prediccion)
    vline(MODEL.DATES.hist_end, ...
          'LineWidth', 1.5, ...
          'LineStyle', '-');

     zeroline();

    % ----- Panel de Tabla -----
    table_p = uipanel(main_p, ...
                        'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
                        'BackgroundColor', [1, 1, 1]);

    data_table = [];

            data_table(:, 1) = MODEL.F_pred.d4_ln_s(params.tab_range);       
            data_table(:, 2) = MODEL.F_pred.d4_ln_ipei(params.tab_range);
            data_table(:, 3) = MODEL.F_pred.d4_ln_cpi_sub(params.tab_range);
            data_table(:, 4) = MODEL.F_pred.d4_ln_z(params.tab_range);

            text_Color = colors;

    SimTools.scripts.plot_data_table(params.tab_range, ...
                                     data_table, ...
                                     'Parent', table_p, ...
                                     'SeriesNames', {'Tipo de Cambio Nominal', 'Inflación Externa',...
                                                     'Inflación Interna','Tipo de Cambio Real'}, ...
                                     'TextColor', text_Color,...
                                     'ColNameWidth', 0.23, ...
                                     'FontSize', 13)

    axis on                

SimTools.scripts.pausaGuarda(...
fullfile('plots',...
            MODEL.CORR_DATE, MODEL.CORR_VER,...
            'otras',...
            'Tipo de cambio real (componentes)act_short.png'), ...
'AutoSave', true)
    
% Corrimiento anterior

    figure;
      set( ...
      gcf, ...
      'defaultaxesfontsize',12, ...
      'Position', [1 42.0182 1717.1 906.73]);

    main_p = uipanel('Units','normalized');

    % ----- Panel de grafica -----
    plot_p = uipanel( ...
             main_p, ...
            'Position', [0, 1 - 0.8, 1, 0.8], ...
            'BackgroundColor', [1, 1, 1]);

    ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);

    plot(MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
        [corr_ant.d4_ln_s, corr_ant.d4_ln_ipei,...
          corr_ant.d4_ln_cpi_sub, corr_ant.d4_ln_z],...
          'Marker', 'none', 'MarkerSize', 17,...
          'LineWidth', 2);
    
      ax = gca;
    ax.ColorOrder = colors;

    legend('Tipo de Cambio Nominal', 'Inflación Externa',...
           'Inflación Interna', 'Tipo de Cambio Real',...
           'Location','best', 'Fontsize', 13);

    grid off;

    % Titulo
    title('Tasa de Variación del Tipo de Cambio Real (Porcentajes)',...
          {strcat("Corrimiento ",MODEL.leg_ant),...
          strcat(dat2char(MODEL.DATES.hist_end-20), '-',...
            dat2char(MODEL.DATES.hist_end+20))},...
            'Fontsize', 13);

    % Linea vertical (inicio prediccion)
    vline(params.pred_ant, ...
          'LineWidth', 1.5, ...
          'LineStyle', '-');

     zeroline();

    % ----- Panel de Tabla -----
    table_p = uipanel(main_p, ...
                        'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
                        'BackgroundColor', [1, 1, 1]);

    data_table = [];

            data_table(:, 1) = corr_ant.d4_ln_s(params.tab_range-1);       
            data_table(:, 2) = corr_ant.d4_ln_ipei(params.tab_range-1);
            data_table(:, 3) = corr_ant.d4_ln_cpi_sub(params.tab_range-1);
            data_table(:, 4) = corr_ant.d4_ln_z(params.tab_range-1);

            text_Color = colors;

    SimTools.scripts.plot_data_table(params.tab_range-1, ...
                                     data_table, ...
                                     'Parent', table_p, ...
                                     'SeriesNames', {'Tipo de Cambio Nominal', 'Inflación Externa',...
                                                     'Inflación Interna','Tipo de Cambio Real'}, ...
                                     'TextColor', text_Color,...
                                     'ColNameWidth', 0.23, ...
                                     'FontSize', 13)

    axis on                
      
SimTools.scripts.pausaGuarda(...
fullfile('plots',...
            MODEL.CORR_DATE, MODEL.CORR_VER,...
            'otras',...
            'Tipo de cambio real (componentes)ant_short.png'), ...
'AutoSave', true)



%% Tipo de cambio real subplots
toplot = {'ln_z_sa', 's_sa', 'ln_ipei_q_sa', 'ln_cpi_sub_sa'};

for i = 1:length(toplot)
    
    set(gcf, ...
        'defaultaxesfontsize',12, ...
        'Position', [1 42.0182 1117.1 776.73]);
    
    if i == 1  
    subplot(2,2,i)
    h = plot(MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
             [MODEL.PostProc.l_sa.(toplot{i}),... %corr actual
             post_proc.l_sa.(toplot{i}),... %corr anterior
             MODEL.PostProc.l_sa.(toplot{i})],... % historia
             'Marker', '.',...
             'MarkerSize', 7,...
             'LineWidth', 1.25); 
        
    % Colores
    % historia
    set(h(end), 'color', [0 0 1]);
    % Corr actual
    set(h(1), 'color', [0 0 1]);
    % Corr anterior
    set(h(2), 'color', [1 0 0]);    
    
    %linea vertical
    vline(MODEL.DATES.hist_end, ...
        'LineWidth', 1, ...
        'LineStyle', '-')
    
    %titulos
    title('Tipo de Cambio Real');
    
    % leyenda
    legend({MODEL.leg_act,...
        MODEL.leg_ant},...
        'Location','best', 'Interpreter', 'none',...
        'FontSize', 8);
    
  
    elseif i == 2
    subplot(2,2,i)
    h = plot(MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
             [MODEL.PostProc.niv_sa.(toplot{i}),... %corr actual
             post_proc.niv_sa.(toplot{i}),... %corr anterior
             MODEL.PostProc.niv_sa.(toplot{i})],... % historia
             'Marker', '.',...
             'MarkerSize', 7,...
             'LineWidth', 1.25); 
        
    % Colores
    % historia
    set(h(end), 'color', [0 0 1]);
    % Corr actual
    set(h(1), 'color', [0 0 1]);
    % Corr anterior
    set(h(2), 'color', [1 0 0]);    
    
    %linea vertical
    vline(MODEL.DATES.hist_end, ...
        'LineWidth', 1, ...
        'LineStyle', '-')
    
    %titulos
    title('Tipo de cambio nominal Q/$');
    
    % leyenda
    legend({MODEL.leg_act,...
        MODEL.leg_ant},...
        'Location','best', 'Interpreter', 'none',...
        'FontSize', 8);
    
    elseif i >= 3
        subplot(2,2,i)
    h = plot(MODEL.DATES.hist_end-20:MODEL.DATES.hist_end+20,...
             [MODEL.PostProc.l_sa.(toplot{i}),... %corr actual
             post_proc.l_sa.(toplot{i}),... %corr anterior
             MODEL.PostProc.l_sa.(toplot{i})],... % historia
             'Marker', '.',...
             'MarkerSize', 7,...
             'LineWidth', 1.25); 
        
    % Colores
    % historia
    set(h(end), 'color', [0 0 1]);
    % Corr actual
    set(h(1), 'color', [0 0 1]);
    % Corr anterior
    set(h(2), 'color', [1 0 0]);    
    
    %linea vertical
    vline(MODEL.DATES.hist_end, ...
        'LineWidth', 1, ...
        'LineStyle', '-')
    
    %titulos
    title(MODEL.PostProc.l_sa.(toplot{i}).Comment{1}(1:end-9));
    
    % leyenda
    legend({MODEL.leg_act,...
        MODEL.leg_ant},...
        'Location','best', 'Interpreter', 'none',...
        'FontSize', 8);
    
     sgtitle({'Componentes del Tipo de Cambio Real',...
        strcat(dat2char(MODEL.DATES.hist_end-20), '-',...
            dat2char(MODEL.DATES.hist_end+20))})
    
        if i == 4
           SimTools.scripts.pausaGuarda(fullfile('plots',...
                                        MODEL.CORR_DATE, MODEL.CORR_VER,...
                                        'otras',...
                                        'TC_real_subplot_short.png'), ...
                                        'AutoSave', true)
        end
    end
end
close all;
end