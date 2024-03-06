clear all;
clc;
%% Carga Modelo
read_SVAR50L;

%%
% Lista de variables del SVAR50-4B
list50 = get(MODEL.M, 'xlist');

shocks50 = get(MODEL.M, 'elist');

listt = {'Foreign GDP Shock', 'Import Prices Shock', 'Foreing Interest Rate',...
             'Non Core Inflation Shock', 'Aggregate Demand Shock', 'Core Inflation Shock',...
             'Exchange Rate Shock','Monetary Shock', 'Interest Rate Shock'};
vars = {'d4_ln_y_star', 'd4_ln_ipei', 'i_star', 'd4_ln_cpi_nosub',...
            'd4_ln_y','d4_ln_cpi_sub', 'd4_ln_s', 'd4_ln_bm', 'i', ...
             'd4_ln_cpi', 'd4_ln_z', 'd4_ln_v','r'};
listv = {'Foreign Output', 'Import price inflation', 'Foreign Nominal Interest Rate',...
         'Non Core Inflation','Output', 'Core Inflation', 'Nom Exchange Rate Deprec',...
         'Monetary Base', 'Nom. Policy Interest Rate', 'Inflation', 'Real Exchange Rate Deprec',...
         'Money Velocity', 'Real Policy Interest Rate'};          
%%

startsim = 1;%qq(1,1);
endsim = 40;%qq(10,4); % four-year simulation horizon

for i = 1:length(shocks50)
    % Base de datos en cero para cada simulación
    ds.(shocks50{i}) = zerodb(MODEL.M,startsim-4:endsim);
    % Definición del shock y su tamaño (igual para todos)
    ds.(shocks50{i}).(shocks50{i})(startsim) = 1;% MODEL.s_vector(i);%1;
    % Simulación
    ss.(shocks50{i}) = simulate(MODEL.M,ds.(shocks50{i}),startsim:endsim,'deviation',true);
    % concatenado de bases de datos
    ss.(shocks50{i}) = dbextend(ds.(shocks50{i}),ss.(shocks50{i}));
end


%%
% Referencia para el tamaño de la grilla de graficado
sp = ceil(length(vars)/4);

for i = 9%1:length(shocks50)
   
    % Gráfica
    plotrng = startsim-4:endsim;
    figure('Position', [1 42.0181818181818 1675.63636363636 825.6])
    
    % Subplots por variable
    for j=1:length(vars)
        subplot(sp,sp,j);
        h = plot(plotrng, [ss.(shocks50{i}).(vars{j})]);%, ss.(shocks50{i}).(list50{j})]);%, '.-b','linewidth',2, 'color','k'); grid on;
        set(h(1), 'color','r','display','QPM');
%         set(h(2), 'color','b','display','SVAR50-4B')
        legend('location','best');
        % Titulo figura
        sgtitle(sprintf(listt{i}));
        % Titulos subplots
        title(listv{j}, 'interpreter', 'none');
        xlabel('Horizonte', 'Fontsize', 9);
%         xline(startSim, 'LineStyle', '-', 'LineWidth', 1);
        highlight(startsim-4:startsim-1);
        zeroline();
        
    end
    
    % Almacenamiento de figura
%     saveas(gcf, ...
%         fullfile('Graf_IRF',...
%         sprintf( "%s_%s.png", num2str(i), listQPM{i}))...
%         );
% close all;    
end