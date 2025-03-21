function PreProcPlots(MODEL, varargin)
%{
Graficas con los datos fuente
    - Producto externo
    - Producto doméstico
    - Tasa de interes de fondos federales
    - Indices y tasas de variacion de precios de importaciones y
    exportaciones
    - Evolucion del ponderador alpha

Departamento de Investigaciones Económicas - 2024.
MJGM/JGOR
%}
p = inputParser;
addParameter(p, 'StartDate', {MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20});
addParameter(p, 'EndDatePlot', {MODEL.DATES.hist_end});
addParameter(p, 'SavePath', {});
addParameter(p, 'Esc_add', {}); % libre v0, alterno v1, contrafactual v2
addParameter(p, 'tab_range', {});
addParameter(p, 'tab_range_mm', {});
addParameter(p, 'TabRange', qq(2021,4):4:qq(2024,4));

parse(p, varargin{:});
params = p.Results;

%% Limpieza y creación de folders
% Verificación y creación del directorio para las gráficas
if isempty(params.SavePath)
    params.SavePath = fullfile('plots', MODEL.CORR_DATE, params.Esc_add{1}, 'PreProcessing');
end

if ~isfolder(params.SavePath)
    mkdir(params.SavePath)
else
    rmdir(params.SavePath, 's')
    mkdir(params.SavePath)
end   

%% Carga de base de datos mes anterior
full_data_add = params.Esc_add{2};

%% configuracion general
% Historia
params.StartDate_mm = {MODEL.DATES.hist_start_mm, MODEL.DATES.hist_end_mm-60};
params.EndDatePlot_mm = {MODEL.DATES.hist_end_mm};

% Leyendas
params.LegendsNames = {MODEL.leg_act, MODEL.leg_ant};

%% Producto y tasa de fondos federales
toplot = {'y_star_qq', 'y_qq','i_star_mm'};
% Nombres de variables y definición de estado estacionario para i_star
MODEL.PreProc.quarterly.y_star_qq.Comment = 'Producto de Estados Unidos';
pre_proc.quarterly.y_star_qq.Comment = sprintf('Producto EEUU corr-%s', MODEL.CORR_DATE_ANT);
MODEL.PreProc.quarterly.y_qq.Comment = 'Producto Real de Guatemala';
pre_proc.quarterly.y_qq.Comment = sprintf('Producto GT corr-%s', MODEL.CORR_DATE_ANT);
i_star_ss = get(MODEL.M, 'Sstatelevel')*'i_star';

colors = [[1 0 0]; [0 0 1]];

