-------------------------------------------------------------------------
-- Jonathan Tan
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- S00.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: TB for S00 interface
-------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_S00 is
	generic(
		gCLK_HPER 		: time		:= 10 ns;   -- Generic for half of the clock cycle period
		-- N 				: integer	:= 32;
		-- A 				: integer	:= 5;
		C_DATA_WIDTH 	: integer	:= 32;
		float_size		: integer	:= 8;
		m 				: integer	:= 4;
		n 				: integer	:= 4;

        -- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 7
    );
end tb_S00;

architecture structural of tb_S00 is

	constant cCLK_PER	: time := gCLK_HPER * 2;	-- The total clock period time

	component mlp_conv_v1_0_S00_AXI is
		generic (
            -- Users to add parameters here
    
            -- User parameters ends
            -- Do not modify the parameters beyond this line
    
            -- Width of S_AXI data bus
            C_S_AXI_DATA_WIDTH	: integer	:= 32;
            -- Width of S_AXI address bus
            C_S_AXI_ADDR_WIDTH	: integer	:= 7
        );
        port (
            -- Users to add ports here
            S00i_READ_START	  : in std_logic;
            S00i_READ_ADDR	  : in std_logic_vector(4 downto 0);
            S00o_READ_RESULT  : out std_logic_vector(31 downto 0);
            S00i_WRITE_START	: in std_logic;
            S00i_WRITE_ADDR	  : in std_logic_vector(4 downto 0);
            S00i_WRITE_DATA	  : in std_logic_vector(31 downto 0);
            S00o_WRITE_DONE   : out std_logic;
            -- User ports ends
            -- Do not modify the ports beyond this line
    
            S_AXI_ACLK	: in std_logic;
            S_AXI_ARESETN	: in std_logic;
            S_AXI_AWADDR	: in std_logic_vector(7-1 downto 0);
            S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
            S_AXI_AWVALID	: in std_logic;
            S_AXI_AWREADY	: out std_logic;
            S_AXI_WDATA	: in std_logic_vector(32-1 downto 0);
            S_AXI_WSTRB	: in std_logic_vector((32/8)-1 downto 0);
            S_AXI_WVALID	: in std_logic;
            S_AXI_WREADY	: out std_logic;
            S_AXI_BRESP	: out std_logic_vector(1 downto 0);
            S_AXI_BVALID	: out std_logic;
            S_AXI_BREADY	: in std_logic;
            S_AXI_ARADDR	: in std_logic_vector(7-1 downto 0);
            S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
            S_AXI_ARVALID	: in std_logic;
            S_AXI_ARREADY	: out std_logic;
            S_AXI_RDATA	: out std_logic_vector(32-1 downto 0);
            S_AXI_RRESP	: out std_logic_vector(1 downto 0);
            S_AXI_RVALID	: out std_logic;
            S_AXI_RREADY	: in std_logic
        );
	end component;

    signal s_S00i_READ_START	    : std_logic;
    signal s_S00i_READ_ADDR	        : std_logic_vector(4 downto 0);
    signal s_S00o_READ_RESULT       : std_logic_vector(31 downto 0);
    signal s_S00i_WRITE_START	    : std_logic;
    signal s_S00i_WRITE_ADDR	    : std_logic_vector(4 downto 0);
    signal s_S00i_WRITE_DATA	    : std_logic_vector(31 downto 0);
    signal s_S00o_WRITE_DONE        : std_logic;
    signal s_S_AXI_ACLK	    : std_logic;
    signal s_S_AXI_ARESETN	: std_logic;
    signal s_S_AXI_AWADDR	: std_logic_vector(7-1 downto 0);
    signal s_S_AXI_AWPROT	: std_logic_vector(2 downto 0);
    signal s_S_AXI_AWVALID	: std_logic;
    signal s_S_AXI_AWREADY	: std_logic;
    signal s_S_AXI_WDATA	: std_logic_vector(32-1 downto 0);
    signal s_S_AXI_WSTRB	: std_logic_vector((32/8)-1 downto 0);
    signal s_S_AXI_WVALID	: std_logic;
    signal s_S_AXI_WREADY	: std_logic;
    signal s_S_AXI_BRESP	: std_logic_vector(1 downto 0);
    signal s_S_AXI_BVALID	: std_logic;
    signal s_S_AXI_BREADY	: std_logic;
    signal s_S_AXI_ARADDR	: std_logic_vector(7-1 downto 0);
    signal s_S_AXI_ARPROT	: std_logic_vector(2 downto 0);
    signal s_S_AXI_ARVALID	: std_logic;
    signal s_S_AXI_ARREADY	: std_logic;
    signal s_S_AXI_RDATA	: std_logic_vector(32-1 downto 0);
    signal s_S_AXI_RRESP	: std_logic_vector(1 downto 0);
    signal s_S_AXI_RVALID	: std_logic;
    signal s_S_AXI_RREADY	: std_logic;

    signal s_INPUT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"42000000";
    signal s_WEIGHT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"44000000";
    signal s_OUTPUT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"40000000";
    signal s_REG_00_ADDR			: std_logic_vector(31 downto 0) := x"43C00000";
    signal s_REG_01_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_02_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_03_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_04_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
	
    signal s_TEST_NUMBER    : integer := 0;
    
	signal s_ONEs 		: std_logic_vector(C_DATA_WIDTH - 1 downto 0) := x"FFFFFFFF";
	signal s_ZEROs 		: std_logic_vector(C_DATA_WIDTH - 1 downto 0) := x"00000000";

