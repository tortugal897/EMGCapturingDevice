library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity not_irq_v1_0_not_irq is

	port (
		in_irq	: in std_logic;
		not_irq	: out std_logic
	);
end not_irq_v1_0_not_irq;

architecture implementation of not_irq_v1_0_not_irq is

begin

not_irq <= in_irq;

end implementation;