for rng = 1:length(params.StartDate)
    for i = 1:length(toplot)
        
        figure;
        set( ...
            gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1417.1 976.73] ...
            );
        
        main_p = uipanel('Units','normalized');
        
        % ----- Panel de gráfica -----
        plot_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.8, 1, 0.8], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        
        ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);
        
        % panel
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
            'BackgroundColor', [1, 1, 1]);
        
        if strcmp(toplot{i}, 'y_star_qq') || strcmp(toplot{i}, 'y_qq')
            
            data_table = [];
            data_table(:, 1) = full_data_add.PreProc.quarterly.(toplot{i})(params.tab_range);
            data_table(:, 2) = MODEL.PreProc.quarterly.(toplot{i})(params.tab_range);
            text_Color = colors;
            
            
            Sim.scripts.plot_data_table( ...
                params.tab_range, ...
                data_table, ...
                'Parent', table_p, ...
                'SeriesNames', {MODEL.leg_ant....
                MODEL.leg_act},...
                'TextColor', text_Color, ...
                'ColNameWidth', 0.23, ...
                'FontSize', 11 ...
                );
            
            axis on;
            
            plt = plot(params.StartDate{rng}:params.EndDatePlot{1},...
                [MODEL.PreProc.quarterly.(toplot{i}),...
                full_data_add.PreProc.quarterly.(toplot{i})],...
                'Marker', '.', ...
                'MarkerSize', 17, ...
                'LineWidth', 1.25);
           
            legend(params.LegendsNames,...
                'Location', 'Best');
            
            % Colors
            % corr actual
            set(plt(1), 'color', [0 0 1]);
            % corr ant
            set(plt(2), 'color', [1 0 0]);
            
            ax = gca;
            ax.YAxis.Exponent = 0;
            
            if strcmp(toplot{i}, 'y_star_qq')
                ytickformat('usd');
                ylabel('Miles de millones');
            else
                ytickformat('Q%.0f')
                ylabel('Millones');
            end
            
            %Titulos
            title(MODEL.PreProc.quarterly.(toplot{i}).Comment{1},...
                strcat(dat2char(params.StartDate{rng}),...
                '-',dat2char(params.EndDatePlot{1})));
            
            if rng == 1
                Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                    sprintf("%s.png",MODEL.PreProc.quarterly.(toplot{i}).Comment{1})),...
                    'AutoSave', true);
            else
                Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                    sprintf("%s_short.png",MODEL.PreProc.quarterly.(toplot{i}).Comment{1})),...
                    'AutoSave', true);
            end
            
            
        else
            
            data_table = [];
            data_table(:, 1) = full_data_add.PreProc.monthly.(toplot{i})(params.tab_range_mm);
            data_table(:, 2) = MODEL.PreProc.monthly.(toplot{i})(params.tab_range_mm);
            
            
            text_Color = colors;
            
            
            Sim.scripts.plot_data_table( ...
                params.tab_range_mm, ...
                data_table, ...
                'Parent', table_p, ...
                'SeriesNames', {MODEL.leg_ant,...
                MODEL.leg_act}, ...
                'TextColor', text_Color, ...
                'ColNameWidth', 0.23, ...
                'FontSize', 11 ...
                );
            
            axis on;
            
            plt = plot(params.StartDate_mm{rng}:params.EndDatePlot_mm{1},...
                [MODEL.PreProc.monthly.(toplot{i}),...
                full_data_add.PreProc.monthly.(toplot{i})],...
                'Marker', '.', ...
                'MarkerSize', 17, ...
                'LineWidth', 1.25, ...
                'color', [0,0,1]);
            
            legend(params.LegendsNames,...
                'Location', 'Best');
            
            % Colors
            % corr actual
            set(plt(1), 'color', [0 0 1]);
            % corr ant
            set(plt(2), 'color', [1 0 0]);
            
            %Titulos
            title('Tasa de interés de Fondos Federales',...
                strcat(dat2char(params.StartDate{rng}),...
                '-',dat2char(params.EndDatePlot{1})));
            
            if strcmp(toplot{i}, 'i_star_mm')
                a = hline(i_star_ss.i_star);
                set(a,'LineStyle','--','Color','k','LineWidth',1.5);
                
                
                text(35,i_star_ss.i_star+0.5,['Estado Estacionario: ',num2str(i_star_ss.i_star,'%4.2f')],'FontSize',9,'Color','k');
            end
            
            if rng == 1
                Sim.scripts.pausaGuarda(fullfile(params.SavePath,'Tasa de fondos federales.png'),...
                    'AutoSave', true);
                
            else
                Sim.scripts.pausaGuarda(fullfile(params.SavePath,'Tasa de fondos federales_short.png'),...
                    'AutoSave', true);
            end
        end
    end
end

%% Precio de importaciones y exportaciones
% variables a graficar
toplot = {'imp_indx_mm', 'imp_dl_mm', 'imp_indx_dl12_mm', 'exp_indx_mm', 'exp_dl_mm', 'exp_indx_dl12_mm'};

