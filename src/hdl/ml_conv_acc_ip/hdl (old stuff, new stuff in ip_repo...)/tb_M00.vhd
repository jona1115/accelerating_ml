-------------------------------------------------------------------------
-- Jonathan Tan
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- M00.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: TB for M00 interface
-------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_M00 is
	generic(
		gCLK_HPER 		: time		:= 10 ns;   -- Generic for half of the clock cycle period
		-- N 				: integer	:= 32;
		-- A 				: integer	:= 5;
		C_DATA_WIDTH 	: integer	:= 32;
		float_size		: integer	:= 8;
		m 				: integer	:= 4;
		n 				: integer	:= 4;
        C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
        -- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
        C_M_AXI_BURST_LEN	: integer	:= 16;
        -- Thread ID Width
        C_M_AXI_ID_WIDTH	: integer	:= 1;
        -- Width of Address Bus
        C_M_AXI_ADDR_WIDTH	: integer	:= 32;
        -- Width of Data Bus
        C_M_AXI_DATA_WIDTH	: integer	:= 32;
        -- Width of User Write Address Bus
        C_M_AXI_AWUSER_WIDTH	: integer	:= 0;
        -- Width of User Read Address Bus
        C_M_AXI_ARUSER_WIDTH	: integer	:= 0;
        -- Width of User Write Data Bus
        C_M_AXI_WUSER_WIDTH	: integer	:= 0;
        -- Width of User Read Data Bus
        C_M_AXI_RUSER_WIDTH	: integer	:= 0;
        -- Width of User Response Bus
        C_M_AXI_BUSER_WIDTH	: integer	:= 0)
	;
end tb_M00;

