-------------------------------------------------------------------------
-- Jonathan Tan
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_ml_acc_conv.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: TB for ml_acc_conv interface
-------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_ml_acc_conv is
	generic(
		gCLK_HPER 		: time		:= 10 ns;   -- Generic for half of the clock cycle period
		-- N 				: integer	:= 32;
		-- A 				: integer	:= 5;

        -- NUMBER_OF_MACS			: integer	:= 200;	-- Maximum axi4 burst length is 256
        NUMBER_OF_MACS			: integer	:= 25;	-- For testing
        NUMBER_OF_MACS_STDLV	: std_logic_vector	:= b"00011001"; -- This is 25 in binary
        -- User parameters ends
        -- Do not modify the parameters beyond this line


        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S00_AXI_DATA_WIDTH	: integer	:= 32;
        C_S00_AXI_ADDR_WIDTH	: integer	:= 7;

        -- Parameters of Axi Master Bus Interface M00_AXI
        C_M00_AXI_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
        C_M00_AXI_BURST_LEN	: integer	:= 16;
        C_M00_AXI_ID_WIDTH	: integer	:= 1;
        C_M00_AXI_ADDR_WIDTH	: integer	:= 32;
        C_M00_AXI_DATA_WIDTH	: integer	:= 32;
        C_M00_AXI_AWUSER_WIDTH	: integer	:= 0;
        C_M00_AXI_ARUSER_WIDTH	: integer	:= 0;
        C_M00_AXI_WUSER_WIDTH	: integer	:= 0;
        C_M00_AXI_RUSER_WIDTH	: integer	:= 0;
        C_M00_AXI_BUSER_WIDTH	: integer	:= 0;

        -- Parameters of Axi Slave Bus Interface S_AXI_INTR
        C_S_AXI_INTR_DATA_WIDTH	: integer	:= 32;
        C_S_AXI_INTR_ADDR_WIDTH	: integer	:= 5;
        C_NUM_OF_INTR	: integer	:= 1;
        C_INTR_SENSITIVITY	: std_logic_vector	:= x"FFFFFFFF";
        C_INTR_ACTIVE_STATE	: std_logic_vector	:= x"FFFFFFFF";
        C_IRQ_SENSITIVITY	: integer	:= 1;
        C_IRQ_ACTIVE_STATE	: integer	:= 1
    );
end tb_ml_acc_conv;

