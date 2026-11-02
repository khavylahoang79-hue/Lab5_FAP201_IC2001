library ieee;
use ieee.std_logic_1164.all;

entity Lab5_TB is
end entity;

architecture TB of Lab5_TB is
  signal r_Clk : std_logic := '0';
  signal r_SW1 : std_logic := '0';
  signal r_SW2 : std_logic := '0';
  signal w_LED1, w_LED2, w_LED3, w_LED4 : std_logic;
begin

  UUT : entity work.Lab5
    generic map (G_WIDTH => 4)
    port map (
      i_Clk      => r_Clk,
      i_Switch_1 => r_SW1,
      i_Switch_2 => r_SW2,
      o_LED_1    => w_LED1,
      o_LED_2    => w_LED2,
      o_LED_3    => w_LED3,
      o_LED_4    => w_LED4
    );

  r_Clk <= not r_Clk after 5 ns;

  p_Stim : process
  begin
    r_SW2 <= '0'; r_SW1 <= '0'; wait for 1 us;
    r_SW2 <= '0'; r_SW1 <= '1'; wait for 1 us;
    r_SW2 <= '1'; r_SW1 <= '0'; wait for 1 us;
    r_SW2 <= '1'; r_SW1 <= '1'; wait for 1 us;
    wait;
  end process;
end architecture;
