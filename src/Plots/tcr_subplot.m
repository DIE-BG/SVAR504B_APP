function tcr_subplot(MODEL, varargin)
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
end   

%% Carga de base de datos mes anterior
full_data_add = params.Esc_add{2};

if isempty(params.Esc_add{3})
    esc_col = [1, 0, 0];
    
else
   esc_col = params.Esc_add{3};
    
end
    
  
%% Gráfica
toplot = {'ln_z_sa', 's_sa', 'ln_ipei_sa', 'ln_cpi_sub_sa'};

    for rng = params.StartDate
        for i = 1:length(toplot)

            set(gcf, ...
                'defaultaxesfontsize',12, ...
                'Position', [1 42.0182 1117.1 776.73]);

            if i == 1 || i >= 3
                subplot(2,2,i)
                % Corrimiento actual
                plot(rng{1}:params.EndDatePlot{1},...
                    MODEL.PostProc.v0.l_sa.(toplot{i}),...
                    'Marker', '.',...
                    'MarkerSize', 7,...
                    'LineWidth', 1.25,...
                    'Color', 'b');

                hold on
                % Escenario
                plot(rng{1}:params.EndDatePlot{1},...
                    full_data_add.(params.Esc_add{1}).l_sa.(toplot{i}),...
                    'Marker', '.',...
                    'MarkerSize', 7,...
                    'LineWidth', 1.25,...
                    'Color', esc_col);
                
                hold off
                %linea vertical
                vline(MODEL.DATES.hist_end, ...
                    'LineWidth', 1, ...
                    'LineStyle', '-');

                % leyenda
                legend({params.LegendsNames{2}, params.LegendsNames{1}},...
                    'Location','best', 'Interpreter', 'none',...
                    'FontSize', 8);
                
                %Returns handles to the patch and line objects
                chi = get(gca, 'Children');
                %Reverse the stacking order so that the patch overlays the line
                set(gca, 'Children',flipud(chi));
                
                %titulos
                title(MODEL.PostProc.v0.l_sa.(toplot{i}).Comment{1});



                if i == 4
                    if rng{1} == params.StartDate{1}
                        SimTools.scripts.pausaGuarda(fullfile(params.SavePath,...
                            'TC_real_subplot.png'), ...
                            'AutoSave', true);

                elseif rng{1} == params.StartDate{2}
                        SimTools.scripts.pausaGuarda(fullfile(params.SavePath,...
                            'TC_real_subplot_short.png'), ...
                            'AutoSave', true);
                    end
                end


            elseif i == 2
                subplot(2,2,i)
                %Corrimiento actual
                plot(rng{1}:params.EndDatePlot{1}, MODEL.PostProc.v0.niv_sa.(toplot{i}),...
                    'Marker', '.',...
                    'MarkerSize', 7,...
                    'LineWidth', 1.25,...
                    'Color', 'b');
                
                hold on

                %Escenario
                plot(rng{1}:params.EndDatePlot{1},...
                    full_data_add.(params.Esc_add{1}).niv_sa.(toplot{i}),...
                    'Marker', '.',...
                    'MarkerSize', 7,...
                    'LineWidth', 1.25,...
                    'Color', esc_col);
                hold off

                % leyenda
                legend({params.LegendsNames{2}, params.LegendsNames{1}},...
                    'Location','best', 'Interpreter', 'none',...
                    'FontSize', 8);
                
                %Returns handles to the patch and line objects
                chi = get(gca, 'Children');
                %Reverse the stacking order so that the patch overlays the line
                set(gca, 'Children',flipud(chi));
                

                
                %linea vertical
                vline(MODEL.DATES.hist_end, ...
                    'LineWidth', 1, ...
                    'LineStyle', '-');

                %titulos
                title('Tipo de cambio nominal Q/$');



        sgtitle({'Componentes del Tipo de Cambio Real',...
               strcat("Comparativo ", params.LegendsNames{2}, "-", params.LegendsNames{1}),...
               strcat(dat2char(rng{1}), '-',...
               dat2char(params.EndDatePlot{1}))});
            end
        end
    end
    close all;    
end