library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity not_irq_v1_0 is
--	generic (
--		-- Users to add parameters here

--		-- User parameters ends
--	);
	port (
		-- Users to add ports here
        in_irq : in std_logic;
        not_irq : out std_logic
		-- User ports ends
		-- Do not modify the ports beyond this line

	);
end not_irq_v1_0;

architecture arch_imp of not_irq_v1_0 is


begin
	-- Add user logic here
    not_irq <= not(in_irq);
	-- User logic ends

end arch_imp;