begin
	
    --------------------------------------------------
	-- Wiring
	--------------------------------------------------

    DUT0: mlp_conv_v1_0_S00_AXI 
    port map(
        S00i_READ_START     => s_S00i_READ_START,
        S00i_READ_ADDR      => s_S00i_READ_ADDR,
        S00o_READ_RESULT        => s_S00o_READ_RESULT,
        S00i_WRITE_START        => s_S00i_WRITE_START,
        S00i_WRITE_ADDR     => s_S00i_WRITE_ADDR,
        S00i_WRITE_DATA     => s_S00i_WRITE_DATA,
        S00o_WRITE_DONE     => s_S00o_WRITE_DONE,
        S_AXI_ACLK      => s_S_AXI_ACLK,
        S_AXI_ARESETN       => s_S_AXI_ARESETN,
        S_AXI_AWADDR        => s_S_AXI_AWADDR,
        S_AXI_AWPROT        => s_S_AXI_AWPROT,
        S_AXI_AWVALID       => s_S_AXI_AWVALID,
        S_AXI_AWREADY       => s_S_AXI_AWREADY,
        S_AXI_WDATA     => s_S_AXI_WDATA,
        S_AXI_WSTRB     => s_S_AXI_WSTRB,
        S_AXI_WVALID        => s_S_AXI_WVALID,
        S_AXI_WREADY        => s_S_AXI_WREADY,
        S_AXI_BRESP     => s_S_AXI_BRESP,
        S_AXI_BVALID        => s_S_AXI_BVALID,
        S_AXI_BREADY        => s_S_AXI_BREADY,
        S_AXI_ARADDR        => s_S_AXI_ARADDR,
        S_AXI_ARPROT        => s_S_AXI_ARPROT,
        S_AXI_ARVALID       => s_S_AXI_ARVALID,
        S_AXI_ARREADY       => s_S_AXI_ARREADY,
        S_AXI_RDATA     => s_S_AXI_RDATA,
        S_AXI_RRESP     => s_S_AXI_RRESP,
        S_AXI_RVALID        => s_S_AXI_RVALID,
        S_AXI_RREADY        => s_S_AXI_RREADY
    );


    --------------------------------------------------
	-- Processes
	--------------------------------------------------

    P_CLK: process	-- Process to setup the clock for the test bench
  	begin
		s_S_AXI_ACLK <= '1';         	-- clock starts at 1
		wait for gCLK_HPER; 	-- after half a cycle
		s_S_AXI_ACLK <= '0';         	-- clock becomes a 0 (negative edge)
		wait for gCLK_HPER; 	-- after half a cycle, process begins evaluation again
  	end process;


    
    P_TEST_CASES: process
	begin
        -------------------------
        -- Clock -1
        -------------------------
        s_S_AXI_ARESETN     <= '0';

        s_TEST_NUMBER   <= s_TEST_NUMBER + 0;
        wait for gCLK_HPER * 1;		-- Wait for 1 cycles
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 0
        -------------------------
        s_S_AXI_AWVALID     <= '0';     -- So that wren is low
        s_S_AXI_WVALID      <= '0';     -- So that wren is low
        s_S_AXI_ARESETN     <= '1';
        s_S00i_READ_START   <= '0';
        s_S00i_WRITE_START  <= '1';
        s_S00i_WRITE_ADDR   <= b"00010";
        s_S00i_WRITE_DATA   <= x"0000FFFF";

        s_TEST_NUMBER   <= s_TEST_NUMBER + 0;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 0b
        -------------------------
        s_S_AXI_AWVALID     <= '0';     -- So that wren is low
        s_S_AXI_WVALID      <= '0';     -- So that wren is low
        s_S_AXI_ARESETN     <= '1';
        s_S00i_READ_START   <= '0';
        s_S00i_WRITE_START  <= '1';
        s_S00i_WRITE_ADDR   <= b"00001";
        s_S00i_WRITE_DATA   <= x"ABCD1234";

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 0c
        -------------------------
        s_S_AXI_AWVALID     <= '0';     -- So that wren is low
        s_S_AXI_WVALID      <= '0';     -- So that wren is low
        s_S_AXI_ARESETN     <= '1';
        s_S00i_READ_START   <= '0';
        s_S00i_WRITE_START  <= '1';
        s_S00i_WRITE_ADDR   <= b"00011";
        -- s_S00i_WRITE_DATA   <= x"ABCD1234";
        s_S00i_WRITE_DATA   <= x"A1B2C3D4";

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 1
        -------------------------
        s_S00i_READ_START   <= '0';
        s_S00i_WRITE_START  <= '0';
        s_S00i_READ_ADDR    <= b"00000";
        
        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 2
        -------------------------
        s_S00i_READ_START   <= '1';
        s_S00i_WRITE_START  <= '0';
        s_S00i_READ_ADDR    <= b"00001";
        s_S00i_READ_ADDR    <= b"00010";
        s_S00i_READ_ADDR    <= b"00011";

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 3
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 4
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 5
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 6
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 7
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 8
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 9
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 10
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 11
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 12
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 13
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- END OF TEST
        -------------------------
        
	end process;

end structural;
