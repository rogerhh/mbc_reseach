/******************************************************************************************
 * Author:      Roger Hsiao
 * Description: Monarch butterfly challenge code
 *                                          - PREv17 / PMUv4 / SNT / FLP
 ******************************************************************************************
 * v1: draft version; not tested on chip
 *
 ******************************************************************************************/

#include "../include/PREv18.h"
#include "../include/SNTv4_RF.h"
#include "../include/mbus.h"

// uncomment this for debug mbus message
//#define DEBUG_MBUS_MSG
// uncomment this for debug radio message
//#define DEBUG_RADIO_MSG

// Stack order: SNT->FLP
#define PRE_ADDR 0x1
#define SNT_ADDR 0x4
#define FLP_ADDR 0x5

// Temp sensor parameters
#define MBUS_DELAY 100      // Amount of delay between successive messages; 100: 6-7ms

// MBC states
#define MBC_IDLE       0x0
#define MBC_SNT_LDO    0x1
#define MBC_TEMP_START 0x2
#define MBC_TEMP_READ  0x3
#define MBC_TEMP_END   0x4

// CP parameters
#define TIMERWD_VAL 0xFFFFF  // 0xFFFFF about 13 sec with Y5 running default clock (PRCv17)
#define TIMER32_VAL 0x20000  // 0x20000 about 1 sec with Y5 run default clock (PRCv17)

#define ENUMID 0xDEADBEEF

/**********************************************
 * Global variables
 **********************************************
 * "static" limits the variables to this file, giving the compiler more freedom
 * "volatile" should only be used for MMIO to ensure memory storage
 */
volatile uint32_t enumerated;
volatile uint32_t wakeup_data;
volatile uint32_t wfi_timeout_flag;
volatile uint32_t mbc_state;

// default register values
volatile prev18_r0B_t prev18_r0B = PREv18_R0B_DEFAULT;
volatile prev18_r19_t prev18_r19 = PREv18_R19_DEFAULT;
volatile prev18_r1A_t prev18_r1A = PREv18_R1A_DEFAULT;
volatile prev18_r1C_t prev18_r1C = PREv18_R1C_DEFAULT;

volatile sntv4_r00_t sntv4_r00 = SNTv4_R00_DEFAULT;
volatile sntv4_r01_t sntv4_r01 = SNTv4_R01_DEFAULT;
volatile sntv4_r07_t sntv4_r07 = SNTv4_R07_DEFAULT;


/**********************************************
 * XO Functions
 **********************************************/

// write to XO driver 0x19
/*
void XO_ctrl(uint32_t xo_sleep,
             uint32_t xo_isolate,
             uint32_t xo_en_div,
             uint32_t xo_s,
             uint32_t xo_sel_cp_div,
             uint32_t xo_delay_en,
             uint32_t xo_drv_start_up,
             uint32_t xo_drv_core,
             uint32_t xo_rp_low,
             uint32_t xo_rp_media,
             uint32_t xo_rp_mvt) {
            
    *REG_XO_CONTROL = ((xo_pulse_sel     << 11) |
                       (xo_delay_en      << 8)  |
                       (xo_drv_start_up  << 7)  |
                       (xo_drv_core      << 6)  |
                       (xo_rp_low        << 5)  |
                       (xo_rp_media      << 4)  |
                       (xo_rp_mvt        << 3)  |
                       (xo_rp_svt        << 2)  |
                       (xo_scn_clk_sel   << 1)  |
                       (xo_scn_enb       << 0));
    mbus_write_message32(0xA1, *REG_XO_CONTROL);
}
*/

