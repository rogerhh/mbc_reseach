/******************************************************************************************
 * Author:      Roger Hsiao, Gordy Carichner
 * Description: Monarch butterfly challenge code
 ******************************************************************************************
 * v1: draft version; not tested on chip
 *
 ******************************************************************************************/

#include "../include/PREv20.h"
#include "../include/PREv20_RF.h"
#include "../include/MRRv10_RF.h"
#include "../include/FLPv3S.h"
#include "../include/FLPv3S_RF.h"
#include "../include/RDCv2_RF.h"
#include "../include/SNTv4_RF.h"
#include "../include/LNTv1A_RF.h"
#include "../include/PMUv9_RF.h"
#include "../include/mbus.h"

// uncomment this for debug mbus message
//#define DEBUG_MBUS_MSG
// uncomment this for debug radio message
//#define DEBUG_RADIO_MSG

// Assigning short prefixes by stack order
#define PRE_ADDR 0x1
#define MRR_ADDR 0x2
#define FLP_ADDR 0x3
#define LNT_ADDR 0x4
#define SNT_ADDR 0x5
#define RDC_ADDR 0x6
#define PMU_ADDR 0x7

// Temp sensor parameters
#define MBUS_DELAY 100      // Amount of delay between successive messages; 100: 6-7ms

// MBC states
#define MBC_IDLE        0x0
#define MBC_READY       0x1
#define MBC_TEMP_READ   0x3
#define MBC_FLASH_WRITE 0x5
#define MBC_FLASH_READ  0x6

// GOC states
#define GOC_IDLE            0x0
#define GOC_FLASH_WRITE1    0x1
#define GOC_FLASH_WRITE2    0x2
#define GOC_FLASH_READ1     0x3
#define GOC_TEMP_TEST 	    0x4

// SNT states
#define SNT_IDLE        0x0
#define SNT_TEMP_LDO    0x1
#define SNT_TEMP_START  0x2
#define SNT_TEMP_READ   0x3
#define SNT_SET_PMU	0x4

// FIXME: Make this more versatile
// FLP states
#define FLP_OFF             0x0
#define FLP_ON              0x1
#define FLP_LOCAL_TO_SRAM   0x2
#define FLP_SRAM_TO_LOCAL   0x3
#define FLP_SRAM_TO_FLASH   0x4
#define FLP_FLASH_TO_SRAM   0x5
#define FLP_ERASE           0x6

// Radio configs
#define RADIO_DATA_LENGTH 192
#define WAKEUP_PERIOD_RADIO_INIT 0xA // About 2 sec (PRCv17)

// PMU states
#define PMU_NEG_10C 0x0
#define PMU_0C      0x1
#define PMU_10C     0x2
#define PMU_20C     0x3
#define PMU_25C     0x4
#define PMU_35C     0x5
#define PMU_55C     0x6
#define PMU_75C     0x7
#define PMU_95C     0x8

// CP parameters
#define TIMERWD_val 0xFFFFFF  // 0xFFFFF about 13 sec with Y5 running default clock (PRCv17)
// FIXME: Update this
#define TIMER32_VAL 0x800000  // 0x20000 about 1 sec with Y5 run default clock (PRCv17)

#define ENUMID 0xDEADBEEF

/**********************************************
 * Global variables
 **********************************************
 * "static" limits the variables to this file, giving the compiler more freedom
 * "volatile" should only be used for mmio to ensure memory storage
 */
volatile uint32_t enumerated;
volatile uint32_t wakeup_data;
volatile uint32_t wfi_timeout_flag;
volatile uint32_t error_code;
volatile uint32_t flash_addr;
volatile uint32_t flash_data;
volatile uint32_t temp_data;
volatile uint32_t exec_count_irq;
volatile uint32_t PMU_ADC_4P2_VAL;
volatile uint32_t pmu_setting_state;
volatile uint32_t PMU_neg_10C_threshold_sns;
volatile uint32_t PMU_0C_threshold_sns;
volatile uint32_t PMU_10C_threshold_sns;
volatile uint32_t PMU_20C_threshold_sns;
volatile uint32_t PMU_25C_threshold_sns;
volatile uint32_t PMU_35C_threshold_sns;
volatile uint32_t PMU_55C_threshold_sns;
volatile uint32_t PMU_75C_threshold_sns;
volatile uint32_t PMU_95C_threshold_sns;

volatile uint32_t read_data_batadc;
volatile uint32_t read_data_batadc_diff;
volatile uint32_t read_data_lnt;

uint32_t goc_temp_arr[20];
volatile uint16_t goc_temp_test_count;

volatile uint8_t wakeup_data_header;
volatile uint8_t mbc_state;
volatile uint8_t goc_state;
volatile uint8_t snt_state;
volatile uint8_t flp_state;
volatile uint8_t temp_data_valid;
volatile uint8_t sensor_queue;      // [0]: lnt; [1]: SNT; [2]: RDC;
volatile uint8_t goc_temp_test_len;
volatile uint32_t flash_test_data_arr[256];

// default register values
volatile prev20_r19_t prev20_r19 = PREv20_R19_DEFAULT;
/*
   volatile prev18_r0B_t prev18_r0B = PREV18_R0B_DEFAULT;
   volatile prev18_r19_t prev18_r19 = PREV18_R19_DEFAULT;
   volatile prev18_r1A_t prev18_r1A = PREV18_R1A_DEFAULT;
   volatile prev18_r1C_t prev18_r1C = PREV18_R1C_DEFAULT;
   */


volatile sntv4_r00_t sntv4_r00 = SNTv4_R00_DEFAULT;
volatile sntv4_r01_t sntv4_r01 = SNTv4_R01_DEFAULT;
volatile sntv4_r07_t sntv4_r07 = SNTv4_R07_DEFAULT;

volatile lntv1a_r00_t lntv1a_r00 = LNTv1A_R00_DEFAULT;
volatile lntv1a_r01_t lntv1a_r01 = LNTv1A_R01_DEFAULT;
volatile lntv1a_r02_t lntv1a_r02 = LNTv1A_R02_DEFAULT;
volatile lntv1a_r03_t lntv1a_r03 = LNTv1A_R03_DEFAULT;
volatile lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
volatile lntv1a_r05_t lntv1a_r05 = LNTv1A_R05_DEFAULT;
volatile lntv1a_r06_t lntv1a_r06 = LNTv1A_R06_DEFAULT;
volatile lntv1a_r07_t lntv1a_r07 = LNTv1A_R07_DEFAULT;
volatile lntv1a_r17_t lntv1a_r17 = LNTv1A_R17_DEFAULT;
volatile lntv1a_r20_t lntv1a_r20 = LNTv1A_R20_DEFAULT;
volatile lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
volatile lntv1a_r22_t lntv1a_r22 = LNTv1A_R22_DEFAULT;
volatile lntv1a_r40_t lntv1a_r40 = LNTv1A_R40_DEFAULT;

volatile uint32_t radio_ready;
volatile uint32_t radio_on;
volatile uint32_t mrr_freq_hopping;
volatile uint32_t mrr_freq_hopping_step;
volatile uint32_t mrr_cfo_val_fine_min;
volatile uint32_t RADIO_PACKET_DELAY;
volatile uint32_t radio_packet_count;

