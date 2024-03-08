%%% SVAR50-4B
%{

This version includes:

SVAR Endogenous block
Additional identities
Log-levels 
4Q-MovSum for GDP's
Annualized QoQ Growth Rates

DIE -04/03/2024
MJGM
%}

!transition_variables
% Log levels
'PIB Externo (100*log)'                                         ln_y_star, %1
'PIB Externo, Suma movil de 4 trimestres (100*log)'             ln_y_star_sm, %2
'Precios de transables (100*log)'                               ln_ipei, %3
'Indice de inflacion No subyacente'                             ln_cpi_nosub, %4
'PIB Real (100*log)'                                            ln_y, %5
'PIB Real, Suma movil de 4 trimestres (100*log)'                ln_y_sm, %6
'Indice Subyacente Optima MSE (100*log)'                        ln_cpi_sub, %7
'Tipo de Cambio Nominal (100*log)'                              ln_s, %8
'Base Monetaria (100*log)'                                      ln_bm, %9
'Indice de Precios al Consumidor (100*log)'                     ln_cpi, %10
'Indice Tipo de Cambio Real (100*log)'                          ln_z, %11
'Velocidad de circulacion, nivel'                               ln_v, %12
'Precios de transables en GTQ(100*log)'                         ln_ipei_q,

% YoY Growth rates
'Crecimiento Economico Externo (%)'                             d4_ln_y_star, %13
'Crecimiento Economico Externo - Suma Movil 4T (%)'             d4_ln_y_star_sm, %14
'Precios de transables YoY (%)'                                 d4_ln_ipei, %15
'Tasa de fondos federales'                                      i_star, %16
'Inflacion No Subyacente (YoY %)'                               d4_ln_cpi_nosub, %17
'Crecimiento Economico Inrterno (%)'                            d4_ln_y, %18
'Crecimiento Economico Inrterno - Suma Movil 4T (%)'            d4_ln_y_sm, %19
'Inflación Subyacente Optima MSE (YoY %)'                       d4_ln_cpi_sub, %20
'Depreciacion Cambiaria Nominal (YoY %)'                        d4_ln_s, %21
'Tasa de variacion de la Base Monetaria (YoY %)'                d4_ln_bm, %22 
'Tasa de Interes Lider de Politica Monetaria'                   i, %23
'Inflacion Total Internual (YoY %)'                             d4_ln_cpi, %24
'Tasa de variacion del Tipo de Cambio Real (YoY)'               d4_ln_z, %25
'Velocidad de circulacion (YoY %)'                              d4_ln_v, %26
'Tasa de interes real de PM'                                    r, %27
'Precios de transables en GTQ YoY (%)'                          d4_ln_ipei_q,

% Annualized QoQ Growth rates
'Precios de transables QoQ (%)'                                 dla_ipei, %28
'Tasa de variacion del Tipo de Cambio Real (QoQ)'               dla_z, %29
'Depreciacion Cambiaria Nominal (QoQ %)'                        dla_s, %30
'Inflacion No Subyacente QoQ (%)'                               dla_cpi_nosub, %31
'Inflacion Subyacente Optima MSE (QoQ %)'                       dla_cpi_sub, %32
'Inflacion Total Internual (QoQ %)'                             dla_cpi, %33
'Tasa de variacion de la Base Monetaria (QoQ %)'                dla_bm, %34
'Velocidad de circulacion (YoY %)'                              dla_v, %35
'Precios de transables en GTQ QoQ (%)'                          dla_ipei_q

!transition_shocks
'Shock de crecimiento externo'      s_d4_ln_y_star,
'Shock de precios de transables'    s_d4_ln_ipei,
'Shock de tasa de interes externa'  s_i_star,
'Choque de inflacion no subyacente' s_d4_ln_cpi_nosub,
'Choque de demanda agregada'        s_d4_ln_y,
'Choque de inflacion subyacente'    s_d4_ln_cpi_sub,
'Choque cambiario nominal'          s_d4_ln_s,
'Choque monetario'                  s_d4_ln_bm,
'Choque de Politica Monetaria'      s_i

