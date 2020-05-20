
mbc_code_v4_pmu_adjustment_test/mbc_code_v4_pmu_adjustment_test.elf:     file format elf32-littlearm


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
  40:	00000b09 	.word	0x00000b09
  44:	00000000 	.word	0x00000000
  48:	00000b15 	.word	0x00000b15
  4c:	00000b2d 	.word	0x00000b2d
	...
  60:	00000b61 	.word	0x00000b61
  64:	00000b71 	.word	0x00000b71
  68:	00000b81 	.word	0x00000b81
  6c:	00000b91 	.word	0x00000b91
	...
  8c:	00000b4d 	.word	0x00000b4d

00000090 <hang>:
  90:	e7fe      	b.n	90 <hang>
	...

000000a0 <_start>:
  a0:	f000 fd7e 	bl	ba0 <main>
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
 290:	00001c9c 	.word	0x00001c9c

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
 3d8:	00001c98 	.word	0x00001c98
 3dc:	00001bb8 	.word	0x00001bb8
 3e0:	00001ce5 	.word	0x00001ce5
 3e4:	00001b54 	.word	0x00001b54
 3e8:	00001bd7 	.word	0x00001bd7
 3ec:	00001b94 	.word	0x00001b94
 3f0:	00001bd0 	.word	0x00001bd0
 3f4:	00001b78 	.word	0x00001b78
 3f8:	00001b70 	.word	0x00001b70

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
 4b0:	00001c4c 	.word	0x00001c4c
 4b4:	00001be4 	.word	0x00001be4
 4b8:	ffefffff 	.word	0xffefffff
 4bc:	00001c1c 	.word	0x00001c1c
 4c0:	00001c48 	.word	0x00001c48
 4c4:	00001cd5 	.word	0x00001cd5
 4c8:	00001c5e 	.word	0x00001c5e

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
 4e8:	00001cd5 	.word	0x00001cd5

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
 65c:	00001c80 	.word	0x00001c80
 660:	00001c2c 	.word	0x00001c2c
 664:	00001c30 	.word	0x00001c30
 668:	00001cd4 	.word	0x00001cd4
 66c:	a0001100 	.word	0xa0001100
 670:	00001c98 	.word	0x00001c98

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
 6f8:	00001c84 	.word	0x00001c84
 6fc:	00001c7c 	.word	0x00001c7c
 700:	deadbee1 	.word	0xdeadbee1
 704:	a0000004 	.word	0xa0000004
 708:	00001c60 	.word	0x00001c60
 70c:	00001cd0 	.word	0x00001cd0
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
 72c:	00001cbc 	.word	0x00001cbc

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
 764:	00001c50 	.word	0x00001c50
 768:	00001cbc 	.word	0x00001cbc
 76c:	00001c84 	.word	0x00001c84

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
 790:	00001cd0 	.word	0x00001cd0
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
 810:	00001c9c 	.word	0x00001c9c
 814:	0000ffff 	.word	0x0000ffff
 818:	00003ffd 	.word	0x00003ffd
 81c:	ffffc002 	.word	0xffffc002
 820:	00001cf4 	.word	0x00001cf4

Disassembly of section .text.mrr_send_radio_data:

