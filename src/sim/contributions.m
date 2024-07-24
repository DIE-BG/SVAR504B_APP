function contributions(MODEL, varargin)
%{
    Descomposición de las contribuciones para cada una de las variables de
    interés. Las constribuciones se construyen a partir de la ecuación que
    define a cada una dentro de la estructura del modelo.

    Variables:
    MCI: Indice de Condiciones Monetarias 
    RMC: Costos Marianels Reales
    IS: Curva IS (Demanda Agregada)
    Phillips: Curva de Phillips (Inflación subyacente (variación
              intertrimestral))
    Regla de Taylor: Tasa de interés lider


__`MODEL`__ [ struct ] -
Debe contener al menos la estructura con los resultados del 
pre-procesamiento de los datos.

* 'StartDate' = {} [ `Cell` ] - Fechas de inicio del plot (Puede ser una o mas).
* 'EndDatePlot' = {} [ `Cell` ] - fechas de fin del plot (pueden ser una o mas).

* 'Esc_add' = {}  [ `Cell` ] - Escenario adicional a plotear. Cell array 
    con dos elementos: (1) Versión o fecha del escenario adicional y (2)
    Base de datos con los datos historicos del corrimiento anterior.

Departamento de Investigaciones Económicas - 2024.
MJGM/JGOR

%}

p = inputParser;
addParameter(p, 'StartDate', {MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20});
addParameter(p, 'EndDatePlot', {MODEL.DATES.pred_end});
addParameter(p, 'SavePath', {});
addParameter(p, 'Esc_add', {}); % libre v0, alterno v1, contrafactual v2...
addParameter(p, 'tab_range', {});
addParameter(p, 'diff', false);

parse(p, varargin{:});
params = p.Results;

%% Limpieza y creación de folders
% Verificación y creación del directorio para las gráficas
if isempty(params.SavePath)
    params.SavePath = fullfile('plots', MODEL.CORR_DATE, params.Esc_add{1}, 'contributions');
end

if ~isfolder(params.SavePath)
    mkdir(params.SavePath)
    mkdir(fullfile(params.SavePath, 'long'))
    mkdir(fullfile(params.SavePath, 'short'))
else
    rmdir(params.SavePath, 's')
    mkdir(params.SavePath)
    mkdir(fullfile(params.SavePath, 'long'))
    mkdir(fullfile(params.SavePath, 'short'))
end

%% Carga de base de datos mes anterior
if strcmp(params.Esc_add{1}, 'v0')
    temp_F_pred = MODEL.F_pred;
    temp_F = MODEL.F;
    full_data_add = params.Esc_add{2};
else
    temp_F_pred = MODEL.F_pred;
    temp_F = MODEL.F;
    full_data_add.F_pred = params.Esc_add{2};
    full_data_add.DATES = MODEL.DATES;
    full_data_add.CORR_DATE = 'Alterno';
end
   
% primera diferencia
if params.diff == true
    temp_F_pred = databank.apply(@(x) diff(x), temp_F_pred,...
                                       'RemoveSource=', true);
           
    for k = 1:length(get(MODEL.M, 'elist'))
       temp_F.(strcat('k',string(k))) = 0; 
    end
    
    full_data_add.F_pred = databank.apply(@(x) diff(x), full_data_add.F_pred,...
                                       'RemoveSource=', true);
                                   
    for k = 1:length(get(MODEL.M, 'elist'))
       full_data_add.F.(strcat('k',string(k))) = 0; 
    end                            
                                
end

%% Identificador
if strcmp(params.Esc_add{1}, 'v0')   
   params.date_ant = MODEL.CORR_DATE_ANT;
else
   params.date_ant = 'Alterno';
end

if ~params.diff
    t = '(Contribuciones)';
    
else
    t = '(Contribuciones a la Primera Diferencia)';
    
end
        

%% Producto doméstico
params.leg = {'Constante',...1
              'Producto externo',...2
              'Precios de importados',...3
              'Tasa externa',...4
              'Inflación no subyacente',...5
              'Producto doméstico',...6
              'Inflación subyacente',...7
              'Tipo de cambio nominal',...8
              'Base Monetaria',...9
              'Tasa de Interés',...10              
              'Shock Propio'};%11

params.cols = get(MODEL.M, 'elist');
          
% Paleta de colores
col = distinguishable_colors(length(params.cols)+1, ...
    'b', ...
    @(x) colorspace('RGB->Lab',x));

