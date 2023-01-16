-- -------------------------------------------------------------
-- 
-- File Name: tp_vivado\hdlsrc\main\rconversor_uart_uint.vhd
-- Created: 2022-12-09 14:11:09
-- 
-- Generated by MATLAB 9.13 and HDL Coder 4.0
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: rconversor_uart_uint
-- Source Path: main/Subsystem/rconversor_uart_uint
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.Subsystem_pkg.ALL;

ENTITY rconversor_uart_uint IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        pulsos                            :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        pulsos_2                          :   IN    std_logic_vector(15 DOWNTO 0);  -- uint16
        RXD                               :   IN    std_logic;  -- ufix1
        flanco                            :   IN    std_logic;
        Fin                               :   OUT   std_logic;
        Salida                            :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END rconversor_uart_uint;


ARCHITECTURE rtl OF rconversor_uart_uint IS

  -- Signals
  SIGNAL pulsos_unsigned                  : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL pulsos_2_unsigned                : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL is_rconversor_uart_uint          : T_state_type_is_rconversor_uart_uint;  -- uint8
  SIGNAL Salida_tmp                       : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Intermedio                       : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL i                                : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL salidaAux                        : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL temporalCounter_i1               : unsigned(15 DOWNTO 0);  -- ufix16
  SIGNAL is_rconversor_uart_uint_next     : T_state_type_is_rconversor_uart_uint;  -- enum type state_type_is_rconversor_uart_uint (6 enums)
  SIGNAL Intermedio_next                  : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL i_next                           : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL salidaAux_next                   : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL temporalCounter_i1_next          : unsigned(15 DOWNTO 0);  -- ufix16

BEGIN
  pulsos_unsigned <= unsigned(pulsos);

  pulsos_2_unsigned <= unsigned(pulsos_2);

  rconversor_uart_uint_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      temporalCounter_i1 <= to_unsigned(16#0000#, 16);
      Intermedio <= to_unsigned(16#00#, 8);
      i <= to_unsigned(16#0000#, 16);
      salidaAux <= to_unsigned(16#00#, 8);
      is_rconversor_uart_uint <= IN_e_inicio;
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        is_rconversor_uart_uint <= is_rconversor_uart_uint_next;
        Intermedio <= Intermedio_next;
        i <= i_next;
        salidaAux <= salidaAux_next;
        temporalCounter_i1 <= temporalCounter_i1_next;
      END IF;
    END IF;
  END PROCESS rconversor_uart_uint_1_process;

  rconversor_uart_uint_1_output : PROCESS (Intermedio, RXD, flanco, i, is_rconversor_uart_uint, pulsos_2_unsigned,
       pulsos_unsigned, salidaAux, temporalCounter_i1)
    VARIABLE temporalCounter_i1_temp : unsigned(15 DOWNTO 0);
    VARIABLE is_rconversor_uart_uint_temp : T_state_type_is_rconversor_uart_uint;
    VARIABLE Intermedio_temp : unsigned(7 DOWNTO 0);
    VARIABLE i_temp : unsigned(15 DOWNTO 0);
    VARIABLE salidaAux_temp : unsigned(7 DOWNTO 0);
  BEGIN
    Intermedio_temp := Intermedio;
    i_temp := i;
    is_rconversor_uart_uint_temp := is_rconversor_uart_uint;
    salidaAux_temp := salidaAux;
    temporalCounter_i1_temp := temporalCounter_i1;
    IF temporalCounter_i1 < to_unsigned(16#FFFF#, 16) THEN 
      temporalCounter_i1_temp := temporalCounter_i1 + to_unsigned(16#0001#, 16);
    END IF;
    CASE is_rconversor_uart_uint IS
      WHEN IN_E_espera =>
        Intermedio_temp := to_unsigned(16#00#, 8);
        i_temp := to_unsigned(16#0000#, 16);
      WHEN IN_E_espera2 =>
        NULL;
      WHEN IN_e_fin =>
        salidaAux_temp := Intermedio;
      WHEN IN_e_inicio =>
        Intermedio_temp := to_unsigned(16#00#, 8);
        salidaAux_temp := to_unsigned(16#00#, 8);
        i_temp := to_unsigned(16#0000#, 16);
      WHEN IN_e_reposo =>
        NULL;
      WHEN OTHERS => 
        --case IN_e_rota:
        Intermedio_temp := RXD & Intermedio(7 DOWNTO 1);
    END CASE;
    CASE is_rconversor_uart_uint IS
      WHEN IN_E_espera =>
        IF temporalCounter_i1_temp >= pulsos_2_unsigned THEN 
          is_rconversor_uart_uint_temp := IN_E_espera2;
          temporalCounter_i1_temp := to_unsigned(16#0000#, 16);
        END IF;
      WHEN IN_E_espera2 =>
        IF temporalCounter_i1_temp >= pulsos_unsigned THEN 
          is_rconversor_uart_uint_temp := IN_e_rota;
        END IF;
      WHEN IN_e_fin =>
        is_rconversor_uart_uint_temp := IN_e_reposo;
      WHEN IN_e_inicio =>
        IF flanco = '1' THEN 
          is_rconversor_uart_uint_temp := IN_E_espera;
          temporalCounter_i1_temp := to_unsigned(16#0000#, 16);
        END IF;
      WHEN IN_e_reposo =>
        IF flanco = '1' THEN 
          is_rconversor_uart_uint_temp := IN_E_espera;
          temporalCounter_i1_temp := to_unsigned(16#0000#, 16);
        ELSE 
          is_rconversor_uart_uint_temp := IN_e_reposo;
        END IF;
      WHEN OTHERS => 
        --case IN_e_rota:
        IF i_temp < to_unsigned(16#0007#, 16) THEN 
          i_temp := i_temp + 1;
          is_rconversor_uart_uint_temp := IN_E_espera2;
          temporalCounter_i1_temp := to_unsigned(16#0000#, 16);
        ELSE 
          is_rconversor_uart_uint_temp := IN_e_fin;
        END IF;
    END CASE;
    Intermedio_next <= Intermedio_temp;
    i_next <= i_temp;
    is_rconversor_uart_uint_next <= is_rconversor_uart_uint_temp;
    salidaAux_next <= salidaAux_temp;
    temporalCounter_i1_next <= temporalCounter_i1_temp;
  END PROCESS rconversor_uart_uint_1_output;

  rconversor_uart_uint_1_output1 : PROCESS (Intermedio, is_rconversor_uart_uint, salidaAux)
    VARIABLE Fin1 : std_logic;
    VARIABLE Salida1 : unsigned(7 DOWNTO 0);
  BEGIN
    CASE is_rconversor_uart_uint IS
      WHEN IN_E_espera =>
        Fin1 := '0';
        Salida1 := salidaAux;
      WHEN IN_E_espera2 =>
        Fin1 := '0';
        Salida1 := salidaAux;
      WHEN IN_e_fin =>
        Fin1 := '1';
        Salida1 := Intermedio;
      WHEN IN_e_inicio =>
        Fin1 := '0';
        Salida1 := to_unsigned(16#00#, 8);
      WHEN IN_e_reposo =>
        Fin1 := '0';
        Salida1 := salidaAux;
      WHEN OTHERS => 
        --case IN_e_rota:
        Fin1 := '0';
        Salida1 := salidaAux;
    END CASE;
    Fin <= Fin1;
    Salida_tmp <= Salida1;
  END PROCESS rconversor_uart_uint_1_output1;


  Salida <= std_logic_vector(Salida_tmp);

END rtl;