for rng = params.StartDate_mm
    for i = 1:length(toplot)
        figure;
        set( ...
            gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1117.1 776.73]);
        
        main_p = uipanel('Units','normalized');
        
        % ----- Panel de gra¡fica -----
        plot_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.8, 1, 0.8], ...
            'BackgroundColor', [1, 1, 1]);
        
        ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);
        
        % panel
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
            'BackgroundColor', [1, 1, 1]);
        
        data_table = [];
        data_table(:, 1) = full_data_add.PreProc.monthly.(toplot{i})(params.tab_range_mm);
        data_table(:, 2) = MODEL.PreProc.monthly.(toplot{i})(params.tab_range_mm);
        
        text_Color = colors;
        
        Sim.scripts.plot_data_table( ...
            params.tab_range_mm, ...
            data_table, ...
            'Parent', table_p, ...
            'SeriesNames', {MODEL.leg_ant,...
            MODEL.leg_act},...
            'TextColor', text_Color, ...
            'ColNameWidth', 0.23, ...
            'FontSize', 10);
        
        axis on;
        
        plt = plot(rng{1}:params.EndDatePlot_mm{1},...
            [MODEL.PreProc.monthly.(toplot{i}),...
            full_data_add.PreProc.monthly.(toplot{i})], ...
            'Marker', '.', ...
            'MarkerSize', 17, ...
            'LineWidth', 1.25);
        
        hold on
        
        if ~isempty(strmatch(toplot{i}, {'imp_dl_mm', 'imp_indx_dl12_mm',...
                'exp_indx_dl12_mm', 'exp_dl_mm'}, 'exact'))
             zeroline();
        end
        
        
        legend({MODEL.leg_act, MODEL.leg_ant},...
            'Location', 'Best');
        
        % Colors
        % corr actual
        set(plt(1), 'color', [0 0 1]);
        % corr ant
        set(plt(2), 'color', [1 0 0]);
        
        %Titulos
        if rng{1} == params.StartDate_mm{1}
            title(MODEL.PreProc.monthly.(toplot{i}).Comment{1},...
                strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot_mm{1})));
            
        elseif rng{1} == params.StartDate_mm{2}
            title(MODEL.PreProc.monthly.(toplot{i}).Comment{1},...
                strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot_mm{1})));
        end
        
        if rng{1} == params.StartDate_mm{1}
            Sim.scripts.pausaGuarda(...
                fullfile(params.SavePath,...
                sprintf("%s.png",MODEL.PreProc.monthly.(toplot{i}).Comment{1})), ...
                'AutoSave', true);
            
        elseif rng{1} == params.StartDate_mm{2}
            Sim.scripts.pausaGuarda(...
                fullfile(params.SavePath,...
                sprintf("%s_short.png",MODEL.PreProc.monthly.(toplot{i}).Comment{1})), ...
                'AutoSave', true);
        end
    end
end

%% Exportaciones e importaciones (juntos)

for rng = params.StartDate_mm
    
    set(gcf, ...
        'defaultaxesfontsize',12, ...
        'Position', [1 42.0182 1117.1 776.73]);
    
    
    main_p = uipanel('Units','normalized');
    
    % ----- Panel de gráfica -----
    plot_p = uipanel(main_p, ...
        'Position', [0, 1 - 0.8, 1, 0.8], ...
        'BackgroundColor', [1, 1, 1]);
    
    ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);
    
    
    % panel
    table_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
        'BackgroundColor', [1, 1, 1] ...
        );
    
    data_table = [];
    data_table(:, 1) = MODEL.PreProc.monthly.imp_indx_mm(params.tab_range_mm);
    data_table(:, 2) = MODEL.PreProc.monthly.exp_indx_mm(params.tab_range_mm);
    
    text_Color = [[0 0 0]; [0 0.498 0]];
    
    
    Sim.scripts.plot_data_table( ...
        params.tab_range_mm, ...
        data_table, ...
        'Parent', table_p, ...
        'SeriesNames', {'Índice de Precios de Importaciones',...
        'Índice de Precios de Exportaciones'}, ...
        'TextColor', text_Color, ...
        'ColNameWidth', 0.23, ...
        'FontSize', 11 ...
        );
    
    axis on;
    
    plt = plot(rng{1}:params.EndDatePlot_mm{1},...
        [MODEL.PreProc.monthly.imp_indx_mm, MODEL.PreProc.monthly.exp_indx_mm], ...
        'LineWidth', 1.25 ...
        );
    
    % Colores
    % importaciones
    set(plt(1), 'color', [0 0 0], 'LineWidth', 1.25, 'Marker', '.', 'MarkerSize', 12);
    % exportaciones
    set(plt(2), 'color', [0 0.498 0],'LineWidth', 1.25, 'Marker', '.', 'MarkerSize', 12);
    
    % leyenda
    legend({'Índice de Precios de importaciones',...
        'Índice de Precios de exportaciones'}, 'Location','best');
    
    %Titulos
    title('Índices de precios',...
        {'Importaciones y exportaciones EEUU',...
        strcat(dat2char(rng{1}),...
        '-',dat2char(params.EndDatePlot_mm{1}))},...
        'FontSiz', 10);
    
    %Guardamos la gráfica
    if rng{1} == params.StartDate_mm{1}
        
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            sprintf("%s.png",'imp_exp_indx')), ...
            'AutoSave', true);
        
    elseif rng{1} == params.StartDate_mm{2}
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            sprintf("%s_short.png",'imp_exp_indx')), ...
            'AutoSave', true);
        
    end
end

%% tasas de varaicón interanual de importaciones y exportaciones (juntos)

