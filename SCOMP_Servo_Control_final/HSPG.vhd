-- HSPG.vhd (hobby servo pulse generator)
-- This starting point generates a pulse between 100 us and something much longer than 2.5 ms.

library IEEE;
library lpm;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use lpm.lpm_components.all;

entity HSPG is
    port(
        CS          : in  std_logic;
        IO_WRITE    : in  std_logic;
        IO_DATA     : in  std_logic_vector(15 downto 0);
        CLOCK       : in  std_logic;
        RESETN      : in  std_logic;
        PULSE       : out std_logic
    );
end HSPG;

architecture a of HSPG is

    signal command : std_logic_vector(7 downto 0);  -- command sent from SCOMP
	 signal mode : std_logic_vector(0 downto 0);
	 signal stopTime   :std_logic_vector(11 downto 0);  -- time delay for pulse
	 signal currentTime   : std_logic_vector(11 downto 0) := x"000";  
	 
begin

    -- Latch data on rising edge of CS
    process (RESETN, CS) begin
        if RESETN = '0' then
            command <= x"00";
        elsif IO_WRITE = '1' and rising_edge(CS) then
            command <= IO_DATA(7 downto 0); --command is 8 bits
				mode(0) <= IO_DATA(8); --mode of peirpheral is 9th bit of command
        end if;
    end process;
	
	
  -- Pulse generation process
process (RESETN, CLOCK)
    begin
	 
	 --reset stop time and current time on reset
		if (RESETN = '0') then
			currentTime <= x"000";
			stopTime <= x"000";
      elsif (rising_edge(CLOCK)) then
		currentTime <= currentTime + 1; --add clock period to current time 
		
		-- BASE FUNCTIONALITY: User enters a pulse width in us
			if (mode(0) = '0') then 
				if (stopTime = x"000") then --start pulse
					PULSE <= '1';
					if (command < x"32") then -- if user enters < 50
						stopTime <= x"032";
					elsif (command > x"FA") then -- if user enters > 250
						stopTime <= x"0FA";
					else -- user enters between 50 and 250
						stopTime <= '0' & '0' & '0' & '0' & command;
					end if;
				elsif (currentTime = stopTime) then --end pulse 
					PULSE <= '0';
				elsif (currentTime = x"07CF") then -- wait until 1999 ms passed
					currentTime <= x"000";
					stopTime <= x"000";
				end if;
		
		--ANGLE FUNCTIONALITY: User enters an angle and peripheral calculates necessary pulse width
			elsif (mode(0) = '1') then
				if (stopTime = x"000") then
				PULSE <= '1';
					if (command = x"00") then --user enters angle of 0
						stopTime <= x"032";
					elsif (command > x"B4" OR command = x"B4") then -- if user enters angle of 180
						stopTime <= x"0FA";
						
					-- user enters angle between 0 and 68
					elsif (command > x"00" AND (command < x"44" OR command = x"44")) then
						stopTime <= '0' & '0' & '0' & '0' & (command + x"37");-- add 55
						
					-- user enters angle between 68 and 113
					elsif (command > x"44" AND (command < x"71" OR command = x"71")) then
						stopTime <= '0' & '0' & '0' & '0' & (command + x"3C"); -- add 60
						
					-- user enters angle between 113 and 180
					elsif (command > x"00" AND command < x"B4") then
						stopTime <= '0' & '0' & '0' & '0' & (command + x"41");-- add 65
						
					end if;
				elsif (currentTime = stopTime) then --end pulse 
					PULSE <= '0';
				elsif (currentTime = x"7CF") then -- wait until 1999 ms passed
					currentTime <= x"000";
					stopTime <= x"000";
				end if;
			end if;
		end if;
	end process;
end a;