volatile mrrv10_r00_t mrrv10_r00 = MRRv10_R00_DEFAULT;
volatile mrrv10_r01_t mrrv10_r01 = MRRv10_R01_DEFAULT;
volatile mrrv10_r02_t mrrv10_r02 = MRRv10_R02_DEFAULT;
volatile mrrv10_r03_t mrrv10_r03 = MRRv10_R03_DEFAULT;
volatile mrrv10_r04_t mrrv10_r04 = MRRv10_R04_DEFAULT;
volatile mrrv10_r07_t mrrv10_r07 = MRRv10_R07_DEFAULT;
volatile mrrv10_r11_t mrrv10_r11 = MRRv10_R11_DEFAULT;
volatile mrrv10_r12_t mrrv10_r12 = MRRv10_R12_DEFAULT;
volatile mrrv10_r13_t mrrv10_r13 = MRRv10_R13_DEFAULT;
volatile mrrv10_r14_t mrrv10_r14 = MRRv10_R14_DEFAULT;
volatile mrrv10_r15_t mrrv10_r15 = MRRv10_R15_DEFAULT;
volatile mrrv10_r1F_t mrrv10_r1F = MRRv10_R1F_DEFAULT;
volatile mrrv10_r21_t mrrv10_r21 = MRRv10_R21_DEFAULT;

//***************************************************
// Timeout Functions
//***************************************************

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
    config_timer32(val, 1, 0, 0);
}

static void stop_timer32_timeout_check(uint32_t code){
    // Turn off Timer32
    *TIMER32_GO = 0;
    if (wfi_timeout_flag){
        wfi_timeout_flag = 0;
        error_code = code;
        mbus_write_message32(0xFA, error_code);
    }
}

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
    delay(40000); // >= 1s

    prev20_r19.XO_SCN_CLK_SEL = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(2000); // >= 300us

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
    prev20_r19.XO_SCN_ENB     = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(40000);  // >= 1s

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


/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/
inline static void pmu_adc_read_latest();
inline static void pmu_setting_temp_based();

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

static void operation_temp_run() {
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
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default

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
            // TODO: verify value measured
            temp_data = *REG0;

            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

            mbus_write_message32(0xDD, 0xBB);
            snt_state = SNT_SET_PMU;
        }
    }
    else if(snt_state == SNT_SET_PMU) {
        temp_data_valid = 1;

        /*
        // Read latest PMU ADC measurement
        pmu_adc_read_latest();

        mbus_write_message32(0xDD, 0xBB);

        // Change PMU based on temp
        // code to save space
        uint32_t last_pmu_state = pmu_setting_state;
        if(temp_data > PMU_95C_threshold_sns) {
        pmu_setting_state = PMU_95C;
        }
        else if(temp_data > PMU_75C_threshold_sns) {
        pmu_setting_state = PMU_75C;
        }
        else if(temp_data > PMU_55C_threshold_sns) {
        pmu_setting_state = PMU_55C;
        }
        else if(temp_data < PMU_10C_threshold_sns) {
        pmu_setting_state = PMU_10C;
        }
        else if(temp_data < PMU_20C_threshold_sns) {
        pmu_setting_state = PMU_20C;
        }
        else if(temp_data > PMU_20C_threshold_sns) {
        pmu_setting_state = PMU_25C;
        }
        if(last_pmu_state != pmu_setting_state) {
        pmu_setting_temp_based();
        }
        */

        snt_state = SNT_IDLE;
    }
}

/**********************************************
 * Flash Functions (FLPv3S)
 **********************************************/

void flp_fail(uint32_t id) {
    delay(10000);
    mbus_write_message32(0xE2, 0xDEADBEEF);
    delay(10000);
    mbus_write_message32(0xE2, id);
    delay(10000);
    mbus_write_message32(0xE2, 0xDEADBEEF);
    delay(10000);
    mbus_sleep_all();
    while(1);
}

void FLASH_init( void ) {
    // Tune Flash
    mbus_remote_register_write(FLP_ADDR, 0x26, 0x0D7788); // Program Current
    mbus_remote_register_write(FLP_ADDR, 0x27, 0x011BC8); // Erase Pump Diode Chain
    mbus_remote_register_write(FLP_ADDR, 0x01, 0x000109); // Tprog idle time
    mbus_remote_register_write(FLP_ADDR, 0x02, 0x000A00); // Terase idle time
    mbus_remote_register_write(FLP_ADDR, 0x05, 0x000FCF); // Tcap
    mbus_remote_register_write(FLP_ADDR, 0x06, 0x002F7F); // Tvref
    mbus_remote_register_write(FLP_ADDR, 0x19, 0x000F06); // Voltage Clamper Tuning
    mbus_remote_register_write(FLP_ADDR, 0x0F, 0x001001); // Flash interrupt target register addr: REG0 -> REG1
    //mbus_remote_register_write(FLP_ADDR, 0x12, 0x000003); // Auto Power On/Off

}

// static void flash_setting_temp_based() {
//     mbus_write_message32(0xB5, pmu_setting_state);
//     // uint32_t Tprog, Terase, Tcap, Tvref, vclamp;
//     if(pmu_setting_state == PMU_NEG_10C) {
// 	mbus_remote_register_write(FLP_ADDR, 0x01, 0x000109); // Tprog idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x02, 0x000100); // Terase idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x05, 0x0007CF); // Tcap
// 	mbus_remote_register_write(FLP_ADDR, 0x06, 0x00217F); // Tvref
// 	mbus_remote_register_write(FLP_ADDR, 0x19, 0x000F06); // Voltage Clamper Tuning
//     }
//     else if(pmu_setting_state == PMU_0C) {
// 	mbus_remote_register_write(FLP_ADDR, 0x01, 0x000109); // Tprog idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x02, 0x000100); // Terase idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x05, 0x0007CF); // Tcap
// 	mbus_remote_register_write(FLP_ADDR, 0x06, 0x001F3F); // Tvref
// 	mbus_remote_register_write(FLP_ADDR, 0x19, 0x000F05); // Voltage Clamper Tuning
//     }
//     else if(pmu_setting_state == PMU_10C) {
// 	mbus_remote_register_write(FLP_ADDR, 0x01, 0x000109); // Tprog idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x02, 0x000100); // Terase idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x05, 0x0007CF); // Tcap
// 	mbus_remote_register_write(FLP_ADDR, 0x06, 0x001F3F); // Tvref
// 	mbus_remote_register_write(FLP_ADDR, 0x19, 0x000F03); // Voltage Clamper Tuning
//     }
//     else if(pmu_setting_state == PMU_20C) {
// 	mbus_remote_register_write(FLP_ADDR, 0x01, 0x000109); // Tprog idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x02, 0x000100); // Terase idle time
// 	mbus_remote_register_write(FLP_ADDR, 0x05, 0x0007CF); // Tcap
// 	mbus_remote_register_write(FLP_ADDR, 0x06, 0x001F3F); // Tvref
// 	mbus_remote_register_write(FLP_ADDR, 0x19, 0x000F03); // Voltage Clamper Tuning
//     }
//     else if(pmu_setting_state == PMU_25C) {
//         pmu_set_active_clk(0x5, 0x1, 0x10, 0x2/*V1P2*/);
//         // pmu_set_sleep_clk(0x2, 0x1, 0x1, 0x1/*V1P2*/);
//         pmu_set_sleep_low();
//     }
//     else if(pmu_setting_state == PMU_35C) {
//         pmu_set_active_clk(0x2, 0x1, 0x10, 0x2/*V1P2*/);
//         pmu_set_sleep_clk(0x2, 0x0, 0x1, 0x1/*V1P2*/);
//     }
//     else if(pmu_setting_state == PMU_55C) {
//         pmu_set_active_clk(0x1, 0x0, 0x10, 0x2/*V1P2*/);
//         pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
//     }
//     else if(pmu_setting_state == PMU_75C) {
//         pmu_set_active_clk(0xA, 0x4, 0x7, 0x8/*V1P2*/);
//         pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
//     }
//     else if(pmu_setting_state == PMU_95C) {
//         pmu_set_active_clk(0x7, 0x2, 0x7, 0x4/*V1P2*/);
//         pmu_set_sleep_clk(0x1, 0x0, 0x1, 0x0/*V1P2*/);
//     }
// }

