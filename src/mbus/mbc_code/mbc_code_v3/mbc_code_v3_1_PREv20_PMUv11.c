/******************************************************************************************
 * Author:      Roger Hsiao
 * Description: Monarch butterfly challenge code
 *                                          - PREv20 / PMUv11 / SNTv4 / FLPv3S / MRRv10
 ******************************************************************************************
 * v1: draft version; not tested on chip
 *
 * v3: first deployment in mexico; not using FLP
 * v3.1: compact code
 *
 * PMUv9 version: with PMUv11
 ******************************************************************************************/

#include "../include/PREv20.h"
#include "../include/PREv20_RF.h"
#include "../include/SNTv4_RF.h"
#include "../include/PMUv11_RF.h"
#include "../include/LNTv1A_RF.h"
#include "../include/MRRv10_RF.h"
#include "../include/mbus.h"

#define PRE_ADDR 0x1
#define MRR_ADDR 0x2
#define LNT_ADDR 0x3
#define SNT_ADDR 0x4
#define PMU_ADDR 0x5
#define MEM_ADDR 0x6
#define ENUMID 0xDEADBEEF

#define MBUS_DELAY 100  // Amount of delay between seccessive messages; 100: 6-7ms
#define TIMER32_val 0x20000  // 0x20000 about 1 sec with Y5 run default clock (PRCv17)

// SNT states
#define SNT_IDLE        0x0
#define SNT_TEMP_LDO    0x1
#define SNT_TEMP_START  0x2
#define SNT_TEMP_READ   0x3
#define SNT_SET_PMU	0x4

/**********************************************
 * Global variables
 **********************************************
 * "static" limits the variables to this file, giving the compiler more freedom
 * "volatile" should only be used for mmio to ensure memory storage
 */
volatile uint32_t enumerated;
volatile uint32_t wakeup_data;
volatile uint8_t wfi_timeout_flag;

volatile uint16_t xo_period;
volatile uint16_t xo_interval[4];
volatile uint32_t xo_sys_time;
volatile uint32_t xo_day_time;
volatile uint32_t xo_day_start;
volatile uint32_t xo_day_end;

volatile uint32_t snt_const_a;
volatile uint32_t snt_const_b;
volatile uint32_t snt_sys_temp;
volatile uint8_t snt_state;
volatile uint8_t temp_data_valid;

volatile uint16_t lnt_upper_thresh[3];
volatile uint16_t lnt_lower_thresh[3];

volatile uint32_t mem_addr;
volatile uint32_t mem_write_data;

volatile uint32_t mrr_signal_period;
volatile uint32_t mrr_data_period;
volatile uint16_t mrr_temp_thresh;
volatile uint32_t mrr_volt_thresh;

volatile uint32_t pmu_setting_val;
volatile uint32_t pmu_cur_active_setting;
volatile uint32_t pmu_cur_sleep_setting;
volatile uint32_t pmu_temp_thresh[4];
volatile uint32_t pmu_active_settings[5];
volatile uint32_t pmu_sleep_settings[5];
volatile uint32_t pmu_radio_settings[5];

// default register values
volatile prev20_r19_t prev20_r19 = PREv20_R19_DEFAULT;

volatile sntv4_r00_t sntv4_r00 = SNTv4_R00_DEFAULT;
volatile sntv4_r01_t sntv4_r01 = SNTv4_R01_DEFAULT;
volatile sntv4_r07_t sntv4_r07 = SNTv4_R07_DEFAULT;

// Message data structures
typedef union header{
    struct{
        unsigned timestamp : 20;
        unsigned len : 8;
        unsigned interval_type : 2;
    };
    uint32_t as_int;
} header_t;

typedef union base_data{
    struct{
        uint16_t base_light_data;
        uint16_t base_temp_data;
    };
    uint32_t as_int;
} base_data_t;

/**********************************************
 * XO Functions
 **********************************************/