col = [[0.627 0.208 0.247]; col];


    for rng = params.StartDate
        % Corrimiento actual
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
            [(temp_F.k5),...
            (MODEL.F.g_1_51*temp_F_pred.dla_y_star.shift(-1)    - MODEL.F.g_0_51*temp_F_pred.dla_y_star),...
            (MODEL.F.g_1_52*temp_F_pred.dla_ipei.shift(-1)      - MODEL.F.g_0_52*temp_F_pred.dla_ipei),......
            (MODEL.F.g_1_53*temp_F_pred.i_star.shift(-1)          - MODEL.F.g_0_53*temp_F_pred.i_star),...,...
            (MODEL.F.g_1_54*temp_F_pred.dla_cpi_nosub.shift(-1) - MODEL.F.g_0_54*temp_F_pred.dla_cpi_nosub),......
            (MODEL.F.g_1_55*temp_F_pred.dla_y.shift(-1)),...
            (MODEL.F.g_1_56*temp_F_pred.dla_cpi_sub.shift(-1)),...
            (MODEL.F.g_1_57*temp_F_pred.dla_s.shift(-1)),...
            (MODEL.F.g_1_58*temp_F_pred.dla_bm.shift(-1))...
            (MODEL.F.g_1_59*temp_F_pred.i.shift(-1)),...
            (temp_F_pred.s_dla_y)],...
            'stacked');
        
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.dla_y,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.dla_y,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              MODEL.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Producto Doméstico',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_act, ' ', 'Intertrimestral anualizada'),...
                'FontSize', 17)

        else
        title({'Producto Doméstico',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                sprintf('Corrimiento %s', MODEL.leg_act),...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'dla_y', MODEL.leg_act)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'dla_y', MODEL.leg_act)), ...
                'AutoSave', true);

        end
        
        % Corrimiento anterior/Escenario
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
           [(full_data_add.F.k5),...
            (full_data_add.F.g_1_51*full_data_add.F_pred.d4_ln_y_star.shift(-1)    - full_data_add.F.g_0_51*full_data_add.F_pred.d4_ln_y_star),...
            (full_data_add.F.g_1_52*full_data_add.F_pred.d4_ln_ipei.shift(-1)      - full_data_add.F.g_0_52*full_data_add.F_pred.d4_ln_ipei),......
            (full_data_add.F.g_1_53*full_data_add.F_pred.i_star.shift(-1)          - full_data_add.F.g_0_53*full_data_add.F_pred.i_star),...,...
            (full_data_add.F.g_1_54*full_data_add.F_pred.d4_ln_cpi_nosub.shift(-1) - full_data_add.F.g_0_54*full_data_add.F_pred.d4_ln_cpi_nosub),......
            (full_data_add.F.g_1_55*full_data_add.F_pred.d4_ln_y.shift(-1)),...
            (full_data_add.F.g_1_56*full_data_add.F_pred.d4_ln_cpi_sub.shift(-1)),...
            (full_data_add.F.g_1_57*full_data_add.F_pred.d4_ln_s.shift(-1)),...
            (full_data_add.F.g_1_58*full_data_add.F_pred.d4_ln_bm.shift(-1))...
            (full_data_add.F.g_1_59*full_data_add.F_pred.i.shift(-1)),...
            (full_data_add.F_pred.s_d4_ln_y)],...
            'stacked');
               
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.d4_ln_y,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.d4_ln_y,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              full_data_add.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Producto Doméstico',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_ant, ' ', 'Interanual'),...
                'FontSize', 17)

        else
        title({'Producto Doméstico',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                params.Esc_add{3},...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'd4_ln_y', MODEL.leg_ant)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'd4_ln_y', MODEL.leg_ant)), ...
                'AutoSave', true);

        end
        
    end

