function simPlots(MODEL, varargin)
%{
    Genera las gráficas de las variables que son parte del Modelo. Pueden
    compararse, o no, con otro escenario o con otro corrimiento.
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

- DIE
- Marzo 2024
- MJGM/JGOR
%}
p = inputParser;
    addParameter(p, 'StartDate', MODEL.DATES.hist_start);
    addParameter(p, 'EndDatePlot', MODEL.DATES.pred_end);
    addParameter(p, 'SavePath', {});
    addParameter(p, 'Esc_add', {});
    addParameter(p, 'PlotList', get(MODEL.MF, 'xlist'));
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
    
%% Limpieza y creación de folders
SS = get(MODEL.M, 'sstate');

%SavePath
if  strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
    params.SavePath = fullfile('plots', MODEL.CORR_DATE, 'v0', 'prediction_compared');
else
    params.SavePath = fullfile('plots', MODEL.CORR_DATE, params.Esc_add{1}, 'prediction_compared');
end

% Verificación y creación del directorio para las gráficas
if ~isfolder(params.SavePath)
    mkdir(params.SavePath)
else
    rmdir(params.SavePath, 's')
    mkdir(params.SavePath)
end    
    
%% Carga de base de datos adicional

if ~isempty(params.Esc_add)
    full_data_add = params.Esc_add{2}; 
end

%% Bloque 1: Variables del modelo (xlist) (libre vs otro)
list = params.PlotList;
% Iteración para los rangos de ploteo
for rng = 1 : length(params.StartDate)
    % Recorte de base da datos para cada plot
    if ~isempty(params.EndDatePlot{rng})
        full_data_add_temp = dbclip(full_data_add, params.StartDate{rng}:params.EndDatePlot{rng});
        F_pred_temp = dbclip(MODEL.F_pred, params.StartDate{rng}:params.EndDatePlot{rng});
    end
    
    % Iteración a traves de las variables
    for var = 1 : length(list)
        
        %%
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
            F_pred_temp.(list{var}),'.-b', ...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        
        if ~isempty(params.Esc_add) 
            hold on
            
            plot(...
                params.StartDate{rng}:params.EndDatePlot{rng}, ...
                full_data_add_temp.(list{var}),'.-r', ...'MarkerSize', 15, ...
                'LineWidth', 1.65, ...
                'LineStyle', '--' ...
                );
            hold off
            %Returns handles to the patch and line objects
            chi = get(gca, 'Children');
            %Reverse the stacking order so that the patch overlays the line
            set(gca, 'Children',flipud(chi));
            
            if ~isempty(params.LegendsNames)
                legend(params.LegendsNames, 'Location', params.LegendLocation);
            end
            
        end
        
        if isempty(F_pred_temp.(list{var}).comment)
            temp_title = {};
        else
            temp_title = F_pred_temp.(list{var}).comment{1};
        end
        
        title( ...
            sprintf(...
            '%s \n %s - %s', ...
            temp_title, ...
            dat2char(params.StartDate{rng}), ...
            dat2char(params.EndDatePlot{rng})...
            ) ,...
            'Interpreter','none'...
            );
        
        highlight(params.StartDate{rng}:MODEL.DATES.hist_end);
        
        vline( ...
            MODEL.DATES.hist_end,...
            'LineWidth', 1, ...
            'LineStyle', '-.' ...
            );
        
        zeroline();
        
        if startsWith(list{var}, 'd4_') || startsWith(list{var}, 'dla_') ||...
                strcmp(list{var},'i') || strcmp(list{var},'r') || strcmp(list{var},'i_star') ...
                && params.PlotSSLine
            
            hline(...
                real(SS.(list{var})), ...
                'LineWidth', 1.5, ...
                'LineStyle', ':' ...
                );
            % Anotación
            x_lims = get(gca, 'XLim');
            SimTools.scripts.anotaciones_simples(...
                x_lims(1), ...
                real(SS.(list{var})), ...
                sprintf('Estado Estacionario: %0.2f', real(SS.(list{var}))), ...
                'Container', plot_p, ...
                'LineStyle', ':', ...
                'HeadStyle', 'none', ...
                'FontSize', 7 ...
                );
        end
        
        if startsWith(list{var}, 'd4_') || startsWith(list{var}, 'dla_') ||...
                strcmp(list{var},'i') || strcmp(list{var},'r') || strcmp(list{var},'i_star') ...
                && params.PlotSSLine && params.PlotAnnotations
            % Anotaciones para corrimiento actual
            SimTools.scripts.die_anotaciones( ...
                dat2dec(params.AnnoRange)', ...
                F_pred_temp.((list{var}))(params.AnnoRange), ...
                string(num2str(F_pred_temp.(list{var})(params.AnnoRange), '%0.2f')), ...
                'Container', plot_p, ...
                'Color', 'b', ...
                'XAdjustment', params.AnnotationXAdjustment, ...
                'YAdjustment', params.AnnotationYAdjustment ...
                );
            
            % Anotaciones para corrimiento anterior si es que se grafica
            if ~isempty(params.Esc_add)
                SimTools.scripts.die_anotaciones( ...
                    dat2dec(params.AnnoRange)', ...
                    full_data_add_temp.((list{var}))(params.AnnoRange), ...
                    string(num2str(full_data_add_temp.((list{var}))(params.AnnoRange), '%0.2f')), ...
                    'Container', plot_p, ...
                    'Color', 'r', ...
                    'IsAnt', true, ...
                    'XAdjustment', params.AnnotationXAdjustment, ...
                    'YAdjustment', params.AnnotationYAdjustment ...
                    )
            end
        end
        
        % ----- Panel de Tabla -----
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.9 - 0.10, 1, 0.10], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        
        data_table = [];
        if ~isempty(params.Esc_add)
            data_table(:, 1) = full_data_add_temp.(list{var})(params.TabRange);
            data_table(:, 2) = F_pred_temp.(list{var})(params.TabRange);
            text_Color = [1,0,0 ; 0,0,1];
        else
            data_table(:, 1) = full_data_add_temp.(list{var})(params.TabRange);
            text_Color = [1, 1, 1];
        end
        
        SimTools.scripts.plot_data_table( ...
            params.TabRange, ...
            data_table, ...
            'Parent', table_p, ...
            'SeriesNames', params.LegendsNames, ...
            'TextColor', text_Color, ...
            'FontSize', 9 ...
            )
        
        % ----- Panel de notas -----
        %      notes_p = uipanel( ...
        %         main_p, ...
        %         'Position', [0, 0, 1, 0.10], ...
        %         'BackgroundColor', [1, 1, 1] ...
        %     );
        %     temp_string = {...
        %         'Notas:', ...
        %         sprintf('   - Último dato observado en %s, correspondiente a la línea vertical punteada.', MODEL.data_mr.(var_data).UserData.endhist), ...
        %         sprintf('   - Fuente historia: %s %s.', MODEL.data_mr.(var_data).UserData.refhist, MODEL.data_mr.(var_data).UserData.refhist_mmdate), ...
        %         sprintf('   - Fuente de anclaje: %s %s.', MODEL.data_mr.(var_data).UserData.refpred, MODEL.data_mr.(var_data).UserData.refpred_mmdate), ...
        %     };
        %     uicontrol( ...
        %         notes_p, ...
        %         'Style', 'text', ...
        %         'Units', 'normalized', ...
        %         'Position', [0, 0, 1, 1],...
        %         'String', temp_string,...
        %         'FontWeight', 'normal', ...
        %         'FontSize', 9, ...
        %         'HorizontalAlignment', 'left', ...
        %         'BackgroundColor', [1, 1, 1]);
        
        
        axis on
        
        if rng == 2
            save_name = sprintf("%s_short.png",list{var});
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


