//*******************************************************************************************
// TOP-LEVEL VERILOG FOR RDC
//-------------------------------------------------------------------------------------------
// < COMPILER DIRECTIVES >
//  RDCv3_def.v must precede whenever this file is used.
//-------------------------------------------------------------------------------------------
// < UPDATE HISTORY >
//  Jun 09 2017 -   First commit for RDCv1 (Yejoogn Kim)
//  Oct 04 2017 -   Updated for RDCv2 (Yejoogn Kim)
//                      Buf fixes in brdc_top
//                      Isolation fix (brdc_top DOUT)
//  Jul 19 2018 -   Updated for RDCv3 Family (Yejoong Kim)
//                      Use of MBus Release 05
//                      Use of ESD_PAD_TSMC180_rev3
//                      New RDC (RDC_TOP_v1p3) designed by Seok Hyeon Jeong.
//                      Pad Name Changes
//                          PAD_RDC_VEXP -> PAD_VH
//                          PAD_RDC_INP  -> PAD_VP
//                          PAD_RDC_INN  -> PAD_VN
//-------------------------------------------------------------------------------------------
// < AUTHOR > 
//  Yejoong Kim (yejoong@umich.edu)
//******************************************************************************************* 

module RDCv3 (
    PAD_CIN,
    PAD_COUT,
    PAD_DIN,
    PAD_DOUT,
    PAD_VH,
    PAD_VP,
    PAD_VN
    );

    //******************************
    // Top IO
    //******************************
    //VDD_3P6
    //VDD_1P2
    //VDD_0P6
    //VDD_1P2_MBC
    //VDD_1P2_LC
    //VDD_0P6_LC
    //VSS
    input       PAD_CIN;
    output      PAD_COUT;
    input       PAD_DIN;
    output      PAD_DOUT;

    input       PAD_VH;
    input       PAD_VP;
    input       PAD_VN;

    //******************************
    // Internal Wire Declerations
    //******************************

    // Power-on-Reset
    wire        resetn;
    wire        reset_3p6;
    wire        reset_3p6_buf;

    // Pads
    wire        cin, cout;
    wire        din, dout;
    wire        esd_detect;

    // MBus
    wire        mbc_sleep, mbc_sleep_b;
    wire        mbc_isolate, mbc_isolate_b;
    wire        mbc_reset, mbc_reset_b;

    wire [31:0] lc2mbc_tx_addr, lc2mbc_tx_addr_uniso;
    wire [31:0] lc2mbc_tx_data, lc2mbc_tx_data_uniso;
    wire        lc2mbc_tx_pend, lc2mbc_tx_pend_uniso;
    wire        lc2mbc_tx_req, lc2mbc_tx_req_uniso;
    wire        lc2mbc_tx_priority, lc2mbc_tx_priority_uniso;
    wire        lc2mbc_tx_resp_ack, lc2mbc_tx_resp_ack_uniso;
    wire        lc2mbc_rx_ack, lc2mbc_rx_ack_uniso;

    wire        mbc2lc_tx_ack;
    wire [31:0] mbc2lc_rx_addr;
    wire [31:0] mbc2lc_rx_data;
    wire        mbc2lc_rx_pend;
    wire        mbc2lc_rx_req;
    wire        mbc2lc_rx_broadcast;
    
    wire        mbc2lc_rx_fail;
    wire        mbc2lc_tx_fail;
    wire        mbc2lc_tx_succ;
    
    wire        lc_sleep, lc_sleep_b, lc_sleep_uniso;
    wire        lc_clkenb, lc_clken, lc_clkenb_uniso;
    wire        lc_reset, lc_reset_b, lc_reset_uniso;
    wire        lc_isolate, lc_isolate_uniso;

    wire [3:0]  mbc2mc_addr;
    wire        mc2mbc_valid;
    wire        mbc2mc_write;
    wire        mbc2mc_resetn;
    wire [3:0]  mc2mbc_addr;
    wire        mbc2mc_cout;
    wire        mbc2mc_dout;
    wire        mc2mbc_wakeup_req;
    wire        mbc2mc_clr_wakeup_req;
    wire        mbc2mc_mbus_busy;
    wire        mbc2mc_sleep_req;

    // Layer_Ctrl <-> Memory Interface
    `ifdef RDCv3_LAYERCTRL_MEM_ENABLE
    wire        lc2mem_req;
    wire        lc2mem_write;
    wire        lc2mem_pend;
    wire [31:0] lc2mem_wr_data;
    wire [31:0] lc2mem_addr;
    wire [31:0] mem2lc_rd_data;
    wire        mem2lc_ack;
    `endif

    // RDC Signals @ VDD_1P2
    wire [16:0] rdc_dout_os_uniso;
    wire        rdc_irq, rdc_irq_uniso;
    wire        rdc_clr_irq, rdc_clr_irq_uniso;

    // Wakeup Request
    wire        wakeup_req;

    // RDC Signals @ VDD_3P6
    wire [4:0] rdc_vref_i_amp_lc_3p6;
    wire [5:0] rdc_vcm_r_sel_lc_3p6;
    wire [1:0] rdc_i_vcm_gen_n_lc_3p6;
    wire [4:0] rdc_sel_vb2_lc_3p6;
    wire [2:0] rdc_sel_vb3b_lc_3p6;
    wire [4:0] rdc_sel_gain_lc_3p6;
    wire [4:0] rdc_offset_p_lc_3p6;
    wire [4:0] rdc_offset_pb_lc_3p6;
    wire [2:0] rdc_offset_seln_b_lc_3p6;
    wire [2:0] rdc_offset_selp_b_lc_3p6;
    wire [2:0] rdc_i_buf_vh_n_lc_3p6;

    // Layer_Ctrl <-> MBus RF Interface
    //---- genRF Beginning of Wire Declaration ----//
    wire [44:0] lc2rf_addr_in;
    wire [23:0] lc2rf_data_in;
    //Register 0x00 (  0)
    wire        wakeup_upon_rdc_irq;
    wire        mbc_wakeup_on_pend_req;
    wire        mbc_ignore_rx_fail;
    wire [ 1:0] lc_clk_div;
    wire [ 1:0] lc_clk_ring;
    //Register 0x01 (  1)
    wire [ 7:0] irq_rply_short_addr;
    wire [ 7:0] irq_rply_reg_addr;
    //Register 0x02 (  2)
    wire [ 7:0] irq_rply_pyld_reg_addr;
    wire [ 7:0] irq_rply_pyld_length_1;
    //Register 0x10 ( 16)
    wire [23:0] rdc_signature;
    //Register 0x11 ( 17)
    wire [16:0] rdc_dout_os;
    //Register 0x20 ( 32)
    wire        rdc_isolate;
    wire        rdc_isolate_b; // Inverted Signal of rdc_isolate
    wire        rdc_resetn_fsm;
    wire [ 8:0] rdc_cnt_init;
    wire [ 4:0] rdc_cnt_amp1;
    wire        rdc_en_az;
    //Register 0x21 ( 33)
    wire [ 3:0] rdc_cnt_az_resetb;
    wire [ 4:0] rdc_cnt_store;
    wire [ 4:0] rdc_cnt_redis;
    wire [ 4:0] rdc_cnt_amp2;
    //Register 0x22 ( 34)
    wire [ 3:0] rdc_cnt_idle;
    wire [ 1:0] rdc_cnt_skip;
    wire [ 6:0] rdc_osr;
    //Register 0x23 ( 35)
    wire [ 4:0] rdc_vref_i_amp_lc;
    wire [ 4:0] rdc_vref_i_amp_lc_b; // Inverted Signal of rdc_vref_i_amp_lc
    wire [ 5:0] rdc_vcm_r_sel_lc;
    wire [ 5:0] rdc_vcm_r_sel_lc_b; // Inverted Signal of rdc_vcm_r_sel_lc
    wire [ 1:0] rdc_i_vcm_gen_n_lc;
    wire [ 1:0] rdc_i_vcm_gen_n_lc_b; // Inverted Signal of rdc_i_vcm_gen_n_lc
    //Register 0x24 ( 36)
    wire [ 3:0] rdc_sel_dly;
    wire        rdc_sel_store;
    wire [ 4:0] rdc_sel_vb2_lc;
    wire [ 4:0] rdc_sel_vb2_lc_b; // Inverted Signal of rdc_sel_vb2_lc
    wire [ 2:0] rdc_sel_vb3b_lc;
    wire [ 2:0] rdc_sel_vb3b_lc_b; // Inverted Signal of rdc_sel_vb3b_lc
    wire [ 4:0] rdc_sel_gain_lc;
    wire [ 4:0] rdc_sel_gain_lc_b; // Inverted Signal of rdc_sel_gain_lc
    //Register 0x25 ( 37)
    wire [ 4:0] rdc_offset_p_lc;
    wire [ 4:0] rdc_offset_p_lc_b; // Inverted Signal of rdc_offset_p_lc
    wire [ 4:0] rdc_offset_pb_lc;
    wire [ 4:0] rdc_offset_pb_lc_b; // Inverted Signal of rdc_offset_pb_lc
    wire [ 2:0] rdc_i_amp_biasgen;
    //Register 0x26 ( 38)
    wire [ 2:0] rdc_offset_seln_b_lc;
    wire [ 2:0] rdc_offset_seln_b_lc_b; // Inverted Signal of rdc_offset_seln_b_lc
    wire [ 2:0] rdc_offset_selp_b_lc;
    wire [ 2:0] rdc_offset_selp_b_lc_b; // Inverted Signal of rdc_offset_selp_b_lc
    wire        rdc_sel_adc_mode;
    wire        rdc_enb_dwa;
    //Register 0x27 ( 39)
    wire [ 2:0] rdc_i_buf_vh_n_lc;
    wire [ 2:0] rdc_i_buf_vh_n_lc_b; // Inverted Signal of rdc_i_buf_vh_n_lc
    //Register 0x28 ( 40)
    wire        rdc_reset_rc_osc;
    wire [ 3:0] rdc_r_ref;
    wire [ 3:0] rdc_i_buf;
    wire [ 3:0] rdc_i_buf2;
    wire [ 3:0] rdc_i_cmp;
    wire [ 1:0] rdc_i_mirror;
    //Register 0x29 ( 41)
    wire [14:0] rdc_pdiff;
    //Register 0x2A ( 42)
    wire [23:0] rdc_poly;
    //Register 0x2B ( 43)
    wire [ 2:0] rdc_mim;
    wire [ 2:0] rdc_mom;
    wire        rdc_clk_isolate;
    //Register 0x2C ( 44)
    wire        rdc_en_pg_fsm;
    wire        rdc_en_pg_amp_v1p2;
    wire        rdc_en_pg_adc_v1p2;
    wire        rdc_en_pg_buf_vh_v1p2;
    wire        rdc_en_pg_rc_osc;
    wire        rdc_enb_pg_vref;
    wire        rdc_enb_pg_amp_vbat;
    wire        rdc_enb_pg_adc_vbat;
    wire        rdc_enb_mirror_ldo;
    wire        rdc_enb_pg_buf_vcm;
    wire        rdc_enb_pg_buf_vh_vbat;
    //---- genRF End of Wire Declaration ----//

    // Clock
    wire   clk_lc;

    //*************************
    // Pads
    //*************************
    // Power
    PAD_100x60_DVDD_TP_TP_TSMC180_rev3  PAD_VDD_3P6_0   (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS)
    PAD_100x60_VDD_TP_TP_TSMC180_rev3   PAD_VDD_1P2_0   (); // DVDD(VDD_3P6), DVSS(VSS), VDD(VDD_1P2)
    PAD_100x60_VDD_ED_TP_TSMC180_rev3   PAD_VDD_0P6_0   (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS), VDD(VDD_0P6)
    PAD_100x60_DVSS_TP_TP_TSMC180_rev3  PAD_VSS_0       (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS)

    // MBus
    PAD_50x60_DI_ST_TP_TSMC180_rev3     PAD_DIN_CIN_0   (.PAD(PAD_CIN),  .Y(cin) ); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DO_TP_TP_TSMC180_rev3     PAD_DOUT_COUT_0 (.PAD(PAD_COUT), .A(cout)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DI_TP_TP_TSMC180_rev3     PAD_DIN_DIN_0   (.PAD(PAD_DIN),  .Y(din) ); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DO_TP_TP_TSMC180_rev3     PAD_DOUT_DOUT_0 (.PAD(PAD_DOUT), .A(dout)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)

    // Resistor Connection
    PAD_50x60_BWS_TP_AM_TSMC180_rev3    PAD_VH_0    (.PAD(PAD_VH)); // DVDD(VDD_3P6), DVSS(VSS)
    PAD_50x60_VSS_TP_TP_TSMC180_rev3    PAD_VSS_1   (); // DVDD(VDD_3P6), DVSS(VSS), VSS(VSS)
    PAD_50x60_BWS_TP_AM_TSMC180_rev3    PAD_VP_0    (.PAD(PAD_VP)); // DVDD(VDD_3P6), DVSS(VSS)
    PAD_50x60_BWS_TP_AM_TSMC180_rev3    PAD_VN_0    (.PAD(PAD_VN)); // DVDD(VDD_3P6), DVSS(VSS)

    //******************************
    // Reset Detector (Dual)
    //******************************
    RSTDTCTRG_DUAL_TSMC180 rdcv3_rstdtctrg_dual_0 (
        //Power
        //.VDD_3P6  (VDD_3P6)
        //.VDD_1P2  (VDD_1P2)
        //.VDD_0P6  (VDD_0P6)
        //.VSS      (VSS)
        .RESETn_V1P2    (resetn),
        .RESETn_V3P6    (), // not used
        .RESET_V3P6     (reset_3p6)
        );

    //******************************
    // Layer Controller Header
    //******************************
    HEADER_1P2_PH100_0P6_NH100_PS100_TSMC180 rdcv3_lc_header_0 (
        //Power
        //.VDD_1P2   (VDD_1P2)
        //.VDD_0P6   (VDD_0P6)
        //.VVDD_1P2  (VDD_1P2_LC)
        //.VVDD_0P6  (VDD_0P6_LC)
        //.VSS       (VSS)
       .SLEEP (lc_sleep)
       );

    //******************************
    // MBC Power Gate Header
    //******************************
    HEADER_1P2_PH100_TSMC180 rdcv3_mbc_header_0 (
        //Power
        //.VDD_1P2      (VDD_1P2)
        //.VVDD_1P2     (VDD_1P2_MBC)
        //.VSS          (VSS)
       .SLEEP (mbc_sleep)
       );

    //*************************
    // Clock Generator
    //*************************
    CLK_GEN_V1_B_TSMC180 rdcv3_clkgen_0 (
        //Power 
        //.VDD_1P2    (VDD_1P2)
        //.VDD_0P6_PG (VDD_0P6_LC)
        //.VSS        (VSS)
       .EN_B        (lc_clkenb),
       .ISOLATE     (lc_isolate),
       .S_DIV       (lc_clk_div),
       .S_RING      (lc_clk_ring),
       .CLK_1P2     (clk_lc)
       );
   
    //******************************
    // Bus Controller (MBC)
    //******************************
    //Power Domain: PD1P2_MBC
    rdcv3_mbus_node  #(.ADDRESS(`RDCv3_MBUS_FULL_PREFIX))
    rdcv3_mbus_node_0 (
        .RESETn       (mbc_reset_b),
        .CIN          (cin),
        .DIN          (din),
        .COUT         (mbc2mc_cout),
        .DOUT         (mbc2mc_dout),
        .TX_ADDR      (lc2mbc_tx_addr),
        .TX_DATA      (lc2mbc_tx_data),
        .TX_PEND      (lc2mbc_tx_pend),
        .TX_REQ       (lc2mbc_tx_req),
        .TX_ACK       (mbc2lc_tx_ack),
        .TX_PRIORITY  (lc2mbc_tx_priority),
        .RX_ADDR      (mbc2lc_rx_addr),
        .RX_DATA      (mbc2lc_rx_data),
        .RX_PEND      (mbc2lc_rx_pend),
        .RX_REQ       (mbc2lc_rx_req),
        .RX_ACK       (lc2mbc_rx_ack),
        .RX_BROADCAST (mbc2lc_rx_broadcast),
        .RX_FAIL      (mbc2lc_rx_fail),
        .TX_FAIL      (mbc2lc_tx_fail),
        .TX_SUCC      (mbc2lc_tx_succ),
        .TX_RESP_ACK  (lc2mbc_tx_resp_ack),
        .MBC_IN_FWD   (),   // Not used
        .MBC_RESET    (mbc_reset),
        .LRC_SLEEP    (lc_sleep_uniso),
        .LRC_CLKENB   (lc_clkenb_uniso),
        .LRC_RESET    (lc_reset_uniso),
        .LRC_ISOLATE  (lc_isolate_uniso),
        .SLEEP_REQUEST_TO_SLEEP_CTRL(mbc2mc_sleep_req),
        .EXTERNAL_INT (mc2mbc_wakeup_req),
        .CLR_EXT_INT  (mbc2mc_clr_wakeup_req),
        .MBUS_BUSY    (mbc2mc_mbus_busy),
        .ASSIGNED_ADDR_IN       (mc2mbc_addr),
        .ASSIGNED_ADDR_OUT      (mbc2mc_addr),
        .ASSIGNED_ADDR_VALID    (mc2mbc_valid),
        .ASSIGNED_ADDR_WRITE    (mbc2mc_write),
        .ASSIGNED_ADDR_INVALIDn (mbc2mc_resetn)
        );
   
    //******************************
    // MBus Member Control
    //******************************
    //Power Domain: PD1P2
    rdcv3_mbus_member_ctrl rdcv3_mbus_member_ctrl_0 (
        .RESETn            (resetn),
        .CIN               (cin),
        .DIN               (din),
        .COUT_FROM_BUS     (mbc2mc_cout),
        .DOUT_FROM_BUS     (mbc2mc_dout),
        .COUT              (cout),
        .DOUT              (dout),
        .SLEEP_REQ         (mbc2mc_sleep_req),
        .WAKEUP_REQ        (wakeup_req),
        .MBC_ISOLATE       (mbc_isolate),
        .MBC_ISOLATE_B     (mbc_isolate_b),
        .MBC_RESET         (mbc_reset),
        .MBC_RESET_B       (mbc_reset_b),
        .MBC_SLEEP         (mbc_sleep),
        .MBC_SLEEP_B       (mbc_sleep_b),
        .CLR_EXT_INT       (mbc2mc_clr_wakeup_req),
        .EXTERNAL_INT      (mc2mbc_wakeup_req), 
        .WAKEUP_ON_PEND_REQ(mbc_wakeup_on_pend_req),
        .ADDR_WR_EN        (mbc2mc_write),
        .ADDR_CLR_B        (mbc2mc_resetn),
        .ADDR_IN           (mbc2mc_addr),
        .ADDR_OUT          (mc2mbc_addr),
        .ADDR_VALID        (mc2mbc_valid),
        .LRC_SLEEP         (lc_sleep),
        .MBUS_BUSY         (mbc2mc_mbus_busy)
        );

    //******************************
    // Layer Controller
    //******************************
    //Power Domain: PD1P2_LC
    rdcv3_layer_ctrl #(
                        `ifdef RDCv3_LAYERCTRL_INT_ENABLE
                        .LC_INT_DEPTH           (`RDCv3_LAYERCTRL_INT_DEPTH),
                        `endif
                        `ifdef RDCv3_LAYERCTRL_MEM_ENABLE
                        .LC_MEM_STREAM_CHANNELS (`RDCv3_LAYERCTRL_MEM_STREAM_CHANNELS),
                        .LC_MEM_ADDR_WIDTH      (`RDCv3_LAYERCTRL_MEM_ADDR_WIDTH),
                        .LC_MEM_DATA_WIDTH      (`RDCv3_LAYERCTRL_MEM_DATA_WIDTH),
                        `endif
                        .LC_RF_DEPTH            (`RDCv3_MBUS_RF_SIZE))
    rdcv3_layer_ctrl_0 (
        .CLK          (clk_lc),
        .RESETn       (lc_reset_b),
        // Interface with MBus
        .TX_ADDR      (lc2mbc_tx_addr_uniso),
        .TX_DATA      (lc2mbc_tx_data_uniso),
        .TX_PEND      (lc2mbc_tx_pend_uniso),
        .TX_REQ       (lc2mbc_tx_req_uniso),
        .TX_ACK       (mbc2lc_tx_ack),
        .TX_PRIORITY  (lc2mbc_tx_priority_uniso),

        .RX_ADDR      (mbc2lc_rx_addr),
        .RX_DATA      (mbc2lc_rx_data),
        .RX_PEND      (mbc2lc_rx_pend),
        .RX_REQ       (mbc2lc_rx_req),
        .RX_ACK       (lc2mbc_rx_ack_uniso),
        .RX_BROADCAST (mbc2lc_rx_broadcast),

        .RX_FAIL      (mbc2lc_rx_fail),
        .TX_FAIL      (mbc2lc_tx_fail),
        .TX_SUCC      (mbc2lc_tx_succ),
        .TX_RESP_ACK  (lc2mbc_tx_resp_ack_uniso),

        .IGNORE_RX_FAIL (mbc_ignore_rx_fail),

        // Interface with MEM
        `ifdef RDCv3_LAYERCTRL_MEM_ENABLE
        .MEM_REQ_OUT    (lc2mem_req),
        .MEM_WRITE      (lc2mem_write),
        .MEM_ACK_IN     (mem2lc_ack),
        .MEM_PEND       (lc2mem_pend),
        .MEM_WR_DATA    (lc2mem_wr_data),
        .MEM_RD_DATA    (mem2lc_rd_data),
        .MEM_ADDR       (lc2mem_addr[31:2]),
        .PREFIX_ADDR_IN (mc2mbc_addr),
        `endif
       
        // Interface with Registers
        .REG_RD_DATA(
                    //---- genRF Beginning of RF_DATA ----//
                 {
                  /*Reg 0x2C (44)*/ 13'h0, rdc_en_pg_fsm, rdc_en_pg_amp_v1p2, rdc_en_pg_adc_v1p2, rdc_en_pg_buf_vh_v1p2, rdc_en_pg_rc_osc, rdc_enb_pg_vref, rdc_enb_pg_amp_vbat, rdc_enb_pg_adc_vbat, rdc_enb_mirror_ldo, rdc_enb_pg_buf_vcm, rdc_enb_pg_buf_vh_vbat, 
                  /*Reg 0x2B (43)*/ 17'h0, rdc_mim, rdc_mom, rdc_clk_isolate, 
                  /*Reg 0x2A (42)*/ rdc_poly, 
                  /*Reg 0x29 (41)*/ 9'h0, rdc_pdiff, 
                  /*Reg 0x28 (40)*/ 5'h0, rdc_reset_rc_osc, rdc_r_ref, rdc_i_buf, rdc_i_buf2, rdc_i_cmp, rdc_i_mirror, 
                  /*Reg 0x27 (39)*/ 21'h0, rdc_i_buf_vh_n_lc, 
                  /*Reg 0x26 (38)*/ 16'h0, rdc_offset_seln_b_lc, rdc_offset_selp_b_lc, rdc_sel_adc_mode, rdc_enb_dwa, 
                  /*Reg 0x25 (37)*/ 11'h0, rdc_offset_p_lc, rdc_offset_pb_lc, rdc_i_amp_biasgen, 
                  /*Reg 0x24 (36)*/ 6'h0, rdc_sel_dly, rdc_sel_store, rdc_sel_vb2_lc, rdc_sel_vb3b_lc, rdc_sel_gain_lc, 
                  /*Reg 0x23 (35)*/ 11'h0, rdc_vref_i_amp_lc, rdc_vcm_r_sel_lc, rdc_i_vcm_gen_n_lc, 
                  /*Reg 0x22 (34)*/ 11'h0, rdc_cnt_idle, rdc_cnt_skip, rdc_osr, 
                  /*Reg 0x21 (33)*/ 5'h0, rdc_cnt_az_resetb, rdc_cnt_store, rdc_cnt_redis, rdc_cnt_amp2, 
                  /*Reg 0x20 (32)*/ 6'h0, rdc_isolate, 1'h0, rdc_resetn_fsm, rdc_cnt_init, rdc_cnt_amp1, rdc_en_az, 
                  /*Reg 0x1F (31)*/ 24'h0, 
                  /*Reg 0x1E (30)*/ 24'h0, 
                  /*Reg 0x1D (29)*/ 24'h0, 
                  /*Reg 0x1C (28)*/ 24'h0, 
                  /*Reg 0x1B (27)*/ 24'h0, 
                  /*Reg 0x1A (26)*/ 24'h0, 
                  /*Reg 0x19 (25)*/ 24'h0, 
                  /*Reg 0x18 (24)*/ 24'h0, 
                  /*Reg 0x17 (23)*/ 24'h0, 
                  /*Reg 0x16 (22)*/ 24'h0, 
                  /*Reg 0x15 (21)*/ 24'h0, 
                  /*Reg 0x14 (20)*/ 24'h0, 
                  /*Reg 0x13 (19)*/ 24'h0, 
                  /*Reg 0x12 (18)*/ 24'h0, 
                  /*Reg 0x11 (17)*/ 7'h0, rdc_dout_os, 
                  /*Reg 0x10 (16)*/ rdc_signature, 
                  /*Reg 0x0F (15)*/ 24'h0, 
                  /*Reg 0x0E (14)*/ 24'h0, 
                  /*Reg 0x0D (13)*/ 24'h0, 
                  /*Reg 0x0C (12)*/ 24'h0, 
                  /*Reg 0x0B (11)*/ 24'h0, 
                  /*Reg 0x0A (10)*/ 24'h0, 
                  /*Reg 0x09 ( 9)*/ 24'h0, 
                  /*Reg 0x08 ( 8)*/ 24'h0, 
                  /*Reg 0x07 ( 7)*/ 24'h0, 
                  /*Reg 0x06 ( 6)*/ 24'h0, 
                  /*Reg 0x05 ( 5)*/ 24'h0, 
                  /*Reg 0x04 ( 4)*/ 24'h0, 
                  /*Reg 0x03 ( 3)*/ 24'h0, 
                  /*Reg 0x02 ( 2)*/ 8'h0, irq_rply_pyld_reg_addr, irq_rply_pyld_length_1, 
                  /*Reg 0x01 ( 1)*/ 8'h0, irq_rply_short_addr, irq_rply_reg_addr, 
                  /*Reg 0x00 ( 0)*/ 17'h0, wakeup_upon_rdc_irq, mbc_wakeup_on_pend_req, mbc_ignore_rx_fail, lc_clk_div, lc_clk_ring
                 }
                    //---- genRF End of RF_DATA ----//
                    ),
        .REG_WR_TRANS   (), // not used
        .REG_WR_DATA    (lc2rf_data_in),
        .REG_WR_EN      (lc2rf_addr_in),
        .REG_WR_EN_IDX  (), // not used
        .REG_WR_DATA_PRE(), // not used
        .REG_WR_DATA_REQ(), // not used

        // Interrupt
        .INT_VECTOR  (rdc_irq),
        .CLR_INT     (rdc_clr_irq_uniso),
        .INT_FU_ID   (4'h1),
        .INT_CMD     ({irq_rply_pyld_reg_addr, irq_rply_pyld_length_1, irq_rply_short_addr, irq_rply_reg_addr, 32'h0 ,32'h0}),
        .INT_CMD_LEN (2'h1),

        // Others
        .RX_REQ_SYNC    (), // not used
        .RX_PEND_SYNC   (), // not used
        .SOFT_RESET_REQ ()  // not used
        );

    //******************************
    // MBUS Isolation
    //******************************
    //Power Domain: PD1P2
    rdcv3_mbus_isolation rdcv3_mbus_isolation_0 (
        .MBC_ISOLATE       (mbc_isolate),

        // Layer Ctrl --> MBus Ctrl
        .TX_ADDR_uniso     (lc2mbc_tx_addr_uniso),
        .TX_DATA_uniso     (lc2mbc_tx_data_uniso),
        .TX_PEND_uniso     (lc2mbc_tx_pend_uniso),
        .TX_REQ_uniso      (lc2mbc_tx_req_uniso),
        .TX_PRIORITY_uniso (lc2mbc_tx_priority_uniso),
        .RX_ACK_uniso      (lc2mbc_rx_ack_uniso),
        .TX_RESP_ACK_uniso (lc2mbc_tx_resp_ack_uniso),

        .TX_ADDR           (lc2mbc_tx_addr),
        .TX_DATA           (lc2mbc_tx_data),
        .TX_PEND           (lc2mbc_tx_pend),
        .TX_REQ            (lc2mbc_tx_req),
        .TX_PRIORITY       (lc2mbc_tx_priority),
        .RX_ACK            (lc2mbc_rx_ack),
        .TX_RESP_ACK       (lc2mbc_tx_resp_ack),

        // MBus Ctrl --> Other
        .LRC_SLEEP_uniso   (lc_sleep_uniso),
        .LRC_CLKENB_uniso  (lc_clkenb_uniso),
        .LRC_RESET_uniso   (lc_reset_uniso),
        .LRC_ISOLATE_uniso (lc_isolate_uniso),

        .LRC_SLEEP         (lc_sleep),
        .LRC_SLEEPB        (lc_sleep_b),
        .LRC_CLKENB        (lc_clkenb),
        .LRC_CLKEN         (lc_clken),
        .LRC_RESET         (lc_reset),
        .LRC_RESETB        (lc_reset_b),
        .LRC_ISOLATE       (lc_isolate),

        // RDC
        .RDC_ISOLATE_B      (rdc_isolate_b),
        .RDC_IRQ_uniso      (rdc_irq_uniso),
        .RDC_IRQ            (rdc_irq),
        .RDC_DOUT_OS_uniso  (rdc_dout_os_uniso),
        .RDC_DOUT_OS        (rdc_dout_os),
        .RDC_CLR_IRQ_uniso  (rdc_clr_irq_uniso),
        .RDC_CLR_IRQ        (rdc_clr_irq),

        // Wakeup Request
        .WAKEUP_UPON_RDC_IRQ    (wakeup_upon_rdc_irq),
        .WAKEUP_REQ             (wakeup_req)
        );
   
    //******************************
    // MBus Register File
    //******************************
    //Power Domain: PD1P2
    //---- genRF Beginning of Register File ----//
    rdcv3_rf rdcv3_rf_0
       (
        //Power
        //.VDD	(VDD_1P2),
        //.VSS	(VSS),
        //Input
        .RESETn	(resetn),
        .ISOLATE	(lc_isolate),
        .ADDR_IN	(lc2rf_addr_in),
        .DATA_IN	(lc2rf_data_in),
        //Output
        //Register 0x00 (0)
        .WAKEUP_UPON_RDC_IRQ	(wakeup_upon_rdc_irq),
        .MBC_WAKEUP_ON_PEND_REQ	(mbc_wakeup_on_pend_req),
        .MBC_IGNORE_RX_FAIL	(mbc_ignore_rx_fail),
        .LC_CLK_DIV	(lc_clk_div),
        .LC_CLK_RING	(lc_clk_ring),
        //Register 0x01 (1)
        .IRQ_RPLY_SHORT_ADDR	(irq_rply_short_addr),
        .IRQ_RPLY_REG_ADDR	(irq_rply_reg_addr),
        //Register 0x02 (2)
        .IRQ_RPLY_PYLD_REG_ADDR	(irq_rply_pyld_reg_addr),
        .IRQ_RPLY_PYLD_LENGTH_1	(irq_rply_pyld_length_1),
        //Register 0x03 (3)
        //--- Empty Register
        //Register 0x04 (4)
        //--- Empty Register
        //Register 0x05 (5)
        //--- Empty Register
        //Register 0x06 (6)
        //--- Empty Register
        //Register 0x07 (7)
        //--- Empty Register
        //Register 0x08 (8)
        //--- Empty Register
        //Register 0x09 (9)
        //--- Empty Register
        //Register 0x0A (10)
        //--- Empty Register
        //Register 0x0B (11)
        //--- Empty Register
        //Register 0x0C (12)
        //--- Empty Register
        //Register 0x0D (13)
        //--- Empty Register
        //Register 0x0E (14)
        //--- Empty Register
        //Register 0x0F (15)
        //--- Empty Register
        //Register 0x10 (16)
        .RDC_SIGNATURE	(rdc_signature),
        //Register 0x11 (17)
        //.RDC_DOUT_OS	(rdc_dout_os),
        //Register 0x12 (18)
        //--- Empty Register
        //Register 0x13 (19)
        //--- Empty Register
        //Register 0x14 (20)
        //--- Empty Register
        //Register 0x15 (21)
        //--- Empty Register
        //Register 0x16 (22)
        //--- Empty Register
        //Register 0x17 (23)
        //--- Empty Register
        //Register 0x18 (24)
        //--- Empty Register
        //Register 0x19 (25)
        //--- Empty Register
        //Register 0x1A (26)
        //--- Empty Register
        //Register 0x1B (27)
        //--- Empty Register
        //Register 0x1C (28)
        //--- Empty Register
        //Register 0x1D (29)
        //--- Empty Register
        //Register 0x1E (30)
        //--- Empty Register
        //Register 0x1F (31)
        //--- Empty Register
        //Register 0x20 (32)
        .RDC_ISOLATE	(rdc_isolate),
        .RDC_ISOLATE_B	(rdc_isolate_b),
        .RDC_RESETn_FSM	(rdc_resetn_fsm),
        .RDC_CNT_INIT	(rdc_cnt_init),
        .RDC_CNT_AMP1	(rdc_cnt_amp1),
        .RDC_EN_AZ	(rdc_en_az),
        //Register 0x21 (33)
        .RDC_CNT_AZ_RESETB	(rdc_cnt_az_resetb),
        .RDC_CNT_STORE	(rdc_cnt_store),
        .RDC_CNT_REDIS	(rdc_cnt_redis),
        .RDC_CNT_AMP2	(rdc_cnt_amp2),
        //Register 0x22 (34)
        .RDC_CNT_IDLE	(rdc_cnt_idle),
        .RDC_CNT_SKIP	(rdc_cnt_skip),
        .RDC_OSR	(rdc_osr),
        //Register 0x23 (35)
        .RDC_VREF_I_AMP_LC	(rdc_vref_i_amp_lc),
        .RDC_VREF_I_AMP_LC_B	(rdc_vref_i_amp_lc_b),
        .RDC_VCM_R_SEL_LC	(rdc_vcm_r_sel_lc),
        .RDC_VCM_R_SEL_LC_B	(rdc_vcm_r_sel_lc_b),
        .RDC_I_VCM_GEN_n_LC	(rdc_i_vcm_gen_n_lc),
        .RDC_I_VCM_GEN_n_LC_B	(rdc_i_vcm_gen_n_lc_b),
        //Register 0x24 (36)
        .RDC_SEL_DLY	(rdc_sel_dly),
        .RDC_SEL_STORE	(rdc_sel_store),
        .RDC_SEL_VB2_LC	(rdc_sel_vb2_lc),
        .RDC_SEL_VB2_LC_B	(rdc_sel_vb2_lc_b),
        .RDC_SEL_VB3b_LC	(rdc_sel_vb3b_lc),
        .RDC_SEL_VB3b_LC_B	(rdc_sel_vb3b_lc_b),
        .RDC_SEL_GAIN_LC	(rdc_sel_gain_lc),
        .RDC_SEL_GAIN_LC_B	(rdc_sel_gain_lc_b),
        //Register 0x25 (37)
        .RDC_OFFSET_P_LC	(rdc_offset_p_lc),
        .RDC_OFFSET_P_LC_B	(rdc_offset_p_lc_b),
        .RDC_OFFSET_PB_LC	(rdc_offset_pb_lc),
        .RDC_OFFSET_PB_LC_B	(rdc_offset_pb_lc_b),
        .RDC_I_AMP_BIASGEN	(rdc_i_amp_biasgen),
        //Register 0x26 (38)
        .RDC_OFFSET_SELN_B_LC	(rdc_offset_seln_b_lc),
        .RDC_OFFSET_SELN_B_LC_B	(rdc_offset_seln_b_lc_b),
        .RDC_OFFSET_SELP_B_LC	(rdc_offset_selp_b_lc),
        .RDC_OFFSET_SELP_B_LC_B	(rdc_offset_selp_b_lc_b),
        .RDC_SEL_ADC_MODE	(rdc_sel_adc_mode),
        .RDC_ENb_DWA	(rdc_enb_dwa),
        //Register 0x27 (39)
        .RDC_I_BUF_VH_n_LC	(rdc_i_buf_vh_n_lc),
        .RDC_I_BUF_VH_n_LC_B	(rdc_i_buf_vh_n_lc_b),
        //Register 0x28 (40)
        .RDC_RESET_RC_OSC	(rdc_reset_rc_osc),
        .RDC_R_REF	(rdc_r_ref),
        .RDC_I_BUF	(rdc_i_buf),
        .RDC_I_BUF2	(rdc_i_buf2),
        .RDC_I_CMP	(rdc_i_cmp),
        .RDC_I_MIRROR	(rdc_i_mirror),
        //Register 0x29 (41)
        .RDC_PDIFF	(rdc_pdiff),
        //Register 0x2A (42)
        .RDC_POLY	(rdc_poly),
        //Register 0x2B (43)
        .RDC_MIM	(rdc_mim),
        .RDC_MOM	(rdc_mom),
        .RDC_CLK_ISOLATE	(rdc_clk_isolate),
        //Register 0x2C (44)
        .RDC_EN_PG_FSM	(rdc_en_pg_fsm),
        .RDC_EN_PG_AMP_V1P2	(rdc_en_pg_amp_v1p2),
        .RDC_EN_PG_ADC_V1P2	(rdc_en_pg_adc_v1p2),
        .RDC_EN_PG_BUF_VH_V1P2	(rdc_en_pg_buf_vh_v1p2),
        .RDC_EN_PG_RC_OSC	(rdc_en_pg_rc_osc),
        .RDC_ENb_PG_VREF	(rdc_enb_pg_vref),
        .RDC_ENb_PG_AMP_VBAT	(rdc_enb_pg_amp_vbat),
        .RDC_ENb_PG_ADC_VBAT	(rdc_enb_pg_adc_vbat),
        .RDC_ENb_MIRROR_LDO	(rdc_enb_mirror_ldo),
        .RDC_ENb_PG_BUF_VCM	(rdc_enb_pg_buf_vcm),
        .RDC_ENb_PG_BUF_VH_VBAT	(rdc_enb_pg_buf_vh_vbat)
       );
    //---- genRF End of Register File ----//

    //******************************
    // RDC Level Converter
    //******************************
    //Power Domain: PD3P6
    RDCv3_LC rdcv3_lc_0 (
        .ISOLATE        (reset_3p6),
        .ISOLATE_BUF    (reset_3p6_buf),

        //Inputs @ 1.2V
        .RDC_VREF_I_AMP_LC      (rdc_vref_i_amp_lc),
        .RDC_VCM_R_SEL_LC       (rdc_vcm_r_sel_lc),
        .RDC_I_VCM_GEN_n_LC     (rdc_i_vcm_gen_n_lc),
        .RDC_SEL_VB2_LC         (rdc_sel_vb2_lc),
        .RDC_SEL_VB3b_LC        (rdc_sel_vb3b_lc),
        .RDC_SEL_GAIN_LC        (rdc_sel_gain_lc),
        .RDC_OFFSET_P_LC        (rdc_offset_p_lc),
        .RDC_OFFSET_PB_LC       (rdc_offset_pb_lc),
        .RDC_OFFSET_SELN_B_LC   (rdc_offset_seln_b_lc),
        .RDC_OFFSET_SELP_B_LC   (rdc_offset_selp_b_lc),
        .RDC_I_BUF_VH_n_LC      (rdc_i_buf_vh_n_lc),

        //Inverted Inputs @ 1.2V
        .RDC_VREF_I_AMP_LC_B    (rdc_vref_i_amp_lc_b),
        .RDC_VCM_R_SEL_LC_B     (rdc_vcm_r_sel_lc_b),
        .RDC_I_VCM_GEN_n_LC_B   (rdc_i_vcm_gen_n_lc_b),
        .RDC_SEL_VB2_LC_B       (rdc_sel_vb2_lc_b),
        .RDC_SEL_VB3b_LC_B      (rdc_sel_vb3b_lc_b),
        .RDC_SEL_GAIN_LC_B      (rdc_sel_gain_lc_b),
        .RDC_OFFSET_P_LC_B      (rdc_offset_p_lc_b),
        .RDC_OFFSET_PB_LC_B     (rdc_offset_pb_lc_b),
        .RDC_OFFSET_SELN_B_LC_B (rdc_offset_seln_b_lc_b),
        .RDC_OFFSET_SELP_B_LC_B (rdc_offset_selp_b_lc_b),
        .RDC_I_BUF_VH_n_LC_B    (rdc_i_buf_vh_n_lc_b),

        //Outputs @ 3.6V
        .RDC_VREF_I_AMP_LC_3P6    (rdc_vref_i_amp_lc_3p6),
        .RDC_VCM_R_SEL_LC_3P6     (rdc_vcm_r_sel_lc_3p6),
        .RDC_I_VCM_GEN_n_LC_3P6   (rdc_i_vcm_gen_n_lc_3p6),
        .RDC_SEL_VB2_LC_3P6       (rdc_sel_vb2_lc_3p6),
        .RDC_SEL_VB3b_LC_3P6      (rdc_sel_vb3b_lc_3p6),
        .RDC_SEL_GAIN_LC_3P6      (rdc_sel_gain_lc_3p6),
        .RDC_OFFSET_P_LC_3P6      (rdc_offset_p_lc_3p6),
        .RDC_OFFSET_PB_LC_3P6     (rdc_offset_pb_lc_3p6),
        .RDC_OFFSET_SELN_B_LC_3P6 (rdc_offset_seln_b_lc_3p6),
        .RDC_OFFSET_SELP_B_LC_3P6 (rdc_offset_selp_b_lc_3p6),
        .RDC_I_BUF_VH_n_LC_3P6    (rdc_i_buf_vh_n_lc_3p6)
        );

    //******************************
    // RDC_TOP
    //******************************
    RDC_TOP_v1p3    rdcv3_rdc_0 (
        //.VBAT (VDD_3P6)
        //.V1P2 (VDD_1P2)
        //.VSS  (VSS)

        // Pad Connection
        .VH (PAD_VH),
        .VP (PAD_VP),
        .VN (PAD_VN),

        // Inputs @ VDD_3P6
        .ISOL_VBAT              (reset_3p6_buf),
        .VREF_I_AMP_LC          (rdc_vref_i_amp_lc_3p6),
        .VCM_R_SEL_LC           (rdc_vcm_r_sel_lc_3p6),
        .I_VCM_GEN_n_LC         (rdc_i_vcm_gen_n_lc_3p6),
        .SEL_VB2_LC             (rdc_sel_vb2_lc_3p6),
        .SEL_VB3b_LC            (rdc_sel_vb3b_lc_3p6),
        .SEL_GAIN_LC            (rdc_sel_gain_lc_3p6),
        .OFFSET_P_LC            (rdc_offset_p_lc_3p6),
        .OFFSET_PB_LC           (rdc_offset_pb_lc_3p6),
        .OFFSET_SELN_B_LC       (rdc_offset_seln_b_lc_3p6),
        .OFFSET_SELP_B_LC       (rdc_offset_selp_b_lc_3p6),
        .I_BUF_VH_n_LC          (rdc_i_buf_vh_n_lc_3p6),

        // Inputs @ VDD_1P2
        .CLR                    (rdc_clr_irq),
        .EN_PG_FSM              (rdc_en_pg_fsm),
        .RESETn_FSM             (rdc_resetn_fsm),
        .CNT_INIT               (rdc_cnt_init),
        .CNT_AMP1               (rdc_cnt_amp1),
        .EN_AZ                  (rdc_en_az),
        .CNT_AZ_RESETB          (rdc_cnt_az_resetb),
        .CNT_STORE              (rdc_cnt_store),
        .CNT_REDIS              (rdc_cnt_redis),
        .CNT_AMP2               (rdc_cnt_amp2),
        .CNT_IDLE               (rdc_cnt_idle),
        .CNT_SKIP               (rdc_cnt_skip),
        .OSR                    (rdc_osr),
        .ENb_PG_VREF            (rdc_enb_pg_vref),
        .ENb_PG_BUF_VCM         (rdc_enb_pg_buf_vcm),
        .ENb_PG_AMP_VBAT        (rdc_enb_pg_amp_vbat),
        .EN_PG_AMP_V1P2         (rdc_en_pg_amp_v1p2),
        .SEL_DLY                (rdc_sel_dly),
        .SEL_STORE              (rdc_sel_store),
        .I_AMP_BIASGEN          (rdc_i_amp_biasgen),
        .ENb_PG_ADC_VBAT        (rdc_enb_pg_adc_vbat),
        .EN_PG_ADC_V1P2         (rdc_en_pg_adc_v1p2),
        .SEL_ADC_MODE           (rdc_sel_adc_mode),
        .ENb_DWA                (rdc_enb_dwa),
        .ENb_PG_BUF_VH_VBAT     (rdc_enb_pg_buf_vh_vbat),
        .EN_PG_BUF_VH_V1P2      (rdc_en_pg_buf_vh_v1p2),
        .EN_PG_RC_OSC           (rdc_en_pg_rc_osc),
        .ENb_MIRROR_LDO         (rdc_enb_mirror_ldo),
        .RESET_RC_OSC           (rdc_reset_rc_osc),
        .R_REF                  (rdc_r_ref),
        .I_BUF                  (rdc_i_buf),
        .I_BUF2                 (rdc_i_buf2),
        .I_CMP                  (rdc_i_cmp),
        .I_MIRROR               (rdc_i_mirror),
        .PDIFF                  (rdc_pdiff),
        .POLY                   (rdc_poly),
        .MIM                    (rdc_mim),
        .MOM                    (rdc_mom),
        .ISOLATE                (rdc_clk_isolate),  // ATTENTION: Pin name and Net name are different.

// [DBG Only]       .SEL_VIN                (rdc_sel_vin),
// [DBG Only]       .EN_BUF                 (rdc_en_buf),
// [DBG Only]       .ADC_SEL_VIN            (rdc_adc_sel_vin),
// [DBG Only]       .SEL_CLK                (rdc_sel_clk),
// [DBG Only]       .SEL_ADC_RESET          (rdc_sel_adc_reset),
// [DBG Only]       .SEL_FSM_CTRL           (rdc_sel_fsm_ctrl),
// [DBG Only]       .EXT_EN_AMP1            (rdc_ext_en_amp1),
// [DBG Only]       .EXT_AZ_RESETB          (rdc_ext_az_resetb),
// [DBG Only]       .EXT_AZ_EN              (rdc_ext_az_en),
// [DBG Only]       .EXT_EN_STORE           (rdc_ext_en_store),
// [DBG Only]       .EXT_EN_REDIS           (rdc_ext_en_redis),
// [DBG Only]       .EXT_EN_AMP2            (rdc_ext_en_amp2),

        // Output @ VDD_1P2
        .DOUT_OS    (rdc_dout_os_uniso),
        .IRQ        (rdc_irq_uniso)
    );

endmodule // RDCv3
