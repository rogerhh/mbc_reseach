//*******************************************************************************************
// TOP-LEVEL VERILOG FOR SNT
//-------------------------------------------------------------------------------------------
// < COMPILER DIRECTIVES >
//  SNTv2_def.v must precede whenever this file is used.
//-------------------------------------------------------------------------------------------
// < UPDATE HISTORY >
//  May 10 2018 -   Template first created by Yejoong Kim
//  Oct 01 2017 -   First Commit for SNTv1 (Yejoong Kim)
//                      Cloned and modified SNSv11.v
//                          - Name changes
//                          - Removed CDC
//                          - Replaced 2-channel LDO with 1-channel LDO
//                          - Removed debug pads
//                          - Added Taekwang Timer (5nW version, SNTv1_TIMER)
//  Jul 16 2018 -   Updated for SNTv2
//                      Use of MBus Release 05
//                      Name changes for analog blocks
//                      Added a header for Timer, and added tmr_sleep and tmr_isolate signals.
//  Nov 08 2018 -   Updated for SNTv3
//                      Updated Timer Version: TIMER_5K_V1_TSMC180 -> TIMER_5K_V2_TSMC180
//                      Replaced VDD_1P2 pad to the one with ESD detection embedded
//                          and removed previous DETECTION circuit.
//-------------------------------------------------------------------------------------------
// < AUTHOR > 
//  Yejoong Kim (yejoong@umich.edu)
//******************************************************************************************* 