!parameters 
% steady States
d4_ln_y_star_ss, 
d4_ln_ipei_ss, 
i_star_ss, 
d4_ln_cpi_nosub_ss, 
d4_ln_y_ss, 
d4_ln_cpi_sub_ss, 
d4_ln_s_ss, 
d4_ln_bm_ss, 
i_ss, 
d4_ln_cpi_ss,
d4_ln_z_ss, 
d4_ln_v_ss,
r_ss

%%%% SVAR PARAMETERS %%%%
% Constants
k1, k2, k3, k4, k5, k6, k7, k8, k9,

% Gamma0 Matrix
g_0_11, g_0_12, g_0_13, g_0_14, g_0_15, g_0_16, g_0_17, g_0_18, g_0_19,
g_0_21, g_0_22, g_0_23, g_0_24, g_0_25, g_0_26, g_0_27, g_0_28, g_0_29,
g_0_31, g_0_32, g_0_33, g_0_34, g_0_35, g_0_36, g_0_37, g_0_38, g_0_39,
g_0_41, g_0_42, g_0_43, g_0_44, g_0_45, g_0_46, g_0_47, g_0_48, g_0_49,
g_0_51, g_0_52, g_0_53, g_0_54, g_0_55, g_0_56, g_0_57, g_0_58, g_0_59,
g_0_61, g_0_62, g_0_63, g_0_64, g_0_65, g_0_66, g_0_67, g_0_68, g_0_69,
g_0_71, g_0_72, g_0_73, g_0_74, g_0_75, g_0_76, g_0_77, g_0_78, g_0_79,
g_0_81, g_0_82, g_0_83, g_0_84, g_0_85, g_0_86, g_0_87, g_0_88, g_0_89,
g_0_91, g_0_92, g_0_93, g_0_94, g_0_95, g_0_96, g_0_97, g_0_98, g_0_99,
% Gamma1 Matrix
g_1_11, g_1_12, g_1_13, g_1_14, g_1_15, g_1_16, g_1_17, g_1_18, g_1_19,
g_1_21, g_1_22, g_1_23, g_1_24, g_1_25, g_1_26, g_1_27, g_1_28, g_1_29,
g_1_31, g_1_32, g_1_33, g_1_34, g_1_35, g_1_36, g_1_37, g_1_38, g_1_39,
g_1_41, g_1_42, g_1_43, g_1_44, g_1_45, g_1_46, g_1_47, g_1_48, g_1_49,
g_1_51, g_1_52, g_1_53, g_1_54, g_1_55, g_1_56, g_1_57, g_1_58, g_1_59,
g_1_61, g_1_62, g_1_63, g_1_64, g_1_65, g_1_66, g_1_67, g_1_68, g_1_69,
g_1_71, g_1_72, g_1_73, g_1_74, g_1_75, g_1_76, g_1_77, g_1_78, g_1_79,
g_1_81, g_1_82, g_1_83, g_1_84, g_1_85, g_1_86, g_1_87, g_1_88, g_1_89,
g_1_91, g_1_92, g_1_93, g_1_94, g_1_95, g_1_96, g_1_97, g_1_98, g_1_99,

!transition_equations
% Log-Levels
ln_y_star = ln_y_star{-4} + d4_ln_y_star; %1
ln_y_star_sm = movsum(ln_y_star, -4); %2
ln_ipei = ln_ipei{-4} + d4_ln_ipei; %3
ln_y = ln_y{-4} + d4_ln_y; %4
ln_y_sm = movsum(ln_y, -4); %5
ln_cpi_sub = ln_cpi_sub{-4} + d4_ln_cpi_sub;%6
ln_cpi_nosub = ln_cpi_nosub{-4} + d4_ln_cpi_nosub; %7
ln_s = ln_s{-4} + d4_ln_s; %8
ln_bm = ln_bm{-4} + d4_ln_bm; %9
ln_cpi = ln_cpi{-4} + d4_ln_cpi; %10
ln_z = ln_z{-4} + d4_ln_z; %11
ln_v = ln_v{-4} + d4_ln_v; %12
ln_ipei_q = ln_ipei + ln_s;

