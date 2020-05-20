
mbc_code_v4_1/mbc_code_v4_1.elf:     file format elf32-littlearm


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
  40:	00000c09 	.word	0x00000c09
  44:	00000000 	.word	0x00000000
  48:	00000c85 	.word	0x00000c85
  4c:	00000c9d 	.word	0x00000c9d
	...
  60:	00000cd1 	.word	0x00000cd1
  64:	00000ce1 	.word	0x00000ce1
  68:	00000cf1 	.word	0x00000cf1
  6c:	00000d01 	.word	0x00000d01
	...
  8c:	00000cbd 	.word	0x00000cbd

00000090 <hang>:
  90:	e7fe      	b.n	90 <hang>
	...

000000a0 <_start>:
  a0:	f000 fe36 	bl	d10 <main>
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

Disassembly of section .text.enable_xo_timer:

0000011c <enable_xo_timer>:

void enable_xo_timer () {
    uint32_t regval = *REG_XOT_CONFIG;
 11c:	4b03      	ldr	r3, [pc, #12]	; (12c <enable_xo_timer+0x10>)
    regval |= 0x800000; // XOT_ENABLE = 1;
 11e:	2280      	movs	r2, #128	; 0x80

	if( reset ) *WUPT_RESET = 0x01;
}

void enable_xo_timer () {
    uint32_t regval = *REG_XOT_CONFIG;
 120:	6819      	ldr	r1, [r3, #0]
    regval |= 0x800000; // XOT_ENABLE = 1;
 122:	0412      	lsls	r2, r2, #16
 124:	430a      	orrs	r2, r1
    *REG_XOT_CONFIG = regval;
 126:	601a      	str	r2, [r3, #0]
}
 128:	4770      	bx	lr
 12a:	46c0      	nop			; (mov r8, r8)
 12c:	a000004c 	.word	0xa000004c

Disassembly of section .text.set_xo_timer:

00000130 <set_xo_timer>:
    uint32_t regval = *REG_XOT_CONFIG;
    regval &= 0x7FFFFF; // XOT_ENABLE = 0;
    *REG_XOT_CONFIG = regval;
}

void set_xo_timer (uint8_t mode, uint32_t timestamp, uint8_t wreq_en, uint8_t irq_en) {
 130:	b510      	push	{r4, lr}
    uint32_t regval0 = timestamp & 0x0000FFFF;
 132:	b28c      	uxth	r4, r1
    uint32_t regval1 = (timestamp >> 16) & 0xFFFF;
 134:	0c09      	lsrs	r1, r1, #16
    // uint32_t regval1 = timestamp & 0xFFFF0000;	// This is wrong

    regval0 |= 0x00800000; // XOT_ENABLE = 1;
    if (mode)    regval0 |= 0x00400000; // XOT_MODE = 1
 136:	2800      	cmp	r0, #0
 138:	d101      	bne.n	13e <set_xo_timer+0xe>
void set_xo_timer (uint8_t mode, uint32_t timestamp, uint8_t wreq_en, uint8_t irq_en) {
    uint32_t regval0 = timestamp & 0x0000FFFF;
    uint32_t regval1 = (timestamp >> 16) & 0xFFFF;
    // uint32_t regval1 = timestamp & 0xFFFF0000;	// This is wrong

    regval0 |= 0x00800000; // XOT_ENABLE = 1;
 13a:	2080      	movs	r0, #128	; 0x80
 13c:	e000      	b.n	140 <set_xo_timer+0x10>
    if (mode)    regval0 |= 0x00400000; // XOT_MODE = 1
 13e:	20c0      	movs	r0, #192	; 0xc0
 140:	0400      	lsls	r0, r0, #16
 142:	4320      	orrs	r0, r4
    if (wreq_en) regval0 |= 0x00200000; // XOT_WREQ_EN = 1
 144:	2a00      	cmp	r2, #0
 146:	d002      	beq.n	14e <set_xo_timer+0x1e>
 148:	2280      	movs	r2, #128	; 0x80
 14a:	0392      	lsls	r2, r2, #14
 14c:	4310      	orrs	r0, r2
    if (irq_en)  regval0 |= 0x00100000; // XOT_IRQ_EN = 1
 14e:	2b00      	cmp	r3, #0
 150:	d002      	beq.n	158 <set_xo_timer+0x28>
 152:	2380      	movs	r3, #128	; 0x80
 154:	035b      	lsls	r3, r3, #13
 156:	4318      	orrs	r0, r3

    *REG_XOT_CONFIGU = regval1;
 158:	4b02      	ldr	r3, [pc, #8]	; (164 <set_xo_timer+0x34>)
 15a:	6019      	str	r1, [r3, #0]
    *REG_XOT_CONFIG  = regval0;
 15c:	4b02      	ldr	r3, [pc, #8]	; (168 <set_xo_timer+0x38>)
 15e:	6018      	str	r0, [r3, #0]
}
 160:	bd10      	pop	{r4, pc}
 162:	46c0      	nop			; (mov r8, r8)
 164:	a0000050 	.word	0xa0000050
 168:	a000004c 	.word	0xa000004c

Disassembly of section .text.reset_xo_cnt:

0000016c <reset_xo_cnt>:

void reset_xo_cnt  () { *XOT_RESET_CNT  = 0x1; }
 16c:	4b01      	ldr	r3, [pc, #4]	; (174 <reset_xo_cnt+0x8>)
 16e:	2201      	movs	r2, #1
 170:	601a      	str	r2, [r3, #0]
 172:	4770      	bx	lr
 174:	a0001400 	.word	0xa0001400

Disassembly of section .text.start_xo_cnt:

00000178 <start_xo_cnt>:
void start_xo_cnt  () { *XOT_START_CNT  = 0x1; }
 178:	4b01      	ldr	r3, [pc, #4]	; (180 <start_xo_cnt+0x8>)
 17a:	2201      	movs	r2, #1
 17c:	601a      	str	r2, [r3, #0]
 17e:	4770      	bx	lr
 180:	a0001404 	.word	0xa0001404

Disassembly of section .text.start_xo_cout:

00000184 <start_xo_cout>:
void stop_xo_cnt   () { *XOT_STOP_CNT   = 0x1; }
void start_xo_cout () { *XOT_START_COUT = 0x1; }
 184:	4b01      	ldr	r3, [pc, #4]	; (18c <start_xo_cout+0x8>)
 186:	2201      	movs	r2, #1
 188:	601a      	str	r2, [r3, #0]
 18a:	4770      	bx	lr
 18c:	a000140c 	.word	0xa000140c

Disassembly of section .text.stop_xo_cout:

00000190 <stop_xo_cout>:
void stop_xo_cout  () { *XOT_STOP_COUT  = 0x1; }
 190:	4b01      	ldr	r3, [pc, #4]	; (198 <stop_xo_cout+0x8>)
 192:	2201      	movs	r2, #1
 194:	601a      	str	r2, [r3, #0]
 196:	4770      	bx	lr
 198:	a0001410 	.word	0xa0001410

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

Disassembly of section .text.mbus_copy_registers_from_remote_to_local:

00000214 <mbus_copy_registers_from_remote_to_local>:
void mbus_copy_registers_from_remote_to_local(
		uint8_t remote_prefix,
		uint8_t remote_reg_start,
		uint8_t local_reg_start,
		uint8_t length_minus_one
		) {
 214:	b507      	push	{r0, r1, r2, lr}
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
        (remote_reg_start << 24) |
 216:	0609      	lsls	r1, r1, #24
 218:	430a      	orrs	r2, r1
		(length_minus_one << 16) |
		(mbus_get_short_prefix() << 12) |
 21a:	2180      	movs	r1, #128	; 0x80
 21c:	0149      	lsls	r1, r1, #5
 21e:	430a      	orrs	r2, r1
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
        (remote_reg_start << 24) |
		(length_minus_one << 16) |
 220:	041b      	lsls	r3, r3, #16
		(mbus_get_short_prefix() << 12) |
		(MPQ_REG_WRITE << 8) | // Write regs *to* _this_ node
 222:	431a      	orrs	r2, r3
		uint8_t length_minus_one
		) {
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
 224:	9201      	str	r2, [sp, #4]
		uint8_t local_reg_start,
		uint8_t length_minus_one
		) {
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
 226:	0100      	lsls	r0, r0, #4
 228:	2201      	movs	r2, #1
 22a:	4310      	orrs	r0, r2
		(length_minus_one << 16) |
		(mbus_get_short_prefix() << 12) |
		(MPQ_REG_WRITE << 8) | // Write regs *to* _this_ node
		(local_reg_start << 0);

	mbus_write_message(address, &data, 1);
 22c:	b2c0      	uxtb	r0, r0
 22e:	a901      	add	r1, sp, #4
 230:	f7ff ffc8 	bl	1c4 <mbus_write_message>
}
 234:	bd07      	pop	{r0, r1, r2, pc}

Disassembly of section .text.mbus_remote_register_write:

00000236 <mbus_remote_register_write>:

void mbus_remote_register_write(
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
 236:	b507      	push	{r0, r1, r2, lr}
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 238:	0212      	lsls	r2, r2, #8
 23a:	0a12      	lsrs	r2, r2, #8
 23c:	0609      	lsls	r1, r1, #24
 23e:	4311      	orrs	r1, r2
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
 240:	0100      	lsls	r0, r0, #4
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 242:	9101      	str	r1, [sp, #4]
	mbus_write_message(address, &data, 1);
 244:	b2c0      	uxtb	r0, r0
 246:	a901      	add	r1, sp, #4
 248:	2201      	movs	r2, #1
 24a:	f7ff ffbb 	bl	1c4 <mbus_write_message>
}
 24e:	bd07      	pop	{r0, r1, r2, pc}

Disassembly of section .text.mbus_copy_mem_from_local_to_remote_bulk:

00000250 <mbus_copy_mem_from_local_to_remote_bulk>:
void mbus_copy_mem_from_local_to_remote_bulk(
		uint8_t   remote_prefix,
		uint32_t* remote_memory_address,
		uint32_t* local_address,
		uint32_t  length_in_words_minus_one
		) {
 250:	b510      	push	{r4, lr}
	*MBUS_CMD0 = ( ((uint32_t) remote_prefix) << 28 ) | (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF);
 252:	2480      	movs	r4, #128	; 0x80
 254:	04a4      	lsls	r4, r4, #18
 256:	0700      	lsls	r0, r0, #28
 258:	031b      	lsls	r3, r3, #12
 25a:	4320      	orrs	r0, r4
 25c:	0b1b      	lsrs	r3, r3, #12
 25e:	4318      	orrs	r0, r3
 260:	4b04      	ldr	r3, [pc, #16]	; (274 <mbus_copy_mem_from_local_to_remote_bulk+0x24>)
 262:	6018      	str	r0, [r3, #0]
	*MBUS_CMD1 = (uint32_t) local_address;
 264:	4b04      	ldr	r3, [pc, #16]	; (278 <mbus_copy_mem_from_local_to_remote_bulk+0x28>)
 266:	601a      	str	r2, [r3, #0]
	*MBUS_CMD2 = (uint32_t) remote_memory_address;
 268:	4b04      	ldr	r3, [pc, #16]	; (27c <mbus_copy_mem_from_local_to_remote_bulk+0x2c>)

	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x3 << 4);
 26a:	2233      	movs	r2, #51	; 0x33
		uint32_t* local_address,
		uint32_t  length_in_words_minus_one
		) {
	*MBUS_CMD0 = ( ((uint32_t) remote_prefix) << 28 ) | (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF);
	*MBUS_CMD1 = (uint32_t) local_address;
	*MBUS_CMD2 = (uint32_t) remote_memory_address;
 26c:	6019      	str	r1, [r3, #0]

	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x3 << 4);
 26e:	4b04      	ldr	r3, [pc, #16]	; (280 <mbus_copy_mem_from_local_to_remote_bulk+0x30>)
 270:	601a      	str	r2, [r3, #0]
}
 272:	bd10      	pop	{r4, pc}
 274:	a0002000 	.word	0xa0002000
 278:	a0002004 	.word	0xa0002004
 27c:	a0002008 	.word	0xa0002008
 280:	a000200c 	.word	0xa000200c

Disassembly of section .text.mbus_copy_mem_from_remote_to_any_bulk:

00000284 <mbus_copy_mem_from_remote_to_any_bulk>:
		uint8_t   source_prefix,
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
 284:	b530      	push	{r4, r5, lr}
 286:	b085      	sub	sp, #20
	uint32_t payload[3] = {
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
 288:	9d08      	ldr	r5, [sp, #32]
 28a:	2480      	movs	r4, #128	; 0x80
 28c:	04a4      	lsls	r4, r4, #18
 28e:	0712      	lsls	r2, r2, #28
 290:	4322      	orrs	r2, r4
 292:	032c      	lsls	r4, r5, #12
 294:	0b24      	lsrs	r4, r4, #12
 296:	4322      	orrs	r2, r4
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 298:	9201      	str	r2, [sp, #4]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 29a:	0100      	lsls	r0, r0, #4
 29c:	2203      	movs	r2, #3
 29e:	4310      	orrs	r0, r2
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 2a0:	9102      	str	r1, [sp, #8]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 2a2:	b2c0      	uxtb	r0, r0
 2a4:	a901      	add	r1, sp, #4
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 2a6:	9303      	str	r3, [sp, #12]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 2a8:	f7ff ff8c 	bl	1c4 <mbus_write_message>
}
 2ac:	b005      	add	sp, #20
 2ae:	bd30      	pop	{r4, r5, pc}

Disassembly of section .text.reset_radio_data_arr:

000002b0 <reset_radio_data_arr>:
 * MRR functions (MRRv7)
 **********************************************/

static void reset_radio_data_arr() {
    uint8_t i;
    for(i = 0; i < 3; i++) { radio_data_arr[i] = 0; }
 2b0:	4b02      	ldr	r3, [pc, #8]	; (2bc <reset_radio_data_arr+0xc>)
 2b2:	2200      	movs	r2, #0
 2b4:	601a      	str	r2, [r3, #0]
 2b6:	605a      	str	r2, [r3, #4]
 2b8:	609a      	str	r2, [r3, #8]
}
 2ba:	4770      	bx	lr
 2bc:	00001c30 	.word	0x00001c30

Disassembly of section .text.pmu_reg_write:

000002c0 <pmu_reg_write>:


/**********************************************
 * PMU functions (PMUv11)
 **********************************************/
static void pmu_reg_write(uint32_t reg_addr, uint32_t reg_data) {
 2c0:	b538      	push	{r3, r4, r5, lr}
 2c2:	1c05      	adds	r5, r0, #0
 2c4:	1c0c      	adds	r4, r1, #0
    set_halt_until_mbus_trx();
 2c6:	f7ff ff6f 	bl	1a8 <set_halt_until_mbus_trx>
    mbus_remote_register_write(PMU_ADDR, reg_addr, reg_data);
 2ca:	b2e9      	uxtb	r1, r5
 2cc:	2005      	movs	r0, #5
 2ce:	1c22      	adds	r2, r4, #0
 2d0:	f7ff ffb1 	bl	236 <mbus_remote_register_write>
    set_halt_until_mbus_tx();
 2d4:	f7ff ff62 	bl	19c <set_halt_until_mbus_tx>
}
 2d8:	bd38      	pop	{r3, r4, r5, pc}

Disassembly of section .text.pmu_set_active_clk:

000002da <pmu_set_active_clk>:
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
 2da:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
 2dc:	1c04      	adds	r4, r0, #0
    }

    operation_sleep();

    while(1);
}
 2de:	25ff      	movs	r5, #255	; 0xff
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 16) & 0xFF;
 2e0:	0c26      	lsrs	r6, r4, #16
    }

    operation_sleep();

    while(1);
}
 2e2:	402e      	ands	r6, r5
    uint8_t r = (setting >> 16) & 0xFF;
    uint8_t l = (setting >> 12) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    mbus_write_message32(0xDE, setting);
 2e4:	1c21      	adds	r1, r4, #0
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2e6:	0276      	lsls	r6, r6, #9
    }

    operation_sleep();

    while(1);
}
 2e8:	1c27      	adds	r7, r4, #0
    uint8_t r = (setting >> 16) & 0xFF;
    uint8_t l = (setting >> 12) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    mbus_write_message32(0xDE, setting);
 2ea:	20de      	movs	r0, #222	; 0xde
 2ec:	f7ff ff62 	bl	1b4 <mbus_write_message32>
    }

    operation_sleep();

    while(1);
}
 2f0:	402f      	ands	r7, r5
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 2f2:	9600      	str	r6, [sp, #0]
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2f4:	1c32      	adds	r2, r6, #0
 2f6:	23c0      	movs	r3, #192	; 0xc0
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 16) & 0xFF;
    uint8_t l = (setting >> 12) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 2f8:	0a26      	lsrs	r6, r4, #8
    }

    operation_sleep();

    while(1);
}
 2fa:	402e      	ands	r6, r5
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 2fc:	021b      	lsls	r3, r3, #8
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 2fe:	017f      	lsls	r7, r7, #5
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 300:	431a      	orrs	r2, r3
                 (r <<  9) |    // frequency multiplier r
 302:	4337      	orrs	r7, r6
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 304:	4317      	orrs	r7, r2
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 16) & 0xFF;
    uint8_t l = (setting >> 12) & 0xFF;
 306:	0b24      	lsrs	r4, r4, #12

    mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 308:	1c39      	adds	r1, r7, #0
 30a:	2016      	movs	r0, #22
    }

    operation_sleep();

    while(1);
}
 30c:	4025      	ands	r5, r4
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 30e:	9201      	str	r2, [sp, #4]
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 310:	016d      	lsls	r5, r5, #5

    mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 312:	f7ff ffd5 	bl	2c0 <pmu_reg_write>
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 316:	1c39      	adds	r1, r7, #0
 318:	2016      	movs	r0, #22
 31a:	f7ff ffd1 	bl	2c0 <pmu_reg_write>
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 31e:	9b01      	ldr	r3, [sp, #4]

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 320:	1c29      	adds	r1, r5, #0
 322:	4331      	orrs	r1, r6
                 (l <<  5) |    // frequency multiplier l
 324:	4319      	orrs	r1, r3
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
 326:	2018      	movs	r0, #24
 328:	f7ff ffca 	bl	2c0 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 32c:	9a00      	ldr	r2, [sp, #0]
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 32e:	201a      	movs	r0, #26
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 330:	4315      	orrs	r5, r2
                 (l <<  5) |    // frequency multiplier l
 332:	1c29      	adds	r1, r5, #0
 334:	4331      	orrs	r1, r6
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 336:	f7ff ffc3 	bl	2c0 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
 33a:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.pmu_setting_temp_based:

0000033c <pmu_setting_temp_based>:

// 0 : normal active
// 1 : radio active
static void pmu_setting_temp_based(uint8_t mode) {
    int i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
 33c:	4b20      	ldr	r3, [pc, #128]	; (3c0 <pmu_setting_temp_based+0x84>)
    }
}

// 0 : normal active
// 1 : radio active
static void pmu_setting_temp_based(uint8_t mode) {
 33e:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    int i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
 340:	2213      	movs	r2, #19
    for(i = 0; i < 7; i++) {
        if(i == 7 || snt_sys_temp_code < PMU_TEMP_THRESH[i]) {
 342:	4920      	ldr	r1, [pc, #128]	; (3c4 <pmu_setting_temp_based+0x88>)

// 0 : normal active
// 1 : radio active
static void pmu_setting_temp_based(uint8_t mode) {
    int i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
 344:	601a      	str	r2, [r3, #0]
    for(i = 0; i < 7; i++) {
 346:	2400      	movs	r4, #0
 348:	1c1a      	adds	r2, r3, #0
    }
}

// 0 : normal active
// 1 : radio active
static void pmu_setting_temp_based(uint8_t mode) {
 34a:	00a3      	lsls	r3, r4, #2
    int i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
    for(i = 0; i < 7; i++) {
        if(i == 7 || snt_sys_temp_code < PMU_TEMP_THRESH[i]) {
 34c:	6815      	ldr	r5, [r2, #0]
 34e:	585e      	ldr	r6, [r3, r1]
 350:	42b5      	cmp	r5, r6
 352:	d22d      	bcs.n	3b0 <pmu_setting_temp_based+0x74>
            if(mode == 0) {
 354:	2800      	cmp	r0, #0
 356:	d101      	bne.n	35c <pmu_setting_temp_based+0x20>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 358:	4a1b      	ldr	r2, [pc, #108]	; (3c8 <pmu_setting_temp_based+0x8c>)
 35a:	e000      	b.n	35e <pmu_setting_temp_based+0x22>
            }
            else {
	        pmu_set_active_clk(PMU_RADIO_SETTINGS[i]);
 35c:	4a1b      	ldr	r2, [pc, #108]	; (3cc <pmu_setting_temp_based+0x90>)
 35e:	5898      	ldr	r0, [r3, r2]
 360:	f7ff ffbb 	bl	2da <pmu_set_active_clk>
            }
            pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 364:	4b1a      	ldr	r3, [pc, #104]	; (3d0 <pmu_setting_temp_based+0x94>)
 366:	00a4      	lsls	r4, r4, #2
 368:	58e5      	ldr	r5, [r4, r3]
    }

    operation_sleep();

    while(1);
}
 36a:	24ff      	movs	r4, #255	; 0xff
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 16) & 0xFF;
 36c:	0c2e      	lsrs	r6, r5, #16
    }

    operation_sleep();

    while(1);
}
 36e:	4026      	ands	r6, r4
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 370:	27c0      	movs	r7, #192	; 0xc0
                 (r <<  9) |    // frequency multiplier r
 372:	0276      	lsls	r6, r6, #9
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 374:	023f      	lsls	r7, r7, #8
 376:	4337      	orrs	r7, r6
                 (r <<  9) |    // frequency multiplier r
 378:	9600      	str	r6, [sp, #0]
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 16) & 0xFF;
    uint8_t l = (setting >> 12) & 0xFF;
 37a:	0b2e      	lsrs	r6, r5, #12
    }

    operation_sleep();

    while(1);
}
 37c:	4026      	ands	r6, r4
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 37e:	0176      	lsls	r6, r6, #5
 380:	9601      	str	r6, [sp, #4]

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 382:	9901      	ldr	r1, [sp, #4]
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 16) & 0xFF;
    uint8_t l = (setting >> 12) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 384:	0a2e      	lsrs	r6, r5, #8
    }

    operation_sleep();

    while(1);
}
 386:	4026      	ands	r6, r4

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 388:	4331      	orrs	r1, r6
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 38a:	4339      	orrs	r1, r7
    uint8_t l = (setting >> 12) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 38c:	2017      	movs	r0, #23
    }

    operation_sleep();

    while(1);
}
 38e:	402c      	ands	r4, r5
    uint8_t l = (setting >> 12) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 390:	f7ff ff96 	bl	2c0 <pmu_reg_write>
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 394:	0161      	lsls	r1, r4, #5
                ((0 << 19) |    // enable pdm even during periodic reset
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
 396:	4331      	orrs	r1, r6
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 398:	4339      	orrs	r1, r7
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
 39a:	2015      	movs	r0, #21
 39c:	f7ff ff90 	bl	2c0 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 3a0:	9900      	ldr	r1, [sp, #0]
 3a2:	9b01      	ldr	r3, [sp, #4]
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 3a4:	2019      	movs	r0, #25
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 3a6:	4319      	orrs	r1, r3
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 3a8:	4331      	orrs	r1, r6
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 3aa:	f7ff ff89 	bl	2c0 <pmu_reg_write>
 3ae:	e002      	b.n	3b6 <pmu_setting_temp_based+0x7a>
// 0 : normal active
// 1 : radio active
static void pmu_setting_temp_based(uint8_t mode) {
    int i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
    for(i = 0; i < 7; i++) {
 3b0:	3401      	adds	r4, #1
 3b2:	2c07      	cmp	r4, #7
 3b4:	d1c9      	bne.n	34a <pmu_setting_temp_based+0xe>
            }
            pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
            break;
        }
    }
    delay(MBUS_DELAY);
 3b6:	2064      	movs	r0, #100	; 0x64
 3b8:	f7ff fe75 	bl	a6 <delay>
}
 3bc:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}
 3be:	46c0      	nop			; (mov r8, r8)
 3c0:	00001c2c 	.word	0x00001c2c
 3c4:	00001b0c 	.word	0x00001b0c
 3c8:	00001b30 	.word	0x00001b30
 3cc:	00001aec 	.word	0x00001aec
 3d0:	00001b58 	.word	0x00001b58

Disassembly of section .text.radio_power_off:

000003d4 <radio_power_off>:
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    delay(MBUS_DELAY*5); // Freq stab

}

static void radio_power_off() {
 3d4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 3d6:	4c2c      	ldr	r4, [pc, #176]	; (488 <radio_power_off+0xb4>)
 3d8:	2601      	movs	r6, #1
 3da:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 3dc:	2002      	movs	r0, #2

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 3de:	43b3      	bics	r3, r6
 3e0:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 3e2:	6822      	ldr	r2, [r4, #0]
 3e4:	2100      	movs	r1, #0
 3e6:	f7ff ff26 	bl	236 <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 3ea:	6823      	ldr	r3, [r4, #0]
 3ec:	227e      	movs	r2, #126	; 0x7e
 3ee:	4393      	bics	r3, r2
 3f0:	2220      	movs	r2, #32
 3f2:	4313      	orrs	r3, r2
 3f4:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 3f6:	6822      	ldr	r2, [r4, #0]
 3f8:	2002      	movs	r0, #2
 3fa:	2100      	movs	r1, #0
 3fc:	f7ff ff1b 	bl	236 <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 400:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 402:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 404:	4333      	orrs	r3, r6
 406:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 408:	6822      	ldr	r2, [r4, #0]
 40a:	2100      	movs	r1, #0
 40c:	f7ff ff13 	bl	236 <mbus_remote_register_write>

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 410:	4b1e      	ldr	r3, [pc, #120]	; (48c <radio_power_off+0xb8>)
 412:	4a1f      	ldr	r2, [pc, #124]	; (490 <radio_power_off+0xbc>)
 414:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 416:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 418:	400a      	ands	r2, r1
 41a:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 41c:	681a      	ldr	r2, [r3, #0]
 41e:	2103      	movs	r1, #3
 420:	f7ff ff09 	bl	236 <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 424:	4b1b      	ldr	r3, [pc, #108]	; (494 <radio_power_off+0xc0>)
 426:	2704      	movs	r7, #4
 428:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 42a:	2502      	movs	r5, #2

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 42c:	43ba      	bics	r2, r7
 42e:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 430:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 432:	1c28      	adds	r0, r5, #0
    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 434:	43aa      	bics	r2, r5
 436:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 438:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 43a:	2111      	movs	r1, #17
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 43c:	4332      	orrs	r2, r6
 43e:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 440:	681a      	ldr	r2, [r3, #0]
 442:	f7ff fef8 	bl	236 <mbus_remote_register_write>

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 446:	4c14      	ldr	r4, [pc, #80]	; (498 <radio_power_off+0xc4>)
 448:	2208      	movs	r2, #8
 44a:	6823      	ldr	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 44c:	1c28      	adds	r0, r5, #0
    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 44e:	4313      	orrs	r3, r2
 450:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
 452:	6823      	ldr	r3, [r4, #0]
 454:	2220      	movs	r2, #32
 456:	4393      	bics	r3, r2
 458:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
 45a:	6823      	ldr	r3, [r4, #0]
 45c:	2210      	movs	r2, #16
 45e:	4313      	orrs	r3, r2
 460:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 462:	1c39      	adds	r1, r7, #0
 464:	6822      	ldr	r2, [r4, #0]
 466:	f7ff fee6 	bl	236 <mbus_remote_register_write>

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 46a:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 46c:	1c28      	adds	r0, r5, #0
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 46e:	43b3      	bics	r3, r6
 470:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 472:	6822      	ldr	r2, [r4, #0]
 474:	1c39      	adds	r1, r7, #0
 476:	f7ff fede 	bl	236 <mbus_remote_register_write>

    radio_on = 0;
 47a:	4a08      	ldr	r2, [pc, #32]	; (49c <radio_power_off+0xc8>)
 47c:	2300      	movs	r3, #0
 47e:	7013      	strb	r3, [r2, #0]
    radio_ready = 0;
 480:	4a07      	ldr	r2, [pc, #28]	; (4a0 <radio_power_off+0xcc>)
 482:	7013      	strb	r3, [r2, #0]

}
 484:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 486:	46c0      	nop			; (mov r8, r8)
 488:	00001bbc 	.word	0x00001bbc
 48c:	00001bc8 	.word	0x00001bc8
 490:	ffefffff 	.word	0xffefffff
 494:	00001bd0 	.word	0x00001bd0
 498:	00001bcc 	.word	0x00001bcc
 49c:	00001c70 	.word	0x00001c70
 4a0:	00001bf6 	.word	0x00001bf6

Disassembly of section .text.operation_sleep:

000004a4 <operation_sleep>:

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
 4a4:	b508      	push	{r3, lr}
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;
 4a6:	2200      	movs	r2, #0
 4a8:	238c      	movs	r3, #140	; 0x8c
 4aa:	601a      	str	r2, [r3, #0]

#ifdef USE_MRR
    if(radio_on) {
 4ac:	4b04      	ldr	r3, [pc, #16]	; (4c0 <operation_sleep+0x1c>)
 4ae:	781b      	ldrb	r3, [r3, #0]
 4b0:	4293      	cmp	r3, r2
 4b2:	d001      	beq.n	4b8 <operation_sleep+0x14>
    	radio_power_off();
 4b4:	f7ff ff8e 	bl	3d4 <radio_power_off>
    }
#endif

    mbus_sleep_all();
 4b8:	f7ff fea6 	bl	208 <mbus_sleep_all>
 4bc:	e7fe      	b.n	4bc <operation_sleep+0x18>
 4be:	46c0      	nop			; (mov r8, r8)
 4c0:	00001c70 	.word	0x00001c70

Disassembly of section .text.operation_sleep_notimer:

000004c4 <operation_sleep_notimer>:
    while(1);
}

static void operation_sleep_notimer( void ) {
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 4c4:	2000      	movs	r0, #0

    mbus_sleep_all();
    while(1);
}

static void operation_sleep_notimer( void ) {
 4c6:	b508      	push	{r3, lr}
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 4c8:	1c01      	adds	r1, r0, #0
 4ca:	1c02      	adds	r2, r0, #0
 4cc:	f7ff fe10 	bl	f0 <set_wakeup_timer>
    set_xo_timer(0, 0, 0, 0);
 4d0:	2000      	movs	r0, #0
 4d2:	1c01      	adds	r1, r0, #0
 4d4:	1c02      	adds	r2, r0, #0
 4d6:	1c03      	adds	r3, r0, #0
 4d8:	f7ff fe2a 	bl	130 <set_xo_timer>
    config_timer32(0, 0, 0, 0);
 4dc:	2000      	movs	r0, #0
 4de:	1c01      	adds	r1, r0, #0
 4e0:	1c02      	adds	r2, r0, #0
 4e2:	1c03      	adds	r3, r0, #0
 4e4:	f7ff fdea 	bl	bc <config_timer32>
    // TODO: reset SNT timer
    operation_sleep();
 4e8:	f7ff ffdc 	bl	4a4 <operation_sleep>

Disassembly of section .text.operation_temp_run:

000004ec <operation_temp_run>:
//     mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
//     mbus_write_message32(0xCE, end_time - xo_sys_time_in_sec);
// }


static void operation_temp_run() {
 4ec:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    if(snt_state == SNT_IDLE) {
 4ee:	4c51      	ldr	r4, [pc, #324]	; (634 <operation_temp_run+0x148>)
 4f0:	7821      	ldrb	r1, [r4, #0]
 4f2:	2900      	cmp	r1, #0
 4f4:	d10c      	bne.n	510 <operation_temp_run+0x24>
    sntv4_r01.TSNS_RESETn = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void snt_ldo_vref_on() {
    sntv4_r00.LDO_EN_VREF = 1;
 4f6:	4b50      	ldr	r3, [pc, #320]	; (638 <operation_temp_run+0x14c>)
 4f8:	2004      	movs	r0, #4
 4fa:	881a      	ldrh	r2, [r3, #0]
 4fc:	4302      	orrs	r2, r0
 4fe:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 500:	681a      	ldr	r2, [r3, #0]
 502:	f7ff fe98 	bl	236 <mbus_remote_register_write>
    if(snt_state == SNT_IDLE) {

        // Turn on snt ldo vref; requires ~30 ms to settle
        // TODo: figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);
 506:	2064      	movs	r0, #100	; 0x64
 508:	f7ff fdcd 	bl	a6 <delay>

        snt_state = SNT_TEMP_LDO;
 50c:	2301      	movs	r3, #1
 50e:	7023      	strb	r3, [r4, #0]

    }
    if(snt_state == SNT_TEMP_LDO) {
 510:	4f48      	ldr	r7, [pc, #288]	; (634 <operation_temp_run+0x148>)
 512:	783d      	ldrb	r5, [r7, #0]
 514:	2d01      	cmp	r5, #1
 516:	d12e      	bne.n	576 <operation_temp_run+0x8a>
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 518:	4b47      	ldr	r3, [pc, #284]	; (638 <operation_temp_run+0x14c>)
 51a:	2602      	movs	r6, #2
 51c:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 51e:	2004      	movs	r0, #4
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 520:	4332      	orrs	r2, r6
 522:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
 524:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 526:	2100      	movs	r1, #0
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
    sntv4_r00.LDO_EN_LDO  = 1;
 528:	432a      	orrs	r2, r5
 52a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 52c:	681a      	ldr	r2, [r3, #0]
 52e:	f7ff fe82 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 532:	4c42      	ldr	r4, [pc, #264]	; (63c <operation_temp_run+0x150>)
 534:	2208      	movs	r2, #8
 536:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 538:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 53a:	4313      	orrs	r3, r2
 53c:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 53e:	6822      	ldr	r2, [r4, #0]
 540:	1c29      	adds	r1, r5, #0
 542:	f7ff fe78 	bl	236 <mbus_remote_register_write>
    // Un-powergate analog block
    sntv4_r01.TSNS_EN_SENSOR_LDO = 1;
 546:	8823      	ldrh	r3, [r4, #0]
 548:	2220      	movs	r2, #32
 54a:	4313      	orrs	r3, r2
 54c:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 54e:	6822      	ldr	r2, [r4, #0]
 550:	1c29      	adds	r1, r5, #0
 552:	2004      	movs	r0, #4
 554:	f7ff fe6f 	bl	236 <mbus_remote_register_write>

    delay(MBUS_DELAY);
 558:	2064      	movs	r0, #100	; 0x64
 55a:	f7ff fda4 	bl	a6 <delay>

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 55e:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 560:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    delay(MBUS_DELAY);

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 562:	43b3      	bics	r3, r6
 564:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 566:	6822      	ldr	r2, [r4, #0]
 568:	1c29      	adds	r1, r5, #0
 56a:	f7ff fe64 	bl	236 <mbus_remote_register_write>
        // Power on snt ldo
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);
 56e:	2064      	movs	r0, #100	; 0x64
 570:	f7ff fd99 	bl	a6 <delay>

        snt_state = SNT_TEMP_START;
 574:	703e      	strb	r6, [r7, #0]
    }
    if(snt_state == SNT_TEMP_START) {
 576:	4d2f      	ldr	r5, [pc, #188]	; (634 <operation_temp_run+0x148>)
 578:	782b      	ldrb	r3, [r5, #0]
 57a:	2b02      	cmp	r3, #2
 57c:	d11d      	bne.n	5ba <operation_temp_run+0xce>
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 57e:	4b30      	ldr	r3, [pc, #192]	; (640 <operation_temp_run+0x154>)
 580:	2400      	movs	r4, #0
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 582:	20a0      	movs	r0, #160	; 0xa0

        snt_state = SNT_TEMP_START;
    }
    if(snt_state == SNT_TEMP_START) {
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 584:	701c      	strb	r4, [r3, #0]
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 586:	0300      	lsls	r0, r0, #12
 588:	2101      	movs	r1, #1
 58a:	1c22      	adds	r2, r4, #0
 58c:	1c23      	adds	r3, r4, #0
 58e:	f7ff fd95 	bl	bc <config_timer32>
/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/

static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
 592:	482a      	ldr	r0, [pc, #168]	; (63c <operation_temp_run+0x150>)
 594:	2101      	movs	r1, #1
 596:	8803      	ldrh	r3, [r0, #0]
 598:	430b      	orrs	r3, r1
 59a:	8003      	strh	r3, [r0, #0]
    sntv4_r01.TSNS_EN_IRQ = 1;
 59c:	8802      	ldrh	r2, [r0, #0]
 59e:	2380      	movs	r3, #128	; 0x80
 5a0:	408b      	lsls	r3, r1
 5a2:	4313      	orrs	r3, r2
 5a4:	8003      	strh	r3, [r0, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5a6:	6802      	ldr	r2, [r0, #0]
 5a8:	2004      	movs	r0, #4
 5aa:	f7ff fe44 	bl	236 <mbus_remote_register_write>
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or TIMER32
	WFI();
 5ae:	f7ff fd82 	bl	b6 <WFI>

        // Turn off timer32
        *TIMER32_GO = 0;
 5b2:	4b24      	ldr	r3, [pc, #144]	; (644 <operation_temp_run+0x158>)
 5b4:	601c      	str	r4, [r3, #0]

        snt_state = SNT_TEMP_READ;
 5b6:	2303      	movs	r3, #3
 5b8:	702b      	strb	r3, [r5, #0]
    }
    if(snt_state == SNT_TEMP_READ) {
 5ba:	4a1e      	ldr	r2, [pc, #120]	; (634 <operation_temp_run+0x148>)
 5bc:	7813      	ldrb	r3, [r2, #0]
 5be:	2b03      	cmp	r3, #3
 5c0:	d136      	bne.n	630 <operation_temp_run+0x144>
        if(wfi_timeout_flag) {
 5c2:	4b1f      	ldr	r3, [pc, #124]	; (640 <operation_temp_run+0x154>)
 5c4:	781d      	ldrb	r5, [r3, #0]
 5c6:	1e2e      	subs	r6, r5, #0
 5c8:	d006      	beq.n	5d8 <operation_temp_run+0xec>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 5ca:	2180      	movs	r1, #128	; 0x80
 5cc:	0449      	lsls	r1, r1, #17
 5ce:	20af      	movs	r0, #175	; 0xaf
 5d0:	f7ff fdf0 	bl	1b4 <mbus_write_message32>
    operation_sleep_notimer();
 5d4:	f7ff ff76 	bl	4c4 <operation_sleep_notimer>
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 5d8:	23a0      	movs	r3, #160	; 0xa0
 5da:	061b      	lsls	r3, r3, #24
 5dc:	681a      	ldr	r2, [r3, #0]
 5de:	4b1a      	ldr	r3, [pc, #104]	; (648 <operation_temp_run+0x15c>)
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5e0:	2401      	movs	r4, #1
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 5e2:	601a      	str	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5e4:	4b15      	ldr	r3, [pc, #84]	; (63c <operation_temp_run+0x150>)
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5e6:	2108      	movs	r1, #8
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5e8:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 5ea:	2702      	movs	r7, #2
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5ec:	43a2      	bics	r2, r4
 5ee:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5f0:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5f2:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5f4:	438a      	bics	r2, r1
 5f6:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
 5f8:	881a      	ldrh	r2, [r3, #0]
 5fa:	2120      	movs	r1, #32
 5fc:	438a      	bics	r2, r1
 5fe:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE       = 1;
 600:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 602:	1c21      	adds	r1, r4, #0

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 604:	433a      	orrs	r2, r7
 606:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 608:	681a      	ldr	r2, [r3, #0]
 60a:	f7ff fe14 	bl	236 <mbus_remote_register_write>
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 60e:	4b0a      	ldr	r3, [pc, #40]	; (638 <operation_temp_run+0x14c>)
 610:	2004      	movs	r0, #4
 612:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
    sntv4_r00.LDO_EN_LDO  = 0;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 614:	1c31      	adds	r1, r6, #0
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 616:	4382      	bics	r2, r0
 618:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
 61a:	881a      	ldrh	r2, [r3, #0]
 61c:	43ba      	bics	r2, r7
 61e:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 0;
 620:	881a      	ldrh	r2, [r3, #0]
 622:	43a2      	bics	r2, r4
 624:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 626:	681a      	ldr	r2, [r3, #0]
 628:	f7ff fe05 	bl	236 <mbus_remote_register_write>
            
            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

            snt_state = SNT_IDLE;
 62c:	4b01      	ldr	r3, [pc, #4]	; (634 <operation_temp_run+0x148>)
 62e:	701d      	strb	r5, [r3, #0]
        }
    }
}
 630:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 632:	46c0      	nop			; (mov r8, r8)
 634:	00001c18 	.word	0x00001c18
 638:	00001b90 	.word	0x00001b90
 63c:	00001b94 	.word	0x00001b94
 640:	00001c6c 	.word	0x00001c6c
 644:	a0001100 	.word	0xa0001100
 648:	00001c2c 	.word	0x00001c2c

Disassembly of section .text.xo_init:

0000064c <xo_init>:
                     (xo_scn_clk_sel   << 1)  |
                     (xo_scn_enb       << 0));
    mbus_write_message32(0xA1, *REG_XO_CONF1);
}

void xo_init( void ) {
 64c:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    // Parasitic capacitance tuning (6 bits for each; each 1 adds 1.8pF)
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));
 64e:	4a53      	ldr	r2, [pc, #332]	; (79c <xo_init+0x150>)
 650:	4b53      	ldr	r3, [pc, #332]	; (7a0 <xo_init+0x154>)

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
 652:	4c54      	ldr	r4, [pc, #336]	; (7a4 <xo_init+0x158>)

void xo_init( void ) {
    // Parasitic capacitance tuning (6 bits for each; each 1 adds 1.8pF)
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));
 654:	601a      	str	r2, [r3, #0]

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
 656:	6822      	ldr	r2, [r4, #0]
 658:	4b53      	ldr	r3, [pc, #332]	; (7a8 <xo_init+0x15c>)
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
    prev20_r19.XO_DRV_START_UP  = 0x0;
    prev20_r19.XO_DRV_CORE      = 0x0;
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
 65a:	2602      	movs	r6, #2
    uint32_t xo_cap_drv = 0x3F;
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
 65c:	4013      	ands	r3, r2
 65e:	2280      	movs	r2, #128	; 0x80
 660:	0192      	lsls	r2, r2, #6
 662:	4313      	orrs	r3, r2
 664:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
 666:	6822      	ldr	r2, [r4, #0]
 668:	4b50      	ldr	r3, [pc, #320]	; (7ac <xo_init+0x160>)
    prev20_r19.XO_RP_MEDIA      = 0x1;
    prev20_r19.XO_RP_MVT        = 0x0;
    prev20_r19.XO_RP_SVT        = 0x0;

    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
 66a:	4d51      	ldr	r5, [pc, #324]	; (7b0 <xo_init+0x164>)
    uint32_t xo_cap_in  = 0x3F;
    *REG_XO_CONF2 = ((xo_cap_drv << 6) | (xo_cap_in << 0));

    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
 66c:	4013      	ands	r3, r2
 66e:	22c0      	movs	r2, #192	; 0xc0
 670:	0092      	lsls	r2, r2, #2
 672:	4313      	orrs	r3, r2
 674:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DRV_START_UP  = 0x0;
 676:	6823      	ldr	r3, [r4, #0]
 678:	2280      	movs	r2, #128	; 0x80
 67a:	4393      	bics	r3, r2
 67c:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DRV_CORE      = 0x0;
 67e:	6823      	ldr	r3, [r4, #0]
 680:	2240      	movs	r2, #64	; 0x40
 682:	4393      	bics	r3, r2
 684:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
 686:	6823      	ldr	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB       = 0x1;
 688:	2201      	movs	r2, #1
    // XO xonfiguration
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
    prev20_r19.XO_DRV_START_UP  = 0x0;
    prev20_r19.XO_DRV_CORE      = 0x0;
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
 68a:	43b3      	bics	r3, r6
 68c:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB       = 0x1;
 68e:	6823      	ldr	r3, [r4, #0]
    prev20_r19.XO_RP_SVT        = 0x0;

    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000); // >= 1ms
 690:	4f48      	ldr	r7, [pc, #288]	; (7b4 <xo_init+0x168>)
    prev20_r19.XO_PULSE_SEL     = 0x4; // pulse with sel, 1-hot encoded
    prev20_r19.XO_DELAY_EN      = 0x3; // pair usage together with xo_pulse_sel
    prev20_r19.XO_DRV_START_UP  = 0x0;
    prev20_r19.XO_DRV_CORE      = 0x0;
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
    prev20_r19.XO_SCN_ENB       = 0x1;
 692:	4313      	orrs	r3, r2
 694:	6023      	str	r3, [r4, #0]

    // TODO: check if need 32.768kHz clock
    prev20_r19.XO_EN_DIV        = 0x1; // divider enable (also enables CLK_OUT)
 696:	6822      	ldr	r2, [r4, #0]
 698:	2380      	movs	r3, #128	; 0x80
 69a:	035b      	lsls	r3, r3, #13
 69c:	4313      	orrs	r3, r2
 69e:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_S             = 0x0; // (not used) division ration for 16kHz out
 6a0:	6822      	ldr	r2, [r4, #0]
 6a2:	4b45      	ldr	r3, [pc, #276]	; (7b8 <xo_init+0x16c>)
    prev20_r19.XO_RP_MVT        = 0x0;
    prev20_r19.XO_RP_SVT        = 0x0;

    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 6a4:	20a1      	movs	r0, #161	; 0xa1
    prev20_r19.XO_SCN_CLK_SEL   = 0x0;
    prev20_r19.XO_SCN_ENB       = 0x1;

    // TODO: check if need 32.768kHz clock
    prev20_r19.XO_EN_DIV        = 0x1; // divider enable (also enables CLK_OUT)
    prev20_r19.XO_S             = 0x0; // (not used) division ration for 16kHz out
 6a6:	4013      	ands	r3, r2
 6a8:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SEL_CP_DIV    = 0x0; // 1: 0.3v-generation charge-pump uses divided clock
 6aa:	6822      	ldr	r2, [r4, #0]
 6ac:	4b43      	ldr	r3, [pc, #268]	; (7bc <xo_init+0x170>)
 6ae:	4013      	ands	r3, r2
 6b0:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_EN_OUT        = 0x1; // xo output enabled;
 6b2:	6822      	ldr	r2, [r4, #0]
 6b4:	2380      	movs	r3, #128	; 0x80
 6b6:	021b      	lsls	r3, r3, #8
 6b8:	4313      	orrs	r3, r2
 6ba:	6023      	str	r3, [r4, #0]
    				       // Note: I think this means output to XOT
    // Pseudo-resistor selection
    prev20_r19.XO_RP_LOW        = 0x0;
 6bc:	6823      	ldr	r3, [r4, #0]
 6be:	2220      	movs	r2, #32
 6c0:	4393      	bics	r3, r2
 6c2:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_RP_MEDIA      = 0x1;
 6c4:	6823      	ldr	r3, [r4, #0]
 6c6:	2210      	movs	r2, #16
 6c8:	4313      	orrs	r3, r2
 6ca:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_RP_MVT        = 0x0;
 6cc:	6823      	ldr	r3, [r4, #0]
 6ce:	2208      	movs	r2, #8
 6d0:	4393      	bics	r3, r2
 6d2:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_RP_SVT        = 0x0;
 6d4:	6823      	ldr	r3, [r4, #0]
 6d6:	2204      	movs	r2, #4
 6d8:	4393      	bics	r3, r2
 6da:	6023      	str	r3, [r4, #0]

    prev20_r19.XO_SLEEP = 0x0;
 6dc:	6822      	ldr	r2, [r4, #0]
 6de:	4b38      	ldr	r3, [pc, #224]	; (7c0 <xo_init+0x174>)
 6e0:	4013      	ands	r3, r2
 6e2:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 6e4:	6823      	ldr	r3, [r4, #0]
 6e6:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 6e8:	6829      	ldr	r1, [r5, #0]
 6ea:	f7ff fd63 	bl	1b4 <mbus_write_message32>
    delay(10000); // >= 1ms
 6ee:	1c38      	adds	r0, r7, #0
 6f0:	f7ff fcd9 	bl	a6 <delay>

    prev20_r19.XO_ISOLATE = 0x0;
 6f4:	6822      	ldr	r2, [r4, #0]
 6f6:	4b33      	ldr	r3, [pc, #204]	; (7c4 <xo_init+0x178>)
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 6f8:	20a1      	movs	r0, #161	; 0xa1
    prev20_r19.XO_SLEEP = 0x0;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000); // >= 1ms

    prev20_r19.XO_ISOLATE = 0x0;
 6fa:	4013      	ands	r3, r2
 6fc:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 6fe:	6823      	ldr	r3, [r4, #0]
 700:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 702:	6829      	ldr	r1, [r5, #0]
 704:	f7ff fd56 	bl	1b4 <mbus_write_message32>
    delay(10000); // >= 1ms
 708:	1c38      	adds	r0, r7, #0
 70a:	f7ff fccc 	bl	a6 <delay>

    prev20_r19.XO_DRV_START_UP = 0x1;
 70e:	6823      	ldr	r3, [r4, #0]
 710:	2280      	movs	r2, #128	; 0x80
 712:	4313      	orrs	r3, r2
 714:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 716:	6823      	ldr	r3, [r4, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(30000); // >= 1s
 718:	4f2b      	ldr	r7, [pc, #172]	; (7c8 <xo_init+0x17c>)
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(10000); // >= 1ms

    prev20_r19.XO_DRV_START_UP = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
 71a:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 71c:	6829      	ldr	r1, [r5, #0]
 71e:	20a1      	movs	r0, #161	; 0xa1
 720:	f7ff fd48 	bl	1b4 <mbus_write_message32>
    delay(30000); // >= 1s
 724:	1c38      	adds	r0, r7, #0
 726:	f7ff fcbe 	bl	a6 <delay>

    prev20_r19.XO_SCN_CLK_SEL = 0x1;
 72a:	6823      	ldr	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 72c:	20a1      	movs	r0, #161	; 0xa1
    prev20_r19.XO_DRV_START_UP = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(30000); // >= 1s

    prev20_r19.XO_SCN_CLK_SEL = 0x1;
 72e:	4333      	orrs	r3, r6
 730:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 732:	6823      	ldr	r3, [r4, #0]
 734:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 736:	6829      	ldr	r1, [r5, #0]
 738:	f7ff fd3c 	bl	1b4 <mbus_write_message32>
    delay(3000); // >= 300us
 73c:	4823      	ldr	r0, [pc, #140]	; (7cc <xo_init+0x180>)
 73e:	f7ff fcb2 	bl	a6 <delay>

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
 742:	6823      	ldr	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB     = 0x0;
 744:	2201      	movs	r2, #1
    prev20_r19.XO_SCN_CLK_SEL = 0x1;
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(3000); // >= 300us

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
 746:	43b3      	bics	r3, r6
 748:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_ENB     = 0x0;
 74a:	6823      	ldr	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 74c:	20a1      	movs	r0, #161	; 0xa1
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(3000); // >= 300us

    prev20_r19.XO_SCN_CLK_SEL = 0x0;
    prev20_r19.XO_SCN_ENB     = 0x0;
 74e:	4393      	bics	r3, r2
 750:	6023      	str	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 752:	6823      	ldr	r3, [r4, #0]
 754:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 756:	6829      	ldr	r1, [r5, #0]
 758:	f7ff fd2c 	bl	1b4 <mbus_write_message32>
    delay(30000);  // >= 1s
 75c:	1c38      	adds	r0, r7, #0
 75e:	f7ff fca2 	bl	a6 <delay>

    prev20_r19.XO_DRV_START_UP = 0x0;
 762:	6823      	ldr	r3, [r4, #0]
 764:	2280      	movs	r2, #128	; 0x80
 766:	4393      	bics	r3, r2
 768:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_DRV_CORE     = 0x1;
 76a:	6823      	ldr	r3, [r4, #0]
 76c:	2240      	movs	r2, #64	; 0x40
 76e:	4313      	orrs	r3, r2
 770:	6023      	str	r3, [r4, #0]
    prev20_r19.XO_SCN_CLK_SEL  = 0x1;
 772:	6823      	ldr	r3, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 774:	20a1      	movs	r0, #161	; 0xa1
    mbus_write_message32(0xA1, *REG_XO_CONF1);
    delay(30000);  // >= 1s

    prev20_r19.XO_DRV_START_UP = 0x0;
    prev20_r19.XO_DRV_CORE     = 0x1;
    prev20_r19.XO_SCN_CLK_SEL  = 0x1;
 776:	431e      	orrs	r6, r3
 778:	6026      	str	r6, [r4, #0]
    *REG_XO_CONF1 = prev20_r19.as_int;
 77a:	6823      	ldr	r3, [r4, #0]
 77c:	602b      	str	r3, [r5, #0]
    mbus_write_message32(0xA1, *REG_XO_CONF1);
 77e:	6829      	ldr	r1, [r5, #0]
 780:	f7ff fd18 	bl	1b4 <mbus_write_message32>

    enable_xo_timer();
 784:	f7ff fcca 	bl	11c <enable_xo_timer>
    reset_xo_cnt();
 788:	f7ff fcf0 	bl	16c <reset_xo_cnt>
    start_xo_cnt();
 78c:	f7ff fcf4 	bl	178 <start_xo_cnt>

    // BREAKPOint 0x03
    mbus_write_message32(0xBA, 0x03);
 790:	2103      	movs	r1, #3
 792:	20ba      	movs	r0, #186	; 0xba
 794:	f7ff fd0e 	bl	1b4 <mbus_write_message32>

}
 798:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 79a:	46c0      	nop			; (mov r8, r8)
 79c:	00000fff 	.word	0x00000fff
 7a0:	a0000068 	.word	0xa0000068
 7a4:	00001b8c 	.word	0x00001b8c
 7a8:	ffff87ff 	.word	0xffff87ff
 7ac:	fffff8ff 	.word	0xfffff8ff
 7b0:	a0000064 	.word	0xa0000064
 7b4:	00002710 	.word	0x00002710
 7b8:	fff1ffff 	.word	0xfff1ffff
 7bc:	fffeffff 	.word	0xfffeffff
 7c0:	ffbfffff 	.word	0xffbfffff
 7c4:	ffdfffff 	.word	0xffdfffff
 7c8:	00007530 	.word	0x00007530
 7cc:	00000bb8 	.word	0x00000bb8

Disassembly of section .text.get_timer_cnt:

000007d0 <get_timer_cnt>:

inline uint32_t get_timer_cnt() {
    return ((*REG_XOT_VAL_U & 0xFFFF) << 16) | (*REG_XOT_VAL_L & 0xFFFF);
 7d0:	4a03      	ldr	r2, [pc, #12]	; (7e0 <get_timer_cnt+0x10>)
 7d2:	4b04      	ldr	r3, [pc, #16]	; (7e4 <get_timer_cnt+0x14>)
 7d4:	681b      	ldr	r3, [r3, #0]
 7d6:	6810      	ldr	r0, [r2, #0]
 7d8:	041b      	lsls	r3, r3, #16
 7da:	b280      	uxth	r0, r0
 7dc:	4318      	orrs	r0, r3
}
 7de:	4770      	bx	lr
 7e0:	a0000054 	.word	0xa0000054
 7e4:	a0000058 	.word	0xa0000058

Disassembly of section .text.update_system_time:

000007e8 <update_system_time>:

void update_system_time() {
 7e8:	b538      	push	{r3, r4, r5, lr}
    uint32_t val = xo_sys_time;
 7ea:	4c0c      	ldr	r4, [pc, #48]	; (81c <update_system_time+0x34>)
 7ec:	6825      	ldr	r5, [r4, #0]
    xo_sys_time = get_timer_cnt();
 7ee:	f7ff ffef 	bl	7d0 <get_timer_cnt>
 7f2:	6020      	str	r0, [r4, #0]
    xo_sys_time_in_sec = xo_sys_time >> 15;
 7f4:	6822      	ldr	r2, [r4, #0]
 7f6:	4b0a      	ldr	r3, [pc, #40]	; (820 <update_system_time+0x38>)
 7f8:	0bd2      	lsrs	r2, r2, #15
 7fa:	601a      	str	r2, [r3, #0]
    xo_day_time_in_sec += (xo_sys_time - val) >> 15;
 7fc:	4b09      	ldr	r3, [pc, #36]	; (824 <update_system_time+0x3c>)
 7fe:	681a      	ldr	r2, [r3, #0]
 800:	6821      	ldr	r1, [r4, #0]
 802:	1b4d      	subs	r5, r1, r5
 804:	0bed      	lsrs	r5, r5, #15
 806:	18ad      	adds	r5, r5, r2
 808:	601d      	str	r5, [r3, #0]

    if(xo_day_time_in_sec >= 86400) {
 80a:	6819      	ldr	r1, [r3, #0]
 80c:	4a06      	ldr	r2, [pc, #24]	; (828 <update_system_time+0x40>)
 80e:	4291      	cmp	r1, r2
 810:	d903      	bls.n	81a <update_system_time+0x32>
        xo_day_time_in_sec -= 86400;
 812:	681a      	ldr	r2, [r3, #0]
 814:	4905      	ldr	r1, [pc, #20]	; (82c <update_system_time+0x44>)
 816:	1852      	adds	r2, r2, r1
 818:	601a      	str	r2, [r3, #0]
    }
}
 81a:	bd38      	pop	{r3, r4, r5, pc}
 81c:	00001bfc 	.word	0x00001bfc
 820:	00001c1c 	.word	0x00001c1c
 824:	00001c68 	.word	0x00001c68
 828:	0001517f 	.word	0x0001517f
 82c:	fffeae80 	.word	0xfffeae80

Disassembly of section .text.reset_timers_list:

00000830 <reset_timers_list>:
    return LNT_INTERVAL[lnt_cur_level];
}

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
 830:	b508      	push	{r3, lr}
    uint8_t i;
    update_system_time();
 832:	f7ff ffd9 	bl	7e8 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
 836:	4b03      	ldr	r3, [pc, #12]	; (844 <reset_timers_list+0x14>)
 838:	2200      	movs	r2, #0
 83a:	601a      	str	r2, [r3, #0]
 83c:	605a      	str	r2, [r3, #4]
 83e:	609a      	str	r2, [r3, #8]
    }
}
 840:	bd08      	pop	{r3, pc}
 842:	46c0      	nop			; (mov r8, r8)
 844:	00001c54 	.word	0x00001c54

Disassembly of section .text.set_next_time:

00000848 <set_next_time>:

static void set_next_time(uint8_t idx, uint16_t step) {
 848:	b538      	push	{r3, r4, r5, lr}
 84a:	1c05      	adds	r5, r0, #0
 84c:	1c0c      	adds	r4, r1, #0
    update_system_time();
 84e:	f7ff ffcb 	bl	7e8 <update_system_time>
    xot_timer_list[idx] = xot_last_timer_list[idx];
 852:	4b08      	ldr	r3, [pc, #32]	; (874 <set_next_time+0x2c>)
 854:	00a8      	lsls	r0, r5, #2
 856:	58c2      	ldr	r2, [r0, r3]
 858:	4b07      	ldr	r3, [pc, #28]	; (878 <set_next_time+0x30>)
    while(xo_sys_time_in_sec + 5 > xot_timer_list[idx]) {    // give some margin of error
 85a:	4d08      	ldr	r5, [pc, #32]	; (87c <set_next_time+0x34>)
    }
}

static void set_next_time(uint8_t idx, uint16_t step) {
    update_system_time();
    xot_timer_list[idx] = xot_last_timer_list[idx];
 85c:	50c2      	str	r2, [r0, r3]
    while(xo_sys_time_in_sec + 5 > xot_timer_list[idx]) {    // give some margin of error
 85e:	e002      	b.n	866 <set_next_time+0x1e>
        xot_timer_list[idx] += step;
 860:	58c2      	ldr	r2, [r0, r3]
 862:	18a2      	adds	r2, r4, r2
 864:	50c2      	str	r2, [r0, r3]
}

static void set_next_time(uint8_t idx, uint16_t step) {
    update_system_time();
    xot_timer_list[idx] = xot_last_timer_list[idx];
    while(xo_sys_time_in_sec + 5 > xot_timer_list[idx]) {    // give some margin of error
 866:	6829      	ldr	r1, [r5, #0]
 868:	58c2      	ldr	r2, [r0, r3]
 86a:	3105      	adds	r1, #5
 86c:	4291      	cmp	r1, r2
 86e:	d8f7      	bhi.n	860 <set_next_time+0x18>
        xot_timer_list[idx] += step;
    }
}
 870:	bd38      	pop	{r3, r4, r5, pc}
 872:	46c0      	nop			; (mov r8, r8)
 874:	00001be8 	.word	0x00001be8
 878:	00001c54 	.word	0x00001c54
 87c:	00001c1c 	.word	0x00001c1c

Disassembly of section .text.xo_check_is_day:

00000880 <xo_check_is_day>:
    if(xo_day_time_in_sec >= 86400) {
        xo_day_time_in_sec -= 86400;
    }
}

bool xo_check_is_day() {
 880:	b508      	push	{r3, lr}
    update_system_time();
 882:	f7ff ffb1 	bl	7e8 <update_system_time>
    return xo_day_time_in_sec >= XO_DAY_START && xo_day_time_in_sec < XO_DAY_END;
 886:	4a06      	ldr	r2, [pc, #24]	; (8a0 <xo_check_is_day+0x20>)
 888:	4906      	ldr	r1, [pc, #24]	; (8a4 <xo_check_is_day+0x24>)
 88a:	6810      	ldr	r0, [r2, #0]
 88c:	2300      	movs	r3, #0
 88e:	4288      	cmp	r0, r1
 890:	d903      	bls.n	89a <xo_check_is_day+0x1a>
 892:	6812      	ldr	r2, [r2, #0]
 894:	4904      	ldr	r1, [pc, #16]	; (8a8 <xo_check_is_day+0x28>)
 896:	4291      	cmp	r1, r2
 898:	415b      	adcs	r3, r3
 89a:	2001      	movs	r0, #1
 89c:	4018      	ands	r0, r3
}
 89e:	bd08      	pop	{r3, pc}
 8a0:	00001c68 	.word	0x00001c68
 8a4:	0000464f 	.word	0x0000464f
 8a8:	00010b2f 	.word	0x00010b2f

Disassembly of section .text.crcEnc16:

000008ac <crcEnc16>:

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 8ac:	4b1c      	ldr	r3, [pc, #112]	; (920 <crcEnc16+0x74>)

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
{
 8ae:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 8b0:	689a      	ldr	r2, [r3, #8]
 8b2:	685f      	ldr	r7, [r3, #4]
 8b4:	0412      	lsls	r2, r2, #16
 8b6:	0c3f      	lsrs	r7, r7, #16
 8b8:	18bf      	adds	r7, r7, r2
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 8ba:	685a      	ldr	r2, [r3, #4]
 8bc:	6819      	ldr	r1, [r3, #0]
 8be:	0412      	lsls	r2, r2, #16
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 8c0:	681c      	ldr	r4, [r3, #0]
    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 8c2:	0c09      	lsrs	r1, r1, #16
 8c4:	1889      	adds	r1, r1, r2
    // intialization
    uint32_t i;

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
 8c6:	2200      	movs	r2, #0
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 8c8:	468c      	mov	ip, r1
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 8ca:	0424      	lsls	r4, r4, #16

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 8cc:	1c13      	adds	r3, r2, #0
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 8ce:	b295      	uxth	r5, r2
 8d0:	b229      	sxth	r1, r5
            MSB = 0xffff;
        else
            MSB = 0x0000;
 8d2:	2000      	movs	r0, #0
    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 8d4:	4281      	cmp	r1, r0
 8d6:	da00      	bge.n	8da <crcEnc16+0x2e>
            MSB = 0xffff;
 8d8:	4812      	ldr	r0, [pc, #72]	; (924 <crcEnc16+0x78>)
        else
            MSB = 0x0000;

        if (i < 32)
 8da:	2b1f      	cmp	r3, #31
 8dc:	d803      	bhi.n	8e6 <crcEnc16+0x3a>
            input_bit = ((data2 << i) > 0x7fffffff);
 8de:	1c39      	adds	r1, r7, #0
 8e0:	4099      	lsls	r1, r3
 8e2:	0fc9      	lsrs	r1, r1, #31
 8e4:	e009      	b.n	8fa <crcEnc16+0x4e>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 8e6:	1c19      	adds	r1, r3, #0
        else
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
 8e8:	2b3f      	cmp	r3, #63	; 0x3f
 8ea:	d802      	bhi.n	8f2 <crcEnc16+0x46>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 8ec:	3920      	subs	r1, #32
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
 8ee:	4666      	mov	r6, ip
 8f0:	e001      	b.n	8f6 <crcEnc16+0x4a>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 8f2:	3940      	subs	r1, #64	; 0x40
        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;
 8f4:	1c26      	adds	r6, r4, #0
 8f6:	408e      	lsls	r6, r1
 8f8:	0ff1      	lsrs	r1, r6, #31

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 8fa:	0bed      	lsrs	r5, r5, #15
 8fc:	4069      	eors	r1, r5
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 8fe:	0052      	lsls	r2, r2, #1
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 900:	4d09      	ldr	r5, [pc, #36]	; (928 <crcEnc16+0x7c>)
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 902:	b292      	uxth	r2, r2
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 904:	4015      	ands	r5, r2
 906:	4042      	eors	r2, r0
 908:	4808      	ldr	r0, [pc, #32]	; (92c <crcEnc16+0x80>)
 90a:	1949      	adds	r1, r1, r5
 90c:	4002      	ands	r2, r0
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 90e:	3301      	adds	r3, #1
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 910:	430a      	orrs	r2, r1
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 912:	2b60      	cmp	r3, #96	; 0x60
 914:	d1db      	bne.n	8ce <crcEnc16+0x22>
        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
    }

    static uint32_t msg_out[1];
    msg_out[0] = data0 + remainder;
 916:	4806      	ldr	r0, [pc, #24]	; (930 <crcEnc16+0x84>)
 918:	1912      	adds	r2, r2, r4
 91a:	6002      	str	r2, [r0, #0]
    //radio_data_arr[0] = data2;
    //radio_data_arr[1] = data1;
    //radio_data_arr[2] = data0;

    return msg_out;    
}
 91c:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
 91e:	46c0      	nop			; (mov r8, r8)
 920:	00001c30 	.word	0x00001c30
 924:	0000ffff 	.word	0x0000ffff
 928:	00003ffd 	.word	0x00003ffd
 92c:	ffffc002 	.word	0xffffc002
 930:	00001c78 	.word	0x00001c78

Disassembly of section .text.mrr_send_radio_data:

00000934 <mrr_send_radio_data>:

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 934:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

#ifndef USE_RAD
    mbus_write_message32(0xAA, 0xAAAAAAAA);
 936:	4995      	ldr	r1, [pc, #596]	; (b8c <mrr_send_radio_data+0x258>)

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
 938:	9001      	str	r0, [sp, #4]
    // MRR REG_E: DATA[47:24]
    // MRR REG_F: DATA[71:48]
    // MRR REG_10: DATA[95:72]

#ifndef USE_RAD
    mbus_write_message32(0xAA, 0xAAAAAAAA);
 93a:	20aa      	movs	r0, #170	; 0xaa
 93c:	f7ff fc3a 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xAA, 0x00000000);
 940:	2100      	movs	r1, #0
 942:	20aa      	movs	r0, #170	; 0xaa
 944:	f7ff fc36 	bl	1b4 <mbus_write_message32>
    
    mbus_write_message32(0xE0, radio_data_arr[0]);
 948:	4c91      	ldr	r4, [pc, #580]	; (b90 <mrr_send_radio_data+0x25c>)
 94a:	20e0      	movs	r0, #224	; 0xe0
 94c:	6821      	ldr	r1, [r4, #0]
 94e:	f7ff fc31 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xE1, radio_data_arr[1]);
 952:	6861      	ldr	r1, [r4, #4]
 954:	20e1      	movs	r0, #225	; 0xe1
 956:	f7ff fc2d 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xE2, radio_data_arr[2]);
 95a:	68a1      	ldr	r1, [r4, #8]
 95c:	20e2      	movs	r0, #226	; 0xe2
 95e:	f7ff fc29 	bl	1b4 <mbus_write_message32>
    
    mbus_write_message32(0xAA, 0x00000000);
 962:	2100      	movs	r1, #0
 964:	20aa      	movs	r0, #170	; 0xaa
 966:	f7ff fc25 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xAA, 0xAAAAAAAA);
 96a:	4988      	ldr	r1, [pc, #544]	; (b8c <mrr_send_radio_data+0x258>)
 96c:	20aa      	movs	r0, #170	; 0xaa
 96e:	f7ff fc21 	bl	1b4 <mbus_write_message32>
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 972:	f7ff ff9b 	bl	8ac <crcEnc16>

#ifndef USE_RAD
    mbus_write_message32(0xBB, 0xBBBBBBBB);
 976:	4987      	ldr	r1, [pc, #540]	; (b94 <mrr_send_radio_data+0x260>)
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
 978:	9000      	str	r0, [sp, #0]

#ifndef USE_RAD
    mbus_write_message32(0xBB, 0xBBBBBBBB);
 97a:	20bb      	movs	r0, #187	; 0xbb
 97c:	f7ff fc1a 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xBB, 0x00000000);
 980:	2100      	movs	r1, #0
 982:	20bb      	movs	r0, #187	; 0xbb
 984:	f7ff fc16 	bl	1b4 <mbus_write_message32>
    
    mbus_write_message32(0xE0, radio_data_arr[0]);
 988:	6821      	ldr	r1, [r4, #0]
 98a:	20e0      	movs	r0, #224	; 0xe0
 98c:	f7ff fc12 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xE1, radio_data_arr[1]);
 990:	6861      	ldr	r1, [r4, #4]
 992:	20e1      	movs	r0, #225	; 0xe1
 994:	f7ff fc0e 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xE2, radio_data_arr[2]);
 998:	68a1      	ldr	r1, [r4, #8]
 99a:	20e2      	movs	r0, #226	; 0xe2
 99c:	f7ff fc0a 	bl	1b4 <mbus_write_message32>
    
    mbus_write_message32(0xBB, 0x00000000);
 9a0:	2100      	movs	r1, #0
 9a2:	20bb      	movs	r0, #187	; 0xbb
 9a4:	f7ff fc06 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xBB, 0xBBBBBBBB);
 9a8:	20bb      	movs	r0, #187	; 0xbb
 9aa:	497a      	ldr	r1, [pc, #488]	; (b94 <mrr_send_radio_data+0x260>)
 9ac:	f7ff fc02 	bl	1b4 <mbus_write_message32>
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
 9b0:	4b79      	ldr	r3, [pc, #484]	; (b98 <mrr_send_radio_data+0x264>)
 9b2:	781f      	ldrb	r7, [r3, #0]
 9b4:	2f00      	cmp	r7, #0
 9b6:	d000      	beq.n	9ba <mrr_send_radio_data+0x86>
 9b8:	e083      	b.n	ac2 <mrr_send_radio_data+0x18e>

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 9ba:	4d78      	ldr	r5, [pc, #480]	; (b9c <mrr_send_radio_data+0x268>)
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
        radio_on = 1;
 9bc:	2601      	movs	r6, #1
 9be:	701e      	strb	r6, [r3, #0]

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 9c0:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 9c2:	2002      	movs	r0, #2

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 9c4:	43b3      	bics	r3, r6
 9c6:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 9c8:	682a      	ldr	r2, [r5, #0]
 9ca:	1c39      	adds	r1, r7, #0
 9cc:	f7ff fc33 	bl	236 <mbus_remote_register_write>

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 9d0:	4c73      	ldr	r4, [pc, #460]	; (ba0 <mrr_send_radio_data+0x26c>)
 9d2:	4b74      	ldr	r3, [pc, #464]	; (ba4 <mrr_send_radio_data+0x270>)
 9d4:	6822      	ldr	r2, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 9d6:	2002      	movs	r0, #2
    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
 9d8:	4013      	ands	r3, r2
 9da:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 9dc:	6822      	ldr	r2, [r4, #0]
 9de:	2103      	movs	r1, #3
 9e0:	f7ff fc29 	bl	236 <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
 9e4:	6822      	ldr	r2, [r4, #0]
 9e6:	2380      	movs	r3, #128	; 0x80
 9e8:	031b      	lsls	r3, r3, #12
 9ea:	4313      	orrs	r3, r2
 9ec:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 9ee:	6822      	ldr	r2, [r4, #0]
 9f0:	2103      	movs	r1, #3
 9f2:	2002      	movs	r0, #2
 9f4:	f7ff fc1f 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
 9f8:	2064      	movs	r0, #100	; 0x64
 9fa:	f7ff fb54 	bl	a6 <delay>

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 9fe:	6822      	ldr	r2, [r4, #0]
 a00:	4b69      	ldr	r3, [pc, #420]	; (ba8 <mrr_send_radio_data+0x274>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 a02:	2002      	movs	r0, #2
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    delay(MBUS_DELAY);

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
 a04:	4013      	ands	r3, r2
 a06:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 a08:	6822      	ldr	r2, [r4, #0]
 a0a:	2103      	movs	r1, #3
 a0c:	f7ff fc13 	bl	236 <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
 a10:	6822      	ldr	r2, [r4, #0]
 a12:	2380      	movs	r3, #128	; 0x80
 a14:	02db      	lsls	r3, r3, #11
 a16:	4313      	orrs	r3, r2
 a18:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
 a1a:	6822      	ldr	r2, [r4, #0]
 a1c:	2103      	movs	r1, #3
 a1e:	2002      	movs	r0, #2
 a20:	f7ff fc09 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
 a24:	2064      	movs	r0, #100	; 0x64
 a26:	f7ff fb3e 	bl	a6 <delay>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 a2a:	682b      	ldr	r3, [r5, #0]
 a2c:	227e      	movs	r2, #126	; 0x7e
 a2e:	4393      	bics	r3, r2
 a30:	2420      	movs	r4, #32
 a32:	4323      	orrs	r3, r4
 a34:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a36:	682a      	ldr	r2, [r5, #0]
 a38:	2002      	movs	r0, #2
 a3a:	1c39      	adds	r1, r7, #0
 a3c:	f7ff fbfb 	bl	236 <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 a40:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a42:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 a44:	4333      	orrs	r3, r6
 a46:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 a48:	682a      	ldr	r2, [r5, #0]
 a4a:	1c39      	adds	r1, r7, #0
 a4c:	f7ff fbf3 	bl	236 <mbus_remote_register_write>

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 a50:	4d56      	ldr	r5, [pc, #344]	; (bac <mrr_send_radio_data+0x278>)
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 a52:	2104      	movs	r1, #4
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 a54:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 a56:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
 a58:	4333      	orrs	r3, r6
 a5a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 a5c:	682a      	ldr	r2, [r5, #0]
 a5e:	f7ff fbea 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
 a62:	2064      	movs	r0, #100	; 0x64
 a64:	f7ff fb1f 	bl	a6 <delay>

    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
 a68:	682b      	ldr	r3, [r5, #0]
 a6a:	2208      	movs	r2, #8
 a6c:	4393      	bics	r3, r2
 a6e:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 a70:	682a      	ldr	r2, [r5, #0]
 a72:	2104      	movs	r1, #4
 a74:	2002      	movs	r0, #2
 a76:	f7ff fbde 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
 a7a:	2064      	movs	r0, #100	; 0x64
 a7c:	f7ff fb13 	bl	a6 <delay>

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 a80:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 a82:	2104      	movs	r1, #4
    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
    delay(MBUS_DELAY);

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
 a84:	431c      	orrs	r4, r3
 a86:	602c      	str	r4, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 a88:	682a      	ldr	r2, [r5, #0]
 a8a:	2002      	movs	r0, #2
 a8c:	f7ff fbd3 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
 a90:	2064      	movs	r0, #100	; 0x64
 a92:	f7ff fb08 	bl	a6 <delay>

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
 a96:	682b      	ldr	r3, [r5, #0]
 a98:	2210      	movs	r2, #16
 a9a:	4393      	bics	r3, r2
 a9c:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 a9e:	682a      	ldr	r2, [r5, #0]
 aa0:	2002      	movs	r0, #2
 aa2:	2104      	movs	r1, #4
 aa4:	f7ff fbc7 	bl	236 <mbus_remote_register_write>

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 aa8:	4b41      	ldr	r3, [pc, #260]	; (bb0 <mrr_send_radio_data+0x27c>)
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 aaa:	2002      	movs	r0, #2

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 aac:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 aae:	2111      	movs	r1, #17

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
 ab0:	43b2      	bics	r2, r6
 ab2:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 ab4:	681a      	ldr	r2, [r3, #0]
 ab6:	f7ff fbbe 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*5); // Freq stab
 aba:	20fa      	movs	r0, #250	; 0xfa
 abc:	40b0      	lsls	r0, r6
 abe:	f7ff faf2 	bl	a6 <delay>
    if(!radio_on) {
        radio_on = 1;
	radio_power_on();
    }
    
    mbus_remote_register_write(MRR_ADDR,0xD, radio_data_arr[0] & 0xFFFFFF);
 ac2:	4c33      	ldr	r4, [pc, #204]	; (b90 <mrr_send_radio_data+0x25c>)
 ac4:	2002      	movs	r0, #2
 ac6:	6822      	ldr	r2, [r4, #0]
 ac8:	210d      	movs	r1, #13
 aca:	0212      	lsls	r2, r2, #8
 acc:	0a12      	lsrs	r2, r2, #8
 ace:	f7ff fbb2 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xE, (radio_data_arr[1] << 8) | (radio_data_arr[0] >> 24));
 ad2:	6863      	ldr	r3, [r4, #4]
 ad4:	6822      	ldr	r2, [r4, #0]
 ad6:	021b      	lsls	r3, r3, #8
 ad8:	0e12      	lsrs	r2, r2, #24
 ada:	431a      	orrs	r2, r3
 adc:	2002      	movs	r0, #2
 ade:	210e      	movs	r1, #14
 ae0:	f7ff fba9 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xF, (radio_data_arr[2] << 16 | radio_data_arr[1] >> 16));
 ae4:	68a3      	ldr	r3, [r4, #8]
 ae6:	6862      	ldr	r2, [r4, #4]
 ae8:	041b      	lsls	r3, r3, #16
 aea:	0c12      	lsrs	r2, r2, #16
 aec:	431a      	orrs	r2, r3
 aee:	2002      	movs	r0, #2
 af0:	210f      	movs	r1, #15
 af2:	f7ff fba0 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x10, ((crc_data[0] & 0xFFFF) << 8 | radio_data_arr[2] >> 8));
 af6:	9900      	ldr	r1, [sp, #0]
 af8:	68a3      	ldr	r3, [r4, #8]
 afa:	880a      	ldrh	r2, [r1, #0]
 afc:	0a1b      	lsrs	r3, r3, #8
 afe:	0212      	lsls	r2, r2, #8
 b00:	431a      	orrs	r2, r3
 b02:	2002      	movs	r0, #2
 b04:	2110      	movs	r1, #16
 b06:	f7ff fb96 	bl	236 <mbus_remote_register_write>

    if (!radio_ready){
 b0a:	4b2a      	ldr	r3, [pc, #168]	; (bb4 <mrr_send_radio_data+0x280>)
 b0c:	781d      	ldrb	r5, [r3, #0]
 b0e:	2d00      	cmp	r5, #0
 b10:	d127      	bne.n	b62 <mrr_send_radio_data+0x22e>
	radio_ready = 1;
 b12:	2201      	movs	r2, #1
 b14:	701a      	strb	r2, [r3, #0]

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 b16:	4b26      	ldr	r3, [pc, #152]	; (bb0 <mrr_send_radio_data+0x27c>)
 b18:	2402      	movs	r4, #2
 b1a:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 b1c:	2111      	movs	r1, #17

    if (!radio_ready){
	radio_ready = 1;

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
 b1e:	4322      	orrs	r2, r4
 b20:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 b22:	681a      	ldr	r2, [r3, #0]
 b24:	1c20      	adds	r0, r4, #0
 b26:	f7ff fb86 	bl	236 <mbus_remote_register_write>
	delay(MBUS_DELAY);
 b2a:	2064      	movs	r0, #100	; 0x64
 b2c:	f7ff fabb 	bl	a6 <delay>

	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
 b30:	4b1b      	ldr	r3, [pc, #108]	; (ba0 <mrr_send_radio_data+0x26c>)
 b32:	2280      	movs	r2, #128	; 0x80
 b34:	6819      	ldr	r1, [r3, #0]
 b36:	0352      	lsls	r2, r2, #13
 b38:	430a      	orrs	r2, r1
 b3a:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 b3c:	681a      	ldr	r2, [r3, #0]
 b3e:	2103      	movs	r1, #3
 b40:	1c20      	adds	r0, r4, #0
 b42:	f7ff fb78 	bl	236 <mbus_remote_register_write>
	delay(MBUS_DELAY);
 b46:	2064      	movs	r0, #100	; 0x64
 b48:	f7ff faad 	bl	a6 <delay>

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 b4c:	4b13      	ldr	r3, [pc, #76]	; (b9c <mrr_send_radio_data+0x268>)
 b4e:	217e      	movs	r1, #126	; 0x7e
 b50:	681a      	ldr	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 b52:	1c20      	adds	r0, r4, #0
	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
	delay(MBUS_DELAY);

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 b54:	438a      	bics	r2, r1
 b56:	4322      	orrs	r2, r4
 b58:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 b5a:	681a      	ldr	r2, [r3, #0]
 b5c:	1c29      	adds	r1, r5, #0
 b5e:	f7ff fb6a 	bl	236 <mbus_remote_register_write>
    }

    radio_packet_count++;
#endif

    if (last_packet){
 b62:	9b01      	ldr	r3, [sp, #4]
 b64:	2b00      	cmp	r3, #0
 b66:	d005      	beq.n	b74 <mrr_send_radio_data+0x240>
	radio_ready = 0;
 b68:	4b12      	ldr	r3, [pc, #72]	; (bb4 <mrr_send_radio_data+0x280>)
 b6a:	2200      	movs	r2, #0
 b6c:	701a      	strb	r2, [r3, #0]
	radio_power_off();
 b6e:	f7ff fc31 	bl	3d4 <radio_power_off>
 b72:	e009      	b.n	b88 <mrr_send_radio_data+0x254>
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 b74:	4b0e      	ldr	r3, [pc, #56]	; (bb0 <mrr_send_radio_data+0x27c>)
 b76:	2104      	movs	r1, #4
 b78:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 b7a:	2002      	movs	r0, #2

    if (last_packet){
	radio_ready = 0;
	radio_power_off();
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
 b7c:	438a      	bics	r2, r1
 b7e:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 b80:	681a      	ldr	r2, [r3, #0]
 b82:	2111      	movs	r1, #17
 b84:	f7ff fb57 	bl	236 <mbus_remote_register_write>
    }
}
 b88:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}
 b8a:	46c0      	nop			; (mov r8, r8)
 b8c:	aaaaaaaa 	.word	0xaaaaaaaa
 b90:	00001c30 	.word	0x00001c30
 b94:	bbbbbbbb 	.word	0xbbbbbbbb
 b98:	00001c70 	.word	0x00001c70
 b9c:	00001bbc 	.word	0x00001bbc
 ba0:	00001bc8 	.word	0x00001bc8
 ba4:	fffbffff 	.word	0xfffbffff
 ba8:	fff7ffff 	.word	0xfff7ffff
 bac:	00001bcc 	.word	0x00001bcc
 bb0:	00001bd0 	.word	0x00001bd0
 bb4:	00001bf6 	.word	0x00001bf6

Disassembly of section .text.set_goc_cmd:

00000bb8 <set_goc_cmd>:

/**********************************************
 * Interrupt handlers
 **********************************************/

void set_goc_cmd() {
 bb8:	b508      	push	{r3, lr}
    goc_component = (*GOC_DATA_IRQ >> 24) & 0xFF;
 bba:	238c      	movs	r3, #140	; 0x8c
 bbc:	6819      	ldr	r1, [r3, #0]
 bbe:	4a0c      	ldr	r2, [pc, #48]	; (bf0 <set_goc_cmd+0x38>)
 bc0:	0e09      	lsrs	r1, r1, #24
 bc2:	7011      	strb	r1, [r2, #0]
    goc_func_id = (*GOC_DATA_IRQ >> 16) & 0xFF;
 bc4:	6819      	ldr	r1, [r3, #0]
 bc6:	4a0b      	ldr	r2, [pc, #44]	; (bf4 <set_goc_cmd+0x3c>)
 bc8:	0c09      	lsrs	r1, r1, #16
 bca:	7011      	strb	r1, [r2, #0]
    goc_data = *GOC_DATA_IRQ & 0xFFFF;
 bcc:	681a      	ldr	r2, [r3, #0]
 bce:	4b0a      	ldr	r3, [pc, #40]	; (bf8 <set_goc_cmd+0x40>)
 bd0:	801a      	strh	r2, [r3, #0]
    goc_state = 0;
 bd2:	4b0a      	ldr	r3, [pc, #40]	; (bfc <set_goc_cmd+0x44>)
 bd4:	2200      	movs	r2, #0
 bd6:	701a      	strb	r2, [r3, #0]
    update_system_time();
 bd8:	f7ff fe06 	bl	7e8 <update_system_time>
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	xot_last_timer_list[i] = xo_sys_time_in_sec;
 bdc:	4a08      	ldr	r2, [pc, #32]	; (c00 <set_goc_cmd+0x48>)
 bde:	4b09      	ldr	r3, [pc, #36]	; (c04 <set_goc_cmd+0x4c>)
 be0:	6811      	ldr	r1, [r2, #0]
 be2:	6019      	str	r1, [r3, #0]
 be4:	6811      	ldr	r1, [r2, #0]
 be6:	6059      	str	r1, [r3, #4]
 be8:	6812      	ldr	r2, [r2, #0]
 bea:	609a      	str	r2, [r3, #8]
    }
}
 bec:	bd08      	pop	{r3, pc}
 bee:	46c0      	nop			; (mov r8, r8)
 bf0:	00001c12 	.word	0x00001c12
 bf4:	00001c20 	.word	0x00001c20
 bf8:	00001c24 	.word	0x00001c24
 bfc:	00001c50 	.word	0x00001c50
 c00:	00001c1c 	.word	0x00001c1c
 c04:	00001be8 	.word	0x00001be8

Disassembly of section .text.handler_ext_int_wakeup:

00000c08 <handler_ext_int_wakeup>:
void handler_ext_int_reg0       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg1       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP
 c08:	b570      	push	{r4, r5, r6, lr}
    update_system_time();
 c0a:	f7ff fded 	bl	7e8 <update_system_time>

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
 c0e:	4b17      	ldr	r3, [pc, #92]	; (c6c <handler_ext_int_wakeup+0x64>)

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
 c10:	4e17      	ldr	r6, [pc, #92]	; (c70 <handler_ext_int_wakeup+0x68>)
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP
    update_system_time();

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
 c12:	2501      	movs	r5, #1
 c14:	601d      	str	r5, [r3, #0]

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
 c16:	6831      	ldr	r1, [r6, #0]
 c18:	20ee      	movs	r0, #238	; 0xee
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
 c1a:	248c      	movs	r4, #140	; 0x8c
void handler_ext_int_wakeup( void ) { // WAKEUP
    update_system_time();

    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
 c1c:	f7ff faca 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
 c20:	6821      	ldr	r1, [r4, #0]
 c22:	20ee      	movs	r0, #238	; 0xee
 c24:	f7ff fac6 	bl	1b4 <mbus_write_message32>

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
 c28:	6833      	ldr	r3, [r6, #0]
 c2a:	422b      	tst	r3, r5
 c2c:	d008      	beq.n	c40 <handler_ext_int_wakeup+0x38>
        if(!(*GOC_DATA_IRQ)) {
 c2e:	6823      	ldr	r3, [r4, #0]
 c30:	2b00      	cmp	r3, #0
 c32:	d101      	bne.n	c38 <handler_ext_int_wakeup+0x30>
            operation_sleep(); // Need to protect against spurious wakeups
 c34:	f7ff fc36 	bl	4a4 <operation_sleep>
        }
        set_goc_cmd();
 c38:	f7ff ffbe 	bl	bb8 <set_goc_cmd>
        reset_timers_list();
 c3c:	f7ff fdf8 	bl	830 <reset_timers_list>
    }

    sntv4_r17.WUP_ENABLE = 0;
 c40:	4b0c      	ldr	r3, [pc, #48]	; (c74 <handler_ext_int_wakeup+0x6c>)
 c42:	4a0d      	ldr	r2, [pc, #52]	; (c78 <handler_ext_int_wakeup+0x70>)
 c44:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
 c46:	2004      	movs	r0, #4
        }
        set_goc_cmd();
        reset_timers_list();
    }

    sntv4_r17.WUP_ENABLE = 0;
 c48:	400a      	ands	r2, r1
 c4a:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
 c4c:	681a      	ldr	r2, [r3, #0]
 c4e:	2117      	movs	r1, #23
 c50:	f7ff faf1 	bl	236 <mbus_remote_register_write>

    mbus_write_message32(0xC0, xo_day_time_in_sec);
 c54:	4b09      	ldr	r3, [pc, #36]	; (c7c <handler_ext_int_wakeup+0x74>)
 c56:	20c0      	movs	r0, #192	; 0xc0
 c58:	6819      	ldr	r1, [r3, #0]
 c5a:	f7ff faab 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xC1, xo_sys_time_in_sec);
 c5e:	4b08      	ldr	r3, [pc, #32]	; (c80 <handler_ext_int_wakeup+0x78>)
 c60:	20c1      	movs	r0, #193	; 0xc1
 c62:	6819      	ldr	r1, [r3, #0]
 c64:	f7ff faa6 	bl	1b4 <mbus_write_message32>
}
 c68:	bd70      	pop	{r4, r5, r6, pc}
 c6a:	46c0      	nop			; (mov r8, r8)
 c6c:	e000e280 	.word	0xe000e280
 c70:	a000a008 	.word	0xa000a008
 c74:	00001bac 	.word	0x00001bac
 c78:	ff7fffff 	.word	0xff7fffff
 c7c:	00001c68 	.word	0x00001c68
 c80:	00001c1c 	.word	0x00001c1c

Disassembly of section .text.handler_ext_int_gocep:

00000c84 <handler_ext_int_gocep>:

void handler_ext_int_gocep( void ) { // GOCEP
 c84:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
 c86:	4b04      	ldr	r3, [pc, #16]	; (c98 <handler_ext_int_gocep+0x14>)
 c88:	2204      	movs	r2, #4
 c8a:	601a      	str	r2, [r3, #0]
    set_goc_cmd();
 c8c:	f7ff ff94 	bl	bb8 <set_goc_cmd>
    reset_timers_list();
 c90:	f7ff fdce 	bl	830 <reset_timers_list>
}
 c94:	bd08      	pop	{r3, pc}
 c96:	46c0      	nop			; (mov r8, r8)
 c98:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_timer32:

00000c9c <handler_ext_int_timer32>:

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
 c9c:	4b04      	ldr	r3, [pc, #16]	; (cb0 <handler_ext_int_timer32+0x14>)
 c9e:	2208      	movs	r2, #8
 ca0:	601a      	str	r2, [r3, #0]
    *TIMER32_STAT = 0x0;
 ca2:	4b04      	ldr	r3, [pc, #16]	; (cb4 <handler_ext_int_timer32+0x18>)
 ca4:	2200      	movs	r2, #0
 ca6:	601a      	str	r2, [r3, #0]
    
    wfi_timeout_flag = 1;
 ca8:	4b03      	ldr	r3, [pc, #12]	; (cb8 <handler_ext_int_timer32+0x1c>)
 caa:	2201      	movs	r2, #1
 cac:	701a      	strb	r2, [r3, #0]
}
 cae:	4770      	bx	lr
 cb0:	e000e280 	.word	0xe000e280
 cb4:	a0001110 	.word	0xa0001110
 cb8:	00001c6c 	.word	0x00001c6c

Disassembly of section .text.handler_ext_int_xot:

00000cbc <handler_ext_int_xot>:

void handler_ext_int_xot( void ) { // TIMER32
 cbc:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_XOT);
 cbe:	2280      	movs	r2, #128	; 0x80
 cc0:	4b02      	ldr	r3, [pc, #8]	; (ccc <handler_ext_int_xot+0x10>)
 cc2:	0312      	lsls	r2, r2, #12
 cc4:	601a      	str	r2, [r3, #0]
    update_system_time();
 cc6:	f7ff fd8f 	bl	7e8 <update_system_time>
}
 cca:	bd08      	pop	{r3, pc}
 ccc:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg0:

00000cd0 <handler_ext_int_reg0>:

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
 cd0:	4b02      	ldr	r3, [pc, #8]	; (cdc <handler_ext_int_reg0+0xc>)
 cd2:	2280      	movs	r2, #128	; 0x80
 cd4:	0052      	lsls	r2, r2, #1
 cd6:	601a      	str	r2, [r3, #0]
}
 cd8:	4770      	bx	lr
 cda:	46c0      	nop			; (mov r8, r8)
 cdc:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg1:

00000ce0 <handler_ext_int_reg1>:

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
 ce0:	4b02      	ldr	r3, [pc, #8]	; (cec <handler_ext_int_reg1+0xc>)
 ce2:	2280      	movs	r2, #128	; 0x80
 ce4:	0092      	lsls	r2, r2, #2
 ce6:	601a      	str	r2, [r3, #0]
}
 ce8:	4770      	bx	lr
 cea:	46c0      	nop			; (mov r8, r8)
 cec:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg2:

00000cf0 <handler_ext_int_reg2>:

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
 cf0:	4b02      	ldr	r3, [pc, #8]	; (cfc <handler_ext_int_reg2+0xc>)
 cf2:	2280      	movs	r2, #128	; 0x80
 cf4:	00d2      	lsls	r2, r2, #3
 cf6:	601a      	str	r2, [r3, #0]
}
 cf8:	4770      	bx	lr
 cfa:	46c0      	nop			; (mov r8, r8)
 cfc:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg3:

00000d00 <handler_ext_int_reg3>:

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
 d00:	4b02      	ldr	r3, [pc, #8]	; (d0c <handler_ext_int_reg3+0xc>)
 d02:	2280      	movs	r2, #128	; 0x80
 d04:	0112      	lsls	r2, r2, #4
 d06:	601a      	str	r2, [r3, #0]
}
 d08:	4770      	bx	lr
 d0a:	46c0      	nop			; (mov r8, r8)
 d0c:	e000e280 	.word	0xe000e280

Disassembly of section .text.startup.main:

00000d10 <main>:

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
     d10:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     d12:	4bfa      	ldr	r3, [pc, #1000]	; (10fc <main+0x3ec>)
     d14:	4afa      	ldr	r2, [pc, #1000]	; (1100 <main+0x3f0>)
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     d16:	4cfb      	ldr	r4, [pc, #1004]	; (1104 <main+0x3f4>)
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
     d18:	601a      	str	r2, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
     d1a:	6823      	ldr	r3, [r4, #0]
     d1c:	4dfa      	ldr	r5, [pc, #1000]	; (1108 <main+0x3f8>)
     d1e:	42ab      	cmp	r3, r5
     d20:	d100      	bne.n	d24 <main+0x14>
     d22:	e342      	b.n	13aa <main+0x69a>
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);
     d24:	2101      	movs	r1, #1
     d26:	20ba      	movs	r0, #186	; 0xba
     d28:	f7ff fa44 	bl	1b4 <mbus_write_message32>

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
     d2c:	4bf7      	ldr	r3, [pc, #988]	; (110c <main+0x3fc>)
     d2e:	2700      	movs	r7, #0
     d30:	601f      	str	r7, [r3, #0]
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     d32:	4bf7      	ldr	r3, [pc, #988]	; (1110 <main+0x400>)
    config_timer32(0, 0, 0, 0);
     d34:	1c39      	adds	r1, r7, #0
     d36:	1c3a      	adds	r2, r7, #0
static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     d38:	601f      	str	r7, [r3, #0]
    config_timer32(0, 0, 0, 0);
     d3a:	1c38      	adds	r0, r7, #0
     d3c:	1c3b      	adds	r3, r7, #0
     d3e:	f7ff f9bd 	bl	bc <config_timer32>

    // Enumeration
    enumerated = ENUMID;

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     d42:	2006      	movs	r0, #6
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    config_timer32(0, 0, 0, 0);

    // Enumeration
    enumerated = ENUMID;
     d44:	6025      	str	r5, [r4, #0]

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
     d46:	f7ff fa55 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     d4a:	2064      	movs	r0, #100	; 0x64
     d4c:	f7ff f9ab 	bl	a6 <delay>
#endif
#ifdef USE_MRR
    mbus_enumerate(MRR_ADDR);
     d50:	2002      	movs	r0, #2
     d52:	f7ff fa4f 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     d56:	2064      	movs	r0, #100	; 0x64
     d58:	f7ff f9a5 	bl	a6 <delay>
#endif
#ifdef USE_LNT
    mbus_enumerate(LNT_ADDR);
     d5c:	2003      	movs	r0, #3
     d5e:	f7ff fa49 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     d62:	2064      	movs	r0, #100	; 0x64
     d64:	f7ff f99f 	bl	a6 <delay>
#endif
#ifdef USE_SNT
    mbus_enumerate(SNT_ADDR);
     d68:	2004      	movs	r0, #4
     d6a:	f7ff fa43 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     d6e:	2064      	movs	r0, #100	; 0x64
     d70:	f7ff f999 	bl	a6 <delay>
#endif
#ifdef USE_PMU
    mbus_enumerate(PMU_ADDR);
     d74:	2005      	movs	r0, #5
     d76:	f7ff fa3d 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
     d7a:	2064      	movs	r0, #100	; 0x64
     d7c:	f7ff f993 	bl	a6 <delay>
#endif

    // Default CPU halt function
    set_halt_until_mbus_tx();
     d80:	f7ff fa0c 	bl	19c <set_halt_until_mbus_tx>

    // Global variables
    wfi_timeout_flag = 0;
     d84:	4be3      	ldr	r3, [pc, #908]	; (1114 <main+0x404>)

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
    xo_day_time_in_sec = 0;

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     d86:	2219      	movs	r2, #25

    // Default CPU halt function
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;
     d88:	701f      	strb	r7, [r3, #0]

    xo_sys_time = 0;
     d8a:	4be3      	ldr	r3, [pc, #908]	; (1118 <main+0x408>)
    // MRR_SIGNAL_PERIOD = 300;
    // MRR_DATA_PERIOD = 18000;
    // MRR_TEMP_THRESH = 5;    // FIXME: use code
    // MRR_VOLT_THRESH = 0x4B;

    pmu_sar_ratio_radio = 0x36;
     d8c:	4de3      	ldr	r5, [pc, #908]	; (111c <main+0x40c>)
    set_halt_until_mbus_tx();

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
     d8e:	601f      	str	r7, [r3, #0]
    xo_sys_time_in_sec = 0;
     d90:	4be3      	ldr	r3, [pc, #908]	; (1120 <main+0x410>)
    // MRR_SIGNAL_PERIOD = 300;
    // MRR_DATA_PERIOD = 18000;
    // MRR_TEMP_THRESH = 5;    // FIXME: use code
    // MRR_VOLT_THRESH = 0x4B;

    pmu_sar_ratio_radio = 0x36;
     d92:	2436      	movs	r4, #54	; 0x36

    // Global variables
    wfi_timeout_flag = 0;

    xo_sys_time = 0;
    xo_sys_time_in_sec = 0;
     d94:	601f      	str	r7, [r3, #0]
    xo_day_time_in_sec = 0;
     d96:	4be3      	ldr	r3, [pc, #908]	; (1124 <main+0x414>)
     d98:	601f      	str	r7, [r3, #0]

    snt_sys_temp_code = 25; 	// FIXME: use code for this
     d9a:	4be3      	ldr	r3, [pc, #908]	; (1128 <main+0x418>)
     d9c:	601a      	str	r2, [r3, #0]
    snt_state = SNT_IDLE;
     d9e:	4be3      	ldr	r3, [pc, #908]	; (112c <main+0x41c>)
     da0:	701f      	strb	r7, [r3, #0]
    // LNT_INTERVAL[0] = 60;
    // LNT_INTERVAL[1] = 300;
    // LNT_INTERVAL[2] = 600;
    // LNT_INTERVAL[3] = 1800;

    lnt_cur_level = 0;
     da2:	4be3      	ldr	r3, [pc, #908]	; (1130 <main+0x420>)
     da4:	701f      	strb	r7, [r3, #0]
    // MRR_SIGNAL_PERIOD = 300;
    // MRR_DATA_PERIOD = 18000;
    // MRR_TEMP_THRESH = 5;    // FIXME: use code
    // MRR_VOLT_THRESH = 0x4B;

    pmu_sar_ratio_radio = 0x36;
     da6:	702c      	strb	r4, [r5, #0]
    // PMU_SLEEP_SETTINGS[5] = 0x02000101;
    // PMU_SLEEP_SETTINGS[6] = 0x01010101;
    // PMU_SLEEP_SETTINGS[7] = 0x01010101;

    // Initialization
    xo_init();
     da8:	f7ff fc50 	bl	64c <xo_init>

    // BREAKPOINT 0x02
    mbus_write_message32(0xBA, 0x02);
     dac:	2102      	movs	r1, #2
     dae:	20ba      	movs	r0, #186	; 0xba
     db0:	f7ff fa00 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);
     db4:	49df      	ldr	r1, [pc, #892]	; (1134 <main+0x424>)
     db6:	20ed      	movs	r0, #237	; 0xed
     db8:	f7ff f9fc 	bl	1b4 <mbus_write_message32>
    }
    delay(MBUS_DELAY);
}

inline static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
     dbc:	1c38      	adds	r0, r7, #0
     dbe:	f7ff fabd 	bl	33c <pmu_setting_temp_based>
    // Use the new reset scheme in PMUv3
    pmu_set_sar_conversion_ratio(pmu_sar_ratio_radio);
     dc2:	782b      	ldrb	r3, [r5, #0]
                     (0 << 12) |    // let vdd_clk always connect to vbat
                     (1 << 11) |    // enable override setting [10] (1'h0)
                     (0 << 10) |    // have the converter have the periodic reset (1'h0)
                     (1 <<  9) |    // enable override setting [8:0] (1'h0)
                     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
                     (1 <<  7) |    // enable override setting [6:0] (1'h0)
     dc4:	25aa      	movs	r5, #170	; 0xaa
     dc6:	01ad      	lsls	r5, r5, #6
     dc8:	431d      	orrs	r5, r3
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
    int i;
    for(i = 0; i < 2; i++) {
        pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
     dca:	1c29      	adds	r1, r5, #0
     dcc:	2005      	movs	r0, #5
     dce:	f7ff fa77 	bl	2c0 <pmu_reg_write>
     dd2:	1c29      	adds	r1, r5, #0
     dd4:	2005      	movs	r0, #5
     dd6:	f7ff fa73 	bl	2c0 <pmu_reg_write>
    set_halt_until_mbus_tx();
}

static void pmu_set_adc_period(uint32_t val) {
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
     dda:	203c      	movs	r0, #60	; 0x3c
     ddc:	49d6      	ldr	r1, [pc, #856]	; (1138 <main+0x428>)
     dde:	f7ff fa6f 	bl	2c0 <pmu_reg_write>
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon

    // Register 0x36: PMU_EN_TICK_REPEAT_VBAT_ADJUST
    pmu_reg_write(0x36, val);
     de2:	1c20      	adds	r0, r4, #0
     de4:	2101      	movs	r1, #1
     de6:	f7ff fa6b 	bl	2c0 <pmu_reg_write>

    // Register 0x33: PMU_EN_TICK_ADC_RESET
    pmu_reg_write(0x33, 2);
     dea:	2033      	movs	r0, #51	; 0x33
     dec:	2102      	movs	r1, #2
     dee:	f7ff fa67 	bl	2c0 <pmu_reg_write>

    // Register 0x34: PMU_ENTICK_ADC_CLK
    pmu_reg_write(0x34, 2);
     df2:	2034      	movs	r0, #52	; 0x34
     df4:	2102      	movs	r1, #2
     df6:	f7ff fa63 	bl	2c0 <pmu_reg_write>

    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
     dfa:	203c      	movs	r0, #60	; 0x3c
     dfc:	49ce      	ldr	r1, [pc, #824]	; (1138 <main+0x428>)
     dfe:	f7ff fa5f 	bl	2c0 <pmu_reg_write>
    }
}

inline static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
     e02:	2186      	movs	r1, #134	; 0x86
     e04:	200e      	movs	r0, #14
     e06:	00c9      	lsls	r1, r1, #3
     e08:	f7ff fa5a 	bl	2c0 <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
     e0c:	2045      	movs	r0, #69	; 0x45
     e0e:	2148      	movs	r1, #72	; 0x48
     e10:	f7ff fa56 	bl	2c0 <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
     e14:	203a      	movs	r0, #58	; 0x3a
     e16:	49c9      	ldr	r1, [pc, #804]	; (113c <main+0x42c>)
     e18:	f7ff fa52 	bl	2c0 <pmu_reg_write>
}

inline static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
     e1c:	203c      	movs	r0, #60	; 0x3c
     e1e:	49c8      	ldr	r1, [pc, #800]	; (1140 <main+0x430>)
     e20:	f7ff fa4e 	bl	2c0 <pmu_reg_write>
#ifdef USE_PMU
    pmu_init();
#endif

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     e24:	4bc7      	ldr	r3, [pc, #796]	; (1144 <main+0x434>)
     e26:	2540      	movs	r5, #64	; 0x40
     e28:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
     e2a:	2080      	movs	r0, #128	; 0x80
#ifdef USE_PMU
    pmu_init();
#endif

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
     e2c:	43aa      	bics	r2, r5
     e2e:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
     e30:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     e32:	2101      	movs	r1, #1
    pmu_init();
#endif

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
     e34:	4382      	bics	r2, r0
     e36:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
     e38:	681a      	ldr	r2, [r3, #0]
     e3a:	2004      	movs	r0, #4
     e3c:	f7ff f9fb 	bl	236 <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
     e40:	4bc1      	ldr	r3, [pc, #772]	; (1148 <main+0x438>)
     e42:	21ff      	movs	r1, #255	; 0xff
     e44:	881a      	ldrh	r2, [r3, #0]
     e46:	2080      	movs	r0, #128	; 0x80
     e48:	400a      	ands	r2, r1
     e4a:	0140      	lsls	r0, r0, #5
     e4c:	4302      	orrs	r2, r0
     e4e:	801a      	strh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     e50:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     e52:	2004      	movs	r0, #4
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
     e54:	438a      	bics	r2, r1
     e56:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
     e58:	681a      	ldr	r2, [r3, #0]
     e5a:	2107      	movs	r1, #7
     e5c:	f7ff f9eb 	bl	236 <mbus_remote_register_write>

    // snt_clk_init();
    operation_temp_run();
     e60:	f7ff fb44 	bl	4ec <operation_temp_run>

inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
     e64:	4bb9      	ldr	r3, [pc, #740]	; (114c <main+0x43c>)
     e66:	48ba      	ldr	r0, [pc, #744]	; (1150 <main+0x440>)
     e68:	681a      	ldr	r2, [r3, #0]
     e6a:	2180      	movs	r1, #128	; 0x80
     e6c:	4002      	ands	r2, r0
     e6e:	0389      	lsls	r1, r1, #14
     e70:	430a      	orrs	r2, r1
     e72:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     e74:	6819      	ldr	r1, [r3, #0]
     e76:	4ab7      	ldr	r2, [pc, #732]	; (1154 <main+0x444>)
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e78:	2003      	movs	r0, #3
inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     e7a:	400a      	ands	r2, r1
     e7c:	49b6      	ldr	r1, [pc, #728]	; (1158 <main+0x448>)
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     e7e:	2402      	movs	r4, #2
inline static void lnt_init() {
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
     e80:	430a      	orrs	r2, r1
     e82:	601a      	str	r2, [r3, #0]
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     e84:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e86:	2122      	movs	r1, #34	; 0x22
    //////// TIMER OPERATION //////////
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
     e88:	432a      	orrs	r2, r5
     e8a:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
     e8c:	681a      	ldr	r2, [r3, #0]
     e8e:	f7ff f9d2 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     e92:	20fa      	movs	r0, #250	; 0xfa
     e94:	0080      	lsls	r0, r0, #2
     e96:	f7ff f906 	bl	a6 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     e9a:	4eb0      	ldr	r6, [pc, #704]	; (115c <main+0x44c>)
     e9c:	4bb0      	ldr	r3, [pc, #704]	; (1160 <main+0x450>)
     e9e:	6832      	ldr	r2, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ea0:	2121      	movs	r1, #33	; 0x21
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
     ea2:	4013      	ands	r3, r2
     ea4:	2280      	movs	r2, #128	; 0x80
     ea6:	0212      	lsls	r2, r2, #8
     ea8:	4313      	orrs	r3, r2
     eaa:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
     eac:	6833      	ldr	r3, [r6, #0]
     eae:	22fc      	movs	r2, #252	; 0xfc
     eb0:	4313      	orrs	r3, r2
     eb2:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     eb4:	6833      	ldr	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     eb6:	2201      	movs	r2, #1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
     eb8:	4323      	orrs	r3, r4
     eba:	6033      	str	r3, [r6, #0]
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     ebc:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ebe:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
     ec0:	4313      	orrs	r3, r2
     ec2:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ec4:	6832      	ldr	r2, [r6, #0]
     ec6:	f7ff f9b6 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     eca:	20fa      	movs	r0, #250	; 0xfa
     ecc:	40a0      	lsls	r0, r4
     ece:	f7ff f8ea 	bl	a6 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     ed2:	4ba4      	ldr	r3, [pc, #656]	; (1164 <main+0x454>)
     ed4:	48a4      	ldr	r0, [pc, #656]	; (1168 <main+0x458>)
     ed6:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     ed8:	1c29      	adds	r1, r5, #0
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
     eda:	4002      	ands	r2, r0
     edc:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
     ede:	681a      	ldr	r2, [r3, #0]
     ee0:	2003      	movs	r0, #3
     ee2:	f7ff f9a8 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     ee6:	20fa      	movs	r0, #250	; 0xfa
     ee8:	40a0      	lsls	r0, r4
     eea:	f7ff f8dc 	bl	a6 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     eee:	6832      	ldr	r2, [r6, #0]
     ef0:	4b9e      	ldr	r3, [pc, #632]	; (116c <main+0x45c>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ef2:	2121      	movs	r1, #33	; 0x21
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
     ef4:	4013      	ands	r3, r2
     ef6:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     ef8:	6832      	ldr	r2, [r6, #0]
     efa:	2003      	movs	r0, #3
     efc:	f7ff f99b 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f00:	20fa      	movs	r0, #250	; 0xfa
     f02:	40a0      	lsls	r0, r4
     f04:	f7ff f8cf 	bl	a6 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     f08:	4d99      	ldr	r5, [pc, #612]	; (1170 <main+0x460>)
     f0a:	2108      	movs	r1, #8
     f0c:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f0e:	2003      	movs	r0, #3
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    delay(MBUS_DELAY*10);
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
     f10:	430b      	orrs	r3, r1
     f12:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f14:	682a      	ldr	r2, [r5, #0]
     f16:	2120      	movs	r1, #32
     f18:	f7ff f98d 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     f1c:	20fa      	movs	r0, #250	; 0xfa
     f1e:	40a0      	lsls	r0, r4
     f20:	f7ff f8c1 	bl	a6 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
     f24:	782b      	ldrb	r3, [r5, #0]
     f26:	2210      	movs	r2, #16
     f28:	4313      	orrs	r3, r2
     f2a:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
     f2c:	782b      	ldrb	r3, [r5, #0]
     f2e:	2004      	movs	r0, #4
     f30:	4303      	orrs	r3, r0
     f32:	702b      	strb	r3, [r5, #0]
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     f34:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f36:	2120      	movs	r1, #32
    delay(MBUS_DELAY*10);
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
     f38:	4323      	orrs	r3, r4
     f3a:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f3c:	682a      	ldr	r2, [r5, #0]
     f3e:	2003      	movs	r0, #3
     f40:	f7ff f979 	bl	236 <mbus_remote_register_write>
    delay(2000); 
     f44:	20fa      	movs	r0, #250	; 0xfa
     f46:	00c0      	lsls	r0, r0, #3
     f48:	f7ff f8ad 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
     f4c:	782b      	ldrb	r3, [r5, #0]
     f4e:	2101      	movs	r1, #1
     f50:	430b      	orrs	r3, r1
     f52:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f54:	682a      	ldr	r2, [r5, #0]
     f56:	2120      	movs	r1, #32
     f58:	2003      	movs	r0, #3
     f5a:	f7ff f96c 	bl	236 <mbus_remote_register_write>
    delay(10); 
     f5e:	200a      	movs	r0, #10
     f60:	f7ff f8a1 	bl	a6 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
     f64:	6833      	ldr	r3, [r6, #0]
     f66:	2280      	movs	r2, #128	; 0x80
     f68:	0392      	lsls	r2, r2, #14
     f6a:	4313      	orrs	r3, r2
     f6c:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
     f6e:	6832      	ldr	r2, [r6, #0]
     f70:	2121      	movs	r1, #33	; 0x21
     f72:	2003      	movs	r0, #3
     f74:	f7ff f95f 	bl	236 <mbus_remote_register_write>
    delay(100000); 
     f78:	487e      	ldr	r0, [pc, #504]	; (1174 <main+0x464>)
     f7a:	f7ff f894 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
     f7e:	782b      	ldrb	r3, [r5, #0]
     f80:	2008      	movs	r0, #8
     f82:	4383      	bics	r3, r0
     f84:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
     f86:	682a      	ldr	r2, [r5, #0]
     f88:	2120      	movs	r1, #32
     f8a:	2003      	movs	r0, #3
     f8c:	f7ff f953 	bl	236 <mbus_remote_register_write>
    delay(100);
     f90:	2064      	movs	r0, #100	; 0x64
     f92:	f7ff f888 	bl	a6 <delay>
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f96:	4b78      	ldr	r3, [pc, #480]	; (1178 <main+0x468>)
     f98:	2101      	movs	r1, #1
     f9a:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
     f9c:	201e      	movs	r0, #30
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
     f9e:	430a      	orrs	r2, r1
     fa0:	701a      	strb	r2, [r3, #0]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
     fa2:	781a      	ldrb	r2, [r3, #0]
     fa4:	2110      	movs	r1, #16
     fa6:	4382      	bics	r2, r0
     fa8:	430a      	orrs	r2, r1
     faa:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
     fac:	681a      	ldr	r2, [r3, #0]
     fae:	2117      	movs	r1, #23
     fb0:	2003      	movs	r0, #3
     fb2:	f7ff f940 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     fb6:	20fa      	movs	r0, #250	; 0xfa
     fb8:	40a0      	lsls	r0, r4
     fba:	f7ff f874 	bl	a6 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     fbe:	4b6f      	ldr	r3, [pc, #444]	; (117c <main+0x46c>)
     fc0:	21f0      	movs	r1, #240	; 0xf0
     fc2:	881a      	ldrh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     fc4:	2003      	movs	r0, #3
    delay(MBUS_DELAY*10);
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
     fc6:	438a      	bics	r2, r1
     fc8:	2170      	movs	r1, #112	; 0x70
     fca:	430a      	orrs	r2, r1
     fcc:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
     fce:	881a      	ldrh	r2, [r3, #0]
     fd0:	210f      	movs	r1, #15
     fd2:	438a      	bics	r2, r1
     fd4:	4322      	orrs	r2, r4
     fd6:	801a      	strh	r2, [r3, #0]
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
     fd8:	8819      	ldrh	r1, [r3, #0]
     fda:	2280      	movs	r2, #128	; 0x80
     fdc:	0052      	lsls	r2, r2, #1
     fde:	430a      	orrs	r2, r1
     fe0:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
     fe2:	681a      	ldr	r2, [r3, #0]
     fe4:	2101      	movs	r1, #1
     fe6:	f7ff f926 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
     fea:	20fa      	movs	r0, #250	; 0xfa
     fec:	40a0      	lsls	r0, r4
     fee:	f7ff f85a 	bl	a6 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
     ff2:	4b63      	ldr	r3, [pc, #396]	; (1180 <main+0x470>)
     ff4:	4a63      	ldr	r2, [pc, #396]	; (1184 <main+0x474>)
     ff6:	6819      	ldr	r1, [r3, #0]
     ff8:	2080      	movs	r0, #128	; 0x80
     ffa:	400a      	ands	r2, r1
     ffc:	4302      	orrs	r2, r0
     ffe:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    1000:	681a      	ldr	r2, [r3, #0]
    1002:	1c21      	adds	r1, r4, #0
    1004:	2003      	movs	r0, #3
    1006:	f7ff f916 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    100a:	20fa      	movs	r0, #250	; 0xfa
    100c:	40a0      	lsls	r0, r4
    100e:	f7ff f84a 	bl	a6 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    1012:	4b5d      	ldr	r3, [pc, #372]	; (1188 <main+0x478>)
    1014:	4a5d      	ldr	r2, [pc, #372]	; (118c <main+0x47c>)
    1016:	6819      	ldr	r1, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    1018:	2003      	movs	r0, #3
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    delay(MBUS_DELAY*10);
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    101a:	400a      	ands	r2, r1
    101c:	21c0      	movs	r1, #192	; 0xc0
    101e:	0289      	lsls	r1, r1, #10
    1020:	430a      	orrs	r2, r1
    1022:	601a      	str	r2, [r3, #0]
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    1024:	681a      	ldr	r2, [r3, #0]
    1026:	2110      	movs	r1, #16
    1028:	0b12      	lsrs	r2, r2, #12
    102a:	0312      	lsls	r2, r2, #12
    102c:	430a      	orrs	r2, r1
    102e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    1030:	681a      	ldr	r2, [r3, #0]
    1032:	2105      	movs	r1, #5
    1034:	f7ff f8ff 	bl	236 <mbus_remote_register_write>
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    1038:	4b55      	ldr	r3, [pc, #340]	; (1190 <main+0x480>)
    103a:	2001      	movs	r0, #1
    103c:	781a      	ldrb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    103e:	2106      	movs	r1, #6
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    1040:	4382      	bics	r2, r0
    1042:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    1044:	681a      	ldr	r2, [r3, #0]
    1046:	2003      	movs	r0, #3
    1048:	f7ff f8f5 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    104c:	20fa      	movs	r0, #250	; 0xfa
    104e:	40a0      	lsls	r0, r4
    1050:	f7ff f829 	bl	a6 <delay>
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    1054:	4b4f      	ldr	r3, [pc, #316]	; (1194 <main+0x484>)
    1056:	4950      	ldr	r1, [pc, #320]	; (1198 <main+0x488>)
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
    1064:	f7ff f8e7 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1068:	20fa      	movs	r0, #250	; 0xfa
    106a:	40a0      	lsls	r0, r4
    106c:	f7ff f81b 	bl	a6 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    1070:	4b4a      	ldr	r3, [pc, #296]	; (119c <main+0x48c>)
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
    1084:	f7ff f8d7 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1088:	20fa      	movs	r0, #250	; 0xfa
    108a:	40a0      	lsls	r0, r4
    108c:	f7ff f80b 	bl	a6 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    1090:	4d43      	ldr	r5, [pc, #268]	; (11a0 <main+0x490>)
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
    10a0:	f7ff f8c9 	bl	236 <mbus_remote_register_write>
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
    10b8:	f7ff f8bd 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    10bc:	20fa      	movs	r0, #250	; 0xfa
    10be:	40a0      	lsls	r0, r4
    10c0:	f7fe fff1 	bl	a6 <delay>

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    10c4:	4d37      	ldr	r5, [pc, #220]	; (11a4 <main+0x494>)
    10c6:	4828      	ldr	r0, [pc, #160]	; (1168 <main+0x458>)
    10c8:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    10ca:	2103      	movs	r1, #3

static inline void mrr_init() {
    // MRR Settings --------------------------------------

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    10cc:	4003      	ands	r3, r0
    10ce:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    10d0:	682a      	ldr	r2, [r5, #0]
    10d2:	1c20      	adds	r0, r4, #0
    10d4:	f7ff f8af 	bl	236 <mbus_remote_register_write>
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
    10e8:	f7ff f8a5 	bl	236 <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    10ec:	4e2e      	ldr	r6, [pc, #184]	; (11a8 <main+0x498>)
    10ee:	227e      	movs	r2, #126	; 0x7e
    10f0:	6833      	ldr	r3, [r6, #0]
    10f2:	2110      	movs	r1, #16
    10f4:	4393      	bics	r3, r2
    10f6:	430b      	orrs	r3, r1
    10f8:	e058      	b.n	11ac <main+0x49c>
    10fa:	46c0      	nop			; (mov r8, r8)
    10fc:	e000e100 	.word	0xe000e100
    1100:	00080f0d 	.word	0x00080f0d
    1104:	00001c14 	.word	0x00001c14
    1108:	deadbeef 	.word	0xdeadbeef
    110c:	a0001200 	.word	0xa0001200
    1110:	a000007c 	.word	0xa000007c
    1114:	00001c6c 	.word	0x00001c6c
    1118:	00001bfc 	.word	0x00001bfc
    111c:	00001c22 	.word	0x00001c22
    1120:	00001c1c 	.word	0x00001c1c
    1124:	00001c68 	.word	0x00001c68
    1128:	00001c2c 	.word	0x00001c2c
    112c:	00001c18 	.word	0x00001c18
    1130:	00001c04 	.word	0x00001c04
    1134:	0d021004 	.word	0x0d021004
    1138:	0017c7fd 	.word	0x0017c7fd
    113c:	00103800 	.word	0x00103800
    1140:	0017c7ff 	.word	0x0017c7ff
    1144:	00001b94 	.word	0x00001b94
    1148:	00001b9c 	.word	0x00001b9c
    114c:	00001ba4 	.word	0x00001ba4
    1150:	ff1fffff 	.word	0xff1fffff
    1154:	ffe0007f 	.word	0xffe0007f
    1158:	001ffe80 	.word	0x001ffe80
    115c:	00001ba0 	.word	0x00001ba0
    1160:	ffff00ff 	.word	0xffff00ff
    1164:	00001ba8 	.word	0x00001ba8
    1168:	fff7ffff 	.word	0xfff7ffff
    116c:	ffdfffff 	.word	0xffdfffff
    1170:	00001c7c 	.word	0x00001c7c
    1174:	000186a0 	.word	0x000186a0
    1178:	00001c80 	.word	0x00001c80
    117c:	00001b84 	.word	0x00001b84
    1180:	00001b88 	.word	0x00001b88
    1184:	fffffe7f 	.word	0xfffffe7f
    1188:	00001bb8 	.word	0x00001bb8
    118c:	ff000fff 	.word	0xff000fff
    1190:	00001c74 	.word	0x00001c74
    1194:	00001bb0 	.word	0x00001bb0
    1198:	00ffffff 	.word	0x00ffffff
    119c:	00001bb4 	.word	0x00001bb4
    11a0:	00001b80 	.word	0x00001b80
    11a4:	00001bc8 	.word	0x00001bc8
    11a8:	00001bbc 	.word	0x00001bbc
    11ac:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    11ae:	6832      	ldr	r2, [r6, #0]
    11b0:	1c20      	adds	r0, r4, #0
    11b2:	1c39      	adds	r1, r7, #0
    11b4:	f7ff f83f 	bl	236 <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    11b8:	6833      	ldr	r3, [r6, #0]
    11ba:	2201      	movs	r2, #1
    11bc:	4313      	orrs	r3, r2
    11be:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    11c0:	6832      	ldr	r2, [r6, #0]
    11c2:	1c39      	adds	r1, r7, #0
    11c4:	1c20      	adds	r0, r4, #0
    11c6:	f7ff f836 	bl	236 <mbus_remote_register_write>

    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    11ca:	48e7      	ldr	r0, [pc, #924]	; (1568 <main+0x858>)
    11cc:	f7fe ff6b 	bl	a6 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    11d0:	4be6      	ldr	r3, [pc, #920]	; (156c <main+0x85c>)
    11d2:	2003      	movs	r0, #3
    11d4:	781a      	ldrb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    11d6:	210c      	movs	r1, #12
    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    11d8:	4302      	orrs	r2, r0
    11da:	701a      	strb	r2, [r3, #0]
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    11dc:	781a      	ldrb	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    11de:	1c20      	adds	r0, r4, #0
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    11e0:	430a      	orrs	r2, r1
    11e2:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    11e4:	681a      	ldr	r2, [r3, #0]
    11e6:	211f      	movs	r1, #31
    11e8:	f7ff f825 	bl	236 <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11ec:	4be0      	ldr	r3, [pc, #896]	; (1570 <main+0x860>)
    11ee:	200c      	movs	r0, #12
    11f0:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11f2:	49e0      	ldr	r1, [pc, #896]	; (1574 <main+0x864>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    11f4:	0a92      	lsrs	r2, r2, #10
    11f6:	0292      	lsls	r2, r2, #10
    11f8:	4302      	orrs	r2, r0
    11fa:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    11fc:	680a      	ldr	r2, [r1, #0]
    11fe:	49de      	ldr	r1, [pc, #888]	; (1578 <main+0x868>)
    1200:	0bd2      	lsrs	r2, r2, #15
    1202:	48dc      	ldr	r0, [pc, #880]	; (1574 <main+0x864>)
    1204:	03d2      	lsls	r2, r2, #15
    1206:	430a      	orrs	r2, r1
    1208:	6002      	str	r2, [r0, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    120a:	6819      	ldr	r1, [r3, #0]
    120c:	4adb      	ldr	r2, [pc, #876]	; (157c <main+0x86c>)

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    120e:	1c20      	adds	r0, r4, #0

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    1210:	400a      	ands	r2, r1
    1212:	21c8      	movs	r1, #200	; 0xc8
    1214:	01c9      	lsls	r1, r1, #7
    1216:	430a      	orrs	r2, r1
    1218:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    121a:	681a      	ldr	r2, [r3, #0]
    121c:	2112      	movs	r1, #18
    121e:	f7ff f80a 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1222:	49d4      	ldr	r1, [pc, #848]	; (1574 <main+0x864>)
    1224:	1c20      	adds	r0, r4, #0
    1226:	680a      	ldr	r2, [r1, #0]
    1228:	2113      	movs	r1, #19
    122a:	f7ff f804 	bl	236 <mbus_remote_register_write>
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    122e:	4bd4      	ldr	r3, [pc, #848]	; (1580 <main+0x870>)
    mrr_freq_hopping_step = 4; // determining center freq
    1230:	2204      	movs	r2, #4
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    1232:	701c      	strb	r4, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
    1234:	4bd3      	ldr	r3, [pc, #844]	; (1584 <main+0x874>)

    mrr_cfo_val_fine_min = 0x0000;

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    1236:	1c20      	adds	r0, r4, #0
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    mrr_freq_hopping_step = 4; // determining center freq
    1238:	701a      	strb	r2, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
    123a:	4bd3      	ldr	r3, [pc, #844]	; (1588 <main+0x878>)

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    123c:	2280      	movs	r2, #128	; 0x80
    123e:	2106      	movs	r1, #6
    1240:	0152      	lsls	r2, r2, #5
    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    mrr_freq_hopping_step = 4; // determining center freq

    mrr_cfo_val_fine_min = 0x0000;
    1242:	801f      	strh	r7, [r3, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    1244:	f7fe fff7 	bl	236 <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
    1248:	2280      	movs	r2, #128	; 0x80
    124a:	1c20      	adds	r0, r4, #0
    124c:	2108      	movs	r1, #8
    124e:	03d2      	lsls	r2, r2, #15
    1250:	f7fe fff1 	bl	236 <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    1254:	4bcd      	ldr	r3, [pc, #820]	; (158c <main+0x87c>)
    1256:	217f      	movs	r1, #127	; 0x7f
    1258:	881a      	ldrh	r2, [r3, #0]
    125a:	2010      	movs	r0, #16
    125c:	438a      	bics	r2, r1
    125e:	4302      	orrs	r2, r0
    1260:	801a      	strh	r2, [r3, #0]
    mrrv7_r07.RO_MIM = 0x10;
    1262:	8819      	ldrh	r1, [r3, #0]
    1264:	4aca      	ldr	r2, [pc, #808]	; (1590 <main+0x880>)
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    1266:	1c20      	adds	r0, r4, #0
    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    1268:	400a      	ands	r2, r1
    126a:	2180      	movs	r1, #128	; 0x80
    126c:	0109      	lsls	r1, r1, #4
    126e:	430a      	orrs	r2, r1
    1270:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    1272:	681a      	ldr	r2, [r3, #0]
    1274:	2107      	movs	r1, #7
    1276:	f7fe ffde 	bl	236 <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    127a:	6832      	ldr	r2, [r6, #0]
    127c:	4bc5      	ldr	r3, [pc, #788]	; (1594 <main+0x884>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    127e:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    1280:	4013      	ands	r3, r2
    1282:	22f8      	movs	r2, #248	; 0xf8
    1284:	0112      	lsls	r2, r2, #4
    1286:	4313      	orrs	r3, r2
    1288:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    128a:	6832      	ldr	r2, [r6, #0]
    128c:	1c39      	adds	r1, r7, #0
    128e:	f7fe ffd2 	bl	236 <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x01f; //ANT CAP 10b unary 830.5 MHz
    1292:	4bc1      	ldr	r3, [pc, #772]	; (1598 <main+0x888>)
    1294:	211f      	movs	r1, #31
    1296:	681a      	ldr	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    1298:	263f      	movs	r6, #63	; 0x3f
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x01f; //ANT CAP 10b unary 830.5 MHz
    129a:	0a92      	lsrs	r2, r2, #10
    129c:	0292      	lsls	r2, r2, #10
    129e:	430a      	orrs	r2, r1
    12a0:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    12a2:	4ab9      	ldr	r2, [pc, #740]	; (1588 <main+0x878>)
    12a4:	8811      	ldrh	r1, [r2, #0]
    12a6:	6818      	ldr	r0, [r3, #0]
    12a8:	4abc      	ldr	r2, [pc, #752]	; (159c <main+0x88c>)
    12aa:	4031      	ands	r1, r6
    12ac:	0409      	lsls	r1, r1, #16
    12ae:	4002      	ands	r2, r0
    12b0:	430a      	orrs	r2, r1
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    12b2:	48b5      	ldr	r0, [pc, #724]	; (1588 <main+0x878>)

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x01f; //ANT CAP 10b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    12b4:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    12b6:	8801      	ldrh	r1, [r0, #0]
    12b8:	4ab9      	ldr	r2, [pc, #740]	; (15a0 <main+0x890>)
    12ba:	6818      	ldr	r0, [r3, #0]
    12bc:	4031      	ands	r1, r6
    12be:	0289      	lsls	r1, r1, #10
    12c0:	4002      	ands	r2, r0
    12c2:	430a      	orrs	r2, r1
    12c4:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    12c6:	681a      	ldr	r2, [r3, #0]
    12c8:	1c20      	adds	r0, r4, #0
    12ca:	2101      	movs	r1, #1
    12cc:	f7fe ffb3 	bl	236 <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    12d0:	4bb4      	ldr	r3, [pc, #720]	; (15a4 <main+0x894>)
    12d2:	49b5      	ldr	r1, [pc, #724]	; (15a8 <main+0x898>)
    12d4:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    12d6:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x01f; //ANT CAP 10b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    12d8:	430a      	orrs	r2, r1
    12da:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    12dc:	681a      	ldr	r2, [r3, #0]
    12de:	1c21      	adds	r1, r4, #0
    12e0:	f7fe ffa9 	bl	236 <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    12e4:	682a      	ldr	r2, [r5, #0]
    12e6:	4bb1      	ldr	r3, [pc, #708]	; (15ac <main+0x89c>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12e8:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    12ea:	4013      	ands	r3, r2
    12ec:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    12ee:	682a      	ldr	r2, [r5, #0]
    12f0:	2103      	movs	r1, #3
    12f2:	f7fe ffa0 	bl	236 <mbus_remote_register_write>

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12f6:	4bae      	ldr	r3, [pc, #696]	; (15b0 <main+0x8a0>)
    12f8:	4aae      	ldr	r2, [pc, #696]	; (15b4 <main+0x8a4>)
    12fa:	6819      	ldr	r1, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    12fc:	4dae      	ldr	r5, [pc, #696]	; (15b8 <main+0x8a8>)

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    12fe:	400a      	ands	r2, r1
    1300:	601a      	str	r2, [r3, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    1302:	682a      	ldr	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    1304:	1c20      	adds	r0, r4, #0
    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    1306:	43b2      	bics	r2, r6
    1308:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    130a:	6829      	ldr	r1, [r5, #0]
    130c:	4aab      	ldr	r2, [pc, #684]	; (15bc <main+0x8ac>)
    130e:	400a      	ands	r2, r1
    1310:	602a      	str	r2, [r5, #0]
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    1312:	6829      	ldr	r1, [r5, #0]
    1314:	4aaa      	ldr	r2, [pc, #680]	; (15c0 <main+0x8b0>)
    1316:	400a      	ands	r2, r1
    1318:	602a      	str	r2, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    131a:	681a      	ldr	r2, [r3, #0]
    131c:	2114      	movs	r1, #20
    131e:	f7fe ff8a 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
    1322:	682a      	ldr	r2, [r5, #0]
    1324:	1c20      	adds	r0, r4, #0
    1326:	2115      	movs	r1, #21
    1328:	f7fe ff85 	bl	236 <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    132c:	1c20      	adds	r0, r4, #0
    132e:	2109      	movs	r1, #9
    1330:	1c3a      	adds	r2, r7, #0
    1332:	f7fe ff80 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    1336:	1c20      	adds	r0, r4, #0
    1338:	210a      	movs	r1, #10
    133a:	1c3a      	adds	r2, r7, #0
    133c:	f7fe ff7b 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    1340:	1c20      	adds	r0, r4, #0
    1342:	210b      	movs	r1, #11
    1344:	1c3a      	adds	r2, r7, #0
    1346:	f7fe ff76 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    134a:	1c20      	adds	r0, r4, #0
    134c:	210c      	movs	r1, #12
    134e:	4a9d      	ldr	r2, [pc, #628]	; (15c4 <main+0x8b4>)
    1350:	f7fe ff71 	bl	236 <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    1354:	4b9c      	ldr	r3, [pc, #624]	; (15c8 <main+0x8b8>)
    1356:	21f8      	movs	r1, #248	; 0xf8
    1358:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    135a:	1c20      	adds	r0, r4, #0
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    135c:	438a      	bics	r2, r1
    135e:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    1360:	881a      	ldrh	r2, [r3, #0]
    1362:	21ff      	movs	r1, #255	; 0xff
    1364:	400a      	ands	r2, r1
    1366:	4999      	ldr	r1, [pc, #612]	; (15cc <main+0x8bc>)
    1368:	430a      	orrs	r2, r1
    136a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    136c:	681a      	ldr	r2, [r3, #0]
    136e:	2111      	movs	r1, #17
    1370:	f7fe ff61 	bl	236 <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    1374:	4a7f      	ldr	r2, [pc, #508]	; (1574 <main+0x864>)
    1376:	4896      	ldr	r0, [pc, #600]	; (15d0 <main+0x8c0>)
    1378:	6813      	ldr	r3, [r2, #0]
    137a:	22c0      	movs	r2, #192	; 0xc0
    137c:	497d      	ldr	r1, [pc, #500]	; (1574 <main+0x864>)
    137e:	4003      	ands	r3, r0
    1380:	03d2      	lsls	r2, r2, #15
    1382:	4313      	orrs	r3, r2
    1384:	600b      	str	r3, [r1, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1386:	680a      	ldr	r2, [r1, #0]
    1388:	1c20      	adds	r0, r4, #0
    138a:	2113      	movs	r1, #19
    138c:	f7fe ff53 	bl	236 <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
    1390:	1c20      	adds	r0, r4, #0
    1392:	211e      	movs	r1, #30
    1394:	4a8f      	ldr	r2, [pc, #572]	; (15d4 <main+0x8c4>)
    1396:	f7fe ff4e 	bl	236 <mbus_remote_register_write>

    // Additional delay for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    139a:	4873      	ldr	r0, [pc, #460]	; (1568 <main+0x858>)
    139c:	f7fe fe83 	bl	a6 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    13a0:	4b8d      	ldr	r3, [pc, #564]	; (15d8 <main+0x8c8>)
    13a2:	701f      	strb	r7, [r3, #0]
    radio_ready = 0;
    13a4:	4b8d      	ldr	r3, [pc, #564]	; (15dc <main+0x8cc>)
    13a6:	701f      	strb	r7, [r3, #0]
    13a8:	e2e5      	b.n	1976 <main+0xc66>
    if(enumerated != ENUMID) {
        operation_init();
        operation_sleep_notimer();
    }

    if(lnt_start_meas == 1) {
    13aa:	4b8d      	ldr	r3, [pc, #564]	; (15e0 <main+0x8d0>)
    13ac:	781c      	ldrb	r4, [r3, #0]
    13ae:	2c01      	cmp	r4, #1
    13b0:	d137      	bne.n	1422 <main+0x712>
        lnt_start_meas = 2;
    13b2:	2202      	movs	r2, #2
    13b4:	701a      	strb	r2, [r3, #0]
    // // Change Counting Time 
    // lntv1a_r03.TIME_COUNTING = 0x000; // Default : 0x258
    // mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    // delay(MBUS_DELAY*10);
    
    set_halt_until_mbus_trx();
    13b6:	f7fe fef7 	bl	1a8 <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    13ba:	1c23      	adds	r3, r4, #0
    13bc:	2003      	movs	r0, #3
    13be:	2110      	movs	r1, #16
    13c0:	2200      	movs	r2, #0
    13c2:	f7fe ff27 	bl	214 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
    13c6:	f7fe fee9 	bl	19c <set_halt_until_mbus_tx>
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0)) >> lnt_counter_base;
    13ca:	4b86      	ldr	r3, [pc, #536]	; (15e4 <main+0x8d4>)
    13cc:	4e86      	ldr	r6, [pc, #536]	; (15e8 <main+0x8d8>)
    13ce:	681a      	ldr	r2, [r3, #0]
    13d0:	23a0      	movs	r3, #160	; 0xa0
    13d2:	061b      	lsls	r3, r3, #24
    13d4:	6819      	ldr	r1, [r3, #0]
    13d6:	4b85      	ldr	r3, [pc, #532]	; (15ec <main+0x8dc>)
    13d8:	0612      	lsls	r2, r2, #24
    13da:	781b      	ldrb	r3, [r3, #0]
    13dc:	430a      	orrs	r2, r1
    13de:	1c14      	adds	r4, r2, #0
    13e0:	40dc      	lsrs	r4, r3
    13e2:	2500      	movs	r5, #0
    13e4:	6034      	str	r4, [r6, #0]
    13e6:	6075      	str	r5, [r6, #4]
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    13e8:	20e0      	movs	r0, #224	; 0xe0
    13ea:	6832      	ldr	r2, [r6, #0]
    13ec:	6873      	ldr	r3, [r6, #4]
    13ee:	1c19      	adds	r1, r3, #0
    13f0:	f7fe fee0 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);
    13f4:	6832      	ldr	r2, [r6, #0]
    13f6:	6873      	ldr	r3, [r6, #4]
    13f8:	20e1      	movs	r0, #225	; 0xe1
    13fa:	1c11      	adds	r1, r2, #0
    13fc:	f7fe feda 	bl	1b4 <mbus_write_message32>

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    1400:	4b7b      	ldr	r3, [pc, #492]	; (15f0 <main+0x8e0>)
    1402:	2110      	movs	r1, #16
    1404:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1406:	2003      	movs	r0, #3
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0)) >> lnt_counter_base;
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    1408:	438a      	bics	r2, r1
    140a:	701a      	strb	r2, [r3, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    140c:	781a      	ldrb	r2, [r3, #0]
    140e:	2140      	movs	r1, #64	; 0x40
    1410:	438a      	bics	r2, r1
    1412:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1414:	681a      	ldr	r2, [r3, #0]
    1416:	1c29      	adds	r1, r5, #0
    1418:	f7fe ff0d 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    141c:	4875      	ldr	r0, [pc, #468]	; (15f4 <main+0x8e4>)
    141e:	f7fe fe42 	bl	a6 <delay>
    if(lnt_start_meas == 1) {
        lnt_start_meas = 2;
        lnt_stop();
    }

    operation_temp_run();
    1422:	f7ff f863 	bl	4ec <operation_temp_run>
    // pmu_adc_read_latest();

    sys_run_continuous = 0;
    1426:	4b74      	ldr	r3, [pc, #464]	; (15f8 <main+0x8e8>)
    1428:	2200      	movs	r2, #0
    142a:	701a      	strb	r2, [r3, #0]
    do {
        if(goc_component == 0x00) {
    142c:	4b73      	ldr	r3, [pc, #460]	; (15fc <main+0x8ec>)
    142e:	781c      	ldrb	r4, [r3, #0]
    1430:	2c00      	cmp	r4, #0
    1432:	d11d      	bne.n	1470 <main+0x760>
            if(goc_func_id == 0x01) {
    1434:	4b72      	ldr	r3, [pc, #456]	; (1600 <main+0x8f0>)
    1436:	781b      	ldrb	r3, [r3, #0]
    1438:	2b01      	cmp	r3, #1
    143a:	d10f      	bne.n	145c <main+0x74c>
                if(sys_run_continuous) {
    143c:	4c6e      	ldr	r4, [pc, #440]	; (15f8 <main+0x8e8>)
    143e:	7823      	ldrb	r3, [r4, #0]
    1440:	2b00      	cmp	r3, #0
    1442:	d002      	beq.n	144a <main+0x73a>
                    start_xo_cout();
    1444:	f7fe fe9e 	bl	184 <start_xo_cout>
    1448:	e001      	b.n	144e <main+0x73e>
                }
                else {
                    stop_xo_cout();
    144a:	f7fe fea1 	bl	190 <stop_xo_cout>
                }
                sys_run_continuous = !sys_run_continuous;
    144e:	7823      	ldrb	r3, [r4, #0]
    1450:	425a      	negs	r2, r3
    1452:	4153      	adcs	r3, r2
    1454:	7023      	strb	r3, [r4, #0]
                goc_func_id = 0xFF;
    1456:	22ff      	movs	r2, #255	; 0xff
    1458:	4b69      	ldr	r3, [pc, #420]	; (1600 <main+0x8f0>)
    145a:	e1a0      	b.n	179e <main+0xa8e>
            }
            else if(goc_func_id == 0x02) {
    145c:	2b02      	cmp	r3, #2
    145e:	d000      	beq.n	1462 <main+0x752>
    1460:	e222      	b.n	18a8 <main+0xb98>
                // enter time in minutes
                xo_day_time_in_sec = goc_data * 60;
    1462:	4b68      	ldr	r3, [pc, #416]	; (1604 <main+0x8f4>)
    1464:	223c      	movs	r2, #60	; 0x3c
    1466:	881b      	ldrh	r3, [r3, #0]
    1468:	435a      	muls	r2, r3
    146a:	4b67      	ldr	r3, [pc, #412]	; (1608 <main+0x8f8>)
    146c:	601a      	str	r2, [r3, #0]
    146e:	e21b      	b.n	18a8 <main+0xb98>
            }
        }
        else if(goc_component == 0x01) {
    1470:	2c01      	cmp	r4, #1
    1472:	d124      	bne.n	14be <main+0x7ae>
            if(!goc_state) {
    1474:	4b65      	ldr	r3, [pc, #404]	; (160c <main+0x8fc>)
    1476:	4a5a      	ldr	r2, [pc, #360]	; (15e0 <main+0x8d0>)
    1478:	7819      	ldrb	r1, [r3, #0]
    147a:	2900      	cmp	r1, #0
    147c:	d102      	bne.n	1484 <main+0x774>
                goc_state = 1;
    147e:	701c      	strb	r4, [r3, #0]
                lnt_start_meas = 1;
    1480:	7014      	strb	r4, [r2, #0]
    1482:	e211      	b.n	18a8 <main+0xb98>
            }
            else if(lnt_start_meas == 2) {
    1484:	7811      	ldrb	r1, [r2, #0]
    1486:	2902      	cmp	r1, #2
    1488:	d000      	beq.n	148c <main+0x77c>
    148a:	e20d      	b.n	18a8 <main+0xb98>
		lnt_start_meas = 0;
    148c:	2500      	movs	r5, #0
    148e:	7015      	strb	r5, [r2, #0]
		goc_state = 0;
    1490:	701d      	strb	r5, [r3, #0]
                reset_radio_data_arr();
    1492:	f7fe ff0d 	bl	2b0 <reset_radio_data_arr>
                radio_data_arr[0] = snt_sys_temp_code;
    1496:	4b5e      	ldr	r3, [pc, #376]	; (1610 <main+0x900>)
    1498:	495e      	ldr	r1, [pc, #376]	; (1614 <main+0x904>)
    149a:	681b      	ldr	r3, [r3, #0]
                radio_data_arr[1] = lnt_sys_light;
                pmu_setting_temp_based(1);
    149c:	1c20      	adds	r0, r4, #0
            }
            else if(lnt_start_meas == 2) {
		lnt_start_meas = 0;
		goc_state = 0;
                reset_radio_data_arr();
                radio_data_arr[0] = snt_sys_temp_code;
    149e:	600b      	str	r3, [r1, #0]
                radio_data_arr[1] = lnt_sys_light;
    14a0:	4b51      	ldr	r3, [pc, #324]	; (15e8 <main+0x8d8>)
    14a2:	681a      	ldr	r2, [r3, #0]
    14a4:	685b      	ldr	r3, [r3, #4]
    14a6:	604a      	str	r2, [r1, #4]
                pmu_setting_temp_based(1);
    14a8:	f7fe ff48 	bl	33c <pmu_setting_temp_based>
                mrr_send_radio_data(1);
    14ac:	1c20      	adds	r0, r4, #0
    14ae:	f7ff fa41 	bl	934 <mrr_send_radio_data>
                pmu_setting_temp_based(0);
    14b2:	1c28      	adds	r0, r5, #0
    14b4:	f7fe ff42 	bl	33c <pmu_setting_temp_based>

		set_next_time(START_LNT, 60);
    14b8:	1c20      	adds	r0, r4, #0
    14ba:	213c      	movs	r1, #60	; 0x3c
    14bc:	e1f2      	b.n	18a4 <main+0xb94>
            }
        }
        else if(goc_component == 0x04) {
    14be:	2c04      	cmp	r4, #4
    14c0:	d000      	beq.n	14c4 <main+0x7b4>
    14c2:	e1f1      	b.n	18a8 <main+0xb98>
            if(goc_func_id == 0x01) {
    14c4:	4b4e      	ldr	r3, [pc, #312]	; (1600 <main+0x8f0>)
    14c6:	7818      	ldrb	r0, [r3, #0]
    14c8:	2801      	cmp	r0, #1
    14ca:	d000      	beq.n	14ce <main+0x7be>
    14cc:	e1ec      	b.n	18a8 <main+0xb98>
		if(goc_state == 0) {
    14ce:	4a4f      	ldr	r2, [pc, #316]	; (160c <main+0x8fc>)
    14d0:	7813      	ldrb	r3, [r2, #0]
    14d2:	2b00      	cmp	r3, #0
    14d4:	d131      	bne.n	153a <main+0x82a>
                    goc_state = 1;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    14d6:	4950      	ldr	r1, [pc, #320]	; (1618 <main+0x908>)

                    snt_counter = 2;    // start code with snt storage
    14d8:	2402      	movs	r4, #2
        else if(goc_component == 0x04) {
            if(goc_func_id == 0x01) {
		if(goc_state == 0) {
                    goc_state = 1;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    14da:	800b      	strh	r3, [r1, #0]

                    snt_counter = 2;    // start code with snt storage
    14dc:	494f      	ldr	r1, [pc, #316]	; (161c <main+0x90c>)
            }
        }
        else if(goc_component == 0x04) {
            if(goc_func_id == 0x01) {
		if(goc_state == 0) {
                    goc_state = 1;
    14de:	7010      	strb	r0, [r2, #0]
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;

                    snt_counter = 2;    // start code with snt storage
    14e0:	700c      	strb	r4, [r1, #0]
                    radio_beacon_counter = 0;
    14e2:	494f      	ldr	r1, [pc, #316]	; (1620 <main+0x910>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
    14e4:	4c4f      	ldr	r4, [pc, #316]	; (1624 <main+0x914>)
                    goc_state = 1;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;

                    snt_counter = 2;    // start code with snt storage
                    radio_beacon_counter = 0;
    14e6:	700b      	strb	r3, [r1, #0]
                    radio_counter = 0;
    14e8:	494f      	ldr	r1, [pc, #316]	; (1628 <main+0x918>)
        else if(goc_component == 0x04) {
            if(goc_func_id == 0x01) {
		if(goc_state == 0) {
                    goc_state = 1;
                    // xo_end_time_in_sec = xo_sys_time_in_sec + OPERATION_DURATION;
                    op_counter = 0;
    14ea:	1c1a      	adds	r2, r3, #0

                    snt_counter = 2;    // start code with snt storage
                    radio_beacon_counter = 0;
                    radio_counter = 0;
    14ec:	700b      	strb	r3, [r1, #0]

                    mem_light_addr = 0;
    14ee:	494f      	ldr	r1, [pc, #316]	; (162c <main+0x91c>)
    14f0:	800b      	strh	r3, [r1, #0]
                    mem_light_len = 0;
    14f2:	494f      	ldr	r1, [pc, #316]	; (1630 <main+0x920>)
    14f4:	800b      	strh	r3, [r1, #0]
                    mem_temp_addr = 7000;
    14f6:	494f      	ldr	r1, [pc, #316]	; (1634 <main+0x924>)
    14f8:	800c      	strh	r4, [r1, #0]
                    mem_temp_len = 0;
    14fa:	494f      	ldr	r1, [pc, #316]	; (1638 <main+0x928>)

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    14fc:	4c42      	ldr	r4, [pc, #264]	; (1608 <main+0x8f8>)
                    radio_counter = 0;

                    mem_light_addr = 0;
                    mem_light_len = 0;
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;
    14fe:	800b      	strh	r3, [r1, #0]

		    lnt_start_meas = 0;
    1500:	4937      	ldr	r1, [pc, #220]	; (15e0 <main+0x8d0>)
    1502:	700b      	strb	r3, [r1, #0]

                    uint32_t next_hour_in_sec = goc_data * 3600;
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    1504:	494d      	ldr	r1, [pc, #308]	; (163c <main+0x92c>)
    1506:	680e      	ldr	r6, [r1, #0]
    1508:	6825      	ldr	r5, [r4, #0]
    150a:	1b75      	subs	r5, r6, r5
                    mem_temp_addr = 7000;
                    mem_temp_len = 0;

		    lnt_start_meas = 0;

                    uint32_t next_hour_in_sec = goc_data * 3600;
    150c:	4e3d      	ldr	r6, [pc, #244]	; (1604 <main+0x8f4>)
    150e:	8837      	ldrh	r7, [r6, #0]
    1510:	26e1      	movs	r6, #225	; 0xe1
    1512:	0136      	lsls	r6, r6, #4
    1514:	437e      	muls	r6, r7
                    xot_timer_list[RUN_SNT] = xo_sys_time_in_sec + next_hour_in_sec - xo_day_time_in_sec;
    1516:	19ae      	adds	r6, r5, r6
    1518:	4d49      	ldr	r5, [pc, #292]	; (1640 <main+0x930>)
    151a:	602e      	str	r6, [r5, #0]
                    xot_timer_list[START_LNT] = 0;
    151c:	606b      	str	r3, [r5, #4]
		    xo_is_day = 0;
    151e:	4b49      	ldr	r3, [pc, #292]	; (1644 <main+0x934>)
    1520:	701a      	strb	r2, [r3, #0]
		    xo_last_is_day = 0;
    1522:	4b49      	ldr	r3, [pc, #292]	; (1648 <main+0x938>)
    1524:	701a      	strb	r2, [r3, #0]

                    radio_data_arr[0] = xo_day_time_in_sec;
    1526:	6822      	ldr	r2, [r4, #0]
    1528:	4b3a      	ldr	r3, [pc, #232]	; (1614 <main+0x904>)
    152a:	601a      	str	r2, [r3, #0]
                    radio_data_arr[1] = xo_sys_time_in_sec;
    152c:	680a      	ldr	r2, [r1, #0]
    152e:	605a      	str	r2, [r3, #4]
                    radio_data_arr[2] = 0xDEAD;
    1530:	4a46      	ldr	r2, [pc, #280]	; (164c <main+0x93c>)
    1532:	609a      	str	r2, [r3, #8]
                    mrr_send_radio_data(1);
    1534:	f7ff f9fe 	bl	934 <mrr_send_radio_data>
    1538:	e1b6      	b.n	18a8 <main+0xb98>
                }

		else if(goc_state == 1) {
    153a:	2b01      	cmp	r3, #1
    153c:	d000      	beq.n	1540 <main+0x830>
    153e:	e130      	b.n	17a2 <main+0xa92>
                    if(op_counter >= SNT_OP_MAX_COUNT) {
    1540:	4b35      	ldr	r3, [pc, #212]	; (1618 <main+0x908>)
    1542:	4c3f      	ldr	r4, [pc, #252]	; (1640 <main+0x930>)
    1544:	8819      	ldrh	r1, [r3, #0]
    1546:	2936      	cmp	r1, #54	; 0x36
    1548:	d800      	bhi.n	154c <main+0x83c>
    154a:	e081      	b.n	1650 <main+0x940>
                        goc_state = 2;
    154c:	2302      	movs	r3, #2
    154e:	7013      	strb	r3, [r2, #0]
			reset_timers_list();
    1550:	f7ff f96e 	bl	830 <reset_timers_list>
			update_system_time();
    1554:	f7ff f948 	bl	7e8 <update_system_time>
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
    1558:	4b38      	ldr	r3, [pc, #224]	; (163c <main+0x92c>)
    155a:	2296      	movs	r2, #150	; 0x96
    155c:	681b      	ldr	r3, [r3, #0]
    155e:	0092      	lsls	r2, r2, #2
    1560:	189b      	adds	r3, r3, r2
    1562:	60a3      	str	r3, [r4, #8]
    1564:	e1a0      	b.n	18a8 <main+0xb98>
    1566:	46c0      	nop			; (mov r8, r8)
    1568:	00004e20 	.word	0x00004e20
    156c:	00001bc0 	.word	0x00001bc0
    1570:	00001bd4 	.word	0x00001bd4
    1574:	00001bd8 	.word	0x00001bd8
    1578:	00000451 	.word	0x00000451
    157c:	fff003ff 	.word	0xfff003ff
    1580:	00001c00 	.word	0x00001c00
    1584:	00001c64 	.word	0x00001c64
    1588:	00001bf4 	.word	0x00001bf4
    158c:	00001b98 	.word	0x00001b98
    1590:	ffffc07f 	.word	0xffffc07f
    1594:	fffe007f 	.word	0xfffe007f
    1598:	00001c88 	.word	0x00001c88
    159c:	ffc0ffff 	.word	0xffc0ffff
    15a0:	ffff03ff 	.word	0xffff03ff
    15a4:	00001bc4 	.word	0x00001bc4
    15a8:	00001fff 	.word	0x00001fff
    15ac:	ffffbfff 	.word	0xffffbfff
    15b0:	00001bdc 	.word	0x00001bdc
    15b4:	fff8ffff 	.word	0xfff8ffff
    15b8:	00001be0 	.word	0x00001be0
    15bc:	fffff03f 	.word	0xfffff03f
    15c0:	fff80fff 	.word	0xfff80fff
    15c4:	007ac800 	.word	0x007ac800
    15c8:	00001bd0 	.word	0x00001bd0
    15cc:	ffffc000 	.word	0xffffc000
    15d0:	ff1fffff 	.word	0xff1fffff
    15d4:	00001002 	.word	0x00001002
    15d8:	00001c70 	.word	0x00001c70
    15dc:	00001bf6 	.word	0x00001bf6
    15e0:	00001c84 	.word	0x00001c84
    15e4:	a0000004 	.word	0xa0000004
    15e8:	00001c48 	.word	0x00001c48
    15ec:	00001c71 	.word	0x00001c71
    15f0:	00001b80 	.word	0x00001b80
    15f4:	00002710 	.word	0x00002710
    15f8:	00001c41 	.word	0x00001c41
    15fc:	00001c12 	.word	0x00001c12
    1600:	00001c20 	.word	0x00001c20
    1604:	00001c24 	.word	0x00001c24
    1608:	00001c68 	.word	0x00001c68
    160c:	00001c50 	.word	0x00001c50
    1610:	00001c2c 	.word	0x00001c2c
    1614:	00001c30 	.word	0x00001c30
    1618:	00001c6e 	.word	0x00001c6e
    161c:	00001c26 	.word	0x00001c26
    1620:	00001c40 	.word	0x00001c40
    1624:	00001b58 	.word	0x00001b58
    1628:	00001c23 	.word	0x00001c23
    162c:	00001c02 	.word	0x00001c02
    1630:	00001c3e 	.word	0x00001c3e
    1634:	00001c3c 	.word	0x00001c3c
    1638:	00001c10 	.word	0x00001c10
    163c:	00001c1c 	.word	0x00001c1c
    1640:	00001c54 	.word	0x00001c54
    1644:	00001c21 	.word	0x00001c21
    1648:	00001c42 	.word	0x00001c42
    164c:	0000dead 	.word	0x0000dead
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
    1650:	6822      	ldr	r2, [r4, #0]
    1652:	3201      	adds	r2, #1
    1654:	d124      	bne.n	16a0 <main+0x990>
			    op_counter++;
    1656:	881a      	ldrh	r2, [r3, #0]
                            pmu_setting_temp_based(0);
    1658:	2000      	movs	r0, #0
                        xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 600; // FIXME: set to 600
                    }
                    else {
                        // SNT measurements
                        if(xot_timer_list[RUN_SNT] == 0xFFFFFFFF) {
			    op_counter++;
    165a:	3201      	adds	r2, #1
    165c:	801a      	strh	r2, [r3, #0]
                            pmu_setting_temp_based(0);
    165e:	f7fe fe6d 	bl	33c <pmu_setting_temp_based>

                            // TODO: compensate XO

                            if(++snt_counter >= 3) {
    1662:	4ac6      	ldr	r2, [pc, #792]	; (197c <main+0xc6c>)
    1664:	7813      	ldrb	r3, [r2, #0]
    1666:	3301      	adds	r3, #1
    1668:	b2db      	uxtb	r3, r3
    166a:	7013      	strb	r3, [r2, #0]
    166c:	2b02      	cmp	r3, #2
    166e:	d90d      	bls.n	168c <main+0x97c>
                                snt_counter = 0;
    1670:	2300      	movs	r3, #0
    1672:	7013      	strb	r3, [r2, #0]
                                // TODO: compress this
                                mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) &snt_sys_temp_code, 0);
    1674:	4cc2      	ldr	r4, [pc, #776]	; (1980 <main+0xc70>)
    1676:	4ac3      	ldr	r2, [pc, #780]	; (1984 <main+0xc74>)
    1678:	2006      	movs	r0, #6
    167a:	8811      	ldrh	r1, [r2, #0]
    167c:	8822      	ldrh	r2, [r4, #0]
    167e:	1889      	adds	r1, r1, r2
    1680:	4ac1      	ldr	r2, [pc, #772]	; (1988 <main+0xc78>)
    1682:	f7fe fde5 	bl	250 <mbus_copy_mem_from_local_to_remote_bulk>
                                mem_temp_len++;
    1686:	8823      	ldrh	r3, [r4, #0]
    1688:	3301      	adds	r3, #1
    168a:	8023      	strh	r3, [r4, #0]
                            }

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
    168c:	4bbf      	ldr	r3, [pc, #764]	; (198c <main+0xc7c>)
    168e:	20ea      	movs	r0, #234	; 0xea
    1690:	6819      	ldr	r1, [r3, #0]
    1692:	f7fe fd8f 	bl	1b4 <mbus_write_message32>
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
    1696:	2196      	movs	r1, #150	; 0x96
    1698:	2000      	movs	r0, #0
    169a:	0089      	lsls	r1, r1, #2
    169c:	f7ff f8d4 	bl	848 <set_next_time>
                        }

			xo_is_day = xo_check_is_day();
    16a0:	f7ff f8ee 	bl	880 <xo_check_is_day>
    16a4:	4cba      	ldr	r4, [pc, #744]	; (1990 <main+0xc80>)

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    16a6:	4bbb      	ldr	r3, [pc, #748]	; (1994 <main+0xc84>)

			    mbus_write_message32(0xEA, xot_timer_list[RUN_SNT]);
                            set_next_time(RUN_SNT, SNT_TEMP_UPDATE_TIME);
                        }

			xo_is_day = xo_check_is_day();
    16a8:	7020      	strb	r0, [r4, #0]

                        // LNT measurements
                        if(lnt_start_meas == 2) {
    16aa:	781a      	ldrb	r2, [r3, #0]
    16ac:	2a02      	cmp	r2, #2
    16ae:	d161      	bne.n	1774 <main+0xa64>
                            lnt_start_meas = 0;
    16b0:	2200      	movs	r2, #0
    16b2:	701a      	strb	r2, [r3, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
    16b4:	4eb8      	ldr	r6, [pc, #736]	; (1998 <main+0xc88>)
    16b6:	4bb9      	ldr	r3, [pc, #740]	; (199c <main+0xc8c>)
    16b8:	4db9      	ldr	r5, [pc, #740]	; (19a0 <main+0xc90>)
    16ba:	8819      	ldrh	r1, [r3, #0]
    16bc:	8833      	ldrh	r3, [r6, #0]
    16be:	2006      	movs	r0, #6
    16c0:	18c9      	adds	r1, r1, r3
    16c2:	1c2a      	adds	r2, r5, #0
    16c4:	2301      	movs	r3, #1
    16c6:	f7fe fdc3 	bl	250 <mbus_copy_mem_from_local_to_remote_bulk>
                            mem_light_len += 2;
    16ca:	8833      	ldrh	r3, [r6, #0]
    16cc:	3302      	adds	r3, #2
    16ce:	8033      	strh	r3, [r6, #0]

                            if(xo_is_day) {
    16d0:	7823      	ldrb	r3, [r4, #0]
    16d2:	2b00      	cmp	r3, #0
    16d4:	d060      	beq.n	1798 <main+0xa88>
    mbus_write_message32(0xCE, end_time - xo_sys_time_in_sec);
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    16d6:	4bb3      	ldr	r3, [pc, #716]	; (19a4 <main+0xc94>)
    16d8:	6818      	ldr	r0, [r3, #0]
    16da:	6859      	ldr	r1, [r3, #4]
    16dc:	682a      	ldr	r2, [r5, #0]
    16de:	686b      	ldr	r3, [r5, #4]
    16e0:	4299      	cmp	r1, r3
    16e2:	d815      	bhi.n	1710 <main+0xa00>
    16e4:	d101      	bne.n	16ea <main+0x9da>
    16e6:	4290      	cmp	r0, r2
    16e8:	d812      	bhi.n	1710 <main+0xa00>
    16ea:	2100      	movs	r1, #0
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    16ec:	48ae      	ldr	r0, [pc, #696]	; (19a8 <main+0xc98>)
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    16ee:	4cac      	ldr	r4, [pc, #688]	; (19a0 <main+0xc90>)
    16f0:	4dae      	ldr	r5, [pc, #696]	; (19ac <main+0xc9c>)
    16f2:	1c0e      	adds	r6, r1, #0
    16f4:	e020      	b.n	1738 <main+0xa28>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    16f6:	004f      	lsls	r7, r1, #1

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    16f8:	682a      	ldr	r2, [r5, #0]
    16fa:	686b      	ldr	r3, [r5, #4]
    16fc:	5bbf      	ldrh	r7, [r7, r6]
    16fe:	2b00      	cmp	r3, #0
    1700:	d101      	bne.n	1706 <main+0x9f6>
    1702:	42ba      	cmp	r2, r7
    1704:	d902      	bls.n	170c <main+0x9fc>
                lnt_cur_level = i + 1;
    1706:	3101      	adds	r1, #1
    1708:	7021      	strb	r1, [r4, #0]
    170a:	e018      	b.n	173e <main+0xa2e>
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
        for(i = 2; i >= lnt_cur_level; i--) {
    170c:	3901      	subs	r1, #1
    170e:	e003      	b.n	1718 <main+0xa08>
    1710:	48a5      	ldr	r0, [pc, #660]	; (19a8 <main+0xc98>)
            if(lnt_sys_light > LNT_UPPER_THRESH[i]) {
    1712:	4da3      	ldr	r5, [pc, #652]	; (19a0 <main+0xc90>)
    1714:	4ea6      	ldr	r6, [pc, #664]	; (19b0 <main+0xca0>)
    mbus_write_message32(0xCE, end_time - xo_sys_time_in_sec);
}

static uint16_t update_light_interval() {
    int i;
    if(lnt_last_light > lnt_sys_light) {
    1716:	2102      	movs	r1, #2
        for(i = 2; i >= lnt_cur_level; i--) {
    1718:	7803      	ldrb	r3, [r0, #0]
    171a:	1c04      	adds	r4, r0, #0
    171c:	4299      	cmp	r1, r3
    171e:	daea      	bge.n	16f6 <main+0x9e6>
    1720:	e00d      	b.n	173e <main+0xa2e>

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1722:	004f      	lsls	r7, r1, #1
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
            if(lnt_sys_light < LNT_LOWER_THRESH[i]) {
    1724:	6822      	ldr	r2, [r4, #0]
    1726:	6863      	ldr	r3, [r4, #4]
    1728:	5b7f      	ldrh	r7, [r7, r5]
    172a:	429e      	cmp	r6, r3
    172c:	d103      	bne.n	1736 <main+0xa26>
    172e:	4297      	cmp	r7, r2
    1730:	d901      	bls.n	1736 <main+0xa26>
                lnt_cur_level = i;
    1732:	7001      	strb	r1, [r0, #0]
    1734:	e003      	b.n	173e <main+0xa2e>
                break;
            }
        }
    }
    else {
        for(i = 0; i < lnt_cur_level; i++) {
    1736:	3101      	adds	r1, #1
    1738:	7803      	ldrb	r3, [r0, #0]
    173a:	4299      	cmp	r1, r3
    173c:	dbf1      	blt.n	1722 <main+0xa12>
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    173e:	4999      	ldr	r1, [pc, #612]	; (19a4 <main+0xc94>)
    1740:	4b97      	ldr	r3, [pc, #604]	; (19a0 <main+0xc90>)
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    1742:	4d99      	ldr	r5, [pc, #612]	; (19a8 <main+0xc98>)
                lnt_cur_level = i;
                break;
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    1744:	681a      	ldr	r2, [r3, #0]
    1746:	685b      	ldr	r3, [r3, #4]
    1748:	600a      	str	r2, [r1, #0]
    174a:	604b      	str	r3, [r1, #4]
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    174c:	782b      	ldrb	r3, [r5, #0]
    174e:	4c99      	ldr	r4, [pc, #612]	; (19b4 <main+0xca4>)
    1750:	005b      	lsls	r3, r3, #1
    1752:	5b19      	ldrh	r1, [r3, r4]
    1754:	20df      	movs	r0, #223	; 0xdf
    1756:	f7fe fd2d 	bl	1b4 <mbus_write_message32>
    return LNT_INTERVAL[lnt_cur_level];
    175a:	782b      	ldrb	r3, [r5, #0]
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    175c:	2001      	movs	r0, #1
            }
        }
    }
    lnt_last_light = lnt_sys_light;
    mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    return LNT_INTERVAL[lnt_cur_level];
    175e:	005b      	lsls	r3, r3, #1
                            // TODO: compress this
                            mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) &lnt_sys_light, 1);
                            mem_light_len += 2;

                            if(xo_is_day) {
                                set_next_time(START_LNT, update_light_interval());
    1760:	5b19      	ldrh	r1, [r3, r4]
    1762:	f7ff f871 	bl	848 <set_next_time>
				mbus_write_message32(0xEB, LNT_INTERVAL[lnt_cur_level]);
    1766:	782b      	ldrb	r3, [r5, #0]
    1768:	20eb      	movs	r0, #235	; 0xeb
    176a:	005b      	lsls	r3, r3, #1
    176c:	5b19      	ldrh	r1, [r3, r4]
    176e:	f7fe fd21 	bl	1b4 <mbus_write_message32>
    1772:	e011      	b.n	1798 <main+0xa88>
                            }
                        }
			else if(xot_timer_list[START_LNT] == 0xFFFFFFFF) {
    1774:	4a85      	ldr	r2, [pc, #532]	; (198c <main+0xc7c>)
    1776:	6851      	ldr	r1, [r2, #4]
    1778:	3101      	adds	r1, #1
    177a:	d101      	bne.n	1780 <main+0xa70>
                            xot_timer_list[START_LNT] = 0;
    177c:	2100      	movs	r1, #0
    177e:	e008      	b.n	1792 <main+0xa82>
                            lnt_start_meas = 1;
                        }

			else if(!xo_last_is_day && xo_is_day) {
    1780:	4a8d      	ldr	r2, [pc, #564]	; (19b8 <main+0xca8>)
    1782:	7812      	ldrb	r2, [r2, #0]
    1784:	2a00      	cmp	r2, #0
    1786:	d107      	bne.n	1798 <main+0xa88>
    1788:	7822      	ldrb	r2, [r4, #0]
    178a:	2a00      	cmp	r2, #0
    178c:	d004      	beq.n	1798 <main+0xa88>
			    // set LNT last timer to SNT current timer for synchronization
			    xot_last_timer_list[START_LNT] = xot_last_timer_list[RUN_SNT];
    178e:	4a8b      	ldr	r2, [pc, #556]	; (19bc <main+0xcac>)
    1790:	6811      	ldr	r1, [r2, #0]
    1792:	6051      	str	r1, [r2, #4]
			    lnt_start_meas = 1;
    1794:	2201      	movs	r2, #1
    1796:	701a      	strb	r2, [r3, #0]
			}

			xo_last_is_day = xo_is_day;
    1798:	4b7d      	ldr	r3, [pc, #500]	; (1990 <main+0xc80>)
    179a:	781a      	ldrb	r2, [r3, #0]
    179c:	4b86      	ldr	r3, [pc, #536]	; (19b8 <main+0xca8>)
    179e:	701a      	strb	r2, [r3, #0]
    17a0:	e082      	b.n	18a8 <main+0xb98>
                    }
                }

		else if(goc_state == 2) {
    17a2:	2b02      	cmp	r3, #2
    17a4:	d000      	beq.n	17a8 <main+0xa98>
    17a6:	e07f      	b.n	18a8 <main+0xb98>
                    // SEND RADIO
                    if(xot_timer_list[SEND_RAD] == 0xFFFFFFFF) {
    17a8:	4b78      	ldr	r3, [pc, #480]	; (198c <main+0xc7c>)
    17aa:	689b      	ldr	r3, [r3, #8]
    17ac:	3301      	adds	r3, #1
    17ae:	d000      	beq.n	17b2 <main+0xaa2>
    17b0:	e07a      	b.n	18a8 <main+0xb98>
                        pmu_setting_temp_based(1);
    17b2:	f7fe fdc3 	bl	33c <pmu_setting_temp_based>

                        if(xo_check_is_day()) {
    17b6:	f7ff f863 	bl	880 <xo_check_is_day>
    17ba:	2800      	cmp	r0, #0
    17bc:	d06f      	beq.n	189e <main+0xb8e>
                            // send beacon
                            reset_radio_data_arr();
    17be:	f7fe fd77 	bl	2b0 <reset_radio_data_arr>
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    17c2:	4a7f      	ldr	r2, [pc, #508]	; (19c0 <main+0xcb0>)
    17c4:	4b7f      	ldr	r3, [pc, #508]	; (19c4 <main+0xcb4>)
                            radio_data_arr[1] = snt_sys_temp_code;

                            mrr_send_radio_data(0);
    17c6:	2000      	movs	r0, #0
                        pmu_setting_temp_based(1);

                        if(xo_check_is_day()) {
                            // send beacon
                            reset_radio_data_arr();
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    17c8:	781b      	ldrb	r3, [r3, #0]
    17ca:	8811      	ldrh	r1, [r2, #0]
    17cc:	22dd      	movs	r2, #221	; 0xdd
    17ce:	0612      	lsls	r2, r2, #24
    17d0:	430a      	orrs	r2, r1
    17d2:	041b      	lsls	r3, r3, #16
    17d4:	431a      	orrs	r2, r3
    17d6:	4b7c      	ldr	r3, [pc, #496]	; (19c8 <main+0xcb8>)
    17d8:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = snt_sys_temp_code;
    17da:	4a6b      	ldr	r2, [pc, #428]	; (1988 <main+0xc78>)
    17dc:	6812      	ldr	r2, [r2, #0]
    17de:	605a      	str	r2, [r3, #4]

                            mrr_send_radio_data(0);
    17e0:	f7ff f8a8 	bl	934 <mrr_send_radio_data>

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
    17e4:	4b79      	ldr	r3, [pc, #484]	; (19cc <main+0xcbc>)
    17e6:	781a      	ldrb	r2, [r3, #0]
    17e8:	3201      	adds	r2, #1
    17ea:	b2d2      	uxtb	r2, r2
    17ec:	701a      	strb	r2, [r3, #0]
    17ee:	2a05      	cmp	r2, #5
    17f0:	d80f      	bhi.n	1812 <main+0xb02>
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    17f2:	4c74      	ldr	r4, [pc, #464]	; (19c4 <main+0xcb4>)
    17f4:	4b74      	ldr	r3, [pc, #464]	; (19c8 <main+0xcb8>)
    17f6:	7822      	ldrb	r2, [r4, #0]
                            radio_data_arr[1] = radio_beacon_counter;
                            radio_data_arr[2] = 0xFEED;

                            mrr_send_radio_data(1);
    17f8:	2001      	movs	r0, #1
                                    mrr_send_radio_data(0);
				}

                            }

                            radio_data_arr[0] = radio_counter;
    17fa:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = radio_beacon_counter;
    17fc:	4a73      	ldr	r2, [pc, #460]	; (19cc <main+0xcbc>)
    17fe:	7812      	ldrb	r2, [r2, #0]
    1800:	605a      	str	r2, [r3, #4]
                            radio_data_arr[2] = 0xFEED;
    1802:	4a73      	ldr	r2, [pc, #460]	; (19d0 <main+0xcc0>)
    1804:	609a      	str	r2, [r3, #8]

                            mrr_send_radio_data(1);
    1806:	f7ff f895 	bl	934 <mrr_send_radio_data>

                            radio_counter++;
    180a:	7823      	ldrb	r3, [r4, #0]
    180c:	3301      	adds	r3, #1
    180e:	7023      	strb	r3, [r4, #0]
    1810:	e045      	b.n	189e <main+0xb8e>

                            mrr_send_radio_data(0);

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
    1812:	2400      	movs	r4, #0
    1814:	701c      	strb	r4, [r3, #0]
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
    1816:	4b60      	ldr	r3, [pc, #384]	; (1998 <main+0xc88>)
    1818:	20b0      	movs	r0, #176	; 0xb0
    181a:	8819      	ldrh	r1, [r3, #0]
    181c:	f7fe fcca 	bl	1b4 <mbus_write_message32>
                                for(i = 0; i < mem_light_len; i += 2) {
    1820:	e016      	b.n	1850 <main+0xb40>
                                    reset_radio_data_arr();
    1822:	f7fe fd45 	bl	2b0 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    1826:	f7fe fcbf 	bl	1a8 <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
    182a:	4b5c      	ldr	r3, [pc, #368]	; (199c <main+0xc8c>)
    182c:	4d66      	ldr	r5, [pc, #408]	; (19c8 <main+0xcb8>)
    182e:	8819      	ldrh	r1, [r3, #0]
    1830:	2201      	movs	r2, #1
    1832:	1909      	adds	r1, r1, r4
    1834:	9200      	str	r2, [sp, #0]
    1836:	2006      	movs	r0, #6
    1838:	1c2b      	adds	r3, r5, #0
    183a:	f7fe fd23 	bl	284 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    183e:	f7fe fcad 	bl	19c <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    1842:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1844:	2000      	movs	r0, #0
                                for(i = 0; i < mem_light_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    1846:	b29b      	uxth	r3, r3
    1848:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    184a:	f7ff f873 	bl	934 <mrr_send_radio_data>
                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
                                for(i = 0; i < mem_light_len; i += 2) {
    184e:	3402      	adds	r4, #2
    1850:	4b51      	ldr	r3, [pc, #324]	; (1998 <main+0xc88>)
    1852:	881b      	ldrh	r3, [r3, #0]
    1854:	429c      	cmp	r4, r3
    1856:	dbe4      	blt.n	1822 <main+0xb12>
				    radio_data_arr[2] &= 0x0000FFFF;

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
    1858:	4b49      	ldr	r3, [pc, #292]	; (1980 <main+0xc70>)
    185a:	20b1      	movs	r0, #177	; 0xb1
    185c:	8819      	ldrh	r1, [r3, #0]
    185e:	f7fe fca9 	bl	1b4 <mbus_write_message32>
				for(i = 0; i < mem_temp_len; i += 2) {
    1862:	2400      	movs	r4, #0
    1864:	e016      	b.n	1894 <main+0xb84>
                                    reset_radio_data_arr();
    1866:	f7fe fd23 	bl	2b0 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    186a:	f7fe fc9d 	bl	1a8 <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
    186e:	4b45      	ldr	r3, [pc, #276]	; (1984 <main+0xc74>)
    1870:	4d55      	ldr	r5, [pc, #340]	; (19c8 <main+0xcb8>)
    1872:	8819      	ldrh	r1, [r3, #0]
    1874:	2201      	movs	r2, #1
    1876:	1909      	adds	r1, r1, r4
    1878:	9200      	str	r2, [sp, #0]
    187a:	2006      	movs	r0, #6
    187c:	1c2b      	adds	r3, r5, #0
    187e:	f7fe fd01 	bl	284 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    1882:	f7fe fc8b 	bl	19c <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    1886:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1888:	2000      	movs	r0, #0
				for(i = 0; i < mem_temp_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    188a:	b29b      	uxth	r3, r3
    188c:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    188e:	f7ff f851 	bl	934 <mrr_send_radio_data>

                                    mrr_send_radio_data(0);
                                }

				mbus_write_message32(0xB1, mem_temp_len);
				for(i = 0; i < mem_temp_len; i += 2) {
    1892:	3402      	adds	r4, #2
    1894:	4b3a      	ldr	r3, [pc, #232]	; (1980 <main+0xc70>)
    1896:	881b      	ldrh	r3, [r3, #0]
    1898:	429c      	cmp	r4, r3
    189a:	dbe4      	blt.n	1866 <main+0xb56>
    189c:	e7a9      	b.n	17f2 <main+0xae2>
                            mrr_send_radio_data(1);

                            radio_counter++;
                        }

                        set_next_time(SEND_RAD, 600); // FIXME: set to 600
    189e:	2002      	movs	r0, #2
    18a0:	2196      	movs	r1, #150	; 0x96
    18a2:	4081      	lsls	r1, r0
    18a4:	f7fe ffd0 	bl	848 <set_next_time>
                    }
                }
            }
        }
    } while(sys_run_continuous);
    18a8:	4b4a      	ldr	r3, [pc, #296]	; (19d4 <main+0xcc4>)
    18aa:	781c      	ldrb	r4, [r3, #0]
    18ac:	2c00      	cmp	r4, #0
    18ae:	d000      	beq.n	18b2 <main+0xba2>
    18b0:	e5bc      	b.n	142c <main+0x71c>

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    18b2:	f7fe ff99 	bl	7e8 <update_system_time>
            }
        }
    } while(sys_run_continuous);

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    18b6:	2601      	movs	r6, #1
    update_system_time();
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    18b8:	4a34      	ldr	r2, [pc, #208]	; (198c <main+0xc7c>)
        }
    } while(sys_run_continuous);

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    18ba:	1c23      	adds	r3, r4, #0
            }
        }
    } while(sys_run_continuous);

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    18bc:	4276      	negs	r6, r6
    update_system_time();
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    18be:	0099      	lsls	r1, r3, #2
    18c0:	5888      	ldr	r0, [r1, r2]
    18c2:	2800      	cmp	r0, #0
    18c4:	d003      	beq.n	18ce <main+0xbbe>
    18c6:	5888      	ldr	r0, [r1, r2]
    18c8:	42b0      	cmp	r0, r6
    18ca:	d800      	bhi.n	18ce <main+0xbbe>
	    min_time = xot_timer_list[i];
    18cc:	588e      	ldr	r6, [r1, r2]
    18ce:	3301      	adds	r3, #1

    // Find min time in system
    uint32_t min_time = 0xFFFFFFFF;
    update_system_time();
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    18d0:	2b03      	cmp	r3, #3
    18d2:	d1f4      	bne.n	18be <main+0xbae>
    	if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
	    min_time = xot_timer_list[i];
	}
    }

    if(lnt_start_meas == 1) {
    18d4:	4b2f      	ldr	r3, [pc, #188]	; (1994 <main+0xc84>)
    18d6:	781b      	ldrb	r3, [r3, #0]
    18d8:	2b01      	cmp	r3, #1
    18da:	d129      	bne.n	1930 <main+0xc20>
	uint32_t sleep_time;
	if(min_time == 0xFFFFFFFF) {
    18dc:	1c73      	adds	r3, r6, #1
    18de:	d003      	beq.n	18e8 <main+0xbd8>
	    sleep_time = 60;	// set arbitrary value so lnt counting time will default to 32
	}
	else {
	    sleep_time = min_time - xo_sys_time_in_sec;
    18e0:	4b3d      	ldr	r3, [pc, #244]	; (19d8 <main+0xcc8>)
    18e2:	681b      	ldr	r3, [r3, #0]
    18e4:	1af6      	subs	r6, r6, r3
    18e6:	e000      	b.n	18ea <main+0xbda>
    }

    if(lnt_start_meas == 1) {
	uint32_t sleep_time;
	if(min_time == 0xFFFFFFFF) {
	    sleep_time = 60;	// set arbitrary value so lnt counting time will default to 32
    18e8:	263c      	movs	r6, #60	; 0x3c
	}
	else {
	    sleep_time = min_time - xo_sys_time_in_sec;
	}
	mbus_write_message32(0xC0, sleep_time);
    18ea:	1c31      	adds	r1, r6, #0
    18ec:	20c0      	movs	r0, #192	; 0xc0
    18ee:	f7fe fc61 	bl	1b4 <mbus_write_message32>
	
	lnt_counter_base = 0;
    18f2:	4b3a      	ldr	r3, [pc, #232]	; (19dc <main+0xccc>)
    18f4:	2200      	movs	r2, #0
    18f6:	701a      	strb	r2, [r3, #0]
	uint32_t lnt_meas_time = LNT_MEAS_TIME;
	while(((lnt_meas_time << (lnt_counter_base + 1)) + 10 < sleep_time) && lnt_counter_base < 4) {
    18f8:	2120      	movs	r1, #32
    18fa:	e002      	b.n	1902 <main+0xbf2>
	    lnt_counter_base++;
    18fc:	781a      	ldrb	r2, [r3, #0]
    18fe:	3201      	adds	r2, #1
    1900:	701a      	strb	r2, [r3, #0]
	}
	mbus_write_message32(0xC0, sleep_time);
	
	lnt_counter_base = 0;
	uint32_t lnt_meas_time = LNT_MEAS_TIME;
	while(((lnt_meas_time << (lnt_counter_base + 1)) + 10 < sleep_time) && lnt_counter_base < 4) {
    1902:	781a      	ldrb	r2, [r3, #0]
    1904:	1c08      	adds	r0, r1, #0
    1906:	3201      	adds	r2, #1
    1908:	4090      	lsls	r0, r2
    190a:	1c02      	adds	r2, r0, #0
    190c:	320a      	adds	r2, #10
    190e:	1c1c      	adds	r4, r3, #0
    1910:	42b2      	cmp	r2, r6
    1912:	d202      	bcs.n	191a <main+0xc0a>
    1914:	781a      	ldrb	r2, [r3, #0]
    1916:	2a03      	cmp	r2, #3
    1918:	d9f0      	bls.n	18fc <main+0xbec>
	    lnt_counter_base++;
	}
	update_system_time();
    191a:	f7fe ff65 	bl	7e8 <update_system_time>
	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME << lnt_counter_base;
    191e:	4b2e      	ldr	r3, [pc, #184]	; (19d8 <main+0xcc8>)
	mbus_write_message32(0xC1, lnt_counter_base);
    1920:	20c1      	movs	r0, #193	; 0xc1
	uint32_t lnt_meas_time = LNT_MEAS_TIME;
	while(((lnt_meas_time << (lnt_counter_base + 1)) + 10 < sleep_time) && lnt_counter_base < 4) {
	    lnt_counter_base++;
	}
	update_system_time();
	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME << lnt_counter_base;
    1922:	681e      	ldr	r6, [r3, #0]
    1924:	7823      	ldrb	r3, [r4, #0]
    1926:	3620      	adds	r6, #32
	mbus_write_message32(0xC1, lnt_counter_base);
    1928:	7821      	ldrb	r1, [r4, #0]
	uint32_t lnt_meas_time = LNT_MEAS_TIME;
	while(((lnt_meas_time << (lnt_counter_base + 1)) + 10 < sleep_time) && lnt_counter_base < 4) {
	    lnt_counter_base++;
	}
	update_system_time();
	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME << lnt_counter_base;
    192a:	409e      	lsls	r6, r3
	mbus_write_message32(0xC1, lnt_counter_base);
    192c:	f7fe fc42 	bl	1b4 <mbus_write_message32>
    }

    if(min_time != 0xFFFFFFFF) {
    1930:	1c71      	adds	r1, r6, #1
    1932:	d100      	bne.n	1936 <main+0xc26>
    1934:	e0ca      	b.n	1acc <main+0xdbc>
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    1936:	2001      	movs	r0, #1
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1938:	4a14      	ldr	r2, [pc, #80]	; (198c <main+0xc7c>)
                xot_last_timer_list[i] = xot_timer_list[i];
    193a:	4920      	ldr	r1, [pc, #128]	; (19bc <main+0xcac>)
	update_system_time();
	min_time = xo_sys_time_in_sec + LNT_MEAS_TIME << lnt_counter_base;
	mbus_write_message32(0xC1, lnt_counter_base);
    }

    if(min_time != 0xFFFFFFFF) {
    193c:	2500      	movs	r5, #0
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
                xot_last_timer_list[i] = xot_timer_list[i];
                xot_timer_list[i] = 0xFFFFFFFF;
    193e:	4240      	negs	r0, r0
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	    if(xot_timer_list[i] != 0 && xot_timer_list[i] <= min_time) {
    1940:	00ab      	lsls	r3, r5, #2
    1942:	589c      	ldr	r4, [r3, r2]
    1944:	2c00      	cmp	r4, #0
    1946:	d005      	beq.n	1954 <main+0xc44>
    1948:	589c      	ldr	r4, [r3, r2]
    194a:	42b4      	cmp	r4, r6
    194c:	d802      	bhi.n	1954 <main+0xc44>
                xot_last_timer_list[i] = xot_timer_list[i];
    194e:	589c      	ldr	r4, [r3, r2]
    1950:	505c      	str	r4, [r3, r1]
                xot_timer_list[i] = 0xFFFFFFFF;
    1952:	5098      	str	r0, [r3, r2]
    1954:	3501      	adds	r5, #1
	mbus_write_message32(0xC1, lnt_counter_base);
    }

    if(min_time != 0xFFFFFFFF) {
	// set timer trigger so operations will trigger
	for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1956:	2d03      	cmp	r5, #3
    1958:	d1f2      	bne.n	1940 <main+0xc30>
    // mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    // delay(MBUS_DELAY*10);
}

static void set_lnt_timer(uint32_t end_time) {
    mbus_write_message32(0xEE, 0xFFFFAAAA);
    195a:	4921      	ldr	r1, [pc, #132]	; (19e0 <main+0xcd0>)
    195c:	20ee      	movs	r0, #238	; 0xee
    195e:	f7fe fc29 	bl	1b4 <mbus_write_message32>
    update_system_time();
    1962:	f7fe ff41 	bl	7e8 <update_system_time>
    if(end_time <= xo_sys_time_in_sec) {
    1966:	4b1c      	ldr	r3, [pc, #112]	; (19d8 <main+0xcc8>)
    1968:	681a      	ldr	r2, [r3, #0]
    196a:	4296      	cmp	r6, r2
    196c:	d83a      	bhi.n	19e4 <main+0xcd4>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
    196e:	20af      	movs	r0, #175	; 0xaf
    1970:	2100      	movs	r1, #0
    1972:	f7fe fc1f 	bl	1b4 <mbus_write_message32>
    operation_sleep_notimer();
    1976:	f7fe fda5 	bl	4c4 <operation_sleep_notimer>
    197a:	46c0      	nop			; (mov r8, r8)
    197c:	00001c26 	.word	0x00001c26
    1980:	00001c10 	.word	0x00001c10
    1984:	00001c3c 	.word	0x00001c3c
    1988:	00001c2c 	.word	0x00001c2c
    198c:	00001c54 	.word	0x00001c54
    1990:	00001c21 	.word	0x00001c21
    1994:	00001c84 	.word	0x00001c84
    1998:	00001c3e 	.word	0x00001c3e
    199c:	00001c02 	.word	0x00001c02
    19a0:	00001c48 	.word	0x00001c48
    19a4:	00001c08 	.word	0x00001c08
    19a8:	00001c04 	.word	0x00001c04
    19ac:	00001b78 	.word	0x00001b78
    19b0:	00001b28 	.word	0x00001b28
    19b4:	00001b50 	.word	0x00001b50
    19b8:	00001c42 	.word	0x00001c42
    19bc:	00001be8 	.word	0x00001be8
    19c0:	00001c28 	.word	0x00001c28
    19c4:	00001c23 	.word	0x00001c23
    19c8:	00001c30 	.word	0x00001c30
    19cc:	00001c40 	.word	0x00001c40
    19d0:	0000feed 	.word	0x0000feed
    19d4:	00001c41 	.word	0x00001c41
    19d8:	00001c1c 	.word	0x00001c1c
    19dc:	00001c71 	.word	0x00001c71
    19e0:	ffffaaaa 	.word	0xffffaaaa
    if(end_time <= xo_sys_time_in_sec) {
        sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
    }

    // TODO: set lnt timer
    if(!lnt_start_meas) {
    19e4:	4a3a      	ldr	r2, [pc, #232]	; (1ad0 <main+0xdc0>)
    19e6:	7812      	ldrb	r2, [r2, #0]
    19e8:	2a00      	cmp	r2, #0
    19ea:	d124      	bne.n	1a36 <main+0xd26>
	uint32_t val = (end_time - xo_sys_time_in_sec) * 1564;
    19ec:	681c      	ldr	r4, [r3, #0]
    19ee:	4b39      	ldr	r3, [pc, #228]	; (1ad4 <main+0xdc4>)
    19f0:	1b34      	subs	r4, r6, r4
    19f2:	435c      	muls	r4, r3
	mbus_remote_register_write(LNT_ADDR, 0x41, (val >> 24));
    19f4:	1c28      	adds	r0, r5, #0
    19f6:	0e22      	lsrs	r2, r4, #24
    19f8:	2141      	movs	r1, #65	; 0x41
	mbus_remote_register_write(LNT_ADDR, 0x42, val & 0xFFFFFF);
    19fa:	0224      	lsls	r4, r4, #8
    }

    // TODO: set lnt timer
    if(!lnt_start_meas) {
	uint32_t val = (end_time - xo_sys_time_in_sec) * 1564;
	mbus_remote_register_write(LNT_ADDR, 0x41, (val >> 24));
    19fc:	f7fe fc1b 	bl	236 <mbus_remote_register_write>
	mbus_remote_register_write(LNT_ADDR, 0x42, val & 0xFFFFFF);
    1a00:	0a22      	lsrs	r2, r4, #8
    1a02:	1c28      	adds	r0, r5, #0
    1a04:	2142      	movs	r1, #66	; 0x42
    1a06:	f7fe fc16 	bl	236 <mbus_remote_register_write>

	lntv1a_r40.WUP_ENABLE = 1;
    1a0a:	4b33      	ldr	r3, [pc, #204]	; (1ad8 <main+0xdc8>)
    1a0c:	2280      	movs	r2, #128	; 0x80
    1a0e:	6819      	ldr	r1, [r3, #0]
    1a10:	0412      	lsls	r2, r2, #16
    1a12:	430a      	orrs	r2, r1
    1a14:	601a      	str	r2, [r3, #0]
	lntv1a_r40.WUP_LC_IRQ_EN = 1;
    1a16:	6819      	ldr	r1, [r3, #0]
    1a18:	2280      	movs	r2, #128	; 0x80
    1a1a:	03d2      	lsls	r2, r2, #15
    1a1c:	430a      	orrs	r2, r1
    1a1e:	601a      	str	r2, [r3, #0]
	lntv1a_r40.WUP_AUTO_RESET = 1;
    1a20:	6819      	ldr	r1, [r3, #0]
    1a22:	2280      	movs	r2, #128	; 0x80
    1a24:	0392      	lsls	r2, r2, #14
    1a26:	430a      	orrs	r2, r1
    1a28:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(LNT_ADDR, 0x40, lntv1a_r40.as_int);
    1a2a:	681a      	ldr	r2, [r3, #0]
    1a2c:	1c28      	adds	r0, r5, #0
    1a2e:	2140      	movs	r1, #64	; 0x40
    1a30:	f7fe fc01 	bl	236 <mbus_remote_register_write>
    1a34:	e044      	b.n	1ac0 <main+0xdb0>
    }
    else {
	uint32_t val = (end_time - xo_sys_time_in_sec) * 8;
    1a36:	6819      	ldr	r1, [r3, #0]
    	lntv1a_r03.TIME_COUNTING = val;
    1a38:	4b28      	ldr	r3, [pc, #160]	; (1adc <main+0xdcc>)
	lntv1a_r40.WUP_LC_IRQ_EN = 1;
	lntv1a_r40.WUP_AUTO_RESET = 1;
	mbus_remote_register_write(LNT_ADDR, 0x40, lntv1a_r40.as_int);
    }
    else {
	uint32_t val = (end_time - xo_sys_time_in_sec) * 8;
    1a3a:	1a71      	subs	r1, r6, r1
    	lntv1a_r03.TIME_COUNTING = val;
    1a3c:	681a      	ldr	r2, [r3, #0]
    1a3e:	02c9      	lsls	r1, r1, #11
    1a40:	0e12      	lsrs	r2, r2, #24
    1a42:	0a09      	lsrs	r1, r1, #8
    1a44:	0612      	lsls	r2, r2, #24
    1a46:	430a      	orrs	r2, r1
    1a48:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1a4a:	681a      	ldr	r2, [r3, #0]
    1a4c:	1c29      	adds	r1, r5, #0
    1a4e:	1c28      	adds	r0, r5, #0
    1a50:	f7fe fbf1 	bl	236 <mbus_remote_register_write>
	delay(MBUS_DELAY*10);
    1a54:	20fa      	movs	r0, #250	; 0xfa
    1a56:	0080      	lsls	r0, r0, #2
    1a58:	f7fe fb25 	bl	a6 <delay>
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1a5c:	4c20      	ldr	r4, [pc, #128]	; (1ae0 <main+0xdd0>)
    1a5e:	2208      	movs	r2, #8
    1a60:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a62:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1a64:	4393      	bics	r3, r2
    1a66:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    1a68:	7823      	ldrb	r3, [r4, #0]
    1a6a:	2204      	movs	r2, #4
    1a6c:	4313      	orrs	r3, r2
    1a6e:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a70:	6822      	ldr	r2, [r4, #0]
    1a72:	1c28      	adds	r0, r5, #0
    1a74:	f7fe fbdf 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1a78:	20fa      	movs	r0, #250	; 0xfa
    1a7a:	0080      	lsls	r0, r0, #2
    1a7c:	f7fe fb13 	bl	a6 <delay>
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    1a80:	7823      	ldrb	r3, [r4, #0]
    1a82:	2210      	movs	r2, #16
    1a84:	4313      	orrs	r3, r2
    1a86:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1a88:	7823      	ldrb	r3, [r4, #0]
    1a8a:	2740      	movs	r7, #64	; 0x40
    1a8c:	43bb      	bics	r3, r7
    1a8e:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1a90:	7823      	ldrb	r3, [r4, #0]
    1a92:	2220      	movs	r2, #32
    1a94:	4393      	bics	r3, r2
    1a96:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1a98:	6822      	ldr	r2, [r4, #0]
    1a9a:	2100      	movs	r1, #0
    1a9c:	1c28      	adds	r0, r5, #0
    1a9e:	f7fe fbca 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1aa2:	20fa      	movs	r0, #250	; 0xfa
    1aa4:	0080      	lsls	r0, r0, #2
    1aa6:	f7fe fafe 	bl	a6 <delay>

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1aaa:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1aac:	1c28      	adds	r0, r5, #0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1aae:	431f      	orrs	r7, r3
    1ab0:	7027      	strb	r7, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1ab2:	6822      	ldr	r2, [r4, #0]
    1ab4:	2100      	movs	r1, #0
    1ab6:	f7fe fbbe 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1aba:	480a      	ldr	r0, [pc, #40]	; (1ae4 <main+0xdd4>)
    1abc:	f7fe faf3 	bl	a6 <delay>
    	lntv1a_r03.TIME_COUNTING = val;
	mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
	delay(MBUS_DELAY*10);
	lnt_start();
    }
    mbus_write_message32(0xCE, end_time - xo_sys_time_in_sec);
    1ac0:	4b09      	ldr	r3, [pc, #36]	; (1ae8 <main+0xdd8>)
    1ac2:	20ce      	movs	r0, #206	; 0xce
    1ac4:	6819      	ldr	r1, [r3, #0]
    1ac6:	1a71      	subs	r1, r6, r1
    1ac8:	f7fe fb74 	bl	1b4 <mbus_write_message32>
	    }
	}
	set_lnt_timer(min_time);
    }

    operation_sleep();
    1acc:	f7fe fcea 	bl	4a4 <operation_sleep>
    1ad0:	00001c84 	.word	0x00001c84
    1ad4:	0000061c 	.word	0x0000061c
    1ad8:	00001ba8 	.word	0x00001ba8
    1adc:	00001bb0 	.word	0x00001bb0
    1ae0:	00001b80 	.word	0x00001b80
    1ae4:	00002710 	.word	0x00002710
    1ae8:	00001c1c 	.word	0x00001c1c
