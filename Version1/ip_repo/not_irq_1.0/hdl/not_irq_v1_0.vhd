library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity not_irq_v1_0 is

	port (
		in_irq	: in std_logic;
		not_irq	: out std_logic
	);
end not_irq_v1_0;

architecture arch_imp of not_irq_v1_0 is
begin

    not_irq <= not in_irq;

end arch_imp;