%% Inflación subyacente         
    for rng = params.StartDate
        % Corrimiento actual
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
            [temp_F.k6,...1
             MODEL.F.g_1_61*temp_F_pred.dla_y_star.shift(-1) - MODEL.F.g_0_61*temp_F_pred.dla_y_star,...2
             MODEL.F.g_1_62*temp_F_pred.dla_ipei.shift(-1)   - MODEL.F.g_0_62*temp_F_pred.dla_ipei,...3
             MODEL.F.g_1_63*temp_F_pred.i_star.shift(-1)       - MODEL.F.g_0_63*temp_F_pred.i_star,...4
             MODEL.F.g_1_64*temp_F_pred.dla_cpi_nosub.shift(-1) - MODEL.F.g_0_64*temp_F_pred.dla_cpi_nosub,...5
             MODEL.F.g_1_65*temp_F_pred.dla_y.shift(-1)      - MODEL.F.g_0_65*temp_F_pred.dla_y,...6
             MODEL.F.g_1_66*temp_F_pred.dla_cpi_sub.shift(-1),...7
             MODEL.F.g_1_67*temp_F_pred.dla_s.shift(-1),... 8
             MODEL.F.g_1_68*temp_F_pred.dla_bm.shift(-1),... 9
             MODEL.F.g_1_69*temp_F_pred.i.shift(-1),... 10
             temp_F_pred.s_dla_cpi_sub],...11
            'stacked');
        
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.dla_cpi_sub,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.dla_cpi_sub,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              MODEL.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Inflación subyacente',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_act, "", 'Intertrimestral anualizada'),...
                'FontSize', 17)

        else
        title({'Inflación subyacente',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                sprintf('Corrimiento %s', MODEL.leg_act),...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'dla_cpi_sub', MODEL.leg_act)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'dla_cpi_sub', MODEL.leg_act)), ...
                'AutoSave', true);
        end
        
        % Corrimiento anterior/Escenario
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
            [full_data_add.F.k6,...1
             (full_data_add.F.g_1_61*full_data_add.F_pred.d4_ln_y_star.shift(-1) - full_data_add.F.g_0_61*full_data_add.F_pred.d4_ln_y_star),...2
             (full_data_add.F.g_1_62*full_data_add.F_pred.d4_ln_ipei.shift(-1)   - full_data_add.F.g_0_62*full_data_add.F_pred.d4_ln_ipei),...3
             (full_data_add.F.g_1_63*full_data_add.F_pred.i_star.shift(-1)       - full_data_add.F.g_0_63*full_data_add.F_pred.i_star),...4
             (full_data_add.F.g_1_64*full_data_add.F_pred.d4_ln_cpi_nosub.shift(-1) - full_data_add.F.g_0_64*full_data_add.F_pred.d4_ln_cpi_nosub),...5
             (full_data_add.F.g_1_65*full_data_add.F_pred.d4_ln_y.shift(-1)      -full_data_add.F.g_0_65*full_data_add.F_pred.dla_y),...6
             (full_data_add.F.g_1_66*full_data_add.F_pred.d4_ln_cpi_sub.shift(-1)),...7
             (full_data_add.F.g_1_67*full_data_add.F_pred.d4_ln_s.shift(-1)),...8
             (full_data_add.F.g_1_68*full_data_add.F_pred.d4_ln_bm.shift(-1)),... 9
             (full_data_add.F.g_1_69*full_data_add.F_pred.i.shift(-1)),... 10
             full_data_add.F_pred.s_d4_ln_cpi_sub],...11
            'stacked');
        
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.d4_ln_cpi_sub,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.d4_ln_cpi_sub,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              full_data_add.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Inflación subyacente',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_ant, "", 'Interanual'),...
                'FontSize', 17)

        else
        title({'Inflación subyacente',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                params.Esc_add{3},...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'd4_ln_cpi_sub', MODEL.leg_ant)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'd4_ln_cpi_sub', MODEL.leg_ant)), ...
                'AutoSave', true);

        end
        
    end