%% Bloque 2: Componentes tasa de interés real (r, i, d4_ln_cpi_sub)

% Iteración a traves de los corrimientos (libre y otro)
for corr = 1:length(params.LegendsNames)
    % Iteración para los rangos de ploteo
    for rng = 1 : length(params.StartDate)
        
        if ~isempty(params.EndDatePlot{rng})
            full_data_add_temp = dbclip(full_data_add, params.StartDate{rng}:params.EndDatePlot{rng});
            F_pred_temp = dbclip(MODEL.F_pred, params.StartDate{rng}:params.EndDatePlot{rng});
        end
        
        if corr ==1
            i_g = full_data_add_temp.i;
            d4_ln_cpi_sub_g = full_data_add_temp.d4_ln_cpi_sub;
            r_g = full_data_add_temp.r;
        else
            i_g = F_pred_temp.i;
            d4_ln_cpi_sub_g = F_pred_temp.d4_ln_cpi_sub;
            r_g = F_pred_temp.r;
        end
        
        
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
            i_g,'.-b', ...
            'Color',"#77AC30",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        hold on
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_cpi_sub_g,'.-', ...
            'Color',"#D95319",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            r_g,'.-', ...
            'Color',"#0072BD",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        hold off
        % highlight(params.StartDate{rng}:MODEL.DATES.hist_end);
        zeroline;
        if corr == 1
            subt = ['Corrimiento ',params.LegendsNames{1}];
            if strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = MODEL.CORR_DATE_ANT;
                vline(MODEL.DATES.hist_end_ant,...
                    'LineWidth', 1,'LineStyle', '-.');
            elseif ~strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = 'Alterno';
                vline(MODEL.DATES.hist_end,...
                'LineWidth', 1,'LineStyle', '-.');
            end
        else
            subt = ['Corrimiento ',params.LegendsNames{2}];
            fig_n = MODEL.CORR_DATE;
            vline(MODEL.DATES.hist_end,...
                'LineWidth', 1, 'LineStyle', '-.');
        end
        
        title( ...
            {'Tasa de Interés Real', ...
            subt,...
            sprintf(...
            '%s - %s', ...
            dat2char(params.StartDate{rng}), ...
            dat2char(params.EndDatePlot{rng})...
            )} ,...
            'Interpreter','none'...
            );
        
        % ----- Panel de Tabla -----
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.9 - 0.10, 1, 0.10], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        data_table = [];
        data_table(:, 1) = i_g(params.TabRange);
        data_table(:, 2) = d4_ln_cpi_sub_g(params.TabRange);
        data_table(:, 3) = r_g(params.TabRange);
        text_Color = [0.4660 0.6740 0.1880 ; 0.8500 0.3250 0.0980;0 0.4470 0.7410];
        
        SimTools.scripts.plot_data_table( ...
            params.TabRange, ...
            data_table, ...
            'Parent', table_p, ...
            'SeriesNames', {'Tasa Líder','Inflación Subyacente Óptima MSE','Tasa de Interés Real'}, ...
            'TextColor', text_Color, ...
            'FontSize', 9 ...
            );
        
        axis on
        
        
        if rng == 2
            save_name = sprintf("Comp_R_short_%s.png", fig_n);
        else
            save_name = sprintf("Comp_R_%s.png", fig_n);
        end
        
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath, ...
            save_name), ...
            'AutoSave', params.AutoSave ...
            );
        
    end
