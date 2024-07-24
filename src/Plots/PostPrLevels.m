function PostPrLevels(MODEL, varargin)

%{
% Niveles de la variable vrs mes anterior u otro escenario.
    Genera las gráficas de los niveles desestacionalizados. Pueden compararse,
    o no, con otro escenario o con otro corrimiento.
{
## Syntax ##

    MODEL = simPlots(MODEL, varargin)

## Input Arguments ##

__`MODEL`__ [ struct ] -
Debe contener al menos la estructura con los resultados del proceso de
simulación MODEL.F_pred.

* 'StartDate' = {} [ `Cell` ] - fechas de inicio del plot (pueden ser una o mas).

* 'EndDatePlot' = {} [ `Cell` ] - fechas de fin del plot (pueden ser una o mas).

* 'Esc_add' = {}  [ `Cell` ] - Escenario adicional a plotear. Cell array 
    con dos elementos: (1) Versión o fecha del escenario adicional y (2)
    Base de datos con los pronósticos del modelo (ambas estructuras deben
    tener los mismos campos por compatibilidad.

* 'PlotList' = {} [ `Cell` ] - Lista de variables a plotear. Compatible con
    lista de niveles que entra en función PostProcessing

- DIE
- Marzo 2024
- MJGM/JGOR
%}
p = inputParser;
    addParameter(p, 'StartDate', MODEL.DATES.hist_start);
    addParameter(p, 'EndDatePlot', MODEL.DATES.pred_end);
    addParameter(p, 'SavePath', {});
    addParameter(p, 'Esc_add', {});
    addParameter(p, 'PlotList', {'y'});
    addParameter(p, 'Titles', {});
    addParameter(p, 'LegendsNames', {});
    addParameter(p, 'LegendLocation', 'best');
    addParameter(p, 'PlotSSLine', true);
    addParameter(p, 'PlotAnnotations', true);
    addParameter(p, 'AnnotationXAdjustment', 0);
    addParameter(p, 'AnnotationYAdjustment', 0);
    addParameter(p, 'AnnoRange', qq(2022,4):4:qq(2024,4));
    addParameter(p, 'TabRange', qq(2021,4):4:qq(2024,4));   
    addParameter(p, 'CloseAll', true);    
    addParameter(p, 'AutoSave', true);
parse(p, varargin{:});
params = p.Results;

%% Obteniendo la historia para las gráficas
H = databank.fromCSV(fullfile(pwd, 'data', 'raw', 'hist.csv'));

%% SavePath
if isempty(params.SavePath)
    params.SavePath = fullfile('plots', MODEL.CORR_DATE, params.Esc_add{1}, 'PostProcessing');
end

%% Carga de base de datos adicional
if ~isempty(params.Esc_add)
    PostProcAdd = params.Esc_add{2};
    esc_col = params.Esc_add{3};
end

if isempty(params.Esc_add{3})
    esc_col = [1 0 0];
end

list = params.PlotList;
for rng = 1:length(params.StartDate)
    
    for var = 1:length(list)
        
        
        figure;
        
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1117.1 776.73] ...
            );
        main_p = uipanel('Units','normalized');
        
        % ----- Panel de gráfica -----
        plot_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.9, 1, 0.9], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        
        ax = axes(plot_p, 'Units','normalized' ,'Position', [0.1 0.1 0.85 0.8]);
        
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            MODEL.PostProc.v0.niv_sa.(strcat(list{var},'_sa')),'.-b', ...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        ax = gca;
        ax.YAxis.Exponent = 0;
        hold on
        
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            PostProcAdd.niv_sa.(strcat(list{var},'_sa')),...
            'Color', esc_col,...
            'LineWidth', 1.65, ...
            'LineStyle', '--' ...
            );
        
        
        plot(...
             params.StartDate{rng}:params.EndDatePlot{rng}, ...
             H.(list{var}),...
             'Color', [0 0 0],...
             'LineWidth', 1.65,...
             'LineStyle', '--'...
             );
        
        ax = gca;
        ax.YAxis.Exponent = 0;
        
        hold off
        %Returns handles to the patch and line objects
        chi = get(gca, 'Children');
        %Reverse the stacking order so that the patch overlays the line
        set(gca, 'Children',flipud(chi));
        
        
        
        if ~isempty(params.LegendsNames)
            legend(params.LegendsNames, 'Location', params.LegendLocation);
        end
        
        title( ...
            params.Titles{var}, ...
            sprintf(...
            '%s - %s', ...
            dat2char(params.StartDate{rng}), ...
            dat2char(params.EndDatePlot{rng})...
            ) ,...
            'Interpreter','none'...
            );
        
        highlight(params.StartDate{rng}:MODEL.DATES.hist_end, 'Color=', 0.95);
        
        vline( ...
            MODEL.DATES.hist_end,...
            'LineWidth', 1, ...
            'LineStyle', '-.' ...
            );
        
        if strcmp(list{var}, 's')
            hline(...
                MODEL.PostProc.v0.niv_sa.(strcat(list{var},'_sa')).mean(), ...
                'LineWidth', 1.5, ...
                'LineStyle', ':' ...
                );
            % Anotaciones
            x_lims = get(gca, 'XLim');
            SimTools.scripts.anotaciones_simples(...
                x_lims(1), ...
                MODEL.PostProc.v0.niv_sa.(strcat(list{var},'_sa')).mean(), ...
                sprintf('Promedio Histórico: %0.2f', ...
                MODEL.PostProc.v0.niv_sa.(strcat(list{var},'_sa')).mean()), ...
                'Container', plot_p, ...
                'LineStyle', ':', ...
                'HeadStyle', 'none', ...
                'FontSize', 9 ...
                );
        end
        
        % ----- Panel de Tabla -----
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.9 - 0.10, 1, 0.10], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        
        data_table = [];
            data_table(:, 1) = PostProcAdd.niv_sa.(strcat(list{var},'_sa'))(params.TabRange);
            data_table(:, 2) = MODEL.PostProc.v0.niv_sa.(strcat(list{var},'_sa'))(params.TabRange);
            text_Color = [esc_col ; 0,0,1];
        
        SimTools.scripts.plot_data_table( ...
            params.TabRange, ...
            data_table, ...
            'Parent', table_p, ...
            'SeriesNames', {params.LegendsNames{2}, params.LegendsNames{3}}, ...
            'TextColor', text_Color, ...
            'FontSize', 9 ...
            )
        axis on
        
        if rng == 2
            save_name = sprintf("%s_short.png", list{var});
        else
            save_name = sprintf("%s.png", list{var});
        end
        
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath, ...
            save_name), ...
            'AutoSave', params.AutoSave ...
            );
    end
    if params.CloseAll
        close all
    end
end



end