void xo_init( void ) {
    // Parasitic capacitance tuning (6 bits for each; each 1 adds 1.8pF)
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    prev18_r1A.XO_CAP_TUNE = ((xo_cap_drv << 6) | (xo_cap_in << 0));    // XO_CLK output pad
    *REG_XO_CONF2 = prev18_r1A.as_int;

    // XO xonfiguration
    prev18_r19.XO_EN_DIV     = 0x1; // divider enable
    prev18_r19.XO_S          = 0x1; // division ration for 16kHz out
    prev18_r19.XO_SEL_CP_DIV = 0x0; // 1: 0.3V-generation charge-pump uses divided clock
    prev18_r19.XO_EN_OUT     = 0x1; // XO output enable
    prev18_r19.XO_PULSE_SEL  = 0x4; // pulse with sel, 1-hot encoded
    prev18_r19.XO_DELAY_EN   = 0x3; // pair usage together with xo_pulse_sel
    // Pseudo-Resistor selection
    prev18_r19.XO_RP_LOW     = 0x0;
    prev18_r19.XO_RP_MEDIA   = 0x1;
    prev18_r19.XO_RP_MVT     = 0x0;
    prev18_r19.XO_RP_SVT     = 0x0;

    prev18_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev18_r19.as_int;
    delay(100); // 1ms

    prev18_r19.XO_ISOLATE      = 0x0;
    *REG_XO_CONF1 = prev18_r19.as_int;
    delay(100); 

    prev18_r19.XO_DRV_START_UP = 0x1;
    *REG_XO_CONF1 = prev18_r19.as_int;
    delay(2000); // 1s

    prev18_r19.XO_SCN_CLK_SEL = 0x1;
    *REG_XO_CONF1 = prev18_r19.as_int;
    delay(2000); // 300us

    prev18_r19.XO_SCN_CLK_SEL = 0x0;
    prev18_r19.XO_SCN_ENB     = 0x0;
    *REG_XO_CONF1 = prev18_r19.as_int;
    delay(2000); // 1s

    prev18_r19.XO_DRV_START_UP = 0x0;
    prev18_r19.XO_DRV_CORE     = 0x1;
    prev18_r19.XO_SCN_CLK_SEL  = 0x1;
    *REG_XO_CONF1 = prev18_r19.as_int;
    
    enable_xo_timer();
    // TODO: Not needed? Takes power
    start_xo_cout();

    // BREAKPOINT 0x03
    mbus_write_message32(0xBA, 0x03);

}

void xo_turn_off( void ) {
    prev18_r19.XO_DRV_CORE = 0x0;
    prev18_r19.XO_SCN_ENB  = 0x1;
    *REG_XO_CONF1 = prev18_r19.as_int;
}

// Sleep xo driver to save power
void xo_sleep( void ) {
    prev18_r19.XO_SLEEP    = 0x0;
    prev18_r19.XO_ISOLATE  = 0x1;
    *REG_XO_CONF1 = prev18_r19.as_int;
}

