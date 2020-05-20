
mbc_code_v4_xo_wakeup/mbc_code_v4_xo_wakeup.elf:     file format elf32-littlearm


Disassembly of section .text:

00000000 <hang-0x90>:
   0:	00002000 	.word	0x00002000
   4:	000000a1 	.word	0x000000a1
	...
  10:	00000090 	.word	0x00000090
  14:	00000090 	.word	0x00000090
  18:	00000090 	.word	0x00000090
  1c:	00000090 	.word	0x00000090
  20:	00000090 	.word	0x00000090
  24:	00000090 	.word	0x00000090
  28:	00000090 	.word	0x00000090
  2c:	00000000 	.word	0x00000000
  30:	00000090 	.word	0x00000090
  34:	00000090 	.word	0x00000090
	...
  40:	000005b9 	.word	0x000005b9
  44:	00000000 	.word	0x00000000
  48:	00000641 	.word	0x00000641
  4c:	00000665 	.word	0x00000665
	...
  60:	00000699 	.word	0x00000699
  64:	000006a9 	.word	0x000006a9
  68:	000006b9 	.word	0x000006b9
  6c:	000006c9 	.word	0x000006c9
	...
  8c:	00000685 	.word	0x00000685

00000090 <hang>:
  90:	e7fe      	b.n	90 <hang>
	...

000000a0 <_start>:
  a0:	f000 fb1a 	bl	6d8 <main>
  a4:	e7fc      	b.n	a0 <_start>

Disassembly of section .text.delay:

000000a6 <delay>:

//*******************************************************************
// OTHER FUNCTIONS
//*******************************************************************

void delay(unsigned ticks){
  a6:	b500      	push	{lr}
  unsigned i;
  for (i=0; i < ticks; i++)
  a8:	2300      	movs	r3, #0
  aa:	e001      	b.n	b0 <delay+0xa>
    asm("nop;");
  ac:	46c0      	nop			; (mov r8, r8)
// OTHER FUNCTIONS
//*******************************************************************

void delay(unsigned ticks){
  unsigned i;
  for (i=0; i < ticks; i++)
  ae:	3301      	adds	r3, #1
  b0:	4283      	cmp	r3, r0
  b2:	d1fb      	bne.n	ac <delay+0x6>
    asm("nop;");
}
  b4:	bd00      	pop	{pc}

Disassembly of section .text.WFI:

000000b6 <WFI>:

void WFI(){
  asm("wfi;");
  b6:	bf30      	wfi
}
  b8:	4770      	bx	lr

Disassembly of section .text.config_timer32:

000000bc <config_timer32>:
	*TIMER16_CNT   = cnt;
	*TIMER16_STAT  = status;
	*TIMER16_GO    = 0x1;
}

