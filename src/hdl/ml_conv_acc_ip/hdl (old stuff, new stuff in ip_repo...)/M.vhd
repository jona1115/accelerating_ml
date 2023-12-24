-------------------------------------------------------------------------
-- Jonathan Tan & Justin Wenzel
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity M is
    port (
        i_0 	: in	std_logic_vector(32-1 downto 0);
        i_1 	: in	std_logic_vector(32-1 downto 0);
        o_0		: out   std_logic_vector(32-1 downto 0)	
    );
end M;


architecture behavioral of M is
begin

    o_0		<= std_logic_vector(unsigned(i_0) + unsigned(i_1));
  
end architecture behavioral;