// write to XO driver 0x19
void xo_ctrl(uint8_t xo_pulse_sel,
	     uint8_t xo_delay_en,
	     uint8_t xo_drv_start_up,
	     uint8_t xo_drv_core,
	     uint8_t xo_rp_low,
	     uint8_t xo_rp_media,
	     uint8_t xo_rp_mvt,
	     uint8_t xo_rp_svt,
	     uint8_t xo_scn_clk_sel,
	     uint8_t xo_scn_enb) {
    *REG_XO_CONF1 = ((xo_pulse_sel     << 11) |
                     (xo_delay_en      << 8)  |
                     (xo_drv_start_up  << 7)  |
                     (xo_drv_core      << 6)  |
                     (xo_rp_low        << 5)  |
                     (xo_rp_media      << 4)  |
                     (xo_rp_mvt        << 3)  |
                     (xo_rp_svt        << 2)  |
                     (xo_scn_clk_sel   << 1)  |
                     (xo_scn_enb       << 0));
    mbus_write_message32(0xA1, *REG_XO_CONF1);
}

void xo_init( void ) {
    // Parasitic capacitance tuning (6 bits for each; each 1 adds 1.8pF)
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
    prev20_r19.XO_DRV_START_UP  = 0x0;
    prev20_r19.XO_DRV_CORE      = 0x0;
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
    prev20_r19.XO_SCN_ENB       = 0x1;

    // TODO: check if need 32.768kHz clock
    prev20_r19.XO_EN_DIV        = 0x1; // divider enable (also enables CLK_OUT)
    prev20_r19.XO_S             = 0x0; // (not used) division ration for 16kHz out
    prev20_r19.XO_SEL_CP_DIV    = 0x0; // 1: 0.3v-generation charge-pump uses divided clock
    prev20_r19.XO_EN_OUT        = 0x1; // xo output enabled;
    				       // Note: I think this means output to XOT
    // Pseudo-resistor selection
    prev20_r19.XO_RP_LOW        = 0x0;
    prev20_r19.XO_RP_MEDIA      = 0x1;
    prev20_r19.XO_RP_MVT        = 0x0;
    prev20_r19.XO_RP_SVT        = 0x0;

    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(100); // >= 1ms

    prev20_r19.XO_ISOLATE = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(100); // >= 1ms

    prev20_r19.XO_DRV_START_UP = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000); // >= 1s

    prev20_r19.XO_SCN_CLK_SEL = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(2000); // >= 300us

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
    prev20_r19.XO_SCN_ENB     = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000);  // >= 1s

    prev20_r19.XO_DRV_START_UP = 0x0;
    prev20_r19.XO_DRV_CORE     = 0x1;
    prev20_r19.XO_SCN_CLK_SEL  = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);

    enable_xo_timer();
    // start_xo_cout();
    
    // BREAKPOint 0x03
    mbus_write_message32(0xBA, 0x03);

}

/*
// TODO: figure out if this is needed
void xo_turn_off( void ) {
    prev20_r19.XO_DRV_CORE = 0x0;
    prev20_r19.XO_SCN_ENB  = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
}

// Sleep xo driver to save power
void xo_sleep( void ) {
    prev20_r19.XO_SLEEP    = 0x0;
    prev20_r19.XO_ISOLATE  = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
}
*/

/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/