architecture structural of tb_ml_acc_conv is

	constant cCLK_PER	: time := gCLK_HPER * 2;	-- The total clock period time

	component ml_acc_conv_v1_0 is
        generic (
            -- Users to add parameters here
            -- NUMBER_OF_MACS			: integer	:= 200;	-- Maximum axi4 burst length is 256
            NUMBER_OF_MACS			: integer	:= 25;	-- For testing
            NUMBER_OF_MACS_STDLV	: std_logic_vector	:= b"00011001"; -- This is 25 in binary
            -- User parameters ends
            -- Do not modify the parameters beyond this line
    
    
            -- Parameters of Axi Slave Bus Interface S00_AXI
            C_S00_AXI_DATA_WIDTH	: integer	:= 32;
            C_S00_AXI_ADDR_WIDTH	: integer	:= 7;
    
            -- Parameters of Axi Master Bus Interface M00_AXI
            C_M00_AXI_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
            C_M00_AXI_BURST_LEN	: integer	:= 16;
            C_M00_AXI_ID_WIDTH	: integer	:= 1;
            C_M00_AXI_ADDR_WIDTH	: integer	:= 32;
            C_M00_AXI_DATA_WIDTH	: integer	:= 32;
            C_M00_AXI_AWUSER_WIDTH	: integer	:= 0;
            C_M00_AXI_ARUSER_WIDTH	: integer	:= 0;
            C_M00_AXI_WUSER_WIDTH	: integer	:= 0;
            C_M00_AXI_RUSER_WIDTH	: integer	:= 0;
            C_M00_AXI_BUSER_WIDTH	: integer	:= 0;
    
            -- Parameters of Axi Slave Bus Interface S_AXI_INTR
            C_S_AXI_INTR_DATA_WIDTH	: integer	:= 32;
            C_S_AXI_INTR_ADDR_WIDTH	: integer	:= 5;
            C_NUM_OF_INTR	: integer	:= 1;
            C_INTR_SENSITIVITY	: std_logic_vector	:= x"FFFFFFFF";
            C_INTR_ACTIVE_STATE	: std_logic_vector	:= x"FFFFFFFF";
            C_IRQ_SENSITIVITY	: integer	:= 1;
            C_IRQ_ACTIVE_STATE	: integer	:= 1
        );
        port (
            -- Users to add ports here
            -- prefix "d" means it is a debug signal
            d_s_M00i_READ_START	    : out std_logic;							-- Probe 0
            d_s_M00i_READ_ADDR	    : out std_logic_vector(31 downto 0);		-- Probe 1
            d_s_M00i_READ_LEN       : out std_logic_vector(7 downto 0);			-- Probe 2
            d_s_M00o_READ_RESULT    : out std_logic_vector(31 downto 0);		-- Probe 3
            d_s_M00o_READ_RESULT_COUNTER : out std_logic_vector(15 downto 0);	-- Probe 4
            d_s_M00i_WRITE_START	: out std_logic;							-- Probe 5
            d_s_M00i_WRITE_ADDR     : out std_logic_vector(31 downto 0);		-- Probe 6
            d_s_M00i_WRITE_DATA	    : out std_logic_vector(31 downto 0);		-- Probe 7
            d_s_M00o_WRITE_DONE     : out std_logic;							-- Probe 8
            d_s_S00_reg10			: out std_logic_vector(31 downto 0);		-- Probe 9
            d_s_read_started		: out std_logic;							-- Probe 10
            d_s_write_started		: out std_logic;							-- Probe 11
    
            -- i_dummy : in std_logic_vector(31 downto 0); 	-- remove after tb test				
            -- User ports ends
            -- Do not modify the ports beyond this line
    
    
            -- Ports of Axi Slave Bus Interface S00_AXI
            s00_axi_aclk	: in std_logic;
            s00_axi_aresetn	: in std_logic;
            s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
            s00_axi_awprot	: in std_logic_vector(2 downto 0);
            s00_axi_awvalid	: in std_logic;
            s00_axi_awready	: out std_logic;
            s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
            s00_axi_wvalid	: in std_logic;
            s00_axi_wready	: out std_logic;
            s00_axi_bresp	: out std_logic_vector(1 downto 0);
            s00_axi_bvalid	: out std_logic;
            s00_axi_bready	: in std_logic;
            s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
            s00_axi_arprot	: in std_logic_vector(2 downto 0);
            s00_axi_arvalid	: in std_logic;
            s00_axi_arready	: out std_logic;
            s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
            s00_axi_rresp	: out std_logic_vector(1 downto 0);
            s00_axi_rvalid	: out std_logic;
            s00_axi_rready	: in std_logic;
    
            -- Ports of Axi Master Bus Interface M00_AXI
            m00_axi_init_axi_txn	: in std_logic;
            m00_axi_txn_done	: out std_logic;
            m00_axi_error	: out std_logic;
            m00_axi_aclk	: in std_logic;
            m00_axi_aresetn	: in std_logic;
            m00_axi_awid	: out std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
            m00_axi_awaddr	: out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
            m00_axi_awlen	: out std_logic_vector(7 downto 0);
            m00_axi_awsize	: out std_logic_vector(2 downto 0);
            m00_axi_awburst	: out std_logic_vector(1 downto 0);
            m00_axi_awlock	: out std_logic;
            m00_axi_awcache	: out std_logic_vector(3 downto 0);
            m00_axi_awprot	: out std_logic_vector(2 downto 0);
            m00_axi_awqos	: out std_logic_vector(3 downto 0);
            m00_axi_awuser	: out std_logic_vector(C_M00_AXI_AWUSER_WIDTH-1 downto 0);
            m00_axi_awvalid	: out std_logic;
            m00_axi_awready	: in std_logic;
            m00_axi_wdata	: out std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
            m00_axi_wstrb	: out std_logic_vector(C_M00_AXI_DATA_WIDTH/8-1 downto 0);
            m00_axi_wlast	: out std_logic;
            m00_axi_wuser	: out std_logic_vector(C_M00_AXI_WUSER_WIDTH-1 downto 0);
            m00_axi_wvalid	: out std_logic;
            m00_axi_wready	: in std_logic;
            m00_axi_bid	: in std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
            m00_axi_bresp	: in std_logic_vector(1 downto 0);
            m00_axi_buser	: in std_logic_vector(C_M00_AXI_BUSER_WIDTH-1 downto 0);
            m00_axi_bvalid	: in std_logic;
            m00_axi_bready	: out std_logic;
            m00_axi_arid	: out std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
            m00_axi_araddr	: out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
            m00_axi_arlen	: out std_logic_vector(7 downto 0);
            m00_axi_arsize	: out std_logic_vector(2 downto 0);
            m00_axi_arburst	: out std_logic_vector(1 downto 0);
            m00_axi_arlock	: out std_logic;
            m00_axi_arcache	: out std_logic_vector(3 downto 0);
            m00_axi_arprot	: out std_logic_vector(2 downto 0);
            m00_axi_arqos	: out std_logic_vector(3 downto 0);
            m00_axi_aruser	: out std_logic_vector(C_M00_AXI_ARUSER_WIDTH-1 downto 0);
            m00_axi_arvalid	: out std_logic;
            m00_axi_arready	: in std_logic;
            m00_axi_rid	: in std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
            m00_axi_rdata	: in std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
            m00_axi_rresp	: in std_logic_vector(1 downto 0);
            m00_axi_rlast	: in std_logic;
            m00_axi_ruser	: in std_logic_vector(C_M00_AXI_RUSER_WIDTH-1 downto 0);
            m00_axi_rvalid	: in std_logic;
            m00_axi_rready	: out std_logic;
    
            -- Ports of Axi Slave Bus Interface S_AXI_INTR
            s_axi_intr_aclk	: in std_logic;
            s_axi_intr_aresetn	: in std_logic;
            s_axi_intr_awaddr	: in std_logic_vector(C_S_AXI_INTR_ADDR_WIDTH-1 downto 0);
            s_axi_intr_awprot	: in std_logic_vector(2 downto 0);
            s_axi_intr_awvalid	: in std_logic;
            s_axi_intr_awready	: out std_logic;
            s_axi_intr_wdata	: in std_logic_vector(C_S_AXI_INTR_DATA_WIDTH-1 downto 0);
            s_axi_intr_wstrb	: in std_logic_vector((C_S_AXI_INTR_DATA_WIDTH/8)-1 downto 0);
            s_axi_intr_wvalid	: in std_logic;
            s_axi_intr_wready	: out std_logic;
            s_axi_intr_bresp	: out std_logic_vector(1 downto 0);
            s_axi_intr_bvalid	: out std_logic;
            s_axi_intr_bready	: in std_logic;
            s_axi_intr_araddr	: in std_logic_vector(C_S_AXI_INTR_ADDR_WIDTH-1 downto 0);
            s_axi_intr_arprot	: in std_logic_vector(2 downto 0);
            s_axi_intr_arvalid	: in std_logic;
            s_axi_intr_arready	: out std_logic;
            s_axi_intr_rdata	: out std_logic_vector(C_S_AXI_INTR_DATA_WIDTH-1 downto 0);
            s_axi_intr_rresp	: out std_logic_vector(1 downto 0);
            s_axi_intr_rvalid	: out std_logic;
            s_axi_intr_rready	: in std_logic;
            irq	: out std_logic
        );
    end component;

    -- tbis = tb internal signal
    signal tbis_d_s_M00i_READ_START	    : std_logic;							-- Probe 0
    signal tbis_d_s_M00i_READ_ADDR	    : std_logic_vector(31 downto 0);		-- Probe 1
    signal tbis_d_s_M00i_READ_LEN       : std_logic_vector(7 downto 0);			-- Probe 2
    signal tbis_d_s_M00o_READ_RESULT    : std_logic_vector(31 downto 0);		-- Probe 3
    signal tbis_d_s_M00o_READ_RESULT_COUNTER : std_logic_vector(15 downto 0);	-- Probe 4
    signal tbis_d_s_M00i_WRITE_START	: std_logic;							-- Probe 5
    signal tbis_d_s_M00i_WRITE_ADDR     : std_logic_vector(31 downto 0);		-- Probe 6
    signal tbis_d_s_M00i_WRITE_DATA	    : std_logic_vector(31 downto 0);		-- Probe 7
    signal tbis_d_s_M00o_WRITE_DONE     : std_logic;							-- Probe 8
    signal tbis_d_s_S00_reg10			: std_logic_vector(31 downto 0);		-- Probe 9
    signal tbis_d_s_read_started		: std_logic;							-- Probe 10
    signal tbis_d_s_write_started		: std_logic;							-- Probe 11
    signal tbis_s00_axi_aclk	: std_logic;
    signal tbis_s00_axi_aresetn	: std_logic;
    signal tbis_s00_axi_awaddr	: std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
    signal tbis_s00_axi_awprot	: std_logic_vector(2 downto 0);
    signal tbis_s00_axi_awvalid	: std_logic;
    signal tbis_s00_axi_awready	: std_logic;
    signal tbis_s00_axi_wdata	: std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal tbis_s00_axi_wstrb	: std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
    signal tbis_s00_axi_wvalid	: std_logic;
    signal tbis_s00_axi_wready	: std_logic;
    signal tbis_s00_axi_bresp	: std_logic_vector(1 downto 0);
    signal tbis_s00_axi_bvalid	: std_logic;
    signal tbis_s00_axi_bready	: std_logic;
    signal tbis_s00_axi_araddr	: std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
    signal tbis_s00_axi_arprot	: std_logic_vector(2 downto 0);
    signal tbis_s00_axi_arvalid	: std_logic;
    signal tbis_s00_axi_arready	: std_logic;
    signal tbis_s00_axi_rdata	: std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal tbis_s00_axi_rresp	: std_logic_vector(1 downto 0);
    signal tbis_s00_axi_rvalid	: std_logic;
    signal tbis_s00_axi_rready	: std_logic;
    signal tbis_m00_axi_init_axi_txn	: std_logic;
    signal tbis_m00_axi_txn_done	: std_logic;
    signal tbis_m00_axi_error	: std_logic;
    signal tbis_m00_axi_aclk	: std_logic;
    signal tbis_m00_axi_aresetn	: std_logic;
    signal tbis_m00_axi_awid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal tbis_m00_axi_awaddr	: std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
    signal tbis_m00_axi_awlen	: std_logic_vector(7 downto 0);
    signal tbis_m00_axi_awsize	: std_logic_vector(2 downto 0);
    signal tbis_m00_axi_awburst	: std_logic_vector(1 downto 0);
    signal tbis_m00_axi_awlock	: std_logic;
    signal tbis_m00_axi_awcache	: std_logic_vector(3 downto 0);
    signal tbis_m00_axi_awprot	: std_logic_vector(2 downto 0);
    signal tbis_m00_axi_awqos	: std_logic_vector(3 downto 0);
    signal tbis_m00_axi_awuser	: std_logic_vector(C_M00_AXI_AWUSER_WIDTH-1 downto 0);
    signal tbis_m00_axi_awvalid	: std_logic;
    signal tbis_m00_axi_awready	: std_logic;
    signal tbis_m00_axi_wdata	: std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
    signal tbis_m00_axi_wstrb	: std_logic_vector(C_M00_AXI_DATA_WIDTH/8-1 downto 0);
    signal tbis_m00_axi_wlast	: std_logic;
    signal tbis_m00_axi_wuser	: std_logic_vector(C_M00_AXI_WUSER_WIDTH-1 downto 0);
    signal tbis_m00_axi_wvalid	: std_logic;
    signal tbis_m00_axi_wready	: std_logic;
    signal tbis_m00_axi_bid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal tbis_m00_axi_bresp	: std_logic_vector(1 downto 0);
    signal tbis_m00_axi_buser	: std_logic_vector(C_M00_AXI_BUSER_WIDTH-1 downto 0);
    signal tbis_m00_axi_bvalid	: std_logic;
    signal tbis_m00_axi_bready	: std_logic;
    signal tbis_m00_axi_arid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal tbis_m00_axi_araddr	: std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
    signal tbis_m00_axi_arlen	: std_logic_vector(7 downto 0);
    signal tbis_m00_axi_arsize	: std_logic_vector(2 downto 0);
    signal tbis_m00_axi_arburst	: std_logic_vector(1 downto 0);
    signal tbis_m00_axi_arlock	: std_logic;
    signal tbis_m00_axi_arcache	: std_logic_vector(3 downto 0);
    signal tbis_m00_axi_arprot	: std_logic_vector(2 downto 0);
    signal tbis_m00_axi_arqos	: std_logic_vector(3 downto 0);
    signal tbis_m00_axi_aruser	: std_logic_vector(C_M00_AXI_ARUSER_WIDTH-1 downto 0);
    signal tbis_m00_axi_arvalid	: std_logic;
    signal tbis_m00_axi_arready	: std_logic;
    signal tbis_m00_axi_rid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal tbis_m00_axi_rdata	: std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
    signal tbis_m00_axi_rresp	: std_logic_vector(1 downto 0);
    signal tbis_m00_axi_rlast	: std_logic;
    signal tbis_m00_axi_ruser	: std_logic_vector(C_M00_AXI_RUSER_WIDTH-1 downto 0);
    signal tbis_m00_axi_rvalid	: std_logic;
    signal tbis_m00_axi_rready	: std_logic;
    signal tbis_s_axi_intr_aclk	: std_logic;
    signal tbis_s_axi_intr_aresetn	: std_logic;
    signal tbis_s_axi_intr_awaddr	: std_logic_vector(C_S_AXI_INTR_ADDR_WIDTH-1 downto 0);
    signal tbis_s_axi_intr_awprot	: std_logic_vector(2 downto 0);
    signal tbis_s_axi_intr_awvalid	: std_logic;
    signal tbis_s_axi_intr_awready	: std_logic;
    signal tbis_s_axi_intr_wdata	: std_logic_vector(C_S_AXI_INTR_DATA_WIDTH-1 downto 0);
    signal tbis_s_axi_intr_wstrb	: std_logic_vector((C_S_AXI_INTR_DATA_WIDTH/8)-1 downto 0);
    signal tbis_s_axi_intr_wvalid	: std_logic;
    signal tbis_s_axi_intr_wready	: std_logic;
    signal tbis_s_axi_intr_bresp	: std_logic_vector(1 downto 0);
    signal tbis_s_axi_intr_bvalid	: std_logic;
    signal tbis_s_axi_intr_bready	: std_logic;
    signal tbis_s_axi_intr_araddr	: std_logic_vector(C_S_AXI_INTR_ADDR_WIDTH-1 downto 0);
    signal tbis_s_axi_intr_arprot	: std_logic_vector(2 downto 0);
    signal tbis_s_axi_intr_arvalid	: std_logic;
    signal tbis_s_axi_intr_arready	: std_logic;
    signal tbis_s_axi_intr_rdata	: std_logic_vector(C_S_AXI_INTR_DATA_WIDTH-1 downto 0);
    signal tbis_s_axi_intr_rresp	: std_logic_vector(1 downto 0);
    signal tbis_s_axi_intr_rvalid	: std_logic;
    signal tbis_s_axi_intr_rready	: std_logic;
    signal tbis_irq	: std_logic;


    signal s_INPUT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"42000000";
    signal s_WEIGHT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"44000000";
    signal s_OUTPUT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"40000000";
    signal s_REG_00_ADDR			: std_logic_vector(31 downto 0) := x"43C00000";
    signal s_REG_01_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_02_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_03_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_04_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
	
    signal s_TEST_NUMBER    : integer := 0;     -- Part of tb template: For easier debugging

