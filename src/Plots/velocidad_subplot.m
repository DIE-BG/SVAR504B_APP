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
addParameter(p, 'Esc_alt', {}); % Para escenario alterno
addParameter(p, 'Esc', 'v0'); % libre v0, alterno v1, contrafactual v2
addParameter(p, 'FullDataAnt', {}); % Para corrimiento anterior
addParameter(p, 'tab_range', {});
addParameter(p, 'TabRange', qq(2021,4):4:qq(2024,4));
addParameter(p, 'LegendsNames', {});

parse(p, varargin{:});
params = p.Results;

%% creación de folders
% Verificación y creación del directorio para las gráficas
if isempty(params.SavePath)
    params.SavePath = fullfile('plots', MODEL.CORR_DATE, params.Esc, 'otras');
end

if ~isfolder(params.SavePath)
    mkdir(params.SavePath)
end   

%% Carga de base de datos mes anterior
if ~isempty(params.FullDataAnt)
    full_data_ant = params.FullDataAnt;
end   

if ~isempty(params.Esc_alt)
   full_data_ant = params.Esc_alt; 
end

% leyendas
if isempty(params.LegendsNames)
    params.LegendsNames = {MODEL.leg_act, MODEL.leg_ant};
else
    params.LegendsNames = params.LegendsNames;
end
%% Gráfica
toplot = {'ln_v_sa', 'ln_cpi_sub_sa', 'ln_y_sa', 'ln_bm_sa'};

for rng = params.StartDate
    for i = 1:length(toplot)

        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1117.1 776.73]);

        subplot(2,2,i);

        h = plot(rng{1}:params.EndDatePlot{1},...
            [MODEL.PostProc.v0.l_sa.(toplot{i}),... %corr actual
            full_data_ant.(params.Esc).l_sa.(toplot{i}),... %corr anterior
            MODEL.PostProc.v0.l_sa.(toplot{i})],... % historia
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
            'LineStyle', '-');

        %titulos
        title(regexprep(MODEL.PostProc.v0.l_sa.(toplot{i}).Comment{1}, '\([^)]*\)', ''),...
            '(niveles)','Interpreter', 'none');

        % leyenda
        legend(params.LegendsNames,...
            'Location','best', 'Interpreter', 'none',...
            'FontSize', 8);
        
        if strcmp(params.Esc, 'v0')
        sgtitle({'Componentes de la Velocidad de Circulación',...
            strcat(dat2char(rng{1}), '-',...
            dat2char(params.EndDatePlot{1}))});
        
        else
        sgtitle({'Componentes de la Velocidad de Circulación',...
            strcat("Comparativo ", params.LegendsNames{1}, "-", params.LegendsNames{2}),...
            strcat(dat2char(rng{1}), '-',...
            dat2char(params.EndDatePlot{1}))});            
        end
        

        if i == 4
            if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(fullfile(params.SavePath,...
                    'Velocidad (componentes).png'), ...
                    'AutoSave', true);
                
            elseif rng{1} == params.StartDate{2}
                 SimTools.scripts.pausaGuarda(fullfile(params.SavePath,...
                    'Velocidad (componentes)_short.png'), ...
                    'AutoSave', true);
            end
        end
    end
end

close all;

end