for rng = params.StartDate_mm
    figure;
    set(gcf, ...
        'defaultaxesfontsize',12, ...
        'Position', [1 42.0182 1117.1 776.73]);
    
    
    main_p = uipanel('Units','normalized');
    
    % ----- Panel de gráfica -----
    plot_p = uipanel(main_p, ...
        'Position', [0, 1 - 0.8, 1, 0.8], ...
        'BackgroundColor', [1, 1, 1]);
    
    ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);
    
    % panel
    table_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
        'BackgroundColor', [1, 1, 1] ...
        );
    
    data_table = [];
    data_table(:, 1) = MODEL.PreProc.monthly.imp_indx_dl12_mm (params.tab_range_mm);
    data_table(:, 2) = MODEL.PreProc.monthly.exp_indx_dl12_mm(params.tab_range_mm);
    text_Color = [[0 0 0]; [0 0.498 0]];
    
    
    Sim.scripts.plot_data_table( ...
        params.tab_range_mm, ...
        data_table, ...
        'Parent', table_p, ...
        'SeriesNames', {'Precios de Importaciones', 'Precios de Exportaciones'}, ...
        'TextColor', text_Color, ...
        'ColNameWidth', 0.23, ...
        'FontSize', 11 ...
        );
    
    plt = plot(rng{1}:params.EndDatePlot_mm{1},...
        [MODEL.PreProc.monthly.imp_indx_dl12_mm, MODEL.PreProc.monthly.exp_indx_dl12_mm], ...
        'LineWidth', 1.25 ...
        );
    
    zeroline();
    
    
    % Colores
    % importaciones
    set(plt(1), 'color', [0 0 0], 'LineWidth', 1.25, 'Marker', '.', 'MarkerSize', 12);
    % exportaciones
    set(plt(2), 'color', [0 0.498 0],'LineWidth', 1.25, 'Marker', '.', 'MarkerSize', 12);
    
    % leyenda
    legend({'Precios de importaciones', 'Precios de exportaciones'}, 'Location','best');
    
    %Titulos
    title('Tasas de variación interanual',...
        {'Precios de Importaciones y Exportaciones EEUU',...
        strcat(dat2char(rng{1}),...
        '-',dat2char(params.EndDatePlot_mm{1}))},...
        'FontSiz', 10);
    
    
    axis on;
    
    % Guardamos la gráfica
    if rng{1} == params.StartDate_mm{1}
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'imp_exp_d12.png'), ...
            'AutoSave', true);
        
    elseif rng{1} == params.StartDate_mm{2}
        
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'imp_exp_d12_short.png'), ...
            'AutoSave', true);
    end
    
end

%% tasas de varaicón intermensual anualizada de importaciones y exportaciones (juntos)
for rng = params.StartDate_mm
    figure;
    set( ...
        gcf, ...
        'defaultaxesfontsize',12, ...
        'Position', [1 42.0182 1117.1 776.73] ...
        );
    
    
    main_p = uipanel('Units','normalized');
    
    % ----- Panel de gráfica -----
    plot_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.8, 1, 0.8], ...
        'BackgroundColor', [1, 1, 1] ...
        );
    
    ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);
    
    % panel
    table_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
        'BackgroundColor', [1, 1, 1] ...
        );
    
    data_table = [];
    data_table(:, 1) = MODEL.PreProc.monthly.imp_dl_mm(params.tab_range_mm);
    data_table(:, 2) = MODEL.PreProc.monthly.exp_dl_mm(params.tab_range_mm);
    text_Color = [[0 0 0]; [0 0.498 0]];
    
    
    Sim.scripts.plot_data_table( ...
        params.tab_range_mm, ...
        data_table, ...
        'Parent', table_p, ...
        'SeriesNames', {'Precios de Importaciones', 'Precios de Exportaciones'}, ...
        'TextColor', text_Color, ...
        'ColNameWidth', 0.23, ...
        'FontSize', 11 ...
        );
    
    plt = plot(rng{1}:params.EndDatePlot_mm{1},...
        [MODEL.PreProc.monthly.imp_dl_mm, MODEL.PreProc.monthly.exp_dl_mm], ...
        'LineWidth', 1.25);
    
    zeroline();
    
    
    % Colores
    % importaciones
    set(plt(1), 'color', [0 0 0], 'LineWidth', 1.25, 'Marker', '.', 'MarkerSize', 12);
    % exportaciones
    set(plt(2), 'color', [0 0.498 0],'LineWidth', 1.25, 'Marker', '.', 'MarkerSize', 12);
    
    % leyenda
    legend({'Precios de importaciones', 'Precios de exportaciones'}, 'Location','best');
    
    %Titulos
    title('Tasas de variación interanual anualizada',...
        {'Precios de Importaciones y Exportaciones EEUU',...
        strcat(dat2char(rng{1}),...
        '-',dat2char(params.EndDatePlot_mm{1}))},...
        'FontSiz', 10);
    
    
    axis on;
    
    % Guardamos la gráfica
    if rng{1} == params.StartDate_mm{1}
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'imp_exp_dl.png'), ...
            'AutoSave', true);
        
    elseif rng{1} == params.StartDate_mm{2}
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'imp_exp_dl_short.png'), ...
            'AutoSave', true);
        
    end
