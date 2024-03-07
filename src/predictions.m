function MODEL = predictions(MODEL, varargin)
%{
    Prediciones en base a la estructura del modelo.
    Utiliza como condiciones iniciales los datos provenientes del filtro
    del Kalman
%}

p = inputParser;
    addParameter(p, 'PredRange', MODEL.DATES.pred_start:MODEL.DATES.pred_end);
    addParameter(p, 'SaveFullData', false);
    addParameter(p, 'DataBase', {});
parse(p, varargin{:});
params = p.Results; 

s = simulate(MODEL.M, MODEL.F, params.PredRange, 'anticipate', false,...
            'DbOverlay=', true);

MODEL.F_pred = s;
MODEL.F_pred = MODEL.F_pred*(get(MODEL.M, 'xlist') + get(MODEL.M, 'elist'));
% Exportando
% añadiendo el fin de historia
names = fieldnames(MODEL.F_pred);
for i = 1:length(names)
    MODEL.F_pred.(names{i}).UserData.endhist = dat2char(MODEL.DATES.hist_end);
end

if params.SaveFullData
   temp_pred = MODEL.F_pred;
   databank.toCSV(temp_pred, MODEL.FULLDATANAME_ACT, Inf, 'Decimals=', 5, 'UserDataFields=', 'endhist');
end
end