% MovSum and other YoY Growth rates
d4_ln_y_star_sm = 1/4*(ln_y_star_sm - ln_y_star_sm{-4}); %13
d4_ln_y_sm = 1/4*(ln_y_sm - ln_y_sm{-4}); %14
d4_ln_ipei_q = ln_ipei_q - ln_ipei_q{-4};


% Annualized QoQ Growth rates
dla_ipei = 4*(ln_ipei - ln_ipei{-1}); %15
dla_cpi_sub = 4*(ln_cpi_sub - ln_cpi_sub{-1}); %16
dla_cpi_nosub = 4*(ln_cpi_nosub - ln_cpi_nosub{-1}); %17
dla_s = 4*(ln_s - ln_s{-1}); %19
dla_bm = 4*(ln_bm - ln_bm{-1}); %20
dla_cpi = 4*(ln_cpi - ln_cpi{-1}); %21
dla_z = 4*(ln_z - ln_z{-1}); %22
dla_v = 4*(ln_v - ln_v{-1}); %23
dla_ipei_q = 4*(ln_ipei_q - ln_ipei_q{-1});


% Theorical identities 
% Headline Inflation 
(d4_ln_cpi - d4_ln_cpi_ss) =   (d4_ln_cpi_nosub - d4_ln_cpi_nosub_ss) ...
                             + (d4_ln_cpi_sub - d4_ln_cpi_sub_ss); %24
                         
% Real Exchange Rate
(d4_ln_z - d4_ln_z_ss) =  (d4_ln_s - d4_ln_s_ss) ...
                        + (d4_ln_ipei - d4_ln_ipei_ss) ... 
                        - (d4_ln_cpi_sub - d4_ln_cpi_sub_ss); %25
% Money vel
(d4_ln_v - d4_ln_v_ss) =  (d4_ln_cpi_sub - d4_ln_cpi_sub_ss) ...
                        + (d4_ln_y - d4_ln_y_ss) ...
                        - (d4_ln_bm - d4_ln_bm_ss); %26
% Real Interest Rate
(r - r_ss) = (i - i_ss) - (d4_ln_cpi_sub{+4} - d4_ln_cpi_sub_ss); %27



%%%%%%%%%%%%%%%% SVAR Endogeouns block (9 Equations) %%%%%%%%%%%%%%%%%%%%%

% Foreign Output
g_0_11 * d4_ln_y_star + ...
g_0_12 * d4_ln_ipei + ...
g_0_13 * i_star + ...
g_0_14 * d4_ln_cpi_nosub + ...
g_0_15 * d4_ln_y + ...
g_0_16 * d4_ln_cpi_sub + ...
g_0_17 * d4_ln_s + ...
g_0_18 * d4_ln_bm +
g_0_19 * i = ...
k1 + ...
g_1_11 * d4_ln_y_star{-1} + ...
g_1_12 * d4_ln_ipei{-1} + ...
g_1_13 * i_star{-1} + ...
g_1_14 * d4_ln_cpi_nosub{-1} + ...
g_1_15 * d4_ln_y{-1} + ...
g_1_16 * d4_ln_cpi_sub{-1} + ...
g_1_17 * d4_ln_s{-1} + ...
g_1_18 * d4_ln_bm{-1} + ...
g_1_19 * i{-1} + ...
s_d4_ln_y_star;

% Import Prices
g_0_21 * d4_ln_y_star + ...
g_0_22 * d4_ln_ipei + ...
g_0_23 * i_star + ...
g_0_24 * d4_ln_cpi_nosub + ...
g_0_25 * d4_ln_y + ...
g_0_26 * d4_ln_cpi_sub + ...
g_0_27 * d4_ln_s + ...
g_0_28 * d4_ln_bm + ...
g_0_29 * i = ...
k2 + ...
g_1_21 * d4_ln_y_star{-1} + ...
g_1_22 * d4_ln_ipei{-1} + ...
g_1_23 * i_star{-1} + ...
g_1_24 * d4_ln_cpi_nosub{-1} + ...
g_1_25 * d4_ln_y{-1} + ...
g_1_26 * d4_ln_cpi_sub{-1} + ...
g_1_27 * d4_ln_s{-1} + ...
g_1_28 * d4_ln_bm{-1} + ...
g_1_29 * i{-1} + ...
s_d4_ln_ipei;