static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
    sntv4_r01.TSNS_EN_IRQ = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_reset() {
    sntv4_r01.TSNS_RESETn = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void snt_ldo_vref_on() {
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
    sntv4_r00.LDO_EN_IREF = 0;
    sntv4_r00.LDO_EN_LDO  = 0;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
    // Un-powergate analog block
    sntv4_r01.TSNS_EN_SENSOR_LDO = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    delay(MBUS_DELAY);

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static uint32_t process_temp(uint32_t temp_code){
    return 0;
}

static void operation_temp_run() {
    uint32_t temp_code;
    if(snt_state == SNT_IDLE) {
        temp_data_valid = 0;

        // Turn on snt ldo vref; requires ~30 ms to settle
        // TODo: figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);

        snt_state = SNT_TEMP_LDO;

    }
    else if(snt_state == SNT_TEMP_LDO) {
        // Power on snt ldo
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);

        snt_state = SNT_TEMP_START;
    }
    else if(snt_state == SNT_TEMP_START) {
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
        config_timer32(TIMER32_val, 1, 0, 0); // 1/10 of MBUS watchdog timer default
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or TIMER32
	WFI();

        // Turn off timer32
        *TIMER32_GO = 0;

        snt_state = SNT_TEMP_READ;
    }
    else if(snt_state == SNT_TEMP_READ) {
        if(wfi_timeout_flag) {
            // if timeout, measure again
            mbus_write_message32(0xFA, 0xFAFAFAFA);
	    snt_state = SNT_TEMP_START;
        }
        else {
            temp_code = *REG0;
            
            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

	    mbus_write_message32(0xDD, 0xBB);
            snt_state = SNT_SET_PMU;
        }
    }
    else if(snt_state == SNT_SET_PMU) {
        temp_data_valid = 1;
        snt_sys_temp = process_temp(temp_code);
	snt_state = SNT_IDLE;
    }
}

/**********************************************
 * Light functions (LNTv1A)
 **********************************************/

inline static void lnt_init() {
    // Config Register A
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1

    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);

    // TIMER CAP_TUNE  
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4

    //lntv1a_r21.TMR_SEL_CAP = 0x8; // Default : 8'h8
    //lntv1a_r21.TMR_SEL_DCAP = 0x4; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);

    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);

    // Change ABUF Input
    lntv1a_r07.OBSSEL_ABUF = 0x2; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x07,lntv1a_r07.as_int);

    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);

    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);

    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);

    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    delay(2000); 

    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    delay(10); 

    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(100000); 

    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    delay(100);

    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
    delay(MBUS_DELAY*10);

    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7, Chosen : 0x7
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8, chosen : 0x2
    //lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x8
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    delay(MBUS_DELAY*10);

    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    delay(MBUS_DELAY*10);

    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    delay(MBUS_DELAY*10);

    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0x020; // Default : 0x258, It was 0x20
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    delay(MBUS_DELAY*10);

    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);

    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Default : 0x1
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
}

/**********************************************
 * CRC16 Encoding
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16(uint32_t data2, uint32_t data1, uint32_t data0)
{
    // intialization
    uint32_t i;

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    data2 = (data2 << CRC_LEN) + (data1 >> CRC_LEN);
    data1 = (data1 << CRC_LEN) + (data0 >> CRC_LEN);
    data0 = data0 << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
            MSB = 0xffff;
        else
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift))
            + (input_bit^(remainder > 0x7fff));
    }

    data0 = data0 + remainder;

    static uint32_t msg_out[3];
    msg_out[0] = data2;
    msg_out[1] = data1;
    msg_out[2] = data0;

    return msg_out;    
}

/**********************************************
 * MRR Functions (MRRv10)
 **********************************************/

static void mrr_ldo_vref_on(){
    mrrv10_r04.LDO_EN_VREF    = 1;
    mbus_remote_register_write(MRR_ADDR,0x4,mrrv10_r04.as_int);
}

static void mrr_ldo_power_on(){
    mrrv10_r04.LDO_EN_IREF    = 1;
    mrrv10_r04.LDO_EN_LDO    = 1;
    mbus_remote_register_write(MRR_ADDR,0x4,mrrv10_r04.as_int);
}
static void mrr_ldo_power_off(){
    mrrv10_r04.LDO_EN_VREF    = 0;
    mrrv10_r04.LDO_EN_IREF    = 0;
    mrrv10_r04.LDO_EN_LDO    = 0;
    mbus_remote_register_write(MRR_ADDR,0x4,mrrv10_r04.as_int);
}

