%% ELEMENTOS GENERALES

params = struct();
params.SavePath = fullfile( ...
    cd, ...
    'plots', ...
    MODEL.CORR_DATE, ...
    MODEL.CORR_VER, ...
    'PostProcessing'...
    );
params.StartDate = {MODEL.DATES.hist_start, MODEL.DATES.hist_end - 20};
params.EndDatePlot = {MODEL.DATES.pred_end, MODEL.DATES.hist_end + 20};

params.FullDataAnt_Name = MODEL.FULLDATANAME_ANT;
params.PlotList = get(MODEL.MF, 'xlist');
params.LegendsNames = {'Tendencia (HP, Lambda=1600)', 'Logaritmo (SA, X12)'};
params.LegendLocation = 'SouthEast';
params.PlotSSLine = true;
params.PlotAnnotations = true;
params.AnnotationXAdjustment = 0;
params.AnnotationYAdjustment = 0;
params.AnnoRange = qq(2021,4):4:qq(2024,4);
params.TabRange = tab_range;
params.CloseAll = false;
params.AutoSave = true;


%%
% Verificación y creación del directorio para las gráficas
if ~isfolder(params.SavePath)
    mkdir(params.SavePath)
else
    rmdir(params.SavePath, 's')
    mkdir(params.SavePath)
end

% Carga de base de datos mes anterior
if ~isempty(params.FullDataAnt_Name)
    full_data_ant = databank.fromCSV(params.FullDataAnt_Name);
end

list = pp_list;%params.PlotList;

%%

for rng = 1:length(params.StartDate)
for var = 1:length(list)
    
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
        MODEL.PostProc.l_sa.(strcat(list{var},'_sa')),'.-b', ...
        'LineWidth', 2 ...
        );
    
    hold on
        
    plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            MODEL.PostProc.l_bar.(strcat(list{var},'_bar')),'.-k',...
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
        
            
    if isempty(MODEL.F_pred.(list{var}).comment)
        temp_title = {};
    else
        temp_title = MODEL.F_pred.(list{var}).comment{1};
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

    
    % ----- Panel de Tabla -----
    table_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.9 - 0.10, 1, 0.10], ...
        'BackgroundColor', [1, 1, 1] ...
    );
    
    data_table = [];
    if ~isempty(params.FullDataAnt_Name)
        data_table(:, 1) = MODEL.PostProc.l_bar.(strcat(list{var},'_bar'))(params.TabRange);
        data_table(:, 2) = MODEL.PostProc.l_sa.(strcat(list{var},'_sa'))(params.TabRange);
        text_Color = [0,0,0 ; 0,0,1];
    else
        data_table(:, 1) = MODEL.PostProc.l_bar.(strcat(list{var},'_bar'))(params.TabRange);
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
axis on

% if var < 10
%     num = sprintf("0%i", var);
% else
%     num = sprintf('%i', var);
% end


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


%% GRAFICAS EN NIVELES: TCN y BM
params.LegendsNames = {MODEL.leg_act, MODEL.leg_ant};
tit ={{'Tipo de Cambio Nominal (GTQ/USD)'},{'Base Monetaria (Millones de Quetzales)'}};
list = {'s','bm'};

% Carga de datos de postprocesamiento mes anterior
temp = load('PostProcessing-2023-11.mat');
PostProcAnt = temp.temp_s;
%%
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
        MODEL.PostProc.niv_sa.(strcat(list{var},'_sa')),'.-b', ...
        'MarkerSize', 17, ...
        'LineWidth', 2 ...
        );
    
    hold on
        
    plot(...
            params.StartDate{rng}:params.EndDatePlot{rng}, ...
            PostProcAnt.niv_sa.(strcat(list{var},'_sa')),'.-r',...
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
        
    title( ...
        tit{var}, ...
        sprintf(...
        '%s - %s', ...
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

    
    % ----- Panel de Tabla -----
    table_p = uipanel( ...
        main_p, ...
        'Position', [0, 1 - 0.9 - 0.10, 1, 0.10], ...
        'BackgroundColor', [1, 1, 1] ...
    );
    
    data_table = [];
    if ~isempty(params.FullDataAnt_Name)
        data_table(:, 1) = PostProcAnt.niv_sa.(strcat(list{var},'_sa'))(params.TabRange);
        data_table(:, 2) = MODEL.PostProc.niv_sa.(strcat(list{var},'_sa'))(params.TabRange);
        text_Color = [1,0,0 ; 0,0,1];
    else
        data_table(:, 1) = PostProcAnt.niv_sa.(strcat(list{var},'_sa'))(params.TabRange);
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