% Federal Fuds Rate
g_0_31 * d4_ln_y_star + ...
g_0_32 * d4_ln_ipei + ...
g_0_33 * i_star + ...
g_0_34 * d4_ln_cpi_nosub + ...
g_0_35 * d4_ln_y + ...
g_0_36 * d4_ln_cpi_sub + ...
g_0_37 * d4_ln_s + ...
g_0_38 * d4_ln_bm + ...
g_0_39 * i = ...
k3 + ...
g_1_31 * d4_ln_y_star{-1} + ...
g_1_32 * d4_ln_ipei{-1} + ...
g_1_33 * i_star{-1} + ...
g_1_34 * d4_ln_cpi_nosub{-1} + ...
g_1_35 * d4_ln_y{-1} + ...
g_1_36 * d4_ln_cpi_sub{-1} + ...
g_1_37 * d4_ln_s{-1} + ...
g_1_38 * d4_ln_bm{-1} + ...
g_1_39 * i{-1} + ...
s_i_star;

% Non-core Inflation
g_0_41 * d4_ln_y_star + ...
g_0_42 * d4_ln_ipei + ...
g_0_43 * i_star + ...
g_0_44 * d4_ln_cpi_nosub + ...
g_0_45 * d4_ln_y + ...
g_0_46 * d4_ln_cpi_sub + ...
g_0_47 * d4_ln_s + ...
g_0_48 * d4_ln_bm + ...
g_0_49 * i = ...
k4 + ...
g_1_41 * d4_ln_y_star{-1} + ...
g_1_42 * d4_ln_ipei{-1} + ...
g_1_43 * i_star{-1} + ...
g_1_44 * d4_ln_cpi_nosub{-1} + ...
g_1_45 * d4_ln_y{-1} + ...
g_1_46 * d4_ln_cpi_sub{-1} + ...
g_1_47 * d4_ln_s{-1} + ...
g_1_48 * d4_ln_bm{-1} + ...
g_1_49 * i{-1} + ...
s_d4_ln_cpi_nosub;

% Real GDP Growth
g_0_51 * d4_ln_y_star + ...
g_0_52 * d4_ln_ipei + ...
g_0_53 * i_star + ...
g_0_54 * d4_ln_cpi_nosub + ...
g_0_55 * d4_ln_y + ...
g_0_56 * d4_ln_cpi_sub + ...
g_0_57 * d4_ln_s + ...
g_0_58 * d4_ln_bm + ...
g_0_59 * i = ...
k5 + ...
g_1_51 * d4_ln_y_star{-1} + ...
g_1_52 * d4_ln_ipei{-1} + ...
g_1_53 * i_star{-1} + ...
g_1_54 * d4_ln_cpi_nosub{-1} + ...
g_1_55 * d4_ln_y{-1} + ...
g_1_56 * d4_ln_cpi_sub{-1} + ...
g_1_57 * d4_ln_s{-1} + ...
g_1_58 * d4_ln_bm{-1} + ...
g_1_59 * i{-1} + ...
s_d4_ln_y;

% Core Inflation
g_0_61 * d4_ln_y_star + ...
g_0_62 * d4_ln_ipei + ...
g_0_63 * i_star + ...
g_0_64 * d4_ln_cpi_nosub + ...
g_0_65 * d4_ln_y + ...
g_0_66 * d4_ln_cpi_sub + ...
g_0_67 * d4_ln_s + ...
g_0_68 * d4_ln_bm + ...
g_0_69 * i = ...
k6 + ...
g_1_61 * d4_ln_y_star{-1} + ...
g_1_62 * d4_ln_ipei{-1} + ...
g_1_63 * i_star{-1} + ...
g_1_64 * d4_ln_cpi_nosub{-1} + ...
g_1_65 * d4_ln_y{-1} + ...
g_1_66 * d4_ln_cpi_sub{-1} + ...
g_1_67 * d4_ln_s{-1} + ...
g_1_68 * d4_ln_bm{-1} + ...
g_1_69 * i{-1} + ...
s_d4_ln_cpi_sub;