architecture structural of tb_M00 is

	constant cCLK_PER	: time := gCLK_HPER * 2;	-- The total clock period time

	component mlp_conv_v1_0_M00_AXI is
		generic (
            -- Users to add parameters here
    
            -- User parameters ends
            -- Do not modify the parameters beyond this line
    
            -- Base address of targeted slave
            C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
            -- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
            C_M_AXI_BURST_LEN	: integer	:= 16;
            -- Thread ID Width
            C_M_AXI_ID_WIDTH	: integer	:= 1;
            -- Width of Address Bus
            C_M_AXI_ADDR_WIDTH	: integer	:= 32;
            -- Width of Data Bus
            C_M_AXI_DATA_WIDTH	: integer	:= 32;
            -- Width of User Write Address Bus
            C_M_AXI_AWUSER_WIDTH	: integer	:= 0;
            -- Width of User Read Address Bus
            C_M_AXI_ARUSER_WIDTH	: integer	:= 0;
            -- Width of User Write Data Bus
            C_M_AXI_WUSER_WIDTH	: integer	:= 0;
            -- Width of User Read Data Bus
            C_M_AXI_RUSER_WIDTH	: integer	:= 0;
            -- Width of User Response Bus
            C_M_AXI_BUSER_WIDTH	: integer	:= 0
        );
        port (
            -- Users to add ports here
    
            M00i_READ_START	  : in std_logic;
            M00i_READ_ADDR	  : in std_logic_vector(31 downto 0);
            M00i_READ_LEN     : in std_logic_vector(7 downto 0);
            M00o_READ_RESULT  : out std_logic_vector(31 downto 0);
            M00o_READ_RESULT_COUNTER : out std_logic_vector(15 downto 0);
            M00i_WRITE_START	: in std_logic;
            M00i_WRITE_ADDR	  : in std_logic_vector(31 downto 0);
            M00i_WRITE_DATA	  : in std_logic_vector(31 downto 0);
            M00o_WRITE_DONE   : out std_logic;
                
            -- User ports ends
            -- Do not modify the ports beyond this line
    
            INIT_AXI_TXN	: in std_logic;
            TXN_DONE	: out std_logic;
            ERROR	: out std_logic;
            M_AXI_ACLK	: in std_logic;
            M_AXI_ARESETN	: in std_logic;
            M_AXI_AWID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
            M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
            M_AXI_AWLEN	: out std_logic_vector(7 downto 0);
            M_AXI_AWSIZE	: out std_logic_vector(2 downto 0);
            M_AXI_AWBURST	: out std_logic_vector(1 downto 0);
            M_AXI_AWLOCK	: out std_logic;
            M_AXI_AWCACHE	: out std_logic_vector(3 downto 0);
            M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
            M_AXI_AWQOS	: out std_logic_vector(3 downto 0);
            M_AXI_AWUSER	: out std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
            M_AXI_AWVALID	: out std_logic;
            M_AXI_AWREADY	: in std_logic;
            M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
            M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
            M_AXI_WLAST	: out std_logic;
            M_AXI_WUSER	: out std_logic_vector(C_M_AXI_WUSER_WIDTH-1 downto 0);
            M_AXI_WVALID	: out std_logic;
            M_AXI_WREADY	: in std_logic;
            M_AXI_BID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
            M_AXI_BRESP	: in std_logic_vector(1 downto 0);
            M_AXI_BUSER	: in std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
            M_AXI_BVALID	: in std_logic;
            M_AXI_BREADY	: out std_logic;
            M_AXI_ARID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
            M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
            M_AXI_ARLEN	: out std_logic_vector(7 downto 0);
            M_AXI_ARSIZE	: out std_logic_vector(2 downto 0);
            M_AXI_ARBURST	: out std_logic_vector(1 downto 0);
            M_AXI_ARLOCK	: out std_logic;
            M_AXI_ARCACHE	: out std_logic_vector(3 downto 0);
            M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
            M_AXI_ARQOS	: out std_logic_vector(3 downto 0);
            M_AXI_ARUSER	: out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
            M_AXI_ARVALID	: out std_logic;
            M_AXI_ARREADY	: in std_logic;
            M_AXI_RID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
            M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
            M_AXI_RRESP	: in std_logic_vector(1 downto 0);
            M_AXI_RLAST	: in std_logic;
            M_AXI_RUSER	: in std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
            M_AXI_RVALID	: in std_logic;
            M_AXI_RREADY	: out std_logic
        );
	end component;


    signal s_M00i_READ_START	  : std_logic;
    signal s_M00i_READ_ADDR	: std_logic_vector(31 downto 0);
    signal s_M00i_READ_LEN	: std_logic_vector(7 downto 0);
    signal s_M00o_READ_RESULT  : std_logic_vector(31 downto 0);
    signal s_M00o_READ_RESULT_COUNTER : std_logic_vector(15 downto 0);
    signal s_M00i_WRITE_START	: std_logic;
    signal s_M00i_WRITE_ADDR	  : std_logic_vector(31 downto 0);
    signal s_M00i_WRITE_DATA	  : std_logic_vector(31 downto 0);
    signal s_M00o_WRITE_DONE   : std_logic;
    signal s_INIT_AXI_TXN	: std_logic;
    signal s_TXN_DONE	: std_logic;
    signal s_ERROR	: std_logic;
    signal s_M_AXI_ACLK	: std_logic := '0';
    signal s_M_AXI_ARESETN	: std_logic := '0';
    signal s_M_AXI_AWID	: std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    signal s_M_AXI_AWADDR	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    signal s_M_AXI_AWLEN	: std_logic_vector(7 downto 0);
    signal s_M_AXI_AWSIZE	: std_logic_vector(2 downto 0);
    signal s_M_AXI_AWBURST	: std_logic_vector(1 downto 0);
    signal s_M_AXI_AWLOCK	: std_logic;
    signal s_M_AXI_AWCACHE	: std_logic_vector(3 downto 0);
    signal s_M_AXI_AWPROT	: std_logic_vector(2 downto 0);
    signal s_M_AXI_AWQOS	: std_logic_vector(3 downto 0);
    signal s_M_AXI_AWUSER	: std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
    signal s_M_AXI_AWVALID	: std_logic;
    signal s_M_AXI_AWREADY	: std_logic;
    signal s_M_AXI_WDATA	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    signal s_M_AXI_WSTRB	: std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
    signal s_M_AXI_WLAST	: std_logic;
    signal s_M_AXI_WUSER	: std_logic_vector(C_M_AXI_WUSER_WIDTH-1 downto 0);
    signal s_M_AXI_WVALID	: std_logic;
    signal s_M_AXI_WREADY	: std_logic;
    signal s_M_AXI_BID	: std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    signal s_M_AXI_BRESP	: std_logic_vector(1 downto 0);
    signal s_M_AXI_BUSER	: std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
    signal s_M_AXI_BVALID	: std_logic;
    signal s_M_AXI_BREADY	: std_logic;
    signal s_M_AXI_ARID	: std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    signal s_M_AXI_ARADDR	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    signal s_M_AXI_ARLEN	: std_logic_vector(7 downto 0);
    signal s_M_AXI_ARSIZE	: std_logic_vector(2 downto 0);
    signal s_M_AXI_ARBURST	: std_logic_vector(1 downto 0);
    signal s_M_AXI_ARLOCK	: std_logic;
    signal s_M_AXI_ARCACHE	: std_logic_vector(3 downto 0);
    signal s_M_AXI_ARPROT	: std_logic_vector(2 downto 0);
    signal s_M_AXI_ARQOS	: std_logic_vector(3 downto 0);
    signal s_M_AXI_ARUSER	: std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
    signal s_M_AXI_ARVALID	: std_logic;
    signal s_M_AXI_ARREADY	: std_logic;
    signal s_M_AXI_RID	: std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    signal s_M_AXI_RDATA	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    signal s_M_AXI_RRESP	: std_logic_vector(1 downto 0);
    signal s_M_AXI_RLAST	: std_logic;
    signal s_M_AXI_RUSER	: std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
    signal s_M_AXI_RVALID	: std_logic;
    signal s_M_AXI_RREADY	: std_logic;

    signal s_INPUT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"42000000";
    signal s_WEIGHT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"44000000";
    signal s_OUTPUT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"40000000";
    signal s_REG_00_ADDR			: std_logic_vector(31 downto 0) := x"43C00000";
    signal s_REG_01_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_02_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_03_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_04_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
	
	signal s_ONEs 		: std_logic_vector(C_DATA_WIDTH - 1 downto 0) := x"FFFFFFFF";
	signal s_ZEROs 		: std_logic_vector(C_DATA_WIDTH - 1 downto 0) := x"00000000";

