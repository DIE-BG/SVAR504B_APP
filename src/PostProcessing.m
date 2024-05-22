function MODEL = PostProcessing(MODEL, varargin)
%{
PostProcessing realiza el post procesamiento de los datos generados en los
ejercicios de simulación del SVAR50-4B. 

Ejecuta para las variables logaritmicas en 'list':
    - Ajuste por estacionalidad (X12)
    - Tendencia HP de las variables ajustadas por estacionalidad.
    - Brecha relacionada a las dos anteriores

Para las variables logaritmicas en list_niv:
    - Recuperación del nivel (exp(x/100))
    - Ajuste por estacionalidad (x12)
    - Tendencia HP de las variables ajustadas por estacionalidad.
{
## Syntax ##

    MODEL = PpostProcessing(MODEL, varargin)

## Input Arguments ##

__`MODEL`__ [ struct ] -
Debe contener al menos la estructura con los resultados del proceso de
simulación MODEL.F_pred.

* 'list' = {} [ `Cell` ] - Nombres de las variables logaritmicas para
procesar.

* 'list_niv' = {} [ `Cell` ] - Nombres de las variables logaritmicas para
reconstruir el nivel original y luego procesar.

- DIE
- Marzo 2024
- MJGM/JGOR
%}
p = inputParser;
    addParameter(p, 'list', {});
    addParameter(p, 'list_niv', {});
    addParameter(p, 'Esc', {MODEL.CORR_VER, MODEL.F_pred});
parse(p, varargin{:});
params = p.Results; 


MODEL.PostProc.(params.Esc{1}) = struct();

%% Logaritmos


temp_db = databank.copy(params.Esc{2}, params.list); 

% Logaritmos desestacionalizados
MODEL.PostProc.(params.Esc{1}).l_sa = databank.apply(@(x) x12(x, 'MaxIter=', 10000), temp_db,...
                                                    'StartsWith=','ln_',...
                                                    'Append=', '_sa',...
                                                    'RemoveSource=',true);

% Tendencias HP de los logs desestacionalizados           
MODEL.PostProc.(params.Esc{1}).l_bar = databank.apply(@(x) hpf(x),...
                                                     MODEL.PostProc.(params.Esc{1}).l_sa,...
                                                    'EndsWith=','_sa',...
                                                    'RemoveEnd=',true,...
                                                    'Append=', '_bar',...
                                                    'RemoveSource=',true);
% brechas relacionadas
for i = 1:length(params.list)
   MODEL.PostProc.(params.Esc{1}).l_gap.(strcat(params.list{i},'_gap')) = ...
                        MODEL.PostProc.(params.Esc{1}).l_sa.(strcat(params.list{i},'_sa')) - ...
                        MODEL.PostProc.(params.Esc{1}).l_bar.(strcat(params.list{i},'_bar'));   
end
%% Niveles
temp_db = databank.copy(params.Esc{2}, params.list_niv); 

% Niveles 
MODEL.PostProc.(params.Esc{1}).niv = databank.apply(@(x) exp(x/100), temp_db,...
                    'StartsWith=','ln_',...
                    'RemoveStart=', true,...
                    'RemoveSource=',true);
% Niveles desestacionalizados
MODEL.PostProc.(params.Esc{1}).niv_sa = databank.apply(@(x) x12(x),...
                                                        MODEL.PostProc.(params.Esc{1}).niv,...
                                                        'Append=', '_sa',...
                                                        'RemoveSource=',true);                
% Tendencias HP de los niveles desestacionalizados  
MODEL.PostProc.(params.Esc{1}).niv_bar = databank.apply(@(x) hpf(x),...
                                                        MODEL.PostProc.(params.Esc{1}).niv_sa,...
                                                        'EndsWith=','_sa',...
                                                        'RemoveEnd=',true,...
                                                        'Append=', '_bar',...   
                                                        'RemoveSource=',true);
                    
end