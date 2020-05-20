
mbc_pmu_adjust/mbc_pmu_adjust.elf:     file format elf32-littlearm


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
  40:	00000bad 	.word	0x00000bad
  44:	00000000 	.word	0x00000000
  48:	00000bb9 	.word	0x00000bb9
  4c:	00000bd1 	.word	0x00000bd1
	...
  60:	00000c05 	.word	0x00000c05
  64:	00000c15 	.word	0x00000c15
  68:	00000c25 	.word	0x00000c25
  6c:	00000c35 	.word	0x00000c35
	...
  8c:	00000bf1 	.word	0x00000bf1

00000090 <hang>:
  90:	e7fe      	b.n	90 <hang>
	...

000000a0 <_start>:
  a0:	f000 fdd0 	bl	c44 <main>
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

Disassembly of section .text.set_wakeup_timer:

000000f0 <set_wakeup_timer>:

void enable_timerwd(){
	*TIMERWD_GO  = 0x1;
}

void set_wakeup_timer( uint32_t timestamp, uint8_t irq_en, uint8_t reset ){
  f0:	b500      	push	{lr}
	uint32_t regval = timestamp;
	if( irq_en ) regval |= 0x800000; // IRQ in Sleep-Only
  f2:	2900      	cmp	r1, #0
  f4:	d003      	beq.n	fe <set_wakeup_timer+0xe>
  f6:	2380      	movs	r3, #128	; 0x80
  f8:	041b      	lsls	r3, r3, #16
  fa:	4318      	orrs	r0, r3
  fc:	e001      	b.n	102 <set_wakeup_timer+0x12>
	else		 regval &= 0x3FFFFF;
  fe:	0280      	lsls	r0, r0, #10
 100:	0a80      	lsrs	r0, r0, #10
    *REG_WUPT_CONFIG = regval;
 102:	4b04      	ldr	r3, [pc, #16]	; (114 <set_wakeup_timer+0x24>)
 104:	6018      	str	r0, [r3, #0]

	if( reset ) *WUPT_RESET = 0x01;
 106:	2a00      	cmp	r2, #0
 108:	d002      	beq.n	110 <set_wakeup_timer+0x20>
 10a:	4b03      	ldr	r3, [pc, #12]	; (118 <set_wakeup_timer+0x28>)
 10c:	2201      	movs	r2, #1
 10e:	601a      	str	r2, [r3, #0]
}
 110:	bd00      	pop	{pc}
 112:	46c0      	nop			; (mov r8, r8)
 114:	a0000044 	.word	0xa0000044
 118:	a0001300 	.word	0xa0001300

Disassembly of section .text.set_xo_timer:

0000011c <set_xo_timer>:
    uint32_t regval = *REG_XOT_CONFIG;
    regval &= 0x7FFFFF; // XOT_ENABLE = 0;
    *REG_XOT_CONFIG = regval;
}

void set_xo_timer (uint8_t mode, uint32_t timestamp, uint8_t wreq_en, uint8_t irq_en) {
 11c:	b510      	push	{r4, lr}
    uint32_t regval0 = timestamp & 0x0000FFFF;
 11e:	b28c      	uxth	r4, r1
    uint32_t regval1 = (timestamp >> 16) & 0xFFFF;
 120:	0c09      	lsrs	r1, r1, #16
    // uint32_t regval1 = timestamp & 0xFFFF0000;	// This is wrong

    regval0 |= 0x00800000; // XOT_ENABLE = 1;
    if (mode)    regval0 |= 0x00400000; // XOT_MODE = 1
 122:	2800      	cmp	r0, #0
 124:	d101      	bne.n	12a <set_xo_timer+0xe>
void set_xo_timer (uint8_t mode, uint32_t timestamp, uint8_t wreq_en, uint8_t irq_en) {
    uint32_t regval0 = timestamp & 0x0000FFFF;
    uint32_t regval1 = (timestamp >> 16) & 0xFFFF;
    // uint32_t regval1 = timestamp & 0xFFFF0000;	// This is wrong

    regval0 |= 0x00800000; // XOT_ENABLE = 1;
 126:	2080      	movs	r0, #128	; 0x80
 128:	e000      	b.n	12c <set_xo_timer+0x10>
    if (mode)    regval0 |= 0x00400000; // XOT_MODE = 1
 12a:	20c0      	movs	r0, #192	; 0xc0
 12c:	0400      	lsls	r0, r0, #16
 12e:	4320      	orrs	r0, r4
    if (wreq_en) regval0 |= 0x00200000; // XOT_WREQ_EN = 1
 130:	2a00      	cmp	r2, #0
 132:	d002      	beq.n	13a <set_xo_timer+0x1e>
 134:	2280      	movs	r2, #128	; 0x80
 136:	0392      	lsls	r2, r2, #14
 138:	4310      	orrs	r0, r2
    if (irq_en)  regval0 |= 0x00100000; // XOT_IRQ_EN = 1
 13a:	2b00      	cmp	r3, #0
 13c:	d002      	beq.n	144 <set_xo_timer+0x28>
 13e:	2380      	movs	r3, #128	; 0x80
 140:	035b      	lsls	r3, r3, #13
 142:	4318      	orrs	r0, r3

    *REG_XOT_CONFIGU = regval1;
 144:	4b02      	ldr	r3, [pc, #8]	; (150 <set_xo_timer+0x34>)
 146:	6019      	str	r1, [r3, #0]
    *REG_XOT_CONFIG  = regval0;
 148:	4b02      	ldr	r3, [pc, #8]	; (154 <set_xo_timer+0x38>)
 14a:	6018      	str	r0, [r3, #0]
}
 14c:	bd10      	pop	{r4, pc}
 14e:	46c0      	nop			; (mov r8, r8)
 150:	a0000050 	.word	0xa0000050
 154:	a000004c 	.word	0xa000004c

Disassembly of section .text.start_xo_cout:

00000158 <start_xo_cout>:

void reset_xo_cnt  () { *XOT_RESET_CNT  = 0x1; }
void start_xo_cnt  () { *XOT_START_CNT  = 0x1; }
void stop_xo_cnt   () { *XOT_STOP_CNT   = 0x1; }
void start_xo_cout () { *XOT_START_COUT = 0x1; }
 158:	4b01      	ldr	r3, [pc, #4]	; (160 <start_xo_cout+0x8>)
 15a:	2201      	movs	r2, #1
 15c:	601a      	str	r2, [r3, #0]
 15e:	4770      	bx	lr
 160:	a000140c 	.word	0xa000140c

Disassembly of section .text.stop_xo_cout:

00000164 <stop_xo_cout>:
void stop_xo_cout  () { *XOT_STOP_COUT  = 0x1; }
 164:	4b01      	ldr	r3, [pc, #4]	; (16c <stop_xo_cout+0x8>)
 166:	2201      	movs	r2, #1
 168:	601a      	str	r2, [r3, #0]
 16a:	4770      	bx	lr
 16c:	a0001410 	.word	0xa0001410

Disassembly of section .text.set_halt_until_mbus_tx:

00000170 <set_halt_until_mbus_tx>:
// MBUS IRQ SETTING
//**************************************************
void set_halt_until_reg(uint32_t reg_id) { *SREG_CONF_HALT = reg_id; }
void set_halt_until_mem_wr(void) { *SREG_CONF_HALT = HALT_UNTIL_MEM_WR; }
void set_halt_until_mbus_rx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_RX; }
void set_halt_until_mbus_tx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_TX; }
 170:	4b01      	ldr	r3, [pc, #4]	; (178 <set_halt_until_mbus_tx+0x8>)
 172:	2209      	movs	r2, #9
 174:	601a      	str	r2, [r3, #0]
 176:	4770      	bx	lr
 178:	a000a000 	.word	0xa000a000

Disassembly of section .text.set_halt_until_mbus_trx:

0000017c <set_halt_until_mbus_trx>:
void set_halt_until_mbus_trx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_TRX; }
 17c:	4b01      	ldr	r3, [pc, #4]	; (184 <set_halt_until_mbus_trx+0x8>)
 17e:	220c      	movs	r2, #12
 180:	601a      	str	r2, [r3, #0]
 182:	4770      	bx	lr
 184:	a000a000 	.word	0xa000a000

Disassembly of section .text.mbus_write_message32:

00000188 <mbus_write_message32>:
	// TODO: Read from LC
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
 188:	4b02      	ldr	r3, [pc, #8]	; (194 <mbus_write_message32+0xc>)
 18a:	0100      	lsls	r0, r0, #4
 18c:	4318      	orrs	r0, r3
    *((volatile uint32_t *) mbus_addr) = data;
 18e:	6001      	str	r1, [r0, #0]
    return 1;
}
 190:	2001      	movs	r0, #1
 192:	4770      	bx	lr
 194:	a0003000 	.word	0xa0003000

Disassembly of section .text.mbus_write_message:

00000198 <mbus_write_message>:

uint32_t mbus_write_message(uint8_t addr, uint32_t data[], unsigned len) {
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;
 198:	2300      	movs	r3, #0
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
    return 1;
}

uint32_t mbus_write_message(uint8_t addr, uint32_t data[], unsigned len) {
 19a:	b500      	push	{lr}
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;
 19c:	429a      	cmp	r2, r3
 19e:	d00a      	beq.n	1b6 <mbus_write_message+0x1e>

	*MBUS_CMD0 = (addr << 24) | (len-1);
 1a0:	4b06      	ldr	r3, [pc, #24]	; (1bc <mbus_write_message+0x24>)
 1a2:	3a01      	subs	r2, #1
 1a4:	0600      	lsls	r0, r0, #24
 1a6:	4302      	orrs	r2, r0
 1a8:	601a      	str	r2, [r3, #0]
	*MBUS_CMD1 = (uint32_t) data;
 1aa:	4b05      	ldr	r3, [pc, #20]	; (1c0 <mbus_write_message+0x28>)
	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x2 << 4);
 1ac:	2223      	movs	r2, #35	; 0x23
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;

	*MBUS_CMD0 = (addr << 24) | (len-1);
	*MBUS_CMD1 = (uint32_t) data;
 1ae:	6019      	str	r1, [r3, #0]
	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x2 << 4);
 1b0:	4b04      	ldr	r3, [pc, #16]	; (1c4 <mbus_write_message+0x2c>)
 1b2:	601a      	str	r2, [r3, #0]
 1b4:	2301      	movs	r3, #1

    return 1;
}
 1b6:	1c18      	adds	r0, r3, #0
 1b8:	bd00      	pop	{pc}
 1ba:	46c0      	nop			; (mov r8, r8)
 1bc:	a0002000 	.word	0xa0002000
 1c0:	a0002004 	.word	0xa0002004
 1c4:	a000200c 	.word	0xa000200c

Disassembly of section .text.mbus_enumerate:

000001c8 <mbus_enumerate>:

void mbus_enumerate(unsigned new_prefix) {
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
 1c8:	0603      	lsls	r3, r0, #24
 1ca:	2080      	movs	r0, #128	; 0x80
 1cc:	0580      	lsls	r0, r0, #22
 1ce:	4318      	orrs	r0, r3
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
 1d0:	4b01      	ldr	r3, [pc, #4]	; (1d8 <mbus_enumerate+0x10>)
 1d2:	6018      	str	r0, [r3, #0]
    return 1;
}

void mbus_enumerate(unsigned new_prefix) {
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
}
 1d4:	4770      	bx	lr
 1d6:	46c0      	nop			; (mov r8, r8)
 1d8:	a0003000 	.word	0xa0003000

Disassembly of section .text.mbus_sleep_all:

000001dc <mbus_sleep_all>:
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
 1dc:	4b01      	ldr	r3, [pc, #4]	; (1e4 <mbus_sleep_all+0x8>)
 1de:	2200      	movs	r2, #0
 1e0:	601a      	str	r2, [r3, #0]
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
}

void mbus_sleep_all(void) {
    mbus_write_message32(MBUS_POWER, MBUS_ALL_SLEEP << 28);
}
 1e2:	4770      	bx	lr
 1e4:	a0003010 	.word	0xa0003010

Disassembly of section .text.mbus_copy_registers_from_remote_to_local:

000001e8 <mbus_copy_registers_from_remote_to_local>:
void mbus_copy_registers_from_remote_to_local(
		uint8_t remote_prefix,
		uint8_t remote_reg_start,
		uint8_t local_reg_start,
		uint8_t length_minus_one
		) {
 1e8:	b507      	push	{r0, r1, r2, lr}
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
        (remote_reg_start << 24) |
 1ea:	0609      	lsls	r1, r1, #24
 1ec:	430a      	orrs	r2, r1
		(length_minus_one << 16) |
		(mbus_get_short_prefix() << 12) |
 1ee:	2180      	movs	r1, #128	; 0x80
 1f0:	0149      	lsls	r1, r1, #5
 1f2:	430a      	orrs	r2, r1
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
        (remote_reg_start << 24) |
		(length_minus_one << 16) |
 1f4:	041b      	lsls	r3, r3, #16
		(mbus_get_short_prefix() << 12) |
		(MPQ_REG_WRITE << 8) | // Write regs *to* _this_ node
 1f6:	431a      	orrs	r2, r3
		uint8_t length_minus_one
		) {
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
 1f8:	9201      	str	r2, [sp, #4]
		uint8_t local_reg_start,
		uint8_t length_minus_one
		) {
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
 1fa:	0100      	lsls	r0, r0, #4
 1fc:	2201      	movs	r2, #1
 1fe:	4310      	orrs	r0, r2
		(length_minus_one << 16) |
		(mbus_get_short_prefix() << 12) |
		(MPQ_REG_WRITE << 8) | // Write regs *to* _this_ node
		(local_reg_start << 0);

	mbus_write_message(address, &data, 1);
 200:	b2c0      	uxtb	r0, r0
 202:	a901      	add	r1, sp, #4
 204:	f7ff ffc8 	bl	198 <mbus_write_message>
}
 208:	bd07      	pop	{r0, r1, r2, pc}

Disassembly of section .text.mbus_remote_register_write:

0000020a <mbus_remote_register_write>:

void mbus_remote_register_write(
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
 20a:	b507      	push	{r0, r1, r2, lr}
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 20c:	0212      	lsls	r2, r2, #8
 20e:	0a12      	lsrs	r2, r2, #8
 210:	0609      	lsls	r1, r1, #24
 212:	4311      	orrs	r1, r2
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
 214:	0100      	lsls	r0, r0, #4
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 216:	9101      	str	r1, [sp, #4]
	mbus_write_message(address, &data, 1);
 218:	b2c0      	uxtb	r0, r0
 21a:	a901      	add	r1, sp, #4
 21c:	2201      	movs	r2, #1
 21e:	f7ff ffbb 	bl	198 <mbus_write_message>
}
 222:	bd07      	pop	{r0, r1, r2, pc}

Disassembly of section .text.mbus_copy_mem_from_local_to_remote_bulk:

00000224 <mbus_copy_mem_from_local_to_remote_bulk>:
void mbus_copy_mem_from_local_to_remote_bulk(
		uint8_t   remote_prefix,
		uint32_t* remote_memory_address,
		uint32_t* local_address,
		uint32_t  length_in_words_minus_one
		) {
 224:	b510      	push	{r4, lr}
	*MBUS_CMD0 = ( ((uint32_t) remote_prefix) << 28 ) | (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF);
 226:	2480      	movs	r4, #128	; 0x80
 228:	04a4      	lsls	r4, r4, #18
 22a:	0700      	lsls	r0, r0, #28
 22c:	031b      	lsls	r3, r3, #12
 22e:	4320      	orrs	r0, r4
 230:	0b1b      	lsrs	r3, r3, #12
 232:	4318      	orrs	r0, r3
 234:	4b04      	ldr	r3, [pc, #16]	; (248 <mbus_copy_mem_from_local_to_remote_bulk+0x24>)
 236:	6018      	str	r0, [r3, #0]
	*MBUS_CMD1 = (uint32_t) local_address;
 238:	4b04      	ldr	r3, [pc, #16]	; (24c <mbus_copy_mem_from_local_to_remote_bulk+0x28>)
 23a:	601a      	str	r2, [r3, #0]
	*MBUS_CMD2 = (uint32_t) remote_memory_address;
 23c:	4b04      	ldr	r3, [pc, #16]	; (250 <mbus_copy_mem_from_local_to_remote_bulk+0x2c>)

	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x3 << 4);
 23e:	2233      	movs	r2, #51	; 0x33
		uint32_t* local_address,
		uint32_t  length_in_words_minus_one
		) {
	*MBUS_CMD0 = ( ((uint32_t) remote_prefix) << 28 ) | (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF);
	*MBUS_CMD1 = (uint32_t) local_address;
	*MBUS_CMD2 = (uint32_t) remote_memory_address;
 240:	6019      	str	r1, [r3, #0]

	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x3 << 4);
 242:	4b04      	ldr	r3, [pc, #16]	; (254 <mbus_copy_mem_from_local_to_remote_bulk+0x30>)
 244:	601a      	str	r2, [r3, #0]
}
 246:	bd10      	pop	{r4, pc}
 248:	a0002000 	.word	0xa0002000
 24c:	a0002004 	.word	0xa0002004
 250:	a0002008 	.word	0xa0002008
 254:	a000200c 	.word	0xa000200c

Disassembly of section .text.mbus_copy_mem_from_remote_to_any_bulk:

00000258 <mbus_copy_mem_from_remote_to_any_bulk>:
		uint8_t   source_prefix,
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
 258:	b530      	push	{r4, r5, lr}
 25a:	b085      	sub	sp, #20
	uint32_t payload[3] = {
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
 25c:	9d08      	ldr	r5, [sp, #32]
 25e:	2480      	movs	r4, #128	; 0x80
 260:	04a4      	lsls	r4, r4, #18
 262:	0712      	lsls	r2, r2, #28
 264:	4322      	orrs	r2, r4
 266:	032c      	lsls	r4, r5, #12
 268:	0b24      	lsrs	r4, r4, #12
 26a:	4322      	orrs	r2, r4
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 26c:	9201      	str	r2, [sp, #4]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 26e:	0100      	lsls	r0, r0, #4
 270:	2203      	movs	r2, #3
 272:	4310      	orrs	r0, r2
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 274:	9102      	str	r1, [sp, #8]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 276:	b2c0      	uxtb	r0, r0
 278:	a901      	add	r1, sp, #4
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 27a:	9303      	str	r3, [sp, #12]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 27c:	f7ff ff8c 	bl	198 <mbus_write_message>
}
 280:	b005      	add	sp, #20
 282:	bd30      	pop	{r4, r5, pc}

Disassembly of section .text.reset_radio_data_arr:

00000284 <reset_radio_data_arr>:
 * MRR functions (MRRv7)
 **********************************************/

static void reset_radio_data_arr() {
    uint8_t i;
    for(i = 0; i < 3; i++) { radio_data_arr[i] = 0; }
 284:	4b02      	ldr	r3, [pc, #8]	; (290 <reset_radio_data_arr+0xc>)
 286:	2200      	movs	r2, #0
 288:	601a      	str	r2, [r3, #0]
 28a:	605a      	str	r2, [r3, #4]
 28c:	609a      	str	r2, [r3, #8]
}
 28e:	4770      	bx	lr
 290:	00001d44 	.word	0x00001d44

Disassembly of section .text.pmu_reg_write:

00000294 <pmu_reg_write>:


/**********************************************
 * PMU functions (PMUv11)
 **********************************************/
static void pmu_reg_write(uint32_t reg_addr, uint32_t reg_data) {
 294:	b538      	push	{r3, r4, r5, lr}
 296:	1c05      	adds	r5, r0, #0
 298:	1c0c      	adds	r4, r1, #0
    set_halt_until_mbus_trx();
 29a:	f7ff ff6f 	bl	17c <set_halt_until_mbus_trx>
    mbus_remote_register_write(PMU_ADDR, reg_addr, reg_data);
 29e:	b2e9      	uxtb	r1, r5
 2a0:	2005      	movs	r0, #5
 2a2:	1c22      	adds	r2, r4, #0
 2a4:	f7ff ffb1 	bl	20a <mbus_remote_register_write>
    set_halt_until_mbus_tx();
 2a8:	f7ff ff62 	bl	170 <set_halt_until_mbus_tx>
}
 2ac:	bd38      	pop	{r3, r4, r5, pc}

Disassembly of section .text.pmu_set_active_clk:

000002ae <pmu_set_active_clk>:
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
 2ae:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
 2b0:	1c04      	adds	r4, r0, #0

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2b2:	0e25      	lsrs	r5, r4, #24
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    mbus_write_message32(0xDE, setting);
 2b4:	1c21      	adds	r1, r4, #0

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2b6:	26ff      	movs	r6, #255	; 0xff
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2b8:	026d      	lsls	r5, r5, #9

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2ba:	1c27      	adds	r7, r4, #0
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    mbus_write_message32(0xDE, setting);
 2bc:	20de      	movs	r0, #222	; 0xde
 2be:	f7ff ff63 	bl	188 <mbus_write_message32>

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2c2:	4037      	ands	r7, r6
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2c4:	9500      	str	r5, [sp, #0]
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2c6:	1c2a      	adds	r2, r5, #0
 2c8:	23c0      	movs	r3, #192	; 0xc0
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 2ca:	0a25      	lsrs	r5, r4, #8

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2cc:	4035      	ands	r5, r6
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2ce:	021b      	lsls	r3, r3, #8
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 2d0:	017f      	lsls	r7, r7, #5
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2d2:	431a      	orrs	r2, r3
                 (r <<  9) |    // frequency multiplier r
 2d4:	432f      	orrs	r7, r5
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 2d6:	4317      	orrs	r7, r2
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 2d8:	0c24      	lsrs	r4, r4, #16

    mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2da:	1c39      	adds	r1, r7, #0
 2dc:	2016      	movs	r0, #22

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2de:	4026      	ands	r6, r4
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2e0:	9201      	str	r2, [sp, #4]
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 2e2:	0176      	lsls	r6, r6, #5

    mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2e4:	f7ff ffd6 	bl	294 <pmu_reg_write>
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2e8:	1c39      	adds	r1, r7, #0
 2ea:	2016      	movs	r0, #22
 2ec:	f7ff ffd2 	bl	294 <pmu_reg_write>
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 2f0:	9b01      	ldr	r3, [sp, #4]

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2f2:	1c31      	adds	r1, r6, #0
 2f4:	4329      	orrs	r1, r5
                 (l <<  5) |    // frequency multiplier l
 2f6:	4319      	orrs	r1, r3
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
 2f8:	2018      	movs	r0, #24
 2fa:	f7ff ffcb 	bl	294 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2fe:	9a00      	ldr	r2, [sp, #0]
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 300:	201a      	movs	r0, #26
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 302:	4316      	orrs	r6, r2
                 (l <<  5) |    // frequency multiplier l
 304:	1c31      	adds	r1, r6, #0
 306:	4329      	orrs	r1, r5
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 308:	f7ff ffc4 	bl	294 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
 30c:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.pmu_set_sar_conversion_ratio:

0000030e <pmu_set_sar_conversion_ratio>:
                     (0 << 12) |    // let vdd_clk always connect to vbat
                     (1 << 11) |    // enable override setting [10] (1'h0)
                     (0 << 10) |    // have the converter have the periodic reset (1'h0)
                     (i <<  9) |    // enable override setting [8:0] (1'h0)
                     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                     (i <<  7) |    // enable override setting [6:0] (1'h0)
 30e:	2180      	movs	r1, #128	; 0x80
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
 310:	b510      	push	{r4, lr}
                     (0 << 12) |    // let vdd_clk always connect to vbat
                     (1 << 11) |    // enable override setting [10] (1'h0)
                     (0 << 10) |    // have the converter have the periodic reset (1'h0)
                     (i <<  9) |    // enable override setting [8:0] (1'h0)
                     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                     (i <<  7) |    // enable override setting [6:0] (1'h0)
 312:	0109      	lsls	r1, r1, #4
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
 314:	1c04      	adds	r4, r0, #0
                     (0 << 12) |    // let vdd_clk always connect to vbat
                     (1 << 11) |    // enable override setting [10] (1'h0)
                     (0 << 10) |    // have the converter have the periodic reset (1'h0)
                     (i <<  9) |    // enable override setting [8:0] (1'h0)
                     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                     (i <<  7) |    // enable override setting [6:0] (1'h0)
 316:	4301      	orrs	r1, r0
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
    int i;
    for(i = 0; i < 2; i++) {
        pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 318:	2005      	movs	r0, #5
 31a:	f7ff ffbb 	bl	294 <pmu_reg_write>
                     (0 << 12) |    // let vdd_clk always connect to vbat
                     (1 << 11) |    // enable override setting [10] (1'h0)
                     (0 << 10) |    // have the converter have the periodic reset (1'h0)
                     (i <<  9) |    // enable override setting [8:0] (1'h0)
                     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                     (i <<  7) |    // enable override setting [6:0] (1'h0)
 31e:	21aa      	movs	r1, #170	; 0xaa
 320:	0189      	lsls	r1, r1, #6
 322:	4321      	orrs	r1, r4
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
    int i;
    for(i = 0; i < 2; i++) {
        pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 324:	2005      	movs	r0, #5
 326:	f7ff ffb5 	bl	294 <pmu_reg_write>
                     (i <<  9) |    // enable override setting [8:0] (1'h0)
                     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                     (i <<  7) |    // enable override setting [6:0] (1'h0)
                     (ratio)));  // binary converter's conversion ratio (7'h00)
    }
}
 32a:	bd10      	pop	{r4, pc}

Disassembly of section .text.pmu_setting_temp_based:

0000032c <pmu_setting_temp_based>:

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 32c:	b5f0      	push	{r4, r5, r6, r7, lr}
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 32e:	4a2a      	ldr	r2, [pc, #168]	; (3d8 <pmu_setting_temp_based+0xac>)
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 330:	492a      	ldr	r1, [pc, #168]	; (3dc <pmu_setting_temp_based+0xb0>)
 332:	b085      	sub	sp, #20
 334:	2300      	movs	r3, #0
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
 336:	2406      	movs	r4, #6
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 338:	18cd      	adds	r5, r1, r3
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 33a:	6816      	ldr	r6, [r2, #0]
 33c:	696d      	ldr	r5, [r5, #20]
 33e:	42ae      	cmp	r6, r5
 340:	d33e      	bcc.n	3c0 <pmu_setting_temp_based+0x94>
	    pmu_setting_cur_index = i;
 342:	4b27      	ldr	r3, [pc, #156]	; (3e0 <pmu_setting_temp_based+0xb4>)
 344:	701c      	strb	r4, [r3, #0]
 346:	b264      	sxtb	r4, r4
            if(mode == 0) {
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 348:	00a2      	lsls	r2, r4, #2
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
	    pmu_setting_cur_index = i;
            if(mode == 0) {
 34a:	2800      	cmp	r0, #0
 34c:	d105      	bne.n	35a <pmu_setting_temp_based+0x2e>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 34e:	4b25      	ldr	r3, [pc, #148]	; (3e4 <pmu_setting_temp_based+0xb8>)
 350:	58d0      	ldr	r0, [r2, r3]
 352:	f7ff ffac 	bl	2ae <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
 356:	4b24      	ldr	r3, [pc, #144]	; (3e8 <pmu_setting_temp_based+0xbc>)
 358:	e028      	b.n	3ac <pmu_setting_temp_based+0x80>
            }
            else if(mode == 2) {
 35a:	2802      	cmp	r0, #2
 35c:	d12a      	bne.n	3b4 <pmu_setting_temp_based+0x88>
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 35e:	4b23      	ldr	r3, [pc, #140]	; (3ec <pmu_setting_temp_based+0xc0>)

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 360:	27ff      	movs	r7, #255	; 0xff
            if(mode == 0) {
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
            }
            else if(mode == 2) {
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 362:	58d5      	ldr	r5, [r2, r3]
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 364:	23c0      	movs	r3, #192	; 0xc0

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 366:	0e2e      	lsrs	r6, r5, #24

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 368:	0276      	lsls	r6, r6, #9
 36a:	9601      	str	r6, [sp, #4]
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 36c:	1c32      	adds	r2, r6, #0
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 36e:	0c2e      	lsrs	r6, r5, #16

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 370:	403e      	ands	r6, r7
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 372:	0176      	lsls	r6, r6, #5
 374:	9603      	str	r6, [sp, #12]

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 376:	9903      	ldr	r1, [sp, #12]
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 378:	0a2e      	lsrs	r6, r5, #8
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 37a:	021b      	lsls	r3, r3, #8

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 37c:	403e      	ands	r6, r7
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 37e:	431a      	orrs	r2, r3
                 (r <<  9) |    // frequency multiplier r
 380:	4331      	orrs	r1, r6
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 382:	4311      	orrs	r1, r2
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 384:	2017      	movs	r0, #23

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 386:	403d      	ands	r5, r7
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 388:	9202      	str	r2, [sp, #8]
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 38a:	f7ff ff83 	bl	294 <pmu_reg_write>
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 38e:	9b02      	ldr	r3, [sp, #8]
 390:	0169      	lsls	r1, r5, #5
                ((0 << 19) |    // enable pdm even during periodic reset
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
 392:	4331      	orrs	r1, r6
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 394:	4319      	orrs	r1, r3
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
 396:	2015      	movs	r0, #21
 398:	f7ff ff7c 	bl	294 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 39c:	9901      	ldr	r1, [sp, #4]
 39e:	9a03      	ldr	r2, [sp, #12]
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 3a0:	2019      	movs	r0, #25
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 3a2:	4311      	orrs	r1, r2
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 3a4:	4331      	orrs	r1, r6
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 3a6:	f7ff ff75 	bl	294 <pmu_reg_write>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
            }
            else if(mode == 2) {
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_SLEEP_SAR_SETTINGS[i]);
 3aa:	4b11      	ldr	r3, [pc, #68]	; (3f0 <pmu_setting_temp_based+0xc4>)
 3ac:	5d18      	ldrb	r0, [r3, r4]
 3ae:	f7ff ffae 	bl	30e <pmu_set_sar_conversion_ratio>
 3b2:	e00b      	b.n	3cc <pmu_setting_temp_based+0xa0>
            }
            else {
	        pmu_set_active_clk(PMU_RADIO_SETTINGS[i]);
 3b4:	4b0f      	ldr	r3, [pc, #60]	; (3f4 <pmu_setting_temp_based+0xc8>)
 3b6:	58d0      	ldr	r0, [r2, r3]
 3b8:	f7ff ff79 	bl	2ae <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_RADIO_SAR_SETTINGS[i]);
 3bc:	4b0e      	ldr	r3, [pc, #56]	; (3f8 <pmu_setting_temp_based+0xcc>)
 3be:	e7f5      	b.n	3ac <pmu_setting_temp_based+0x80>
// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
 3c0:	3c01      	subs	r4, #1
 3c2:	b2e4      	uxtb	r4, r4
 3c4:	3b04      	subs	r3, #4
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 3c6:	2c00      	cmp	r4, #0
 3c8:	d1b6      	bne.n	338 <pmu_setting_temp_based+0xc>
 3ca:	e7ba      	b.n	342 <pmu_setting_temp_based+0x16>
                pmu_set_sar_conversion_ratio(PMU_RADIO_SAR_SETTINGS[i]);
            }
            break;
        }
    }
    delay(MBUS_DELAY);
 3cc:	2064      	movs	r0, #100	; 0x64
 3ce:	f7ff fe6a 	bl	a6 <delay>
    return;
}
 3d2:	b005      	add	sp, #20
 3d4:	bdf0      	pop	{r4, r5, r6, r7, pc}
 3d6:	46c0      	nop			; (mov r8, r8)
 3d8:	00001d40 	.word	0x00001d40
 3dc:	00001c5c 	.word	0x00001c5c
 3e0:	00001d8d 	.word	0x00001d8d
 3e4:	00001bf8 	.word	0x00001bf8
 3e8:	00001c7b 	.word	0x00001c7b
 3ec:	00001c38 	.word	0x00001c38
 3f0:	00001c74 	.word	0x00001c74
 3f4:	00001c1c 	.word	0x00001c1c
 3f8:	00001c14 	.word	0x00001c14

Disassembly of section .text.radio_power_off:

000003fc <radio_power_off>:
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    delay(MBUS_DELAY*5); // Freq stab

}

static void radio_power_off() {
 3fc:	b5f8      	push	{r3, r4, r5, r6, r7, lr}

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 3fe:	4c2c      	ldr	r4, [pc, #176]	; (4b0 <radio_power_off+0xb4>)
 400:	2601      	movs	r6, #1
 402:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 404:	2002      	movs	r0, #2

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 406:	43b3      	bics	r3, r6
 408:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 40a:	6822      	ldr	r2, [r4, #0]
 40c:	2100      	movs	r1, #0
 40e:	f7ff fefc 	bl	20a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 412:	6823      	ldr	r3, [r4, #0]
 414:	227e      	movs	r2, #126	; 0x7e
 416:	4393      	bics	r3, r2
 418:	2220      	movs	r2, #32
 41a:	4313      	orrs	r3, r2
 41c:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 41e:	6822      	ldr	r2, [r4, #0]
 420:	2002      	movs	r0, #2
 422:	2100      	movs	r1, #0
 424:	f7ff fef1 	bl	20a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 428:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 42a:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 42c:	4333      	orrs	r3, r6
 42e:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 430:	6822      	ldr	r2, [r4, #0]
 432:	2100      	movs	r1, #0
 434:	f7ff fee9 	bl	20a <mbus_remote_register_write>

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 438:	4b1e      	ldr	r3, [pc, #120]	; (4b4 <radio_power_off+0xb8>)
 43a:	4a1f      	ldr	r2, [pc, #124]	; (4b8 <radio_power_off+0xbc>)
 43c:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 43e:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 440:	400a      	ands	r2, r1
 442:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 444:	681a      	ldr	r2, [r3, #0]
 446:	2103      	movs	r1, #3
 448:	f7ff fedf 	bl	20a <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 44c:	4b1b      	ldr	r3, [pc, #108]	; (4bc <radio_power_off+0xc0>)
 44e:	2704      	movs	r7, #4
 450:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 452:	2502      	movs	r5, #2

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 454:	43ba      	bics	r2, r7
 456:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 458:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 45a:	1c28      	adds	r0, r5, #0
    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 45c:	43aa      	bics	r2, r5
 45e:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 460:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 462:	2111      	movs	r1, #17
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 464:	4332      	orrs	r2, r6
 466:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 468:	681a      	ldr	r2, [r3, #0]
 46a:	f7ff fece 	bl	20a <mbus_remote_register_write>

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 46e:	4c14      	ldr	r4, [pc, #80]	; (4c0 <radio_power_off+0xc4>)
 470:	2208      	movs	r2, #8
 472:	6823      	ldr	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 474:	1c28      	adds	r0, r5, #0
    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 476:	4313      	orrs	r3, r2
 478:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
 47a:	6823      	ldr	r3, [r4, #0]
 47c:	2220      	movs	r2, #32
 47e:	4393      	bics	r3, r2
 480:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
 482:	6823      	ldr	r3, [r4, #0]
 484:	2210      	movs	r2, #16
 486:	4313      	orrs	r3, r2
 488:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 48a:	1c39      	adds	r1, r7, #0
 48c:	6822      	ldr	r2, [r4, #0]
 48e:	f7ff febc 	bl	20a <mbus_remote_register_write>

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 492:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 494:	1c28      	adds	r0, r5, #0
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 496:	43b3      	bics	r3, r6
 498:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 49a:	6822      	ldr	r2, [r4, #0]
 49c:	1c39      	adds	r1, r7, #0
 49e:	f7ff feb4 	bl	20a <mbus_remote_register_write>

    radio_on = 0;
 4a2:	4a08      	ldr	r2, [pc, #32]	; (4c4 <radio_power_off+0xc8>)
 4a4:	2300      	movs	r3, #0
 4a6:	7013      	strb	r3, [r2, #0]
    radio_ready = 0;
 4a8:	4a07      	ldr	r2, [pc, #28]	; (4c8 <radio_power_off+0xcc>)
 4aa:	7013      	strb	r3, [r2, #0]

}
 4ac:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 4ae:	46c0      	nop			; (mov r8, r8)
 4b0:	00001cf0 	.word	0x00001cf0
 4b4:	00001c88 	.word	0x00001c88
 4b8:	ffefffff 	.word	0xffefffff
 4bc:	00001cc0 	.word	0x00001cc0
 4c0:	00001cec 	.word	0x00001cec
 4c4:	00001d7d 	.word	0x00001d7d
 4c8:	00001d06 	.word	0x00001d06

Disassembly of section .text.operation_sleep:

000004cc <operation_sleep>:

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
 4cc:	b508      	push	{r3, lr}
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;
 4ce:	2200      	movs	r2, #0
 4d0:	238c      	movs	r3, #140	; 0x8c
 4d2:	601a      	str	r2, [r3, #0]

#ifdef USE_MRR
    if(radio_on) {
 4d4:	4b04      	ldr	r3, [pc, #16]	; (4e8 <operation_sleep+0x1c>)
 4d6:	781b      	ldrb	r3, [r3, #0]
 4d8:	4293      	cmp	r3, r2
 4da:	d001      	beq.n	4e0 <operation_sleep+0x14>
    	radio_power_off();
 4dc:	f7ff ff8e 	bl	3fc <radio_power_off>
    }
#endif

    mbus_sleep_all();
 4e0:	f7ff fe7c 	bl	1dc <mbus_sleep_all>
 4e4:	e7fe      	b.n	4e4 <operation_sleep+0x18>
 4e6:	46c0      	nop			; (mov r8, r8)
 4e8:	00001d7d 	.word	0x00001d7d

Disassembly of section .text.operation_sleep_notimer:

000004ec <operation_sleep_notimer>:
    while(1);
}

static void operation_sleep_notimer( void ) {
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 4ec:	2000      	movs	r0, #0

    mbus_sleep_all();
    while(1);
}

static void operation_sleep_notimer( void ) {
 4ee:	b508      	push	{r3, lr}
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 4f0:	1c01      	adds	r1, r0, #0
 4f2:	1c02      	adds	r2, r0, #0
 4f4:	f7ff fdfc 	bl	f0 <set_wakeup_timer>
    set_xo_timer(0, 0, 0, 0);
 4f8:	2000      	movs	r0, #0
 4fa:	1c01      	adds	r1, r0, #0
 4fc:	1c02      	adds	r2, r0, #0
 4fe:	1c03      	adds	r3, r0, #0
 500:	f7ff fe0c 	bl	11c <set_xo_timer>
    config_timer32(0, 0, 0, 0);
 504:	2000      	movs	r0, #0
 506:	1c01      	adds	r1, r0, #0
 508:	1c02      	adds	r2, r0, #0
 50a:	1c03      	adds	r3, r0, #0
 50c:	f7ff fdd6 	bl	bc <config_timer32>
    // TODO: reset SNT timer
    operation_sleep();
 510:	f7ff ffdc 	bl	4cc <operation_sleep>

Disassembly of section .text.operation_temp_run:

00000514 <operation_temp_run>:
//     mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
//     mbus_write_message32(0xCE, end_time - xo_sys_time_in_sec);
// }


static void operation_temp_run() {
 514:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    if(snt_state == SNT_IDLE) {
 516:	4c51      	ldr	r4, [pc, #324]	; (65c <operation_temp_run+0x148>)
 518:	7821      	ldrb	r1, [r4, #0]
 51a:	2900      	cmp	r1, #0
 51c:	d10c      	bne.n	538 <operation_temp_run+0x24>
    sntv4_r01.TSNS_RESETn = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void snt_ldo_vref_on() {
    sntv4_r00.LDO_EN_VREF = 1;
 51e:	4b50      	ldr	r3, [pc, #320]	; (660 <operation_temp_run+0x14c>)
 520:	2004      	movs	r0, #4
 522:	881a      	ldrh	r2, [r3, #0]
 524:	4302      	orrs	r2, r0
 526:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 528:	681a      	ldr	r2, [r3, #0]
 52a:	f7ff fe6e 	bl	20a <mbus_remote_register_write>
    if(snt_state == SNT_IDLE) {

        // Turn on snt ldo vref; requires ~30 ms to settle
        // TODo: figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);
 52e:	2064      	movs	r0, #100	; 0x64
 530:	f7ff fdb9 	bl	a6 <delay>

        snt_state = SNT_TEMP_LDO;
 534:	2301      	movs	r3, #1
 536:	7023      	strb	r3, [r4, #0]

    }
    if(snt_state == SNT_TEMP_LDO) {
 538:	4f48      	ldr	r7, [pc, #288]	; (65c <operation_temp_run+0x148>)
 53a:	783d      	ldrb	r5, [r7, #0]
 53c:	2d01      	cmp	r5, #1
 53e:	d12e      	bne.n	59e <operation_temp_run+0x8a>
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 540:	4b47      	ldr	r3, [pc, #284]	; (660 <operation_temp_run+0x14c>)
 542:	2602      	movs	r6, #2
 544:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 546:	2004      	movs	r0, #4
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 548:	4332      	orrs	r2, r6
 54a:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
 54c:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 54e:	2100      	movs	r1, #0
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
    sntv4_r00.LDO_EN_LDO  = 1;
 550:	432a      	orrs	r2, r5
 552:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 554:	681a      	ldr	r2, [r3, #0]
 556:	f7ff fe58 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 55a:	4c42      	ldr	r4, [pc, #264]	; (664 <operation_temp_run+0x150>)
 55c:	2208      	movs	r2, #8
 55e:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 560:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 562:	4313      	orrs	r3, r2
 564:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 566:	6822      	ldr	r2, [r4, #0]
 568:	1c29      	adds	r1, r5, #0
 56a:	f7ff fe4e 	bl	20a <mbus_remote_register_write>
    // Un-powergate analog block
    sntv4_r01.TSNS_EN_SENSOR_LDO = 1;
 56e:	8823      	ldrh	r3, [r4, #0]
 570:	2220      	movs	r2, #32
 572:	4313      	orrs	r3, r2
 574:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 576:	6822      	ldr	r2, [r4, #0]
 578:	1c29      	adds	r1, r5, #0
 57a:	2004      	movs	r0, #4
 57c:	f7ff fe45 	bl	20a <mbus_remote_register_write>

    delay(MBUS_DELAY);
 580:	2064      	movs	r0, #100	; 0x64
 582:	f7ff fd90 	bl	a6 <delay>

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 586:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 588:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    delay(MBUS_DELAY);

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 58a:	43b3      	bics	r3, r6
 58c:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 58e:	6822      	ldr	r2, [r4, #0]
 590:	1c29      	adds	r1, r5, #0
 592:	f7ff fe3a 	bl	20a <mbus_remote_register_write>
        // Power on snt ldo
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);
 596:	2064      	movs	r0, #100	; 0x64
 598:	f7ff fd85 	bl	a6 <delay>

        snt_state = SNT_TEMP_START;
 59c:	703e      	strb	r6, [r7, #0]
    }
    if(snt_state == SNT_TEMP_START) {
 59e:	4d2f      	ldr	r5, [pc, #188]	; (65c <operation_temp_run+0x148>)
 5a0:	782b      	ldrb	r3, [r5, #0]
 5a2:	2b02      	cmp	r3, #2
 5a4:	d11d      	bne.n	5e2 <operation_temp_run+0xce>
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 5a6:	4b30      	ldr	r3, [pc, #192]	; (668 <operation_temp_run+0x154>)
 5a8:	2400      	movs	r4, #0
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 5aa:	20a0      	movs	r0, #160	; 0xa0

        snt_state = SNT_TEMP_START;
    }
    if(snt_state == SNT_TEMP_START) {
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 5ac:	701c      	strb	r4, [r3, #0]
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 5ae:	0300      	lsls	r0, r0, #12
 5b0:	2101      	movs	r1, #1
 5b2:	1c22      	adds	r2, r4, #0
 5b4:	1c23      	adds	r3, r4, #0
 5b6:	f7ff fd81 	bl	bc <config_timer32>
/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/

static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
 5ba:	482a      	ldr	r0, [pc, #168]	; (664 <operation_temp_run+0x150>)
 5bc:	2101      	movs	r1, #1
 5be:	8803      	ldrh	r3, [r0, #0]
 5c0:	430b      	orrs	r3, r1
 5c2:	8003      	strh	r3, [r0, #0]
    sntv4_r01.TSNS_EN_IRQ = 1;
 5c4:	8802      	ldrh	r2, [r0, #0]
 5c6:	2380      	movs	r3, #128	; 0x80
 5c8:	408b      	lsls	r3, r1
 5ca:	4313      	orrs	r3, r2
 5cc:	8003      	strh	r3, [r0, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5ce:	6802      	ldr	r2, [r0, #0]
 5d0:	2004      	movs	r0, #4
 5d2:	f7ff fe1a 	bl	20a <mbus_remote_register_write>
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or TIMER32
	WFI();
 5d6:	f7ff fd6e 	bl	b6 <WFI>

        // Turn off timer32
        *TIMER32_GO = 0;
 5da:	4b24      	ldr	r3, [pc, #144]	; (66c <operation_temp_run+0x158>)
 5dc:	601c      	str	r4, [r3, #0]

        snt_state = SNT_TEMP_READ;
 5de:	2303      	movs	r3, #3
 5e0:	702b      	strb	r3, [r5, #0]
    }
    if(snt_state == SNT_TEMP_READ) {
 5e2:	4a1e      	ldr	r2, [pc, #120]	; (65c <operation_temp_run+0x148>)
 5e4:	7813      	ldrb	r3, [r2, #0]
 5e6:	2b03      	cmp	r3, #3
 5e8:	d136      	bne.n	658 <operation_temp_run+0x144>
        if(wfi_timeout_flag) {
 5ea:	4b1f      	ldr	r3, [pc, #124]	; (668 <operation_temp_run+0x154>)
 5ec:	781d      	ldrb	r5, [r3, #0]
 5ee:	1e2e      	subs	r6, r5, #0
 5f0:	d006      	beq.n	600 <operation_temp_run+0xec>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 5f2:	2180      	movs	r1, #128	; 0x80
 5f4:	0449      	lsls	r1, r1, #17
 5f6:	20af      	movs	r0, #175	; 0xaf
 5f8:	f7ff fdc6 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
 5fc:	f7ff ff76 	bl	4ec <operation_sleep_notimer>
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 600:	23a0      	movs	r3, #160	; 0xa0
 602:	061b      	lsls	r3, r3, #24
 604:	681a      	ldr	r2, [r3, #0]
 606:	4b1a      	ldr	r3, [pc, #104]	; (670 <operation_temp_run+0x15c>)
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 608:	2401      	movs	r4, #1
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 60a:	601a      	str	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 60c:	4b15      	ldr	r3, [pc, #84]	; (664 <operation_temp_run+0x150>)
    sntv4_r01.TSNS_SEL_LDO       = 0;
 60e:	2108      	movs	r1, #8
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 610:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 612:	2702      	movs	r7, #2
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 614:	43a2      	bics	r2, r4
 616:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
 618:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 61a:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
 61c:	438a      	bics	r2, r1
 61e:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
 620:	881a      	ldrh	r2, [r3, #0]
 622:	2120      	movs	r1, #32
 624:	438a      	bics	r2, r1
 626:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE       = 1;
 628:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 62a:	1c21      	adds	r1, r4, #0

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 62c:	433a      	orrs	r2, r7
 62e:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 630:	681a      	ldr	r2, [r3, #0]
 632:	f7ff fdea 	bl	20a <mbus_remote_register_write>
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 636:	4b0a      	ldr	r3, [pc, #40]	; (660 <operation_temp_run+0x14c>)
 638:	2004      	movs	r0, #4
 63a:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
    sntv4_r00.LDO_EN_LDO  = 0;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 63c:	1c31      	adds	r1, r6, #0
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 63e:	4382      	bics	r2, r0
 640:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
 642:	881a      	ldrh	r2, [r3, #0]
 644:	43ba      	bics	r2, r7
 646:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 0;
 648:	881a      	ldrh	r2, [r3, #0]
 64a:	43a2      	bics	r2, r4
 64c:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 64e:	681a      	ldr	r2, [r3, #0]
 650:	f7ff fddb 	bl	20a <mbus_remote_register_write>
            
            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

            snt_state = SNT_IDLE;
 654:	4b01      	ldr	r3, [pc, #4]	; (65c <operation_temp_run+0x148>)
 656:	701d      	strb	r5, [r3, #0]
        }
    }
}
 658:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 65a:	46c0      	nop			; (mov r8, r8)
 65c:	00001d28 	.word	0x00001d28
 660:	00001cd0 	.word	0x00001cd0
 664:	00001cd4 	.word	0x00001cd4
 668:	00001d7c 	.word	0x00001d7c
 66c:	a0001100 	.word	0xa0001100
 670:	00001d40 	.word	0x00001d40

Disassembly of section .text.update_system_time:

00000674 <update_system_time>:
}

#define XO_MAX_DAY_TIME_IN_SEC 86400
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
 674:	b538      	push	{r3, r4, r5, lr}
    uint32_t val = xo_sys_time_in_sec;
 676:	4b20      	ldr	r3, [pc, #128]	; (6f8 <update_system_time+0x84>)
    mbus_write_message32(0xBA, 0x03);

}

static uint32_t get_timer_cnt() {
    if(enumerated != ENUMID) { return 0; }
 678:	2400      	movs	r4, #0

#define XO_MAX_DAY_TIME_IN_SEC 86400
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
 67a:	681d      	ldr	r5, [r3, #0]
    mbus_write_message32(0xBA, 0x03);

}

static uint32_t get_timer_cnt() {
    if(enumerated != ENUMID) { return 0; }
 67c:	4b1f      	ldr	r3, [pc, #124]	; (6fc <update_system_time+0x88>)
 67e:	681a      	ldr	r2, [r3, #0]
 680:	4b1f      	ldr	r3, [pc, #124]	; (700 <update_system_time+0x8c>)
 682:	429a      	cmp	r2, r3
 684:	d115      	bne.n	6b2 <update_system_time+0x3e>
    set_halt_until_mbus_trx();
 686:	f7ff fd79 	bl	17c <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(SNT_ADDR, 0x1B, 0x0, 1);
 68a:	1c22      	adds	r2, r4, #0
 68c:	2301      	movs	r3, #1
 68e:	2004      	movs	r0, #4
 690:	211b      	movs	r1, #27
 692:	f7ff fda9 	bl	1e8 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
 696:	f7ff fd6b 	bl	170 <set_halt_until_mbus_tx>

    delay(MBUS_DELAY);
 69a:	2064      	movs	r0, #100	; 0x64
 69c:	f7ff fd03 	bl	a6 <delay>

    return ((*REG0 & 0xFF) << 24) | (*REG1 & 0xFFFFFF);
 6a0:	23a0      	movs	r3, #160	; 0xa0
 6a2:	4a18      	ldr	r2, [pc, #96]	; (704 <update_system_time+0x90>)
 6a4:	061b      	lsls	r3, r3, #24
 6a6:	681b      	ldr	r3, [r3, #0]
 6a8:	6814      	ldr	r4, [r2, #0]
 6aa:	061b      	lsls	r3, r3, #24
 6ac:	0224      	lsls	r4, r4, #8
 6ae:	0a24      	lsrs	r4, r4, #8
 6b0:	431c      	orrs	r4, r3
#define XO_MAX_DAY_TIME_IN_SEC 86400
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
    xo_sys_time = get_timer_cnt();
 6b2:	4a15      	ldr	r2, [pc, #84]	; (708 <update_system_time+0x94>)
    xo_sys_time_in_sec = xo_sys_time >> XO_TO_SEC_SHIFT;
 6b4:	4910      	ldr	r1, [pc, #64]	; (6f8 <update_system_time+0x84>)
#define XO_MAX_DAY_TIME_IN_SEC 86400
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
    xo_sys_time = get_timer_cnt();
 6b6:	6014      	str	r4, [r2, #0]
    xo_sys_time_in_sec = xo_sys_time >> XO_TO_SEC_SHIFT;
 6b8:	6813      	ldr	r3, [r2, #0]
 6ba:	0a9b      	lsrs	r3, r3, #10
 6bc:	600b      	str	r3, [r1, #0]
    xo_day_time_in_sec += xo_sys_time_in_sec - val;
 6be:	4b13      	ldr	r3, [pc, #76]	; (70c <update_system_time+0x98>)
 6c0:	6818      	ldr	r0, [r3, #0]
 6c2:	680c      	ldr	r4, [r1, #0]
 6c4:	1820      	adds	r0, r4, r0
 6c6:	1b45      	subs	r5, r0, r5
 6c8:	601d      	str	r5, [r3, #0]
 6ca:	1c0c      	adds	r4, r1, #0

    if(xo_day_time_in_sec >= XO_MAX_DAY_TIME_IN_SEC) {
 6cc:	6818      	ldr	r0, [r3, #0]
 6ce:	4910      	ldr	r1, [pc, #64]	; (710 <update_system_time+0x9c>)
 6d0:	4288      	cmp	r0, r1
 6d2:	d903      	bls.n	6dc <update_system_time+0x68>
        xo_day_time_in_sec -= XO_MAX_DAY_TIME_IN_SEC;
 6d4:	6819      	ldr	r1, [r3, #0]
 6d6:	480f      	ldr	r0, [pc, #60]	; (714 <update_system_time+0xa0>)
 6d8:	1809      	adds	r1, r1, r0
 6da:	6019      	str	r1, [r3, #0]
    }

    mbus_write_message32(0xC2, xo_sys_time);
 6dc:	6811      	ldr	r1, [r2, #0]
 6de:	20c2      	movs	r0, #194	; 0xc2
 6e0:	f7ff fd52 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xC1, xo_sys_time_in_sec);
 6e4:	6821      	ldr	r1, [r4, #0]
 6e6:	20c1      	movs	r0, #193	; 0xc1
 6e8:	f7ff fd4e 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xC0, xo_day_time_in_sec);
 6ec:	4b07      	ldr	r3, [pc, #28]	; (70c <update_system_time+0x98>)
 6ee:	20c0      	movs	r0, #192	; 0xc0
 6f0:	6819      	ldr	r1, [r3, #0]
 6f2:	f7ff fd49 	bl	188 <mbus_write_message32>

}
 6f6:	bd38      	pop	{r3, r4, r5, pc}
 6f8:	00001d2c 	.word	0x00001d2c
 6fc:	00001d24 	.word	0x00001d24
 700:	deadbeef 	.word	0xdeadbeef
 704:	a0000004 	.word	0xa0000004
 708:	00001d08 	.word	0x00001d08
 70c:	00001d78 	.word	0x00001d78
 710:	0001517f 	.word	0x0001517f
 714:	fffeae80 	.word	0xfffeae80

Disassembly of section .text.reset_timers_list:

00000718 <reset_timers_list>:
    return LNT_INTERVAL[lnt_cur_level];
}

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
 718:	b508      	push	{r3, lr}
    uint8_t i;
    update_system_time();
 71a:	f7ff ffab 	bl	674 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
 71e:	4b03      	ldr	r3, [pc, #12]	; (72c <reset_timers_list+0x14>)
 720:	2200      	movs	r2, #0
 722:	601a      	str	r2, [r3, #0]
 724:	605a      	str	r2, [r3, #4]
 726:	609a      	str	r2, [r3, #8]
    }
}
 728:	bd08      	pop	{r3, pc}
 72a:	46c0      	nop			; (mov r8, r8)
 72c:	00001d64 	.word	0x00001d64

Disassembly of section .text.set_next_time:

00000730 <set_next_time>:

static void set_next_time(uint8_t idx, uint16_t step) {
 730:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
 732:	1c06      	adds	r6, r0, #0
 734:	1c0f      	adds	r7, r1, #0
    update_system_time();
 736:	f7ff ff9d 	bl	674 <update_system_time>
    xot_timer_list[idx] = xot_last_timer_list[idx];
 73a:	4a0a      	ldr	r2, [pc, #40]	; (764 <set_next_time+0x34>)
 73c:	00b3      	lsls	r3, r6, #2
 73e:	5899      	ldr	r1, [r3, r2]
 740:	4a09      	ldr	r2, [pc, #36]	; (768 <set_next_time+0x38>)
 742:	5099      	str	r1, [r3, r2]
    do {
    	mbus_write_message32(0xD3, xot_timer_list[idx]);
 744:	4c08      	ldr	r4, [pc, #32]	; (768 <set_next_time+0x38>)
 746:	00b5      	lsls	r5, r6, #2
 748:	5929      	ldr	r1, [r5, r4]
 74a:	20d3      	movs	r0, #211	; 0xd3
 74c:	f7ff fd1c 	bl	188 <mbus_write_message32>
        xot_timer_list[idx] += step;
 750:	592b      	ldr	r3, [r5, r4]
 752:	18fb      	adds	r3, r7, r3
 754:	512b      	str	r3, [r5, r4]
    } while(xo_sys_time_in_sec + 5 > xot_timer_list[idx]);    // give some margin of error
 756:	4b05      	ldr	r3, [pc, #20]	; (76c <set_next_time+0x3c>)
 758:	681a      	ldr	r2, [r3, #0]
 75a:	592b      	ldr	r3, [r5, r4]
 75c:	3205      	adds	r2, #5
 75e:	429a      	cmp	r2, r3
 760:	d8f0      	bhi.n	744 <set_next_time+0x14>

}
 762:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 764:	00001cf8 	.word	0x00001cf8
 768:	00001d64 	.word	0x00001d64
 76c:	00001d2c 	.word	0x00001d2c

Disassembly of section .text.xo_check_is_day:

00000770 <xo_check_is_day>:
    mbus_write_message32(0xC1, xo_sys_time_in_sec);
    mbus_write_message32(0xC0, xo_day_time_in_sec);

}

bool xo_check_is_day() {
 770:	b508      	push	{r3, lr}
    update_system_time();
 772:	f7ff ff7f 	bl	674 <update_system_time>
    return xo_day_time_in_sec >= XO_DAY_START && xo_day_time_in_sec < XO_DAY_END;
 776:	4a06      	ldr	r2, [pc, #24]	; (790 <xo_check_is_day+0x20>)
 778:	4906      	ldr	r1, [pc, #24]	; (794 <xo_check_is_day+0x24>)
 77a:	6810      	ldr	r0, [r2, #0]
 77c:	2300      	movs	r3, #0
 77e:	4288      	cmp	r0, r1
 780:	d903      	bls.n	78a <xo_check_is_day+0x1a>
 782:	6812      	ldr	r2, [r2, #0]
 784:	4904      	ldr	r1, [pc, #16]	; (798 <xo_check_is_day+0x28>)
 786:	4291      	cmp	r1, r2
 788:	415b      	adcs	r3, r3
 78a:	2001      	movs	r0, #1
 78c:	4018      	ands	r0, r3
}
 78e:	bd08      	pop	{r3, pc}
 790:	00001d78 	.word	0x00001d78
 794:	0000464f 	.word	0x0000464f
 798:	00010b2f 	.word	0x00010b2f

Disassembly of section .text.crcEnc16:

0000079c <crcEnc16>:

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 79c:	4b1c      	ldr	r3, [pc, #112]	; (810 <crcEnc16+0x74>)

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
{
 79e:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 7a0:	689a      	ldr	r2, [r3, #8]
 7a2:	685f      	ldr	r7, [r3, #4]
 7a4:	0412      	lsls	r2, r2, #16
 7a6:	0c3f      	lsrs	r7, r7, #16
 7a8:	18bf      	adds	r7, r7, r2
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 7aa:	685a      	ldr	r2, [r3, #4]
 7ac:	6819      	ldr	r1, [r3, #0]
 7ae:	0412      	lsls	r2, r2, #16
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 7b0:	681c      	ldr	r4, [r3, #0]
    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 7b2:	0c09      	lsrs	r1, r1, #16
 7b4:	1889      	adds	r1, r1, r2
    // intialization
    uint32_t i;

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
 7b6:	2200      	movs	r2, #0
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 7b8:	468c      	mov	ip, r1
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 7ba:	0424      	lsls	r4, r4, #16

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 7bc:	1c13      	adds	r3, r2, #0
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 7be:	b295      	uxth	r5, r2
 7c0:	b229      	sxth	r1, r5
            MSB = 0xffff;
        else
            MSB = 0x0000;
 7c2:	2000      	movs	r0, #0
    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 7c4:	4281      	cmp	r1, r0
 7c6:	da00      	bge.n	7ca <crcEnc16+0x2e>
            MSB = 0xffff;
 7c8:	4812      	ldr	r0, [pc, #72]	; (814 <crcEnc16+0x78>)
        else
            MSB = 0x0000;

        if (i < 32)
 7ca:	2b1f      	cmp	r3, #31
 7cc:	d803      	bhi.n	7d6 <crcEnc16+0x3a>
            input_bit = ((data2 << i) > 0x7fffffff);
 7ce:	1c39      	adds	r1, r7, #0
 7d0:	4099      	lsls	r1, r3
 7d2:	0fc9      	lsrs	r1, r1, #31
 7d4:	e009      	b.n	7ea <crcEnc16+0x4e>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 7d6:	1c19      	adds	r1, r3, #0
        else
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
 7d8:	2b3f      	cmp	r3, #63	; 0x3f
 7da:	d802      	bhi.n	7e2 <crcEnc16+0x46>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 7dc:	3920      	subs	r1, #32
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
 7de:	4666      	mov	r6, ip
 7e0:	e001      	b.n	7e6 <crcEnc16+0x4a>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 7e2:	3940      	subs	r1, #64	; 0x40
        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;
 7e4:	1c26      	adds	r6, r4, #0
 7e6:	408e      	lsls	r6, r1
 7e8:	0ff1      	lsrs	r1, r6, #31

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 7ea:	0bed      	lsrs	r5, r5, #15
 7ec:	4069      	eors	r1, r5
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 7ee:	0052      	lsls	r2, r2, #1
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 7f0:	4d09      	ldr	r5, [pc, #36]	; (818 <crcEnc16+0x7c>)
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 7f2:	b292      	uxth	r2, r2
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 7f4:	4015      	ands	r5, r2
 7f6:	4042      	eors	r2, r0
 7f8:	4808      	ldr	r0, [pc, #32]	; (81c <crcEnc16+0x80>)
 7fa:	1949      	adds	r1, r1, r5
 7fc:	4002      	ands	r2, r0
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 7fe:	3301      	adds	r3, #1
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 800:	430a      	orrs	r2, r1
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 802:	2b60      	cmp	r3, #96	; 0x60
 804:	d1db      	bne.n	7be <crcEnc16+0x22>
        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
    }

    static uint32_t msg_out[1];
    msg_out[0] = data0 + remainder;
 806:	4806      	ldr	r0, [pc, #24]	; (820 <crcEnc16+0x84>)
 808:	1912      	adds	r2, r2, r4
 80a:	6002      	str	r2, [r0, #0]
    //radio_data_arr[0] = data2;
    //radio_data_arr[1] = data1;
    //radio_data_arr[2] = data0;

    return msg_out;    
}
 80c:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
 80e:	46c0      	nop			; (mov r8, r8)
 810:	00001d44 	.word	0x00001d44
 814:	0000ffff 	.word	0x0000ffff
 818:	00003ffd 	.word	0x00003ffd
 81c:	ffffc002 	.word	0xffffc002
 820:	00001d9c 	.word	0x00001d9c

Disassembly of section .text.mrr_send_radio_data:

00000824 <mrr_send_radio_data>:

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 824:	b5f0      	push	{r4, r5, r6, r7, lr}
    // MRR REG_D: DATA[23:0]
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

    if(!mrr_send_enable) {
 826:	4bb8      	ldr	r3, [pc, #736]	; (b08 <mrr_send_radio_data+0x2e4>)

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 828:	b085      	sub	sp, #20
    // MRR REG_D: DATA[23:0]
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

    if(!mrr_send_enable) {
 82a:	781b      	ldrb	r3, [r3, #0]

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 82c:	9003      	str	r0, [sp, #12]
    // MRR REG_D: DATA[23:0]
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

    if(!mrr_send_enable) {
 82e:	2b00      	cmp	r3, #0
 830:	d100      	bne.n	834 <mrr_send_radio_data+0x10>
 832:	e167      	b.n	b04 <mrr_send_radio_data+0x2e0>
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 834:	f7ff ffb2 	bl	79c <crcEnc16>
    mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
 838:	4bb4      	ldr	r3, [pc, #720]	; (b0c <mrr_send_radio_data+0x2e8>)
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 83a:	9001      	str	r0, [sp, #4]
    mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
 83c:	781f      	ldrb	r7, [r3, #0]
 83e:	2f00      	cmp	r7, #0
 840:	d000      	beq.n	844 <mrr_send_radio_data+0x20>
 842:	e083      	b.n	94c <mrr_send_radio_data+0x128>

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 844:	4db2      	ldr	r5, [pc, #712]	; (b10 <mrr_send_radio_data+0x2ec>)
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
        radio_on = 1;
 846:	2601      	movs	r6, #1
 848:	701e      	strb	r6, [r3, #0]

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 84a:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 84c:	2002      	movs	r0, #2

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 84e:	43b3      	bics	r3, r6
 850:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 852:	682a      	ldr	r2, [r5, #0]
 854:	1c39      	adds	r1, r7, #0
 856:	f7ff fcd8 	bl	20a <mbus_remote_register_write>

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 85a:	4cae      	ldr	r4, [pc, #696]	; (b14 <mrr_send_radio_data+0x2f0>)
 85c:	4bae      	ldr	r3, [pc, #696]	; (b18 <mrr_send_radio_data+0x2f4>)
 85e:	6822      	ldr	r2, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 860:	2002      	movs	r0, #2
    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 862:	4013      	ands	r3, r2
 864:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 866:	6822      	ldr	r2, [r4, #0]
 868:	2103      	movs	r1, #3
 86a:	f7ff fcce 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
 86e:	6822      	ldr	r2, [r4, #0]
 870:	2380      	movs	r3, #128	; 0x80
 872:	031b      	lsls	r3, r3, #12
 874:	4313      	orrs	r3, r2
 876:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 878:	6822      	ldr	r2, [r4, #0]
 87a:	2103      	movs	r1, #3
 87c:	2002      	movs	r0, #2
 87e:	f7ff fcc4 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 882:	2064      	movs	r0, #100	; 0x64
 884:	f7ff fc0f 	bl	a6 <delay>

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 888:	6822      	ldr	r2, [r4, #0]
 88a:	4ba4      	ldr	r3, [pc, #656]	; (b1c <mrr_send_radio_data+0x2f8>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 88c:	2002      	movs	r0, #2
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    delay(MBUS_DELAY);

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 88e:	4013      	ands	r3, r2
 890:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 892:	6822      	ldr	r2, [r4, #0]
 894:	2103      	movs	r1, #3
 896:	f7ff fcb8 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
 89a:	6822      	ldr	r2, [r4, #0]
 89c:	2380      	movs	r3, #128	; 0x80
 89e:	02db      	lsls	r3, r3, #11
 8a0:	4313      	orrs	r3, r2
 8a2:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 8a4:	6822      	ldr	r2, [r4, #0]
 8a6:	2103      	movs	r1, #3
 8a8:	2002      	movs	r0, #2
 8aa:	f7ff fcae 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 8ae:	2064      	movs	r0, #100	; 0x64
 8b0:	f7ff fbf9 	bl	a6 <delay>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 8b4:	682b      	ldr	r3, [r5, #0]
 8b6:	227e      	movs	r2, #126	; 0x7e
 8b8:	4393      	bics	r3, r2
 8ba:	2420      	movs	r4, #32
 8bc:	4323      	orrs	r3, r4
 8be:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 8c0:	682a      	ldr	r2, [r5, #0]
 8c2:	2002      	movs	r0, #2
 8c4:	1c39      	adds	r1, r7, #0
 8c6:	f7ff fca0 	bl	20a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 8ca:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 8cc:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 8ce:	4333      	orrs	r3, r6
 8d0:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 8d2:	682a      	ldr	r2, [r5, #0]
 8d4:	1c39      	adds	r1, r7, #0
 8d6:	f7ff fc98 	bl	20a <mbus_remote_register_write>

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 8da:	4d91      	ldr	r5, [pc, #580]	; (b20 <mrr_send_radio_data+0x2fc>)
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8dc:	2104      	movs	r1, #4
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 8de:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8e0:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 8e2:	4333      	orrs	r3, r6
 8e4:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8e6:	682a      	ldr	r2, [r5, #0]
 8e8:	f7ff fc8f 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 8ec:	2064      	movs	r0, #100	; 0x64
 8ee:	f7ff fbda 	bl	a6 <delay>

    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
 8f2:	682b      	ldr	r3, [r5, #0]
 8f4:	2208      	movs	r2, #8
 8f6:	4393      	bics	r3, r2
 8f8:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8fa:	682a      	ldr	r2, [r5, #0]
 8fc:	2104      	movs	r1, #4
 8fe:	2002      	movs	r0, #2
 900:	f7ff fc83 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 904:	2064      	movs	r0, #100	; 0x64
 906:	f7ff fbce 	bl	a6 <delay>

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 90a:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 90c:	2104      	movs	r1, #4
    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
    delay(MBUS_DELAY);

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 90e:	431c      	orrs	r4, r3
 910:	602c      	str	r4, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 912:	682a      	ldr	r2, [r5, #0]
 914:	2002      	movs	r0, #2
 916:	f7ff fc78 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 91a:	2064      	movs	r0, #100	; 0x64
 91c:	f7ff fbc3 	bl	a6 <delay>

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
 920:	682b      	ldr	r3, [r5, #0]
 922:	2210      	movs	r2, #16
 924:	4393      	bics	r3, r2
 926:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 928:	682a      	ldr	r2, [r5, #0]
 92a:	2002      	movs	r0, #2
 92c:	2104      	movs	r1, #4
 92e:	f7ff fc6c 	bl	20a <mbus_remote_register_write>

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 932:	4b7c      	ldr	r3, [pc, #496]	; (b24 <mrr_send_radio_data+0x300>)
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 934:	2002      	movs	r0, #2

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 936:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 938:	2111      	movs	r1, #17

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 93a:	43b2      	bics	r2, r6
 93c:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 93e:	681a      	ldr	r2, [r3, #0]
 940:	f7ff fc63 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*5); // Freq stab
 944:	20fa      	movs	r0, #250	; 0xfa
 946:	40b0      	lsls	r0, r6
 948:	f7ff fbad 	bl	a6 <delay>
    if(!radio_on) {
        radio_on = 1;
	radio_power_on();
    }
    
    mbus_remote_register_write(MRR_ADDR,0xD, radio_data_arr[0] & 0xFFFFFF);
 94c:	4c76      	ldr	r4, [pc, #472]	; (b28 <mrr_send_radio_data+0x304>)
 94e:	2002      	movs	r0, #2
 950:	6822      	ldr	r2, [r4, #0]
 952:	210d      	movs	r1, #13
 954:	0212      	lsls	r2, r2, #8
 956:	0a12      	lsrs	r2, r2, #8
 958:	f7ff fc57 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xE, (radio_data_arr[1] << 8) | ((radio_data_arr[0] >> 24) & 0xFF));
 95c:	6863      	ldr	r3, [r4, #4]
 95e:	6822      	ldr	r2, [r4, #0]
 960:	021b      	lsls	r3, r3, #8
 962:	0e12      	lsrs	r2, r2, #24
 964:	431a      	orrs	r2, r3
 966:	2002      	movs	r0, #2
 968:	210e      	movs	r1, #14
 96a:	f7ff fc4e 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xF, (radio_data_arr[2] << 16) | ((radio_data_arr[1] >> 16) & 0xFFFF));
 96e:	68a3      	ldr	r3, [r4, #8]
 970:	6862      	ldr	r2, [r4, #4]
 972:	041b      	lsls	r3, r3, #16
 974:	0c12      	lsrs	r2, r2, #16
 976:	431a      	orrs	r2, r3
 978:	2002      	movs	r0, #2
 97a:	210f      	movs	r1, #15
 97c:	f7ff fc45 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x10, ((crc_data[0] & 0xFFFF) << 8 | (radio_data_arr[2] >> 8) & 0xFF));
 980:	9901      	ldr	r1, [sp, #4]
 982:	68a2      	ldr	r2, [r4, #8]
 984:	880b      	ldrh	r3, [r1, #0]
 986:	0a12      	lsrs	r2, r2, #8
 988:	021b      	lsls	r3, r3, #8
 98a:	b2d2      	uxtb	r2, r2
 98c:	431a      	orrs	r2, r3
 98e:	2002      	movs	r0, #2
 990:	2110      	movs	r1, #16
 992:	f7ff fc3a 	bl	20a <mbus_remote_register_write>

    if (!radio_ready){
 996:	4b65      	ldr	r3, [pc, #404]	; (b2c <mrr_send_radio_data+0x308>)
 998:	781d      	ldrb	r5, [r3, #0]
 99a:	2d00      	cmp	r5, #0
 99c:	d127      	bne.n	9ee <mrr_send_radio_data+0x1ca>
	radio_ready = 1;
 99e:	2201      	movs	r2, #1
 9a0:	701a      	strb	r2, [r3, #0]

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 9a2:	4b60      	ldr	r3, [pc, #384]	; (b24 <mrr_send_radio_data+0x300>)
 9a4:	2402      	movs	r4, #2
 9a6:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 9a8:	2111      	movs	r1, #17

    if (!radio_ready){
	radio_ready = 1;

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 9aa:	4322      	orrs	r2, r4
 9ac:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 9ae:	681a      	ldr	r2, [r3, #0]
 9b0:	1c20      	adds	r0, r4, #0
 9b2:	f7ff fc2a 	bl	20a <mbus_remote_register_write>
	delay(MBUS_DELAY);
 9b6:	2064      	movs	r0, #100	; 0x64
 9b8:	f7ff fb75 	bl	a6 <delay>

	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
 9bc:	4b55      	ldr	r3, [pc, #340]	; (b14 <mrr_send_radio_data+0x2f0>)
 9be:	2280      	movs	r2, #128	; 0x80
 9c0:	6819      	ldr	r1, [r3, #0]
 9c2:	0352      	lsls	r2, r2, #13
 9c4:	430a      	orrs	r2, r1
 9c6:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 9c8:	681a      	ldr	r2, [r3, #0]
 9ca:	2103      	movs	r1, #3
 9cc:	1c20      	adds	r0, r4, #0
 9ce:	f7ff fc1c 	bl	20a <mbus_remote_register_write>
	delay(MBUS_DELAY);
 9d2:	2064      	movs	r0, #100	; 0x64
 9d4:	f7ff fb67 	bl	a6 <delay>

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 9d8:	4b4d      	ldr	r3, [pc, #308]	; (b10 <mrr_send_radio_data+0x2ec>)
 9da:	217e      	movs	r1, #126	; 0x7e
 9dc:	681a      	ldr	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 9de:	1c20      	adds	r0, r4, #0
	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
	delay(MBUS_DELAY);

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 9e0:	438a      	bics	r2, r1
 9e2:	4322      	orrs	r2, r4
 9e4:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 9e6:	681a      	ldr	r2, [r3, #0]
 9e8:	1c29      	adds	r1, r5, #0
 9ea:	f7ff fc0e 	bl	20a <mbus_remote_register_write>

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
 9ee:	4b50      	ldr	r3, [pc, #320]	; (b30 <mrr_send_radio_data+0x30c>)
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
 9f0:	2101      	movs	r1, #1
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
 9f2:	781a      	ldrb	r2, [r3, #0]
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
 9f4:	9102      	str	r1, [sp, #8]
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
 9f6:	2a00      	cmp	r2, #0
 9f8:	d001      	beq.n	9fe <mrr_send_radio_data+0x1da>
 9fa:	781b      	ldrb	r3, [r3, #0]
 9fc:	9302      	str	r3, [sp, #8]

    mrr_cfo_val_fine = 0x0000;
 9fe:	2700      	movs	r7, #0
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    }

#ifdef USE_RAD
    uint8_t count = 0;
 a00:	9701      	str	r7, [sp, #4]
 a02:	e064      	b.n	ace <mrr_send_radio_data+0x2aa>

    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
 a04:	4b4b      	ldr	r3, [pc, #300]	; (b34 <mrr_send_radio_data+0x310>)
 a06:	2400      	movs	r4, #0
 a08:	601c      	str	r4, [r3, #0]
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
 a0a:	4b4b      	ldr	r3, [pc, #300]	; (b38 <mrr_send_radio_data+0x314>)

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
 a0c:	223f      	movs	r2, #63	; 0x3f
    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
 a0e:	601c      	str	r4, [r3, #0]

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
 a10:	4b4a      	ldr	r3, [pc, #296]	; (b3c <mrr_send_radio_data+0x318>)
 a12:	494b      	ldr	r1, [pc, #300]	; (b40 <mrr_send_radio_data+0x31c>)
 a14:	681d      	ldr	r5, [r3, #0]
 a16:	403a      	ands	r2, r7
 a18:	0410      	lsls	r0, r2, #16
 a1a:	4029      	ands	r1, r5
 a1c:	4301      	orrs	r1, r0
 a1e:	6019      	str	r1, [r3, #0]
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
 a20:	6818      	ldr	r0, [r3, #0]
 a22:	0291      	lsls	r1, r2, #10
 a24:	4a47      	ldr	r2, [pc, #284]	; (b44 <mrr_send_radio_data+0x320>)
 a26:	4002      	ands	r2, r0
 a28:	430a      	orrs	r2, r1
 a2a:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
 a2c:	681a      	ldr	r2, [r3, #0]
 a2e:	2002      	movs	r0, #2
 a30:	2101      	movs	r1, #1
 a32:	f7ff fbea 	bl	20a <mbus_remote_register_write>
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
 a36:	4a44      	ldr	r2, [pc, #272]	; (b48 <mrr_send_radio_data+0x324>)
    config_timer32(val, 1, 0, 0);
 a38:	20a0      	movs	r0, #160	; 0xa0
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
 a3a:	7014      	strb	r4, [r2, #0]
    config_timer32(val, 1, 0, 0);
 a3c:	0300      	lsls	r0, r0, #12
 a3e:	2101      	movs	r1, #1
 a40:	1c22      	adds	r2, r4, #0
 a42:	1c23      	adds	r3, r4, #0
 a44:	f7ff fb3a 	bl	bc <config_timer32>

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
 a48:	4e31      	ldr	r6, [pc, #196]	; (b10 <mrr_send_radio_data+0x2ec>)
 a4a:	2101      	movs	r1, #1
 a4c:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a4e:	2002      	movs	r0, #2

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
 a50:	430b      	orrs	r3, r1
 a52:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a54:	6832      	ldr	r2, [r6, #0]
 a56:	1c21      	adds	r1, r4, #0
 a58:	f7ff fbd7 	bl	20a <mbus_remote_register_write>

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
 a5c:	4d31      	ldr	r5, [pc, #196]	; (b24 <mrr_send_radio_data+0x300>)
 a5e:	2204      	movs	r2, #4
 a60:	882b      	ldrh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a62:	2111      	movs	r1, #17
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
 a64:	4313      	orrs	r3, r2
 a66:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a68:	682a      	ldr	r2, [r5, #0]
 a6a:	2002      	movs	r0, #2
 a6c:	f7ff fbcd 	bl	20a <mbus_remote_register_write>

    // Wait for radio response
    WFI();
 a70:	f7ff fb21 	bl	b6 <WFI>
    config_timer32(val, 1, 0, 0);
}

static void stop_timer32_timeout_check(){
    // Turn off Timer32
    *TIMER32_GO = 0;
 a74:	4b35      	ldr	r3, [pc, #212]	; (b4c <mrr_send_radio_data+0x328>)
 a76:	601c      	str	r4, [r3, #0]
    if (wfi_timeout_flag){
 a78:	4b33      	ldr	r3, [pc, #204]	; (b48 <mrr_send_radio_data+0x324>)
 a7a:	7819      	ldrb	r1, [r3, #0]
 a7c:	42a1      	cmp	r1, r4
 a7e:	d007      	beq.n	a90 <mrr_send_radio_data+0x26c>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 a80:	2180      	movs	r1, #128	; 0x80
 a82:	04c9      	lsls	r1, r1, #19
 a84:	20af      	movs	r0, #175	; 0xaf

static void stop_timer32_timeout_check(){
    // Turn off Timer32
    *TIMER32_GO = 0;
    if (wfi_timeout_flag){
        wfi_timeout_flag = 0;
 a86:	701c      	strb	r4, [r3, #0]
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 a88:	f7ff fb7e 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
 a8c:	f7ff fd2e 	bl	4ec <operation_sleep_notimer>
    // Wait for radio response
    WFI();
    stop_timer32_timeout_check();

    // Turn off Current Limter
    mrrv7_r00.MRR_CL_EN = 0;
 a90:	6833      	ldr	r3, [r6, #0]
 a92:	2201      	movs	r2, #1
 a94:	4393      	bics	r3, r2
 a96:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a98:	6832      	ldr	r2, [r6, #0]
 a9a:	2002      	movs	r0, #2
 a9c:	f7ff fbb5 	bl	20a <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
 aa0:	882b      	ldrh	r3, [r5, #0]
 aa2:	2104      	movs	r1, #4
 aa4:	438b      	bics	r3, r1
 aa6:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 aa8:	682a      	ldr	r2, [r5, #0]
 aaa:	2002      	movs	r0, #2
 aac:	2111      	movs	r1, #17
 aae:	f7ff fbac 	bl	20a <mbus_remote_register_write>

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
 ab2:	9b01      	ldr	r3, [sp, #4]
	if (count < num_packets){
 ab4:	9a02      	ldr	r2, [sp, #8]

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
 ab6:	3301      	adds	r3, #1
 ab8:	b2db      	uxtb	r3, r3
 aba:	9301      	str	r3, [sp, #4]
	if (count < num_packets){
 abc:	4293      	cmp	r3, r2
 abe:	d202      	bcs.n	ac6 <mrr_send_radio_data+0x2a2>
		delay(RADIO_PACKET_DELAY);
 ac0:	4823      	ldr	r0, [pc, #140]	; (b50 <mrr_send_radio_data+0x32c>)
 ac2:	f7ff faf0 	bl	a6 <delay>
	}
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
 ac6:	4b23      	ldr	r3, [pc, #140]	; (b54 <mrr_send_radio_data+0x330>)
 ac8:	781b      	ldrb	r3, [r3, #0]
 aca:	18ff      	adds	r7, r7, r3
 acc:	b2bf      	uxth	r7, r7
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
 ace:	9b01      	ldr	r3, [sp, #4]
 ad0:	9902      	ldr	r1, [sp, #8]
 ad2:	428b      	cmp	r3, r1
 ad4:	d196      	bne.n	a04 <mrr_send_radio_data+0x1e0>
		delay(RADIO_PACKET_DELAY);
	}
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
    }

    radio_packet_count++;
 ad6:	4b20      	ldr	r3, [pc, #128]	; (b58 <mrr_send_radio_data+0x334>)
 ad8:	681a      	ldr	r2, [r3, #0]
 ada:	3201      	adds	r2, #1
 adc:	601a      	str	r2, [r3, #0]
#endif

    if (last_packet){
 ade:	9a03      	ldr	r2, [sp, #12]
 ae0:	2a00      	cmp	r2, #0
 ae2:	d005      	beq.n	af0 <mrr_send_radio_data+0x2cc>
	radio_ready = 0;
 ae4:	4b11      	ldr	r3, [pc, #68]	; (b2c <mrr_send_radio_data+0x308>)
 ae6:	2200      	movs	r2, #0
 ae8:	701a      	strb	r2, [r3, #0]
	radio_power_off();
 aea:	f7ff fc87 	bl	3fc <radio_power_off>
 aee:	e009      	b.n	b04 <mrr_send_radio_data+0x2e0>
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 af0:	4b0c      	ldr	r3, [pc, #48]	; (b24 <mrr_send_radio_data+0x300>)
 af2:	2104      	movs	r1, #4
 af4:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 af6:	2002      	movs	r0, #2

    if (last_packet){
	radio_ready = 0;
	radio_power_off();
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 af8:	438a      	bics	r2, r1
 afa:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 afc:	681a      	ldr	r2, [r3, #0]
 afe:	2111      	movs	r1, #17
 b00:	f7ff fb83 	bl	20a <mbus_remote_register_write>
    }
}
 b04:	b005      	add	sp, #20
 b06:	bdf0      	pop	{r4, r5, r6, r7, pc}
 b08:	00001c98 	.word	0x00001c98
 b0c:	00001d7d 	.word	0x00001d7d
 b10:	00001cf0 	.word	0x00001cf0
 b14:	00001c88 	.word	0x00001c88
 b18:	fffbffff 	.word	0xfffbffff
 b1c:	fff7ffff 	.word	0xfff7ffff
 b20:	00001cec 	.word	0x00001cec
 b24:	00001cc0 	.word	0x00001cc0
 b28:	00001d44 	.word	0x00001d44
 b2c:	00001d06 	.word	0x00001d06
 b30:	00001d0c 	.word	0x00001d0c
 b34:	a0001200 	.word	0xa0001200
 b38:	a000007c 	.word	0xa000007c
 b3c:	00001da0 	.word	0x00001da0
 b40:	ffc0ffff 	.word	0xffc0ffff
 b44:	ffff03ff 	.word	0xffff03ff
 b48:	00001d7c 	.word	0x00001d7c
 b4c:	a0001100 	.word	0xa0001100
 b50:	000032c8 	.word	0x000032c8
 b54:	00001d74 	.word	0x00001d74
 b58:	00001d70 	.word	0x00001d70

Disassembly of section .text.set_goc_cmd:

00000b5c <set_goc_cmd>:

/**********************************************
 * Interrupt handlers
 **********************************************/

void set_goc_cmd() {
 b5c:	b508      	push	{r3, lr}
    goc_component = (*GOC_DATA_IRQ >> 24) & 0xFF;
 b5e:	238c      	movs	r3, #140	; 0x8c
 b60:	6819      	ldr	r1, [r3, #0]
 b62:	4a0c      	ldr	r2, [pc, #48]	; (b94 <set_goc_cmd+0x38>)
 b64:	0e09      	lsrs	r1, r1, #24
 b66:	7011      	strb	r1, [r2, #0]
    goc_func_id = (*GOC_DATA_IRQ >> 16) & 0xFF;
 b68:	6819      	ldr	r1, [r3, #0]
 b6a:	4a0b      	ldr	r2, [pc, #44]	; (b98 <set_goc_cmd+0x3c>)
 b6c:	0c09      	lsrs	r1, r1, #16
 b6e:	7011      	strb	r1, [r2, #0]
    goc_data = *GOC_DATA_IRQ & 0xFFFF;
 b70:	681a      	ldr	r2, [r3, #0]
 b72:	4b0a      	ldr	r3, [pc, #40]	; (b9c <set_goc_cmd+0x40>)
 b74:	801a      	strh	r2, [r3, #0]
    goc_state = 0;
 b76:	4b0a      	ldr	r3, [pc, #40]	; (ba0 <set_goc_cmd+0x44>)
 b78:	2200      	movs	r2, #0
 b7a:	701a      	strb	r2, [r3, #0]
    update_system_time();
 b7c:	f7ff fd7a 	bl	674 <update_system_time>
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	xot_last_timer_list[i] = xo_sys_time_in_sec;
 b80:	4a08      	ldr	r2, [pc, #32]	; (ba4 <set_goc_cmd+0x48>)
 b82:	4b09      	ldr	r3, [pc, #36]	; (ba8 <set_goc_cmd+0x4c>)
 b84:	6811      	ldr	r1, [r2, #0]
 b86:	6019      	str	r1, [r3, #0]
 b88:	6811      	ldr	r1, [r2, #0]
 b8a:	6059      	str	r1, [r3, #4]
 b8c:	6812      	ldr	r2, [r2, #0]
 b8e:	609a      	str	r2, [r3, #8]
    }
}
 b90:	bd08      	pop	{r3, pc}
 b92:	46c0      	nop			; (mov r8, r8)
 b94:	00001d22 	.word	0x00001d22
 b98:	00001d30 	.word	0x00001d30
 b9c:	00001d3a 	.word	0x00001d3a
 ba0:	00001d60 	.word	0x00001d60
 ba4:	00001d2c 	.word	0x00001d2c
 ba8:	00001cf8 	.word	0x00001cf8

Disassembly of section .text.handler_ext_int_wakeup:

00000bac <handler_ext_int_wakeup>:
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
 bac:	4b01      	ldr	r3, [pc, #4]	; (bb4 <handler_ext_int_wakeup+0x8>)
 bae:	2201      	movs	r2, #1
 bb0:	601a      	str	r2, [r3, #0]

}
 bb2:	4770      	bx	lr
 bb4:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_gocep:

00000bb8 <handler_ext_int_gocep>:

void handler_ext_int_gocep( void ) { // GOCEP
 bb8:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
 bba:	4b04      	ldr	r3, [pc, #16]	; (bcc <handler_ext_int_gocep+0x14>)
 bbc:	2204      	movs	r2, #4
 bbe:	601a      	str	r2, [r3, #0]
    set_goc_cmd();
 bc0:	f7ff ffcc 	bl	b5c <set_goc_cmd>
    reset_timers_list();
 bc4:	f7ff fda8 	bl	718 <reset_timers_list>
}
 bc8:	bd08      	pop	{r3, pc}
 bca:	46c0      	nop			; (mov r8, r8)
 bcc:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_timer32:

00000bd0 <handler_ext_int_timer32>:

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
 bd0:	4b04      	ldr	r3, [pc, #16]	; (be4 <handler_ext_int_timer32+0x14>)
 bd2:	2208      	movs	r2, #8
 bd4:	601a      	str	r2, [r3, #0]
    *TIMER32_STAT = 0x0;
 bd6:	4b04      	ldr	r3, [pc, #16]	; (be8 <handler_ext_int_timer32+0x18>)
 bd8:	2200      	movs	r2, #0
 bda:	601a      	str	r2, [r3, #0]
    
    wfi_timeout_flag = 1;
 bdc:	4b03      	ldr	r3, [pc, #12]	; (bec <handler_ext_int_timer32+0x1c>)
 bde:	2201      	movs	r2, #1
 be0:	701a      	strb	r2, [r3, #0]
}
 be2:	4770      	bx	lr
 be4:	e000e280 	.word	0xe000e280
 be8:	a0001110 	.word	0xa0001110
 bec:	00001d7c 	.word	0x00001d7c

Disassembly of section .text.handler_ext_int_xot:

00000bf0 <handler_ext_int_xot>:

void handler_ext_int_xot( void ) { // TIMER32
 bf0:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_XOT);
 bf2:	2280      	movs	r2, #128	; 0x80
 bf4:	4b02      	ldr	r3, [pc, #8]	; (c00 <handler_ext_int_xot+0x10>)
 bf6:	0312      	lsls	r2, r2, #12
 bf8:	601a      	str	r2, [r3, #0]
    update_system_time();
 bfa:	f7ff fd3b 	bl	674 <update_system_time>
}
 bfe:	bd08      	pop	{r3, pc}
 c00:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg0:

00000c04 <handler_ext_int_reg0>:

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
 c04:	4b02      	ldr	r3, [pc, #8]	; (c10 <handler_ext_int_reg0+0xc>)
 c06:	2280      	movs	r2, #128	; 0x80
 c08:	0052      	lsls	r2, r2, #1
 c0a:	601a      	str	r2, [r3, #0]
}
 c0c:	4770      	bx	lr
 c0e:	46c0      	nop			; (mov r8, r8)
 c10:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg1:

00000c14 <handler_ext_int_reg1>:

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
 c14:	4b02      	ldr	r3, [pc, #8]	; (c20 <handler_ext_int_reg1+0xc>)
 c16:	2280      	movs	r2, #128	; 0x80
 c18:	0092      	lsls	r2, r2, #2
 c1a:	601a      	str	r2, [r3, #0]
}
 c1c:	4770      	bx	lr
 c1e:	46c0      	nop			; (mov r8, r8)
 c20:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg2:

00000c24 <handler_ext_int_reg2>:

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
 c24:	4b02      	ldr	r3, [pc, #8]	; (c30 <handler_ext_int_reg2+0xc>)
 c26:	2280      	movs	r2, #128	; 0x80
 c28:	00d2      	lsls	r2, r2, #3
 c2a:	601a      	str	r2, [r3, #0]
}
 c2c:	4770      	bx	lr
 c2e:	46c0      	nop			; (mov r8, r8)
 c30:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg3:

00000c34 <handler_ext_int_reg3>:

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
 c34:	4b02      	ldr	r3, [pc, #8]	; (c40 <handler_ext_int_reg3+0xc>)
 c36:	2280      	movs	r2, #128	; 0x80
 c38:	0112      	lsls	r2, r2, #4
 c3a:	601a      	str	r2, [r3, #0]
}
 c3c:	4770      	bx	lr
 c3e:	46c0      	nop			; (mov r8, r8)
 c40:	e000e280 	.word	0xe000e280

Disassembly of section .text.startup.main:

00000c44 <main>:

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
     c44:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     c46:	4bfa      	ldr	r3, [pc, #1000]	; (1030 <main+0x3ec>)
     c48:	4afa      	ldr	r2, [pc, #1000]	; (1034 <main+0x3f0>)
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     c4a:	4cfb      	ldr	r4, [pc, #1004]	; (1038 <main+0x3f4>)
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     c4c:	601a      	str	r2, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     c4e:	6823      	ldr	r3, [r4, #0]
     c50:	4dfa      	ldr	r5, [pc, #1000]	; (103c <main+0x3f8>)
     c52:	42ab      	cmp	r3, r5
     c54:	d100      	bne.n	c58 <main+0x14>
     c56:	e3b9      	b.n	13cc <main+0x788>
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);
     c58:	2101      	movs	r1, #1
     c5a:	20ba      	movs	r0, #186	; 0xba
     c5c:	f7ff fa94 	bl	188 <mbus_write_message32>

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
     c60:	4bf7      	ldr	r3, [pc, #988]	; (1040 <main+0x3fc>)
     c62:	2700      	movs	r7, #0
     c64:	601f      	str	r7, [r3, #0]
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     c66:	4bf7      	ldr	r3, [pc, #988]	; (1044 <main+0x400>)
    config_timer32(0, 0, 0, 0);
     c68:	1c39      	adds	r1, r7, #0
     c6a:	1c3a      	adds	r2, r7, #0
static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     c6c:	601f      	str	r7, [r3, #0]
    config_timer32(0, 0, 0, 0);
     c6e:	1c38      	adds	r0, r7, #0
     c70:	1c3b      	adds	r3, r7, #0
     c72:	f7ff fa23 	bl	bc <config_timer32>

    // Enumeration
    enumerated = ENUMID;

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     c76:	2006      	movs	r0, #6
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    config_timer32(0, 0, 0, 0);

    // Enumeration
    enumerated = ENUMID;
     c78:	6025      	str	r5, [r4, #0]

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     c7a:	f7ff faa5 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c7e:	2064      	movs	r0, #100	; 0x64
     c80:	f7ff fa11 	bl	a6 <delay>
#endif
#ifdef USE_MRR
    mbus_enumerate(MRR_ADDR);
     c84:	2002      	movs	r0, #2
     c86:	f7ff fa9f 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c8a:	2064      	movs	r0, #100	; 0x64
     c8c:	f7ff fa0b 	bl	a6 <delay>
#endif
#ifdef USE_LNT
    mbus_enumerate(LNT_ADDR);
     c90:	2003      	movs	r0, #3
     c92:	f7ff fa99 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c96:	2064      	movs	r0, #100	; 0x64
     c98:	f7ff fa05 	bl	a6 <delay>
#endif
#ifdef USE_SNT
    mbus_enumerate(SNT_ADDR);
     c9c:	2004      	movs	r0, #4
     c9e:	f7ff fa93 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     ca2:	2064      	movs	r0, #100	; 0x64
     ca4:	f7ff f9ff 	bl	a6 <delay>
#endif
#ifdef USE_PMU
    mbus_enumerate(PMU_ADDR);
     ca8:	2005      	movs	r0, #5
     caa:	f7ff fa8d 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     cae:	2064      	movs	r0, #100	; 0x64
     cb0:	f7ff f9f9 	bl	a6 <delay>
#endif

    // Default CPU halt function
    set_halt_until_mbus_tx();
     cb4:	f7ff fa5c 	bl	170 <set_halt_until_mbus_tx>

    // Global variables
    wfi_timeout_flag = 0;
     cb8:	4be3      	ldr	r3, [pc, #908]	; (1048 <main+0x404>)

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     cba:	2119      	movs	r1, #25

    // Default CPU halt function
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;
     cbc:	701f      	strb	r7, [r3, #0]

    xo_sys_time = 0;
     cbe:	4be3      	ldr	r3, [pc, #908]	; (104c <main+0x408>)
    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;

    lnt_cur_level = 0;

    pmu_sar_ratio_radio = 0x34;
     cc0:	2234      	movs	r2, #52	; 0x34
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
     cc2:	601f      	str	r7, [r3, #0]
    xo_sys_time_in_sec = 0;
     cc4:	4be2      	ldr	r3, [pc, #904]	; (1050 <main+0x40c>)

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     cc6:	20ba      	movs	r0, #186	; 0xba

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
     cc8:	601f      	str	r7, [r3, #0]
    xo_day_time_in_sec = 0;
     cca:	4be2      	ldr	r3, [pc, #904]	; (1054 <main+0x410>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     ccc:	2402      	movs	r4, #2
    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;
     cce:	601f      	str	r7, [r3, #0]

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     cd0:	4be1      	ldr	r3, [pc, #900]	; (1058 <main+0x414>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     cd2:	2601      	movs	r6, #1

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     cd4:	6019      	str	r1, [r3, #0]
    snt_state = SNT_IDLE;
     cd6:	4be1      	ldr	r3, [pc, #900]	; (105c <main+0x418>)

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     cd8:	2102      	movs	r1, #2
    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;
     cda:	701f      	strb	r7, [r3, #0]

    lnt_cur_level = 0;
     cdc:	4be0      	ldr	r3, [pc, #896]	; (1060 <main+0x41c>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     cde:	4326      	orrs	r6, r4
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;

    lnt_cur_level = 0;
     ce0:	701f      	strb	r7, [r3, #0]

    pmu_sar_ratio_radio = 0x34;
     ce2:	4be0      	ldr	r3, [pc, #896]	; (1064 <main+0x420>)
     ce4:	701a      	strb	r2, [r3, #0]
    pmu_setting_state = PMU_20C;
     ce6:	4be0      	ldr	r3, [pc, #896]	; (1068 <main+0x424>)
     ce8:	2203      	movs	r2, #3
     cea:	601a      	str	r2, [r3, #0]

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     cec:	f7ff fa4c 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);
     cf0:	49de      	ldr	r1, [pc, #888]	; (106c <main+0x428>)
     cf2:	20ed      	movs	r0, #237	; 0xed
     cf4:	f7ff fa48 	bl	188 <mbus_write_message32>



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     cf8:	4bdd      	ldr	r3, [pc, #884]	; (1070 <main+0x42c>)
     cfa:	2140      	movs	r1, #64	; 0x40
     cfc:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     cfe:	2004      	movs	r0, #4
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     d00:	438a      	bics	r2, r1
     d02:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
     d04:	881a      	ldrh	r2, [r3, #0]
     d06:	2180      	movs	r1, #128	; 0x80
     d08:	438a      	bics	r2, r1
     d0a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     d0c:	681a      	ldr	r2, [r3, #0]
     d0e:	2101      	movs	r1, #1
     d10:	f7ff fa7b 	bl	20a <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     d14:	4bd7      	ldr	r3, [pc, #860]	; (1074 <main+0x430>)
     d16:	21ff      	movs	r1, #255	; 0xff
     d18:	881a      	ldrh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     d1a:	2004      	movs	r0, #4
#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     d1c:	400a      	ands	r2, r1
     d1e:	2180      	movs	r1, #128	; 0x80
     d20:	0149      	lsls	r1, r1, #5
     d22:	430a      	orrs	r2, r1
     d24:	801a      	strh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     d26:	881a      	ldrh	r2, [r3, #0]
     d28:	21ff      	movs	r1, #255	; 0xff
     d2a:	438a      	bics	r2, r1
     d2c:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     d2e:	681a      	ldr	r2, [r3, #0]
     d30:	2107      	movs	r1, #7
     d32:	f7ff fa6a 	bl	20a <mbus_remote_register_write>
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d36:	22fc      	movs	r2, #252	; 0xfc
     d38:	2380      	movs	r3, #128	; 0x80
     d3a:	4316      	orrs	r6, r2
     d3c:	021b      	lsls	r3, r3, #8
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     d3e:	4dce      	ldr	r5, [pc, #824]	; (1078 <main+0x434>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d40:	431e      	orrs	r6, r3
     d42:	2380      	movs	r3, #128	; 0x80
     d44:	031b      	lsls	r3, r3, #12
     d46:	431e      	orrs	r6, r3
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     d48:	782b      	ldrb	r3, [r5, #0]
     d4a:	2240      	movs	r2, #64	; 0x40
     d4c:	4393      	bics	r3, r2
     d4e:	702b      	strb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d50:	2180      	movs	r1, #128	; 0x80
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     d52:	782b      	ldrb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d54:	03c9      	lsls	r1, r1, #15
     d56:	430e      	orrs	r6, r1
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     d58:	2120      	movs	r1, #32
     d5a:	438b      	bics	r3, r1
     d5c:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d5e:	682a      	ldr	r2, [r5, #0]
     d60:	2004      	movs	r0, #4
     d62:	2108      	movs	r1, #8
     d64:	f7ff fa51 	bl	20a <mbus_remote_register_write>

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     d68:	4ac4      	ldr	r2, [pc, #784]	; (107c <main+0x438>)
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d6a:	2004      	movs	r0, #4
    sntv4_r08.TMR_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     d6c:	4016      	ands	r6, r2
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d6e:	1c32      	adds	r2, r6, #0
     d70:	2109      	movs	r1, #9
     d72:	f7ff fa4a 	bl	20a <mbus_remote_register_write>

    sntv4_r08.TMR_EN_OSC = 1;
     d76:	782b      	ldrb	r3, [r5, #0]
     d78:	2108      	movs	r1, #8
     d7a:	430b      	orrs	r3, r1
     d7c:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d7e:	682a      	ldr	r2, [r5, #0]
     d80:	2004      	movs	r0, #4
     d82:	f7ff fa42 	bl	20a <mbus_remote_register_write>
    delay(10000);
     d86:	48be      	ldr	r0, [pc, #760]	; (1080 <main+0x43c>)
     d88:	f7ff f98d 	bl	a6 <delay>

    sntv4_r08.TMR_RESETB = 1;
     d8c:	782b      	ldrb	r3, [r5, #0]
     d8e:	2210      	movs	r2, #16
     d90:	4313      	orrs	r3, r2
     d92:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DIV = 1;
     d94:	782b      	ldrb	r3, [r5, #0]
     d96:	2104      	movs	r1, #4
     d98:	430b      	orrs	r3, r1
     d9a:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DCDC = 1;
     d9c:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d9e:	1c08      	adds	r0, r1, #0
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r08.TMR_RESETB = 1;
    sntv4_r08.TMR_RESETB_DIV = 1;
    sntv4_r08.TMR_RESETB_DCDC = 1;
     da0:	4323      	orrs	r3, r4
     da2:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     da4:	682a      	ldr	r2, [r5, #0]
     da6:	2108      	movs	r1, #8
     da8:	f7ff fa2f 	bl	20a <mbus_remote_register_write>
    delay(10000);	// need to wait for clock to stabilize
     dac:	48b4      	ldr	r0, [pc, #720]	; (1080 <main+0x43c>)
     dae:	f7ff f97a 	bl	a6 <delay>

    sntv4_r08.TMR_EN_SELF_CLK = 1;
     db2:	782b      	ldrb	r3, [r5, #0]
     db4:	2201      	movs	r2, #1
     db6:	4313      	orrs	r3, r2
     db8:	702b      	strb	r3, [r5, #0]
    sntv4_r09.TMR_SELF_EN = 1;
     dba:	2380      	movs	r3, #128	; 0x80
     dbc:	039b      	lsls	r3, r3, #14
     dbe:	431e      	orrs	r6, r3
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     dc0:	682a      	ldr	r2, [r5, #0]
     dc2:	2004      	movs	r0, #4
     dc4:	2108      	movs	r1, #8
     dc6:	f7ff fa20 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     dca:	1c32      	adds	r2, r6, #0
     dcc:	2109      	movs	r1, #9
     dce:	2004      	movs	r0, #4
     dd0:	f7ff fa1b 	bl	20a <mbus_remote_register_write>
    delay(100000);
     dd4:	48ab      	ldr	r0, [pc, #684]	; (1084 <main+0x440>)
     dd6:	f7ff f966 	bl	a6 <delay>

    sntv4_r08.TMR_EN_OSC = 0;
     dda:	782b      	ldrb	r3, [r5, #0]
     ddc:	2108      	movs	r1, #8
     dde:	438b      	bics	r3, r1
     de0:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     de2:	682a      	ldr	r2, [r5, #0]
     de4:	2004      	movs	r0, #4
     de6:	f7ff fa10 	bl	20a <mbus_remote_register_write>
    delay(10000);
     dea:	48a5      	ldr	r0, [pc, #660]	; (1080 <main+0x43c>)
     dec:	f7ff f95b 	bl	a6 <delay>

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     df0:	4ba5      	ldr	r3, [pc, #660]	; (1088 <main+0x444>)
    sntv4_r1A.WUP_THRESHOLD = 0;
     df2:	4da6      	ldr	r5, [pc, #664]	; (108c <main+0x448>)

    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     df4:	781a      	ldrb	r2, [r3, #0]
     df6:	701f      	strb	r7, [r3, #0]
    sntv4_r1A.WUP_THRESHOLD = 0;
     df8:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     dfa:	2004      	movs	r0, #4
    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
     dfc:	0e12      	lsrs	r2, r2, #24
     dfe:	0612      	lsls	r2, r2, #24
     e00:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     e02:	681a      	ldr	r2, [r3, #0]
     e04:	2119      	movs	r1, #25
     e06:	f7ff fa00 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);
     e0a:	682a      	ldr	r2, [r5, #0]
     e0c:	2004      	movs	r0, #4
     e0e:	211a      	movs	r1, #26
     e10:	f7ff f9fb 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 0;
     e14:	4d9e      	ldr	r5, [pc, #632]	; (1090 <main+0x44c>)
     e16:	4b9f      	ldr	r3, [pc, #636]	; (1094 <main+0x450>)
     e18:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e1a:	2004      	movs	r0, #4
    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);

    sntv4_r17.WUP_ENABLE = 0;
     e1c:	4013      	ands	r3, r2
     e1e:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e20:	682a      	ldr	r2, [r5, #0]
     e22:	2117      	movs	r1, #23
     e24:	f7ff f9f1 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 1;
     e28:	682a      	ldr	r2, [r5, #0]
     e2a:	2380      	movs	r3, #128	; 0x80
     e2c:	041b      	lsls	r3, r3, #16
     e2e:	4313      	orrs	r3, r2
     e30:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_CLK_SEL = 0;
     e32:	682a      	ldr	r2, [r5, #0]
     e34:	4b98      	ldr	r3, [pc, #608]	; (1098 <main+0x454>)
    sntv4_r17.WUP_LC_IRQ_EN = 0;
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e36:	2004      	movs	r0, #4

    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
     e38:	4013      	ands	r3, r2
     e3a:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     e3c:	682a      	ldr	r2, [r5, #0]
     e3e:	4b97      	ldr	r3, [pc, #604]	; (109c <main+0x458>)
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e40:	2117      	movs	r1, #23
    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     e42:	4013      	ands	r3, r2
     e44:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_AUTO_RESET = 0;
     e46:	682b      	ldr	r3, [r5, #0]
     e48:	4a8c      	ldr	r2, [pc, #560]	; (107c <main+0x438>)
     e4a:	4013      	ands	r3, r2
     e4c:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e4e:	682a      	ldr	r2, [r5, #0]
     e50:	f7ff f9db 	bl	20a <mbus_remote_register_write>
    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    snt_clk_init();
    operation_temp_run();
     e54:	f7ff fb5e 	bl	514 <operation_temp_run>

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     e58:	4b91      	ldr	r3, [pc, #580]	; (10a0 <main+0x45c>)
     e5a:	4992      	ldr	r1, [pc, #584]	; (10a4 <main+0x460>)
     e5c:	681a      	ldr	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e5e:	2003      	movs	r0, #3

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     e60:	400a      	ands	r2, r1
     e62:	2180      	movs	r1, #128	; 0x80
     e64:	0389      	lsls	r1, r1, #14
     e66:	430a      	orrs	r2, r1
     e68:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     e6a:	6819      	ldr	r1, [r3, #0]
     e6c:	4a8e      	ldr	r2, [pc, #568]	; (10a8 <main+0x464>)
     e6e:	400a      	ands	r2, r1
     e70:	498e      	ldr	r1, [pc, #568]	; (10ac <main+0x468>)
     e72:	430a      	orrs	r2, r1
     e74:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     e76:	681a      	ldr	r2, [r3, #0]
     e78:	2140      	movs	r1, #64	; 0x40
     e7a:	430a      	orrs	r2, r1
     e7c:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e7e:	681a      	ldr	r2, [r3, #0]
     e80:	2122      	movs	r1, #34	; 0x22
     e82:	f7ff f9c2 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e86:	20fa      	movs	r0, #250	; 0xfa
     e88:	40a0      	lsls	r0, r4
     e8a:	f7ff f90c 	bl	a6 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     e8e:	4e88      	ldr	r6, [pc, #544]	; (10b0 <main+0x46c>)
     e90:	4b88      	ldr	r3, [pc, #544]	; (10b4 <main+0x470>)
     e92:	6832      	ldr	r2, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e94:	21fc      	movs	r1, #252	; 0xfc
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     e96:	4013      	ands	r3, r2
     e98:	2280      	movs	r2, #128	; 0x80
     e9a:	0212      	lsls	r2, r2, #8
     e9c:	4313      	orrs	r3, r2
     e9e:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     ea0:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     ea2:	2201      	movs	r2, #1
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     ea4:	430b      	orrs	r3, r1
     ea6:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     ea8:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     eaa:	2121      	movs	r1, #33	; 0x21
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     eac:	4323      	orrs	r3, r4
     eae:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     eb0:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     eb2:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     eb4:	4313      	orrs	r3, r2
     eb6:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     eb8:	6832      	ldr	r2, [r6, #0]
     eba:	f7ff f9a6 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ebe:	20fa      	movs	r0, #250	; 0xfa
     ec0:	40a0      	lsls	r0, r4
     ec2:	f7ff f8f0 	bl	a6 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     ec6:	4b7c      	ldr	r3, [pc, #496]	; (10b8 <main+0x474>)
     ec8:	497c      	ldr	r1, [pc, #496]	; (10bc <main+0x478>)
     eca:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     ecc:	2003      	movs	r0, #3
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     ece:	400a      	ands	r2, r1
     ed0:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     ed2:	681a      	ldr	r2, [r3, #0]
     ed4:	2140      	movs	r1, #64	; 0x40
     ed6:	f7ff f998 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     eda:	20fa      	movs	r0, #250	; 0xfa
     edc:	40a0      	lsls	r0, r4
     ede:	f7ff f8e2 	bl	a6 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     ee2:	6833      	ldr	r3, [r6, #0]
     ee4:	4a65      	ldr	r2, [pc, #404]	; (107c <main+0x438>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ee6:	2121      	movs	r1, #33	; 0x21
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     ee8:	4013      	ands	r3, r2
     eea:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     eec:	6832      	ldr	r2, [r6, #0]
     eee:	2003      	movs	r0, #3
     ef0:	f7ff f98b 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ef4:	20fa      	movs	r0, #250	; 0xfa
     ef6:	40a0      	lsls	r0, r4
     ef8:	f7ff f8d5 	bl	a6 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     efc:	4d70      	ldr	r5, [pc, #448]	; (10c0 <main+0x47c>)
     efe:	2108      	movs	r1, #8
     f00:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f02:	2003      	movs	r0, #3
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     f04:	430b      	orrs	r3, r1
     f06:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f08:	682a      	ldr	r2, [r5, #0]
     f0a:	2120      	movs	r1, #32
     f0c:	f7ff f97d 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f10:	20fa      	movs	r0, #250	; 0xfa
     f12:	40a0      	lsls	r0, r4
     f14:	f7ff f8c7 	bl	a6 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
     f18:	782b      	ldrb	r3, [r5, #0]
     f1a:	2210      	movs	r2, #16
     f1c:	4313      	orrs	r3, r2
     f1e:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
     f20:	782b      	ldrb	r3, [r5, #0]
     f22:	2104      	movs	r1, #4
     f24:	430b      	orrs	r3, r1
     f26:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     f28:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f2a:	2120      	movs	r1, #32
    delay(MBUS_DELAY*10);
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     f2c:	4323      	orrs	r3, r4
     f2e:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f30:	682a      	ldr	r2, [r5, #0]
     f32:	2003      	movs	r0, #3
     f34:	f7ff f969 	bl	20a <mbus_remote_register_write>
    delay(2000); 
     f38:	20fa      	movs	r0, #250	; 0xfa
     f3a:	00c0      	lsls	r0, r0, #3
     f3c:	f7ff f8b3 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
     f40:	782b      	ldrb	r3, [r5, #0]
     f42:	2201      	movs	r2, #1
     f44:	4313      	orrs	r3, r2
     f46:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f48:	682a      	ldr	r2, [r5, #0]
     f4a:	2120      	movs	r1, #32
     f4c:	2003      	movs	r0, #3
     f4e:	f7ff f95c 	bl	20a <mbus_remote_register_write>
    delay(10); 
     f52:	200a      	movs	r0, #10
     f54:	f7ff f8a7 	bl	a6 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
     f58:	6833      	ldr	r3, [r6, #0]
     f5a:	2180      	movs	r1, #128	; 0x80
     f5c:	0389      	lsls	r1, r1, #14
     f5e:	430b      	orrs	r3, r1
     f60:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     f62:	6832      	ldr	r2, [r6, #0]
     f64:	2121      	movs	r1, #33	; 0x21
     f66:	2003      	movs	r0, #3
     f68:	f7ff f94f 	bl	20a <mbus_remote_register_write>
    delay(100000); 
     f6c:	4845      	ldr	r0, [pc, #276]	; (1084 <main+0x440>)
     f6e:	f7ff f89a 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
     f72:	782b      	ldrb	r3, [r5, #0]
     f74:	2208      	movs	r2, #8
     f76:	4393      	bics	r3, r2
     f78:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f7a:	682a      	ldr	r2, [r5, #0]
     f7c:	2120      	movs	r1, #32
     f7e:	2003      	movs	r0, #3
     f80:	f7ff f943 	bl	20a <mbus_remote_register_write>
    delay(100);
     f84:	2064      	movs	r0, #100	; 0x64
     f86:	f7ff f88e 	bl	a6 <delay>
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f8a:	4b4e      	ldr	r3, [pc, #312]	; (10c4 <main+0x480>)
     f8c:	2101      	movs	r1, #1
     f8e:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     f90:	2003      	movs	r0, #3
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f92:	430a      	orrs	r2, r1
     f94:	701a      	strb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
     f96:	781a      	ldrb	r2, [r3, #0]
     f98:	211e      	movs	r1, #30
     f9a:	438a      	bics	r2, r1
     f9c:	2110      	movs	r1, #16
     f9e:	430a      	orrs	r2, r1
     fa0:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     fa2:	681a      	ldr	r2, [r3, #0]
     fa4:	2117      	movs	r1, #23
     fa6:	f7ff f930 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     faa:	20fa      	movs	r0, #250	; 0xfa
     fac:	40a0      	lsls	r0, r4
     fae:	f7ff f87a 	bl	a6 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     fb2:	4b45      	ldr	r3, [pc, #276]	; (10c8 <main+0x484>)
     fb4:	21f0      	movs	r1, #240	; 0xf0
     fb6:	881a      	ldrh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     fb8:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     fba:	438a      	bics	r2, r1
     fbc:	2170      	movs	r1, #112	; 0x70
     fbe:	430a      	orrs	r2, r1
     fc0:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
     fc2:	881a      	ldrh	r2, [r3, #0]
     fc4:	210f      	movs	r1, #15
     fc6:	438a      	bics	r2, r1
     fc8:	4322      	orrs	r2, r4
     fca:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
     fcc:	8819      	ldrh	r1, [r3, #0]
     fce:	2280      	movs	r2, #128	; 0x80
     fd0:	0052      	lsls	r2, r2, #1
     fd2:	430a      	orrs	r2, r1
     fd4:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     fd6:	681a      	ldr	r2, [r3, #0]
     fd8:	2101      	movs	r1, #1
     fda:	f7ff f916 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     fde:	20fa      	movs	r0, #250	; 0xfa
     fe0:	40a0      	lsls	r0, r4
     fe2:	f7ff f860 	bl	a6 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     fe6:	4b39      	ldr	r3, [pc, #228]	; (10cc <main+0x488>)
     fe8:	4a39      	ldr	r2, [pc, #228]	; (10d0 <main+0x48c>)
     fea:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     fec:	2003      	movs	r0, #3
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    delay(MBUS_DELAY*10);
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     fee:	400a      	ands	r2, r1
     ff0:	2180      	movs	r1, #128	; 0x80
     ff2:	430a      	orrs	r2, r1
     ff4:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     ff6:	681a      	ldr	r2, [r3, #0]
     ff8:	1c21      	adds	r1, r4, #0
     ffa:	f7ff f906 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ffe:	20fa      	movs	r0, #250	; 0xfa
    1000:	40a0      	lsls	r0, r4
    1002:	f7ff f850 	bl	a6 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    1006:	4b33      	ldr	r3, [pc, #204]	; (10d4 <main+0x490>)
    1008:	4a33      	ldr	r2, [pc, #204]	; (10d8 <main+0x494>)
    100a:	6819      	ldr	r1, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    100c:	2003      	movs	r0, #3
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    delay(MBUS_DELAY*10);
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    100e:	400a      	ands	r2, r1
    1010:	21c0      	movs	r1, #192	; 0xc0
    1012:	0289      	lsls	r1, r1, #10
    1014:	430a      	orrs	r2, r1
    1016:	601a      	str	r2, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    1018:	681a      	ldr	r2, [r3, #0]
    101a:	2110      	movs	r1, #16
    101c:	0b12      	lsrs	r2, r2, #12
    101e:	0312      	lsls	r2, r2, #12
    1020:	430a      	orrs	r2, r1
    1022:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    1024:	681a      	ldr	r2, [r3, #0]
    1026:	2105      	movs	r1, #5
    1028:	f7ff f8ef 	bl	20a <mbus_remote_register_write>
    102c:	e056      	b.n	10dc <main+0x498>
    102e:	46c0      	nop			; (mov r8, r8)
    1030:	e000e100 	.word	0xe000e100
    1034:	00080f0d 	.word	0x00080f0d
    1038:	00001d24 	.word	0x00001d24
    103c:	deadbeef 	.word	0xdeadbeef
    1040:	a0001200 	.word	0xa0001200
    1044:	a000007c 	.word	0xa000007c
    1048:	00001d7c 	.word	0x00001d7c
    104c:	00001d08 	.word	0x00001d08
    1050:	00001d2c 	.word	0x00001d2c
    1054:	00001d78 	.word	0x00001d78
    1058:	00001d40 	.word	0x00001d40
    105c:	00001d28 	.word	0x00001d28
    1060:	00001d10 	.word	0x00001d10
    1064:	00001d32 	.word	0x00001d32
    1068:	00001d34 	.word	0x00001d34
    106c:	0d0a0f0f 	.word	0x0d0a0f0f
    1070:	00001cd4 	.word	0x00001cd4
    1074:	00001ce0 	.word	0x00001ce0
    1078:	00001ce4 	.word	0x00001ce4
    107c:	ffdfffff 	.word	0xffdfffff
    1080:	00002710 	.word	0x00002710
    1084:	000186a0 	.word	0x000186a0
    1088:	00001d98 	.word	0x00001d98
    108c:	00001cdc 	.word	0x00001cdc
    1090:	00001c94 	.word	0x00001c94
    1094:	ff7fffff 	.word	0xff7fffff
    1098:	ffefffff 	.word	0xffefffff
    109c:	ffbfffff 	.word	0xffbfffff
    10a0:	00001cb8 	.word	0x00001cb8
    10a4:	ff1fffff 	.word	0xff1fffff
    10a8:	ffe0007f 	.word	0xffe0007f
    10ac:	001ffe80 	.word	0x001ffe80
    10b0:	00001cb4 	.word	0x00001cb4
    10b4:	ffff00ff 	.word	0xffff00ff
    10b8:	00001cbc 	.word	0x00001cbc
    10bc:	fff7ffff 	.word	0xfff7ffff
    10c0:	00001d94 	.word	0x00001d94
    10c4:	00001d88 	.word	0x00001d88
    10c8:	00001ca0 	.word	0x00001ca0
    10cc:	00001ca4 	.word	0x00001ca4
    10d0:	fffffe7f 	.word	0xfffffe7f
    10d4:	00001cb0 	.word	0x00001cb0
    10d8:	ff000fff 	.word	0xff000fff
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    10dc:	4bdc      	ldr	r3, [pc, #880]	; (1450 <main+0x80c>)
    10de:	2101      	movs	r1, #1
    10e0:	781a      	ldrb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    10e2:	2003      	movs	r0, #3
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    10e4:	438a      	bics	r2, r1
    10e6:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    10e8:	681a      	ldr	r2, [r3, #0]
    10ea:	2106      	movs	r1, #6
    10ec:	f7ff f88d 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10f0:	20fa      	movs	r0, #250	; 0xfa
    10f2:	40a0      	lsls	r0, r4
    10f4:	f7fe ffd7 	bl	a6 <delay>
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    10f8:	4bd6      	ldr	r3, [pc, #856]	; (1454 <main+0x810>)
    10fa:	49d7      	ldr	r1, [pc, #860]	; (1458 <main+0x814>)
    10fc:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    10fe:	2003      	movs	r0, #3
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    1100:	430a      	orrs	r2, r1
    1102:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    1104:	681a      	ldr	r2, [r3, #0]
    1106:	1c01      	adds	r1, r0, #0
    1108:	f7ff f87f 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    110c:	20fa      	movs	r0, #250	; 0xfa
    110e:	40a0      	lsls	r0, r4
    1110:	f7fe ffc9 	bl	a6 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    1114:	4bd1      	ldr	r3, [pc, #836]	; (145c <main+0x818>)
    1116:	210a      	movs	r1, #10
    1118:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    111a:	2003      	movs	r0, #3
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    111c:	0b12      	lsrs	r2, r2, #12
    111e:	0312      	lsls	r2, r2, #12
    1120:	430a      	orrs	r2, r1
    1122:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    1124:	681a      	ldr	r2, [r3, #0]
    1126:	2104      	movs	r1, #4
    1128:	f7ff f86f 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    112c:	20fa      	movs	r0, #250	; 0xfa
    112e:	40a0      	lsls	r0, r4
    1130:	f7fe ffb9 	bl	a6 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    1134:	4dca      	ldr	r5, [pc, #808]	; (1460 <main+0x81c>)
    1136:	2201      	movs	r2, #1
    1138:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    113a:	1c39      	adds	r1, r7, #0
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    113c:	4393      	bics	r3, r2
    113e:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1140:	682a      	ldr	r2, [r5, #0]
    1142:	2003      	movs	r0, #3
    1144:	f7ff f861 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1148:	20fa      	movs	r0, #250	; 0xfa
    114a:	40a0      	lsls	r0, r4
    114c:	f7fe ffab 	bl	a6 <delay>
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    1150:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1152:	1c39      	adds	r1, r7, #0
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    1154:	43a3      	bics	r3, r4
    1156:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1158:	682a      	ldr	r2, [r5, #0]
    115a:	2003      	movs	r0, #3
    115c:	f7ff f855 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1160:	20fa      	movs	r0, #250	; 0xfa
    1162:	40a0      	lsls	r0, r4
    1164:	f7fe ff9f 	bl	a6 <delay>

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    1168:	4dbe      	ldr	r5, [pc, #760]	; (1464 <main+0x820>)
    116a:	49bf      	ldr	r1, [pc, #764]	; (1468 <main+0x824>)
    116c:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    116e:	1c20      	adds	r0, r4, #0

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    1170:	400b      	ands	r3, r1
    1172:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1174:	682a      	ldr	r2, [r5, #0]
    1176:	2103      	movs	r1, #3
    1178:	f7ff f847 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    117c:	682a      	ldr	r2, [r5, #0]
    117e:	2380      	movs	r3, #128	; 0x80
    1180:	02db      	lsls	r3, r3, #11
    1182:	4313      	orrs	r3, r2
    1184:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1186:	682a      	ldr	r2, [r5, #0]
    1188:	1c20      	adds	r0, r4, #0
    118a:	2103      	movs	r1, #3
    118c:	f7ff f83d 	bl	20a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    1190:	4eb6      	ldr	r6, [pc, #728]	; (146c <main+0x828>)
    1192:	227e      	movs	r2, #126	; 0x7e
    1194:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1196:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    1198:	4393      	bics	r3, r2
    119a:	2210      	movs	r2, #16
    119c:	4313      	orrs	r3, r2
    119e:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    11a0:	6832      	ldr	r2, [r6, #0]
    11a2:	1c39      	adds	r1, r7, #0
    11a4:	f7ff f831 	bl	20a <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    11a8:	6833      	ldr	r3, [r6, #0]
    11aa:	2101      	movs	r1, #1
    11ac:	430b      	orrs	r3, r1
    11ae:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    11b0:	6832      	ldr	r2, [r6, #0]
    11b2:	1c39      	adds	r1, r7, #0
    11b4:	1c20      	adds	r0, r4, #0
    11b6:	f7ff f828 	bl	20a <mbus_remote_register_write>

    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    11ba:	48ad      	ldr	r0, [pc, #692]	; (1470 <main+0x82c>)
    11bc:	f7fe ff73 	bl	a6 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    11c0:	4bac      	ldr	r3, [pc, #688]	; (1474 <main+0x830>)
    11c2:	2103      	movs	r1, #3
    11c4:	781a      	ldrb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    11c6:	1c20      	adds	r0, r4, #0
    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    11c8:	430a      	orrs	r2, r1
    11ca:	701a      	strb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    11cc:	781a      	ldrb	r2, [r3, #0]
    11ce:	210c      	movs	r1, #12
    11d0:	430a      	orrs	r2, r1
    11d2:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    11d4:	681a      	ldr	r2, [r3, #0]
    11d6:	211f      	movs	r1, #31
    11d8:	f7ff f817 	bl	20a <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11dc:	4ba6      	ldr	r3, [pc, #664]	; (1478 <main+0x834>)
    11de:	210c      	movs	r1, #12
    11e0:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    11e2:	1c20      	adds	r0, r4, #0

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11e4:	0a92      	lsrs	r2, r2, #10
    11e6:	0292      	lsls	r2, r2, #10
    11e8:	430a      	orrs	r2, r1
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11ea:	49a4      	ldr	r1, [pc, #656]	; (147c <main+0x838>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11ec:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11ee:	680a      	ldr	r2, [r1, #0]
    11f0:	49a3      	ldr	r1, [pc, #652]	; (1480 <main+0x83c>)
    11f2:	0bd2      	lsrs	r2, r2, #15
    11f4:	03d2      	lsls	r2, r2, #15
    11f6:	430a      	orrs	r2, r1
    11f8:	49a0      	ldr	r1, [pc, #640]	; (147c <main+0x838>)
    11fa:	600a      	str	r2, [r1, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    11fc:	6819      	ldr	r1, [r3, #0]
    11fe:	4aa1      	ldr	r2, [pc, #644]	; (1484 <main+0x840>)
    1200:	400a      	ands	r2, r1
    1202:	21c8      	movs	r1, #200	; 0xc8
    1204:	01c9      	lsls	r1, r1, #7
    1206:	430a      	orrs	r2, r1
    1208:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    120a:	681a      	ldr	r2, [r3, #0]
    120c:	2112      	movs	r1, #18
    120e:	f7fe fffc 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1212:	4b9a      	ldr	r3, [pc, #616]	; (147c <main+0x838>)
    1214:	1c20      	adds	r0, r4, #0
    1216:	681a      	ldr	r2, [r3, #0]
    1218:	2113      	movs	r1, #19
    121a:	f7fe fff6 	bl	20a <mbus_remote_register_write>
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 1;
    121e:	4b9a      	ldr	r3, [pc, #616]	; (1488 <main+0x844>)
    1220:	2101      	movs	r1, #1
    1222:	7019      	strb	r1, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
    1224:	4b99      	ldr	r3, [pc, #612]	; (148c <main+0x848>)
    1226:	2204      	movs	r2, #4
    1228:	701a      	strb	r2, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
    122a:	4b99      	ldr	r3, [pc, #612]	; (1490 <main+0x84c>)

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    122c:	2280      	movs	r2, #128	; 0x80
    122e:	1c20      	adds	r0, r4, #0
    1230:	2106      	movs	r1, #6
    1232:	0152      	lsls	r2, r2, #5
    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 1;
    mrr_freq_hopping_step = 4; // determining center freq

    mrr_cfo_val_fine_min = 0x0000;
    1234:	801f      	strh	r7, [r3, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    1236:	f7fe ffe8 	bl	20a <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
    123a:	2280      	movs	r2, #128	; 0x80
    123c:	1c20      	adds	r0, r4, #0
    123e:	2108      	movs	r1, #8
    1240:	03d2      	lsls	r2, r2, #15
    1242:	f7fe ffe2 	bl	20a <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    1246:	4b93      	ldr	r3, [pc, #588]	; (1494 <main+0x850>)
    1248:	217f      	movs	r1, #127	; 0x7f
    124a:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    124c:	1c20      	adds	r0, r4, #0

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    124e:	438a      	bics	r2, r1
    1250:	2110      	movs	r1, #16
    1252:	430a      	orrs	r2, r1
    1254:	801a      	strh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    1256:	8819      	ldrh	r1, [r3, #0]
    1258:	4a8f      	ldr	r2, [pc, #572]	; (1498 <main+0x854>)
    125a:	400a      	ands	r2, r1
    125c:	2180      	movs	r1, #128	; 0x80
    125e:	0109      	lsls	r1, r1, #4
    1260:	430a      	orrs	r2, r1
    1262:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    1264:	681a      	ldr	r2, [r3, #0]
    1266:	2107      	movs	r1, #7
    1268:	f7fe ffcf 	bl	20a <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    126c:	6832      	ldr	r2, [r6, #0]
    126e:	4b8b      	ldr	r3, [pc, #556]	; (149c <main+0x858>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1270:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    1272:	4013      	ands	r3, r2
    1274:	22e0      	movs	r2, #224	; 0xe0
    1276:	40a2      	lsls	r2, r4
    1278:	4313      	orrs	r3, r2
    127a:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    127c:	6832      	ldr	r2, [r6, #0]
    127e:	1c39      	adds	r1, r7, #0
    1280:	f7fe ffc3 	bl	20a <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    1284:	4b86      	ldr	r3, [pc, #536]	; (14a0 <main+0x85c>)
    1286:	2107      	movs	r1, #7
    1288:	681a      	ldr	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    128a:	263f      	movs	r6, #63	; 0x3f
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    128c:	0a92      	lsrs	r2, r2, #10
    128e:	0292      	lsls	r2, r2, #10
    1290:	430a      	orrs	r2, r1
    1292:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    1294:	4a7e      	ldr	r2, [pc, #504]	; (1490 <main+0x84c>)
    1296:	8811      	ldrh	r1, [r2, #0]
    1298:	6818      	ldr	r0, [r3, #0]
    129a:	4a82      	ldr	r2, [pc, #520]	; (14a4 <main+0x860>)
    129c:	4031      	ands	r1, r6
    129e:	0409      	lsls	r1, r1, #16
    12a0:	4002      	ands	r2, r0
    12a2:	430a      	orrs	r2, r1
    12a4:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    12a6:	4a7a      	ldr	r2, [pc, #488]	; (1490 <main+0x84c>)
    12a8:	8811      	ldrh	r1, [r2, #0]
    12aa:	6818      	ldr	r0, [r3, #0]
    12ac:	4a7e      	ldr	r2, [pc, #504]	; (14a8 <main+0x864>)
    12ae:	4031      	ands	r1, r6
    12b0:	0289      	lsls	r1, r1, #10
    12b2:	4002      	ands	r2, r0
    12b4:	430a      	orrs	r2, r1
    12b6:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    12b8:	681a      	ldr	r2, [r3, #0]
    12ba:	1c20      	adds	r0, r4, #0
    12bc:	2101      	movs	r1, #1
    12be:	f7fe ffa4 	bl	20a <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    12c2:	4b7a      	ldr	r3, [pc, #488]	; (14ac <main+0x868>)
    12c4:	497a      	ldr	r1, [pc, #488]	; (14b0 <main+0x86c>)
    12c6:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    12c8:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    12ca:	430a      	orrs	r2, r1
    12cc:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    12ce:	681a      	ldr	r2, [r3, #0]
    12d0:	1c21      	adds	r1, r4, #0
    12d2:	f7fe ff9a 	bl	20a <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    12d6:	682a      	ldr	r2, [r5, #0]
    12d8:	4b76      	ldr	r3, [pc, #472]	; (14b4 <main+0x870>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12da:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    12dc:	4013      	ands	r3, r2
    12de:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12e0:	682a      	ldr	r2, [r5, #0]
    12e2:	2103      	movs	r1, #3
    12e4:	f7fe ff91 	bl	20a <mbus_remote_register_write>

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12e8:	4b73      	ldr	r3, [pc, #460]	; (14b8 <main+0x874>)
    12ea:	4a74      	ldr	r2, [pc, #464]	; (14bc <main+0x878>)
    12ec:	6819      	ldr	r1, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12ee:	4d74      	ldr	r5, [pc, #464]	; (14c0 <main+0x87c>)

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12f0:	400a      	ands	r2, r1
    12f2:	601a      	str	r2, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12f4:	682a      	ldr	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    12f6:	1c20      	adds	r0, r4, #0
    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12f8:	43b2      	bics	r2, r6
    12fa:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    12fc:	6829      	ldr	r1, [r5, #0]
    12fe:	4a71      	ldr	r2, [pc, #452]	; (14c4 <main+0x880>)
    1300:	400a      	ands	r2, r1
    1302:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    1304:	6829      	ldr	r1, [r5, #0]
    1306:	4a70      	ldr	r2, [pc, #448]	; (14c8 <main+0x884>)
    1308:	400a      	ands	r2, r1
    130a:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    130c:	681a      	ldr	r2, [r3, #0]
    130e:	2114      	movs	r1, #20
    1310:	f7fe ff7b 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
    1314:	682a      	ldr	r2, [r5, #0]
    1316:	1c20      	adds	r0, r4, #0
    1318:	2115      	movs	r1, #21
    131a:	f7fe ff76 	bl	20a <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    131e:	1c20      	adds	r0, r4, #0
    1320:	1c3a      	adds	r2, r7, #0
    1322:	2109      	movs	r1, #9
    1324:	f7fe ff71 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    1328:	1c20      	adds	r0, r4, #0
    132a:	1c3a      	adds	r2, r7, #0
    132c:	210a      	movs	r1, #10
    132e:	f7fe ff6c 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    1332:	1c20      	adds	r0, r4, #0
    1334:	1c3a      	adds	r2, r7, #0
    1336:	210b      	movs	r1, #11
    1338:	f7fe ff67 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    133c:	1c20      	adds	r0, r4, #0
    133e:	210c      	movs	r1, #12
    1340:	4a62      	ldr	r2, [pc, #392]	; (14cc <main+0x888>)
    1342:	f7fe ff62 	bl	20a <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    1346:	4b62      	ldr	r3, [pc, #392]	; (14d0 <main+0x88c>)
    1348:	21f8      	movs	r1, #248	; 0xf8
    134a:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    134c:	1c20      	adds	r0, r4, #0
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    134e:	438a      	bics	r2, r1
    1350:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    1352:	881a      	ldrh	r2, [r3, #0]
    1354:	21ff      	movs	r1, #255	; 0xff
    1356:	400a      	ands	r2, r1
    1358:	495e      	ldr	r1, [pc, #376]	; (14d4 <main+0x890>)
    135a:	430a      	orrs	r2, r1
    135c:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    135e:	681a      	ldr	r2, [r3, #0]
    1360:	2111      	movs	r1, #17
    1362:	f7fe ff52 	bl	20a <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    1366:	4a45      	ldr	r2, [pc, #276]	; (147c <main+0x838>)
    1368:	495b      	ldr	r1, [pc, #364]	; (14d8 <main+0x894>)
    136a:	6813      	ldr	r3, [r2, #0]
    136c:	22c0      	movs	r2, #192	; 0xc0
    136e:	400b      	ands	r3, r1
    1370:	03d2      	lsls	r2, r2, #15
    1372:	4313      	orrs	r3, r2
    1374:	4a41      	ldr	r2, [pc, #260]	; (147c <main+0x838>)
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1376:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    1378:	6013      	str	r3, [r2, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    137a:	6812      	ldr	r2, [r2, #0]
    137c:	2113      	movs	r1, #19
    137e:	f7fe ff44 	bl	20a <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
    1382:	4a56      	ldr	r2, [pc, #344]	; (14dc <main+0x898>)
    1384:	211e      	movs	r1, #30
    1386:	1c20      	adds	r0, r4, #0
    1388:	f7fe ff3f 	bl	20a <mbus_remote_register_write>

    // Additional delay for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    138c:	4838      	ldr	r0, [pc, #224]	; (1470 <main+0x82c>)
    138e:	f7fe fe8a 	bl	a6 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    1392:	4b53      	ldr	r3, [pc, #332]	; (14e0 <main+0x89c>)
    delay(MBUS_DELAY);
    return;
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    1394:	1c38      	adds	r0, r7, #0
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    1396:	701f      	strb	r7, [r3, #0]
    radio_ready = 0;
    1398:	4b52      	ldr	r3, [pc, #328]	; (14e4 <main+0x8a0>)
    139a:	701f      	strb	r7, [r3, #0]
    delay(MBUS_DELAY);
    return;
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    139c:	f7fe ffc6 	bl	32c <pmu_setting_temp_based>
    read_data_batadc = *REG0 & 0xFFFF;
}

inline static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
    13a0:	2186      	movs	r1, #134	; 0x86
    13a2:	200e      	movs	r0, #14
    13a4:	00c9      	lsls	r1, r1, #3
    13a6:	f7fe ff75 	bl	294 <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
    13aa:	2045      	movs	r0, #69	; 0x45
    13ac:	2148      	movs	r1, #72	; 0x48
    13ae:	f7fe ff71 	bl	294 <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
    13b2:	203a      	movs	r0, #58	; 0x3a
    13b4:	494c      	ldr	r1, [pc, #304]	; (14e8 <main+0x8a4>)
    13b6:	f7fe ff6d 	bl	294 <pmu_reg_write>
}

inline static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    13ba:	203c      	movs	r0, #60	; 0x3c
    13bc:	494b      	ldr	r1, [pc, #300]	; (14ec <main+0x8a8>)
    13be:	f7fe ff69 	bl	294 <pmu_reg_write>

inline static void pmu_adc_enable() {
    // PMU ADC will be automatically reset when system wakes up
    // PMU_CONTROLLER_DESIRED_STATE sleep
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
    13c2:	203b      	movs	r0, #59	; 0x3b
    13c4:	494a      	ldr	r1, [pc, #296]	; (14f0 <main+0x8ac>)
    13c6:	f7fe ff65 	bl	294 <pmu_reg_write>
    13ca:	e38a      	b.n	1ae2 <main+0xe9e>
    if(enumerated != ENUMID) {
        operation_init();
        operation_sleep_notimer();
    }

    update_system_time();
    13cc:	f7ff f952 	bl	674 <update_system_time>
#define MPLIER_SHIFT 6
uint8_t lnt_snt_mplier = 0x52;
uint32_t projected_end_time = 0;

static void update_lnt_timer() {
    if(xo_sys_time > projected_end_time + TIMER_MARGIN 
    13d0:	4b48      	ldr	r3, [pc, #288]	; (14f4 <main+0x8b0>)
    13d2:	4a49      	ldr	r2, [pc, #292]	; (14f8 <main+0x8b4>)
    13d4:	681b      	ldr	r3, [r3, #0]
    13d6:	6810      	ldr	r0, [r2, #0]
    13d8:	1c59      	adds	r1, r3, #1
    13da:	31ff      	adds	r1, #255	; 0xff
    13dc:	4288      	cmp	r0, r1
    13de:	d909      	bls.n	13f4 <main+0x7b0>
	&& xo_sys_time_in_sec - (projected_end_time >> XO_TO_SEC_SHIFT) < 256) {
    13e0:	4946      	ldr	r1, [pc, #280]	; (14fc <main+0x8b8>)
    13e2:	6808      	ldr	r0, [r1, #0]
    13e4:	0a99      	lsrs	r1, r3, #10
    13e6:	1a41      	subs	r1, r0, r1
    13e8:	29ff      	cmp	r1, #255	; 0xff
    13ea:	d803      	bhi.n	13f4 <main+0x7b0>
        lnt_snt_mplier--;
    13ec:	4944      	ldr	r1, [pc, #272]	; (1500 <main+0x8bc>)
    13ee:	7808      	ldrb	r0, [r1, #0]
    13f0:	3801      	subs	r0, #1
    13f2:	e00d      	b.n	1410 <main+0x7cc>
    }
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
    13f4:	1e59      	subs	r1, r3, #1
    13f6:	6810      	ldr	r0, [r2, #0]
    13f8:	39ff      	subs	r1, #255	; 0xff
    13fa:	4288      	cmp	r0, r1
    13fc:	d209      	bcs.n	1412 <main+0x7ce>
		&& (projected_end_time >> XO_TO_SEC_SHIFT) - xo_sys_time_in_sec < 256) {
    13fe:	493f      	ldr	r1, [pc, #252]	; (14fc <main+0x8b8>)
    1400:	0a98      	lsrs	r0, r3, #10
    1402:	6809      	ldr	r1, [r1, #0]
    1404:	1a41      	subs	r1, r0, r1
    1406:	29ff      	cmp	r1, #255	; 0xff
    1408:	d803      	bhi.n	1412 <main+0x7ce>
        lnt_snt_mplier++;
    140a:	493d      	ldr	r1, [pc, #244]	; (1500 <main+0x8bc>)
    140c:	7808      	ldrb	r0, [r1, #0]
    140e:	3001      	adds	r0, #1
    1410:	7008      	strb	r0, [r1, #0]
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    1412:	6811      	ldr	r1, [r2, #0]
    1414:	20e4      	movs	r0, #228	; 0xe4
    1416:	1a59      	subs	r1, r3, r1
    1418:	f7fe feb6 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE4, lnt_snt_mplier);
    141c:	4b38      	ldr	r3, [pc, #224]	; (1500 <main+0x8bc>)
    update_system_time();
    update_lnt_timer();

    pmu_setting_temp_based(0);

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    141e:	4d39      	ldr	r5, [pc, #228]	; (1504 <main+0x8c0>)
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
		&& (projected_end_time >> XO_TO_SEC_SHIFT) - xo_sys_time_in_sec < 256) {
        lnt_snt_mplier++;
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
    1420:	7819      	ldrb	r1, [r3, #0]
    1422:	20e4      	movs	r0, #228	; 0xe4
    1424:	f7fe feb0 	bl	188 <mbus_write_message32>
    }

    update_system_time();
    update_lnt_timer();

    pmu_setting_temp_based(0);
    1428:	2000      	movs	r0, #0
    142a:	f7fe ff7f 	bl	32c <pmu_setting_temp_based>

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    142e:	248c      	movs	r4, #140	; 0x8c
    update_system_time();
    update_lnt_timer();

    pmu_setting_temp_based(0);

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    1430:	6829      	ldr	r1, [r5, #0]
    1432:	20ee      	movs	r0, #238	; 0xee
    1434:	f7fe fea8 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    1438:	6821      	ldr	r1, [r4, #0]
    143a:	20ee      	movs	r0, #238	; 0xee
    143c:	f7fe fea4 	bl	188 <mbus_write_message32>

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
    1440:	682b      	ldr	r3, [r5, #0]
    1442:	07d9      	lsls	r1, r3, #31
    1444:	d564      	bpl.n	1510 <main+0x8cc>
        if(!(*GOC_DATA_IRQ)) {
    1446:	6823      	ldr	r3, [r4, #0]
    1448:	2b00      	cmp	r3, #0
    144a:	d15d      	bne.n	1508 <main+0x8c4>
    144c:	e392      	b.n	1b74 <main+0xf30>
    144e:	46c0      	nop			; (mov r8, r8)
    1450:	00001d90 	.word	0x00001d90
    1454:	00001ca8 	.word	0x00001ca8
    1458:	00ffffff 	.word	0x00ffffff
    145c:	00001cac 	.word	0x00001cac
    1460:	00001c9c 	.word	0x00001c9c
    1464:	00001c88 	.word	0x00001c88
    1468:	fff7ffff 	.word	0xfff7ffff
    146c:	00001cf0 	.word	0x00001cf0
    1470:	00004e20 	.word	0x00004e20
    1474:	00001ce8 	.word	0x00001ce8
    1478:	00001cc4 	.word	0x00001cc4
    147c:	00001cc8 	.word	0x00001cc8
    1480:	00000451 	.word	0x00000451
    1484:	fff003ff 	.word	0xfff003ff
    1488:	00001d0c 	.word	0x00001d0c
    148c:	00001d74 	.word	0x00001d74
    1490:	00001d04 	.word	0x00001d04
    1494:	00001c8c 	.word	0x00001c8c
    1498:	ffffc07f 	.word	0xffffc07f
    149c:	fffe007f 	.word	0xfffe007f
    14a0:	00001da0 	.word	0x00001da0
    14a4:	ffc0ffff 	.word	0xffc0ffff
    14a8:	ffff03ff 	.word	0xffff03ff
    14ac:	00001c84 	.word	0x00001c84
    14b0:	00001fff 	.word	0x00001fff
    14b4:	ffffbfff 	.word	0xffffbfff
    14b8:	00001ccc 	.word	0x00001ccc
    14bc:	fff8ffff 	.word	0xfff8ffff
    14c0:	00001c90 	.word	0x00001c90
    14c4:	fffff03f 	.word	0xfffff03f
    14c8:	fff80fff 	.word	0xfff80fff
    14cc:	007ac800 	.word	0x007ac800
    14d0:	00001cc0 	.word	0x00001cc0
    14d4:	ffffc000 	.word	0xffffc000
    14d8:	ff1fffff 	.word	0xff1fffff
    14dc:	00001002 	.word	0x00001002
    14e0:	00001d7d 	.word	0x00001d7d
    14e4:	00001d06 	.word	0x00001d06
    14e8:	00103800 	.word	0x00103800
    14ec:	0017c7ff 	.word	0x0017c7ff
    14f0:	0017efff 	.word	0x0017efff
    14f4:	00001d80 	.word	0x00001d80
    14f8:	00001d08 	.word	0x00001d08
    14fc:	00001d2c 	.word	0x00001d2c
    1500:	00001cd8 	.word	0x00001cd8
    1504:	a000a008 	.word	0xa000a008
            operation_sleep(); // Need to protect against spurious wakeups
        }
        set_goc_cmd();
    1508:	f7ff fb28 	bl	b5c <set_goc_cmd>
        reset_timers_list();
    150c:	f7ff f904 	bl	718 <reset_timers_list>
    }

    lnt_start_meas = 2;
    1510:	4bce      	ldr	r3, [pc, #824]	; (184c <main+0xc08>)
    1512:	2202      	movs	r2, #2
    1514:	701a      	strb	r2, [r3, #0]
    // // Change Counting Time 
    // lntv1a_r03.TIME_COUNTING = 0x000; // Default : 0x258
    // mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    // delay(MBUS_DELAY*10);
    
    set_halt_until_mbus_trx();
    1516:	f7fe fe31 	bl	17c <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    151a:	2003      	movs	r0, #3
    151c:	2110      	movs	r1, #16
    151e:	2200      	movs	r2, #0
    1520:	2301      	movs	r3, #1
    1522:	f7fe fe61 	bl	1e8 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
    1526:	f7fe fe23 	bl	170 <set_halt_until_mbus_tx>
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    152a:	4bc9      	ldr	r3, [pc, #804]	; (1850 <main+0xc0c>)
    152c:	26a0      	movs	r6, #160	; 0xa0
    152e:	681a      	ldr	r2, [r3, #0]
    1530:	0636      	lsls	r6, r6, #24
    1532:	6833      	ldr	r3, [r6, #0]
    1534:	0612      	lsls	r2, r2, #24
    1536:	4fc7      	ldr	r7, [pc, #796]	; (1854 <main+0xc10>)
    1538:	1c14      	adds	r4, r2, #0
    153a:	2500      	movs	r5, #0
    153c:	431c      	orrs	r4, r3
    153e:	603c      	str	r4, [r7, #0]
    1540:	607d      	str	r5, [r7, #4]
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    1542:	683a      	ldr	r2, [r7, #0]
    1544:	687b      	ldr	r3, [r7, #4]
    1546:	20e0      	movs	r0, #224	; 0xe0
    1548:	1c19      	adds	r1, r3, #0
    154a:	f7fe fe1d 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);
    154e:	683a      	ldr	r2, [r7, #0]
    1550:	687b      	ldr	r3, [r7, #4]
    1552:	20e1      	movs	r0, #225	; 0xe1
    1554:	1c11      	adds	r1, r2, #0
    1556:	f7fe fe17 	bl	188 <mbus_write_message32>

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    155a:	4cbf      	ldr	r4, [pc, #764]	; (1858 <main+0xc14>)
    155c:	2210      	movs	r2, #16
    155e:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1560:	1c29      	adds	r1, r5, #0
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    1562:	4393      	bics	r3, r2
    1564:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    1566:	7823      	ldrb	r3, [r4, #0]
    1568:	2240      	movs	r2, #64	; 0x40
    156a:	4393      	bics	r3, r2
    156c:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    156e:	6822      	ldr	r2, [r4, #0]
    1570:	2003      	movs	r0, #3
    1572:	f7fe fe4a 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1576:	48b9      	ldr	r0, [pc, #740]	; (185c <main+0xc18>)
    1578:	f7fe fd95 	bl	a6 <delay>
    
    // Reset LNT //lntv1a_r00.RESET_AFE = 0x1; // Default : 0x1
    lntv1a_r00.RESETN_DBE = 0x0; // Default : 0x0
    157c:	7823      	ldrb	r3, [r4, #0]
    157e:	2204      	movs	r2, #4
    1580:	4393      	bics	r3, r2
    1582:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1584:	6822      	ldr	r2, [r4, #0]
    1586:	2003      	movs	r0, #3
    1588:	1c29      	adds	r1, r5, #0
    158a:	f7fe fe3e 	bl	20a <mbus_remote_register_write>
    }

    lnt_start_meas = 2;
    lnt_stop();

    operation_temp_run();
    158e:	f7fe ffc1 	bl	514 <operation_temp_run>

inline static void pmu_adc_read_latest() {
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    1592:	1c28      	adds	r0, r5, #0
    1594:	2103      	movs	r1, #3
    1596:	f7fe fe7d 	bl	294 <pmu_reg_write>
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
    159a:	6832      	ldr	r2, [r6, #0]
    159c:	4bb0      	ldr	r3, [pc, #704]	; (1860 <main+0xc1c>)
    lnt_stop();

    operation_temp_run();
    pmu_adc_read_latest();

    mrr_send_enable = 1;
    159e:	2101      	movs	r1, #1
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
    15a0:	801a      	strh	r2, [r3, #0]
    lnt_stop();

    operation_temp_run();
    pmu_adc_read_latest();

    mrr_send_enable = 1;
    15a2:	4ab0      	ldr	r2, [pc, #704]	; (1864 <main+0xc20>)
    15a4:	7011      	strb	r1, [r2, #0]
    if(snt_sys_temp_code < PMU_TEMP_THRESH[1] 
    15a6:	49b0      	ldr	r1, [pc, #704]	; (1868 <main+0xc24>)
    15a8:	6808      	ldr	r0, [r1, #0]
    15aa:	49b0      	ldr	r1, [pc, #704]	; (186c <main+0xc28>)
    15ac:	4288      	cmp	r0, r1
    15ae:	d903      	bls.n	15b8 <main+0x974>
	|| (read_data_batadc & 0xFF) > MRR_VOLT_THRESH) {
    15b0:	881b      	ldrh	r3, [r3, #0]
    15b2:	b2db      	uxtb	r3, r3
    15b4:	2b4f      	cmp	r3, #79	; 0x4f
    15b6:	dd01      	ble.n	15bc <main+0x978>
        mrr_send_enable = 0;
    15b8:	2300      	movs	r3, #0
    15ba:	7013      	strb	r3, [r2, #0]
    }

    sys_run_continuous = 0;
    15bc:	4bac      	ldr	r3, [pc, #688]	; (1870 <main+0xc2c>)
    15be:	2200      	movs	r2, #0
    15c0:	701a      	strb	r2, [r3, #0]
    do {
        if(goc_component == 0x00) {
    15c2:	4bac      	ldr	r3, [pc, #688]	; (1874 <main+0xc30>)
    15c4:	781c      	ldrb	r4, [r3, #0]
    15c6:	2c00      	cmp	r4, #0
    15c8:	d11d      	bne.n	1606 <main+0x9c2>
            if(goc_func_id == 0x01) {
    15ca:	4bab      	ldr	r3, [pc, #684]	; (1878 <main+0xc34>)
    15cc:	781b      	ldrb	r3, [r3, #0]
    15ce:	2b01      	cmp	r3, #1
    15d0:	d10f      	bne.n	15f2 <main+0x9ae>
                if(sys_run_continuous) {
    15d2:	4ca7      	ldr	r4, [pc, #668]	; (1870 <main+0xc2c>)
    15d4:	7823      	ldrb	r3, [r4, #0]
    15d6:	2b00      	cmp	r3, #0
    15d8:	d002      	beq.n	15e0 <main+0x99c>
                    start_xo_cout();
    15da:	f7fe fdbd 	bl	158 <start_xo_cout>
    15de:	e001      	b.n	15e4 <main+0x9a0>
                }
                else {
                    stop_xo_cout();
    15e0:	f7fe fdc0 	bl	164 <stop_xo_cout>
                }
                sys_run_continuous = !sys_run_continuous;
    15e4:	7823      	ldrb	r3, [r4, #0]
    15e6:	425a      	negs	r2, r3
    15e8:	4153      	adcs	r3, r2
    15ea:	7023      	strb	r3, [r4, #0]
                goc_func_id = 0xFF;
    15ec:	22ff      	movs	r2, #255	; 0xff
    15ee:	4ba2      	ldr	r3, [pc, #648]	; (1878 <main+0xc34>)
    15f0:	e1ac      	b.n	194c <main+0xd08>
            }
            else if(goc_func_id == 0x02) {
    15f2:	2b02      	cmp	r3, #2
    15f4:	d000      	beq.n	15f8 <main+0x9b4>
    15f6:	e233      	b.n	1a60 <main+0xe1c>
                // enter time in minutes
                xo_day_time_in_sec = goc_data * 60;
    15f8:	4ba0      	ldr	r3, [pc, #640]	; (187c <main+0xc38>)
    15fa:	223c      	movs	r2, #60	; 0x3c
    15fc:	881b      	ldrh	r3, [r3, #0]
    15fe:	435a      	muls	r2, r3
    1600:	4b9f      	ldr	r3, [pc, #636]	; (1880 <main+0xc3c>)
    1602:	601a      	str	r2, [r3, #0]
    1604:	e22c      	b.n	1a60 <main+0xe1c>
            }
        }
        else if(goc_component == 0x01) {
    1606:	2c01      	cmp	r4, #1
    1608:	d141      	bne.n	168e <main+0xa4a>
	    op_counter++;
    160a:	4f9e      	ldr	r7, [pc, #632]	; (1884 <main+0xc40>)
	    lnt_start_meas = 0;
    160c:	2600      	movs	r6, #0
                // enter time in minutes
                xo_day_time_in_sec = goc_data * 60;
            }
        }
        else if(goc_component == 0x01) {
	    op_counter++;
    160e:	883b      	ldrh	r3, [r7, #0]
    1610:	3301      	adds	r3, #1
    1612:	803b      	strh	r3, [r7, #0]
	    lnt_start_meas = 0;
    1614:	4b8d      	ldr	r3, [pc, #564]	; (184c <main+0xc08>)
    1616:	701e      	strb	r6, [r3, #0]
	    goc_state = 0;
    1618:	4b9b      	ldr	r3, [pc, #620]	; (1888 <main+0xc44>)
    161a:	701e      	strb	r6, [r3, #0]

	    if(mrr_send_enable) {
    161c:	4b91      	ldr	r3, [pc, #580]	; (1864 <main+0xc20>)
    161e:	781b      	ldrb	r3, [r3, #0]
    1620:	42b3      	cmp	r3, r6
    1622:	d031      	beq.n	1688 <main+0xa44>
	        pmu_setting_temp_based(1);
    1624:	1c20      	adds	r0, r4, #0
    1626:	f7fe fe81 	bl	32c <pmu_setting_temp_based>
                reset_radio_data_arr();
    162a:	f7fe fe2b 	bl	284 <reset_radio_data_arr>
                radio_data_arr[0] = snt_sys_temp_code;
    162e:	4b8e      	ldr	r3, [pc, #568]	; (1868 <main+0xc24>)
    1630:	4d96      	ldr	r5, [pc, #600]	; (188c <main+0xc48>)
    1632:	681b      	ldr	r3, [r3, #0]
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    1634:	220f      	movs	r2, #15
	    goc_state = 0;

	    if(mrr_send_enable) {
	        pmu_setting_temp_based(1);
                reset_radio_data_arr();
                radio_data_arr[0] = snt_sys_temp_code;
    1636:	602b      	str	r3, [r5, #0]
                radio_data_arr[1] = read_data_batadc;
    1638:	4b89      	ldr	r3, [pc, #548]	; (1860 <main+0xc1c>)
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    163a:	2140      	movs	r1, #64	; 0x40

	    if(mrr_send_enable) {
	        pmu_setting_temp_based(1);
                reset_radio_data_arr();
                radio_data_arr[0] = snt_sys_temp_code;
                radio_data_arr[1] = read_data_batadc;
    163c:	881b      	ldrh	r3, [r3, #0]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
    163e:	1c30      	adds	r0, r6, #0

	    if(mrr_send_enable) {
	        pmu_setting_temp_based(1);
                reset_radio_data_arr();
                radio_data_arr[0] = snt_sys_temp_code;
                radio_data_arr[1] = read_data_batadc;
    1640:	606b      	str	r3, [r5, #4]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    1642:	883b      	ldrh	r3, [r7, #0]
    1644:	4013      	ands	r3, r2
    1646:	021b      	lsls	r3, r3, #8
    1648:	430b      	orrs	r3, r1
    164a:	60ab      	str	r3, [r5, #8]
                mrr_send_radio_data(0);
    164c:	f7ff f8ea 	bl	824 <mrr_send_radio_data>
	        reset_radio_data_arr();
    1650:	f7fe fe18 	bl	284 <reset_radio_data_arr>
	        update_system_time();
    1654:	f7ff f80e 	bl	674 <update_system_time>
	        radio_data_arr[0] = PMU_RADIO_SETTINGS[pmu_setting_cur_index];
    1658:	4b8d      	ldr	r3, [pc, #564]	; (1890 <main+0xc4c>)
    165a:	4a8e      	ldr	r2, [pc, #568]	; (1894 <main+0xc50>)
    165c:	781b      	ldrb	r3, [r3, #0]
	        radio_data_arr[1] = (pmu_setting_cur_index << 16) | (PMU_RADIO_SAR_SETTINGS[pmu_setting_cur_index]);
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(1);
    165e:	1c20      	adds	r0, r4, #0
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
	        reset_radio_data_arr();
	        update_system_time();
	        radio_data_arr[0] = PMU_RADIO_SETTINGS[pmu_setting_cur_index];
    1660:	0099      	lsls	r1, r3, #2
    1662:	588a      	ldr	r2, [r1, r2]
	        radio_data_arr[1] = (pmu_setting_cur_index << 16) | (PMU_RADIO_SAR_SETTINGS[pmu_setting_cur_index]);
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    1664:	2140      	movs	r1, #64	; 0x40
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
	        reset_radio_data_arr();
	        update_system_time();
	        radio_data_arr[0] = PMU_RADIO_SETTINGS[pmu_setting_cur_index];
    1666:	602a      	str	r2, [r5, #0]
	        radio_data_arr[1] = (pmu_setting_cur_index << 16) | (PMU_RADIO_SAR_SETTINGS[pmu_setting_cur_index]);
    1668:	4a8b      	ldr	r2, [pc, #556]	; (1898 <main+0xc54>)
    166a:	5cd2      	ldrb	r2, [r2, r3]
    166c:	041b      	lsls	r3, r3, #16
    166e:	4313      	orrs	r3, r2
    1670:	606b      	str	r3, [r5, #4]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    1672:	883b      	ldrh	r3, [r7, #0]
    1674:	220f      	movs	r2, #15
    1676:	4013      	ands	r3, r2
    1678:	021b      	lsls	r3, r3, #8
    167a:	430b      	orrs	r3, r1
    167c:	60ab      	str	r3, [r5, #8]
                mrr_send_radio_data(1);
    167e:	f7ff f8d1 	bl	824 <mrr_send_radio_data>
                pmu_setting_temp_based(0);
    1682:	1c30      	adds	r0, r6, #0
    1684:	f7fe fe52 	bl	32c <pmu_setting_temp_based>
	    }

	    set_next_time(START_LNT, 100);
    1688:	2001      	movs	r0, #1
    168a:	2164      	movs	r1, #100	; 0x64
    168c:	e1e6      	b.n	1a5c <main+0xe18>
        }
	else if(goc_component == 0x02) {
    168e:	2c02      	cmp	r4, #2
    1690:	d109      	bne.n	16a6 <main+0xa62>
	    update_system_time();
    1692:	f7fe ffef 	bl	674 <update_system_time>
	    mbus_write_message32(0xC1, xo_sys_time);
    1696:	4b81      	ldr	r3, [pc, #516]	; (189c <main+0xc58>)
    1698:	20c1      	movs	r0, #193	; 0xc1
    169a:	6819      	ldr	r1, [r3, #0]
    169c:	f7fe fd74 	bl	188 <mbus_write_message32>
	    mbus_sleep_all();
    16a0:	f7fe fd9c 	bl	1dc <mbus_sleep_all>
    16a4:	e1dc      	b.n	1a60 <main+0xe1c>
	}
        else if(goc_component == 0x04) {
    16a6:	2c04      	cmp	r4, #4
    16a8:	d000      	beq.n	16ac <main+0xa68>
    16aa:	e1d9      	b.n	1a60 <main+0xe1c>
            if(goc_func_id == 0x01) {
    16ac:	4b72      	ldr	r3, [pc, #456]	; (1878 <main+0xc34>)
    16ae:	781a      	ldrb	r2, [r3, #0]
    16b0:	2a01      	cmp	r2, #1
    16b2:	d000      	beq.n	16b6 <main+0xa72>
    16b4:	e1d4      	b.n	1a60 <main+0xe1c>
		if(goc_state == 0) {
    16b6:	4b74      	ldr	r3, [pc, #464]	; (1888 <main+0xc44>)
    16b8:	7818      	ldrb	r0, [r3, #0]
    16ba:	2800      	cmp	r0, #0
    16bc:	d102      	bne.n	16c4 <main+0xa80>
		    goc_state = 1;
    16be:	701a      	strb	r2, [r3, #0]
		    lnt_start_meas = 1;
    16c0:	4b62      	ldr	r3, [pc, #392]	; (184c <main+0xc08>)
    16c2:	e143      	b.n	194c <main+0xd08>
		}
		else if(goc_state == 1) {
    16c4:	2801      	cmp	r0, #1
    16c6:	d137      	bne.n	1738 <main+0xaf4>
                    goc_state = 2;
    16c8:	2102      	movs	r1, #2
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    16ca:	4c6e      	ldr	r4, [pc, #440]	; (1884 <main+0xc40>)
		if(goc_state == 0) {
		    goc_state = 1;
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
    16cc:	7019      	strb	r1, [r3, #0]
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    16ce:	2300      	movs	r3, #0
    16d0:	8023      	strh	r3, [r4, #0]

                    snt_counter = 2;    // start code with snt storage
    16d2:	4c73      	ldr	r4, [pc, #460]	; (18a0 <main+0xc5c>)
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    16d4:	1c1a      	adds	r2, r3, #0

                    snt_counter = 2;    // start code with snt storage
    16d6:	7021      	strb	r1, [r4, #0]
                    radio_beacon_counter = 0;
    16d8:	4972      	ldr	r1, [pc, #456]	; (18a4 <main+0xc60>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
    16da:	4c73      	ldr	r4, [pc, #460]	; (18a8 <main+0xc64>)
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;

                    snt_counter = 2;    // start code with snt storage
                    radio_beacon_counter = 0;
    16dc:	700b      	strb	r3, [r1, #0]
                    radio_counter = 0;
    16de:	4973      	ldr	r1, [pc, #460]	; (18ac <main+0xc68>)
    16e0:	700b      	strb	r3, [r1, #0]

                    mem_light_addr = 0;
    16e2:	4973      	ldr	r1, [pc, #460]	; (18b0 <main+0xc6c>)
    16e4:	800b      	strh	r3, [r1, #0]
                    mem_light_len = 0;
    16e6:	4973      	ldr	r1, [pc, #460]	; (18b4 <main+0xc70>)
    16e8:	800b      	strh	r3, [r1, #0]
                    mem_temp_addr = 7000;
    16ea:	4973      	ldr	r1, [pc, #460]	; (18b8 <main+0xc74>)
    16ec:	800c      	strh	r4, [r1, #0]
                    mem_temp_len = 0;
    16ee:	4973      	ldr	r1, [pc, #460]	; (18bc <main+0xc78>)

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    16f0:	4c63      	ldr	r4, [pc, #396]	; (1880 <main+0xc3c>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;
    16f2:	800b      	strh	r3, [r1, #0]

		    lnt_start_meas = 0;
    16f4:	4955      	ldr	r1, [pc, #340]	; (184c <main+0xc08>)
    16f6:	700b      	strb	r3, [r1, #0]

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    16f8:	4971      	ldr	r1, [pc, #452]	; (18c0 <main+0xc7c>)
    16fa:	680e      	ldr	r6, [r1, #0]
    16fc:	6825      	ldr	r5, [r4, #0]
    16fe:	1b75      	subs	r5, r6, r5
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
    1700:	4e5e      	ldr	r6, [pc, #376]	; (187c <main+0xc38>)
    1702:	8837      	ldrh	r7, [r6, #0]
    1704:	26e1      	movs	r6, #225	; 0xe1
    1706:	0136      	lsls	r6, r6, #4
    1708:	437e      	muls	r6, r7
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    170a:	19ae      	adds	r6, r5, r6
    170c:	4d6d      	ldr	r5, [pc, #436]	; (18c4 <main+0xc80>)
    170e:	602e      	str	r6, [r5, #0]
                    xot_timer_list[START_LNT] = 0;
    1710:	606b      	str	r3, [r5, #4]
		    xo_is_day = 0;
    1712:	4b6d      	ldr	r3, [pc, #436]	; (18c8 <main+0xc84>)
    1714:	701a      	strb	r2, [r3, #0]
		    xo_last_is_day = 0;
    1716:	4b6d      	ldr	r3, [pc, #436]	; (18cc <main+0xc88>)
    1718:	701a      	strb	r2, [r3, #0]

                    radio_data_arr[0] = xo_day_time_in_sec;
    171a:	6822      	ldr	r2, [r4, #0]
    171c:	4b5b      	ldr	r3, [pc, #364]	; (188c <main+0xc48>)
    171e:	601a      	str	r2, [r3, #0]
                    radio_data_arr[1] = xo_sys_time_in_sec;
    1720:	680a      	ldr	r2, [r1, #0]
    1722:	605a      	str	r2, [r3, #4]
                    radio_data_arr[2] = 0xDEAD;
    1724:	4a6a      	ldr	r2, [pc, #424]	; (18d0 <main+0xc8c>)
    1726:	609a      	str	r2, [r3, #8]
		    if(mrr_send_enable) {
    1728:	4b4e      	ldr	r3, [pc, #312]	; (1864 <main+0xc20>)
    172a:	781b      	ldrb	r3, [r3, #0]
    172c:	2b00      	cmp	r3, #0
    172e:	d100      	bne.n	1732 <main+0xaee>
    1730:	e196      	b.n	1a60 <main+0xe1c>
                        mrr_send_radio_data(1);
    1732:	f7ff f877 	bl	824 <mrr_send_radio_data>
    1736:	e193      	b.n	1a60 <main+0xe1c>
		    }
                }

		else if(goc_state == 2) {
    1738:	2802      	cmp	r0, #2
    173a:	d000      	beq.n	173e <main+0xafa>
    173c:	e108      	b.n	1950 <main+0xd0c>
                    if(op_counter >= SNT_OP_MAX_COUNT) {
    173e:	4a51      	ldr	r2, [pc, #324]	; (1884 <main+0xc40>)
    1740:	4c60      	ldr	r4, [pc, #384]	; (18c4 <main+0xc80>)
    1742:	8811      	ldrh	r1, [r2, #0]
    1744:	290c      	cmp	r1, #12
    1746:	d90c      	bls.n	1762 <main+0xb1e>
                        goc_state = 3;
    1748:	2203      	movs	r2, #3
    174a:	701a      	strb	r2, [r3, #0]
			reset_timers_list();
    174c:	f7fe ffe4 	bl	718 <reset_timers_list>
			update_system_time();
    1750:	f7fe ff90 	bl	674 <update_system_time>
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
    1754:	4b5a      	ldr	r3, [pc, #360]	; (18c0 <main+0xc7c>)
    1756:	2296      	movs	r2, #150	; 0x96
    1758:	681b      	ldr	r3, [r3, #0]
    175a:	0092      	lsls	r2, r2, #2
    175c:	189b      	adds	r3, r3, r2
    175e:	60a3      	str	r3, [r4, #8]
    1760:	e17e      	b.n	1a60 <main+0xe1c>
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
    1762:	6823      	ldr	r3, [r4, #0]
    1764:	3301      	adds	r3, #1
    1766:	d124      	bne.n	17b2 <main+0xb6e>
			    op_counter++;
    1768:	8813      	ldrh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    176a:	2000      	movs	r0, #0
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
			    op_counter++;
    176c:	3301      	adds	r3, #1
    176e:	8013      	strh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    1770:	f7fe fddc 	bl	32c <pmu_setting_temp_based>

                            // TODO: compensate XO

                            if(++snt_counter >= 3) {
    1774:	4a4a      	ldr	r2, [pc, #296]	; (18a0 <main+0xc5c>)
    1776:	7813      	ldrb	r3, [r2, #0]
    1778:	3301      	adds	r3, #1
    177a:	b2db      	uxtb	r3, r3
    177c:	7013      	strb	r3, [r2, #0]
    177e:	2b02      	cmp	r3, #2
    1780:	d90d      	bls.n	179e <main+0xb5a>
                                snt_counter = 0;
    1782:	2300      	movs	r3, #0
    1784:	7013      	strb	r3, [r2, #0]
                                // TODO: compress this
                                mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) &snt_sys_temp_code, 0);
    1786:	4c4d      	ldr	r4, [pc, #308]	; (18bc <main+0xc78>)
    1788:	4a4b      	ldr	r2, [pc, #300]	; (18b8 <main+0xc74>)
    178a:	2006      	movs	r0, #6
    178c:	8811      	ldrh	r1, [r2, #0]
    178e:	8822      	ldrh	r2, [r4, #0]
    1790:	1889      	adds	r1, r1, r2
    1792:	4a35      	ldr	r2, [pc, #212]	; (1868 <main+0xc24>)
    1794:	f7fe fd46 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                                mem_temp_len++;
    1798:	8823      	ldrh	r3, [r4, #0]
    179a:	3301      	adds	r3, #1
    179c:	8023      	strh	r3, [r4, #0]
                            }

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
    179e:	4b49      	ldr	r3, [pc, #292]	; (18c4 <main+0xc80>)
    17a0:	20ea      	movs	r0, #234	; 0xea
    17a2:	6819      	ldr	r1, [r3, #0]
    17a4:	f7fe fcf0 	bl	188 <mbus_write_message32>
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
    17a8:	2196      	movs	r1, #150	; 0x96
    17aa:	2000      	movs	r0, #0
    17ac:	0089      	lsls	r1, r1, #2
    17ae:	f7fe ffbf 	bl	730 <set_next_time>
                        }

			xo_is_day = xo_check_is_day();
    17b2:	f7fe ffdd 	bl	770 <xo_check_is_day>
    17b6:	4c44      	ldr	r4, [pc, #272]	; (18c8 <main+0xc84>)

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    17b8:	4b24      	ldr	r3, [pc, #144]	; (184c <main+0xc08>)

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
                        }

			xo_is_day = xo_check_is_day();
    17ba:	7020      	strb	r0, [r4, #0]

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    17bc:	781a      	ldrb	r2, [r3, #0]
    17be:	2a02      	cmp	r2, #2
    17c0:	d000      	beq.n	17c4 <main+0xb80>
    17c2:	e0ae      	b.n	1922 <main+0xcde>
                            lnt_start_meas = 0;
    17c4:	2200      	movs	r2, #0
    17c6:	701a      	strb	r2, [r3, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
    17c8:	4e3a      	ldr	r6, [pc, #232]	; (18b4 <main+0xc70>)
    17ca:	4b39      	ldr	r3, [pc, #228]	; (18b0 <main+0xc6c>)
    17cc:	4d21      	ldr	r5, [pc, #132]	; (1854 <main+0xc10>)
    17ce:	8819      	ldrh	r1, [r3, #0]
    17d0:	8833      	ldrh	r3, [r6, #0]
    17d2:	2006      	movs	r0, #6
    17d4:	18c9      	adds	r1, r1, r3
    17d6:	1c2a      	adds	r2, r5, #0
    17d8:	2301      	movs	r3, #1
    17da:	f7fe fd23 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                            mem_light_len += 2;
    17de:	8833      	ldrh	r3, [r6, #0]
    17e0:	3302      	adds	r3, #2
    17e2:	8033      	strh	r3, [r6, #0]

                            if(xo_is_day) {
    17e4:	7823      	ldrb	r3, [r4, #0]
    17e6:	2b00      	cmp	r3, #0
    17e8:	d100      	bne.n	17ec <main+0xba8>
    17ea:	e0ac      	b.n	1946 <main+0xd02>
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    17ec:	4b39      	ldr	r3, [pc, #228]	; (18d4 <main+0xc90>)
    17ee:	6818      	ldr	r0, [r3, #0]
    17f0:	6859      	ldr	r1, [r3, #4]
    17f2:	682a      	ldr	r2, [r5, #0]
    17f4:	686b      	ldr	r3, [r5, #4]
    17f6:	4299      	cmp	r1, r3
    17f8:	d815      	bhi.n	1826 <main+0xbe2>
    17fa:	d101      	bne.n	1800 <main+0xbbc>
    17fc:	4290      	cmp	r0, r2
    17fe:	d812      	bhi.n	1826 <main+0xbe2>
    1800:	2100      	movs	r1, #0
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    1802:	4835      	ldr	r0, [pc, #212]	; (18d8 <main+0xc94>)
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    1804:	4c13      	ldr	r4, [pc, #76]	; (1854 <main+0xc10>)
    1806:	4d35      	ldr	r5, [pc, #212]	; (18dc <main+0xc98>)
    1808:	1c0e      	adds	r6, r1, #0
    180a:	e06c      	b.n	18e6 <main+0xca2>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    180c:	004f      	lsls	r7, r1, #1

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    180e:	682a      	ldr	r2, [r5, #0]
    1810:	686b      	ldr	r3, [r5, #4]
    1812:	5bbf      	ldrh	r7, [r7, r6]
    1814:	2b00      	cmp	r3, #0
    1816:	d101      	bne.n	181c <main+0xbd8>
    1818:	42ba      	cmp	r2, r7
    181a:	d902      	bls.n	1822 <main+0xbde>
                lnt_cur_level = i + 1;
    181c:	3101      	adds	r1, #1
    181e:	7021      	strb	r1, [r4, #0]
    1820:	e064      	b.n	18ec <main+0xca8>
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
    1822:	3901      	subs	r1, #1
    1824:	e003      	b.n	182e <main+0xbea>
    1826:	482c      	ldr	r0, [pc, #176]	; (18d8 <main+0xc94>)
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    1828:	4d0a      	ldr	r5, [pc, #40]	; (1854 <main+0xc10>)
    182a:	4e2d      	ldr	r6, [pc, #180]	; (18e0 <main+0xc9c>)
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    182c:	2102      	movs	r1, #2
        for(i = 2; i >= lnt_cur_level; i--) {
    182e:	7803      	ldrb	r3, [r0, #0]
    1830:	1c04      	adds	r4, r0, #0
    1832:	4299      	cmp	r1, r3
    1834:	daea      	bge.n	180c <main+0xbc8>
    1836:	e059      	b.n	18ec <main+0xca8>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1838:	004f      	lsls	r7, r1, #1
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    183a:	6822      	ldr	r2, [r4, #0]
    183c:	6863      	ldr	r3, [r4, #4]
    183e:	5b7f      	ldrh	r7, [r7, r5]
    1840:	429e      	cmp	r6, r3
    1842:	d14f      	bne.n	18e4 <main+0xca0>
    1844:	4297      	cmp	r7, r2
    1846:	d94d      	bls.n	18e4 <main+0xca0>
                lnt_cur_level = i;
    1848:	7001      	strb	r1, [r0, #0]
    184a:	e04f      	b.n	18ec <main+0xca8>
    184c:	00001d8c 	.word	0x00001d8c
    1850:	a0000004 	.word	0xa0000004
    1854:	00001d58 	.word	0x00001d58
    1858:	00001c9c 	.word	0x00001c9c
    185c:	00002710 	.word	0x00002710
    1860:	00001d3e 	.word	0x00001d3e
    1864:	00001c98 	.word	0x00001c98
    1868:	00001d40 	.word	0x00001d40
    186c:	00000311 	.word	0x00000311
    1870:	00001d55 	.word	0x00001d55
    1874:	00001d22 	.word	0x00001d22
    1878:	00001d30 	.word	0x00001d30
    187c:	00001d3a 	.word	0x00001d3a
    1880:	00001d78 	.word	0x00001d78
    1884:	00001d84 	.word	0x00001d84
    1888:	00001d60 	.word	0x00001d60
    188c:	00001d44 	.word	0x00001d44
    1890:	00001d8d 	.word	0x00001d8d
    1894:	00001c1c 	.word	0x00001c1c
    1898:	00001c14 	.word	0x00001c14
    189c:	00001d08 	.word	0x00001d08
    18a0:	00001d3c 	.word	0x00001d3c
    18a4:	00001d54 	.word	0x00001d54
    18a8:	00001b58 	.word	0x00001b58
    18ac:	00001d38 	.word	0x00001d38
    18b0:	00001d0e 	.word	0x00001d0e
    18b4:	00001d52 	.word	0x00001d52
    18b8:	00001d50 	.word	0x00001d50
    18bc:	00001d20 	.word	0x00001d20
    18c0:	00001d2c 	.word	0x00001d2c
    18c4:	00001d64 	.word	0x00001d64
    18c8:	00001d31 	.word	0x00001d31
    18cc:	00001d56 	.word	0x00001d56
    18d0:	0000dead 	.word	0x0000dead
    18d4:	00001d18 	.word	0x00001d18
    18d8:	00001d10 	.word	0x00001d10
    18dc:	00001be8 	.word	0x00001be8
    18e0:	00001c54 	.word	0x00001c54
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    18e4:	3101      	adds	r1, #1
    18e6:	7803      	ldrb	r3, [r0, #0]
    18e8:	4299      	cmp	r1, r3
    18ea:	dba5      	blt.n	1838 <main+0xbf4>
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    18ec:	49a2      	ldr	r1, [pc, #648]	; (1b78 <main+0xf34>)
    18ee:	4ba3      	ldr	r3, [pc, #652]	; (1b7c <main+0xf38>)
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    18f0:	4da3      	ldr	r5, [pc, #652]	; (1b80 <main+0xf3c>)
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    18f2:	681a      	ldr	r2, [r3, #0]
    18f4:	685b      	ldr	r3, [r3, #4]
    18f6:	600a      	str	r2, [r1, #0]
    18f8:	604b      	str	r3, [r1, #4]
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    18fa:	782b      	ldrb	r3, [r5, #0]
    18fc:	4ca1      	ldr	r4, [pc, #644]	; (1b84 <main+0xf40>)
    18fe:	005b      	lsls	r3, r3, #1
    1900:	5b19      	ldrh	r1, [r3, r4]
    1902:	20df      	movs	r0, #223	; 0xdf
    1904:	f7fe fc40 	bl	188 <mbus_write_message32>
    return LNT_INTERVAL[lnt_cur_level];
    1908:	782b      	ldrb	r3, [r5, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    190a:	2001      	movs	r0, #1
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    return LNT_INTERVAL[lnt_cur_level];
    190c:	005b      	lsls	r3, r3, #1
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    190e:	5b19      	ldrh	r1, [r3, r4]
    1910:	f7fe ff0e 	bl	730 <set_next_time>
				mbus_write_message32(0xEB, LNT_INTERVAL[lnt_cur_level]);
    1914:	782b      	ldrb	r3, [r5, #0]
    1916:	20eb      	movs	r0, #235	; 0xeb
    1918:	005b      	lsls	r3, r3, #1
    191a:	5b19      	ldrh	r1, [r3, r4]
    191c:	f7fe fc34 	bl	188 <mbus_write_message32>
    1920:	e011      	b.n	1946 <main+0xd02>
                            }
                        }
			else if(xot_timer_list[START_LNT] == 0xFFFFFFFF) {
    1922:	4a99      	ldr	r2, [pc, #612]	; (1b88 <main+0xf44>)
    1924:	6851      	ldr	r1, [r2, #4]
    1926:	3101      	adds	r1, #1
    1928:	d101      	bne.n	192e <main+0xcea>
                            xot_timer_list[START_LNT] = 0;
    192a:	2100      	movs	r1, #0
    192c:	e008      	b.n	1940 <main+0xcfc>
                            lnt_start_meas = 1;
                        }

			else if(!xo_last_is_day && xo_is_day) {
    192e:	4a97      	ldr	r2, [pc, #604]	; (1b8c <main+0xf48>)
    1930:	7812      	ldrb	r2, [r2, #0]
    1932:	2a00      	cmp	r2, #0
    1934:	d107      	bne.n	1946 <main+0xd02>
    1936:	7822      	ldrb	r2, [r4, #0]
    1938:	2a00      	cmp	r2, #0
    193a:	d004      	beq.n	1946 <main+0xd02>
			    // set LNT last timer to SNT current timer for synchronization
			    xot_last_timer_list[START_LNT] = xot_last_timer_list[RUN_SNT];
    193c:	4a94      	ldr	r2, [pc, #592]	; (1b90 <main+0xf4c>)
    193e:	6811      	ldr	r1, [r2, #0]
    1940:	6051      	str	r1, [r2, #4]
			    lnt_start_meas = 1;
    1942:	2201      	movs	r2, #1
    1944:	701a      	strb	r2, [r3, #0]
			}

			xo_last_is_day = xo_is_day;
    1946:	4b93      	ldr	r3, [pc, #588]	; (1b94 <main+0xf50>)
    1948:	781a      	ldrb	r2, [r3, #0]
    194a:	4b90      	ldr	r3, [pc, #576]	; (1b8c <main+0xf48>)
    194c:	701a      	strb	r2, [r3, #0]
    194e:	e087      	b.n	1a60 <main+0xe1c>
                    }
                }

		else if(goc_state == 3) {
    1950:	2803      	cmp	r0, #3
    1952:	d000      	beq.n	1956 <main+0xd12>
    1954:	e084      	b.n	1a60 <main+0xe1c>
                    // SEND RADIO
                    if(xot_timer_list[SEND_RAD] == 0xFFFFFFFF) {
    1956:	4b8c      	ldr	r3, [pc, #560]	; (1b88 <main+0xf44>)
    1958:	689b      	ldr	r3, [r3, #8]
    195a:	3301      	adds	r3, #1
    195c:	d000      	beq.n	1960 <main+0xd1c>
    195e:	e07a      	b.n	1a56 <main+0xe12>

			pmu_setting_temp_based(1);
    1960:	2001      	movs	r0, #1
    1962:	f7fe fce3 	bl	32c <pmu_setting_temp_based>

                        if(mrr_send_enable && xo_check_is_day()) {
    1966:	4b8c      	ldr	r3, [pc, #560]	; (1b98 <main+0xf54>)
    1968:	781b      	ldrb	r3, [r3, #0]
    196a:	2b00      	cmp	r3, #0
    196c:	d073      	beq.n	1a56 <main+0xe12>
    196e:	f7fe feff 	bl	770 <xo_check_is_day>
    1972:	2800      	cmp	r0, #0
    1974:	d06f      	beq.n	1a56 <main+0xe12>
                            // send beacon
                            reset_radio_data_arr();
    1976:	f7fe fc85 	bl	284 <reset_radio_data_arr>
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    197a:	4a88      	ldr	r2, [pc, #544]	; (1b9c <main+0xf58>)
    197c:	4b88      	ldr	r3, [pc, #544]	; (1ba0 <main+0xf5c>)
                            radio_data_arr[1] = snt_sys_temp_code;

                            mrr_send_radio_data(0);
    197e:	2000      	movs	r0, #0
			pmu_setting_temp_based(1);

                        if(mrr_send_enable && xo_check_is_day()) {
                            // send beacon
                            reset_radio_data_arr();
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    1980:	781b      	ldrb	r3, [r3, #0]
    1982:	8811      	ldrh	r1, [r2, #0]
    1984:	22dd      	movs	r2, #221	; 0xdd
    1986:	0612      	lsls	r2, r2, #24
    1988:	430a      	orrs	r2, r1
    198a:	041b      	lsls	r3, r3, #16
    198c:	431a      	orrs	r2, r3
    198e:	4b85      	ldr	r3, [pc, #532]	; (1ba4 <main+0xf60>)
    1990:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = snt_sys_temp_code;
    1992:	4a85      	ldr	r2, [pc, #532]	; (1ba8 <main+0xf64>)
    1994:	6812      	ldr	r2, [r2, #0]
    1996:	605a      	str	r2, [r3, #4]

                            mrr_send_radio_data(0);
    1998:	f7fe ff44 	bl	824 <mrr_send_radio_data>

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
    199c:	4b83      	ldr	r3, [pc, #524]	; (1bac <main+0xf68>)
    199e:	781a      	ldrb	r2, [r3, #0]
    19a0:	3201      	adds	r2, #1
    19a2:	b2d2      	uxtb	r2, r2
    19a4:	701a      	strb	r2, [r3, #0]
    19a6:	2a05      	cmp	r2, #5
    19a8:	d80f      	bhi.n	19ca <main+0xd86>
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    19aa:	4c7d      	ldr	r4, [pc, #500]	; (1ba0 <main+0xf5c>)
    19ac:	4b7d      	ldr	r3, [pc, #500]	; (1ba4 <main+0xf60>)
    19ae:	7822      	ldrb	r2, [r4, #0]
                            radio_data_arr[1] = radio_beacon_counter;
                            radio_data_arr[2] = 0xFEED;

                            mrr_send_radio_data(1);
    19b0:	2001      	movs	r0, #1
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    19b2:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = radio_beacon_counter;
    19b4:	4a7d      	ldr	r2, [pc, #500]	; (1bac <main+0xf68>)
    19b6:	7812      	ldrb	r2, [r2, #0]
    19b8:	605a      	str	r2, [r3, #4]
                            radio_data_arr[2] = 0xFEED;
    19ba:	4a7d      	ldr	r2, [pc, #500]	; (1bb0 <main+0xf6c>)
    19bc:	609a      	str	r2, [r3, #8]

                            mrr_send_radio_data(1);
    19be:	f7fe ff31 	bl	824 <mrr_send_radio_data>

                            radio_counter++;
    19c2:	7823      	ldrb	r3, [r4, #0]
    19c4:	3301      	adds	r3, #1
    19c6:	7023      	strb	r3, [r4, #0]
    19c8:	e045      	b.n	1a56 <main+0xe12>

                            mrr_send_radio_data(0);

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
    19ca:	2400      	movs	r4, #0
    19cc:	701c      	strb	r4, [r3, #0]
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
    19ce:	4b79      	ldr	r3, [pc, #484]	; (1bb4 <main+0xf70>)
    19d0:	20b0      	movs	r0, #176	; 0xb0
    19d2:	8819      	ldrh	r1, [r3, #0]
    19d4:	f7fe fbd8 	bl	188 <mbus_write_message32>
                                for(i = 0; i < mem_light_len; i += 2) {
    19d8:	e016      	b.n	1a08 <main+0xdc4>
                                    reset_radio_data_arr();
    19da:	f7fe fc53 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    19de:	f7fe fbcd 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
    19e2:	4b75      	ldr	r3, [pc, #468]	; (1bb8 <main+0xf74>)
    19e4:	4d6f      	ldr	r5, [pc, #444]	; (1ba4 <main+0xf60>)
    19e6:	8819      	ldrh	r1, [r3, #0]
    19e8:	2201      	movs	r2, #1
    19ea:	1909      	adds	r1, r1, r4
    19ec:	9200      	str	r2, [sp, #0]
    19ee:	2006      	movs	r0, #6
    19f0:	1c2b      	adds	r3, r5, #0
    19f2:	f7fe fc31 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    19f6:	f7fe fbbb 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    19fa:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    19fc:	2000      	movs	r0, #0
                                for(i = 0; i < mem_light_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    19fe:	b29b      	uxth	r3, r3
    1a00:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1a02:	f7fe ff0f 	bl	824 <mrr_send_radio_data>
                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
                                for(i = 0; i < mem_light_len; i += 2) {
    1a06:	3402      	adds	r4, #2
    1a08:	4b6a      	ldr	r3, [pc, #424]	; (1bb4 <main+0xf70>)
    1a0a:	881b      	ldrh	r3, [r3, #0]
    1a0c:	429c      	cmp	r4, r3
    1a0e:	dbe4      	blt.n	19da <main+0xd96>
				    radio_data_arr[2] &= 0x0000FFFF;

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
    1a10:	4b6a      	ldr	r3, [pc, #424]	; (1bbc <main+0xf78>)
    1a12:	20b1      	movs	r0, #177	; 0xb1
    1a14:	8819      	ldrh	r1, [r3, #0]
    1a16:	f7fe fbb7 	bl	188 <mbus_write_message32>
				for(i = 0; i < mem_temp_len; i += 2) {
    1a1a:	2400      	movs	r4, #0
    1a1c:	e016      	b.n	1a4c <main+0xe08>
                                    reset_radio_data_arr();
    1a1e:	f7fe fc31 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    1a22:	f7fe fbab 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
    1a26:	4b66      	ldr	r3, [pc, #408]	; (1bc0 <main+0xf7c>)
    1a28:	4d5e      	ldr	r5, [pc, #376]	; (1ba4 <main+0xf60>)
    1a2a:	8819      	ldrh	r1, [r3, #0]
    1a2c:	2201      	movs	r2, #1
    1a2e:	1909      	adds	r1, r1, r4
    1a30:	9200      	str	r2, [sp, #0]
    1a32:	2006      	movs	r0, #6
    1a34:	1c2b      	adds	r3, r5, #0
    1a36:	f7fe fc0f 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    1a3a:	f7fe fb99 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    1a3e:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1a40:	2000      	movs	r0, #0
				for(i = 0; i < mem_temp_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    1a42:	b29b      	uxth	r3, r3
    1a44:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1a46:	f7fe feed 	bl	824 <mrr_send_radio_data>

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
				for(i = 0; i < mem_temp_len; i += 2) {
    1a4a:	3402      	adds	r4, #2
    1a4c:	4b5b      	ldr	r3, [pc, #364]	; (1bbc <main+0xf78>)
    1a4e:	881b      	ldrh	r3, [r3, #0]
    1a50:	429c      	cmp	r4, r3
    1a52:	dbe4      	blt.n	1a1e <main+0xdda>
    1a54:	e7a9      	b.n	19aa <main+0xd66>

                            radio_counter++;
                        }
		    }

                    set_next_time(SEND_RAD, 600); // FIXME: set to 600
    1a56:	2002      	movs	r0, #2
    1a58:	2196      	movs	r1, #150	; 0x96
    1a5a:	4081      	lsls	r1, r0
    1a5c:	f7fe fe68 	bl	730 <set_next_time>
                }
            }
        }
    } while(sys_run_continuous);
    1a60:	4b58      	ldr	r3, [pc, #352]	; (1bc4 <main+0xf80>)
    1a62:	781c      	ldrb	r4, [r3, #0]
    1a64:	2c00      	cmp	r4, #0
    1a66:	d000      	beq.n	1a6a <main+0xe26>
    1a68:	e5ab      	b.n	15c2 <main+0x97e>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    1a6a:	f7fe fe03 	bl	674 <update_system_time>
    uint8_t i;
    if(lnt_start_meas == 1) {
    1a6e:	4b56      	ldr	r3, [pc, #344]	; (1bc8 <main+0xf84>)
    1a70:	781b      	ldrb	r3, [r3, #0]
    1a72:	2b01      	cmp	r3, #1
    1a74:	d103      	bne.n	1a7e <main+0xe3a>
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    1a76:	4b55      	ldr	r3, [pc, #340]	; (1bcc <main+0xf88>)
    1a78:	681c      	ldr	r4, [r3, #0]
    1a7a:	3432      	adds	r4, #50	; 0x32
    1a7c:	e00e      	b.n	1a9c <main+0xe58>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    1a7e:	1c23      	adds	r3, r4, #0
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1a80:	4a41      	ldr	r2, [pc, #260]	; (1b88 <main+0xf44>)

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    1a82:	2401      	movs	r4, #1
    1a84:	4264      	negs	r4, r4
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1a86:	0099      	lsls	r1, r3, #2
    1a88:	5888      	ldr	r0, [r1, r2]
    1a8a:	2800      	cmp	r0, #0
    1a8c:	d003      	beq.n	1a96 <main+0xe52>
    1a8e:	5888      	ldr	r0, [r1, r2]
    1a90:	42a0      	cmp	r0, r4
    1a92:	d800      	bhi.n	1a96 <main+0xe52>
                min_time = xot_timer_list[i];
    1a94:	588c      	ldr	r4, [r1, r2]
    1a96:	3301      	adds	r3, #1
    uint8_t i;
    if(lnt_start_meas == 1) {
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1a98:	2b03      	cmp	r3, #3
    1a9a:	d1f4      	bne.n	1a86 <main+0xe42>
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    1a9c:	1c63      	adds	r3, r4, #1
    1a9e:	d066      	beq.n	1b6e <main+0xf2a>
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    1aa0:	2001      	movs	r0, #1
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1aa2:	4a39      	ldr	r2, [pc, #228]	; (1b88 <main+0xf44>)
                xot_last_timer_list[i] = xot_timer_list[i];
    1aa4:	493a      	ldr	r1, [pc, #232]	; (1b90 <main+0xf4c>)
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    1aa6:	2500      	movs	r5, #0
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    1aa8:	4240      	negs	r0, r0
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1aaa:	00ab      	lsls	r3, r5, #2
    1aac:	589e      	ldr	r6, [r3, r2]
    1aae:	2e00      	cmp	r6, #0
    1ab0:	d005      	beq.n	1abe <main+0xe7a>
    1ab2:	589e      	ldr	r6, [r3, r2]
    1ab4:	42a6      	cmp	r6, r4
    1ab6:	d802      	bhi.n	1abe <main+0xe7a>
                xot_last_timer_list[i] = xot_timer_list[i];
    1ab8:	589e      	ldr	r6, [r3, r2]
    1aba:	505e      	str	r6, [r3, r1]
                xot_timer_list[i] = 0xFFFFFFFF;
    1abc:	5098      	str	r0, [r3, r2]
    1abe:	3501      	adds	r5, #1
        }
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1ac0:	2d03      	cmp	r5, #3
    1ac2:	d1f2      	bne.n	1aaa <main+0xe66>
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
}

static void set_lnt_timer(uint32_t end_time) {
    mbus_write_message32(0xCE, end_time);
    1ac4:	20ce      	movs	r0, #206	; 0xce
    1ac6:	1c21      	adds	r1, r4, #0
    1ac8:	f7fe fb5e 	bl	188 <mbus_write_message32>
    projected_end_time = end_time << XO_TO_SEC_SHIFT;
    1acc:	4a40      	ldr	r2, [pc, #256]	; (1bd0 <main+0xf8c>)
    1ace:	02a3      	lsls	r3, r4, #10
    1ad0:	6013      	str	r3, [r2, #0]

    if(end_time <= xo_sys_time_in_sec) {
    1ad2:	4a3e      	ldr	r2, [pc, #248]	; (1bcc <main+0xf88>)
    1ad4:	6812      	ldr	r2, [r2, #0]
    1ad6:	4294      	cmp	r4, r2
    1ad8:	d805      	bhi.n	1ae6 <main+0xea2>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
    1ada:	20af      	movs	r0, #175	; 0xaf
    1adc:	2100      	movs	r1, #0
    1ade:	f7fe fb53 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
    1ae2:	f7fe fd03 	bl	4ec <operation_sleep_notimer>

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1ae6:	4a3b      	ldr	r2, [pc, #236]	; (1bd4 <main+0xf90>)
    uint32_t val = temp >> (MPLIER_SHIFT + XO_TO_SEC_SHIFT - 2);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1ae8:	1c28      	adds	r0, r5, #0

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1aea:	6811      	ldr	r1, [r2, #0]
    1aec:	4a3a      	ldr	r2, [pc, #232]	; (1bd8 <main+0xf94>)
    1aee:	1a5b      	subs	r3, r3, r1
    1af0:	7811      	ldrb	r1, [r2, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1af2:	2640      	movs	r6, #64	; 0x40

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1af4:	4359      	muls	r1, r3
    uint32_t val = temp >> (MPLIER_SHIFT + XO_TO_SEC_SHIFT - 2);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    1af6:	4b39      	ldr	r3, [pc, #228]	; (1bdc <main+0xf98>)
    1af8:	0b89      	lsrs	r1, r1, #14
    1afa:	681a      	ldr	r2, [r3, #0]
    1afc:	0e12      	lsrs	r2, r2, #24
    1afe:	0612      	lsls	r2, r2, #24
    1b00:	430a      	orrs	r2, r1
    1b02:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1b04:	681a      	ldr	r2, [r3, #0]
    1b06:	1c29      	adds	r1, r5, #0
    1b08:	f7fe fb7f 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1b0c:	4c34      	ldr	r4, [pc, #208]	; (1be0 <main+0xf9c>)
    1b0e:	2208      	movs	r2, #8
    1b10:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b12:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1b14:	4393      	bics	r3, r2
    1b16:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    1b18:	7823      	ldrb	r3, [r4, #0]
    1b1a:	2204      	movs	r2, #4
    1b1c:	4313      	orrs	r3, r2
    1b1e:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b20:	6822      	ldr	r2, [r4, #0]
    1b22:	1c28      	adds	r0, r5, #0
    1b24:	f7fe fb71 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1b28:	20fa      	movs	r0, #250	; 0xfa
    1b2a:	0080      	lsls	r0, r0, #2
    1b2c:	f7fe fabb 	bl	a6 <delay>
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    1b30:	7823      	ldrb	r3, [r4, #0]
    1b32:	2210      	movs	r2, #16
    1b34:	4313      	orrs	r3, r2
    1b36:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1b38:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1b3a:	2220      	movs	r2, #32
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1b3c:	43b3      	bics	r3, r6
    1b3e:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1b40:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b42:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1b44:	4393      	bics	r3, r2
    1b46:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b48:	6822      	ldr	r2, [r4, #0]
    1b4a:	1c28      	adds	r0, r5, #0
    1b4c:	f7fe fb5d 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1b50:	20fa      	movs	r0, #250	; 0xfa
    1b52:	0080      	lsls	r0, r0, #2
    1b54:	f7fe faa7 	bl	a6 <delay>

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1b58:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b5a:	1c28      	adds	r0, r5, #0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1b5c:	431e      	orrs	r6, r3
    1b5e:	7026      	strb	r6, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b60:	6822      	ldr	r2, [r4, #0]
    1b62:	2100      	movs	r1, #0
    1b64:	f7fe fb51 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1b68:	481e      	ldr	r0, [pc, #120]	; (1be4 <main+0xfa0>)
    1b6a:	f7fe fa9c 	bl	a6 <delay>
	    }
	}
	set_lnt_timer(min_time);
    }

    pmu_setting_temp_based(2);
    1b6e:	2002      	movs	r0, #2
    1b70:	f7fe fbdc 	bl	32c <pmu_setting_temp_based>
    operation_sleep();
    1b74:	f7fe fcaa 	bl	4cc <operation_sleep>
    1b78:	00001d18 	.word	0x00001d18
    1b7c:	00001d58 	.word	0x00001d58
    1b80:	00001d10 	.word	0x00001d10
    1b84:	00001bee 	.word	0x00001bee
    1b88:	00001d64 	.word	0x00001d64
    1b8c:	00001d56 	.word	0x00001d56
    1b90:	00001cf8 	.word	0x00001cf8
    1b94:	00001d31 	.word	0x00001d31
    1b98:	00001c98 	.word	0x00001c98
    1b9c:	00001d3e 	.word	0x00001d3e
    1ba0:	00001d38 	.word	0x00001d38
    1ba4:	00001d44 	.word	0x00001d44
    1ba8:	00001d40 	.word	0x00001d40
    1bac:	00001d54 	.word	0x00001d54
    1bb0:	0000feed 	.word	0x0000feed
    1bb4:	00001d52 	.word	0x00001d52
    1bb8:	00001d0e 	.word	0x00001d0e
    1bbc:	00001d20 	.word	0x00001d20
    1bc0:	00001d50 	.word	0x00001d50
    1bc4:	00001d55 	.word	0x00001d55
    1bc8:	00001d8c 	.word	0x00001d8c
    1bcc:	00001d2c 	.word	0x00001d2c
    1bd0:	00001d80 	.word	0x00001d80
    1bd4:	00001d08 	.word	0x00001d08
    1bd8:	00001cd8 	.word	0x00001cd8
    1bdc:	00001ca8 	.word	0x00001ca8
    1be0:	00001c9c 	.word	0x00001c9c
    1be4:	00002710 	.word	0x00002710