%% Base Monetaria
          
    for rng = params.StartDate
        % Corrimiento actual
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
            [temp_F.k8,...1
             (MODEL.F.g_1_81*temp_F_pred.dla_y_star.shift(-1) - MODEL.F.g_0_81*temp_F_pred.dla_y_star),...1
             (MODEL.F.g_1_82*temp_F_pred.dla_ipei.shift(-1)   - MODEL.F.g_0_82*temp_F_pred.dla_ipei),...2
             (MODEL.F.g_1_83*temp_F_pred.i_star.shift(-1)       - MODEL.F.g_0_83*temp_F_pred.i_star),...4
             (MODEL.F.g_1_84*temp_F_pred.dla_cpi_nosub.shift(-1) - MODEL.F.g_0_84*temp_F_pred.dla_cpi_nosub),...5
             (MODEL.F.g_1_85*temp_F_pred.dla_y.shift(-1)         - MODEL.F.g_0_85*temp_F_pred.dla_y),...6
             (MODEL.F.g_1_86*temp_F_pred.dla_cpi_sub.shift(-1)   - MODEL.F.g_0_86*temp_F_pred.dla_cpi_sub),...7
             (MODEL.F.g_1_87*temp_F_pred.dla_s.shift(-1)         - MODEL.F.g_0_87*temp_F_pred.dla_s ),...8
             (MODEL.F.g_1_88*temp_F_pred.dla_bm.shift(-1)        - MODEL.F.g_1_88*temp_F_pred.dla_bm),... 9
             (MODEL.F.g_1_89*temp_F_pred.i.shift(-1)),...10
              temp_F_pred.s_dla_bm],...11
            'stacked');
        
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.dla_bm,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.dla_bm,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              MODEL.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Base Monetaria',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_act, " ", 'Intertrimestral analizado'),...
                'FontSize', 17)

        else
        title({'Base Monetaria',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                sprintf('Corrimiento %s', MODEL.leg_act),...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'dla_bm', MODEL.leg_act)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'dla_bm', MODEL.leg_act)), ...
                'AutoSave', true);
        end
        
        % Corrimiento anterior/Escenario
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
            [full_data_add.F.k8,...1
             (full_data_add.F.g_1_81*full_data_add.F_pred.d4_ln_y_star.shift(-1) - full_data_add.F.g_0_81*full_data_add.F_pred.d4_ln_y_star),...2
             (full_data_add.F.g_1_82*full_data_add.F_pred.d4_ln_ipei.shift(-1)   - full_data_add.F.g_0_82*full_data_add.F_pred.d4_ln_ipei),...3
             (full_data_add.F.g_1_83*full_data_add.F_pred.i_star.shift(-1)       - full_data_add.F.g_0_83*full_data_add.F_pred.i_star),...4
             (full_data_add.F.g_1_84*full_data_add.F_pred.d4_ln_cpi_nosub.shift(-1) - full_data_add.F.g_0_84*full_data_add.F_pred.d4_ln_cpi_nosub),...5
             (full_data_add.F.g_1_85*full_data_add.F_pred.d4_ln_y.shift(-1)         - full_data_add.F.g_0_85*full_data_add.F_pred.d4_ln_y),...6
             (full_data_add.F.g_1_86*full_data_add.F_pred.d4_ln_cpi_sub.shift(-1)   - full_data_add.F.g_0_86*full_data_add.F_pred.d4_ln_cpi_sub),...7
             (full_data_add.F.g_1_87*full_data_add.F_pred.d4_ln_s.shift(-1)         - full_data_add.F.g_0_87*full_data_add.F_pred.d4_ln_s ),...8
             (full_data_add.F.g_1_88*full_data_add.F_pred.d4_ln_bm.shift(-1)),... 9
             (full_data_add.F.g_1_89*full_data_add.F_pred.i.shift(-1)),...10
              full_data_add.F_pred.s_d4_ln_bm],...11
            'stacked');
        
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.d4_ln_bm,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.d4_ln_bm,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              full_data_add.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Base Monetaria',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_ant, " ", 'Interanual'),...
                'FontSize', 17)

        else
        title({'Base Monetaria',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                params.Esc_add{3},...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'd4_ln_bm', MODEL.leg_ant)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'd4_ln_bm', MODEL.leg_ant)), ...
                'AutoSave', true);

        end
        
    end

