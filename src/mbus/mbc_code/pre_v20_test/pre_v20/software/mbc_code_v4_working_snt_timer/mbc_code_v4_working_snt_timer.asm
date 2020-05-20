
mbc_code_v4_working_snt_timer/mbc_code_v4_working_snt_timer.elf:     file format elf32-littlearm


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
 290:	00001ce4 	.word	0x00001ce4

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

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2b0:	0e05      	lsrs	r5, r0, #24
 2b2:	26ff      	movs	r6, #255	; 0xff
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2b4:	026d      	lsls	r5, r5, #9

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2b6:	1c07      	adds	r7, r0, #0
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2b8:	9500      	str	r5, [sp, #0]
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2ba:	1c2a      	adds	r2, r5, #0

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2bc:	4037      	ands	r7, r6
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 2be:	0a05      	lsrs	r5, r0, #8
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2c0:	23c0      	movs	r3, #192	; 0xc0

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2c2:	4035      	ands	r5, r6
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2c4:	021b      	lsls	r3, r3, #8
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 2c6:	017f      	lsls	r7, r7, #5
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2c8:	431a      	orrs	r2, r3
                 (r <<  9) |    // frequency multiplier r
 2ca:	432f      	orrs	r7, r5
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
 2cc:	1c04      	adds	r4, r0, #0
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 2ce:	4317      	orrs	r7, r2
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 2d0:	0c24      	lsrs	r4, r4, #16

    // mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2d2:	1c39      	adds	r1, r7, #0
 2d4:	2016      	movs	r0, #22

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 2d6:	4026      	ands	r6, r4
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2d8:	9201      	str	r2, [sp, #4]
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 2da:	0176      	lsls	r6, r6, #5

    // mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2dc:	f7ff ffda 	bl	294 <pmu_reg_write>
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 2e0:	1c39      	adds	r1, r7, #0
 2e2:	2016      	movs	r0, #22
 2e4:	f7ff ffd6 	bl	294 <pmu_reg_write>
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 2e8:	9b01      	ldr	r3, [sp, #4]

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2ea:	1c31      	adds	r1, r6, #0
 2ec:	4329      	orrs	r1, r5
                 (l <<  5) |    // frequency multiplier l
 2ee:	4319      	orrs	r1, r3
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
 2f0:	2018      	movs	r0, #24
 2f2:	f7ff ffcf 	bl	294 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2f6:	9a00      	ldr	r2, [sp, #0]
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 2f8:	201a      	movs	r0, #26
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2fa:	4316      	orrs	r6, r2
                 (l <<  5) |    // frequency multiplier l
 2fc:	1c31      	adds	r1, r6, #0
 2fe:	4329      	orrs	r1, r5
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 300:	f7ff ffc8 	bl	294 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
 304:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.pmu_set_sar_conversion_ratio:

00000306 <pmu_set_sar_conversion_ratio>:
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
 306:	b510      	push	{r4, lr}
 308:	1c04      	adds	r4, r0, #0
    uint8_t i;
    for(i = 0; i < 2; i++) {
	    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 30a:	1c21      	adds	r1, r4, #0
 30c:	2005      	movs	r0, #5
 30e:	f7ff ffc1 	bl	294 <pmu_reg_write>
		     (0 << 12) |    // let vdd_clk always connect to vbat
		     (i << 11) |    // enable override setting [10] (1'h0)
		     (0 << 10) |    // have the converter have the periodic reset (1'h0)
		     (i <<  9) |    // enable override setting [8:0] (1'h0)
		     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
		     (i <<  7) |    // enable override setting [6:0] (1'h0)
 312:	21aa      	movs	r1, #170	; 0xaa
 314:	0189      	lsls	r1, r1, #6
 316:	4321      	orrs	r1, r4
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
    uint8_t i;
    for(i = 0; i < 2; i++) {
	    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 318:	2005      	movs	r0, #5
 31a:	f7ff ffbb 	bl	294 <pmu_reg_write>
		     (i <<  9) |    // enable override setting [8:0] (1'h0)
		     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
		     (i <<  7) |    // enable override setting [6:0] (1'h0)
		     (ratio)));  // binary converter's conversion ratio (7'h00)
    }
}
 31e:	bd10      	pop	{r4, pc}

Disassembly of section .text.pmu_setting_temp_based:

00000320 <pmu_setting_temp_based>:

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 320:	b5f0      	push	{r4, r5, r6, r7, lr}
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 322:	4a27      	ldr	r2, [pc, #156]	; (3c0 <pmu_setting_temp_based+0xa0>)
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 324:	4927      	ldr	r1, [pc, #156]	; (3c4 <pmu_setting_temp_based+0xa4>)
 326:	b085      	sub	sp, #20
 328:	2300      	movs	r3, #0
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
 32a:	2406      	movs	r4, #6
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 32c:	18cd      	adds	r5, r1, r3
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 32e:	6816      	ldr	r6, [r2, #0]
 330:	696d      	ldr	r5, [r5, #20]
 332:	42ae      	cmp	r6, r5
 334:	d33c      	bcc.n	3b0 <pmu_setting_temp_based+0x90>
 336:	b264      	sxtb	r4, r4
            if(mode == 0) {
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 338:	00a2      	lsls	r2, r4, #2
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
            if(mode == 0) {
 33a:	2800      	cmp	r0, #0
 33c:	d105      	bne.n	34a <pmu_setting_temp_based+0x2a>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 33e:	4b22      	ldr	r3, [pc, #136]	; (3c8 <pmu_setting_temp_based+0xa8>)
 340:	58d0      	ldr	r0, [r2, r3]
 342:	f7ff ffb4 	bl	2ae <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
 346:	4b21      	ldr	r3, [pc, #132]	; (3cc <pmu_setting_temp_based+0xac>)
 348:	e02e      	b.n	3a8 <pmu_setting_temp_based+0x88>
            }
            else if(mode == 2) {
 34a:	2802      	cmp	r0, #2
 34c:	d127      	bne.n	39e <pmu_setting_temp_based+0x7e>
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 34e:	4b20      	ldr	r3, [pc, #128]	; (3d0 <pmu_setting_temp_based+0xb0>)

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 350:	27ff      	movs	r7, #255	; 0xff
            if(mode == 0) {
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
            }
            else if(mode == 2) {
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 352:	58d5      	ldr	r5, [r2, r3]
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 354:	23c0      	movs	r3, #192	; 0xc0

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 356:	0e2e      	lsrs	r6, r5, #24

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 358:	0276      	lsls	r6, r6, #9
 35a:	9601      	str	r6, [sp, #4]
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 35c:	1c32      	adds	r2, r6, #0
//                  (base)));      // floor frequency base (0-63)
// }

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 35e:	0c2e      	lsrs	r6, r5, #16

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 360:	403e      	ands	r6, r7
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 362:	0176      	lsls	r6, r6, #5
 364:	9603      	str	r6, [sp, #12]

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 366:	9903      	ldr	r1, [sp, #12]
// }

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 368:	0a2e      	lsrs	r6, r5, #8
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 36a:	021b      	lsls	r3, r3, #8

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 36c:	403e      	ands	r6, r7
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 36e:	431a      	orrs	r2, r3
                 (r <<  9) |    // frequency multiplier r
 370:	4331      	orrs	r1, r6
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 372:	4311      	orrs	r1, r2
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 374:	2017      	movs	r0, #23

    pmu_setting_temp_based(2);
    operation_sleep();

    while(1);
}
 376:	403d      	ands	r5, r7
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 378:	9202      	str	r2, [sp, #8]
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 37a:	f7ff ff8b 	bl	294 <pmu_reg_write>
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 37e:	9b02      	ldr	r3, [sp, #8]
 380:	0169      	lsls	r1, r5, #5
                ((0 << 19) |    // enable pdm even during periodic reset
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
 382:	4331      	orrs	r1, r6
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 384:	4319      	orrs	r1, r3
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
 386:	2015      	movs	r0, #21
 388:	f7ff ff84 	bl	294 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 38c:	9901      	ldr	r1, [sp, #4]
 38e:	9a03      	ldr	r2, [sp, #12]
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 390:	2019      	movs	r0, #25
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 392:	4311      	orrs	r1, r2
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 394:	4331      	orrs	r1, r6
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 396:	f7ff ff7d 	bl	294 <pmu_reg_write>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
            }
            else if(mode == 2) {
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_SLEEP_SAR_SETTINGS[i]);
 39a:	4b0e      	ldr	r3, [pc, #56]	; (3d4 <pmu_setting_temp_based+0xb4>)
 39c:	e004      	b.n	3a8 <pmu_setting_temp_based+0x88>
            }
            else {
	        pmu_set_active_clk(PMU_RADIO_SETTINGS[i]);
 39e:	4b0e      	ldr	r3, [pc, #56]	; (3d8 <pmu_setting_temp_based+0xb8>)
 3a0:	58d0      	ldr	r0, [r2, r3]
 3a2:	f7ff ff84 	bl	2ae <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_RADIO_SAR_SETTINGS[i]);
 3a6:	4b0d      	ldr	r3, [pc, #52]	; (3dc <pmu_setting_temp_based+0xbc>)
 3a8:	5d18      	ldrb	r0, [r3, r4]
 3aa:	f7ff ffac 	bl	306 <pmu_set_sar_conversion_ratio>
 3ae:	e005      	b.n	3bc <pmu_setting_temp_based+0x9c>
// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
 3b0:	3c01      	subs	r4, #1
 3b2:	b2e4      	uxtb	r4, r4
 3b4:	3b04      	subs	r3, #4
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 3b6:	2c00      	cmp	r4, #0
 3b8:	d1b8      	bne.n	32c <pmu_setting_temp_based+0xc>
 3ba:	e7bc      	b.n	336 <pmu_setting_temp_based+0x16>
            }
            break;
        }
    }
    return;
}
 3bc:	b005      	add	sp, #20
 3be:	bdf0      	pop	{r4, r5, r6, r7, pc}
 3c0:	00001ce0 	.word	0x00001ce0
 3c4:	00001c04 	.word	0x00001c04
 3c8:	00001ba0 	.word	0x00001ba0
 3cc:	00001c23 	.word	0x00001c23
 3d0:	00001be0 	.word	0x00001be0
 3d4:	00001c1c 	.word	0x00001c1c
 3d8:	00001bc4 	.word	0x00001bc4
 3dc:	00001bbc 	.word	0x00001bbc

Disassembly of section .text.radio_power_off:

000003e0 <radio_power_off>:
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    delay(MBUS_DELAY*5); // Freq stab

}

static void radio_power_off() {
 3e0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 3e2:	4c2c      	ldr	r4, [pc, #176]	; (494 <radio_power_off+0xb4>)
 3e4:	2601      	movs	r6, #1
 3e6:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 3e8:	2002      	movs	r0, #2

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 3ea:	43b3      	bics	r3, r6
 3ec:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 3ee:	6822      	ldr	r2, [r4, #0]
 3f0:	2100      	movs	r1, #0
 3f2:	f7ff ff0a 	bl	20a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 3f6:	6823      	ldr	r3, [r4, #0]
 3f8:	227e      	movs	r2, #126	; 0x7e
 3fa:	4393      	bics	r3, r2
 3fc:	2220      	movs	r2, #32
 3fe:	4313      	orrs	r3, r2
 400:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 402:	6822      	ldr	r2, [r4, #0]
 404:	2002      	movs	r0, #2
 406:	2100      	movs	r1, #0
 408:	f7ff feff 	bl	20a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 40c:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 40e:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 410:	4333      	orrs	r3, r6
 412:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 414:	6822      	ldr	r2, [r4, #0]
 416:	2100      	movs	r1, #0
 418:	f7ff fef7 	bl	20a <mbus_remote_register_write>

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 41c:	4b1e      	ldr	r3, [pc, #120]	; (498 <radio_power_off+0xb8>)
 41e:	4a1f      	ldr	r2, [pc, #124]	; (49c <radio_power_off+0xbc>)
 420:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 422:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 424:	400a      	ands	r2, r1
 426:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 428:	681a      	ldr	r2, [r3, #0]
 42a:	2103      	movs	r1, #3
 42c:	f7ff feed 	bl	20a <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 430:	4b1b      	ldr	r3, [pc, #108]	; (4a0 <radio_power_off+0xc0>)
 432:	2704      	movs	r7, #4
 434:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 436:	2502      	movs	r5, #2

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 438:	43ba      	bics	r2, r7
 43a:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 43c:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 43e:	1c28      	adds	r0, r5, #0
    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 440:	43aa      	bics	r2, r5
 442:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 444:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 446:	2111      	movs	r1, #17
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 448:	4332      	orrs	r2, r6
 44a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 44c:	681a      	ldr	r2, [r3, #0]
 44e:	f7ff fedc 	bl	20a <mbus_remote_register_write>

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 452:	4c14      	ldr	r4, [pc, #80]	; (4a4 <radio_power_off+0xc4>)
 454:	2208      	movs	r2, #8
 456:	6823      	ldr	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 458:	1c28      	adds	r0, r5, #0
    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 45a:	4313      	orrs	r3, r2
 45c:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
 45e:	6823      	ldr	r3, [r4, #0]
 460:	2220      	movs	r2, #32
 462:	4393      	bics	r3, r2
 464:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
 466:	6823      	ldr	r3, [r4, #0]
 468:	2210      	movs	r2, #16
 46a:	4313      	orrs	r3, r2
 46c:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 46e:	1c39      	adds	r1, r7, #0
 470:	6822      	ldr	r2, [r4, #0]
 472:	f7ff feca 	bl	20a <mbus_remote_register_write>

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 476:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 478:	1c28      	adds	r0, r5, #0
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 47a:	43b3      	bics	r3, r6
 47c:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 47e:	6822      	ldr	r2, [r4, #0]
 480:	1c39      	adds	r1, r7, #0
 482:	f7ff fec2 	bl	20a <mbus_remote_register_write>

    radio_on = 0;
 486:	4a08      	ldr	r2, [pc, #32]	; (4a8 <radio_power_off+0xc8>)
 488:	2300      	movs	r3, #0
 48a:	7013      	strb	r3, [r2, #0]
    radio_ready = 0;
 48c:	4a07      	ldr	r2, [pc, #28]	; (4ac <radio_power_off+0xcc>)
 48e:	7013      	strb	r3, [r2, #0]

}
 490:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 492:	46c0      	nop			; (mov r8, r8)
 494:	00001c94 	.word	0x00001c94
 498:	00001c30 	.word	0x00001c30
 49c:	ffefffff 	.word	0xffefffff
 4a0:	00001c68 	.word	0x00001c68
 4a4:	00001c90 	.word	0x00001c90
 4a8:	00001d20 	.word	0x00001d20
 4ac:	00001ca6 	.word	0x00001ca6

Disassembly of section .text.operation_sleep:

000004b0 <operation_sleep>:

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
 4b0:	b508      	push	{r3, lr}
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;
 4b2:	2200      	movs	r2, #0
 4b4:	238c      	movs	r3, #140	; 0x8c
 4b6:	601a      	str	r2, [r3, #0]

#ifdef USE_MRR
    if(radio_on) {
 4b8:	4b04      	ldr	r3, [pc, #16]	; (4cc <operation_sleep+0x1c>)
 4ba:	781b      	ldrb	r3, [r3, #0]
 4bc:	4293      	cmp	r3, r2
 4be:	d001      	beq.n	4c4 <operation_sleep+0x14>
    	radio_power_off();
 4c0:	f7ff ff8e 	bl	3e0 <radio_power_off>
    }
#endif

    mbus_sleep_all();
 4c4:	f7ff fe8a 	bl	1dc <mbus_sleep_all>
 4c8:	e7fe      	b.n	4c8 <operation_sleep+0x18>
 4ca:	46c0      	nop			; (mov r8, r8)
 4cc:	00001d20 	.word	0x00001d20

Disassembly of section .text.operation_sleep_notimer:

000004d0 <operation_sleep_notimer>:
    while(1);
}

static void operation_sleep_notimer( void ) {
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 4d0:	2000      	movs	r0, #0

    mbus_sleep_all();
    while(1);
}

static void operation_sleep_notimer( void ) {
 4d2:	b508      	push	{r3, lr}
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 4d4:	1c01      	adds	r1, r0, #0
 4d6:	1c02      	adds	r2, r0, #0
 4d8:	f7ff fe0a 	bl	f0 <set_wakeup_timer>
    set_xo_timer(0, 0, 0, 0);
 4dc:	2000      	movs	r0, #0
 4de:	1c01      	adds	r1, r0, #0
 4e0:	1c02      	adds	r2, r0, #0
 4e2:	1c03      	adds	r3, r0, #0
 4e4:	f7ff fe1a 	bl	11c <set_xo_timer>
    config_timer32(0, 0, 0, 0);
 4e8:	2000      	movs	r0, #0
 4ea:	1c01      	adds	r1, r0, #0
 4ec:	1c02      	adds	r2, r0, #0
 4ee:	1c03      	adds	r3, r0, #0
 4f0:	f7ff fde4 	bl	bc <config_timer32>
    // TODO: reset SNT timer
    operation_sleep();
 4f4:	f7ff ffdc 	bl	4b0 <operation_sleep>

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
 5e0:	f7ff ff76 	bl	4d0 <operation_sleep_notimer>
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
 640:	00001cc8 	.word	0x00001cc8
 644:	00001c78 	.word	0x00001c78
 648:	00001c7c 	.word	0x00001c7c
 64c:	00001d1c 	.word	0x00001d1c
 650:	a0001100 	.word	0xa0001100
 654:	00001ce0 	.word	0x00001ce0

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
 6dc:	00001ccc 	.word	0x00001ccc
 6e0:	00001cc4 	.word	0x00001cc4
 6e4:	deadbee1 	.word	0xdeadbee1
 6e8:	a0000004 	.word	0xa0000004
 6ec:	00001cac 	.word	0x00001cac
 6f0:	00001d18 	.word	0x00001d18
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
 710:	00001d04 	.word	0x00001d04

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
 748:	00001c98 	.word	0x00001c98
 74c:	00001d04 	.word	0x00001d04
 750:	00001ccc 	.word	0x00001ccc

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
 774:	00001d18 	.word	0x00001d18
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
 7f4:	00001ce4 	.word	0x00001ce4
 7f8:	0000ffff 	.word	0x0000ffff
 7fc:	00003ffd 	.word	0x00003ffd
 800:	ffffc002 	.word	0xffffc002
 804:	00001d3c 	.word	0x00001d3c

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
 a66:	f7ff fd33 	bl	4d0 <operation_sleep_notimer>
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
 ac4:	f7ff fc8c 	bl	3e0 <radio_power_off>
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
 ae4:	00001d20 	.word	0x00001d20
 ae8:	00001c94 	.word	0x00001c94
 aec:	00001c30 	.word	0x00001c30
 af0:	fffbffff 	.word	0xfffbffff
 af4:	fff7ffff 	.word	0xfff7ffff
 af8:	00001c90 	.word	0x00001c90
 afc:	00001c68 	.word	0x00001c68
 b00:	00001ce4 	.word	0x00001ce4
 b04:	00001ca6 	.word	0x00001ca6
 b08:	00001cb0 	.word	0x00001cb0
 b0c:	a0001200 	.word	0xa0001200
 b10:	a000007c 	.word	0xa000007c
 b14:	00001d40 	.word	0x00001d40
 b18:	ffc0ffff 	.word	0xffc0ffff
 b1c:	ffff03ff 	.word	0xffff03ff
 b20:	00001d1c 	.word	0x00001d1c
 b24:	a0001100 	.word	0xa0001100
 b28:	000032c8 	.word	0x000032c8
 b2c:	00001d14 	.word	0x00001d14
 b30:	00001d10 	.word	0x00001d10

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
 b6c:	00001cc2 	.word	0x00001cc2
 b70:	00001cd0 	.word	0x00001cd0
 b74:	00001cda 	.word	0x00001cda
 b78:	00001d00 	.word	0x00001d00
 b7c:	00001ccc 	.word	0x00001ccc
 b80:	00001c98 	.word	0x00001c98

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
 bc4:	00001d1c 	.word	0x00001d1c

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
     c2e:	e3b4      	b.n	139a <main+0x77e>
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
     c40:	1c3a      	adds	r2, r7, #0
     c42:	1c39      	adds	r1, r7, #0
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

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     c98:	20ba      	movs	r0, #186	; 0xba
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
     c9a:	601f      	str	r7, [r3, #0]
    xo_sys_time_in_sec = 0;
     c9c:	4be2      	ldr	r3, [pc, #904]	; (1028 <main+0x40c>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     c9e:	2402      	movs	r4, #2

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
     ca4:	2601      	movs	r6, #1
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
     caa:	4326      	orrs	r6, r4

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
     cb6:	701f      	strb	r7, [r3, #0]

    // Initialization
    // xo_init();

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     cb8:	f7ff fa66 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);
     cbc:	49df      	ldr	r1, [pc, #892]	; (103c <main+0x420>)
     cbe:	20ed      	movs	r0, #237	; 0xed
     cc0:	f7ff fa62 	bl	188 <mbus_write_message32>



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     cc4:	4bde      	ldr	r3, [pc, #888]	; (1040 <main+0x424>)
     cc6:	2140      	movs	r1, #64	; 0x40
     cc8:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     cca:	2004      	movs	r0, #4
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);



#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     ccc:	438a      	bics	r2, r1
     cce:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
     cd0:	881a      	ldrh	r2, [r3, #0]
     cd2:	2180      	movs	r1, #128	; 0x80
     cd4:	438a      	bics	r2, r1
     cd6:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     cd8:	681a      	ldr	r2, [r3, #0]
     cda:	2101      	movs	r1, #1
     cdc:	f7ff fa95 	bl	20a <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     ce0:	4bd8      	ldr	r3, [pc, #864]	; (1044 <main+0x428>)
     ce2:	21ff      	movs	r1, #255	; 0xff
     ce4:	881a      	ldrh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     ce6:	2004      	movs	r0, #4
#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     ce8:	400a      	ands	r2, r1
     cea:	2180      	movs	r1, #128	; 0x80
     cec:	0149      	lsls	r1, r1, #5
     cee:	430a      	orrs	r2, r1
     cf0:	801a      	strh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     cf2:	881a      	ldrh	r2, [r3, #0]
     cf4:	21ff      	movs	r1, #255	; 0xff
     cf6:	438a      	bics	r2, r1
     cf8:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     cfa:	681a      	ldr	r2, [r3, #0]
     cfc:	2107      	movs	r1, #7
     cfe:	f7ff fa84 	bl	20a <mbus_remote_register_write>
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d02:	22fc      	movs	r2, #252	; 0xfc
     d04:	2380      	movs	r3, #128	; 0x80
     d06:	4316      	orrs	r6, r2
     d08:	021b      	lsls	r3, r3, #8
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     d0a:	4dcf      	ldr	r5, [pc, #828]	; (1048 <main+0x42c>)
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d0c:	431e      	orrs	r6, r3
     d0e:	2380      	movs	r3, #128	; 0x80
     d10:	031b      	lsls	r3, r3, #12
     d12:	431e      	orrs	r6, r3
    // sntv4_r08.TMR_EN_OSC = 0x0; // Default : 0x0
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
     d14:	782b      	ldrb	r3, [r5, #0]
     d16:	2240      	movs	r2, #64	; 0x40
     d18:	4393      	bics	r3, r2
     d1a:	702b      	strb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d1c:	2180      	movs	r1, #128	; 0x80
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     d1e:	782b      	ldrb	r3, [r5, #0]
    return temp_code;
}

static inline void snt_clk_init() {	// NOTE: now using LNT TIMER
    
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
     d20:	03c9      	lsls	r1, r1, #15
     d22:	430e      	orrs	r6, r1
    // mbus_remote_register_write(SNT_ADDR,0x08,sntv4_r08.as_int);
    // delay(100);

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
     d24:	2120      	movs	r1, #32
     d26:	438b      	bics	r3, r1
     d28:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d2a:	682a      	ldr	r2, [r5, #0]
     d2c:	2004      	movs	r0, #4
     d2e:	2108      	movs	r1, #8
     d30:	f7ff fa6b 	bl	20a <mbus_remote_register_write>

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     d34:	4ac5      	ldr	r2, [pc, #788]	; (104c <main+0x430>)
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d36:	2004      	movs	r0, #4
    sntv4_r08.TMR_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);

    // delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
     d38:	4016      	ands	r6, r2
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d3a:	1c32      	adds	r2, r6, #0
     d3c:	2109      	movs	r1, #9
     d3e:	f7ff fa64 	bl	20a <mbus_remote_register_write>

    sntv4_r08.TMR_EN_OSC = 1;
     d42:	782b      	ldrb	r3, [r5, #0]
     d44:	2108      	movs	r1, #8
     d46:	430b      	orrs	r3, r1
     d48:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d4a:	682a      	ldr	r2, [r5, #0]
     d4c:	2004      	movs	r0, #4
     d4e:	f7ff fa5c 	bl	20a <mbus_remote_register_write>
    delay(10000);
     d52:	48bf      	ldr	r0, [pc, #764]	; (1050 <main+0x434>)
     d54:	f7ff f9a7 	bl	a6 <delay>

    sntv4_r08.TMR_RESETB = 1;
     d58:	782b      	ldrb	r3, [r5, #0]
     d5a:	2210      	movs	r2, #16
     d5c:	4313      	orrs	r3, r2
     d5e:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DIV = 1;
     d60:	782b      	ldrb	r3, [r5, #0]
     d62:	2104      	movs	r1, #4
     d64:	430b      	orrs	r3, r1
     d66:	702b      	strb	r3, [r5, #0]
    sntv4_r08.TMR_RESETB_DCDC = 1;
     d68:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d6a:	1c08      	adds	r0, r1, #0
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r08.TMR_RESETB = 1;
    sntv4_r08.TMR_RESETB_DIV = 1;
    sntv4_r08.TMR_RESETB_DCDC = 1;
     d6c:	4323      	orrs	r3, r4
     d6e:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d70:	682a      	ldr	r2, [r5, #0]
     d72:	2108      	movs	r1, #8
     d74:	f7ff fa49 	bl	20a <mbus_remote_register_write>
    delay(10000);	// need to wait for clock to stabilize
     d78:	48b5      	ldr	r0, [pc, #724]	; (1050 <main+0x434>)
     d7a:	f7ff f994 	bl	a6 <delay>

    sntv4_r08.TMR_EN_SELF_CLK = 1;
     d7e:	782b      	ldrb	r3, [r5, #0]
     d80:	2201      	movs	r2, #1
     d82:	4313      	orrs	r3, r2
     d84:	702b      	strb	r3, [r5, #0]
    sntv4_r09.TMR_SELF_EN = 1;
     d86:	2380      	movs	r3, #128	; 0x80
     d88:	039b      	lsls	r3, r3, #14
     d8a:	431e      	orrs	r6, r3
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     d8c:	682a      	ldr	r2, [r5, #0]
     d8e:	2004      	movs	r0, #4
     d90:	2108      	movs	r1, #8
     d92:	f7ff fa3a 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
     d96:	1c32      	adds	r2, r6, #0
     d98:	2109      	movs	r1, #9
     d9a:	2004      	movs	r0, #4
     d9c:	f7ff fa35 	bl	20a <mbus_remote_register_write>
    delay(100000);
     da0:	48ac      	ldr	r0, [pc, #688]	; (1054 <main+0x438>)
     da2:	f7ff f980 	bl	a6 <delay>

    sntv4_r08.TMR_EN_OSC = 0;
     da6:	782b      	ldrb	r3, [r5, #0]
     da8:	2108      	movs	r1, #8
     daa:	438b      	bics	r3, r1
     dac:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
     dae:	682a      	ldr	r2, [r5, #0]
     db0:	2004      	movs	r0, #4
     db2:	f7ff fa2a 	bl	20a <mbus_remote_register_write>
    delay(10000);
     db6:	48a6      	ldr	r0, [pc, #664]	; (1050 <main+0x434>)
     db8:	f7ff f975 	bl	a6 <delay>

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     dbc:	4ba6      	ldr	r3, [pc, #664]	; (1058 <main+0x43c>)
    sntv4_r1A.WUP_THRESHOLD = 0;
     dbe:	4da7      	ldr	r5, [pc, #668]	; (105c <main+0x440>)

    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
     dc0:	781a      	ldrb	r2, [r3, #0]
     dc2:	701f      	strb	r7, [r3, #0]
    sntv4_r1A.WUP_THRESHOLD = 0;
     dc4:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     dc6:	2004      	movs	r0, #4
    sntv4_r08.TMR_EN_OSC = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);

    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
     dc8:	0e12      	lsrs	r2, r2, #24
     dca:	0612      	lsls	r2, r2, #24
     dcc:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
     dce:	681a      	ldr	r2, [r3, #0]
     dd0:	2119      	movs	r1, #25
     dd2:	f7ff fa1a 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);
     dd6:	682a      	ldr	r2, [r5, #0]
     dd8:	2004      	movs	r0, #4
     dda:	211a      	movs	r1, #26
     ddc:	f7ff fa15 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 0;
     de0:	4d9f      	ldr	r5, [pc, #636]	; (1060 <main+0x444>)
     de2:	4ba0      	ldr	r3, [pc, #640]	; (1064 <main+0x448>)
     de4:	682a      	ldr	r2, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     de6:	2004      	movs	r0, #4
    sntv4_r19.WUP_THRESHOLD_EXT = 0;
    sntv4_r1A.WUP_THRESHOLD = 0;
    mbus_remote_register_write(SNT_ADDR, 0x19, sntv4_r19.as_int);
    mbus_remote_register_write(SNT_ADDR, 0x1A, sntv4_r1A.as_int);

    sntv4_r17.WUP_ENABLE = 0;
     de8:	4013      	ands	r3, r2
     dea:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     dec:	682a      	ldr	r2, [r5, #0]
     dee:	2117      	movs	r1, #23
     df0:	f7ff fa0b 	bl	20a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 1;
     df4:	682a      	ldr	r2, [r5, #0]
     df6:	2380      	movs	r3, #128	; 0x80
     df8:	041b      	lsls	r3, r3, #16
     dfa:	4313      	orrs	r3, r2
     dfc:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_CLK_SEL = 0;
     dfe:	682a      	ldr	r2, [r5, #0]
     e00:	4b99      	ldr	r3, [pc, #612]	; (1068 <main+0x44c>)
    sntv4_r17.WUP_LC_IRQ_EN = 0;
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e02:	2004      	movs	r0, #4

    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
     e04:	4013      	ands	r3, r2
     e06:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     e08:	682a      	ldr	r2, [r5, #0]
     e0a:	4b98      	ldr	r3, [pc, #608]	; (106c <main+0x450>)
    sntv4_r17.WUP_AUTO_RESET = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e0c:	2117      	movs	r1, #23
    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
    sntv4_r17.WUP_LC_IRQ_EN = 0;
     e0e:	4013      	ands	r3, r2
     e10:	602b      	str	r3, [r5, #0]
    sntv4_r17.WUP_AUTO_RESET = 0;
     e12:	682b      	ldr	r3, [r5, #0]
     e14:	4a8d      	ldr	r2, [pc, #564]	; (104c <main+0x430>)
     e16:	4013      	ands	r3, r2
     e18:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
     e1a:	682a      	ldr	r2, [r5, #0]
     e1c:	f7ff f9f5 	bl	20a <mbus_remote_register_write>
    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    snt_clk_init();
    operation_temp_run();
     e20:	f7ff fb6a 	bl	4f8 <operation_temp_run>

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     e24:	4b92      	ldr	r3, [pc, #584]	; (1070 <main+0x454>)
     e26:	4993      	ldr	r1, [pc, #588]	; (1074 <main+0x458>)
     e28:	681a      	ldr	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e2a:	2003      	movs	r0, #3

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     e2c:	400a      	ands	r2, r1
     e2e:	2180      	movs	r1, #128	; 0x80
     e30:	0389      	lsls	r1, r1, #14
     e32:	430a      	orrs	r2, r1
     e34:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     e36:	6819      	ldr	r1, [r3, #0]
     e38:	4a8f      	ldr	r2, [pc, #572]	; (1078 <main+0x45c>)
     e3a:	400a      	ands	r2, r1
     e3c:	498f      	ldr	r1, [pc, #572]	; (107c <main+0x460>)
     e3e:	430a      	orrs	r2, r1
     e40:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     e42:	681a      	ldr	r2, [r3, #0]
     e44:	2140      	movs	r1, #64	; 0x40
     e46:	430a      	orrs	r2, r1
     e48:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e4a:	681a      	ldr	r2, [r3, #0]
     e4c:	2122      	movs	r1, #34	; 0x22
     e4e:	f7ff f9dc 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e52:	20fa      	movs	r0, #250	; 0xfa
     e54:	40a0      	lsls	r0, r4
     e56:	f7ff f926 	bl	a6 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     e5a:	4e89      	ldr	r6, [pc, #548]	; (1080 <main+0x464>)
     e5c:	4b89      	ldr	r3, [pc, #548]	; (1084 <main+0x468>)
     e5e:	6832      	ldr	r2, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e60:	21fc      	movs	r1, #252	; 0xfc
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     e62:	4013      	ands	r3, r2
     e64:	2280      	movs	r2, #128	; 0x80
     e66:	0212      	lsls	r2, r2, #8
     e68:	4313      	orrs	r3, r2
     e6a:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e6c:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e6e:	2201      	movs	r2, #1
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     e70:	430b      	orrs	r3, r1
     e72:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     e74:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e76:	2121      	movs	r1, #33	; 0x21
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     e78:	4323      	orrs	r3, r4
     e7a:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e7c:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e7e:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     e80:	4313      	orrs	r3, r2
     e82:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     e84:	6832      	ldr	r2, [r6, #0]
     e86:	f7ff f9c0 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e8a:	20fa      	movs	r0, #250	; 0xfa
     e8c:	40a0      	lsls	r0, r4
     e8e:	f7ff f90a 	bl	a6 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     e92:	4b7d      	ldr	r3, [pc, #500]	; (1088 <main+0x46c>)
     e94:	497d      	ldr	r1, [pc, #500]	; (108c <main+0x470>)
     e96:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     e98:	2003      	movs	r0, #3
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     e9a:	400a      	ands	r2, r1
     e9c:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     e9e:	681a      	ldr	r2, [r3, #0]
     ea0:	2140      	movs	r1, #64	; 0x40
     ea2:	f7ff f9b2 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ea6:	20fa      	movs	r0, #250	; 0xfa
     ea8:	40a0      	lsls	r0, r4
     eaa:	f7ff f8fc 	bl	a6 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     eae:	6833      	ldr	r3, [r6, #0]
     eb0:	4a66      	ldr	r2, [pc, #408]	; (104c <main+0x430>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     eb2:	2121      	movs	r1, #33	; 0x21
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     eb4:	4013      	ands	r3, r2
     eb6:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     eb8:	6832      	ldr	r2, [r6, #0]
     eba:	2003      	movs	r0, #3
     ebc:	f7ff f9a5 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ec0:	20fa      	movs	r0, #250	; 0xfa
     ec2:	40a0      	lsls	r0, r4
     ec4:	f7ff f8ef 	bl	a6 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     ec8:	4d71      	ldr	r5, [pc, #452]	; (1090 <main+0x474>)
     eca:	2108      	movs	r1, #8
     ecc:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     ece:	2003      	movs	r0, #3
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     ed0:	430b      	orrs	r3, r1
     ed2:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     ed4:	682a      	ldr	r2, [r5, #0]
     ed6:	2120      	movs	r1, #32
     ed8:	f7ff f997 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     edc:	20fa      	movs	r0, #250	; 0xfa
     ede:	40a0      	lsls	r0, r4
     ee0:	f7ff f8e1 	bl	a6 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
     ee4:	782b      	ldrb	r3, [r5, #0]
     ee6:	2210      	movs	r2, #16
     ee8:	4313      	orrs	r3, r2
     eea:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
     eec:	782b      	ldrb	r3, [r5, #0]
     eee:	2104      	movs	r1, #4
     ef0:	430b      	orrs	r3, r1
     ef2:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     ef4:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     ef6:	2120      	movs	r1, #32
    delay(MBUS_DELAY*10);
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     ef8:	4323      	orrs	r3, r4
     efa:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     efc:	682a      	ldr	r2, [r5, #0]
     efe:	2003      	movs	r0, #3
     f00:	f7ff f983 	bl	20a <mbus_remote_register_write>
    delay(2000); 
     f04:	20fa      	movs	r0, #250	; 0xfa
     f06:	00c0      	lsls	r0, r0, #3
     f08:	f7ff f8cd 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
     f0c:	782b      	ldrb	r3, [r5, #0]
     f0e:	2201      	movs	r2, #1
     f10:	4313      	orrs	r3, r2
     f12:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f14:	682a      	ldr	r2, [r5, #0]
     f16:	2120      	movs	r1, #32
     f18:	2003      	movs	r0, #3
     f1a:	f7ff f976 	bl	20a <mbus_remote_register_write>
    delay(10); 
     f1e:	200a      	movs	r0, #10
     f20:	f7ff f8c1 	bl	a6 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
     f24:	6833      	ldr	r3, [r6, #0]
     f26:	2180      	movs	r1, #128	; 0x80
     f28:	0389      	lsls	r1, r1, #14
     f2a:	430b      	orrs	r3, r1
     f2c:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     f2e:	6832      	ldr	r2, [r6, #0]
     f30:	2121      	movs	r1, #33	; 0x21
     f32:	2003      	movs	r0, #3
     f34:	f7ff f969 	bl	20a <mbus_remote_register_write>
    delay(100000); 
     f38:	4846      	ldr	r0, [pc, #280]	; (1054 <main+0x438>)
     f3a:	f7ff f8b4 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
     f3e:	782b      	ldrb	r3, [r5, #0]
     f40:	2208      	movs	r2, #8
     f42:	4393      	bics	r3, r2
     f44:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f46:	682a      	ldr	r2, [r5, #0]
     f48:	2120      	movs	r1, #32
     f4a:	2003      	movs	r0, #3
     f4c:	f7ff f95d 	bl	20a <mbus_remote_register_write>
    delay(100);
     f50:	2064      	movs	r0, #100	; 0x64
     f52:	f7ff f8a8 	bl	a6 <delay>
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f56:	4b4f      	ldr	r3, [pc, #316]	; (1094 <main+0x478>)
     f58:	2101      	movs	r1, #1
     f5a:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     f5c:	2003      	movs	r0, #3
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f5e:	430a      	orrs	r2, r1
     f60:	701a      	strb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
     f62:	781a      	ldrb	r2, [r3, #0]
     f64:	211e      	movs	r1, #30
     f66:	438a      	bics	r2, r1
     f68:	2110      	movs	r1, #16
     f6a:	430a      	orrs	r2, r1
     f6c:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     f6e:	681a      	ldr	r2, [r3, #0]
     f70:	2117      	movs	r1, #23
     f72:	f7ff f94a 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f76:	20fa      	movs	r0, #250	; 0xfa
     f78:	40a0      	lsls	r0, r4
     f7a:	f7ff f894 	bl	a6 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     f7e:	4b46      	ldr	r3, [pc, #280]	; (1098 <main+0x47c>)
     f80:	21f0      	movs	r1, #240	; 0xf0
     f82:	881a      	ldrh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     f84:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     f86:	438a      	bics	r2, r1
     f88:	2170      	movs	r1, #112	; 0x70
     f8a:	430a      	orrs	r2, r1
     f8c:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
     f8e:	881a      	ldrh	r2, [r3, #0]
     f90:	210f      	movs	r1, #15
     f92:	438a      	bics	r2, r1
     f94:	4322      	orrs	r2, r4
     f96:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
     f98:	8819      	ldrh	r1, [r3, #0]
     f9a:	2280      	movs	r2, #128	; 0x80
     f9c:	0052      	lsls	r2, r2, #1
     f9e:	430a      	orrs	r2, r1
     fa0:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     fa2:	681a      	ldr	r2, [r3, #0]
     fa4:	2101      	movs	r1, #1
     fa6:	f7ff f930 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     faa:	20fa      	movs	r0, #250	; 0xfa
     fac:	40a0      	lsls	r0, r4
     fae:	f7ff f87a 	bl	a6 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     fb2:	4b3a      	ldr	r3, [pc, #232]	; (109c <main+0x480>)
     fb4:	4a3a      	ldr	r2, [pc, #232]	; (10a0 <main+0x484>)
     fb6:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     fb8:	2003      	movs	r0, #3
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    delay(MBUS_DELAY*10);
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     fba:	400a      	ands	r2, r1
     fbc:	2180      	movs	r1, #128	; 0x80
     fbe:	430a      	orrs	r2, r1
     fc0:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
     fc2:	681a      	ldr	r2, [r3, #0]
     fc4:	1c21      	adds	r1, r4, #0
     fc6:	f7ff f920 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     fca:	20fa      	movs	r0, #250	; 0xfa
     fcc:	40a0      	lsls	r0, r4
     fce:	f7ff f86a 	bl	a6 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     fd2:	4b34      	ldr	r3, [pc, #208]	; (10a4 <main+0x488>)
     fd4:	4a34      	ldr	r2, [pc, #208]	; (10a8 <main+0x48c>)
     fd6:	6819      	ldr	r1, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     fd8:	2003      	movs	r0, #3
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    delay(MBUS_DELAY*10);
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
     fda:	400a      	ands	r2, r1
     fdc:	21c0      	movs	r1, #192	; 0xc0
     fde:	0289      	lsls	r1, r1, #10
     fe0:	430a      	orrs	r2, r1
     fe2:	601a      	str	r2, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
     fe4:	681a      	ldr	r2, [r3, #0]
     fe6:	2110      	movs	r1, #16
     fe8:	0b12      	lsrs	r2, r2, #12
     fea:	0312      	lsls	r2, r2, #12
     fec:	430a      	orrs	r2, r1
     fee:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
     ff0:	681a      	ldr	r2, [r3, #0]
     ff2:	2105      	movs	r1, #5
     ff4:	f7ff f909 	bl	20a <mbus_remote_register_write>
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
     ff8:	4b2c      	ldr	r3, [pc, #176]	; (10ac <main+0x490>)
     ffa:	2101      	movs	r1, #1
     ffc:	781a      	ldrb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
     ffe:	2003      	movs	r0, #3
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    1000:	438a      	bics	r2, r1
    1002:	701a      	strb	r2, [r3, #0]
    1004:	e054      	b.n	10b0 <main+0x494>
    1006:	46c0      	nop			; (mov r8, r8)
    1008:	e000e100 	.word	0xe000e100
    100c:	00080f0d 	.word	0x00080f0d
    1010:	00001cc4 	.word	0x00001cc4
    1014:	deadbee1 	.word	0xdeadbee1
    1018:	a0001200 	.word	0xa0001200
    101c:	a000007c 	.word	0xa000007c
    1020:	00001d1c 	.word	0x00001d1c
    1024:	00001cac 	.word	0x00001cac
    1028:	00001ccc 	.word	0x00001ccc
    102c:	00001d18 	.word	0x00001d18
    1030:	00001ce0 	.word	0x00001ce0
    1034:	00001cc8 	.word	0x00001cc8
    1038:	00001cb4 	.word	0x00001cb4
    103c:	0d0a0f0f 	.word	0x0d0a0f0f
    1040:	00001c7c 	.word	0x00001c7c
    1044:	00001c80 	.word	0x00001c80
    1048:	00001c84 	.word	0x00001c84
    104c:	ffdfffff 	.word	0xffdfffff
    1050:	00002710 	.word	0x00002710
    1054:	000186a0 	.word	0x000186a0
    1058:	00001d38 	.word	0x00001d38
    105c:	00001c40 	.word	0x00001c40
    1060:	00001c3c 	.word	0x00001c3c
    1064:	ff7fffff 	.word	0xff7fffff
    1068:	ffefffff 	.word	0xffefffff
    106c:	ffbfffff 	.word	0xffbfffff
    1070:	00001c60 	.word	0x00001c60
    1074:	ff1fffff 	.word	0xff1fffff
    1078:	ffe0007f 	.word	0xffe0007f
    107c:	001ffe80 	.word	0x001ffe80
    1080:	00001c5c 	.word	0x00001c5c
    1084:	ffff00ff 	.word	0xffff00ff
    1088:	00001c64 	.word	0x00001c64
    108c:	fff7ffff 	.word	0xfff7ffff
    1090:	00001d34 	.word	0x00001d34
    1094:	00001d28 	.word	0x00001d28
    1098:	00001c48 	.word	0x00001c48
    109c:	00001c4c 	.word	0x00001c4c
    10a0:	fffffe7f 	.word	0xfffffe7f
    10a4:	00001c58 	.word	0x00001c58
    10a8:	ff000fff 	.word	0xff000fff
    10ac:	00001d30 	.word	0x00001d30
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    10b0:	681a      	ldr	r2, [r3, #0]
    10b2:	2106      	movs	r1, #6
    10b4:	f7ff f8a9 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10b8:	20fa      	movs	r0, #250	; 0xfa
    10ba:	40a0      	lsls	r0, r4
    10bc:	f7fe fff3 	bl	a6 <delay>
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    10c0:	4bd6      	ldr	r3, [pc, #856]	; (141c <main+0x800>)
    10c2:	49d7      	ldr	r1, [pc, #860]	; (1420 <main+0x804>)
    10c4:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    10c6:	2003      	movs	r0, #3
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    10c8:	430a      	orrs	r2, r1
    10ca:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    10cc:	681a      	ldr	r2, [r3, #0]
    10ce:	1c01      	adds	r1, r0, #0
    10d0:	f7ff f89b 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10d4:	20fa      	movs	r0, #250	; 0xfa
    10d6:	40a0      	lsls	r0, r4
    10d8:	f7fe ffe5 	bl	a6 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    10dc:	4bd1      	ldr	r3, [pc, #836]	; (1424 <main+0x808>)
    10de:	210a      	movs	r1, #10
    10e0:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    10e2:	2003      	movs	r0, #3
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    10e4:	0b12      	lsrs	r2, r2, #12
    10e6:	0312      	lsls	r2, r2, #12
    10e8:	430a      	orrs	r2, r1
    10ea:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    10ec:	681a      	ldr	r2, [r3, #0]
    10ee:	2104      	movs	r1, #4
    10f0:	f7ff f88b 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10f4:	20fa      	movs	r0, #250	; 0xfa
    10f6:	40a0      	lsls	r0, r4
    10f8:	f7fe ffd5 	bl	a6 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    10fc:	4dca      	ldr	r5, [pc, #808]	; (1428 <main+0x80c>)
    10fe:	2201      	movs	r2, #1
    1100:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1102:	1c39      	adds	r1, r7, #0
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    1104:	4393      	bics	r3, r2
    1106:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1108:	682a      	ldr	r2, [r5, #0]
    110a:	2003      	movs	r0, #3
    110c:	f7ff f87d 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1110:	20fa      	movs	r0, #250	; 0xfa
    1112:	40a0      	lsls	r0, r4
    1114:	f7fe ffc7 	bl	a6 <delay>
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    1118:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    111a:	1c39      	adds	r1, r7, #0
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    111c:	43a3      	bics	r3, r4
    111e:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1120:	682a      	ldr	r2, [r5, #0]
    1122:	2003      	movs	r0, #3
    1124:	f7ff f871 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1128:	20fa      	movs	r0, #250	; 0xfa
    112a:	40a0      	lsls	r0, r4
    112c:	f7fe ffbb 	bl	a6 <delay>

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    1130:	4dbe      	ldr	r5, [pc, #760]	; (142c <main+0x810>)
    1132:	49bf      	ldr	r1, [pc, #764]	; (1430 <main+0x814>)
    1134:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1136:	1c20      	adds	r0, r4, #0

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    1138:	400b      	ands	r3, r1
    113a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    113c:	682a      	ldr	r2, [r5, #0]
    113e:	2103      	movs	r1, #3
    1140:	f7ff f863 	bl	20a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    1144:	682a      	ldr	r2, [r5, #0]
    1146:	2380      	movs	r3, #128	; 0x80
    1148:	02db      	lsls	r3, r3, #11
    114a:	4313      	orrs	r3, r2
    114c:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    114e:	682a      	ldr	r2, [r5, #0]
    1150:	1c20      	adds	r0, r4, #0
    1152:	2103      	movs	r1, #3
    1154:	f7ff f859 	bl	20a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    1158:	4eb6      	ldr	r6, [pc, #728]	; (1434 <main+0x818>)
    115a:	227e      	movs	r2, #126	; 0x7e
    115c:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    115e:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    1160:	4393      	bics	r3, r2
    1162:	2210      	movs	r2, #16
    1164:	4313      	orrs	r3, r2
    1166:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1168:	6832      	ldr	r2, [r6, #0]
    116a:	1c39      	adds	r1, r7, #0
    116c:	f7ff f84d 	bl	20a <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    1170:	6833      	ldr	r3, [r6, #0]
    1172:	2101      	movs	r1, #1
    1174:	430b      	orrs	r3, r1
    1176:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1178:	6832      	ldr	r2, [r6, #0]
    117a:	1c39      	adds	r1, r7, #0
    117c:	1c20      	adds	r0, r4, #0
    117e:	f7ff f844 	bl	20a <mbus_remote_register_write>

    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    1182:	48ad      	ldr	r0, [pc, #692]	; (1438 <main+0x81c>)
    1184:	f7fe ff8f 	bl	a6 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    1188:	4bac      	ldr	r3, [pc, #688]	; (143c <main+0x820>)
    118a:	2103      	movs	r1, #3
    118c:	781a      	ldrb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    118e:	1c20      	adds	r0, r4, #0
    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    1190:	430a      	orrs	r2, r1
    1192:	701a      	strb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    1194:	781a      	ldrb	r2, [r3, #0]
    1196:	210c      	movs	r1, #12
    1198:	430a      	orrs	r2, r1
    119a:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    119c:	681a      	ldr	r2, [r3, #0]
    119e:	211f      	movs	r1, #31
    11a0:	f7ff f833 	bl	20a <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11a4:	4ba6      	ldr	r3, [pc, #664]	; (1440 <main+0x824>)
    11a6:	210c      	movs	r1, #12
    11a8:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    11aa:	1c20      	adds	r0, r4, #0

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11ac:	0a92      	lsrs	r2, r2, #10
    11ae:	0292      	lsls	r2, r2, #10
    11b0:	430a      	orrs	r2, r1
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11b2:	49a4      	ldr	r1, [pc, #656]	; (1444 <main+0x828>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11b4:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11b6:	680a      	ldr	r2, [r1, #0]
    11b8:	49a3      	ldr	r1, [pc, #652]	; (1448 <main+0x82c>)
    11ba:	0bd2      	lsrs	r2, r2, #15
    11bc:	03d2      	lsls	r2, r2, #15
    11be:	430a      	orrs	r2, r1
    11c0:	49a0      	ldr	r1, [pc, #640]	; (1444 <main+0x828>)
    11c2:	600a      	str	r2, [r1, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    11c4:	6819      	ldr	r1, [r3, #0]
    11c6:	4aa1      	ldr	r2, [pc, #644]	; (144c <main+0x830>)
    11c8:	400a      	ands	r2, r1
    11ca:	21c8      	movs	r1, #200	; 0xc8
    11cc:	01c9      	lsls	r1, r1, #7
    11ce:	430a      	orrs	r2, r1
    11d0:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    11d2:	681a      	ldr	r2, [r3, #0]
    11d4:	2112      	movs	r1, #18
    11d6:	f7ff f818 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    11da:	4b9a      	ldr	r3, [pc, #616]	; (1444 <main+0x828>)
    11dc:	1c20      	adds	r0, r4, #0
    11de:	681a      	ldr	r2, [r3, #0]
    11e0:	2113      	movs	r1, #19
    11e2:	f7ff f812 	bl	20a <mbus_remote_register_write>
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
    11e6:	4b9a      	ldr	r3, [pc, #616]	; (1450 <main+0x834>)
    11e8:	2205      	movs	r2, #5
    11ea:	701a      	strb	r2, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
    11ec:	4b99      	ldr	r3, [pc, #612]	; (1454 <main+0x838>)

    mrr_cfo_val_fine_min = 0x0000;
    11ee:	4a9a      	ldr	r2, [pc, #616]	; (1458 <main+0x83c>)
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 5;
    mrr_freq_hopping_step = 4; // determining center freq
    11f0:	2104      	movs	r1, #4
    11f2:	7019      	strb	r1, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
    11f4:	8017      	strh	r7, [r2, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    11f6:	2280      	movs	r2, #128	; 0x80
    11f8:	1c20      	adds	r0, r4, #0
    11fa:	2106      	movs	r1, #6
    11fc:	0152      	lsls	r2, r2, #5
    11fe:	f7ff f804 	bl	20a <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
    1202:	2280      	movs	r2, #128	; 0x80
    1204:	1c20      	adds	r0, r4, #0
    1206:	2108      	movs	r1, #8
    1208:	03d2      	lsls	r2, r2, #15
    120a:	f7fe fffe 	bl	20a <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    120e:	4b93      	ldr	r3, [pc, #588]	; (145c <main+0x840>)
    1210:	217f      	movs	r1, #127	; 0x7f
    1212:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    1214:	1c20      	adds	r0, r4, #0

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    1216:	438a      	bics	r2, r1
    1218:	2110      	movs	r1, #16
    121a:	430a      	orrs	r2, r1
    121c:	801a      	strh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    121e:	8819      	ldrh	r1, [r3, #0]
    1220:	4a8f      	ldr	r2, [pc, #572]	; (1460 <main+0x844>)
    1222:	400a      	ands	r2, r1
    1224:	2180      	movs	r1, #128	; 0x80
    1226:	0109      	lsls	r1, r1, #4
    1228:	430a      	orrs	r2, r1
    122a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    122c:	681a      	ldr	r2, [r3, #0]
    122e:	2107      	movs	r1, #7
    1230:	f7fe ffeb 	bl	20a <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    1234:	6832      	ldr	r2, [r6, #0]
    1236:	4b8b      	ldr	r3, [pc, #556]	; (1464 <main+0x848>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1238:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    123a:	4013      	ands	r3, r2
    123c:	22e0      	movs	r2, #224	; 0xe0
    123e:	40a2      	lsls	r2, r4
    1240:	4313      	orrs	r3, r2
    1242:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1244:	6832      	ldr	r2, [r6, #0]
    1246:	1c39      	adds	r1, r7, #0
    1248:	f7fe ffdf 	bl	20a <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    124c:	4b86      	ldr	r3, [pc, #536]	; (1468 <main+0x84c>)
    124e:	2107      	movs	r1, #7
    1250:	681a      	ldr	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    1252:	263f      	movs	r6, #63	; 0x3f
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    1254:	0a92      	lsrs	r2, r2, #10
    1256:	0292      	lsls	r2, r2, #10
    1258:	430a      	orrs	r2, r1
    125a:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    125c:	4a7e      	ldr	r2, [pc, #504]	; (1458 <main+0x83c>)
    125e:	8811      	ldrh	r1, [r2, #0]
    1260:	6818      	ldr	r0, [r3, #0]
    1262:	4a82      	ldr	r2, [pc, #520]	; (146c <main+0x850>)
    1264:	4031      	ands	r1, r6
    1266:	0409      	lsls	r1, r1, #16
    1268:	4002      	ands	r2, r0
    126a:	430a      	orrs	r2, r1
    126c:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    126e:	4a7a      	ldr	r2, [pc, #488]	; (1458 <main+0x83c>)
    1270:	8811      	ldrh	r1, [r2, #0]
    1272:	6818      	ldr	r0, [r3, #0]
    1274:	4a7e      	ldr	r2, [pc, #504]	; (1470 <main+0x854>)
    1276:	4031      	ands	r1, r6
    1278:	0289      	lsls	r1, r1, #10
    127a:	4002      	ands	r2, r0
    127c:	430a      	orrs	r2, r1
    127e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    1280:	681a      	ldr	r2, [r3, #0]
    1282:	1c20      	adds	r0, r4, #0
    1284:	2101      	movs	r1, #1
    1286:	f7fe ffc0 	bl	20a <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    128a:	4b7a      	ldr	r3, [pc, #488]	; (1474 <main+0x858>)
    128c:	497a      	ldr	r1, [pc, #488]	; (1478 <main+0x85c>)
    128e:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    1290:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    1292:	430a      	orrs	r2, r1
    1294:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    1296:	681a      	ldr	r2, [r3, #0]
    1298:	1c21      	adds	r1, r4, #0
    129a:	f7fe ffb6 	bl	20a <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    129e:	682a      	ldr	r2, [r5, #0]
    12a0:	4b76      	ldr	r3, [pc, #472]	; (147c <main+0x860>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12a2:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    12a4:	4013      	ands	r3, r2
    12a6:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12a8:	682a      	ldr	r2, [r5, #0]
    12aa:	2103      	movs	r1, #3
    12ac:	f7fe ffad 	bl	20a <mbus_remote_register_write>

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12b0:	4b73      	ldr	r3, [pc, #460]	; (1480 <main+0x864>)
    12b2:	4a74      	ldr	r2, [pc, #464]	; (1484 <main+0x868>)
    12b4:	6819      	ldr	r1, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12b6:	4d74      	ldr	r5, [pc, #464]	; (1488 <main+0x86c>)

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12b8:	400a      	ands	r2, r1
    12ba:	601a      	str	r2, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12bc:	682a      	ldr	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    12be:	1c20      	adds	r0, r4, #0
    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12c0:	43b2      	bics	r2, r6
    12c2:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    12c4:	6829      	ldr	r1, [r5, #0]
    12c6:	4a71      	ldr	r2, [pc, #452]	; (148c <main+0x870>)
    12c8:	400a      	ands	r2, r1
    12ca:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    12cc:	6829      	ldr	r1, [r5, #0]
    12ce:	4a70      	ldr	r2, [pc, #448]	; (1490 <main+0x874>)
    12d0:	400a      	ands	r2, r1
    12d2:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    12d4:	681a      	ldr	r2, [r3, #0]
    12d6:	2114      	movs	r1, #20
    12d8:	f7fe ff97 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
    12dc:	682a      	ldr	r2, [r5, #0]
    12de:	1c20      	adds	r0, r4, #0
    12e0:	2115      	movs	r1, #21
    12e2:	f7fe ff92 	bl	20a <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    12e6:	1c20      	adds	r0, r4, #0
    12e8:	1c3a      	adds	r2, r7, #0
    12ea:	2109      	movs	r1, #9
    12ec:	f7fe ff8d 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    12f0:	1c20      	adds	r0, r4, #0
    12f2:	1c3a      	adds	r2, r7, #0
    12f4:	210a      	movs	r1, #10
    12f6:	f7fe ff88 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    12fa:	1c20      	adds	r0, r4, #0
    12fc:	1c3a      	adds	r2, r7, #0
    12fe:	210b      	movs	r1, #11
    1300:	f7fe ff83 	bl	20a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    1304:	1c20      	adds	r0, r4, #0
    1306:	210c      	movs	r1, #12
    1308:	4a62      	ldr	r2, [pc, #392]	; (1494 <main+0x878>)
    130a:	f7fe ff7e 	bl	20a <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    130e:	4b62      	ldr	r3, [pc, #392]	; (1498 <main+0x87c>)
    1310:	21f8      	movs	r1, #248	; 0xf8
    1312:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1314:	1c20      	adds	r0, r4, #0
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    1316:	438a      	bics	r2, r1
    1318:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    131a:	881a      	ldrh	r2, [r3, #0]
    131c:	21ff      	movs	r1, #255	; 0xff
    131e:	400a      	ands	r2, r1
    1320:	495e      	ldr	r1, [pc, #376]	; (149c <main+0x880>)
    1322:	430a      	orrs	r2, r1
    1324:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1326:	681a      	ldr	r2, [r3, #0]
    1328:	2111      	movs	r1, #17
    132a:	f7fe ff6e 	bl	20a <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    132e:	4a45      	ldr	r2, [pc, #276]	; (1444 <main+0x828>)
    1330:	495b      	ldr	r1, [pc, #364]	; (14a0 <main+0x884>)
    1332:	6813      	ldr	r3, [r2, #0]
    1334:	22c0      	movs	r2, #192	; 0xc0
    1336:	400b      	ands	r3, r1
    1338:	03d2      	lsls	r2, r2, #15
    133a:	4313      	orrs	r3, r2
    133c:	4a41      	ldr	r2, [pc, #260]	; (1444 <main+0x828>)
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    133e:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    1340:	6013      	str	r3, [r2, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1342:	6812      	ldr	r2, [r2, #0]
    1344:	2113      	movs	r1, #19
    1346:	f7fe ff60 	bl	20a <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
    134a:	4a56      	ldr	r2, [pc, #344]	; (14a4 <main+0x888>)
    134c:	211e      	movs	r1, #30
    134e:	1c20      	adds	r0, r4, #0
    1350:	f7fe ff5b 	bl	20a <mbus_remote_register_write>

    // Additional delay for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    1354:	4838      	ldr	r0, [pc, #224]	; (1438 <main+0x81c>)
    1356:	f7fe fea6 	bl	a6 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    135a:	4b53      	ldr	r3, [pc, #332]	; (14a8 <main+0x88c>)
    }
    return;
}

static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    135c:	1c38      	adds	r0, r7, #0
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    135e:	701f      	strb	r7, [r3, #0]
    radio_ready = 0;
    1360:	4b52      	ldr	r3, [pc, #328]	; (14ac <main+0x890>)
    1362:	701f      	strb	r7, [r3, #0]
    }
    return;
}

static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    1364:	f7fe ffdc 	bl	320 <pmu_setting_temp_based>
    read_data_batadc = *REG0 & 0xFFFF;
}

inline static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
    1368:	2186      	movs	r1, #134	; 0x86
    136a:	200e      	movs	r0, #14
    136c:	00c9      	lsls	r1, r1, #3
    136e:	f7fe ff91 	bl	294 <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
    1372:	2045      	movs	r0, #69	; 0x45
    1374:	2148      	movs	r1, #72	; 0x48
    1376:	f7fe ff8d 	bl	294 <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
    137a:	203a      	movs	r0, #58	; 0x3a
    137c:	494c      	ldr	r1, [pc, #304]	; (14b0 <main+0x894>)
    137e:	f7fe ff89 	bl	294 <pmu_reg_write>
// }

inline static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    1382:	203c      	movs	r0, #60	; 0x3c
    1384:	494b      	ldr	r1, [pc, #300]	; (14b4 <main+0x898>)
    1386:	f7fe ff85 	bl	294 <pmu_reg_write>

inline static void pmu_adc_enable() {
    // PMU ADC will be automatically reset when system wakes up
    // PMU_CONTROLLER_DESIRED_STATE sleep
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
    138a:	203b      	movs	r0, #59	; 0x3b
    138c:	494a      	ldr	r1, [pc, #296]	; (14b8 <main+0x89c>)
    138e:	f7fe ff81 	bl	294 <pmu_reg_write>
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
        operation_init();
	pmu_setting_temp_based(2);
    1392:	1c20      	adds	r0, r4, #0
    1394:	f7fe ffc4 	bl	320 <pmu_setting_temp_based>
    1398:	e379      	b.n	1a8e <main+0xe72>
        operation_sleep_notimer();
    }

    pmu_setting_temp_based(0);
    139a:	2000      	movs	r0, #0
    139c:	f7fe ffc0 	bl	320 <pmu_setting_temp_based>

    update_system_time();
    13a0:	f7ff f95a 	bl	658 <update_system_time>
#define MPLIER_SHIFT 6
uint8_t lnt_snt_mplier = 0x52;
uint32_t projected_end_time = 0;

static void update_lnt_timer() {
    if(xo_sys_time > projected_end_time + TIMER_MARGIN 
    13a4:	4b45      	ldr	r3, [pc, #276]	; (14bc <main+0x8a0>)
    13a6:	4a46      	ldr	r2, [pc, #280]	; (14c0 <main+0x8a4>)
    13a8:	681b      	ldr	r3, [r3, #0]
    13aa:	6810      	ldr	r0, [r2, #0]
    13ac:	1c59      	adds	r1, r3, #1
    13ae:	31ff      	adds	r1, #255	; 0xff
    13b0:	4288      	cmp	r0, r1
    13b2:	d909      	bls.n	13c8 <main+0x7ac>
	&& xo_sys_time_in_sec - (projected_end_time >> 10) < 256) {
    13b4:	4943      	ldr	r1, [pc, #268]	; (14c4 <main+0x8a8>)
    13b6:	6808      	ldr	r0, [r1, #0]
    13b8:	0a99      	lsrs	r1, r3, #10
    13ba:	1a41      	subs	r1, r0, r1
    13bc:	29ff      	cmp	r1, #255	; 0xff
    13be:	d803      	bhi.n	13c8 <main+0x7ac>
        lnt_snt_mplier--;
    13c0:	4941      	ldr	r1, [pc, #260]	; (14c8 <main+0x8ac>)
    13c2:	7808      	ldrb	r0, [r1, #0]
    13c4:	3801      	subs	r0, #1
    13c6:	e00d      	b.n	13e4 <main+0x7c8>
    }
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
    13c8:	1e59      	subs	r1, r3, #1
    13ca:	6810      	ldr	r0, [r2, #0]
    13cc:	39ff      	subs	r1, #255	; 0xff
    13ce:	4288      	cmp	r0, r1
    13d0:	d209      	bcs.n	13e6 <main+0x7ca>
		&& (projected_end_time >> 10) - xo_sys_time_in_sec < 256) {
    13d2:	493c      	ldr	r1, [pc, #240]	; (14c4 <main+0x8a8>)
    13d4:	0a98      	lsrs	r0, r3, #10
    13d6:	6809      	ldr	r1, [r1, #0]
    13d8:	1a41      	subs	r1, r0, r1
    13da:	29ff      	cmp	r1, #255	; 0xff
    13dc:	d803      	bhi.n	13e6 <main+0x7ca>
        lnt_snt_mplier++;
    13de:	493a      	ldr	r1, [pc, #232]	; (14c8 <main+0x8ac>)
    13e0:	7808      	ldrb	r0, [r1, #0]
    13e2:	3001      	adds	r0, #1
    13e4:	7008      	strb	r0, [r1, #0]
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    13e6:	6811      	ldr	r1, [r2, #0]
    13e8:	20e4      	movs	r0, #228	; 0xe4
    13ea:	1a59      	subs	r1, r3, r1
    13ec:	f7fe fecc 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE4, lnt_snt_mplier);
    13f0:	4b35      	ldr	r3, [pc, #212]	; (14c8 <main+0x8ac>)
    pmu_setting_temp_based(0);

    update_system_time();
    update_lnt_timer();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    13f2:	4d36      	ldr	r5, [pc, #216]	; (14cc <main+0x8b0>)
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
		&& (projected_end_time >> 10) - xo_sys_time_in_sec < 256) {
        lnt_snt_mplier++;
    }
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
    13f4:	7819      	ldrb	r1, [r3, #0]
    13f6:	20e4      	movs	r0, #228	; 0xe4
    13f8:	f7fe fec6 	bl	188 <mbus_write_message32>

    update_system_time();
    update_lnt_timer();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    13fc:	248c      	movs	r4, #140	; 0x8c
    pmu_setting_temp_based(0);

    update_system_time();
    update_lnt_timer();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    13fe:	6829      	ldr	r1, [r5, #0]
    1400:	20ee      	movs	r0, #238	; 0xee
    1402:	f7fe fec1 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    1406:	6821      	ldr	r1, [r4, #0]
    1408:	20ee      	movs	r0, #238	; 0xee
    140a:	f7fe febd 	bl	188 <mbus_write_message32>

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
    140e:	682b      	ldr	r3, [r5, #0]
    1410:	07d9      	lsls	r1, r3, #31
    1412:	d561      	bpl.n	14d8 <main+0x8bc>
        if(!(*GOC_DATA_IRQ)) {
    1414:	6823      	ldr	r3, [r4, #0]
    1416:	2b00      	cmp	r3, #0
    1418:	d15a      	bne.n	14d0 <main+0x8b4>
    141a:	e381      	b.n	1b20 <main+0xf04>
    141c:	00001c50 	.word	0x00001c50
    1420:	00ffffff 	.word	0x00ffffff
    1424:	00001c54 	.word	0x00001c54
    1428:	00001c44 	.word	0x00001c44
    142c:	00001c30 	.word	0x00001c30
    1430:	fff7ffff 	.word	0xfff7ffff
    1434:	00001c94 	.word	0x00001c94
    1438:	00004e20 	.word	0x00004e20
    143c:	00001c88 	.word	0x00001c88
    1440:	00001c6c 	.word	0x00001c6c
    1444:	00001c70 	.word	0x00001c70
    1448:	00000451 	.word	0x00000451
    144c:	fff003ff 	.word	0xfff003ff
    1450:	00001cb0 	.word	0x00001cb0
    1454:	00001d14 	.word	0x00001d14
    1458:	00001ca4 	.word	0x00001ca4
    145c:	00001c34 	.word	0x00001c34
    1460:	ffffc07f 	.word	0xffffc07f
    1464:	fffe007f 	.word	0xfffe007f
    1468:	00001d40 	.word	0x00001d40
    146c:	ffc0ffff 	.word	0xffc0ffff
    1470:	ffff03ff 	.word	0xffff03ff
    1474:	00001c2c 	.word	0x00001c2c
    1478:	00001fff 	.word	0x00001fff
    147c:	ffffbfff 	.word	0xffffbfff
    1480:	00001c74 	.word	0x00001c74
    1484:	fff8ffff 	.word	0xfff8ffff
    1488:	00001c38 	.word	0x00001c38
    148c:	fffff03f 	.word	0xfffff03f
    1490:	fff80fff 	.word	0xfff80fff
    1494:	007ac800 	.word	0x007ac800
    1498:	00001c68 	.word	0x00001c68
    149c:	ffffc000 	.word	0xffffc000
    14a0:	ff1fffff 	.word	0xff1fffff
    14a4:	00001002 	.word	0x00001002
    14a8:	00001d20 	.word	0x00001d20
    14ac:	00001ca6 	.word	0x00001ca6
    14b0:	00103800 	.word	0x00103800
    14b4:	0017c7ff 	.word	0x0017c7ff
    14b8:	0017efff 	.word	0x0017efff
    14bc:	00001d24 	.word	0x00001d24
    14c0:	00001cac 	.word	0x00001cac
    14c4:	00001ccc 	.word	0x00001ccc
    14c8:	00001c8c 	.word	0x00001c8c
    14cc:	a000a008 	.word	0xa000a008
            operation_sleep(); // Need to protect against spurious wakeups
        }
        set_goc_cmd();
    14d0:	f7ff fb30 	bl	b34 <set_goc_cmd>
        reset_timers_list();
    14d4:	f7ff f912 	bl	6fc <reset_timers_list>
    }

    lnt_start_meas = 2;
    14d8:	4bce      	ldr	r3, [pc, #824]	; (1814 <main+0xbf8>)
    14da:	2202      	movs	r2, #2
    14dc:	701a      	strb	r2, [r3, #0]
    // // Change Counting Time 
    // lntv1a_r03.TIME_COUNTING = 0x000; // Default : 0x258
    // mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    // delay(MBUS_DELAY*10);
    
    set_halt_until_mbus_trx();
    14de:	f7fe fe4d 	bl	17c <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    14e2:	2003      	movs	r0, #3
    14e4:	2110      	movs	r1, #16
    14e6:	2200      	movs	r2, #0
    14e8:	2301      	movs	r3, #1
    14ea:	f7fe fe7d 	bl	1e8 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
    14ee:	f7fe fe3f 	bl	170 <set_halt_until_mbus_tx>
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    14f2:	4bc9      	ldr	r3, [pc, #804]	; (1818 <main+0xbfc>)
    14f4:	26a0      	movs	r6, #160	; 0xa0
    14f6:	6818      	ldr	r0, [r3, #0]
    14f8:	0636      	lsls	r6, r6, #24
    14fa:	6831      	ldr	r1, [r6, #0]
    14fc:	0600      	lsls	r0, r0, #24
    14fe:	2400      	movs	r4, #0
    1500:	4dc6      	ldr	r5, [pc, #792]	; (181c <main+0xc00>)
    1502:	1c02      	adds	r2, r0, #0
    1504:	430a      	orrs	r2, r1
    1506:	1c23      	adds	r3, r4, #0
    1508:	602a      	str	r2, [r5, #0]
    150a:	606b      	str	r3, [r5, #4]
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    150c:	20e0      	movs	r0, #224	; 0xe0
    150e:	682a      	ldr	r2, [r5, #0]
    1510:	686b      	ldr	r3, [r5, #4]
    1512:	1c19      	adds	r1, r3, #0
    1514:	f7fe fe38 	bl	188 <mbus_write_message32>
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);
    1518:	682a      	ldr	r2, [r5, #0]
    151a:	686b      	ldr	r3, [r5, #4]
    151c:	20e1      	movs	r0, #225	; 0xe1
    151e:	1c11      	adds	r1, r2, #0
    1520:	f7fe fe32 	bl	188 <mbus_write_message32>

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    1524:	4dbe      	ldr	r5, [pc, #760]	; (1820 <main+0xc04>)
    1526:	2210      	movs	r2, #16
    1528:	782b      	ldrb	r3, [r5, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    152a:	1c21      	adds	r1, r4, #0
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0));
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    152c:	4393      	bics	r3, r2
    152e:	702b      	strb	r3, [r5, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    1530:	782b      	ldrb	r3, [r5, #0]
    1532:	2240      	movs	r2, #64	; 0x40
    1534:	4393      	bics	r3, r2
    1536:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1538:	682a      	ldr	r2, [r5, #0]
    153a:	2003      	movs	r0, #3
    153c:	f7fe fe65 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1540:	48b8      	ldr	r0, [pc, #736]	; (1824 <main+0xc08>)
    1542:	f7fe fdb0 	bl	a6 <delay>
    
    // Reset LNT //lntv1a_r00.RESET_AFE = 0x1; // Default : 0x1
    lntv1a_r00.RESETN_DBE = 0x0; // Default : 0x0
    1546:	782b      	ldrb	r3, [r5, #0]
    1548:	2204      	movs	r2, #4
    154a:	4393      	bics	r3, r2
    154c:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    154e:	682a      	ldr	r2, [r5, #0]
    1550:	2003      	movs	r0, #3
    1552:	1c21      	adds	r1, r4, #0
    1554:	f7fe fe59 	bl	20a <mbus_remote_register_write>
    }

    lnt_start_meas = 2;
    lnt_stop();

    operation_temp_run();
    1558:	f7fe ffce 	bl	4f8 <operation_temp_run>

inline static void pmu_adc_read_latest() {
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    155c:	1c20      	adds	r0, r4, #0
    155e:	2103      	movs	r1, #3
    1560:	f7fe fe98 	bl	294 <pmu_reg_write>
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
    1564:	4bb0      	ldr	r3, [pc, #704]	; (1828 <main+0xc0c>)
    1566:	6832      	ldr	r2, [r6, #0]
    lnt_start_meas = 2;
    lnt_stop();

    operation_temp_run();
    pmu_adc_read_latest();
    mbus_write_message32(0xAA, read_data_batadc);
    1568:	20aa      	movs	r0, #170	; 0xaa
    // FIXME: this is weird. Readings are higher when ext_bat is lower
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFFFF;
    156a:	801a      	strh	r2, [r3, #0]
    lnt_start_meas = 2;
    lnt_stop();

    operation_temp_run();
    pmu_adc_read_latest();
    mbus_write_message32(0xAA, read_data_batadc);
    156c:	8819      	ldrh	r1, [r3, #0]
    156e:	f7fe fe0b 	bl	188 <mbus_write_message32>

    sys_run_continuous = 0;
    1572:	4bae      	ldr	r3, [pc, #696]	; (182c <main+0xc10>)
    1574:	701c      	strb	r4, [r3, #0]
    do {
        if(goc_component == 0x00) {
    1576:	4bae      	ldr	r3, [pc, #696]	; (1830 <main+0xc14>)
    1578:	781b      	ldrb	r3, [r3, #0]
    157a:	2b00      	cmp	r3, #0
    157c:	d11d      	bne.n	15ba <main+0x99e>
            if(goc_func_id == 0x01) {
    157e:	4bad      	ldr	r3, [pc, #692]	; (1834 <main+0xc18>)
    1580:	781b      	ldrb	r3, [r3, #0]
    1582:	2b01      	cmp	r3, #1
    1584:	d10f      	bne.n	15a6 <main+0x98a>
                if(sys_run_continuous) {
    1586:	4ca9      	ldr	r4, [pc, #676]	; (182c <main+0xc10>)
    1588:	7823      	ldrb	r3, [r4, #0]
    158a:	2b00      	cmp	r3, #0
    158c:	d002      	beq.n	1594 <main+0x978>
                    start_xo_cout();
    158e:	f7fe fde3 	bl	158 <start_xo_cout>
    1592:	e001      	b.n	1598 <main+0x97c>
                }
                else {
                    stop_xo_cout();
    1594:	f7fe fde6 	bl	164 <stop_xo_cout>
                }
                sys_run_continuous = !sys_run_continuous;
    1598:	7823      	ldrb	r3, [r4, #0]
    159a:	425a      	negs	r2, r3
    159c:	4153      	adcs	r3, r2
    159e:	7023      	strb	r3, [r4, #0]
                goc_func_id = 0xFF;
    15a0:	22ff      	movs	r2, #255	; 0xff
    15a2:	4ba4      	ldr	r3, [pc, #656]	; (1834 <main+0xc18>)
    15a4:	e1ac      	b.n	1900 <main+0xce4>
            }
            else if(goc_func_id == 0x02) {
    15a6:	2b02      	cmp	r3, #2
    15a8:	d000      	beq.n	15ac <main+0x990>
    15aa:	e22f      	b.n	1a0c <main+0xdf0>
                // enter time in minutes
                xo_day_time_in_sec = goc_data * 60;
    15ac:	4ba2      	ldr	r3, [pc, #648]	; (1838 <main+0xc1c>)
    15ae:	223c      	movs	r2, #60	; 0x3c
    15b0:	881b      	ldrh	r3, [r3, #0]
    15b2:	435a      	muls	r2, r3
    15b4:	4ba1      	ldr	r3, [pc, #644]	; (183c <main+0xc20>)
    15b6:	601a      	str	r2, [r3, #0]
    15b8:	e228      	b.n	1a0c <main+0xdf0>
            }
        }
        else if(goc_component == 0x01) {
    15ba:	2b01      	cmp	r3, #1
    15bc:	d150      	bne.n	1660 <main+0xa44>
            if(!goc_state) {
    15be:	4aa0      	ldr	r2, [pc, #640]	; (1840 <main+0xc24>)
    15c0:	7815      	ldrb	r5, [r2, #0]
    15c2:	2d00      	cmp	r5, #0
    15c4:	d103      	bne.n	15ce <main+0x9b2>
                goc_state = 1;
    15c6:	7013      	strb	r3, [r2, #0]
                lnt_start_meas = 1;
    15c8:	4a92      	ldr	r2, [pc, #584]	; (1814 <main+0xbf8>)
    15ca:	7013      	strb	r3, [r2, #0]
    15cc:	e21e      	b.n	1a0c <main+0xdf0>
            }
            else if(goc_state == 1) {
    15ce:	2d01      	cmp	r5, #1
    15d0:	d000      	beq.n	15d4 <main+0x9b8>
    15d2:	e21b      	b.n	1a0c <main+0xdf0>
		op_counter++;
    15d4:	4f9b      	ldr	r7, [pc, #620]	; (1844 <main+0xc28>)
		lnt_start_meas = 0;
    15d6:	2600      	movs	r6, #0
            if(!goc_state) {
                goc_state = 1;
                lnt_start_meas = 1;
            }
            else if(goc_state == 1) {
		op_counter++;
    15d8:	883b      	ldrh	r3, [r7, #0]
		lnt_start_meas = 0;
		goc_state = 0;
                pmu_setting_temp_based(1);
    15da:	1c28      	adds	r0, r5, #0
            if(!goc_state) {
                goc_state = 1;
                lnt_start_meas = 1;
            }
            else if(goc_state == 1) {
		op_counter++;
    15dc:	3301      	adds	r3, #1
    15de:	803b      	strh	r3, [r7, #0]
		lnt_start_meas = 0;
    15e0:	4b8c      	ldr	r3, [pc, #560]	; (1814 <main+0xbf8>)
		goc_state = 0;
    15e2:	7016      	strb	r6, [r2, #0]
                goc_state = 1;
                lnt_start_meas = 1;
            }
            else if(goc_state == 1) {
		op_counter++;
		lnt_start_meas = 0;
    15e4:	701e      	strb	r6, [r3, #0]
		goc_state = 0;
                pmu_setting_temp_based(1);
    15e6:	f7fe fe9b 	bl	320 <pmu_setting_temp_based>
                reset_radio_data_arr();
    15ea:	f7fe fe4b 	bl	284 <reset_radio_data_arr>
                radio_data_arr[0] = lnt_sys_light & 0xFFFFFFFF;
    15ee:	4c96      	ldr	r4, [pc, #600]	; (1848 <main+0xc2c>)
    15f0:	498a      	ldr	r1, [pc, #552]	; (181c <main+0xc00>)
                radio_data_arr[1] = lnt_sys_light >> 32;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
    15f2:	1c30      	adds	r0, r6, #0
		op_counter++;
		lnt_start_meas = 0;
		goc_state = 0;
                pmu_setting_temp_based(1);
                reset_radio_data_arr();
                radio_data_arr[0] = lnt_sys_light & 0xFFFFFFFF;
    15f4:	680a      	ldr	r2, [r1, #0]
    15f6:	684b      	ldr	r3, [r1, #4]
    15f8:	6022      	str	r2, [r4, #0]
                radio_data_arr[1] = lnt_sys_light >> 32;
    15fa:	680a      	ldr	r2, [r1, #0]
    15fc:	684b      	ldr	r3, [r1, #4]
    15fe:	6063      	str	r3, [r4, #4]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
    1600:	883b      	ldrh	r3, [r7, #0]
    1602:	220f      	movs	r2, #15
    1604:	4013      	ands	r3, r2
    1606:	021b      	lsls	r3, r3, #8
    1608:	2240      	movs	r2, #64	; 0x40
    160a:	4313      	orrs	r3, r2
    160c:	60a3      	str	r3, [r4, #8]
                mrr_send_radio_data(0);
    160e:	f7ff f8fb 	bl	808 <mrr_send_radio_data>
                radio_data_arr[0] = snt_sys_temp_code;
    1612:	4b8e      	ldr	r3, [pc, #568]	; (184c <main+0xc30>)
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x41);
    1614:	210f      	movs	r1, #15
                reset_radio_data_arr();
                radio_data_arr[0] = lnt_sys_light & 0xFFFFFFFF;
                radio_data_arr[1] = lnt_sys_light >> 32;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
                radio_data_arr[0] = snt_sys_temp_code;
    1616:	681b      	ldr	r3, [r3, #0]
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x41);
    1618:	2241      	movs	r2, #65	; 0x41
                reset_radio_data_arr();
                radio_data_arr[0] = lnt_sys_light & 0xFFFFFFFF;
                radio_data_arr[1] = lnt_sys_light >> 32;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
                radio_data_arr[0] = snt_sys_temp_code;
    161a:	6023      	str	r3, [r4, #0]
                radio_data_arr[1] = read_data_batadc;
    161c:	4b82      	ldr	r3, [pc, #520]	; (1828 <main+0xc0c>)
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x41);
                mrr_send_radio_data(0);
    161e:	1c30      	adds	r0, r6, #0
                radio_data_arr[0] = lnt_sys_light & 0xFFFFFFFF;
                radio_data_arr[1] = lnt_sys_light >> 32;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x40);
                mrr_send_radio_data(0);
                radio_data_arr[0] = snt_sys_temp_code;
                radio_data_arr[1] = read_data_batadc;
    1620:	881b      	ldrh	r3, [r3, #0]
    1622:	6063      	str	r3, [r4, #4]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x41);
    1624:	883b      	ldrh	r3, [r7, #0]
    1626:	400b      	ands	r3, r1
    1628:	021b      	lsls	r3, r3, #8
    162a:	4313      	orrs	r3, r2
    162c:	60a3      	str	r3, [r4, #8]
                mrr_send_radio_data(0);
    162e:	f7ff f8eb 	bl	808 <mrr_send_radio_data>
		reset_radio_data_arr();
    1632:	f7fe fe27 	bl	284 <reset_radio_data_arr>
		update_system_time();
    1636:	f7ff f80f 	bl	658 <update_system_time>
		radio_data_arr[0] = xo_sys_time;
    163a:	4b85      	ldr	r3, [pc, #532]	; (1850 <main+0xc34>)
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x42);
    163c:	220f      	movs	r2, #15
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x41);
                mrr_send_radio_data(0);
		reset_radio_data_arr();
		update_system_time();
		radio_data_arr[0] = xo_sys_time;
    163e:	681b      	ldr	r3, [r3, #0]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x42);
                mrr_send_radio_data(1);
    1640:	1c28      	adds	r0, r5, #0
                radio_data_arr[1] = read_data_batadc;
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x41);
                mrr_send_radio_data(0);
		reset_radio_data_arr();
		update_system_time();
		radio_data_arr[0] = xo_sys_time;
    1642:	6023      	str	r3, [r4, #0]
                radio_data_arr[2] = (op_counter & 0xF) << 8 | (0x42);
    1644:	883b      	ldrh	r3, [r7, #0]
    1646:	4013      	ands	r3, r2
    1648:	021b      	lsls	r3, r3, #8
    164a:	2242      	movs	r2, #66	; 0x42
    164c:	4313      	orrs	r3, r2
    164e:	60a3      	str	r3, [r4, #8]
                mrr_send_radio_data(1);
    1650:	f7ff f8da 	bl	808 <mrr_send_radio_data>
                pmu_setting_temp_based(0);
    1654:	1c30      	adds	r0, r6, #0
    1656:	f7fe fe63 	bl	320 <pmu_setting_temp_based>

		set_next_time(START_LNT, 100);
    165a:	1c28      	adds	r0, r5, #0
    165c:	2164      	movs	r1, #100	; 0x64
    165e:	e1d3      	b.n	1a08 <main+0xdec>
            }
        }
	else if(goc_component == 0x02) {
    1660:	2b02      	cmp	r3, #2
    1662:	d109      	bne.n	1678 <main+0xa5c>
	    update_system_time();
    1664:	f7fe fff8 	bl	658 <update_system_time>
	    mbus_write_message32(0xC1, xo_sys_time);
    1668:	4b79      	ldr	r3, [pc, #484]	; (1850 <main+0xc34>)
    166a:	20c1      	movs	r0, #193	; 0xc1
    166c:	6819      	ldr	r1, [r3, #0]
    166e:	f7fe fd8b 	bl	188 <mbus_write_message32>
	    mbus_sleep_all();
    1672:	f7fe fdb3 	bl	1dc <mbus_sleep_all>
    1676:	e1c9      	b.n	1a0c <main+0xdf0>
	}
        else if(goc_component == 0x04) {
    1678:	2b04      	cmp	r3, #4
    167a:	d000      	beq.n	167e <main+0xa62>
    167c:	e1c6      	b.n	1a0c <main+0xdf0>
            if(goc_func_id == 0x01) {
    167e:	4b6d      	ldr	r3, [pc, #436]	; (1834 <main+0xc18>)
    1680:	781a      	ldrb	r2, [r3, #0]
    1682:	2a01      	cmp	r2, #1
    1684:	d000      	beq.n	1688 <main+0xa6c>
    1686:	e1c1      	b.n	1a0c <main+0xdf0>
		if(goc_state == 0) {
    1688:	4b6d      	ldr	r3, [pc, #436]	; (1840 <main+0xc24>)
    168a:	7818      	ldrb	r0, [r3, #0]
    168c:	2800      	cmp	r0, #0
    168e:	d102      	bne.n	1696 <main+0xa7a>
		    goc_state = 1;
    1690:	701a      	strb	r2, [r3, #0]
		    lnt_start_meas = 1;
    1692:	4b60      	ldr	r3, [pc, #384]	; (1814 <main+0xbf8>)
    1694:	e134      	b.n	1900 <main+0xce4>
		}
		else if(goc_state == 1) {
    1696:	2801      	cmp	r0, #1
    1698:	d132      	bne.n	1700 <main+0xae4>
                    goc_state = 2;
    169a:	2102      	movs	r1, #2
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    169c:	4c69      	ldr	r4, [pc, #420]	; (1844 <main+0xc28>)
		if(goc_state == 0) {
		    goc_state = 1;
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
    169e:	7019      	strb	r1, [r3, #0]
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    16a0:	2300      	movs	r3, #0
    16a2:	8023      	strh	r3, [r4, #0]

                    snt_counter = 2;    // start code with snt storage
    16a4:	4c6b      	ldr	r4, [pc, #428]	; (1854 <main+0xc38>)
		    lnt_start_meas = 1;
		}
		else if(goc_state == 1) {
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    16a6:	1c1a      	adds	r2, r3, #0

                    snt_counter = 2;    // start code with snt storage
    16a8:	7021      	strb	r1, [r4, #0]
                    radio_beacon_counter = 0;
    16aa:	496b      	ldr	r1, [pc, #428]	; (1858 <main+0xc3c>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
    16ac:	4c6b      	ldr	r4, [pc, #428]	; (185c <main+0xc40>)
                    goc_state = 2;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;

                    snt_counter = 2;    // start code with snt storage
                    radio_beacon_counter = 0;
    16ae:	700b      	strb	r3, [r1, #0]
                    radio_counter = 0;
    16b0:	496b      	ldr	r1, [pc, #428]	; (1860 <main+0xc44>)
    16b2:	700b      	strb	r3, [r1, #0]

                    mem_light_addr = 0;
    16b4:	496b      	ldr	r1, [pc, #428]	; (1864 <main+0xc48>)
    16b6:	800b      	strh	r3, [r1, #0]
                    mem_light_len = 0;
    16b8:	496b      	ldr	r1, [pc, #428]	; (1868 <main+0xc4c>)
    16ba:	800b      	strh	r3, [r1, #0]
                    mem_temp_addr = 7000;
    16bc:	496b      	ldr	r1, [pc, #428]	; (186c <main+0xc50>)
    16be:	800c      	strh	r4, [r1, #0]
                    mem_temp_len = 0;
    16c0:	496b      	ldr	r1, [pc, #428]	; (1870 <main+0xc54>)

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    16c2:	4c5e      	ldr	r4, [pc, #376]	; (183c <main+0xc20>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;
    16c4:	800b      	strh	r3, [r1, #0]

		    lnt_start_meas = 0;
    16c6:	4953      	ldr	r1, [pc, #332]	; (1814 <main+0xbf8>)
    16c8:	700b      	strb	r3, [r1, #0]

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    16ca:	496a      	ldr	r1, [pc, #424]	; (1874 <main+0xc58>)
    16cc:	680e      	ldr	r6, [r1, #0]
    16ce:	6825      	ldr	r5, [r4, #0]
    16d0:	1b75      	subs	r5, r6, r5
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
    16d2:	4e59      	ldr	r6, [pc, #356]	; (1838 <main+0xc1c>)
    16d4:	8837      	ldrh	r7, [r6, #0]
    16d6:	26e1      	movs	r6, #225	; 0xe1
    16d8:	0136      	lsls	r6, r6, #4
    16da:	437e      	muls	r6, r7
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    16dc:	19ae      	adds	r6, r5, r6
    16de:	4d66      	ldr	r5, [pc, #408]	; (1878 <main+0xc5c>)
    16e0:	602e      	str	r6, [r5, #0]
                    xot_timer_list[START_LNT] = 0;
    16e2:	606b      	str	r3, [r5, #4]
		    xo_is_day = 0;
    16e4:	4b65      	ldr	r3, [pc, #404]	; (187c <main+0xc60>)
    16e6:	701a      	strb	r2, [r3, #0]
		    xo_last_is_day = 0;
    16e8:	4b65      	ldr	r3, [pc, #404]	; (1880 <main+0xc64>)
    16ea:	701a      	strb	r2, [r3, #0]

                    radio_data_arr[0] = xo_day_time_in_sec;
    16ec:	6822      	ldr	r2, [r4, #0]
    16ee:	4b56      	ldr	r3, [pc, #344]	; (1848 <main+0xc2c>)
    16f0:	601a      	str	r2, [r3, #0]
                    radio_data_arr[1] = xo_sys_time_in_sec;
    16f2:	680a      	ldr	r2, [r1, #0]
    16f4:	605a      	str	r2, [r3, #4]
                    radio_data_arr[2] = 0xDEAD;
    16f6:	4a63      	ldr	r2, [pc, #396]	; (1884 <main+0xc68>)
    16f8:	609a      	str	r2, [r3, #8]
                    mrr_send_radio_data(1);
    16fa:	f7ff f885 	bl	808 <mrr_send_radio_data>
    16fe:	e185      	b.n	1a0c <main+0xdf0>
                }

		else if(goc_state == 2) {
    1700:	2802      	cmp	r0, #2
    1702:	d000      	beq.n	1706 <main+0xaea>
    1704:	e0fe      	b.n	1904 <main+0xce8>
                    if(op_counter >= SNT_OP_MAX_COUNT) {
    1706:	4a4f      	ldr	r2, [pc, #316]	; (1844 <main+0xc28>)
    1708:	4c5b      	ldr	r4, [pc, #364]	; (1878 <main+0xc5c>)
    170a:	8811      	ldrh	r1, [r2, #0]
    170c:	290c      	cmp	r1, #12
    170e:	d90c      	bls.n	172a <main+0xb0e>
                        goc_state = 3;
    1710:	2203      	movs	r2, #3
    1712:	701a      	strb	r2, [r3, #0]
			reset_timers_list();
    1714:	f7fe fff2 	bl	6fc <reset_timers_list>
			update_system_time();
    1718:	f7fe ff9e 	bl	658 <update_system_time>
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
    171c:	4b55      	ldr	r3, [pc, #340]	; (1874 <main+0xc58>)
    171e:	2196      	movs	r1, #150	; 0x96
    1720:	681b      	ldr	r3, [r3, #0]
    1722:	0089      	lsls	r1, r1, #2
    1724:	185b      	adds	r3, r3, r1
    1726:	60a3      	str	r3, [r4, #8]
    1728:	e170      	b.n	1a0c <main+0xdf0>
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
    172a:	6823      	ldr	r3, [r4, #0]
    172c:	3301      	adds	r3, #1
    172e:	d124      	bne.n	177a <main+0xb5e>
			    op_counter++;
    1730:	8813      	ldrh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    1732:	2000      	movs	r0, #0
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
			    op_counter++;
    1734:	3301      	adds	r3, #1
    1736:	8013      	strh	r3, [r2, #0]
                            pmu_setting_temp_based(0);
    1738:	f7fe fdf2 	bl	320 <pmu_setting_temp_based>

                            // TODO: compensate XO

                            if(++snt_counter >= 3) {
    173c:	4a45      	ldr	r2, [pc, #276]	; (1854 <main+0xc38>)
    173e:	7813      	ldrb	r3, [r2, #0]
    1740:	3301      	adds	r3, #1
    1742:	b2db      	uxtb	r3, r3
    1744:	7013      	strb	r3, [r2, #0]
    1746:	2b02      	cmp	r3, #2
    1748:	d90d      	bls.n	1766 <main+0xb4a>
                                snt_counter = 0;
    174a:	2300      	movs	r3, #0
    174c:	7013      	strb	r3, [r2, #0]
                                // TODO: compress this
                                mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) &snt_sys_temp_code, 0);
    174e:	4c48      	ldr	r4, [pc, #288]	; (1870 <main+0xc54>)
    1750:	4a46      	ldr	r2, [pc, #280]	; (186c <main+0xc50>)
    1752:	2006      	movs	r0, #6
    1754:	8811      	ldrh	r1, [r2, #0]
    1756:	8822      	ldrh	r2, [r4, #0]
    1758:	1889      	adds	r1, r1, r2
    175a:	4a3c      	ldr	r2, [pc, #240]	; (184c <main+0xc30>)
    175c:	f7fe fd62 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                                mem_temp_len++;
    1760:	8823      	ldrh	r3, [r4, #0]
    1762:	3301      	adds	r3, #1
    1764:	8023      	strh	r3, [r4, #0]
                            }

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
    1766:	4b44      	ldr	r3, [pc, #272]	; (1878 <main+0xc5c>)
    1768:	20ea      	movs	r0, #234	; 0xea
    176a:	6819      	ldr	r1, [r3, #0]
    176c:	f7fe fd0c 	bl	188 <mbus_write_message32>
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
    1770:	2196      	movs	r1, #150	; 0x96
    1772:	2000      	movs	r0, #0
    1774:	0089      	lsls	r1, r1, #2
    1776:	f7fe ffcd 	bl	714 <set_next_time>
                        }

			xo_is_day = xo_check_is_day();
    177a:	f7fe ffeb 	bl	754 <xo_check_is_day>
    177e:	4c3f      	ldr	r4, [pc, #252]	; (187c <main+0xc60>)

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    1780:	4b24      	ldr	r3, [pc, #144]	; (1814 <main+0xbf8>)

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
                        }

			xo_is_day = xo_check_is_day();
    1782:	7020      	strb	r0, [r4, #0]

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    1784:	781a      	ldrb	r2, [r3, #0]
    1786:	2a02      	cmp	r2, #2
    1788:	d000      	beq.n	178c <main+0xb70>
    178a:	e0a4      	b.n	18d6 <main+0xcba>
                            lnt_start_meas = 0;
    178c:	2200      	movs	r2, #0
    178e:	701a      	strb	r2, [r3, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
    1790:	4e35      	ldr	r6, [pc, #212]	; (1868 <main+0xc4c>)
    1792:	4b34      	ldr	r3, [pc, #208]	; (1864 <main+0xc48>)
    1794:	4d21      	ldr	r5, [pc, #132]	; (181c <main+0xc00>)
    1796:	8819      	ldrh	r1, [r3, #0]
    1798:	8833      	ldrh	r3, [r6, #0]
    179a:	2006      	movs	r0, #6
    179c:	18c9      	adds	r1, r1, r3
    179e:	1c2a      	adds	r2, r5, #0
    17a0:	2301      	movs	r3, #1
    17a2:	f7fe fd3f 	bl	224 <mbus_copy_mem_from_local_to_remote_bulk>
                            mem_light_len += 2;
    17a6:	8833      	ldrh	r3, [r6, #0]
    17a8:	3302      	adds	r3, #2
    17aa:	8033      	strh	r3, [r6, #0]

                            if(xo_is_day) {
    17ac:	7823      	ldrb	r3, [r4, #0]
    17ae:	2b00      	cmp	r3, #0
    17b0:	d100      	bne.n	17b4 <main+0xb98>
    17b2:	e0a2      	b.n	18fa <main+0xcde>
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    17b4:	4b34      	ldr	r3, [pc, #208]	; (1888 <main+0xc6c>)
    17b6:	6818      	ldr	r0, [r3, #0]
    17b8:	6859      	ldr	r1, [r3, #4]
    17ba:	682a      	ldr	r2, [r5, #0]
    17bc:	686b      	ldr	r3, [r5, #4]
    17be:	4299      	cmp	r1, r3
    17c0:	d815      	bhi.n	17ee <main+0xbd2>
    17c2:	d101      	bne.n	17c8 <main+0xbac>
    17c4:	4290      	cmp	r0, r2
    17c6:	d812      	bhi.n	17ee <main+0xbd2>
    17c8:	2100      	movs	r1, #0
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    17ca:	4830      	ldr	r0, [pc, #192]	; (188c <main+0xc70>)
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    17cc:	4c13      	ldr	r4, [pc, #76]	; (181c <main+0xc00>)
    17ce:	4d30      	ldr	r5, [pc, #192]	; (1890 <main+0xc74>)
    17d0:	1c0e      	adds	r6, r1, #0
    17d2:	e062      	b.n	189a <main+0xc7e>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    17d4:	004f      	lsls	r7, r1, #1

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    17d6:	682a      	ldr	r2, [r5, #0]
    17d8:	686b      	ldr	r3, [r5, #4]
    17da:	5bbf      	ldrh	r7, [r7, r6]
    17dc:	2b00      	cmp	r3, #0
    17de:	d101      	bne.n	17e4 <main+0xbc8>
    17e0:	42ba      	cmp	r2, r7
    17e2:	d902      	bls.n	17ea <main+0xbce>
                lnt_cur_level = i + 1;
    17e4:	3101      	adds	r1, #1
    17e6:	7021      	strb	r1, [r4, #0]
    17e8:	e05a      	b.n	18a0 <main+0xc84>
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
    17ea:	3901      	subs	r1, #1
    17ec:	e003      	b.n	17f6 <main+0xbda>
    17ee:	4827      	ldr	r0, [pc, #156]	; (188c <main+0xc70>)
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    17f0:	4d0a      	ldr	r5, [pc, #40]	; (181c <main+0xc00>)
    17f2:	4e28      	ldr	r6, [pc, #160]	; (1894 <main+0xc78>)
    lnt_start();
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    17f4:	2102      	movs	r1, #2
        for(i = 2; i >= lnt_cur_level; i--) {
    17f6:	7803      	ldrb	r3, [r0, #0]
    17f8:	1c04      	adds	r4, r0, #0
    17fa:	4299      	cmp	r1, r3
    17fc:	daea      	bge.n	17d4 <main+0xbb8>
    17fe:	e04f      	b.n	18a0 <main+0xc84>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1800:	004f      	lsls	r7, r1, #1
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    1802:	6822      	ldr	r2, [r4, #0]
    1804:	6863      	ldr	r3, [r4, #4]
    1806:	5b7f      	ldrh	r7, [r7, r5]
    1808:	429e      	cmp	r6, r3
    180a:	d145      	bne.n	1898 <main+0xc7c>
    180c:	4297      	cmp	r7, r2
    180e:	d943      	bls.n	1898 <main+0xc7c>
                lnt_cur_level = i;
    1810:	7001      	strb	r1, [r0, #0]
    1812:	e045      	b.n	18a0 <main+0xc84>
    1814:	00001d2c 	.word	0x00001d2c
    1818:	a0000004 	.word	0xa0000004
    181c:	00001cf8 	.word	0x00001cf8
    1820:	00001c44 	.word	0x00001c44
    1824:	00002710 	.word	0x00002710
    1828:	00001cde 	.word	0x00001cde
    182c:	00001cf5 	.word	0x00001cf5
    1830:	00001cc2 	.word	0x00001cc2
    1834:	00001cd0 	.word	0x00001cd0
    1838:	00001cda 	.word	0x00001cda
    183c:	00001d18 	.word	0x00001d18
    1840:	00001d00 	.word	0x00001d00
    1844:	00001d1e 	.word	0x00001d1e
    1848:	00001ce4 	.word	0x00001ce4
    184c:	00001ce0 	.word	0x00001ce0
    1850:	00001cac 	.word	0x00001cac
    1854:	00001cdc 	.word	0x00001cdc
    1858:	00001cf4 	.word	0x00001cf4
    185c:	00001b58 	.word	0x00001b58
    1860:	00001cd8 	.word	0x00001cd8
    1864:	00001cb2 	.word	0x00001cb2
    1868:	00001cf2 	.word	0x00001cf2
    186c:	00001cf0 	.word	0x00001cf0
    1870:	00001cc0 	.word	0x00001cc0
    1874:	00001ccc 	.word	0x00001ccc
    1878:	00001d04 	.word	0x00001d04
    187c:	00001cd1 	.word	0x00001cd1
    1880:	00001cf6 	.word	0x00001cf6
    1884:	0000dead 	.word	0x0000dead
    1888:	00001cb8 	.word	0x00001cb8
    188c:	00001cb4 	.word	0x00001cb4
    1890:	00001b90 	.word	0x00001b90
    1894:	00001bfc 	.word	0x00001bfc
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    1898:	3101      	adds	r1, #1
    189a:	7803      	ldrb	r3, [r0, #0]
    189c:	4299      	cmp	r1, r3
    189e:	dbaf      	blt.n	1800 <main+0xbe4>
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    18a0:	49a0      	ldr	r1, [pc, #640]	; (1b24 <main+0xf08>)
    18a2:	4ba1      	ldr	r3, [pc, #644]	; (1b28 <main+0xf0c>)
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    18a4:	4da1      	ldr	r5, [pc, #644]	; (1b2c <main+0xf10>)
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    18a6:	681a      	ldr	r2, [r3, #0]
    18a8:	685b      	ldr	r3, [r3, #4]
    18aa:	600a      	str	r2, [r1, #0]
    18ac:	604b      	str	r3, [r1, #4]
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    18ae:	782b      	ldrb	r3, [r5, #0]
    18b0:	4c9f      	ldr	r4, [pc, #636]	; (1b30 <main+0xf14>)
    18b2:	005b      	lsls	r3, r3, #1
    18b4:	5b19      	ldrh	r1, [r3, r4]
    18b6:	20df      	movs	r0, #223	; 0xdf
    18b8:	f7fe fc66 	bl	188 <mbus_write_message32>
    return LNT_INTERVAL[lnt_cur_level];
    18bc:	782b      	ldrb	r3, [r5, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    18be:	2001      	movs	r0, #1
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    return LNT_INTERVAL[lnt_cur_level];
    18c0:	005b      	lsls	r3, r3, #1
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    18c2:	5b19      	ldrh	r1, [r3, r4]
    18c4:	f7fe ff26 	bl	714 <set_next_time>
				mbus_write_message32(0xEB, LNT_INTERVAL[lnt_cur_level]);
    18c8:	782b      	ldrb	r3, [r5, #0]
    18ca:	20eb      	movs	r0, #235	; 0xeb
    18cc:	005b      	lsls	r3, r3, #1
    18ce:	5b19      	ldrh	r1, [r3, r4]
    18d0:	f7fe fc5a 	bl	188 <mbus_write_message32>
    18d4:	e011      	b.n	18fa <main+0xcde>
                            }
                        }
			else if(xot_timer_list[START_LNT] == 0xFFFFFFFF) {
    18d6:	4a97      	ldr	r2, [pc, #604]	; (1b34 <main+0xf18>)
    18d8:	6851      	ldr	r1, [r2, #4]
    18da:	3101      	adds	r1, #1
    18dc:	d101      	bne.n	18e2 <main+0xcc6>
                            xot_timer_list[START_LNT] = 0;
    18de:	2100      	movs	r1, #0
    18e0:	e008      	b.n	18f4 <main+0xcd8>
                            lnt_start_meas = 1;
                        }

			else if(!xo_last_is_day && xo_is_day) {
    18e2:	4a95      	ldr	r2, [pc, #596]	; (1b38 <main+0xf1c>)
    18e4:	7812      	ldrb	r2, [r2, #0]
    18e6:	2a00      	cmp	r2, #0
    18e8:	d107      	bne.n	18fa <main+0xcde>
    18ea:	7822      	ldrb	r2, [r4, #0]
    18ec:	2a00      	cmp	r2, #0
    18ee:	d004      	beq.n	18fa <main+0xcde>
			    // set LNT last timer to SNT current timer for synchronization
			    xot_last_timer_list[START_LNT] = xot_last_timer_list[RUN_SNT];
    18f0:	4a92      	ldr	r2, [pc, #584]	; (1b3c <main+0xf20>)
    18f2:	6811      	ldr	r1, [r2, #0]
    18f4:	6051      	str	r1, [r2, #4]
			    lnt_start_meas = 1;
    18f6:	2201      	movs	r2, #1
    18f8:	701a      	strb	r2, [r3, #0]
			}

			xo_last_is_day = xo_is_day;
    18fa:	4b91      	ldr	r3, [pc, #580]	; (1b40 <main+0xf24>)
    18fc:	781a      	ldrb	r2, [r3, #0]
    18fe:	4b8e      	ldr	r3, [pc, #568]	; (1b38 <main+0xf1c>)
    1900:	701a      	strb	r2, [r3, #0]
    1902:	e083      	b.n	1a0c <main+0xdf0>
                    }
                }

		else if(goc_state == 3) {
    1904:	2803      	cmp	r0, #3
    1906:	d000      	beq.n	190a <main+0xcee>
    1908:	e080      	b.n	1a0c <main+0xdf0>
                    // SEND RADIO
                    if(xot_timer_list[SEND_RAD] == 0xFFFFFFFF) {
    190a:	4b8a      	ldr	r3, [pc, #552]	; (1b34 <main+0xf18>)
    190c:	689b      	ldr	r3, [r3, #8]
    190e:	3301      	adds	r3, #1
    1910:	d000      	beq.n	1914 <main+0xcf8>
    1912:	e07b      	b.n	1a0c <main+0xdf0>
                        pmu_setting_temp_based(1);
    1914:	2001      	movs	r0, #1
    1916:	f7fe fd03 	bl	320 <pmu_setting_temp_based>

                        if(xo_check_is_day()) {
    191a:	f7fe ff1b 	bl	754 <xo_check_is_day>
    191e:	2800      	cmp	r0, #0
    1920:	d06f      	beq.n	1a02 <main+0xde6>
                            // send beacon
                            reset_radio_data_arr();
    1922:	f7fe fcaf 	bl	284 <reset_radio_data_arr>
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    1926:	4a87      	ldr	r2, [pc, #540]	; (1b44 <main+0xf28>)
    1928:	4b87      	ldr	r3, [pc, #540]	; (1b48 <main+0xf2c>)
                            radio_data_arr[1] = snt_sys_temp_code;

                            mrr_send_radio_data(0);
    192a:	2000      	movs	r0, #0
                        pmu_setting_temp_based(1);

                        if(xo_check_is_day()) {
                            // send beacon
                            reset_radio_data_arr();
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    192c:	781b      	ldrb	r3, [r3, #0]
    192e:	8811      	ldrh	r1, [r2, #0]
    1930:	22dd      	movs	r2, #221	; 0xdd
    1932:	0612      	lsls	r2, r2, #24
    1934:	430a      	orrs	r2, r1
    1936:	041b      	lsls	r3, r3, #16
    1938:	431a      	orrs	r2, r3
    193a:	4b84      	ldr	r3, [pc, #528]	; (1b4c <main+0xf30>)
    193c:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = snt_sys_temp_code;
    193e:	4a84      	ldr	r2, [pc, #528]	; (1b50 <main+0xf34>)
    1940:	6812      	ldr	r2, [r2, #0]
    1942:	605a      	str	r2, [r3, #4]

                            mrr_send_radio_data(0);
    1944:	f7fe ff60 	bl	808 <mrr_send_radio_data>

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
    1948:	4b82      	ldr	r3, [pc, #520]	; (1b54 <main+0xf38>)
    194a:	781a      	ldrb	r2, [r3, #0]
    194c:	3201      	adds	r2, #1
    194e:	b2d2      	uxtb	r2, r2
    1950:	701a      	strb	r2, [r3, #0]
    1952:	2a05      	cmp	r2, #5
    1954:	d80f      	bhi.n	1976 <main+0xd5a>
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    1956:	4c7c      	ldr	r4, [pc, #496]	; (1b48 <main+0xf2c>)
    1958:	4b7c      	ldr	r3, [pc, #496]	; (1b4c <main+0xf30>)
    195a:	7822      	ldrb	r2, [r4, #0]
                            radio_data_arr[1] = radio_beacon_counter;
                            radio_data_arr[2] = 0xFEED;

                            mrr_send_radio_data(1);
    195c:	2001      	movs	r0, #1
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    195e:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = radio_beacon_counter;
    1960:	4a7c      	ldr	r2, [pc, #496]	; (1b54 <main+0xf38>)
    1962:	7812      	ldrb	r2, [r2, #0]
    1964:	605a      	str	r2, [r3, #4]
                            radio_data_arr[2] = 0xFEED;
    1966:	4a7c      	ldr	r2, [pc, #496]	; (1b58 <main+0xf3c>)
    1968:	609a      	str	r2, [r3, #8]

                            mrr_send_radio_data(1);
    196a:	f7fe ff4d 	bl	808 <mrr_send_radio_data>

                            radio_counter++;
    196e:	7823      	ldrb	r3, [r4, #0]
    1970:	3301      	adds	r3, #1
    1972:	7023      	strb	r3, [r4, #0]
    1974:	e045      	b.n	1a02 <main+0xde6>

                            mrr_send_radio_data(0);

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
    1976:	2400      	movs	r4, #0
    1978:	701c      	strb	r4, [r3, #0]
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
    197a:	4b78      	ldr	r3, [pc, #480]	; (1b5c <main+0xf40>)
    197c:	20b0      	movs	r0, #176	; 0xb0
    197e:	8819      	ldrh	r1, [r3, #0]
    1980:	f7fe fc02 	bl	188 <mbus_write_message32>
                                for(i = 0; i < mem_light_len; i += 2) {
    1984:	e016      	b.n	19b4 <main+0xd98>
                                    reset_radio_data_arr();
    1986:	f7fe fc7d 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    198a:	f7fe fbf7 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
    198e:	4b74      	ldr	r3, [pc, #464]	; (1b60 <main+0xf44>)
    1990:	4d6e      	ldr	r5, [pc, #440]	; (1b4c <main+0xf30>)
    1992:	8819      	ldrh	r1, [r3, #0]
    1994:	2201      	movs	r2, #1
    1996:	1909      	adds	r1, r1, r4
    1998:	9200      	str	r2, [sp, #0]
    199a:	2006      	movs	r0, #6
    199c:	1c2b      	adds	r3, r5, #0
    199e:	f7fe fc5b 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    19a2:	f7fe fbe5 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    19a6:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    19a8:	2000      	movs	r0, #0
                                for(i = 0; i < mem_light_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    19aa:	b29b      	uxth	r3, r3
    19ac:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    19ae:	f7fe ff2b 	bl	808 <mrr_send_radio_data>
                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
                                for(i = 0; i < mem_light_len; i += 2) {
    19b2:	3402      	adds	r4, #2
    19b4:	4b69      	ldr	r3, [pc, #420]	; (1b5c <main+0xf40>)
    19b6:	881b      	ldrh	r3, [r3, #0]
    19b8:	429c      	cmp	r4, r3
    19ba:	dbe4      	blt.n	1986 <main+0xd6a>
				    radio_data_arr[2] &= 0x0000FFFF;

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
    19bc:	4b69      	ldr	r3, [pc, #420]	; (1b64 <main+0xf48>)
    19be:	20b1      	movs	r0, #177	; 0xb1
    19c0:	8819      	ldrh	r1, [r3, #0]
    19c2:	f7fe fbe1 	bl	188 <mbus_write_message32>
				for(i = 0; i < mem_temp_len; i += 2) {
    19c6:	2400      	movs	r4, #0
    19c8:	e016      	b.n	19f8 <main+0xddc>
                                    reset_radio_data_arr();
    19ca:	f7fe fc5b 	bl	284 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    19ce:	f7fe fbd5 	bl	17c <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
    19d2:	4b65      	ldr	r3, [pc, #404]	; (1b68 <main+0xf4c>)
    19d4:	4d5d      	ldr	r5, [pc, #372]	; (1b4c <main+0xf30>)
    19d6:	8819      	ldrh	r1, [r3, #0]
    19d8:	2201      	movs	r2, #1
    19da:	1909      	adds	r1, r1, r4
    19dc:	9200      	str	r2, [sp, #0]
    19de:	2006      	movs	r0, #6
    19e0:	1c2b      	adds	r3, r5, #0
    19e2:	f7fe fc39 	bl	258 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    19e6:	f7fe fbc3 	bl	170 <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    19ea:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    19ec:	2000      	movs	r0, #0
				for(i = 0; i < mem_temp_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    19ee:	b29b      	uxth	r3, r3
    19f0:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    19f2:	f7fe ff09 	bl	808 <mrr_send_radio_data>

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
				for(i = 0; i < mem_temp_len; i += 2) {
    19f6:	3402      	adds	r4, #2
    19f8:	4b5a      	ldr	r3, [pc, #360]	; (1b64 <main+0xf48>)
    19fa:	881b      	ldrh	r3, [r3, #0]
    19fc:	429c      	cmp	r4, r3
    19fe:	dbe4      	blt.n	19ca <main+0xdae>
    1a00:	e7a9      	b.n	1956 <main+0xd3a>
                            mrr_send_radio_data(1);

                            radio_counter++;
                        }

                        set_next_time(SEND_RAD, 600); // FIXME: set to 600
    1a02:	2002      	movs	r0, #2
    1a04:	2196      	movs	r1, #150	; 0x96
    1a06:	4081      	lsls	r1, r0
    1a08:	f7fe fe84 	bl	714 <set_next_time>
                    }
                }
            }
        }
    } while(sys_run_continuous);
    1a0c:	4b57      	ldr	r3, [pc, #348]	; (1b6c <main+0xf50>)
    1a0e:	781c      	ldrb	r4, [r3, #0]
    1a10:	2c00      	cmp	r4, #0
    1a12:	d000      	beq.n	1a16 <main+0xdfa>
    1a14:	e5af      	b.n	1576 <main+0x95a>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    1a16:	f7fe fe1f 	bl	658 <update_system_time>
    uint8_t i;
    if(lnt_start_meas == 1) {
    1a1a:	4b55      	ldr	r3, [pc, #340]	; (1b70 <main+0xf54>)
    1a1c:	781b      	ldrb	r3, [r3, #0]
    1a1e:	2b01      	cmp	r3, #1
    1a20:	d103      	bne.n	1a2a <main+0xe0e>
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    1a22:	4b54      	ldr	r3, [pc, #336]	; (1b74 <main+0xf58>)
    1a24:	681c      	ldr	r4, [r3, #0]
    1a26:	3432      	adds	r4, #50	; 0x32
    1a28:	e00e      	b.n	1a48 <main+0xe2c>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    1a2a:	1c23      	adds	r3, r4, #0
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1a2c:	4a41      	ldr	r2, [pc, #260]	; (1b34 <main+0xf18>)

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    if(lnt_start_meas == 1) {
    1a2e:	2401      	movs	r4, #1
    1a30:	4264      	negs	r4, r4
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1a32:	0099      	lsls	r1, r3, #2
    1a34:	5888      	ldr	r0, [r1, r2]
    1a36:	2800      	cmp	r0, #0
    1a38:	d003      	beq.n	1a42 <main+0xe26>
    1a3a:	5888      	ldr	r0, [r1, r2]
    1a3c:	42a0      	cmp	r0, r4
    1a3e:	d800      	bhi.n	1a42 <main+0xe26>
                min_time = xot_timer_list[i];
    1a40:	588c      	ldr	r4, [r1, r2]
    1a42:	3301      	adds	r3, #1
    uint8_t i;
    if(lnt_start_meas == 1) {
    	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME;
    }
    else {
        for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1a44:	2b03      	cmp	r3, #3
    1a46:	d1f4      	bne.n	1a32 <main+0xe16>
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    1a48:	1c62      	adds	r2, r4, #1
    1a4a:	d066      	beq.n	1b1a <main+0xefe>
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    1a4c:	2001      	movs	r0, #1
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1a4e:	4a39      	ldr	r2, [pc, #228]	; (1b34 <main+0xf18>)
                xot_last_timer_list[i] = xot_timer_list[i];
    1a50:	493a      	ldr	r1, [pc, #232]	; (1b3c <main+0xf20>)
                min_time = xot_timer_list[i];
            }
        }
    }

    if(min_time != 0xFFFFFFFF) {
    1a52:	2500      	movs	r5, #0
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    1a54:	4240      	negs	r0, r0
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1a56:	00ab      	lsls	r3, r5, #2
    1a58:	589e      	ldr	r6, [r3, r2]
    1a5a:	2e00      	cmp	r6, #0
    1a5c:	d005      	beq.n	1a6a <main+0xe4e>
    1a5e:	589e      	ldr	r6, [r3, r2]
    1a60:	42a6      	cmp	r6, r4
    1a62:	d802      	bhi.n	1a6a <main+0xe4e>
                xot_last_timer_list[i] = xot_timer_list[i];
    1a64:	589e      	ldr	r6, [r3, r2]
    1a66:	505e      	str	r6, [r3, r1]
                xot_timer_list[i] = 0xFFFFFFFF;
    1a68:	5098      	str	r0, [r3, r2]
    1a6a:	3501      	adds	r5, #1
        }
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1a6c:	2d03      	cmp	r5, #3
    1a6e:	d1f2      	bne.n	1a56 <main+0xe3a>
    mbus_write_message32(0xE4, (int32_t) (projected_end_time - xo_sys_time));
    mbus_write_message32(0xE4, lnt_snt_mplier);
}

static void set_lnt_timer(uint32_t end_time) {
    mbus_write_message32(0xCE, end_time);
    1a70:	20ce      	movs	r0, #206	; 0xce
    1a72:	1c21      	adds	r1, r4, #0
    1a74:	f7fe fb88 	bl	188 <mbus_write_message32>
    projected_end_time = end_time << 10;
    1a78:	4a3f      	ldr	r2, [pc, #252]	; (1b78 <main+0xf5c>)
    1a7a:	02a3      	lsls	r3, r4, #10
    1a7c:	6013      	str	r3, [r2, #0]

    if(end_time <= xo_sys_time_in_sec) {
    1a7e:	4a3d      	ldr	r2, [pc, #244]	; (1b74 <main+0xf58>)
    1a80:	6812      	ldr	r2, [r2, #0]
    1a82:	4294      	cmp	r4, r2
    1a84:	d805      	bhi.n	1a92 <main+0xe76>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
    1a86:	20af      	movs	r0, #175	; 0xaf
    1a88:	2100      	movs	r1, #0
    1a8a:	f7fe fb7d 	bl	188 <mbus_write_message32>
    operation_sleep_notimer();
    1a8e:	f7fe fd1f 	bl	4d0 <operation_sleep_notimer>

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a92:	4a3a      	ldr	r2, [pc, #232]	; (1b7c <main+0xf60>)
    uint32_t val = temp >> (MPLIER_SHIFT + 8);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1a94:	1c28      	adds	r0, r5, #0

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1a96:	6811      	ldr	r1, [r2, #0]
    1a98:	4a39      	ldr	r2, [pc, #228]	; (1b80 <main+0xf64>)
    1a9a:	1a5b      	subs	r3, r3, r1
    1a9c:	7811      	ldrb	r1, [r2, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a9e:	2640      	movs	r6, #64	; 0x40

    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1aa0:	4359      	muls	r1, r3
    uint32_t val = temp >> (MPLIER_SHIFT + 8);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    1aa2:	4b38      	ldr	r3, [pc, #224]	; (1b84 <main+0xf68>)
    1aa4:	0b89      	lsrs	r1, r1, #14
    1aa6:	681a      	ldr	r2, [r3, #0]
    1aa8:	0e12      	lsrs	r2, r2, #24
    1aaa:	0612      	lsls	r2, r2, #24
    1aac:	430a      	orrs	r2, r1
    1aae:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1ab0:	681a      	ldr	r2, [r3, #0]
    1ab2:	1c29      	adds	r1, r5, #0
    1ab4:	f7fe fba9 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1ab8:	4c33      	ldr	r4, [pc, #204]	; (1b88 <main+0xf6c>)
    1aba:	2208      	movs	r2, #8
    1abc:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1abe:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1ac0:	4393      	bics	r3, r2
    1ac2:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    1ac4:	7823      	ldrb	r3, [r4, #0]
    1ac6:	2204      	movs	r2, #4
    1ac8:	4313      	orrs	r3, r2
    1aca:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1acc:	6822      	ldr	r2, [r4, #0]
    1ace:	1c28      	adds	r0, r5, #0
    1ad0:	f7fe fb9b 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1ad4:	20fa      	movs	r0, #250	; 0xfa
    1ad6:	0080      	lsls	r0, r0, #2
    1ad8:	f7fe fae5 	bl	a6 <delay>
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    1adc:	7823      	ldrb	r3, [r4, #0]
    1ade:	2210      	movs	r2, #16
    1ae0:	4313      	orrs	r3, r2
    1ae2:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1ae4:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1ae6:	2220      	movs	r2, #32
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1ae8:	43b3      	bics	r3, r6
    1aea:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1aec:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1aee:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1af0:	4393      	bics	r3, r2
    1af2:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1af4:	6822      	ldr	r2, [r4, #0]
    1af6:	1c28      	adds	r0, r5, #0
    1af8:	f7fe fb87 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1afc:	20fa      	movs	r0, #250	; 0xfa
    1afe:	0080      	lsls	r0, r0, #2
    1b00:	f7fe fad1 	bl	a6 <delay>

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1b04:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b06:	1c28      	adds	r0, r5, #0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1b08:	431e      	orrs	r6, r3
    1b0a:	7026      	strb	r6, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1b0c:	6822      	ldr	r2, [r4, #0]
    1b0e:	2100      	movs	r1, #0
    1b10:	f7fe fb7b 	bl	20a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1b14:	481d      	ldr	r0, [pc, #116]	; (1b8c <main+0xf70>)
    1b16:	f7fe fac6 	bl	a6 <delay>
	    }
	}
	set_lnt_timer(min_time);
    }

    pmu_setting_temp_based(2);
    1b1a:	2002      	movs	r0, #2
    1b1c:	f7fe fc00 	bl	320 <pmu_setting_temp_based>
    operation_sleep();
    1b20:	f7fe fcc6 	bl	4b0 <operation_sleep>
    1b24:	00001cb8 	.word	0x00001cb8
    1b28:	00001cf8 	.word	0x00001cf8
    1b2c:	00001cb4 	.word	0x00001cb4
    1b30:	00001b96 	.word	0x00001b96
    1b34:	00001d04 	.word	0x00001d04
    1b38:	00001cf6 	.word	0x00001cf6
    1b3c:	00001c98 	.word	0x00001c98
    1b40:	00001cd1 	.word	0x00001cd1
    1b44:	00001cde 	.word	0x00001cde
    1b48:	00001cd8 	.word	0x00001cd8
    1b4c:	00001ce4 	.word	0x00001ce4
    1b50:	00001ce0 	.word	0x00001ce0
    1b54:	00001cf4 	.word	0x00001cf4
    1b58:	0000feed 	.word	0x0000feed
    1b5c:	00001cf2 	.word	0x00001cf2
    1b60:	00001cb2 	.word	0x00001cb2
    1b64:	00001cc0 	.word	0x00001cc0
    1b68:	00001cf0 	.word	0x00001cf0
    1b6c:	00001cf5 	.word	0x00001cf5
    1b70:	00001d2c 	.word	0x00001d2c
    1b74:	00001ccc 	.word	0x00001ccc
    1b78:	00001d24 	.word	0x00001d24
    1b7c:	00001cac 	.word	0x00001cac
    1b80:	00001c8c 	.word	0x00001c8c
    1b84:	00001c50 	.word	0x00001c50
    1b88:	00001c44 	.word	0x00001c44
    1b8c:	00002710 	.word	0x00002710