static void radio_power_on(){
    // Turn off PMU ADC
    //pmu_adc_disable();

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // New for MRRv10
    mrr_ldo_vref_on();

    // Turn off Current Limter Briefly
    mrrv10_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Set decap to parallel
    mrrv10_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv10_r03.as_int);
    mrrv10_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv10_r03.as_int);
    delay(MBUS_DELAY);

    // Set decap to series
    mrrv10_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv10_r03.as_int);
    mrrv10_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv10_r03.as_int);
    delay(MBUS_DELAY);

    // Current Limter set-up 
    mrrv10_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    radio_on = 1;

    // New for MRRv10
    mrr_ldo_power_on();

    // Turn on Current Limter
    mrrv10_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Release timer power-gate
    mrrv10_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
    //mrrv10_r04.RO_EN_RO_LDO = 1;  //Use LDO for TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv10_r04.as_int);
    delay(MBUS_DELAY);

    // Turn on timer
    mrrv10_r04.RO_RESET = 0;  //Release Reset TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv10_r04.as_int);
    delay(MBUS_DELAY);

    mrrv10_r04.RO_EN_CLK = 1; //Enable CLK TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv10_r04.as_int);
    delay(MBUS_DELAY);

    mrrv10_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv10_r04.as_int);

    // Release FSM Sleep
    mrrv10_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv10_r11.as_int);
    delay(MBUS_DELAY*5); // Freq stab

}

static void radio_power_off(){
    // Need to restore sleep pmu clock

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv10_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Current Limter set-up 
    mrrv10_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Turn on Current Limter
    mrrv10_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Turn off everything
    mrrv10_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv10_r03.as_int);

    mrrv10_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv10_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv10_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv10_r11.as_int);

    mrrv10_r04.RO_RESET = 1;  //Release Reset TIMER
    mrrv10_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv10_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv10_r04.as_int);

    mrr_ldo_power_off();

    // Enable timer power-gate
    mrrv10_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
    //mrrv10_r04.RO_EN_RO_LDO = 0;  //Use LDO for TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv10_r04.as_int);

    radio_on = 0;
    radio_ready = 0;

}

static void mrr_configure_pulse_width_long(){

    //mrrv10_r12.MRR_RAD_FSM_TX_PW_LEN = 24; //100us PW
    //mrrv10_r13.MRR_RAD_FSM_TX_C_LEN = 100; // (PW_LEN+1):C_LEN=1:32
    //mrrv10_r12.MRR_RAD_FSM_TX_PS_LEN = 49; // PW=PS   

    mrrv10_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //100us PW
    mrrv10_r13.MRR_RAD_FSM_TX_C_LEN = 1105; // (PW_LEN+1):C_LEN=1:32
    mrrv10_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv10_r12.as_int);
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv10_r13.as_int);
}

/*
   static void mrr_configure_pulse_width_long_2(){

   mrrv10_r12.MRR_RAD_FSM_TX_PW_LEN = 19; //80us PW
   mrrv10_r13.MRR_RAD_FSM_TX_C_LEN = 100; // (PW_LEN+1):C_LEN=1:32
   mrrv10_r12.MRR_RAD_FSM_TX_PS_LEN = 39; // PW=PS   

   mbus_remote_register_write(MRR_ADDR,0x12,mrrv10_r12.as_int);
   mbus_remote_register_write(MRR_ADDR,0x13,mrrv10_r13.as_int);
   }

   static void mrr_configure_pulse_width_long_3(){

   mrrv10_r12.MRR_RAD_FSM_TX_PW_LEN = 9; //40us PW
   mrrv10_r13.MRR_RAD_FSM_TX_C_LEN = 100; // (PW_LEN+1):C_LEN=1:32
   mrrv10_r12.MRR_RAD_FSM_TX_PS_LEN = 19; // PW=PS   

   mbus_remote_register_write(MRR_ADDR,0x12,mrrv10_r12.as_int);
   mbus_remote_register_write(MRR_ADDR,0x13,mrrv10_r13.as_int);
   }

   static void mrr_configure_pulse_width_short(){

   mrrv10_r12.MRR_RAD_FSM_TX_PW_LEN = 0; //4us PW
   mrrv10_r13.MRR_RAD_FSM_TX_C_LEN = 32; // (PW_LEN+1):C_LEN=1:32
   mrrv10_r12.MRR_RAD_FSM_TX_PS_LEN = 1; // PW=PS guard interval betwen 0 and 1 pulse

   mbus_remote_register_write(MRR_ADDR,0x12,mrrv10_r12.as_int);
   mbus_remote_register_write(MRR_ADDR,0x13,mrrv10_r13.as_int);
   }
   */


