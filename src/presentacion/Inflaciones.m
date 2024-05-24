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
% Historia long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación subyacente-1.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación subyacente-12.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 

% Historia long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación subyacente-1_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación subyacente-12_short.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
         
%% Simulación
%Long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','dla_cpi_sub.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','d4_ln_cpi_sub.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 
exportToPPTX('addpicture',...
            fullfile('src','presentacion','star.png'),...
            'Position',[16.93/2.54 0/2.54 0.9/2.54 0.9/2.54]);
         
% short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','dla_cpi_sub_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','d4_ln_cpi_sub_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('src','presentacion','star.png'),...
            'Position',[16.93/2.54 0/2.54 0.9/2.54 0.9/2.54]);
        
%% Contribuciones a Inflación subyacente
if strcmp(folder_name{i}, 'v0')
        % Long
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','long', sprintf('d4_ln_cpi_sub_%s.png', MODEL.CORR_DATE_ANT)),... 
                    'Position',[0/2.54 0/2.54 16.93/2.54 17.57/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','long', sprintf('d4_ln_cpi_sub_%s.png', MODEL.CORR_DATE)),... 
                    'Position',[16.93/2.54 0/2.54 16.93/2.54 17.57/2.54]);

                
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','short', sprintf('d4_ln_cpi_sub_%s_short.png', MODEL.CORR_DATE_ANT)),...
                    'Position',[0/2.54 0/2.54 16.93/2.54 17.57/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','short', sprintf('d4_ln_cpi_sub_%s_short.png', MODEL.CORR_DATE)),... 
                    'Position',[16.93/2.54 0/2.54 16.93/2.54 17.57/2.54]);
                                
% Escenario
else
        % Long
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','long', sprintf('d4_ln_cpi_sub_%s.png', MODEL.CORR_DATE)),... 
                    'Position',[0/2.54 0/2.54 16.93/2.54 17.57/2.54]);
        
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','long',sprintf('d4_ln_cpi_sub_%s.png', 'Alterno')),...
                    'Position',[16.93/2.54 0/2.54 16.93/2.54 17.57/2.54]);  
                
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','short', sprintf('d4_ln_cpi_sub_%s_short.png', MODEL.CORR_DATE)),... 
                    'Position',[0/2.54 0/2.54 16.93/2.54 17.57/2.54]);
        
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'contributions','short',sprintf('d4_ln_cpi_sub_%s_short.png', 'Alterno')),...
                    'Position',[16.93/2.54 0/2.54 16.93/2.54 17.57/2.54]);

end

%% Contribuciones a Inflación subyacente (Primera diferencia)
if strcmp(folder_name{i}, 'v0')  
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'diff contributions','short',sprintf('d4_ln_cpi_sub_%s_short.png', MODEL.CORR_DATE_ANT)),...
                    'Position',[0/2.54 0/2.54 16.93/2.54 17.57/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'diff contributions','short', sprintf('d4_ln_cpi_sub_%s_short.png', MODEL.CORR_DATE)),... 
                    'Position',[16.93/2.54 0/2.54 16.93/2.54 17.57/2.54]);
                                
% Escenario
else
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'diff contributions','short', sprintf('d4_ln_cpi_sub_%s_short.png', MODEL.CORR_DATE)),... 
                    'Position',[0/2.54 0/2.54 16.93/2.54 17.57/2.54]);
        
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'diff contributions','short',sprintf('d4_ln_cpi_sub_%s_short.png', 'Alterno')),...
                    'Position',[16.93/2.54 0/2.54 16.93/2.54 17.57/2.54]);

end


%% Descomposición de shocks
if strcmp(folder_name{i}, 'v0')
% Long
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','long','d4_ln_cpi_sub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
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
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_sub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_sub_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

%Escenario
else
exportToPPTX('addslide');
        % Long
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,'v0',... 
                             'shock_dec','long','d4_ln_cpi_sub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','long','d4_ln_cpi_sub_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,'v0',... 
                             'shock_dec','short','d4_ln_cpi_sub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_sub_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);
end

%% Descomposición de shocks Primera Diferencia
if strcmp(folder_name{i}, 'v0')
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','diff','03_d4_ln_cpi_sub_diff_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','diff','03_d4_ln_cpi_sub_diff_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

%Escenario
else
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,'v0',... 
                             'shock_dec','diff','03_d4_ln_cpi_sub_diff_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','diff','03_d4_ln_cpi_sub_diff_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);
end  
%% Inflación No Subyacente
% Historia long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación no subyacente-1.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación no subyacente-12.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 

% Historia long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación no subyacente-1_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación no subyacente-12_short.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
         
%% Simulación
% Long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','dla_cpi_nosub.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','d4_ln_cpi_nosub.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('src','presentacion','star.png'),...
            'Position',[16.93/2.54 0/2.54 0.9/2.54 0.9/2.54]);
         