void FLASH_turn_on() {
    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x11, 0x00002F);
    set_halt_until_mbus_tx();

    if(*REG1 != 0xB5) { flp_fail(1); }

    flp_state = FLP_ON;
}

void FLASH_turn_off() {
    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x11, 0x00002D);
    set_halt_until_mbus_tx();

    if(*REG1 != 0xBB) { flp_fail(2); }

    flp_state = FLP_OFF;
}

void FLASH_write_to_SRAM_bulk(uint32_t* remote_addr, 
        uint32_t* local_addr, 
        uint32_t length_in_words_minus_one) {
    mbus_copy_mem_from_local_to_remote_bulk(FLP_ADDR, remote_addr, local_addr, 
            length_in_words_minus_one);
}

void FLASH_read_from_SRAM_bulk(uint32_t* remote_addr,
        uint32_t* local_addr,
        uint32_t length_in_words_minus_one) {
    mbus_copy_mem_from_remote_to_any_bulk(FLP_ADDR, remote_addr, PRE_ADDR, local_addr,
            length_in_words_minus_one);
}

// REQUIRES: Flash is turned on
void copy_mem_from_SRAM_to_FLASH(uint32_t sram_addr, 
        uint32_t flash_addr, 
        uint32_t length_in_words_minus_one) {
    flp_state = FLP_SRAM_TO_FLASH;

    mbus_remote_register_write(FLP_ADDR, 0x07, sram_addr);
    mbus_remote_register_write(FLP_ADDR, 0x08, flash_addr);
    delay(MBUS_DELAY);

    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x09, (length_in_words_minus_one << 6) |
            (0x1 << 5) |
            (0x2 << 1) |
            (0x1));
    set_halt_until_mbus_tx();

    if(*REG1 != 0x00003F) { flp_fail(2); }
}

// REQUIRES: Flash is turned on
void copy_mem_from_FLASH_to_SRAM(uint32_t sram_addr, 
        uint32_t flash_addr,
        uint32_t length_in_words_minus_one) {
    flp_state = FLP_FLASH_TO_SRAM;

    mbus_remote_register_write(FLP_ADDR, 0x07, sram_addr);
    mbus_remote_register_write(FLP_ADDR, 0x08, flash_addr);
    delay(MBUS_DELAY);

    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x09, (length_in_words_minus_one << 6) |
            (0x1 << 5) |
            (0x1 << 1) |
            (0x1));
    set_halt_until_mbus_tx();

    if(*REG1 != 0x00002B) { flp_fail(3); }
}

// REQUIRES: Flash is turned on
void FLASH_erase_page(uint32_t flash_addr) {
    flp_state = FLP_ERASE;

    mbus_remote_register_write(FLP_ADDR, 0x08, flash_addr & 0x7F00);

    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x09, (0x1 << 5) |
            (0x4 << 1) |
            (0x1));
    set_halt_until_mbus_tx();

    delay(MBUS_DELAY);

    if(*REG1 != 0x00004F) { flp_fail(4); }
}

// REQUIRES: Flash is turned on
void FLASH_erase_all() {
    uint32_t i;
    for(i = 0; i <= 0x7F; ++i) {
        FLASH_erase_page(i << 8);
        delay(10000);
    }
}

/**********************************************
 * PMU functions (PMUv9)
 **********************************************/
static void pmu_reg_write(uint32_t reg_addr, uint32_t reg_data) {
    set_halt_until_mbus_trx();
    mbus_remote_register_write(PMU_ADDR, reg_addr, reg_data);
    set_halt_until_mbus_tx();
}

