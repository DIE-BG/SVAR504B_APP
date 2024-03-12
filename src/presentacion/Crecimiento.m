% isOpen  = exportToPPTX();
% if ~isempty(isOpen)
%     % If PowerPoint already started, then close first and then open a new one
%     exportToPPTX('close');
% end
% 
% exportToPPTX('open',fullfile('presentacion','dieTemplate.pptx'));

%% Encabezado

exportToPPTX('addslide','Layout','Encabezado de sección');
exportToPPTX('addtext','Crecimiento Interno','Position','title','fontsize',48);

%%
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'PreProcessing','Producto de Estados Unidos.png'),... %%%%% ACTUALIZAR
            'Position',[3.25/2.54 0 27.38/2.54 17.55/2.54]); 
        
% Simulacion
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'PostProcessing','ln_y.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_y.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_y_sm.png'),...
            'Position',[16.93/2.54 8.78/2.54 16.93/2.54 8.79/2.54]);
% simulación short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'PostProcessing','ln_y_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_y_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_y_sm_short.png'),...
            'Position',[16.93/2.54 8.78/2.54 16.93/2.54 8.79/2.54]);

%% Descomposición de shocks
exportToPPTX('addslide');

exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','01_d4_ln_y_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','01_d4_ln_y_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);
         
%%
% exportToPPTX( ...
%     'save', ...
%     'prueba');
% exportToPPTX('close');  