%% Tasa de interés
          
    for rng = params.StartDate
        % Corrimiento actual
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
            [temp_F.k9,...1
             (MODEL.F.g_1_91*temp_F_pred.dla_y_star.shift(-1)    - MODEL.F.g_0_91*temp_F_pred.dla_y_star),...2
             (MODEL.F.g_1_92*temp_F_pred.dla_ipei.shift(-1)      - MODEL.F.g_0_92*temp_F_pred.dla_ipei ),...3
             (MODEL.F.g_1_93*temp_F_pred.i_star.shift(-1)          - MODEL.F.g_0_93*temp_F_pred.i_star),...4
             (MODEL.F.g_1_94*temp_F_pred.dla_cpi_nosub.shift(-1) - MODEL.F.g_0_94*temp_F_pred.dla_cpi_nosub),...5
             (MODEL.F.g_1_95*temp_F_pred.dla_y.shift(-1)         - MODEL.F.g_0_95*temp_F_pred.dla_y),... 6
             (MODEL.F.g_1_96*temp_F_pred.dla_cpi_sub.shift(-1)   - MODEL.F.g_0_96*temp_F_pred.dla_cpi_sub),...7
             (MODEL.F.g_1_97*temp_F_pred.dla_s.shift(-1)         - MODEL.F.g_0_97*temp_F_pred.dla_s),...8
             (MODEL.F.g_1_98*temp_F_pred.dla_bm.shift(-1)        - MODEL.F.g_0_98*temp_F_pred.dla_bm ),...9
             (MODEL.F.g_1_99*temp_F_pred.i.shift(-1)),...10
              temp_F_pred.s_i],...11
            'stacked');
        
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.i,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, temp_F_pred.i,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              MODEL.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Tasa de Interés',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_act, " ", 'Intertrimestral anualizado'),...
                'FontSize', 17)

        else
        title({'Tasa de Interés',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                sprintf('Corrimiento %s', MODEL.leg_act),...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'i', MODEL.leg_act)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'i', MODEL.leg_act)), ...
                'AutoSave', true);
        end
        
        % Corrimiento anterior/Escenario
        figure;
        set(gcf, ...
            'defaultaxesfontsize',12, ...
            'Position', [1 42.0182 1.6756e+03 825.6000]);
        % Barras
        bar(rng{1}:params.EndDatePlot{1},...
            [temp_F.k9,...1
             (full_data_add.F.g_1_91*full_data_add.F_pred.d4_ln_y_star.shift(-1)    - full_data_add.F.g_0_91*full_data_add.F_pred.d4_ln_y_star),...2
             (full_data_add.F.g_1_92*full_data_add.F_pred.d4_ln_ipei.shift(-1)      - full_data_add.F.g_0_92*full_data_add.F_pred.d4_ln_ipei ),...3
             (full_data_add.F.g_1_93*full_data_add.F_pred.i_star.shift(-1)          - full_data_add.F.g_0_93*full_data_add.F_pred.i_star),...4
             (full_data_add.F.g_1_94*full_data_add.F_pred.d4_ln_cpi_nosub.shift(-1) - full_data_add.F.g_0_94*full_data_add.F_pred.d4_ln_cpi_nosub),...5
             (full_data_add.F.g_1_95*full_data_add.F_pred.d4_ln_y.shift(-1)         - full_data_add.F.g_0_95*full_data_add.F_pred.d4_ln_y),... 6
             (full_data_add.F.g_1_96*full_data_add.F_pred.d4_ln_cpi_sub.shift(-1)   - full_data_add.F.g_0_96*full_data_add.F_pred.d4_ln_cpi_sub),...7
             (full_data_add.F.g_1_97*full_data_add.F_pred.d4_ln_s.shift(-1)         - full_data_add.F.g_0_97*full_data_add.F_pred.d4_ln_s),...8
             (full_data_add.F.g_1_98*full_data_add.F_pred.d4_ln_bm.shift(-1)        - full_data_add.F.g_0_98*full_data_add.F_pred.d4_ln_bm ),...9
             (full_data_add.F.g_1_99*full_data_add.F_pred.i.shift(-1)),...10
              full_data_add.F_pred.s_i],...11
            'stacked');
        
        hold on

        % Lineas
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.i,'w','LineWidth',5);
        plot(rng{1}:params.EndDatePlot{1}, full_data_add.F_pred.i,'k.-','LineWidth',2, 'MarkerSize', 20);

        
        vline(...
              full_data_add.DATES.hist_end,...
              'LineWidth', 1, ...
              'LineStyle', '-.');

        hold off
        
        legend(params.leg, 'Location', 'northeastoutside',...
               'FontSize', 11.5);

        colororder(col);

        if strcmp(params.Esc_add{1}, 'v0')
        title({'Tasa de Interés',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                strcat(MODEL.leg_ant, " ", 'Intertrimestral'),...
                'FontSize', 17)

        else
        title({'Tasa de Interés',...
            t,...
            strcat(dat2char(rng{1}),...
                '-',dat2char(params.EndDatePlot{1}))},...
                params.Esc_add{3},...
                'FontSize', 17)
        end
           
        
        grid on

        % Guardamos la gráfica
        if rng{1} == params.StartDate{1}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'long',...
                sprintf("%s_%s.png", 'i', MODEL.leg_ant)), ...
                'AutoSave', true);

        elseif rng{1} == params.StartDate{2}
                SimTools.scripts.pausaGuarda(...
                fullfile(params.SavePath, 'short',...
                sprintf("%s_%s_short.png", 'i', MODEL.leg_ant)), ...
                'AutoSave', true);

        end
        
    end
    
end