% short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','dla_cpi_nosub_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','d4_ln_cpi_nosub_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('src','presentacion','star.png'),...
            'Position',[16.93/2.54 0/2.54 0.9/2.54 0.9/2.54]);
        
%% Descomposición de shocks
if strcmp(folder_name{i}, 'v0')
        % Long
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','long','d4_ln_cpi_nosub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
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
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_nosub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_nosub_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

% Escenario
else
% Long
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date, 'v0',... 
                             'shock_dec','long','d4_ln_cpi_nosub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'shock_dec','long','d4_ln_cpi_nosub_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date, 'v0',... 
                             'shock_dec','short','d4_ln_cpi_nosub_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_nosub_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);
end

%% Descomposición de shocks Primera diferencia
if strcmp(folder_name{i}, 'v0')
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','diff','01_d4_ln_cpi_nosub_diff_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','diff','01_d4_ln_cpi_nosub_diff_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

% Escenario
else
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date, 'v0',... 
                             'shock_dec','diff','01_d4_ln_cpi_nosub_diff_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'shock_dec','diff','01_d4_ln_cpi_nosub_diff_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);
end 

%% Inflación Total
% Historia long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación total-1.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación total-12.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 

% Historia long
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación total-1_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'PreProcessing','Inflación total-12_short.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
         
% Simulación
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','dla_cpi.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','d4_ln_cpi.png'),...
             'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);                      
                     
% short
exportToPPTX('addslide');
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','dla_cpi_short.png'),...
            'Position',[0 0 16.93/2.54 17.57/2.54]);
exportToPPTX('addpicture',...
            fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                     'prediction_compared','d4_ln_cpi_short.png'),...
            'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
        
%% Descomposición de shocks
if strcmp(folder_name{i}, 'v0')
        % Long
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','long','d4_ln_cpi_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
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
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

% Escenario
else
    % Long
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date, 'v0',... 
                             'shock_dec','long','d4_ln_cpi_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'shock_dec','long','d4_ln_cpi_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date, 'v0',... 
                             'shock_dec','short','d4_ln_cpi_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'shock_dec','short','d4_ln_cpi_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

end     

%% Descomposición de shocks Primera diferencia
if strcmp(folder_name{i}, 'v0')
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_ant),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date,folder_name{i},... 
                             'shock_dec','diff','07_d4_ln_cpi_diff_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'shock_dec','diff','07_d4_ln_cpi_diff_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

% Escenario
else
        % Short
        exportToPPTX('addslide');
        exportToPPTX('addtext',sprintf('Corrimiento %s', MODEL.leg_act),...
                     'Position',[0/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18); 
        exportToPPTX('addpicture',...
                    fullfile('plots',corr_date, 'v0',... 
                             'shock_dec','diff','07_d4_ln_cpi_diff_shd_dsc.png'),... 
                    'Position',[0 2.51/2.54 16.93/2.54 14.98/2.54]);

        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE, folder_name{i},... 
                             'shock_dec','diff','07_d4_ln_cpi_diff_shd_dsc.png'),...
                    'Position',[16.93/2.54 2.51/2.54 16.93/2.54 14.98/2.54]);  
        exportToPPTX('addtext',sprintf('%s', MODEL.esc_names{i}),...
                     'Position',[17.04/2.54, 1.2/2.54, 16.93/2.54, 1.05/2.54],...
                     'HorizontalAlignment', 'center','fontsize',18);

end     

%% Componentes Inflación
if strcmp(folder_name{i}, 'v0')
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_%s.png', corr_date)),...
                    'Position',[0 0 16.93/2.54 17.57/2.54]);
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_%s.png', MODEL.CORR_DATE)),...
                     'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);

        % Componentes Inflación short
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_short_%s.png', corr_date)),...
                    'Position',[0 0 16.93/2.54 17.57/2.54]);
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_short_%s.png', MODEL.CORR_DATE)),...
                     'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);
                 
% Escenario
else
exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_%s.png', corr_date)),...
                    'Position',[0 0 16.93/2.54 17.57/2.54]);
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_%s.png', 'Alterno')),...
                     'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]);

        % Componentes Inflación short
        exportToPPTX('addslide');
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_short_%s.png', corr_date)),...
                    'Position',[0 0 16.93/2.54 17.57/2.54]);
        exportToPPTX('addpicture',...
                    fullfile('plots',MODEL.CORR_DATE,folder_name{i},... 
                             'prediction_compared',sprintf('Comp_Inf_short_%s.png', 'Alterno')),...
                     'Position',[16.93/2.54 0 16.93/2.54 17.57/2.54]); 
end
%%
% exportToPPTX( ...
%     'save', ...
%     'prueba');
% exportToPPTX('close');  