end

%% Evolución alpha
for rng = params.StartDate_mm    

    set( ...
        gcf, ...
        'defaultaxesfontsize',12, ...
        'Position', [1 42.0182 1117.1 776.73] ...
        );
    
    
    main_p = uipanel('Units','normalized');
    
    % ----- Panel de gráfica -----
    plot_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.8, 1, 0.8], ...
        'BackgroundColor', [1, 1, 1] ...
        );
    
    ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);
    
    
    plt = plot(rng{1}:params.EndDatePlot_mm{1},...
        [MODEL.PreProc.monthly.a_mm, MODEL.PreProc.monthly.a_prom_mm], ...
        'LineWidth', 1.25);
    
    % Colores
    % mes con mes
    set(plt(1), 'color', [0 0 0], 'LineWidth', 1.25);
    % promedio movil 12 meses
    set(plt(2), 'color', [0 0.498 0],'LineWidth', 1.25, 'Marker', '.', 'MarkerSize', 12);
    
    % leyenda
    legend({'Evolución mensual', 'Promedio Movil (12 meses)'}, 'Location','best');
    
    %Titulos
    title('Importancia de EEUU en importaciones de GT',...
        strcat(dat2char(rng{1}),...
        '-',dat2char(params.EndDatePlot_mm{1})));
    
    % panel
    table_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
        'BackgroundColor', [1, 1, 1] ...
        );
    
    data_table = [];
    data_table(:, 1) = MODEL.PreProc.monthly.a_mm(params.tab_range_mm);
    data_table(:, 2) = MODEL.PreProc.monthly.a_prom_mm(params.tab_range_mm);
    text_Color = [[0 0 0]; [0 0.498 0]];
    
    
    Sim.scripts.plot_data_table( ...
        params.tab_range_mm, ...
        data_table, ...
        'Parent', table_p, ...
        'SeriesNames', {'Evolución mensual', 'Promedio Movil 12 meses'}, ...
        'TextColor', text_Color, ...
        'ColNameWidth', 0.23, ...
        'FontSize', 11 ...
        );
    
    axis on;
    
    % Guardamos la gráfica
    if rng{1} == params.StartDate_mm{1}
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'alpha.png'), ...
            'AutoSave', true);
        
    elseif rng{1} == params.StartDate_mm{2}
        Sim.scripts.pausaGuarda(...
            fullfile(params.SavePath,...
            'alpha_short.png'), ...
            'AutoSave', true);
    end
    
end

%% Inflaciones
toplot = {'cpi_mm', 'cpi_sub_mm', 'cpi_nosub_mm'};
a = {-1, -12};