/*
static void XO_div(uint32_t div_val) {
    uint32_t xo_cap_drv = 0x3F; // Additional cap on OSC_DRV
    uint32_t xo_cap_in  = 0x3F; // Additional cap on OSC_IN
    *REG_XO_CONFIG = ((div_val      << 16)  |
                      (xo_cap_drv   << 6)   |
                      (xo_cap_in    << 0));
}

static void XO_init( void ) {
    
    // XO_CLK output pad (0: Disabled; 1: 32kHz; 2: 16kHz; 3: 8kHz)
    uint32_t xot_clk_out_sel = 0x1;
    // Parasitic capacitance tuning (6-bit for each; each one adds 1.8pF)
    uint32_t xo_cap_drv = 0x3F; // Additional cap on OSC_DRV
    uint32_t xo_cap_in  = 0x3F; // Additional cap on OSC_IN

    // Pulse length selection
    uint32_t xo_pulse_sel = 0x4;    // XO_PULSE_SEL
    uint32_t xo_delay_en  = 0x3;    // XO_DELAY_EN

    // Pseudo-resisitor selection
    uint32_t xo_rp_low   = 0x0;
    uint32_t xo_rp_media = 0x0;
    uint32_t xo_rp_mvt   = 0x1;
    uint32_t xo_rp_svt   = 0x0;

    // Parasitic capacitance tuning
    *REG_XO_CONFIG = ((xot_clk_out_sel << 16) |
                      (xo_cap_drv      << 6)  |
                      (xo_cap_in       << 0));

    // Start XO clock
    // XO_ctrl(xo_pulse_sel, xo_delay_en, xo_drv_start_up, xo_drv_core, xo_rp_low, 
    //         xo_rp_media, xo_rp_mvt, xo_rp_svt, xo_scn_clk_sel, xo_scn_enb);
    XO_ctrl(xo_pulse_sel, xo_delay_en, 1, 0, xo_rp_low, xo_rp_media, xo_rp_mvt, xo_rp_svt, 0, 
            1); delay(10000); // XO_DRV_START_UP = 1
    XO_ctrl(xo_pulse_sel, xo_delay_en, 1, 0, xo_rp_low, xo_rp_media, xo_rp_mvt, xo_rp_svt, 1, 
            1); delay(10000); // XO_SCN_CLK_SEL  = 1
    XO_ctrl(xo_pulse_sel, xo_delay_en, 1, 0, xo_rp_low, xo_rp_media, xo_rp_mvt, xo_rp_svt, 0, 
            0); delay(10000); // XO_SCN_CLK_SEL  = 1; XO_SCN_ENB  = 1
    XO_ctrl(xo_pulse_sel, xo_delay_en, 0, 1, xo_rp_low, xo_rp_media, xo_rp_mvt, xo_rp_svt, 1,
            0); delay(10000); // XO_DRV_START_UP = 0; XO_DRV_CORE = 1; XO_SCN_CLK_SEL = 1
}
*/

/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/
static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
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

/**********************************************
 * Flash Functions
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
    mbus_remote_register_write (FLP_ADDR, 0x26, 0x0D7788); // Program Current
    mbus_remote_register_write (FLP_ADDR, 0x27, 0x011BC8); // Erase Pump Diode Chain
    mbus_remote_register_write (FLP_ADDR, 0x01, 0x000109); // Tprog idle time
    mbus_remote_register_write (FLP_ADDR, 0x19, 0x000F03); // Voltage Clamper Tuning
    mbus_remote_register_write (FLP_ADDR, 0x0F, 0x001001); // Flash interrupt target register addr: REG0 -> REG1
    //mbus_remote_register_write (FLP_ADDR, 0x12, 0x000003); // Auto Power On/Off

}

void FLASH_turn_on() {
    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x11, 0x00002D);
    set_halt_until_mbus_tx();

    if(*REG1 != 0xBB) { flp_fail(1); }
}

inline void FLASH_write_to_SRAM_bulk(uint32_t* remote_addr, 
                                     uint32_t* local_addr, 
                                     uint32_t length_in_words_minus_one) {
    mbus_copy_mem_from_local_to_remote_bulk(FLP_ADDR, remote_addr, local_addr, 
                                            length_in_words_minus_one);
}

inline void FLASH_read_from_SRAM_bulk(uint32_t* remote_addr,
                                      uint32_t* local_addr,
                                      uint32_t length_in_words_minus_one) {
    mbus_copy_mem_from_remote_to_any_bulk(FLP_ADDR, remote_addr, PRE_ADDR, local_addr,
                                          length_in_words_minus_one);
}

void copy_mem_from_SRAM_to_FLASH(uint32_t SRAM_addr, 
                                 uint32_t FLASH_addr, 
                                 uint32_t length_in_words_minus_one) {
    mbus_remote_register_write(FLP_ADDR, 0x07, SRAM_addr);
    mbus_remote_register_write(FLP_ADDR, 0x08, FLASH_addr);

    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x09, (length_in_words_minus_one << 6) |
                                               (0x1 << 5) |
                                               (0x2 << 1) |
                                               (0x1 << 0));
    set_halt_until_mbus_tx();

    if(*REG1 != 0x00003F) { flp_fail(2); }
}

void copy_mem_from_FLASH_to_SRAM(uint32_t SRAM_addr, 
                                 uint32_t FLASH_addr,
                                 uint32_t length_in_words_minus_one) {
    mbus_remote_register_write(FLP_ADDR, 0x07, SRAM_addr);
    mbus_remote_register_write(FLP_ADDR, 0x08, FLASH_addr);

    set_halt_until_mbus_trx();
    mbus_remote_register_write(FLP_ADDR, 0x09, (length_in_words_minus_one << 6) |
                                               (0x1 << 5) |
                                               (0x1 << 1) |
                                               (0x1 << 0));
    set_halt_until_mbus_tx();

    if(*REG1 != 0x00002B) { flp_fail(3); }
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
    mbus_write_message32(0xAA, *SREG_WAKEUP_SOURCE);
}

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
/*
    *REG1 = *TIMER32_CNT;
    *REG2 = *TIMER32_STAT;
*/
    *TIMER32_STAT = 0x0;
    wfi_timeout_flag = 1;
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