begin
	
    --------------------------------------------------
	-- Wiring
	--------------------------------------------------

    DUT0: ml_acc_conv_v1_0 
    port map(
        d_s_M00i_READ_START => tbis_d_s_M00i_READ_START,
        d_s_M00i_READ_ADDR => tbis_d_s_M00i_READ_ADDR,
        d_s_M00i_READ_LEN => tbis_d_s_M00i_READ_LEN,
        d_s_M00o_READ_RESULT => tbis_d_s_M00o_READ_RESULT,
        d_s_M00o_READ_RESULT_COUNTER => tbis_d_s_M00o_READ_RESULT_COUNTER,
        d_s_M00i_WRITE_START => tbis_d_s_M00i_WRITE_START,
        d_s_M00i_WRITE_ADDR => tbis_d_s_M00i_WRITE_ADDR,
        d_s_M00i_WRITE_DATA => tbis_d_s_M00i_WRITE_DATA,
        d_s_M00o_WRITE_DONE => tbis_d_s_M00o_WRITE_DONE,
        d_s_S00_reg10 => tbis_d_s_S00_reg10,
        d_s_read_started => tbis_d_s_read_started,
        d_s_write_started => tbis_d_s_write_started,
        s00_axi_aclk => tbis_s00_axi_aclk,
        s00_axi_aresetn => tbis_s00_axi_aresetn,
        s00_axi_awaddr => tbis_s00_axi_awaddr,
        s00_axi_awprot => tbis_s00_axi_awprot,
        s00_axi_awvalid => tbis_s00_axi_awvalid,
        s00_axi_awready => tbis_s00_axi_awready,
        s00_axi_wdata => tbis_s00_axi_wdata,
        s00_axi_wstrb => tbis_s00_axi_wstrb,
        s00_axi_wvalid => tbis_s00_axi_wvalid,
        s00_axi_wready => tbis_s00_axi_wready,
        s00_axi_bresp => tbis_s00_axi_bresp,
        s00_axi_bvalid => tbis_s00_axi_bvalid,
        s00_axi_bready => tbis_s00_axi_bready,
        s00_axi_araddr => tbis_s00_axi_araddr,
        s00_axi_arprot => tbis_s00_axi_arprot,
        s00_axi_arvalid => tbis_s00_axi_arvalid,
        s00_axi_arready => tbis_s00_axi_arready,
        s00_axi_rdata => tbis_s00_axi_rdata,
        s00_axi_rresp => tbis_s00_axi_rresp,
        s00_axi_rvalid => tbis_s00_axi_rvalid,
        s00_axi_rready => tbis_s00_axi_rready,
        m00_axi_init_axi_txn => tbis_m00_axi_init_axi_txn,
        m00_axi_txn_done => tbis_m00_axi_txn_done,
        m00_axi_error => tbis_m00_axi_error,
        m00_axi_aclk => tbis_s00_axi_aclk,
        m00_axi_aresetn => tbis_m00_axi_aresetn,
        m00_axi_awid => tbis_m00_axi_awid,
        m00_axi_awaddr => tbis_m00_axi_awaddr,
        m00_axi_awlen => tbis_m00_axi_awlen,
        m00_axi_awsize => tbis_m00_axi_awsize,
        m00_axi_awburst => tbis_m00_axi_awburst,
        m00_axi_awlock => tbis_m00_axi_awlock,
        m00_axi_awcache => tbis_m00_axi_awcache,
        m00_axi_awprot => tbis_m00_axi_awprot,
        m00_axi_awqos => tbis_m00_axi_awqos,
        m00_axi_awuser => tbis_m00_axi_awuser,
        m00_axi_awvalid => tbis_m00_axi_awvalid,
        m00_axi_awready => tbis_m00_axi_awready,
        m00_axi_wdata => tbis_m00_axi_wdata,
        m00_axi_wstrb => tbis_m00_axi_wstrb,
        m00_axi_wlast => tbis_m00_axi_wlast,
        m00_axi_wuser => tbis_m00_axi_wuser,
        m00_axi_wvalid => tbis_m00_axi_wvalid,
        m00_axi_wready => tbis_m00_axi_wready,
        m00_axi_bid => tbis_m00_axi_bid,
        m00_axi_bresp => tbis_m00_axi_bresp,
        m00_axi_buser => tbis_m00_axi_buser,
        m00_axi_bvalid => tbis_m00_axi_bvalid,
        m00_axi_bready => tbis_m00_axi_bready,
        m00_axi_arid => tbis_m00_axi_arid,
        m00_axi_araddr => tbis_m00_axi_araddr,
        m00_axi_arlen => tbis_m00_axi_arlen,
        m00_axi_arsize => tbis_m00_axi_arsize,
        m00_axi_arburst => tbis_m00_axi_arburst,
        m00_axi_arlock => tbis_m00_axi_arlock,
        m00_axi_arcache => tbis_m00_axi_arcache,
        m00_axi_arprot => tbis_m00_axi_arprot,
        m00_axi_arqos => tbis_m00_axi_arqos,
        m00_axi_aruser => tbis_m00_axi_aruser,
        m00_axi_arvalid => tbis_m00_axi_arvalid,
        m00_axi_arready => tbis_m00_axi_arready,
        m00_axi_rid => tbis_m00_axi_rid,
        m00_axi_rdata => tbis_m00_axi_rdata,
        m00_axi_rresp => tbis_m00_axi_rresp,
        m00_axi_rlast => tbis_m00_axi_rlast,
        m00_axi_ruser => tbis_m00_axi_ruser,
        m00_axi_rvalid => tbis_m00_axi_rvalid,
        m00_axi_rready => tbis_m00_axi_rready,
        s_axi_intr_aclk => tbis_s00_axi_aclk,
        s_axi_intr_aresetn => tbis_s_axi_intr_aresetn,
        s_axi_intr_awaddr => tbis_s_axi_intr_awaddr,
        s_axi_intr_awprot => tbis_s_axi_intr_awprot,
        s_axi_intr_awvalid => tbis_s_axi_intr_awvalid,
        s_axi_intr_awready => tbis_s_axi_intr_awready,
        s_axi_intr_wdata => tbis_s_axi_intr_wdata,
        s_axi_intr_wstrb => tbis_s_axi_intr_wstrb,
        s_axi_intr_wvalid => tbis_s_axi_intr_wvalid,
        s_axi_intr_wready => tbis_s_axi_intr_wready,
        s_axi_intr_bresp => tbis_s_axi_intr_bresp,
        s_axi_intr_bvalid => tbis_s_axi_intr_bvalid,
        s_axi_intr_bready => tbis_s_axi_intr_bready,
        s_axi_intr_araddr => tbis_s_axi_intr_araddr,
        s_axi_intr_arprot => tbis_s_axi_intr_arprot,
        s_axi_intr_arvalid => tbis_s_axi_intr_arvalid,
        s_axi_intr_arready => tbis_s_axi_intr_arready,
        s_axi_intr_rdata => tbis_s_axi_intr_rdata,
        s_axi_intr_rresp => tbis_s_axi_intr_rresp,
        s_axi_intr_rvalid => tbis_s_axi_intr_rvalid,
        s_axi_intr_rready => tbis_s_axi_intr_rready,
        irq => tbis_irq
    );


    --------------------------------------------------
	-- Processes
	--------------------------------------------------

    P_CLK: process	-- Process to setup the clock for the test bench
  	begin
		tbis_s00_axi_aclk <= '1';         	-- clock starts at 1
		wait for gCLK_HPER; 	-- after half a cycle
		tbis_s00_axi_aclk <= '0';         	-- clock becomes a 0 (negative edge)
		wait for gCLK_HPER; 	-- after half a cycle, process begins evaluation again
  	end process;


    
    P_TEST_CASES: process
	begin

        -------------------------
        -- Clock 0
        -------------------------
        tbis_s00_axi_aresetn    <= '0';
        tbis_m00_axi_aresetn    <= '0';
        tbis_s_axi_intr_aresetn <= '0';

        -- Initial state
        tbis_s00_axi_awvalid    <= '0';
        tbis_s00_axi_wvalid     <= '0';
        tbis_s00_axi_awaddr     <= b"00000" & b"00";
        tbis_s00_axi_wdata      <= x"00000000";
        tbis_s00_axi_bready     <= '0';

        s_TEST_NUMBER   <= s_TEST_NUMBER + 0;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 4;		-- Wait for 1 cycles

        -------------------------
        -- Clock 1
        -------------------------
        tbis_s00_axi_aresetn    <= '1';
        tbis_m00_axi_aresetn    <= '1';
        tbis_s_axi_intr_aresetn <= '1';
        
        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 2
        -------------------------
        tbis_s00_axi_awvalid    <= '1';
        tbis_s00_axi_wvalid     <= '1';
        -- tbis_s00_axi_awaddr     <= b"01010" & b"00";
        tbis_s00_axi_awaddr     <= b"11111" & b"00";
        -- tbis_s00_axi_wdata      <= x"00000001";
        tbis_s00_axi_wdata      <= x"FFFFFFFF";
        tbis_s00_axi_bready     <= '1';

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 3
        -------------------------
        
        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 4
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 5
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 6
        -------------------------
        -- I put these here so simu have a couple of cycles to process
        tbis_s00_axi_awvalid    <= '0';
        tbis_s00_axi_wvalid     <= '0';
        tbis_s00_axi_awaddr     <= b"00000" & b"00";
        tbis_s00_axi_wdata      <= x"00000000";
        tbis_s00_axi_bready     <= '0';

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 7
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 8
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 9
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 10
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 11
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 12
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 13
        -------------------------

        s_TEST_NUMBER   <= s_TEST_NUMBER + 1;   -- Part of tb template: For easier debugging
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- END OF TEST
        -------------------------
        
	end process;

end structural;
