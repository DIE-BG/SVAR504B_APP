%{
Se generan las Impulso respuesta de las 9 variables de modelo
%}

%% Preparación
% obtenemos las desviaciones estándar
for i = 1:length(MODEL.K)
    s.(strcat('std_s_',char(MODEL.ExoVar(i)))) = sqrt(MODEL.COV_MAT(i, i));
end

%% Simulación
% Definición de períodos de simulación
startSim = 1;
endSim = 40;

% Variables con choque
shocks_list = get(MODEL.M, 'elist');

for i = 1:length(shocks_list)
    % base de datos
    db_sim = sstatedb(MODEL.M, startSim-4:endSim);
    db_sim.(shocks_list{i})(startSim) = s.(strcat('std_', shocks_list{i}));
    
    % simulación
    MODEL.impulse_response.(shocks_list{i}) = simulate(MODEL.M, db_sim, startSim:endSim,...
                                                       'DbOverlay=', true);
                                                   
    % Alrededor de cero
    MODEL.impulse_response.(shocks_list{i}) = cell2struct(...
                                                         cellfun(...
                                                         @(x) MODEL.impulse_response.(shocks_list{i}).(x) - db_sim.(x),...
                                                         get(MODEL.M, 'xlist'), ...
                                                         'UniformOutput', false),...
                                                         get(MODEL.M, 'xlist'), 2);
    
    % Corregir problemas de aproximación
    MODEL.impulse_response.(shocks_list{i}) = structfun( ...
                    @(x) round(x, 8), ...
                    MODEL.impulse_response.(shocks_list{i}), ...
                    'UniformOutput', false);
end

%% Gráficas
IRF_plot_list = {'d4_ln_y_star', 'd4_ln_ipei', 'i_star', 'd4_ln_cpi_nosub',...
                'd4_ln_y', 'd4_ln_cpi_sub', 'd4_ln_s', 'd4_ln_bm',...
                'i', 'd4_ln_cpi', 'd4_ln_z', 'd4_ln_v', 'r'};

if ~isfolder(fullfile('plots', MODEL.CORR_DATE, 'IRF'))
   mkdir(fullfile('plots', MODEL.CORR_DATE, 'IRF'))
end


% limpieza de bases de datos
for i = 1:length(shocks_list)
    MODEL.impulse_response.(shocks_list{i}) = MODEL.impulse_response.(shocks_list{i})*IRF_plot_list;
end

for shock = 1:length(shocks_list)
    
    figure;
    
    set(gcf, ...
        'defaultaxesfontsize', 12, ...
        'Position', [1 42.0182 1.6756e+03 825.6000]);
  
    for x_i = 1:length(IRF_plot_list)
            subplot(4, 4, x_i);
            
            if strcmp(shocks_list{shock}, strcat('s_', IRF_plot_list{x_i}))
            plot(startSim-4:endSim-10, ...
                MODEL.impulse_response.(shocks_list{shock}).(IRF_plot_list{x_i}), ...
                'r', 'LineWidth', 1.25);   
                
            else
            plot(startSim-4:endSim-10, ...
                MODEL.impulse_response.(shocks_list{shock}).(IRF_plot_list{x_i}), ...
                'b', 'LineWidth', 1.25);
            
            end

            grid on

             highlight(-3:0);

            title(IRF_plot_list{x_i}, ...
                'interpreter', 'none');

            ylabel('Porcentaje', ...
                'Fontsize', 12);

            ytickformat('%0.3f')
    end

        sgtitle({sprintf("Respuesta a un choque en %s", shocks_list{shock}),...
                sprintf('Shock de una desviación estándar %s',...
                sprintf('%.3f', s.(strcat('std_', string(shocks_list{shock}))...
                )))}, ...
            'Interpreter', 'none');    
        
        saveas(gcf,...
            fullfile('plots', MODEL.CORR_DATE, 'IRF',...
                    sprintf('%s_%s.png', string(shock), shocks_list{shock})))
        
        close all;
end


