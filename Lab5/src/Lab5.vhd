library ieee;
use ieee.std_logic_1164.all;

entity Lab5 is
  generic (G_WIDTH : integer := 22);
  port (
    i_Clk      : in  std_logic;
    i_Switch_1 : in  std_logic;
    i_Switch_2 : in  std_logic;
    o_LED_1    : out std_logic;
    o_LED_2    : out std_logic;
    o_LED_3    : out std_logic;
    o_LED_4    : out std_logic
  );
end entity;

architecture RTL of Lab5 is
  signal r_LFSR   : std_logic_vector(G_WIDTH-1 downto 0) := (others => '0');
  signal w_Done   : std_logic;
  signal r_Toggle : std_logic := '0';
begin

  p_LFSR : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      r_LFSR <= r_LFSR(G_WIDTH-2 downto 0) &
                (r_LFSR(G_WIDTH-1) xnor r_LFSR(G_WIDTH-2));
    end if;
  end process;

  w_Done <= '1' when r_LFSR = (r_LFSR'range => '0') else '0';

  p_Toggle : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      if w_Done = '1' then
        r_Toggle <= not r_Toggle;
      end if;
    end if;
  end process;

  o_LED_1 <= r_Toggle when (i_Switch_2 = '0' and i_Switch_1 = '0') else '0';
  o_LED_2 <= r_Toggle when (i_Switch_2 = '0' and i_Switch_1 = '1') else '0';
  o_LED_3 <= r_Toggle when (i_Switch_2 = '1' and i_Switch_1 = '0') else '0';
  o_LED_4 <= r_Toggle when (i_Switch_2 = '1' and i_Switch_1 = '1') else '0';

end architecture;