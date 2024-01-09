-------------------------------------------------------------------------
-- Jonathan Tan (jona1115@iastate.edu)
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- Revision:
-- v0.1: Copied over old code (mine) from class (CPRE 487).
-------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ml_acc_conv_v1_0 is
	generic (
		-- Users to add parameters here
		-- NUMBER_OF_MACS			: integer	:= 200;	-- Maximum axi4 burst length is 256
		NUMBER_OF_MACS			: integer	:= 30;	-- For testing
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
end ml_acc_conv_v1_0;

architecture arch_imp of ml_acc_conv_v1_0 is
	--------------------------------------------------------------------------------
    -- Component Declaration --
    --------------------------------------------------------------------------------
	component ml_acc_conv_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 7
		);
		port (
        S00i_READ_START	  : in std_logic;
        S00i_READ_ADDR	  : in std_logic_vector(4 downto 0);
        S00o_READ_RESULT  : out std_logic_vector(31 downto 0);
        S00i_WRITE_START	: in std_logic;
        S00i_WRITE_ADDR	  : in std_logic_vector(4 downto 0);
        S00i_WRITE_DATA	  : in std_logic_vector(31 downto 0);
        S00o_WRITE_DONE   : out std_logic;

		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component ml_acc_conv_v1_0_S00_AXI;

	component ml_acc_conv_v1_0_M00_AXI is
		generic (
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M_AXI_BURST_LEN	: integer	:= 16;
		C_M_AXI_ID_WIDTH	: integer	:= 1;
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		C_M_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_M_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_M_AXI_WUSER_WIDTH	: integer	:= 0;
		C_M_AXI_RUSER_WIDTH	: integer	:= 0;
		C_M_AXI_BUSER_WIDTH	: integer	:= 0
		);
		port (
		-- Jonathan code start
		M00i_READ_START	    : in std_logic;
		M00i_READ_ADDR	    : in std_logic_vector(31 downto 0);
        M00i_READ_LEN       : in std_logic_vector(7 downto 0);
		M00o_READ_RESULT    : out std_logic_vector(31 downto 0);
		M00o_READ_RESULT_COUNTER : out std_logic_vector(15 downto 0);
		M00i_WRITE_START    : in std_logic;
		M00i_WRITE_ADDR	    : in std_logic_vector(31 downto 0);
		M00i_WRITE_DATA	    : in std_logic_vector(31 downto 0);
		M00o_WRITE_DONE     : out std_logic;
		-- Jonathan code end

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
	end component ml_acc_conv_v1_0_M00_AXI;

	component ml_acc_conv_v1_0_S_AXI_INTR is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5;
		C_NUM_OF_INTR	: integer	:= 1;
		C_INTR_SENSITIVITY	: std_logic_vector	:= x"FFFFFFFF";
		C_INTR_ACTIVE_STATE	: std_logic_vector	:= x"FFFFFFFF";
		C_IRQ_SENSITIVITY	: integer	:= 1;
		C_IRQ_ACTIVE_STATE	: integer	:= 1
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic;
		irq	: out std_logic
		);
	end component ml_acc_conv_v1_0_S_AXI_INTR;

	-- component M is
	-- 	port (
	-- 		i_0 	: in	std_logic_vector(32-1 downto 0);
	-- 		i_1 	: in	std_logic_vector(32-1 downto 0);
	-- 		o_0		: out   std_logic_vector(32-1 downto 0)	
	-- 	);
	-- end component M;
	
	
	--------------------------------------------------------------------------------
    -- Internal Signal Definitions --
    --------------------------------------------------------------------------------
	signal s_INACT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"40000000";
	signal s_WEIGHT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"42000000";
	signal s_OUTACT_BRAM_BASE_ADDR	: std_logic_vector(31 downto 0)	:= x"44000000";
	signal s_REG_00_ADDR			: std_logic_vector(31 downto 0) := x"43C00000";
	signal s_REG_01_ADDR			: std_logic_vector(31 downto 0) := x"43C00004";
	signal s_REG_02_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
	signal s_REG_03_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
	signal s_REG_04_ADDR			: std_logic_vector(31 downto 0) := x"00000000";
    signal s_REG_00_ADDR_LOC		: std_logic_vector(4 downto 0) := b"00000";
    signal s_REG_01_ADDR_LOC		: std_logic_vector(4 downto 0) := b"00001";
    signal s_REG_02_ADDR_LOC		: std_logic_vector(4 downto 0) := b"00010";
    signal s_REG_03_ADDR_LOC		: std_logic_vector(4 downto 0) := b"00011";
    signal s_REG_04_ADDR_LOC		: std_logic_vector(4 downto 0) := b"00100";
    signal s_REG_10_ADDR_LOC		: std_logic_vector(4 downto 0) := b"01010"; -- reg 10 is the start conv flag (driven by software)
    signal s_REG_11_ADDR_LOC		: std_logic_vector(4 downto 0) := b"01011"; -- reg 10 is the start conv flag (driven by software)

	-- Below signals are for interfacing with M00
    signal s_M00i_READ_START	    : std_logic;
    signal s_M00i_READ_ADDR	        : std_logic_vector(31 downto 0);
    signal s_M00i_READ_LEN          : std_logic_vector(7 downto 0);
    signal s_M00o_READ_RESULT       : std_logic_vector(31 downto 0);
    signal s_M00o_READ_RESULT_COUNTER : std_logic_vector(15 downto 0);
    signal s_M00i_WRITE_START       : std_logic;
    signal s_M00i_WRITE_ADDR	    : std_logic_vector(31 downto 0);
    signal s_M00i_WRITE_DATA	    : std_logic_vector(31 downto 0);
    signal s_M00o_WRITE_DONE        : std_logic;
	signal s_M00_INIT_AXI_TXN		: std_logic := '0';
	
    -- Below signals are for interfacing with S00
    signal s_S00i_READ_START	    : std_logic;
    signal s_S00i_READ_ADDR	        : std_logic_vector(4 downto 0);
    signal s_S00o_READ_RESULT       : std_logic_vector(31 downto 0);
    signal s_S00i_WRITE_START	    : std_logic;
    signal s_S00i_WRITE_ADDR	    : std_logic_vector(4 downto 0);
    signal s_S00i_WRITE_DATA	    : std_logic_vector(31 downto 0);
    signal s_S00o_WRITE_DONE        : std_logic;
    
    signal s_i_M00_read_result_counter : std_logic_vector(15 downto 0)  := x"0000"; -- "i" means internal within this component
    signal s_read_started           : std_logic := '0';
    signal s_write_started          : std_logic := '0';
    signal s_xxx_started            : std_logic := '0';
    
	signal s_S00_AXI_reg_0_addr		: std_logic_vector(6 downto 0)	:= b"0000000";
	type weights_array is array (0 to NUMBER_OF_MACS - 1) of std_logic_vector(31 downto 0);
	signal weights_arr	: weights_array;
	type inputs_array is array (0 to NUMBER_OF_MACS - 1) of std_logic_vector(31 downto 0);
	signal inputs_arr	: inputs_array;
	signal filter_expired	: std_logic;
	type parsum_array is array (0 to NUMBER_OF_MACS - 1) of std_logic_vector(63 downto 0);
	signal parsum_arr	: parsum_array;
	signal final_sum	: std_logic_vector(63 downto 0)	:= x"0000000000000000";

	-- Pipeline Stages
    type STATE_TYPE is (IDLE,
                        LOADING_WEIGHTS,
                        LOADING_IACT,
                        MAC,	-- M for Multiply
                        PREPARE_OUTPUT);
    signal state : STATE_TYPE := IDLE;
	
	signal s_ONEs 		: std_logic_vector(31 downto 0) := x"FFFFFFFF";
	signal s_ZEROs 		: std_logic_vector(31 downto 0) := x"00000000";

	--------------------------------------------------------------------------------
    -- Internal Component Definitions --
    --------------------------------------------------------------------------------
    type fifo_array is array (0 to NUMBER_OF_MACS - 1) of std_logic_vector(31 downto 0);
    signal fifo         : fifo_array;
    signal write_ptr    : natural range 0 to NUMBER_OF_MACS	:= 0;
    signal read_ptr     : natural range 0 to NUMBER_OF_MACS	:= 0;

begin

-- Instantiation of Axi Bus Interface S00_AXI
ml_acc_conv_v1_0_S00_AXI_inst : ml_acc_conv_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        S00i_READ_START     => s_S00i_READ_START,
		S00i_READ_ADDR      => s_S00i_READ_ADDR,
		S00o_READ_RESULT    => s_S00o_READ_RESULT,
		S00i_WRITE_START    => s_S00i_WRITE_START,
		S00i_WRITE_ADDR     => s_S00i_WRITE_ADDR,
		S00i_WRITE_DATA     => s_S00i_WRITE_DATA,
		S00o_WRITE_DONE     => s_S00o_WRITE_DONE,
        
		S_AXI_ACLK		=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA		=> s00_axi_wdata,
		S_AXI_WSTRB		=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP		=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA		=> s00_axi_rdata,
		S_AXI_RRESP		=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

-- Instantiation of Axi Bus Interface M00_AXI
ml_acc_conv_v1_0_M00_AXI_inst : ml_acc_conv_v1_0_M00_AXI
	generic map (
		C_M_TARGET_SLAVE_BASE_ADDR	=> C_M00_AXI_TARGET_SLAVE_BASE_ADDR,
		C_M_AXI_BURST_LEN	=> C_M00_AXI_BURST_LEN,
		C_M_AXI_ID_WIDTH	=> C_M00_AXI_ID_WIDTH,
		C_M_AXI_ADDR_WIDTH	=> C_M00_AXI_ADDR_WIDTH,
		C_M_AXI_DATA_WIDTH	=> C_M00_AXI_DATA_WIDTH,
		C_M_AXI_AWUSER_WIDTH	=> C_M00_AXI_AWUSER_WIDTH,
		C_M_AXI_ARUSER_WIDTH	=> C_M00_AXI_ARUSER_WIDTH,
		C_M_AXI_WUSER_WIDTH	=> C_M00_AXI_WUSER_WIDTH,
		C_M_AXI_RUSER_WIDTH	=> C_M00_AXI_RUSER_WIDTH,
		C_M_AXI_BUSER_WIDTH	=> C_M00_AXI_BUSER_WIDTH
	)
	port map (
		M00i_READ_START             => s_M00i_READ_START,
        M00i_READ_ADDR              => s_M00i_READ_ADDR,
        M00i_READ_LEN               => s_M00i_READ_LEN,
        M00o_READ_RESULT            => s_M00o_READ_RESULT,
        M00o_READ_RESULT_COUNTER    => s_M00o_READ_RESULT_COUNTER,
        M00i_WRITE_START            => s_M00i_WRITE_START,
        M00i_WRITE_ADDR             => s_M00i_WRITE_ADDR,
        M00i_WRITE_DATA             => s_M00i_WRITE_DATA,
        M00o_WRITE_DONE             => s_M00o_WRITE_DONE,

		-- INIT_AXI_TXN	=> m00_axi_init_axi_txn,
		-- Jonathan code start
		INIT_AXI_TXN	=> s_M00_INIT_AXI_TXN,
		-- Jonathan code end
		TXN_DONE		=> m00_axi_txn_done,
		ERROR			=> m00_axi_error,
		M_AXI_ACLK		=> m00_axi_aclk,
		M_AXI_ARESETN	=> m00_axi_aresetn,
		M_AXI_AWID		=> m00_axi_awid,
		M_AXI_AWADDR	=> m00_axi_awaddr,
		M_AXI_AWLEN		=> m00_axi_awlen,
		M_AXI_AWSIZE	=> m00_axi_awsize,
		M_AXI_AWBURST	=> m00_axi_awburst,
		M_AXI_AWLOCK	=> m00_axi_awlock,
		M_AXI_AWCACHE	=> m00_axi_awcache,
		M_AXI_AWPROT	=> m00_axi_awprot,
		M_AXI_AWQOS		=> m00_axi_awqos,
		M_AXI_AWUSER	=> m00_axi_awuser,
		M_AXI_AWVALID	=> m00_axi_awvalid,
		M_AXI_AWREADY	=> m00_axi_awready,
		M_AXI_WDATA		=> m00_axi_wdata,
		M_AXI_WSTRB		=> m00_axi_wstrb,
		M_AXI_WLAST		=> m00_axi_wlast,
		M_AXI_WUSER		=> m00_axi_wuser,
		M_AXI_WVALID	=> m00_axi_wvalid,
		M_AXI_WREADY	=> m00_axi_wready,
		M_AXI_BID		=> m00_axi_bid,
		M_AXI_BRESP		=> m00_axi_bresp,
		M_AXI_BUSER		=> m00_axi_buser,
		M_AXI_BVALID	=> m00_axi_bvalid,
		M_AXI_BREADY	=> m00_axi_bready,
		M_AXI_ARID		=> m00_axi_arid,
		M_AXI_ARADDR	=> m00_axi_araddr,
		M_AXI_ARLEN		=> m00_axi_arlen,
		M_AXI_ARSIZE	=> m00_axi_arsize,
		M_AXI_ARBURST	=> m00_axi_arburst,
		M_AXI_ARLOCK	=> m00_axi_arlock,
		M_AXI_ARCACHE	=> m00_axi_arcache,
		M_AXI_ARPROT	=> m00_axi_arprot,
		M_AXI_ARQOS		=> m00_axi_arqos,
		M_AXI_ARUSER	=> m00_axi_aruser,
		M_AXI_ARVALID	=> m00_axi_arvalid,
		M_AXI_ARREADY	=> m00_axi_arready,
		M_AXI_RID		=> m00_axi_rid,
		M_AXI_RDATA		=> m00_axi_rdata,
		M_AXI_RRESP		=> m00_axi_rresp,
		M_AXI_RLAST		=> m00_axi_rlast,
		M_AXI_RUSER		=> m00_axi_ruser,
		M_AXI_RVALID	=> m00_axi_rvalid,
		M_AXI_RREADY	=> m00_axi_rready
	);
-- Instantiation of Axi Bus Interface S_AXI_INTR
ml_acc_conv_v1_0_S_AXI_INTR_inst : ml_acc_conv_v1_0_S_AXI_INTR
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_INTR_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_INTR_ADDR_WIDTH,
		C_NUM_OF_INTR		=> C_NUM_OF_INTR,
		C_INTR_SENSITIVITY	=> C_INTR_SENSITIVITY,
		C_INTR_ACTIVE_STATE	=> C_INTR_ACTIVE_STATE,
		C_IRQ_SENSITIVITY	=> C_IRQ_SENSITIVITY,
		C_IRQ_ACTIVE_STATE	=> C_IRQ_ACTIVE_STATE
	)
	port map (
		S_AXI_ACLK			=> s_axi_intr_aclk,
		S_AXI_ARESETN		=> s_axi_intr_aresetn,
		S_AXI_AWADDR		=> s_axi_intr_awaddr,
		S_AXI_AWPROT		=> s_axi_intr_awprot,
		S_AXI_AWVALID		=> s_axi_intr_awvalid,
		S_AXI_AWREADY		=> s_axi_intr_awready,
		S_AXI_WDATA			=> s_axi_intr_wdata,
		S_AXI_WSTRB			=> s_axi_intr_wstrb,
		S_AXI_WVALID		=> s_axi_intr_wvalid,
		S_AXI_WREADY		=> s_axi_intr_wready,
		S_AXI_BRESP			=> s_axi_intr_bresp,
		S_AXI_BVALID		=> s_axi_intr_bvalid,
		S_AXI_BREADY		=> s_axi_intr_bready,
		S_AXI_ARADDR		=> s_axi_intr_araddr,
		S_AXI_ARPROT		=> s_axi_intr_arprot,
		S_AXI_ARVALID		=> s_axi_intr_arvalid,
		S_AXI_ARREADY		=> s_axi_intr_arready,
		S_AXI_RDATA			=> s_axi_intr_rdata,
		S_AXI_RRESP			=> s_axi_intr_rresp,
		S_AXI_RVALID		=> s_axi_intr_rvalid,
		S_AXI_RREADY		=> s_axi_intr_rready,
		irq					=> irq
	);

