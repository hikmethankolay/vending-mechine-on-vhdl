library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Entity declaration for the vending machine
entity vending_machine is
    Port ( 
            clk : in STD_LOGIC;  -- Clock signal
            rst : in STD_LOGIC;  -- Reset signal
            coin_inserted : in STD_LOGIC;  -- Signal indicating a coin is inserted
            coin_value : in std_logic_vector(4 downto 0);  -- Value of the inserted coin
             
            -- Output signals
            product_ready : out STD_LOGIC;  -- Signal indicating the product is ready for collection
            change_out : out STD_LOGIC  -- Signal indicating change is being dispensed
    );
end entity;

-- Architecture definition
architecture arc of vending_machine is

    -- Define the states of the vending machine
    type state_type is (IDLE, COIN_INSERT, PRODUCT_DELIVERED, COIN_CHANGE);
    signal state : state_type;  -- Current state of the vending machine

    -- Internal signals
    signal total_amount : std_logic_vector(4 downto 0);  -- Total money inserted
    signal insufficient_funds_flag : std_logic;  -- Flag for insufficient funds
    signal price : std_logic_vector(4 downto 0) := "01010"; -- Fixed price of the product (10 TL)

begin
    
    price <= "01010"; -- Set product price to 10 TL

    process(clk, rst)
    begin
        if (rst = '1') then  -- Reset condition
            state <= IDLE;
            total_amount <= (others => '0');
            change_out <= '0';
            product_ready <= '0';
            insufficient_funds_flag <= '0';
        elsif (rising_edge(clk)) then  -- Clock edge detection
            case state is
                when IDLE =>  -- Idle state
                    state <= IDLE;
                    total_amount <= (others => '0');
                    change_out <= '0';
                    product_ready <= '0';
                    insufficient_funds_flag <= '0';

                    if (coin_inserted = '1') then  -- If a coin is inserted
                        state <= COIN_INSERT;
                        total_amount <= total_amount + coin_value;  -- Update total amount
                    else
                        state <= IDLE;
                    end if;
                
                when COIN_INSERT =>  -- Coin insertion state
                    if (coin_inserted = '1') then
                        state <= COIN_INSERT;
                        total_amount <= total_amount + coin_value;  -- Continue adding coins
                    else
                        if (total_amount >= price) then
                            state <= PRODUCT_DELIVERED;  -- If enough money is inserted, proceed to product delivery
                        else
                            state <= COIN_CHANGE;
                            insufficient_funds_flag <= '1';  -- Indicate insufficient funds
                        end if;
                    end if;

                when PRODUCT_DELIVERED =>  -- Product delivery state
                    total_amount <= total_amount - price;  -- Deduct product price
                    product_ready <= '1';  -- Indicate product is ready
                    state <= COIN_CHANGE;  -- Proceed to change return state

                when COIN_CHANGE =>  -- Change return state
                    insufficient_funds_flag <= '0';
                    product_ready <= '0';
                    if (total_amount /= "00000") then
                        total_amount <= total_amount - "00001";  -- Dispense 1 TL change at a time
                        change_out <= '1';
                        state <= COIN_CHANGE;  -- Continue returning change
                    else  -- If no remaining money
                        state <= IDLE;
                        change_out <= '0';
                    end if;

                when others =>  -- Default case to handle unexpected situations
                    state <= IDLE;
                    total_amount <= (others => '0');
                    change_out <= '0';
                    product_ready <= '0';
                    insufficient_funds_flag <= '0';
            end case;
        end if;
    end process;

end architecture;