begin
	
    --------------------------------------------------
	-- Wiring
	--------------------------------------------------

    DUT0: mlp_conv_v1_0_M00_AXI 
    port map(
        M00i_READ_START => s_M00i_READ_START,
        M00i_READ_ADDR  => s_M00i_READ_ADDR,
        M00i_READ_LEN    => s_M00i_READ_LEN,
        M00o_READ_RESULT  => s_M00o_READ_RESULT,
        M00o_READ_RESULT_COUNTER    => s_M00o_READ_RESULT_COUNTER,
        M00i_WRITE_START    => s_M00i_WRITE_START,
        M00i_WRITE_ADDR => s_M00i_WRITE_ADDR,
        M00i_WRITE_DATA => s_M00i_WRITE_DATA,
        M00o_WRITE_DONE => s_M00o_WRITE_DONE,
        INIT_AXI_TXN    => s_INIT_AXI_TXN,
        TXN_DONE    => s_TXN_DONE,
        ERROR   => s_ERROR,
        M_AXI_ACLK  => s_M_AXI_ACLK,
        M_AXI_ARESETN   => s_M_AXI_ARESETN,
        M_AXI_AWID  => s_M_AXI_AWID,
        M_AXI_AWADDR    => s_M_AXI_AWADDR,
        M_AXI_AWLEN => s_M_AXI_AWLEN,
        M_AXI_AWSIZE    => s_M_AXI_AWSIZE,
        M_AXI_AWBURST   => s_M_AXI_AWBURST,
        M_AXI_AWLOCK    => s_M_AXI_AWLOCK,
        M_AXI_AWCACHE   => s_M_AXI_AWCACHE,
        M_AXI_AWPROT    => s_M_AXI_AWPROT,
        M_AXI_AWQOS => s_M_AXI_AWQOS,
        M_AXI_AWUSER    => s_M_AXI_AWUSER,
        M_AXI_AWVALID   => s_M_AXI_AWVALID,
        M_AXI_AWREADY   => s_M_AXI_AWREADY,
        M_AXI_WDATA => s_M_AXI_WDATA,
        M_AXI_WSTRB => s_M_AXI_WSTRB,
        M_AXI_WLAST => s_M_AXI_WLAST,
        M_AXI_WUSER => s_M_AXI_WUSER,
        M_AXI_WVALID    => s_M_AXI_WVALID,
        M_AXI_WREADY    => s_M_AXI_WREADY,
        M_AXI_BID   => s_M_AXI_BID,
        M_AXI_BRESP => s_M_AXI_BRESP,
        M_AXI_BUSER => s_M_AXI_BUSER,
        M_AXI_BVALID    => s_M_AXI_BVALID,
        M_AXI_BREADY    => s_M_AXI_BREADY,
        M_AXI_ARID  => s_M_AXI_ARID,
        M_AXI_ARADDR    => s_M_AXI_ARADDR,
        M_AXI_ARLEN => s_M_AXI_ARLEN,
        M_AXI_ARSIZE    => s_M_AXI_ARSIZE,
        M_AXI_ARBURST   => s_M_AXI_ARBURST,
        M_AXI_ARLOCK    => s_M_AXI_ARLOCK,
        M_AXI_ARCACHE   => s_M_AXI_ARCACHE,
        M_AXI_ARPROT    => s_M_AXI_ARPROT,
        M_AXI_ARQOS => s_M_AXI_ARQOS,
        M_AXI_ARUSER    => s_M_AXI_ARUSER,
        M_AXI_ARVALID   => s_M_AXI_ARVALID,
        M_AXI_ARREADY   => s_M_AXI_ARREADY,
        M_AXI_RID   => s_M_AXI_RID,
        M_AXI_RDATA => s_M_AXI_RDATA,
        M_AXI_RRESP => s_M_AXI_RRESP,
        M_AXI_RLAST => s_M_AXI_RLAST,
        M_AXI_RUSER => s_M_AXI_RUSER,
        M_AXI_RVALID    => s_M_AXI_RVALID,
        M_AXI_RREADY    => s_M_AXI_RREADY
    );


    --------------------------------------------------
	-- Processes
	--------------------------------------------------

    P_CLK: process	-- Process to setup the clock for the test bench
  	begin
		s_M_AXI_ACLK <= '1';         	-- clock starts at 1
		wait for gCLK_HPER; 	-- after half a cycle
		s_M_AXI_ACLK <= '0';         	-- clock becomes a 0 (negative edge)
		wait for gCLK_HPER; 	-- after half a cycle, process begins evaluation again
  	end process;


    
    P_TEST_CASES: process
	begin

        -------------------------
        -- Clock 0
        -------------------------
        -- Reset
        s_M_AXI_ARESETN         <= '0';

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 1
        -------------------------
        s_M_AXI_ARESETN         <= '1';
        s_M_AXI_RVALID          <= '1';             -- Simulating master
        -- Testing read start
        s_INIT_AXI_TXN          <= '1';
        s_M00i_READ_START       <= '1';
        s_M00i_WRITE_START      <= '0';
        s_M00i_READ_ADDR        <= s_INPUT_BRAM_BASE_ADDR;
        s_M00i_READ_LEN         <= b"00000010";
        s_M_AXI_RLAST           <= '0';             -- Simulating master
        
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 2
        -------------------------
        s_M_AXI_ARREADY         <= '1'; -- Simulating master
        s_M00i_READ_START       <= '0';
        s_M00i_WRITE_START      <= '0';
        s_INIT_AXI_TXN          <= '0';

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 3
        -------------------------
        s_M_AXI_RDATA           <= x"ABCD1234";     -- Simulating master
        s_M_AXI_RVALID          <= '1';             -- Simulating master
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 4
        -------------------------
        s_M_AXI_RDATA           <= x"ABCD1234";     -- Simulating master
        s_M_AXI_RVALID          <= '1';             -- Simulating master
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 5
        -------------------------
        s_M_AXI_RDATA           <= x"12345678";     -- Simulating master
        s_M_AXI_RVALID          <= '1';             -- Simulating master
        s_M_AXI_RLAST           <= '1';             -- Simulating master

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 6
        -------------------------
        s_M_AXI_RDATA           <= x"2468ACEF";     -- Simulating master
        s_M_AXI_RVALID          <= '0';             -- Simulating master
        s_M_AXI_RLAST           <= '0';             -- Simulating master

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 7
        -------------------------
        s_INIT_AXI_TXN          <= '1';
        s_M00i_READ_START	    <= '0';
        s_M00i_WRITE_START      <= '1';
        s_M00i_WRITE_ADDR       <= s_INPUT_BRAM_BASE_ADDR;
        s_M00i_WRITE_DATA       <= x"00000010";
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 8
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 9
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 10
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 11
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 12
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 13
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- END OF TEST
        -------------------------
        
		-- s_M_AXI_ARESETN			<= '0';

        -- wait for gCLK_HPER * 2;		-- Wait for 1 cycles

		-- s_M_AXI_ARESETN			<= '1';

        -- s_M_AXI_RVALID          <= '1'; -- Simulating master
        
		-- -- Testing read start
        -- s_INIT_AXI_TXN          <= '1';

		-- s_M00i_READ_START	    <= '1';
		-- s_M00i_WRITE_START      <= '0';
		-- s_M00i_READ_ADDR	    <= s_INPUT_BRAM_BASE_ADDR;
		
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        -- s_INIT_AXI_TXN          <= '1';
        -- -- s_M00i_READ_START	    <= '0';
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        -- s_M_AXI_ARREADY         <= '1'; -- Simulating master
        -- s_M_AXI_RLAST           <= '1'; -- Simulating master
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
		
        -- -- Clear start signals
		-- s_M00i_READ_START	    <= '0';
		-- s_M00i_WRITE_START	    <= '0';
		-- s_M00i_READ_ADDR	    <= x"FFFFFFFF";

		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -- s_M_AXI_ARESETN			<= '0';
        
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles

		-- s_M_AXI_ARESETN			<= '1';
        
        -- s_INIT_AXI_TXN          <= '1';
		-- s_M00i_READ_START	    <= '0';
		-- s_M00i_WRITE_START      <= '1';
        -- s_M00i_WRITE_ADDR       <= s_INPUT_BRAM_BASE_ADDR;
        -- s_M00i_WRITE_DATA       <= x"00000010";

		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        -- s_INIT_AXI_TXN          <= '0';
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles
		-- wait for gCLK_HPER * 2;		-- Wait for 1 cycles

	end process;

end structural;
