function tc_real(MODEL, varargin)
%{
    Genera las graficas relacionadas al tipo de cambio real
        Tipo de cambio real por componentes (corrimiento actual)
    
    tab_range: Rango trimestres que se utilizarán en la tabla
    pred_ant: Trimestre de inicio de predicción del periodo anterior.
%}

p = inputParser;
addParameter(p, 'StartDate', {MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20});
addParameter(p, 'EndDatePlot', {MODEL.DATES.pred_end});
addParameter(p, 'SavePath', {});
addParameter(p, 'Esc_add', {}); % libre v0, alterno v1, contrafactual v2
addParameter(p, 'tab_range', {});
addParameter(p, 'TabRange', qq(2021,4):4:qq(2024,4));
addParameter(p, 'LegendsNames', {});

parse(p, varargin{:});
params = p.Results;

%% Limpieza y creación de folders
% Verificación y creación del directorio para las gráficas
if isempty(params.SavePath)
    params.SavePath = fullfile('plots', MODEL.CORR_DATE, params.Esc_add{1}, 'otras');
end

if ~isfolder(params.SavePath)
    mkdir(params.SavePath)
else
    rmdir(params.SavePath, 's')
    mkdir(params.SavePath)
end   

%% Carga de base de datos mes anterior
full_data_add = params.Esc_add{2};

% leyendas
if strcmp(params.Esc_add{1}, 'v0')
    params.LegendsNames = {MODEL.leg_act, MODEL.leg_ant};
end
%% Tipo de cambio real por componentes

% Corrimiento actual
colors = [[0 0 0]; [0 0.498 0]; [0.4940 0.1840 0.5560]; [0.667 0 0]];

for rng = params.StartDate
    
        
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
    
    plot(rng{1}:params.EndDatePlot{1},...
        [MODEL.F_pred.d4_ln_z, MODEL.F_pred.d4_ln_ipei,...
        MODEL.F_pred.d4_ln_s, MODEL.F_pred.d4_ln_cpi_sub],...
        'Marker', 'none', 'MarkerSize', 17,...
        'LineWidth', 2);
    
    ax = gca;
    ax.ColorOrder = colors;
    
    legend('Tipo de Cambio Real', 'Inflación Externa',...
        'Tipo de Cambio Nominal', 'Inflación Interna',...
        'Location','best', 'Fontsize', 13);
    
    grid off;
    
    % Titulo
    title('Tasa de Variación del Tipo de Cambio Real (Porcentajes)',...
        {strcat("Corrimiento ", MODEL.leg_act),...
        strcat(dat2char(rng{1}), '-',...
        dat2char(params.EndDatePlot{1}))},...
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
    
    data_table(:, 1) = MODEL.F_pred.d4_ln_z(params.tab_range);
    data_table(:, 2) = MODEL.F_pred.d4_ln_ipei(params.tab_range);
    data_table(:, 3) = MODEL.F_pred.d4_ln_s(params.tab_range);
    data_table(:, 4) = MODEL.F_pred.d4_ln_cpi_sub(params.tab_range);
    
    text_Color = colors;
    
    SimTools.scripts.plot_data_table(params.tab_range, ...
        data_table, ...
        'Parent', table_p, ...
        'SeriesNames', {'Tipo de Cambio Real', 'Inflación Externa',...
        'Tipo de Cambio Nominal','Inflación Interna'}, ...
        'TextColor', text_Color,...
        'ColNameWidth', 0.23, ...
        'FontSize', 13);
    
    axis on;
    
    % Guardamos la gráfica
    if rng{1} == params.StartDate{1}
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'Tipo de cambio real (componentes)act.png'), ...
            'AutoSave', true);
        
    elseif rng{1} == params.StartDate{2}
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath,....
            'Tipo de cambio real (componentes)act_short.png'), ...
            'AutoSave', true);
        
    end
    
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
    
    plot(rng{1}:params.EndDatePlot{1},...
        [full_data_add.d4_ln_z, full_data_add.d4_ln_ipei,...
        full_data_add.d4_ln_s, full_data_add.d4_ln_cpi_sub],...
        'Marker', 'none', 'MarkerSize', 17,...
        'LineWidth', 2);
    
    ax = gca;
    ax.ColorOrder = colors;
    
    legend('Tipo de Cambio Real', 'Inflación Externa',...
        'Tipo de Cambio Nominal', 'Inflación Interna',...
        'Location','best', 'Fontsize', 13);
    
    grid off;
    
    % Titulo
    if strcmp(params.Esc_add{1}, 'v0')
    title('Tasa de Variación del Tipo de Cambio Real (Porcentajes)',...
        {strcat("Corrimiento ",MODEL.leg_ant),...
        strcat(dat2char(rng{1}), '-',...
        dat2char(params.EndDatePlot{1}))},...
        'Fontsize', 13);
    
    else
    title('Tasa de Variación del Tipo de Cambio Real (Porcentajes)',...
        {strcat("Comparativo ", params.LegendsNames{2}, "-", params.LegendsNames{1}),...
        strcat(dat2char(rng{1}), '-',...
        dat2char(params.EndDatePlot{1}))},...
        'Fontsize', 13);
    end
       
    zeroline();
    
    % ----- Panel de Tabla -----
    table_p = uipanel(main_p, ...
        'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
        'BackgroundColor', [1, 1, 1]);
    
    data_table = [];
    
    data_table(:, 1) = full_data_add.d4_ln_z(params.tab_range-1);
    data_table(:, 2) = full_data_add.d4_ln_ipei(params.tab_range-1);
    data_table(:, 3) = full_data_add.d4_ln_s(params.tab_range-1);
    data_table(:, 4) = full_data_add.d4_ln_cpi_sub(params.tab_range-1);
    
    text_Color = colors;
    
    SimTools.scripts.plot_data_table(params.tab_range-1, ...
        data_table, ...
        'Parent', table_p, ...
        'SeriesNames', {'Tipo de Cambio Real', 'Inflación Externa',...
        'Tipo de Cambio Nominal','Inflación Interna'}, ...
        'TextColor', text_Color,...
        'ColNameWidth', 0.23, ...
        'FontSize', 13);
    
    axis on;
    
    % Guardamos la gráfica
    if rng{1} == params.StartDate{1}
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'Tipo de cambio real (componentes)ant.png'), ...
            'AutoSave', true);
        
    elseif rng{1} == params.StartDate{2}
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'Tipo de cambio real (componentes)ant_short.png'), ...
            'AutoSave', true);
        
    end
end

close all;
end
