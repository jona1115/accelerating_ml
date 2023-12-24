-------------------------------------------------------------------------
-- Jonathan Tan
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- conv.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: TB for conv interface
-------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_conv is
	generic(
		gCLK_HPER 		: time		:= 10 ns;   -- Generic for half of the clock cycle period
		-- N 				: integer	:= 32;
		-- A 				: integer	:= 5;
		C_DATA_WIDTH 	: integer	:= 32;
		float_size		: integer	:= 8;
		m 				: integer	:= 4;
		n 				: integer	:= 4;
        -- Users to add parameters here
		NUMBER_OF_MACS			: integer	:= 800;
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

		-- Parameters of Axi Slave Bus Interface S01_AXI
		C_S01_AXI_ID_WIDTH	: integer	:= 1;
		C_S01_AXI_DATA_WIDTH	: integer	:= 32;
		C_S01_AXI_ADDR_WIDTH	: integer	:= 10;
		C_S01_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_WUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_RUSER_WIDTH	: integer	:= 0;
		C_S01_AXI_BUSER_WIDTH	: integer	:= 0;

		-- Parameters of Axi Slave Bus Interface S_AXI_INTR
		C_S_AXI_INTR_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_INTR_ADDR_WIDTH	: integer	:= 5;
		C_NUM_OF_INTR	: integer	:= 1;
		C_INTR_SENSITIVITY	: std_logic_vector	:= x"FFFFFFFF";
		C_INTR_ACTIVE_STATE	: std_logic_vector	:= x"FFFFFFFF";
		C_IRQ_SENSITIVITY	: integer	:= 1;
		C_IRQ_ACTIVE_STATE	: integer	:= 1)
	;
end tb_conv;

