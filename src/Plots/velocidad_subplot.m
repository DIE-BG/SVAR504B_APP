function velocidad_subplot(MODEL, varargin)
%{
    Se genera una gráfica con los componentes de la velocidad de
    circulación. Todas las variables son logaritmos naturales
    desestacionalizados.
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

%% creación de folders
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
toplot = {'ln_v_sa', 'ln_cpi_sub_sa', 'ln_y_sa', 'ln_bm_sa'};

for rng = params.StartDate
    for i = 1:length(toplot)

        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1117.1 776.73]);

        subplot(2,2,i);
        % Corrimiento
        plot(rng{1}:params.EndDatePlot{1},...
            MODEL.PostProc.v0.l_sa.(toplot{i}),...
            'Marker', '.',...
            'MarkerSize', 7,...
            'LineWidth', 0.5,...
            'color', 'b');
        
        hold on
        % Escenario
        plot(rng{1}:params.EndDatePlot{1},...
            full_data_add.(params.Esc_add{1}).l_sa.(toplot{i}),...
            'Marker', '.',...
            'MarkerSize', 7,...
            'LineWidth', 0.5,...
            'color', esc_col);

        % leyenda
        legend({params.LegendsNames{2}, params.LegendsNames{1}},...
                'Location','best', 'Interpreter', 'none',...
                'FontSize', 8);
        
        hold off
        
        %Returns handles to the patch and line objects
        chi = get(gca, 'Children');
        %Reverse the stacking order so that the patch overlays the line
        set(gca, 'Children',flipud(chi));
        

        
        %linea vertical
        vline(MODEL.DATES.hist_end, ...
            'LineWidth', 1, ...
            'LineStyle', '-');

        %titulos
        title(regexprep(MODEL.PostProc.v0.l_sa.(toplot{i}).Comment{1}, '\([^)]*\)', ''),...
            '(niveles)','Interpreter', 'none');
        
        if strcmp(params.Esc_add{1}, 'v0')
        sgtitle({'Componentes de la Velocidad de Circulación',...
            strcat(dat2char(rng{1}), '-',...
            dat2char(params.EndDatePlot{1}))});
        
        else
        sgtitle({'Componentes de la Velocidad de Circulación',...
            strcat("Comparativo ", params.LegendsNames{2}, "-", params.LegendsNames{1}),...
            strcat(dat2char(rng{1}), '-',...
            dat2char(params.EndDatePlot{1}))});            
        end
        

        if i == 4
            if rng{1} == params.StartDate{1}
                Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                    'Velocidad (componentes).png'), ...
                    'AutoSave', true);
                
            elseif rng{1} == params.StartDate{2}
                 Sim.scripts.pausaGuarda(fullfile(params.SavePath,...
                    'Velocidad (componentes)_short.png'), ...
                    'AutoSave', true);
            end
        end
    end
end

close all;

end

