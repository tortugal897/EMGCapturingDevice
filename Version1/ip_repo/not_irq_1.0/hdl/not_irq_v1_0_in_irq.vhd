library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity not_irq_v1_0_in_irq is

	port (
		in_irq	: in std_logic;
		not_irq	: out std_logic
	);
end not_irq_v1_0_in_irq;

architecture arch_imp of not_irq_v1_0_in_irq is

begin
	-- I/O Connections assignments

end arch_imp;