end


%% Bloque 3: Inflaciones (d4_ln_cpi, d4_ln_cpi_sub, d4_ln_cpi_nosub)
% Iteración a traves de los corrimientos (actual y anterior)
for corr = 1:length(params.LegendsNames)
    % Iteración para los rangos de ploteo
    for rng = 1 : length(params.StartDate)
        
        if ~isempty(params.EndDatePlot{rng})
            full_data_add_temp = dbclip(full_data_add, params.StartDate{rng}:params.EndDatePlot{rng});
            F_pred_temp = dbclip(MODEL.F_pred, params.StartDate{rng}:params.EndDatePlot{rng});
        end
        
        if corr ==1
            d4_ln_cpi_g = full_data_add_temp.d4_ln_cpi;
            d4_ln_cpi_sub_g = full_data_add_temp.d4_ln_cpi_sub;
            d4_ln_cpi_nosub_g = full_data_add_temp.d4_ln_cpi_nosub;
        else
            d4_ln_cpi_g = F_pred_temp.d4_ln_cpi;
            d4_ln_cpi_sub_g = F_pred_temp.d4_ln_cpi_sub;
            d4_ln_cpi_nosub_g = F_pred_temp.d4_ln_cpi_nosub;
        end
        
        
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
            d4_ln_cpi_sub_g,'.-b', ...
            'Color',"#77AC30",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        hold on
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_cpi_nosub_g,'.-', ...
            'Color',"#D95319",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_cpi_g,'.-', ...
            'Color',"#0072BD",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        hold off
        % highlight(params.StartDate{rng}:MODEL.DATES.hist_end);
        zeroline;
        if corr == 1
            subt = ['Corrimiento ',params.LegendsNames{1}];
            if strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = MODEL.CORR_DATE_ANT;
                vline(MODEL.DATES.hist_end_ant,...
                    'LineWidth', 1,'LineStyle', '-.');
            elseif ~strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = 'Alterno';
                vline(MODEL.DATES.hist_end,...
                'LineWidth', 1,'LineStyle', '-.');
            end
        else
            subt = ['Corrimiento ',params.LegendsNames{2}];
            fig_n = MODEL.CORR_DATE;
            vline(MODEL.DATES.hist_end,...
                'LineWidth', 1, 'LineStyle', '-.');
        end
        
        title( ...
            {'Inflación Interanual', ...
            subt,...
            sprintf(...
            '%s - %s', ...
            dat2char(params.StartDate{rng}), ...
            dat2char(params.EndDatePlot{rng})...
            )} ,...
            'Interpreter','none'...
            );
        
        % ----- Panel de Tabla -----
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.9 - 0.10, 1, 0.10], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        data_table = [];
        data_table(:, 1) = d4_ln_cpi_sub_g(params.TabRange);
        data_table(:, 2) = d4_ln_cpi_nosub_g(params.TabRange);
        data_table(:, 3) = d4_ln_cpi_g(params.TabRange);
        text_Color = [0.4660 0.6740 0.1880 ; 0.8500 0.3250 0.0980;0 0.4470 0.7410];
        
        SimTools.scripts.plot_data_table( ...
            params.TabRange, ...
            data_table, ...
            'Parent', table_p, ...
            'SeriesNames', {'Inflación Subyacente  Óptima MSE','Inflación No Subyacente','Inflación Total'}, ...
            'TextColor', text_Color, ...
            'FontSize', 9 ...
            );
        
        axis on
        
        
        if rng == 2
            save_name = sprintf("Comp_Inf_short_%s.png", fig_n);
        else
            save_name = sprintf("Comp_Inf_%s.png", fig_n);
        end
        
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath, ...
            save_name), ...
            'AutoSave', params.AutoSave ...
            );
        
    end