void handler_ext_int_gocep( void ) { // GOCEP
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
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
 * End of program sleep operation
 **********************************************/

static void operation_init( void ) {
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer

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

    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    // Enumeration
    enumerated = ENUMID;
    mbus_enumerate(SNT_ADDR);
    mbus_enumerate(FLP_ADDR);
    delay(MBUS_DELAY);

    // Default CPU halt function
    set_halt_until_mbus_tx();

    wakeup_data = 0;
    wfi_timeout_flag = 0;
    mbc_state = MBC_IDLE;

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);

    xo_init();

    // Initialization
    // FLASH_init()
    
    operation_sleep_notimer();
}

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ICER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_REG0 | 
                  1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3);

    // BREAKPOINT 0x00
    mbus_write_message32(0xBA, 0x00);

    // Initialization
    if(enumerated != ENUMID) {
        operation_init();
        
        // BREAKPOINT 0x01
        mbus_write_message32(0xBA, 0x01);
    }

    // GOCEP triggered wakeup
    if(*SREG_WAKEUP_SOURCE == 0)
    {
        wakeup_data = *GOC_DATA_IRQ;
        uint32_t wakeup_data_header = (wakeup_data >> 24) & 0xFF;
        uint32_t wakeup_data_field_0 = wakeup_data & 0xFF;
        uint32_t wakeup_data_field_1 = (wakeup_data >> 8) & 0xFF;
        uint32_t wakeup_data_field_2 = (wakeup_data >> 16) & 0xFF;
            
        // For testing
        if(wakeup_data_header == 0x01) {
            if(mbc_state == MBC_IDLE) {
                mbc_state = MBC_SNT_LDO;
            }
        }
    }

    // Finite state machine
    while(1) {

    mbus_write_message32(0xBA, mbc_state);
    
    if(mbc_state == MBC_SNT_LDO) {
        mbc_state = MBC_TEMP_START;

        // Turn on SNT LDO VREF; requires ~30 ms to settle
        // TODO: Figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);

        // Power on SNT LDO
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);
    }
    else if(mbc_state == MBC_TEMP_START) {
        mbc_state = MBC_TEMP_READ;

        // Use Timer32 as a timeout counter
        wfi_timeout_flag = 0;
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or Timer32
        WFI();

        // Turn off Timer32
        *TIMER32_GO = 0;
    }
    else if(mbc_state == MBC_TEMP_READ) {
        if(wfi_timeout_flag) {
            // if timeout, measure again
            mbus_write_message32(0xFA, 0xFAFAFAFA);
        }
        else {
            mbc_state = MBC_IDLE;

            // Output measure value for now
            // TODO: Verify value measured
            mbus_write_message32(0xAB, *REG7);
            
            // Turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();
        }
    }
    else if(mbc_state == MBC_IDLE) {
        // Go to sleep and wait for next wakeup
        operation_sleep_notimer();
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
