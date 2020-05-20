
mbc_code_v4_battery_draw_test/mbc_code_v4_battery_draw_test.elf:     file format elf32-littlearm


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
  40:	00000b85 	.word	0x00000b85
  44:	00000000 	.word	0x00000000
  48:	00000b91 	.word	0x00000b91
  4c:	00000ba9 	.word	0x00000ba9
	...
  60:	00000bdd 	.word	0x00000bdd
  64:	00000bed 	.word	0x00000bed
  68:	00000bfd 	.word	0x00000bfd
  6c:	00000c0d 	.word	0x00000c0d
	...
  8c:	00000bc9 	.word	0x00000bc9

00000090 <hang>:
  90:	e7fe      	b.n	90 <hang>
	...

000000a0 <_start>:
  a0:	f000 fdbc 	bl	c1c <main>
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

Disassembly of section .text.unlikely.reset_radio_data_arr:

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
 290:	00001bcc 	.word	0x00001bcc

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
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
*/
static void pmu_set_active_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 2ae:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2b0:	25c0      	movs	r5, #192	; 0xc0
                 (r <<  9) |    // frequency multiplier r
 2b2:	0240      	lsls	r0, r0, #9
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2b4:	022d      	lsls	r5, r5, #8
 2b6:	4305      	orrs	r5, r0
                 (r <<  9) |    // frequency multiplier r
 2b8:	4315      	orrs	r5, r2
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 2ba:	015e      	lsls	r6, r3, #5
 2bc:	432e      	orrs	r6, r5
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2be:	9001      	str	r0, [sp, #4]
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
*/
static void pmu_set_active_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 2c0:	1c0f      	adds	r7, r1, #0
    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2c2:	2016      	movs	r0, #22
 2c4:	1c31      	adds	r1, r6, #0
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
*/
static void pmu_set_active_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 2c6:	1c14      	adds	r4, r2, #0
    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2c8:	f7ff ffe4 	bl	294 <pmu_reg_write>
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2cc:	1c31      	adds	r1, r6, #0
 2ce:	2016      	movs	r0, #22
 2d0:	f7ff ffe0 	bl	294 <pmu_reg_write>
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 2d4:	017f      	lsls	r7, r7, #5
 2d6:	1c29      	adds	r1, r5, #0
 2d8:	4339      	orrs	r1, r7
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
 2da:	2018      	movs	r0, #24
 2dc:	f7ff ffda 	bl	294 <pmu_reg_write>

    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 2e0:	9901      	ldr	r1, [sp, #4]
                 (base)));      // floor frequency base (0-63)

    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2e2:	4327      	orrs	r7, r4
                 (l <<  5) |    // frequency multiplier l
 2e4:	4339      	orrs	r1, r7
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1a: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 2e6:	201a      	movs	r0, #26
 2e8:	f7ff ffd4 	bl	294 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
 2ec:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.radio_power_off:

000002f0 <radio_power_off>:
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    delay(MBUS_DELAY*5); // Freq stab

}

