%% Inicializacion de presentacion
isOpen  = exportToPPTX();
if ~isempty(isOpen)
    % If PowerPoint already started, then close first and then open a new one
    exportToPPTX('close');
end

exportToPPTX('open',fullfile('presentacion','dieTemplate.pptx'));

%% Diapositiva de título
exportToPPTX('addslide','Master',1,'Layout','Diapositiva de título');
exportToPPTX('addtext',{'Modelo SVAR50-4B', sprintf('Corrimiento %s: Libre',MODEL.leg_act)},...
            'Position','Title','fontsize',45);
exportToPPTX('addtext',{'DEPARTAMENTO DE INVESTIGACIONES ECONÓMICAS','BANCO DE GUATEMALA'},...
             'Position','Subtitle','fontsize',20);
exportToPPTX('addtext',sprintf('%s', dat2char(ddtoday)),...
             'Position',[7.00/2.54, 14.45/2.54, 20.75/2.54, 1.05/2.54],...
             'HorizontalAlignment', 'center','fontsize',15);       
         
%% CONTENIDO
exportToPPTX('addslide','Layout','Título y objetos');
exportToPPTX('addtext','CONTENIDO','Position',...
             'Title','fontsize',36,...
             'HorizontalAlignment','Left');
exportToPPTX('addtext',{...         
            sprintf('\t Variables Externas'),...
            sprintf('\t Tipo de Cambio Real'),...
            sprintf('\t Tipo de Cambio Nominal'),...
            sprintf('\t Inflación'),...            
            sprintf('\t Tasa de Interés'),...
            sprintf('\t Crecimiento Interno'),...
            sprintf('\t Base Monetaria'),...
            sprintf('\t Velocidad de Circulación de la Base Monetaria')},...
            'Position','content','fontsize',22);%

%% secciones
VarExt;     
TCReal;
TCNominal;
Inflaciones;
TasasInteres;
Crecimiento;
BM_Vel;

if esc_alt == true
    EscAltPres;
end   
    
    
%%
exportToPPTX('addslide','Layout','Encabezado de sección');
exportToPPTX('addtext','Muchas Gracias','Position','title','fontsize',48);

%% Guardar y cerrar
exportToPPTX( ...
    'save', ...
    fullfile(sprintf('SVAR50-4B Corrimiento %s', MODEL.CORR_DATE)));
exportToPPTX('close');   