static void send_radio_data_mrr_sub1(){

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv10_r00.MRR_CL_EN = 1;
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Fire off data
    mrrv10_r11.MRR_RAD_FSM_EN = 1;  //Start BB
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv10_r11.as_int);

    // Wait for radio response
    WFI();
    mbus_write_message32(0xCC, 0x89ABCDEF);
    stop_timer32_timeout_check(0x3);

    // Turn off Current Limter
    mrrv10_r00.MRR_CL_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    mrrv10_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv10_r11.as_int);
}

static void send_radio_data_mrr(uint32_t last_packet, uint8_t radio_packet_prefix, uint32_t radio_data){
    // Sends 192 bit packet, of which 96b is actual data
    // MRR REG_9: reserved for header
    // MRR REG_A: reserved for header
    // MRR REG_B: reserved for header
    // MRR REG_C: reserved for header
    // MRR REG_D: DATA[23:0]
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

    // CRC16 Encoding 
    uint32_t* output_data;
    //output_data = crcEnc16(((radio_packet_count & 0xFF)<<8) | radio_packet_prefix, (radio_data_2 <<16) | ((radio_data_1 & 0xFFFFFF) >>8), (radio_data_1 << 24) | (radio_data_0 & 0xFFFFFF));
    output_data = crcEnc16(((read_data_batadc & 0xFF)<<8) | ((radio_packet_prefix & 0xF)<<4) | ((radio_packet_count>>16)&0xF), ((radio_packet_count & 0xFFFF)<<16) | (*REG_CHIP_ID & 0xFFFF), radio_data);

    mbus_write_message32(0xBB, radio_data);
    mbus_write_message32(0xBB, radio_packet_prefix);

    // mbus_remote_register_write(MRR_ADDR,0xD,radio_data & 0xFFFFFF);
    mbus_remote_register_write(MRR_ADDR,0xD,((output_data[2] & 0xFFFF)/*CRC16*/<<8)|(read_data_batadc&0xFF));
    mbus_remote_register_write(MRR_ADDR,0xE,(*REG_CHIP_ID<<8)|(radio_data>>24));
    mbus_remote_register_write(MRR_ADDR,0xF,(radio_packet_prefix<<20)|(radio_packet_count&0xFFFFF));
    // mbus_remote_register_write(MRR_ADDR,0x10,((output_data[2] & 0xFFFF)/*CRC16*/<<8)|(read_data_batadc&0xFF));
    mbus_remote_register_write(MRR_ADDR,0x10,radio_data & 0xFFFFFF);

    //mbus_remote_register_write(MRR_ADDR,0xD,0xAAAAAA);
    //mbus_remote_register_write(MRR_ADDR,0xE,0x555555);
    //mbus_remote_register_write(MRR_ADDR,0xF,0xAAAAAA);
    //mbus_remote_register_write(MRR_ADDR,0x10,0x555555);

    if (!radio_ready){
        radio_ready = 1;

        // Release FSM Reset
        mrrv10_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
        mbus_remote_register_write(MRR_ADDR,0x11,mrrv10_r11.as_int);
        delay(MBUS_DELAY);

        mrrv10_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
        mbus_remote_register_write(MRR_ADDR,0x03,mrrv10_r03.as_int);
        delay(MBUS_DELAY);

        // Current Limter set-up 
        mrrv10_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
        mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    }

    uint32_t count = 0;
    uint32_t mrr_cfo_val_fine = 0;
    uint32_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    // New for mrrv10
    mrr_cfo_val_fine = 0x2000;

    while (count < num_packets){
#ifdef DEBUG_MBUS_MSG
        mbus_write_message32(0xCE, mrr_cfo_val);
#endif

        *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
        *REG_MBUS_WD = 0; // Disables Mbus watchdog timer

        mrrv10_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
        mrrv10_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
        mbus_remote_register_write(MRR_ADDR,0x01,mrrv10_r01.as_int);
        send_radio_data_mrr_sub1();
        mbus_write_message32(0xDD, count);
        count++;
        if (count < num_packets){
            delay(RADIO_PACKET_DELAY);
        }
        mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
    }

    radio_packet_count++;

    if (last_packet){
        radio_ready = 0;
        radio_power_off();
    }else{
        mrrv10_r11.MRR_RAD_FSM_EN = 0;
        mbus_remote_register_write(MRR_ADDR,0x11,mrrv10_r11.as_int);
    }
}