void config_timer32(uint32_t cmp, uint8_t roi, uint32_t cnt, uint32_t status){
  bc:	b530      	push	{r4, r5, lr}
	*TIMER32_GO   = 0x0;
  be:	4c07      	ldr	r4, [pc, #28]	; (dc <config_timer32+0x20>)
  c0:	2500      	movs	r5, #0
  c2:	6025      	str	r5, [r4, #0]
	*TIMER32_CMP  = cmp;
  c4:	4d06      	ldr	r5, [pc, #24]	; (e0 <config_timer32+0x24>)
  c6:	6028      	str	r0, [r5, #0]
	*TIMER32_ROI  = roi;
  c8:	4806      	ldr	r0, [pc, #24]	; (e4 <config_timer32+0x28>)
  ca:	6001      	str	r1, [r0, #0]
	*TIMER32_CNT  = cnt;
  cc:	4906      	ldr	r1, [pc, #24]	; (e8 <config_timer32+0x2c>)
  ce:	600a      	str	r2, [r1, #0]
	*TIMER32_STAT = status;
  d0:	4a06      	ldr	r2, [pc, #24]	; (ec <config_timer32+0x30>)
  d2:	6013      	str	r3, [r2, #0]
	*TIMER32_GO   = 0x1;
  d4:	2301      	movs	r3, #1
  d6:	6023      	str	r3, [r4, #0]
}
  d8:	bd30      	pop	{r4, r5, pc}
  da:	46c0      	nop			; (mov r8, r8)
  dc:	a0001100 	.word	0xa0001100
  e0:	a0001104 	.word	0xa0001104
  e4:	a0001108 	.word	0xa0001108
  e8:	a000110c 	.word	0xa000110c
  ec:	a0001110 	.word	0xa0001110

Disassembly of section .text.config_timerwd:

000000f0 <config_timerwd>:

void config_timerwd(uint32_t cnt){
	*TIMERWD_GO  = 0x0;
  f0:	4b03      	ldr	r3, [pc, #12]	; (100 <config_timerwd+0x10>)
  f2:	2200      	movs	r2, #0
  f4:	601a      	str	r2, [r3, #0]
	*TIMERWD_CNT = cnt;
  f6:	4a03      	ldr	r2, [pc, #12]	; (104 <config_timerwd+0x14>)
  f8:	6010      	str	r0, [r2, #0]
	*TIMERWD_GO  = 0x1;
  fa:	2201      	movs	r2, #1
  fc:	601a      	str	r2, [r3, #0]
}
  fe:	4770      	bx	lr
 100:	a0001200 	.word	0xa0001200
 104:	a0001204 	.word	0xa0001204

Disassembly of section .text.set_wakeup_timer:

00000108 <set_wakeup_timer>:

void enable_timerwd(){
	*TIMERWD_GO  = 0x1;
}

void set_wakeup_timer( uint32_t timestamp, uint8_t irq_en, uint8_t reset ){
 108:	b500      	push	{lr}
	uint32_t regval = timestamp;
	if( irq_en ) regval |= 0x800000; // IRQ in Sleep-Only
 10a:	2900      	cmp	r1, #0
 10c:	d003      	beq.n	116 <set_wakeup_timer+0xe>
 10e:	2380      	movs	r3, #128	; 0x80
 110:	041b      	lsls	r3, r3, #16
 112:	4318      	orrs	r0, r3
 114:	e001      	b.n	11a <set_wakeup_timer+0x12>
	else		 regval &= 0x3FFFFF;
 116:	0280      	lsls	r0, r0, #10
 118:	0a80      	lsrs	r0, r0, #10
    *REG_WUPT_CONFIG = regval;
 11a:	4b04      	ldr	r3, [pc, #16]	; (12c <set_wakeup_timer+0x24>)
 11c:	6018      	str	r0, [r3, #0]

	if( reset ) *WUPT_RESET = 0x01;
 11e:	2a00      	cmp	r2, #0
 120:	d002      	beq.n	128 <set_wakeup_timer+0x20>
 122:	4b03      	ldr	r3, [pc, #12]	; (130 <set_wakeup_timer+0x28>)
 124:	2201      	movs	r2, #1
 126:	601a      	str	r2, [r3, #0]
}
 128:	bd00      	pop	{pc}
 12a:	46c0      	nop			; (mov r8, r8)
 12c:	a0000044 	.word	0xa0000044
 130:	a0001300 	.word	0xa0001300

Disassembly of section .text.enable_xo_timer:

00000134 <enable_xo_timer>:

void enable_xo_timer () {
    uint32_t regval = *REG_XOT_CONFIG;
 134:	4b03      	ldr	r3, [pc, #12]	; (144 <enable_xo_timer+0x10>)
    regval |= 0x800000; // XOT_ENABLE = 1;
 136:	2280      	movs	r2, #128	; 0x80

	if( reset ) *WUPT_RESET = 0x01;
}

void enable_xo_timer () {
    uint32_t regval = *REG_XOT_CONFIG;
 138:	6819      	ldr	r1, [r3, #0]
    regval |= 0x800000; // XOT_ENABLE = 1;
 13a:	0412      	lsls	r2, r2, #16
 13c:	430a      	orrs	r2, r1
    *REG_XOT_CONFIG = regval;
 13e:	601a      	str	r2, [r3, #0]
}
 140:	4770      	bx	lr
 142:	46c0      	nop			; (mov r8, r8)
 144:	a000004c 	.word	0xa000004c

Disassembly of section .text.set_xo_timer:

00000148 <set_xo_timer>:
    uint32_t regval = *REG_XOT_CONFIG;
    regval &= 0x7FFFFF; // XOT_ENABLE = 0;
    *REG_XOT_CONFIG = regval;
}

void set_xo_timer (uint8_t mode, uint32_t timestamp, uint8_t wreq_en, uint8_t irq_en) {
 148:	b510      	push	{r4, lr}
    uint32_t regval0 = timestamp & 0x0000FFFF;
 14a:	b28c      	uxth	r4, r1
    uint32_t regval1 = (timestamp >> 16) & 0xFFFF;
 14c:	0c09      	lsrs	r1, r1, #16
    // uint32_t regval1 = timestamp & 0xFFFF0000;	// This is wrong

    regval0 |= 0x00800000; // XOT_ENABLE = 1;
    if (mode)    regval0 |= 0x00400000; // XOT_MODE = 1
 14e:	2800      	cmp	r0, #0
 150:	d101      	bne.n	156 <set_xo_timer+0xe>
void set_xo_timer (uint8_t mode, uint32_t timestamp, uint8_t wreq_en, uint8_t irq_en) {
    uint32_t regval0 = timestamp & 0x0000FFFF;
    uint32_t regval1 = (timestamp >> 16) & 0xFFFF;
    // uint32_t regval1 = timestamp & 0xFFFF0000;	// This is wrong

    regval0 |= 0x00800000; // XOT_ENABLE = 1;
 152:	2080      	movs	r0, #128	; 0x80
 154:	e000      	b.n	158 <set_xo_timer+0x10>
    if (mode)    regval0 |= 0x00400000; // XOT_MODE = 1
 156:	20c0      	movs	r0, #192	; 0xc0
 158:	0400      	lsls	r0, r0, #16
 15a:	4320      	orrs	r0, r4
    if (wreq_en) regval0 |= 0x00200000; // XOT_WREQ_EN = 1
 15c:	2a00      	cmp	r2, #0
 15e:	d002      	beq.n	166 <set_xo_timer+0x1e>
 160:	2280      	movs	r2, #128	; 0x80
 162:	0392      	lsls	r2, r2, #14
 164:	4310      	orrs	r0, r2
    if (irq_en)  regval0 |= 0x00100000; // XOT_IRQ_EN = 1
 166:	2b00      	cmp	r3, #0
 168:	d002      	beq.n	170 <set_xo_timer+0x28>
 16a:	2380      	movs	r3, #128	; 0x80
 16c:	035b      	lsls	r3, r3, #13
 16e:	4318      	orrs	r0, r3

    *REG_XOT_CONFIGU = regval1;
 170:	4b02      	ldr	r3, [pc, #8]	; (17c <set_xo_timer+0x34>)
 172:	6019      	str	r1, [r3, #0]
    *REG_XOT_CONFIG  = regval0;
 174:	4b02      	ldr	r3, [pc, #8]	; (180 <set_xo_timer+0x38>)
 176:	6018      	str	r0, [r3, #0]
}
 178:	bd10      	pop	{r4, pc}
 17a:	46c0      	nop			; (mov r8, r8)
 17c:	a0000050 	.word	0xa0000050
 180:	a000004c 	.word	0xa000004c

Disassembly of section .text.reset_xo_cnt:

00000184 <reset_xo_cnt>:

void reset_xo_cnt  () { *XOT_RESET_CNT  = 0x1; }
 184:	4b01      	ldr	r3, [pc, #4]	; (18c <reset_xo_cnt+0x8>)
 186:	2201      	movs	r2, #1
 188:	601a      	str	r2, [r3, #0]
 18a:	4770      	bx	lr
 18c:	a0001400 	.word	0xa0001400

Disassembly of section .text.start_xo_cnt:

00000190 <start_xo_cnt>:
void start_xo_cnt  () { *XOT_START_CNT  = 0x1; }
 190:	4b01      	ldr	r3, [pc, #4]	; (198 <start_xo_cnt+0x8>)
 192:	2201      	movs	r2, #1
 194:	601a      	str	r2, [r3, #0]
 196:	4770      	bx	lr
 198:	a0001404 	.word	0xa0001404

Disassembly of section .text.set_halt_until_mbus_tx:

0000019c <set_halt_until_mbus_tx>:
// MBUS IRQ SETTING
//**************************************************
void set_halt_until_reg(uint32_t reg_id) { *SREG_CONF_HALT = reg_id; }
void set_halt_until_mem_wr(void) { *SREG_CONF_HALT = HALT_UNTIL_MEM_WR; }
void set_halt_until_mbus_rx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_RX; }
void set_halt_until_mbus_tx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_TX; }
 19c:	4b01      	ldr	r3, [pc, #4]	; (1a4 <set_halt_until_mbus_tx+0x8>)
 19e:	2209      	movs	r2, #9
 1a0:	601a      	str	r2, [r3, #0]
 1a2:	4770      	bx	lr
 1a4:	a000a000 	.word	0xa000a000

Disassembly of section .text.set_halt_until_mbus_trx:

000001a8 <set_halt_until_mbus_trx>:
void set_halt_until_mbus_trx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_TRX; }
 1a8:	4b01      	ldr	r3, [pc, #4]	; (1b0 <set_halt_until_mbus_trx+0x8>)
 1aa:	220c      	movs	r2, #12
 1ac:	601a      	str	r2, [r3, #0]
 1ae:	4770      	bx	lr
 1b0:	a000a000 	.word	0xa000a000

Disassembly of section .text.mbus_write_message32:

000001b4 <mbus_write_message32>:
	// TODO: Read from LC
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
 1b4:	4b02      	ldr	r3, [pc, #8]	; (1c0 <mbus_write_message32+0xc>)
 1b6:	0100      	lsls	r0, r0, #4
 1b8:	4318      	orrs	r0, r3
    *((volatile uint32_t *) mbus_addr) = data;
 1ba:	6001      	str	r1, [r0, #0]
    return 1;
}
 1bc:	2001      	movs	r0, #1
 1be:	4770      	bx	lr
 1c0:	a0003000 	.word	0xa0003000

Disassembly of section .text.mbus_write_message:

000001c4 <mbus_write_message>:

uint32_t mbus_write_message(uint8_t addr, uint32_t data[], unsigned len) {
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;
 1c4:	2300      	movs	r3, #0
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
    return 1;
}

uint32_t mbus_write_message(uint8_t addr, uint32_t data[], unsigned len) {
 1c6:	b500      	push	{lr}
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;
 1c8:	429a      	cmp	r2, r3
 1ca:	d00a      	beq.n	1e2 <mbus_write_message+0x1e>

	*MBUS_CMD0 = (addr << 24) | (len-1);
 1cc:	4b06      	ldr	r3, [pc, #24]	; (1e8 <mbus_write_message+0x24>)
 1ce:	3a01      	subs	r2, #1
 1d0:	0600      	lsls	r0, r0, #24
 1d2:	4302      	orrs	r2, r0
 1d4:	601a      	str	r2, [r3, #0]
	*MBUS_CMD1 = (uint32_t) data;
 1d6:	4b05      	ldr	r3, [pc, #20]	; (1ec <mbus_write_message+0x28>)
	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x2 << 4);
 1d8:	2223      	movs	r2, #35	; 0x23
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;

	*MBUS_CMD0 = (addr << 24) | (len-1);
	*MBUS_CMD1 = (uint32_t) data;
 1da:	6019      	str	r1, [r3, #0]
	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x2 << 4);
 1dc:	4b04      	ldr	r3, [pc, #16]	; (1f0 <mbus_write_message+0x2c>)
 1de:	601a      	str	r2, [r3, #0]
 1e0:	2301      	movs	r3, #1

    return 1;
}
 1e2:	1c18      	adds	r0, r3, #0
 1e4:	bd00      	pop	{pc}
 1e6:	46c0      	nop			; (mov r8, r8)
 1e8:	a0002000 	.word	0xa0002000
 1ec:	a0002004 	.word	0xa0002004
 1f0:	a000200c 	.word	0xa000200c

Disassembly of section .text.mbus_enumerate:

000001f4 <mbus_enumerate>:

void mbus_enumerate(unsigned new_prefix) {
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
 1f4:	0603      	lsls	r3, r0, #24
 1f6:	2080      	movs	r0, #128	; 0x80
 1f8:	0580      	lsls	r0, r0, #22
 1fa:	4318      	orrs	r0, r3
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
 1fc:	4b01      	ldr	r3, [pc, #4]	; (204 <mbus_enumerate+0x10>)
 1fe:	6018      	str	r0, [r3, #0]
    return 1;
}

void mbus_enumerate(unsigned new_prefix) {
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
}
 200:	4770      	bx	lr
 202:	46c0      	nop			; (mov r8, r8)
 204:	a0003000 	.word	0xa0003000

Disassembly of section .text.mbus_sleep_all:

00000208 <mbus_sleep_all>:
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
 208:	4b01      	ldr	r3, [pc, #4]	; (210 <mbus_sleep_all+0x8>)
 20a:	2200      	movs	r2, #0
 20c:	601a      	str	r2, [r3, #0]
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
}

void mbus_sleep_all(void) {
    mbus_write_message32(MBUS_POWER, MBUS_ALL_SLEEP << 28);
}
 20e:	4770      	bx	lr
 210:	a0003010 	.word	0xa0003010

Disassembly of section .text.mbus_remote_register_write:

00000214 <mbus_remote_register_write>:

void mbus_remote_register_write(
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
 214:	b507      	push	{r0, r1, r2, lr}
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 216:	0212      	lsls	r2, r2, #8
 218:	0a12      	lsrs	r2, r2, #8
 21a:	0609      	lsls	r1, r1, #24
 21c:	4311      	orrs	r1, r2
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
 21e:	0100      	lsls	r0, r0, #4
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 220:	9101      	str	r1, [sp, #4]
	mbus_write_message(address, &data, 1);
 222:	b2c0      	uxtb	r0, r0
 224:	a901      	add	r1, sp, #4
 226:	2201      	movs	r2, #1
 228:	f7ff ffcc 	bl	1c4 <mbus_write_message>
}
 22c:	bd07      	pop	{r0, r1, r2, pc}

Disassembly of section .text.pmu_reg_write:

0000022e <pmu_reg_write>:


/**********************************************
 * PMU functions (PMUv11)
 **********************************************/
static void pmu_reg_write(uint32_t reg_addr, uint32_t reg_data) {
 22e:	b538      	push	{r3, r4, r5, lr}
 230:	1c05      	adds	r5, r0, #0
 232:	1c0c      	adds	r4, r1, #0
    set_halt_until_mbus_trx();
 234:	f7ff ffb8 	bl	1a8 <set_halt_until_mbus_trx>
    mbus_remote_register_write(PMU_ADDR, reg_addr, reg_data);
 238:	b2e9      	uxtb	r1, r5
 23a:	2005      	movs	r0, #5
 23c:	1c22      	adds	r2, r4, #0
 23e:	f7ff ffe9 	bl	214 <mbus_remote_register_write>
    set_halt_until_mbus_tx();
 242:	f7ff ffab 	bl	19c <set_halt_until_mbus_tx>
}
 246:	bd38      	pop	{r3, r4, r5, pc}

Disassembly of section .text.pmu_set_active_clk:

00000248 <pmu_set_active_clk>:
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
*/
static void pmu_set_active_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 248:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 24a:	25c0      	movs	r5, #192	; 0xc0
                 (r <<  9) |    // frequency multiplier r
 24c:	0240      	lsls	r0, r0, #9
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 24e:	022d      	lsls	r5, r5, #8
 250:	4305      	orrs	r5, r0
                 (r <<  9) |    // frequency multiplier r
 252:	4315      	orrs	r5, r2
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 254:	015e      	lsls	r6, r3, #5
 256:	432e      	orrs	r6, r5
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 258:	9001      	str	r0, [sp, #4]
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
*/
static void pmu_set_active_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 25a:	1c0f      	adds	r7, r1, #0
    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 25c:	2016      	movs	r0, #22
 25e:	1c31      	adds	r1, r6, #0
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
*/
static void pmu_set_active_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 260:	1c14      	adds	r4, r2, #0
    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 262:	f7ff ffe4 	bl	22e <pmu_reg_write>
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 266:	1c31      	adds	r1, r6, #0
 268:	2016      	movs	r0, #22
 26a:	f7ff ffe0 	bl	22e <pmu_reg_write>
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 26e:	017f      	lsls	r7, r7, #5
 270:	1c29      	adds	r1, r5, #0
 272:	4339      	orrs	r1, r7
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
 274:	2018      	movs	r0, #24
 276:	f7ff ffda 	bl	22e <pmu_reg_write>

    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 27a:	9901      	ldr	r1, [sp, #4]
                 (base)));      // floor frequency base (0-63)

    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 27c:	4327      	orrs	r7, r4
                 (l <<  5) |    // frequency multiplier l
 27e:	4339      	orrs	r1, r7
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 280:	201a      	movs	r0, #26
 282:	f7ff ffd4 	bl	22e <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
 286:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.operation_sleep:

00000288 <operation_sleep>:

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
 288:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;

#ifdef USE_MRR
    if(radio_on) {
 28a:	4930      	ldr	r1, [pc, #192]	; (34c <operation_sleep+0xc4>)
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;
 28c:	238c      	movs	r3, #140	; 0x8c
 28e:	2500      	movs	r5, #0
 290:	601d      	str	r5, [r3, #0]

#ifdef USE_MRR
    if(radio_on) {
 292:	780b      	ldrb	r3, [r1, #0]
 294:	42ab      	cmp	r3, r5
 296:	d055      	beq.n	344 <operation_sleep+0xbc>

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 298:	4c2d      	ldr	r4, [pc, #180]	; (350 <operation_sleep+0xc8>)
 29a:	2701      	movs	r7, #1
 29c:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 29e:	2002      	movs	r0, #2

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 2a0:	43bb      	bics	r3, r7
 2a2:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 2a4:	6822      	ldr	r2, [r4, #0]
 2a6:	1c29      	adds	r1, r5, #0
 2a8:	f7ff ffb4 	bl	214 <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 2ac:	6823      	ldr	r3, [r4, #0]
 2ae:	227e      	movs	r2, #126	; 0x7e
 2b0:	4393      	bics	r3, r2
 2b2:	2220      	movs	r2, #32
 2b4:	4313      	orrs	r3, r2
 2b6:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 2b8:	6822      	ldr	r2, [r4, #0]
 2ba:	2002      	movs	r0, #2
 2bc:	1c29      	adds	r1, r5, #0
 2be:	f7ff ffa9 	bl	214 <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 2c2:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 2c4:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 2c6:	433b      	orrs	r3, r7
 2c8:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 2ca:	6822      	ldr	r2, [r4, #0]
 2cc:	1c29      	adds	r1, r5, #0
 2ce:	f7ff ffa1 	bl	214 <mbus_remote_register_write>

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 2d2:	4b20      	ldr	r3, [pc, #128]	; (354 <operation_sleep+0xcc>)
 2d4:	4a20      	ldr	r2, [pc, #128]	; (358 <operation_sleep+0xd0>)
 2d6:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 2d8:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 2da:	400a      	ands	r2, r1
 2dc:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 2de:	681a      	ldr	r2, [r3, #0]
 2e0:	2103      	movs	r1, #3
 2e2:	f7ff ff97 	bl	214 <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 2e6:	4b1d      	ldr	r3, [pc, #116]	; (35c <operation_sleep+0xd4>)
 2e8:	2104      	movs	r1, #4
 2ea:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 2ec:	2602      	movs	r6, #2

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 2ee:	438a      	bics	r2, r1
 2f0:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 2f2:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 2f4:	1c30      	adds	r0, r6, #0
    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 2f6:	43b2      	bics	r2, r6
 2f8:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 2fa:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 2fc:	2111      	movs	r1, #17
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 2fe:	433a      	orrs	r2, r7
 300:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 302:	681a      	ldr	r2, [r3, #0]
 304:	f7ff ff86 	bl	214 <mbus_remote_register_write>

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 308:	4c15      	ldr	r4, [pc, #84]	; (360 <operation_sleep+0xd8>)
 30a:	2208      	movs	r2, #8
 30c:	6823      	ldr	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 30e:	1c30      	adds	r0, r6, #0
    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 310:	4313      	orrs	r3, r2
 312:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
 314:	6823      	ldr	r3, [r4, #0]
 316:	2220      	movs	r2, #32
 318:	4393      	bics	r3, r2
 31a:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
 31c:	6823      	ldr	r3, [r4, #0]
 31e:	2210      	movs	r2, #16
 320:	4313      	orrs	r3, r2
 322:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 324:	6822      	ldr	r2, [r4, #0]
 326:	2104      	movs	r1, #4
 328:	f7ff ff74 	bl	214 <mbus_remote_register_write>

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 32c:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 32e:	1c30      	adds	r0, r6, #0
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 330:	43bb      	bics	r3, r7
 332:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 334:	6822      	ldr	r2, [r4, #0]
 336:	2104      	movs	r1, #4
 338:	f7ff ff6c 	bl	214 <mbus_remote_register_write>

    radio_on = 0;
 33c:	4b03      	ldr	r3, [pc, #12]	; (34c <operation_sleep+0xc4>)
 33e:	701d      	strb	r5, [r3, #0]
    radio_ready = 0;
 340:	4b08      	ldr	r3, [pc, #32]	; (364 <operation_sleep+0xdc>)
 342:	701d      	strb	r5, [r3, #0]
    if(radio_on) {
    	radio_power_off();
    }
#endif

    mbus_sleep_all();
 344:	f7ff ff60 	bl	208 <mbus_sleep_all>
 348:	e7fe      	b.n	348 <operation_sleep+0xc0>
 34a:	46c0      	nop			; (mov r8, r8)
 34c:	00001168 	.word	0x00001168
 350:	000010b8 	.word	0x000010b8
 354:	000010c0 	.word	0x000010c0
 358:	ffefffff 	.word	0xffefffff
 35c:	000010cc 	.word	0x000010cc
 360:	000010c4 	.word	0x000010c4
 364:	000010ee 	.word	0x000010ee

Disassembly of section .text.pmu_set_sleep_clk.constprop.1:

00000368 <pmu_set_sleep_clk.constprop.1>:
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 368:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 36a:	4e0b      	ldr	r6, [pc, #44]	; (398 <pmu_set_sleep_clk.constprop.1+0x30>)
 36c:	0245      	lsls	r5, r0, #9
 36e:	432e      	orrs	r6, r5
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 370:	014c      	lsls	r4, r1, #5
 372:	1c31      	adds	r1, r6, #0
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 374:	1c17      	adds	r7, r2, #0
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 376:	4321      	orrs	r1, r4
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 378:	2017      	movs	r0, #23
 37a:	f7ff ff58 	bl	22e <pmu_reg_write>
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 37e:	0179      	lsls	r1, r7, #5
 380:	4331      	orrs	r1, r6
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
 382:	2015      	movs	r0, #21
 384:	f7ff ff53 	bl	22e <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 388:	2101      	movs	r1, #1
 38a:	430d      	orrs	r5, r1
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 38c:	1c29      	adds	r1, r5, #0
 38e:	4321      	orrs	r1, r4
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 390:	2019      	movs	r0, #25
 392:	f7ff ff4c 	bl	22e <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)
}
 396:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 398:	0000c001 	.word	0x0000c001

Disassembly of section .text.xo_init:

0000039c <xo_init>:
                     (xo_scn_clk_sel   << 1)  |
                     (xo_scn_enb       << 0));
    mbus_write_message32(0xA1, *REG_XO_CONF1);
}

void xo_init( void ) {
 39c:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    // Parasitic capacitance tuning (6 bits for each; each 1 adds 1.8pF)
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));
 39e:	4a53      	ldr	r2, [pc, #332]	; (4ec <xo_init+0x150>)
 3a0:	4b53      	ldr	r3, [pc, #332]	; (4f0 <xo_init+0x154>)

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
 3a2:	4c54      	ldr	r4, [pc, #336]	; (4f4 <xo_init+0x158>)

void xo_init( void ) {
    // Parasitic capacitance tuning (6 bits for each; each 1 adds 1.8pF)
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));
 3a4:	601a      	str	r2, [r3, #0]

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
 3a6:	6822      	ldr	r2, [r4, #0]
 3a8:	4b53      	ldr	r3, [pc, #332]	; (4f8 <xo_init+0x15c>)
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
    prev20_r19.XO_DRV_START_UP  = 0x0;
    prev20_r19.XO_DRV_CORE      = 0x0;
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
 3aa:	2602      	movs	r6, #2
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
 3ac:	4013      	ands	r3, r2
 3ae:	2280      	movs	r2, #128	; 0x80
 3b0:	0192      	lsls	r2, r2, #6
 3b2:	4313      	orrs	r3, r2
 3b4:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
 3b6:	6822      	ldr	r2, [r4, #0]
 3b8:	4b50      	ldr	r3, [pc, #320]	; (4fc <xo_init+0x160>)
    prev20_r19.XO_RP_MEDIA      = 0x1;
    prev20_r19.XO_RP_MVT        = 0x0;
    prev20_r19.XO_RP_SVT        = 0x0;

    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
 3ba:	4d51      	ldr	r5, [pc, #324]	; (500 <xo_init+0x164>)
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
 3bc:	4013      	ands	r3, r2
 3be:	22c0      	movs	r2, #192	; 0xc0
 3c0:	0092      	lsls	r2, r2, #2
 3c2:	4313      	orrs	r3, r2
 3c4:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DRV_START_UP  = 0x0;
 3c6:	6823      	ldr	r3, [r4, #0]
 3c8:	2280      	movs	r2, #128	; 0x80
 3ca:	4393      	bics	r3, r2
 3cc:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DRV_CORE      = 0x0;
 3ce:	6823      	ldr	r3, [r4, #0]
 3d0:	2240      	movs	r2, #64	; 0x40
 3d2:	4393      	bics	r3, r2
 3d4:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
 3d6:	6823      	ldr	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB       = 0x1;
 3d8:	2201      	movs	r2, #1
    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
    prev20_r19.XO_DRV_START_UP  = 0x0;
    prev20_r19.XO_DRV_CORE      = 0x0;
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
 3da:	43b3      	bics	r3, r6
 3dc:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB       = 0x1;
 3de:	6823      	ldr	r3, [r4, #0]
    prev20_r19.XO_RP_SVT        = 0x0;

    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000); // >= 1ms
 3e0:	4f48      	ldr	r7, [pc, #288]	; (504 <xo_init+0x168>)
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
    prev20_r19.XO_DRV_START_UP  = 0x0;
    prev20_r19.XO_DRV_CORE      = 0x0;
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
    prev20_r19.XO_SCN_ENB       = 0x1;
 3e2:	4313      	orrs	r3, r2
 3e4:	6023      	str	r3, [r4, #0]

    // TODO: check if need 32.768kHz clock
    prev20_r19.XO_EN_DIV        = 0x1; // divider enable (also enables CLK_OUT)
 3e6:	6822      	ldr	r2, [r4, #0]
 3e8:	2380      	movs	r3, #128	; 0x80
 3ea:	035b      	lsls	r3, r3, #13
 3ec:	4313      	orrs	r3, r2
 3ee:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_S             = 0x0; // (not used) division ration for 16kHz out
 3f0:	6822      	ldr	r2, [r4, #0]
 3f2:	4b45      	ldr	r3, [pc, #276]	; (508 <xo_init+0x16c>)
    prev20_r19.XO_RP_MVT        = 0x0;
    prev20_r19.XO_RP_SVT        = 0x0;

    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 3f4:	20a1      	movs	r0, #161	; 0xa1
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
    prev20_r19.XO_SCN_ENB       = 0x1;

    // TODO: check if need 32.768kHz clock
    prev20_r19.XO_EN_DIV        = 0x1; // divider enable (also enables CLK_OUT)
    prev20_r19.XO_S             = 0x0; // (not used) division ration for 16kHz out
 3f6:	4013      	ands	r3, r2
 3f8:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SEL_CP_DIV    = 0x0; // 1: 0.3v-generation charge-pump uses divided clock
 3fa:	6822      	ldr	r2, [r4, #0]
 3fc:	4b43      	ldr	r3, [pc, #268]	; (50c <xo_init+0x170>)
 3fe:	4013      	ands	r3, r2
 400:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_EN_OUT        = 0x1; // xo output enabled;
 402:	6822      	ldr	r2, [r4, #0]
 404:	2380      	movs	r3, #128	; 0x80
 406:	021b      	lsls	r3, r3, #8
 408:	4313      	orrs	r3, r2
 40a:	6023      	str	r3, [r4, #0]
    				       // Note: I think this means output to XOT
    // Pseudo-resistor selection
    prev20_r19.XO_RP_LOW        = 0x0;
 40c:	6823      	ldr	r3, [r4, #0]
 40e:	2220      	movs	r2, #32
 410:	4393      	bics	r3, r2
 412:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_RP_MEDIA      = 0x1;
 414:	6823      	ldr	r3, [r4, #0]
 416:	2210      	movs	r2, #16
 418:	4313      	orrs	r3, r2
 41a:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_RP_MVT        = 0x0;
 41c:	6823      	ldr	r3, [r4, #0]
 41e:	2208      	movs	r2, #8
 420:	4393      	bics	r3, r2
 422:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_RP_SVT        = 0x0;
 424:	6823      	ldr	r3, [r4, #0]
 426:	2204      	movs	r2, #4
 428:	4393      	bics	r3, r2
 42a:	6023      	str	r3, [r4, #0]

    prev20_r19.XO_SLEEP = 0x0;
 42c:	6822      	ldr	r2, [r4, #0]
 42e:	4b38      	ldr	r3, [pc, #224]	; (510 <xo_init+0x174>)
 430:	4013      	ands	r3, r2
 432:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 434:	6823      	ldr	r3, [r4, #0]
 436:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 438:	6829      	ldr	r1, [r5, #0]
 43a:	f7ff febb 	bl	1b4 <mbus_write_message32>
    delay(10000); // >= 1ms
 43e:	1c38      	adds	r0, r7, #0
 440:	f7ff fe31 	bl	a6 <delay>

    prev20_r19.XO_ISOLATE = 0x0;
 444:	6822      	ldr	r2, [r4, #0]
 446:	4b33      	ldr	r3, [pc, #204]	; (514 <xo_init+0x178>)
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 448:	20a1      	movs	r0, #161	; 0xa1
    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000); // >= 1ms

    prev20_r19.XO_ISOLATE = 0x0;
 44a:	4013      	ands	r3, r2
 44c:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 44e:	6823      	ldr	r3, [r4, #0]
 450:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 452:	6829      	ldr	r1, [r5, #0]
 454:	f7ff feae 	bl	1b4 <mbus_write_message32>
    delay(10000); // >= 1ms
 458:	1c38      	adds	r0, r7, #0
 45a:	f7ff fe24 	bl	a6 <delay>

    prev20_r19.XO_DRV_START_UP = 0x1;
 45e:	6823      	ldr	r3, [r4, #0]
 460:	2280      	movs	r2, #128	; 0x80
 462:	4313      	orrs	r3, r2
 464:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 466:	6823      	ldr	r3, [r4, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(30000); // >= 1s
 468:	4f2b      	ldr	r7, [pc, #172]	; (518 <xo_init+0x17c>)
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000); // >= 1ms

    prev20_r19.XO_DRV_START_UP = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
 46a:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 46c:	6829      	ldr	r1, [r5, #0]
 46e:	20a1      	movs	r0, #161	; 0xa1
 470:	f7ff fea0 	bl	1b4 <mbus_write_message32>
    delay(30000); // >= 1s
 474:	1c38      	adds	r0, r7, #0
 476:	f7ff fe16 	bl	a6 <delay>

    prev20_r19.XO_SCN_CLK_SEL = 0x1;
 47a:	6823      	ldr	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 47c:	20a1      	movs	r0, #161	; 0xa1
    prev20_r19.XO_DRV_START_UP = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(30000); // >= 1s

    prev20_r19.XO_SCN_CLK_SEL = 0x1;
 47e:	4333      	orrs	r3, r6
 480:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 482:	6823      	ldr	r3, [r4, #0]
 484:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 486:	6829      	ldr	r1, [r5, #0]
 488:	f7ff fe94 	bl	1b4 <mbus_write_message32>
    delay(3000); // >= 300us
 48c:	4823      	ldr	r0, [pc, #140]	; (51c <xo_init+0x180>)
 48e:	f7ff fe0a 	bl	a6 <delay>

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
 492:	6823      	ldr	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB     = 0x0;
 494:	2201      	movs	r2, #1
    prev20_r19.XO_SCN_CLK_SEL = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(3000); // >= 300us

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
 496:	43b3      	bics	r3, r6
 498:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB     = 0x0;
 49a:	6823      	ldr	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 49c:	20a1      	movs	r0, #161	; 0xa1
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(3000); // >= 300us

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
    prev20_r19.XO_SCN_ENB     = 0x0;
 49e:	4393      	bics	r3, r2
 4a0:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 4a2:	6823      	ldr	r3, [r4, #0]
 4a4:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 4a6:	6829      	ldr	r1, [r5, #0]
 4a8:	f7ff fe84 	bl	1b4 <mbus_write_message32>
    delay(30000);  // >= 1s
 4ac:	1c38      	adds	r0, r7, #0
 4ae:	f7ff fdfa 	bl	a6 <delay>

    prev20_r19.XO_DRV_START_UP = 0x0;
 4b2:	6823      	ldr	r3, [r4, #0]
 4b4:	2280      	movs	r2, #128	; 0x80
 4b6:	4393      	bics	r3, r2
 4b8:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DRV_CORE     = 0x1;
 4ba:	6823      	ldr	r3, [r4, #0]
 4bc:	2240      	movs	r2, #64	; 0x40
 4be:	4313      	orrs	r3, r2
 4c0:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_CLK_SEL  = 0x1;
 4c2:	6823      	ldr	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 4c4:	20a1      	movs	r0, #161	; 0xa1
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(30000);  // >= 1s

    prev20_r19.XO_DRV_START_UP = 0x0;
    prev20_r19.XO_DRV_CORE     = 0x1;
    prev20_r19.XO_SCN_CLK_SEL  = 0x1;
 4c6:	431e      	orrs	r6, r3
 4c8:	6026      	str	r6, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 4ca:	6823      	ldr	r3, [r4, #0]
 4cc:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 4ce:	6829      	ldr	r1, [r5, #0]
 4d0:	f7ff fe70 	bl	1b4 <mbus_write_message32>

    enable_xo_timer();
 4d4:	f7ff fe2e 	bl	134 <enable_xo_timer>
    reset_xo_cnt();
 4d8:	f7ff fe54 	bl	184 <reset_xo_cnt>
    start_xo_cnt();
 4dc:	f7ff fe58 	bl	190 <start_xo_cnt>

    // BREAKPOint 0x03
    mbus_write_message32(0xBA, 0x03);
 4e0:	2103      	movs	r1, #3
 4e2:	20ba      	movs	r0, #186	; 0xba
 4e4:	f7ff fe66 	bl	1b4 <mbus_write_message32>

}
 4e8:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 4ea:	46c0      	nop			; (mov r8, r8)
 4ec:	00000fff 	.word	0x00000fff
 4f0:	a0000068 	.word	0xa0000068
 4f4:	00001088 	.word	0x00001088
 4f8:	ffff87ff 	.word	0xffff87ff
 4fc:	fffff8ff 	.word	0xfffff8ff
 500:	a0000064 	.word	0xa0000064
 504:	00002710 	.word	0x00002710
 508:	fff1ffff 	.word	0xfff1ffff
 50c:	fffeffff 	.word	0xfffeffff
 510:	ffbfffff 	.word	0xffbfffff
 514:	ffdfffff 	.word	0xffdfffff
 518:	00007530 	.word	0x00007530
 51c:	00000bb8 	.word	0x00000bb8

Disassembly of section .text.update_system_time:

00000520 <update_system_time>:
    return 0;
    return ((*REG_XOT_VAL_U & 0xFFFF) << 16) | (*REG_XOT_VAL_L & 0xFFFF);
}

void update_system_time() {
    uint32_t val = xo_sys_time;
 520:	4a0c      	ldr	r2, [pc, #48]	; (554 <update_system_time+0x34>)
    xo_sys_time = get_timer_cnt();
 522:	2300      	movs	r3, #0
    return 0;
    return ((*REG_XOT_VAL_U & 0xFFFF) << 16) | (*REG_XOT_VAL_L & 0xFFFF);
}

void update_system_time() {
    uint32_t val = xo_sys_time;
 524:	6810      	ldr	r0, [r2, #0]
inline static uint32_t get_timer_cnt() {
    return 0;
    return ((*REG_XOT_VAL_U & 0xFFFF) << 16) | (*REG_XOT_VAL_L & 0xFFFF);
}

void update_system_time() {
 526:	b500      	push	{lr}
    uint32_t val = xo_sys_time;
    xo_sys_time = get_timer_cnt();
 528:	6013      	str	r3, [r2, #0]
    xo_sys_time_in_sec = xo_sys_time >> 15;
 52a:	6811      	ldr	r1, [r2, #0]
 52c:	4b0a      	ldr	r3, [pc, #40]	; (558 <update_system_time+0x38>)
 52e:	0bc9      	lsrs	r1, r1, #15
 530:	6019      	str	r1, [r3, #0]
    xo_day_time_in_sec += (xo_sys_time - val) >> 15;
 532:	4b0a      	ldr	r3, [pc, #40]	; (55c <update_system_time+0x3c>)
 534:	6819      	ldr	r1, [r3, #0]
 536:	6812      	ldr	r2, [r2, #0]
 538:	1a12      	subs	r2, r2, r0
 53a:	0bd2      	lsrs	r2, r2, #15
 53c:	1852      	adds	r2, r2, r1
 53e:	601a      	str	r2, [r3, #0]

    if(xo_day_time_in_sec >= 86400) {
 540:	6819      	ldr	r1, [r3, #0]
 542:	4a07      	ldr	r2, [pc, #28]	; (560 <update_system_time+0x40>)
 544:	4291      	cmp	r1, r2
 546:	d903      	bls.n	550 <update_system_time+0x30>
        xo_day_time_in_sec -= 86400;
 548:	681a      	ldr	r2, [r3, #0]
 54a:	4906      	ldr	r1, [pc, #24]	; (564 <update_system_time+0x44>)
 54c:	1852      	adds	r2, r2, r1
 54e:	601a      	str	r2, [r3, #0]
    }
}
 550:	bd00      	pop	{pc}
 552:	46c0      	nop			; (mov r8, r8)
 554:	000010f4 	.word	0x000010f4
 558:	00001114 	.word	0x00001114
 55c:	00001160 	.word	0x00001160
 560:	0001517f 	.word	0x0001517f
 564:	fffeae80 	.word	0xfffeae80

Disassembly of section .text.set_goc_cmd:

00000568 <set_goc_cmd>:

/**********************************************
 * Interrupt handlers
 **********************************************/

void set_goc_cmd() {
 568:	b508      	push	{r3, lr}
    goc_component = (*GOC_DATA_IRQ >> 24) & 0xFF;
 56a:	238c      	movs	r3, #140	; 0x8c
 56c:	6819      	ldr	r1, [r3, #0]
 56e:	4a0c      	ldr	r2, [pc, #48]	; (5a0 <set_goc_cmd+0x38>)
 570:	0e09      	lsrs	r1, r1, #24
 572:	7011      	strb	r1, [r2, #0]
    goc_func_id = (*GOC_DATA_IRQ >> 16) & 0xFF;
 574:	6819      	ldr	r1, [r3, #0]
 576:	4a0b      	ldr	r2, [pc, #44]	; (5a4 <set_goc_cmd+0x3c>)
 578:	0c09      	lsrs	r1, r1, #16
 57a:	7011      	strb	r1, [r2, #0]
    goc_data = *GOC_DATA_IRQ & 0xFFFF;
 57c:	681a      	ldr	r2, [r3, #0]
 57e:	4b0a      	ldr	r3, [pc, #40]	; (5a8 <set_goc_cmd+0x40>)
 580:	801a      	strh	r2, [r3, #0]
    goc_state = 0;
 582:	4b0a      	ldr	r3, [pc, #40]	; (5ac <set_goc_cmd+0x44>)
 584:	2200      	movs	r2, #0
 586:	701a      	strb	r2, [r3, #0]
    update_system_time();
 588:	f7ff ffca 	bl	520 <update_system_time>
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	xot_last_timer_list[i] = xo_sys_time_in_sec;
 58c:	4a08      	ldr	r2, [pc, #32]	; (5b0 <set_goc_cmd+0x48>)
 58e:	4b09      	ldr	r3, [pc, #36]	; (5b4 <set_goc_cmd+0x4c>)
 590:	6811      	ldr	r1, [r2, #0]
 592:	6019      	str	r1, [r3, #0]
 594:	6811      	ldr	r1, [r2, #0]
 596:	6059      	str	r1, [r3, #4]
 598:	6812      	ldr	r2, [r2, #0]
 59a:	609a      	str	r2, [r3, #8]
    }
}
 59c:	bd08      	pop	{r3, pc}
 59e:	46c0      	nop			; (mov r8, r8)
 5a0:	0000110a 	.word	0x0000110a
 5a4:	00001118 	.word	0x00001118
 5a8:	00001122 	.word	0x00001122
 5ac:	00001148 	.word	0x00001148
 5b0:	00001114 	.word	0x00001114
 5b4:	000010e0 	.word	0x000010e0

Disassembly of section .text.handler_ext_int_wakeup:

000005b8 <handler_ext_int_wakeup>:
void handler_ext_int_reg0       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg1       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP
 5b8:	b570      	push	{r4, r5, r6, lr}
    update_system_time();
 5ba:	f7ff ffb1 	bl	520 <update_system_time>

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
 5be:	4b19      	ldr	r3, [pc, #100]	; (624 <handler_ext_int_wakeup+0x6c>)

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
 5c0:	4e19      	ldr	r6, [pc, #100]	; (628 <handler_ext_int_wakeup+0x70>)
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP
    update_system_time();

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
 5c2:	2501      	movs	r5, #1
 5c4:	601d      	str	r5, [r3, #0]

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
 5c6:	6831      	ldr	r1, [r6, #0]
 5c8:	20ee      	movs	r0, #238	; 0xee
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
 5ca:	248c      	movs	r4, #140	; 0x8c
void handler_ext_int_wakeup( void ) { // WAKEUP
    update_system_time();

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
 5cc:	f7ff fdf2 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
 5d0:	6821      	ldr	r1, [r4, #0]
 5d2:	20ee      	movs	r0, #238	; 0xee
 5d4:	f7ff fdee 	bl	1b4 <mbus_write_message32>

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
 5d8:	6833      	ldr	r3, [r6, #0]
 5da:	422b      	tst	r3, r5
 5dc:	d00d      	beq.n	5fa <handler_ext_int_wakeup+0x42>
        if(!(*GOC_DATA_IRQ)) {
 5de:	6823      	ldr	r3, [r4, #0]
 5e0:	2b00      	cmp	r3, #0
 5e2:	d101      	bne.n	5e8 <handler_ext_int_wakeup+0x30>
            operation_sleep(); // Need to protect against spurious wakeups
 5e4:	f7ff fe50 	bl	288 <operation_sleep>
        }
        set_goc_cmd();
 5e8:	f7ff ffbe 	bl	568 <set_goc_cmd>

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
    uint8_t i;
    update_system_time();
 5ec:	f7ff ff98 	bl	520 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
 5f0:	4b0e      	ldr	r3, [pc, #56]	; (62c <handler_ext_int_wakeup+0x74>)
 5f2:	2200      	movs	r2, #0
 5f4:	601a      	str	r2, [r3, #0]
 5f6:	605a      	str	r2, [r3, #4]
 5f8:	609a      	str	r2, [r3, #8]
        }
        set_goc_cmd();
        reset_timers_list();
    }

    sntv4_r17.WUP_ENABLE = 0;
 5fa:	4b0d      	ldr	r3, [pc, #52]	; (630 <handler_ext_int_wakeup+0x78>)
 5fc:	4a0d      	ldr	r2, [pc, #52]	; (634 <handler_ext_int_wakeup+0x7c>)
 5fe:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
 600:	2004      	movs	r0, #4
        }
        set_goc_cmd();
        reset_timers_list();
    }

    sntv4_r17.WUP_ENABLE = 0;
 602:	400a      	ands	r2, r1
 604:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
 606:	681a      	ldr	r2, [r3, #0]
 608:	2117      	movs	r1, #23
 60a:	f7ff fe03 	bl	214 <mbus_remote_register_write>

    mbus_write_message32(0xC0, xo_day_time_in_sec);
 60e:	4b0a      	ldr	r3, [pc, #40]	; (638 <handler_ext_int_wakeup+0x80>)
 610:	20c0      	movs	r0, #192	; 0xc0
 612:	6819      	ldr	r1, [r3, #0]
 614:	f7ff fdce 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xC1, xo_sys_time_in_sec);
 618:	4b08      	ldr	r3, [pc, #32]	; (63c <handler_ext_int_wakeup+0x84>)
 61a:	20c1      	movs	r0, #193	; 0xc1
 61c:	6819      	ldr	r1, [r3, #0]
 61e:	f7ff fdc9 	bl	1b4 <mbus_write_message32>
}
 622:	bd70      	pop	{r4, r5, r6, pc}
 624:	e000e280 	.word	0xe000e280
 628:	a000a008 	.word	0xa000a008
 62c:	0000114c 	.word	0x0000114c
 630:	000010a8 	.word	0x000010a8
 634:	ff7fffff 	.word	0xff7fffff
 638:	00001160 	.word	0x00001160
 63c:	00001114 	.word	0x00001114

Disassembly of section .text.handler_ext_int_gocep:

00000640 <handler_ext_int_gocep>:

void handler_ext_int_gocep( void ) { // GOCEP
 640:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
 642:	4b06      	ldr	r3, [pc, #24]	; (65c <handler_ext_int_gocep+0x1c>)
 644:	2204      	movs	r2, #4
 646:	601a      	str	r2, [r3, #0]
    set_goc_cmd();
 648:	f7ff ff8e 	bl	568 <set_goc_cmd>

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
    uint8_t i;
    update_system_time();
 64c:	f7ff ff68 	bl	520 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
 650:	4b03      	ldr	r3, [pc, #12]	; (660 <handler_ext_int_gocep+0x20>)
 652:	2200      	movs	r2, #0
 654:	601a      	str	r2, [r3, #0]
 656:	605a      	str	r2, [r3, #4]
 658:	609a      	str	r2, [r3, #8]

void handler_ext_int_gocep( void ) { // GOCEP
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
    set_goc_cmd();
    reset_timers_list();
}
 65a:	bd08      	pop	{r3, pc}
 65c:	e000e280 	.word	0xe000e280
 660:	0000114c 	.word	0x0000114c

Disassembly of section .text.handler_ext_int_timer32:

00000664 <handler_ext_int_timer32>:

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
 664:	4b04      	ldr	r3, [pc, #16]	; (678 <handler_ext_int_timer32+0x14>)
 666:	2208      	movs	r2, #8
 668:	601a      	str	r2, [r3, #0]
    *TIMER32_STAT = 0x0;
 66a:	4b04      	ldr	r3, [pc, #16]	; (67c <handler_ext_int_timer32+0x18>)
 66c:	2200      	movs	r2, #0
 66e:	601a      	str	r2, [r3, #0]
    
    wfi_timeout_flag = 1;
 670:	4b03      	ldr	r3, [pc, #12]	; (680 <handler_ext_int_timer32+0x1c>)
 672:	2201      	movs	r2, #1
 674:	701a      	strb	r2, [r3, #0]
}
 676:	4770      	bx	lr
 678:	e000e280 	.word	0xe000e280
 67c:	a0001110 	.word	0xa0001110
 680:	00001164 	.word	0x00001164

Disassembly of section .text.handler_ext_int_xot:

00000684 <handler_ext_int_xot>:

void handler_ext_int_xot( void ) { // TIMER32
 684:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_XOT);
 686:	2280      	movs	r2, #128	; 0x80
 688:	4b02      	ldr	r3, [pc, #8]	; (694 <handler_ext_int_xot+0x10>)
 68a:	0312      	lsls	r2, r2, #12
 68c:	601a      	str	r2, [r3, #0]
    update_system_time();
 68e:	f7ff ff47 	bl	520 <update_system_time>
}
 692:	bd08      	pop	{r3, pc}
 694:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg0:

00000698 <handler_ext_int_reg0>:

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
 698:	4b02      	ldr	r3, [pc, #8]	; (6a4 <handler_ext_int_reg0+0xc>)
 69a:	2280      	movs	r2, #128	; 0x80
 69c:	0052      	lsls	r2, r2, #1
 69e:	601a      	str	r2, [r3, #0]
}
 6a0:	4770      	bx	lr
 6a2:	46c0      	nop			; (mov r8, r8)
 6a4:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg1:

000006a8 <handler_ext_int_reg1>:

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
 6a8:	4b02      	ldr	r3, [pc, #8]	; (6b4 <handler_ext_int_reg1+0xc>)
 6aa:	2280      	movs	r2, #128	; 0x80
 6ac:	0092      	lsls	r2, r2, #2
 6ae:	601a      	str	r2, [r3, #0]
}
 6b0:	4770      	bx	lr
 6b2:	46c0      	nop			; (mov r8, r8)
 6b4:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg2:

000006b8 <handler_ext_int_reg2>:

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
 6b8:	4b02      	ldr	r3, [pc, #8]	; (6c4 <handler_ext_int_reg2+0xc>)
 6ba:	2280      	movs	r2, #128	; 0x80
 6bc:	00d2      	lsls	r2, r2, #3
 6be:	601a      	str	r2, [r3, #0]
}
 6c0:	4770      	bx	lr
 6c2:	46c0      	nop			; (mov r8, r8)
 6c4:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg3:

000006c8 <handler_ext_int_reg3>:

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
 6c8:	4b02      	ldr	r3, [pc, #8]	; (6d4 <handler_ext_int_reg3+0xc>)
 6ca:	2280      	movs	r2, #128	; 0x80
 6cc:	0112      	lsls	r2, r2, #4
 6ce:	601a      	str	r2, [r3, #0]
}
 6d0:	4770      	bx	lr
 6d2:	46c0      	nop			; (mov r8, r8)
 6d4:	e000e280 	.word	0xe000e280

Disassembly of section .text.startup.main:

000006d8 <main>:

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
     6d8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     6da:	4a7a      	ldr	r2, [pc, #488]	; (8c4 <main+0x1ec>)
     6dc:	4b7a      	ldr	r3, [pc, #488]	; (8c8 <main+0x1f0>)
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     6de:	4d7b      	ldr	r5, [pc, #492]	; (8cc <main+0x1f4>)
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     6e0:	601a      	str	r2, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     6e2:	682b      	ldr	r3, [r5, #0]
     6e4:	4f7a      	ldr	r7, [pc, #488]	; (8d0 <main+0x1f8>)
     6e6:	42bb      	cmp	r3, r7
     6e8:	d101      	bne.n	6ee <main+0x16>
     6ea:	f000 fc5d 	bl	fa8 <main+0x8d0>
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);
     6ee:	2101      	movs	r1, #1
     6f0:	20ba      	movs	r0, #186	; 0xba
     6f2:	f7ff fd5f 	bl	1b4 <mbus_write_message32>

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     6f6:	4e77      	ldr	r6, [pc, #476]	; (8d4 <main+0x1fc>)

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
     6f8:	4b77      	ldr	r3, [pc, #476]	; (8d8 <main+0x200>)
     6fa:	2400      	movs	r4, #0
     6fc:	601c      	str	r4, [r3, #0]

    // Enumeration
    enumerated = ENUMID;

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     6fe:	2006      	movs	r0, #6
static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     700:	6034      	str	r4, [r6, #0]
    //config_timer32(0, 0, 0, 0);

    // Enumeration
    enumerated = ENUMID;
     702:	602f      	str	r7, [r5, #0]

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     704:	f7ff fd76 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     708:	2064      	movs	r0, #100	; 0x64
     70a:	f7ff fccc 	bl	a6 <delay>
#endif
#ifdef USE_MRR
    mbus_enumerate(MRR_ADDR);
     70e:	2002      	movs	r0, #2
     710:	f7ff fd70 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     714:	2064      	movs	r0, #100	; 0x64
     716:	f7ff fcc6 	bl	a6 <delay>
#endif
#ifdef USE_LNT
    mbus_enumerate(LNT_ADDR);
     71a:	2003      	movs	r0, #3
     71c:	f7ff fd6a 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     720:	2064      	movs	r0, #100	; 0x64
     722:	f7ff fcc0 	bl	a6 <delay>
#endif
#ifdef USE_SNT
    mbus_enumerate(SNT_ADDR);
     726:	2004      	movs	r0, #4
     728:	f7ff fd64 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     72c:	2064      	movs	r0, #100	; 0x64
     72e:	f7ff fcba 	bl	a6 <delay>
#endif
#ifdef USE_PMU
    mbus_enumerate(PMU_ADDR);
     732:	2005      	movs	r0, #5
     734:	f7ff fd5e 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     738:	2064      	movs	r0, #100	; 0x64
     73a:	f7ff fcb4 	bl	a6 <delay>
#endif

    // Default CPU halt function
    set_halt_until_mbus_tx();
     73e:	f7ff fd2d 	bl	19c <set_halt_until_mbus_tx>

    // Global variables
    wfi_timeout_flag = 0;
     742:	4b66      	ldr	r3, [pc, #408]	; (8dc <main+0x204>)

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     744:	2219      	movs	r2, #25

    // Default CPU halt function
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;
     746:	701c      	strb	r4, [r3, #0]

    xo_sys_time = 0;
     748:	4b65      	ldr	r3, [pc, #404]	; (8e0 <main+0x208>)
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;
     74a:	4d66      	ldr	r5, [pc, #408]	; (8e4 <main+0x20c>)
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
     74c:	601c      	str	r4, [r3, #0]
    xo_sys_time_in_sec = 0;
     74e:	4b66      	ldr	r3, [pc, #408]	; (8e8 <main+0x210>)
     750:	601c      	str	r4, [r3, #0]
    xo_day_time_in_sec = 0;
     752:	4b66      	ldr	r3, [pc, #408]	; (8ec <main+0x214>)
     754:	601c      	str	r4, [r3, #0]

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     756:	4b66      	ldr	r3, [pc, #408]	; (8f0 <main+0x218>)
     758:	601a      	str	r2, [r3, #0]
    // LNT_INTERVAL[0] = 60;
    // LNT_INTERVAL[1] = 300;
    // LNT_INTERVAL[2] = 600;
    // LNT_INTERVAL[3] = 1800;

    lnt_cur_level = 0;
     75a:	4b66      	ldr	r3, [pc, #408]	; (8f4 <main+0x21c>)
    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;
     75c:	702c      	strb	r4, [r5, #0]
    // LNT_INTERVAL[0] = 60;
    // LNT_INTERVAL[1] = 300;
    // LNT_INTERVAL[2] = 600;
    // LNT_INTERVAL[3] = 1800;

    lnt_cur_level = 0;
     75e:	701c      	strb	r4, [r3, #0]
    // MRR_SIGNAL_PERIOD = 300;
    // MRR_DATA_PERIOD = 18000;
    // MRR_TEMP_THRESH = 5;    // FIXME: use code
    // MRR_VOLT_THRESH = 0x4B;

    pmu_sar_ratio_radio = 0x34;
     760:	4b65      	ldr	r3, [pc, #404]	; (8f8 <main+0x220>)
     762:	2234      	movs	r2, #52	; 0x34
     764:	701a      	strb	r2, [r3, #0]
	pmu_setting_state = PMU_20C;
     766:	4b65      	ldr	r3, [pc, #404]	; (8fc <main+0x224>)
     768:	2203      	movs	r2, #3
     76a:	601a      	str	r2, [r3, #0]
    // PMU_SLEEP_SETTINGS[5] = 0x02000101;
    // PMU_SLEEP_SETTINGS[6] = 0x01010101;
    // PMU_SLEEP_SETTINGS[7] = 0x01010101;

    // Initialization
    xo_init();
     76c:	f7ff fe16 	bl	39c <xo_init>

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     770:	2102      	movs	r1, #2
     772:	20ba      	movs	r0, #186	; 0xba
     774:	f7ff fd1e 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);
     778:	4961      	ldr	r1, [pc, #388]	; (900 <main+0x228>)
     77a:	20ed      	movs	r0, #237	; 0xed
     77c:	f7ff fd1a 	bl	1b4 <mbus_write_message32>



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     780:	4b60      	ldr	r3, [pc, #384]	; (904 <main+0x22c>)
     782:	2140      	movs	r1, #64	; 0x40
     784:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     786:	2004      	movs	r0, #4
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     788:	438a      	bics	r2, r1
     78a:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
     78c:	881a      	ldrh	r2, [r3, #0]
     78e:	2180      	movs	r1, #128	; 0x80
     790:	438a      	bics	r2, r1
     792:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     794:	681a      	ldr	r2, [r3, #0]
     796:	2101      	movs	r1, #1
     798:	f7ff fd3c 	bl	214 <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     79c:	4b5a      	ldr	r3, [pc, #360]	; (908 <main+0x230>)
     79e:	22ff      	movs	r2, #255	; 0xff
     7a0:	8819      	ldrh	r1, [r3, #0]
     7a2:	2080      	movs	r0, #128	; 0x80
     7a4:	4011      	ands	r1, r2
     7a6:	0140      	lsls	r0, r0, #5
     7a8:	4301      	orrs	r1, r0
     7aa:	8019      	strh	r1, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     7ac:	8819      	ldrh	r1, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     7ae:	2004      	movs	r0, #4
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     7b0:	4391      	bics	r1, r2
     7b2:	8019      	strh	r1, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     7b4:	681a      	ldr	r2, [r3, #0]
     7b6:	2107      	movs	r1, #7
     7b8:	f7ff fd2c 	bl	214 <mbus_remote_register_write>
//     mbus_write_message32(0xCE, end_time - xo_sys_time_in_sec);
// }


static void operation_temp_run() {
    if(snt_state == SNT_IDLE) {
     7bc:	7829      	ldrb	r1, [r5, #0]
     7be:	42a1      	cmp	r1, r4
     7c0:	d10c      	bne.n	7dc <main+0x104>
    sntv4_r01.TSNS_RESETn = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void snt_ldo_vref_on() {
    sntv4_r00.LDO_EN_VREF = 1;
     7c2:	4b52      	ldr	r3, [pc, #328]	; (90c <main+0x234>)
     7c4:	2004      	movs	r0, #4
     7c6:	881a      	ldrh	r2, [r3, #0]
     7c8:	4302      	orrs	r2, r0
     7ca:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
     7cc:	681a      	ldr	r2, [r3, #0]
     7ce:	f7ff fd21 	bl	214 <mbus_remote_register_write>
    if(snt_state == SNT_IDLE) {

        // Turn on snt ldo vref; requires ~30 ms to settle
        // TODo: figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);
     7d2:	2064      	movs	r0, #100	; 0x64
     7d4:	f7ff fc67 	bl	a6 <delay>

        snt_state = SNT_TEMP_LDO;
     7d8:	2301      	movs	r3, #1
     7da:	702b      	strb	r3, [r5, #0]

    }
    if(snt_state == SNT_TEMP_LDO) {
     7dc:	4f41      	ldr	r7, [pc, #260]	; (8e4 <main+0x20c>)
     7de:	783d      	ldrb	r5, [r7, #0]
     7e0:	2d01      	cmp	r5, #1
     7e2:	d12e      	bne.n	842 <main+0x16a>
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
     7e4:	4b49      	ldr	r3, [pc, #292]	; (90c <main+0x234>)
     7e6:	2602      	movs	r6, #2
     7e8:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
     7ea:	2004      	movs	r0, #4
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
     7ec:	4332      	orrs	r2, r6
     7ee:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
     7f0:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
     7f2:	2100      	movs	r1, #0
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
    sntv4_r00.LDO_EN_LDO  = 1;
     7f4:	432a      	orrs	r2, r5
     7f6:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
     7f8:	681a      	ldr	r2, [r3, #0]
     7fa:	f7ff fd0b 	bl	214 <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
     7fe:	4c41      	ldr	r4, [pc, #260]	; (904 <main+0x22c>)
     800:	2208      	movs	r2, #8
     802:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     804:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
     806:	4313      	orrs	r3, r2
     808:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     80a:	6822      	ldr	r2, [r4, #0]
     80c:	1c29      	adds	r1, r5, #0
     80e:	f7ff fd01 	bl	214 <mbus_remote_register_write>
    // Un-powergate analog block
    sntv4_r01.TSNS_EN_SENSOR_LDO = 1;
     812:	8823      	ldrh	r3, [r4, #0]
     814:	2220      	movs	r2, #32
     816:	4313      	orrs	r3, r2
     818:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     81a:	6822      	ldr	r2, [r4, #0]
     81c:	1c29      	adds	r1, r5, #0
     81e:	2004      	movs	r0, #4
     820:	f7ff fcf8 	bl	214 <mbus_remote_register_write>

    delay(MBUS_DELAY);
     824:	2064      	movs	r0, #100	; 0x64
     826:	f7ff fc3e 	bl	a6 <delay>

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
     82a:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     82c:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    delay(MBUS_DELAY);

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
     82e:	43b3      	bics	r3, r6
     830:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     832:	6822      	ldr	r2, [r4, #0]
     834:	1c29      	adds	r1, r5, #0
     836:	f7ff fced 	bl	214 <mbus_remote_register_write>
        // Power on snt ldo
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);
     83a:	2064      	movs	r0, #100	; 0x64
     83c:	f7ff fc33 	bl	a6 <delay>

        snt_state = SNT_TEMP_START;
     840:	703e      	strb	r6, [r7, #0]
    }
    if(snt_state == SNT_TEMP_START) {
     842:	4d28      	ldr	r5, [pc, #160]	; (8e4 <main+0x20c>)
     844:	782b      	ldrb	r3, [r5, #0]
     846:	2b02      	cmp	r3, #2
     848:	d11d      	bne.n	886 <main+0x1ae>
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
     84a:	4b24      	ldr	r3, [pc, #144]	; (8dc <main+0x204>)
     84c:	2400      	movs	r4, #0
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
     84e:	20a0      	movs	r0, #160	; 0xa0

        snt_state = SNT_TEMP_START;
    }
    if(snt_state == SNT_TEMP_START) {
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
     850:	701c      	strb	r4, [r3, #0]
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
     852:	0300      	lsls	r0, r0, #12
     854:	2101      	movs	r1, #1
     856:	1c22      	adds	r2, r4, #0
     858:	1c23      	adds	r3, r4, #0
     85a:	f7ff fc2f 	bl	bc <config_timer32>
/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/

static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
     85e:	4829      	ldr	r0, [pc, #164]	; (904 <main+0x22c>)
     860:	2101      	movs	r1, #1
     862:	8803      	ldrh	r3, [r0, #0]
     864:	430b      	orrs	r3, r1
     866:	8003      	strh	r3, [r0, #0]
    sntv4_r01.TSNS_EN_IRQ = 1;
     868:	8802      	ldrh	r2, [r0, #0]
     86a:	2380      	movs	r3, #128	; 0x80
     86c:	408b      	lsls	r3, r1
     86e:	4313      	orrs	r3, r2
     870:	8003      	strh	r3, [r0, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     872:	6802      	ldr	r2, [r0, #0]
     874:	2004      	movs	r0, #4
     876:	f7ff fccd 	bl	214 <mbus_remote_register_write>
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or TIMER32
	WFI();
     87a:	f7ff fc1c 	bl	b6 <WFI>

        // Turn off timer32
        *TIMER32_GO = 0;
     87e:	4b24      	ldr	r3, [pc, #144]	; (910 <main+0x238>)
     880:	601c      	str	r4, [r3, #0]

        snt_state = SNT_TEMP_READ;
     882:	2303      	movs	r3, #3
     884:	702b      	strb	r3, [r5, #0]
    }
    if(snt_state == SNT_TEMP_READ) {
     886:	4917      	ldr	r1, [pc, #92]	; (8e4 <main+0x20c>)
     888:	780b      	ldrb	r3, [r1, #0]
     88a:	2b03      	cmp	r3, #3
     88c:	d16e      	bne.n	96c <main+0x294>
        if(wfi_timeout_flag) {
     88e:	4b13      	ldr	r3, [pc, #76]	; (8dc <main+0x204>)
     890:	781d      	ldrb	r5, [r3, #0]
     892:	1e2e      	subs	r6, r5, #0
     894:	d03e      	beq.n	914 <main+0x23c>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
     896:	2180      	movs	r1, #128	; 0x80
     898:	0449      	lsls	r1, r1, #17
     89a:	20af      	movs	r0, #175	; 0xaf
     89c:	f7ff fc8a 	bl	1b4 <mbus_write_message32>
    while(1);
}

static void operation_sleep_notimer( void ) {
    // Diable timer
    set_wakeup_timer(0, 0, 0);
     8a0:	2000      	movs	r0, #0
     8a2:	1c01      	adds	r1, r0, #0
     8a4:	1c02      	adds	r2, r0, #0
     8a6:	f7ff fc2f 	bl	108 <set_wakeup_timer>
    set_xo_timer(0, 0, 0, 0);
     8aa:	2000      	movs	r0, #0
     8ac:	1c01      	adds	r1, r0, #0
     8ae:	1c02      	adds	r2, r0, #0
     8b0:	1c03      	adds	r3, r0, #0
     8b2:	f7ff fc49 	bl	148 <set_xo_timer>
    config_timer32(0, 0, 0, 0);
     8b6:	2000      	movs	r0, #0
     8b8:	1c01      	adds	r1, r0, #0
     8ba:	1c02      	adds	r2, r0, #0
     8bc:	1c03      	adds	r3, r0, #0
     8be:	f7ff fbfd 	bl	bc <config_timer32>
     8c2:	e39b      	b.n	ffc <main+0x924>
     8c4:	00080f0d 	.word	0x00080f0d
     8c8:	e000e100 	.word	0xe000e100
     8cc:	0000110c 	.word	0x0000110c
     8d0:	deadbee1 	.word	0xdeadbee1
     8d4:	a000007c 	.word	0xa000007c
     8d8:	a0001200 	.word	0xa0001200
     8dc:	00001164 	.word	0x00001164
     8e0:	000010f4 	.word	0x000010f4
     8e4:	00001110 	.word	0x00001110
     8e8:	00001114 	.word	0x00001114
     8ec:	00001160 	.word	0x00001160
     8f0:	00001128 	.word	0x00001128
     8f4:	000010fc 	.word	0x000010fc
     8f8:	0000111a 	.word	0x0000111a
     8fc:	0000111c 	.word	0x0000111c
     900:	0d020f0f 	.word	0x0d020f0f
     904:	00001090 	.word	0x00001090
     908:	00001098 	.word	0x00001098
     90c:	0000108c 	.word	0x0000108c
     910:	a0001100 	.word	0xa0001100
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
     914:	23a0      	movs	r3, #160	; 0xa0
     916:	061b      	lsls	r3, r3, #24
     918:	681a      	ldr	r2, [r3, #0]
     91a:	4bf9      	ldr	r3, [pc, #996]	; (d00 <main+0x628>)
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
     91c:	2401      	movs	r4, #1
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
     91e:	601a      	str	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
     920:	4bf8      	ldr	r3, [pc, #992]	; (d04 <main+0x62c>)
    sntv4_r01.TSNS_SEL_LDO       = 0;
     922:	2108      	movs	r1, #8
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
     924:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
     926:	2702      	movs	r7, #2
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
     928:	43a2      	bics	r2, r4
     92a:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
     92c:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     92e:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
     930:	438a      	bics	r2, r1
     932:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
     934:	881a      	ldrh	r2, [r3, #0]
     936:	2120      	movs	r1, #32
     938:	438a      	bics	r2, r1
     93a:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE       = 1;
     93c:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     93e:	1c21      	adds	r1, r4, #0

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
     940:	433a      	orrs	r2, r7
     942:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     944:	681a      	ldr	r2, [r3, #0]
     946:	f7ff fc65 	bl	214 <mbus_remote_register_write>
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
     94a:	4bef      	ldr	r3, [pc, #956]	; (d08 <main+0x630>)
     94c:	2004      	movs	r0, #4
     94e:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
    sntv4_r00.LDO_EN_LDO  = 0;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
     950:	1c31      	adds	r1, r6, #0
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
     952:	4382      	bics	r2, r0
     954:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
     956:	881a      	ldrh	r2, [r3, #0]
     958:	43ba      	bics	r2, r7
     95a:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 0;
     95c:	881a      	ldrh	r2, [r3, #0]
     95e:	43a2      	bics	r2, r4
     960:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
     962:	681a      	ldr	r2, [r3, #0]
     964:	f7ff fc56 	bl	214 <mbus_remote_register_write>
            
            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

            snt_state = SNT_IDLE;
     968:	4ae8      	ldr	r2, [pc, #928]	; (d0c <main+0x634>)
     96a:	7015      	strb	r5, [r2, #0]

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     96c:	4be8      	ldr	r3, [pc, #928]	; (d10 <main+0x638>)
     96e:	49e9      	ldr	r1, [pc, #932]	; (d14 <main+0x63c>)
     970:	681a      	ldr	r2, [r3, #0]
     972:	2780      	movs	r7, #128	; 0x80
     974:	400a      	ands	r2, r1
     976:	03bf      	lsls	r7, r7, #14
     978:	433a      	orrs	r2, r7
     97a:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     97c:	6819      	ldr	r1, [r3, #0]
     97e:	4ae6      	ldr	r2, [pc, #920]	; (d18 <main+0x640>)
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     980:	2540      	movs	r5, #64	; 0x40
inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     982:	400a      	ands	r2, r1
     984:	49e5      	ldr	r1, [pc, #916]	; (d1c <main+0x644>)
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     986:	2003      	movs	r0, #3
inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     988:	430a      	orrs	r2, r1
     98a:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     98c:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     98e:	2122      	movs	r1, #34	; 0x22
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     990:	432a      	orrs	r2, r5
     992:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     994:	681a      	ldr	r2, [r3, #0]
     996:	f7ff fc3d 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     99a:	20fa      	movs	r0, #250	; 0xfa
     99c:	0080      	lsls	r0, r0, #2
     99e:	f7ff fb82 	bl	a6 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     9a2:	4edf      	ldr	r6, [pc, #892]	; (d20 <main+0x648>)
     9a4:	4bdf      	ldr	r3, [pc, #892]	; (d24 <main+0x64c>)
     9a6:	6832      	ldr	r2, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     9a8:	2402      	movs	r4, #2
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     9aa:	4013      	ands	r3, r2
     9ac:	2280      	movs	r2, #128	; 0x80
     9ae:	0212      	lsls	r2, r2, #8
     9b0:	4313      	orrs	r3, r2
     9b2:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     9b4:	6833      	ldr	r3, [r6, #0]
     9b6:	22fc      	movs	r2, #252	; 0xfc
     9b8:	4313      	orrs	r3, r2
     9ba:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     9bc:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     9be:	2201      	movs	r2, #1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     9c0:	4323      	orrs	r3, r4
     9c2:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     9c4:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     9c6:	2121      	movs	r1, #33	; 0x21
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     9c8:	4313      	orrs	r3, r2
     9ca:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     9cc:	6832      	ldr	r2, [r6, #0]
     9ce:	2003      	movs	r0, #3
     9d0:	f7ff fc20 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     9d4:	20fa      	movs	r0, #250	; 0xfa
     9d6:	40a0      	lsls	r0, r4
     9d8:	f7ff fb65 	bl	a6 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     9dc:	4bd2      	ldr	r3, [pc, #840]	; (d28 <main+0x650>)
     9de:	49d3      	ldr	r1, [pc, #844]	; (d2c <main+0x654>)
     9e0:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     9e2:	2003      	movs	r0, #3
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     9e4:	400a      	ands	r2, r1
     9e6:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     9e8:	681a      	ldr	r2, [r3, #0]
     9ea:	1c29      	adds	r1, r5, #0
     9ec:	f7ff fc12 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     9f0:	20fa      	movs	r0, #250	; 0xfa
     9f2:	40a0      	lsls	r0, r4
     9f4:	f7ff fb57 	bl	a6 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     9f8:	6832      	ldr	r2, [r6, #0]
     9fa:	4bcd      	ldr	r3, [pc, #820]	; (d30 <main+0x658>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     9fc:	2121      	movs	r1, #33	; 0x21
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     9fe:	4013      	ands	r3, r2
     a00:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     a02:	6832      	ldr	r2, [r6, #0]
     a04:	2003      	movs	r0, #3
     a06:	f7ff fc05 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     a0a:	20fa      	movs	r0, #250	; 0xfa
     a0c:	40a0      	lsls	r0, r4
     a0e:	f7ff fb4a 	bl	a6 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     a12:	4dc8      	ldr	r5, [pc, #800]	; (d34 <main+0x65c>)
     a14:	2208      	movs	r2, #8
     a16:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     a18:	2120      	movs	r1, #32
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     a1a:	4313      	orrs	r3, r2
     a1c:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     a1e:	682a      	ldr	r2, [r5, #0]
     a20:	2003      	movs	r0, #3
     a22:	f7ff fbf7 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     a26:	20fa      	movs	r0, #250	; 0xfa
     a28:	40a0      	lsls	r0, r4
     a2a:	f7ff fb3c 	bl	a6 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
     a2e:	782b      	ldrb	r3, [r5, #0]
     a30:	2110      	movs	r1, #16
     a32:	430b      	orrs	r3, r1
     a34:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
     a36:	782b      	ldrb	r3, [r5, #0]
     a38:	2204      	movs	r2, #4
     a3a:	4313      	orrs	r3, r2
     a3c:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     a3e:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     a40:	2120      	movs	r1, #32
    delay(MBUS_DELAY*10);
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     a42:	4323      	orrs	r3, r4
     a44:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     a46:	682a      	ldr	r2, [r5, #0]
     a48:	2003      	movs	r0, #3
     a4a:	f7ff fbe3 	bl	214 <mbus_remote_register_write>
    delay(2000); 
     a4e:	20fa      	movs	r0, #250	; 0xfa
     a50:	00c0      	lsls	r0, r0, #3
     a52:	f7ff fb28 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
     a56:	782b      	ldrb	r3, [r5, #0]
     a58:	2101      	movs	r1, #1
     a5a:	430b      	orrs	r3, r1
     a5c:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     a5e:	682a      	ldr	r2, [r5, #0]
     a60:	2120      	movs	r1, #32
     a62:	2003      	movs	r0, #3
     a64:	f7ff fbd6 	bl	214 <mbus_remote_register_write>
    delay(10); 
     a68:	200a      	movs	r0, #10
     a6a:	f7ff fb1c 	bl	a6 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
     a6e:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     a70:	2121      	movs	r1, #33	; 0x21
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    delay(10); 
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
     a72:	431f      	orrs	r7, r3
     a74:	6037      	str	r7, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     a76:	6832      	ldr	r2, [r6, #0]
     a78:	2003      	movs	r0, #3
     a7a:	f7ff fbcb 	bl	214 <mbus_remote_register_write>
    delay(100000); 
     a7e:	48ae      	ldr	r0, [pc, #696]	; (d38 <main+0x660>)
     a80:	f7ff fb11 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
     a84:	782b      	ldrb	r3, [r5, #0]
     a86:	2208      	movs	r2, #8
     a88:	4393      	bics	r3, r2
     a8a:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     a8c:	682a      	ldr	r2, [r5, #0]
     a8e:	2120      	movs	r1, #32
     a90:	2003      	movs	r0, #3
     a92:	f7ff fbbf 	bl	214 <mbus_remote_register_write>
    delay(100);
     a96:	2064      	movs	r0, #100	; 0x64
     a98:	f7ff fb05 	bl	a6 <delay>
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     a9c:	4ba7      	ldr	r3, [pc, #668]	; (d3c <main+0x664>)
     a9e:	2101      	movs	r1, #1
     aa0:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     aa2:	2003      	movs	r0, #3
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     aa4:	430a      	orrs	r2, r1
     aa6:	701a      	strb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
     aa8:	781a      	ldrb	r2, [r3, #0]
     aaa:	211e      	movs	r1, #30
     aac:	438a      	bics	r2, r1
     aae:	2110      	movs	r1, #16
     ab0:	430a      	orrs	r2, r1
     ab2:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     ab4:	681a      	ldr	r2, [r3, #0]
     ab6:	2117      	movs	r1, #23
     ab8:	f7ff fbac 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     abc:	20fa      	movs	r0, #250	; 0xfa
     abe:	40a0      	lsls	r0, r4
     ac0:	f7ff faf1 	bl	a6 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     ac4:	4b9e      	ldr	r3, [pc, #632]	; (d40 <main+0x668>)
     ac6:	21f0      	movs	r1, #240	; 0xf0
     ac8:	881a      	ldrh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     aca:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     acc:	438a      	bics	r2, r1
     ace:	2170      	movs	r1, #112	; 0x70
     ad0:	430a      	orrs	r2, r1
     ad2:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
     ad4:	881a      	ldrh	r2, [r3, #0]
     ad6:	210f      	movs	r1, #15
     ad8:	438a      	bics	r2, r1
     ada:	4322      	orrs	r2, r4
     adc:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
     ade:	8819      	ldrh	r1, [r3, #0]
     ae0:	2280      	movs	r2, #128	; 0x80
     ae2:	0052      	lsls	r2, r2, #1
     ae4:	430a      	orrs	r2, r1
     ae6:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     ae8:	681a      	ldr	r2, [r3, #0]
     aea:	2101      	movs	r1, #1
     aec:	f7ff fb92 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     af0:	20fa      	movs	r0, #250	; 0xfa
     af2:	40a0      	lsls	r0, r4
     af4:	f7ff fad7 	bl	a6 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     af8:	4b92      	ldr	r3, [pc, #584]	; (d44 <main+0x66c>)
     afa:	4a93      	ldr	r2, [pc, #588]	; (d48 <main+0x670>)
     afc:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     afe:	2003      	movs	r0, #3
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    delay(MBUS_DELAY*10);
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     b00:	400a      	ands	r2, r1
     b02:	2180      	movs	r1, #128	; 0x80
     b04:	430a      	orrs	r2, r1
     b06:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     b08:	681a      	ldr	r2, [r3, #0]
     b0a:	1c21      	adds	r1, r4, #0
     b0c:	f7ff fb82 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     b10:	20fa      	movs	r0, #250	; 0xfa
     b12:	40a0      	lsls	r0, r4
     b14:	f7ff fac7 	bl	a6 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     b18:	4b8c      	ldr	r3, [pc, #560]	; (d4c <main+0x674>)
     b1a:	4a8d      	ldr	r2, [pc, #564]	; (d50 <main+0x678>)
     b1c:	6819      	ldr	r1, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     b1e:	2003      	movs	r0, #3
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    delay(MBUS_DELAY*10);
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     b20:	400a      	ands	r2, r1
     b22:	21c0      	movs	r1, #192	; 0xc0
     b24:	0289      	lsls	r1, r1, #10
     b26:	430a      	orrs	r2, r1
     b28:	601a      	str	r2, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
     b2a:	681a      	ldr	r2, [r3, #0]
     b2c:	2110      	movs	r1, #16
     b2e:	0b12      	lsrs	r2, r2, #12
     b30:	0312      	lsls	r2, r2, #12
     b32:	430a      	orrs	r2, r1
     b34:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     b36:	681a      	ldr	r2, [r3, #0]
     b38:	2105      	movs	r1, #5
     b3a:	f7ff fb6b 	bl	214 <mbus_remote_register_write>
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
     b3e:	4b85      	ldr	r3, [pc, #532]	; (d54 <main+0x67c>)
     b40:	2101      	movs	r1, #1
     b42:	781a      	ldrb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
     b44:	2003      	movs	r0, #3
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
     b46:	438a      	bics	r2, r1
     b48:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
     b4a:	681a      	ldr	r2, [r3, #0]
     b4c:	2106      	movs	r1, #6
     b4e:	f7ff fb61 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     b52:	20fa      	movs	r0, #250	; 0xfa
     b54:	40a0      	lsls	r0, r4
     b56:	f7ff faa6 	bl	a6 <delay>
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
     b5a:	4b7f      	ldr	r3, [pc, #508]	; (d58 <main+0x680>)
     b5c:	497f      	ldr	r1, [pc, #508]	; (d5c <main+0x684>)
     b5e:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
     b60:	2003      	movs	r0, #3
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
     b62:	430a      	orrs	r2, r1
     b64:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
     b66:	681a      	ldr	r2, [r3, #0]
     b68:	1c01      	adds	r1, r0, #0
     b6a:	f7ff fb53 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     b6e:	20fa      	movs	r0, #250	; 0xfa
     b70:	40a0      	lsls	r0, r4
     b72:	f7ff fa98 	bl	a6 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
     b76:	4b7a      	ldr	r3, [pc, #488]	; (d60 <main+0x688>)
     b78:	210a      	movs	r1, #10
     b7a:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
     b7c:	2003      	movs	r0, #3
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
     b7e:	0b12      	lsrs	r2, r2, #12
     b80:	0312      	lsls	r2, r2, #12
     b82:	430a      	orrs	r2, r1
     b84:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
     b86:	681a      	ldr	r2, [r3, #0]
     b88:	2104      	movs	r1, #4
     b8a:	f7ff fb43 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     b8e:	20fa      	movs	r0, #250	; 0xfa
     b90:	40a0      	lsls	r0, r4
     b92:	f7ff fa88 	bl	a6 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
     b96:	4d73      	ldr	r5, [pc, #460]	; (d64 <main+0x68c>)
     b98:	2201      	movs	r2, #1
     b9a:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
     b9c:	2100      	movs	r1, #0
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
     b9e:	4393      	bics	r3, r2
     ba0:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
     ba2:	682a      	ldr	r2, [r5, #0]
     ba4:	2003      	movs	r0, #3
     ba6:	f7ff fb35 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     baa:	20fa      	movs	r0, #250	; 0xfa
     bac:	40a0      	lsls	r0, r4
     bae:	f7ff fa7a 	bl	a6 <delay>
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
     bb2:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
     bb4:	2100      	movs	r1, #0
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
     bb6:	43a3      	bics	r3, r4
     bb8:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
     bba:	682a      	ldr	r2, [r5, #0]
     bbc:	2003      	movs	r0, #3
     bbe:	f7ff fb29 	bl	214 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     bc2:	20fa      	movs	r0, #250	; 0xfa
     bc4:	40a0      	lsls	r0, r4
     bc6:	f7ff fa6e 	bl	a6 <delay>

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
     bca:	4e67      	ldr	r6, [pc, #412]	; (d68 <main+0x690>)
     bcc:	4957      	ldr	r1, [pc, #348]	; (d2c <main+0x654>)
     bce:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     bd0:	1c20      	adds	r0, r4, #0

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
     bd2:	400b      	ands	r3, r1
     bd4:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     bd6:	6832      	ldr	r2, [r6, #0]
     bd8:	2103      	movs	r1, #3
     bda:	f7ff fb1b 	bl	214 <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
     bde:	6832      	ldr	r2, [r6, #0]
     be0:	2380      	movs	r3, #128	; 0x80
     be2:	02db      	lsls	r3, r3, #11
     be4:	4313      	orrs	r3, r2
     be6:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     be8:	6832      	ldr	r2, [r6, #0]
     bea:	1c20      	adds	r0, r4, #0
     bec:	2103      	movs	r1, #3
     bee:	f7ff fb11 	bl	214 <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     bf2:	4f5e      	ldr	r7, [pc, #376]	; (d6c <main+0x694>)
     bf4:	227e      	movs	r2, #126	; 0x7e
     bf6:	683b      	ldr	r3, [r7, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     bf8:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     bfa:	4393      	bics	r3, r2
     bfc:	2210      	movs	r2, #16
     bfe:	4313      	orrs	r3, r2
     c00:	603b      	str	r3, [r7, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     c02:	683a      	ldr	r2, [r7, #0]
     c04:	2100      	movs	r1, #0
     c06:	f7ff fb05 	bl	214 <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
     c0a:	683b      	ldr	r3, [r7, #0]
     c0c:	2101      	movs	r1, #1
     c0e:	430b      	orrs	r3, r1
     c10:	603b      	str	r3, [r7, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     c12:	683a      	ldr	r2, [r7, #0]
     c14:	2100      	movs	r1, #0
     c16:	1c20      	adds	r0, r4, #0
     c18:	f7ff fafc 	bl	214 <mbus_remote_register_write>

    // Wait for charging decap
    config_timerwd(TIMERWD_VAL);
     c1c:	484f      	ldr	r0, [pc, #316]	; (d5c <main+0x684>)
     c1e:	f7ff fa67 	bl	f0 <config_timerwd>
    *REG_MBUS_WD = 1500000*3; // default: 1500000
     c22:	4b53      	ldr	r3, [pc, #332]	; (d70 <main+0x698>)
     c24:	4a53      	ldr	r2, [pc, #332]	; (d74 <main+0x69c>)
    delay(MBUS_DELAY*200); // Wait for decap to charge
     c26:	4854      	ldr	r0, [pc, #336]	; (d78 <main+0x6a0>)
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Wait for charging decap
    config_timerwd(TIMERWD_VAL);
    *REG_MBUS_WD = 1500000*3; // default: 1500000
     c28:	6013      	str	r3, [r2, #0]
    delay(MBUS_DELAY*200); // Wait for decap to charge
     c2a:	f7ff fa3c 	bl	a6 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
     c2e:	4b53      	ldr	r3, [pc, #332]	; (d7c <main+0x6a4>)
     c30:	2103      	movs	r1, #3
     c32:	781a      	ldrb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
     c34:	1c20      	adds	r0, r4, #0
    // Wait for charging decap
    config_timerwd(TIMERWD_VAL);
    *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
     c36:	430a      	orrs	r2, r1
     c38:	701a      	strb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
     c3a:	781a      	ldrb	r2, [r3, #0]
     c3c:	210c      	movs	r1, #12
     c3e:	430a      	orrs	r2, r1
     c40:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
     c42:	681a      	ldr	r2, [r3, #0]
     c44:	211f      	movs	r1, #31
     c46:	f7ff fae5 	bl	214 <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
     c4a:	4b4d      	ldr	r3, [pc, #308]	; (d80 <main+0x6a8>)
     c4c:	210c      	movs	r1, #12
     c4e:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
     c50:	4d4c      	ldr	r5, [pc, #304]	; (d84 <main+0x6ac>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
     c52:	0a92      	lsrs	r2, r2, #10
     c54:	0292      	lsls	r2, r2, #10
     c56:	430a      	orrs	r2, r1
     c58:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
     c5a:	682a      	ldr	r2, [r5, #0]
     c5c:	494a      	ldr	r1, [pc, #296]	; (d88 <main+0x6b0>)
     c5e:	0bd2      	lsrs	r2, r2, #15
     c60:	03d2      	lsls	r2, r2, #15
     c62:	430a      	orrs	r2, r1
     c64:	602a      	str	r2, [r5, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
     c66:	6819      	ldr	r1, [r3, #0]
     c68:	4a48      	ldr	r2, [pc, #288]	; (d8c <main+0x6b4>)

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
     c6a:	1c20      	adds	r0, r4, #0

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
     c6c:	400a      	ands	r2, r1
     c6e:	21c8      	movs	r1, #200	; 0xc8
     c70:	01c9      	lsls	r1, r1, #7
     c72:	430a      	orrs	r2, r1
     c74:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
     c76:	681a      	ldr	r2, [r3, #0]
     c78:	2112      	movs	r1, #18
     c7a:	f7ff facb 	bl	214 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
     c7e:	682a      	ldr	r2, [r5, #0]
     c80:	1c20      	adds	r0, r4, #0
     c82:	2113      	movs	r1, #19
     c84:	f7ff fac6 	bl	214 <mbus_remote_register_write>
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
     c88:	4b41      	ldr	r3, [pc, #260]	; (d90 <main+0x6b8>)
     c8a:	2205      	movs	r2, #5
     c8c:	701a      	strb	r2, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
     c8e:	4b41      	ldr	r3, [pc, #260]	; (d94 <main+0x6bc>)

    mrr_cfo_val_fine_min = 0x0000;
     c90:	4a41      	ldr	r2, [pc, #260]	; (d98 <main+0x6c0>)
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
    mrr_freq_hopping_step = 4; // determining center freq
     c92:	2104      	movs	r1, #4
     c94:	7019      	strb	r1, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
     c96:	2300      	movs	r3, #0
     c98:	8013      	strh	r3, [r2, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
     c9a:	2280      	movs	r2, #128	; 0x80
     c9c:	1c20      	adds	r0, r4, #0
     c9e:	2106      	movs	r1, #6
     ca0:	0152      	lsls	r2, r2, #5
     ca2:	f7ff fab7 	bl	214 <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
     ca6:	2280      	movs	r2, #128	; 0x80
     ca8:	1c20      	adds	r0, r4, #0
     caa:	2108      	movs	r1, #8
     cac:	03d2      	lsls	r2, r2, #15
     cae:	f7ff fab1 	bl	214 <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
     cb2:	4b3a      	ldr	r3, [pc, #232]	; (d9c <main+0x6c4>)
     cb4:	217f      	movs	r1, #127	; 0x7f
     cb6:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
     cb8:	1c20      	adds	r0, r4, #0

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
     cba:	438a      	bics	r2, r1
     cbc:	2110      	movs	r1, #16
     cbe:	430a      	orrs	r2, r1
     cc0:	801a      	strh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
     cc2:	8819      	ldrh	r1, [r3, #0]
     cc4:	4a36      	ldr	r2, [pc, #216]	; (da0 <main+0x6c8>)
     cc6:	400a      	ands	r2, r1
     cc8:	2180      	movs	r1, #128	; 0x80
     cca:	0109      	lsls	r1, r1, #4
     ccc:	430a      	orrs	r2, r1
     cce:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
     cd0:	681a      	ldr	r2, [r3, #0]
     cd2:	2107      	movs	r1, #7
     cd4:	f7ff fa9e 	bl	214 <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
     cd8:	683a      	ldr	r2, [r7, #0]
     cda:	4b32      	ldr	r3, [pc, #200]	; (da4 <main+0x6cc>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     cdc:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
     cde:	4013      	ands	r3, r2
     ce0:	22e0      	movs	r2, #224	; 0xe0
     ce2:	40a2      	lsls	r2, r4
     ce4:	4313      	orrs	r3, r2
     ce6:	603b      	str	r3, [r7, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     ce8:	683a      	ldr	r2, [r7, #0]
     cea:	2100      	movs	r1, #0
     cec:	f7ff fa92 	bl	214 <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
     cf0:	4b2d      	ldr	r3, [pc, #180]	; (da8 <main+0x6d0>)
     cf2:	2107      	movs	r1, #7
     cf4:	681a      	ldr	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
     cf6:	273f      	movs	r7, #63	; 0x3f
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
     cf8:	0a92      	lsrs	r2, r2, #10
     cfa:	0292      	lsls	r2, r2, #10
     cfc:	e056      	b.n	dac <main+0x6d4>
     cfe:	46c0      	nop			; (mov r8, r8)
     d00:	00001128 	.word	0x00001128
     d04:	00001090 	.word	0x00001090
     d08:	0000108c 	.word	0x0000108c
     d0c:	00001110 	.word	0x00001110
     d10:	0000109c 	.word	0x0000109c
     d14:	ff1fffff 	.word	0xff1fffff
     d18:	ffe0007f 	.word	0xffe0007f
     d1c:	001ffe80 	.word	0x001ffe80
     d20:	000010c8 	.word	0x000010c8
     d24:	ffff00ff 	.word	0xffff00ff
     d28:	000010a4 	.word	0x000010a4
     d2c:	fff7ffff 	.word	0xfff7ffff
     d30:	ffdfffff 	.word	0xffdfffff
     d34:	00001174 	.word	0x00001174
     d38:	000186a0 	.word	0x000186a0
     d3c:	00001170 	.word	0x00001170
     d40:	00001080 	.word	0x00001080
     d44:	00001084 	.word	0x00001084
     d48:	fffffe7f 	.word	0xfffffe7f
     d4c:	000010b4 	.word	0x000010b4
     d50:	ff000fff 	.word	0xff000fff
     d54:	0000116c 	.word	0x0000116c
     d58:	000010ac 	.word	0x000010ac
     d5c:	00ffffff 	.word	0x00ffffff
     d60:	000010b0 	.word	0x000010b0
     d64:	0000107c 	.word	0x0000107c
     d68:	000010c0 	.word	0x000010c0
     d6c:	000010b8 	.word	0x000010b8
     d70:	0044aa20 	.word	0x0044aa20
     d74:	a000007c 	.word	0xa000007c
     d78:	00004e20 	.word	0x00004e20
     d7c:	000010a0 	.word	0x000010a0
     d80:	000010d0 	.word	0x000010d0
     d84:	000010d4 	.word	0x000010d4
     d88:	00000451 	.word	0x00000451
     d8c:	fff003ff 	.word	0xfff003ff
     d90:	000010f8 	.word	0x000010f8
     d94:	0000115c 	.word	0x0000115c
     d98:	000010ec 	.word	0x000010ec
     d9c:	00001094 	.word	0x00001094
     da0:	ffffc07f 	.word	0xffffc07f
     da4:	fffe007f 	.word	0xfffe007f
     da8:	00001178 	.word	0x00001178
     dac:	430a      	orrs	r2, r1
     dae:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
     db0:	4a93      	ldr	r2, [pc, #588]	; (1000 <main+0x928>)
     db2:	8811      	ldrh	r1, [r2, #0]
     db4:	6818      	ldr	r0, [r3, #0]
     db6:	4a93      	ldr	r2, [pc, #588]	; (1004 <main+0x92c>)
     db8:	4039      	ands	r1, r7
     dba:	0409      	lsls	r1, r1, #16
     dbc:	4002      	ands	r2, r0
     dbe:	430a      	orrs	r2, r1
     dc0:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
     dc2:	4a8f      	ldr	r2, [pc, #572]	; (1000 <main+0x928>)
     dc4:	8811      	ldrh	r1, [r2, #0]
     dc6:	6818      	ldr	r0, [r3, #0]
     dc8:	4a8f      	ldr	r2, [pc, #572]	; (1008 <main+0x930>)
     dca:	4039      	ands	r1, r7
     dcc:	0289      	lsls	r1, r1, #10
     dce:	4002      	ands	r2, r0
     dd0:	430a      	orrs	r2, r1
     dd2:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
     dd4:	681a      	ldr	r2, [r3, #0]
     dd6:	1c20      	adds	r0, r4, #0
     dd8:	2101      	movs	r1, #1
     dda:	f7ff fa1b 	bl	214 <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
     dde:	4b8b      	ldr	r3, [pc, #556]	; (100c <main+0x934>)
     de0:	498b      	ldr	r1, [pc, #556]	; (1010 <main+0x938>)
     de2:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
     de4:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
     de6:	430a      	orrs	r2, r1
     de8:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
     dea:	681a      	ldr	r2, [r3, #0]
     dec:	1c21      	adds	r1, r4, #0
     dee:	f7ff fa11 	bl	214 <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
     df2:	6832      	ldr	r2, [r6, #0]
     df4:	4b87      	ldr	r3, [pc, #540]	; (1014 <main+0x93c>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     df6:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
     df8:	4013      	ands	r3, r2
     dfa:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     dfc:	6832      	ldr	r2, [r6, #0]
     dfe:	2103      	movs	r1, #3
     e00:	f7ff fa08 	bl	214 <mbus_remote_register_write>

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
     e04:	4b84      	ldr	r3, [pc, #528]	; (1018 <main+0x940>)
     e06:	4a85      	ldr	r2, [pc, #532]	; (101c <main+0x944>)
     e08:	6819      	ldr	r1, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
     e0a:	4e85      	ldr	r6, [pc, #532]	; (1020 <main+0x948>)

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
     e0c:	400a      	ands	r2, r1
     e0e:	601a      	str	r2, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
     e10:	6832      	ldr	r2, [r6, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
     e12:	1c20      	adds	r0, r4, #0
    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
     e14:	43ba      	bics	r2, r7
     e16:	6032      	str	r2, [r6, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
     e18:	6831      	ldr	r1, [r6, #0]
     e1a:	4a82      	ldr	r2, [pc, #520]	; (1024 <main+0x94c>)
     e1c:	400a      	ands	r2, r1
     e1e:	6032      	str	r2, [r6, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
     e20:	6831      	ldr	r1, [r6, #0]
     e22:	4a81      	ldr	r2, [pc, #516]	; (1028 <main+0x950>)
     e24:	400a      	ands	r2, r1
     e26:	6032      	str	r2, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
     e28:	681a      	ldr	r2, [r3, #0]
     e2a:	2114      	movs	r1, #20
     e2c:	f7ff f9f2 	bl	214 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
     e30:	6832      	ldr	r2, [r6, #0]
     e32:	1c20      	adds	r0, r4, #0
     e34:	2115      	movs	r1, #21
     e36:	f7ff f9ed 	bl	214 <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
     e3a:	1c20      	adds	r0, r4, #0
     e3c:	2109      	movs	r1, #9
     e3e:	2200      	movs	r2, #0
     e40:	f7ff f9e8 	bl	214 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
     e44:	1c20      	adds	r0, r4, #0
     e46:	210a      	movs	r1, #10
     e48:	2200      	movs	r2, #0
     e4a:	f7ff f9e3 	bl	214 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
     e4e:	1c20      	adds	r0, r4, #0
     e50:	210b      	movs	r1, #11
     e52:	2200      	movs	r2, #0
     e54:	f7ff f9de 	bl	214 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
     e58:	1c20      	adds	r0, r4, #0
     e5a:	210c      	movs	r1, #12
     e5c:	4a73      	ldr	r2, [pc, #460]	; (102c <main+0x954>)
     e5e:	f7ff f9d9 	bl	214 <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
     e62:	4b73      	ldr	r3, [pc, #460]	; (1030 <main+0x958>)
     e64:	21f8      	movs	r1, #248	; 0xf8
     e66:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     e68:	1c20      	adds	r0, r4, #0
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
     e6a:	438a      	bics	r2, r1
     e6c:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
     e6e:	881a      	ldrh	r2, [r3, #0]
     e70:	4970      	ldr	r1, [pc, #448]	; (1034 <main+0x95c>)
     e72:	b2d2      	uxtb	r2, r2
     e74:	430a      	orrs	r2, r1
     e76:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     e78:	681a      	ldr	r2, [r3, #0]
     e7a:	2111      	movs	r1, #17
     e7c:	f7ff f9ca 	bl	214 <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
     e80:	682b      	ldr	r3, [r5, #0]
     e82:	496d      	ldr	r1, [pc, #436]	; (1038 <main+0x960>)
     e84:	22c0      	movs	r2, #192	; 0xc0
     e86:	400b      	ands	r3, r1
     e88:	03d2      	lsls	r2, r2, #15
     e8a:	4313      	orrs	r3, r2
     e8c:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
     e8e:	682a      	ldr	r2, [r5, #0]
     e90:	1c20      	adds	r0, r4, #0
     e92:	2113      	movs	r1, #19
     e94:	f7ff f9be 	bl	214 <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
     e98:	211e      	movs	r1, #30
     e9a:	4a68      	ldr	r2, [pc, #416]	; (103c <main+0x964>)
     e9c:	1c20      	adds	r0, r4, #0
     e9e:	f7ff f9b9 	bl	214 <mbus_remote_register_write>

    // Additional delay for charging decap
    config_timerwd(TIMERWD_VAL);
     ea2:	4867      	ldr	r0, [pc, #412]	; (1040 <main+0x968>)
     ea4:	f7ff f924 	bl	f0 <config_timerwd>
    *REG_MBUS_WD = 1500000; // default: 1500000
     ea8:	4b66      	ldr	r3, [pc, #408]	; (1044 <main+0x96c>)
     eaa:	4a67      	ldr	r2, [pc, #412]	; (1048 <main+0x970>)
    delay(MBUS_DELAY*200); // Wait for decap to charge
     eac:	4867      	ldr	r0, [pc, #412]	; (104c <main+0x974>)
    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);

    // Additional delay for charging decap
    config_timerwd(TIMERWD_VAL);
    *REG_MBUS_WD = 1500000; // default: 1500000
     eae:	6013      	str	r3, [r2, #0]
    delay(MBUS_DELAY*200); // Wait for decap to charge
     eb0:	f7ff f8f9 	bl	a6 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
     eb4:	4b66      	ldr	r3, [pc, #408]	; (1050 <main+0x978>)
     eb6:	2100      	movs	r1, #0
     eb8:	7019      	strb	r1, [r3, #0]
    radio_ready = 0;
     eba:	4b66      	ldr	r3, [pc, #408]	; (1054 <main+0x97c>)
                     (ratio)));  // binary converter's conversion ratio (7'h00)
    }
}

static void pmu_setting_temp_based() {
    mbus_write_message32(0xB7, pmu_setting_state);
     ebc:	4e66      	ldr	r6, [pc, #408]	; (1058 <main+0x980>)
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    radio_ready = 0;
     ebe:	7019      	strb	r1, [r3, #0]
                     (ratio)));  // binary converter's conversion ratio (7'h00)
    }
}

static void pmu_setting_temp_based() {
    mbus_write_message32(0xB7, pmu_setting_state);
     ec0:	6831      	ldr	r1, [r6, #0]
     ec2:	20b7      	movs	r0, #183	; 0xb7
     ec4:	f7ff f976 	bl	1b4 <mbus_write_message32>
    if(pmu_setting_state == PMU_10C) {
     ec8:	6837      	ldr	r7, [r6, #0]
     eca:	42a7      	cmp	r7, r4
     ecc:	d109      	bne.n	ee2 <main+0x80a>
        pmu_set_active_clk(0xD, 0x2, 0x10, 0x4/*V1P2*/);
     ece:	200d      	movs	r0, #13
     ed0:	1c39      	adds	r1, r7, #0
     ed2:	2210      	movs	r2, #16
     ed4:	2304      	movs	r3, #4
     ed6:	f7ff f9b7 	bl	248 <pmu_set_active_clk>
        pmu_set_sleep_clk(0xF, 0x1, 0x1, 0x2/*V1P2*/);
     eda:	200f      	movs	r0, #15
     edc:	2101      	movs	r1, #1
     ede:	1c3a      	adds	r2, r7, #0
     ee0:	e043      	b.n	f6a <main+0x892>
    }
    else if(pmu_setting_state == PMU_20C) {
     ee2:	6833      	ldr	r3, [r6, #0]
     ee4:	2b03      	cmp	r3, #3
     ee6:	d109      	bne.n	efc <main+0x824>
    	pmu_set_active_clk(0xD, 0x2, 0x0f, 0xf/*V1P2*/);
     ee8:	220f      	movs	r2, #15
     eea:	200d      	movs	r0, #13
     eec:	1c21      	adds	r1, r4, #0
     eee:	1c13      	adds	r3, r2, #0
     ef0:	f7ff f9aa 	bl	248 <pmu_set_active_clk>
		pmu_set_sleep_clk(0xF, 0x1, 0x1, 0x2/*V1P2*/);
     ef4:	200f      	movs	r0, #15
     ef6:	2101      	movs	r1, #1
     ef8:	1c22      	adds	r2, r4, #0
     efa:	e036      	b.n	f6a <main+0x892>
	    //    pmu_set_sleep_low();
    }
    else if(pmu_setting_state == PMU_25C) {
     efc:	6833      	ldr	r3, [r6, #0]
     efe:	2b04      	cmp	r3, #4
     f00:	d108      	bne.n	f14 <main+0x83c>
        pmu_set_active_clk(0x5, 0x1, 0x10, 0x2/*V1P2*/);
     f02:	2005      	movs	r0, #5
     f04:	2101      	movs	r1, #1
     f06:	2210      	movs	r2, #16
     f08:	1c23      	adds	r3, r4, #0
     f0a:	f7ff f99d 	bl	248 <pmu_set_active_clk>
        pmu_set_sleep_clk(0x2, 0x1, 0x1, 0x1/*V1P2*/);
     f0e:	1c20      	adds	r0, r4, #0
     f10:	2101      	movs	r1, #1
     f12:	e029      	b.n	f68 <main+0x890>
        //pmu_set_sleep_low();
    }
    else if(pmu_setting_state == PMU_35C) {
     f14:	6833      	ldr	r3, [r6, #0]
     f16:	2b05      	cmp	r3, #5
     f18:	d109      	bne.n	f2e <main+0x856>
        pmu_set_active_clk(0x2, 0x1, 0x10, 0x2/*V1P2*/);
     f1a:	1c20      	adds	r0, r4, #0
     f1c:	2101      	movs	r1, #1
     f1e:	2210      	movs	r2, #16
     f20:	1c23      	adds	r3, r4, #0
     f22:	f7ff f991 	bl	248 <pmu_set_active_clk>
        pmu_set_sleep_clk(0x2, 0x0, 0x1, 0x1/*V1P2*/);
     f26:	1c20      	adds	r0, r4, #0
     f28:	2100      	movs	r1, #0
     f2a:	2201      	movs	r2, #1
     f2c:	e01d      	b.n	f6a <main+0x892>
    }
    else if(pmu_setting_state == PMU_55C) {
     f2e:	6833      	ldr	r3, [r6, #0]
     f30:	2b06      	cmp	r3, #6
     f32:	d104      	bne.n	f3e <main+0x866>
        pmu_set_active_clk(0x1, 0x0, 0x10, 0x2/*V1P2*/);
     f34:	2001      	movs	r0, #1
     f36:	2100      	movs	r1, #0
     f38:	2210      	movs	r2, #16
     f3a:	1c23      	adds	r3, r4, #0
     f3c:	e005      	b.n	f4a <main+0x872>
        pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_75C) {
     f3e:	6832      	ldr	r2, [r6, #0]
     f40:	2a07      	cmp	r2, #7
     f42:	d106      	bne.n	f52 <main+0x87a>
        pmu_set_active_clk(0xA, 0x4, 0x7, 0x8/*V1P2*/);
     f44:	200a      	movs	r0, #10
     f46:	2104      	movs	r1, #4
     f48:	2308      	movs	r3, #8
     f4a:	f7ff f97d 	bl	248 <pmu_set_active_clk>
        pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
     f4e:	2001      	movs	r0, #1
     f50:	e7de      	b.n	f10 <main+0x838>
    }
    else if(pmu_setting_state == PMU_95C) {
     f52:	6833      	ldr	r3, [r6, #0]
     f54:	2b08      	cmp	r3, #8
     f56:	d10a      	bne.n	f6e <main+0x896>
        pmu_set_active_clk(0x7, 0x2, 0x7, 0x4/*V1P2*/);
     f58:	2007      	movs	r0, #7
     f5a:	1c21      	adds	r1, r4, #0
     f5c:	1c02      	adds	r2, r0, #0
     f5e:	2304      	movs	r3, #4
     f60:	f7ff f972 	bl	248 <pmu_set_active_clk>
        pmu_set_sleep_clk(0x1, 0x0, 0x1, 0x0/*V1P2*/);
     f64:	2001      	movs	r0, #1
     f66:	2100      	movs	r1, #0
     f68:	1c0a      	adds	r2, r1, #0
     f6a:	f7ff f9fd 	bl	368 <pmu_set_sleep_clk.constprop.1>
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based();
    // Use the new reset scheme in PMUv3
    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
     f6e:	2005      	movs	r0, #5
     f70:	493a      	ldr	r1, [pc, #232]	; (105c <main+0x984>)
     f72:	f7ff f95c 	bl	22e <pmu_reg_write>
                 (0 << 10) |    // have the converter have the periodic reset (1'h0)
                 (0 <<  9) |    // enable override setting [8:0] (1'h0)
                 (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                 (0 <<  7) |    // enable override setting [6:0] (1'h0)
                 (52)));        // binary converter's conversion ratio (7'h00)
    pmu_reg_write(0x05,         // default 12'h000
     f76:	2005      	movs	r0, #5
     f78:	4939      	ldr	r1, [pc, #228]	; (1060 <main+0x988>)
     f7a:	f7ff f958 	bl	22e <pmu_reg_write>
    }
}

inline static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
     f7e:	2186      	movs	r1, #134	; 0x86
     f80:	200e      	movs	r0, #14
     f82:	00c9      	lsls	r1, r1, #3
     f84:	f7ff f953 	bl	22e <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
     f88:	2045      	movs	r0, #69	; 0x45
     f8a:	2148      	movs	r1, #72	; 0x48
     f8c:	f7ff f94f 	bl	22e <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
     f90:	203a      	movs	r0, #58	; 0x3a
     f92:	4934      	ldr	r1, [pc, #208]	; (1064 <main+0x98c>)
     f94:	f7ff f94b 	bl	22e <pmu_reg_write>
}
*/
inline static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
     f98:	203c      	movs	r0, #60	; 0x3c
     f9a:	4933      	ldr	r1, [pc, #204]	; (1068 <main+0x990>)
     f9c:	f7ff f947 	bl	22e <pmu_reg_write>

inline static void pmu_adc_enable() {
    // PMU ADC will be automatically reset when system wakes up
    // PMU_CONTROLLER_DESIRED_STATE sleep
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
     fa0:	203b      	movs	r0, #59	; 0x3b
     fa2:	4932      	ldr	r1, [pc, #200]	; (106c <main+0x994>)
     fa4:	f7ff f943 	bl	22e <pmu_reg_write>

inline static void pmu_adc_read_latest() {
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
     fa8:	2103      	movs	r1, #3
     faa:	2000      	movs	r0, #0
     fac:	f7ff f93f 	bl	22e <pmu_reg_write>
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
     fb0:	23a0      	movs	r3, #160	; 0xa0
     fb2:	061b      	lsls	r3, r3, #24
     fb4:	681a      	ldr	r2, [r3, #0]
     fb6:	4b2e      	ldr	r3, [pc, #184]	; (1070 <main+0x998>)
     fb8:	801a      	strh	r2, [r3, #0]

    if(read_data_batadc < MRR_VOLT_THRESH) {
     fba:	8819      	ldrh	r1, [r3, #0]
     fbc:	4a2d      	ldr	r2, [pc, #180]	; (1074 <main+0x99c>)
     fbe:	294a      	cmp	r1, #74	; 0x4a
     fc0:	d801      	bhi.n	fc6 <main+0x8ee>
        read_data_batadc_diff = 0;
     fc2:	2100      	movs	r1, #0
     fc4:	e001      	b.n	fca <main+0x8f2>
    }
    else {
        read_data_batadc_diff = read_data_batadc - MRR_VOLT_THRESH;
     fc6:	8819      	ldrh	r1, [r3, #0]
     fc8:	394b      	subs	r1, #75	; 0x4b
     fca:	8011      	strh	r1, [r2, #0]

    if(enumerated != ENUMID) {
        operation_init();
    }
    pmu_adc_read_latest();
    mbus_write_message32(0xAA, read_data_batadc);
     fcc:	8819      	ldrh	r1, [r3, #0]
     fce:	20aa      	movs	r0, #170	; 0xaa
     fd0:	f7ff f8f0 	bl	1b4 <mbus_write_message32>

    update_system_time();
     fd4:	f7ff faa4 	bl	520 <update_system_time>

    set_xo_timer(0, 15 << 15, 1, 0);
     fd8:	2000      	movs	r0, #0
     fda:	21f0      	movs	r1, #240	; 0xf0
     fdc:	1c03      	adds	r3, r0, #0
     fde:	02c9      	lsls	r1, r1, #11
     fe0:	2201      	movs	r2, #1
     fe2:	f7ff f8b1 	bl	148 <set_xo_timer>
    start_xo_cnt();
     fe6:	f7ff f8d3 	bl	190 <start_xo_cnt>
    set_wakeup_timer(500, 0x1, 0x1); // 2500 = 5:13 sleep on #5
     fea:	2101      	movs	r1, #1
     fec:	20fa      	movs	r0, #250	; 0xfa
     fee:	0040      	lsls	r0, r0, #1
     ff0:	1c0a      	adds	r2, r1, #0
     ff2:	f7ff f889 	bl	108 <set_wakeup_timer>
	delay(200000);
     ff6:	4820      	ldr	r0, [pc, #128]	; (1078 <main+0x9a0>)
     ff8:	f7ff f855 	bl	a6 <delay>

    operation_sleep();
     ffc:	f7ff f944 	bl	288 <operation_sleep>
    1000:	000010ec 	.word	0x000010ec
    1004:	ffc0ffff 	.word	0xffc0ffff
    1008:	ffff03ff 	.word	0xffff03ff
    100c:	000010bc 	.word	0x000010bc
    1010:	00001fff 	.word	0x00001fff
    1014:	ffffbfff 	.word	0xffffbfff
    1018:	000010d8 	.word	0x000010d8
    101c:	fff8ffff 	.word	0xfff8ffff
    1020:	000010dc 	.word	0x000010dc
    1024:	fffff03f 	.word	0xfffff03f
    1028:	fff80fff 	.word	0xfff80fff
    102c:	007ac800 	.word	0x007ac800
    1030:	000010cc 	.word	0x000010cc
    1034:	ffffc000 	.word	0xffffc000
    1038:	ff1fffff 	.word	0xff1fffff
    103c:	00001002 	.word	0x00001002
    1040:	00ffffff 	.word	0x00ffffff
    1044:	0016e360 	.word	0x0016e360
    1048:	a000007c 	.word	0xa000007c
    104c:	00004e20 	.word	0x00004e20
    1050:	00001168 	.word	0x00001168
    1054:	000010ee 	.word	0x000010ee
    1058:	0000111c 	.word	0x0000111c
    105c:	00000834 	.word	0x00000834
    1060:	00002ab4 	.word	0x00002ab4
    1064:	00103800 	.word	0x00103800
    1068:	0017c7ff 	.word	0x0017c7ff
    106c:	0017efff 	.word	0x0017efff
    1070:	00001126 	.word	0x00001126
    1074:	000010f0 	.word	0x000010f0
    1078:	00030d40 	.word	0x00030d40