architecture structural of tb_conv is

	constant cCLK_PER	: time := gCLK_HPER * 2;	-- The total clock period time

	component mlp_conv_v1_0 is
        generic (
            -- Users to add parameters here
            NUMBER_OF_MACS			: integer	:= 800;
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
    
            -- Parameters of Axi Slave Bus Interface S01_AXI
            C_S01_AXI_ID_WIDTH	: integer	:= 1;
            C_S01_AXI_DATA_WIDTH	: integer	:= 32;
            C_S01_AXI_ADDR_WIDTH	: integer	:= 10;
            C_S01_AXI_AWUSER_WIDTH	: integer	:= 0;
            C_S01_AXI_ARUSER_WIDTH	: integer	:= 0;
            C_S01_AXI_WUSER_WIDTH	: integer	:= 0;
            C_S01_AXI_RUSER_WIDTH	: integer	:= 0;
            C_S01_AXI_BUSER_WIDTH	: integer	:= 0;
    
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
            d_s_M00i_READ_START	    : out std_logic;
            d_s_M00i_READ_ADDR	    : out std_logic_vector(31 downto 0);
            d_s_M00i_READ_LEN       : out std_logic_vector(7 downto 0);
            d_s_M00o_READ_RESULT    : out std_logic_vector(31 downto 0);
            d_s_M00o_READ_RESULT_COUNTER : out std_logic_vector(15 downto 0);
            d_s_M00i_WRITE_START	: out std_logic;
            d_s_M00i_WRITE_ADDR     : out std_logic_vector(31 downto 0);
            d_s_M00i_WRITE_DATA	    : out std_logic_vector(31 downto 0);
            d_s_M00o_WRITE_DONE     : out std_logic;

            -- i_dummy					: in std_logic_vector(31 downto 0); -- Remove me after tb testing
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
    
            -- Ports of Axi Slave Bus Interface S01_AXI
            s01_axi_aclk	: in std_logic;
            s01_axi_aresetn	: in std_logic;
            s01_axi_awid	: in std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
            s01_axi_awaddr	: in std_logic_vector(C_S01_AXI_ADDR_WIDTH-1 downto 0);
            s01_axi_awlen	: in std_logic_vector(7 downto 0);
            s01_axi_awsize	: in std_logic_vector(2 downto 0);
            s01_axi_awburst	: in std_logic_vector(1 downto 0);
            s01_axi_awlock	: in std_logic;
            s01_axi_awcache	: in std_logic_vector(3 downto 0);
            s01_axi_awprot	: in std_logic_vector(2 downto 0);
            s01_axi_awqos	: in std_logic_vector(3 downto 0);
            s01_axi_awregion	: in std_logic_vector(3 downto 0);
            s01_axi_awuser	: in std_logic_vector(C_S01_AXI_AWUSER_WIDTH-1 downto 0);
            s01_axi_awvalid	: in std_logic;
            s01_axi_awready	: out std_logic;
            s01_axi_wdata	: in std_logic_vector(C_S01_AXI_DATA_WIDTH-1 downto 0);
            s01_axi_wstrb	: in std_logic_vector((C_S01_AXI_DATA_WIDTH/8)-1 downto 0);
            s01_axi_wlast	: in std_logic;
            s01_axi_wuser	: in std_logic_vector(C_S01_AXI_WUSER_WIDTH-1 downto 0);
            s01_axi_wvalid	: in std_logic;
            s01_axi_wready	: out std_logic;
            s01_axi_bid	: out std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
            s01_axi_bresp	: out std_logic_vector(1 downto 0);
            s01_axi_buser	: out std_logic_vector(C_S01_AXI_BUSER_WIDTH-1 downto 0);
            s01_axi_bvalid	: out std_logic;
            s01_axi_bready	: in std_logic;
            s01_axi_arid	: in std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
            s01_axi_araddr	: in std_logic_vector(C_S01_AXI_ADDR_WIDTH-1 downto 0);
            s01_axi_arlen	: in std_logic_vector(7 downto 0);
            s01_axi_arsize	: in std_logic_vector(2 downto 0);
            s01_axi_arburst	: in std_logic_vector(1 downto 0);
            s01_axi_arlock	: in std_logic;
            s01_axi_arcache	: in std_logic_vector(3 downto 0);
            s01_axi_arprot	: in std_logic_vector(2 downto 0);
            s01_axi_arqos	: in std_logic_vector(3 downto 0);
            s01_axi_arregion	: in std_logic_vector(3 downto 0);
            s01_axi_aruser	: in std_logic_vector(C_S01_AXI_ARUSER_WIDTH-1 downto 0);
            s01_axi_arvalid	: in std_logic;
            s01_axi_arready	: out std_logic;
            s01_axi_rid	: out std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
            s01_axi_rdata	: out std_logic_vector(C_S01_AXI_DATA_WIDTH-1 downto 0);
            s01_axi_rresp	: out std_logic_vector(1 downto 0);
            s01_axi_rlast	: out std_logic;
            s01_axi_ruser	: out std_logic_vector(C_S01_AXI_RUSER_WIDTH-1 downto 0);
            s01_axi_rvalid	: out std_logic;
            s01_axi_rready	: in std_logic;
    
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


    signal CLK	: std_logic := '0';

    ------------------------------
    -- Component signals start
    -- signal s_i_dummy    : std_logic_vector(31 downto 0);
    signal s_d_s_M00i_READ_START	    : std_logic;
    signal s_d_s_M00i_READ_ADDR	    : std_logic_vector(31 downto 0);
    signal s_d_s_M00i_READ_LEN       : std_logic_vector(7 downto 0);
    signal s_d_s_M00o_READ_RESULT    : std_logic_vector(31 downto 0);
    signal s_d_s_M00o_READ_RESULT_COUNTER : std_logic_vector(15 downto 0);
    signal s_d_s_M00i_WRITE_START	: std_logic;
    signal s_d_s_M00i_WRITE_ADDR     : std_logic_vector(31 downto 0);
    signal s_d_s_M00i_WRITE_DATA	    : std_logic_vector(31 downto 0);
    signal s_d_s_M00o_WRITE_DONE     : std_logic;
    signal s_s00_axi_aresetn	: std_logic;
    signal s_s00_axi_awaddr	: std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
    signal s_s00_axi_awprot	: std_logic_vector(2 downto 0);
    signal s_s00_axi_awvalid	: std_logic;
    signal s_s00_axi_awready	: std_logic;
    signal s_s00_axi_wdata	: std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal s_s00_axi_wstrb	: std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
    signal s_s00_axi_wvalid	: std_logic;
    signal s_s00_axi_wready	: std_logic;
    signal s_s00_axi_bresp	: std_logic_vector(1 downto 0);
    signal s_s00_axi_bvalid	: std_logic;
    signal s_s00_axi_bready	: std_logic;
    signal s_s00_axi_araddr	: std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
    signal s_s00_axi_arprot	: std_logic_vector(2 downto 0);
    signal s_s00_axi_arvalid	: std_logic;
    signal s_s00_axi_arready	: std_logic;
    signal s_s00_axi_rdata	: std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal s_s00_axi_rresp	: std_logic_vector(1 downto 0);
    signal s_s00_axi_rvalid	: std_logic;
    signal s_s00_axi_rready	: std_logic;
    signal s_m00_axi_init_axi_txn	: std_logic;
    signal s_m00_axi_txn_done	: std_logic;
    signal s_m00_axi_error	: std_logic;
    signal s_m00_axi_aclk	: std_logic;
    signal s_m00_axi_aresetn	: std_logic;
    signal s_m00_axi_awid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal s_m00_axi_awaddr	: std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
    signal s_m00_axi_awlen	: std_logic_vector(7 downto 0);
    signal s_m00_axi_awsize	: std_logic_vector(2 downto 0);
    signal s_m00_axi_awburst	: std_logic_vector(1 downto 0);
    signal s_m00_axi_awlock	: std_logic;
    signal s_m00_axi_awcache	: std_logic_vector(3 downto 0);
    signal s_m00_axi_awprot	: std_logic_vector(2 downto 0);
    signal s_m00_axi_awqos	: std_logic_vector(3 downto 0);
    signal s_m00_axi_awuser	: std_logic_vector(C_M00_AXI_AWUSER_WIDTH-1 downto 0);
    signal s_m00_axi_awvalid	: std_logic;
    signal s_m00_axi_awready	: std_logic;
    signal s_m00_axi_wdata	: std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
    signal s_m00_axi_wstrb	: std_logic_vector(C_M00_AXI_DATA_WIDTH/8-1 downto 0);
    signal s_m00_axi_wlast	: std_logic;
    signal s_m00_axi_wuser	: std_logic_vector(C_M00_AXI_WUSER_WIDTH-1 downto 0);
    signal s_m00_axi_wvalid	: std_logic;
    signal s_m00_axi_wready	: std_logic;
    signal s_m00_axi_bid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal s_m00_axi_bresp	: std_logic_vector(1 downto 0);
    signal s_m00_axi_buser	: std_logic_vector(C_M00_AXI_BUSER_WIDTH-1 downto 0);
    signal s_m00_axi_bvalid	: std_logic;
    signal s_m00_axi_bready	: std_logic;
    signal s_m00_axi_arid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal s_m00_axi_araddr	: std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
    signal s_m00_axi_arlen	: std_logic_vector(7 downto 0);
    signal s_m00_axi_arsize	: std_logic_vector(2 downto 0);
    signal s_m00_axi_arburst	: std_logic_vector(1 downto 0);
    signal s_m00_axi_arlock	: std_logic;
    signal s_m00_axi_arcache	: std_logic_vector(3 downto 0);
    signal s_m00_axi_arprot	: std_logic_vector(2 downto 0);
    signal s_m00_axi_arqos	: std_logic_vector(3 downto 0);
    signal s_m00_axi_aruser	: std_logic_vector(C_M00_AXI_ARUSER_WIDTH-1 downto 0);
    signal s_m00_axi_arvalid	: std_logic;
    signal s_m00_axi_arready	: std_logic;
    signal s_m00_axi_rid	: std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
    signal s_m00_axi_rdata	: std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
    signal s_m00_axi_rresp	: std_logic_vector(1 downto 0);
    signal s_m00_axi_rlast	: std_logic;
    signal s_m00_axi_ruser	: std_logic_vector(C_M00_AXI_RUSER_WIDTH-1 downto 0);
    signal s_m00_axi_rvalid	: std_logic;
    signal s_m00_axi_rready	: std_logic;
    signal s_s01_axi_aclk	: std_logic;
    signal s_s01_axi_aresetn	: std_logic;
    signal s_s01_axi_awid	: std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
    signal s_s01_axi_awaddr	: std_logic_vector(C_S01_AXI_ADDR_WIDTH-1 downto 0);
    signal s_s01_axi_awlen	: std_logic_vector(7 downto 0);
    signal s_s01_axi_awsize	: std_logic_vector(2 downto 0);
    signal s_s01_axi_awburst	: std_logic_vector(1 downto 0);
    signal s_s01_axi_awlock	: std_logic;
    signal s_s01_axi_awcache	: std_logic_vector(3 downto 0);
    signal s_s01_axi_awprot	: std_logic_vector(2 downto 0);
    signal s_s01_axi_awqos	: std_logic_vector(3 downto 0);
    signal s_s01_axi_awregion	: std_logic_vector(3 downto 0);
    signal s_s01_axi_awuser	: std_logic_vector(C_S01_AXI_AWUSER_WIDTH-1 downto 0);
    signal s_s01_axi_awvalid	: std_logic;
    signal s_s01_axi_awready	: std_logic;
    signal s_s01_axi_wdata	: std_logic_vector(C_S01_AXI_DATA_WIDTH-1 downto 0);
    signal s_s01_axi_wstrb	: std_logic_vector((C_S01_AXI_DATA_WIDTH/8)-1 downto 0);
    signal s_s01_axi_wlast	: std_logic;
    signal s_s01_axi_wuser	: std_logic_vector(C_S01_AXI_WUSER_WIDTH-1 downto 0);
    signal s_s01_axi_wvalid	: std_logic;
    signal s_s01_axi_wready	: std_logic;
    signal s_s01_axi_bid	: std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
    signal s_s01_axi_bresp	: std_logic_vector(1 downto 0);
    signal s_s01_axi_buser	: std_logic_vector(C_S01_AXI_BUSER_WIDTH-1 downto 0);
    signal s_s01_axi_bvalid	: std_logic;
    signal s_s01_axi_bready	: std_logic;
    signal s_s01_axi_arid	: std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
    signal s_s01_axi_araddr	: std_logic_vector(C_S01_AXI_ADDR_WIDTH-1 downto 0);
    signal s_s01_axi_arlen	: std_logic_vector(7 downto 0);
    signal s_s01_axi_arsize	: std_logic_vector(2 downto 0);
    signal s_s01_axi_arburst	: std_logic_vector(1 downto 0);
    signal s_s01_axi_arlock	: std_logic;
    signal s_s01_axi_arcache	: std_logic_vector(3 downto 0);
    signal s_s01_axi_arprot	: std_logic_vector(2 downto 0);
    signal s_s01_axi_arqos	: std_logic_vector(3 downto 0);
    signal s_s01_axi_arregion	: std_logic_vector(3 downto 0);
    signal s_s01_axi_aruser	: std_logic_vector(C_S01_AXI_ARUSER_WIDTH-1 downto 0);
    signal s_s01_axi_arvalid	: std_logic;
    signal s_s01_axi_arready	: std_logic;
    signal s_s01_axi_rid	: std_logic_vector(C_S01_AXI_ID_WIDTH-1 downto 0);
    signal s_s01_axi_rdata	: std_logic_vector(C_S01_AXI_DATA_WIDTH-1 downto 0);
    signal s_s01_axi_rresp	: std_logic_vector(1 downto 0);
    signal s_s01_axi_rlast	: std_logic;
    signal s_s01_axi_ruser	: std_logic_vector(C_S01_AXI_RUSER_WIDTH-1 downto 0);
    signal s_s01_axi_rvalid	: std_logic;
    signal s_s01_axi_rready	: std_logic;
    signal s_s_axi_intr_aclk	: std_logic;
    signal s_s_axi_intr_aresetn	: std_logic;
    signal s_s_axi_intr_awaddr	: std_logic_vector(C_S_AXI_INTR_ADDR_WIDTH-1 downto 0);
    signal s_s_axi_intr_awprot	: std_logic_vector(2 downto 0);
    signal s_s_axi_intr_awvalid	: std_logic;
    signal s_s_axi_intr_awready	: std_logic;
    signal s_s_axi_intr_wdata	: std_logic_vector(C_S_AXI_INTR_DATA_WIDTH-1 downto 0);
    signal s_s_axi_intr_wstrb	: std_logic_vector((C_S_AXI_INTR_DATA_WIDTH/8)-1 downto 0);
    signal s_s_axi_intr_wvalid	: std_logic;
    signal s_s_axi_intr_wready	: std_logic;
    signal s_s_axi_intr_bresp	: std_logic_vector(1 downto 0);
    signal s_s_axi_intr_bvalid	: std_logic;
    signal s_s_axi_intr_bready	: std_logic;
    signal s_s_axi_intr_araddr	: std_logic_vector(C_S_AXI_INTR_ADDR_WIDTH-1 downto 0);
    signal s_s_axi_intr_arprot	: std_logic_vector(2 downto 0);
    signal s_s_axi_intr_arvalid	: std_logic;
    signal s_s_axi_intr_arready	: std_logic;
    signal s_s_axi_intr_rdata	: std_logic_vector(C_S_AXI_INTR_DATA_WIDTH-1 downto 0);
    signal s_s_axi_intr_rresp	: std_logic_vector(1 downto 0);
    signal s_s_axi_intr_rvalid	: std_logic;
    signal s_s_axi_intr_rready	: std_logic;
    signal s_irq	: std_logic;
    -- Component signals end
    ------------------------------

    
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

    DUT0: mlp_conv_v1_0 
    port map(
        d_s_M00i_READ_START   => s_d_s_M00i_READ_START,
        d_s_M00i_READ_ADDR    => s_d_s_M00i_READ_ADDR,
        d_s_M00i_READ_LEN   => s_d_s_M00i_READ_LEN,
        d_s_M00o_READ_RESULT   => s_d_s_M00o_READ_RESULT,
        d_s_M00o_READ_RESULT_COUNTER   => s_d_s_M00o_READ_RESULT_COUNTER,
        d_s_M00i_WRITE_START   => s_d_s_M00i_WRITE_START,
        d_s_M00i_WRITE_ADDR   => s_d_s_M00i_WRITE_ADDR,
        d_s_M00i_WRITE_DATA   => s_d_s_M00i_WRITE_DATA,
        d_s_M00o_WRITE_DONE   => s_d_s_M00o_WRITE_DONE,
        -- i_dummy => s_i_dummy,
        s00_axi_aclk   => CLK,
        s00_axi_aresetn   => s_s00_axi_aresetn,
        s00_axi_awaddr    => s_s00_axi_awaddr,
        s00_axi_awprot    => s_s00_axi_awprot,
        s00_axi_awvalid   => s_s00_axi_awvalid,
        s00_axi_awready   => s_s00_axi_awready,
        s00_axi_wdata   => s_s00_axi_wdata,
        s00_axi_wstrb   => s_s00_axi_wstrb,
        s00_axi_wvalid    => s_s00_axi_wvalid,
        s00_axi_wready    => s_s00_axi_wready,
        s00_axi_bresp   => s_s00_axi_bresp,
        s00_axi_bvalid    => s_s00_axi_bvalid,
        s00_axi_bready    => s_s00_axi_bready,
        s00_axi_araddr    => s_s00_axi_araddr,
        s00_axi_arprot    => s_s00_axi_arprot,
        s00_axi_arvalid   => s_s00_axi_arvalid,
        s00_axi_arready   => s_s00_axi_arready,
        s00_axi_rdata   => s_s00_axi_rdata,
        s00_axi_rresp   => s_s00_axi_rresp,
        s00_axi_rvalid    => s_s00_axi_rvalid,
        s00_axi_rready    => s_s00_axi_rready,
        m00_axi_init_axi_txn   => s_m00_axi_init_axi_txn,
        m00_axi_txn_done   => s_m00_axi_txn_done,
        m00_axi_error   => s_m00_axi_error,
        m00_axi_aclk   => CLK,
        m00_axi_aresetn   => s_m00_axi_aresetn,
        m00_axi_awid   => s_m00_axi_awid,
        m00_axi_awaddr    => s_m00_axi_awaddr,
        m00_axi_awlen   => s_m00_axi_awlen,
        m00_axi_awsize    => s_m00_axi_awsize,
        m00_axi_awburst   => s_m00_axi_awburst,
        m00_axi_awlock    => s_m00_axi_awlock,
        m00_axi_awcache   => s_m00_axi_awcache,
        m00_axi_awprot    => s_m00_axi_awprot,
        m00_axi_awqos   => s_m00_axi_awqos,
        m00_axi_awuser    => s_m00_axi_awuser,
        m00_axi_awvalid   => s_m00_axi_awvalid,
        m00_axi_awready   => s_m00_axi_awready,
        m00_axi_wdata   => s_m00_axi_wdata,
        m00_axi_wstrb   => s_m00_axi_wstrb,
        m00_axi_wlast   => s_m00_axi_wlast,
        m00_axi_wuser   => s_m00_axi_wuser,
        m00_axi_wvalid    => s_m00_axi_wvalid,
        m00_axi_wready    => s_m00_axi_wready,
        m00_axi_bid   => s_m00_axi_bid,
        m00_axi_bresp   => s_m00_axi_bresp,
        m00_axi_buser   => s_m00_axi_buser,
        m00_axi_bvalid    => s_m00_axi_bvalid,
        m00_axi_bready    => s_m00_axi_bready,
        m00_axi_arid   => s_m00_axi_arid,
        m00_axi_araddr    => s_m00_axi_araddr,
        m00_axi_arlen   => s_m00_axi_arlen,
        m00_axi_arsize    => s_m00_axi_arsize,
        m00_axi_arburst   => s_m00_axi_arburst,
        m00_axi_arlock    => s_m00_axi_arlock,
        m00_axi_arcache   => s_m00_axi_arcache,
        m00_axi_arprot    => s_m00_axi_arprot,
        m00_axi_arqos   => s_m00_axi_arqos,
        m00_axi_aruser    => s_m00_axi_aruser,
        m00_axi_arvalid   => s_m00_axi_arvalid,
        m00_axi_arready   => s_m00_axi_arready,
        m00_axi_rid   => s_m00_axi_rid,
        m00_axi_rdata   => s_m00_axi_rdata,
        m00_axi_rresp   => s_m00_axi_rresp,
        m00_axi_rlast   => s_m00_axi_rlast,
        m00_axi_ruser   => s_m00_axi_ruser,
        m00_axi_rvalid    => s_m00_axi_rvalid,
        m00_axi_rready    => s_m00_axi_rready,
        s01_axi_aclk   => CLK,
        s01_axi_aresetn   => s_s01_axi_aresetn,
        s01_axi_awid   => s_s01_axi_awid,
        s01_axi_awaddr    => s_s01_axi_awaddr,
        s01_axi_awlen   => s_s01_axi_awlen,
        s01_axi_awsize    => s_s01_axi_awsize,
        s01_axi_awburst   => s_s01_axi_awburst,
        s01_axi_awlock    => s_s01_axi_awlock,
        s01_axi_awcache   => s_s01_axi_awcache,
        s01_axi_awprot    => s_s01_axi_awprot,
        s01_axi_awqos   => s_s01_axi_awqos,
        s01_axi_awregion   => s_s01_axi_awregion,
        s01_axi_awuser    => s_s01_axi_awuser,
        s01_axi_awvalid   => s_s01_axi_awvalid,
        s01_axi_awready   => s_s01_axi_awready,
        s01_axi_wdata   => s_s01_axi_wdata,
        s01_axi_wstrb   => s_s01_axi_wstrb,
        s01_axi_wlast   => s_s01_axi_wlast,
        s01_axi_wuser   => s_s01_axi_wuser,
        s01_axi_wvalid    => s_s01_axi_wvalid,
        s01_axi_wready    => s_s01_axi_wready,
        s01_axi_bid   => s_s01_axi_bid,
        s01_axi_bresp   => s_s01_axi_bresp,
        s01_axi_buser   => s_s01_axi_buser,
        s01_axi_bvalid    => s_s01_axi_bvalid,
        s01_axi_bready    => s_s01_axi_bready,
        s01_axi_arid   => s_s01_axi_arid,
        s01_axi_araddr    => s_s01_axi_araddr,
        s01_axi_arlen   => s_s01_axi_arlen,
        s01_axi_arsize    => s_s01_axi_arsize,
        s01_axi_arburst   => s_s01_axi_arburst,
        s01_axi_arlock    => s_s01_axi_arlock,
        s01_axi_arcache   => s_s01_axi_arcache,
        s01_axi_arprot    => s_s01_axi_arprot,
        s01_axi_arqos   => s_s01_axi_arqos,
        s01_axi_arregion   => s_s01_axi_arregion,
        s01_axi_aruser    => s_s01_axi_aruser,
        s01_axi_arvalid   => s_s01_axi_arvalid,
        s01_axi_arready   => s_s01_axi_arready,
        s01_axi_rid   => s_s01_axi_rid,
        s01_axi_rdata   => s_s01_axi_rdata,
        s01_axi_rresp   => s_s01_axi_rresp,
        s01_axi_rlast   => s_s01_axi_rlast,
        s01_axi_ruser   => s_s01_axi_ruser,
        s01_axi_rvalid    => s_s01_axi_rvalid,
        s01_axi_rready    => s_s01_axi_rready,
        s_axi_intr_aclk   => s_s_axi_intr_aclk,
        s_axi_intr_aresetn    => s_s_axi_intr_aresetn,
        s_axi_intr_awaddr   => s_s_axi_intr_awaddr,
        s_axi_intr_awprot   => s_s_axi_intr_awprot,
        s_axi_intr_awvalid    => s_s_axi_intr_awvalid,
        s_axi_intr_awready    => s_s_axi_intr_awready,
        s_axi_intr_wdata   => s_s_axi_intr_wdata,
        s_axi_intr_wstrb   => s_s_axi_intr_wstrb,
        s_axi_intr_wvalid   => s_s_axi_intr_wvalid,
        s_axi_intr_wready   => s_s_axi_intr_wready,
        s_axi_intr_bresp   => s_s_axi_intr_bresp,
        s_axi_intr_bvalid   => s_s_axi_intr_bvalid,
        s_axi_intr_bready   => s_s_axi_intr_bready,
        s_axi_intr_araddr   => s_s_axi_intr_araddr,
        s_axi_intr_arprot   => s_s_axi_intr_arprot,
        s_axi_intr_arvalid    => s_s_axi_intr_arvalid,
        s_axi_intr_arready    => s_s_axi_intr_arready,
        s_axi_intr_rdata   => s_s_axi_intr_rdata,
        s_axi_intr_rresp   => s_s_axi_intr_rresp,
        s_axi_intr_rvalid   => s_s_axi_intr_rvalid,
        s_axi_intr_rready   => s_s_axi_intr_rready,
        irq   => s_irq
    );


    --------------------------------------------------
	-- Processes
	--------------------------------------------------

    P_CLK: process	-- Process to setup the clock for the test bench
  	begin
		CLK <= '1';         	-- clock starts at 1
		wait for gCLK_HPER; 	-- after half a cycle
		CLK <= '0';         	-- clock becomes a 0 (negative edge)
		wait for gCLK_HPER; 	-- after half a cycle, process begins evaluation again
  	end process;


    
    P_TEST_CASES: process
	begin

        -------------------------
        -- Clock 0
        -------------------------
        -- s_i_dummy   <= x"00000000";
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 1
        -------------------------
        -- s_i_dummy   <= x"00000001"; -- Make it change state
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 2
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 3
        -------------------------
        
        wait for gCLK_HPER * 2;		-- Wait for 1 cycles

        -------------------------
        -- Clock 4
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 5
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 6
        -------------------------

        wait for gCLK_HPER * 2;		-- Wait for 1 cycles
        
        -------------------------
        -- Clock 7
        -------------------------

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
        
	end process;

end structural;
