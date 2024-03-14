% isOpen  = exportToPPTX();
% if ~isempty(isOpen)
%     % If PowerPoint already started, then close first and then open a new one
%     exportToPPTX('close');
% end
% 
% exportToPPTX('open',fullfile('presentacion','dieTemplate.pptx'));

%%  Encabezado

exportToPPTX('addslide','Layout','Encabezado de sección');
exportToPPTX('addtext','Inflación','Position','title','fontsize',48);


%% Inflación Subyacente
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_cpi_sub.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_cpi_sub.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 
% short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_cpi_sub_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_cpi_sub_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 
%% Descomposición de shocks

% Long
exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_cpi_sub_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_cpi_sub_shd_dsc.png'),...
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
                     'shock_dec','short','d4_ln_cpi_sub_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','short','d4_ln_cpi_sub_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);
         
%% Inflación No Subyacente
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_cpi_nosub.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_cpi_nosub.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);                      
% short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_cpi_nosub_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_cpi_nosub_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);

%% Descomposición de shocks

% Long
exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_cpi_nosub_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_cpi_nosub_shd_dsc.png'),...
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
                     'shock_dec','short','d4_ln_cpi_nosub_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','short','d4_ln_cpi_nosub_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);
         
%% Inflación Total
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_cpi.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_cpi.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);                      
                     
% short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','dla_cpi_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared','d4_ln_cpi_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
        
%% Descomposición de shocks

% Long
exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
             'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18); 
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE_ANT,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_cpi_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','long','d4_ln_cpi_shd_dsc.png'),...
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
                     'shock_dec','short','d4_ln_cpi_shd_dsc.png'),... 
            'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'shock_dec','short','d4_ln_cpi_shd_dsc.png'),...
            'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
             'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',18);

         
%% Componentes Inflación
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_Inf_%s.png', MODEL.CORR_DATE_ANT)),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_Inf_%s.png', MODEL.CORR_DATE)),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
         
% Componentes Inflación short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_Inf_short_%s.png', MODEL.CORR_DATE_ANT)),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,MODEL.CORR_VER,... 
                     'prediction_compared',sprintf('Comp_Inf_short_%s.png', MODEL.CORR_DATE)),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);



%%
% exportToPPTX( ...
%     'save', ...
%     'prueba');
% exportToPPTX('close');  