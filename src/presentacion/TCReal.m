% isOpen  = exportToPPTX();
% if ~isempty(isOpen)
%     % If PowerPoint already started, then close first and then open a new one
%     exportToPPTX('close');
% end
% 
% exportToPPTX('open',fullfile('presentacion','dieTemplate.pptx'));

%% Encabezado

exportToPPTX('addslide','Layout','Encabezado de sección');
exportToPPTX('addtext','Tipo de Cambio Real','Position','title','fontsize',48);

%% TCR
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'PostProcessing','ln_z.png'),...
            'Position',[0 0 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'PostProcessing','ln_z_gap.png'),...
            'Position',[0 8.78/2.54 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_z.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_z.png'),...
            'Position',[16.93/2.54 8.78/2.54 16.93/2.54 8.79/2.54]);

%% TCR SHORT
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'PostProcessing','ln_z_short.png'),...
            'Position',[0 0 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'PostProcessing','ln_z_gap_short.png'),...
            'Position',[0 8.78/2.54 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_z_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 8.79/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_z_short.png'),...
            'Position',[16.93/2.54 8.78/2.54 16.93/2.54 8.79/2.54]);
        
        
%% TCR SUBPLOT
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'otras','TC_real_subplot.png'),...
            'Position',[3.25/2.54 0 27.38/2.54 17.55/2.54]); 

% TCR SUBPLOT short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'otras','TC_real_subplot_short.png'),...
            'Position',[3.25/2.54 0 27.38/2.54 17.55/2.54]); 
%% TCR Componentes por corrimiento
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'otras','Tipo de cambio real (componentes)ant.png'),... 
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'otras','Tipo de cambio real (componentes)act.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);  

% TCR Componentes por corrimiento short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'otras','Tipo de cambio real (componentes)ant_short.png'),... 
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'otras','Tipo de cambio real (componentes)act_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);  

%% Descomposición de shocks

% Long
exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_z_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_z_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);
% Short
exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','short','d4_ln_z_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','short','d4_ln_z_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);


%%
% exportToPPTX( ...
%     'save', ...
%     'prueba');
% exportToPPTX('close');  