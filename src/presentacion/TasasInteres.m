% isOpen  = exportToPPTX();
% if ~isempty(isOpen)
%     % If PowerPoint already started, then close first and then open a new one
%     exportToPPTX('close');
% end
% 
% exportToPPTX('open',fullfile('presentacion','dieTemplate.pptx'));

%% Encabezado

exportToPPTX('addslide','Layout','Encabezado de sección');
exportToPPTX('addtext','Tasa de Interés','Position','title','fontsize',48);

%% Tasa líder
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','i.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','i_short.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 
         
%% Descomposición de shocks

% Long
exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','long','i_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','long','i_shd_dsc.png'),...
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
                     'shock_dec','short','i_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','short','i_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);
%% Tasa Real

exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','r.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','r_short.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 
%% Descomposición de shocks

% Long
exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','long','r_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','long','r_shd_dsc.png'),...
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
                     'shock_dec','short','r_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','short','r_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);

%% componentes R
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_R_%s.png', MODEL.CORR_DATE_ANT)),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_R_%s.png', MODEL.CORR_DATE)),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
         
% Componentes R short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_R_short_%s.png', MODEL.CORR_DATE_ANT)),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_R_short_%s.png', MODEL.CORR_DATE)),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
%%
% exportToPPTX( ...
%     'save', ...
%     'prueba');
% exportToPPTX('close');  