static void radio_power_off() {
 2f0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 2f2:	4c2c      	ldr	r4, [pc, #176]	; (3a4 <radio_power_off+0xb4>)
 2f4:	2601      	movs	r6, #1
 2f6:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 2f8:	2002      	movs	r0, #2

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 2fa:	43b3      	bics	r3, r6
 2fc:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 2fe:	6822      	ldr	r2, [r4, #0]
 300:	2100      	movs	r1, #0
 302:	f7ff ff82 	bl	20a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 306:	6823      	ldr	r3, [r4, #0]
 308:	227e      	movs	r2, #126	; 0x7e
 30a:	4393      	bics	r3, r2
 30c:	2220      	movs	r2, #32
 30e:	4313      	orrs	r3, r2
 310:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 312:	6822      	ldr	r2, [r4, #0]
 314:	2002      	movs	r0, #2
 316:	2100      	movs	r1, #0
 318:	f7ff ff77 	bl	20a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 31c:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 31e:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 320:	4333      	orrs	r3, r6
 322:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 324:	6822      	ldr	r2, [r4, #0]
 326:	2100      	movs	r1, #0
 328:	f7ff ff6f 	bl	20a <mbus_remote_register_write>

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 32c:	4b1e      	ldr	r3, [pc, #120]	; (3a8 <radio_power_off+0xb8>)
 32e:	4a1f      	ldr	r2, [pc, #124]	; (3ac <radio_power_off+0xbc>)
 330:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 332:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 334:	400a      	ands	r2, r1
 336:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 338:	681a      	ldr	r2, [r3, #0]
 33a:	2103      	movs	r1, #3
 33c:	f7ff ff65 	bl	20a <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 340:	4b1b      	ldr	r3, [pc, #108]	; (3b0 <radio_power_off+0xc0>)
 342:	2704      	movs	r7, #4
 344:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 346:	2502      	movs	r5, #2

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 348:	43ba      	bics	r2, r7
 34a:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 34c:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 34e:	1c28      	adds	r0, r5, #0
    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 350:	43aa      	bics	r2, r5
 352:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 354:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 356:	2111      	movs	r1, #17
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 358:	4332      	orrs	r2, r6
 35a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 35c:	681a      	ldr	r2, [r3, #0]
 35e:	f7ff ff54 	bl	20a <mbus_remote_register_write>

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 362:	4c14      	ldr	r4, [pc, #80]	; (3b4 <radio_power_off+0xc4>)
 364:	2208      	movs	r2, #8
 366:	6823      	ldr	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 368:	1c28      	adds	r0, r5, #0
    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 36a:	4313      	orrs	r3, r2
 36c:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
 36e:	6823      	ldr	r3, [r4, #0]
 370:	2220      	movs	r2, #32
 372:	4393      	bics	r3, r2
 374:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
 376:	6823      	ldr	r3, [r4, #0]
 378:	2210      	movs	r2, #16
 37a:	4313      	orrs	r3, r2
 37c:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 37e:	1c39      	adds	r1, r7, #0
 380:	6822      	ldr	r2, [r4, #0]
 382:	f7ff ff42 	bl	20a <mbus_remote_register_write>

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 386:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 388:	1c28      	adds	r0, r5, #0
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 38a:	43b3      	bics	r3, r6
 38c:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 38e:	6822      	ldr	r2, [r4, #0]
 390:	1c39      	adds	r1, r7, #0
 392:	f7ff ff3a 	bl	20a <mbus_remote_register_write>

    radio_on = 0;
 396:	4a08      	ldr	r2, [pc, #32]	; (3b8 <radio_power_off+0xc8>)
 398:	2300      	movs	r3, #0
 39a:	7013      	strb	r3, [r2, #0]
    radio_ready = 0;
 39c:	4a07      	ldr	r2, [pc, #28]	; (3bc <radio_power_off+0xcc>)
 39e:	7013      	strb	r3, [r2, #0]

}
 3a0:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 3a2:	46c0      	nop			; (mov r8, r8)
 3a4:	00001b58 	.word	0x00001b58
 3a8:	00001b64 	.word	0x00001b64
 3ac:	ffefffff 	.word	0xffefffff
 3b0:	00001b6c 	.word	0x00001b6c
 3b4:	00001b68 	.word	0x00001b68
 3b8:	00001c08 	.word	0x00001c08
 3bc:	00001b8e 	.word	0x00001b8e

Disassembly of section .text.operation_sleep:

000003c0 <operation_sleep>:

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
 3c0:	b508      	push	{r3, lr}
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;
 3c2:	2200      	movs	r2, #0
 3c4:	238c      	movs	r3, #140	; 0x8c
 3c6:	601a      	str	r2, [r3, #0]

#ifdef USE_MRR
    if(radio_on) {
 3c8:	4b04      	ldr	r3, [pc, #16]	; (3dc <operation_sleep+0x1c>)
 3ca:	781b      	ldrb	r3, [r3, #0]
 3cc:	4293      	cmp	r3, r2
 3ce:	d001      	beq.n	3d4 <operation_sleep+0x14>
    	radio_power_off();
 3d0:	f7ff ff8e 	bl	2f0 <radio_power_off>
    }
#endif

    mbus_sleep_all();
 3d4:	f7ff ff02 	bl	1dc <mbus_sleep_all>
 3d8:	e7fe      	b.n	3d8 <operation_sleep+0x18>
 3da:	46c0      	nop			; (mov r8, r8)
 3dc:	00001c08 	.word	0x00001c08

Disassembly of section .text.operation_sleep_notimer:

000003e0 <operation_sleep_notimer>:
    while(1);
}

static void operation_sleep_notimer( void ) {
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 3e0:	2000      	movs	r0, #0

    mbus_sleep_all();
    while(1);
}

static void operation_sleep_notimer( void ) {
 3e2:	b508      	push	{r3, lr}
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 3e4:	1c01      	adds	r1, r0, #0
 3e6:	1c02      	adds	r2, r0, #0
 3e8:	f7ff fe82 	bl	f0 <set_wakeup_timer>
    set_xo_timer(0, 0, 0, 0);
 3ec:	2000      	movs	r0, #0
 3ee:	1c01      	adds	r1, r0, #0
 3f0:	1c02      	adds	r2, r0, #0
 3f2:	1c03      	adds	r3, r0, #0
 3f4:	f7ff fe92 	bl	11c <set_xo_timer>
    config_timer32(0, 0, 0, 0);
 3f8:	2000      	movs	r0, #0
 3fa:	1c01      	adds	r1, r0, #0
 3fc:	1c02      	adds	r2, r0, #0
 3fe:	1c03      	adds	r3, r0, #0
 400:	f7ff fe5c 	bl	bc <config_timer32>
    // TODO: reset SNT timer
    operation_sleep();
 404:	f7ff ffdc 	bl	3c0 <operation_sleep>

Disassembly of section .text.pmu_set_sleep_clk.constprop.1:

00000408 <pmu_set_sleep_clk.constprop.1>:
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 408:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 40a:	4e0b      	ldr	r6, [pc, #44]	; (438 <pmu_set_sleep_clk.constprop.1+0x30>)
 40c:	0245      	lsls	r5, r0, #9
 40e:	432e      	orrs	r6, r5
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 410:	014c      	lsls	r4, r1, #5
 412:	1c31      	adds	r1, r6, #0
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
 414:	1c17      	adds	r7, r2, #0
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 416:	4321      	orrs	r1, r4
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint8_t r, uint8_t l, uint8_t base, uint8_t l_1p2) {
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 418:	2017      	movs	r0, #23
 41a:	f7ff ff3b 	bl	294 <pmu_reg_write>
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 41e:	0179      	lsls	r1, r7, #5
 420:	4331      	orrs	r1, r6
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
 422:	2015      	movs	r0, #21
 424:	f7ff ff36 	bl	294 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 428:	2101      	movs	r1, #1
 42a:	430d      	orrs	r5, r1
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 42c:	1c29      	adds	r1, r5, #0
 42e:	4321      	orrs	r1, r4
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 430:	2019      	movs	r0, #25
 432:	f7ff ff2f 	bl	294 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)
}
 436:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 438:	0000c001 	.word	0x0000c001

Disassembly of section .text.pmu_setting_temp_based:

0000043c <pmu_setting_temp_based>:
                     (i <<  7) |    // enable override setting [6:0] (1'h0)
                     (ratio)));  // binary converter's conversion ratio (7'h00)
    }
}

static void pmu_setting_temp_based() {
 43c:	b538      	push	{r3, r4, r5, lr}
    mbus_write_message32(0xB7, pmu_setting_state);
 43e:	4c2d      	ldr	r4, [pc, #180]	; (4f4 <pmu_setting_temp_based+0xb8>)
 440:	20b7      	movs	r0, #183	; 0xb7
 442:	6821      	ldr	r1, [r4, #0]
 444:	f7ff fea0 	bl	188 <mbus_write_message32>
    if(pmu_setting_state == PMU_10C) {
 448:	6825      	ldr	r5, [r4, #0]
 44a:	2d02      	cmp	r5, #2
 44c:	d109      	bne.n	462 <pmu_setting_temp_based+0x26>
        pmu_set_active_clk(0xD, 0x2, 0x10, 0x4/*V1P2*/);
 44e:	200d      	movs	r0, #13
 450:	1c29      	adds	r1, r5, #0
 452:	2210      	movs	r2, #16
 454:	2304      	movs	r3, #4
 456:	f7ff ff2a 	bl	2ae <pmu_set_active_clk>
        pmu_set_sleep_clk(0xF, 0x1, 0x1, 0x2/*V1P2*/);
 45a:	200f      	movs	r0, #15
 45c:	2101      	movs	r1, #1
 45e:	1c2a      	adds	r2, r5, #0
 460:	e044      	b.n	4ec <pmu_setting_temp_based+0xb0>
    }
    else if(pmu_setting_state == PMU_20C) {
 462:	6823      	ldr	r3, [r4, #0]
 464:	2b03      	cmp	r3, #3
 466:	d109      	bne.n	47c <pmu_setting_temp_based+0x40>
    	pmu_set_active_clk(0xD, 0x2, 0x0f, 0xf/*V1P2*/);
 468:	220f      	movs	r2, #15
 46a:	200d      	movs	r0, #13
 46c:	2102      	movs	r1, #2
 46e:	1c13      	adds	r3, r2, #0
 470:	f7ff ff1d 	bl	2ae <pmu_set_active_clk>
		pmu_set_sleep_clk(0xF, 0x1, 0x1, 0x2/*V1P2*/);
 474:	200f      	movs	r0, #15
 476:	2101      	movs	r1, #1
 478:	2202      	movs	r2, #2
 47a:	e037      	b.n	4ec <pmu_setting_temp_based+0xb0>
	    //    pmu_set_sleep_low();
    }
    else if(pmu_setting_state == PMU_25C) {
 47c:	6823      	ldr	r3, [r4, #0]
 47e:	2b04      	cmp	r3, #4
 480:	d108      	bne.n	494 <pmu_setting_temp_based+0x58>
        pmu_set_active_clk(0x5, 0x1, 0x10, 0x2/*V1P2*/);
 482:	2005      	movs	r0, #5
 484:	2101      	movs	r1, #1
 486:	2210      	movs	r2, #16
 488:	2302      	movs	r3, #2
 48a:	f7ff ff10 	bl	2ae <pmu_set_active_clk>
        pmu_set_sleep_clk(0x2, 0x1, 0x1, 0x1/*V1P2*/);
 48e:	2002      	movs	r0, #2
 490:	2101      	movs	r1, #1
 492:	e02a      	b.n	4ea <pmu_setting_temp_based+0xae>
        //pmu_set_sleep_low();
    }
    else if(pmu_setting_state == PMU_35C) {
 494:	6823      	ldr	r3, [r4, #0]
 496:	2b05      	cmp	r3, #5
 498:	d109      	bne.n	4ae <pmu_setting_temp_based+0x72>
        pmu_set_active_clk(0x2, 0x1, 0x10, 0x2/*V1P2*/);
 49a:	2002      	movs	r0, #2
 49c:	2101      	movs	r1, #1
 49e:	2210      	movs	r2, #16
 4a0:	1c03      	adds	r3, r0, #0
 4a2:	f7ff ff04 	bl	2ae <pmu_set_active_clk>
        pmu_set_sleep_clk(0x2, 0x0, 0x1, 0x1/*V1P2*/);
 4a6:	2002      	movs	r0, #2
 4a8:	2100      	movs	r1, #0
 4aa:	2201      	movs	r2, #1
 4ac:	e01e      	b.n	4ec <pmu_setting_temp_based+0xb0>
    }
    else if(pmu_setting_state == PMU_55C) {
 4ae:	6823      	ldr	r3, [r4, #0]
 4b0:	2b06      	cmp	r3, #6
 4b2:	d104      	bne.n	4be <pmu_setting_temp_based+0x82>
        pmu_set_active_clk(0x1, 0x0, 0x10, 0x2/*V1P2*/);
 4b4:	2001      	movs	r0, #1
 4b6:	2100      	movs	r1, #0
 4b8:	2210      	movs	r2, #16
 4ba:	2302      	movs	r3, #2
 4bc:	e005      	b.n	4ca <pmu_setting_temp_based+0x8e>
        pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
    }
    else if(pmu_setting_state == PMU_75C) {
 4be:	6822      	ldr	r2, [r4, #0]
 4c0:	2a07      	cmp	r2, #7
 4c2:	d107      	bne.n	4d4 <pmu_setting_temp_based+0x98>
        pmu_set_active_clk(0xA, 0x4, 0x7, 0x8/*V1P2*/);
 4c4:	200a      	movs	r0, #10
 4c6:	2104      	movs	r1, #4
 4c8:	2308      	movs	r3, #8
 4ca:	f7ff fef0 	bl	2ae <pmu_set_active_clk>
        pmu_set_sleep_clk(0x1, 0x1, 0x1, 0x1/*V1P2*/);
 4ce:	2001      	movs	r0, #1
 4d0:	1c01      	adds	r1, r0, #0
 4d2:	e00a      	b.n	4ea <pmu_setting_temp_based+0xae>
    }
    else if(pmu_setting_state == PMU_95C) {
 4d4:	6823      	ldr	r3, [r4, #0]
 4d6:	2b08      	cmp	r3, #8
 4d8:	d10a      	bne.n	4f0 <pmu_setting_temp_based+0xb4>
        pmu_set_active_clk(0x7, 0x2, 0x7, 0x4/*V1P2*/);
 4da:	2007      	movs	r0, #7
 4dc:	2102      	movs	r1, #2
 4de:	1c02      	adds	r2, r0, #0
 4e0:	2304      	movs	r3, #4
 4e2:	f7ff fee4 	bl	2ae <pmu_set_active_clk>
        pmu_set_sleep_clk(0x1, 0x0, 0x1, 0x0/*V1P2*/);
 4e6:	2001      	movs	r0, #1
 4e8:	2100      	movs	r1, #0
 4ea:	1c0a      	adds	r2, r1, #0
 4ec:	f7ff ff8c 	bl	408 <pmu_set_sleep_clk.constprop.1>
    }
}
 4f0:	bd38      	pop	{r3, r4, r5, pc}
 4f2:	46c0      	nop			; (mov r8, r8)
 4f4:	00001bbc 	.word	0x00001bbc

Disassembly of section .text.operation_temp_run:

000004f8 <operation_temp_run>:
//     mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
//     mbus_write_message32(0xCE, end_time - xo_sys_time_in_sec);
// }


static void operation_temp_run() {
 4f8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    if(snt_state == SNT_IDLE) {
 4fa:	4c51      	ldr	r4, [pc, #324]	; (640 <operation_temp_run+0x148>)
 4fc:	7821      	ldrb	r1, [r4, #0]
 4fe:	2900      	cmp	r1, #0
 500:	d10c      	bne.n	51c <operation_temp_run+0x24>
    sntv4_r01.TSNS_RESETn = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void snt_ldo_vref_on() {
    sntv4_r00.LDO_EN_VREF = 1;
 502:	4b50      	ldr	r3, [pc, #320]	; (644 <operation_temp_run+0x14c>)
 504:	2004      	movs	r0, #4
 506:	881a      	ldrh	r2, [r3, #0]
 508:	4302      	orrs	r2, r0
 50a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 50c:	681a      	ldr	r2, [r3, #0]
 50e:	f7ff fe7c 	bl	20a <mbus_remote_register_write>
    if(snt_state == SNT_IDLE) {

        // Turn on snt ldo vref; requires ~30 ms to settle
        // TODo: figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);
 512:	2064      	movs	r0, #100	; 0x64
 514:	f7ff fdc7 	bl	a6 <delay>

        snt_state = SNT_TEMP_LDO;
 518:	2301      	movs	r3, #1
 51a:	7023      	strb	r3, [r4, #0]

    }
    if(snt_state == SNT_TEMP_LDO) {
 51c:	4f48      	ldr	r7, [pc, #288]	; (640 <operation_temp_run+0x148>)
 51e:	783d      	ldrb	r5, [r7, #0]
 520:	2d01      	cmp	r5, #1
 522:	d12e      	bne.n	582 <operation_temp_run+0x8a>
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 524:	4b47      	ldr	r3, [pc, #284]	; (644 <operation_temp_run+0x14c>)
 526:	2602      	movs	r6, #2
 528:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 52a:	2004      	movs	r0, #4
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 52c:	4332      	orrs	r2, r6
 52e:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
 530:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 532:	2100      	movs	r1, #0
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
    sntv4_r00.LDO_EN_LDO  = 1;
 534:	432a      	orrs	r2, r5
 536:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 538:	681a      	ldr	r2, [r3, #0]
 53a:	f7ff fe66 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 53e:	4c42      	ldr	r4, [pc, #264]	; (648 <operation_temp_run+0x150>)
 540:	2208      	movs	r2, #8
 542:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 544:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 546:	4313      	orrs	r3, r2
 548:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 54a:	6822      	ldr	r2, [r4, #0]
 54c:	1c29      	adds	r1, r5, #0
 54e:	f7ff fe5c 	bl	20a <mbus_remote_register_write>
    // Un-powergate analog block
    sntv4_r01.TSNS_EN_SENSOR_LDO = 1;
 552:	8823      	ldrh	r3, [r4, #0]
 554:	2220      	movs	r2, #32
 556:	4313      	orrs	r3, r2
 558:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 55a:	6822      	ldr	r2, [r4, #0]
 55c:	1c29      	adds	r1, r5, #0
 55e:	2004      	movs	r0, #4
 560:	f7ff fe53 	bl	20a <mbus_remote_register_write>

    delay(MBUS_DELAY);
 564:	2064      	movs	r0, #100	; 0x64
 566:	f7ff fd9e 	bl	a6 <delay>

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 56a:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 56c:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    delay(MBUS_DELAY);

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 56e:	43b3      	bics	r3, r6
 570:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 572:	6822      	ldr	r2, [r4, #0]
 574:	1c29      	adds	r1, r5, #0
 576:	f7ff fe48 	bl	20a <mbus_remote_register_write>
        // Power on snt ldo
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);
 57a:	2064      	movs	r0, #100	; 0x64
 57c:	f7ff fd93 	bl	a6 <delay>

        snt_state = SNT_TEMP_START;
 580:	703e      	strb	r6, [r7, #0]
    }
    if(snt_state == SNT_TEMP_START) {
 582:	4d2f      	ldr	r5, [pc, #188]	; (640 <operation_temp_run+0x148>)
 584:	782b      	ldrb	r3, [r5, #0]
 586:	2b02      	cmp	r3, #2
 588:	d11d      	bne.n	5c6 <operation_temp_run+0xce>
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 58a:	4b30      	ldr	r3, [pc, #192]	; (64c <operation_temp_run+0x154>)
 58c:	2400      	movs	r4, #0
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 58e:	20a0      	movs	r0, #160	; 0xa0

        snt_state = SNT_TEMP_START;
    }
    if(snt_state == SNT_TEMP_START) {
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 590:	701c      	strb	r4, [r3, #0]
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 592:	0300      	lsls	r0, r0, #12
 594:	2101      	movs	r1, #1
 596:	1c22      	adds	r2, r4, #0
 598:	1c23      	adds	r3, r4, #0
 59a:	f7ff fd8f 	bl	bc <config_timer32>
/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/

static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
 59e:	482a      	ldr	r0, [pc, #168]	; (648 <operation_temp_run+0x150>)
 5a0:	2101      	movs	r1, #1
 5a2:	8803      	ldrh	r3, [r0, #0]
 5a4:	430b      	orrs	r3, r1
 5a6:	8003      	strh	r3, [r0, #0]
    sntv4_r01.TSNS_EN_IRQ = 1;
 5a8:	8802      	ldrh	r2, [r0, #0]
 5aa:	2380      	movs	r3, #128	; 0x80
 5ac:	408b      	lsls	r3, r1
 5ae:	4313      	orrs	r3, r2
 5b0:	8003      	strh	r3, [r0, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5b2:	6802      	ldr	r2, [r0, #0]
 5b4:	2004      	movs	r0, #4
 5b6:	f7ff fe28 	bl	20a <mbus_remote_register_write>
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or TIMER32
	WFI();
 5ba:	f7ff fd7c 	bl	b6 <WFI>

        // Turn off timer32
        *TIMER32_GO = 0;
 5be:	4b24      	ldr	r3, [pc, #144]	; (650 <operation_temp_run+0x158>)
 5c0:	601c      	str	r4, [r3, #0]

        snt_state = SNT_TEMP_READ;
 5c2:	2303      	movs	r3, #3
 5c4:	702b      	strb	r3, [r5, #0]
    }
    if(snt_state == SNT_TEMP_READ) {
 5c6:	4a1e      	ldr	r2, [pc, #120]	; (640 <operation_temp_run+0x148>)
 5c8:	7813      	ldrb	r3, [r2, #0]
 5ca:	2b03      	cmp	r3, #3
 5cc:	d136      	bne.n	63c <operation_temp_run+0x144>
        if(wfi_timeout_flag) {
 5ce:	4b1f      	ldr	r3, [pc, #124]	; (64c <operation_temp_run+0x154>)
 5d0:	781d      	ldrb	r5, [r3, #0]
 5d2:	1e2e      	subs	r6, r5, #0
 5d4:	d006      	beq.n	5e4 <operation_temp_run+0xec>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 5d6:	2180      	movs	r1, #128	; 0x80
 5d8:	0449      	lsls	r1, r1, #17
 5da:	20af      	movs	r0, #175	; 0xaf
 5dc:	f7ff fdd4 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
 5e0:	f7ff fefe 	bl	3e0 <operation_sleep_notimer>
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 5e4:	23a0      	movs	r3, #160	; 0xa0
 5e6:	061b      	lsls	r3, r3, #24
 5e8:	681a      	ldr	r2, [r3, #0]
 5ea:	4b1a      	ldr	r3, [pc, #104]	; (654 <operation_temp_run+0x15c>)
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5ec:	2401      	movs	r4, #1
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 5ee:	601a      	str	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5f0:	4b15      	ldr	r3, [pc, #84]	; (648 <operation_temp_run+0x150>)
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5f2:	2108      	movs	r1, #8
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5f4:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 5f6:	2702      	movs	r7, #2
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5f8:	43a2      	bics	r2, r4
 5fa:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5fc:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5fe:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
 600:	438a      	bics	r2, r1
 602:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
 604:	881a      	ldrh	r2, [r3, #0]
 606:	2120      	movs	r1, #32
 608:	438a      	bics	r2, r1
 60a:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE       = 1;
 60c:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 60e:	1c21      	adds	r1, r4, #0

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 610:	433a      	orrs	r2, r7
 612:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 614:	681a      	ldr	r2, [r3, #0]
 616:	f7ff fdf8 	bl	20a <mbus_remote_register_write>
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 61a:	4b0a      	ldr	r3, [pc, #40]	; (644 <operation_temp_run+0x14c>)
 61c:	2004      	movs	r0, #4
 61e:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
    sntv4_r00.LDO_EN_LDO  = 0;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 620:	1c31      	adds	r1, r6, #0
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 622:	4382      	bics	r2, r0
 624:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
 626:	881a      	ldrh	r2, [r3, #0]
 628:	43ba      	bics	r2, r7
 62a:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 0;
 62c:	881a      	ldrh	r2, [r3, #0]
 62e:	43a2      	bics	r2, r4
 630:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 632:	681a      	ldr	r2, [r3, #0]
 634:	f7ff fde9 	bl	20a <mbus_remote_register_write>
            
            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

            snt_state = SNT_IDLE;
 638:	4b01      	ldr	r3, [pc, #4]	; (640 <operation_temp_run+0x148>)
 63a:	701d      	strb	r5, [r3, #0]
        }
    }
}
 63c:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 63e:	46c0      	nop			; (mov r8, r8)
 640:	00001bb0 	.word	0x00001bb0
 644:	00001b1c 	.word	0x00001b1c
 648:	00001b20 	.word	0x00001b20
 64c:	00001c04 	.word	0x00001c04
 650:	a0001100 	.word	0xa0001100
 654:	00001bc8 	.word	0x00001bc8

Disassembly of section .text.update_system_time:

00000658 <update_system_time>:
    delay(MBUS_DELAY);

    return ((*REG0 & 0xFF) << 24) | (*REG1 & 0xFFFFFF);
}

void update_system_time() {
 658:	b538      	push	{r3, r4, r5, lr}
    uint32_t val = xo_sys_time_in_sec;
 65a:	4b20      	ldr	r3, [pc, #128]	; (6dc <update_system_time+0x84>)
    mbus_write_message32(0xBA, 0x03);

}

static uint32_t get_timer_cnt() {
    if(enumerated != ENUMID) { return 0; }
 65c:	2400      	movs	r4, #0

    return ((*REG0 & 0xFF) << 24) | (*REG1 & 0xFFFFFF);
}

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
 65e:	681d      	ldr	r5, [r3, #0]
    mbus_write_message32(0xBA, 0x03);

}

static uint32_t get_timer_cnt() {
    if(enumerated != ENUMID) { return 0; }
 660:	4b1f      	ldr	r3, [pc, #124]	; (6e0 <update_system_time+0x88>)
 662:	681a      	ldr	r2, [r3, #0]
 664:	4b1f      	ldr	r3, [pc, #124]	; (6e4 <update_system_time+0x8c>)
 666:	429a      	cmp	r2, r3
 668:	d115      	bne.n	696 <update_system_time+0x3e>
    set_halt_until_mbus_trx();
 66a:	f7ff fd87 	bl	17c <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(SNT_ADDR, 0x1B, 0x0, 1);
 66e:	1c22      	adds	r2, r4, #0
 670:	2301      	movs	r3, #1
 672:	2004      	movs	r0, #4
 674:	211b      	movs	r1, #27
 676:	f7ff fdb7 	bl	1e8 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
 67a:	f7ff fd79 	bl	170 <set_halt_until_mbus_tx>

    delay(MBUS_DELAY);
 67e:	2064      	movs	r0, #100	; 0x64
 680:	f7ff fd11 	bl	a6 <delay>

    return ((*REG0 & 0xFF) << 24) | (*REG1 & 0xFFFFFF);
 684:	23a0      	movs	r3, #160	; 0xa0
 686:	4a18      	ldr	r2, [pc, #96]	; (6e8 <update_system_time+0x90>)
 688:	061b      	lsls	r3, r3, #24
 68a:	681b      	ldr	r3, [r3, #0]
 68c:	6814      	ldr	r4, [r2, #0]
 68e:	061b      	lsls	r3, r3, #24
 690:	0224      	lsls	r4, r4, #8
 692:	0a24      	lsrs	r4, r4, #8
 694:	431c      	orrs	r4, r3
}

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
    xo_sys_time = get_timer_cnt();
 696:	4a15      	ldr	r2, [pc, #84]	; (6ec <update_system_time+0x94>)
    xo_sys_time_in_sec = xo_sys_time >> 10;
 698:	4910      	ldr	r1, [pc, #64]	; (6dc <update_system_time+0x84>)
    return ((*REG0 & 0xFF) << 24) | (*REG1 & 0xFFFFFF);
}

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
    xo_sys_time = get_timer_cnt();
 69a:	6014      	str	r4, [r2, #0]
    xo_sys_time_in_sec = xo_sys_time >> 10;
 69c:	6813      	ldr	r3, [r2, #0]
 69e:	0a9b      	lsrs	r3, r3, #10
 6a0:	600b      	str	r3, [r1, #0]
    xo_day_time_in_sec += xo_sys_time_in_sec - val;
 6a2:	4b13      	ldr	r3, [pc, #76]	; (6f0 <update_system_time+0x98>)
 6a4:	6818      	ldr	r0, [r3, #0]
 6a6:	680c      	ldr	r4, [r1, #0]
 6a8:	1820      	adds	r0, r4, r0
 6aa:	1b45      	subs	r5, r0, r5
 6ac:	601d      	str	r5, [r3, #0]
 6ae:	1c0c      	adds	r4, r1, #0

    if(xo_day_time_in_sec >= 86400) {
 6b0:	6818      	ldr	r0, [r3, #0]
 6b2:	4910      	ldr	r1, [pc, #64]	; (6f4 <update_system_time+0x9c>)
 6b4:	4288      	cmp	r0, r1
 6b6:	d903      	bls.n	6c0 <update_system_time+0x68>
        xo_day_time_in_sec -= 86400;
 6b8:	6819      	ldr	r1, [r3, #0]
 6ba:	480f      	ldr	r0, [pc, #60]	; (6f8 <update_system_time+0xa0>)
 6bc:	1809      	adds	r1, r1, r0
 6be:	6019      	str	r1, [r3, #0]
    }

    mbus_write_message32(0xC2, xo_sys_time);
 6c0:	6811      	ldr	r1, [r2, #0]
 6c2:	20c2      	movs	r0, #194	; 0xc2
 6c4:	f7ff fd60 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xC1, xo_sys_time_in_sec);
 6c8:	6821      	ldr	r1, [r4, #0]
 6ca:	20c1      	movs	r0, #193	; 0xc1
 6cc:	f7ff fd5c 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xC0, xo_day_time_in_sec);
 6d0:	4b07      	ldr	r3, [pc, #28]	; (6f0 <update_system_time+0x98>)
 6d2:	20c0      	movs	r0, #192	; 0xc0
 6d4:	6819      	ldr	r1, [r3, #0]
 6d6:	f7ff fd57 	bl	188 <mbus_write_message32>

}
 6da:	bd38      	pop	{r3, r4, r5, pc}
 6dc:	00001bb4 	.word	0x00001bb4
 6e0:	00001bac 	.word	0x00001bac
 6e4:	deadbee1 	.word	0xdeadbee1
 6e8:	a0000004 	.word	0xa0000004
 6ec:	00001b94 	.word	0x00001b94
 6f0:	00001c00 	.word	0x00001c00
 6f4:	0001517f 	.word	0x0001517f
 6f8:	fffeae80 	.word	0xfffeae80

Disassembly of section .text.reset_timers_list:

000006fc <reset_timers_list>:
    return LNT_INTERVAL[lnt_cur_level];
}

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
 6fc:	b508      	push	{r3, lr}
    uint8_t i;
    update_system_time();
 6fe:	f7ff ffab 	bl	658 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
 702:	4b03      	ldr	r3, [pc, #12]	; (710 <reset_timers_list+0x14>)
 704:	2200      	movs	r2, #0
 706:	601a      	str	r2, [r3, #0]
 708:	605a      	str	r2, [r3, #4]
 70a:	609a      	str	r2, [r3, #8]
    }
}
 70c:	bd08      	pop	{r3, pc}
 70e:	46c0      	nop			; (mov r8, r8)
 710:	00001bec 	.word	0x00001bec

Disassembly of section .text.set_next_time:

00000714 <set_next_time>:

static void set_next_time(uint8_t idx, uint16_t step) {
 714:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
 716:	1c06      	adds	r6, r0, #0
 718:	1c0f      	adds	r7, r1, #0
    update_system_time();
 71a:	f7ff ff9d 	bl	658 <update_system_time>
    xot_timer_list[idx] = xot_last_timer_list[idx];
 71e:	4a0a      	ldr	r2, [pc, #40]	; (748 <set_next_time+0x34>)
 720:	00b3      	lsls	r3, r6, #2
 722:	5899      	ldr	r1, [r3, r2]
 724:	4a09      	ldr	r2, [pc, #36]	; (74c <set_next_time+0x38>)
 726:	5099      	str	r1, [r3, r2]
    do {
	mbus_write_message32(0xD3, xot_timer_list[idx]);
 728:	4c08      	ldr	r4, [pc, #32]	; (74c <set_next_time+0x38>)
 72a:	00b5      	lsls	r5, r6, #2
 72c:	5929      	ldr	r1, [r5, r4]
 72e:	20d3      	movs	r0, #211	; 0xd3
 730:	f7ff fd2a 	bl	188 <mbus_write_message32>
        xot_timer_list[idx] += step;
 734:	592b      	ldr	r3, [r5, r4]
 736:	18fb      	adds	r3, r7, r3
 738:	512b      	str	r3, [r5, r4]
    } while(xo_sys_time_in_sec + 5 > xot_timer_list[idx]);    // give some margin of error
 73a:	4b05      	ldr	r3, [pc, #20]	; (750 <set_next_time+0x3c>)
 73c:	681a      	ldr	r2, [r3, #0]
 73e:	592b      	ldr	r3, [r5, r4]
 740:	3205      	adds	r2, #5
 742:	429a      	cmp	r2, r3
 744:	d8f0      	bhi.n	728 <set_next_time+0x14>
}
 746:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 748:	00001b80 	.word	0x00001b80
 74c:	00001bec 	.word	0x00001bec
 750:	00001bb4 	.word	0x00001bb4

Disassembly of section .text.xo_check_is_day:

00000754 <xo_check_is_day>:
    mbus_write_message32(0xC1, xo_sys_time_in_sec);
    mbus_write_message32(0xC0, xo_day_time_in_sec);

}

bool xo_check_is_day() {
 754:	b508      	push	{r3, lr}
    update_system_time();
 756:	f7ff ff7f 	bl	658 <update_system_time>
    return xo_day_time_in_sec >= XO_DAY_START && xo_day_time_in_sec < XO_DAY_END;
 75a:	4a06      	ldr	r2, [pc, #24]	; (774 <xo_check_is_day+0x20>)
 75c:	4906      	ldr	r1, [pc, #24]	; (778 <xo_check_is_day+0x24>)
 75e:	6810      	ldr	r0, [r2, #0]
 760:	2300      	movs	r3, #0
 762:	4288      	cmp	r0, r1
 764:	d903      	bls.n	76e <xo_check_is_day+0x1a>
 766:	6812      	ldr	r2, [r2, #0]
 768:	4904      	ldr	r1, [pc, #16]	; (77c <xo_check_is_day+0x28>)
 76a:	4291      	cmp	r1, r2
 76c:	415b      	adcs	r3, r3
 76e:	2001      	movs	r0, #1
 770:	4018      	ands	r0, r3
}
 772:	bd08      	pop	{r3, pc}
 774:	00001c00 	.word	0x00001c00
 778:	0000464f 	.word	0x0000464f
 77c:	00010b2f 	.word	0x00010b2f

Disassembly of section .text.crcEnc16:

00000780 <crcEnc16>:

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 780:	4b1c      	ldr	r3, [pc, #112]	; (7f4 <crcEnc16+0x74>)

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
{
 782:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 784:	689a      	ldr	r2, [r3, #8]
 786:	685f      	ldr	r7, [r3, #4]
 788:	0412      	lsls	r2, r2, #16
 78a:	0c3f      	lsrs	r7, r7, #16
 78c:	18bf      	adds	r7, r7, r2
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 78e:	685a      	ldr	r2, [r3, #4]
 790:	6819      	ldr	r1, [r3, #0]
 792:	0412      	lsls	r2, r2, #16
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 794:	681c      	ldr	r4, [r3, #0]
    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 796:	0c09      	lsrs	r1, r1, #16
 798:	1889      	adds	r1, r1, r2
    // intialization
    uint32_t i;

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
 79a:	2200      	movs	r2, #0
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 79c:	468c      	mov	ip, r1
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 79e:	0424      	lsls	r4, r4, #16

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 7a0:	1c13      	adds	r3, r2, #0
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 7a2:	b295      	uxth	r5, r2
 7a4:	b229      	sxth	r1, r5
            MSB = 0xffff;
        else
            MSB = 0x0000;
 7a6:	2000      	movs	r0, #0
    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 7a8:	4281      	cmp	r1, r0
 7aa:	da00      	bge.n	7ae <crcEnc16+0x2e>
            MSB = 0xffff;
 7ac:	4812      	ldr	r0, [pc, #72]	; (7f8 <crcEnc16+0x78>)
        else
            MSB = 0x0000;

        if (i < 32)
 7ae:	2b1f      	cmp	r3, #31
 7b0:	d803      	bhi.n	7ba <crcEnc16+0x3a>
            input_bit = ((data2 << i) > 0x7fffffff);
 7b2:	1c39      	adds	r1, r7, #0
 7b4:	4099      	lsls	r1, r3
 7b6:	0fc9      	lsrs	r1, r1, #31
 7b8:	e009      	b.n	7ce <crcEnc16+0x4e>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 7ba:	1c19      	adds	r1, r3, #0
        else
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
 7bc:	2b3f      	cmp	r3, #63	; 0x3f
 7be:	d802      	bhi.n	7c6 <crcEnc16+0x46>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 7c0:	3920      	subs	r1, #32
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
 7c2:	4666      	mov	r6, ip
 7c4:	e001      	b.n	7ca <crcEnc16+0x4a>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 7c6:	3940      	subs	r1, #64	; 0x40
        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;
 7c8:	1c26      	adds	r6, r4, #0
 7ca:	408e      	lsls	r6, r1
 7cc:	0ff1      	lsrs	r1, r6, #31

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 7ce:	0bed      	lsrs	r5, r5, #15
 7d0:	4069      	eors	r1, r5
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 7d2:	0052      	lsls	r2, r2, #1
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 7d4:	4d09      	ldr	r5, [pc, #36]	; (7fc <crcEnc16+0x7c>)
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 7d6:	b292      	uxth	r2, r2
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 7d8:	4015      	ands	r5, r2
 7da:	4042      	eors	r2, r0
 7dc:	4808      	ldr	r0, [pc, #32]	; (800 <crcEnc16+0x80>)
 7de:	1949      	adds	r1, r1, r5
 7e0:	4002      	ands	r2, r0
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 7e2:	3301      	adds	r3, #1
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 7e4:	430a      	orrs	r2, r1
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 7e6:	2b60      	cmp	r3, #96	; 0x60
 7e8:	d1db      	bne.n	7a2 <crcEnc16+0x22>
        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
    }

    static uint32_t msg_out[1];
    msg_out[0] = data0 + remainder;
 7ea:	4806      	ldr	r0, [pc, #24]	; (804 <crcEnc16+0x84>)
 7ec:	1912      	adds	r2, r2, r4
 7ee:	6002      	str	r2, [r0, #0]
    //radio_data_arr[0] = data2;
    //radio_data_arr[1] = data1;
    //radio_data_arr[2] = data0;

    return msg_out;    
}
 7f0:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
 7f2:	46c0      	nop			; (mov r8, r8)
 7f4:	00001bcc 	.word	0x00001bcc
 7f8:	0000ffff 	.word	0x0000ffff
 7fc:	00003ffd 	.word	0x00003ffd
 800:	ffffc002 	.word	0xffffc002
 804:	00001c10 	.word	0x00001c10

Disassembly of section .text.mrr_send_radio_data:

00000808 <mrr_send_radio_data>:

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 808:	b5f0      	push	{r4, r5, r6, r7, lr}
 80a:	b085      	sub	sp, #20
 80c:	9003      	str	r0, [sp, #12]
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 80e:	f7ff ffb7 	bl	780 <crcEnc16>
    mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
 812:	4bb4      	ldr	r3, [pc, #720]	; (ae4 <mrr_send_radio_data+0x2dc>)
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 814:	9001      	str	r0, [sp, #4]
    mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
 816:	781f      	ldrb	r7, [r3, #0]
 818:	2f00      	cmp	r7, #0
 81a:	d000      	beq.n	81e <mrr_send_radio_data+0x16>
 81c:	e083      	b.n	926 <mrr_send_radio_data+0x11e>

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 81e:	4db2      	ldr	r5, [pc, #712]	; (ae8 <mrr_send_radio_data+0x2e0>)
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
        radio_on = 1;
 820:	2601      	movs	r6, #1
 822:	701e      	strb	r6, [r3, #0]

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 824:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 826:	2002      	movs	r0, #2

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 828:	43b3      	bics	r3, r6
 82a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 82c:	682a      	ldr	r2, [r5, #0]
 82e:	1c39      	adds	r1, r7, #0
 830:	f7ff fceb 	bl	20a <mbus_remote_register_write>

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 834:	4cad      	ldr	r4, [pc, #692]	; (aec <mrr_send_radio_data+0x2e4>)
 836:	4bae      	ldr	r3, [pc, #696]	; (af0 <mrr_send_radio_data+0x2e8>)
 838:	6822      	ldr	r2, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 83a:	2002      	movs	r0, #2
    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 83c:	4013      	ands	r3, r2
 83e:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 840:	6822      	ldr	r2, [r4, #0]
 842:	2103      	movs	r1, #3
 844:	f7ff fce1 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
 848:	6822      	ldr	r2, [r4, #0]
 84a:	2380      	movs	r3, #128	; 0x80
 84c:	031b      	lsls	r3, r3, #12
 84e:	4313      	orrs	r3, r2
 850:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 852:	6822      	ldr	r2, [r4, #0]
 854:	2103      	movs	r1, #3
 856:	2002      	movs	r0, #2
 858:	f7ff fcd7 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 85c:	2064      	movs	r0, #100	; 0x64
 85e:	f7ff fc22 	bl	a6 <delay>

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 862:	6822      	ldr	r2, [r4, #0]
 864:	4ba3      	ldr	r3, [pc, #652]	; (af4 <mrr_send_radio_data+0x2ec>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 866:	2002      	movs	r0, #2
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    delay(MBUS_DELAY);

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 868:	4013      	ands	r3, r2
 86a:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 86c:	6822      	ldr	r2, [r4, #0]
 86e:	2103      	movs	r1, #3
 870:	f7ff fccb 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
 874:	6822      	ldr	r2, [r4, #0]
 876:	2380      	movs	r3, #128	; 0x80
 878:	02db      	lsls	r3, r3, #11
 87a:	4313      	orrs	r3, r2
 87c:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 87e:	6822      	ldr	r2, [r4, #0]
 880:	2103      	movs	r1, #3
 882:	2002      	movs	r0, #2
 884:	f7ff fcc1 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 888:	2064      	movs	r0, #100	; 0x64
 88a:	f7ff fc0c 	bl	a6 <delay>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 88e:	682b      	ldr	r3, [r5, #0]
 890:	227e      	movs	r2, #126	; 0x7e
 892:	4393      	bics	r3, r2
 894:	2420      	movs	r4, #32
 896:	4323      	orrs	r3, r4
 898:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 89a:	682a      	ldr	r2, [r5, #0]
 89c:	2002      	movs	r0, #2
 89e:	1c39      	adds	r1, r7, #0
 8a0:	f7ff fcb3 	bl	20a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 8a4:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 8a6:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 8a8:	4333      	orrs	r3, r6
 8aa:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 8ac:	682a      	ldr	r2, [r5, #0]
 8ae:	1c39      	adds	r1, r7, #0
 8b0:	f7ff fcab 	bl	20a <mbus_remote_register_write>

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 8b4:	4d90      	ldr	r5, [pc, #576]	; (af8 <mrr_send_radio_data+0x2f0>)
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8b6:	2104      	movs	r1, #4
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 8b8:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8ba:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 8bc:	4333      	orrs	r3, r6
 8be:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8c0:	682a      	ldr	r2, [r5, #0]
 8c2:	f7ff fca2 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 8c6:	2064      	movs	r0, #100	; 0x64
 8c8:	f7ff fbed 	bl	a6 <delay>

    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
 8cc:	682b      	ldr	r3, [r5, #0]
 8ce:	2208      	movs	r2, #8
 8d0:	4393      	bics	r3, r2
 8d2:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8d4:	682a      	ldr	r2, [r5, #0]
 8d6:	2104      	movs	r1, #4
 8d8:	2002      	movs	r0, #2
 8da:	f7ff fc96 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 8de:	2064      	movs	r0, #100	; 0x64
 8e0:	f7ff fbe1 	bl	a6 <delay>

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 8e4:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8e6:	2104      	movs	r1, #4
    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
    delay(MBUS_DELAY);

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 8e8:	431c      	orrs	r4, r3
 8ea:	602c      	str	r4, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 8ec:	682a      	ldr	r2, [r5, #0]
 8ee:	2002      	movs	r0, #2
 8f0:	f7ff fc8b 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY);
 8f4:	2064      	movs	r0, #100	; 0x64
 8f6:	f7ff fbd6 	bl	a6 <delay>

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
 8fa:	682b      	ldr	r3, [r5, #0]
 8fc:	2210      	movs	r2, #16
 8fe:	4393      	bics	r3, r2
 900:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 902:	682a      	ldr	r2, [r5, #0]
 904:	2002      	movs	r0, #2
 906:	2104      	movs	r1, #4
 908:	f7ff fc7f 	bl	20a <mbus_remote_register_write>

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 90c:	4b7b      	ldr	r3, [pc, #492]	; (afc <mrr_send_radio_data+0x2f4>)
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 90e:	2002      	movs	r0, #2

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 910:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 912:	2111      	movs	r1, #17

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 914:	43b2      	bics	r2, r6
 916:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 918:	681a      	ldr	r2, [r3, #0]
 91a:	f7ff fc76 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*5); // Freq stab
 91e:	20fa      	movs	r0, #250	; 0xfa
 920:	40b0      	lsls	r0, r6
 922:	f7ff fbc0 	bl	a6 <delay>
    if(!radio_on) {
        radio_on = 1;
	radio_power_on();
    }
    
    mbus_remote_register_write(MRR_ADDR,0xD, radio_data_arr[0] & 0xFFFFFF);
 926:	4c76      	ldr	r4, [pc, #472]	; (b00 <mrr_send_radio_data+0x2f8>)
 928:	2002      	movs	r0, #2
 92a:	6822      	ldr	r2, [r4, #0]
 92c:	210d      	movs	r1, #13
 92e:	0212      	lsls	r2, r2, #8
 930:	0a12      	lsrs	r2, r2, #8
 932:	f7ff fc6a 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xE, (radio_data_arr[1] << 8) | ((radio_data_arr[0] >> 24) & 0xFF));
 936:	6863      	ldr	r3, [r4, #4]
 938:	6822      	ldr	r2, [r4, #0]
 93a:	021b      	lsls	r3, r3, #8
 93c:	0e12      	lsrs	r2, r2, #24
 93e:	431a      	orrs	r2, r3
 940:	2002      	movs	r0, #2
 942:	210e      	movs	r1, #14
 944:	f7ff fc61 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xF, (radio_data_arr[2] << 16) | ((radio_data_arr[1] >> 16) & 0xFFFF));
 948:	68a3      	ldr	r3, [r4, #8]
 94a:	6862      	ldr	r2, [r4, #4]
 94c:	041b      	lsls	r3, r3, #16
 94e:	0c12      	lsrs	r2, r2, #16
 950:	431a      	orrs	r2, r3
 952:	2002      	movs	r0, #2
 954:	210f      	movs	r1, #15
 956:	f7ff fc58 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x10, ((crc_data[0] & 0xFFFF) << 8 | (radio_data_arr[2] >> 8) & 0xFF));
 95a:	9901      	ldr	r1, [sp, #4]
 95c:	68a2      	ldr	r2, [r4, #8]
 95e:	880b      	ldrh	r3, [r1, #0]
 960:	0a12      	lsrs	r2, r2, #8
 962:	021b      	lsls	r3, r3, #8
 964:	b2d2      	uxtb	r2, r2
 966:	431a      	orrs	r2, r3
 968:	2002      	movs	r0, #2
 96a:	2110      	movs	r1, #16
 96c:	f7ff fc4d 	bl	20a <mbus_remote_register_write>

    if (!radio_ready){
 970:	4b64      	ldr	r3, [pc, #400]	; (b04 <mrr_send_radio_data+0x2fc>)
 972:	781d      	ldrb	r5, [r3, #0]
 974:	2d00      	cmp	r5, #0
 976:	d127      	bne.n	9c8 <mrr_send_radio_data+0x1c0>
	radio_ready = 1;
 978:	2201      	movs	r2, #1
 97a:	701a      	strb	r2, [r3, #0]

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 97c:	4b5f      	ldr	r3, [pc, #380]	; (afc <mrr_send_radio_data+0x2f4>)
 97e:	2402      	movs	r4, #2
 980:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 982:	2111      	movs	r1, #17

    if (!radio_ready){
	radio_ready = 1;

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 984:	4322      	orrs	r2, r4
 986:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 988:	681a      	ldr	r2, [r3, #0]
 98a:	1c20      	adds	r0, r4, #0
 98c:	f7ff fc3d 	bl	20a <mbus_remote_register_write>
	delay(MBUS_DELAY);
 990:	2064      	movs	r0, #100	; 0x64
 992:	f7ff fb88 	bl	a6 <delay>

	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
 996:	4b55      	ldr	r3, [pc, #340]	; (aec <mrr_send_radio_data+0x2e4>)
 998:	2280      	movs	r2, #128	; 0x80
 99a:	6819      	ldr	r1, [r3, #0]
 99c:	0352      	lsls	r2, r2, #13
 99e:	430a      	orrs	r2, r1
 9a0:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 9a2:	681a      	ldr	r2, [r3, #0]
 9a4:	2103      	movs	r1, #3
 9a6:	1c20      	adds	r0, r4, #0
 9a8:	f7ff fc2f 	bl	20a <mbus_remote_register_write>
	delay(MBUS_DELAY);
 9ac:	2064      	movs	r0, #100	; 0x64
 9ae:	f7ff fb7a 	bl	a6 <delay>

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 9b2:	4b4d      	ldr	r3, [pc, #308]	; (ae8 <mrr_send_radio_data+0x2e0>)
 9b4:	217e      	movs	r1, #126	; 0x7e
 9b6:	681a      	ldr	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 9b8:	1c20      	adds	r0, r4, #0
	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
	delay(MBUS_DELAY);

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 9ba:	438a      	bics	r2, r1
 9bc:	4322      	orrs	r2, r4
 9be:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 9c0:	681a      	ldr	r2, [r3, #0]
 9c2:	1c29      	adds	r1, r5, #0
 9c4:	f7ff fc21 	bl	20a <mbus_remote_register_write>

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
 9c8:	4b4f      	ldr	r3, [pc, #316]	; (b08 <mrr_send_radio_data+0x300>)
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
 9ca:	2101      	movs	r1, #1
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
 9cc:	781a      	ldrb	r2, [r3, #0]
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
 9ce:	9102      	str	r1, [sp, #8]
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
 9d0:	2a00      	cmp	r2, #0
 9d2:	d001      	beq.n	9d8 <mrr_send_radio_data+0x1d0>
 9d4:	781b      	ldrb	r3, [r3, #0]
 9d6:	9302      	str	r3, [sp, #8]

    mrr_cfo_val_fine = 0x0000;
 9d8:	2700      	movs	r7, #0
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    }

#ifdef USE_RAD
    uint8_t count = 0;
 9da:	9701      	str	r7, [sp, #4]
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
 9dc:	e064      	b.n	aa8 <mrr_send_radio_data+0x2a0>
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
 9de:	4b4b      	ldr	r3, [pc, #300]	; (b0c <mrr_send_radio_data+0x304>)
 9e0:	2400      	movs	r4, #0
 9e2:	601c      	str	r4, [r3, #0]
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
 9e4:	4b4a      	ldr	r3, [pc, #296]	; (b10 <mrr_send_radio_data+0x308>)

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
 9e6:	223f      	movs	r2, #63	; 0x3f
    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
 9e8:	601c      	str	r4, [r3, #0]

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
 9ea:	4b4a      	ldr	r3, [pc, #296]	; (b14 <mrr_send_radio_data+0x30c>)
 9ec:	494a      	ldr	r1, [pc, #296]	; (b18 <mrr_send_radio_data+0x310>)
 9ee:	681d      	ldr	r5, [r3, #0]
 9f0:	403a      	ands	r2, r7
 9f2:	0410      	lsls	r0, r2, #16
 9f4:	4029      	ands	r1, r5
 9f6:	4301      	orrs	r1, r0
 9f8:	6019      	str	r1, [r3, #0]
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
 9fa:	6818      	ldr	r0, [r3, #0]
 9fc:	0291      	lsls	r1, r2, #10
 9fe:	4a47      	ldr	r2, [pc, #284]	; (b1c <mrr_send_radio_data+0x314>)
 a00:	4002      	ands	r2, r0
 a02:	430a      	orrs	r2, r1
 a04:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
 a06:	681a      	ldr	r2, [r3, #0]
 a08:	2002      	movs	r0, #2
 a0a:	2101      	movs	r1, #1
 a0c:	f7ff fbfd 	bl	20a <mbus_remote_register_write>
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
 a10:	4a43      	ldr	r2, [pc, #268]	; (b20 <mrr_send_radio_data+0x318>)
    config_timer32(val, 1, 0, 0);
 a12:	20a0      	movs	r0, #160	; 0xa0
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
 a14:	7014      	strb	r4, [r2, #0]
    config_timer32(val, 1, 0, 0);
 a16:	0300      	lsls	r0, r0, #12
 a18:	2101      	movs	r1, #1
 a1a:	1c22      	adds	r2, r4, #0
 a1c:	1c23      	adds	r3, r4, #0
 a1e:	f7ff fb4d 	bl	bc <config_timer32>

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
 a22:	4e31      	ldr	r6, [pc, #196]	; (ae8 <mrr_send_radio_data+0x2e0>)
 a24:	2101      	movs	r1, #1
 a26:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a28:	2002      	movs	r0, #2

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
 a2a:	430b      	orrs	r3, r1
 a2c:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a2e:	6832      	ldr	r2, [r6, #0]
 a30:	1c21      	adds	r1, r4, #0
 a32:	f7ff fbea 	bl	20a <mbus_remote_register_write>

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
 a36:	4d31      	ldr	r5, [pc, #196]	; (afc <mrr_send_radio_data+0x2f4>)
 a38:	2204      	movs	r2, #4
 a3a:	882b      	ldrh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a3c:	2111      	movs	r1, #17
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
 a3e:	4313      	orrs	r3, r2
 a40:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a42:	682a      	ldr	r2, [r5, #0]
 a44:	2002      	movs	r0, #2
 a46:	f7ff fbe0 	bl	20a <mbus_remote_register_write>

    // Wait for radio response
    WFI();
 a4a:	f7ff fb34 	bl	b6 <WFI>
    config_timer32(val, 1, 0, 0);
}

static void stop_timer32_timeout_check(){
    // Turn off Timer32
    *TIMER32_GO = 0;
 a4e:	4b35      	ldr	r3, [pc, #212]	; (b24 <mrr_send_radio_data+0x31c>)
 a50:	601c      	str	r4, [r3, #0]
    if (wfi_timeout_flag){
 a52:	4b33      	ldr	r3, [pc, #204]	; (b20 <mrr_send_radio_data+0x318>)
 a54:	7819      	ldrb	r1, [r3, #0]
 a56:	42a1      	cmp	r1, r4
 a58:	d007      	beq.n	a6a <mrr_send_radio_data+0x262>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 a5a:	2180      	movs	r1, #128	; 0x80
 a5c:	04c9      	lsls	r1, r1, #19
 a5e:	20af      	movs	r0, #175	; 0xaf

static void stop_timer32_timeout_check(){
    // Turn off Timer32
    *TIMER32_GO = 0;
    if (wfi_timeout_flag){
        wfi_timeout_flag = 0;
 a60:	701c      	strb	r4, [r3, #0]
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 a62:	f7ff fb91 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
 a66:	f7ff fcbb 	bl	3e0 <operation_sleep_notimer>
    // Wait for radio response
    WFI();
    stop_timer32_timeout_check();

    // Turn off Current Limter
    mrrv7_r00.MRR_CL_EN = 0;
 a6a:	6833      	ldr	r3, [r6, #0]
 a6c:	2201      	movs	r2, #1
 a6e:	4393      	bics	r3, r2
 a70:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a72:	6832      	ldr	r2, [r6, #0]
 a74:	2002      	movs	r0, #2
 a76:	f7ff fbc8 	bl	20a <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
 a7a:	882b      	ldrh	r3, [r5, #0]
 a7c:	2104      	movs	r1, #4
 a7e:	438b      	bics	r3, r1
 a80:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 a82:	682a      	ldr	r2, [r5, #0]
 a84:	2002      	movs	r0, #2
 a86:	2111      	movs	r1, #17
 a88:	f7ff fbbf 	bl	20a <mbus_remote_register_write>

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
 a8c:	9b01      	ldr	r3, [sp, #4]
	if (count < num_packets){
 a8e:	9a02      	ldr	r2, [sp, #8]

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
 a90:	3301      	adds	r3, #1
 a92:	b2db      	uxtb	r3, r3
 a94:	9301      	str	r3, [sp, #4]
	if (count < num_packets){
 a96:	4293      	cmp	r3, r2
 a98:	d202      	bcs.n	aa0 <mrr_send_radio_data+0x298>
		delay(RADIO_PACKET_DELAY);
 a9a:	4823      	ldr	r0, [pc, #140]	; (b28 <mrr_send_radio_data+0x320>)
 a9c:	f7ff fb03 	bl	a6 <delay>
	}
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
 aa0:	4b22      	ldr	r3, [pc, #136]	; (b2c <mrr_send_radio_data+0x324>)
 aa2:	781b      	ldrb	r3, [r3, #0]
 aa4:	18ff      	adds	r7, r7, r3
 aa6:	b2bf      	uxth	r7, r7
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
 aa8:	9b01      	ldr	r3, [sp, #4]
 aaa:	9902      	ldr	r1, [sp, #8]
 aac:	428b      	cmp	r3, r1
 aae:	d196      	bne.n	9de <mrr_send_radio_data+0x1d6>
		delay(RADIO_PACKET_DELAY);
	}
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
    }

    radio_packet_count++;
 ab0:	4b1f      	ldr	r3, [pc, #124]	; (b30 <mrr_send_radio_data+0x328>)
 ab2:	681a      	ldr	r2, [r3, #0]
 ab4:	3201      	adds	r2, #1
 ab6:	601a      	str	r2, [r3, #0]
#endif

    if (last_packet){
 ab8:	9a03      	ldr	r2, [sp, #12]
 aba:	2a00      	cmp	r2, #0
 abc:	d005      	beq.n	aca <mrr_send_radio_data+0x2c2>
	radio_ready = 0;
 abe:	4b11      	ldr	r3, [pc, #68]	; (b04 <mrr_send_radio_data+0x2fc>)
 ac0:	2200      	movs	r2, #0
 ac2:	701a      	strb	r2, [r3, #0]
	radio_power_off();
 ac4:	f7ff fc14 	bl	2f0 <radio_power_off>
 ac8:	e009      	b.n	ade <mrr_send_radio_data+0x2d6>
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 aca:	4b0c      	ldr	r3, [pc, #48]	; (afc <mrr_send_radio_data+0x2f4>)
 acc:	2104      	movs	r1, #4
 ace:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 ad0:	2002      	movs	r0, #2

    if (last_packet){
	radio_ready = 0;
	radio_power_off();
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 ad2:	438a      	bics	r2, r1
 ad4:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 ad6:	681a      	ldr	r2, [r3, #0]
 ad8:	2111      	movs	r1, #17
 ada:	f7ff fb96 	bl	20a <mbus_remote_register_write>
    }
}
 ade:	b005      	add	sp, #20
 ae0:	bdf0      	pop	{r4, r5, r6, r7, pc}
 ae2:	46c0      	nop			; (mov r8, r8)
 ae4:	00001c08 	.word	0x00001c08
 ae8:	00001b58 	.word	0x00001b58
 aec:	00001b64 	.word	0x00001b64
 af0:	fffbffff 	.word	0xfffbffff
 af4:	fff7ffff 	.word	0xfff7ffff
 af8:	00001b68 	.word	0x00001b68
 afc:	00001b6c 	.word	0x00001b6c
 b00:	00001bcc 	.word	0x00001bcc
 b04:	00001b8e 	.word	0x00001b8e
 b08:	00001b98 	.word	0x00001b98
 b0c:	a0001200 	.word	0xa0001200
 b10:	a000007c 	.word	0xa000007c
 b14:	00001c20 	.word	0x00001c20
 b18:	ffc0ffff 	.word	0xffc0ffff
 b1c:	ffff03ff 	.word	0xffff03ff
 b20:	00001c04 	.word	0x00001c04
 b24:	a0001100 	.word	0xa0001100
 b28:	000032c8 	.word	0x000032c8
 b2c:	00001bfc 	.word	0x00001bfc
 b30:	00001bf8 	.word	0x00001bf8

Disassembly of section .text.set_goc_cmd:

00000b34 <set_goc_cmd>:

/**********************************************
 * Interrupt handlers
 **********************************************/

void set_goc_cmd() {
 b34:	b508      	push	{r3, lr}
    goc_component = (*GOC_DATA_IRQ >> 24) & 0xFF;
 b36:	238c      	movs	r3, #140	; 0x8c
 b38:	6819      	ldr	r1, [r3, #0]
 b3a:	4a0c      	ldr	r2, [pc, #48]	; (b6c <set_goc_cmd+0x38>)
 b3c:	0e09      	lsrs	r1, r1, #24
 b3e:	7011      	strb	r1, [r2, #0]
    goc_func_id = (*GOC_DATA_IRQ >> 16) & 0xFF;
 b40:	6819      	ldr	r1, [r3, #0]
 b42:	4a0b      	ldr	r2, [pc, #44]	; (b70 <set_goc_cmd+0x3c>)
 b44:	0c09      	lsrs	r1, r1, #16
 b46:	7011      	strb	r1, [r2, #0]
    goc_data = *GOC_DATA_IRQ & 0xFFFF;
 b48:	681a      	ldr	r2, [r3, #0]
 b4a:	4b0a      	ldr	r3, [pc, #40]	; (b74 <set_goc_cmd+0x40>)
 b4c:	801a      	strh	r2, [r3, #0]
    goc_state = 0;
 b4e:	4b0a      	ldr	r3, [pc, #40]	; (b78 <set_goc_cmd+0x44>)
 b50:	2200      	movs	r2, #0
 b52:	701a      	strb	r2, [r3, #0]
    update_system_time();
 b54:	f7ff fd80 	bl	658 <update_system_time>
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	xot_last_timer_list[i] = xo_sys_time_in_sec;
 b58:	4a08      	ldr	r2, [pc, #32]	; (b7c <set_goc_cmd+0x48>)
 b5a:	4b09      	ldr	r3, [pc, #36]	; (b80 <set_goc_cmd+0x4c>)
 b5c:	6811      	ldr	r1, [r2, #0]
 b5e:	6019      	str	r1, [r3, #0]
 b60:	6811      	ldr	r1, [r2, #0]
 b62:	6059      	str	r1, [r3, #4]
 b64:	6812      	ldr	r2, [r2, #0]
 b66:	609a      	str	r2, [r3, #8]
    }
}
 b68:	bd08      	pop	{r3, pc}
 b6a:	46c0      	nop			; (mov r8, r8)
 b6c:	00001baa 	.word	0x00001baa
 b70:	00001bb8 	.word	0x00001bb8
 b74:	00001bc2 	.word	0x00001bc2
 b78:	00001be8 	.word	0x00001be8
 b7c:	00001bb4 	.word	0x00001bb4
 b80:	00001b80 	.word	0x00001b80

Disassembly of section .text.handler_ext_int_wakeup:

00000b84 <handler_ext_int_wakeup>:
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
 b84:	4b01      	ldr	r3, [pc, #4]	; (b8c <handler_ext_int_wakeup+0x8>)
 b86:	2201      	movs	r2, #1
 b88:	601a      	str	r2, [r3, #0]

}
 b8a:	4770      	bx	lr
 b8c:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_gocep:

00000b90 <handler_ext_int_gocep>:

void handler_ext_int_gocep( void ) { // GOCEP
 b90:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
 b92:	4b04      	ldr	r3, [pc, #16]	; (ba4 <handler_ext_int_gocep+0x14>)
 b94:	2204      	movs	r2, #4
 b96:	601a      	str	r2, [r3, #0]
    set_goc_cmd();
 b98:	f7ff ffcc 	bl	b34 <set_goc_cmd>
    reset_timers_list();
 b9c:	f7ff fdae 	bl	6fc <reset_timers_list>
}
 ba0:	bd08      	pop	{r3, pc}
 ba2:	46c0      	nop			; (mov r8, r8)
 ba4:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_timer32:

00000ba8 <handler_ext_int_timer32>:

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
 ba8:	4b04      	ldr	r3, [pc, #16]	; (bbc <handler_ext_int_timer32+0x14>)
 baa:	2208      	movs	r2, #8
 bac:	601a      	str	r2, [r3, #0]
    *TIMER32_STAT = 0x0;
 bae:	4b04      	ldr	r3, [pc, #16]	; (bc0 <handler_ext_int_timer32+0x18>)
 bb0:	2200      	movs	r2, #0
 bb2:	601a      	str	r2, [r3, #0]
    
    wfi_timeout_flag = 1;
 bb4:	4b03      	ldr	r3, [pc, #12]	; (bc4 <handler_ext_int_timer32+0x1c>)
 bb6:	2201      	movs	r2, #1
 bb8:	701a      	strb	r2, [r3, #0]
}
 bba:	4770      	bx	lr
 bbc:	e000e280 	.word	0xe000e280
 bc0:	a0001110 	.word	0xa0001110
 bc4:	00001c04 	.word	0x00001c04

Disassembly of section .text.handler_ext_int_xot:

00000bc8 <handler_ext_int_xot>:

void handler_ext_int_xot( void ) { // TIMER32
 bc8:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_XOT);
 bca:	2280      	movs	r2, #128	; 0x80
 bcc:	4b02      	ldr	r3, [pc, #8]	; (bd8 <handler_ext_int_xot+0x10>)
 bce:	0312      	lsls	r2, r2, #12
 bd0:	601a      	str	r2, [r3, #0]
    update_system_time();
 bd2:	f7ff fd41 	bl	658 <update_system_time>
}
 bd6:	bd08      	pop	{r3, pc}
 bd8:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg0:

00000bdc <handler_ext_int_reg0>:

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
 bdc:	4b02      	ldr	r3, [pc, #8]	; (be8 <handler_ext_int_reg0+0xc>)
 bde:	2280      	movs	r2, #128	; 0x80
 be0:	0052      	lsls	r2, r2, #1
 be2:	601a      	str	r2, [r3, #0]
}
 be4:	4770      	bx	lr
 be6:	46c0      	nop			; (mov r8, r8)
 be8:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg1:

00000bec <handler_ext_int_reg1>:

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
 bec:	4b02      	ldr	r3, [pc, #8]	; (bf8 <handler_ext_int_reg1+0xc>)
 bee:	2280      	movs	r2, #128	; 0x80
 bf0:	0092      	lsls	r2, r2, #2
 bf2:	601a      	str	r2, [r3, #0]
}
 bf4:	4770      	bx	lr
 bf6:	46c0      	nop			; (mov r8, r8)
 bf8:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg2:

00000bfc <handler_ext_int_reg2>:

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
 bfc:	4b02      	ldr	r3, [pc, #8]	; (c08 <handler_ext_int_reg2+0xc>)
 bfe:	2280      	movs	r2, #128	; 0x80
 c00:	00d2      	lsls	r2, r2, #3
 c02:	601a      	str	r2, [r3, #0]
}
 c04:	4770      	bx	lr
 c06:	46c0      	nop			; (mov r8, r8)
 c08:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg3:

00000c0c <handler_ext_int_reg3>:

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
 c0c:	4b02      	ldr	r3, [pc, #8]	; (c18 <handler_ext_int_reg3+0xc>)
 c0e:	2280      	movs	r2, #128	; 0x80
 c10:	0112      	lsls	r2, r2, #4
 c12:	601a      	str	r2, [r3, #0]
}
 c14:	4770      	bx	lr
 c16:	46c0      	nop			; (mov r8, r8)
 c18:	e000e280 	.word	0xe000e280

Disassembly of section .text.startup.main:

00000c1c <main>:

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
     c1c:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     c1e:	4bfa      	ldr	r3, [pc, #1000]	; (1008 <main+0x3ec>)
     c20:	4afa      	ldr	r2, [pc, #1000]	; (100c <main+0x3f0>)
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     c22:	4cfb      	ldr	r4, [pc, #1004]	; (1010 <main+0x3f4>)
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     c24:	601a      	str	r2, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     c26:	6823      	ldr	r3, [r4, #0]
     c28:	4dfa      	ldr	r5, [pc, #1000]	; (1014 <main+0x3f8>)
     c2a:	42ab      	cmp	r3, r5
     c2c:	d100      	bne.n	c30 <main+0x14>
     c2e:	e3c0      	b.n	13b2 <main+0x796>
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);
     c30:	2101      	movs	r1, #1
     c32:	20ba      	movs	r0, #186	; 0xba
     c34:	f7ff faa8 	bl	188 <mbus_write_message32>

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
     c38:	4bf7      	ldr	r3, [pc, #988]	; (1018 <main+0x3fc>)
     c3a:	2700      	movs	r7, #0
     c3c:	601f      	str	r7, [r3, #0]
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     c3e:	4bf7      	ldr	r3, [pc, #988]	; (101c <main+0x400>)
    config_timer32(0, 0, 0, 0);
     c40:	1c39      	adds	r1, r7, #0
     c42:	1c3a      	adds	r2, r7, #0
static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     c44:	601f      	str	r7, [r3, #0]
    config_timer32(0, 0, 0, 0);
     c46:	1c38      	adds	r0, r7, #0
     c48:	1c3b      	adds	r3, r7, #0
     c4a:	f7ff fa37 	bl	bc <config_timer32>

    // Enumeration
    enumerated = ENUMID;

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     c4e:	2006      	movs	r0, #6
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    config_timer32(0, 0, 0, 0);

    // Enumeration
    enumerated = ENUMID;
     c50:	6025      	str	r5, [r4, #0]

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     c52:	f7ff fab9 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c56:	2064      	movs	r0, #100	; 0x64
     c58:	f7ff fa25 	bl	a6 <delay>
#endif
#ifdef USE_MRR
    mbus_enumerate(MRR_ADDR);
     c5c:	2002      	movs	r0, #2
     c5e:	f7ff fab3 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c62:	2064      	movs	r0, #100	; 0x64
     c64:	f7ff fa1f 	bl	a6 <delay>
#endif
#ifdef USE_LNT
    mbus_enumerate(LNT_ADDR);
     c68:	2003      	movs	r0, #3
     c6a:	f7ff faad 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c6e:	2064      	movs	r0, #100	; 0x64
     c70:	f7ff fa19 	bl	a6 <delay>
#endif
#ifdef USE_SNT
    mbus_enumerate(SNT_ADDR);
     c74:	2004      	movs	r0, #4
     c76:	f7ff faa7 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c7a:	2064      	movs	r0, #100	; 0x64
     c7c:	f7ff fa13 	bl	a6 <delay>
#endif
#ifdef USE_PMU
    mbus_enumerate(PMU_ADDR);
     c80:	2005      	movs	r0, #5
     c82:	f7ff faa1 	bl	1c8 <mbus_enumerate>
    delay(MBUS_DELAY);
     c86:	2064      	movs	r0, #100	; 0x64
     c88:	f7ff fa0d 	bl	a6 <delay>
#endif

    // Default CPU halt function
    set_halt_until_mbus_tx();
     c8c:	f7ff fa70 	bl	170 <set_halt_until_mbus_tx>

    // Global variables
    wfi_timeout_flag = 0;
     c90:	4be3      	ldr	r3, [pc, #908]	; (1020 <main+0x404>)

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     c92:	2119      	movs	r1, #25

    // Default CPU halt function
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;
     c94:	701f      	strb	r7, [r3, #0]

    xo_sys_time = 0;
     c96:	4be3      	ldr	r3, [pc, #908]	; (1024 <main+0x408>)
    // MRR_SIGNAL_PERIOD = 300;
    // MRR_DATA_PERIOD = 18000;
    // MRR_TEMP_THRESH = 5;    // FIXME: use code
    // MRR_VOLT_THRESH = 0x4B;

    pmu_sar_ratio_radio = 0x34;
     c98:	2234      	movs	r2, #52	; 0x34
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
     c9a:	601f      	str	r7, [r3, #0]
    xo_sys_time_in_sec = 0;
     c9c:	4be2      	ldr	r3, [pc, #904]	; (1028 <main+0x40c>)

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     c9e:	20ba      	movs	r0, #186	; 0xba

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
     ca0:	601f      	str	r7, [r3, #0]
    xo_day_time_in_sec = 0;
     ca2:	4be2      	ldr	r3, [pc, #904]	; (102c <main+0x410>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     ca4:	2402      	movs	r4, #2
    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;
     ca6:	601f      	str	r7, [r3, #0]

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     ca8:	4be1      	ldr	r3, [pc, #900]	; (1030 <main+0x414>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     caa:	2601      	movs	r6, #1

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     cac:	6019      	str	r1, [r3, #0]
    snt_state = SNT_IDLE;
     cae:	4be1      	ldr	r3, [pc, #900]	; (1034 <main+0x418>)

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     cb0:	2102      	movs	r1, #2
    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
    snt_state = SNT_IDLE;
     cb2:	701f      	strb	r7, [r3, #0]
    // LNT_INTERVAL[0] = 60;
    // LNT_INTERVAL[1] = 300;
    // LNT_INTERVAL[2] = 600;
    // LNT_INTERVAL[3] = 1800;

    lnt_cur_level = 0;
     cb4:	4be0      	ldr	r3, [pc, #896]	; (1038 <main+0x41c>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     cb6:	4326      	orrs	r6, r4
    // LNT_INTERVAL[0] = 60;
    // LNT_INTERVAL[1] = 300;
    // LNT_INTERVAL[2] = 600;
    // LNT_INTERVAL[3] = 1800;

    lnt_cur_level = 0;
     cb8:	701f      	strb	r7, [r3, #0]
    // MRR_SIGNAL_PERIOD = 300;
    // MRR_DATA_PERIOD = 18000;
    // MRR_TEMP_THRESH = 5;    // FIXME: use code
    // MRR_VOLT_THRESH = 0x4B;

    pmu_sar_ratio_radio = 0x34;
     cba:	4be0      	ldr	r3, [pc, #896]	; (103c <main+0x420>)
     cbc:	701a      	strb	r2, [r3, #0]
	pmu_setting_state = PMU_20C;
     cbe:	4be0      	ldr	r3, [pc, #896]	; (1040 <main+0x424>)
     cc0:	2203      	movs	r2, #3
     cc2:	601a      	str	r2, [r3, #0]

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     cc4:	f7ff fa60 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);
     cc8:	49de      	ldr	r1, [pc, #888]	; (1044 <main+0x428>)
     cca:	20ed      	movs	r0, #237	; 0xed
     ccc:	f7ff fa5c 	bl	188 <mbus_write_message32>



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     cd0:	4bdd      	ldr	r3, [pc, #884]	; (1048 <main+0x42c>)
     cd2:	2140      	movs	r1, #64	; 0x40
     cd4:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     cd6:	2004      	movs	r0, #4
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     cd8:	438a      	bics	r2, r1
     cda:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
     cdc:	881a      	ldrh	r2, [r3, #0]
     cde:	2180      	movs	r1, #128	; 0x80
     ce0:	438a      	bics	r2, r1
     ce2:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     ce4:	681a      	ldr	r2, [r3, #0]
     ce6:	2101      	movs	r1, #1
     ce8:	f7ff fa8f 	bl	20a <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     cec:	4bd7      	ldr	r3, [pc, #860]	; (104c <main+0x430>)
     cee:	21ff      	movs	r1, #255	; 0xff
     cf0:	881a      	ldrh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     cf2:	2004      	movs	r0, #4
#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     cf4:	400a      	ands	r2, r1
     cf6:	2180      	movs	r1, #128	; 0x80
     cf8:	0149      	lsls	r1, r1, #5
     cfa:	430a      	orrs	r2, r1
     cfc:	801a      	strh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     cfe:	881a      	ldrh	r2, [r3, #0]
     d00:	21ff      	movs	r1, #255	; 0xff
     d02:	438a      	bics	r2, r1
     d04:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     d06:	681a      	ldr	r2, [r3, #0]
     d08:	2107      	movs	r1, #7
     d0a:	f7ff fa7e 	bl	20a <mbus_remote_register_write>
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d0e:	22fc      	movs	r2, #252	; 0xfc
     d10:	2380      	movs	r3, #128	; 0x80
     d12:	4316      	orrs	r6, r2
     d14:	021b      	lsls	r3, r3, #8
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     d16:	4dce      	ldr	r5, [pc, #824]	; (1050 <main+0x434>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d18:	431e      	orrs	r6, r3
     d1a:	2380      	movs	r3, #128	; 0x80
     d1c:	031b      	lsls	r3, r3, #12
     d1e:	431e      	orrs	r6, r3
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     d20:	782b      	ldrb	r3, [r5, #0]
     d22:	2240      	movs	r2, #64	; 0x40
     d24:	4393      	bics	r3, r2
     d26:	702b      	strb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d28:	2180      	movs	r1, #128	; 0x80
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     d2a:	782b      	ldrb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d2c:	03c9      	lsls	r1, r1, #15
     d2e:	430e      	orrs	r6, r1
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     d30:	2120      	movs	r1, #32
     d32:	438b      	bics	r3, r1
     d34:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d36:	682a      	ldr	r2, [r5, #0]
     d38:	2004      	movs	r0, #4
     d3a:	2108      	movs	r1, #8
     d3c:	f7ff fa65 	bl	20a <mbus_remote_register_write>

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     d40:	4ac4      	ldr	r2, [pc, #784]	; (1054 <main+0x438>)
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d42:	2004      	movs	r0, #4
    sntv4_r08.TMR_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     d44:	4016      	ands	r6, r2
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d46:	1c32      	adds	r2, r6, #0
     d48:	2109      	movs	r1, #9
     d4a:	f7ff fa5e 	bl	20a <mbus_remote_register_write>

    sntv4_r08.TMR_EN_OSC = 1;
     d4e:	782b      	ldrb	r3, [r5, #0]
     d50:	2108      	movs	r1, #8
     d52:	430b      	orrs	r3, r1
     d54:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d56:	682a      	ldr	r2, [r5, #0]
     d58:	2004      	movs	r0, #4
     d5a:	f7ff fa56 	bl	20a <mbus_remote_register_write>
    delay(10000);
     d5e:	48be      	ldr	r0, [pc, #760]	; (1058 <main+0x43c>)
     d60:	f7ff f9a1 	bl	a6 <delay>

    sntv4_r08.TMR_RESETB = 1;
     d64:	782b      	ldrb	r3, [r5, #0]
     d66:	2210      	movs	r2, #16
     d68:	4313      	orrs	r3, r2
     d6a:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DIV = 1;
     d6c:	782b      	ldrb	r3, [r5, #0]
     d6e:	2104      	movs	r1, #4
     d70:	430b      	orrs	r3, r1
     d72:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DCDC = 1;
     d74:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d76:	1c08      	adds	r0, r1, #0
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r08.TMR_RESETB = 1;
    sntv4_r08.TMR_RESETB_DIV = 1;
    sntv4_r08.TMR_RESETB_DCDC = 1;
     d78:	4323      	orrs	r3, r4
     d7a:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d7c:	682a      	ldr	r2, [r5, #0]
     d7e:	2108      	movs	r1, #8
     d80:	f7ff fa43 	bl	20a <mbus_remote_register_write>
    delay(10000);	// need to wait for clock to stabilize
     d84:	48b4      	ldr	r0, [pc, #720]	; (1058 <main+0x43c>)
     d86:	f7ff f98e 	bl	a6 <delay>

    sntv4_r08.TMR_EN_SELF_CLK = 1;
     d8a:	782b      	ldrb	r3, [r5, #0]
     d8c:	2201      	movs	r2, #1
     d8e:	4313      	orrs	r3, r2
     d90:	702b      	strb	r3, [r5, #0]
    sntv4_r09.TMR_SELF_EN = 1;
     d92:	2380      	movs	r3, #128	; 0x80
     d94:	039b      	lsls	r3, r3, #14
     d96:	431e      	orrs	r6, r3
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d98:	682a      	ldr	r2, [r5, #0]
     d9a:	2004      	movs	r0, #4
     d9c:	2108      	movs	r1, #8
     d9e:	f7ff fa34 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     da2:	1c32      	adds	r2, r6, #0
     da4:	2109      	movs	r1, #9
     da6:	2004      	movs	r0, #4
     da8:	f7ff fa2f 	bl	20a <mbus_remote_register_write>
    delay(100000);
     dac:	48ab      	ldr	r0, [pc, #684]	; (105c <main+0x440>)
     dae:	f7ff f97a 	bl	a6 <delay>

    sntv4_r08.TMR_EN_OSC = 0;
     db2:	782b      	ldrb	r3, [r5, #0]
     db4:	2108      	movs	r1, #8
     db6:	438b      	bics	r3, r1
     db8:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     dba:	682a      	ldr	r2, [r5, #0]
     dbc:	2004      	movs	r0, #4
     dbe:	f7ff fa24 	bl	20a <mbus_remote_register_write>
    delay(10000);
     dc2:	48a5      	ldr	r0, [pc, #660]	; (1058 <main+0x43c>)
     dc4:	f7ff f96f 	bl	a6 <delay>

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     dc8:	4ba5      	ldr	r3, [pc, #660]	; (1060 <main+0x444>)
    sntv4_r1A.WUP_THRESHOLD = 0;
     dca:	4da6      	ldr	r5, [pc, #664]	; (1064 <main+0x448>)

    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     dcc:	781a      	ldrb	r2, [r3, #0]
     dce:	701f      	strb	r7, [r3, #0]
    sntv4_r1A.WUP_THRESHOLD = 0;
     dd0:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     dd2:	2004      	movs	r0, #4
    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
     dd4:	0e12      	lsrs	r2, r2, #24
     dd6:	0612      	lsls	r2, r2, #24
     dd8:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     dda:	681a      	ldr	r2, [r3, #0]
     ddc:	2119      	movs	r1, #25
     dde:	f7ff fa14 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);
     de2:	682a      	ldr	r2, [r5, #0]
     de4:	2004      	movs	r0, #4
     de6:	211a      	movs	r1, #26
     de8:	f7ff fa0f 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 0;
     dec:	4d9e      	ldr	r5, [pc, #632]	; (1068 <main+0x44c>)
     dee:	4b9f      	ldr	r3, [pc, #636]	; (106c <main+0x450>)
     df0:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     df2:	2004      	movs	r0, #4
    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);

    sntv4_r17.WUP_ENABLE = 0;
     df4:	4013      	ands	r3, r2
     df6:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     df8:	682a      	ldr	r2, [r5, #0]
     dfa:	2117      	movs	r1, #23
     dfc:	f7ff fa05 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 1;
     e00:	682a      	ldr	r2, [r5, #0]
     e02:	2380      	movs	r3, #128	; 0x80
     e04:	041b      	lsls	r3, r3, #16
     e06:	4313      	orrs	r3, r2
     e08:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_CLK_SEL = 0;
     e0a:	682a      	ldr	r2, [r5, #0]
     e0c:	4b98      	ldr	r3, [pc, #608]	; (1070 <main+0x454>)
    sntv4_r17.WUP_LC_IRQ_EN = 0;
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e0e:	2004      	movs	r0, #4

    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
     e10:	4013      	ands	r3, r2
     e12:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     e14:	682a      	ldr	r2, [r5, #0]
     e16:	4b97      	ldr	r3, [pc, #604]	; (1074 <main+0x458>)
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e18:	2117      	movs	r1, #23
    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     e1a:	4013      	ands	r3, r2
     e1c:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_AUTO_RESET = 0;
     e1e:	682b      	ldr	r3, [r5, #0]
     e20:	4a8c      	ldr	r2, [pc, #560]	; (1054 <main+0x438>)
     e22:	4013      	ands	r3, r2
     e24:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e26:	682a      	ldr	r2, [r5, #0]
     e28:	f7ff f9ef 	bl	20a <mbus_remote_register_write>
    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    snt_clk_init();
    operation_temp_run();
     e2c:	f7ff fb64 	bl	4f8 <operation_temp_run>

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     e30:	4b91      	ldr	r3, [pc, #580]	; (1078 <main+0x45c>)
     e32:	4992      	ldr	r1, [pc, #584]	; (107c <main+0x460>)
     e34:	681a      	ldr	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e36:	2003      	movs	r0, #3

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     e38:	400a      	ands	r2, r1
     e3a:	2180      	movs	r1, #128	; 0x80
     e3c:	0389      	lsls	r1, r1, #14
     e3e:	430a      	orrs	r2, r1
     e40:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     e42:	6819      	ldr	r1, [r3, #0]
     e44:	4a8e      	ldr	r2, [pc, #568]	; (1080 <main+0x464>)
     e46:	400a      	ands	r2, r1
     e48:	498e      	ldr	r1, [pc, #568]	; (1084 <main+0x468>)
     e4a:	430a      	orrs	r2, r1
     e4c:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     e4e:	681a      	ldr	r2, [r3, #0]
     e50:	2140      	movs	r1, #64	; 0x40
     e52:	430a      	orrs	r2, r1
     e54:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e56:	681a      	ldr	r2, [r3, #0]
     e58:	2122      	movs	r1, #34	; 0x22
     e5a:	f7ff f9d6 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e5e:	20fa      	movs	r0, #250	; 0xfa
     e60:	40a0      	lsls	r0, r4
     e62:	f7ff f920 	bl	a6 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     e66:	4e88      	ldr	r6, [pc, #544]	; (1088 <main+0x46c>)
     e68:	4b88      	ldr	r3, [pc, #544]	; (108c <main+0x470>)
     e6a:	6832      	ldr	r2, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e6c:	21fc      	movs	r1, #252	; 0xfc
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     e6e:	4013      	ands	r3, r2
     e70:	2280      	movs	r2, #128	; 0x80
     e72:	0212      	lsls	r2, r2, #8
     e74:	4313      	orrs	r3, r2
     e76:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e78:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e7a:	2201      	movs	r2, #1
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e7c:	430b      	orrs	r3, r1
     e7e:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     e80:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e82:	2121      	movs	r1, #33	; 0x21
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     e84:	4323      	orrs	r3, r4
     e86:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e88:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e8a:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e8c:	4313      	orrs	r3, r2
     e8e:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e90:	6832      	ldr	r2, [r6, #0]
     e92:	f7ff f9ba 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e96:	20fa      	movs	r0, #250	; 0xfa
     e98:	40a0      	lsls	r0, r4
     e9a:	f7ff f904 	bl	a6 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     e9e:	4b7c      	ldr	r3, [pc, #496]	; (1090 <main+0x474>)
     ea0:	497c      	ldr	r1, [pc, #496]	; (1094 <main+0x478>)
     ea2:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     ea4:	2003      	movs	r0, #3
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     ea6:	400a      	ands	r2, r1
     ea8:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     eaa:	681a      	ldr	r2, [r3, #0]
     eac:	2140      	movs	r1, #64	; 0x40
     eae:	f7ff f9ac 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     eb2:	20fa      	movs	r0, #250	; 0xfa
     eb4:	40a0      	lsls	r0, r4
     eb6:	f7ff f8f6 	bl	a6 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     eba:	6833      	ldr	r3, [r6, #0]
     ebc:	4a65      	ldr	r2, [pc, #404]	; (1054 <main+0x438>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ebe:	2121      	movs	r1, #33	; 0x21
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     ec0:	4013      	ands	r3, r2
     ec2:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ec4:	6832      	ldr	r2, [r6, #0]
     ec6:	2003      	movs	r0, #3
     ec8:	f7ff f99f 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ecc:	20fa      	movs	r0, #250	; 0xfa
     ece:	40a0      	lsls	r0, r4
     ed0:	f7ff f8e9 	bl	a6 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     ed4:	4d70      	ldr	r5, [pc, #448]	; (1098 <main+0x47c>)
     ed6:	2108      	movs	r1, #8
     ed8:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     eda:	2003      	movs	r0, #3
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     edc:	430b      	orrs	r3, r1
     ede:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     ee0:	682a      	ldr	r2, [r5, #0]
     ee2:	2120      	movs	r1, #32
     ee4:	f7ff f991 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ee8:	20fa      	movs	r0, #250	; 0xfa
     eea:	40a0      	lsls	r0, r4
     eec:	f7ff f8db 	bl	a6 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
     ef0:	782b      	ldrb	r3, [r5, #0]
     ef2:	2210      	movs	r2, #16
     ef4:	4313      	orrs	r3, r2
     ef6:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
     ef8:	782b      	ldrb	r3, [r5, #0]
     efa:	2104      	movs	r1, #4
     efc:	430b      	orrs	r3, r1
     efe:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     f00:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f02:	2120      	movs	r1, #32
    delay(MBUS_DELAY*10);
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     f04:	4323      	orrs	r3, r4
     f06:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f08:	682a      	ldr	r2, [r5, #0]
     f0a:	2003      	movs	r0, #3
     f0c:	f7ff f97d 	bl	20a <mbus_remote_register_write>
    delay(2000); 
     f10:	20fa      	movs	r0, #250	; 0xfa
     f12:	00c0      	lsls	r0, r0, #3
     f14:	f7ff f8c7 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
     f18:	782b      	ldrb	r3, [r5, #0]
     f1a:	2201      	movs	r2, #1
     f1c:	4313      	orrs	r3, r2
     f1e:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f20:	682a      	ldr	r2, [r5, #0]
     f22:	2120      	movs	r1, #32
     f24:	2003      	movs	r0, #3
     f26:	f7ff f970 	bl	20a <mbus_remote_register_write>
    delay(10); 
     f2a:	200a      	movs	r0, #10
     f2c:	f7ff f8bb 	bl	a6 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
     f30:	6833      	ldr	r3, [r6, #0]
     f32:	2180      	movs	r1, #128	; 0x80
     f34:	0389      	lsls	r1, r1, #14
     f36:	430b      	orrs	r3, r1
     f38:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     f3a:	6832      	ldr	r2, [r6, #0]
     f3c:	2121      	movs	r1, #33	; 0x21
     f3e:	2003      	movs	r0, #3
     f40:	f7ff f963 	bl	20a <mbus_remote_register_write>
    delay(100000); 
     f44:	4845      	ldr	r0, [pc, #276]	; (105c <main+0x440>)
     f46:	f7ff f8ae 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
     f4a:	782b      	ldrb	r3, [r5, #0]
     f4c:	2208      	movs	r2, #8
     f4e:	4393      	bics	r3, r2
     f50:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f52:	682a      	ldr	r2, [r5, #0]
     f54:	2120      	movs	r1, #32
     f56:	2003      	movs	r0, #3
     f58:	f7ff f957 	bl	20a <mbus_remote_register_write>
    delay(100);
     f5c:	2064      	movs	r0, #100	; 0x64
     f5e:	f7ff f8a2 	bl	a6 <delay>
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f62:	4b4e      	ldr	r3, [pc, #312]	; (109c <main+0x480>)
     f64:	2101      	movs	r1, #1
     f66:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     f68:	2003      	movs	r0, #3
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f6a:	430a      	orrs	r2, r1
     f6c:	701a      	strb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
     f6e:	781a      	ldrb	r2, [r3, #0]
     f70:	211e      	movs	r1, #30
     f72:	438a      	bics	r2, r1
     f74:	2110      	movs	r1, #16
     f76:	430a      	orrs	r2, r1
     f78:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     f7a:	681a      	ldr	r2, [r3, #0]
     f7c:	2117      	movs	r1, #23
     f7e:	f7ff f944 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f82:	20fa      	movs	r0, #250	; 0xfa
     f84:	40a0      	lsls	r0, r4
     f86:	f7ff f88e 	bl	a6 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     f8a:	4b45      	ldr	r3, [pc, #276]	; (10a0 <main+0x484>)
     f8c:	21f0      	movs	r1, #240	; 0xf0
     f8e:	881a      	ldrh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     f90:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     f92:	438a      	bics	r2, r1
     f94:	2170      	movs	r1, #112	; 0x70
     f96:	430a      	orrs	r2, r1
     f98:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
     f9a:	881a      	ldrh	r2, [r3, #0]
     f9c:	210f      	movs	r1, #15
     f9e:	438a      	bics	r2, r1
     fa0:	4322      	orrs	r2, r4
     fa2:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
     fa4:	8819      	ldrh	r1, [r3, #0]
     fa6:	2280      	movs	r2, #128	; 0x80
     fa8:	0052      	lsls	r2, r2, #1
     faa:	430a      	orrs	r2, r1
     fac:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     fae:	681a      	ldr	r2, [r3, #0]
     fb0:	2101      	movs	r1, #1
     fb2:	f7ff f92a 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     fb6:	20fa      	movs	r0, #250	; 0xfa
     fb8:	40a0      	lsls	r0, r4
     fba:	f7ff f874 	bl	a6 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     fbe:	4b39      	ldr	r3, [pc, #228]	; (10a4 <main+0x488>)
     fc0:	4a39      	ldr	r2, [pc, #228]	; (10a8 <main+0x48c>)
     fc2:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     fc4:	2003      	movs	r0, #3
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    delay(MBUS_DELAY*10);
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     fc6:	400a      	ands	r2, r1
     fc8:	2180      	movs	r1, #128	; 0x80
     fca:	430a      	orrs	r2, r1
     fcc:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     fce:	681a      	ldr	r2, [r3, #0]
     fd0:	1c21      	adds	r1, r4, #0
     fd2:	f7ff f91a 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     fd6:	20fa      	movs	r0, #250	; 0xfa
     fd8:	40a0      	lsls	r0, r4
     fda:	f7ff f864 	bl	a6 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     fde:	4b33      	ldr	r3, [pc, #204]	; (10ac <main+0x490>)
     fe0:	4a33      	ldr	r2, [pc, #204]	; (10b0 <main+0x494>)
     fe2:	6819      	ldr	r1, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     fe4:	2003      	movs	r0, #3
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    delay(MBUS_DELAY*10);
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     fe6:	400a      	ands	r2, r1
     fe8:	21c0      	movs	r1, #192	; 0xc0
     fea:	0289      	lsls	r1, r1, #10
     fec:	430a      	orrs	r2, r1
     fee:	601a      	str	r2, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
     ff0:	681a      	ldr	r2, [r3, #0]
     ff2:	2110      	movs	r1, #16
     ff4:	0b12      	lsrs	r2, r2, #12
     ff6:	0312      	lsls	r2, r2, #12
     ff8:	430a      	orrs	r2, r1
     ffa:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     ffc:	681a      	ldr	r2, [r3, #0]
     ffe:	2105      	movs	r1, #5
    1000:	f7ff f903 	bl	20a <mbus_remote_register_write>
    1004:	e056      	b.n	10b4 <main+0x498>
    1006:	46c0      	nop			; (mov r8, r8)
    1008:	e000e100 	.word	0xe000e100
    100c:	00080f0d 	.word	0x00080f0d
    1010:	00001bac 	.word	0x00001bac
    1014:	deadbee1 	.word	0xdeadbee1
    1018:	a0001200 	.word	0xa0001200
    101c:	a000007c 	.word	0xa000007c
    1020:	00001c04 	.word	0x00001c04
    1024:	00001b94 	.word	0x00001b94
    1028:	00001bb4 	.word	0x00001bb4
    102c:	00001c00 	.word	0x00001c00
    1030:	00001bc8 	.word	0x00001bc8
    1034:	00001bb0 	.word	0x00001bb0
    1038:	00001b9c 	.word	0x00001b9c
    103c:	00001bba 	.word	0x00001bba
    1040:	00001bbc 	.word	0x00001bbc
    1044:	0d020f0f 	.word	0x0d020f0f
    1048:	00001b20 	.word	0x00001b20
    104c:	00001b28 	.word	0x00001b28
    1050:	00001b2c 	.word	0x00001b2c
    1054:	ffdfffff 	.word	0xffdfffff
    1058:	00002710 	.word	0x00002710
    105c:	000186a0 	.word	0x000186a0
    1060:	00001c28 	.word	0x00001c28
    1064:	00001b3c 	.word	0x00001b3c
    1068:	00001b44 	.word	0x00001b44
    106c:	ff7fffff 	.word	0xff7fffff
    1070:	ffefffff 	.word	0xffefffff
    1074:	ffbfffff 	.word	0xffbfffff
    1078:	00001b34 	.word	0x00001b34
    107c:	ff1fffff 	.word	0xff1fffff
    1080:	ffe0007f 	.word	0xffe0007f
    1084:	001ffe80 	.word	0x001ffe80
    1088:	00001b30 	.word	0x00001b30
    108c:	ffff00ff 	.word	0xffff00ff
    1090:	00001b38 	.word	0x00001b38
    1094:	fff7ffff 	.word	0xfff7ffff
    1098:	00001c14 	.word	0x00001c14
    109c:	00001c18 	.word	0x00001c18
    10a0:	00001b14 	.word	0x00001b14
    10a4:	00001b18 	.word	0x00001b18
    10a8:	fffffe7f 	.word	0xfffffe7f
    10ac:	00001b54 	.word	0x00001b54
    10b0:	ff000fff 	.word	0xff000fff
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    10b4:	4bde      	ldr	r3, [pc, #888]	; (1430 <main+0x814>)
    10b6:	2101      	movs	r1, #1
    10b8:	781a      	ldrb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    10ba:	2003      	movs	r0, #3
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    10bc:	438a      	bics	r2, r1
    10be:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    10c0:	681a      	ldr	r2, [r3, #0]
    10c2:	2106      	movs	r1, #6
    10c4:	f7ff f8a1 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10c8:	20fa      	movs	r0, #250	; 0xfa
    10ca:	40a0      	lsls	r0, r4
    10cc:	f7fe ffeb 	bl	a6 <delay>
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    10d0:	4bd8      	ldr	r3, [pc, #864]	; (1434 <main+0x818>)
    10d2:	49d9      	ldr	r1, [pc, #868]	; (1438 <main+0x81c>)
    10d4:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    10d6:	2003      	movs	r0, #3
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    10d8:	430a      	orrs	r2, r1
    10da:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    10dc:	681a      	ldr	r2, [r3, #0]
    10de:	1c01      	adds	r1, r0, #0
    10e0:	f7ff f893 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10e4:	20fa      	movs	r0, #250	; 0xfa
    10e6:	40a0      	lsls	r0, r4
    10e8:	f7fe ffdd 	bl	a6 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    10ec:	4bd3      	ldr	r3, [pc, #844]	; (143c <main+0x820>)
    10ee:	210a      	movs	r1, #10
    10f0:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    10f2:	2003      	movs	r0, #3
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    10f4:	0b12      	lsrs	r2, r2, #12
    10f6:	0312      	lsls	r2, r2, #12
    10f8:	430a      	orrs	r2, r1
    10fa:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    10fc:	681a      	ldr	r2, [r3, #0]
    10fe:	2104      	movs	r1, #4
    1100:	f7ff f883 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1104:	20fa      	movs	r0, #250	; 0xfa
    1106:	40a0      	lsls	r0, r4
    1108:	f7fe ffcd 	bl	a6 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    110c:	4dcc      	ldr	r5, [pc, #816]	; (1440 <main+0x824>)
    110e:	2201      	movs	r2, #1
    1110:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1112:	1c39      	adds	r1, r7, #0
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    1114:	4393      	bics	r3, r2
    1116:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1118:	682a      	ldr	r2, [r5, #0]
    111a:	2003      	movs	r0, #3
    111c:	f7ff f875 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1120:	20fa      	movs	r0, #250	; 0xfa
    1122:	40a0      	lsls	r0, r4
    1124:	f7fe ffbf 	bl	a6 <delay>
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    1128:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    112a:	1c39      	adds	r1, r7, #0
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    112c:	43a3      	bics	r3, r4
    112e:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1130:	682a      	ldr	r2, [r5, #0]
    1132:	2003      	movs	r0, #3
    1134:	f7ff f869 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1138:	20fa      	movs	r0, #250	; 0xfa
    113a:	40a0      	lsls	r0, r4
    113c:	f7fe ffb3 	bl	a6 <delay>

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    1140:	4dc0      	ldr	r5, [pc, #768]	; (1444 <main+0x828>)
    1142:	49c1      	ldr	r1, [pc, #772]	; (1448 <main+0x82c>)
    1144:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1146:	1c20      	adds	r0, r4, #0

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    1148:	400b      	ands	r3, r1
    114a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    114c:	682a      	ldr	r2, [r5, #0]
    114e:	2103      	movs	r1, #3
    1150:	f7ff f85b 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    1154:	682a      	ldr	r2, [r5, #0]
    1156:	2380      	movs	r3, #128	; 0x80
    1158:	02db      	lsls	r3, r3, #11
    115a:	4313      	orrs	r3, r2
    115c:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    115e:	682a      	ldr	r2, [r5, #0]
    1160:	1c20      	adds	r0, r4, #0
    1162:	2103      	movs	r1, #3
    1164:	f7ff f851 	bl	20a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    1168:	4eb8      	ldr	r6, [pc, #736]	; (144c <main+0x830>)
    116a:	227e      	movs	r2, #126	; 0x7e
    116c:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    116e:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    1170:	4393      	bics	r3, r2
    1172:	2210      	movs	r2, #16
    1174:	4313      	orrs	r3, r2
    1176:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1178:	6832      	ldr	r2, [r6, #0]
    117a:	1c39      	adds	r1, r7, #0
    117c:	f7ff f845 	bl	20a <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    1180:	6833      	ldr	r3, [r6, #0]
    1182:	2101      	movs	r1, #1
    1184:	430b      	orrs	r3, r1
    1186:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1188:	6832      	ldr	r2, [r6, #0]
    118a:	1c39      	adds	r1, r7, #0
    118c:	1c20      	adds	r0, r4, #0
    118e:	f7ff f83c 	bl	20a <mbus_remote_register_write>

    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    1192:	48af      	ldr	r0, [pc, #700]	; (1450 <main+0x834>)
    1194:	f7fe ff87 	bl	a6 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    1198:	4bae      	ldr	r3, [pc, #696]	; (1454 <main+0x838>)
    119a:	2103      	movs	r1, #3
    119c:	781a      	ldrb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    119e:	1c20      	adds	r0, r4, #0
    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    11a0:	430a      	orrs	r2, r1
    11a2:	701a      	strb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    11a4:	781a      	ldrb	r2, [r3, #0]
    11a6:	210c      	movs	r1, #12
    11a8:	430a      	orrs	r2, r1
    11aa:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    11ac:	681a      	ldr	r2, [r3, #0]
    11ae:	211f      	movs	r1, #31
    11b0:	f7ff f82b 	bl	20a <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11b4:	4ba8      	ldr	r3, [pc, #672]	; (1458 <main+0x83c>)
    11b6:	210c      	movs	r1, #12
    11b8:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    11ba:	1c20      	adds	r0, r4, #0

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11bc:	0a92      	lsrs	r2, r2, #10
    11be:	0292      	lsls	r2, r2, #10
    11c0:	430a      	orrs	r2, r1
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11c2:	49a6      	ldr	r1, [pc, #664]	; (145c <main+0x840>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11c4:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11c6:	680a      	ldr	r2, [r1, #0]
    11c8:	49a5      	ldr	r1, [pc, #660]	; (1460 <main+0x844>)
    11ca:	0bd2      	lsrs	r2, r2, #15
    11cc:	03d2      	lsls	r2, r2, #15
    11ce:	430a      	orrs	r2, r1
    11d0:	49a2      	ldr	r1, [pc, #648]	; (145c <main+0x840>)
    11d2:	600a      	str	r2, [r1, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    11d4:	6819      	ldr	r1, [r3, #0]
    11d6:	4aa3      	ldr	r2, [pc, #652]	; (1464 <main+0x848>)
    11d8:	400a      	ands	r2, r1
    11da:	21c8      	movs	r1, #200	; 0xc8
    11dc:	01c9      	lsls	r1, r1, #7
    11de:	430a      	orrs	r2, r1
    11e0:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    11e2:	681a      	ldr	r2, [r3, #0]
    11e4:	2112      	movs	r1, #18
    11e6:	f7ff f810 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    11ea:	4b9c      	ldr	r3, [pc, #624]	; (145c <main+0x840>)
    11ec:	1c20      	adds	r0, r4, #0
    11ee:	681a      	ldr	r2, [r3, #0]
    11f0:	2113      	movs	r1, #19
    11f2:	f7ff f80a 	bl	20a <mbus_remote_register_write>
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
    11f6:	4b9c      	ldr	r3, [pc, #624]	; (1468 <main+0x84c>)
    11f8:	2105      	movs	r1, #5
    11fa:	7019      	strb	r1, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
    11fc:	4b9b      	ldr	r3, [pc, #620]	; (146c <main+0x850>)
    11fe:	2204      	movs	r2, #4
    1200:	701a      	strb	r2, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
    1202:	4b9b      	ldr	r3, [pc, #620]	; (1470 <main+0x854>)

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    1204:	2280      	movs	r2, #128	; 0x80
    1206:	1c20      	adds	r0, r4, #0
    1208:	2106      	movs	r1, #6
    120a:	0152      	lsls	r2, r2, #5
    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
    mrr_freq_hopping_step = 4; // determining center freq

    mrr_cfo_val_fine_min = 0x0000;
    120c:	801f      	strh	r7, [r3, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    120e:	f7fe fffc 	bl	20a <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
    1212:	2280      	movs	r2, #128	; 0x80
    1214:	1c20      	adds	r0, r4, #0
    1216:	2108      	movs	r1, #8
    1218:	03d2      	lsls	r2, r2, #15
    121a:	f7fe fff6 	bl	20a <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    121e:	4b95      	ldr	r3, [pc, #596]	; (1474 <main+0x858>)
    1220:	217f      	movs	r1, #127	; 0x7f
    1222:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    1224:	1c20      	adds	r0, r4, #0

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    1226:	438a      	bics	r2, r1
    1228:	2110      	movs	r1, #16
    122a:	430a      	orrs	r2, r1
    122c:	801a      	strh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    122e:	8819      	ldrh	r1, [r3, #0]
    1230:	4a91      	ldr	r2, [pc, #580]	; (1478 <main+0x85c>)
    1232:	400a      	ands	r2, r1
    1234:	2180      	movs	r1, #128	; 0x80
    1236:	0109      	lsls	r1, r1, #4
    1238:	430a      	orrs	r2, r1
    123a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    123c:	681a      	ldr	r2, [r3, #0]
    123e:	2107      	movs	r1, #7
    1240:	f7fe ffe3 	bl	20a <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    1244:	6832      	ldr	r2, [r6, #0]
    1246:	4b8d      	ldr	r3, [pc, #564]	; (147c <main+0x860>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1248:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    124a:	4013      	ands	r3, r2
    124c:	22e0      	movs	r2, #224	; 0xe0
    124e:	40a2      	lsls	r2, r4
    1250:	4313      	orrs	r3, r2
    1252:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1254:	6832      	ldr	r2, [r6, #0]
    1256:	1c39      	adds	r1, r7, #0
    1258:	f7fe ffd7 	bl	20a <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    125c:	4b88      	ldr	r3, [pc, #544]	; (1480 <main+0x864>)
    125e:	2107      	movs	r1, #7
    1260:	681a      	ldr	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    1262:	263f      	movs	r6, #63	; 0x3f
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    1264:	0a92      	lsrs	r2, r2, #10
    1266:	0292      	lsls	r2, r2, #10
    1268:	430a      	orrs	r2, r1
    126a:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    126c:	4a80      	ldr	r2, [pc, #512]	; (1470 <main+0x854>)
    126e:	8811      	ldrh	r1, [r2, #0]
    1270:	6818      	ldr	r0, [r3, #0]
    1272:	4a84      	ldr	r2, [pc, #528]	; (1484 <main+0x868>)
    1274:	4031      	ands	r1, r6
    1276:	0409      	lsls	r1, r1, #16
    1278:	4002      	ands	r2, r0
    127a:	430a      	orrs	r2, r1
    127c:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    127e:	4a7c      	ldr	r2, [pc, #496]	; (1470 <main+0x854>)
    1280:	8811      	ldrh	r1, [r2, #0]
    1282:	6818      	ldr	r0, [r3, #0]
    1284:	4a80      	ldr	r2, [pc, #512]	; (1488 <main+0x86c>)
    1286:	4031      	ands	r1, r6
    1288:	0289      	lsls	r1, r1, #10
    128a:	4002      	ands	r2, r0
    128c:	430a      	orrs	r2, r1
    128e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    1290:	681a      	ldr	r2, [r3, #0]
    1292:	1c20      	adds	r0, r4, #0
    1294:	2101      	movs	r1, #1
    1296:	f7fe ffb8 	bl	20a <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    129a:	4b7c      	ldr	r3, [pc, #496]	; (148c <main+0x870>)
    129c:	497c      	ldr	r1, [pc, #496]	; (1490 <main+0x874>)
    129e:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    12a0:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    12a2:	430a      	orrs	r2, r1
    12a4:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    12a6:	681a      	ldr	r2, [r3, #0]
    12a8:	1c21      	adds	r1, r4, #0
    12aa:	f7fe ffae 	bl	20a <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    12ae:	682a      	ldr	r2, [r5, #0]
    12b0:	4b78      	ldr	r3, [pc, #480]	; (1494 <main+0x878>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12b2:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    12b4:	4013      	ands	r3, r2
    12b6:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12b8:	682a      	ldr	r2, [r5, #0]
    12ba:	2103      	movs	r1, #3
    12bc:	f7fe ffa5 	bl	20a <mbus_remote_register_write>

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12c0:	4b75      	ldr	r3, [pc, #468]	; (1498 <main+0x87c>)
    12c2:	4a76      	ldr	r2, [pc, #472]	; (149c <main+0x880>)
    12c4:	6819      	ldr	r1, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12c6:	4d76      	ldr	r5, [pc, #472]	; (14a0 <main+0x884>)

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12c8:	400a      	ands	r2, r1
    12ca:	601a      	str	r2, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12cc:	682a      	ldr	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    12ce:	1c20      	adds	r0, r4, #0
    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12d0:	43b2      	bics	r2, r6
    12d2:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    12d4:	6829      	ldr	r1, [r5, #0]
    12d6:	4a73      	ldr	r2, [pc, #460]	; (14a4 <main+0x888>)
    12d8:	400a      	ands	r2, r1
    12da:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    12dc:	6829      	ldr	r1, [r5, #0]
    12de:	4a72      	ldr	r2, [pc, #456]	; (14a8 <main+0x88c>)
    12e0:	400a      	ands	r2, r1
    12e2:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    12e4:	681a      	ldr	r2, [r3, #0]
    12e6:	2114      	movs	r1, #20
    12e8:	f7fe ff8f 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
    12ec:	682a      	ldr	r2, [r5, #0]
    12ee:	1c20      	adds	r0, r4, #0
    12f0:	2115      	movs	r1, #21
    12f2:	f7fe ff8a 	bl	20a <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    12f6:	1c20      	adds	r0, r4, #0
    12f8:	1c3a      	adds	r2, r7, #0
    12fa:	2109      	movs	r1, #9
    12fc:	f7fe ff85 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    1300:	1c20      	adds	r0, r4, #0
    1302:	1c3a      	adds	r2, r7, #0
    1304:	210a      	movs	r1, #10
    1306:	f7fe ff80 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    130a:	1c20      	adds	r0, r4, #0
    130c:	1c3a      	adds	r2, r7, #0
    130e:	210b      	movs	r1, #11
    1310:	f7fe ff7b 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    1314:	1c20      	adds	r0, r4, #0
    1316:	210c      	movs	r1, #12
    1318:	4a64      	ldr	r2, [pc, #400]	; (14ac <main+0x890>)
    131a:	f7fe ff76 	bl	20a <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    131e:	4b64      	ldr	r3, [pc, #400]	; (14b0 <main+0x894>)
    1320:	21f8      	movs	r1, #248	; 0xf8
    1322:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1324:	1c20      	adds	r0, r4, #0
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    1326:	438a      	bics	r2, r1
    1328:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    132a:	881a      	ldrh	r2, [r3, #0]
    132c:	21ff      	movs	r1, #255	; 0xff
    132e:	400a      	ands	r2, r1
    1330:	4960      	ldr	r1, [pc, #384]	; (14b4 <main+0x898>)
    1332:	430a      	orrs	r2, r1
    1334:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1336:	681a      	ldr	r2, [r3, #0]
    1338:	2111      	movs	r1, #17
    133a:	f7fe ff66 	bl	20a <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    133e:	4a47      	ldr	r2, [pc, #284]	; (145c <main+0x840>)
    1340:	495d      	ldr	r1, [pc, #372]	; (14b8 <main+0x89c>)
    1342:	6813      	ldr	r3, [r2, #0]
    1344:	22c0      	movs	r2, #192	; 0xc0
    1346:	400b      	ands	r3, r1
    1348:	03d2      	lsls	r2, r2, #15
    134a:	4313      	orrs	r3, r2
    134c:	4a43      	ldr	r2, [pc, #268]	; (145c <main+0x840>)
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    134e:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    1350:	6013      	str	r3, [r2, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1352:	6812      	ldr	r2, [r2, #0]
    1354:	2113      	movs	r1, #19
    1356:	f7fe ff58 	bl	20a <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
    135a:	4a58      	ldr	r2, [pc, #352]	; (14bc <main+0x8a0>)
    135c:	211e      	movs	r1, #30
    135e:	1c20      	adds	r0, r4, #0
    1360:	f7fe ff53 	bl	20a <mbus_remote_register_write>

    // Additional delay for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    1364:	483a      	ldr	r0, [pc, #232]	; (1450 <main+0x834>)
    1366:	f7fe fe9e 	bl	a6 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    136a:	4b55      	ldr	r3, [pc, #340]	; (14c0 <main+0x8a4>)
    136c:	701f      	strb	r7, [r3, #0]
    radio_ready = 0;
    136e:	4b55      	ldr	r3, [pc, #340]	; (14c4 <main+0x8a8>)
    1370:	701f      	strb	r7, [r3, #0]
        pmu_set_sleep_clk(0x1, 0x0, 0x1, 0x0/*V1P2*/);
    }
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based();
    1372:	f7ff f863 	bl	43c <pmu_setting_temp_based>
    // Use the new reset scheme in PMUv3
    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
    1376:	2005      	movs	r0, #5
    1378:	4953      	ldr	r1, [pc, #332]	; (14c8 <main+0x8ac>)
    137a:	f7fe ff8b 	bl	294 <pmu_reg_write>
                 (0 << 10) |    // have the converter have the periodic reset (1'h0)
                 (0 <<  9) |    // enable override setting [8:0] (1'h0)
                 (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                 (0 <<  7) |    // enable override setting [6:0] (1'h0)
                 (52)));        // binary converter's conversion ratio (7'h00)
    pmu_reg_write(0x05,         // default 12'h000
    137e:	2005      	movs	r0, #5
    1380:	4952      	ldr	r1, [pc, #328]	; (14cc <main+0x8b0>)
    1382:	f7fe ff87 	bl	294 <pmu_reg_write>
    }
}

inline static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
    1386:	2186      	movs	r1, #134	; 0x86
    1388:	200e      	movs	r0, #14
    138a:	00c9      	lsls	r1, r1, #3
    138c:	f7fe ff82 	bl	294 <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
    1390:	2045      	movs	r0, #69	; 0x45
    1392:	2148      	movs	r1, #72	; 0x48
    1394:	f7fe ff7e 	bl	294 <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
    1398:	203a      	movs	r0, #58	; 0x3a
    139a:	494d      	ldr	r1, [pc, #308]	; (14d0 <main+0x8b4>)
    139c:	f7fe ff7a 	bl	294 <pmu_reg_write>
}
*/
inline static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    13a0:	203c      	movs	r0, #60	; 0x3c
    13a2:	494c      	ldr	r1, [pc, #304]	; (14d4 <main+0x8b8>)
    13a4:	f7fe ff76 	bl	294 <pmu_reg_write>

inline static void pmu_adc_enable() {
    // PMU ADC will be automatically reset when system wakes up
    // PMU_CONTROLLER_DESIRED_STATE sleep
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
    13a8:	203b      	movs	r0, #59	; 0x3b
    13aa:	494b      	ldr	r1, [pc, #300]	; (14d8 <main+0x8bc>)
    13ac:	f7fe ff72 	bl	294 <pmu_reg_write>
    13b0:	e333      	b.n	1a1a <main+0xdfe>
    if(enumerated != ENUMID) {
        operation_init();
        operation_sleep_notimer();
    }

    update_system_time();
    13b2:	f7ff f951 	bl	658 <update_system_time>
#define MPLIER_SHIFT 6
uint8_t lnt_snt_mplier = 0x52;
uint32_t projected_end_time = 0;

static void update_lnt_timer() {
    if(xo_sys_time > projected_end_time + TIMER_MARGIN 
    13b6:	4b49      	ldr	r3, [pc, #292]	; (14dc <main+0x8c0>)
    13b8:	4a49      	ldr	r2, [pc, #292]	; (14e0 <main+0x8c4>)
    13ba:	681b      	ldr	r3, [r3, #0]
    13bc:	6810      	ldr	r0, [r2, #0]
    13be:	1c59      	adds	r1, r3, #1
    13c0:	31ff      	adds	r1, #255	; 0xff
    13c2:	4288      	cmp	r0, r1
    13c4:	d909      	bls.n	13da <main+0x7be>
	&& xo_sys_time_in_sec - (projected_end_time >> 10) < 256) {
    13c6:	4947      	ldr	r1, [pc, #284]	; (14e4 <main+0x8c8>)
    13c8:	6808      	ldr	r0, [r1, #0]
    13ca:	0a99      	lsrs	r1, r3, #10
    13cc:	1a41      	subs	r1, r0, r1
    13ce:	29ff      	cmp	r1, #255	; 0xff
    13d0:	d803      	bhi.n	13da <main+0x7be>
        lnt_snt_mplier--;
    13d2:	4945      	ldr	r1, [pc, #276]	; (14e8 <main+0x8cc>)
    13d4:	7808      	ldrb	r0, [r1, #0]
    13d6:	3801      	subs	r0, #1
    13d8:	e00d      	b.n	13f6 <main+0x7da>
    }
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
    13da:	1e59      	subs	r1, r3, #1
    13dc:	6810      	ldr	r0, [r2, #0]
    13de:	39ff      	subs	r1, #255	; 0xff
    13e0:	4288      	cmp	r0, r1
    13e2:	d209      	bcs.n	13f8 <main+0x7dc>
		&& (projected_end_time >> 10) - xo_sys_time_in_sec < 256) {
    13e4:	493f      	ldr	r1, [pc, #252]	; (14e4 <main+0x8c8>)
    13e6:	0a98      	lsrs	r0, r3, #10
    13e8:	6809      	ldr	r1, [r1, #0]
    13ea:	1a41      	subs	r1, r0, r1
    13ec:	29ff      	cmp	r1, #255	; 0xff
    13ee:	d803      	bhi.n	13f8 <main+0x7dc>
        lnt_snt_mplier++;
    13f0:	493d      	ldr	r1, [pc, #244]	; (14e8 <main+0x8cc>)
    13f2:	7808      	ldrb	r0, [r1, #0]
    13f4:	3001      	adds	r0, #1
    13f6:	7008      	strb	r0, [r1, #0]
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    13f8:	6811      	ldr	r1, [r2, #0]
    13fa:	20e4      	movs	r0, #228	; 0xe4
    13fc:	1a59      	subs	r1, r3, r1
    13fe:	f7fe fec3 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE4, lnt_snt_mplier);
    1402:	4b39      	ldr	r3, [pc, #228]	; (14e8 <main+0x8cc>)
    }

    update_system_time();
    update_lnt_timer();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    1404:	4d39      	ldr	r5, [pc, #228]	; (14ec <main+0x8d0>)
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
		&& (projected_end_time >> 10) - xo_sys_time_in_sec < 256) {
        lnt_snt_mplier++;
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
    1406:	7819      	ldrb	r1, [r3, #0]
    1408:	20e4      	movs	r0, #228	; 0xe4
    140a:	f7fe febd 	bl	188 <mbus_write_message32>

    update_system_time();
    update_lnt_timer();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    140e:	248c      	movs	r4, #140	; 0x8c
    }

    update_system_time();
    update_lnt_timer();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    1410:	6829      	ldr	r1, [r5, #0]
    1412:	20ee      	movs	r0, #238	; 0xee
    1414:	f7fe feb8 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    1418:	6821      	ldr	r1, [r4, #0]
    141a:	20ee      	movs	r0, #238	; 0xee
    141c:	f7fe feb4 	bl	188 <mbus_write_message32>

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
    1420:	682b      	ldr	r3, [r5, #0]
    1422:	07d9      	lsls	r1, r3, #31
    1424:	d568      	bpl.n	14f8 <main+0x8dc>
        if(!(*GOC_DATA_IRQ)) {
    1426:	6823      	ldr	r3, [r4, #0]
    1428:	2b00      	cmp	r3, #0
    142a:	d161      	bne.n	14f0 <main+0x8d4>
            operation_sleep(); // Need to protect against spurious wakeups
    142c:	f7fe ffc8 	bl	3c0 <operation_sleep>
    1430:	00001c0c 	.word	0x00001c0c
    1434:	00001b4c 	.word	0x00001b4c
    1438:	00ffffff 	.word	0x00ffffff
    143c:	00001b50 	.word	0x00001b50
    1440:	00001b10 	.word	0x00001b10
    1444:	00001b64 	.word	0x00001b64
    1448:	fff7ffff 	.word	0xfff7ffff
    144c:	00001b58 	.word	0x00001b58
    1450:	00004e20 	.word	0x00004e20
    1454:	00001b5c 	.word	0x00001b5c
    1458:	00001b70 	.word	0x00001b70
    145c:	00001b74 	.word	0x00001b74
    1460:	00000451 	.word	0x00000451
    1464:	fff003ff 	.word	0xfff003ff
    1468:	00001b98 	.word	0x00001b98
    146c:	00001bfc 	.word	0x00001bfc
    1470:	00001b8c 	.word	0x00001b8c
    1474:	00001b24 	.word	0x00001b24
    1478:	ffffc07f 	.word	0xffffc07f
    147c:	fffe007f 	.word	0xfffe007f
    1480:	00001c20 	.word	0x00001c20
    1484:	ffc0ffff 	.word	0xffc0ffff
    1488:	ffff03ff 	.word	0xffff03ff
    148c:	00001b60 	.word	0x00001b60
    1490:	00001fff 	.word	0x00001fff
    1494:	ffffbfff 	.word	0xffffbfff
    1498:	00001b78 	.word	0x00001b78
    149c:	fff8ffff 	.word	0xfff8ffff
    14a0:	00001b40 	.word	0x00001b40
    14a4:	fffff03f 	.word	0xfffff03f
    14a8:	fff80fff 	.word	0xfff80fff
    14ac:	007ac800 	.word	0x007ac800
    14b0:	00001b6c 	.word	0x00001b6c
    14b4:	ffffc000 	.word	0xffffc000
    14b8:	ff1fffff 	.word	0xff1fffff
    14bc:	00001002 	.word	0x00001002
    14c0:	00001c08 	.word	0x00001c08
    14c4:	00001b8e 	.word	0x00001b8e
    14c8:	00000834 	.word	0x00000834
    14cc:	00002ab4 	.word	0x00002ab4
    14d0:	00103800 	.word	0x00103800
    14d4:	0017c7ff 	.word	0x0017c7ff
    14d8:	0017efff 	.word	0x0017efff
    14dc:	00001c24 	.word	0x00001c24
    14e0:	00001b94 	.word	0x00001b94
    14e4:	00001bb4 	.word	0x00001bb4
    14e8:	00001b48 	.word	0x00001b48
    14ec:	a000a008 	.word	0xa000a008
        }
        set_goc_cmd();
    14f0:	f7ff fb20 	bl	b34 <set_goc_cmd>
        reset_timers_list();
    14f4:	f7ff f902 	bl	6fc <reset_timers_list>
    }

    lnt_start_meas = 2;
    14f8:	4bc1      	ldr	r3, [pc, #772]	; (1800 <main+0xbe4>)
    14fa:	2202      	movs	r2, #2
    14fc:	701a      	strb	r2, [r3, #0]
    // // Change Counting Time 
    // lntv1a_r03.TIME_COUNTING = 0x000; // Default : 0x258
    // mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    // delay(MBUS_DELAY*10);
    
    set_halt_until_mbus_trx();
    14fe:	f7fe fe3d 	bl	17c <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    1502:	2003      	movs	r0, #3
    1504:	2110      	movs	r1, #16
    1506:	2200      	movs	r2, #0
    1508:	2301      	movs	r3, #1
    150a:	f7fe fe6d 	bl	1e8 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
    150e:	f7fe fe2f 	bl	170 <set_halt_until_mbus_tx>
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    1512:	4bbc      	ldr	r3, [pc, #752]	; (1804 <main+0xbe8>)
    1514:	26a0      	movs	r6, #160	; 0xa0
    1516:	6818      	ldr	r0, [r3, #0]
    1518:	0636      	lsls	r6, r6, #24
    151a:	6831      	ldr	r1, [r6, #0]
    151c:	0600      	lsls	r0, r0, #24
    151e:	4dba      	ldr	r5, [pc, #744]	; (1808 <main+0xbec>)
    1520:	2400      	movs	r4, #0
    1522:	1c02      	adds	r2, r0, #0
    1524:	430a      	orrs	r2, r1
    1526:	1c23      	adds	r3, r4, #0
    1528:	602a      	str	r2, [r5, #0]
    152a:	606b      	str	r3, [r5, #4]
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    152c:	20e0      	movs	r0, #224	; 0xe0
    152e:	682a      	ldr	r2, [r5, #0]
    1530:	686b      	ldr	r3, [r5, #4]
    1532:	1c19      	adds	r1, r3, #0
    1534:	f7fe fe28 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);
    1538:	682a      	ldr	r2, [r5, #0]
    153a:	686b      	ldr	r3, [r5, #4]
    153c:	20e1      	movs	r0, #225	; 0xe1
    153e:	1c11      	adds	r1, r2, #0
    1540:	f7fe fe22 	bl	188 <mbus_write_message32>

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    1544:	4db1      	ldr	r5, [pc, #708]	; (180c <main+0xbf0>)
    1546:	2210      	movs	r2, #16
    1548:	782b      	ldrb	r3, [r5, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    154a:	1c21      	adds	r1, r4, #0
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    154c:	4393      	bics	r3, r2
    154e:	702b      	strb	r3, [r5, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    1550:	782b      	ldrb	r3, [r5, #0]
    1552:	2240      	movs	r2, #64	; 0x40
    1554:	4393      	bics	r3, r2
    1556:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1558:	682a      	ldr	r2, [r5, #0]
    155a:	2003      	movs	r0, #3
    155c:	f7fe fe55 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1560:	48ab      	ldr	r0, [pc, #684]	; (1810 <main+0xbf4>)
    1562:	f7fe fda0 	bl	a6 <delay>
    
    // Reset LNT //lntv1a_r00.RESET_AFE = 0x1; // Default : 0x1
    lntv1a_r00.RESETN_DBE = 0x0; // Default : 0x0
    1566:	782b      	ldrb	r3, [r5, #0]
    1568:	2204      	movs	r2, #4
    156a:	4393      	bics	r3, r2
    156c:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    156e:	682a      	ldr	r2, [r5, #0]
    1570:	2003      	movs	r0, #3
    1572:	1c21      	adds	r1, r4, #0
    1574:	f7fe fe49 	bl	20a <mbus_remote_register_write>
    }

    lnt_start_meas = 2;
    lnt_stop();

    operation_temp_run();
    1578:	f7fe ffbe 	bl	4f8 <operation_temp_run>

inline static void pmu_adc_read_latest() {
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    157c:	2103      	movs	r1, #3
    157e:	1c20      	adds	r0, r4, #0
    1580:	f7fe fe88 	bl	294 <pmu_reg_write>
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
    1584:	6832      	ldr	r2, [r6, #0]
    1586:	4ba3      	ldr	r3, [pc, #652]	; (1814 <main+0xbf8>)
    1588:	801a      	strh	r2, [r3, #0]

    if(read_data_batadc < MRR_VOLT_THRESH) {
    158a:	8819      	ldrh	r1, [r3, #0]
    158c:	4aa2      	ldr	r2, [pc, #648]	; (1818 <main+0xbfc>)
    158e:	294a      	cmp	r1, #74	; 0x4a
    1590:	d801      	bhi.n	1596 <main+0x97a>
        read_data_batadc_diff = 0;
    1592:	8014      	strh	r4, [r2, #0]
    1594:	e002      	b.n	159c <main+0x980>
    }
    else {
        read_data_batadc_diff = read_data_batadc - MRR_VOLT_THRESH;
    1596:	8819      	ldrh	r1, [r3, #0]
    1598:	394b      	subs	r1, #75	; 0x4b
    159a:	8011      	strh	r1, [r2, #0]
    lnt_start_meas = 2;
    lnt_stop();

    operation_temp_run();
    pmu_adc_read_latest();
    mbus_write_message32(0xAA, read_data_batadc);
    159c:	8819      	ldrh	r1, [r3, #0]
    159e:	20aa      	movs	r0, #170	; 0xaa
    15a0:	f7fe fdf2 	bl	188 <mbus_write_message32>

    sys_run_continuous = 0;
    15a4:	4b9d      	ldr	r3, [pc, #628]	; (181c <main+0xc00>)
    15a6:	2200      	movs	r2, #0
    15a8:	701a      	strb	r2, [r3, #0]
    do {
        if(goc_component == 0x00) {
    15aa:	4b9d      	ldr	r3, [pc, #628]	; (1820 <main+0xc04>)
    15ac:	7818      	ldrb	r0, [r3, #0]
    15ae:	2800      	cmp	r0, #0
    15b0:	d11d      	bne.n	15ee <main+0x9d2>
            if(goc_func_id == 0x01) {
    15b2:	4b9c      	ldr	r3, [pc, #624]	; (1824 <main+0xc08>)
    15b4:	781b      	ldrb	r3, [r3, #0]
    15b6:	2b01      	cmp	r3, #1
    15b8:	d10f      	bne.n	15da <main+0x9be>
                if(sys_run_continuous) {
    15ba:	4c98      	ldr	r4, [pc, #608]	; (181c <main+0xc00>)
    15bc:	7823      	ldrb	r3, [r4, #0]
    15be:	2b00      	cmp	r3, #0
    15c0:	d002      	beq.n	15c8 <main+0x9ac>
                    start_xo_cout();
    15c2:	f7fe fdc9 	bl	158 <start_xo_cout>
    15c6:	e001      	b.n	15cc <main+0x9b0>
                }
                else {
                    stop_xo_cout();
    15c8:	f7fe fdcc 	bl	164 <stop_xo_cout>
                }
                sys_run_continuous = !sys_run_continuous;
    15cc:	7823      	ldrb	r3, [r4, #0]
    15ce:	425a      	negs	r2, r3
    15d0:	4153      	adcs	r3, r2
    15d2:	7023      	strb	r3, [r4, #0]
                goc_func_id = 0xFF;
    15d4:	22ff      	movs	r2, #255	; 0xff
    15d6:	4b93      	ldr	r3, [pc, #588]	; (1824 <main+0xc08>)
    15d8:	e10f      	b.n	17fa <main+0xbde>
            }
            else if(goc_func_id == 0x02) {
    15da:	2b02      	cmp	r3, #2
    15dc:	d000      	beq.n	15e0 <main+0x9c4>
    15de:	e1da      	b.n	1996 <main+0xd7a>
                // enter time in minutes
                xo_day_time_in_sec = goc_data * 60;
    15e0:	4b91      	ldr	r3, [pc, #580]	; (1828 <main+0xc0c>)
    15e2:	223c      	movs	r2, #60	; 0x3c
    15e4:	881b      	ldrh	r3, [r3, #0]
    15e6:	435a      	muls	r2, r3
    15e8:	4b90      	ldr	r3, [pc, #576]	; (182c <main+0xc10>)
    15ea:	601a      	str	r2, [r3, #0]
    15ec:	e1d3      	b.n	1996 <main+0xd7a>
            }
        }
        else if(goc_component == 0x01) {
    15ee:	2801      	cmp	r0, #1
    15f0:	d101      	bne.n	15f6 <main+0x9da>
	    set_next_time(START_LNT, 706); // around 7:30 minutes
    15f2:	498f      	ldr	r1, [pc, #572]	; (1830 <main+0xc14>)
    15f4:	e1cd      	b.n	1992 <main+0xd76>
        }
        else if(goc_component == 0x04) {
    15f6:	2804      	cmp	r0, #4
    15f8:	d000      	beq.n	15fc <main+0x9e0>
    15fa:	e1cc      	b.n	1996 <main+0xd7a>
            if(goc_func_id == 0x01) {
    15fc:	4b89      	ldr	r3, [pc, #548]	; (1824 <main+0xc08>)
    15fe:	7818      	ldrb	r0, [r3, #0]
    1600:	2801      	cmp	r0, #1
    1602:	d000      	beq.n	1606 <main+0x9ea>
    1604:	e1c7      	b.n	1996 <main+0xd7a>
		if(goc_state == 0) {
    1606:	4b8b      	ldr	r3, [pc, #556]	; (1834 <main+0xc18>)
    1608:	781a      	ldrb	r2, [r3, #0]
    160a:	2a00      	cmp	r2, #0
    160c:	d103      	bne.n	1616 <main+0x9fa>
		    goc_state = 1;
    160e:	7018      	strb	r0, [r3, #0]
		    lnt_start_meas = 1;
    1610:	4b7b      	ldr	r3, [pc, #492]	; (1800 <main+0xbe4>)
    1612:	7018      	strb	r0, [r3, #0]
    1614:	e1bf      	b.n	1996 <main+0xd7a>
		}
		else if(goc_state == 1) {
    1616:	2a01      	cmp	r2, #1
    1618:	d133      	bne.n	1682 <main+0xa66>
                    goc_state = 2;
    161a:	2002      	movs	r0, #2
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    161c:	4c86      	ldr	r4, [pc, #536]	; (1838 <main+0xc1c>)
		if(goc_state == 0) {
		    goc_state = 1;
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
    161e:	7018      	strb	r0, [r3, #0]
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    1620:	2300      	movs	r3, #0
    1622:	8023      	strh	r3, [r4, #0]

                    snt_counter = 2;    // start code with snt storage
    1624:	4c85      	ldr	r4, [pc, #532]	; (183c <main+0xc20>)
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    1626:	1c19      	adds	r1, r3, #0

                    snt_counter = 2;    // start code with snt storage
    1628:	7020      	strb	r0, [r4, #0]
                    radio_beacon_counter = 0;
    162a:	4885      	ldr	r0, [pc, #532]	; (1840 <main+0xc24>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
    162c:	4c85      	ldr	r4, [pc, #532]	; (1844 <main+0xc28>)
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;

                    snt_counter = 2;    // start code with snt storage
                    radio_beacon_counter = 0;
    162e:	7003      	strb	r3, [r0, #0]
                    radio_counter = 0;
    1630:	4885      	ldr	r0, [pc, #532]	; (1848 <main+0xc2c>)
    1632:	7003      	strb	r3, [r0, #0]

                    mem_light_addr = 0;
    1634:	4885      	ldr	r0, [pc, #532]	; (184c <main+0xc30>)
    1636:	8003      	strh	r3, [r0, #0]
                    mem_light_len = 0;
    1638:	4885      	ldr	r0, [pc, #532]	; (1850 <main+0xc34>)
    163a:	8003      	strh	r3, [r0, #0]
                    mem_temp_addr = 7000;
    163c:	4885      	ldr	r0, [pc, #532]	; (1854 <main+0xc38>)
    163e:	8004      	strh	r4, [r0, #0]
                    mem_temp_len = 0;
    1640:	4885      	ldr	r0, [pc, #532]	; (1858 <main+0xc3c>)

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    1642:	4c7a      	ldr	r4, [pc, #488]	; (182c <main+0xc10>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;
    1644:	8003      	strh	r3, [r0, #0]

		    lnt_start_meas = 0;
    1646:	486e      	ldr	r0, [pc, #440]	; (1800 <main+0xbe4>)
    1648:	7003      	strb	r3, [r0, #0]

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    164a:	4884      	ldr	r0, [pc, #528]	; (185c <main+0xc40>)
    164c:	6806      	ldr	r6, [r0, #0]
    164e:	6825      	ldr	r5, [r4, #0]
    1650:	1b75      	subs	r5, r6, r5
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
    1652:	4e75      	ldr	r6, [pc, #468]	; (1828 <main+0xc0c>)
    1654:	8837      	ldrh	r7, [r6, #0]
    1656:	26e1      	movs	r6, #225	; 0xe1
    1658:	0136      	lsls	r6, r6, #4
    165a:	437e      	muls	r6, r7
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    165c:	19ae      	adds	r6, r5, r6
    165e:	4d80      	ldr	r5, [pc, #512]	; (1860 <main+0xc44>)
    1660:	602e      	str	r6, [r5, #0]
                    xot_timer_list[START_LNT] = 0;
    1662:	606b      	str	r3, [r5, #4]
		    xo_is_day = 0;
    1664:	4b7f      	ldr	r3, [pc, #508]	; (1864 <main+0xc48>)
    1666:	7019      	strb	r1, [r3, #0]
		    xo_last_is_day = 0;
    1668:	4b7f      	ldr	r3, [pc, #508]	; (1868 <main+0xc4c>)
    166a:	7019      	strb	r1, [r3, #0]

                    radio_data_arr[0] = xo_day_time_in_sec;
    166c:	6821      	ldr	r1, [r4, #0]
    166e:	4b7f      	ldr	r3, [pc, #508]	; (186c <main+0xc50>)
    1670:	6019      	str	r1, [r3, #0]
                    radio_data_arr[1] = xo_sys_time_in_sec;
    1672:	6801      	ldr	r1, [r0, #0]
                    radio_data_arr[2] = 0xDEAD;
                    mrr_send_radio_data(1);
    1674:	1c10      	adds	r0, r2, #0
                    xot_timer_list[START_LNT] = 0;
		    xo_is_day = 0;
		    xo_last_is_day = 0;

                    radio_data_arr[0] = xo_day_time_in_sec;
                    radio_data_arr[1] = xo_sys_time_in_sec;
    1676:	6059      	str	r1, [r3, #4]
                    radio_data_arr[2] = 0xDEAD;
    1678:	497d      	ldr	r1, [pc, #500]	; (1870 <main+0xc54>)
    167a:	6099      	str	r1, [r3, #8]
                    mrr_send_radio_data(1);
    167c:	f7ff f8c4 	bl	808 <mrr_send_radio_data>
    1680:	e189      	b.n	1996 <main+0xd7a>
                }

		else if(goc_state == 2) {
    1682:	2a02      	cmp	r2, #2
    1684:	d000      	beq.n	1688 <main+0xa6c>
    1686:	e103      	b.n	1890 <main+0xc74>
                    if(op_counter >= SNT_OP_MAX_COUNT) {
    1688:	4a6b      	ldr	r2, [pc, #428]	; (1838 <main+0xc1c>)
    168a:	4c75      	ldr	r4, [pc, #468]	; (1860 <main+0xc44>)
    168c:	8811      	ldrh	r1, [r2, #0]
    168e:	290c      	cmp	r1, #12
    1690:	d90c      	bls.n	16ac <main+0xa90>
                        goc_state = 3;
    1692:	2203      	movs	r2, #3
    1694:	701a      	strb	r2, [r3, #0]
			reset_timers_list();
    1696:	f7ff f831 	bl	6fc <reset_timers_list>
			update_system_time();
    169a:	f7fe ffdd 	bl	658 <update_system_time>
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
    169e:	4b6f      	ldr	r3, [pc, #444]	; (185c <main+0xc40>)
    16a0:	2296      	movs	r2, #150	; 0x96
    16a2:	681b      	ldr	r3, [r3, #0]
    16a4:	0092      	lsls	r2, r2, #2
    16a6:	189b      	adds	r3, r3, r2
    16a8:	60a3      	str	r3, [r4, #8]
    16aa:	e174      	b.n	1996 <main+0xd7a>
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
    16ac:	6823      	ldr	r3, [r4, #0]
    16ae:	3301      	adds	r3, #1
    16b0:	d124      	bne.n	16fc <main+0xae0>
			    op_counter++;
    16b2:	8813      	ldrh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    16b4:	2000      	movs	r0, #0
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
			    op_counter++;
    16b6:	3301      	adds	r3, #1
    16b8:	8013      	strh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    16ba:	f7fe febf 	bl	43c <pmu_setting_temp_based>

                            // TODO: compensate XO

                            if(++snt_counter >= 3) {
    16be:	4a5f      	ldr	r2, [pc, #380]	; (183c <main+0xc20>)
    16c0:	7813      	ldrb	r3, [r2, #0]
    16c2:	3301      	adds	r3, #1
    16c4:	b2db      	uxtb	r3, r3
    16c6:	7013      	strb	r3, [r2, #0]
    16c8:	2b02      	cmp	r3, #2
    16ca:	d90d      	bls.n	16e8 <main+0xacc>
                                snt_counter = 0;
    16cc:	2300      	movs	r3, #0
    16ce:	7013      	strb	r3, [r2, #0]
                                // TODO: compress this
                                mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) &snt_sys_temp_code, 0);
    16d0:	4c61      	ldr	r4, [pc, #388]	; (1858 <main+0xc3c>)
    16d2:	4a60      	ldr	r2, [pc, #384]	; (1854 <main+0xc38>)
    16d4:	2006      	movs	r0, #6
    16d6:	8811      	ldrh	r1, [r2, #0]
    16d8:	8822      	ldrh	r2, [r4, #0]
    16da:	1889      	adds	r1, r1, r2
    16dc:	4a65      	ldr	r2, [pc, #404]	; (1874 <main+0xc58>)
    16de:	f7fe fda1 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                                mem_temp_len++;
    16e2:	8823      	ldrh	r3, [r4, #0]
    16e4:	3301      	adds	r3, #1
    16e6:	8023      	strh	r3, [r4, #0]
                            }

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
    16e8:	4b5d      	ldr	r3, [pc, #372]	; (1860 <main+0xc44>)
    16ea:	20ea      	movs	r0, #234	; 0xea
    16ec:	6819      	ldr	r1, [r3, #0]
    16ee:	f7fe fd4b 	bl	188 <mbus_write_message32>
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
    16f2:	2196      	movs	r1, #150	; 0x96
    16f4:	2000      	movs	r0, #0
    16f6:	0089      	lsls	r1, r1, #2
    16f8:	f7ff f80c 	bl	714 <set_next_time>
                        }

			xo_is_day = xo_check_is_day();
    16fc:	f7ff f82a 	bl	754 <xo_check_is_day>
    1700:	4c58      	ldr	r4, [pc, #352]	; (1864 <main+0xc48>)

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    1702:	4b3f      	ldr	r3, [pc, #252]	; (1800 <main+0xbe4>)

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
                        }

			xo_is_day = xo_check_is_day();
    1704:	7020      	strb	r0, [r4, #0]

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    1706:	781a      	ldrb	r2, [r3, #0]
    1708:	2a02      	cmp	r2, #2
    170a:	d161      	bne.n	17d0 <main+0xbb4>
                            lnt_start_meas = 0;
    170c:	2200      	movs	r2, #0
    170e:	701a      	strb	r2, [r3, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
    1710:	4e4f      	ldr	r6, [pc, #316]	; (1850 <main+0xc34>)
    1712:	4b4e      	ldr	r3, [pc, #312]	; (184c <main+0xc30>)
    1714:	4d3c      	ldr	r5, [pc, #240]	; (1808 <main+0xbec>)
    1716:	8819      	ldrh	r1, [r3, #0]
    1718:	8833      	ldrh	r3, [r6, #0]
    171a:	2006      	movs	r0, #6
    171c:	18c9      	adds	r1, r1, r3
    171e:	1c2a      	adds	r2, r5, #0
    1720:	2301      	movs	r3, #1
    1722:	f7fe fd7f 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                            mem_light_len += 2;
    1726:	8833      	ldrh	r3, [r6, #0]
    1728:	3302      	adds	r3, #2
    172a:	8033      	strh	r3, [r6, #0]

                            if(xo_is_day) {
    172c:	7823      	ldrb	r3, [r4, #0]
    172e:	2b00      	cmp	r3, #0
    1730:	d060      	beq.n	17f4 <main+0xbd8>
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    1732:	4b51      	ldr	r3, [pc, #324]	; (1878 <main+0xc5c>)
    1734:	6818      	ldr	r0, [r3, #0]
    1736:	6859      	ldr	r1, [r3, #4]
    1738:	682a      	ldr	r2, [r5, #0]
    173a:	686b      	ldr	r3, [r5, #4]
    173c:	4299      	cmp	r1, r3
    173e:	d815      	bhi.n	176c <main+0xb50>
    1740:	d101      	bne.n	1746 <main+0xb2a>
    1742:	4290      	cmp	r0, r2
    1744:	d812      	bhi.n	176c <main+0xb50>
    1746:	2100      	movs	r1, #0
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    1748:	484c      	ldr	r0, [pc, #304]	; (187c <main+0xc60>)
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    174a:	4c2f      	ldr	r4, [pc, #188]	; (1808 <main+0xbec>)
    174c:	4d4c      	ldr	r5, [pc, #304]	; (1880 <main+0xc64>)
    174e:	1c0e      	adds	r6, r1, #0
    1750:	e020      	b.n	1794 <main+0xb78>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1752:	004f      	lsls	r7, r1, #1

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    1754:	682a      	ldr	r2, [r5, #0]
    1756:	686b      	ldr	r3, [r5, #4]
    1758:	5bbf      	ldrh	r7, [r7, r6]
    175a:	2b00      	cmp	r3, #0
    175c:	d101      	bne.n	1762 <main+0xb46>
    175e:	42ba      	cmp	r2, r7
    1760:	d902      	bls.n	1768 <main+0xb4c>
                lnt_cur_level = i + 1;
    1762:	3101      	adds	r1, #1
    1764:	7021      	strb	r1, [r4, #0]
    1766:	e018      	b.n	179a <main+0xb7e>
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
    1768:	3901      	subs	r1, #1
    176a:	e003      	b.n	1774 <main+0xb58>
    176c:	4843      	ldr	r0, [pc, #268]	; (187c <main+0xc60>)
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    176e:	4d26      	ldr	r5, [pc, #152]	; (1808 <main+0xbec>)
    1770:	4e44      	ldr	r6, [pc, #272]	; (1884 <main+0xc68>)
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    1772:	2102      	movs	r1, #2
        for(i = 2; i >= lnt_cur_level; i--) {
    1774:	7803      	ldrb	r3, [r0, #0]
    1776:	1c04      	adds	r4, r0, #0
    1778:	4299      	cmp	r1, r3
    177a:	daea      	bge.n	1752 <main+0xb36>
    177c:	e00d      	b.n	179a <main+0xb7e>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    177e:	004f      	lsls	r7, r1, #1
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    1780:	6822      	ldr	r2, [r4, #0]
    1782:	6863      	ldr	r3, [r4, #4]
    1784:	5b7f      	ldrh	r7, [r7, r5]
    1786:	429e      	cmp	r6, r3
    1788:	d103      	bne.n	1792 <main+0xb76>
    178a:	4297      	cmp	r7, r2
    178c:	d901      	bls.n	1792 <main+0xb76>
                lnt_cur_level = i;
    178e:	7001      	strb	r1, [r0, #0]
    1790:	e003      	b.n	179a <main+0xb7e>
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    1792:	3101      	adds	r1, #1
    1794:	7803      	ldrb	r3, [r0, #0]
    1796:	4299      	cmp	r1, r3
    1798:	dbf1      	blt.n	177e <main+0xb62>
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    179a:	4937      	ldr	r1, [pc, #220]	; (1878 <main+0xc5c>)
    179c:	4b1a      	ldr	r3, [pc, #104]	; (1808 <main+0xbec>)
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    179e:	4d37      	ldr	r5, [pc, #220]	; (187c <main+0xc60>)
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    17a0:	681a      	ldr	r2, [r3, #0]
    17a2:	685b      	ldr	r3, [r3, #4]
    17a4:	600a      	str	r2, [r1, #0]
    17a6:	604b      	str	r3, [r1, #4]
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    17a8:	782b      	ldrb	r3, [r5, #0]
    17aa:	4c37      	ldr	r4, [pc, #220]	; (1888 <main+0xc6c>)
    17ac:	005b      	lsls	r3, r3, #1
    17ae:	5b19      	ldrh	r1, [r3, r4]
    17b0:	20df      	movs	r0, #223	; 0xdf
    17b2:	f7fe fce9 	bl	188 <mbus_write_message32>
    return LNT_INTERVAL[lnt_cur_level];
    17b6:	782b      	ldrb	r3, [r5, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    17b8:	2001      	movs	r0, #1
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    return LNT_INTERVAL[lnt_cur_level];
    17ba:	005b      	lsls	r3, r3, #1
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    17bc:	5b19      	ldrh	r1, [r3, r4]
    17be:	f7fe ffa9 	bl	714 <set_next_time>
				mbus_write_message32(0xEB, LNT_INTERVAL[lnt_cur_level]);
    17c2:	782b      	ldrb	r3, [r5, #0]
    17c4:	20eb      	movs	r0, #235	; 0xeb
    17c6:	005b      	lsls	r3, r3, #1
    17c8:	5b19      	ldrh	r1, [r3, r4]
    17ca:	f7fe fcdd 	bl	188 <mbus_write_message32>
    17ce:	e011      	b.n	17f4 <main+0xbd8>
                            }
                        }
			else if(xot_timer_list[START_LNT] == 0xFFFFFFFF) {
    17d0:	4a23      	ldr	r2, [pc, #140]	; (1860 <main+0xc44>)
    17d2:	6851      	ldr	r1, [r2, #4]
    17d4:	3101      	adds	r1, #1
    17d6:	d101      	bne.n	17dc <main+0xbc0>
                            xot_timer_list[START_LNT] = 0;
    17d8:	2100      	movs	r1, #0
    17da:	e008      	b.n	17ee <main+0xbd2>
                            lnt_start_meas = 1;
                        }

			else if(!xo_last_is_day && xo_is_day) {
    17dc:	4a22      	ldr	r2, [pc, #136]	; (1868 <main+0xc4c>)
    17de:	7812      	ldrb	r2, [r2, #0]
    17e0:	2a00      	cmp	r2, #0
    17e2:	d107      	bne.n	17f4 <main+0xbd8>
    17e4:	7822      	ldrb	r2, [r4, #0]
    17e6:	2a00      	cmp	r2, #0
    17e8:	d004      	beq.n	17f4 <main+0xbd8>
			    // set LNT last timer to SNT current timer for synchronization
			    xot_last_timer_list[START_LNT] = xot_last_timer_list[RUN_SNT];
    17ea:	4a28      	ldr	r2, [pc, #160]	; (188c <main+0xc70>)
    17ec:	6811      	ldr	r1, [r2, #0]
    17ee:	6051      	str	r1, [r2, #4]
			    lnt_start_meas = 1;
    17f0:	2201      	movs	r2, #1
    17f2:	701a      	strb	r2, [r3, #0]
			}

			xo_last_is_day = xo_is_day;
    17f4:	4b1b      	ldr	r3, [pc, #108]	; (1864 <main+0xc48>)
    17f6:	781a      	ldrb	r2, [r3, #0]
    17f8:	4b1b      	ldr	r3, [pc, #108]	; (1868 <main+0xc4c>)
    17fa:	701a      	strb	r2, [r3, #0]
    17fc:	e0cb      	b.n	1996 <main+0xd7a>
    17fe:	46c0      	nop			; (mov r8, r8)
    1800:	00001c1c 	.word	0x00001c1c
    1804:	a0000004 	.word	0xa0000004
    1808:	00001be0 	.word	0x00001be0
    180c:	00001b10 	.word	0x00001b10
    1810:	00002710 	.word	0x00002710
    1814:	00001bc6 	.word	0x00001bc6
    1818:	00001b90 	.word	0x00001b90
    181c:	00001bdd 	.word	0x00001bdd
    1820:	00001baa 	.word	0x00001baa
    1824:	00001bb8 	.word	0x00001bb8
    1828:	00001bc2 	.word	0x00001bc2
    182c:	00001c00 	.word	0x00001c00
    1830:	000002c2 	.word	0x000002c2
    1834:	00001be8 	.word	0x00001be8
    1838:	00001c06 	.word	0x00001c06
    183c:	00001bc4 	.word	0x00001bc4
    1840:	00001bdc 	.word	0x00001bdc
    1844:	00001b58 	.word	0x00001b58
    1848:	00001bc0 	.word	0x00001bc0
    184c:	00001b9a 	.word	0x00001b9a
    1850:	00001bda 	.word	0x00001bda
    1854:	00001bd8 	.word	0x00001bd8
    1858:	00001ba8 	.word	0x00001ba8
    185c:	00001bb4 	.word	0x00001bb4
    1860:	00001bec 	.word	0x00001bec
    1864:	00001bb9 	.word	0x00001bb9
    1868:	00001bde 	.word	0x00001bde
    186c:	00001bcc 	.word	0x00001bcc
    1870:	0000dead 	.word	0x0000dead
    1874:	00001bc8 	.word	0x00001bc8
    1878:	00001ba0 	.word	0x00001ba0
    187c:	00001b9c 	.word	0x00001b9c
    1880:	00001b0a 	.word	0x00001b0a
    1884:	00001afc 	.word	0x00001afc
    1888:	00001b02 	.word	0x00001b02
    188c:	00001b80 	.word	0x00001b80
                    }
                }

		else if(goc_state == 3) {
    1890:	2a03      	cmp	r2, #3
    1892:	d000      	beq.n	1896 <main+0xc7a>
    1894:	e07f      	b.n	1996 <main+0xd7a>
                    // SEND RADIO
                    if(xot_timer_list[SEND_RAD] == 0xFFFFFFFF) {
    1896:	4b84      	ldr	r3, [pc, #528]	; (1aa8 <main+0xe8c>)
    1898:	689b      	ldr	r3, [r3, #8]
    189a:	3301      	adds	r3, #1
    189c:	d000      	beq.n	18a0 <main+0xc84>
    189e:	e07a      	b.n	1996 <main+0xd7a>
                        pmu_setting_temp_based(1);
    18a0:	f7fe fdcc 	bl	43c <pmu_setting_temp_based>

                        if(xo_check_is_day()) {
    18a4:	f7fe ff56 	bl	754 <xo_check_is_day>
    18a8:	2800      	cmp	r0, #0
    18aa:	d06f      	beq.n	198c <main+0xd70>
                            // send beacon
                            reset_radio_data_arr();
    18ac:	f7fe fcea 	bl	284 <reset_radio_data_arr>
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    18b0:	4a7e      	ldr	r2, [pc, #504]	; (1aac <main+0xe90>)
    18b2:	4b7f      	ldr	r3, [pc, #508]	; (1ab0 <main+0xe94>)
                            radio_data_arr[1] = snt_sys_temp_code;

                            mrr_send_radio_data(0);
    18b4:	2000      	movs	r0, #0
                        pmu_setting_temp_based(1);

                        if(xo_check_is_day()) {
                            // send beacon
                            reset_radio_data_arr();
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    18b6:	781b      	ldrb	r3, [r3, #0]
    18b8:	8811      	ldrh	r1, [r2, #0]
    18ba:	22dd      	movs	r2, #221	; 0xdd
    18bc:	0612      	lsls	r2, r2, #24
    18be:	430a      	orrs	r2, r1
    18c0:	041b      	lsls	r3, r3, #16
    18c2:	431a      	orrs	r2, r3
    18c4:	4b7b      	ldr	r3, [pc, #492]	; (1ab4 <main+0xe98>)
    18c6:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = snt_sys_temp_code;
    18c8:	4a7b      	ldr	r2, [pc, #492]	; (1ab8 <main+0xe9c>)
    18ca:	6812      	ldr	r2, [r2, #0]
    18cc:	605a      	str	r2, [r3, #4]

                            mrr_send_radio_data(0);
    18ce:	f7fe ff9b 	bl	808 <mrr_send_radio_data>

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
    18d2:	4b7a      	ldr	r3, [pc, #488]	; (1abc <main+0xea0>)
    18d4:	781a      	ldrb	r2, [r3, #0]
    18d6:	3201      	adds	r2, #1
    18d8:	b2d2      	uxtb	r2, r2
    18da:	701a      	strb	r2, [r3, #0]
    18dc:	2a05      	cmp	r2, #5
    18de:	d80f      	bhi.n	1900 <main+0xce4>
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    18e0:	4c73      	ldr	r4, [pc, #460]	; (1ab0 <main+0xe94>)
    18e2:	4b74      	ldr	r3, [pc, #464]	; (1ab4 <main+0xe98>)
    18e4:	7822      	ldrb	r2, [r4, #0]
                            radio_data_arr[1] = radio_beacon_counter;
                            radio_data_arr[2] = 0xFEED;

                            mrr_send_radio_data(1);
    18e6:	2001      	movs	r0, #1
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    18e8:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = radio_beacon_counter;
    18ea:	4a74      	ldr	r2, [pc, #464]	; (1abc <main+0xea0>)
    18ec:	7812      	ldrb	r2, [r2, #0]
    18ee:	605a      	str	r2, [r3, #4]
                            radio_data_arr[2] = 0xFEED;
    18f0:	4a73      	ldr	r2, [pc, #460]	; (1ac0 <main+0xea4>)
    18f2:	609a      	str	r2, [r3, #8]

                            mrr_send_radio_data(1);
    18f4:	f7fe ff88 	bl	808 <mrr_send_radio_data>

                            radio_counter++;
    18f8:	7823      	ldrb	r3, [r4, #0]
    18fa:	3301      	adds	r3, #1
    18fc:	7023      	strb	r3, [r4, #0]
    18fe:	e045      	b.n	198c <main+0xd70>

                            mrr_send_radio_data(0);

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
    1900:	2400      	movs	r4, #0
    1902:	701c      	strb	r4, [r3, #0]
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
    1904:	4b6f      	ldr	r3, [pc, #444]	; (1ac4 <main+0xea8>)
    1906:	20b0      	movs	r0, #176	; 0xb0
    1908:	8819      	ldrh	r1, [r3, #0]
    190a:	f7fe fc3d 	bl	188 <mbus_write_message32>
                                for(i = 0; i < mem_light_len; i += 2) {
    190e:	e016      	b.n	193e <main+0xd22>
                                    reset_radio_data_arr();
    1910:	f7fe fcb8 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    1914:	f7fe fc32 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
    1918:	4b6b      	ldr	r3, [pc, #428]	; (1ac8 <main+0xeac>)
    191a:	4d66      	ldr	r5, [pc, #408]	; (1ab4 <main+0xe98>)
    191c:	8819      	ldrh	r1, [r3, #0]
    191e:	2201      	movs	r2, #1
    1920:	1909      	adds	r1, r1, r4
    1922:	9200      	str	r2, [sp, #0]
    1924:	2006      	movs	r0, #6
    1926:	1c2b      	adds	r3, r5, #0
    1928:	f7fe fc96 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    192c:	f7fe fc20 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    1930:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1932:	2000      	movs	r0, #0
                                for(i = 0; i < mem_light_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    1934:	b29b      	uxth	r3, r3
    1936:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1938:	f7fe ff66 	bl	808 <mrr_send_radio_data>
                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
                                for(i = 0; i < mem_light_len; i += 2) {
    193c:	3402      	adds	r4, #2
    193e:	4b61      	ldr	r3, [pc, #388]	; (1ac4 <main+0xea8>)
    1940:	881b      	ldrh	r3, [r3, #0]
    1942:	429c      	cmp	r4, r3
    1944:	dbe4      	blt.n	1910 <main+0xcf4>
				    radio_data_arr[2] &= 0x0000FFFF;

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
    1946:	4b61      	ldr	r3, [pc, #388]	; (1acc <main+0xeb0>)
    1948:	20b1      	movs	r0, #177	; 0xb1
    194a:	8819      	ldrh	r1, [r3, #0]
    194c:	f7fe fc1c 	bl	188 <mbus_write_message32>
				for(i = 0; i < mem_temp_len; i += 2) {
    1950:	2400      	movs	r4, #0
    1952:	e016      	b.n	1982 <main+0xd66>
                                    reset_radio_data_arr();
    1954:	f7fe fc96 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    1958:	f7fe fc10 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
    195c:	4b5c      	ldr	r3, [pc, #368]	; (1ad0 <main+0xeb4>)
    195e:	4d55      	ldr	r5, [pc, #340]	; (1ab4 <main+0xe98>)
    1960:	8819      	ldrh	r1, [r3, #0]
    1962:	2201      	movs	r2, #1
    1964:	1909      	adds	r1, r1, r4
    1966:	9200      	str	r2, [sp, #0]
    1968:	2006      	movs	r0, #6
    196a:	1c2b      	adds	r3, r5, #0
    196c:	f7fe fc74 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    1970:	f7fe fbfe 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    1974:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1976:	2000      	movs	r0, #0
				for(i = 0; i < mem_temp_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    1978:	b29b      	uxth	r3, r3
    197a:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    197c:	f7fe ff44 	bl	808 <mrr_send_radio_data>

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
				for(i = 0; i < mem_temp_len; i += 2) {
    1980:	3402      	adds	r4, #2
    1982:	4b52      	ldr	r3, [pc, #328]	; (1acc <main+0xeb0>)
    1984:	881b      	ldrh	r3, [r3, #0]
    1986:	429c      	cmp	r4, r3
    1988:	dbe4      	blt.n	1954 <main+0xd38>
    198a:	e7a9      	b.n	18e0 <main+0xcc4>
                            mrr_send_radio_data(1);

                            radio_counter++;
                        }

                        set_next_time(SEND_RAD, 600); // FIXME: set to 600
    198c:	2002      	movs	r0, #2
    198e:	2196      	movs	r1, #150	; 0x96
    1990:	4081      	lsls	r1, r0
    1992:	f7fe febf 	bl	714 <set_next_time>
                    }
                }
            }
        }
    } while(sys_run_continuous);
    1996:	4b4f      	ldr	r3, [pc, #316]	; (1ad4 <main+0xeb8>)
    1998:	781c      	ldrb	r4, [r3, #0]
    199a:	2c00      	cmp	r4, #0
    199c:	d000      	beq.n	19a0 <main+0xd84>
    199e:	e604      	b.n	15aa <main+0x98e>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    19a0:	f7fe fe5a 	bl	658 <update_system_time>
    uint8_t i;
    if(lnt_start_meas == 1) {
    19a4:	4b4c      	ldr	r3, [pc, #304]	; (1ad8 <main+0xebc>)
    19a6:	781b      	ldrb	r3, [r3, #0]
    19a8:	2b01      	cmp	r3, #1
    19aa:	d103      	bne.n	19b4 <main+0xd98>
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    19ac:	4b4b      	ldr	r3, [pc, #300]	; (1adc <main+0xec0>)
    19ae:	681c      	ldr	r4, [r3, #0]
    19b0:	3432      	adds	r4, #50	; 0x32
    19b2:	e00e      	b.n	19d2 <main+0xdb6>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    19b4:	1c23      	adds	r3, r4, #0
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    19b6:	4a3c      	ldr	r2, [pc, #240]	; (1aa8 <main+0xe8c>)

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    19b8:	2401      	movs	r4, #1
    19ba:	4264      	negs	r4, r4
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    19bc:	0099      	lsls	r1, r3, #2
    19be:	5888      	ldr	r0, [r1, r2]
    19c0:	2800      	cmp	r0, #0
    19c2:	d003      	beq.n	19cc <main+0xdb0>
    19c4:	5888      	ldr	r0, [r1, r2]
    19c6:	42a0      	cmp	r0, r4
    19c8:	d800      	bhi.n	19cc <main+0xdb0>
                min_time = xot_timer_list[i];
    19ca:	588c      	ldr	r4, [r1, r2]
    19cc:	3301      	adds	r3, #1
    uint8_t i;
    if(lnt_start_meas == 1) {
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    19ce:	2b03      	cmp	r3, #3
    19d0:	d1f4      	bne.n	19bc <main+0xda0>
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    19d2:	1c63      	adds	r3, r4, #1
    19d4:	d100      	bne.n	19d8 <main+0xdbc>
    19d6:	e529      	b.n	142c <main+0x810>
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    19d8:	2001      	movs	r0, #1
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    19da:	4a33      	ldr	r2, [pc, #204]	; (1aa8 <main+0xe8c>)
                xot_last_timer_list[i] = xot_timer_list[i];
    19dc:	4940      	ldr	r1, [pc, #256]	; (1ae0 <main+0xec4>)
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    19de:	2500      	movs	r5, #0
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    19e0:	4240      	negs	r0, r0
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    19e2:	00ab      	lsls	r3, r5, #2
    19e4:	589e      	ldr	r6, [r3, r2]
    19e6:	2e00      	cmp	r6, #0
    19e8:	d005      	beq.n	19f6 <main+0xdda>
    19ea:	589e      	ldr	r6, [r3, r2]
    19ec:	42a6      	cmp	r6, r4
    19ee:	d802      	bhi.n	19f6 <main+0xdda>
                xot_last_timer_list[i] = xot_timer_list[i];
    19f0:	589e      	ldr	r6, [r3, r2]
    19f2:	505e      	str	r6, [r3, r1]
                xot_timer_list[i] = 0xFFFFFFFF;
    19f4:	5098      	str	r0, [r3, r2]
    19f6:	3501      	adds	r5, #1
        }
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    19f8:	2d03      	cmp	r5, #3
    19fa:	d1f2      	bne.n	19e2 <main+0xdc6>
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
}

static void set_lnt_timer(uint32_t end_time) {
    mbus_write_message32(0xCE, end_time);
    19fc:	20ce      	movs	r0, #206	; 0xce
    19fe:	1c21      	adds	r1, r4, #0
    1a00:	f7fe fbc2 	bl	188 <mbus_write_message32>
    projected_end_time = end_time << 10;
    1a04:	4a37      	ldr	r2, [pc, #220]	; (1ae4 <main+0xec8>)
    1a06:	02a3      	lsls	r3, r4, #10
    1a08:	6013      	str	r3, [r2, #0]

    if(end_time <= xo_sys_time_in_sec) {
    1a0a:	4a34      	ldr	r2, [pc, #208]	; (1adc <main+0xec0>)
    1a0c:	6812      	ldr	r2, [r2, #0]
    1a0e:	4294      	cmp	r4, r2
    1a10:	d805      	bhi.n	1a1e <main+0xe02>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
    1a12:	20af      	movs	r0, #175	; 0xaf
    1a14:	2100      	movs	r1, #0
    1a16:	f7fe fbb7 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
    1a1a:	f7fe fce1 	bl	3e0 <operation_sleep_notimer>

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a1e:	4a32      	ldr	r2, [pc, #200]	; (1ae8 <main+0xecc>)
    uint32_t val = temp >> (MPLIER_SHIFT + 8);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1a20:	1c28      	adds	r0, r5, #0

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a22:	6811      	ldr	r1, [r2, #0]
    1a24:	4a31      	ldr	r2, [pc, #196]	; (1aec <main+0xed0>)
    1a26:	1a5b      	subs	r3, r3, r1
    1a28:	7811      	ldrb	r1, [r2, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a2a:	2640      	movs	r6, #64	; 0x40

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a2c:	4359      	muls	r1, r3
    uint32_t val = temp >> (MPLIER_SHIFT + 8);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    1a2e:	4b30      	ldr	r3, [pc, #192]	; (1af0 <main+0xed4>)
    1a30:	0b89      	lsrs	r1, r1, #14
    1a32:	681a      	ldr	r2, [r3, #0]
    1a34:	0e12      	lsrs	r2, r2, #24
    1a36:	0612      	lsls	r2, r2, #24
    1a38:	430a      	orrs	r2, r1
    1a3a:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1a3c:	681a      	ldr	r2, [r3, #0]
    1a3e:	1c29      	adds	r1, r5, #0
    1a40:	f7fe fbe3 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1a44:	4c2b      	ldr	r4, [pc, #172]	; (1af4 <main+0xed8>)
    1a46:	2208      	movs	r2, #8
    1a48:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a4a:	1c28      	adds	r0, r5, #0
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1a4c:	4393      	bics	r3, r2
    1a4e:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    1a50:	7823      	ldrb	r3, [r4, #0]
    1a52:	2204      	movs	r2, #4
    1a54:	4313      	orrs	r3, r2
    1a56:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a58:	6822      	ldr	r2, [r4, #0]
    1a5a:	2100      	movs	r1, #0
    1a5c:	f7fe fbd5 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1a60:	20fa      	movs	r0, #250	; 0xfa
    1a62:	0080      	lsls	r0, r0, #2
    1a64:	f7fe fb1f 	bl	a6 <delay>
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    1a68:	7823      	ldrb	r3, [r4, #0]
    1a6a:	2210      	movs	r2, #16
    1a6c:	4313      	orrs	r3, r2
    1a6e:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a70:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1a72:	2220      	movs	r2, #32
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a74:	43b3      	bics	r3, r6
    1a76:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1a78:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a7a:	1c28      	adds	r0, r5, #0
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1a7c:	4393      	bics	r3, r2
    1a7e:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a80:	6822      	ldr	r2, [r4, #0]
    1a82:	2100      	movs	r1, #0
    1a84:	f7fe fbc1 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1a88:	20fa      	movs	r0, #250	; 0xfa
    1a8a:	0080      	lsls	r0, r0, #2
    1a8c:	f7fe fb0b 	bl	a6 <delay>

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1a90:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a92:	1c28      	adds	r0, r5, #0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1a94:	431e      	orrs	r6, r3
    1a96:	7026      	strb	r6, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a98:	6822      	ldr	r2, [r4, #0]
    1a9a:	2100      	movs	r1, #0
    1a9c:	f7fe fbb5 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1aa0:	4815      	ldr	r0, [pc, #84]	; (1af8 <main+0xedc>)
    1aa2:	f7fe fb00 	bl	a6 <delay>
    1aa6:	e4c1      	b.n	142c <main+0x810>
    1aa8:	00001bec 	.word	0x00001bec
    1aac:	00001bc6 	.word	0x00001bc6
    1ab0:	00001bc0 	.word	0x00001bc0
    1ab4:	00001bcc 	.word	0x00001bcc
    1ab8:	00001bc8 	.word	0x00001bc8
    1abc:	00001bdc 	.word	0x00001bdc
    1ac0:	0000feed 	.word	0x0000feed
    1ac4:	00001bda 	.word	0x00001bda
    1ac8:	00001b9a 	.word	0x00001b9a
    1acc:	00001ba8 	.word	0x00001ba8
    1ad0:	00001bd8 	.word	0x00001bd8
    1ad4:	00001bdd 	.word	0x00001bdd
    1ad8:	00001c1c 	.word	0x00001c1c
    1adc:	00001bb4 	.word	0x00001bb4
    1ae0:	00001b80 	.word	0x00001b80
    1ae4:	00001c24 	.word	0x00001c24
    1ae8:	00001b94 	.word	0x00001b94
    1aec:	00001b48 	.word	0x00001b48
    1af0:	00001b4c 	.word	0x00001b4c
    1af4:	00001b10 	.word	0x00001b10
    1af8:	00002710 	.word	0x00002710