--

	-- All Below are Jonathan Code

	-- Debug ports mapping
    d_s_M00i_READ_START             <= s_M00i_READ_START;			-- Probe 0
    d_s_M00i_READ_ADDR              <= s_M00i_READ_ADDR;			-- Probe 1
    d_s_M00i_READ_LEN               <= s_M00i_READ_LEN;				-- Probe 2
    d_s_M00o_READ_RESULT            <= s_M00o_READ_RESULT;    		-- Probe 3
    d_s_M00o_READ_RESULT_COUNTER    <= s_M00o_READ_RESULT_COUNTER;	-- Probe 4
    d_s_M00i_WRITE_START            <= s_M00i_WRITE_START;    		-- Probe 5
    d_s_M00i_WRITE_ADDR             <= s_M00i_WRITE_ADDR;			-- Probe 6
    d_s_M00i_WRITE_DATA             <= s_M00i_WRITE_DATA;			-- Probe 7
    d_s_M00o_WRITE_DONE             <= s_M00o_WRITE_DONE;			-- Probe 8
	d_s_S00_reg10                   <= s_S00o_READ_RESULT;          -- Probe 9
	d_s_read_started				<= s_read_started;				-- Probe 10
	d_s_write_started				<= s_write_started;				-- Probe 11
	

	-- Create and connect 25 Multiply units in parallel
	gen_M_s: for i in 0 to NUMBER_OF_MACS - 1 generate
		parsum_arr(i) <= std_logic_vector(unsigned(weights_arr(i)) * unsigned(inputs_arr(i)));
	end generate;
	
    
    process (m00_axi_aclk) is
        begin
            if rising_edge(m00_axi_aclk) then	-- Rising Edge
            case state is  -- State
            when IDLE =>
                    -- Poll S00's reg 10
                    s_S00i_READ_START <= '1';
                    s_S00i_WRITE_START <= '0';
                    s_S00i_READ_ADDR <= s_REG_10_ADDR_LOC;

                    if (s_S00o_READ_RESULT = x"00000001") then
                    -- if (1 = 1) then
                    -- if (i_dummy = x"00000001") then 	-- remove after tb test
                        s_M00i_READ_START	<= '0';
                        s_M00i_READ_ADDR    <= s_ZEROs;
                        s_M00i_WRITE_START	<= '0';
                        s_M00i_WRITE_ADDR	<= s_ZEROs;
                        s_M00i_WRITE_DATA	<= s_ZEROs;
                        s_M00_INIT_AXI_TXN	<= '0';

                        state <= LOADING_WEIGHTS;
                    else
						s_M00i_READ_START	<= '0';		-- Reset everything to stay and idle
						s_M00i_WRITE_START	<= '0';		-- Reset everything to stay and idle
						s_read_started		<= '0';		-- Reset everything to stay and idle
						s_write_started		<= '0';		-- Reset everything to stay and idle
						
                        state <= IDLE;
                    end if;
                
                -- Wait here until we receive all weights
                when LOADING_WEIGHTS =>
                    -- Testing writing to S00 start
                    s_S00i_READ_START   <= '0';
                    s_S00i_WRITE_START  <= '1';
                    s_S00i_WRITE_ADDR   <= s_REG_00_ADDR_LOC;
                    s_S00i_WRITE_DATA   <= x"D00D1234";
					-- Test end
                
                    -- if (s_M00i_READ_START = '0' and s_read_started = '0') then
                    --     -- If read has not started ("start" is defined by s_M00i_READ_START and s_read_started being hi)
                    --     -------------------------------------------------------
                    --     -- Required signals to start read transaction start
                    --     s_M00_INIT_AXI_TXN  <= '1';
                    --     s_M00i_READ_START   <= '1';
                    --     s_M00i_WRITE_START  <= '0';
                    --     s_M00i_READ_ADDR    <= s_WEIGHT_BRAM_BASE_ADDR;
                    --     -- s_M00i_READ_LEN     <= b"00001010";
                    --     s_M00i_READ_LEN     <= NUMBER_OF_MACS_STDLV;
                    --     s_i_M00_read_result_counter <= (others => '0');
                    --     -- Required signals to start read transaction end
                    --     -------------------------------------------------------
                    --     s_read_started      <= '1';
                    -- elsif (s_read_started = '1') then
                    --     -- If read has started
                    --     if (s_M00i_READ_START = '1') then
                    --         -- This is the first cycle since read started, as my API is that s_M00i_READ_START will only be hi for one cycle
                    --         -------------------------------------------------------
                    --         -- Required signals to continue read transaction start
                    --         s_M00_INIT_AXI_TXN  <= '0';
                    --         s_M00i_READ_START   <= '0'; -- Ensure s_M00i_READ_START is only hi for one cycle
                    --         s_M00i_WRITE_START  <= '0';
                    --         -- Required signals to continue read transaction end
                    --         -------------------------------------------------------
                    --     end if;

                    --     s_i_M00_read_result_counter <= std_logic_vector(unsigned(s_i_M00_read_result_counter) + x"0001"); -- Increment counter (Internal)
                    --     -- Wait here until we recieve valid values
                    --     if (s_i_M00_read_result_counter = s_M00o_READ_RESULT_COUNTER) then -- If M00's counter also incremented
                    --         -- This means we got a new read result, so:
                            
                    --         -------------------------------------------------------
                    --         -- Adding stuff into FIFO start
                    --         fifo(write_ptr) <= s_M00o_READ_RESULT;
                    --         write_ptr <= write_ptr + 1;

                    --         if (write_ptr = NUMBER_OF_MACS) then -- aka fifo is full
                    --             -- Load (copy) all weights into weights array
                    --             -- Serial approach (used when hw resource is limited):
                    --             for i in 0 to NUMBER_OF_MACS - 1 loop
                    --                 weights_arr(i) <= fifo(i);
                    --             end loop;

                    --             -- Reset fifo write pointer
                    --             write_ptr <= 0;
                    --             -- Set next state
                    --             -- state	<= IDLE;		-- Delete this line once data-orcha test is complete
                    --             state	<= LOADING_IACT;    -- Go to next state
                    --         else -- aka fifo not full
                    --             state	<= LOADING_WEIGHTS;
                    --         end if;
                    --         -- Adding stuff into FIFO end
                    --         -------------------------------------------------------
                    --     else
                    --         -- Since we didnt get new read result, we should decrement the counter
                    --         s_i_M00_read_result_counter <= std_logic_vector(unsigned(s_i_M00_read_result_counter) - x"0001");
                    --     end if;
                    -- else
                    --     state           <= LOADING_WEIGHTS;
                    -- end if;

                -- EVERYTHING BELOW UNTESTED (NOT LIKE ABOVE IS TESTED BUT YEAH)

                when LOADING_IACT =>
                    -- Wait here until we recieve valid values
                    if m00_axi_rlast = '1' then
                        -- Add it into the FIFO
                        fifo(write_ptr) <= m00_axi_rdata;
                        write_ptr <= write_ptr + 1;

                        if (write_ptr = NUMBER_OF_MACS) then -- aka fifo is full
                            -- Load (copy) all weights into weights array
                            -- Serial approach (used when hw resource is limited):
                            for i in 0 to NUMBER_OF_MACS - 1 loop
                                inputs_arr(i) <= fifo(i);
                            end loop;
                            -- Parallel approach (look at LOADING_WEIGHTS stage!)

                            -- Tell M00 we are ready to load more data
                            -- m00_axi_rready	<= '1';	-- this cause error
                            -- Reset fifo write pointer
                            write_ptr <= 0;
                            -- Set next state
                            state	<= MAC;
                        else -- fifo not full
                            state	<= LOADING_IACT;
                        end if;
                    else
                        state	<= LOADING_IACT;
                    end if;

                when MAC =>
                    for i in 0 to NUMBER_OF_MACS - 1 loop
                        final_sum	<= std_logic_vector(unsigned(final_sum) + unsigned(parsum_arr(i)));
                    end loop;
                    state           <= PREPARE_OUTPUT;

                when PREPARE_OUTPUT =>
                    -- The "WB" stage, job is to prepare the output
                    filter_expired	<= '1'; -- TODO
                    if filter_expired = '1' then
                        state           <= LOADING_WEIGHTS;
                    else
                        state           <= LOADING_IACT;
                    end if;

                when others =>
                    state   <= IDLE;
                    -- Not really important, this case should never happen
                    -- Needed for proper synthesis
            end case;  -- State
        end if;  -- Rising Edge
    end process;
end arch_imp;