%{
Descomposición de shocks del producto doméstico
%}
if ~isfolder('otras')
    mkdir('otras')
end


shd = simulate(MODEL.MF, MODEL.F, MODEL.DATES.hist_start:MODEL.DATES.hist_end,...
               'anticipate',false, ...
                'contributions',true);       
            
listSHK = get(MODEL.MF, 'elist');
col = SimTools.from_stack_exchange.distinguishable_colors(length(listSHK) + 1, ...
    'b', ...
    @(x) SimTools.from_stack_exchange.colorspace('RGB->Lab',x));

figure('Position', [1 42.0182 1.6756e+03 825.6000]);
hold on

barcon(shd.d4_ln_y{:, 1:end-2},...
            'dateFormat=','YYFP', ...
        'colorMap=',col, ...
        'evenlySpread=', false);
   
 
% Líneas
    plot(MODEL.F_pred.d4_ln_y{qq(2005,1):qq(2023,1)}- shd.d4_ln_y{:, end-1:end-1}{qq(2005,1):qq(2023,1)},'w','LineWidth',5)
    plot(MODEL.F_pred.d4_ln_y{qq(2005,1):qq(2023,1)}- shd.d4_ln_y{:, end-1:end-1}{qq(2005,1):qq(2023,1)},'k.-','LineWidth',2, 'MarkerSize', 20)
    %titulo
    set(gca,'FontSize',12);       
    title({'Producto','d4_ln_y'}, 'Interpreter', 'none');
%     % Leyendas
    legend(listSHK(1:end),'location','northeastoutside','FontSize',11, 'Interpreter', 'none')
    grid on;

saveas(gcf, ...
            fullfile('plots',...
            MODEL.CORR_DATE, MODEL.CORR_VER,...
            'otras',...
            'd4_ln_y.png'))%,...
%              'AutoSave', true);
        
        