static void pmu_set_adc_period(uint32_t val) {
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
            ((1 <<  0) |    // state_sar_scn_on
             (0 <<  1) |    // state_wait_for_clock_cycles
             (1 <<  2) |    // state_wait_for_time
             (1 <<  3) |    // state_sar_scn_reset
             (1 <<  4) |    // state_sar_scn_stabilized
             (1 <<  5) |    // state_sar_scn_ratio_roughly_adjusted
             (1 <<  6) |    // state_clock_supply_switched
             (1 <<  7) |    // state_control_supply_switched
             (1 <<  8) |    // state_upconverter_on
             (1 <<  9) |    // state_upconverter_stabilized
             (1 << 10) |    // state_refgen_on
             (0 << 11) |    // state_adc_output_ready
             (0 << 12) |    // state_adc_adjusted
             (0 << 13) |    // state_sar_scn_ratio_adjusted
             (1 << 14) |    // state_downconverter_on
             (1 << 15) |    // state_downconverter_stabilized
             (1 << 16) |    // state_vdd_3p6_turned_on
             (1 << 17) |    // state_vdd_1p2_turned_on
             (1 << 18) |    // state_vdd_0p6_turned_on
             (0 << 19) |    // state_vbat_read
             (1 << 20)));   // state_state_horizon

    // Register 0x36: PMU_EN_TICK_REPEAT_VBAT_ADJUST
    pmu_reg_write(0x36, val);

    // Register 0x33: PMU_EN_TICK_ADC_RESET
    pmu_reg_write(0x33, 2);

    // Register 0x34: PMU_ENTICK_ADC_CLK
    pmu_reg_write(0x34, 2);

    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
            ((1 <<  0) |    // state_sar_scn_on
             (0 <<  1) |    // state_wait_for_clock_cycles
             (1 <<  2) |    // state_wait_for_time
             (1 <<  3) |    // state_sar_scn_reset
             (1 <<  4) |    // state_sar_scn_stabilized
             (1 <<  5) |    // state_sar_scn_ratio_roughly_adjusted
             (1 <<  6) |    // state_clock_supply_switched
             (1 <<  7) |    // state_control_supply_switched
             (1 <<  8) |    // state_upconverter_on
             (1 <<  9) |    // state_upconverter_stabilized
             (1 << 10) |    // state_refgen_on
             (0 << 11) |    // state_adc_output_ready
             (0 << 12) |    // state_adc_adjusted
             (0 << 13) |    // state_sar_scn_ratio_adjusted
             (1 << 14) |    // state_downconverter_on
             (1 << 15) |    // state_downconverter_stabilized
             (1 << 16) |    // state_vdd_3p6_turned_on
             (1 << 17) |    // state_vdd_1p2_turned_on
             (1 << 18) |    // state_vdd_0p6_turned_on
             (0 << 19) |    // state_vbat_read
             (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
            ((0 << 19) |    // enable PFM even during periodic reset
             (0 << 18) |    // enable PFM even when Vref is not used as ref
             (0 << 17) |    // enable PFM
             (3 << 14) |    // comparator clock division ratio
             (0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l_1p2 << 5) | // frequency multiplier l (actually l+1)
             (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
            ((0 << 19) |    // enable pfm even during periodic reset
             (0 << 18) |    // enable pfm even when Vref is not used as ref
             (0 << 17) |    // enable pfm
             (3 << 14) |    // comparator clock division ratio
             (0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l_1p2 << 5) | // frequency multiplier l (actually l+1)
             (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
            ((3 << 14) |    // desired vout/vin ratio; default: 0
             (0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l <<  5) |    // frequency multiplier l
             (base)));      // floor frequency base (0-63)

    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
            ((0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l <<  5) |    // frequency multiplier l
             (base)));      // floor frequency base (0-63)
}

static void pmu_set_active_clk_sar(uint8_t r, uint8_t l, uint8_t base) {
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
            ((0 << 19) |    // enable PFM even during periodic reset
             (0 << 18) |    // enable PFM even when Vref is not used as ref
             (0 << 17) |    // enable PFM
             (3 << 14) |    // comparator clock division ratio
             (0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l << 5) | // frequency multiplier l (actually l+1)
             (base)));      // floor frequency base (0-63)
}

static void pmu_set_active_clk_3p6(uint8_t r, uint8_t l, uint8_t base) {
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
            ((3 << 14) |    // desired vout/vin ratio; default: 0
             (0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l <<  5) |    // frequency multiplier l
             (base)));      // floor frequency base (0-63)
}

static void pmu_set_active_clk_0p6(uint8_t r, uint8_t l, uint8_t base) {
    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
            ((0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l <<  5) |    // frequency multiplier l
             (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
            ((3 << 14) |    // desired vout/vin ratio; default: 0
             (0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l <<  5) |    // frequency multiplier l (actually l+1)
             (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
            ((0 << 19) |    // enable pdm even during periodic reset
             (0 << 18) |    // enable pfm even when Vref is not used as ref
             (0 << 17) |    // enable pfm
             (3 << 14) |    // comparator clock division ratio
             (0 << 13) |    // enable main feedack loop
             (r <<  9) |    // frequency multiplier r
             (l_1p2 << 5) | // frequency multiplier l (actually l+1)
             (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
            ((0 << 13) |    // enable main feedback loop
             (r <<  9) |    // frequency multiplier r
             (l <<  5) |    // frequency multiplier l (actually l+1)
             (base)));      // floor frequency base (0-63)
}

inline static void pmu_set_sleep_radio() {
    pmu_set_sleep_clk(0xF, 0xA, 0x5, 0xF/*V1P2*/);
}

inline static void pmu_set_sleep_low() {
    pmu_set_sleep_clk(0x2, 0x1, 0x1, 0x1/*V1P2*/);
}

static void pmu_setting_temp_based_with_active_r(uint8_t r) {
    mbus_write_message32(0xB7, pmu_setting_state);
    if(pmu_setting_state == PMU_10C) {
        pmu_set_active_clk(r, 0x2, 0x10, 0x4/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_20C) {
        pmu_set_active_clk(r, 0x2, 0x10, 0x4/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_25C) {
        pmu_set_active_clk(r, 0x1, 0x10, 0x2/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_35C) {
        pmu_set_active_clk(r, 0x1, 0x10, 0x2/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_55C) {
        pmu_set_active_clk(r, 0x0, 0x10, 0x2/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_75C) {
        pmu_set_active_clk(r, 0x4, 0x7, 0x8/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_95C) {
        pmu_set_active_clk(r, 0x2, 0x7, 0x4/*V1P2*/);
    }
}

static void pmu_setting_temp_based_with_sleep_r(uint8_t r) {
    mbus_write_message32(0xB7, pmu_setting_state);
    if(pmu_setting_state == PMU_10C) {
        pmu_set_sleep_clk(r, 0x1, 0x1, 0x2/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_20C) {
        pmu_set_sleep_clk(r, 0x2, 0x1, 0x4/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_25C) {
        pmu_set_sleep_clk(r, 0x1, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_35C) {
        pmu_set_sleep_clk(r, 0x0, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_55C) {
        pmu_set_sleep_clk(r, 0x1, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_75C) {
        pmu_set_sleep_clk(r, 0x1, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_95C) {
        pmu_set_sleep_clk(r, 0x0, 0x1, 0x0/*V1P2*/);
    }
}

static void pmu_setting_temp_based() {
    mbus_write_message32(0xB7, pmu_setting_state);
    if(pmu_setting_state == PMU_10C) {
        pmu_set_active_clk(0xD, 0x2, 0x10, 0x4/*V1P2*/);
        pmu_set_sleep_clk(0xF, 0x1, 0x1, 0x2/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_20C) {
        pmu_set_active_clk(0x7, 0x2, 0x10, 0x4/*V1P2*/);
        //pmu_set_sleep_clk(0xF, 0x2, 0x1, 0x4/*V1P2*/);
        pmu_set_sleep_low();
    }
    else if(pmu_setting_state == PMU_25C) {
        pmu_set_active_clk(0x5, 0x1, 0x10, 0x2/*V1P2*/);
        // pmu_set_sleep_clk(0x2, 0x1, 0x1, 0x1/*V1P2*/);
        pmu_set_sleep_low();
    }
    else if(pmu_setting_state == PMU_35C) {
        pmu_set_active_clk(0x2, 0x1, 0x10, 0x2/*V1P2*/);
        pmu_set_sleep_clk(0x2, 0x0, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_55C) {
        pmu_set_active_clk(0x1, 0x0, 0x10, 0x2/*V1P2*/);
        pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_75C) {
        pmu_set_active_clk(0xA, 0x4, 0x7, 0x8/*V1P2*/);
        pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_95C) {
        pmu_set_active_clk(0x7, 0x2, 0x7, 0x4/*V1P2*/);
        pmu_set_sleep_clk(0x1, 0x0, 0x1, 0x0/*V1P2*/);
    }
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based();
    // Use the new reset scheme in PMUv3
    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
            ((0 << 13) |    // enable override setting [12] (1'b1)
             (0 << 12) |    // let vdd_clk always connect to vbat
             (1 << 11) |    // enable override setting [10] (1'h0)
             (0 << 10) |    // have the converter have the periodic reset (1'h0)
             (0 <<  9) |    // enable override setting [8:0] (1'h0)
             (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
             (0 <<  7) |    // enable override setting [6:0] (1'h0)
             (54)));        // binary converter's conversion ratio (7'h00)
    pmu_reg_write(0x05,         // default 12'h000
            ((1 << 13) |    // enable override setting [12] (1'b1)
             (0 << 12) |    // let vdd_clk always connect to vbat
             (1 << 11) |    // enable override setting [10] (1'h0)
             (0 << 10) |    // have the converter have the periodic reset (1'h0)
             (1 <<  9) |    // enable override setting [8:0] (1'h0)
             (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
             (1 <<  7) |    // enable override setting [6:0] (1'h0)
             (54)));        // binary converter's conversion ratio (7'h00)
}

inline static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
            ((1 <<  0) |    // state_sar_scn_on
             (1 <<  1) |    // state_wait_for_clock_cycles
             (1 <<  2) |    // state_wait_for_time
             (1 <<  3) |    // state_sar_scn_reset
             (1 <<  4) |    // state_sar_scn_stabilized
             (1 <<  5) |    // state_sar_scn_ratio_roughly_adjusted
             (1 <<  6) |    // state_clock_supply_switched
             (1 <<  7) |    // state_control_supply_switched
             (1 <<  8) |    // state_upconverter_on
             (1 <<  9) |    // state_upconverter_stabilized
             (1 << 10) |    // state_refgen_on
             (0 << 11) |    // state_adc_output_ready
             (0 << 12) |    // state_adc_adjusted
             (0 << 13) |    // state_sar_scn_ratio_adjusted
             (1 << 14) |    // state_downconverter_on
             (1 << 15) |    // state_downconverter_stabilized
             (1 << 16) |    // state_vdd_3p6_turned_on // Needed for other functions
             (1 << 17) |    // state_vdd_1p2_turned_on
             (1 << 18) |    // state_vdd_0p6_turned_on
             (0 << 19) |    // state_vbat_read
             (1 << 20)));   // state_state_horizon
}

inline static void pmu_adc_disable() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
            ((1 <<  0) |    // state_sar_scn_on
             (1 <<  1) |    // state_wait_for_clock_cycles
             (1 <<  2) |    // state_wait_for_time
             (1 <<  3) |    // state_sar_scn_reset
             (1 <<  4) |    // state_sar_scn_stabilized
             (1 <<  5) |    // state_sar_scn_ratio_roughly_adjusted
             (1 <<  6) |    // state_clock_supply_switched
             (1 <<  7) |    // state_control_supply_switched
             (1 <<  8) |    // state_upconverter_on
             (1 <<  9) |    // state_upconverter_stabilized
             (1 << 10) |    // state_refgen_on
             (0 << 11) |    // state_adc_output_ready
             (0 << 12) |    // state_adc_adjusted
             (1 << 13) |    // state_sar_scn_ratio_adjusted     // Turn on for old adc, off for new adc
             (1 << 14) |    // state_downconverter_on
             (1 << 15) |    // state_downconverter_stabilized
             (1 << 16) |    // state_vdd_3p6_turned_on
             (1 << 17) |    // state_vdd_1p2_turned_on
             (1 << 18) |    // state_vdd_0p6_turned_on
             (0 << 19) |    // state_vbat_read                  // Turn off for old adc
             (1 << 20)));   // state_state_horizon
}

inline static void pmu_adc_enable() {
    // PMU ADC will be automatically reset when system wakes up
    // PMU_CONTROLLER_DESIRED_STATE sleep
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
            ((1 <<  0) |    // state_sar_scn_on
             (1 <<  1) |    // state_wait_for_clock_cycles
             (1 <<  2) |    // state_wait_for_time
             (1 <<  3) |    // state_sar_scn_reset
             (1 <<  4) |    // state_sar_scn_stabilized
             (1 <<  5) |    // state_sar_scn_ratio_roughly_adjusted
             (1 <<  6) |    // state_clock_supply_switched
             (1 <<  7) |    // state_control_supply_switched
             (1 <<  8) |    // state_upconverter_on
             (1 <<  9) |    // state_upconverter_stabilized
             (1 << 10) |    // state_refgen_on
             (1 << 11) |    // state_adc_output_ready
             (0 << 12) |    // state_adc_adjusted               // Turning off offset cancellation
             (1 << 13) |    // state_sar_scn_ratio_adjusted     // Turn on for old adc, off for new adc
             (1 << 14) |    // state_downconverter_on
             (1 << 15) |    // state_downconverter_stabilized
             (1 << 16) |    // state_vdd_3p6_turned_on
             (1 << 17) |    // state_vdd_1p2_turned_on
             (1 << 18) |    // state_vdd_0p6_turned_on
             (0 << 19) |    // state_vbat_read                  // Turn of for old adc
             (1 << 20)));   // state_state_horizon
}

inline static void pmu_adc_read_latest() {
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFF;

    if(read_data_batadc < PMU_ADC_4P2_VAL) {
        read_data_batadc_diff = 0;
    }
    else {
        read_data_batadc_diff = read_data_batadc - PMU_ADC_4P2_VAL;
    }
}

inline static void pmu_reset_solar_short() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
            ((0 << 12) |    // 1: solar short by latched vbat_high (new); 0: follow [10] setting
             (1 << 11) |    // Reset of vbat_high latch for [12]=1
             (1 << 10) |    // When to turn on harvester-inhibiting switch (0: PoR, 1: VBAT high)
             (1 <<  9) |    // Enable override setting [8]
             (0 <<  8) |    // Turn on the harvester-inhibiting switch
             (3 <<  4) |    // clamp_tune_bottom (increases clamp thresh)
             (0)));         // clamp_tune_top (decreases clamp thresh)

    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
            ((0 << 12) |    // 1: solar short by latched vbat_high (new); 0: follow [10] setting
             (1 << 11) |    // Reset of vbat_high latch for [12]=1
             (1 << 10) |    // When to turn on harvester-inhibiting switch (0: PoR, 1: VBAT high)
             (1 <<  9) |    // Enable override setting [8]
             (0 <<  8) |    // Turn on the harvester-inhibiting switch
             (3 <<  4) |    // clamp_tune_bottom (increases clamp thresh)
             (0)));         // clamp_tune_top (decreases clamp thresh)
}

inline static void pmu_init() {
    pmu_set_clk_init();
    // pmu_reset_solar_short();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
            ((0x00 << 9) |  // 0x0 no:mon; mx1: sar conv mon; 0x2: up conv mon; 0x3: down conv mon
             (0x00 << 8) |  // 1: vbat_read_mode enable; 0: vbat_read_mode_disable
             (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
            ((1 << 20) |    // ignore state_horizen; default: 1
             (0 << 19) |    // state_vbat_read
             (1 << 13) |    // ignore state_adc_output_ready; default: 0
             (1 << 12) |    // ignore state_adc_output_ready; default:0
             (1 << 11)));   // ignore state_adc_output_ready; default:0

    pmu_adc_reset_setting();
    pmu_adc_enable();
}

inline static void lnt_init() {
    // Config Register A
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    //lntv1a_r22.TMR_S = 0x4; // Default: 0x4
    //lntv1a_r22.TMR_DIFF_CON = 0x1FFF; // Default: 0x3FFB
    //lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
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

//***************************************************
// CRC16 Encoding
//***************************************************
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

//***************************************************
// MRR Functions
//***************************************************

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

    // Make sure the irq counter is reset    
    exec_count_irq = 0;

    // Make sure Radio is off
    if (radio_on){radio_power_off();}

    // Disable Timer
    set_wakeup_timer(0, 0, 0);

    // Go to sleep
    operation_sleep();

}

// TEMP WAKEUP TIMER FUNCTION
void set_wakeup_timer_prev17 ( uint32_t timestamp, uint8_t irq_en, uint8_t reset ){
    uint32_t regval = timestamp;
    if( irq_en ) regval |= 0x030000; // IRQ in Sleep-Only
    else		 regval &= 0xFCFFFF;
    *REG_WUPT_CONFIG = regval;

    if( reset ) *WUPT_RESET = 0x01;
}

/**********************************************
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer

    /*
    // Set CPU and Mbus clock speeds
    // Under default settings Mbus clock speed = 192.5kHz, core clock speed is 96.3kHz
    // TODO: Verify this
    prev18_r0B.CLK_GEN_HIGH_FREQ    = 0x0; // Default 0x0, 1bit
    prev18_r0B.CLK_GEN_RING         = 0x1; // Default 0x1, 2bits
    prev18_r0B.CLK_GEN_DIV_MBC      = 0x2; // Default 0x2, 3bits
    prev18_r0B.CLK_GEN_DIV_CORE     = 0x3; // Default 0x3, 3bits
    // GOC_CLK_GEN_SEL_DIV = 0x0, GOC_CLK_GEN_SEL_FREQ = 0x6 gives GOC clock speed = 11550Hz
    prev18_r0B.GOC_CLK_GEN_SEL_DIV  = 0x0; // Default 0x1, 2bits
    prev18_r0B.GOC_CLK_GEN_SEL_FREQ = 0x6; // Default 0x7, 3bits
     *REG_CLKGEN_TUNE = prev18_r0B.as_int;

    // FIXME: This adds a delay to SRAM reads for debugging purpose, which improves the
    // robustness of SRAM reads at the cost of speed and power. Possibly remove this 
    // after testing
    prev18_r1C.SRAM0_TUNE_ASO_DLY     = 0x1F; // Default 0x00, 5bits
    prev18_r1C.SRAM0_TUNE_DECODER_DLY = 0xF;  // Default 0x2, 4bits
    prev18_r1C.SRAM0_USE_INVERTER_SA  = 0x0;  // Default 0x0, 1bit
    */

    // Enumeration
    enumerated = ENUMID;
    mbus_enumerate(MRR_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(FLP_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(LNT_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(SNT_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(RDC_ADDR);
    delay(MBUS_DELAY);
    mbus_enumerate(PMU_ADDR);
    delay(MBUS_DELAY);

    // Default CPU halt function
    set_halt_until_mbus_tx();

    // MRR Settings --------------------------------------
    // Reqruied in MRRv10 to run like MRRv7
    mrrv10_r21.MRR_TRX_ENb_CONT_RC = 0;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,0x21,mrrv10_r21.as_int);

    // Decap in series
    mrrv10_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv10_r03.as_int);
    mrrv10_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv10_r03.as_int);

    // Current Limter set-up 
    mrrv10_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Turn on Current Limter
    mrrv10_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);

    // Wait for charging decap
    config_timerwd(TIMERWD_val);
    *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv10_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    mrrv10_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv10_r1F.as_int);

    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 20;
    mrr_freq_hopping_step = 0; // determining center freq

    mrr_cfo_val_fine_min = 0x0000;

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY

    // Adjust C
    mrrv10_r07.RO_MOM = 0x10;
    mrrv10_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv10_r07.as_int);

    // TX Setup Carrier Freq
    mrrv10_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv10_r00.as_int);
    mrrv10_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x01f; //ANT CAP 10b unary 830.5 MHz
    mrrv10_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv10_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv10_r01.as_int);
    mrrv10_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv10_r02.as_int);

    // Turn off RX mode
    mrrv10_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv10_r03.as_int);

    mrrv10_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv10_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    mrrv10_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv10_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv10_r14.as_int);
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv10_r15.as_int);

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv10_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    mrrv10_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv10_r11.as_int);

    mrrv10_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv10_r13.as_int);

    mrrv10_r04.LDO_SEL_VOUT = 0; // New for MRRv10
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv10_r04.as_int);
    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);

    // Additional delay for charging decap
    config_timerwd(TIMERWD_val);
    *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    // Global variables
    wakeup_data = 0;
    exec_count_irq = 0;
    wfi_timeout_flag = 0;
    mbc_state = MBC_IDLE;
    goc_state = GOC_IDLE;
    snt_state = SNT_IDLE;
    flp_state = FLP_OFF;
    radio_packet_count = 0;
    RADIO_PACKET_DELAY = 13000;

    temp_data = 0;
    temp_data_valid = 0;

    sensor_queue = 0;

    PMU_ADC_4P2_VAL = 0x4B;

    // // 35C works for now
    pmu_setting_state = PMU_20C;
    PMU_10C_threshold_sns =   600;    // Around 10C
    PMU_20C_threshold_sns =  1000;    // Around 20C
    PMU_35C_threshold_sns =  2000;    // Around 35C
    PMU_55C_threshold_sns =  3200;    // Around 55C
    PMU_75C_threshold_sns =  7000;    // Around 75C
    PMU_95C_threshold_sns = 12000;    // Around 95C


    // Initialization

    // Set CPU & Mbus Clock Speeds
    /*
       prev17_r0D.SRAM_TUNE_ASO_DLY = 31; // Default 0x0, 5 bits
       prev17_r0D.SRAM_TUNE_DECODER_DLY = 15; // Default 0x2, 4 bits
       prev17_r0D.SRAM_USE_INVERTER_SA= 1; 
     *REG_SRAM_TUNE = prev17_r0D.as_int;
     */

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);

    FLASH_init();
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    // PMU initialization
    pmu_init();

    xo_init();

    //lnt_init();
}

