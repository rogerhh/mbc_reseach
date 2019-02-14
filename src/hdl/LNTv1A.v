//*******************************************************************************************
// TOP-LEVEL VERILOG FOR LNTv1A
//-------------------------------------------------------------------------------------------
// < COMPILER DIRECTIVES >
//  LNTv1A_def.v must precede whenever this file is used.
//-------------------------------------------------------------------------------------------
// < UPDATE HISTORY >
//  May 10 2018 -   Template first created by Yejoong Kim
//-------------------------------------------------------------------------------------------
// < AUTHOR > 
//  Yejoong Kim (yejoong@umich.edu)
//******************************************************************************************* 

module LNTv1A (
    PAD_CIN,
    PAD_COUT,
    PAD_DIN,
    PAD_DOUT,
    PAD_CLK_SLP,
    PV_HIGH,
    PV_LOW,
	PAD_OVVAL_ABUF,
	PAD_OVVAL_IBIAS_VBIAS,
	PAD_OVVAL_VREF_COMP,
	PAD_OVVAL_VREF_PV,
	PAD_OBS_ABUF,
	PAD_OBS_IBIAS,
	PAD_OBS_AFEOUT
    );

    //******************************
    // Top IO
    //******************************
    input       PAD_CIN;
    output      PAD_COUT;
    input       PAD_DIN;
    output      PAD_DOUT;
    output      PAD_CLK_SLP;

    // Barewire
    input       PV_HIGH;
    input       PV_LOW;

    // Included in LDC
	output      PAD_OVVAL_ABUF;
	output      PAD_OVVAL_IBIAS_VBIAS;
	output      PAD_OVVAL_VREF_COMP;
	output      PAD_OVVAL_VREF_PV;
	output      PAD_OBS_ABUF;
	output      PAD_OBS_IBIAS;
	output      PAD_OBS_AFEOUT;

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
    wire        lc_isolate, lc_isolate_b, lc_isolate_uniso;

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
    `ifdef LNTv1A_LAYERCTRL_MEM_ENABLE
    wire        lc2mem_req;
    wire        lc2mem_write;
    wire        lc2mem_pend;
    wire [31:0] lc2mem_wr_data;
    wire [31:0] lc2mem_addr;
    wire [31:0] mem2lc_rd_data;
    wire        mem2lc_ack;
    `endif

    // Layer Ctrl Interrupt Interface
    wire   ldc2lc_irq_uniso, ldc2lc_irq;
    wire   lc2ldc_clr_irq_uniso, lc2ldc_clr_irq, lc2ldc_clr_irq_b;
    wire   wup2lc_irq;
    wire   lc2wup_clr_irq_uniso, lc2wup_clr_irq;

    // LNTv1A_LDC signals
    wire clk_fdiv, clk_fdiv_b, clk_fdiv_3p6;

    // Output from LNTv1A_LDC
    wire [23:0] dout_lower_uniso; 
    wire [22:0] dout_upper_uniso;
    wire [6:0] ctrl_icharge_div_uniso;
    wire [2:0] ctrlb_icharge_div_uniso;
    wire [6:0] ctrl_icharge_mul_uniso;
    wire ctrlb_icharge_div_lowleak_uniso;
    wire ctrlb_icharge_mul_lowleak_uniso;
    wire [11:0] monitor_uniso;
    wire dout_overflow_uniso;
    wire monitor_overflow_uniso;
    wire [2:0] counter_state_uniso;
    wire [2:0] monitor_state_uniso;
    wire [4:0] ldc_config_uniso;

    // Input@3P6 to LNTv1A_LDC
    wire        lc2ldc_clr_irq_3p6;
    wire [ 2:0] ctrl_capsize_3p6;
    wire [ 2:0] ctrl_icomp_3p6;
    wire [ 3:0] ctrl_ibias_vbias_3p6;
    wire [ 3:0] ctrl_ibias_i_3p6;
    wire        ctrl_vofs_cancel_3p6;
    wire        mode_continuous_3p6;
    wire        dbe_enable_3p6;
    wire        reset_afe_3p6;
    wire        resetn_dbe_3p6;
    wire        ldc_isolate_3p6;
    wire        ldc_pg_3p6;
    wire        ovsel_ibias_vbias_3p6;
    wire        ovsel_vref_comp_3p6;
    wire        ovsel_vref_pv_3p6;
    wire [ 1:0] obssel_abuf_3p6;
    wire        obsen_afeout_3p6;
    wire [ 1:0] ctrl_vref_comp_v_3p6;
    wire [ 6:0] ctrlb_vref_comp_i_3p6;
    wire [ 1:0] ctrl_vref_pv_v_3p6;
    wire [ 6:0] ctrlb_vref_pv_i_3p6;
    wire [23:0] time_counting_3p6;
    wire [11:0] time_monitor_hold_3p6;
    wire [11:0] time_monitoring_3p6;
    wire [11:0] threshold_high_3p6;
    wire [11:0] threshold_low_3p6;
    wire        ovval_ctrlb_icharge_mul_lowleak_3p6;
    wire        ovsel_ctrlb_icharge_mul_lowleak_3p6;
    wire        ovval_ctrlb_icharge_div_lowleak_3p6;
    wire        ovsel_ctrlb_icharge_div_lowleak_3p6;
    wire [ 4:0] ovval_config_3p6;
    wire        ovsel_config_3p6;
    wire [ 2:0] ovval_monitor_state_3p6;
    wire        ovsel_monitor_state_3p6;
    wire [ 2:0] ovval_counter_state_3p6;
    wire        ovsel_counter_state_3p6;
    wire        ovval_din_3p6;
    wire        ovsel_din_3p6;
    wire        ovval_clk_3p6;
    wire        ovsel_clk_3p6;
    wire [ 6:0] ovval_ctrl_icharge_mul_3p6;
    wire        ovsel_ctrl_icharge_mul_3p6;
    wire [ 2:0] ovval_ctrlb_icharge_div_3p6;
    wire        ovsel_ctrlb_icharge_div_3p6;
    wire [ 6:0] ovval_ctrl_icharge_div_3p6;
    wire        ovsel_ctrl_icharge_div_3p6;


    // Layer_Ctrl <-> MBus RF Interface
    //---- genRF Beginning of Wire Declaration ----//
    wire [71:0] lc2rf_addr_in;
    wire [23:0] lc2rf_data_in;
    //Register 0x00 (  0)
    wire        wakeup_when_done;
    wire        mode_continuous;
    wire        mode_continuous_b; // Inverted Signal of mode_continuous
    wire        dbe_enable;
    wire        dbe_enable_b; // Inverted Signal of dbe_enable
    wire        reset_afe;
    wire        reset_afe_b; // Inverted Signal of reset_afe
    wire        resetn_dbe;
    wire        resetn_dbe_b; // Inverted Signal of resetn_dbe
    wire        ldc_isolate;
    wire        ldc_isolate_b; // Inverted Signal of ldc_isolate
    wire        ldc_pg;
    wire        ldc_pg_b; // Inverted Signal of ldc_pg
    //Register 0x01 (  1)
    wire [ 2:0] ctrl_capsize;
    wire [ 2:0] ctrl_capsize_b; // Inverted Signal of ctrl_capsize
    wire [ 2:0] ctrl_icomp;
    wire [ 2:0] ctrl_icomp_b; // Inverted Signal of ctrl_icomp
    wire        ctrl_vofs_cancel;
    wire        ctrl_vofs_cancel_b; // Inverted Signal of ctrl_vofs_cancel
    wire [ 3:0] ctrl_ibias_vbias;
    wire [ 3:0] ctrl_ibias_vbias_b; // Inverted Signal of ctrl_ibias_vbias
    wire [ 3:0] ctrl_ibias_i;
    wire [ 3:0] ctrl_ibias_i_b; // Inverted Signal of ctrl_ibias_i
    //Register 0x02 (  2)
    wire [ 1:0] ctrl_vref_comp_v;
    wire [ 1:0] ctrl_vref_comp_v_b; // Inverted Signal of ctrl_vref_comp_v
    wire [ 6:0] ctrlb_vref_comp_i;
    wire [ 6:0] ctrlb_vref_comp_i_b; // Inverted Signal of ctrlb_vref_comp_i
    wire [ 1:0] ctrl_vref_pv_v;
    wire [ 1:0] ctrl_vref_pv_v_b; // Inverted Signal of ctrl_vref_pv_v
    wire [ 6:0] ctrlb_vref_pv_i;
    wire [ 6:0] ctrlb_vref_pv_i_b; // Inverted Signal of ctrlb_vref_pv_i
    //Register 0x03 (  3)
    wire [23:0] time_counting;
    wire [23:0] time_counting_b; // Inverted Signal of time_counting
    //Register 0x04 (  4)
    wire [11:0] time_monitor_hold;
    wire [11:0] time_monitor_hold_b; // Inverted Signal of time_monitor_hold
    wire [11:0] time_monitoring;
    wire [11:0] time_monitoring_b; // Inverted Signal of time_monitoring
    //Register 0x05 (  5)
    wire [11:0] threshold_high;
    wire [11:0] threshold_high_b; // Inverted Signal of threshold_high
    wire [11:0] threshold_low;
    wire [11:0] threshold_low_b; // Inverted Signal of threshold_low
    //Register 0x06 (  6)
    wire        obsen_afeout;
    wire        obsen_afeout_b; // Inverted Signal of obsen_afeout
    //Register 0x07 (  7)
    wire [ 1:0] obssel_abuf;
    wire [ 1:0] obssel_abuf_b; // Inverted Signal of obssel_abuf
    //Register 0x08 (  8)
    wire        ovsel_ibias_vbias;
    wire        ovsel_ibias_vbias_b; // Inverted Signal of ovsel_ibias_vbias
    wire        ovsel_vref_comp;
    wire        ovsel_vref_comp_b; // Inverted Signal of ovsel_vref_comp
    wire        ovsel_vref_pv;
    wire        ovsel_vref_pv_b; // Inverted Signal of ovsel_vref_pv
    //Register 0x09 (  9)
    wire        ovval_din;
    wire        ovval_din_b; // Inverted Signal of ovval_din
    wire        ovsel_din;
    wire        ovsel_din_b; // Inverted Signal of ovsel_din
    //Register 0x0A ( 10)
    wire        ovval_clk;
    wire        ovval_clk_b; // Inverted Signal of ovval_clk
    wire        ovsel_clk;
    wire        ovsel_clk_b; // Inverted Signal of ovsel_clk
    //Register 0x0B ( 11)
    wire [ 4:0] ovval_config;
    wire [ 4:0] ovval_config_b; // Inverted Signal of ovval_config
    wire        ovsel_config;
    wire        ovsel_config_b; // Inverted Signal of ovsel_config
    //Register 0x0C ( 12)
    wire [ 2:0] ovval_monitor_state;
    wire [ 2:0] ovval_monitor_state_b; // Inverted Signal of ovval_monitor_state
    wire        ovsel_monitor_state;
    wire        ovsel_monitor_state_b; // Inverted Signal of ovsel_monitor_state
    //Register 0x0D ( 13)
    wire [ 2:0] ovval_counter_state;
    wire [ 2:0] ovval_counter_state_b; // Inverted Signal of ovval_counter_state
    wire        ovsel_counter_state;
    wire        ovsel_counter_state_b; // Inverted Signal of ovsel_counter_state
    //Register 0x0E ( 14)
    wire [ 6:0] ovval_ctrl_icharge_mul;
    wire [ 6:0] ovval_ctrl_icharge_mul_b; // Inverted Signal of ovval_ctrl_icharge_mul
    wire [ 2:0] ovval_ctrlb_icharge_div;
    wire [ 2:0] ovval_ctrlb_icharge_div_b; // Inverted Signal of ovval_ctrlb_icharge_div
    wire [ 6:0] ovval_ctrl_icharge_div;
    wire [ 6:0] ovval_ctrl_icharge_div_b; // Inverted Signal of ovval_ctrl_icharge_div
    wire        ovval_ctrlb_icharge_mul_lowleak;
    wire        ovval_ctrlb_icharge_mul_lowleak_b; // Inverted Signal of ovval_ctrlb_icharge_mul_lowleak
    wire        ovval_ctrlb_icharge_div_lowleak;
    wire        ovval_ctrlb_icharge_div_lowleak_b; // Inverted Signal of ovval_ctrlb_icharge_div_lowleak
    //Register 0x0F ( 15)
    wire        ovsel_ctrl_icharge_mul;
    wire        ovsel_ctrl_icharge_mul_b; // Inverted Signal of ovsel_ctrl_icharge_mul
    wire        ovsel_ctrlb_icharge_div;
    wire        ovsel_ctrlb_icharge_div_b; // Inverted Signal of ovsel_ctrlb_icharge_div
    wire        ovsel_ctrl_icharge_div;
    wire        ovsel_ctrl_icharge_div_b; // Inverted Signal of ovsel_ctrl_icharge_div
    wire        ovsel_ctrlb_icharge_mul_lowleak;
    wire        ovsel_ctrlb_icharge_mul_lowleak_b; // Inverted Signal of ovsel_ctrlb_icharge_mul_lowleak
    wire        ovsel_ctrlb_icharge_div_lowleak;
    wire        ovsel_ctrlb_icharge_div_lowleak_b; // Inverted Signal of ovsel_ctrlb_icharge_div_lowleak
    //Register 0x10 ( 16)
    wire [23:0] dout_lower;
    //Register 0x11 ( 17)
    wire        dout_overflow;
    wire [22:0] dout_upper;
    //Register 0x12 ( 18)
    wire [ 4:0] ldc_config;
    //Register 0x13 ( 19)
    wire [ 6:0] ctrl_icharge_mul;
    wire [ 2:0] ctrlb_icharge_div;
    wire [ 6:0] ctrl_icharge_div;
    wire        ctrlb_icharge_mul_lowleak;
    wire        ctrlb_icharge_div_lowleak;
    //Register 0x14 ( 20)
    wire        monitor_overflow;
    wire [11:0] monitor;
    //Register 0x15 ( 21)
    wire [ 2:0] monitor_state;
    //Register 0x16 ( 22)
    wire [ 2:0] counter_state;
    //Register 0x17 ( 23)
    wire [ 3:0] fdiv_ctrl_freq;
    wire        fdiv_resetn;
    //Register 0x20 ( 32)
    wire        tmr_resetb;
    wire        tmr_en_osc;
    wire        tmr_resetb_div;
    wire        tmr_resetb_dcdc;
    wire        tmr_en_self_clk;
    //Register 0x21 ( 33)
    wire        tmr_sel_clk_div;
    wire        tmr_sel_clk_osc;
    wire        tmr_self_en;
    wire [ 3:0] tmr_ibias_ref;
    wire        tmr_cascode_boost;
    wire [ 7:0] tmr_sel_cap;
    wire [ 5:0] tmr_sel_dcap;
    wire        tmr_en_tune1;
    wire        tmr_en_tune2;
    //Register 0x22 ( 34)
    wire [ 2:0] tmr_s;
    wire [13:0] tmr_diff_con;
    wire        tmr_poly_con;
    wire        tmr_en_tune1_res;
    wire        tmr_en_tune2_res;
    wire        tmr_sample_en;
    wire [ 2:0] tmr_afc;
    //Register 0x30 ( 48)
    wire        wakeup_on_pend_req;
    wire        mbus_ignore_rx_fail;
    wire [ 1:0] clkgen_div;
    wire [ 1:0] clkgen_ring;
    //Register 0x31 ( 49)
    wire [ 7:0] ldc_irq_short_addr;
    wire [ 7:0] ldc_irq_reg_addr;
    //Register 0x32 ( 50)
    wire [ 7:0] ldc_irq_start_reg_addr;
    wire [ 7:0] ldc_irq_num_reg_1;
    //Register 0x40 ( 64)
    wire        wup_enable;
    wire        wup_lc_irq_en;
    wire        wup_auto_reset;
    wire        wup_enable_clk_slp_out;
    //Register 0x41 ( 65)
    wire [ 7:0] wup_threshold_ext;
    //Register 0x42 ( 66)
    wire [23:0] wup_threshold;
    //Register 0x43 ( 67)
    wire [ 7:0] wup_cnt_value_ext;
    //Register 0x44 ( 68)
    wire [23:0] wup_cnt_value;
    //Register 0x45 ( 69)
    wire [23:0] wup_irq_payload;
    //Register 0x46 ( 70)
    wire [ 7:0] wup_irq_short_addr;
    wire [ 7:0] wup_irq_reg_addr;
    //Register 0x47 ( 71)
    wire [ 7:0] wup_irq_start_reg_addr;
    wire [ 7:0] wup_irq_num_reg_1;
    //---- genRF End of Wire Declaration ----//

    // Clock
    wire   clk_lc;
    wire   clk_tmr;
    wire   clk_slp;

    // Misc
    wire        wakeup_req;             // System wakeup request. Must be generated by an always-on module.

    //*************************
    // Pads
    //*************************
    // Power
    PAD_100x60_DVDD_TP_TP_TSMC180    PAD_VDD_3P6_0    (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS)
    PAD_100x60_VDD_TP_TP_TSMC180     PAD_VDD_1P2_0    (); // DVDD(VDD_3P6), DVSS(VSS), VDD(VDD_1P2)
    PAD_100x60_VDD_TP_TP_TSMC180     PAD_VDD_0P6_0    (); // DVDD(VDD_3P6), DVSS(VSS), VDD(VDD_0P6)
    PAD_100x60_DVSS_TP_TP_TSMC180    PAD_VSS_0        (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS)

    // MBus
    PAD_50x60_DI_ST_TP_TSMC180       PAD_DIN_CIN_0    (.PAD(PAD_CIN),  .Y(cin) ); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DO_TP_TP_TSMC180       PAD_DOUT_COUT_0  (.PAD(PAD_COUT), .A(cout)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DI_TP_TP_TSMC180       PAD_DIN_DIN_0    (.PAD(PAD_DIN),  .Y(din) ); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)
    PAD_50x60_DO_TP_TP_TSMC180       PAD_DOUT_DOUT_0  (.PAD(PAD_DOUT), .A(dout)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)

    // Sleep Clock Output
    PAD_50x60_DO_TP_TP_TSMC180      PAD_DOUT_CLK_SLP_0      (.PAD(PAD_CLK_SLP), .A(clk_slp)); // DVDD(VDD_3P6), DVSS(VSS), DIO_VDD(VDD_1P2)

    // Diode Connection
    PAD_50x60_BWS_NE_TP_TSMC180     PAD_PV_HIGH_0   (.PAD(PV_HIGH)); // DVDD(VDD_3P6), DVSS(VSS)
    PAD_50x60_BWS_NE_TP_TSMC180     PAD_PV_LOW_0    (.PAD(PV_LOW)); // DVDD(VDD_3P6), DVSS(VSS)

    // ESD Detection
    DETECTION_TSMC180                DETECTION_0      (.DETECT(esd_detect)); // DVDD(VDD_3P6), DVSS(VSS)

    //*************************
    // Reset Detector
    //*************************
    RSTDTCTRG_DUAL_TSMC180 lntv1a_rstdtctrg_dual_0 (
        .RESETn_V1P2    (resetn),
        .RESETn_V3P6    (), // not used
        .RESET_V3P6     (reset_3p6)
        );

    //******************************
    // Layer Controller Header
    //******************************
    HEADER_1P2_PH100_0P6_NH100_PS100_TSMC180 lntv1a_lc_header_0 (
        .SLEEP (lc_sleep)
        );

    //******************************
    // MBC Power Gate Header
    //******************************
    HEADER_1P2_PH100_TSMC180 lntv1a_mbc_header_0 (
        .SLEEP (mbc_sleep)
        );

    //*************************
    // Clock Generator
    //*************************
    CLK_GEN_V1_B_TSMC180 lntv1a_clkgen_0 (
        .EN_B        (lc_clkenb),
        .ISOLATE     (lc_isolate),
        .S_DIV       (clkgen_div),
        .S_RING      (clkgen_ring),
        .CLK_1P2     (clk_lc)
        );
   
    //******************************
    // Bus Controller (MBC)
    //******************************
    lntv1a_mbus_node  #(.ADDRESS(`LNTv1A_MBUS_FULL_PREFIX))
    lntv1a_mbus_node_0 (
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
        .MBC_IN_FWD   (), // not used
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
    lntv1a_mbus_member_ctrl lntv1a_mbus_member_ctrl_0 (
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
        .WAKEUP_ON_PEND_REQ(wakeup_on_pend_req),
        .ADDR_WR_EN        (mbc2mc_write),
        .ADDR_CLR_B        (mbc2mc_resetn),
        .ADDR_IN           (mbc2mc_addr),
        .ADDR_OUT          (mc2mbc_addr),
        .ADDR_VALID        (mc2mbc_valid),
		.LRC_SLEEP		   (lc_sleep),
        .MBUS_BUSY         (mbc2mc_mbus_busy)
        );

    //******************************
    // Layer Controller
    //******************************
    lntv1a_layer_ctrl #(
                        `ifdef LNTv1A_LAYERCTRL_INT_ENABLE
                        .LC_INT_DEPTH           (`LNTv1A_LAYERCTRL_INT_DEPTH),
                        `endif
                        `ifdef LNTv1A_LAYERCTRL_MEM_ENABLE
                        .LC_MEM_STREAM_CHANNELS (`LNTv1A_LAYERCTRL_MEM_STREAM_CHANNELS),
                        .LC_MEM_ADDR_WIDTH      (`LNTv1A_LAYERCTRL_MEM_ADDR_WIDTH),
                        .LC_MEM_DATA_WIDTH      (`LNTv1A_LAYERCTRL_MEM_DATA_WIDTH),
                        `endif
                        .LC_RF_DEPTH            (`LNTv1A_MBUS_RF_SIZE))
    lntv1a_layer_ctrl_0 (
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

        .IGNORE_RX_FAIL (1'b1), // hardwired to 1'b1

        // Interface with MEM
        `ifdef LNTv1A_LAYERCTRL_MEM_ENABLE
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
                  /*Reg 0x47 (71)*/ 8'h0, wup_irq_start_reg_addr, wup_irq_num_reg_1, 
                  /*Reg 0x46 (70)*/ 8'h0, wup_irq_short_addr, wup_irq_reg_addr, 
                  /*Reg 0x45 (69)*/ wup_irq_payload, 
                  /*Reg 0x44 (68)*/ wup_cnt_value, 
                  /*Reg 0x43 (67)*/ 16'h0, wup_cnt_value_ext, 
                  /*Reg 0x42 (66)*/ wup_threshold, 
                  /*Reg 0x41 (65)*/ 16'h0, wup_threshold_ext, 
                  /*Reg 0x40 (64)*/ wup_enable, wup_lc_irq_en, wup_auto_reset, 1'h0, wup_enable_clk_slp_out, 19'h0, 
                  /*Reg 0x3F (63)*/ 24'h0, 
                  /*Reg 0x3E (62)*/ 24'h0, 
                  /*Reg 0x3D (61)*/ 24'h0, 
                  /*Reg 0x3C (60)*/ 24'h0, 
                  /*Reg 0x3B (59)*/ 24'h0, 
                  /*Reg 0x3A (58)*/ 24'h0, 
                  /*Reg 0x39 (57)*/ 24'h0, 
                  /*Reg 0x38 (56)*/ 24'h0, 
                  /*Reg 0x37 (55)*/ 24'h0, 
                  /*Reg 0x36 (54)*/ 24'h0, 
                  /*Reg 0x35 (53)*/ 24'h0, 
                  /*Reg 0x34 (52)*/ 24'h0, 
                  /*Reg 0x33 (51)*/ 24'h0, 
                  /*Reg 0x32 (50)*/ 8'h0, ldc_irq_start_reg_addr, ldc_irq_num_reg_1, 
                  /*Reg 0x31 (49)*/ 8'h0, ldc_irq_short_addr, ldc_irq_reg_addr, 
                  /*Reg 0x30 (48)*/ 18'h0, wakeup_on_pend_req, mbus_ignore_rx_fail, clkgen_div, clkgen_ring, 
                  /*Reg 0x2F (47)*/ 24'h0, 
                  /*Reg 0x2E (46)*/ 24'h0, 
                  /*Reg 0x2D (45)*/ 24'h0, 
                  /*Reg 0x2C (44)*/ 24'h0, 
                  /*Reg 0x2B (43)*/ 24'h0, 
                  /*Reg 0x2A (42)*/ 24'h0, 
                  /*Reg 0x29 (41)*/ 24'h0, 
                  /*Reg 0x28 (40)*/ 24'h0, 
                  /*Reg 0x27 (39)*/ 24'h0, 
                  /*Reg 0x26 (38)*/ 24'h0, 
                  /*Reg 0x25 (37)*/ 24'h0, 
                  /*Reg 0x24 (36)*/ 24'h0, 
                  /*Reg 0x23 (35)*/ 24'h0, 
                  /*Reg 0x22 (34)*/ tmr_s, tmr_diff_con, tmr_poly_con, tmr_en_tune1_res, tmr_en_tune2_res, tmr_sample_en, tmr_afc, 
                  /*Reg 0x21 (33)*/ tmr_sel_clk_div, tmr_sel_clk_osc, tmr_self_en, tmr_ibias_ref, tmr_cascode_boost, tmr_sel_cap, tmr_sel_dcap, tmr_en_tune1, tmr_en_tune2, 
                  /*Reg 0x20 (32)*/ 19'h0, tmr_resetb, tmr_en_osc, tmr_resetb_div, tmr_resetb_dcdc, tmr_en_self_clk, 
                  /*Reg 0x1F (31)*/ 24'h0, 
                  /*Reg 0x1E (30)*/ 24'h0, 
                  /*Reg 0x1D (29)*/ 24'h0, 
                  /*Reg 0x1C (28)*/ 24'h0, 
                  /*Reg 0x1B (27)*/ 24'h0, 
                  /*Reg 0x1A (26)*/ 24'h0, 
                  /*Reg 0x19 (25)*/ 24'h0, 
                  /*Reg 0x18 (24)*/ 24'h0, 
                  /*Reg 0x17 (23)*/ 19'h0, fdiv_ctrl_freq, fdiv_resetn, 
                  /*Reg 0x16 (22)*/ 21'h0, counter_state, 
                  /*Reg 0x15 (21)*/ 21'h0, monitor_state, 
                  /*Reg 0x14 (20)*/ 11'h0, monitor_overflow, monitor, 
                  /*Reg 0x13 (19)*/ 5'h0, ctrl_icharge_mul, ctrlb_icharge_div, ctrl_icharge_div, ctrlb_icharge_mul_lowleak, ctrlb_icharge_div_lowleak, 
                  /*Reg 0x12 (18)*/ 19'h0, ldc_config, 
                  /*Reg 0x11 (17)*/ dout_overflow, dout_upper, 
                  /*Reg 0x10 (16)*/ dout_lower, 
                  /*Reg 0x0F (15)*/ 19'h0, ovsel_ctrl_icharge_mul, ovsel_ctrlb_icharge_div, ovsel_ctrl_icharge_div, ovsel_ctrlb_icharge_mul_lowleak, ovsel_ctrlb_icharge_div_lowleak, 
                  /*Reg 0x0E (14)*/ 5'h0, ovval_ctrl_icharge_mul, ovval_ctrlb_icharge_div, ovval_ctrl_icharge_div, ovval_ctrlb_icharge_mul_lowleak, ovval_ctrlb_icharge_div_lowleak, 
                  /*Reg 0x0D (13)*/ 20'h0, ovval_counter_state, ovsel_counter_state, 
                  /*Reg 0x0C (12)*/ 20'h0, ovval_monitor_state, ovsel_monitor_state, 
                  /*Reg 0x0B (11)*/ 18'h0, ovval_config, ovsel_config, 
                  /*Reg 0x0A (10)*/ 22'h0, ovval_clk, ovsel_clk, 
                  /*Reg 0x09 ( 9)*/ 22'h0, ovval_din, ovsel_din, 
                  /*Reg 0x08 ( 8)*/ 21'h0, ovsel_ibias_vbias, ovsel_vref_comp, ovsel_vref_pv, 
                  /*Reg 0x07 ( 7)*/ 22'h0, obssel_abuf, 
                  /*Reg 0x06 ( 6)*/ 23'h0, obsen_afeout, 
                  /*Reg 0x05 ( 5)*/ threshold_high, threshold_low, 
                  /*Reg 0x04 ( 4)*/ time_monitor_hold, time_monitoring, 
                  /*Reg 0x03 ( 3)*/ time_counting, 
                  /*Reg 0x02 ( 2)*/ 6'h0, ctrl_vref_comp_v, ctrlb_vref_comp_i, ctrl_vref_pv_v, ctrlb_vref_pv_i, 
                  /*Reg 0x01 ( 1)*/ 9'h0, ctrl_capsize, ctrl_icomp, ctrl_vofs_cancel, ctrl_ibias_vbias, ctrl_ibias_i, 
                  /*Reg 0x00 ( 0)*/ 17'h0, wakeup_when_done, mode_continuous, dbe_enable, reset_afe, resetn_dbe, ldc_isolate, ldc_pg
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
        `ifdef LNTv1A_LAYERCTRL_INT_ENABLE
        .INT_VECTOR     ({ldc2lc_irq, wup2lc_irq}),
        .CLR_INT        ({lc2ldc_clr_irq_uniso, lc2wup_clr_irq_uniso}),
        .INT_FU_ID      ({4'h1, 4'h1}),
        .INT_CMD        ({ldc_irq_start_reg_addr, ldc_irq_num_reg_1, ldc_irq_short_addr, ldc_irq_reg_addr, 64'h0,
                          wup_irq_start_reg_addr, wup_irq_num_reg_1, wup_irq_short_addr, wup_irq_reg_addr, 64'h0}),
        .INT_CMD_LEN    ({2'h1, 2'h1}),
        `endif

        // Others
        .RX_REQ_SYNC    (), // not used
        .RX_PEND_SYNC   (), // not used
        .SOFT_RESET_REQ ()  // not used
        );

    //******************************
    // MBUS Isolation
    //******************************
    lntv1a_mbus_isolation lntv1a_mbus_isolation_0 (
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
        .LRC_ISOLATEB      (lc_isolate_b),

        // LDC
        .LDC_ISOLATE_B                       (ldc_isolate_b),
        .LDC_DOUT_uniso                      ({dout_upper_uniso, dout_lower_uniso}),
        .LDC_DOUT                            ({dout_upper, dout_lower}),
        .LDC_DONE_uniso                      (ldc2lc_irq_uniso),
        .LDC_DONE                            (ldc2lc_irq),
        .LDC_CTRL_ICHARGE_DIV_uniso          (ctrl_icharge_div_uniso),
        .LDC_CTRL_ICHARGE_DIV                (ctrl_icharge_div),
        .LDC_CTRLB_ICHARGE_DIV_uniso         (ctrlb_icharge_div_uniso),
        .LDC_CTRLB_ICHARGE_DIV               (ctrlb_icharge_div),
        .LDC_CTRL_ICHARGE_MUL_uniso          (ctrl_icharge_mul_uniso),
        .LDC_CTRL_ICHARGE_MUL                (ctrl_icharge_mul),
        .LDC_CTRLB_ICHARGE_DIV_LOWLEAK_uniso (ctrlb_icharge_div_lowleak_uniso),
        .LDC_CTRLB_ICHARGE_DIV_LOWLEAK       (ctrlb_icharge_div_lowleak),
        .LDC_CTRLB_ICHARGE_MUL_LOWLEAK_uniso (ctrlb_icharge_mul_lowleak_uniso),
        .LDC_CTRLB_ICHARGE_MUL_LOWLEAK       (ctrlb_icharge_mul_lowleak),
        .LDC_MONITOR_uniso                   (monitor_uniso),
        .LDC_MONITOR                         (monitor),
        .LDC_DOUT_OVERFLOW_uniso             (dout_overflow_uniso),
        .LDC_DOUT_OVERFLOW                   (dout_overflow),
        .LDC_MONITOR_OVERFLOW_uniso          (monitor_overflow_uniso),
        .LDC_MONITOR_OVERFLOW                (monitor_overflow),
        .LDC_COUNTER_STATE_uniso             (counter_state_uniso),
        .LDC_COUNTER_STATE                   (counter_state),
        .LDC_MONITOR_STATE_uniso             (monitor_state_uniso),
        .LDC_MONITOR_STATE                   (monitor_state),
        .LDC_CONFIG_uniso                    (ldc_config_uniso),
        .LDC_CONFIG                          (ldc_config),

        // Layer Ctrl --> Other
        .LDC_CLR_IRQ_uniso  (lc2ldc_clr_irq_uniso),
        .LDC_CLR_IRQ        (lc2ldc_clr_irq),
        .LDC_CLR_IRQ_B      (lc2ldc_clr_irq_b),
        .WUP_CLR_IRQ_uniso  (lc2wup_clr_irq_uniso),
        .WUP_CLR_IRQ        (lc2wup_clr_irq)
        );
   
    //******************************
    // MBus Register File
    //******************************
    //---- genRF Beginning of Register File ----//
    lntv1a_rf lntv1a_rf_0
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
        .WAKEUP_WHEN_DONE	(wakeup_when_done),
        .MODE_CONTINUOUS	(mode_continuous),
        .MODE_CONTINUOUS_B	(mode_continuous_b),
        .DBE_ENABLE	(dbe_enable),
        .DBE_ENABLE_B	(dbe_enable_b),
        .RESET_AFE	(reset_afe),
        .RESET_AFE_B	(reset_afe_b),
        .RESETN_DBE	(resetn_dbe),
        .RESETN_DBE_B	(resetn_dbe_b),
        .LDC_ISOLATE	(ldc_isolate),
        .LDC_ISOLATE_B	(ldc_isolate_b),
        .LDC_PG	(ldc_pg),
        .LDC_PG_B	(ldc_pg_b),
        //Register 0x01 (1)
        .CTRL_CAPSIZE	(ctrl_capsize),
        .CTRL_CAPSIZE_B	(ctrl_capsize_b),
        .CTRL_ICOMP	(ctrl_icomp),
        .CTRL_ICOMP_B	(ctrl_icomp_b),
        .CTRL_VOFS_CANCEL	(ctrl_vofs_cancel),
        .CTRL_VOFS_CANCEL_B	(ctrl_vofs_cancel_b),
        .CTRL_IBIAS_VBIAS	(ctrl_ibias_vbias),
        .CTRL_IBIAS_VBIAS_B	(ctrl_ibias_vbias_b),
        .CTRL_IBIAS_I	(ctrl_ibias_i),
        .CTRL_IBIAS_I_B	(ctrl_ibias_i_b),
        //Register 0x02 (2)
        .CTRL_VREF_COMP_V	(ctrl_vref_comp_v),
        .CTRL_VREF_COMP_V_B	(ctrl_vref_comp_v_b),
        .CTRLB_VREF_COMP_I	(ctrlb_vref_comp_i),
        .CTRLB_VREF_COMP_I_B	(ctrlb_vref_comp_i_b),
        .CTRL_VREF_PV_V	(ctrl_vref_pv_v),
        .CTRL_VREF_PV_V_B	(ctrl_vref_pv_v_b),
        .CTRLB_VREF_PV_I	(ctrlb_vref_pv_i),
        .CTRLB_VREF_PV_I_B	(ctrlb_vref_pv_i_b),
        //Register 0x03 (3)
        .TIME_COUNTING	(time_counting),
        .TIME_COUNTING_B	(time_counting_b),
        //Register 0x04 (4)
        .TIME_MONITOR_HOLD	(time_monitor_hold),
        .TIME_MONITOR_HOLD_B	(time_monitor_hold_b),
        .TIME_MONITORING	(time_monitoring),
        .TIME_MONITORING_B	(time_monitoring_b),
        //Register 0x05 (5)
        .THRESHOLD_HIGH	(threshold_high),
        .THRESHOLD_HIGH_B	(threshold_high_b),
        .THRESHOLD_LOW	(threshold_low),
        .THRESHOLD_LOW_B	(threshold_low_b),
        //Register 0x06 (6)
        .OBSEN_AFEOUT	(obsen_afeout),
        .OBSEN_AFEOUT_B	(obsen_afeout_b),
        //Register 0x07 (7)
        .OBSSEL_ABUF	(obssel_abuf),
        .OBSSEL_ABUF_B	(obssel_abuf_b),
        //Register 0x08 (8)
        .OVSEL_IBIAS_VBIAS	(ovsel_ibias_vbias),
        .OVSEL_IBIAS_VBIAS_B	(ovsel_ibias_vbias_b),
        .OVSEL_VREF_COMP	(ovsel_vref_comp),
        .OVSEL_VREF_COMP_B	(ovsel_vref_comp_b),
        .OVSEL_VREF_PV	(ovsel_vref_pv),
        .OVSEL_VREF_PV_B	(ovsel_vref_pv_b),
        //Register 0x09 (9)
        .OVVAL_DIN	(ovval_din),
        .OVVAL_DIN_B	(ovval_din_b),
        .OVSEL_DIN	(ovsel_din),
        .OVSEL_DIN_B	(ovsel_din_b),
        //Register 0x0A (10)
        .OVVAL_CLK	(ovval_clk),
        .OVVAL_CLK_B	(ovval_clk_b),
        .OVSEL_CLK	(ovsel_clk),
        .OVSEL_CLK_B	(ovsel_clk_b),
        //Register 0x0B (11)
        .OVVAL_CONFIG	(ovval_config),
        .OVVAL_CONFIG_B	(ovval_config_b),
        .OVSEL_CONFIG	(ovsel_config),
        .OVSEL_CONFIG_B	(ovsel_config_b),
        //Register 0x0C (12)
        .OVVAL_MONITOR_STATE	(ovval_monitor_state),
        .OVVAL_MONITOR_STATE_B	(ovval_monitor_state_b),
        .OVSEL_MONITOR_STATE	(ovsel_monitor_state),
        .OVSEL_MONITOR_STATE_B	(ovsel_monitor_state_b),
        //Register 0x0D (13)
        .OVVAL_COUNTER_STATE	(ovval_counter_state),
        .OVVAL_COUNTER_STATE_B	(ovval_counter_state_b),
        .OVSEL_COUNTER_STATE	(ovsel_counter_state),
        .OVSEL_COUNTER_STATE_B	(ovsel_counter_state_b),
        //Register 0x0E (14)
        .OVVAL_CTRL_ICHARGE_MUL	(ovval_ctrl_icharge_mul),
        .OVVAL_CTRL_ICHARGE_MUL_B	(ovval_ctrl_icharge_mul_b),
        .OVVAL_CTRLB_ICHARGE_DIV	(ovval_ctrlb_icharge_div),
        .OVVAL_CTRLB_ICHARGE_DIV_B	(ovval_ctrlb_icharge_div_b),
        .OVVAL_CTRL_ICHARGE_DIV	(ovval_ctrl_icharge_div),
        .OVVAL_CTRL_ICHARGE_DIV_B	(ovval_ctrl_icharge_div_b),
        .OVVAL_CTRLB_ICHARGE_MUL_LOWLEAK	(ovval_ctrlb_icharge_mul_lowleak),
        .OVVAL_CTRLB_ICHARGE_MUL_LOWLEAK_B	(ovval_ctrlb_icharge_mul_lowleak_b),
        .OVVAL_CTRLB_ICHARGE_DIV_LOWLEAK	(ovval_ctrlb_icharge_div_lowleak),
        .OVVAL_CTRLB_ICHARGE_DIV_LOWLEAK_B	(ovval_ctrlb_icharge_div_lowleak_b),
        //Register 0x0F (15)
        .OVSEL_CTRL_ICHARGE_MUL	(ovsel_ctrl_icharge_mul),
        .OVSEL_CTRL_ICHARGE_MUL_B	(ovsel_ctrl_icharge_mul_b),
        .OVSEL_CTRLB_ICHARGE_DIV	(ovsel_ctrlb_icharge_div),
        .OVSEL_CTRLB_ICHARGE_DIV_B	(ovsel_ctrlb_icharge_div_b),
        .OVSEL_CTRL_ICHARGE_DIV	(ovsel_ctrl_icharge_div),
        .OVSEL_CTRL_ICHARGE_DIV_B	(ovsel_ctrl_icharge_div_b),
        .OVSEL_CTRLB_ICHARGE_MUL_LOWLEAK	(ovsel_ctrlb_icharge_mul_lowleak),
        .OVSEL_CTRLB_ICHARGE_MUL_LOWLEAK_B	(ovsel_ctrlb_icharge_mul_lowleak_b),
        .OVSEL_CTRLB_ICHARGE_DIV_LOWLEAK	(ovsel_ctrlb_icharge_div_lowleak),
        .OVSEL_CTRLB_ICHARGE_DIV_LOWLEAK_B	(ovsel_ctrlb_icharge_div_lowleak_b),
        //Register 0x10 (16)
        //.DOUT_LOWER	(dout_lower),
        //Register 0x11 (17)
        //.DOUT_OVERFLOW	(dout_overflow),
        //.DOUT_UPPER	(dout_upper),
        //Register 0x12 (18)
        //.LDC_CONFIG	(ldc_config),
        //Register 0x13 (19)
        //.CTRL_ICHARGE_MUL	(ctrl_icharge_mul),
        //.CTRLB_ICHARGE_DIV	(ctrlb_icharge_div),
        //.CTRL_ICHARGE_DIV	(ctrl_icharge_div),
        //.CTRLB_ICHARGE_MUL_LOWLEAK	(ctrlb_icharge_mul_lowleak),
        //.CTRLB_ICHARGE_DIV_LOWLEAK	(ctrlb_icharge_div_lowleak),
        //Register 0x14 (20)
        //.MONITOR_OVERFLOW	(monitor_overflow),
        //.MONITOR	(monitor),
        //Register 0x15 (21)
        //.MONITOR_STATE	(monitor_state),
        //Register 0x16 (22)
        //.COUNTER_STATE	(counter_state),
        //Register 0x17 (23)
        .FDIV_CTRL_FREQ	(fdiv_ctrl_freq),
        .FDIV_RESETN	(fdiv_resetn),
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
        .TMR_RESETB	(tmr_resetb),
        .TMR_EN_OSC	(tmr_en_osc),
        .TMR_RESETB_DIV	(tmr_resetb_div),
        .TMR_RESETB_DCDC	(tmr_resetb_dcdc),
        .TMR_EN_SELF_CLK	(tmr_en_self_clk),
        //Register 0x21 (33)
        .TMR_SEL_CLK_DIV	(tmr_sel_clk_div),
        .TMR_SEL_CLK_OSC	(tmr_sel_clk_osc),
        .TMR_SELF_EN	(tmr_self_en),
        .TMR_IBIAS_REF	(tmr_ibias_ref),
        .TMR_CASCODE_BOOST	(tmr_cascode_boost),
        .TMR_SEL_CAP	(tmr_sel_cap),
        .TMR_SEL_DCAP	(tmr_sel_dcap),
        .TMR_EN_TUNE1	(tmr_en_tune1),
        .TMR_EN_TUNE2	(tmr_en_tune2),
        //Register 0x22 (34)
        .TMR_S	(tmr_s),
        .TMR_DIFF_CON	(tmr_diff_con),
        .TMR_POLY_CON	(tmr_poly_con),
        .TMR_EN_TUNE1_RES	(tmr_en_tune1_res),
        .TMR_EN_TUNE2_RES	(tmr_en_tune2_res),
        .TMR_SAMPLE_EN	(tmr_sample_en),
        .TMR_AFC	(tmr_afc),
        //Register 0x23 (35)
        //--- Empty Register
        //Register 0x24 (36)
        //--- Empty Register
        //Register 0x25 (37)
        //--- Empty Register
        //Register 0x26 (38)
        //--- Empty Register
        //Register 0x27 (39)
        //--- Empty Register
        //Register 0x28 (40)
        //--- Empty Register
        //Register 0x29 (41)
        //--- Empty Register
        //Register 0x2A (42)
        //--- Empty Register
        //Register 0x2B (43)
        //--- Empty Register
        //Register 0x2C (44)
        //--- Empty Register
        //Register 0x2D (45)
        //--- Empty Register
        //Register 0x2E (46)
        //--- Empty Register
        //Register 0x2F (47)
        //--- Empty Register
        //Register 0x30 (48)
        .WAKEUP_ON_PEND_REQ	(wakeup_on_pend_req),
        .MBUS_IGNORE_RX_FAIL	(mbus_ignore_rx_fail),
        .CLKGEN_DIV	(clkgen_div),
        .CLKGEN_RING	(clkgen_ring),
        //Register 0x31 (49)
        .LDC_IRQ_SHORT_ADDR	(ldc_irq_short_addr),
        .LDC_IRQ_REG_ADDR	(ldc_irq_reg_addr),
        //Register 0x32 (50)
        .LDC_IRQ_START_REG_ADDR	(ldc_irq_start_reg_addr),
        .LDC_IRQ_NUM_REG_1	(ldc_irq_num_reg_1),
        //Register 0x33 (51)
        //--- Empty Register
        //Register 0x34 (52)
        //--- Empty Register
        //Register 0x35 (53)
        //--- Empty Register
        //Register 0x36 (54)
        //--- Empty Register
        //Register 0x37 (55)
        //--- Empty Register
        //Register 0x38 (56)
        //--- Empty Register
        //Register 0x39 (57)
        //--- Empty Register
        //Register 0x3A (58)
        //--- Empty Register
        //Register 0x3B (59)
        //--- Empty Register
        //Register 0x3C (60)
        //--- Empty Register
        //Register 0x3D (61)
        //--- Empty Register
        //Register 0x3E (62)
        //--- Empty Register
        //Register 0x3F (63)
        //--- Empty Register
        //Register 0x40 (64)
        .WUP_ENABLE	(wup_enable),
        .WUP_LC_IRQ_EN	(wup_lc_irq_en),
        .WUP_AUTO_RESET	(wup_auto_reset),
        .WUP_ENABLE_CLK_SLP_OUT	(wup_enable_clk_slp_out),
        //Register 0x41 (65)
        .WUP_THRESHOLD_EXT	(wup_threshold_ext),
        //Register 0x42 (66)
        .WUP_THRESHOLD	(wup_threshold),
        //Register 0x43 (67)
        //.WUP_CNT_VALUE_EXT	(wup_cnt_value_ext),
        //Register 0x44 (68)
        //.WUP_CNT_VALUE	(wup_cnt_value),
        //Register 0x45 (69)
        .WUP_IRQ_PAYLOAD	(wup_irq_payload),
        //Register 0x46 (70)
        .WUP_IRQ_SHORT_ADDR	(wup_irq_short_addr),
        .WUP_IRQ_REG_ADDR	(wup_irq_reg_addr),
        //Register 0x47 (71)
        .WUP_IRQ_START_REG_ADDR	(wup_irq_start_reg_addr),
        .WUP_IRQ_NUM_REG_1	(wup_irq_num_reg_1)
       );
    //---- genRF End of Register File ----//

    //******************************
    // Taekwang Timer
    //******************************
    LNTv1A_TIMER lntv1a_timer_0 (
        //Power
        //.V1P2 (VDD_1P2)
        //.VSS  (VSS)

        // Output @ VDD_1P2
        .CLK            (clk_tmr),
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
        .POLY_CON       (tmr_poly_con),
        .EN_TUNE1_RES   (tmr_en_tune1_res),
        .EN_TUNE2_RES   (tmr_en_tune2_res),
        .SAMPLE_EN      (tmr_sample_en),
        .AFC            (tmr_afc)
    );

    //******************************
    // Level Conversion
    //******************************
    LNTv1A_LC lntv1a_lc_0 (
        .ISOLATE (reset_3p6),

        .CLK_FDIV_1P2                          (clk_fdiv),
        .CTRL_VOFS_CANCEL_1P2                  (ctrl_vofs_cancel),
        .DBE_ENABLE_1P2                        (dbe_enable),
        .LDC_ISOLATE_1P2                       (ldc_isolate),
        .LDC_PG_1P2                            (ldc_pg),
        .MODE_CONTINUOUS_1P2                   (mode_continuous),
        .OBSEN_AFEOUT_1P2                      (obsen_afeout),
        .OVSEL_CLK_1P2                         (ovsel_clk),
        .OVSEL_CONFIG_1P2                      (ovsel_config),
        .OVSEL_COUNTER_STATE_1P2               (ovsel_counter_state),
        .OVSEL_CTRLB_ICHARGE_DIV_1P2           (ovsel_ctrlb_icharge_div),
        .OVSEL_CTRLB_ICHARGE_DIV_LOWLEAK_1P2   (ovsel_ctrlb_icharge_div_lowleak),
        .OVSEL_CTRLB_ICHARGE_MUL_LOWLEAK_1P2   (ovsel_ctrlb_icharge_mul_lowleak),
        .OVSEL_CTRL_ICHARGE_DIV_1P2            (ovsel_ctrl_icharge_div),
        .OVSEL_CTRL_ICHARGE_MUL_1P2            (ovsel_ctrl_icharge_mul),
        .OVSEL_DIN_1P2                         (ovsel_din),
        .OVSEL_IBIAS_VBIAS_1P2                 (ovsel_ibias_vbias),
        .OVSEL_MONITOR_STATE_1P2               (ovsel_monitor_state),
        .OVSEL_VREF_COMP_1P2                   (ovsel_vref_comp),
        .OVSEL_VREF_PV_1P2                     (ovsel_vref_pv),
        .OVVAL_CLK_1P2                         (ovval_clk),
        .OVVAL_CTRLB_ICHARGE_DIV_LOWLEAK_1P2   (ovval_ctrlb_icharge_div_lowleak),
        .OVVAL_CTRLB_ICHARGE_MUL_LOWLEAK_1P2   (ovval_ctrlb_icharge_mul_lowleak),
        .OVVAL_DIN_1P2                         (ovval_din),
        .RESETN_DBE_1P2                        (resetn_dbe),
        .RESET_AFE_1P2                         (reset_afe),
        .LDC_CLR_IRQ_1P2                       (lc2ldc_clr_irq),
        .CTRL_VREF_COMP_V_1P2                  (ctrl_vref_comp_v),
        .CTRL_VREF_PV_V_1P2                    (ctrl_vref_pv_v),
        .OBSSEL_ABUF_1P2                       (obssel_abuf),
        .CTRL_CAPSIZE_1P2                      (ctrl_capsize),
        .CTRL_ICOMP_1P2                        (ctrl_icomp),
        .OVVAL_COUNTER_STATE_1P2               (ovval_counter_state),
        .OVVAL_CTRLB_ICHARGE_DIV_1P2           (ovval_ctrlb_icharge_div),
        .OVVAL_MONITOR_STATE_1P2               (ovval_monitor_state),
        .CTRL_IBIAS_I_1P2                      (ctrl_ibias_i),
        .CTRL_IBIAS_VBIAS_1P2                  (ctrl_ibias_vbias),
        .OVVAL_CONFIG_1P2                      (ovval_config),
        .CTRLB_VREF_COMP_I_1P2                 (ctrlb_vref_comp_i),
        .CTRLB_VREF_PV_I_1P2                   (ctrlb_vref_pv_i),
        .OVVAL_CTRL_ICHARGE_DIV_1P2            (ovval_ctrl_icharge_div),
        .OVVAL_CTRL_ICHARGE_MUL_1P2            (ovval_ctrl_icharge_mul),
        .THRESHOLD_HIGH_1P2                    (threshold_high),
        .THRESHOLD_LOW_1P2                     (threshold_low),
        .TIME_MONITORING_1P2                   (time_monitoring),
        .TIME_MONITOR_HOLD_1P2                 (time_monitor_hold),
        .TIME_COUNTING_1P2                     (time_counting),
        .CLK_FDIV_1P2_B                        (clk_fdiv_b),
        .CTRL_VOFS_CANCEL_1P2_B                (ctrl_vofs_cancel_b),
        .DBE_ENABLE_1P2_B                      (dbe_enable_b),
        .LDC_ISOLATE_1P2_B                     (ldc_isolate_b),
        .LDC_PG_1P2_B                          (ldc_pg_b),
        .MODE_CONTINUOUS_1P2_B                 (mode_continuous_b),
        .OBSEN_AFEOUT_1P2_B                    (obsen_afeout_b),
        .OVSEL_CLK_1P2_B                       (ovsel_clk_b),
        .OVSEL_CONFIG_1P2_B                    (ovsel_config_b),
        .OVSEL_COUNTER_STATE_1P2_B             (ovsel_counter_state_b),
        .OVSEL_CTRLB_ICHARGE_DIV_1P2_B         (ovsel_ctrlb_icharge_div_b),
        .OVSEL_CTRLB_ICHARGE_DIV_LOWLEAK_1P2_B (ovsel_ctrlb_icharge_div_lowleak_b),
        .OVSEL_CTRLB_ICHARGE_MUL_LOWLEAK_1P2_B (ovsel_ctrlb_icharge_mul_lowleak_b),
        .OVSEL_CTRL_ICHARGE_DIV_1P2_B          (ovsel_ctrl_icharge_div_b),
        .OVSEL_CTRL_ICHARGE_MUL_1P2_B          (ovsel_ctrl_icharge_mul_b),
        .OVSEL_DIN_1P2_B                       (ovsel_din_b),
        .OVSEL_IBIAS_VBIAS_1P2_B               (ovsel_ibias_vbias_b),
        .OVSEL_MONITOR_STATE_1P2_B             (ovsel_monitor_state_b),
        .OVSEL_VREF_COMP_1P2_B                 (ovsel_vref_comp_b),
        .OVSEL_VREF_PV_1P2_B                   (ovsel_vref_pv_b),
        .OVVAL_CLK_1P2_B                       (ovval_clk_b),
        .OVVAL_CTRLB_ICHARGE_DIV_LOWLEAK_1P2_B (ovval_ctrlb_icharge_div_lowleak_b),
        .OVVAL_CTRLB_ICHARGE_MUL_LOWLEAK_1P2_B (ovval_ctrlb_icharge_mul_lowleak_b),
        .OVVAL_DIN_1P2_B                       (ovval_din_b),
        .RESETN_DBE_1P2_B                      (resetn_dbe_b),
        .RESET_AFE_1P2_B                       (reset_afe_b),
        .LDC_CLR_IRQ_1P2_B                     (lc2ldc_clr_irq_b),
        .CTRL_VREF_COMP_V_1P2_B                (ctrl_vref_comp_v_b),
        .CTRL_VREF_PV_V_1P2_B                  (ctrl_vref_pv_v_b),
        .OBSSEL_ABUF_1P2_B                     (obssel_abuf_b),
        .CTRL_CAPSIZE_1P2_B                    (ctrl_capsize_b),
        .CTRL_ICOMP_1P2_B                      (ctrl_icomp_b),
        .OVVAL_COUNTER_STATE_1P2_B             (ovval_counter_state_b),
        .OVVAL_CTRLB_ICHARGE_DIV_1P2_B         (ovval_ctrlb_icharge_div_b),
        .OVVAL_MONITOR_STATE_1P2_B             (ovval_monitor_state_b),
        .CTRL_IBIAS_I_1P2_B                    (ctrl_ibias_i_b),
        .CTRL_IBIAS_VBIAS_1P2_B                (ctrl_ibias_vbias_b),
        .OVVAL_CONFIG_1P2_B                    (ovval_config_b),
        .CTRLB_VREF_COMP_I_1P2_B               (ctrlb_vref_comp_i_b),
        .CTRLB_VREF_PV_I_1P2_B                 (ctrlb_vref_pv_i_b),
        .OVVAL_CTRL_ICHARGE_DIV_1P2_B          (ovval_ctrl_icharge_div_b),
        .OVVAL_CTRL_ICHARGE_MUL_1P2_B          (ovval_ctrl_icharge_mul_b),
        .THRESHOLD_HIGH_1P2_B                  (threshold_high_b),
        .THRESHOLD_LOW_1P2_B                   (threshold_low_b),
        .TIME_MONITORING_1P2_B                 (time_monitoring_b),
        .TIME_MONITOR_HOLD_1P2_B               (time_monitor_hold_b),
        .TIME_COUNTING_1P2_B                   (time_counting_b),
        .CLK_FDIV                              (clk_fdiv_3p6),
        .CTRL_VOFS_CANCEL                      (ctrl_vofs_cancel_3p6),
        .DBE_ENABLE                            (dbe_enable_3p6),
        .LDC_ISOLATE                           (ldc_isolate_3p6),
        .LDC_PG                                (ldc_pg_3p6),
        .MODE_CONTINUOUS                       (mode_continuous_3p6),
        .OBSEN_AFEOUT                          (obsen_afeout_3p6),
        .OVSEL_CLK                             (ovsel_clk_3p6),
        .OVSEL_CONFIG                          (ovsel_config_3p6),
        .OVSEL_COUNTER_STATE                   (ovsel_counter_state_3p6),
        .OVSEL_CTRLB_ICHARGE_DIV               (ovsel_ctrlb_icharge_div_3p6),
        .OVSEL_CTRLB_ICHARGE_DIV_LOWLEAK       (ovsel_ctrlb_icharge_div_lowleak_3p6),
        .OVSEL_CTRLB_ICHARGE_MUL_LOWLEAK       (ovsel_ctrlb_icharge_mul_lowleak_3p6),
        .OVSEL_CTRL_ICHARGE_DIV                (ovsel_ctrl_icharge_div_3p6),
        .OVSEL_CTRL_ICHARGE_MUL                (ovsel_ctrl_icharge_mul_3p6),
        .OVSEL_DIN                             (ovsel_din_3p6),
        .OVSEL_IBIAS_VBIAS                     (ovsel_ibias_vbias_3p6),
        .OVSEL_MONITOR_STATE                   (ovsel_monitor_state_3p6),
        .OVSEL_VREF_COMP                       (ovsel_vref_comp_3p6),
        .OVSEL_VREF_PV                         (ovsel_vref_pv_3p6),
        .OVVAL_CLK                             (ovval_clk_3p6),
        .OVVAL_CTRLB_ICHARGE_DIV_LOWLEAK       (ovval_ctrlb_icharge_div_lowleak_3p6),
        .OVVAL_CTRLB_ICHARGE_MUL_LOWLEAK       (ovval_ctrlb_icharge_mul_lowleak_3p6),
        .OVVAL_DIN                             (ovval_din_3p6),
        .RESETN_DBE                            (resetn_dbe_3p6),
        .RESET_AFE                             (reset_afe_3p6),
        .LDC_CLR_IRQ                           (lc2ldc_clr_irq_3p6),
        .CTRL_VREF_COMP_V                      (ctrl_vref_comp_v_3p6),
        .CTRL_VREF_PV_V                        (ctrl_vref_pv_v_3p6),
        .OBSSEL_ABUF                           (obssel_abuf_3p6),
        .CTRL_CAPSIZE                          (ctrl_capsize_3p6),
        .CTRL_ICOMP                            (ctrl_icomp_3p6),
        .OVVAL_COUNTER_STATE                   (ovval_counter_state_3p6),
        .OVVAL_CTRLB_ICHARGE_DIV               (ovval_ctrlb_icharge_div_3p6),
        .OVVAL_MONITOR_STATE                   (ovval_monitor_state_3p6),
        .CTRL_IBIAS_I                          (ctrl_ibias_i_3p6),
        .CTRL_IBIAS_VBIAS                      (ctrl_ibias_vbias_3p6),
        .OVVAL_CONFIG                          (ovval_config_3p6),
        .CTRLB_VREF_COMP_I                     (ctrlb_vref_comp_i_3p6),
        .CTRLB_VREF_PV_I                       (ctrlb_vref_pv_i_3p6),
        .OVVAL_CTRL_ICHARGE_DIV                (ovval_ctrl_icharge_div_3p6),
        .OVVAL_CTRL_ICHARGE_MUL                (ovval_ctrl_icharge_mul_3p6),
        .THRESHOLD_HIGH                        (threshold_high_3p6),
        .THRESHOLD_LOW                         (threshold_low_3p6),
        .TIME_MONITORING                       (time_monitoring_3p6),
        .TIME_MONITOR_HOLD                     (time_monitor_hold_3p6),
        .TIME_COUNTING                         (time_counting_3p6)
    );

    //******************************
    // Frequency Divider
    //******************************
    LNTv1A_FDIV lntv1a_fdiv_0 (
        //Power
        //VDD_1P2
        .CLK    (clk_tmr),
        .RESETN (fdiv_resetn),
        .CTRL_FREQ(fdiv_ctrl_freq),
        //Output
        .OUT    (clk_fdiv),
        .OUT_B  (clk_fdiv_b)
    );

    //******************************
    // Light Detection (Custom Block)
    //******************************
    LNTv1A_LDC lntv1a_ldc_0 (
        //Power
        //VDD_3P6, VDD_TEST (ideal)
	    //Input - LNTv1A_FDIV_1KHZ
	    .CLK        (clk_fdiv_3p6),

	    //Input - Register File
	    .PG                         (ldc_pg_3p6),
	    .RESETN_DBE                 (resetn_dbe_3p6),
	    .RESET_AFE                  (reset_afe_3p6),
	    .ENABLE                     (dbe_enable_3p6),
	    .MODE_CONTINUOUS            (mode_continuous_3p6),
	    .TIME_COUNTING              (time_counting_3p6),
	    .TIME_MONITORING            (time_monitoring_3p6),
	    .TIME_MONITOR_HOLD          (time_monitor_hold_3p6),
	    .THRESHOLD_HIGH             (threshold_high_3p6),
	    .THRESHOLD_LOW              (threshold_low_3p6),
	    .OVSEL_CLK                  (ovsel_clk_3p6),
	    .OVVAL_CLK                  (ovval_clk_3p6),
	    .OVSEL_DIN                  (ovsel_din_3p6),
	    .OVVAL_DIN                  (ovval_din_3p6),
	    .OVSEL_COUNTER_STATE        (ovsel_counter_state_3p6),
	    .OVVAL_COUNTER_STATE        (ovval_counter_state_3p6),
	    .OVSEL_MONITOR_STATE        (ovsel_monitor_state_3p6),
	    .OVVAL_MONITOR_STATE        (ovval_monitor_state_3p6),
	    .OVSEL_CONFIG               (ovsel_config_3p6),
	    .OVVAL_CONFIG               (ovval_config_3p6),
	    .OVSEL_CTRL_ICHARGE_DIV     (ovsel_ctrl_icharge_div_3p6),
	    .OVVAL_CTRL_ICHARGE_DIV     (ovval_ctrl_icharge_div_3p6),
	    .OVSEL_CTRLB_ICHARGE_DIV    (ovsel_ctrlb_icharge_div_3p6),
	    .OVVAL_CTRLB_ICHARGE_DIV    (ovval_ctrlb_icharge_div_3p6),
	    .OVSEL_CTRL_ICHARGE_MUL     (ovsel_ctrl_icharge_mul_3p6),
	    .OVVAL_CTRL_ICHARGE_MUL     (ovval_ctrl_icharge_mul_3p6),
	    .OVSEL_CTRLB_ICHARGE_DIV_LOWLEAK    (ovsel_ctrlb_icharge_div_lowleak_3p6),
	    .OVVAL_CTRLB_ICHARGE_DIV_LOWLEAK    (ovval_ctrlb_icharge_div_lowleak_3p6),
	    .OVSEL_CTRLB_ICHARGE_MUL_LOWLEAK    (ovsel_ctrlb_icharge_mul_lowleak_3p6),
	    .OVVAL_CTRLB_ICHARGE_MUL_LOWLEAK    (ovval_ctrlb_icharge_mul_lowleak_3p6),
	    .CTRL_CAPSIZE               (ctrl_capsize_3p6),
	    .CTRL_IBIAS_I               (ctrl_ibias_i_3p6),
	    .CTRL_IBIAS_VBIAS           (ctrl_ibias_vbias_3p6),
	    .CTRL_ICOMP                 (ctrl_icomp_3p6),
	    .CTRL_VREF_COMP_V           (ctrl_vref_comp_v_3p6),
	    .CTRL_VREF_PV_V             (ctrl_vref_pv_v_3p6),
	    .CTRLB_VREF_COMP_I          (ctrlb_vref_comp_i_3p6),
	    .CTRLB_VREF_PV_I            (ctrlb_vref_pv_i_3p6),
	    .CTRL_VOFS_CANCEL           (ctrl_vofs_cancel_3p6),
	    .OBSSEL_ABUF                (obssel_abuf_3p6),
	    .OBSEN_AFEOUT               (obsen_afeout_3p6),
	    .OVSEL_IBIAS_VBIAS          (ovsel_ibias_vbias_3p6),
	    .OVSEL_VREF_COMP            (ovsel_vref_comp_3p6),
	    .OVSEL_VREF_PV              (ovsel_vref_pv_3p6),

	    //Outputs - Directly Send MBus MSG 
	    .DOUT       ({dout_upper_uniso, dout_lower_uniso}),

        //Layer Ctrl Clear Interrupt
        .CLR_IRQ    (lc2ldc_clr_irq_3p6),
	    //Outputs - Directly Send MBus MSG  & Also to Register File
	    .DONE       (ldc2lc_irq_uniso), 

	    //Outputs - LDCv1A_AFE & Register File
	    .CTRL_ICHARGE_DIV           (ctrl_icharge_div_uniso),
	    .CTRLB_ICHARGE_DIV          (ctrlb_icharge_div_uniso),
	    .CTRL_ICHARGE_MUL           (ctrl_icharge_mul_uniso),
	    .CTRLB_ICHARGE_DIV_LOWLEAK  (ctrlb_icharge_div_lowleak_uniso),
	    .CTRLB_ICHARGE_MUL_LOWLEAK  (ctrlb_icharge_mul_lowleak_uniso),

	    //Outputs - Register File
	    .MONITOR            (monitor_uniso),
	    .DOUT_OVERFLOW      (dout_overflow_uniso),
	    .MONITOR_OVERFLOW   (monitor_overflow_uniso),
	    .COUNTER_STATE      (counter_state_uniso),
	    .MONITOR_STATE      (monitor_state_uniso),
	    .CONFIG             (ldc_config_uniso),

	    //PADs for PV cells (Main PAD line)
	    .PV_HIGH            (PV_HIGH),
	    .PV_LOW             (PV_LOW),

        // Pads included in AFE
	    .PAD_OVVAL_ABUF         (PAD_OVVAL_ABUF),
	    .PAD_OVVAL_IBIAS_VBIAS  (PAD_OVVAL_IBIAS_VBIAS),
	    .PAD_OVVAL_VREF_COMP    (PAD_OVVAL_VREF_COMP),
	    .PAD_OVVAL_VREF_PV      (PAD_OVVAL_VREF_PV),
	    .PAD_OBS_ABUF           (PAD_OBS_ABUF),
	    .PAD_OBS_IBIAS          (PAD_OBS_IBIAS),
	    .PAD_OBS_AFEOUT         (PAD_OBS_AFEOUT)
        );
 
    //******************************
    // Wakeup Timer
    //******************************
    LNTv1A_WUP_TIMER lntv1a_wup_timer_0 (
        //Power
        //.VDD (VDD_1P2)
        //.VSS (VSS)

        //Inputs
        .RESETn         (resetn),
        .ENABLE         (wup_enable),
        .CLK            (clk_tmr),
        .THRESHOLD      (wup_threshold),
        .THRESHOLD_EXT  (wup_threshold_ext),
        .CLR_IRQ        (lc2wup_clr_irq),
        .LC_IRQ_EN      (wup_lc_irq_en),
        .AUTO_RESET     (wup_auto_reset),
        .EN_CLK_SLP_OUT (wup_enable_clk_slp_out),

        .MBC_SLEEP      (mbc_sleep),
        .MBC_ISOLATE    (mbc_isolate),
        .MBC_RESET      (mbc_reset),
        .LC_ISOLATE     (lc_isolate),

        .IRQ_FROM_LDC   (ldc2lc_irq),
        .WAKEUP_WHEN_LDC_DONE   (wakeup_when_done),

        //Output
        .CNT_VALUE      (wup_cnt_value),
        .CNT_VALUE_EXT  (wup_cnt_value_ext),
        .IRQ            (wup2lc_irq),
        .WAKEUP_REQ     (wakeup_req),
        .CLK_SLP        (clk_slp)   // Pad output
    );

endmodule // LNTv1A