for rng = params.StartDate_mm
    for i = a
        for j = 1:length(toplot)
            set( ...
                gcf, ...
                'defaultaxesfontsize',12, ...
                'Position', [1 42.0182 1117.1 776.73] ...
                );


                main_p = uipanel('Units','normalized');

                % ----- Panel de gráfica -----
                plot_p = uipanel( ...
                    main_p, ...
                    'Position', [0, 1 - 0.8, 1, 0.8], ...
                    'BackgroundColor', [1, 1, 1] ...
                    );

                ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);

                if j <= 2
                plot(rng{1}:params.EndDatePlot_mm{1},...
                    [MODEL.PreProc.monthly.(toplot{j}).pct(i{1}), full_data_add.PreProc.monthly.(toplot{j}).pct(i{1})], ...
                    'Marker', '.',...
                    'MarkerSize', 9,...
                    'LineWidth', 1.25);
                
                hold on
                s = hline(4);
                    set(s,'LineStyle','--','Color','k','LineWidth',1.5);
                hold off
                
                elseif j == 3
                plot(rng{1}:params.EndDatePlot_mm{1},...
                    [MODEL.PreProc.monthly.cpi_mm.pct(i{1}) - MODEL.PreProc.monthly.cpi_sub_mm.pct(i{1}),...
                    full_data_add.PreProc.monthly.cpi_mm.pct(i{1}) - full_data_add.PreProc.monthly.cpi_sub_mm.pct(i{1})],...
                    'Marker', '.',...
                    'MarkerSize', 9,...
                    'LineWidth', 1.25);
                
                hold on
                zeroline();
                hold off
                
                end

                % Colores
                colororder([[0 0 1]; [1 0 0]])

                % leyenda
                legend(params.LegendsNames, 'Location','best');

                %Titulos
                if i{1} == -1 && ~strcmp(toplot{j}, 'cpi_nosub_mm')
                title(MODEL.PreProc.monthly.(toplot{j}).Comment{1}, 'Variación Intermensual');
                
                elseif i{1} == -12 && ~strcmp(toplot{j}, 'cpi_nosub_mm')
                title(MODEL.PreProc.monthly.(toplot{j}).Comment{1}, 'Variación Interanual');
                
                elseif i{1} == -1 && strcmp(toplot{j}, 'cpi_nosub_mm')
                title('Inflación no subyacente', 'Variación Intermensual');    
                    
                elseif i{1} == -12 && strcmp(toplot{j}, 'cpi_nosub_mm')
                title('Inflación no subyacente', 'Variación Interanual');
                    
                end
                
                if ~strcmp(toplot{j}, 'cpi_nosub_mm')
                temp_act = MODEL.PreProc.monthly.(toplot{j}).pct(i{1});
                temp_ant = full_data_add.PreProc.monthly.(toplot{j}).pct(i{1});
                
                elseif strcmp(toplot{j}, 'cpi_nosub_mm')
                temp_act = MODEL.PreProc.monthly.cpi_mm.pct(i{1}) - MODEL.PreProc.monthly.cpi_sub_mm.pct(i{1});
                temp_ant = full_data_add.PreProc.monthly.cpi_mm.pct(i{1}) - full_data_add.PreProc.monthly.cpi_sub_mm.pct(i{1});
                
                end
                
                % panel
                table_p = uipanel( ...
                    main_p, ...
                    'Position', [0, 1 - 0.8 - 0.20, 1, 0.20], ...
                    'BackgroundColor', [1, 1, 1] ...
                    );

                data_table = [];
                data_table(:, 1) = temp_act(params.tab_range_mm);
                data_table(:, 2) = temp_ant(params.tab_range_mm);
                text_Color = [[0 0 1]; [1 0 0]];

                Sim.scripts.plot_data_table( ...
                    params.tab_range_mm, ...
                    data_table, ...
                    'Parent', table_p, ...
                    'SeriesNames', {MODEL.leg_act, MODEL.leg_ant}, ...
                    'TextColor', text_Color, ...
                    'ColNameWidth', 0.23, ...
                    'FontSize', 11 ...
                    );

                axis on;   
            
                
                %save
                if rng{1} == params.StartDate_mm{1} && ~strcmp(toplot{j}, 'cpi_nosub_mm')
                      Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                                sprintf("%s%s.png",  MODEL.PreProc.monthly.(toplot{j}).Comment{1}, string(i{1}))), ...
                                'AutoSave', true);
                
                elseif rng{1} == params.StartDate_mm{2} && ~strcmp(toplot{j}, 'cpi_nosub_mm')
                      Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                                sprintf("%s%s_short.png", MODEL.PreProc.monthly.(toplot{j}).Comment{1},  string(i{1}))), ...
                                'AutoSave', true);
                            
                elseif rng{1} == params.StartDate_mm{1} && strcmp(toplot{j}, 'cpi_nosub_mm')
                      Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                                sprintf("%s%s.png", 'Inflación no subyacente',  string(i{1}))), ...
                                'AutoSave', true); 
                    
                elseif rng{1} == params.StartDate_mm{2} && strcmp(toplot{j}, 'cpi_nosub_mm')
                      Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                                sprintf("%s%s_short.png", 'Inflación no subyacente',  string(i{1}))), ...
                                'AutoSave', true);
                            
                end
            
            
        end
    end
end


        


close all;

end