end

%% Bloque 4: Componentes IPEI_Q (d4_ln_ipei, d4_ln_s, d4_ln_ipei_q)
% Iteración a traves de los corrimientos (actual y anterior)
for corr = 1:length(params.LegendsNames)
    % Iteración para los rangos de ploteo
    for rng = 1 : length(params.StartDate)
        
        if ~isempty(params.EndDatePlot{rng})
            full_data_add_temp = dbclip(full_data_add, params.StartDate{rng}:params.EndDatePlot{rng});
            F_pred_temp = dbclip(MODEL.F_pred, params.StartDate{rng}:params.EndDatePlot{rng});
        end
        
        if corr ==1
            d4_ln_ipei_q_g = full_data_add_temp.d4_ln_ipei_q;
            d4_ln_ipei_g = full_data_add_temp.d4_ln_ipei;
            d4_ln_s_g = full_data_add_temp.d4_ln_s;
        else
            d4_ln_ipei_q_g = F_pred_temp.d4_ln_ipei_q;
            d4_ln_ipei_g = F_pred_temp.d4_ln_ipei;
            d4_ln_s_g = F_pred_temp.d4_ln_s;
        end
        
        
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
            d4_ln_ipei_g,'.-b', ...
            'Color',"#77AC30",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        hold on
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_s_g,'.-', ...
            'Color',"#D95319",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_ipei_q_g,'.-', ...
            'Color',"#0072BD",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        hold off
        % highlight(params.StartDate{rng}:MODEL.DATES.hist_end);
        zeroline;
        if corr == 1
            subt = ['Corrimiento ',params.LegendsNames{1}];
            if strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = MODEL.CORR_DATE_ANT;
                vline(MODEL.DATES.hist_end_ant,...
                    'LineWidth', 1,'LineStyle', '-.');
            elseif ~strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = 'Alterno';
                vline(MODEL.DATES.hist_end,...
                'LineWidth', 1,'LineStyle', '-.');
            end
        else
            subt = ['Corrimiento ',params.LegendsNames{2}];
            fig_n = MODEL.CORR_DATE;
            vline(MODEL.DATES.hist_end,...
                'LineWidth', 1, 'LineStyle', '-.');
        end
        
        title( ...
            {'Tasa de Variación Interanual del Índice de Precios de Transables en GTQ', ...
            subt,...
            sprintf(...
            '%s - %s', ...
            dat2char(params.StartDate{rng}), ...
            dat2char(params.EndDatePlot{rng})...
            )} ,...
            'Interpreter','none'...
            );
        
        % ----- Panel de Tabla -----
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.9 - 0.10, 1, 0.10], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        data_table = [];
        data_table(:, 1) = d4_ln_ipei_g(params.TabRange);
        data_table(:, 2) = d4_ln_s_g(params.TabRange);
        data_table(:, 3) = d4_ln_ipei_q_g(params.TabRange);
        text_Color = [0.4660 0.6740 0.1880 ; 0.8500 0.3250 0.0980;0 0.4470 0.7410];
        
        SimTools.scripts.plot_data_table( ...
            params.TabRange, ...
            data_table, ...
            'Parent', table_p, ...
            'SeriesNames', {'Precios de Transables (USD)','Tipo de Cambio Nominal','Precios de Transables (GTQ)'}, ...
            'TextColor', text_Color, ...
            'FontSize', 9 ...
            );
        
        axis on
        
        
        if rng == 2
            save_name = sprintf("Comp_IPEI_Q_short_%s.png", fig_n);
        else
            save_name = sprintf("Comp_IPEI_Q_%s.png", fig_n);
        end
        
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath, ...
            save_name), ...
            'AutoSave', params.AutoSave ...
            );
        
    end
