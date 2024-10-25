library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
    Port ( cs,rd,iom : in std_logic;
           dir      : in std_logic_vector(6 downto 0);
           data     : out std_logic_vector(7 downto 0));
end ROM;

architecture Behavioral of ROM is
begin
process(cs,rd,dir)
begin
if cs = '1' and rd = '0' and iom = '1' then
    case dir is
        -- Programa principal
        when "0000000" => data <= "01010000";  -- 0x00 JMP MAIN
        when "0000001" => data <= "00000011";  -- 0x01 DIR=MAIN (0x03)
        when "0000010" => data <= "00000000";  -- 0x02 NOP
        
        -- MAIN: Escribir valor en LEDs
        when "0000011" => data <= "00011000";  -- 0x03 MOV ACC,CTE
        when "0000100" => data <= "01010101";  -- 0x04 CTE = 0x55 (patrón alternado)
        when "0000101" => data <= "00101000";  -- 0x05 MOV DPTR,ACC
        when "0000110" => data <= "00011000";  -- 0x06 MOV ACC,CTE  
        when "0000111" => data <= "00000100";  -- 0x07 CTE = 0x04 (dir LEDs)
        when "0001000" => data <= "10100000";  -- 0x08 SND [DPTR],ACC
        
        -- POLL: Loop de polling
        when "0001001" => data <= "00011000";  -- 0x09 MOV ACC,CTE
        when "0001010" => data <= "00000101";  -- 0x0A CTE = 0x05 (dir switches)
        when "0001011" => data <= "00101000";  -- 0x0B MOV DPTR,ACC
        when "0001100" => data <= "10011000";  -- 0x0C RCV ACC,[DPTR]
        
        -- Si hay dato nuevo, guardarlo en RAM
        when "0001101" => data <= "00101000";  -- 0x0D MOV DPTR,ACC
        when "0001110" => data <= "10000000";  -- 0x0E CTE = 0x80 (dir RAM)
        when "0001111" => data <= "00110000";  -- 0x0F MOV [DPTR],ACC
        
        -- Volver a POLL
        when "0010000" => data <= "01010000";  -- 0x10 JMP POLL
        when "0010001" => data <= "00001001";  -- 0x11 DIR=POLL (0x09)
        
        when others => data <= (others => 'X');
    end case;
else 
    data <= (others => 'Z');
end if;
end process;
end Behavioral;