library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_vending_machine is
--  Port ( );
end tb_vending_machine;

architecture Behavioral of tb_vending_machine is


component  vending_machine is
    Port ( 
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            coin_inserted : in STD_LOGIC;
            coin_value : in std_logic_vector(4 downto 0);
             
            -- Output
            product_ready : out STD_LOGIC;
            change_out : out STD_LOGIC;  -- Signal indicating change is being dispensed
            coin_value_out : out STD_LOGIC

    );
end component;

signal clk : STD_LOGIC;
signal rst : STD_LOGIC;
signal coin_inserted : STD_LOGIC;
signal coin_value : std_logic_vector(4 downto 0);
signal product_ready : STD_LOGIC;
signal coin_value_out : STD_LOGIC;

constant clock_period: time := 20ns;

begin

    clock_process:process 
    begin
        clk <= '0';
        wait for clock_period/2;
        clk <= '1';
        wait for clock_period/2;
    end process;

uut: vending_machine port map(
            clk  =>  clk,
            rst  =>  rst,
            coin_inserted  =>  coin_inserted,
            coin_value  =>  coin_value,
            product_ready  =>  product_ready,
            coin_value_out  =>  coin_value_out
);

    stim_proc: process
    begin
        rst <= '1';
        coin_inserted <= '0';
        coin_value <= (others => '0');
        wait for 100ns;
        rst <= '0';
        wait for clock_period*2;
        
        --1--
        coin_inserted <= '1';
        coin_value <= "00001";
        wait for clock_period;
        coin_value <= "00101";
        wait for clock_period;
        coin_value <= "01010";
        wait for clock_period;
        coin_inserted <= '0';
        wait for clock_period*15;
        
        --2--
        coin_inserted <= '1';
        coin_value <= "00001";
        wait for clock_period;
        coin_value <= "00001";
        wait for clock_period;
        coin_value <= "00101";
        wait for clock_period;
        coin_inserted <= '0';
        wait for clock_period*15;
        
        --3--
        coin_inserted <= '1';
        coin_value <= "00101";
        wait for clock_period;
        coin_value <= "00001";
        wait for clock_period;
        coin_value <= "00001";
        wait for clock_period;
        coin_value <= "00101";
        wait for clock_period;
        coin_inserted <= '0';
        wait for clock_period*15;
        
        --4--
        coin_inserted <= '1';
        coin_value <= "01010";
        wait for clock_period;
        coin_value <= "00101";
        wait for clock_period;
        coin_inserted <= '0';
        wait for clock_period*15;
        
        wait;
    end process;
end Behavioral;