% Nominal Exchange Rate
g_0_71 * d4_ln_y_star + ...
g_0_72 * d4_ln_ipei + ...
g_0_73 * i_star + ...
g_0_74 * d4_ln_cpi_nosub + ...
g_0_75 * d4_ln_y + ...
g_0_76 * d4_ln_cpi_sub + ...
g_0_77 * d4_ln_s + ...
g_0_78 * d4_ln_bm + ...
g_0_79 * i = ...
k7 + ...
g_1_71 * d4_ln_y_star{-1} + ...
g_1_72 * d4_ln_ipei{-1} + ...
g_1_73 * i_star{-1} + ...
g_1_74 * d4_ln_cpi_nosub{-1} + ...
g_1_75 * d4_ln_y{-1} + ...
g_1_76 * d4_ln_cpi_sub{-1} + ...
g_1_77 * d4_ln_s{-1} + ...
g_1_78 * d4_ln_bm{-1} + ...
g_1_79 * i{-1} + ...
s_d4_ln_s;

% Money Base
g_0_81 * d4_ln_y_star + ...
g_0_82 * d4_ln_ipei + ...
g_0_83 * i_star + ...
g_0_84 * d4_ln_cpi_nosub + ...
g_0_85 * d4_ln_y + ...
g_0_86 * d4_ln_cpi_sub + ...
g_0_87 * d4_ln_s + ...
g_0_88 * d4_ln_bm + ...
g_0_89 * i = ...
k8 + ...
g_1_81 * d4_ln_y_star{-1} + ...
g_1_82 * d4_ln_ipei{-1} + ...
g_1_83 * i_star{-1} + ...
g_1_84 * d4_ln_cpi_nosub{-1} + ...
g_1_85 * d4_ln_y{-1} + ...
g_1_86 * d4_ln_cpi_sub{-1} + ...
g_1_87 * d4_ln_s{-1} + ...
g_1_88 * d4_ln_bm{-1} + ...
g_1_89 * i{-1} + ...
s_d4_ln_bm;

% Monetary Policy Rate
g_0_91 * d4_ln_y_star + ...
g_0_92 * d4_ln_ipei + ...
g_0_93 * i_star + ...
g_0_94 * d4_ln_cpi_nosub + ...
g_0_95 * d4_ln_y + ...
g_0_96 * d4_ln_cpi_sub + ...
g_0_97 * d4_ln_s + ...
g_0_98 * d4_ln_bm + ...
g_0_99 * i = ...
k9 + ...
g_1_91 * d4_ln_y_star{-1} + ...
g_1_92 * d4_ln_ipei{-1} + ...
g_1_93 * i_star{-1} + ...
g_1_94 * d4_ln_cpi_nosub{-1} + ...
g_1_95 * d4_ln_y{-1} + ...
g_1_96 * d4_ln_cpi_sub{-1} + ...
g_1_97 * d4_ln_s{-1} + ...
g_1_98 * d4_ln_bm{-1} + ...
g_1_99 * i{-1} + ...
s_i;

!measurement_variables
m_ln_y_star,
m_ln_ipei,
m_i_star,
m_ln_y,
m_ln_cpi_sub,
m_ln_s, 
m_ln_bm,
m_i,
m_ln_cpi

!measurement_equations
m_ln_y_star = ln_y_star;
m_ln_ipei = ln_ipei;
m_i_star = i_star;
m_ln_y = ln_y;
m_ln_cpi_sub = ln_cpi_sub;
m_ln_s = ln_s;
m_ln_bm = ln_bm;
m_i = i;
m_ln_cpi = ln_cpi;