/**********************************************
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer

    // Enumeration
    enumerated = ENUMID;
    mbus_enumerate(SNT_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(LNT_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(MEM_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(MRR_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(PMU_ADDR);
    delay(MBUS_DELAY);

    // Default CPU halt function
    set_halt_until_mbus_tx();

    // Global variables
    wakeup_data = 0;
    wfi_timeout_flag = 0;

    xo_period = 60;
    xo_interval[0] = 60;
    xo_interval[1] = 300;
    xo_interval[2] = 1500;
    xo_interval[3] = 7500;

    xo_day_time = 0;
    xo_day_start = 18000;
    xo_day_end = 36400;

    snt_const_a = 9.45;
    snt_const_b = -1628.85;
    snt_sys_temp = 25;
    snt_state = SNT_IDLE;
    temp_data_valid = 0;

    lnt_upper_thresh[0] = 500;
    lnt_upper_thresh[1] = 2000;
    lnt_upper_thresh[2] = 6000;

    lnt_lower_thresh[0] = 250;
    lnt_lower_thresh[1] = 1000;
    lnt_lower_thresh[2] = 3000;

    mem_addr = 0;
    mem_write_data = 0;

    mrr_signal_period = 300;
    mrr_data_period = 18000;
    mrr_temp_thresh = 5;
    mrr_volt_thresh = 4;

    pmu_setting_val = 0;
    pmu_cur_active_setting = 0;
    pmu_cur_sleep_setting = 0;
    pmu_temp_thresh[0] = 0;
    pmu_temp_thresh[1] = 10;
    pmu_temp_thresh[2] = 25;
    pmu_temp_thresh[3] = 65;
    pmu_active_settings[0] = 0x00000000;
    pmu_active_settings[1] = 0x00000000;
    pmu_active_settings[2] = 0x00000000;
    pmu_active_settings[3] = 0x00000000;
    pmu_active_settings[4] = 0x00000000;
    pmu_sleep_settings[0] = 0x00000000;
    pmu_sleep_settings[1] = 0x00000000;
    pmu_sleep_settings[2] = 0x00000000;
    pmu_sleep_settings[3] = 0x00000000;
    pmu_sleep_settings[4] = 0x00000000;
    pmu_radio_settings[0] = 0x00000000;
    pmu_radio_settings[1] = 0x00000000;
    pmu_radio_settings[2] = 0x00000000;
    pmu_radio_settings[3] = 0x00000000;
    pmu_radio_settings[4] = 0x00000000;

    // Initialization

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);

    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    // PMU initialization
    pmu_init();
    
    xo_init();
}

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;

    mbus_sleep_all();
    while(1);
}

static void operation_sleep_noirqreset( void ) {
    mbus_sleep_all();
    while(1);
}

static void operation_sleep_notimer( void ) {
    // Diable timer
    set_wakeup_timer(0, 0, 0);
    operation_sleep();
}

/**********************************************
 * Interrupt handlers
 **********************************************/

void handler_ext_int_wakeup     (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_gocep      (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_timer32    (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg0       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg1       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP
    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
    // Report who woke up
    delay(MBUS_DELAY);
    mbus_write_message32(0xAA, *SREG_WAKEUP_SOURCE);

}

void handler_ext_int_gocep( void ) { // GOCEP
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
    mbus_write_message32(0xCC, 0x0);
}

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
/*
    *REG1 = *TIMER32_CNT;
    *REG2 = *TIMER32_STAT;
*/
    *TIMER32_STAT = 0x0;
    wfi_timeout_flag = 1;
    mbus_write_message32(0xDD, 0x0);
}

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
}

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
}

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
}

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
}

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    // BREAKPOINT 0x00
    mbus_write_message32(0xBA, 0x00);

}