module SNTv3 (
    PAD_CIN,
    PAD_COUT,
    PAD_DIN,
    PAD_DOUT,
    PAD_CLK_SLP
    );

    //******************************
    // Top IO
    //******************************
    //VDD_3P6
    //VDD_1P2
    //VDD_0P6
    //VDD_1P2_TMR
    //VDD_1P2_MBC
    //VDD_1P2_LC
    //VDD_0P6_LC
    //VSS
    input       PAD_CIN;
    output      PAD_COUT;
    input       PAD_DIN;
    output      PAD_DOUT;

    output      PAD_CLK_SLP;

    //******************************
    // Internal Wire Declerations
    //******************************

    // Power-on-Reset
    wire        resetn;
    wire        reset_3p6;

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
    `ifdef SNTv3_LAYERCTRL_MEM_ENABLE
    wire        lc2mem_req;
    wire        lc2mem_write;
    wire        lc2mem_pend;
    wire [31:0] lc2mem_wr_data;
    wire [31:0] lc2mem_addr;
    wire [31:0] mem2lc_rd_data;
    wire        mem2lc_ack;
    `endif

    // Layer Ctrl Interrupt Interface
    `ifdef SNTv3_LAYERCTRL_INT_ENABLE
    wire   [`SNTv3_LAYERCTRL_INT_DEPTH-1:0]      ctr2lc_int_vector;
    wire   [`SNTv3_LAYERCTRL_INT_DEPTH-1:0]      lc2ctr_clr_int_uniso;
    wire   [`SNTv3_LAYERCTRL_INT_DEPTH-1:0]      lc2ctr_clr_int;
    wire   [`SNTv3_LAYERCTRL_INT_DEPTH*4-1:0]    ctr2lc_int_fu_id;
    wire   [`SNTv3_LAYERCTRL_INT_DEPTH*96-1:0]   ctr2lc_int_cmd;
    wire   [`SNTv3_LAYERCTRL_INT_DEPTH*2-1:0]    ctr2lc_int_cmd_len;
    `endif

    // Temperature Sensor
    wire        tsns_clr_irq_uniso,    tsns_clr_irq,            tsns_clr_irq_b;
    wire [23:0] tsns_dout_vldo,        tsns_dout_b_vldo;        // tsnse_dout is declared in MBus RF section 
    wire        tsns_irq_vldo,         tsns_irq_b_vldo,         tsns_irq;
    wire        tsns_clk_sense_vldo,   tsns_clk_sense_b_vldo,   tsns_clk_sense;
    wire        tsns_clk_ref_vldo,     tsns_clk_ref_b_vldo,     tsns_clk_ref;
    wire        tsns_en_sensor_ldo_3p6;
    wire        tsns_en_sensor_v1p2_3p6;
    wire        tsns_sel_ldo_3p6;
    wire        tsns_sel_v1p2_3p6;

    // Timer
    wire        tmr_clk_uniso, tmr_clk;
    
    // Wakeup Timer
    wire        wup_clr_irq_uniso,   wup_clr_irq;
    wire        wup_irq;
    wire        wup_wakeup_req;

    // Wakeup Request
    wire        wakeup_req;

    // Layer_Ctrl <-> MBus RF Interface
    //---- genRF Beginning of Wire Declaration ----//
    wire [29:0] lc2rf_addr_in;
    wire [23:0] lc2rf_data_in;
    //Register 0x00 (  0)
    wire [ 3:0] ldo_vref_i_amp;
    wire [ 2:0] ldo_sel_vout;
    wire        ldo_en_vref;
    wire        ldo_en_iref;
    wire        ldo_en_ldo;
    //Register 0x01 (  1)
    wire        tsns_force_clr_irq_if_en_irq_0;
    wire        tsns_en_clk_ref;
    wire        tsns_en_clk_ref_b; // Inverted Signal of tsns_en_clk_ref
    wire        tsns_en_clk_sens;
    wire        tsns_en_clk_sens_b; // Inverted Signal of tsns_en_clk_sens
    wire        tsns_en_irq;
    wire        tsns_en_irq_b; // Inverted Signal of tsns_en_irq
    wire        tsns_cont_mode;
    wire        tsns_cont_mode_b; // Inverted Signal of tsns_cont_mode
    wire        tsns_burst_mode;
    wire        tsns_burst_mode_b; // Inverted Signal of tsns_burst_mode
    wire        tsns_en_sensor_ldo;
    wire        tsns_en_sensor_ldo_b; // Inverted Signal of tsns_en_sensor_ldo
    wire        tsns_en_sensor_v1p2;
    wire        tsns_en_sensor_v1p2_b; // Inverted Signal of tsns_en_sensor_v1p2
    wire        tsns_sel_ldo;
    wire        tsns_sel_ldo_b; // Inverted Signal of tsns_sel_ldo
    wire        tsns_sel_v1p2;
    wire        tsns_sel_v1p2_b; // Inverted Signal of tsns_sel_v1p2
    wire        tsns_isolate;
    wire        tsns_isolate_b; // Inverted Signal of tsns_isolate
    wire        tsns_resetn;
    wire        tsns_resetn_b; // Inverted Signal of tsns_resetn
    //Register 0x02 (  2)
    wire [ 3:0] tsns_r_ref;
    wire [ 3:0] tsns_r_ref_b; // Inverted Signal of tsns_r_ref
    wire [ 3:0] tsns_i_buf;
    wire [ 3:0] tsns_i_buf_b; // Inverted Signal of tsns_i_buf
    wire [ 3:0] tsns_i_buf2;
    wire [ 3:0] tsns_i_buf2_b; // Inverted Signal of tsns_i_buf2
    wire [ 3:0] tsns_i_cmp;
    wire [ 3:0] tsns_i_cmp_b; // Inverted Signal of tsns_i_cmp
    wire [ 1:0] tsns_i_mirror;
    wire [ 1:0] tsns_i_mirror_b; // Inverted Signal of tsns_i_mirror
    wire [ 3:0] tsns_i_sosc;
    wire [ 3:0] tsns_i_sosc_b; // Inverted Signal of tsns_i_sosc
    //Register 0x03 (  3)
    wire [ 2:0] tsns_mim;
    wire [ 2:0] tsns_mim_b; // Inverted Signal of tsns_mim
    wire [ 2:0] tsns_mom;
    wire [ 2:0] tsns_mom_b; // Inverted Signal of tsns_mom
    wire [ 3:0] tsns_sel_vvdd;
    wire [ 3:0] tsns_sel_vvdd_b; // Inverted Signal of tsns_sel_vvdd
    wire [ 2:0] tsns_sel_stb_time;
    wire [ 2:0] tsns_sel_stb_time_b; // Inverted Signal of tsns_sel_stb_time
    wire [ 1:0] tsns_sel_ref_stb_time;
    wire [ 1:0] tsns_sel_ref_stb_time_b; // Inverted Signal of tsns_sel_ref_stb_time
    wire [ 3:0] tsns_sel_conv_time;
    wire [ 3:0] tsns_sel_conv_time_b; // Inverted Signal of tsns_sel_conv_time
    //Register 0x04 (  4)
    wire [14:0] tsns_pdiff;
    wire [14:0] tsns_pdiff_b; // Inverted Signal of tsns_pdiff
    //Register 0x05 (  5)
    wire [23:0] tsns_poly;
    wire [23:0] tsns_poly_b; // Inverted Signal of tsns_poly
    //Register 0x06 (  6)
    wire [23:0] tsns_dout;
    //Register 0x07 (  7)
    wire [ 7:0] tsns_int_rply_short_addr;
    wire [ 7:0] tsns_int_rply_reg_addr;
    //Register 0x08 (  8)
    wire        tmr_sleep;
    wire        tmr_isolate;
    wire        tmr_isolate_b; // Inverted Signal of tmr_isolate
    wire        tmr_resetb;
    wire        tmr_en_osc;
    wire        tmr_resetb_div;
    wire        tmr_resetb_dcdc;
    wire        tmr_en_self_clk;
    //Register 0x09 (  9)
    wire        tmr_sel_clk_div;
    wire        tmr_sel_clk_osc;
    wire        tmr_self_en;
    wire [ 3:0] tmr_ibias_ref;
    wire        tmr_cascode_boost;
    wire [ 7:0] tmr_sel_cap;
    wire [ 5:0] tmr_sel_dcap;
    wire        tmr_en_tune1;
    wire        tmr_en_tune2;
    //Register 0x0A ( 10)
    wire [ 2:0] tmr_s;
    wire [13:0] tmr_diff_con;
    wire        tmr_en_tune1_res;
    wire        tmr_en_tune2_res;
    wire        tmr_sample_en;
    wire [ 2:0] tmr_afc;
    //Register 0x0B ( 11)
    wire [ 3:0] tmr_tfr_con;
    //Register 0x17 ( 23)
    wire        wup_enable;
    wire        wup_lc_irq_en;
    wire        wup_auto_reset;
    wire        wup_clk_sel;
    wire        wup_enable_clk_slp_out;
    wire [ 7:0] wup_int_rply_short_addr;
    wire [ 7:0] wup_int_rply_reg_addr;
    //Register 0x18 ( 24)
    wire [23:0] wup_int_rply_payload;
    //Register 0x19 ( 25)
    wire [ 7:0] wup_threshold_ext;
    //Register 0x1A ( 26)
    wire [23:0] wup_threshold;
    //Register 0x1B ( 27)
    wire [ 7:0] wup_cnt_value_ext;
    //Register 0x1C ( 28)
    wire [23:0] wup_cnt_value;
    //Register 0x1D ( 29)
    wire        mbc_wakeup_on_pend_req;
    wire        mbc_ignore_rx_fail;
    wire [ 1:0] lc_clk_div;
    wire [ 1:0] lc_clk_ring;
    //---- genRF End of Wire Declaration ----//

    // Clock
    wire   clk_lc;
    wire   clk_slp;

    //*************************
    // Pads
    //*************************
    // Power
    PAD_100x60_DVDD_TP_TP_TSMC180_rev3  PAD_VDD_3P6_0   (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS)
    PAD_100x60_VDD_ED_TP_TSMC180_rev3   PAD_VDD_1P2_0   (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS), VDD(VDD_1P2)
    PAD_100x60_VDD_TP_TP_TSMC180_rev3   PAD_VDD_0P6_0   (); // DVDD(VDD_3P6), DVSS(VSS), VDD(VDD_0P6)
    PAD_100x60_DVSS_TP_TP_TSMC180_rev3  PAD_VSS_0       (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS)

    // MBus
    PAD_50x60_DI_ST_TP_TSMC180_rev3     PAD_DIN_CIN_0   (.PAD(PAD_CIN),  .Y(cin) ); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DO_TP_TP_TSMC180_rev3     PAD_DOUT_COUT_0 (.PAD(PAD_COUT), .A(cout)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DI_TP_TP_TSMC180_rev3     PAD_DIN_DIN_0   (.PAD(PAD_DIN),  .Y(din) ); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DO_TP_TP_TSMC180_rev3     PAD_DOUT_DOUT_0 (.PAD(PAD_DOUT), .A(dout)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)

    // Sleep Clock Output
    PAD_50x60_DO_TP_TP_TSMC180_rev3     PAD_DOUT_CLK_SLP_0 (.PAD(PAD_CLK_SLP), .A(clk_slp)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)

    //******************************
    // Reset Detector (Dual)
    //******************************
    RSTDTCTRG_DUAL_TSMC180 sntv3_rstdtctrg_dual_0 (
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
    HEADER_1P2_PH100_0P6_NH100_PS100_TSMC180 sntv3_lc_header_0 (
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
    HEADER_1P2_PH100_TSMC180 sntv3_mbc_header_0 (
        //Power
        //.VDD_1P2      (VDD_1P2)
        //.VVDD_1P2     (VDD_1P2_MBC)
        //.VSS          (VSS)
       .SLEEP (mbc_sleep)
       );

    //******************************
    // Timer Header
    //******************************
    HEADER_1P2_PH100_TSMC180 sntv3_tmr_header_0 (
        //Power
        //.VDD_1P2      (VDD_1P2)
        //.VVDD_1P2     (VDD_1P2_TMR)
        //.VSS          (VSS)
       .SLEEP (tmr_sleep)
       );

    //*************************
    // Clock Generator
    //*************************
    CLK_GEN_V1_B_TSMC180 sntv3_clkgen_0 (
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
    sntv3_mbus_node  #(.ADDRESS(`SNTv3_MBUS_FULL_PREFIX))
    sntv3_mbus_node_0 (
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
    sntv3_mbus_member_ctrl sntv3_mbus_member_ctrl_0 (
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
    sntv3_layer_ctrl #(
                        `ifdef SNTv3_LAYERCTRL_INT_ENABLE
                        .LC_INT_DEPTH           (`SNTv3_LAYERCTRL_INT_DEPTH),
                        `endif
                        `ifdef SNTv3_LAYERCTRL_MEM_ENABLE
                        .LC_MEM_STREAM_CHANNELS (`SNTv3_LAYERCTRL_MEM_STREAM_CHANNELS),
                        .LC_MEM_ADDR_WIDTH      (`SNTv3_LAYERCTRL_MEM_ADDR_WIDTH),
                        .LC_MEM_DATA_WIDTH      (`SNTv3_LAYERCTRL_MEM_DATA_WIDTH),
                        `endif
                        .LC_RF_DEPTH            (`SNTv3_MBUS_RF_SIZE))
    sntv3_layer_ctrl_0 (
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
        `ifdef SNTv3_LAYERCTRL_MEM_ENABLE
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
                  /*Reg 0x1D (29)*/ 18'h0, mbc_wakeup_on_pend_req, mbc_ignore_rx_fail, lc_clk_div, lc_clk_ring, 
                  /*Reg 0x1C (28)*/ wup_cnt_value, 
                  /*Reg 0x1B (27)*/ 16'h0, wup_cnt_value_ext, 
                  /*Reg 0x1A (26)*/ wup_threshold, 
                  /*Reg 0x19 (25)*/ 16'h0, wup_threshold_ext, 
                  /*Reg 0x18 (24)*/ wup_int_rply_payload, 
                  /*Reg 0x17 (23)*/ wup_enable, wup_lc_irq_en, wup_auto_reset, wup_clk_sel, wup_enable_clk_slp_out, 3'h0, wup_int_rply_short_addr, wup_int_rply_reg_addr, 
                  /*Reg 0x16 (22)*/ 24'h0, 
                  /*Reg 0x15 (21)*/ 24'h0, 
                  /*Reg 0x14 (20)*/ 24'h0, 
                  /*Reg 0x13 (19)*/ 24'h0, 
                  /*Reg 0x12 (18)*/ 24'h0, 
                  /*Reg 0x11 (17)*/ 24'h0, 
                  /*Reg 0x10 (16)*/ 24'h0, 
                  /*Reg 0x0F (15)*/ 24'h0, 
                  /*Reg 0x0E (14)*/ 24'h0, 
                  /*Reg 0x0D (13)*/ 24'h0, 
                  /*Reg 0x0C (12)*/ 24'h0, 
                  /*Reg 0x0B (11)*/ 20'h0, tmr_tfr_con, 
                  /*Reg 0x0A (10)*/ tmr_s, tmr_diff_con, 1'h0, tmr_en_tune1_res, tmr_en_tune2_res, tmr_sample_en, tmr_afc, 
                  /*Reg 0x09 ( 9)*/ tmr_sel_clk_div, tmr_sel_clk_osc, tmr_self_en, tmr_ibias_ref, tmr_cascode_boost, tmr_sel_cap, tmr_sel_dcap, tmr_en_tune1, tmr_en_tune2, 
                  /*Reg 0x08 ( 8)*/ 17'h0, tmr_sleep, tmr_isolate, tmr_resetb, tmr_en_osc, tmr_resetb_div, tmr_resetb_dcdc, tmr_en_self_clk, 
                  /*Reg 0x07 ( 7)*/ 8'h0, tsns_int_rply_short_addr, tsns_int_rply_reg_addr, 
                  /*Reg 0x06 ( 6)*/ tsns_dout, 
                  /*Reg 0x05 ( 5)*/ tsns_poly, 
                  /*Reg 0x04 ( 4)*/ 9'h0, tsns_pdiff, 
                  /*Reg 0x03 ( 3)*/ 5'h0, tsns_mim, tsns_mom, tsns_sel_vvdd, tsns_sel_stb_time, tsns_sel_ref_stb_time, tsns_sel_conv_time, 
                  /*Reg 0x02 ( 2)*/ 2'h0, tsns_r_ref, tsns_i_buf, tsns_i_buf2, tsns_i_cmp, tsns_i_mirror, tsns_i_sosc, 
                  /*Reg 0x01 ( 1)*/ 12'h0, tsns_force_clr_irq_if_en_irq_0, tsns_en_clk_ref, tsns_en_clk_sens, tsns_en_irq, tsns_cont_mode, tsns_burst_mode, tsns_en_sensor_ldo, tsns_en_sensor_v1p2, tsns_sel_ldo, tsns_sel_v1p2, tsns_isolate, tsns_resetn, 
                  /*Reg 0x00 ( 0)*/ 14'h0, ldo_vref_i_amp, ldo_sel_vout, ldo_en_vref, ldo_en_iref, ldo_en_ldo
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
        .INT_VECTOR  ({tsns_irq, wup_irq}),
        .CLR_INT     ({tsns_clr_irq_uniso, wup_clr_irq_uniso}),
        .INT_FU_ID   ({4'h1, 4'h1}),
        .INT_CMD    ({{8'h06, 8'h00, tsns_int_rply_short_addr, tsns_int_rply_reg_addr, 32'h0 ,32'h0},
                      {8'h18, 8'h00, wup_int_rply_short_addr, wup_int_rply_reg_addr, 32'h0 ,32'h0}}),
        .INT_CMD_LEN ({2'h1, 2'h1}),

        // Others
        .RX_REQ_SYNC    (), // not used
        .RX_PEND_SYNC   (), // not used
        .SOFT_RESET_REQ ()  // not used
        );

    //******************************
    // MBUS Isolation
    //******************************
    //Power Domain: PD1P2
    sntv3_mbus_isolation sntv3_mbus_isolation_0 (
        .RESET_3P6         (reset_3p6),
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

        // Temp Sensor
        .TSNS_ISOLATE      (tsns_isolate),
        .TSNS_EN_IRQ       (tsns_en_irq),
        .TSNS_EN_IRQ_B     (tsns_en_irq_b),
        .TSNS_FORCE_CLR_IRQ(tsns_force_clr_irq_if_en_irq_0),

        .TSNS_CLR_IRQ_uniso(tsns_clr_irq_uniso),
        .TSNS_CLR_IRQ      (tsns_clr_irq),
        .TSNS_CLR_IRQ_B    (tsns_clr_irq_b),

        .TSNS_DOUT_VLDO    (tsns_dout_vldo),
        .TSNS_DOUT_B_VLDO  (tsns_dout_b_vldo),
        .TSNS_DOUT         (tsns_dout),
        .TSNS_IRQ_VLDO     (tsns_irq_vldo),
        .TSNS_IRQ_B_VLDO   (tsns_irq_b_vldo),
        .TSNS_IRQ          (tsns_irq),

        .TSNS_CLK_SENSE_VLDO       (tsns_clk_sense_vldo),
        .TSNS_CLK_SENSE_B_VLDO     (tsns_clk_sense_b_vldo),
        .TSNS_CLK_SENSE            (tsns_clk_sense),
        .TSNS_CLK_REF_VLDO         (tsns_clk_ref_vldo),
        .TSNS_CLK_REF_B_VLDO       (tsns_clk_ref_b_vldo),
        .TSNS_CLK_REF              (tsns_clk_ref),

        // Timer Isolation
        .TMR_ISOLATE_B      (tmr_isolate_b),
        .TMR_CLK_uniso      (tmr_clk_uniso),
        .TMR_CLK            (tmr_clk),

        // Wakeup Timer
        .WUP_WAKEUP_REQ         (wup_wakeup_req),
        .WUP_CLR_IRQ_uniso      (wup_clr_irq_uniso),
        .WUP_CLR_IRQ            (wup_clr_irq),

        // Wakeup Request
        .WAKEUP_REQ             (wakeup_req)
        );
   
    //******************************
    // MBus Register File
    //******************************
    //Power Domain: PD1P2
    //---- genRF Beginning of Register File ----//
    sntv3_rf sntv3_rf_0
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
        .LDO_VREF_I_AMP	(ldo_vref_i_amp),
        .LDO_SEL_VOUT	(ldo_sel_vout),
        .LDO_EN_VREF	(ldo_en_vref),
        .LDO_EN_IREF	(ldo_en_iref),
        .LDO_EN_LDO	(ldo_en_ldo),
        //Register 0x01 (1)
        .TSNS_FORCE_CLR_IRQ_IF_EN_IRQ_0	(tsns_force_clr_irq_if_en_irq_0),
        .TSNS_EN_CLK_REF	(tsns_en_clk_ref),
        .TSNS_EN_CLK_REF_B	(tsns_en_clk_ref_b),
        .TSNS_EN_CLK_SENS	(tsns_en_clk_sens),
        .TSNS_EN_CLK_SENS_B	(tsns_en_clk_sens_b),
        .TSNS_EN_IRQ	(tsns_en_irq),
        .TSNS_EN_IRQ_B	(tsns_en_irq_b),
        .TSNS_CONT_MODE	(tsns_cont_mode),
        .TSNS_CONT_MODE_B	(tsns_cont_mode_b),
        .TSNS_BURST_MODE	(tsns_burst_mode),
        .TSNS_BURST_MODE_B	(tsns_burst_mode_b),
        .TSNS_EN_SENSOR_LDO	(tsns_en_sensor_ldo),
        .TSNS_EN_SENSOR_LDO_B	(tsns_en_sensor_ldo_b),
        .TSNS_EN_SENSOR_V1P2	(tsns_en_sensor_v1p2),
        .TSNS_EN_SENSOR_V1P2_B	(tsns_en_sensor_v1p2_b),
        .TSNS_SEL_LDO	(tsns_sel_ldo),
        .TSNS_SEL_LDO_B	(tsns_sel_ldo_b),
        .TSNS_SEL_V1P2	(tsns_sel_v1p2),
        .TSNS_SEL_V1P2_B	(tsns_sel_v1p2_b),
        .TSNS_ISOLATE	(tsns_isolate),
        .TSNS_ISOLATE_B	(tsns_isolate_b),
        .TSNS_RESETn	(tsns_resetn),
        .TSNS_RESETn_B	(tsns_resetn_b),
        //Register 0x02 (2)
        .TSNS_R_REF	(tsns_r_ref),
        .TSNS_R_REF_B	(tsns_r_ref_b),
        .TSNS_I_BUF	(tsns_i_buf),
        .TSNS_I_BUF_B	(tsns_i_buf_b),
        .TSNS_I_BUF2	(tsns_i_buf2),
        .TSNS_I_BUF2_B	(tsns_i_buf2_b),
        .TSNS_I_CMP	(tsns_i_cmp),
        .TSNS_I_CMP_B	(tsns_i_cmp_b),
        .TSNS_I_MIRROR	(tsns_i_mirror),
        .TSNS_I_MIRROR_B	(tsns_i_mirror_b),
        .TSNS_I_SOSC	(tsns_i_sosc),
        .TSNS_I_SOSC_B	(tsns_i_sosc_b),
        //Register 0x03 (3)
        .TSNS_MIM	(tsns_mim),
        .TSNS_MIM_B	(tsns_mim_b),
        .TSNS_MOM	(tsns_mom),
        .TSNS_MOM_B	(tsns_mom_b),
        .TSNS_SEL_VVDD	(tsns_sel_vvdd),
        .TSNS_SEL_VVDD_B	(tsns_sel_vvdd_b),
        .TSNS_SEL_STB_TIME	(tsns_sel_stb_time),
        .TSNS_SEL_STB_TIME_B	(tsns_sel_stb_time_b),
        .TSNS_SEL_REF_STB_TIME	(tsns_sel_ref_stb_time),
        .TSNS_SEL_REF_STB_TIME_B	(tsns_sel_ref_stb_time_b),
        .TSNS_SEL_CONV_TIME	(tsns_sel_conv_time),
        .TSNS_SEL_CONV_TIME_B	(tsns_sel_conv_time_b),
        //Register 0x04 (4)
        .TSNS_PDIFF	(tsns_pdiff),
        .TSNS_PDIFF_B	(tsns_pdiff_b),
        //Register 0x05 (5)
        .TSNS_POLY	(tsns_poly),
        .TSNS_POLY_B	(tsns_poly_b),
        //Register 0x06 (6)
        //.TSNS_DOUT	(tsns_dout),
        //Register 0x07 (7)
        .TSNS_INT_RPLY_SHORT_ADDR	(tsns_int_rply_short_addr),
        .TSNS_INT_RPLY_REG_ADDR	(tsns_int_rply_reg_addr),
        //Register 0x08 (8)
        .TMR_SLEEP	(tmr_sleep),
        .TMR_ISOLATE	(tmr_isolate),
        .TMR_ISOLATE_B	(tmr_isolate_b),
        .TMR_RESETB	(tmr_resetb),
        .TMR_EN_OSC	(tmr_en_osc),
        .TMR_RESETB_DIV	(tmr_resetb_div),
        .TMR_RESETB_DCDC	(tmr_resetb_dcdc),
        .TMR_EN_SELF_CLK	(tmr_en_self_clk),
        //Register 0x09 (9)
        .TMR_SEL_CLK_DIV	(tmr_sel_clk_div),
        .TMR_SEL_CLK_OSC	(tmr_sel_clk_osc),
        .TMR_SELF_EN	(tmr_self_en),
        .TMR_IBIAS_REF	(tmr_ibias_ref),
        .TMR_CASCODE_BOOST	(tmr_cascode_boost),
        .TMR_SEL_CAP	(tmr_sel_cap),
        .TMR_SEL_DCAP	(tmr_sel_dcap),
        .TMR_EN_TUNE1	(tmr_en_tune1),
        .TMR_EN_TUNE2	(tmr_en_tune2),
        //Register 0x0A (10)
        .TMR_S	(tmr_s),
        .TMR_DIFF_CON	(tmr_diff_con),
        .TMR_EN_TUNE1_RES	(tmr_en_tune1_res),
        .TMR_EN_TUNE2_RES	(tmr_en_tune2_res),
        .TMR_SAMPLE_EN	(tmr_sample_en),
        .TMR_AFC	(tmr_afc),
        //Register 0x0B (11)
        .TMR_TFR_CON	(tmr_tfr_con),
        //Register 0x0C (12)
        //--- Empty Register
        //Register 0x0D (13)
        //--- Empty Register
        //Register 0x0E (14)
        //--- Empty Register
        //Register 0x0F (15)
        //--- Empty Register
        //Register 0x10 (16)
        //--- Empty Register
        //Register 0x11 (17)
        //--- Empty Register
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
        .WUP_ENABLE	(wup_enable),
        .WUP_LC_IRQ_EN	(wup_lc_irq_en),
        .WUP_AUTO_RESET	(wup_auto_reset),
        .WUP_CLK_SEL	(wup_clk_sel),
        .WUP_ENABLE_CLK_SLP_OUT	(wup_enable_clk_slp_out),
        .WUP_INT_RPLY_SHORT_ADDR	(wup_int_rply_short_addr),
        .WUP_INT_RPLY_REG_ADDR	(wup_int_rply_reg_addr),
        //Register 0x18 (24)
        .WUP_INT_RPLY_PAYLOAD	(wup_int_rply_payload),
        //Register 0x19 (25)
        .WUP_THRESHOLD_EXT	(wup_threshold_ext),
        //Register 0x1A (26)
        .WUP_THRESHOLD	(wup_threshold),
        //Register 0x1B (27)
        //.WUP_CNT_VALUE_EXT	(wup_cnt_value_ext),
        //Register 0x1C (28)
        //.WUP_CNT_VALUE	(wup_cnt_value),
        //Register 0x1D (29)
        .MBC_WAKEUP_ON_PEND_REQ	(mbc_wakeup_on_pend_req),
        .MBC_IGNORE_RX_FAIL	(mbc_ignore_rx_fail),
        .LC_CLK_DIV	(lc_clk_div),
        .LC_CLK_RING	(lc_clk_ring)
       );
    //---- genRF End of Register File ----//

    //******************************
    // LDO
    //******************************
    LDO_V1_TSMC180 sntv3_ldo_0 (
        //Power: 
        //.VDD_3P6      (VDD_3P6)
        //.VDD_1P2      (VDD_1P2)
        //.VOUT         (VDD_LDO_TSNS)
        //.VSS          (VSS)

        // Input @ VDD_3P6
        .ISOLATE_V3P6   (reset_3p6),

        // Input @ VDD_1P2
        .EN_VREF        (ldo_en_vref),
        .EN_IREF        (ldo_en_iref),
        .EN_LDO         (ldo_en_ldo),
        .VREF_I_AMP     (ldo_vref_i_amp),
        .SEL_VOUT       (ldo_sel_vout)
    );
   
    //******************************
    // SNT Level Converter
    //******************************
    //Power Domain: PD3P6
    SNTv3_LC sntv3_lc_0 (
        .ISOLATE                    (reset_3p6),
        //Inputs @ 1.2V
        .TSNS_EN_SENSOR_LDO_1P2     (tsns_en_sensor_ldo),
        .TSNS_EN_SENSOR_LDO_1P2_B   (tsns_en_sensor_ldo_b),
        .TSNS_EN_SENSOR_V1P2_1P2    (tsns_en_sensor_v1p2),
        .TSNS_EN_SENSOR_V1P2_1P2_B  (tsns_en_sensor_v1p2_b),
        .TSNS_SEL_LDO_1P2           (tsns_sel_ldo),
        .TSNS_SEL_LDO_1P2_B         (tsns_sel_ldo_b),
        .TSNS_SEL_V1P2_1P2          (tsns_sel_v1p2),
        .TSNS_SEL_V1P2_1P2_B        (tsns_sel_v1p2_b),

        //Outputs @ 3.6V
        .TSNS_EN_SENSOR_LDO         (tsns_en_sensor_ldo_3p6),
        .TSNS_EN_SENSOR_V1P2        (tsns_en_sensor_v1p2_3p6),
        .TSNS_SEL_LDO               (tsns_sel_ldo_3p6),
        .TSNS_SEL_V1P2              (tsns_sel_v1p2_3p6)
        );

    //******************************
    // TEMP SENSOR
    //******************************
    TEMPSENSOR_V1_TSMC180 sntv3_tempsensor_0 (
        //Power
        //.V1P2 (VDD_1P2)
        //.VLDO (VDD_LDO_TSNS)
        //.VSS  (VSS)

        // Input @ VDD_1P2
        .RESETn     (tsns_resetn),
        .RESETn_B   (tsns_resetn_b),
        .CLR        (tsns_clr_irq),
        .CLR_B      (tsns_clr_irq_b),
        .ISOLATE    (tsns_isolate),
        .ISOLATE_B  (tsns_isolate_b),

        // Input @ VDD_3P6
        .EN_SENSOR_LDO  (tsns_en_sensor_ldo_3p6),
        .EN_SENSOR_V1P2 (tsns_en_sensor_v1p2_3p6),
        .SEL_LDO        (tsns_sel_ldo_3p6),
        .SEL_V1P2       (tsns_sel_v1p2_3p6),

        // Input (Control Bits) @ VDD_1P2
        .CONT_MODE          (tsns_cont_mode),
        .CONT_MODE_B        (tsns_cont_mode_b),
        .BURST_MODE         (tsns_burst_mode),
        .BURST_MODE_B       (tsns_burst_mode_b),
        .SEL_VVDD           (tsns_sel_vvdd),
        .SEL_VVDD_B         (tsns_sel_vvdd_b),
        .R_REF              (tsns_r_ref),
        .R_REF_B            (tsns_r_ref_b),
        .I_BUF              (tsns_i_buf),
        .I_BUF_B            (tsns_i_buf_b),
        .I_BUF2             (tsns_i_buf2),
        .I_BUF2_B           (tsns_i_buf2_b),
        .I_CMP              (tsns_i_cmp),
        .I_CMP_B            (tsns_i_cmp_b),
        .I_MIRROR           (tsns_i_mirror),
        .I_MIRROR_B         (tsns_i_mirror_b),
        .I_SOSC             (tsns_i_sosc),
        .I_SOSC_B           (tsns_i_sosc_b),
        .MIM                (tsns_mim),
        .MIM_B              (tsns_mim_b),
        .MOM                (tsns_mom),
        .MOM_B              (tsns_mom_b),
        .PDIFF              (tsns_pdiff),
        .PDIFF_B            (tsns_pdiff_b),
        .POLY               (tsns_poly),
        .POLY_B             (tsns_poly_b),
        .SEL_STB_TIME       (tsns_sel_stb_time),
        .SEL_STB_TIME_B     (tsns_sel_stb_time_b),
        .SEL_REF_STB_TIME   (tsns_sel_ref_stb_time),
        .SEL_REF_STB_TIME_B (tsns_sel_ref_stb_time_b),
        .SEL_CONV_TIME      (tsns_sel_conv_time),
        .SEL_CONV_TIME_B    (tsns_sel_conv_time_b),
        .EN_CLK_REF         (tsns_en_clk_ref),
        .EN_CLK_REF_B       (tsns_en_clk_ref_b),
        .EN_CLK_SENS        (tsns_en_clk_sens),
        .EN_CLK_SENS_B      (tsns_en_clk_sens_b),

        // Output @ VDD_LDO or VDD_1P2
        .DOUT               (tsns_dout_vldo),
        .DOUT_B             (tsns_dout_b_vldo),
        .IRQ                (tsns_irq_vldo),
        .IRQ_B              (tsns_irq_b_vldo),
        .PAD_CLK_SENS       (tsns_clk_sense_vldo),
        .PAD_CLK_SENS_B     (tsns_clk_sense_b_vldo),
        .PAD_CLK_REF        (tsns_clk_ref_vldo),
        .PAD_CLK_REF_B      (tsns_clk_ref_b_vldo),
        .CLK_REF_DIV        (), // not-used
        .CLK_REF_DIV_B      ()  // not-used
    );


    //******************************
    // TIMER
    //******************************
    TIMER_5K_V2_TSMC180 sntv3_timer_0 (
        //Power
        //.V1P2 (VDD_1P2_TMR)
        //.VSS  (VSS)

        // Output @ VDD_1P2
        .CLK            (tmr_clk_uniso),
        .CLK_DIV        (), // not-used

        // Input @ VDD_1P2
        .RESETB         (tmr_resetb),
        .EN_OSC         (tmr_en_osc),
        .RESETB_DIV     (tmr_resetb_div),
        .RESETB_DCDC    (tmr_resetb_dcdc),
        .EN_SELF_CLK    (tmr_en_self_clk),
        .SEL_CLK_DIV    (tmr_sel_clk_div),
        .SEL_CLK_OSC    (tmr_sel_clk_osc),
        .SELF_EN        (tmr_self_en),
        .IBIAS_REF      (tmr_ibias_ref),
        .CASCODE_BOOST  (tmr_cascode_boost),
        .SEL_CAP        (tmr_sel_cap),
        .SEL_DCAP       (tmr_sel_dcap),
        .EN_TUNE1       (tmr_en_tune1),
        .EN_TUNE2       (tmr_en_tune2),
        .S              (tmr_s),
        .DIFF_CON       (tmr_diff_con),
        .EN_TUNE1_RES   (tmr_en_tune1_res),
        .EN_TUNE2_RES   (tmr_en_tune2_res),
        .SAMPLE_EN      (tmr_sample_en),
        .AFC            (tmr_afc),
        .TFR_CON        (tmr_tfr_con)
    );


    //******************************
    // Wakeup Timer
    //******************************
    //Power Domain: PD1P2
    SNTv3_WUP_TIMER sntv3_wup_timer_0 (
        //Inputs
        .RESETn         (resetn),
        .ENABLE         (wup_enable),
        .CLK_TSNS       (tsns_clk_ref),
        .CLK_TMR        (tmr_clk),
        .CLK_SEL        (wup_clk_sel),
        .THRESHOLD      (wup_threshold),
        .THRESHOLD_EXT  (wup_threshold_ext),
        .CLR_IRQ        (wup_clr_irq),
        .LC_IRQ_EN      (wup_lc_irq_en),
        .AUTO_RESET     (wup_auto_reset),
        .EN_CLK_SLP_OUT (wup_enable_clk_slp_out),

        .MBC_SLEEP      (mbc_sleep),
        .MBC_ISOLATE    (mbc_isolate),
        .MBC_RESET      (mbc_reset),
        .LC_ISOLATE     (lc_isolate),

        //Output
        .CNT_VALUE      (wup_cnt_value),
        .CNT_VALUE_EXT  (wup_cnt_value_ext),
        .IRQ            (wup_irq),
        .WAKEUP_REQ     (wup_wakeup_req),
        .CLK_SLP        (clk_slp)   // Pad output
    );

endmodule // SNTv3