00000824 <mrr_send_radio_data>:

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 824:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    // MRR REG_D: DATA[23:0]
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

    if(!mrr_send_enable) {
 826:	4b98      	ldr	r3, [pc, #608]	; (a88 <mrr_send_radio_data+0x264>)

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 828:	9001      	str	r0, [sp, #4]
    // MRR REG_D: DATA[23:0]
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

    if(!mrr_send_enable) {
 82a:	781b      	ldrb	r3, [r3, #0]
 82c:	2b00      	cmp	r3, #0
 82e:	d100      	bne.n	832 <mrr_send_radio_data+0xe>
 830:	e128      	b.n	a84 <mrr_send_radio_data+0x260>
        return;
    }
	    
#ifndef USE_RAD
    mbus_write_message32(0xAA, 0xAAAAAAAA);
 832:	4996      	ldr	r1, [pc, #600]	; (a8c <mrr_send_radio_data+0x268>)
 834:	20aa      	movs	r0, #170	; 0xaa
 836:	f7ff fca7 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xAA, 0x00000000);
 83a:	2100      	movs	r1, #0
 83c:	20aa      	movs	r0, #170	; 0xaa
 83e:	f7ff fca3 	bl	188 <mbus_write_message32>
    
    mbus_write_message32(0xE0, radio_data_arr[0]);
 842:	4c93      	ldr	r4, [pc, #588]	; (a90 <mrr_send_radio_data+0x26c>)
 844:	20e0      	movs	r0, #224	; 0xe0
 846:	6821      	ldr	r1, [r4, #0]
 848:	f7ff fc9e 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE1, radio_data_arr[1]);
 84c:	6861      	ldr	r1, [r4, #4]
 84e:	20e1      	movs	r0, #225	; 0xe1
 850:	f7ff fc9a 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE2, radio_data_arr[2]);
 854:	68a1      	ldr	r1, [r4, #8]
 856:	20e2      	movs	r0, #226	; 0xe2
 858:	f7ff fc96 	bl	188 <mbus_write_message32>
    
    mbus_write_message32(0xAA, 0x00000000);
 85c:	2100      	movs	r1, #0
 85e:	20aa      	movs	r0, #170	; 0xaa
 860:	f7ff fc92 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xAA, 0xAAAAAAAA);
 864:	4989      	ldr	r1, [pc, #548]	; (a8c <mrr_send_radio_data+0x268>)
 866:	20aa      	movs	r0, #170	; 0xaa
 868:	f7ff fc8e 	bl	188 <mbus_write_message32>
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 86c:	f7ff ff96 	bl	79c <crcEnc16>

#ifndef USE_RAD
    mbus_write_message32(0xBB, 0xBBBBBBBB);
 870:	4988      	ldr	r1, [pc, #544]	; (a94 <mrr_send_radio_data+0x270>)
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 872:	1c06      	adds	r6, r0, #0

#ifndef USE_RAD
    mbus_write_message32(0xBB, 0xBBBBBBBB);
 874:	20bb      	movs	r0, #187	; 0xbb
 876:	f7ff fc87 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xBB, 0x00000000);
 87a:	2100      	movs	r1, #0
 87c:	20bb      	movs	r0, #187	; 0xbb
 87e:	f7ff fc83 	bl	188 <mbus_write_message32>
    
    mbus_write_message32(0xE0, crc_data[0]);
 882:	6831      	ldr	r1, [r6, #0]
 884:	20e0      	movs	r0, #224	; 0xe0
 886:	f7ff fc7f 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE1, crc_data[1]);
 88a:	6871      	ldr	r1, [r6, #4]
 88c:	20e1      	movs	r0, #225	; 0xe1
 88e:	f7ff fc7b 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE2, crc_data[2]);
 892:	68b1      	ldr	r1, [r6, #8]
 894:	20e2      	movs	r0, #226	; 0xe2
 896:	f7ff fc77 	bl	188 <mbus_write_message32>
    
    mbus_write_message32(0xBB, 0x00000000);
 89a:	2100      	movs	r1, #0
 89c:	20bb      	movs	r0, #187	; 0xbb
 89e:	f7ff fc73 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xBB, 0xBBBBBBBB);
 8a2:	20bb      	movs	r0, #187	; 0xbb
 8a4:	497b      	ldr	r1, [pc, #492]	; (a94 <mrr_send_radio_data+0x270>)
 8a6:	f7ff fc6f 	bl	188 <mbus_write_message32>
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
 8aa:	4b7b      	ldr	r3, [pc, #492]	; (a98 <mrr_send_radio_data+0x274>)
 8ac:	781f      	ldrb	r7, [r3, #0]
 8ae:	9700      	str	r7, [sp, #0]
 8b0:	2f00      	cmp	r7, #0
 8b2:	d000      	beq.n	8b6 <mrr_send_radio_data+0x92>
 8b4:	e083      	b.n	9be <mrr_send_radio_data+0x19a>

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 8b6:	4d79      	ldr	r5, [pc, #484]	; (a9c <mrr_send_radio_data+0x278>)
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
        radio_on = 1;
 8b8:	2701      	movs	r7, #1
 8ba:	701f      	strb	r7, [r3, #0]

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 8bc:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 8be:	2002      	movs	r0, #2

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 8c0:	43bb      	bics	r3, r7
 8c2:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 8c4:	682a      	ldr	r2, [r5, #0]
 8c6:	9900      	ldr	r1, [sp, #0]
 8c8:	f7ff fc9f 	bl	20a <mbus_remote_register_write>

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 8cc:	4c74      	ldr	r4, [pc, #464]	; (aa0 <mrr_send_radio_data+0x27c>)
 8ce:	4b75      	ldr	r3, [pc, #468]	; (aa4 <mrr_send_radio_data+0x280>)
 8d0:	6822      	ldr	r2, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 8d2:	2002      	movs	r0, #2
    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 8d4:	4013      	ands	r3, r2
 8d6:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 8d8:	6822      	ldr	r2, [r4, #0]
 8da:	2103      	movs	r1, #3
 8dc:	f7ff fc95 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
 8e0:	6822      	ldr	r2, [r4, #0]
 8e2:	2380      	movs	r3, #128	; 0x80
 8e4:	031b      	lsls	r3, r3, #12
 8e6:	4313      	orrs	r3, r2
 8e8:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 8ea:	6822      	ldr	r2, [r4, #0]
 8ec:	2103      	movs	r1, #3
 8ee:	2002      	movs	r0, #2
 8f0:	f7ff fc8b 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 8f4:	2064      	movs	r0, #100	; 0x64
 8f6:	f7ff fbd6 	bl	a6 <delay>

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 8fa:	6822      	ldr	r2, [r4, #0]
 8fc:	4b6a      	ldr	r3, [pc, #424]	; (aa8 <mrr_send_radio_data+0x284>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 8fe:	2002      	movs	r0, #2
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    delay(MBUS_DELAY);

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 900:	4013      	ands	r3, r2
 902:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 904:	6822      	ldr	r2, [r4, #0]
 906:	2103      	movs	r1, #3
 908:	f7ff fc7f 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
 90c:	6822      	ldr	r2, [r4, #0]
 90e:	2380      	movs	r3, #128	; 0x80
 910:	02db      	lsls	r3, r3, #11
 912:	4313      	orrs	r3, r2
 914:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 916:	6822      	ldr	r2, [r4, #0]
 918:	2103      	movs	r1, #3
 91a:	2002      	movs	r0, #2
 91c:	f7ff fc75 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 920:	2064      	movs	r0, #100	; 0x64
 922:	f7ff fbc0 	bl	a6 <delay>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 926:	682b      	ldr	r3, [r5, #0]
 928:	227e      	movs	r2, #126	; 0x7e
 92a:	4393      	bics	r3, r2
 92c:	2420      	movs	r4, #32
 92e:	4323      	orrs	r3, r4
 930:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 932:	682a      	ldr	r2, [r5, #0]
 934:	2002      	movs	r0, #2
 936:	9900      	ldr	r1, [sp, #0]
 938:	f7ff fc67 	bl	20a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 93c:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 93e:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 940:	433b      	orrs	r3, r7
 942:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 944:	682a      	ldr	r2, [r5, #0]
 946:	9900      	ldr	r1, [sp, #0]
 948:	f7ff fc5f 	bl	20a <mbus_remote_register_write>

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 94c:	4d57      	ldr	r5, [pc, #348]	; (aac <mrr_send_radio_data+0x288>)
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 94e:	2104      	movs	r1, #4
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 950:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 952:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 954:	433b      	orrs	r3, r7
 956:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 958:	682a      	ldr	r2, [r5, #0]
 95a:	f7ff fc56 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 95e:	2064      	movs	r0, #100	; 0x64
 960:	f7ff fba1 	bl	a6 <delay>

    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
 964:	682b      	ldr	r3, [r5, #0]
 966:	2208      	movs	r2, #8
 968:	4393      	bics	r3, r2
 96a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 96c:	682a      	ldr	r2, [r5, #0]
 96e:	2104      	movs	r1, #4
 970:	2002      	movs	r0, #2
 972:	f7ff fc4a 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 976:	2064      	movs	r0, #100	; 0x64
 978:	f7ff fb95 	bl	a6 <delay>

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 97c:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 97e:	2104      	movs	r1, #4
    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
    delay(MBUS_DELAY);

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 980:	431c      	orrs	r4, r3
 982:	602c      	str	r4, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 984:	682a      	ldr	r2, [r5, #0]
 986:	2002      	movs	r0, #2
 988:	f7ff fc3f 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 98c:	2064      	movs	r0, #100	; 0x64
 98e:	f7ff fb8a 	bl	a6 <delay>

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
 992:	682b      	ldr	r3, [r5, #0]
 994:	2210      	movs	r2, #16
 996:	4393      	bics	r3, r2
 998:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 99a:	682a      	ldr	r2, [r5, #0]
 99c:	2002      	movs	r0, #2
 99e:	2104      	movs	r1, #4
 9a0:	f7ff fc33 	bl	20a <mbus_remote_register_write>

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 9a4:	4b42      	ldr	r3, [pc, #264]	; (ab0 <mrr_send_radio_data+0x28c>)
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 9a6:	2002      	movs	r0, #2

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 9a8:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 9aa:	2111      	movs	r1, #17

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 9ac:	43ba      	bics	r2, r7
 9ae:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 9b0:	681a      	ldr	r2, [r3, #0]
 9b2:	f7ff fc2a 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*5); // Freq stab
 9b6:	20fa      	movs	r0, #250	; 0xfa
 9b8:	40b8      	lsls	r0, r7
 9ba:	f7ff fb74 	bl	a6 <delay>
    if(!radio_on) {
        radio_on = 1;
	radio_power_on();
    }
    
    mbus_remote_register_write(MRR_ADDR,0xD, radio_data_arr[0] & 0xFFFFFF);
 9be:	4c34      	ldr	r4, [pc, #208]	; (a90 <mrr_send_radio_data+0x26c>)
 9c0:	2002      	movs	r0, #2
 9c2:	6822      	ldr	r2, [r4, #0]
 9c4:	210d      	movs	r1, #13
 9c6:	0212      	lsls	r2, r2, #8
 9c8:	0a12      	lsrs	r2, r2, #8
 9ca:	f7ff fc1e 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xE, (radio_data_arr[1] << 8) | ((radio_data_arr[0] >> 24) & 0xFF));
 9ce:	6863      	ldr	r3, [r4, #4]
 9d0:	6822      	ldr	r2, [r4, #0]
 9d2:	021b      	lsls	r3, r3, #8
 9d4:	0e12      	lsrs	r2, r2, #24
 9d6:	431a      	orrs	r2, r3
 9d8:	2002      	movs	r0, #2
 9da:	210e      	movs	r1, #14
 9dc:	f7ff fc15 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xF, (radio_data_arr[2] << 16) | ((radio_data_arr[1] >> 16) & 0xFFFF));
 9e0:	68a3      	ldr	r3, [r4, #8]
 9e2:	6862      	ldr	r2, [r4, #4]
 9e4:	041b      	lsls	r3, r3, #16
 9e6:	0c12      	lsrs	r2, r2, #16
 9e8:	431a      	orrs	r2, r3
 9ea:	2002      	movs	r0, #2
 9ec:	210f      	movs	r1, #15
 9ee:	f7ff fc0c 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x10, ((crc_data[0] & 0xFFFF) << 8 | (radio_data_arr[2] >> 8) & 0xFF));
 9f2:	68a2      	ldr	r2, [r4, #8]
 9f4:	8833      	ldrh	r3, [r6, #0]
 9f6:	0a12      	lsrs	r2, r2, #8
 9f8:	021b      	lsls	r3, r3, #8
 9fa:	b2d2      	uxtb	r2, r2
 9fc:	431a      	orrs	r2, r3
 9fe:	2002      	movs	r0, #2
 a00:	2110      	movs	r1, #16
 a02:	f7ff fc02 	bl	20a <mbus_remote_register_write>

    if (!radio_ready){
 a06:	4b2b      	ldr	r3, [pc, #172]	; (ab4 <mrr_send_radio_data+0x290>)
 a08:	781d      	ldrb	r5, [r3, #0]
 a0a:	2d00      	cmp	r5, #0
 a0c:	d127      	bne.n	a5e <mrr_send_radio_data+0x23a>
	radio_ready = 1;
 a0e:	2201      	movs	r2, #1
 a10:	701a      	strb	r2, [r3, #0]

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 a12:	4b27      	ldr	r3, [pc, #156]	; (ab0 <mrr_send_radio_data+0x28c>)
 a14:	2402      	movs	r4, #2
 a16:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a18:	2111      	movs	r1, #17

    if (!radio_ready){
	radio_ready = 1;

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 a1a:	4322      	orrs	r2, r4
 a1c:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a1e:	681a      	ldr	r2, [r3, #0]
 a20:	1c20      	adds	r0, r4, #0
 a22:	f7ff fbf2 	bl	20a <mbus_remote_register_write>
	delay(MBUS_DELAY);
 a26:	2064      	movs	r0, #100	; 0x64
 a28:	f7ff fb3d 	bl	a6 <delay>

	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
 a2c:	4b1c      	ldr	r3, [pc, #112]	; (aa0 <mrr_send_radio_data+0x27c>)
 a2e:	2280      	movs	r2, #128	; 0x80
 a30:	6819      	ldr	r1, [r3, #0]
 a32:	0352      	lsls	r2, r2, #13
 a34:	430a      	orrs	r2, r1
 a36:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 a38:	681a      	ldr	r2, [r3, #0]
 a3a:	2103      	movs	r1, #3
 a3c:	1c20      	adds	r0, r4, #0
 a3e:	f7ff fbe4 	bl	20a <mbus_remote_register_write>
	delay(MBUS_DELAY);
 a42:	2064      	movs	r0, #100	; 0x64
 a44:	f7ff fb2f 	bl	a6 <delay>

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 a48:	4b14      	ldr	r3, [pc, #80]	; (a9c <mrr_send_radio_data+0x278>)
 a4a:	217e      	movs	r1, #126	; 0x7e
 a4c:	681a      	ldr	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a4e:	1c20      	adds	r0, r4, #0
	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
	delay(MBUS_DELAY);

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 a50:	438a      	bics	r2, r1
 a52:	4322      	orrs	r2, r4
 a54:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a56:	681a      	ldr	r2, [r3, #0]
 a58:	1c29      	adds	r1, r5, #0
 a5a:	f7ff fbd6 	bl	20a <mbus_remote_register_write>
    }

    radio_packet_count++;
#endif

    if (last_packet){
 a5e:	9a01      	ldr	r2, [sp, #4]
 a60:	2a00      	cmp	r2, #0
 a62:	d005      	beq.n	a70 <mrr_send_radio_data+0x24c>
	radio_ready = 0;
 a64:	4b13      	ldr	r3, [pc, #76]	; (ab4 <mrr_send_radio_data+0x290>)
 a66:	2200      	movs	r2, #0
 a68:	701a      	strb	r2, [r3, #0]
	radio_power_off();
 a6a:	f7ff fcc7 	bl	3fc <radio_power_off>
 a6e:	e009      	b.n	a84 <mrr_send_radio_data+0x260>
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 a70:	4b0f      	ldr	r3, [pc, #60]	; (ab0 <mrr_send_radio_data+0x28c>)
 a72:	2104      	movs	r1, #4
 a74:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a76:	2002      	movs	r0, #2

    if (last_packet){
	radio_ready = 0;
	radio_power_off();
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 a78:	438a      	bics	r2, r1
 a7a:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a7c:	681a      	ldr	r2, [r3, #0]
 a7e:	2111      	movs	r1, #17
 a80:	f7ff fbc3 	bl	20a <mbus_remote_register_write>
    }
}
 a84:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}
 a86:	46c0      	nop			; (mov r8, r8)
 a88:	00001bf4 	.word	0x00001bf4
 a8c:	aaaaaaaa 	.word	0xaaaaaaaa
 a90:	00001c9c 	.word	0x00001c9c
 a94:	bbbbbbbb 	.word	0xbbbbbbbb
 a98:	00001cd5 	.word	0x00001cd5
 a9c:	00001c4c 	.word	0x00001c4c
 aa0:	00001be4 	.word	0x00001be4
 aa4:	fffbffff 	.word	0xfffbffff
 aa8:	fff7ffff 	.word	0xfff7ffff
 aac:	00001c48 	.word	0x00001c48
 ab0:	00001c1c 	.word	0x00001c1c
 ab4:	00001c5e 	.word	0x00001c5e

Disassembly of section .text.set_goc_cmd:

00000ab8 <set_goc_cmd>:

/**********************************************
 * Interrupt handlers
 **********************************************/

void set_goc_cmd() {
 ab8:	b508      	push	{r3, lr}
    goc_component = (*GOC_DATA_IRQ >> 24) & 0xFF;
 aba:	238c      	movs	r3, #140	; 0x8c
 abc:	6819      	ldr	r1, [r3, #0]
 abe:	4a0c      	ldr	r2, [pc, #48]	; (af0 <set_goc_cmd+0x38>)
 ac0:	0e09      	lsrs	r1, r1, #24
 ac2:	7011      	strb	r1, [r2, #0]
    goc_func_id = (*GOC_DATA_IRQ >> 16) & 0xFF;
 ac4:	6819      	ldr	r1, [r3, #0]
 ac6:	4a0b      	ldr	r2, [pc, #44]	; (af4 <set_goc_cmd+0x3c>)
 ac8:	0c09      	lsrs	r1, r1, #16
 aca:	7011      	strb	r1, [r2, #0]
    goc_data = *GOC_DATA_IRQ & 0xFFFF;
 acc:	681a      	ldr	r2, [r3, #0]
 ace:	4b0a      	ldr	r3, [pc, #40]	; (af8 <set_goc_cmd+0x40>)
 ad0:	801a      	strh	r2, [r3, #0]
    goc_state = 0;
 ad2:	4b0a      	ldr	r3, [pc, #40]	; (afc <set_goc_cmd+0x44>)
 ad4:	2200      	movs	r2, #0
 ad6:	701a      	strb	r2, [r3, #0]
    update_system_time();
 ad8:	f7ff fdcc 	bl	674 <update_system_time>
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	xot_last_timer_list[i] = xo_sys_time_in_sec;
 adc:	4a08      	ldr	r2, [pc, #32]	; (b00 <set_goc_cmd+0x48>)
 ade:	4b09      	ldr	r3, [pc, #36]	; (b04 <set_goc_cmd+0x4c>)
 ae0:	6811      	ldr	r1, [r2, #0]
 ae2:	6019      	str	r1, [r3, #0]
 ae4:	6811      	ldr	r1, [r2, #0]
 ae6:	6059      	str	r1, [r3, #4]
 ae8:	6812      	ldr	r2, [r2, #0]
 aea:	609a      	str	r2, [r3, #8]
    }
}
 aec:	bd08      	pop	{r3, pc}
 aee:	46c0      	nop			; (mov r8, r8)
 af0:	00001c7a 	.word	0x00001c7a
 af4:	00001c88 	.word	0x00001c88
 af8:	00001c92 	.word	0x00001c92
 afc:	00001cb8 	.word	0x00001cb8
 b00:	00001c84 	.word	0x00001c84
 b04:	00001c50 	.word	0x00001c50

Disassembly of section .text.handler_ext_int_wakeup:

00000b08 <handler_ext_int_wakeup>:
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
 b08:	4b01      	ldr	r3, [pc, #4]	; (b10 <handler_ext_int_wakeup+0x8>)
 b0a:	2201      	movs	r2, #1
 b0c:	601a      	str	r2, [r3, #0]

}
 b0e:	4770      	bx	lr
 b10:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_gocep:

00000b14 <handler_ext_int_gocep>:

void handler_ext_int_gocep( void ) { // GOCEP
 b14:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
 b16:	4b04      	ldr	r3, [pc, #16]	; (b28 <handler_ext_int_gocep+0x14>)
 b18:	2204      	movs	r2, #4
 b1a:	601a      	str	r2, [r3, #0]
    set_goc_cmd();
 b1c:	f7ff ffcc 	bl	ab8 <set_goc_cmd>
    reset_timers_list();
 b20:	f7ff fdfa 	bl	718 <reset_timers_list>
}
 b24:	bd08      	pop	{r3, pc}
 b26:	46c0      	nop			; (mov r8, r8)
 b28:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_timer32:

00000b2c <handler_ext_int_timer32>:

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
 b2c:	4b04      	ldr	r3, [pc, #16]	; (b40 <handler_ext_int_timer32+0x14>)
 b2e:	2208      	movs	r2, #8
 b30:	601a      	str	r2, [r3, #0]
    *TIMER32_STAT = 0x0;
 b32:	4b04      	ldr	r3, [pc, #16]	; (b44 <handler_ext_int_timer32+0x18>)
 b34:	2200      	movs	r2, #0
 b36:	601a      	str	r2, [r3, #0]
    
    wfi_timeout_flag = 1;
 b38:	4b03      	ldr	r3, [pc, #12]	; (b48 <handler_ext_int_timer32+0x1c>)
 b3a:	2201      	movs	r2, #1
 b3c:	701a      	strb	r2, [r3, #0]
}
 b3e:	4770      	bx	lr
 b40:	e000e280 	.word	0xe000e280
 b44:	a0001110 	.word	0xa0001110
 b48:	00001cd4 	.word	0x00001cd4

Disassembly of section .text.handler_ext_int_xot:

00000b4c <handler_ext_int_xot>:

void handler_ext_int_xot( void ) { // TIMER32
 b4c:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_XOT);
 b4e:	2280      	movs	r2, #128	; 0x80
 b50:	4b02      	ldr	r3, [pc, #8]	; (b5c <handler_ext_int_xot+0x10>)
 b52:	0312      	lsls	r2, r2, #12
 b54:	601a      	str	r2, [r3, #0]
    update_system_time();
 b56:	f7ff fd8d 	bl	674 <update_system_time>
}
 b5a:	bd08      	pop	{r3, pc}
 b5c:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg0:

00000b60 <handler_ext_int_reg0>:

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
 b60:	4b02      	ldr	r3, [pc, #8]	; (b6c <handler_ext_int_reg0+0xc>)
 b62:	2280      	movs	r2, #128	; 0x80
 b64:	0052      	lsls	r2, r2, #1
 b66:	601a      	str	r2, [r3, #0]
}
 b68:	4770      	bx	lr
 b6a:	46c0      	nop			; (mov r8, r8)
 b6c:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg1:

00000b70 <handler_ext_int_reg1>:

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
 b70:	4b02      	ldr	r3, [pc, #8]	; (b7c <handler_ext_int_reg1+0xc>)
 b72:	2280      	movs	r2, #128	; 0x80
 b74:	0092      	lsls	r2, r2, #2
 b76:	601a      	str	r2, [r3, #0]
}
 b78:	4770      	bx	lr
 b7a:	46c0      	nop			; (mov r8, r8)
 b7c:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg2:

00000b80 <handler_ext_int_reg2>:

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
 b80:	4b02      	ldr	r3, [pc, #8]	; (b8c <handler_ext_int_reg2+0xc>)
 b82:	2280      	movs	r2, #128	; 0x80
 b84:	00d2      	lsls	r2, r2, #3
 b86:	601a      	str	r2, [r3, #0]
}
 b88:	4770      	bx	lr
 b8a:	46c0      	nop			; (mov r8, r8)
 b8c:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg3:

00000b90 <handler_ext_int_reg3>:

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
 b90:	4b02      	ldr	r3, [pc, #8]	; (b9c <handler_ext_int_reg3+0xc>)
 b92:	2280      	movs	r2, #128	; 0x80
 b94:	0112      	lsls	r2, r2, #4
 b96:	601a      	str	r2, [r3, #0]
}
 b98:	4770      	bx	lr
 b9a:	46c0      	nop			; (mov r8, r8)
 b9c:	e000e280 	.word	0xe000e280

Disassembly of section .text.startup.main:

00000ba0 <main>:

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
     ba0:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     ba2:	4bfa      	ldr	r3, [pc, #1000]	; (f8c <main+0x3ec>)
     ba4:	4afa      	ldr	r2, [pc, #1000]	; (f90 <main+0x3f0>)
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     ba6:	4cfb      	ldr	r4, [pc, #1004]	; (f94 <main+0x3f4>)
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     ba8:	601a      	str	r2, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     baa:	6823      	ldr	r3, [r4, #0]
     bac:	4dfa      	ldr	r5, [pc, #1000]	; (f98 <main+0x3f8>)
     bae:	42ab      	cmp	r3, r5
     bb0:	d100      	bne.n	bb4 <main+0x14>
     bb2:	e3b9      	b.n	1328 <main+0x788>
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);
     bb4:	2101      	movs	r1, #1
     bb6:	20ba      	movs	r0, #186	; 0xba
     bb8:	f7ff fae6 	bl	188 <mbus_write_message32>

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
     bbc:	4bf7      	ldr	r3, [pc, #988]	; (f9c <main+0x3fc>)
     bbe:	2700      	movs	r7, #0
     bc0:	601f      	str	r7, [r3, #0]
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     bc2:	4bf7      	ldr	r3, [pc, #988]	; (fa0 <main+0x400>)
    config_timer32(0, 0, 0, 0);
     bc4:	1c39      	adds	r1, r7, #0
     bc6:	1c3a      	adds	r2, r7, #0
static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     bc8:	601f      	str	r7, [r3, #0]
    config_timer32(0, 0, 0, 0);
     bca:	1c38      	adds	r0, r7, #0
     bcc:	1c3b      	adds	r3, r7, #0
     bce:	f7ff fa75 	bl	bc <config_timer32>

    // Enumeration
    enumerated = ENUMID;

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     bd2:	2006      	movs	r0, #6
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    config_timer32(0, 0, 0, 0);

    // Enumeration
    enumerated = ENUMID;
     bd4:	6025      	str	r5, [r4, #0]

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     bd6:	f7ff faf7 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     bda:	2064      	movs	r0, #100	; 0x64
     bdc:	f7ff fa63 	bl	a6 <delay>
#endif
#ifdef USE_MRR
    mbus_enumerate(MRR_ADDR);
     be0:	2002      	movs	r0, #2
     be2:	f7ff faf1 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     be6:	2064      	movs	r0, #100	; 0x64
     be8:	f7ff fa5d 	bl	a6 <delay>
#endif
#ifdef USE_LNT
    mbus_enumerate(LNT_ADDR);
     bec:	2003      	movs	r0, #3
     bee:	f7ff faeb 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     bf2:	2064      	movs	r0, #100	; 0x64
     bf4:	f7ff fa57 	bl	a6 <delay>
#endif
#ifdef USE_SNT
    mbus_enumerate(SNT_ADDR);
     bf8:	2004      	movs	r0, #4
     bfa:	f7ff fae5 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     bfe:	2064      	movs	r0, #100	; 0x64
     c00:	f7ff fa51 	bl	a6 <delay>
#endif
#ifdef USE_PMU
    mbus_enumerate(PMU_ADDR);
     c04:	2005      	movs	r0, #5
     c06:	f7ff fadf 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c0a:	2064      	movs	r0, #100	; 0x64
     c0c:	f7ff fa4b 	bl	a6 <delay>
#endif

    // Default CPU halt function
    set_halt_until_mbus_tx();
     c10:	f7ff faae 	bl	170 <set_halt_until_mbus_tx>

    // Global variables
    wfi_timeout_flag = 0;
     c14:	4be3      	ldr	r3, [pc, #908]	; (fa4 <main+0x404>)

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     c16:	2119      	movs	r1, #25

    // Default CPU halt function
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;
     c18:	701f      	strb	r7, [r3, #0]

    xo_sys_time = 0;
     c1a:	4be3      	ldr	r3, [pc, #908]	; (fa8 <main+0x408>)
    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;

    lnt_cur_level = 0;

    pmu_sar_ratio_radio = 0x34;
     c1c:	2234      	movs	r2, #52	; 0x34
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
     c1e:	601f      	str	r7, [r3, #0]
    xo_sys_time_in_sec = 0;
     c20:	4be2      	ldr	r3, [pc, #904]	; (fac <main+0x40c>)

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     c22:	20ba      	movs	r0, #186	; 0xba

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
     c24:	601f      	str	r7, [r3, #0]
    xo_day_time_in_sec = 0;
     c26:	4be2      	ldr	r3, [pc, #904]	; (fb0 <main+0x410>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     c28:	2402      	movs	r4, #2
    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;
     c2a:	601f      	str	r7, [r3, #0]

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     c2c:	4be1      	ldr	r3, [pc, #900]	; (fb4 <main+0x414>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     c2e:	2601      	movs	r6, #1

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     c30:	6019      	str	r1, [r3, #0]
    snt_state = SNT_IDLE;
     c32:	4be1      	ldr	r3, [pc, #900]	; (fb8 <main+0x418>)

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     c34:	2102      	movs	r1, #2
    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;
     c36:	701f      	strb	r7, [r3, #0]

    lnt_cur_level = 0;
     c38:	4be0      	ldr	r3, [pc, #896]	; (fbc <main+0x41c>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     c3a:	4326      	orrs	r6, r4
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;

    lnt_cur_level = 0;
     c3c:	701f      	strb	r7, [r3, #0]

    pmu_sar_ratio_radio = 0x34;
     c3e:	4be0      	ldr	r3, [pc, #896]	; (fc0 <main+0x420>)
     c40:	701a      	strb	r2, [r3, #0]
    pmu_setting_state = PMU_20C;
     c42:	4be0      	ldr	r3, [pc, #896]	; (fc4 <main+0x424>)
     c44:	2203      	movs	r2, #3
     c46:	601a      	str	r2, [r3, #0]

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     c48:	f7ff fa9e 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);
     c4c:	49de      	ldr	r1, [pc, #888]	; (fc8 <main+0x428>)
     c4e:	20ed      	movs	r0, #237	; 0xed
     c50:	f7ff fa9a 	bl	188 <mbus_write_message32>



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     c54:	4bdd      	ldr	r3, [pc, #884]	; (fcc <main+0x42c>)
     c56:	2140      	movs	r1, #64	; 0x40
     c58:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     c5a:	2004      	movs	r0, #4
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     c5c:	438a      	bics	r2, r1
     c5e:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
     c60:	881a      	ldrh	r2, [r3, #0]
     c62:	2180      	movs	r1, #128	; 0x80
     c64:	438a      	bics	r2, r1
     c66:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     c68:	681a      	ldr	r2, [r3, #0]
     c6a:	2101      	movs	r1, #1
     c6c:	f7ff facd 	bl	20a <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     c70:	4bd7      	ldr	r3, [pc, #860]	; (fd0 <main+0x430>)
     c72:	21ff      	movs	r1, #255	; 0xff
     c74:	881a      	ldrh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     c76:	2004      	movs	r0, #4
#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     c78:	400a      	ands	r2, r1
     c7a:	2180      	movs	r1, #128	; 0x80
     c7c:	0149      	lsls	r1, r1, #5
     c7e:	430a      	orrs	r2, r1
     c80:	801a      	strh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     c82:	881a      	ldrh	r2, [r3, #0]
     c84:	21ff      	movs	r1, #255	; 0xff
     c86:	438a      	bics	r2, r1
     c88:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     c8a:	681a      	ldr	r2, [r3, #0]
     c8c:	2107      	movs	r1, #7
     c8e:	f7ff fabc 	bl	20a <mbus_remote_register_write>
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     c92:	22fc      	movs	r2, #252	; 0xfc
     c94:	2380      	movs	r3, #128	; 0x80
     c96:	4316      	orrs	r6, r2
     c98:	021b      	lsls	r3, r3, #8
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     c9a:	4dce      	ldr	r5, [pc, #824]	; (fd4 <main+0x434>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     c9c:	431e      	orrs	r6, r3
     c9e:	2380      	movs	r3, #128	; 0x80
     ca0:	031b      	lsls	r3, r3, #12
     ca2:	431e      	orrs	r6, r3
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     ca4:	782b      	ldrb	r3, [r5, #0]
     ca6:	2240      	movs	r2, #64	; 0x40
     ca8:	4393      	bics	r3, r2
     caa:	702b      	strb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     cac:	2180      	movs	r1, #128	; 0x80
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     cae:	782b      	ldrb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     cb0:	03c9      	lsls	r1, r1, #15
     cb2:	430e      	orrs	r6, r1
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     cb4:	2120      	movs	r1, #32
     cb6:	438b      	bics	r3, r1
     cb8:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     cba:	682a      	ldr	r2, [r5, #0]
     cbc:	2004      	movs	r0, #4
     cbe:	2108      	movs	r1, #8
     cc0:	f7ff faa3 	bl	20a <mbus_remote_register_write>

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     cc4:	4ac4      	ldr	r2, [pc, #784]	; (fd8 <main+0x438>)
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     cc6:	2004      	movs	r0, #4
    sntv4_r08.TMR_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     cc8:	4016      	ands	r6, r2
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     cca:	1c32      	adds	r2, r6, #0
     ccc:	2109      	movs	r1, #9
     cce:	f7ff fa9c 	bl	20a <mbus_remote_register_write>

    sntv4_r08.TMR_EN_OSC = 1;
     cd2:	782b      	ldrb	r3, [r5, #0]
     cd4:	2108      	movs	r1, #8
     cd6:	430b      	orrs	r3, r1
     cd8:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     cda:	682a      	ldr	r2, [r5, #0]
     cdc:	2004      	movs	r0, #4
     cde:	f7ff fa94 	bl	20a <mbus_remote_register_write>
    delay(10000);
     ce2:	48be      	ldr	r0, [pc, #760]	; (fdc <main+0x43c>)
     ce4:	f7ff f9df 	bl	a6 <delay>

    sntv4_r08.TMR_RESETB = 1;
     ce8:	782b      	ldrb	r3, [r5, #0]
     cea:	2210      	movs	r2, #16
     cec:	4313      	orrs	r3, r2
     cee:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DIV = 1;
     cf0:	782b      	ldrb	r3, [r5, #0]
     cf2:	2104      	movs	r1, #4
     cf4:	430b      	orrs	r3, r1
     cf6:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DCDC = 1;
     cf8:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     cfa:	1c08      	adds	r0, r1, #0
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r08.TMR_RESETB = 1;
    sntv4_r08.TMR_RESETB_DIV = 1;
    sntv4_r08.TMR_RESETB_DCDC = 1;
     cfc:	4323      	orrs	r3, r4
     cfe:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d00:	682a      	ldr	r2, [r5, #0]
     d02:	2108      	movs	r1, #8
     d04:	f7ff fa81 	bl	20a <mbus_remote_register_write>
    delay(10000);	// need to wait for clock to stabilize
     d08:	48b4      	ldr	r0, [pc, #720]	; (fdc <main+0x43c>)
     d0a:	f7ff f9cc 	bl	a6 <delay>

    sntv4_r08.TMR_EN_SELF_CLK = 1;
     d0e:	782b      	ldrb	r3, [r5, #0]
     d10:	2201      	movs	r2, #1
     d12:	4313      	orrs	r3, r2
     d14:	702b      	strb	r3, [r5, #0]
    sntv4_r09.TMR_SELF_EN = 1;
     d16:	2380      	movs	r3, #128	; 0x80
     d18:	039b      	lsls	r3, r3, #14
     d1a:	431e      	orrs	r6, r3
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d1c:	682a      	ldr	r2, [r5, #0]
     d1e:	2004      	movs	r0, #4
     d20:	2108      	movs	r1, #8
     d22:	f7ff fa72 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d26:	1c32      	adds	r2, r6, #0
     d28:	2109      	movs	r1, #9
     d2a:	2004      	movs	r0, #4
     d2c:	f7ff fa6d 	bl	20a <mbus_remote_register_write>
    delay(100000);
     d30:	48ab      	ldr	r0, [pc, #684]	; (fe0 <main+0x440>)
     d32:	f7ff f9b8 	bl	a6 <delay>

    sntv4_r08.TMR_EN_OSC = 0;
     d36:	782b      	ldrb	r3, [r5, #0]
     d38:	2108      	movs	r1, #8
     d3a:	438b      	bics	r3, r1
     d3c:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d3e:	682a      	ldr	r2, [r5, #0]
     d40:	2004      	movs	r0, #4
     d42:	f7ff fa62 	bl	20a <mbus_remote_register_write>
    delay(10000);
     d46:	48a5      	ldr	r0, [pc, #660]	; (fdc <main+0x43c>)
     d48:	f7ff f9ad 	bl	a6 <delay>

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     d4c:	4ba5      	ldr	r3, [pc, #660]	; (fe4 <main+0x444>)
    sntv4_r1A.WUP_THRESHOLD = 0;
     d4e:	4da6      	ldr	r5, [pc, #664]	; (fe8 <main+0x448>)

    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     d50:	781a      	ldrb	r2, [r3, #0]
     d52:	701f      	strb	r7, [r3, #0]
    sntv4_r1A.WUP_THRESHOLD = 0;
     d54:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     d56:	2004      	movs	r0, #4
    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
     d58:	0e12      	lsrs	r2, r2, #24
     d5a:	0612      	lsls	r2, r2, #24
     d5c:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     d5e:	681a      	ldr	r2, [r3, #0]
     d60:	2119      	movs	r1, #25
     d62:	f7ff fa52 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);
     d66:	682a      	ldr	r2, [r5, #0]
     d68:	2004      	movs	r0, #4
     d6a:	211a      	movs	r1, #26
     d6c:	f7ff fa4d 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 0;
     d70:	4d9e      	ldr	r5, [pc, #632]	; (fec <main+0x44c>)
     d72:	4b9f      	ldr	r3, [pc, #636]	; (ff0 <main+0x450>)
     d74:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     d76:	2004      	movs	r0, #4
    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);

    sntv4_r17.WUP_ENABLE = 0;
     d78:	4013      	ands	r3, r2
     d7a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     d7c:	682a      	ldr	r2, [r5, #0]
     d7e:	2117      	movs	r1, #23
     d80:	f7ff fa43 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 1;
     d84:	682a      	ldr	r2, [r5, #0]
     d86:	2380      	movs	r3, #128	; 0x80
     d88:	041b      	lsls	r3, r3, #16
     d8a:	4313      	orrs	r3, r2
     d8c:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_CLK_SEL = 0;
     d8e:	682a      	ldr	r2, [r5, #0]
     d90:	4b98      	ldr	r3, [pc, #608]	; (ff4 <main+0x454>)
    sntv4_r17.WUP_LC_IRQ_EN = 0;
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     d92:	2004      	movs	r0, #4

    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
     d94:	4013      	ands	r3, r2
     d96:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     d98:	682a      	ldr	r2, [r5, #0]
     d9a:	4b97      	ldr	r3, [pc, #604]	; (ff8 <main+0x458>)
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     d9c:	2117      	movs	r1, #23
    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     d9e:	4013      	ands	r3, r2
     da0:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_AUTO_RESET = 0;
     da2:	682b      	ldr	r3, [r5, #0]
     da4:	4a8c      	ldr	r2, [pc, #560]	; (fd8 <main+0x438>)
     da6:	4013      	ands	r3, r2
     da8:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     daa:	682a      	ldr	r2, [r5, #0]
     dac:	f7ff fa2d 	bl	20a <mbus_remote_register_write>
    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    snt_clk_init();
    operation_temp_run();
     db0:	f7ff fbb0 	bl	514 <operation_temp_run>

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     db4:	4b91      	ldr	r3, [pc, #580]	; (ffc <main+0x45c>)
     db6:	4992      	ldr	r1, [pc, #584]	; (1000 <main+0x460>)
     db8:	681a      	ldr	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     dba:	2003      	movs	r0, #3

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     dbc:	400a      	ands	r2, r1
     dbe:	2180      	movs	r1, #128	; 0x80
     dc0:	0389      	lsls	r1, r1, #14
     dc2:	430a      	orrs	r2, r1
     dc4:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     dc6:	6819      	ldr	r1, [r3, #0]
     dc8:	4a8e      	ldr	r2, [pc, #568]	; (1004 <main+0x464>)
     dca:	400a      	ands	r2, r1
     dcc:	498e      	ldr	r1, [pc, #568]	; (1008 <main+0x468>)
     dce:	430a      	orrs	r2, r1
     dd0:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     dd2:	681a      	ldr	r2, [r3, #0]
     dd4:	2140      	movs	r1, #64	; 0x40
     dd6:	430a      	orrs	r2, r1
     dd8:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     dda:	681a      	ldr	r2, [r3, #0]
     ddc:	2122      	movs	r1, #34	; 0x22
     dde:	f7ff fa14 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     de2:	20fa      	movs	r0, #250	; 0xfa
     de4:	40a0      	lsls	r0, r4
     de6:	f7ff f95e 	bl	a6 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     dea:	4e88      	ldr	r6, [pc, #544]	; (100c <main+0x46c>)
     dec:	4b88      	ldr	r3, [pc, #544]	; (1010 <main+0x470>)
     dee:	6832      	ldr	r2, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     df0:	21fc      	movs	r1, #252	; 0xfc
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     df2:	4013      	ands	r3, r2
     df4:	2280      	movs	r2, #128	; 0x80
     df6:	0212      	lsls	r2, r2, #8
     df8:	4313      	orrs	r3, r2
     dfa:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     dfc:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     dfe:	2201      	movs	r2, #1
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e00:	430b      	orrs	r3, r1
     e02:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     e04:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e06:	2121      	movs	r1, #33	; 0x21
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     e08:	4323      	orrs	r3, r4
     e0a:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e0c:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e0e:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e10:	4313      	orrs	r3, r2
     e12:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e14:	6832      	ldr	r2, [r6, #0]
     e16:	f7ff f9f8 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e1a:	20fa      	movs	r0, #250	; 0xfa
     e1c:	40a0      	lsls	r0, r4
     e1e:	f7ff f942 	bl	a6 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     e22:	4b7c      	ldr	r3, [pc, #496]	; (1014 <main+0x474>)
     e24:	497c      	ldr	r1, [pc, #496]	; (1018 <main+0x478>)
     e26:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     e28:	2003      	movs	r0, #3
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     e2a:	400a      	ands	r2, r1
     e2c:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     e2e:	681a      	ldr	r2, [r3, #0]
     e30:	2140      	movs	r1, #64	; 0x40
     e32:	f7ff f9ea 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e36:	20fa      	movs	r0, #250	; 0xfa
     e38:	40a0      	lsls	r0, r4
     e3a:	f7ff f934 	bl	a6 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     e3e:	6833      	ldr	r3, [r6, #0]
     e40:	4a65      	ldr	r2, [pc, #404]	; (fd8 <main+0x438>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e42:	2121      	movs	r1, #33	; 0x21
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     e44:	4013      	ands	r3, r2
     e46:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e48:	6832      	ldr	r2, [r6, #0]
     e4a:	2003      	movs	r0, #3
     e4c:	f7ff f9dd 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e50:	20fa      	movs	r0, #250	; 0xfa
     e52:	40a0      	lsls	r0, r4
     e54:	f7ff f927 	bl	a6 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     e58:	4d70      	ldr	r5, [pc, #448]	; (101c <main+0x47c>)
     e5a:	2108      	movs	r1, #8
     e5c:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     e5e:	2003      	movs	r0, #3
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     e60:	430b      	orrs	r3, r1
     e62:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     e64:	682a      	ldr	r2, [r5, #0]
     e66:	2120      	movs	r1, #32
     e68:	f7ff f9cf 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e6c:	20fa      	movs	r0, #250	; 0xfa
     e6e:	40a0      	lsls	r0, r4
     e70:	f7ff f919 	bl	a6 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
     e74:	782b      	ldrb	r3, [r5, #0]
     e76:	2210      	movs	r2, #16
     e78:	4313      	orrs	r3, r2
     e7a:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
     e7c:	782b      	ldrb	r3, [r5, #0]
     e7e:	2104      	movs	r1, #4
     e80:	430b      	orrs	r3, r1
     e82:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     e84:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     e86:	2120      	movs	r1, #32
    delay(MBUS_DELAY*10);
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     e88:	4323      	orrs	r3, r4
     e8a:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     e8c:	682a      	ldr	r2, [r5, #0]
     e8e:	2003      	movs	r0, #3
     e90:	f7ff f9bb 	bl	20a <mbus_remote_register_write>
    delay(2000); 
     e94:	20fa      	movs	r0, #250	; 0xfa
     e96:	00c0      	lsls	r0, r0, #3
     e98:	f7ff f905 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
     e9c:	782b      	ldrb	r3, [r5, #0]
     e9e:	2201      	movs	r2, #1
     ea0:	4313      	orrs	r3, r2
     ea2:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     ea4:	682a      	ldr	r2, [r5, #0]
     ea6:	2120      	movs	r1, #32
     ea8:	2003      	movs	r0, #3
     eaa:	f7ff f9ae 	bl	20a <mbus_remote_register_write>
    delay(10); 
     eae:	200a      	movs	r0, #10
     eb0:	f7ff f8f9 	bl	a6 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
     eb4:	6833      	ldr	r3, [r6, #0]
     eb6:	2180      	movs	r1, #128	; 0x80
     eb8:	0389      	lsls	r1, r1, #14
     eba:	430b      	orrs	r3, r1
     ebc:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ebe:	6832      	ldr	r2, [r6, #0]
     ec0:	2121      	movs	r1, #33	; 0x21
     ec2:	2003      	movs	r0, #3
     ec4:	f7ff f9a1 	bl	20a <mbus_remote_register_write>
    delay(100000); 
     ec8:	4845      	ldr	r0, [pc, #276]	; (fe0 <main+0x440>)
     eca:	f7ff f8ec 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
     ece:	782b      	ldrb	r3, [r5, #0]
     ed0:	2208      	movs	r2, #8
     ed2:	4393      	bics	r3, r2
     ed4:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     ed6:	682a      	ldr	r2, [r5, #0]
     ed8:	2120      	movs	r1, #32
     eda:	2003      	movs	r0, #3
     edc:	f7ff f995 	bl	20a <mbus_remote_register_write>
    delay(100);
     ee0:	2064      	movs	r0, #100	; 0x64
     ee2:	f7ff f8e0 	bl	a6 <delay>
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     ee6:	4b4e      	ldr	r3, [pc, #312]	; (1020 <main+0x480>)
     ee8:	2101      	movs	r1, #1
     eea:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     eec:	2003      	movs	r0, #3
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     eee:	430a      	orrs	r2, r1
     ef0:	701a      	strb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
     ef2:	781a      	ldrb	r2, [r3, #0]
     ef4:	211e      	movs	r1, #30
     ef6:	438a      	bics	r2, r1
     ef8:	2110      	movs	r1, #16
     efa:	430a      	orrs	r2, r1
     efc:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     efe:	681a      	ldr	r2, [r3, #0]
     f00:	2117      	movs	r1, #23
     f02:	f7ff f982 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f06:	20fa      	movs	r0, #250	; 0xfa
     f08:	40a0      	lsls	r0, r4
     f0a:	f7ff f8cc 	bl	a6 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     f0e:	4b45      	ldr	r3, [pc, #276]	; (1024 <main+0x484>)
     f10:	21f0      	movs	r1, #240	; 0xf0
     f12:	881a      	ldrh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     f14:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     f16:	438a      	bics	r2, r1
     f18:	2170      	movs	r1, #112	; 0x70
     f1a:	430a      	orrs	r2, r1
     f1c:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
     f1e:	881a      	ldrh	r2, [r3, #0]
     f20:	210f      	movs	r1, #15
     f22:	438a      	bics	r2, r1
     f24:	4322      	orrs	r2, r4
     f26:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
     f28:	8819      	ldrh	r1, [r3, #0]
     f2a:	2280      	movs	r2, #128	; 0x80
     f2c:	0052      	lsls	r2, r2, #1
     f2e:	430a      	orrs	r2, r1
     f30:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     f32:	681a      	ldr	r2, [r3, #0]
     f34:	2101      	movs	r1, #1
     f36:	f7ff f968 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f3a:	20fa      	movs	r0, #250	; 0xfa
     f3c:	40a0      	lsls	r0, r4
     f3e:	f7ff f8b2 	bl	a6 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     f42:	4b39      	ldr	r3, [pc, #228]	; (1028 <main+0x488>)
     f44:	4a39      	ldr	r2, [pc, #228]	; (102c <main+0x48c>)
     f46:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     f48:	2003      	movs	r0, #3
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    delay(MBUS_DELAY*10);
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     f4a:	400a      	ands	r2, r1
     f4c:	2180      	movs	r1, #128	; 0x80
     f4e:	430a      	orrs	r2, r1
     f50:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     f52:	681a      	ldr	r2, [r3, #0]
     f54:	1c21      	adds	r1, r4, #0
     f56:	f7ff f958 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f5a:	20fa      	movs	r0, #250	; 0xfa
     f5c:	40a0      	lsls	r0, r4
     f5e:	f7ff f8a2 	bl	a6 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     f62:	4b33      	ldr	r3, [pc, #204]	; (1030 <main+0x490>)
     f64:	4a33      	ldr	r2, [pc, #204]	; (1034 <main+0x494>)
     f66:	6819      	ldr	r1, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     f68:	2003      	movs	r0, #3
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    delay(MBUS_DELAY*10);
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     f6a:	400a      	ands	r2, r1
     f6c:	21c0      	movs	r1, #192	; 0xc0
     f6e:	0289      	lsls	r1, r1, #10
     f70:	430a      	orrs	r2, r1
     f72:	601a      	str	r2, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
     f74:	681a      	ldr	r2, [r3, #0]
     f76:	2110      	movs	r1, #16
     f78:	0b12      	lsrs	r2, r2, #12
     f7a:	0312      	lsls	r2, r2, #12
     f7c:	430a      	orrs	r2, r1
     f7e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     f80:	681a      	ldr	r2, [r3, #0]
     f82:	2105      	movs	r1, #5
     f84:	f7ff f941 	bl	20a <mbus_remote_register_write>
     f88:	e056      	b.n	1038 <main+0x498>
     f8a:	46c0      	nop			; (mov r8, r8)
     f8c:	e000e100 	.word	0xe000e100
     f90:	00080f0d 	.word	0x00080f0d
     f94:	00001c7c 	.word	0x00001c7c
     f98:	deadbee1 	.word	0xdeadbee1
     f9c:	a0001200 	.word	0xa0001200
     fa0:	a000007c 	.word	0xa000007c
     fa4:	00001cd4 	.word	0x00001cd4
     fa8:	00001c60 	.word	0x00001c60
     fac:	00001c84 	.word	0x00001c84
     fb0:	00001cd0 	.word	0x00001cd0
     fb4:	00001c98 	.word	0x00001c98
     fb8:	00001c80 	.word	0x00001c80
     fbc:	00001c68 	.word	0x00001c68
     fc0:	00001c8a 	.word	0x00001c8a
     fc4:	00001c8c 	.word	0x00001c8c
     fc8:	0d0a0f0f 	.word	0x0d0a0f0f
     fcc:	00001c30 	.word	0x00001c30
     fd0:	00001c3c 	.word	0x00001c3c
     fd4:	00001c40 	.word	0x00001c40
     fd8:	ffdfffff 	.word	0xffdfffff
     fdc:	00002710 	.word	0x00002710
     fe0:	000186a0 	.word	0x000186a0
     fe4:	00001cf0 	.word	0x00001cf0
     fe8:	00001c38 	.word	0x00001c38
     fec:	00001bf0 	.word	0x00001bf0
     ff0:	ff7fffff 	.word	0xff7fffff
     ff4:	ffefffff 	.word	0xffefffff
     ff8:	ffbfffff 	.word	0xffbfffff
     ffc:	00001c14 	.word	0x00001c14
    1000:	ff1fffff 	.word	0xff1fffff
    1004:	ffe0007f 	.word	0xffe0007f
    1008:	001ffe80 	.word	0x001ffe80
    100c:	00001c10 	.word	0x00001c10
    1010:	ffff00ff 	.word	0xffff00ff
    1014:	00001c18 	.word	0x00001c18
    1018:	fff7ffff 	.word	0xfff7ffff
    101c:	00001cec 	.word	0x00001cec
    1020:	00001ce0 	.word	0x00001ce0
    1024:	00001bfc 	.word	0x00001bfc
    1028:	00001c00 	.word	0x00001c00
    102c:	fffffe7f 	.word	0xfffffe7f
    1030:	00001c0c 	.word	0x00001c0c
    1034:	ff000fff 	.word	0xff000fff
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    1038:	4bdc      	ldr	r3, [pc, #880]	; (13ac <main+0x80c>)
    103a:	2101      	movs	r1, #1
    103c:	781a      	ldrb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    103e:	2003      	movs	r0, #3
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    1040:	438a      	bics	r2, r1
    1042:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    1044:	681a      	ldr	r2, [r3, #0]
    1046:	2106      	movs	r1, #6
    1048:	f7ff f8df 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    104c:	20fa      	movs	r0, #250	; 0xfa
    104e:	40a0      	lsls	r0, r4
    1050:	f7ff f829 	bl	a6 <delay>
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    1054:	4bd6      	ldr	r3, [pc, #856]	; (13b0 <main+0x810>)
    1056:	49d7      	ldr	r1, [pc, #860]	; (13b4 <main+0x814>)
    1058:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    105a:	2003      	movs	r0, #3
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    105c:	430a      	orrs	r2, r1
    105e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    1060:	681a      	ldr	r2, [r3, #0]
    1062:	1c01      	adds	r1, r0, #0
    1064:	f7ff f8d1 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1068:	20fa      	movs	r0, #250	; 0xfa
    106a:	40a0      	lsls	r0, r4
    106c:	f7ff f81b 	bl	a6 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    1070:	4bd1      	ldr	r3, [pc, #836]	; (13b8 <main+0x818>)
    1072:	210a      	movs	r1, #10
    1074:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    1076:	2003      	movs	r0, #3
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    1078:	0b12      	lsrs	r2, r2, #12
    107a:	0312      	lsls	r2, r2, #12
    107c:	430a      	orrs	r2, r1
    107e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    1080:	681a      	ldr	r2, [r3, #0]
    1082:	2104      	movs	r1, #4
    1084:	f7ff f8c1 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1088:	20fa      	movs	r0, #250	; 0xfa
    108a:	40a0      	lsls	r0, r4
    108c:	f7ff f80b 	bl	a6 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    1090:	4dca      	ldr	r5, [pc, #808]	; (13bc <main+0x81c>)
    1092:	2201      	movs	r2, #1
    1094:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1096:	1c39      	adds	r1, r7, #0
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    1098:	4393      	bics	r3, r2
    109a:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    109c:	682a      	ldr	r2, [r5, #0]
    109e:	2003      	movs	r0, #3
    10a0:	f7ff f8b3 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10a4:	20fa      	movs	r0, #250	; 0xfa
    10a6:	40a0      	lsls	r0, r4
    10a8:	f7fe fffd 	bl	a6 <delay>
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    10ac:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    10ae:	1c39      	adds	r1, r7, #0
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    10b0:	43a3      	bics	r3, r4
    10b2:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    10b4:	682a      	ldr	r2, [r5, #0]
    10b6:	2003      	movs	r0, #3
    10b8:	f7ff f8a7 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10bc:	20fa      	movs	r0, #250	; 0xfa
    10be:	40a0      	lsls	r0, r4
    10c0:	f7fe fff1 	bl	a6 <delay>

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    10c4:	4dbe      	ldr	r5, [pc, #760]	; (13c0 <main+0x820>)
    10c6:	49bf      	ldr	r1, [pc, #764]	; (13c4 <main+0x824>)
    10c8:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    10ca:	1c20      	adds	r0, r4, #0

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    10cc:	400b      	ands	r3, r1
    10ce:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    10d0:	682a      	ldr	r2, [r5, #0]
    10d2:	2103      	movs	r1, #3
    10d4:	f7ff f899 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    10d8:	682a      	ldr	r2, [r5, #0]
    10da:	2380      	movs	r3, #128	; 0x80
    10dc:	02db      	lsls	r3, r3, #11
    10de:	4313      	orrs	r3, r2
    10e0:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    10e2:	682a      	ldr	r2, [r5, #0]
    10e4:	1c20      	adds	r0, r4, #0
    10e6:	2103      	movs	r1, #3
    10e8:	f7ff f88f 	bl	20a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    10ec:	4eb6      	ldr	r6, [pc, #728]	; (13c8 <main+0x828>)
    10ee:	227e      	movs	r2, #126	; 0x7e
    10f0:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    10f2:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    10f4:	4393      	bics	r3, r2
    10f6:	2210      	movs	r2, #16
    10f8:	4313      	orrs	r3, r2
    10fa:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    10fc:	6832      	ldr	r2, [r6, #0]
    10fe:	1c39      	adds	r1, r7, #0
    1100:	f7ff f883 	bl	20a <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    1104:	6833      	ldr	r3, [r6, #0]
    1106:	2101      	movs	r1, #1
    1108:	430b      	orrs	r3, r1
    110a:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    110c:	6832      	ldr	r2, [r6, #0]
    110e:	1c39      	adds	r1, r7, #0
    1110:	1c20      	adds	r0, r4, #0
    1112:	f7ff f87a 	bl	20a <mbus_remote_register_write>

    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    1116:	48ad      	ldr	r0, [pc, #692]	; (13cc <main+0x82c>)
    1118:	f7fe ffc5 	bl	a6 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    111c:	4bac      	ldr	r3, [pc, #688]	; (13d0 <main+0x830>)
    111e:	2103      	movs	r1, #3
    1120:	781a      	ldrb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    1122:	1c20      	adds	r0, r4, #0
    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    1124:	430a      	orrs	r2, r1
    1126:	701a      	strb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    1128:	781a      	ldrb	r2, [r3, #0]
    112a:	210c      	movs	r1, #12
    112c:	430a      	orrs	r2, r1
    112e:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    1130:	681a      	ldr	r2, [r3, #0]
    1132:	211f      	movs	r1, #31
    1134:	f7ff f869 	bl	20a <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1138:	4ba6      	ldr	r3, [pc, #664]	; (13d4 <main+0x834>)
    113a:	210c      	movs	r1, #12
    113c:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    113e:	1c20      	adds	r0, r4, #0

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1140:	0a92      	lsrs	r2, r2, #10
    1142:	0292      	lsls	r2, r2, #10
    1144:	430a      	orrs	r2, r1
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    1146:	49a4      	ldr	r1, [pc, #656]	; (13d8 <main+0x838>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1148:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    114a:	680a      	ldr	r2, [r1, #0]
    114c:	49a3      	ldr	r1, [pc, #652]	; (13dc <main+0x83c>)
    114e:	0bd2      	lsrs	r2, r2, #15
    1150:	03d2      	lsls	r2, r2, #15
    1152:	430a      	orrs	r2, r1
    1154:	49a0      	ldr	r1, [pc, #640]	; (13d8 <main+0x838>)
    1156:	600a      	str	r2, [r1, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    1158:	6819      	ldr	r1, [r3, #0]
    115a:	4aa1      	ldr	r2, [pc, #644]	; (13e0 <main+0x840>)
    115c:	400a      	ands	r2, r1
    115e:	21c8      	movs	r1, #200	; 0xc8
    1160:	01c9      	lsls	r1, r1, #7
    1162:	430a      	orrs	r2, r1
    1164:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    1166:	681a      	ldr	r2, [r3, #0]
    1168:	2112      	movs	r1, #18
    116a:	f7ff f84e 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    116e:	4b9a      	ldr	r3, [pc, #616]	; (13d8 <main+0x838>)
    1170:	1c20      	adds	r0, r4, #0
    1172:	681a      	ldr	r2, [r3, #0]
    1174:	2113      	movs	r1, #19
    1176:	f7ff f848 	bl	20a <mbus_remote_register_write>
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
    117a:	4b9a      	ldr	r3, [pc, #616]	; (13e4 <main+0x844>)
    117c:	2205      	movs	r2, #5
    117e:	701a      	strb	r2, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
    1180:	4b99      	ldr	r3, [pc, #612]	; (13e8 <main+0x848>)

    mrr_cfo_val_fine_min = 0x0000;
    1182:	4a9a      	ldr	r2, [pc, #616]	; (13ec <main+0x84c>)
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
    mrr_freq_hopping_step = 4; // determining center freq
    1184:	2104      	movs	r1, #4
    1186:	7019      	strb	r1, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
    1188:	8017      	strh	r7, [r2, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    118a:	2280      	movs	r2, #128	; 0x80
    118c:	1c20      	adds	r0, r4, #0
    118e:	2106      	movs	r1, #6
    1190:	0152      	lsls	r2, r2, #5
    1192:	f7ff f83a 	bl	20a <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
    1196:	2280      	movs	r2, #128	; 0x80
    1198:	1c20      	adds	r0, r4, #0
    119a:	2108      	movs	r1, #8
    119c:	03d2      	lsls	r2, r2, #15
    119e:	f7ff f834 	bl	20a <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    11a2:	4b93      	ldr	r3, [pc, #588]	; (13f0 <main+0x850>)
    11a4:	217f      	movs	r1, #127	; 0x7f
    11a6:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    11a8:	1c20      	adds	r0, r4, #0

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    11aa:	438a      	bics	r2, r1
    11ac:	2110      	movs	r1, #16
    11ae:	430a      	orrs	r2, r1
    11b0:	801a      	strh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    11b2:	8819      	ldrh	r1, [r3, #0]
    11b4:	4a8f      	ldr	r2, [pc, #572]	; (13f4 <main+0x854>)
    11b6:	400a      	ands	r2, r1
    11b8:	2180      	movs	r1, #128	; 0x80
    11ba:	0109      	lsls	r1, r1, #4
    11bc:	430a      	orrs	r2, r1
    11be:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    11c0:	681a      	ldr	r2, [r3, #0]
    11c2:	2107      	movs	r1, #7
    11c4:	f7ff f821 	bl	20a <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    11c8:	6832      	ldr	r2, [r6, #0]
    11ca:	4b8b      	ldr	r3, [pc, #556]	; (13f8 <main+0x858>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    11cc:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    11ce:	4013      	ands	r3, r2
    11d0:	22e0      	movs	r2, #224	; 0xe0
    11d2:	40a2      	lsls	r2, r4
    11d4:	4313      	orrs	r3, r2
    11d6:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    11d8:	6832      	ldr	r2, [r6, #0]
    11da:	1c39      	adds	r1, r7, #0
    11dc:	f7ff f815 	bl	20a <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    11e0:	4b86      	ldr	r3, [pc, #536]	; (13fc <main+0x85c>)
    11e2:	2107      	movs	r1, #7
    11e4:	681a      	ldr	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    11e6:	263f      	movs	r6, #63	; 0x3f
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    11e8:	0a92      	lsrs	r2, r2, #10
    11ea:	0292      	lsls	r2, r2, #10
    11ec:	430a      	orrs	r2, r1
    11ee:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    11f0:	4a7e      	ldr	r2, [pc, #504]	; (13ec <main+0x84c>)
    11f2:	8811      	ldrh	r1, [r2, #0]
    11f4:	6818      	ldr	r0, [r3, #0]
    11f6:	4a82      	ldr	r2, [pc, #520]	; (1400 <main+0x860>)
    11f8:	4031      	ands	r1, r6
    11fa:	0409      	lsls	r1, r1, #16
    11fc:	4002      	ands	r2, r0
    11fe:	430a      	orrs	r2, r1
    1200:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    1202:	4a7a      	ldr	r2, [pc, #488]	; (13ec <main+0x84c>)
    1204:	8811      	ldrh	r1, [r2, #0]
    1206:	6818      	ldr	r0, [r3, #0]
    1208:	4a7e      	ldr	r2, [pc, #504]	; (1404 <main+0x864>)
    120a:	4031      	ands	r1, r6
    120c:	0289      	lsls	r1, r1, #10
    120e:	4002      	ands	r2, r0
    1210:	430a      	orrs	r2, r1
    1212:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    1214:	681a      	ldr	r2, [r3, #0]
    1216:	1c20      	adds	r0, r4, #0
    1218:	2101      	movs	r1, #1
    121a:	f7fe fff6 	bl	20a <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    121e:	4b7a      	ldr	r3, [pc, #488]	; (1408 <main+0x868>)
    1220:	497a      	ldr	r1, [pc, #488]	; (140c <main+0x86c>)
    1222:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    1224:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    1226:	430a      	orrs	r2, r1
    1228:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    122a:	681a      	ldr	r2, [r3, #0]
    122c:	1c21      	adds	r1, r4, #0
    122e:	f7fe ffec 	bl	20a <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    1232:	682a      	ldr	r2, [r5, #0]
    1234:	4b76      	ldr	r3, [pc, #472]	; (1410 <main+0x870>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1236:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    1238:	4013      	ands	r3, r2
    123a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    123c:	682a      	ldr	r2, [r5, #0]
    123e:	2103      	movs	r1, #3
    1240:	f7fe ffe3 	bl	20a <mbus_remote_register_write>

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    1244:	4b73      	ldr	r3, [pc, #460]	; (1414 <main+0x874>)
    1246:	4a74      	ldr	r2, [pc, #464]	; (1418 <main+0x878>)
    1248:	6819      	ldr	r1, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    124a:	4d74      	ldr	r5, [pc, #464]	; (141c <main+0x87c>)

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    124c:	400a      	ands	r2, r1
    124e:	601a      	str	r2, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    1250:	682a      	ldr	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    1252:	1c20      	adds	r0, r4, #0
    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    1254:	43b2      	bics	r2, r6
    1256:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    1258:	6829      	ldr	r1, [r5, #0]
    125a:	4a71      	ldr	r2, [pc, #452]	; (1420 <main+0x880>)
    125c:	400a      	ands	r2, r1
    125e:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    1260:	6829      	ldr	r1, [r5, #0]
    1262:	4a70      	ldr	r2, [pc, #448]	; (1424 <main+0x884>)
    1264:	400a      	ands	r2, r1
    1266:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    1268:	681a      	ldr	r2, [r3, #0]
    126a:	2114      	movs	r1, #20
    126c:	f7fe ffcd 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
    1270:	682a      	ldr	r2, [r5, #0]
    1272:	1c20      	adds	r0, r4, #0
    1274:	2115      	movs	r1, #21
    1276:	f7fe ffc8 	bl	20a <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    127a:	1c20      	adds	r0, r4, #0
    127c:	1c3a      	adds	r2, r7, #0
    127e:	2109      	movs	r1, #9
    1280:	f7fe ffc3 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    1284:	1c20      	adds	r0, r4, #0
    1286:	1c3a      	adds	r2, r7, #0
    1288:	210a      	movs	r1, #10
    128a:	f7fe ffbe 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    128e:	1c20      	adds	r0, r4, #0
    1290:	1c3a      	adds	r2, r7, #0
    1292:	210b      	movs	r1, #11
    1294:	f7fe ffb9 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    1298:	1c20      	adds	r0, r4, #0
    129a:	210c      	movs	r1, #12
    129c:	4a62      	ldr	r2, [pc, #392]	; (1428 <main+0x888>)
    129e:	f7fe ffb4 	bl	20a <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    12a2:	4b62      	ldr	r3, [pc, #392]	; (142c <main+0x88c>)
    12a4:	21f8      	movs	r1, #248	; 0xf8
    12a6:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    12a8:	1c20      	adds	r0, r4, #0
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    12aa:	438a      	bics	r2, r1
    12ac:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    12ae:	881a      	ldrh	r2, [r3, #0]
    12b0:	21ff      	movs	r1, #255	; 0xff
    12b2:	400a      	ands	r2, r1
    12b4:	495e      	ldr	r1, [pc, #376]	; (1430 <main+0x890>)
    12b6:	430a      	orrs	r2, r1
    12b8:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    12ba:	681a      	ldr	r2, [r3, #0]
    12bc:	2111      	movs	r1, #17
    12be:	f7fe ffa4 	bl	20a <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    12c2:	4a45      	ldr	r2, [pc, #276]	; (13d8 <main+0x838>)
    12c4:	495b      	ldr	r1, [pc, #364]	; (1434 <main+0x894>)
    12c6:	6813      	ldr	r3, [r2, #0]
    12c8:	22c0      	movs	r2, #192	; 0xc0
    12ca:	400b      	ands	r3, r1
    12cc:	03d2      	lsls	r2, r2, #15
    12ce:	4313      	orrs	r3, r2
    12d0:	4a41      	ldr	r2, [pc, #260]	; (13d8 <main+0x838>)
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    12d2:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    12d4:	6013      	str	r3, [r2, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    12d6:	6812      	ldr	r2, [r2, #0]
    12d8:	2113      	movs	r1, #19
    12da:	f7fe ff96 	bl	20a <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
    12de:	4a56      	ldr	r2, [pc, #344]	; (1438 <main+0x898>)
    12e0:	211e      	movs	r1, #30
    12e2:	1c20      	adds	r0, r4, #0
    12e4:	f7fe ff91 	bl	20a <mbus_remote_register_write>

    // Additional delay for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    12e8:	4838      	ldr	r0, [pc, #224]	; (13cc <main+0x82c>)
    12ea:	f7fe fedc 	bl	a6 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    12ee:	4b53      	ldr	r3, [pc, #332]	; (143c <main+0x89c>)
    delay(MBUS_DELAY);
    return;
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    12f0:	1c38      	adds	r0, r7, #0
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    12f2:	701f      	strb	r7, [r3, #0]
    radio_ready = 0;
    12f4:	4b52      	ldr	r3, [pc, #328]	; (1440 <main+0x8a0>)
    12f6:	701f      	strb	r7, [r3, #0]
    delay(MBUS_DELAY);
    return;
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    12f8:	f7ff f818 	bl	32c <pmu_setting_temp_based>
    read_data_batadc = *REG0 & 0xFFFF;
}

inline static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
    12fc:	2186      	movs	r1, #134	; 0x86
    12fe:	200e      	movs	r0, #14
    1300:	00c9      	lsls	r1, r1, #3
    1302:	f7fe ffc7 	bl	294 <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
    1306:	2045      	movs	r0, #69	; 0x45
    1308:	2148      	movs	r1, #72	; 0x48
    130a:	f7fe ffc3 	bl	294 <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
    130e:	203a      	movs	r0, #58	; 0x3a
    1310:	494c      	ldr	r1, [pc, #304]	; (1444 <main+0x8a4>)
    1312:	f7fe ffbf 	bl	294 <pmu_reg_write>
}

inline static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    1316:	203c      	movs	r0, #60	; 0x3c
    1318:	494b      	ldr	r1, [pc, #300]	; (1448 <main+0x8a8>)
    131a:	f7fe ffbb 	bl	294 <pmu_reg_write>

inline static void pmu_adc_enable() {
    // PMU ADC will be automatically reset when system wakes up
    // PMU_CONTROLLER_DESIRED_STATE sleep
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
    131e:	203b      	movs	r0, #59	; 0x3b
    1320:	494a      	ldr	r1, [pc, #296]	; (144c <main+0x8ac>)
    1322:	f7fe ffb7 	bl	294 <pmu_reg_write>
    1326:	e38a      	b.n	1a3e <main+0xe9e>
    if(enumerated != ENUMID) {
        operation_init();
        operation_sleep_notimer();
    }

    update_system_time();
    1328:	f7ff f9a4 	bl	674 <update_system_time>
#define MPLIER_SHIFT 6
uint8_t lnt_snt_mplier = 0x52;
uint32_t projected_end_time = 0;

static void update_lnt_timer() {
    if(xo_sys_time > projected_end_time + TIMER_MARGIN 
    132c:	4b48      	ldr	r3, [pc, #288]	; (1450 <main+0x8b0>)
    132e:	4a49      	ldr	r2, [pc, #292]	; (1454 <main+0x8b4>)
    1330:	681b      	ldr	r3, [r3, #0]
    1332:	6810      	ldr	r0, [r2, #0]
    1334:	1c59      	adds	r1, r3, #1
    1336:	31ff      	adds	r1, #255	; 0xff
    1338:	4288      	cmp	r0, r1
    133a:	d909      	bls.n	1350 <main+0x7b0>
	&& xo_sys_time_in_sec - (projected_end_time >> XO_TO_SEC_SHIFT) < 256) {
    133c:	4946      	ldr	r1, [pc, #280]	; (1458 <main+0x8b8>)
    133e:	6808      	ldr	r0, [r1, #0]
    1340:	0a99      	lsrs	r1, r3, #10
    1342:	1a41      	subs	r1, r0, r1
    1344:	29ff      	cmp	r1, #255	; 0xff
    1346:	d803      	bhi.n	1350 <main+0x7b0>
        lnt_snt_mplier--;
    1348:	4944      	ldr	r1, [pc, #272]	; (145c <main+0x8bc>)
    134a:	7808      	ldrb	r0, [r1, #0]
    134c:	3801      	subs	r0, #1
    134e:	e00d      	b.n	136c <main+0x7cc>
    }
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
    1350:	1e59      	subs	r1, r3, #1
    1352:	6810      	ldr	r0, [r2, #0]
    1354:	39ff      	subs	r1, #255	; 0xff
    1356:	4288      	cmp	r0, r1
    1358:	d209      	bcs.n	136e <main+0x7ce>
		&& (projected_end_time >> XO_TO_SEC_SHIFT) - xo_sys_time_in_sec < 256) {
    135a:	493f      	ldr	r1, [pc, #252]	; (1458 <main+0x8b8>)
    135c:	0a98      	lsrs	r0, r3, #10
    135e:	6809      	ldr	r1, [r1, #0]
    1360:	1a41      	subs	r1, r0, r1
    1362:	29ff      	cmp	r1, #255	; 0xff
    1364:	d803      	bhi.n	136e <main+0x7ce>
        lnt_snt_mplier++;
    1366:	493d      	ldr	r1, [pc, #244]	; (145c <main+0x8bc>)
    1368:	7808      	ldrb	r0, [r1, #0]
    136a:	3001      	adds	r0, #1
    136c:	7008      	strb	r0, [r1, #0]
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    136e:	6811      	ldr	r1, [r2, #0]
    1370:	20e4      	movs	r0, #228	; 0xe4
    1372:	1a59      	subs	r1, r3, r1
    1374:	f7fe ff08 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE4, lnt_snt_mplier);
    1378:	4b38      	ldr	r3, [pc, #224]	; (145c <main+0x8bc>)
    update_system_time();
    update_lnt_timer();

    pmu_setting_temp_based(0);

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    137a:	4d39      	ldr	r5, [pc, #228]	; (1460 <main+0x8c0>)
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
		&& (projected_end_time >> XO_TO_SEC_SHIFT) - xo_sys_time_in_sec < 256) {
        lnt_snt_mplier++;
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
    137c:	7819      	ldrb	r1, [r3, #0]
    137e:	20e4      	movs	r0, #228	; 0xe4
    1380:	f7fe ff02 	bl	188 <mbus_write_message32>
    }

    update_system_time();
    update_lnt_timer();

    pmu_setting_temp_based(0);
    1384:	2000      	movs	r0, #0
    1386:	f7fe ffd1 	bl	32c <pmu_setting_temp_based>

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    138a:	248c      	movs	r4, #140	; 0x8c
    update_system_time();
    update_lnt_timer();

    pmu_setting_temp_based(0);

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    138c:	6829      	ldr	r1, [r5, #0]
    138e:	20ee      	movs	r0, #238	; 0xee
    1390:	f7fe fefa 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    1394:	6821      	ldr	r1, [r4, #0]
    1396:	20ee      	movs	r0, #238	; 0xee
    1398:	f7fe fef6 	bl	188 <mbus_write_message32>

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
    139c:	682b      	ldr	r3, [r5, #0]
    139e:	07d9      	lsls	r1, r3, #31
    13a0:	d564      	bpl.n	146c <main+0x8cc>
        if(!(*GOC_DATA_IRQ)) {
    13a2:	6823      	ldr	r3, [r4, #0]
    13a4:	2b00      	cmp	r3, #0
    13a6:	d15d      	bne.n	1464 <main+0x8c4>
    13a8:	e392      	b.n	1ad0 <main+0xf30>
    13aa:	46c0      	nop			; (mov r8, r8)
    13ac:	00001ce8 	.word	0x00001ce8
    13b0:	00001c04 	.word	0x00001c04
    13b4:	00ffffff 	.word	0x00ffffff
    13b8:	00001c08 	.word	0x00001c08
    13bc:	00001bf8 	.word	0x00001bf8
    13c0:	00001be4 	.word	0x00001be4
    13c4:	fff7ffff 	.word	0xfff7ffff
    13c8:	00001c4c 	.word	0x00001c4c
    13cc:	00004e20 	.word	0x00004e20
    13d0:	00001c44 	.word	0x00001c44
    13d4:	00001c20 	.word	0x00001c20
    13d8:	00001c24 	.word	0x00001c24
    13dc:	00000451 	.word	0x00000451
    13e0:	fff003ff 	.word	0xfff003ff
    13e4:	00001c64 	.word	0x00001c64
    13e8:	00001ccc 	.word	0x00001ccc
    13ec:	00001c5c 	.word	0x00001c5c
    13f0:	00001be8 	.word	0x00001be8
    13f4:	ffffc07f 	.word	0xffffc07f
    13f8:	fffe007f 	.word	0xfffe007f
    13fc:	00001cf8 	.word	0x00001cf8
    1400:	ffc0ffff 	.word	0xffc0ffff
    1404:	ffff03ff 	.word	0xffff03ff
    1408:	00001be0 	.word	0x00001be0
    140c:	00001fff 	.word	0x00001fff
    1410:	ffffbfff 	.word	0xffffbfff
    1414:	00001c28 	.word	0x00001c28
    1418:	fff8ffff 	.word	0xfff8ffff
    141c:	00001bec 	.word	0x00001bec
    1420:	fffff03f 	.word	0xfffff03f
    1424:	fff80fff 	.word	0xfff80fff
    1428:	007ac800 	.word	0x007ac800
    142c:	00001c1c 	.word	0x00001c1c
    1430:	ffffc000 	.word	0xffffc000
    1434:	ff1fffff 	.word	0xff1fffff
    1438:	00001002 	.word	0x00001002
    143c:	00001cd5 	.word	0x00001cd5
    1440:	00001c5e 	.word	0x00001c5e
    1444:	00103800 	.word	0x00103800
    1448:	0017c7ff 	.word	0x0017c7ff
    144c:	0017efff 	.word	0x0017efff
    1450:	00001cd8 	.word	0x00001cd8
    1454:	00001c60 	.word	0x00001c60
    1458:	00001c84 	.word	0x00001c84
    145c:	00001c34 	.word	0x00001c34
    1460:	a000a008 	.word	0xa000a008
            operation_sleep(); // Need to protect against spurious wakeups
        }
        set_goc_cmd();
    1464:	f7ff fb28 	bl	ab8 <set_goc_cmd>
        reset_timers_list();
    1468:	f7ff f956 	bl	718 <reset_timers_list>
    }

    lnt_start_meas = 2;
    146c:	4bce      	ldr	r3, [pc, #824]	; (17a8 <main+0xc08>)
    146e:	2202      	movs	r2, #2
    1470:	701a      	strb	r2, [r3, #0]
    // // Change Counting Time 
    // lntv1a_r03.TIME_COUNTING = 0x000; // Default : 0x258
    // mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    // delay(MBUS_DELAY*10);
    
    set_halt_until_mbus_trx();
    1472:	f7fe fe83 	bl	17c <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    1476:	2003      	movs	r0, #3
    1478:	2110      	movs	r1, #16
    147a:	2200      	movs	r2, #0
    147c:	2301      	movs	r3, #1
    147e:	f7fe feb3 	bl	1e8 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
    1482:	f7fe fe75 	bl	170 <set_halt_until_mbus_tx>
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    1486:	4bc9      	ldr	r3, [pc, #804]	; (17ac <main+0xc0c>)
    1488:	26a0      	movs	r6, #160	; 0xa0
    148a:	681a      	ldr	r2, [r3, #0]
    148c:	0636      	lsls	r6, r6, #24
    148e:	6833      	ldr	r3, [r6, #0]
    1490:	0612      	lsls	r2, r2, #24
    1492:	4fc7      	ldr	r7, [pc, #796]	; (17b0 <main+0xc10>)
    1494:	1c14      	adds	r4, r2, #0
    1496:	2500      	movs	r5, #0
    1498:	431c      	orrs	r4, r3
    149a:	603c      	str	r4, [r7, #0]
    149c:	607d      	str	r5, [r7, #4]
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    149e:	683a      	ldr	r2, [r7, #0]
    14a0:	687b      	ldr	r3, [r7, #4]
    14a2:	20e0      	movs	r0, #224	; 0xe0
    14a4:	1c19      	adds	r1, r3, #0
    14a6:	f7fe fe6f 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);
    14aa:	683a      	ldr	r2, [r7, #0]
    14ac:	687b      	ldr	r3, [r7, #4]
    14ae:	20e1      	movs	r0, #225	; 0xe1
    14b0:	1c11      	adds	r1, r2, #0
    14b2:	f7fe fe69 	bl	188 <mbus_write_message32>

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    14b6:	4cbf      	ldr	r4, [pc, #764]	; (17b4 <main+0xc14>)
    14b8:	2210      	movs	r2, #16
    14ba:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    14bc:	1c29      	adds	r1, r5, #0
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    14be:	4393      	bics	r3, r2
    14c0:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    14c2:	7823      	ldrb	r3, [r4, #0]
    14c4:	2240      	movs	r2, #64	; 0x40
    14c6:	4393      	bics	r3, r2
    14c8:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    14ca:	6822      	ldr	r2, [r4, #0]
    14cc:	2003      	movs	r0, #3
    14ce:	f7fe fe9c 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    14d2:	48b9      	ldr	r0, [pc, #740]	; (17b8 <main+0xc18>)
    14d4:	f7fe fde7 	bl	a6 <delay>
    
    // Reset LNT //lntv1a_r00.RESET_AFE = 0x1; // Default : 0x1
    lntv1a_r00.RESETN_DBE = 0x0; // Default : 0x0
    14d8:	7823      	ldrb	r3, [r4, #0]
    14da:	2204      	movs	r2, #4
    14dc:	4393      	bics	r3, r2
    14de:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    14e0:	6822      	ldr	r2, [r4, #0]
    14e2:	2003      	movs	r0, #3
    14e4:	1c29      	adds	r1, r5, #0
    14e6:	f7fe fe90 	bl	20a <mbus_remote_register_write>
    }

    lnt_start_meas = 2;
    lnt_stop();

    operation_temp_run();
    14ea:	f7ff f813 	bl	514 <operation_temp_run>

inline static void pmu_adc_read_latest() {
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    14ee:	1c28      	adds	r0, r5, #0
    14f0:	2103      	movs	r1, #3
    14f2:	f7fe fecf 	bl	294 <pmu_reg_write>
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
    14f6:	6832      	ldr	r2, [r6, #0]
    14f8:	4bb0      	ldr	r3, [pc, #704]	; (17bc <main+0xc1c>)
    lnt_stop();

    operation_temp_run();
    pmu_adc_read_latest();

    mrr_send_enable = 1;
    14fa:	2101      	movs	r1, #1
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
    14fc:	801a      	strh	r2, [r3, #0]
    lnt_stop();

    operation_temp_run();
    pmu_adc_read_latest();

    mrr_send_enable = 1;
    14fe:	4ab0      	ldr	r2, [pc, #704]	; (17c0 <main+0xc20>)
    1500:	7011      	strb	r1, [r2, #0]
    if(snt_sys_temp_code < PMU_TEMP_THRESH[1] 
    1502:	49b0      	ldr	r1, [pc, #704]	; (17c4 <main+0xc24>)
    1504:	6808      	ldr	r0, [r1, #0]
    1506:	49b0      	ldr	r1, [pc, #704]	; (17c8 <main+0xc28>)
    1508:	4288      	cmp	r0, r1
    150a:	d903      	bls.n	1514 <main+0x974>
	|| (read_data_batadc & 0xFF) > MRR_VOLT_THRESH) {
    150c:	881b      	ldrh	r3, [r3, #0]
    150e:	b2db      	uxtb	r3, r3
    1510:	2b4f      	cmp	r3, #79	; 0x4f
    1512:	dd01      	ble.n	1518 <main+0x978>
        mrr_send_enable = 0;
    1514:	2300      	movs	r3, #0
    1516:	7013      	strb	r3, [r2, #0]
    }

    sys_run_continuous = 0;
    1518:	4bac      	ldr	r3, [pc, #688]	; (17cc <main+0xc2c>)
    151a:	2200      	movs	r2, #0
    151c:	701a      	strb	r2, [r3, #0]
    do {
        if(goc_component == 0x00) {
    151e:	4bac      	ldr	r3, [pc, #688]	; (17d0 <main+0xc30>)
    1520:	781c      	ldrb	r4, [r3, #0]
    1522:	2c00      	cmp	r4, #0
    1524:	d11d      	bne.n	1562 <main+0x9c2>
            if(goc_func_id == 0x01) {
    1526:	4bab      	ldr	r3, [pc, #684]	; (17d4 <main+0xc34>)
    1528:	781b      	ldrb	r3, [r3, #0]
    152a:	2b01      	cmp	r3, #1
    152c:	d10f      	bne.n	154e <main+0x9ae>
                if(sys_run_continuous) {
    152e:	4ca7      	ldr	r4, [pc, #668]	; (17cc <main+0xc2c>)
    1530:	7823      	ldrb	r3, [r4, #0]
    1532:	2b00      	cmp	r3, #0
    1534:	d002      	beq.n	153c <main+0x99c>
                    start_xo_cout();
    1536:	f7fe fe0f 	bl	158 <start_xo_cout>
    153a:	e001      	b.n	1540 <main+0x9a0>
                }
                else {
                    stop_xo_cout();
    153c:	f7fe fe12 	bl	164 <stop_xo_cout>
                }
                sys_run_continuous = !sys_run_continuous;
    1540:	7823      	ldrb	r3, [r4, #0]
    1542:	425a      	negs	r2, r3
    1544:	4153      	adcs	r3, r2
    1546:	7023      	strb	r3, [r4, #0]
                goc_func_id = 0xFF;
    1548:	22ff      	movs	r2, #255	; 0xff
    154a:	4ba2      	ldr	r3, [pc, #648]	; (17d4 <main+0xc34>)
    154c:	e1ac      	b.n	18a8 <main+0xd08>
            }
            else if(goc_func_id == 0x02) {
    154e:	2b02      	cmp	r3, #2
    1550:	d000      	beq.n	1554 <main+0x9b4>
    1552:	e233      	b.n	19bc <main+0xe1c>
                // enter time in minutes
                xo_day_time_in_sec = goc_data * 60;
    1554:	4ba0      	ldr	r3, [pc, #640]	; (17d8 <main+0xc38>)
    1556:	223c      	movs	r2, #60	; 0x3c
    1558:	881b      	ldrh	r3, [r3, #0]
    155a:	435a      	muls	r2, r3
    155c:	4b9f      	ldr	r3, [pc, #636]	; (17dc <main+0xc3c>)
    155e:	601a      	str	r2, [r3, #0]
    1560:	e22c      	b.n	19bc <main+0xe1c>
            }
        }
        else if(goc_component == 0x01) {
    1562:	2c01      	cmp	r4, #1
    1564:	d141      	bne.n	15ea <main+0xa4a>
	    op_counter++;
    1566:	4f9e      	ldr	r7, [pc, #632]	; (17e0 <main+0xc40>)
	    lnt_start_meas = 0;
    1568:	2600      	movs	r6, #0
                // enter time in minutes
                xo_day_time_in_sec = goc_data * 60;
            }
        }
        else if(goc_component == 0x01) {
	    op_counter++;
    156a:	883b      	ldrh	r3, [r7, #0]
    156c:	3301      	adds	r3, #1
    156e:	803b      	strh	r3, [r7, #0]
	    lnt_start_meas = 0;
    1570:	4b8d      	ldr	r3, [pc, #564]	; (17a8 <main+0xc08>)
    1572:	701e      	strb	r6, [r3, #0]
	    goc_state = 0;
    1574:	4b9b      	ldr	r3, [pc, #620]	; (17e4 <main+0xc44>)
    1576:	701e      	strb	r6, [r3, #0]

	    if(mrr_send_enable) {
    1578:	4b91      	ldr	r3, [pc, #580]	; (17c0 <main+0xc20>)
    157a:	781b      	ldrb	r3, [r3, #0]
    157c:	42b3      	cmp	r3, r6
    157e:	d031      	beq.n	15e4 <main+0xa44>
	        pmu_setting_temp_based(1);
    1580:	1c20      	adds	r0, r4, #0
    1582:	f7fe fed3 	bl	32c <pmu_setting_temp_based>
                reset_radio_data_arr();
    1586:	f7fe fe7d 	bl	284 <reset_radio_data_arr>
                radio_data_arr[0] = snt_sys_temp_code;
    158a:	4b8e      	ldr	r3, [pc, #568]	; (17c4 <main+0xc24>)
    158c:	4d96      	ldr	r5, [pc, #600]	; (17e8 <main+0xc48>)
    158e:	681b      	ldr	r3, [r3, #0]
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    1590:	220f      	movs	r2, #15
	    goc_state = 0;

	    if(mrr_send_enable) {
	        pmu_setting_temp_based(1);
                reset_radio_data_arr();
                radio_data_arr[0] = snt_sys_temp_code;
    1592:	602b      	str	r3, [r5, #0]
                radio_data_arr[1] = read_data_batadc;
    1594:	4b89      	ldr	r3, [pc, #548]	; (17bc <main+0xc1c>)
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    1596:	2140      	movs	r1, #64	; 0x40

	    if(mrr_send_enable) {
	        pmu_setting_temp_based(1);
                reset_radio_data_arr();
                radio_data_arr[0] = snt_sys_temp_code;
                radio_data_arr[1] = read_data_batadc;
    1598:	881b      	ldrh	r3, [r3, #0]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
    159a:	1c30      	adds	r0, r6, #0

	    if(mrr_send_enable) {
	        pmu_setting_temp_based(1);
                reset_radio_data_arr();
                radio_data_arr[0] = snt_sys_temp_code;
                radio_data_arr[1] = read_data_batadc;
    159c:	606b      	str	r3, [r5, #4]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    159e:	883b      	ldrh	r3, [r7, #0]
    15a0:	4013      	ands	r3, r2
    15a2:	021b      	lsls	r3, r3, #8
    15a4:	430b      	orrs	r3, r1
    15a6:	60ab      	str	r3, [r5, #8]
                mrr_send_radio_data(0);
    15a8:	f7ff f93c 	bl	824 <mrr_send_radio_data>
	        reset_radio_data_arr();
    15ac:	f7fe fe6a 	bl	284 <reset_radio_data_arr>
	        update_system_time();
    15b0:	f7ff f860 	bl	674 <update_system_time>
	        radio_data_arr[0] = PMU_RADIO_SETTINGS[pmu_setting_cur_index];
    15b4:	4b8d      	ldr	r3, [pc, #564]	; (17ec <main+0xc4c>)
    15b6:	4a8e      	ldr	r2, [pc, #568]	; (17f0 <main+0xc50>)
    15b8:	781b      	ldrb	r3, [r3, #0]
	        radio_data_arr[1] = (pmu_setting_cur_index << 16) | (PMU_RADIO_SAR_SETTINGS[pmu_setting_cur_index]);
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(1);
    15ba:	1c20      	adds	r0, r4, #0
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
	        reset_radio_data_arr();
	        update_system_time();
	        radio_data_arr[0] = PMU_RADIO_SETTINGS[pmu_setting_cur_index];
    15bc:	0099      	lsls	r1, r3, #2
    15be:	588a      	ldr	r2, [r1, r2]
	        radio_data_arr[1] = (pmu_setting_cur_index << 16) | (PMU_RADIO_SAR_SETTINGS[pmu_setting_cur_index]);
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    15c0:	2140      	movs	r1, #64	; 0x40
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
	        reset_radio_data_arr();
	        update_system_time();
	        radio_data_arr[0] = PMU_RADIO_SETTINGS[pmu_setting_cur_index];
    15c2:	602a      	str	r2, [r5, #0]
	        radio_data_arr[1] = (pmu_setting_cur_index << 16) | (PMU_RADIO_SAR_SETTINGS[pmu_setting_cur_index]);
    15c4:	4a8b      	ldr	r2, [pc, #556]	; (17f4 <main+0xc54>)
    15c6:	5cd2      	ldrb	r2, [r2, r3]
    15c8:	041b      	lsls	r3, r3, #16
    15ca:	4313      	orrs	r3, r2
    15cc:	606b      	str	r3, [r5, #4]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    15ce:	883b      	ldrh	r3, [r7, #0]
    15d0:	220f      	movs	r2, #15
    15d2:	4013      	ands	r3, r2
    15d4:	021b      	lsls	r3, r3, #8
    15d6:	430b      	orrs	r3, r1
    15d8:	60ab      	str	r3, [r5, #8]
                mrr_send_radio_data(1);
    15da:	f7ff f923 	bl	824 <mrr_send_radio_data>
                pmu_setting_temp_based(0);
    15de:	1c30      	adds	r0, r6, #0
    15e0:	f7fe fea4 	bl	32c <pmu_setting_temp_based>
	    }

	    set_next_time(START_LNT, 100);
    15e4:	2001      	movs	r0, #1
    15e6:	2164      	movs	r1, #100	; 0x64
    15e8:	e1e6      	b.n	19b8 <main+0xe18>
        }
	else if(goc_component == 0x02) {
    15ea:	2c02      	cmp	r4, #2
    15ec:	d109      	bne.n	1602 <main+0xa62>
	    update_system_time();
    15ee:	f7ff f841 	bl	674 <update_system_time>
	    mbus_write_message32(0xC1, xo_sys_time);
    15f2:	4b81      	ldr	r3, [pc, #516]	; (17f8 <main+0xc58>)
    15f4:	20c1      	movs	r0, #193	; 0xc1
    15f6:	6819      	ldr	r1, [r3, #0]
    15f8:	f7fe fdc6 	bl	188 <mbus_write_message32>
	    mbus_sleep_all();
    15fc:	f7fe fdee 	bl	1dc <mbus_sleep_all>
    1600:	e1dc      	b.n	19bc <main+0xe1c>
	}
        else if(goc_component == 0x04) {
    1602:	2c04      	cmp	r4, #4
    1604:	d000      	beq.n	1608 <main+0xa68>
    1606:	e1d9      	b.n	19bc <main+0xe1c>
            if(goc_func_id == 0x01) {
    1608:	4b72      	ldr	r3, [pc, #456]	; (17d4 <main+0xc34>)
    160a:	781a      	ldrb	r2, [r3, #0]
    160c:	2a01      	cmp	r2, #1
    160e:	d000      	beq.n	1612 <main+0xa72>
    1610:	e1d4      	b.n	19bc <main+0xe1c>
		if(goc_state == 0) {
    1612:	4b74      	ldr	r3, [pc, #464]	; (17e4 <main+0xc44>)
    1614:	7818      	ldrb	r0, [r3, #0]
    1616:	2800      	cmp	r0, #0
    1618:	d102      	bne.n	1620 <main+0xa80>
		    goc_state = 1;
    161a:	701a      	strb	r2, [r3, #0]
		    lnt_start_meas = 1;
    161c:	4b62      	ldr	r3, [pc, #392]	; (17a8 <main+0xc08>)
    161e:	e143      	b.n	18a8 <main+0xd08>
		}
		else if(goc_state == 1) {
    1620:	2801      	cmp	r0, #1
    1622:	d137      	bne.n	1694 <main+0xaf4>
                    goc_state = 2;
    1624:	2102      	movs	r1, #2
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    1626:	4c6e      	ldr	r4, [pc, #440]	; (17e0 <main+0xc40>)
		if(goc_state == 0) {
		    goc_state = 1;
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
    1628:	7019      	strb	r1, [r3, #0]
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    162a:	2300      	movs	r3, #0
    162c:	8023      	strh	r3, [r4, #0]

                    snt_counter = 2;    // start code with snt storage
    162e:	4c73      	ldr	r4, [pc, #460]	; (17fc <main+0xc5c>)
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    1630:	1c1a      	adds	r2, r3, #0

                    snt_counter = 2;    // start code with snt storage
    1632:	7021      	strb	r1, [r4, #0]
                    radio_beacon_counter = 0;
    1634:	4972      	ldr	r1, [pc, #456]	; (1800 <main+0xc60>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
    1636:	4c73      	ldr	r4, [pc, #460]	; (1804 <main+0xc64>)
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;

                    snt_counter = 2;    // start code with snt storage
                    radio_beacon_counter = 0;
    1638:	700b      	strb	r3, [r1, #0]
                    radio_counter = 0;
    163a:	4973      	ldr	r1, [pc, #460]	; (1808 <main+0xc68>)
    163c:	700b      	strb	r3, [r1, #0]

                    mem_light_addr = 0;
    163e:	4973      	ldr	r1, [pc, #460]	; (180c <main+0xc6c>)
    1640:	800b      	strh	r3, [r1, #0]
                    mem_light_len = 0;
    1642:	4973      	ldr	r1, [pc, #460]	; (1810 <main+0xc70>)
    1644:	800b      	strh	r3, [r1, #0]
                    mem_temp_addr = 7000;
    1646:	4973      	ldr	r1, [pc, #460]	; (1814 <main+0xc74>)
    1648:	800c      	strh	r4, [r1, #0]
                    mem_temp_len = 0;
    164a:	4973      	ldr	r1, [pc, #460]	; (1818 <main+0xc78>)

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    164c:	4c63      	ldr	r4, [pc, #396]	; (17dc <main+0xc3c>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;
    164e:	800b      	strh	r3, [r1, #0]

		    lnt_start_meas = 0;
    1650:	4955      	ldr	r1, [pc, #340]	; (17a8 <main+0xc08>)
    1652:	700b      	strb	r3, [r1, #0]

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    1654:	4971      	ldr	r1, [pc, #452]	; (181c <main+0xc7c>)
    1656:	680e      	ldr	r6, [r1, #0]
    1658:	6825      	ldr	r5, [r4, #0]
    165a:	1b75      	subs	r5, r6, r5
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
    165c:	4e5e      	ldr	r6, [pc, #376]	; (17d8 <main+0xc38>)
    165e:	8837      	ldrh	r7, [r6, #0]
    1660:	26e1      	movs	r6, #225	; 0xe1
    1662:	0136      	lsls	r6, r6, #4
    1664:	437e      	muls	r6, r7
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    1666:	19ae      	adds	r6, r5, r6
    1668:	4d6d      	ldr	r5, [pc, #436]	; (1820 <main+0xc80>)
    166a:	602e      	str	r6, [r5, #0]
                    xot_timer_list[START_LNT] = 0;
    166c:	606b      	str	r3, [r5, #4]
		    xo_is_day = 0;
    166e:	4b6d      	ldr	r3, [pc, #436]	; (1824 <main+0xc84>)
    1670:	701a      	strb	r2, [r3, #0]
		    xo_last_is_day = 0;
    1672:	4b6d      	ldr	r3, [pc, #436]	; (1828 <main+0xc88>)
    1674:	701a      	strb	r2, [r3, #0]

                    radio_data_arr[0] = xo_day_time_in_sec;
    1676:	6822      	ldr	r2, [r4, #0]
    1678:	4b5b      	ldr	r3, [pc, #364]	; (17e8 <main+0xc48>)
    167a:	601a      	str	r2, [r3, #0]
                    radio_data_arr[1] = xo_sys_time_in_sec;
    167c:	680a      	ldr	r2, [r1, #0]
    167e:	605a      	str	r2, [r3, #4]
                    radio_data_arr[2] = 0xDEAD;
    1680:	4a6a      	ldr	r2, [pc, #424]	; (182c <main+0xc8c>)
    1682:	609a      	str	r2, [r3, #8]
		    if(mrr_send_enable) {
    1684:	4b4e      	ldr	r3, [pc, #312]	; (17c0 <main+0xc20>)
    1686:	781b      	ldrb	r3, [r3, #0]
    1688:	2b00      	cmp	r3, #0
    168a:	d100      	bne.n	168e <main+0xaee>
    168c:	e196      	b.n	19bc <main+0xe1c>
                        mrr_send_radio_data(1);
    168e:	f7ff f8c9 	bl	824 <mrr_send_radio_data>
    1692:	e193      	b.n	19bc <main+0xe1c>
		    }
                }

		else if(goc_state == 2) {
    1694:	2802      	cmp	r0, #2
    1696:	d000      	beq.n	169a <main+0xafa>
    1698:	e108      	b.n	18ac <main+0xd0c>
                    if(op_counter >= SNT_OP_MAX_COUNT) {
    169a:	4a51      	ldr	r2, [pc, #324]	; (17e0 <main+0xc40>)
    169c:	4c60      	ldr	r4, [pc, #384]	; (1820 <main+0xc80>)
    169e:	8811      	ldrh	r1, [r2, #0]
    16a0:	290c      	cmp	r1, #12
    16a2:	d90c      	bls.n	16be <main+0xb1e>
                        goc_state = 3;
    16a4:	2203      	movs	r2, #3
    16a6:	701a      	strb	r2, [r3, #0]
			reset_timers_list();
    16a8:	f7ff f836 	bl	718 <reset_timers_list>
			update_system_time();
    16ac:	f7fe ffe2 	bl	674 <update_system_time>
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
    16b0:	4b5a      	ldr	r3, [pc, #360]	; (181c <main+0xc7c>)
    16b2:	2296      	movs	r2, #150	; 0x96
    16b4:	681b      	ldr	r3, [r3, #0]
    16b6:	0092      	lsls	r2, r2, #2
    16b8:	189b      	adds	r3, r3, r2
    16ba:	60a3      	str	r3, [r4, #8]
    16bc:	e17e      	b.n	19bc <main+0xe1c>
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
    16be:	6823      	ldr	r3, [r4, #0]
    16c0:	3301      	adds	r3, #1
    16c2:	d124      	bne.n	170e <main+0xb6e>
			    op_counter++;
    16c4:	8813      	ldrh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    16c6:	2000      	movs	r0, #0
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
			    op_counter++;
    16c8:	3301      	adds	r3, #1
    16ca:	8013      	strh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    16cc:	f7fe fe2e 	bl	32c <pmu_setting_temp_based>

                            // TODO: compensate XO

                            if(++snt_counter >= 3) {
    16d0:	4a4a      	ldr	r2, [pc, #296]	; (17fc <main+0xc5c>)
    16d2:	7813      	ldrb	r3, [r2, #0]
    16d4:	3301      	adds	r3, #1
    16d6:	b2db      	uxtb	r3, r3
    16d8:	7013      	strb	r3, [r2, #0]
    16da:	2b02      	cmp	r3, #2
    16dc:	d90d      	bls.n	16fa <main+0xb5a>
                                snt_counter = 0;
    16de:	2300      	movs	r3, #0
    16e0:	7013      	strb	r3, [r2, #0]
                                // TODO: compress this
                                mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) &snt_sys_temp_code, 0);
    16e2:	4c4d      	ldr	r4, [pc, #308]	; (1818 <main+0xc78>)
    16e4:	4a4b      	ldr	r2, [pc, #300]	; (1814 <main+0xc74>)
    16e6:	2006      	movs	r0, #6
    16e8:	8811      	ldrh	r1, [r2, #0]
    16ea:	8822      	ldrh	r2, [r4, #0]
    16ec:	1889      	adds	r1, r1, r2
    16ee:	4a35      	ldr	r2, [pc, #212]	; (17c4 <main+0xc24>)
    16f0:	f7fe fd98 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                                mem_temp_len++;
    16f4:	8823      	ldrh	r3, [r4, #0]
    16f6:	3301      	adds	r3, #1
    16f8:	8023      	strh	r3, [r4, #0]
                            }

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
    16fa:	4b49      	ldr	r3, [pc, #292]	; (1820 <main+0xc80>)
    16fc:	20ea      	movs	r0, #234	; 0xea
    16fe:	6819      	ldr	r1, [r3, #0]
    1700:	f7fe fd42 	bl	188 <mbus_write_message32>
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
    1704:	2196      	movs	r1, #150	; 0x96
    1706:	2000      	movs	r0, #0
    1708:	0089      	lsls	r1, r1, #2
    170a:	f7ff f811 	bl	730 <set_next_time>
                        }

			xo_is_day = xo_check_is_day();
    170e:	f7ff f82f 	bl	770 <xo_check_is_day>
    1712:	4c44      	ldr	r4, [pc, #272]	; (1824 <main+0xc84>)

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    1714:	4b24      	ldr	r3, [pc, #144]	; (17a8 <main+0xc08>)

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
                        }

			xo_is_day = xo_check_is_day();
    1716:	7020      	strb	r0, [r4, #0]

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    1718:	781a      	ldrb	r2, [r3, #0]
    171a:	2a02      	cmp	r2, #2
    171c:	d000      	beq.n	1720 <main+0xb80>
    171e:	e0ae      	b.n	187e <main+0xcde>
                            lnt_start_meas = 0;
    1720:	2200      	movs	r2, #0
    1722:	701a      	strb	r2, [r3, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
    1724:	4e3a      	ldr	r6, [pc, #232]	; (1810 <main+0xc70>)
    1726:	4b39      	ldr	r3, [pc, #228]	; (180c <main+0xc6c>)
    1728:	4d21      	ldr	r5, [pc, #132]	; (17b0 <main+0xc10>)
    172a:	8819      	ldrh	r1, [r3, #0]
    172c:	8833      	ldrh	r3, [r6, #0]
    172e:	2006      	movs	r0, #6
    1730:	18c9      	adds	r1, r1, r3
    1732:	1c2a      	adds	r2, r5, #0
    1734:	2301      	movs	r3, #1
    1736:	f7fe fd75 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                            mem_light_len += 2;
    173a:	8833      	ldrh	r3, [r6, #0]
    173c:	3302      	adds	r3, #2
    173e:	8033      	strh	r3, [r6, #0]

                            if(xo_is_day) {
    1740:	7823      	ldrb	r3, [r4, #0]
    1742:	2b00      	cmp	r3, #0
    1744:	d100      	bne.n	1748 <main+0xba8>
    1746:	e0ac      	b.n	18a2 <main+0xd02>
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    1748:	4b39      	ldr	r3, [pc, #228]	; (1830 <main+0xc90>)
    174a:	6818      	ldr	r0, [r3, #0]
    174c:	6859      	ldr	r1, [r3, #4]
    174e:	682a      	ldr	r2, [r5, #0]
    1750:	686b      	ldr	r3, [r5, #4]
    1752:	4299      	cmp	r1, r3
    1754:	d815      	bhi.n	1782 <main+0xbe2>
    1756:	d101      	bne.n	175c <main+0xbbc>
    1758:	4290      	cmp	r0, r2
    175a:	d812      	bhi.n	1782 <main+0xbe2>
    175c:	2100      	movs	r1, #0
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    175e:	4835      	ldr	r0, [pc, #212]	; (1834 <main+0xc94>)
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    1760:	4c13      	ldr	r4, [pc, #76]	; (17b0 <main+0xc10>)
    1762:	4d35      	ldr	r5, [pc, #212]	; (1838 <main+0xc98>)
    1764:	1c0e      	adds	r6, r1, #0
    1766:	e06c      	b.n	1842 <main+0xca2>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1768:	004f      	lsls	r7, r1, #1

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    176a:	682a      	ldr	r2, [r5, #0]
    176c:	686b      	ldr	r3, [r5, #4]
    176e:	5bbf      	ldrh	r7, [r7, r6]
    1770:	2b00      	cmp	r3, #0
    1772:	d101      	bne.n	1778 <main+0xbd8>
    1774:	42ba      	cmp	r2, r7
    1776:	d902      	bls.n	177e <main+0xbde>
                lnt_cur_level = i + 1;
    1778:	3101      	adds	r1, #1
    177a:	7021      	strb	r1, [r4, #0]
    177c:	e064      	b.n	1848 <main+0xca8>
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
    177e:	3901      	subs	r1, #1
    1780:	e003      	b.n	178a <main+0xbea>
    1782:	482c      	ldr	r0, [pc, #176]	; (1834 <main+0xc94>)
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    1784:	4d0a      	ldr	r5, [pc, #40]	; (17b0 <main+0xc10>)
    1786:	4e2d      	ldr	r6, [pc, #180]	; (183c <main+0xc9c>)
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    1788:	2102      	movs	r1, #2
        for(i = 2; i >= lnt_cur_level; i--) {
    178a:	7803      	ldrb	r3, [r0, #0]
    178c:	1c04      	adds	r4, r0, #0
    178e:	4299      	cmp	r1, r3
    1790:	daea      	bge.n	1768 <main+0xbc8>
    1792:	e059      	b.n	1848 <main+0xca8>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1794:	004f      	lsls	r7, r1, #1
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    1796:	6822      	ldr	r2, [r4, #0]
    1798:	6863      	ldr	r3, [r4, #4]
    179a:	5b7f      	ldrh	r7, [r7, r5]
    179c:	429e      	cmp	r6, r3
    179e:	d14f      	bne.n	1840 <main+0xca0>
    17a0:	4297      	cmp	r7, r2
    17a2:	d94d      	bls.n	1840 <main+0xca0>
                lnt_cur_level = i;
    17a4:	7001      	strb	r1, [r0, #0]
    17a6:	e04f      	b.n	1848 <main+0xca8>
    17a8:	00001ce4 	.word	0x00001ce4
    17ac:	a0000004 	.word	0xa0000004
    17b0:	00001cb0 	.word	0x00001cb0
    17b4:	00001bf8 	.word	0x00001bf8
    17b8:	00002710 	.word	0x00002710
    17bc:	00001c96 	.word	0x00001c96
    17c0:	00001bf4 	.word	0x00001bf4
    17c4:	00001c98 	.word	0x00001c98
    17c8:	00000257 	.word	0x00000257
    17cc:	00001cad 	.word	0x00001cad
    17d0:	00001c7a 	.word	0x00001c7a
    17d4:	00001c88 	.word	0x00001c88
    17d8:	00001c92 	.word	0x00001c92
    17dc:	00001cd0 	.word	0x00001cd0
    17e0:	00001cdc 	.word	0x00001cdc
    17e4:	00001cb8 	.word	0x00001cb8
    17e8:	00001c9c 	.word	0x00001c9c
    17ec:	00001ce5 	.word	0x00001ce5
    17f0:	00001b78 	.word	0x00001b78
    17f4:	00001b70 	.word	0x00001b70
    17f8:	00001c60 	.word	0x00001c60
    17fc:	00001c94 	.word	0x00001c94
    1800:	00001cac 	.word	0x00001cac
    1804:	00001b58 	.word	0x00001b58
    1808:	00001c90 	.word	0x00001c90
    180c:	00001c66 	.word	0x00001c66
    1810:	00001caa 	.word	0x00001caa
    1814:	00001ca8 	.word	0x00001ca8
    1818:	00001c78 	.word	0x00001c78
    181c:	00001c84 	.word	0x00001c84
    1820:	00001cbc 	.word	0x00001cbc
    1824:	00001c89 	.word	0x00001c89
    1828:	00001cae 	.word	0x00001cae
    182c:	0000dead 	.word	0x0000dead
    1830:	00001c70 	.word	0x00001c70
    1834:	00001c68 	.word	0x00001c68
    1838:	00001b44 	.word	0x00001b44
    183c:	00001bb0 	.word	0x00001bb0
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    1840:	3101      	adds	r1, #1
    1842:	7803      	ldrb	r3, [r0, #0]
    1844:	4299      	cmp	r1, r3
    1846:	dba5      	blt.n	1794 <main+0xbf4>
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    1848:	49a2      	ldr	r1, [pc, #648]	; (1ad4 <main+0xf34>)
    184a:	4ba3      	ldr	r3, [pc, #652]	; (1ad8 <main+0xf38>)
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    184c:	4da3      	ldr	r5, [pc, #652]	; (1adc <main+0xf3c>)
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    184e:	681a      	ldr	r2, [r3, #0]
    1850:	685b      	ldr	r3, [r3, #4]
    1852:	600a      	str	r2, [r1, #0]
    1854:	604b      	str	r3, [r1, #4]
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    1856:	782b      	ldrb	r3, [r5, #0]
    1858:	4ca1      	ldr	r4, [pc, #644]	; (1ae0 <main+0xf40>)
    185a:	005b      	lsls	r3, r3, #1
    185c:	5b19      	ldrh	r1, [r3, r4]
    185e:	20df      	movs	r0, #223	; 0xdf
    1860:	f7fe fc92 	bl	188 <mbus_write_message32>
    return LNT_INTERVAL[lnt_cur_level];
    1864:	782b      	ldrb	r3, [r5, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    1866:	2001      	movs	r0, #1
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    return LNT_INTERVAL[lnt_cur_level];
    1868:	005b      	lsls	r3, r3, #1
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    186a:	5b19      	ldrh	r1, [r3, r4]
    186c:	f7fe ff60 	bl	730 <set_next_time>
				mbus_write_message32(0xEB, LNT_INTERVAL[lnt_cur_level]);
    1870:	782b      	ldrb	r3, [r5, #0]
    1872:	20eb      	movs	r0, #235	; 0xeb
    1874:	005b      	lsls	r3, r3, #1
    1876:	5b19      	ldrh	r1, [r3, r4]
    1878:	f7fe fc86 	bl	188 <mbus_write_message32>
    187c:	e011      	b.n	18a2 <main+0xd02>
                            }
                        }
			else if(xot_timer_list[START_LNT] == 0xFFFFFFFF) {
    187e:	4a99      	ldr	r2, [pc, #612]	; (1ae4 <main+0xf44>)
    1880:	6851      	ldr	r1, [r2, #4]
    1882:	3101      	adds	r1, #1
    1884:	d101      	bne.n	188a <main+0xcea>
                            xot_timer_list[START_LNT] = 0;
    1886:	2100      	movs	r1, #0
    1888:	e008      	b.n	189c <main+0xcfc>
                            lnt_start_meas = 1;
                        }

			else if(!xo_last_is_day && xo_is_day) {
    188a:	4a97      	ldr	r2, [pc, #604]	; (1ae8 <main+0xf48>)
    188c:	7812      	ldrb	r2, [r2, #0]
    188e:	2a00      	cmp	r2, #0
    1890:	d107      	bne.n	18a2 <main+0xd02>
    1892:	7822      	ldrb	r2, [r4, #0]
    1894:	2a00      	cmp	r2, #0
    1896:	d004      	beq.n	18a2 <main+0xd02>
			    // set LNT last timer to SNT current timer for synchronization
			    xot_last_timer_list[START_LNT] = xot_last_timer_list[RUN_SNT];
    1898:	4a94      	ldr	r2, [pc, #592]	; (1aec <main+0xf4c>)
    189a:	6811      	ldr	r1, [r2, #0]
    189c:	6051      	str	r1, [r2, #4]
			    lnt_start_meas = 1;
    189e:	2201      	movs	r2, #1
    18a0:	701a      	strb	r2, [r3, #0]
			}

			xo_last_is_day = xo_is_day;
    18a2:	4b93      	ldr	r3, [pc, #588]	; (1af0 <main+0xf50>)
    18a4:	781a      	ldrb	r2, [r3, #0]
    18a6:	4b90      	ldr	r3, [pc, #576]	; (1ae8 <main+0xf48>)
    18a8:	701a      	strb	r2, [r3, #0]
    18aa:	e087      	b.n	19bc <main+0xe1c>
                    }
                }

		else if(goc_state == 3) {
    18ac:	2803      	cmp	r0, #3
    18ae:	d000      	beq.n	18b2 <main+0xd12>
    18b0:	e084      	b.n	19bc <main+0xe1c>
                    // SEND RADIO
                    if(xot_timer_list[SEND_RAD] == 0xFFFFFFFF) {
    18b2:	4b8c      	ldr	r3, [pc, #560]	; (1ae4 <main+0xf44>)
    18b4:	689b      	ldr	r3, [r3, #8]
    18b6:	3301      	adds	r3, #1
    18b8:	d000      	beq.n	18bc <main+0xd1c>
    18ba:	e07a      	b.n	19b2 <main+0xe12>

			pmu_setting_temp_based(1);
    18bc:	2001      	movs	r0, #1
    18be:	f7fe fd35 	bl	32c <pmu_setting_temp_based>

                        if(mrr_send_enable && xo_check_is_day()) {
    18c2:	4b8c      	ldr	r3, [pc, #560]	; (1af4 <main+0xf54>)
    18c4:	781b      	ldrb	r3, [r3, #0]
    18c6:	2b00      	cmp	r3, #0
    18c8:	d073      	beq.n	19b2 <main+0xe12>
    18ca:	f7fe ff51 	bl	770 <xo_check_is_day>
    18ce:	2800      	cmp	r0, #0
    18d0:	d06f      	beq.n	19b2 <main+0xe12>
                            // send beacon
                            reset_radio_data_arr();
    18d2:	f7fe fcd7 	bl	284 <reset_radio_data_arr>
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    18d6:	4a88      	ldr	r2, [pc, #544]	; (1af8 <main+0xf58>)
    18d8:	4b88      	ldr	r3, [pc, #544]	; (1afc <main+0xf5c>)
                            radio_data_arr[1] = snt_sys_temp_code;

                            mrr_send_radio_data(0);
    18da:	2000      	movs	r0, #0
			pmu_setting_temp_based(1);

                        if(mrr_send_enable && xo_check_is_day()) {
                            // send beacon
                            reset_radio_data_arr();
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    18dc:	781b      	ldrb	r3, [r3, #0]
    18de:	8811      	ldrh	r1, [r2, #0]
    18e0:	22dd      	movs	r2, #221	; 0xdd
    18e2:	0612      	lsls	r2, r2, #24
    18e4:	430a      	orrs	r2, r1
    18e6:	041b      	lsls	r3, r3, #16
    18e8:	431a      	orrs	r2, r3
    18ea:	4b85      	ldr	r3, [pc, #532]	; (1b00 <main+0xf60>)
    18ec:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = snt_sys_temp_code;
    18ee:	4a85      	ldr	r2, [pc, #532]	; (1b04 <main+0xf64>)
    18f0:	6812      	ldr	r2, [r2, #0]
    18f2:	605a      	str	r2, [r3, #4]

                            mrr_send_radio_data(0);
    18f4:	f7fe ff96 	bl	824 <mrr_send_radio_data>

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
    18f8:	4b83      	ldr	r3, [pc, #524]	; (1b08 <main+0xf68>)
    18fa:	781a      	ldrb	r2, [r3, #0]
    18fc:	3201      	adds	r2, #1
    18fe:	b2d2      	uxtb	r2, r2
    1900:	701a      	strb	r2, [r3, #0]
    1902:	2a05      	cmp	r2, #5
    1904:	d80f      	bhi.n	1926 <main+0xd86>
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    1906:	4c7d      	ldr	r4, [pc, #500]	; (1afc <main+0xf5c>)
    1908:	4b7d      	ldr	r3, [pc, #500]	; (1b00 <main+0xf60>)
    190a:	7822      	ldrb	r2, [r4, #0]
                            radio_data_arr[1] = radio_beacon_counter;
                            radio_data_arr[2] = 0xFEED;

                            mrr_send_radio_data(1);
    190c:	2001      	movs	r0, #1
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    190e:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = radio_beacon_counter;
    1910:	4a7d      	ldr	r2, [pc, #500]	; (1b08 <main+0xf68>)
    1912:	7812      	ldrb	r2, [r2, #0]
    1914:	605a      	str	r2, [r3, #4]
                            radio_data_arr[2] = 0xFEED;
    1916:	4a7d      	ldr	r2, [pc, #500]	; (1b0c <main+0xf6c>)
    1918:	609a      	str	r2, [r3, #8]

                            mrr_send_radio_data(1);
    191a:	f7fe ff83 	bl	824 <mrr_send_radio_data>

                            radio_counter++;
    191e:	7823      	ldrb	r3, [r4, #0]
    1920:	3301      	adds	r3, #1
    1922:	7023      	strb	r3, [r4, #0]
    1924:	e045      	b.n	19b2 <main+0xe12>

                            mrr_send_radio_data(0);

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
    1926:	2400      	movs	r4, #0
    1928:	701c      	strb	r4, [r3, #0]
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
    192a:	4b79      	ldr	r3, [pc, #484]	; (1b10 <main+0xf70>)
    192c:	20b0      	movs	r0, #176	; 0xb0
    192e:	8819      	ldrh	r1, [r3, #0]
    1930:	f7fe fc2a 	bl	188 <mbus_write_message32>
                                for(i = 0; i < mem_light_len; i += 2) {
    1934:	e016      	b.n	1964 <main+0xdc4>
                                    reset_radio_data_arr();
    1936:	f7fe fca5 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    193a:	f7fe fc1f 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
    193e:	4b75      	ldr	r3, [pc, #468]	; (1b14 <main+0xf74>)
    1940:	4d6f      	ldr	r5, [pc, #444]	; (1b00 <main+0xf60>)
    1942:	8819      	ldrh	r1, [r3, #0]
    1944:	2201      	movs	r2, #1
    1946:	1909      	adds	r1, r1, r4
    1948:	9200      	str	r2, [sp, #0]
    194a:	2006      	movs	r0, #6
    194c:	1c2b      	adds	r3, r5, #0
    194e:	f7fe fc83 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    1952:	f7fe fc0d 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    1956:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1958:	2000      	movs	r0, #0
                                for(i = 0; i < mem_light_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    195a:	b29b      	uxth	r3, r3
    195c:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    195e:	f7fe ff61 	bl	824 <mrr_send_radio_data>
                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
                                for(i = 0; i < mem_light_len; i += 2) {
    1962:	3402      	adds	r4, #2
    1964:	4b6a      	ldr	r3, [pc, #424]	; (1b10 <main+0xf70>)
    1966:	881b      	ldrh	r3, [r3, #0]
    1968:	429c      	cmp	r4, r3
    196a:	dbe4      	blt.n	1936 <main+0xd96>
				    radio_data_arr[2] &= 0x0000FFFF;

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
    196c:	4b6a      	ldr	r3, [pc, #424]	; (1b18 <main+0xf78>)
    196e:	20b1      	movs	r0, #177	; 0xb1
    1970:	8819      	ldrh	r1, [r3, #0]
    1972:	f7fe fc09 	bl	188 <mbus_write_message32>
				for(i = 0; i < mem_temp_len; i += 2) {
    1976:	2400      	movs	r4, #0
    1978:	e016      	b.n	19a8 <main+0xe08>
                                    reset_radio_data_arr();
    197a:	f7fe fc83 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    197e:	f7fe fbfd 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
    1982:	4b66      	ldr	r3, [pc, #408]	; (1b1c <main+0xf7c>)
    1984:	4d5e      	ldr	r5, [pc, #376]	; (1b00 <main+0xf60>)
    1986:	8819      	ldrh	r1, [r3, #0]
    1988:	2201      	movs	r2, #1
    198a:	1909      	adds	r1, r1, r4
    198c:	9200      	str	r2, [sp, #0]
    198e:	2006      	movs	r0, #6
    1990:	1c2b      	adds	r3, r5, #0
    1992:	f7fe fc61 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    1996:	f7fe fbeb 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    199a:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    199c:	2000      	movs	r0, #0
				for(i = 0; i < mem_temp_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    199e:	b29b      	uxth	r3, r3
    19a0:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    19a2:	f7fe ff3f 	bl	824 <mrr_send_radio_data>

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
				for(i = 0; i < mem_temp_len; i += 2) {
    19a6:	3402      	adds	r4, #2
    19a8:	4b5b      	ldr	r3, [pc, #364]	; (1b18 <main+0xf78>)
    19aa:	881b      	ldrh	r3, [r3, #0]
    19ac:	429c      	cmp	r4, r3
    19ae:	dbe4      	blt.n	197a <main+0xdda>
    19b0:	e7a9      	b.n	1906 <main+0xd66>

                            radio_counter++;
                        }
		    }

                    set_next_time(SEND_RAD, 600); // FIXME: set to 600
    19b2:	2002      	movs	r0, #2
    19b4:	2196      	movs	r1, #150	; 0x96
    19b6:	4081      	lsls	r1, r0
    19b8:	f7fe feba 	bl	730 <set_next_time>
                }
            }
        }
    } while(sys_run_continuous);
    19bc:	4b58      	ldr	r3, [pc, #352]	; (1b20 <main+0xf80>)
    19be:	781c      	ldrb	r4, [r3, #0]
    19c0:	2c00      	cmp	r4, #0
    19c2:	d000      	beq.n	19c6 <main+0xe26>
    19c4:	e5ab      	b.n	151e <main+0x97e>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    19c6:	f7fe fe55 	bl	674 <update_system_time>
    uint8_t i;
    if(lnt_start_meas == 1) {
    19ca:	4b56      	ldr	r3, [pc, #344]	; (1b24 <main+0xf84>)
    19cc:	781b      	ldrb	r3, [r3, #0]
    19ce:	2b01      	cmp	r3, #1
    19d0:	d103      	bne.n	19da <main+0xe3a>
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    19d2:	4b55      	ldr	r3, [pc, #340]	; (1b28 <main+0xf88>)
    19d4:	681c      	ldr	r4, [r3, #0]
    19d6:	3432      	adds	r4, #50	; 0x32
    19d8:	e00e      	b.n	19f8 <main+0xe58>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    19da:	1c23      	adds	r3, r4, #0
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    19dc:	4a41      	ldr	r2, [pc, #260]	; (1ae4 <main+0xf44>)

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    19de:	2401      	movs	r4, #1
    19e0:	4264      	negs	r4, r4
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    19e2:	0099      	lsls	r1, r3, #2
    19e4:	5888      	ldr	r0, [r1, r2]
    19e6:	2800      	cmp	r0, #0
    19e8:	d003      	beq.n	19f2 <main+0xe52>
    19ea:	5888      	ldr	r0, [r1, r2]
    19ec:	42a0      	cmp	r0, r4
    19ee:	d800      	bhi.n	19f2 <main+0xe52>
                min_time = xot_timer_list[i];
    19f0:	588c      	ldr	r4, [r1, r2]
    19f2:	3301      	adds	r3, #1
    uint8_t i;
    if(lnt_start_meas == 1) {
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    19f4:	2b03      	cmp	r3, #3
    19f6:	d1f4      	bne.n	19e2 <main+0xe42>
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    19f8:	1c63      	adds	r3, r4, #1
    19fa:	d066      	beq.n	1aca <main+0xf2a>
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    19fc:	2001      	movs	r0, #1
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    19fe:	4a39      	ldr	r2, [pc, #228]	; (1ae4 <main+0xf44>)
                xot_last_timer_list[i] = xot_timer_list[i];
    1a00:	493a      	ldr	r1, [pc, #232]	; (1aec <main+0xf4c>)
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    1a02:	2500      	movs	r5, #0
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    1a04:	4240      	negs	r0, r0
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1a06:	00ab      	lsls	r3, r5, #2
    1a08:	589e      	ldr	r6, [r3, r2]
    1a0a:	2e00      	cmp	r6, #0
    1a0c:	d005      	beq.n	1a1a <main+0xe7a>
    1a0e:	589e      	ldr	r6, [r3, r2]
    1a10:	42a6      	cmp	r6, r4
    1a12:	d802      	bhi.n	1a1a <main+0xe7a>
                xot_last_timer_list[i] = xot_timer_list[i];
    1a14:	589e      	ldr	r6, [r3, r2]
    1a16:	505e      	str	r6, [r3, r1]
                xot_timer_list[i] = 0xFFFFFFFF;
    1a18:	5098      	str	r0, [r3, r2]
    1a1a:	3501      	adds	r5, #1
        }
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1a1c:	2d03      	cmp	r5, #3
    1a1e:	d1f2      	bne.n	1a06 <main+0xe66>
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
}

static void set_lnt_timer(uint32_t end_time) {
    mbus_write_message32(0xCE, end_time);
    1a20:	20ce      	movs	r0, #206	; 0xce
    1a22:	1c21      	adds	r1, r4, #0
    1a24:	f7fe fbb0 	bl	188 <mbus_write_message32>
    projected_end_time = end_time << XO_TO_SEC_SHIFT;
    1a28:	4a40      	ldr	r2, [pc, #256]	; (1b2c <main+0xf8c>)
    1a2a:	02a3      	lsls	r3, r4, #10
    1a2c:	6013      	str	r3, [r2, #0]

    if(end_time <= xo_sys_time_in_sec) {
    1a2e:	4a3e      	ldr	r2, [pc, #248]	; (1b28 <main+0xf88>)
    1a30:	6812      	ldr	r2, [r2, #0]
    1a32:	4294      	cmp	r4, r2
    1a34:	d805      	bhi.n	1a42 <main+0xea2>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
    1a36:	20af      	movs	r0, #175	; 0xaf
    1a38:	2100      	movs	r1, #0
    1a3a:	f7fe fba5 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
    1a3e:	f7fe fd55 	bl	4ec <operation_sleep_notimer>

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a42:	4a3b      	ldr	r2, [pc, #236]	; (1b30 <main+0xf90>)
    uint32_t val = temp >> (MPLIER_SHIFT + XO_TO_SEC_SHIFT - 2);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1a44:	1c28      	adds	r0, r5, #0

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a46:	6811      	ldr	r1, [r2, #0]
    1a48:	4a3a      	ldr	r2, [pc, #232]	; (1b34 <main+0xf94>)
    1a4a:	1a5b      	subs	r3, r3, r1
    1a4c:	7811      	ldrb	r1, [r2, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a4e:	2640      	movs	r6, #64	; 0x40

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a50:	4359      	muls	r1, r3
    uint32_t val = temp >> (MPLIER_SHIFT + XO_TO_SEC_SHIFT - 2);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    1a52:	4b39      	ldr	r3, [pc, #228]	; (1b38 <main+0xf98>)
    1a54:	0b89      	lsrs	r1, r1, #14
    1a56:	681a      	ldr	r2, [r3, #0]
    1a58:	0e12      	lsrs	r2, r2, #24
    1a5a:	0612      	lsls	r2, r2, #24
    1a5c:	430a      	orrs	r2, r1
    1a5e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1a60:	681a      	ldr	r2, [r3, #0]
    1a62:	1c29      	adds	r1, r5, #0
    1a64:	f7fe fbd1 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1a68:	4c34      	ldr	r4, [pc, #208]	; (1b3c <main+0xf9c>)
    1a6a:	2208      	movs	r2, #8
    1a6c:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a6e:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1a70:	4393      	bics	r3, r2
    1a72:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    1a74:	7823      	ldrb	r3, [r4, #0]
    1a76:	2204      	movs	r2, #4
    1a78:	4313      	orrs	r3, r2
    1a7a:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a7c:	6822      	ldr	r2, [r4, #0]
    1a7e:	1c28      	adds	r0, r5, #0
    1a80:	f7fe fbc3 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1a84:	20fa      	movs	r0, #250	; 0xfa
    1a86:	0080      	lsls	r0, r0, #2
    1a88:	f7fe fb0d 	bl	a6 <delay>
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    1a8c:	7823      	ldrb	r3, [r4, #0]
    1a8e:	2210      	movs	r2, #16
    1a90:	4313      	orrs	r3, r2
    1a92:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a94:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1a96:	2220      	movs	r2, #32
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a98:	43b3      	bics	r3, r6
    1a9a:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1a9c:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a9e:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1aa0:	4393      	bics	r3, r2
    1aa2:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1aa4:	6822      	ldr	r2, [r4, #0]
    1aa6:	1c28      	adds	r0, r5, #0
    1aa8:	f7fe fbaf 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1aac:	20fa      	movs	r0, #250	; 0xfa
    1aae:	0080      	lsls	r0, r0, #2
    1ab0:	f7fe faf9 	bl	a6 <delay>

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1ab4:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1ab6:	1c28      	adds	r0, r5, #0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1ab8:	431e      	orrs	r6, r3
    1aba:	7026      	strb	r6, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1abc:	6822      	ldr	r2, [r4, #0]
    1abe:	2100      	movs	r1, #0
    1ac0:	f7fe fba3 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1ac4:	481e      	ldr	r0, [pc, #120]	; (1b40 <main+0xfa0>)
    1ac6:	f7fe faee 	bl	a6 <delay>
	    }
	}
	set_lnt_timer(min_time);
    }

    pmu_setting_temp_based(2);
    1aca:	2002      	movs	r0, #2
    1acc:	f7fe fc2e 	bl	32c <pmu_setting_temp_based>
    operation_sleep();
    1ad0:	f7fe fcfc 	bl	4cc <operation_sleep>
    1ad4:	00001c70 	.word	0x00001c70
    1ad8:	00001cb0 	.word	0x00001cb0
    1adc:	00001c68 	.word	0x00001c68
    1ae0:	00001b4a 	.word	0x00001b4a
    1ae4:	00001cbc 	.word	0x00001cbc
    1ae8:	00001cae 	.word	0x00001cae
    1aec:	00001c50 	.word	0x00001c50
    1af0:	00001c89 	.word	0x00001c89
    1af4:	00001bf4 	.word	0x00001bf4
    1af8:	00001c96 	.word	0x00001c96
    1afc:	00001c90 	.word	0x00001c90
    1b00:	00001c9c 	.word	0x00001c9c
    1b04:	00001c98 	.word	0x00001c98
    1b08:	00001cac 	.word	0x00001cac
    1b0c:	0000feed 	.word	0x0000feed
    1b10:	00001caa 	.word	0x00001caa
    1b14:	00001c66 	.word	0x00001c66
    1b18:	00001c78 	.word	0x00001c78
    1b1c:	00001ca8 	.word	0x00001ca8
    1b20:	00001cad 	.word	0x00001cad
    1b24:	00001ce4 	.word	0x00001ce4
    1b28:	00001c84 	.word	0x00001c84
    1b2c:	00001cd8 	.word	0x00001cd8
    1b30:	00001c60 	.word	0x00001c60
    1b34:	00001c34 	.word	0x00001c34
    1b38:	00001c04 	.word	0x00001c04
    1b3c:	00001bf8 	.word	0x00001bf8
    1b40:	00002710 	.word	0x00002710