end

%% Bloque 5: Componentes Velocidad (d4_ln_v, d4_ln_cpi_sub, d4_ln_y, d4_ln_bm)
% Iteración a traves de los corrimientos (actual y anterior)
for corr = 1:length(params.LegendsNames)
    % Iteración para los rangos de ploteo
    for rng = 1 : length(params.StartDate)
        
        if ~isempty(params.EndDatePlot{rng})
            full_data_add_temp = dbclip(full_data_add, params.StartDate{rng}:params.EndDatePlot{rng});
            F_pred_temp = dbclip(MODEL.F_pred, params.StartDate{rng}:params.EndDatePlot{rng});
        end
        
        if corr ==1
            d4_ln_v_g = full_data_add_temp.d4_ln_v;
            d4_ln_cpi_sub_g = full_data_add_temp.d4_ln_cpi_sub;
            d4_ln_y_g = full_data_add_temp.d4_ln_y;
            d4_ln_bm_g = full_data_add_temp.d4_ln_bm;
                      
        else
            d4_ln_v_g = F_pred_temp.d4_ln_v;
            d4_ln_cpi_sub_g = F_pred_temp.d4_ln_cpi_sub;
            d4_ln_y_g = F_pred_temp.d4_ln_y;
            d4_ln_bm_g = F_pred_temp.d4_ln_bm;
        end
        
        
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
            d4_ln_v_g,'.-b', ...
            'Color','k',..."#77AC30",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        hold on
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_cpi_sub_g,'.-', ...
            'Color',"#77AC30",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_y_g,'.-', ...
            'Color',"#D95319",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        
        plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            d4_ln_bm_g,'.-', ...
            'Color',"#0072BD",...
            'MarkerSize', 17, ...
            'LineWidth', 2 ...
            );
        
        hold off
        % highlight(params.StartDate{rng}:MODEL.DATES.hist_end);
        zeroline;
        if corr == 1
            subt = ['Corrimiento ',params.LegendsNames{1}];
            if strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = MODEL.CORR_DATE_ANT;
                vline(MODEL.DATES.hist_end_ant,...
                    'LineWidth', 1,'LineStyle', '-.');
            elseif ~strcmp(params.Esc_add{1}, MODEL.CORR_DATE_ANT)
                fig_n = 'Alterno';
                vline(MODEL.DATES.hist_end,...
                'LineWidth', 1,'LineStyle', '-.');
            end
        else
            subt = ['Corrimiento ',params.LegendsNames{2}];
            fig_n = MODEL.CORR_DATE;
            vline(MODEL.DATES.hist_end,...
                'LineWidth', 1, 'LineStyle', '-.');
        end
        
        title( ...
            {'Tasa de variación de la Velocidad de Circulación (Porcentajes)', ...
            subt,...
            sprintf(...
            '%s - %s', ...
            dat2char(params.StartDate{rng}), ...
            dat2char(params.EndDatePlot{rng})...
            )} ,...
            'Interpreter','none'...
            );
        
        % ----- Panel de Tabla -----
        table_p = uipanel( ...
            main_p, ...
            'Position', [0, 1 - 0.9 - 0.10, 1, 0.15], ...
            'BackgroundColor', [1, 1, 1] ...
            );
        data_table = [];
        data_table(:, 1) = d4_ln_v_g(params.TabRange);
        data_table(:, 2) = d4_ln_cpi_sub_g(params.TabRange);
        data_table(:, 3) = d4_ln_y_g(params.TabRange);
        data_table(:, 4) = d4_ln_bm_g(params.TabRange);
        text_Color = [0 0 0; 0.4660 0.6740 0.1880 ; 0.8500 0.3250 0.0980;0 0.4470 0.7410];
        
        SimTools.scripts.plot_data_table( ...
            params.TabRange, ...
            data_table, ...
            'Parent', table_p, ...
            'SeriesNames', {'Velocidad de circulación', 'Inflación interna','Producto Doméstico', 'Base Monetaria'}, ...
            'TextColor', text_Color, ...
            'FontSize', 9 ...
            );
        
        axis on
        
        
        if rng == 2
            save_name = sprintf("Comp_Vel_short_%s.png", fig_n);
        else
            save_name = sprintf("Comp_Vel_%s.png", fig_n);
        end
        
        SimTools.scripts.pausaGuarda(...
            fullfile(params.SavePath, ...
            save_name), ...
            'AutoSave', params.AutoSave ...
            );
        
    end
end






end