static void operation_goc_trigger_init(void){

    // This is critical
    set_halt_until_mbus_tx();

    // Debug
    //mbus_write_message32(0xAA,0xABCD1234);
    //mbus_write_message32(0xAA,wakeup_data);

    // Initialize variables & registers
    //sns_running = 0;
    //stack_state = STK_IDLE;

    radio_power_off();
    //radio_packet_count = 0;
}

static void operation_goc_trigger_radio(uint32_t radio_tx_num, uint32_t wakeup_timer_val, uint8_t radio_tx_prefix, uint32_t radio_tx_data){


    mbus_write_message32(0xAA, radio_tx_data);
    mbus_write_message32(0xAA, exec_count_irq);
    mbus_write_message32(0xAA, radio_tx_num);

    // Prepare radio TX
    radio_power_on();
    exec_count_irq++;
    // radio
    send_radio_data_mrr(0,radio_tx_prefix,radio_tx_data);
    radio_power_off();	

    if (exec_count_irq < radio_tx_num){
        // set timer
        set_wakeup_timer (wakeup_timer_val, 0x1, 0x1);
        // go to sleep and wake up with same condition
        operation_sleep_noirqreset();

    }else{
        exec_count_irq = 0;
        // Go to sleep without timer
        //operation_sleep_notimer();
    }
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

    // Initialization
    if(enumerated != ENUMID) {
        operation_init();

        // BREAKPOINT 0x01
        mbus_write_message32(0xBA, 0x01);

        //operation_sleep_notimer();
    }

    // FLASH_turn_on();

    // check if wakeup is due to GOC
    if((*SREG_WAKEUP_SOURCE) & 1) {

        wakeup_data = *GOC_DATA_IRQ;
        mbus_write_message32(0xAD, wakeup_data);
        wakeup_data_header = (wakeup_data >> 24) & 0xFF;
        uint32_t wakeup_data_field_0 = wakeup_data & 0xFF;
        uint32_t wakeup_data_field_1 = (wakeup_data >> 8) & 0xFF;
        uint32_t wakeup_data_field_2 = (wakeup_data >> 16) & 0xFF;

        // In case GOC triggered in the middle of routines
        if ((wakeup_data_header != 0) && (exec_count_irq == 0)){
            operation_goc_trigger_init();
        }

        if(wakeup_data_header == 0x01) {
            if(snt_state == SNT_IDLE) {
                // For testing
                // Take a manual temp measurement
                do {
                    operation_temp_run();
                } while(!temp_data_valid);

                mbus_write_message32(0xAB, temp_data);
            }

        }
        else if(wakeup_data_header == 0x02) {
            if(flp_state == FLP_OFF) {
                // Erase flash
                FLASH_turn_on();
                FLASH_erase_all();
                FLASH_turn_off();
            }

        }
        else if(wakeup_data_header == 0x03) {
            // Store 1 32-bit word in flash
            // Needs 3 GOCEP interrupts
            mbus_write_message32(0xED, goc_state);
            if(goc_state == GOC_IDLE) {
                flash_addr = wakeup_data & 0x7FFF;
                goc_state = GOC_FLASH_WRITE1;
            }
            else if(goc_state == GOC_FLASH_WRITE1) {
                flash_data = (wakeup_data & 0xFFFF) << 16;
                goc_state = GOC_FLASH_WRITE2;
            }
            else if(goc_state == GOC_FLASH_WRITE2) {
                flash_data |= (wakeup_data & 0xFFFF);
                uint32_t temp_arr[1] = { flash_data };

                if(flp_state == FLP_OFF) {
                    FLASH_turn_on();
                    FLASH_write_to_SRAM_bulk((uint32_t*) 0x000, temp_arr, 0);
                    copy_mem_from_SRAM_to_FLASH(0x000, flash_addr, 0);
                    FLASH_turn_off();
                    /*
                       copy_mem_from_FLASH_to_SRAM(0x000, flash_addr, 0);
                       FLASH_turn_off();
                       FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, temp_arr, 0);
                       delay(MBUS_DELAY);

                       mbus_write_message32(0xC1, *temp_arr);
                       delay(MBUS_DELAY);
                       mbus_write_message32(0xC1, flash_addr);
                       delay(MBUS_DELAY);
                       */
                }

                goc_state = GOC_IDLE;
            }
        }
        else if(wakeup_data_header == 0x04) {
            // Read an array from flash
            // Needs 2 GOCEP interrupts
            mbus_write_message32(0xED, goc_state);
            if(goc_state == GOC_IDLE) {
                flash_addr = wakeup_data & 0x7FFF;
                goc_state = GOC_FLASH_READ1;
            }
            else if(goc_state == GOC_FLASH_READ1) {
                uint32_t len_min_one = wakeup_data & 0xFF;
                uint32_t temp_arr[256];

                if(flp_state == FLP_OFF) {
                    FLASH_turn_on();
                    copy_mem_from_FLASH_to_SRAM(0x000, flash_addr, 
                            len_min_one);
                    FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, temp_arr,
                            len_min_one);
                    FLASH_turn_off();
                }
                uint32_t i;
                for(i = 0; i <= len_min_one; ++i) {
                    mbus_write_message32(0xC1, temp_arr[i]);
                }

                goc_state = GOC_IDLE;
            }
        }
        else if(wakeup_data_header == 0x05) {
            // Take a temp measurement every 5 secs
            // Store data into flash after 10 measurements
            if(goc_state == GOC_IDLE) {
                goc_temp_test_len = wakeup_data & 0xFF;
                goc_temp_test_count = 0;
                goc_state = GOC_TEMP_TEST;
                //set_wakeup_timer_prev17(10, 1, 1);
                set_xo_timer(0, 32900, 1, 0);
                start_xo_cnt();
                operation_sleep();
            }
        }
        // ERASE BEFORE REWRITE
        else if(wakeup_data_header == 0x06) {
            if(flp_state == FLP_OFF) {
                flash_addr = wakeup_data & 0x7FFF;
                FLASH_turn_on();
                FLASH_erase_page(flash_addr);
                FLASH_turn_off();
            }
        }
        else if(wakeup_data_header == 0x07) {
            // pmu_adc_read_latest();
            // mbus_write_message32(0xB1, read_data_batadc);
            // mbus_write_message32(0xB2, read_data_batadc_diff);
        }
        else if(wakeup_data_header == 0x08) {
            // pmu_adc_read_latest();
            // mbus_write_message32(0xB1, read_data_batadc);

            // // Update 4P2 voltage reference
            // if(wakeup_data_field_0 == 0) {
            //     PMU_ADC_4P2_VAL = read_data_batadc;
            // }
            // else {
            //     PMU_ADC_4P2_VAL = wakeup_data_field_0;
            // }
        }
        else if(wakeup_data_header == 0x09) {
            // pmu_setting_state = wakeup_data_field_0 & 0x7;
            // pmu_setting_temp_based();
            // // FLASH_init();
        }
        else if(wakeup_data_header == 0x10) {
            // uint8_t temp_r = wakeup_data_field_0;
            // pmu_setting_state = wakeup_data_field_1;
            // pmu_setting_temp_based_with_active_r(temp_r);
            // // FLASH_init();
        }
        else if(wakeup_data_header == 0x11) {
            // uint8_t temp_r = wakeup_data_field_0;
            // pmu_setting_state = wakeup_data_field_1;
            // pmu_setting_temp_based_with_sleep_r(temp_r);
            // // FLASH_init();
        }
        else if(wakeup_data_header == 0x12) {
            // test flash routine
            flash_addr = wakeup_data & 0x7FFF;
            uint32_t data_arr[40], read_data[40];

            FLASH_turn_on();
            FLASH_erase_page(flash_addr);
            FLASH_erase_page(flash_addr + 0x100);
            FLASH_turn_off();

            FLASH_turn_on();
            copy_mem_from_FLASH_to_SRAM(0, flash_addr, 39);
            FLASH_turn_off();

            FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, data_arr, 39);
            delay(MBUS_DELAY);

            uint8_t i = 0;
            for(i = 0; i < 40; i++) {
                mbus_write_message32(0xC1, data_arr[i]);
                data_arr[i] = 0x12345 + i;
            }

            FLASH_write_to_SRAM_bulk((uint32_t*) 0x000, data_arr, 39);
            FLASH_turn_on();
            copy_mem_from_SRAM_to_FLASH(0x000, flash_addr, 39);
            FLASH_turn_off();

            delay(10000);

            FLASH_turn_on();
            copy_mem_from_FLASH_to_SRAM(0, flash_addr, 39);
            FLASH_turn_off();
            FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, read_data, 39);
            delay(MBUS_DELAY);

            for(i = 0; i < 40; i++) {
                mbus_write_message32(0xC1, read_data[i]);
            }
        }
        else if(wakeup_data_header == 0x13) {
            // write to one of the PMU converters frequency registers
            // wakeup_data[3:0] is the R parameter
            // wakeup_data[7:4] is the L parameter
            // wakeup_data[12:8] is the base parameter
            // wakeup_data[13] selects SAR converter
            // wakeup_data[14] selects downconverter
            // wakeup_data[15] selects upconverter
            if(wakeup_data_field_1 & 0x20)
                pmu_set_active_clk_sar(wakeup_data_field_0 & 0x0F, (wakeup_data_field_0 >> 4) & 0x0F, wakeup_data_field_1 & 0x1F);
            else if(wakeup_data_field_1 & 0x40)
                pmu_set_active_clk_0p6(wakeup_data_field_0 & 0x0F, (wakeup_data_field_0 >> 4) & 0x0F, wakeup_data_field_1 & 0x1F);
            else if(wakeup_data_field_1 & 0x80)
                pmu_set_active_clk_3p6(wakeup_data_field_0 & 0x0F, (wakeup_data_field_0 >> 4) & 0x0F, wakeup_data_field_1 & 0x1F); 
            delay(MBUS_DELAY);
        }
        else if(wakeup_data_header == 0x14) {
            // Terase idle time
            mbus_remote_register_write(FLP_ADDR, 0x02, wakeup_data & 0xFFFFFF); 
        }
        else if(wakeup_data_header == 0x15) {
            // Tcap 
            mbus_remote_register_write(FLP_ADDR, 0x05, wakeup_data & 0xFFFFFF); 
        }
        else if(wakeup_data_header == 0x16) {
            // Tref 
            mbus_remote_register_write(FLP_ADDR, 0x06, wakeup_data & 0xFFFFFF); 
        }
        else if(wakeup_data_header == 0x17) {
            // Voltage Clamper Tuning
            mbus_remote_register_write(FLP_ADDR, 0x19, wakeup_data & 0xFFFFFF); 
        }
        else if(wakeup_data_header == 0x18) {
            int i;
            for(i = 0; i < 256; i++) {
                flash_test_data_arr[i] = 0;
            }
        }
        else if(wakeup_data_header == 0x19) {
            int len = wakeup_data & 0xFF;
            FLASH_write_to_SRAM_bulk((uint32_t*) 0x000, flash_test_data_arr, len);
            FLASH_turn_on();
            copy_mem_from_SRAM_to_FLASH(0x000, 0x0000, len);
            FLASH_turn_off();
            delay(MBUS_DELAY);
        }
        else if(wakeup_data_header == 0x20) {
            int len = wakeup_data & 0xFF;
            FLASH_turn_on();
            copy_mem_from_FLASH_to_SRAM(0, 0x0000, len);
            FLASH_turn_off();
            FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, flash_test_data_arr, len);
            delay(MBUS_DELAY);
        }
        else if(wakeup_data_header == 0x21) {
            int len = wakeup_data & 0xFF;
            FLASH_write_to_SRAM_bulk((uint32_t*) 0x000, flash_test_data_arr, len);
            delay(MBUS_DELAY);
        }
        else if(wakeup_data_header == 0x22) {
            int len = wakeup_data & 0xFF;
            FLASH_turn_on();
            copy_mem_from_SRAM_to_FLASH(0x000, 0x0000, len);
            FLASH_turn_off();
            delay(MBUS_DELAY);
        }
        else if(wakeup_data_header == 0x23) {
            int len = wakeup_data & 0xFF;
            FLASH_turn_on();
            copy_mem_from_FLASH_to_SRAM(0, 0x0000, len);
            FLASH_turn_off();
            delay(MBUS_DELAY);
        }
        else if(wakeup_data_header == 0x24) {
            int len = wakeup_data & 0xFF;
            FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, flash_test_data_arr, len);
            delay(MBUS_DELAY);
        }
        else if(wakeup_data_header == 0x25) {
            // Transmit something via radio and go to sleep w/o timer
            // wakeup_data[7:0] is the # of transmissions
            // wakeup_data[15:8] is the user-specified period
            // wakeup_data[23:16] is the MSB of # of transmissions
            operation_goc_trigger_radio(wakeup_data_field_0 + (wakeup_data_field_2<<8), wakeup_data_field_1, 0x4, 0x1817FADE);
        }
        mbus_write_message32(0xE2, goc_state);
    }

    if(*SREG_WAKEUP_SOURCE == 4) { // XO timer
        if(goc_state == GOC_TEMP_TEST) {
            sensor_queue |= 0b010;
        }
    }


    // testing XOT
    // set_xo_timer(0, 0x8888, 1, 0);
    // start_xo_cnt();
    // operation_sleep();
    // while(1);

    mbc_state = MBC_READY;

    // Finite state machine
    while(1) {

        mbus_write_message32(0xED, mbc_state);



        if(mbc_state == MBC_READY) {
            if(sensor_queue & 0b001) {
                // LNT
                sensor_queue &= 0b110;
                continue;
            }
            else if(sensor_queue & 0b010) {
                mbc_state = MBC_TEMP_READ;
                sensor_queue &= 0b101;
                continue;
            }
            else if(sensor_queue & 0b100) {
                // RDC
                sensor_queue &= 0b011;
                continue;
            }
            mbc_state = MBC_IDLE;
        }
        else if(mbc_state == MBC_TEMP_READ) {
            do {
                operation_temp_run();
            } while(!temp_data_valid);

            mbus_write_message32(0xDD, temp_data);

            if(goc_state == GOC_TEMP_TEST) {
                mbus_write_message32(0xBC, goc_temp_test_count);
                goc_temp_arr[goc_temp_test_count] = temp_data;
                ++goc_temp_test_count;

                if(goc_temp_test_count < goc_temp_test_len) {
                    // set_wakeup_timer() NOT WORKING
                    // set_wakeup_timer_prev17(10, 1, 1);
                    set_xo_timer(0, 32900, 1, 0);
                    start_xo_cnt();
                }
                else {
                    uint32_t i;
                    for(i = 0; i < goc_temp_test_len; i++) {
                        mbus_write_message32(0xEE, goc_temp_arr[i]);
                    }
                    FLASH_turn_on();
                    FLASH_erase_page(0x000);
                    FLASH_turn_off();
                    FLASH_turn_on();
                    // delay(60000);
                    FLASH_write_to_SRAM_bulk((uint32_t*) 0x000, goc_temp_arr, goc_temp_test_len - 1);
                    // delay(10000);
                    // FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, goc_temp_arr, goc_temp_test_len - 1);
                    // delay(10000);
                    copy_mem_from_SRAM_to_FLASH(0x000, 0x000, goc_temp_test_len - 1);
                    // delay(10000);
                    //copy_mem_from_FLASH_to_SRAM(0x000, 0x000, goc_temp_test_len - 1);
                    //delay(10000);
                    //FLASH_read_from_SRAM_bulk((uint32_t*) 0x000, goc_temp_arr, goc_temp_test_len - 1);
                    //delay(10000);
                    FLASH_turn_off();
                    goc_state = GOC_IDLE;

                }
            }

            mbc_state = MBC_READY;
        }
        else if(mbc_state == MBC_IDLE) {
            // Go to sleep and wait for next wakeup
            // reading out LNT value to MBUS before sleep

            //read_data_lnt = *REG0;
            //mbus_write_message32(0xFA, read_data_lnt);

            //lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
            //mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
            //delay(MBUS_DELAY*10);
            //lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
            //mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
            //delay(MBUS_DELAY*100);

            mbus_write_message32(0xAA, 0XAAAAAAAA);
            operation_sleep();
        }
        else {
            // Should not get here
            // State not defined; go to sleep
            mbus_write_message32(0xBA, 0XDEADBEEF);
            operation_sleep_notimer();
        }

    }

    // Should not get here
    operation_sleep_notimer();

    while(1);
}

