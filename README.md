# SVAR504B_APP
 Deployment SVAR50-4B

Herramienta de Corrimientos: SVAR50-4B<br>
Sim: branch->  modelo-con-variables-de-medida.

Modelo: SVAR50-4B Redefinido con observables en niveles. La estructura
endogena principal (9 variables/ecuaciones) se mantiene.

Estructura:
 - PreProcessing: 
    - Carga de datos primitivos (en el nivel y frecuencia de la fuente). 
    - Cálculos y transformaciones de frecuencia para gráficas de preprocesamiento
      y generación de base de datos con variables observables (ver .mod).
  - Filtrado:
    - Con base en la base de datos de observables generadas en PreProcessing 
    se utiliza el filtro de Kalman para recuperar el resto de variables y 
    generar la base de datos de condiciones iniciales para la simulación.
 - Simulación: 
    - Utiliza la base de datos filtrada (kalman) para generar los pronósticos del
    modelo, los cuales incluyen:<br>
            - Niveles (logaritmos)<br>
            - Sumas móviles de de 4T los Productos interno y externo.<br>
            - Tasas de variación intertrimestral anualizadas.<br>
            - Tasas de variación interanual. <br>
 - PostProcessing:
    - Genera los cálculos posteriores que no es posible hacer dentro de la
    estructura del modelo para un subgrupo de variables:<br>
            - Desestacionalización (X12)<br>
            - Calculo de brechas y tendencias (HP, lambda=1600)<br>

Posterior a los procesos de tratamiento de datos y simulación se generan
las descomposiciones de shocks, gráficas y presentación correspondientes.

Nota: Derivado del cambio en el planteamiento del modelo estado-espacio no
fue posible utilizar todas las funciones de Sim en el proceso de
corrimiento

Departamento de Investigaciones Económicas - 2024.
MJGM/JGOR