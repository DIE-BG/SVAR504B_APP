% clear; clc;
%% MODELO
%{

%}

%% Creación de modelo y parametrización
% Carga de parametrización
run('SVAR50/setparam');
% Creación del objeto modelo (todo dentro de estructura MODEL)
MODEL.M = model('SVAR50L.mod', 'assign', s, 'growth=', true);
% Estados estacioanrios del sistema
MODEL.M = sstate(MODEL.M,'growth=',true,'MaxFunEvals',1000,'display=','off');
% Sanity-Check de estados estacionarios impuestos
[flag,~,~] = chksstate(MODEL.M);
% Solución del modelo
MODEL.M = solve(MODEL.M,'error=',true);