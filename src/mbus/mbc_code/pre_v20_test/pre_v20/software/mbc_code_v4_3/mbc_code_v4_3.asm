
mbc_code_v4_3/mbc_code_v4_3.elf:     file format elf32-littlearm


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
  40:	000010c1 	.word	0x000010c1
  44:	00000000 	.word	0x00000000
  48:	000010cd 	.word	0x000010cd
  4c:	000010e5 	.word	0x000010e5
	...
  60:	00001119 	.word	0x00001119
  64:	00001129 	.word	0x00001129
  68:	00001139 	.word	0x00001139
  6c:	00001149 	.word	0x00001149
	...
  8c:	00001105 	.word	0x00001105

00000090 <hang>:
  90:	e7fe      	b.n	90 <hang>
	...

000000a0 <_start>:
  a0:	f001 f85a 	bl	1158 <main>
  a4:	e7fc      	b.n	a0 <_start>
	...

000000a8 <__aeabi_llsr>:
  a8:	e2523020 	subs	r3, r2, #32
  ac:	e262c020 	rsb	ip, r2, #32
  b0:	41a00230 	lsrmi	r0, r0, r2
  b4:	51a00331 	lsrpl	r0, r1, r3
  b8:	41800c11 	orrmi	r0, r0, r1, lsl ip
  bc:	e1a01231 	lsr	r1, r1, r2
  c0:	e12fff1e 	bx	lr

000000c4 <__aeabi_llsl>:
  c4:	e2523020 	subs	r3, r2, #32
  c8:	e262c020 	rsb	ip, r2, #32
  cc:	41a01211 	lslmi	r1, r1, r2
  d0:	51a01310 	lslpl	r1, r0, r3
  d4:	41811c30 	orrmi	r1, r1, r0, lsr ip
  d8:	e1a00210 	lsl	r0, r0, r2
  dc:	e12fff1e 	bx	lr

000000e0 <__aeabi_lmul>:
  e0:	e0010192 	mul	r1, r2, r1
  e4:	e0211390 	mla	r1, r0, r3, r1
  e8:	e52d4004 	push	{r4}		; (str r4, [sp, #-4]!)
  ec:	e1a03820 	lsr	r3, r0, #16
  f0:	e1a0c822 	lsr	ip, r2, #16
  f4:	e1c04803 	bic	r4, r0, r3, lsl #16
  f8:	e1c2280c 	bic	r2, r2, ip, lsl #16
  fc:	e0000294 	mul	r0, r4, r2
 100:	e0020293 	mul	r2, r3, r2
 104:	e004049c 	mul	r4, ip, r4
 108:	e00c0c93 	mul	ip, r3, ip
 10c:	e0924004 	adds	r4, r2, r4
 110:	228cc801 	addcs	ip, ip, #65536	; 0x10000
 114:	e0900804 	adds	r0, r0, r4, lsl #16
 118:	e0acc824 	adc	ip, ip, r4, lsr #16
 11c:	e081100c 	add	r1, r1, ip
 120:	e8bd0010 	ldmfd	sp!, {r4}
 124:	e12fff1e 	bx	lr

Disassembly of section .text.delay:

00000128 <delay>:

//*******************************************************************
// OTHER FUNCTIONS
//*******************************************************************

void delay(unsigned ticks){
 128:	b500      	push	{lr}
  unsigned i;
  for (i=0; i < ticks; i++)
 12a:	2300      	movs	r3, #0
 12c:	e001      	b.n	132 <delay+0xa>
    asm("nop;");
 12e:	46c0      	nop			; (mov r8, r8)
// OTHER FUNCTIONS
//*******************************************************************

void delay(unsigned ticks){
  unsigned i;
  for (i=0; i < ticks; i++)
 130:	3301      	adds	r3, #1
 132:	4283      	cmp	r3, r0
 134:	d1fb      	bne.n	12e <delay+0x6>
    asm("nop;");
}
 136:	bd00      	pop	{pc}

Disassembly of section .text.WFI:

00000138 <WFI>:

void WFI(){
  asm("wfi;");
 138:	bf30      	wfi
}
 13a:	4770      	bx	lr

Disassembly of section .text.config_timer32:

0000013c <config_timer32>:
	*TIMER16_CNT   = cnt;
	*TIMER16_STAT  = status;
	*TIMER16_GO    = 0x1;
}

void config_timer32(uint32_t cmp, uint8_t roi, uint32_t cnt, uint32_t status){
 13c:	b530      	push	{r4, r5, lr}
	*TIMER32_GO   = 0x0;
 13e:	4c07      	ldr	r4, [pc, #28]	; (15c <config_timer32+0x20>)
 140:	2500      	movs	r5, #0
 142:	6025      	str	r5, [r4, #0]
	*TIMER32_CMP  = cmp;
 144:	4d06      	ldr	r5, [pc, #24]	; (160 <config_timer32+0x24>)
 146:	6028      	str	r0, [r5, #0]
	*TIMER32_ROI  = roi;
 148:	4806      	ldr	r0, [pc, #24]	; (164 <config_timer32+0x28>)
 14a:	6001      	str	r1, [r0, #0]
	*TIMER32_CNT  = cnt;
 14c:	4906      	ldr	r1, [pc, #24]	; (168 <config_timer32+0x2c>)
 14e:	600a      	str	r2, [r1, #0]
	*TIMER32_STAT = status;
 150:	4a06      	ldr	r2, [pc, #24]	; (16c <config_timer32+0x30>)
 152:	6013      	str	r3, [r2, #0]
	*TIMER32_GO   = 0x1;
 154:	2301      	movs	r3, #1
 156:	6023      	str	r3, [r4, #0]
}
 158:	bd30      	pop	{r4, r5, pc}
 15a:	46c0      	nop			; (mov r8, r8)
 15c:	a0001100 	.word	0xa0001100
 160:	a0001104 	.word	0xa0001104
 164:	a0001108 	.word	0xa0001108
 168:	a000110c 	.word	0xa000110c
 16c:	a0001110 	.word	0xa0001110

Disassembly of section .text.set_wakeup_timer:

00000170 <set_wakeup_timer>:

void enable_timerwd(){
	*TIMERWD_GO  = 0x1;
}

void set_wakeup_timer( uint32_t timestamp, uint8_t irq_en, uint8_t reset ){
 170:	b500      	push	{lr}
	uint32_t regval = timestamp;
	if( irq_en ) regval |= 0x800000; // IRQ in Sleep-Only
 172:	2900      	cmp	r1, #0
 174:	d003      	beq.n	17e <set_wakeup_timer+0xe>
 176:	2380      	movs	r3, #128	; 0x80
 178:	041b      	lsls	r3, r3, #16
 17a:	4318      	orrs	r0, r3
 17c:	e001      	b.n	182 <set_wakeup_timer+0x12>
	else		 regval &= 0x3FFFFF;
 17e:	0280      	lsls	r0, r0, #10
 180:	0a80      	lsrs	r0, r0, #10
    *REG_WUPT_CONFIG = regval;
 182:	4b04      	ldr	r3, [pc, #16]	; (194 <set_wakeup_timer+0x24>)
 184:	6018      	str	r0, [r3, #0]

	if( reset ) *WUPT_RESET = 0x01;
 186:	2a00      	cmp	r2, #0
 188:	d002      	beq.n	190 <set_wakeup_timer+0x20>
 18a:	4b03      	ldr	r3, [pc, #12]	; (198 <set_wakeup_timer+0x28>)
 18c:	2201      	movs	r2, #1
 18e:	601a      	str	r2, [r3, #0]
}
 190:	bd00      	pop	{pc}
 192:	46c0      	nop			; (mov r8, r8)
 194:	a0000044 	.word	0xa0000044
 198:	a0001300 	.word	0xa0001300

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

Disassembly of section .text.long_int_mult:

000002b0 <long_int_mult>:
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
    }
}

static void long_int_mult(const long_int lhs, const uint16_t rhs, long_int res) {
 2b0:	b5f0      	push	{r4, r5, r6, r7, lr}
 2b2:	2400      	movs	r4, #0
 2b4:	b089      	sub	sp, #36	; 0x24
 2b6:	1c07      	adds	r7, r0, #0
 2b8:	9103      	str	r1, [sp, #12]
 2ba:	1c15      	adds	r5, r2, #0
    uint32_t carry_in = 0;
 2bc:	1c26      	adds	r6, r4, #0
    uint32_t temp_res[LONG_INT_LEN];
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        uint64_t temp = ((uint64_t) lhs[i] * rhs) + carry_in;
 2be:	2100      	movs	r1, #0
 2c0:	5938      	ldr	r0, [r7, r4]
 2c2:	9a03      	ldr	r2, [sp, #12]
 2c4:	1c0b      	adds	r3, r1, #0
 2c6:	f000 f81b 	bl	300 <____aeabi_lmul_from_thumb>
 2ca:	2200      	movs	r2, #0
 2cc:	9600      	str	r6, [sp, #0]
 2ce:	9201      	str	r2, [sp, #4]
 2d0:	9a00      	ldr	r2, [sp, #0]
 2d2:	9b01      	ldr	r3, [sp, #4]
 2d4:	1880      	adds	r0, r0, r2
 2d6:	4159      	adcs	r1, r3
        carry_in = temp >> 32;
        temp_res[i] = temp & 0xFFFFFFFF;
 2d8:	2310      	movs	r3, #16
 2da:	191b      	adds	r3, r3, r4
 2dc:	466a      	mov	r2, sp
 2de:	3404      	adds	r4, #4
    uint32_t carry_in = 0;
    uint32_t temp_res[LONG_INT_LEN];
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        uint64_t temp = ((uint64_t) lhs[i] * rhs) + carry_in;
        carry_in = temp >> 32;
 2e0:	1c0e      	adds	r6, r1, #0
        temp_res[i] = temp & 0xFFFFFFFF;
 2e2:	5098      	str	r0, [r3, r2]

static void long_int_mult(const long_int lhs, const uint16_t rhs, long_int res) {
    uint32_t carry_in = 0;
    uint32_t temp_res[LONG_INT_LEN];
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
 2e4:	2c10      	cmp	r4, #16
 2e6:	d1ea      	bne.n	2be <long_int_mult+0xe>
typedef uint32_t* long_int;

static void long_int_assign(long_int dest, const long_int src) {
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
 2e8:	9b04      	ldr	r3, [sp, #16]
 2ea:	9a05      	ldr	r2, [sp, #20]
 2ec:	602b      	str	r3, [r5, #0]
 2ee:	606a      	str	r2, [r5, #4]
 2f0:	9b06      	ldr	r3, [sp, #24]
 2f2:	9a07      	ldr	r2, [sp, #28]
 2f4:	60ab      	str	r3, [r5, #8]
 2f6:	60ea      	str	r2, [r5, #12]
        uint64_t temp = ((uint64_t) lhs[i] * rhs) + carry_in;
        carry_in = temp >> 32;
        temp_res[i] = temp & 0xFFFFFFFF;
    }
    long_int_assign(res, temp_res);
}
 2f8:	b009      	add	sp, #36	; 0x24
 2fa:	bdf0      	pop	{r4, r5, r6, r7, pc}
 2fc:	0000      	movs	r0, r0
	...

00000300 <____aeabi_lmul_from_thumb>:
 300:	4778      	bx	pc
 302:	46c0      	nop			; (mov r8, r8)
 304:	eaffff75 	b	e0 <__aeabi_lmul>

Disassembly of section .text.reset_radio_data_arr:

00000308 <reset_radio_data_arr>:
 * MRR functions (MRRv7)
 **********************************************/

static void reset_radio_data_arr() {
    uint8_t i;
    for(i = 0; i < 3; i++) { radio_data_arr[i] = 0; }
 308:	4b02      	ldr	r3, [pc, #8]	; (314 <reset_radio_data_arr+0xc>)
 30a:	2200      	movs	r2, #0
 30c:	601a      	str	r2, [r3, #0]
 30e:	605a      	str	r2, [r3, #4]
 310:	609a      	str	r2, [r3, #8]
}
 312:	4770      	bx	lr
 314:	00001d9c 	.word	0x00001d9c

Disassembly of section .text.radio_power_off:

00000318 <radio_power_off>:
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    delay(MBUS_DELAY*5); // Freq stab

}

static void radio_power_off() {
 318:	b5f8      	push	{r3, r4, r5, r6, r7, lr}

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 31a:	4c2c      	ldr	r4, [pc, #176]	; (3cc <radio_power_off+0xb4>)
 31c:	2601      	movs	r6, #1
 31e:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 320:	2002      	movs	r0, #2

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 322:	43b3      	bics	r3, r6
 324:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 326:	6822      	ldr	r2, [r4, #0]
 328:	2100      	movs	r1, #0
 32a:	f7ff ff84 	bl	236 <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 32e:	6823      	ldr	r3, [r4, #0]
 330:	227e      	movs	r2, #126	; 0x7e
 332:	4393      	bics	r3, r2
 334:	2220      	movs	r2, #32
 336:	4313      	orrs	r3, r2
 338:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 33a:	6822      	ldr	r2, [r4, #0]
 33c:	2002      	movs	r0, #2
 33e:	2100      	movs	r1, #0
 340:	f7ff ff79 	bl	236 <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 344:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 346:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 348:	4333      	orrs	r3, r6
 34a:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 34c:	6822      	ldr	r2, [r4, #0]
 34e:	2100      	movs	r1, #0
 350:	f7ff ff71 	bl	236 <mbus_remote_register_write>

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 354:	4b1e      	ldr	r3, [pc, #120]	; (3d0 <radio_power_off+0xb8>)
 356:	4a1f      	ldr	r2, [pc, #124]	; (3d4 <radio_power_off+0xbc>)
 358:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 35a:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 35c:	400a      	ands	r2, r1
 35e:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 360:	681a      	ldr	r2, [r3, #0]
 362:	2103      	movs	r1, #3
 364:	f7ff ff67 	bl	236 <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 368:	4b1b      	ldr	r3, [pc, #108]	; (3d8 <radio_power_off+0xc0>)
 36a:	2704      	movs	r7, #4
 36c:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 36e:	2502      	movs	r5, #2

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 370:	43ba      	bics	r2, r7
 372:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 374:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 376:	1c28      	adds	r0, r5, #0
    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 378:	43aa      	bics	r2, r5
 37a:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 37c:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 37e:	2111      	movs	r1, #17
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 380:	4332      	orrs	r2, r6
 382:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 384:	681a      	ldr	r2, [r3, #0]
 386:	f7ff ff56 	bl	236 <mbus_remote_register_write>

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 38a:	4c14      	ldr	r4, [pc, #80]	; (3dc <radio_power_off+0xc4>)
 38c:	2208      	movs	r2, #8
 38e:	6823      	ldr	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 390:	1c28      	adds	r0, r5, #0
    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 392:	4313      	orrs	r3, r2
 394:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
 396:	6823      	ldr	r3, [r4, #0]
 398:	2220      	movs	r2, #32
 39a:	4393      	bics	r3, r2
 39c:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
 39e:	6823      	ldr	r3, [r4, #0]
 3a0:	2210      	movs	r2, #16
 3a2:	4313      	orrs	r3, r2
 3a4:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 3a6:	1c39      	adds	r1, r7, #0
 3a8:	6822      	ldr	r2, [r4, #0]
 3aa:	f7ff ff44 	bl	236 <mbus_remote_register_write>

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 3ae:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 3b0:	1c28      	adds	r0, r5, #0
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 3b2:	43b3      	bics	r3, r6
 3b4:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 3b6:	6822      	ldr	r2, [r4, #0]
 3b8:	1c39      	adds	r1, r7, #0
 3ba:	f7ff ff3c 	bl	236 <mbus_remote_register_write>

    radio_on = 0;
 3be:	4a08      	ldr	r2, [pc, #32]	; (3e0 <radio_power_off+0xc8>)
 3c0:	2300      	movs	r3, #0
 3c2:	7013      	strb	r3, [r2, #0]
    radio_ready = 0;
 3c4:	4a07      	ldr	r2, [pc, #28]	; (3e4 <radio_power_off+0xcc>)
 3c6:	7013      	strb	r3, [r2, #0]

}
 3c8:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 3ca:	46c0      	nop			; (mov r8, r8)
 3cc:	00001d44 	.word	0x00001d44
 3d0:	00001d48 	.word	0x00001d48
 3d4:	ffefffff 	.word	0xffefffff
 3d8:	00001d50 	.word	0x00001d50
 3dc:	00001d4c 	.word	0x00001d4c
 3e0:	00001de2 	.word	0x00001de2
 3e4:	00001d7e 	.word	0x00001d7e

Disassembly of section .text.pmu_reg_write:

000003e8 <pmu_reg_write>:


/**********************************************
 * PMU functions (PMUv11)
 **********************************************/
static void pmu_reg_write(uint32_t reg_addr, uint32_t reg_data) {
 3e8:	b538      	push	{r3, r4, r5, lr}
 3ea:	1c05      	adds	r5, r0, #0
 3ec:	1c0c      	adds	r4, r1, #0
    set_halt_until_mbus_trx();
 3ee:	f7ff fedb 	bl	1a8 <set_halt_until_mbus_trx>
    mbus_remote_register_write(PMU_ADDR, reg_addr, reg_data);
 3f2:	b2e9      	uxtb	r1, r5
 3f4:	2005      	movs	r0, #5
 3f6:	1c22      	adds	r2, r4, #0
 3f8:	f7ff ff1d 	bl	236 <mbus_remote_register_write>
    set_halt_until_mbus_tx();
 3fc:	f7ff fece 	bl	19c <set_halt_until_mbus_tx>
}
 400:	bd38      	pop	{r3, r4, r5, pc}

Disassembly of section .text.pmu_set_active_clk:

00000402 <pmu_set_active_clk>:
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
 402:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
 404:	1c04      	adds	r4, r0, #0
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 406:	0e25      	lsrs	r5, r4, #24
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    mbus_write_message32(0xDE, setting);
 408:	1c21      	adds	r1, r4, #0
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 40a:	26ff      	movs	r6, #255	; 0xff
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 40c:	026d      	lsls	r5, r5, #9
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 40e:	1c27      	adds	r7, r4, #0
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    mbus_write_message32(0xDE, setting);
 410:	20de      	movs	r0, #222	; 0xde
 412:	f7ff fecf 	bl	1b4 <mbus_write_message32>
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 416:	4037      	ands	r7, r6
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 418:	9500      	str	r5, [sp, #0]
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 41a:	1c2a      	adds	r2, r5, #0
 41c:	23c0      	movs	r3, #192	; 0xc0
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 41e:	0a25      	lsrs	r5, r4, #8
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 420:	4035      	ands	r5, r6
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 422:	021b      	lsls	r3, r3, #8
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 424:	017f      	lsls	r7, r7, #5
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 426:	431a      	orrs	r2, r3
                 (r <<  9) |    // frequency multiplier r
 428:	432f      	orrs	r7, r5
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 42a:	4317      	orrs	r7, r2
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 42c:	0c24      	lsrs	r4, r4, #16

    mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 42e:	1c39      	adds	r1, r7, #0
 430:	2016      	movs	r0, #22
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 432:	4026      	ands	r6, r4
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 434:	9201      	str	r2, [sp, #4]
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 436:	0176      	lsls	r6, r6, #5

    mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 438:	f7ff ffd6 	bl	3e8 <pmu_reg_write>
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 43c:	1c39      	adds	r1, r7, #0
 43e:	2016      	movs	r0, #22
 440:	f7ff ffd2 	bl	3e8 <pmu_reg_write>
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 444:	9b01      	ldr	r3, [sp, #4]

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 446:	1c31      	adds	r1, r6, #0
 448:	4329      	orrs	r1, r5
                 (l <<  5) |    // frequency multiplier l
 44a:	4319      	orrs	r1, r3
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
 44c:	2018      	movs	r0, #24
 44e:	f7ff ffcb 	bl	3e8 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 452:	9a00      	ldr	r2, [sp, #0]
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 454:	201a      	movs	r0, #26
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 456:	4316      	orrs	r6, r2
                 (l <<  5) |    // frequency multiplier l
 458:	1c31      	adds	r1, r6, #0
 45a:	4329      	orrs	r1, r5
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 45c:	f7ff ffc4 	bl	3e8 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
 460:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.pmu_set_sar_conversion_ratio:

00000462 <pmu_set_sar_conversion_ratio>:
static void pmu_set_sleep_low() {
    pmu_set_sleep_clk(0x02010101);
    // pmu_set_sleep_clk(0x2, 0x1, 0x1, 0x1/*V1P2*/);
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
 462:	b510      	push	{r4, lr}
 464:	1c04      	adds	r4, r0, #0
    uint8_t i;
    for(i = 0; i < 2; i++) {
	    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 466:	1c21      	adds	r1, r4, #0
 468:	2005      	movs	r0, #5
 46a:	f7ff ffbd 	bl	3e8 <pmu_reg_write>
		     (0 << 12) |    // let vdd_clk always connect to vbat
		     (i << 11) |    // enable override setting [10] (1'h0)
		     (0 << 10) |    // have the converter have the periodic reset (1'h0)
		     (i <<  9) |    // enable override setting [8:0] (1'h0)
		     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
		     (i <<  7) |    // enable override setting [6:0] (1'h0)
 46e:	21aa      	movs	r1, #170	; 0xaa
 470:	0189      	lsls	r1, r1, #6
 472:	4321      	orrs	r1, r4
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
    uint8_t i;
    for(i = 0; i < 2; i++) {
	    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 474:	2005      	movs	r0, #5
 476:	f7ff ffb7 	bl	3e8 <pmu_reg_write>
		     (i <<  9) |    // enable override setting [8:0] (1'h0)
		     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
		     (i <<  7) |    // enable override setting [6:0] (1'h0)
		     (ratio)));  // binary converter's conversion ratio (7'h00)
    }
}
 47a:	bd10      	pop	{r4, pc}

Disassembly of section .text.pmu_setting_temp_based:

0000047c <pmu_setting_temp_based>:

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 47c:	b5f0      	push	{r4, r5, r6, r7, lr}
    int8_t i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
 47e:	492e      	ldr	r1, [pc, #184]	; (538 <pmu_setting_temp_based+0xbc>)
 480:	2313      	movs	r3, #19
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 482:	4d2e      	ldr	r5, [pc, #184]	; (53c <pmu_setting_temp_based+0xc0>)
    int8_t i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
 484:	600b      	str	r3, [r1, #0]
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 486:	b085      	sub	sp, #20
    int8_t i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
 488:	2200      	movs	r2, #0
    for(i = PMU_SETTINGS_LEN - 1; i >= 0; i--) {
 48a:	2306      	movs	r3, #6
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 48c:	18ac      	adds	r4, r5, r2
    int8_t i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
    for(i = PMU_SETTINGS_LEN - 1; i >= 0; i--) {
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i]) {
 48e:	69a6      	ldr	r6, [r4, #24]
 490:	680f      	ldr	r7, [r1, #0]
 492:	1c0c      	adds	r4, r1, #0
 494:	42b7      	cmp	r7, r6
 496:	d343      	bcc.n	520 <pmu_setting_temp_based+0xa4>
            if(mode == 0) {
 498:	2800      	cmp	r0, #0
 49a:	d107      	bne.n	4ac <pmu_setting_temp_based+0x30>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 49c:	b25c      	sxtb	r4, r3
 49e:	4b28      	ldr	r3, [pc, #160]	; (540 <pmu_setting_temp_based+0xc4>)
 4a0:	00a2      	lsls	r2, r4, #2
 4a2:	58d0      	ldr	r0, [r2, r3]
 4a4:	f7ff ffad 	bl	402 <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
 4a8:	4b26      	ldr	r3, [pc, #152]	; (544 <pmu_setting_temp_based+0xc8>)
 4aa:	e037      	b.n	51c <pmu_setting_temp_based+0xa0>
            }
            else if(mode == 2) {
 4ac:	2802      	cmp	r0, #2
 4ae:	d12b      	bne.n	508 <pmu_setting_temp_based+0x8c>
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 4b0:	b25b      	sxtb	r3, r3
 4b2:	009a      	lsls	r2, r3, #2
 4b4:	9301      	str	r3, [sp, #4]
 4b6:	4b24      	ldr	r3, [pc, #144]	; (548 <pmu_setting_temp_based+0xcc>)
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 4b8:	27c0      	movs	r7, #192	; 0xc0
            if(mode == 0) {
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
            }
            else if(mode == 2) {
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 4ba:	58d4      	ldr	r4, [r2, r3]
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 4bc:	023f      	lsls	r7, r7, #8
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 4be:	0e25      	lsrs	r5, r4, #24

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 4c0:	026d      	lsls	r5, r5, #9
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 4c2:	26ff      	movs	r6, #255	; 0xff
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 4c4:	432f      	orrs	r7, r5
                 (r <<  9) |    // frequency multiplier r
 4c6:	9502      	str	r5, [sp, #8]
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 4c8:	0c25      	lsrs	r5, r4, #16
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 4ca:	4035      	ands	r5, r6
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 4cc:	016d      	lsls	r5, r5, #5
 4ce:	9503      	str	r5, [sp, #12]

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 4d0:	9903      	ldr	r1, [sp, #12]
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 4d2:	0a25      	lsrs	r5, r4, #8
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 4d4:	4035      	ands	r5, r6

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 4d6:	4329      	orrs	r1, r5
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 4d8:	4339      	orrs	r1, r7
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 4da:	2017      	movs	r0, #23
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 4dc:	4034      	ands	r4, r6
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 4de:	f7ff ff83 	bl	3e8 <pmu_reg_write>
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 4e2:	0161      	lsls	r1, r4, #5
                ((0 << 19) |    // enable pdm even during periodic reset
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
 4e4:	4329      	orrs	r1, r5
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 4e6:	4339      	orrs	r1, r7
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
 4e8:	2015      	movs	r0, #21
 4ea:	f7ff ff7d 	bl	3e8 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 4ee:	9a03      	ldr	r2, [sp, #12]
 4f0:	9902      	ldr	r1, [sp, #8]
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 4f2:	2019      	movs	r0, #25
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 4f4:	4311      	orrs	r1, r2
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 4f6:	4329      	orrs	r1, r5
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 4f8:	f7ff ff76 	bl	3e8 <pmu_reg_write>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
            }
            else if(mode == 2) {
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
                pmu_set_sar_conversion_ratio(PMU_SLEEP_SAR_SETTINGS[i]);
 4fc:	4b13      	ldr	r3, [pc, #76]	; (54c <pmu_setting_temp_based+0xd0>)
 4fe:	9a01      	ldr	r2, [sp, #4]
 500:	5c98      	ldrb	r0, [r3, r2]
 502:	f7ff ffae 	bl	462 <pmu_set_sar_conversion_ratio>
 506:	e011      	b.n	52c <pmu_setting_temp_based+0xb0>
            }
            else if(snt_sys_temp_code < PMU_TEMP_THRESH[2]) { 
 508:	6822      	ldr	r2, [r4, #0]
 50a:	2a09      	cmp	r2, #9
 50c:	d911      	bls.n	532 <pmu_setting_temp_based+0xb6>
                return; 
            }
            else {
	        pmu_set_active_clk(PMU_RADIO_SETTINGS[i]);
 50e:	b25c      	sxtb	r4, r3
 510:	4b0f      	ldr	r3, [pc, #60]	; (550 <pmu_setting_temp_based+0xd4>)
 512:	00a2      	lsls	r2, r4, #2
 514:	58d0      	ldr	r0, [r2, r3]
 516:	f7ff ff74 	bl	402 <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_RADIO_SAR_SETTINGS[i]);
 51a:	4b0e      	ldr	r3, [pc, #56]	; (554 <pmu_setting_temp_based+0xd8>)
 51c:	5d18      	ldrb	r0, [r3, r4]
 51e:	e7f0      	b.n	502 <pmu_setting_temp_based+0x86>
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    snt_sys_temp_code = 19; // FIXME: set this to the data from the temp meas
    for(i = PMU_SETTINGS_LEN - 1; i >= 0; i--) {
 520:	3b01      	subs	r3, #1
 522:	b2db      	uxtb	r3, r3
 524:	3a04      	subs	r2, #4
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i]) {
 526:	2b00      	cmp	r3, #0
 528:	d1b0      	bne.n	48c <pmu_setting_temp_based+0x10>
 52a:	e7b5      	b.n	498 <pmu_setting_temp_based+0x1c>
                pmu_set_sar_conversion_ratio(PMU_RADIO_SAR_SETTINGS[i]);
            }
            break;
        }
    }
    delay(MBUS_DELAY);
 52c:	2064      	movs	r0, #100	; 0x64
 52e:	f7ff fdfb 	bl	128 <delay>
}
 532:	b005      	add	sp, #20
 534:	bdf0      	pop	{r4, r5, r6, r7, pc}
 536:	46c0      	nop			; (mov r8, r8)
 538:	00001d30 	.word	0x00001d30
 53c:	00001cb0 	.word	0x00001cb0
 540:	00001ccc 	.word	0x00001ccc
 544:	00001c8b 	.word	0x00001c8b
 548:	00001cf4 	.word	0x00001cf4
 54c:	00001c84 	.word	0x00001c84
 550:	00001c94 	.word	0x00001c94
 554:	00001d10 	.word	0x00001d10

Disassembly of section .text.operation_sleep:

00000558 <operation_sleep>:

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
 558:	b508      	push	{r3, lr}
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;
 55a:	2200      	movs	r2, #0
 55c:	238c      	movs	r3, #140	; 0x8c
 55e:	601a      	str	r2, [r3, #0]

#ifdef USE_MRR
    if(radio_on) {
 560:	4b04      	ldr	r3, [pc, #16]	; (574 <operation_sleep+0x1c>)
 562:	781b      	ldrb	r3, [r3, #0]
 564:	4293      	cmp	r3, r2
 566:	d001      	beq.n	56c <operation_sleep+0x14>
    	radio_power_off();
 568:	f7ff fed6 	bl	318 <radio_power_off>
    }
#endif

    mbus_sleep_all();
 56c:	f7ff fe4c 	bl	208 <mbus_sleep_all>
 570:	e7fe      	b.n	570 <operation_sleep+0x18>
 572:	46c0      	nop			; (mov r8, r8)
 574:	00001de2 	.word	0x00001de2

Disassembly of section .text.operation_sleep_notimer:

00000578 <operation_sleep_notimer>:
    while(1);
}

static void operation_sleep_notimer( void ) {
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 578:	2000      	movs	r0, #0

    mbus_sleep_all();
    while(1);
}

static void operation_sleep_notimer( void ) {
 57a:	b508      	push	{r3, lr}
    // Diable timer
    set_wakeup_timer(0, 0, 0);
 57c:	1c01      	adds	r1, r0, #0
 57e:	1c02      	adds	r2, r0, #0
 580:	f7ff fdf6 	bl	170 <set_wakeup_timer>
    // set_xo_timer(0, 0, 0, 0);
    config_timer32(0, 0, 0, 0);
 584:	2000      	movs	r0, #0
 586:	1c01      	adds	r1, r0, #0
 588:	1c02      	adds	r2, r0, #0
 58a:	1c03      	adds	r3, r0, #0
 58c:	f7ff fdd6 	bl	13c <config_timer32>
    // TODO: reset SNT timer
    operation_sleep();
 590:	f7ff ffe2 	bl	558 <operation_sleep>

Disassembly of section .text.unlikely.temp_shift_left_store.part.0:

00000598 <temp_shift_left_store.part.0>:
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) storage, 2);
        mem_temp_len += 3;
    }
}

static uint8_t temp_shift_left_store(uint32_t data, uint8_t len) {
 598:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
        return 1;
    }

    data &= ((1 << len) - 1);

    temp_code_storage[1] = temp_code_storage[1] << len;
 59a:	4e1a      	ldr	r6, [pc, #104]	; (604 <temp_shift_left_store.part.0+0x6c>)
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) storage, 2);
        mem_temp_len += 3;
    }
}

static uint8_t temp_shift_left_store(uint32_t data, uint8_t len) {
 59c:	1c0f      	adds	r7, r1, #0
 59e:	9001      	str	r0, [sp, #4]
        return 1;
    }

    data &= ((1 << len) - 1);

    temp_code_storage[1] = temp_code_storage[1] << len;
 5a0:	1c3a      	adds	r2, r7, #0
 5a2:	68b0      	ldr	r0, [r6, #8]
 5a4:	68f1      	ldr	r1, [r6, #12]
 5a6:	f000 f833 	bl	610 <____aeabi_llsl_from_thumb>
 5aa:	1c0b      	adds	r3, r1, #0
 5ac:	1c02      	adds	r2, r0, #0
 5ae:	60b2      	str	r2, [r6, #8]
 5b0:	60f3      	str	r3, [r6, #12]
    temp_code_storage[1] |= (temp_code_storage[0] >> (64 - len));
 5b2:	2240      	movs	r2, #64	; 0x40
 5b4:	68b4      	ldr	r4, [r6, #8]
 5b6:	68f5      	ldr	r5, [r6, #12]
 5b8:	1bd2      	subs	r2, r2, r7
 5ba:	6830      	ldr	r0, [r6, #0]
 5bc:	6871      	ldr	r1, [r6, #4]
 5be:	f000 f82b 	bl	618 <____aeabi_llsr_from_thumb>
 5c2:	1c02      	adds	r2, r0, #0
 5c4:	1c0b      	adds	r3, r1, #0
 5c6:	432b      	orrs	r3, r5
 5c8:	4322      	orrs	r2, r4
 5ca:	60b2      	str	r2, [r6, #8]
 5cc:	60f3      	str	r3, [r6, #12]
    temp_code_storage[0] = temp_code_storage[0] << len;
 5ce:	1c3a      	adds	r2, r7, #0
 5d0:	6830      	ldr	r0, [r6, #0]
 5d2:	6871      	ldr	r1, [r6, #4]
 5d4:	f000 f81c 	bl	610 <____aeabi_llsl_from_thumb>
static uint8_t temp_shift_left_store(uint32_t data, uint8_t len) {
    if(temp_storage_remainder < len) {
        return 1;
    }

    data &= ((1 << len) - 1);
 5d8:	2401      	movs	r4, #1

    temp_code_storage[1] = temp_code_storage[1] << len;
    temp_code_storage[1] |= (temp_code_storage[0] >> (64 - len));
    temp_code_storage[0] = temp_code_storage[0] << len;
 5da:	1c02      	adds	r2, r0, #0
 5dc:	1c0b      	adds	r3, r1, #0
 5de:	6032      	str	r2, [r6, #0]
 5e0:	6073      	str	r3, [r6, #4]
static uint8_t temp_shift_left_store(uint32_t data, uint8_t len) {
    if(temp_storage_remainder < len) {
        return 1;
    }

    data &= ((1 << len) - 1);
 5e2:	40bc      	lsls	r4, r7
 5e4:	9b01      	ldr	r3, [sp, #4]
 5e6:	3c01      	subs	r4, #1
 5e8:	401c      	ands	r4, r3

    temp_code_storage[1] = temp_code_storage[1] << len;
    temp_code_storage[1] |= (temp_code_storage[0] >> (64 - len));
    temp_code_storage[0] = temp_code_storage[0] << len;
    temp_code_storage[0] |= data;
 5ea:	1c22      	adds	r2, r4, #0
 5ec:	6830      	ldr	r0, [r6, #0]
 5ee:	6871      	ldr	r1, [r6, #4]
 5f0:	4302      	orrs	r2, r0
 5f2:	1c0b      	adds	r3, r1, #0
 5f4:	6032      	str	r2, [r6, #0]
 5f6:	6073      	str	r3, [r6, #4]
    temp_storage_remainder -= len;
 5f8:	4b03      	ldr	r3, [pc, #12]	; (608 <temp_shift_left_store.part.0+0x70>)

    return 0;
}
 5fa:	2000      	movs	r0, #0

    temp_code_storage[1] = temp_code_storage[1] << len;
    temp_code_storage[1] |= (temp_code_storage[0] >> (64 - len));
    temp_code_storage[0] = temp_code_storage[0] << len;
    temp_code_storage[0] |= data;
    temp_storage_remainder -= len;
 5fc:	781a      	ldrb	r2, [r3, #0]
 5fe:	1bd7      	subs	r7, r2, r7
 600:	701f      	strb	r7, [r3, #0]

    return 0;
}
 602:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
 604:	00001dd0 	.word	0x00001dd0
 608:	00001d3d 	.word	0x00001d3d
 60c:	00000000 	.word	0x00000000

00000610 <____aeabi_llsl_from_thumb>:
 610:	4778      	bx	pc
 612:	46c0      	nop			; (mov r8, r8)
 614:	eafffeaa 	b	c4 <__aeabi_llsl>

00000618 <____aeabi_llsr_from_thumb>:
 618:	4778      	bx	pc
 61a:	46c0      	nop			; (mov r8, r8)
 61c:	eafffea1 	b	a8 <__aeabi_llsr>

Disassembly of section .text.light_left_shift_store:

00000620 <light_left_shift_store>:
        store_temp();
        temp_storage_remainder = 80;
    }
}

static uint8_t light_left_shift_store(uint32_t data, uint8_t len) {
 620:	b5f0      	push	{r4, r5, r6, r7, lr}
    if(light_storage_remainder < len) {
 622:	4a2b      	ldr	r2, [pc, #172]	; (6d0 <light_left_shift_store+0xb0>)
        store_temp();
        temp_storage_remainder = 80;
    }
}

static uint8_t light_left_shift_store(uint32_t data, uint8_t len) {
 624:	b085      	sub	sp, #20
    if(light_storage_remainder < len) {
 626:	7813      	ldrb	r3, [r2, #0]
        store_temp();
        temp_storage_remainder = 80;
    }
}

static uint8_t light_left_shift_store(uint32_t data, uint8_t len) {
 628:	9003      	str	r0, [sp, #12]
 62a:	1c0d      	adds	r5, r1, #0
    if(light_storage_remainder < len) {
        return 1;
 62c:	2601      	movs	r6, #1
        temp_storage_remainder = 80;
    }
}

static uint8_t light_left_shift_store(uint32_t data, uint8_t len) {
    if(light_storage_remainder < len) {
 62e:	428b      	cmp	r3, r1
 630:	d34b      	bcc.n	6ca <light_left_shift_store+0xaa>

    data &= ((1 << len) - 1);

    int8_t i;
    for(i = 2; i >= 1; i--) {
        light_code_storage[i] = light_code_storage[i] << len;
 632:	4c28      	ldr	r4, [pc, #160]	; (6d4 <light_left_shift_store+0xb4>)
 634:	1c2a      	adds	r2, r5, #0
 636:	6920      	ldr	r0, [r4, #16]
 638:	6961      	ldr	r1, [r4, #20]
 63a:	f000 f851 	bl	6e0 <____aeabi_llsl_from_thumb>
 63e:	1c02      	adds	r2, r0, #0
 640:	1c0b      	adds	r3, r1, #0
 642:	6122      	str	r2, [r4, #16]
 644:	6163      	str	r3, [r4, #20]
        light_code_storage[i] |= (light_code_storage[i - 1] >> (64 - len));
 646:	2740      	movs	r7, #64	; 0x40
 648:	1b7f      	subs	r7, r7, r5
 64a:	6922      	ldr	r2, [r4, #16]
 64c:	6963      	ldr	r3, [r4, #20]
 64e:	68a0      	ldr	r0, [r4, #8]
 650:	68e1      	ldr	r1, [r4, #12]
 652:	9200      	str	r2, [sp, #0]
 654:	9301      	str	r3, [sp, #4]
 656:	1c3a      	adds	r2, r7, #0
 658:	f000 f83e 	bl	6d8 <____aeabi_llsr_from_thumb>
 65c:	9a00      	ldr	r2, [sp, #0]
 65e:	9b01      	ldr	r3, [sp, #4]
 660:	4302      	orrs	r2, r0
 662:	430b      	orrs	r3, r1
 664:	6122      	str	r2, [r4, #16]
 666:	6163      	str	r3, [r4, #20]

    data &= ((1 << len) - 1);

    int8_t i;
    for(i = 2; i >= 1; i--) {
        light_code_storage[i] = light_code_storage[i] << len;
 668:	1c2a      	adds	r2, r5, #0
 66a:	68a0      	ldr	r0, [r4, #8]
 66c:	68e1      	ldr	r1, [r4, #12]
 66e:	f000 f837 	bl	6e0 <____aeabi_llsl_from_thumb>
 672:	1c02      	adds	r2, r0, #0
 674:	1c0b      	adds	r3, r1, #0
 676:	60a2      	str	r2, [r4, #8]
 678:	60e3      	str	r3, [r4, #12]
        light_code_storage[i] |= (light_code_storage[i - 1] >> (64 - len));
 67a:	68a2      	ldr	r2, [r4, #8]
 67c:	68e3      	ldr	r3, [r4, #12]
 67e:	6820      	ldr	r0, [r4, #0]
 680:	6861      	ldr	r1, [r4, #4]
 682:	9200      	str	r2, [sp, #0]
 684:	9301      	str	r3, [sp, #4]
 686:	1c3a      	adds	r2, r7, #0
 688:	f000 f826 	bl	6d8 <____aeabi_llsr_from_thumb>
 68c:	9a00      	ldr	r2, [sp, #0]
 68e:	9b01      	ldr	r3, [sp, #4]
 690:	4302      	orrs	r2, r0
 692:	430b      	orrs	r3, r1
 694:	60a2      	str	r2, [r4, #8]
 696:	60e3      	str	r3, [r4, #12]
    }
    light_code_storage[0] = light_code_storage[0] << len;
 698:	1c2a      	adds	r2, r5, #0
 69a:	6820      	ldr	r0, [r4, #0]
 69c:	6861      	ldr	r1, [r4, #4]
 69e:	f000 f81f 	bl	6e0 <____aeabi_llsl_from_thumb>
 6a2:	1c02      	adds	r2, r0, #0
 6a4:	1c0b      	adds	r3, r1, #0
 6a6:	6022      	str	r2, [r4, #0]
 6a8:	6063      	str	r3, [r4, #4]
static uint8_t light_left_shift_store(uint32_t data, uint8_t len) {
    if(light_storage_remainder < len) {
        return 1;
    }

    data &= ((1 << len) - 1);
 6aa:	40ae      	lsls	r6, r5
 6ac:	9b03      	ldr	r3, [sp, #12]
 6ae:	3e01      	subs	r6, #1
 6b0:	401e      	ands	r6, r3
    for(i = 2; i >= 1; i--) {
        light_code_storage[i] = light_code_storage[i] << len;
        light_code_storage[i] |= (light_code_storage[i - 1] >> (64 - len));
    }
    light_code_storage[0] = light_code_storage[0] << len;
    light_code_storage[0] |= data;
 6b2:	1c32      	adds	r2, r6, #0
 6b4:	6820      	ldr	r0, [r4, #0]
 6b6:	6861      	ldr	r1, [r4, #4]
 6b8:	4302      	orrs	r2, r0
 6ba:	1c0b      	adds	r3, r1, #0
 6bc:	6022      	str	r2, [r4, #0]
 6be:	6063      	str	r3, [r4, #4]

    light_storage_remainder -= len;
 6c0:	4a03      	ldr	r2, [pc, #12]	; (6d0 <light_left_shift_store+0xb0>)
 6c2:	2600      	movs	r6, #0
 6c4:	7813      	ldrb	r3, [r2, #0]
 6c6:	1b5d      	subs	r5, r3, r5
 6c8:	7015      	strb	r5, [r2, #0]
    return 0;
}
 6ca:	1c30      	adds	r0, r6, #0
 6cc:	b005      	add	sp, #20
 6ce:	bdf0      	pop	{r4, r5, r6, r7, pc}
 6d0:	00001d3c 	.word	0x00001d3c
 6d4:	00001d58 	.word	0x00001d58

000006d8 <____aeabi_llsr_from_thumb>:
 6d8:	4778      	bx	pc
 6da:	46c0      	nop			; (mov r8, r8)
 6dc:	eafffe71 	b	a8 <__aeabi_llsr>

000006e0 <____aeabi_llsl_from_thumb>:
 6e0:	4778      	bx	pc
 6e2:	46c0      	nop			; (mov r8, r8)
 6e4:	eafffe76 	b	c4 <__aeabi_llsl>

Disassembly of section .text.store_l1_header.part.2:

000006e8 <store_l1_header.part.2>:

static void store_l1_header() {
 6e8:	b510      	push	{r4, lr}
    if(lnt_l1_len == 0) {
        return;
    }
    light_left_shift_store(lnt_l1_len, 3);
 6ea:	4c07      	ldr	r4, [pc, #28]	; (708 <store_l1_header.part.2+0x20>)
 6ec:	2103      	movs	r1, #3
 6ee:	7820      	ldrb	r0, [r4, #0]
 6f0:	f7ff ff96 	bl	620 <light_left_shift_store>
    light_left_shift_store(l1_cur_meas_time_mode, 2);
 6f4:	4b05      	ldr	r3, [pc, #20]	; (70c <store_l1_header.part.2+0x24>)
 6f6:	2102      	movs	r1, #2
 6f8:	7818      	ldrb	r0, [r3, #0]
 6fa:	f7ff ff91 	bl	620 <light_left_shift_store>
    lnt_l1_len = 0;
    lnt_l2_len = 0;
 6fe:	4a04      	ldr	r2, [pc, #16]	; (710 <store_l1_header.part.2+0x28>)
    if(lnt_l1_len == 0) {
        return;
    }
    light_left_shift_store(lnt_l1_len, 3);
    light_left_shift_store(l1_cur_meas_time_mode, 2);
    lnt_l1_len = 0;
 700:	2300      	movs	r3, #0
 702:	7023      	strb	r3, [r4, #0]
    lnt_l2_len = 0;
 704:	7013      	strb	r3, [r2, #0]
}
 706:	bd10      	pop	{r4, pc}
 708:	00001dfe 	.word	0x00001dfe
 70c:	00001dfc 	.word	0x00001dfc
 710:	00001de3 	.word	0x00001de3

Disassembly of section .text.store_l2_header.part.3:

00000714 <store_l2_header.part.3>:

static void store_l2_header() {
 714:	b538      	push	{r3, r4, r5, lr}
    if(lnt_l2_len == 0) {
        return;
    }
    light_left_shift_store(lnt_l2_len, 6 - cur_len_mode);
 716:	4d0a      	ldr	r5, [pc, #40]	; (740 <store_l2_header.part.3+0x2c>)
 718:	4c0a      	ldr	r4, [pc, #40]	; (744 <store_l2_header.part.3+0x30>)
 71a:	2106      	movs	r1, #6
 71c:	7820      	ldrb	r0, [r4, #0]
 71e:	782b      	ldrb	r3, [r5, #0]
 720:	1ac9      	subs	r1, r1, r3
 722:	b2c9      	uxtb	r1, r1
 724:	f7ff ff7c 	bl	620 <light_left_shift_store>
    light_left_shift_store(cur_len_mode, 2);
 728:	7828      	ldrb	r0, [r5, #0]
 72a:	2102      	movs	r1, #2
 72c:	f7ff ff78 	bl	620 <light_left_shift_store>
    lnt_l1_len++;
 730:	4b05      	ldr	r3, [pc, #20]	; (748 <store_l2_header.part.3+0x34>)
 732:	781a      	ldrb	r2, [r3, #0]
 734:	3201      	adds	r2, #1
 736:	701a      	strb	r2, [r3, #0]
    lnt_l2_len = 0;
 738:	2300      	movs	r3, #0
 73a:	7023      	strb	r3, [r4, #0]
}
 73c:	bd38      	pop	{r3, r4, r5, pc}
 73e:	46c0      	nop			; (mov r8, r8)
 740:	00001d3e 	.word	0x00001d3e
 744:	00001de3 	.word	0x00001de3
 748:	00001dfe 	.word	0x00001dfe

Disassembly of section .text.store_temp.part.4:

0000074c <store_temp.part.4>:
    }

    return out & 0x7FF;
}

static void store_temp() {
 74c:	b51f      	push	{r0, r1, r2, r3, r4, lr}
    if(temp_storage_remainder <= 80) {
        uint32_t storage[3];
        storage[2] = temp_code_storage[1] & 0xFFFFFFFF;
 74e:	490c      	ldr	r1, [pc, #48]	; (780 <store_temp.part.4+0x34>)
        storage[1] = temp_code_storage[0] >> 32;
        storage[0] = temp_code_storage[0] & 0xFFFFFFFF;
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) storage, 2);
 750:	4c0c      	ldr	r4, [pc, #48]	; (784 <store_temp.part.4+0x38>)
}

static void store_temp() {
    if(temp_storage_remainder <= 80) {
        uint32_t storage[3];
        storage[2] = temp_code_storage[1] & 0xFFFFFFFF;
 752:	688a      	ldr	r2, [r1, #8]
 754:	68cb      	ldr	r3, [r1, #12]
 756:	9203      	str	r2, [sp, #12]
        storage[1] = temp_code_storage[0] >> 32;
 758:	680a      	ldr	r2, [r1, #0]
 75a:	684b      	ldr	r3, [r1, #4]
 75c:	9302      	str	r3, [sp, #8]
        storage[0] = temp_code_storage[0] & 0xFFFFFFFF;
 75e:	680a      	ldr	r2, [r1, #0]
 760:	684b      	ldr	r3, [r1, #4]
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) storage, 2);
 762:	4b09      	ldr	r3, [pc, #36]	; (788 <store_temp.part.4+0x3c>)
static void store_temp() {
    if(temp_storage_remainder <= 80) {
        uint32_t storage[3];
        storage[2] = temp_code_storage[1] & 0xFFFFFFFF;
        storage[1] = temp_code_storage[0] >> 32;
        storage[0] = temp_code_storage[0] & 0xFFFFFFFF;
 764:	9201      	str	r2, [sp, #4]
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + mem_temp_len), (uint32_t*) storage, 2);
 766:	8819      	ldrh	r1, [r3, #0]
 768:	8823      	ldrh	r3, [r4, #0]
 76a:	2006      	movs	r0, #6
 76c:	18c9      	adds	r1, r1, r3
 76e:	aa01      	add	r2, sp, #4
 770:	2302      	movs	r3, #2
 772:	f7ff fd6d 	bl	250 <mbus_copy_mem_from_local_to_remote_bulk>
        mem_temp_len += 3;
 776:	8823      	ldrh	r3, [r4, #0]
 778:	3303      	adds	r3, #3
 77a:	8023      	strh	r3, [r4, #0]
    }
}
 77c:	bd1f      	pop	{r0, r1, r2, r3, r4, pc}
 77e:	46c0      	nop			; (mov r8, r8)
 780:	00001dd0 	.word	0x00001dd0
 784:	00001dfa 	.word	0x00001dfa
 788:	00001d18 	.word	0x00001d18

Disassembly of section .text.store_light:

0000078c <store_light>:
    light_left_shift_store(cur_len_mode, 2);
    lnt_l1_len++;
    lnt_l2_len = 0;
}

static void store_light() {
 78c:	b530      	push	{r4, r5, lr}
    lnt_l1_len = 0;
    lnt_l2_len = 0;
}

static void store_l2_header() {
    if(lnt_l2_len == 0) {
 78e:	4b24      	ldr	r3, [pc, #144]	; (820 <store_light+0x94>)
    light_left_shift_store(cur_len_mode, 2);
    lnt_l1_len++;
    lnt_l2_len = 0;
}

static void store_light() {
 790:	b087      	sub	sp, #28
    lnt_l1_len = 0;
    lnt_l2_len = 0;
}

static void store_l2_header() {
    if(lnt_l2_len == 0) {
 792:	781b      	ldrb	r3, [r3, #0]
 794:	2b00      	cmp	r3, #0
 796:	d001      	beq.n	79c <store_light+0x10>
 798:	f7ff ffbc 	bl	714 <store_l2_header.part.3>
    light_storage_remainder -= len;
    return 0;
}

static void store_l1_header() {
    if(lnt_l1_len == 0) {
 79c:	4b21      	ldr	r3, [pc, #132]	; (824 <store_light+0x98>)
 79e:	781b      	ldrb	r3, [r3, #0]
 7a0:	2b00      	cmp	r3, #0
 7a2:	d001      	beq.n	7a8 <store_light+0x1c>
 7a4:	f7ff ffa0 	bl	6e8 <store_l1_header.part.2>

static void store_light() {
    store_l2_header();
    store_l1_header();

    if(light_storage_remainder <= 160) {
 7a8:	4b1f      	ldr	r3, [pc, #124]	; (828 <store_light+0x9c>)
 7aa:	781b      	ldrb	r3, [r3, #0]
 7ac:	2ba0      	cmp	r3, #160	; 0xa0
 7ae:	d834      	bhi.n	81a <store_light+0x8e>
        uint32_t storage1[3], storage2[3];
        storage1[2] = (light_code_storage[2] >> 16) & 0xFFFF;
 7b0:	4c1e      	ldr	r4, [pc, #120]	; (82c <store_light+0xa0>)
        storage1[0] = (light_code_storage[1] >> 16) & 0xFFFFFFFF;
        storage2[2] = light_code_storage[1] & 0xFFFF;
        storage2[1] = light_code_storage[0] >> 32;
        storage2[0] = light_code_storage[0] & 0xFFFFFFFF;

        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) storage1, 2);
 7b2:	4d1f      	ldr	r5, [pc, #124]	; (830 <store_light+0xa4>)
    store_l2_header();
    store_l1_header();

    if(light_storage_remainder <= 160) {
        uint32_t storage1[3], storage2[3];
        storage1[2] = (light_code_storage[2] >> 16) & 0xFFFF;
 7b4:	6922      	ldr	r2, [r4, #16]
 7b6:	6963      	ldr	r3, [r4, #20]
 7b8:	0c12      	lsrs	r2, r2, #16
 7ba:	9202      	str	r2, [sp, #8]
        storage1[1] = ((light_code_storage[2] & 0xFFFF) << 16) | (light_code_storage[1] >> 48);
 7bc:	6922      	ldr	r2, [r4, #16]
 7be:	6963      	ldr	r3, [r4, #20]
 7c0:	68a0      	ldr	r0, [r4, #8]
 7c2:	68e1      	ldr	r1, [r4, #12]
 7c4:	0412      	lsls	r2, r2, #16
 7c6:	0c0b      	lsrs	r3, r1, #16
 7c8:	431a      	orrs	r2, r3
 7ca:	9201      	str	r2, [sp, #4]
        storage1[0] = (light_code_storage[1] >> 16) & 0xFFFFFFFF;
 7cc:	68a2      	ldr	r2, [r4, #8]
 7ce:	68e3      	ldr	r3, [r4, #12]
 7d0:	041b      	lsls	r3, r3, #16
 7d2:	0c12      	lsrs	r2, r2, #16
 7d4:	431a      	orrs	r2, r3
 7d6:	9200      	str	r2, [sp, #0]
        storage2[2] = light_code_storage[1] & 0xFFFF;
 7d8:	68a2      	ldr	r2, [r4, #8]
 7da:	68e3      	ldr	r3, [r4, #12]
 7dc:	b292      	uxth	r2, r2
 7de:	9205      	str	r2, [sp, #20]
        storage2[1] = light_code_storage[0] >> 32;
 7e0:	6822      	ldr	r2, [r4, #0]
 7e2:	6863      	ldr	r3, [r4, #4]
 7e4:	9304      	str	r3, [sp, #16]
        storage2[0] = light_code_storage[0] & 0xFFFFFFFF;
 7e6:	6822      	ldr	r2, [r4, #0]
 7e8:	6863      	ldr	r3, [r4, #4]

        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) storage1, 2);
 7ea:	4c12      	ldr	r4, [pc, #72]	; (834 <store_light+0xa8>)
 7ec:	8829      	ldrh	r1, [r5, #0]
 7ee:	8823      	ldrh	r3, [r4, #0]
        storage1[2] = (light_code_storage[2] >> 16) & 0xFFFF;
        storage1[1] = ((light_code_storage[2] & 0xFFFF) << 16) | (light_code_storage[1] >> 48);
        storage1[0] = (light_code_storage[1] >> 16) & 0xFFFFFFFF;
        storage2[2] = light_code_storage[1] & 0xFFFF;
        storage2[1] = light_code_storage[0] >> 32;
        storage2[0] = light_code_storage[0] & 0xFFFFFFFF;
 7f0:	9203      	str	r2, [sp, #12]

        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) storage1, 2);
 7f2:	18c9      	adds	r1, r1, r3
 7f4:	2006      	movs	r0, #6
 7f6:	466a      	mov	r2, sp
 7f8:	2302      	movs	r3, #2
 7fa:	f7ff fd29 	bl	250 <mbus_copy_mem_from_local_to_remote_bulk>
        mem_light_len += 3;
 7fe:	8823      	ldrh	r3, [r4, #0]
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) storage2, 2);
 800:	2006      	movs	r0, #6
        storage2[2] = light_code_storage[1] & 0xFFFF;
        storage2[1] = light_code_storage[0] >> 32;
        storage2[0] = light_code_storage[0] & 0xFFFFFFFF;

        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) storage1, 2);
        mem_light_len += 3;
 802:	3303      	adds	r3, #3
 804:	8023      	strh	r3, [r4, #0]
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (mem_light_addr + mem_light_len), (uint32_t*) storage2, 2);
 806:	8829      	ldrh	r1, [r5, #0]
 808:	8823      	ldrh	r3, [r4, #0]
 80a:	aa03      	add	r2, sp, #12
 80c:	18c9      	adds	r1, r1, r3
 80e:	2302      	movs	r3, #2
 810:	f7ff fd1e 	bl	250 <mbus_copy_mem_from_local_to_remote_bulk>
        mem_light_len += 3;
 814:	8823      	ldrh	r3, [r4, #0]
 816:	3303      	adds	r3, #3
 818:	8023      	strh	r3, [r4, #0]
    }
}
 81a:	b007      	add	sp, #28
 81c:	bd30      	pop	{r4, r5, pc}
 81e:	46c0      	nop			; (mov r8, r8)
 820:	00001de3 	.word	0x00001de3
 824:	00001dfe 	.word	0x00001dfe
 828:	00001d3c 	.word	0x00001d3c
 82c:	00001d58 	.word	0x00001d58
 830:	00001df6 	.word	0x00001df6
 834:	00001dec 	.word	0x00001dec

Disassembly of section .text.operation_temp_run:

00000838 <operation_temp_run>:
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}


static void operation_temp_run() {
 838:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    if(snt_state == SNT_IDLE) {
 83a:	4c51      	ldr	r4, [pc, #324]	; (980 <operation_temp_run+0x148>)
 83c:	7821      	ldrb	r1, [r4, #0]
 83e:	2900      	cmp	r1, #0
 840:	d10c      	bne.n	85c <operation_temp_run+0x24>
    sntv4_r01.TSNS_RESETn = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void snt_ldo_vref_on() {
    sntv4_r00.LDO_EN_VREF = 1;
 842:	4b50      	ldr	r3, [pc, #320]	; (984 <operation_temp_run+0x14c>)
 844:	2004      	movs	r0, #4
 846:	881a      	ldrh	r2, [r3, #0]
 848:	4302      	orrs	r2, r0
 84a:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 84c:	681a      	ldr	r2, [r3, #0]
 84e:	f7ff fcf2 	bl	236 <mbus_remote_register_write>
    if(snt_state == SNT_IDLE) {

        // Turn on snt ldo vref; requires ~30 ms to settle
        // TODo: figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);
 852:	2064      	movs	r0, #100	; 0x64
 854:	f7ff fc68 	bl	128 <delay>

        snt_state = SNT_TEMP_LDO;
 858:	2301      	movs	r3, #1
 85a:	7023      	strb	r3, [r4, #0]

    }
    if(snt_state == SNT_TEMP_LDO) {
 85c:	4f48      	ldr	r7, [pc, #288]	; (980 <operation_temp_run+0x148>)
 85e:	783d      	ldrb	r5, [r7, #0]
 860:	2d01      	cmp	r5, #1
 862:	d12e      	bne.n	8c2 <operation_temp_run+0x8a>
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 864:	4b47      	ldr	r3, [pc, #284]	; (984 <operation_temp_run+0x14c>)
 866:	2602      	movs	r6, #2
 868:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 86a:	2004      	movs	r0, #4
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 86c:	4332      	orrs	r2, r6
 86e:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
 870:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 872:	2100      	movs	r1, #0
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
    sntv4_r00.LDO_EN_LDO  = 1;
 874:	432a      	orrs	r2, r5
 876:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 878:	681a      	ldr	r2, [r3, #0]
 87a:	f7ff fcdc 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 87e:	4c42      	ldr	r4, [pc, #264]	; (988 <operation_temp_run+0x150>)
 880:	2208      	movs	r2, #8
 882:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 884:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 886:	4313      	orrs	r3, r2
 888:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 88a:	6822      	ldr	r2, [r4, #0]
 88c:	1c29      	adds	r1, r5, #0
 88e:	f7ff fcd2 	bl	236 <mbus_remote_register_write>
    // Un-powergate analog block
    sntv4_r01.TSNS_EN_SENSOR_LDO = 1;
 892:	8823      	ldrh	r3, [r4, #0]
 894:	2220      	movs	r2, #32
 896:	4313      	orrs	r3, r2
 898:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 89a:	6822      	ldr	r2, [r4, #0]
 89c:	1c29      	adds	r1, r5, #0
 89e:	2004      	movs	r0, #4
 8a0:	f7ff fcc9 	bl	236 <mbus_remote_register_write>

    delay(MBUS_DELAY);
 8a4:	2064      	movs	r0, #100	; 0x64
 8a6:	f7ff fc3f 	bl	128 <delay>

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 8aa:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 8ac:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    delay(MBUS_DELAY);

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 8ae:	43b3      	bics	r3, r6
 8b0:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 8b2:	6822      	ldr	r2, [r4, #0]
 8b4:	1c29      	adds	r1, r5, #0
 8b6:	f7ff fcbe 	bl	236 <mbus_remote_register_write>
        // Power on snt ldo
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);
 8ba:	2064      	movs	r0, #100	; 0x64
 8bc:	f7ff fc34 	bl	128 <delay>

        snt_state = SNT_TEMP_START;
 8c0:	703e      	strb	r6, [r7, #0]
    }
    if(snt_state == SNT_TEMP_START) {
 8c2:	4d2f      	ldr	r5, [pc, #188]	; (980 <operation_temp_run+0x148>)
 8c4:	782b      	ldrb	r3, [r5, #0]
 8c6:	2b02      	cmp	r3, #2
 8c8:	d11d      	bne.n	906 <operation_temp_run+0xce>
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 8ca:	4b30      	ldr	r3, [pc, #192]	; (98c <operation_temp_run+0x154>)
 8cc:	2400      	movs	r4, #0
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 8ce:	20a0      	movs	r0, #160	; 0xa0

        snt_state = SNT_TEMP_START;
    }
    if(snt_state == SNT_TEMP_START) {
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 8d0:	701c      	strb	r4, [r3, #0]
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 8d2:	0300      	lsls	r0, r0, #12
 8d4:	2101      	movs	r1, #1
 8d6:	1c22      	adds	r2, r4, #0
 8d8:	1c23      	adds	r3, r4, #0
 8da:	f7ff fc2f 	bl	13c <config_timer32>
/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/

static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
 8de:	482a      	ldr	r0, [pc, #168]	; (988 <operation_temp_run+0x150>)
 8e0:	2101      	movs	r1, #1
 8e2:	8803      	ldrh	r3, [r0, #0]
 8e4:	430b      	orrs	r3, r1
 8e6:	8003      	strh	r3, [r0, #0]
    sntv4_r01.TSNS_EN_IRQ = 1;
 8e8:	8802      	ldrh	r2, [r0, #0]
 8ea:	2380      	movs	r3, #128	; 0x80
 8ec:	408b      	lsls	r3, r1
 8ee:	4313      	orrs	r3, r2
 8f0:	8003      	strh	r3, [r0, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 8f2:	6802      	ldr	r2, [r0, #0]
 8f4:	2004      	movs	r0, #4
 8f6:	f7ff fc9e 	bl	236 <mbus_remote_register_write>
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or TIMER32
	WFI();
 8fa:	f7ff fc1d 	bl	138 <WFI>

        // Turn off timer32
        *TIMER32_GO = 0;
 8fe:	4b24      	ldr	r3, [pc, #144]	; (990 <operation_temp_run+0x158>)
 900:	601c      	str	r4, [r3, #0]

        snt_state = SNT_TEMP_READ;
 902:	2303      	movs	r3, #3
 904:	702b      	strb	r3, [r5, #0]
    }
    if(snt_state == SNT_TEMP_READ) {
 906:	4a1e      	ldr	r2, [pc, #120]	; (980 <operation_temp_run+0x148>)
 908:	7813      	ldrb	r3, [r2, #0]
 90a:	2b03      	cmp	r3, #3
 90c:	d136      	bne.n	97c <operation_temp_run+0x144>
        if(wfi_timeout_flag) {
 90e:	4b1f      	ldr	r3, [pc, #124]	; (98c <operation_temp_run+0x154>)
 910:	781d      	ldrb	r5, [r3, #0]
 912:	1e2e      	subs	r6, r5, #0
 914:	d006      	beq.n	924 <operation_temp_run+0xec>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
 916:	2180      	movs	r1, #128	; 0x80
 918:	0449      	lsls	r1, r1, #17
 91a:	20af      	movs	r0, #175	; 0xaf
 91c:	f7ff fc4a 	bl	1b4 <mbus_write_message32>
    operation_sleep_notimer();
 920:	f7ff fe2a 	bl	578 <operation_sleep_notimer>
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 924:	23a0      	movs	r3, #160	; 0xa0
 926:	061b      	lsls	r3, r3, #24
 928:	681a      	ldr	r2, [r3, #0]
 92a:	4b1a      	ldr	r3, [pc, #104]	; (994 <operation_temp_run+0x15c>)
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 92c:	2401      	movs	r4, #1
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 92e:	601a      	str	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 930:	4b15      	ldr	r3, [pc, #84]	; (988 <operation_temp_run+0x150>)
    sntv4_r01.TSNS_SEL_LDO       = 0;
 932:	2108      	movs	r1, #8
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 934:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 936:	2702      	movs	r7, #2
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 938:	43a2      	bics	r2, r4
 93a:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
 93c:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 93e:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
 940:	438a      	bics	r2, r1
 942:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
 944:	881a      	ldrh	r2, [r3, #0]
 946:	2120      	movs	r1, #32
 948:	438a      	bics	r2, r1
 94a:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE       = 1;
 94c:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 94e:	1c21      	adds	r1, r4, #0

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 950:	433a      	orrs	r2, r7
 952:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 954:	681a      	ldr	r2, [r3, #0]
 956:	f7ff fc6e 	bl	236 <mbus_remote_register_write>
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 95a:	4b0a      	ldr	r3, [pc, #40]	; (984 <operation_temp_run+0x14c>)
 95c:	2004      	movs	r0, #4
 95e:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
    sntv4_r00.LDO_EN_LDO  = 0;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 960:	1c31      	adds	r1, r6, #0
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 962:	4382      	bics	r2, r0
 964:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
 966:	881a      	ldrh	r2, [r3, #0]
 968:	43ba      	bics	r2, r7
 96a:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 0;
 96c:	881a      	ldrh	r2, [r3, #0]
 96e:	43a2      	bics	r2, r4
 970:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 972:	681a      	ldr	r2, [r3, #0]
 974:	f7ff fc5f 	bl	236 <mbus_remote_register_write>
            
            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

            snt_state = SNT_IDLE;
 978:	4b01      	ldr	r3, [pc, #4]	; (980 <operation_temp_run+0x148>)
 97a:	701d      	strb	r5, [r3, #0]
        }
    }
}
 97c:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 97e:	46c0      	nop			; (mov r8, r8)
 980:	00001df8 	.word	0x00001df8
 984:	00001d20 	.word	0x00001d20
 988:	00001d24 	.word	0x00001d24
 98c:	00001dfd 	.word	0x00001dfd
 990:	a0001100 	.word	0xa0001100
 994:	00001d30 	.word	0x00001d30

Disassembly of section .text.get_timer_cnt:

00000998 <get_timer_cnt>:
//     mbus_write_message32(0xBA, 0x03);
// 
// }

uint32_t get_timer_cnt() {
    return ((*REG_XOT_VAL_U & 0xFFFF) << 16) | (*REG_XOT_VAL_L & 0xFFFF);
 998:	4a03      	ldr	r2, [pc, #12]	; (9a8 <get_timer_cnt+0x10>)
 99a:	4b04      	ldr	r3, [pc, #16]	; (9ac <get_timer_cnt+0x14>)
 99c:	681b      	ldr	r3, [r3, #0]
 99e:	6810      	ldr	r0, [r2, #0]
 9a0:	041b      	lsls	r3, r3, #16
 9a2:	b280      	uxth	r0, r0
 9a4:	4318      	orrs	r0, r3
}
 9a6:	4770      	bx	lr
 9a8:	a0000054 	.word	0xa0000054
 9ac:	a0000058 	.word	0xa0000058

Disassembly of section .text.update_system_time:

000009b0 <update_system_time>:

void update_system_time() {
 9b0:	b538      	push	{r3, r4, r5, lr}
    uint32_t val = xo_sys_time;
 9b2:	4c13      	ldr	r4, [pc, #76]	; (a00 <update_system_time+0x50>)
 9b4:	6825      	ldr	r5, [r4, #0]
    xo_sys_time = get_timer_cnt();
 9b6:	f7ff ffef 	bl	998 <get_timer_cnt>
    xo_day_time += val;
 9ba:	4b12      	ldr	r3, [pc, #72]	; (a04 <update_system_time+0x54>)
    return ((*REG_XOT_VAL_U & 0xFFFF) << 16) | (*REG_XOT_VAL_L & 0xFFFF);
}

void update_system_time() {
    uint32_t val = xo_sys_time;
    xo_sys_time = get_timer_cnt();
 9bc:	6020      	str	r0, [r4, #0]
    xo_day_time += val;
 9be:	681a      	ldr	r2, [r3, #0]
    
    uint32_t old_timestamp = xo_day_timestamp_count * XO_56_12_SEC;
 9c0:	4911      	ldr	r1, [pc, #68]	; (a08 <update_system_time+0x58>)
}

void update_system_time() {
    uint32_t val = xo_sys_time;
    xo_sys_time = get_timer_cnt();
    xo_day_time += val;
 9c2:	1955      	adds	r5, r2, r5
 9c4:	601d      	str	r5, [r3, #0]
    
    uint32_t old_timestamp = xo_day_timestamp_count * XO_56_12_SEC;
 9c6:	8808      	ldrh	r0, [r1, #0]
 9c8:	22e1      	movs	r2, #225	; 0xe1
 9ca:	0352      	lsls	r2, r2, #13
 9cc:	4342      	muls	r2, r0

    while(old_timestamp + XO_56_12_SEC < xo_day_time) {
 9ce:	e002      	b.n	9d6 <update_system_time+0x26>
        old_timestamp += XO_56_12_SEC;
        xo_day_timestamp_count++;
 9d0:	8808      	ldrh	r0, [r1, #0]
 9d2:	3001      	adds	r0, #1
 9d4:	8008      	strh	r0, [r1, #0]
    xo_sys_time = get_timer_cnt();
    xo_day_time += val;
    
    uint32_t old_timestamp = xo_day_timestamp_count * XO_56_12_SEC;

    while(old_timestamp + XO_56_12_SEC < xo_day_time) {
 9d6:	20e1      	movs	r0, #225	; 0xe1
 9d8:	0340      	lsls	r0, r0, #13
 9da:	1812      	adds	r2, r2, r0
 9dc:	6818      	ldr	r0, [r3, #0]
 9de:	4282      	cmp	r2, r0
 9e0:	d3f6      	bcc.n	9d0 <update_system_time+0x20>
        old_timestamp += XO_56_12_SEC;
        xo_day_timestamp_count++;
    }

    if(xo_day_time >= (uint32_t) XO_86400_SEC) {
 9e2:	6819      	ldr	r1, [r3, #0]
 9e4:	4a09      	ldr	r2, [pc, #36]	; (a0c <update_system_time+0x5c>)
 9e6:	4291      	cmp	r1, r2
 9e8:	d908      	bls.n	9fc <update_system_time+0x4c>
        xo_day_time -= (uint32_t) XO_86400_SEC;
 9ea:	681a      	ldr	r2, [r3, #0]
 9ec:	4908      	ldr	r1, [pc, #32]	; (a10 <update_system_time+0x60>)
        xo_day_timestamp_count -= 1536;
 9ee:	4809      	ldr	r0, [pc, #36]	; (a14 <update_system_time+0x64>)
        old_timestamp += XO_56_12_SEC;
        xo_day_timestamp_count++;
    }

    if(xo_day_time >= (uint32_t) XO_86400_SEC) {
        xo_day_time -= (uint32_t) XO_86400_SEC;
 9f0:	1852      	adds	r2, r2, r1
 9f2:	601a      	str	r2, [r3, #0]
        xo_day_timestamp_count -= 1536;
 9f4:	4b04      	ldr	r3, [pc, #16]	; (a08 <update_system_time+0x58>)
 9f6:	881a      	ldrh	r2, [r3, #0]
 9f8:	1812      	adds	r2, r2, r0
 9fa:	801a      	strh	r2, [r3, #0]
    }

}
 9fc:	bd38      	pop	{r3, r4, r5, pc}
 9fe:	46c0      	nop			; (mov r8, r8)
 a00:	00001e00 	.word	0x00001e00
 a04:	00001d90 	.word	0x00001d90
 a08:	00001d84 	.word	0x00001d84
 a0c:	a8bfffff 	.word	0xa8bfffff
 a10:	57400000 	.word	0x57400000
 a14:	fffffa00 	.word	0xfffffa00

Disassembly of section .text.reset_timers_list:

00000a18 <reset_timers_list>:

}

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
 a18:	b508      	push	{r3, lr}
    uint8_t i;
    update_system_time();
 a1a:	f7ff ffc9 	bl	9b0 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
 a1e:	4b03      	ldr	r3, [pc, #12]	; (a2c <reset_timers_list+0x14>)
 a20:	2200      	movs	r2, #0
 a22:	601a      	str	r2, [r3, #0]
 a24:	605a      	str	r2, [r3, #4]
 a26:	609a      	str	r2, [r3, #8]
    }
}
 a28:	bd08      	pop	{r3, pc}
 a2a:	46c0      	nop			; (mov r8, r8)
 a2c:	00001dbc 	.word	0x00001dbc

Disassembly of section .text.set_next_time:

00000a30 <set_next_time>:

static void set_next_time(uint8_t idx, uint32_t step) {
 a30:	b570      	push	{r4, r5, r6, lr}
 a32:	1c05      	adds	r5, r0, #0
 a34:	1c0c      	adds	r4, r1, #0
    update_system_time();
 a36:	f7ff ffbb 	bl	9b0 <update_system_time>
    xot_timer_list[idx] = xot_last_timer_list[idx];
 a3a:	4b09      	ldr	r3, [pc, #36]	; (a60 <set_next_time+0x30>)
 a3c:	00a8      	lsls	r0, r5, #2
 a3e:	58c2      	ldr	r2, [r0, r3]
 a40:	4b08      	ldr	r3, [pc, #32]	; (a64 <set_next_time+0x34>)
    while(xo_sys_time + (5 << 15) > xot_timer_list[idx]) {    // give some margin of error
 a42:	4d09      	ldr	r5, [pc, #36]	; (a68 <set_next_time+0x38>)
    }
}

static void set_next_time(uint8_t idx, uint32_t step) {
    update_system_time();
    xot_timer_list[idx] = xot_last_timer_list[idx];
 a44:	50c2      	str	r2, [r0, r3]
    while(xo_sys_time + (5 << 15) > xot_timer_list[idx]) {    // give some margin of error
 a46:	e002      	b.n	a4e <set_next_time+0x1e>
        xot_timer_list[idx] += step;
 a48:	58c2      	ldr	r2, [r0, r3]
 a4a:	1912      	adds	r2, r2, r4
 a4c:	50c2      	str	r2, [r0, r3]
}

static void set_next_time(uint8_t idx, uint32_t step) {
    update_system_time();
    xot_timer_list[idx] = xot_last_timer_list[idx];
    while(xo_sys_time + (5 << 15) > xot_timer_list[idx]) {    // give some margin of error
 a4e:	6829      	ldr	r1, [r5, #0]
 a50:	26a0      	movs	r6, #160	; 0xa0
 a52:	02b6      	lsls	r6, r6, #10
 a54:	58c2      	ldr	r2, [r0, r3]
 a56:	1989      	adds	r1, r1, r6
 a58:	4291      	cmp	r1, r2
 a5a:	d8f5      	bhi.n	a48 <set_next_time+0x18>
        xot_timer_list[idx] += step;
    }
}
 a5c:	bd70      	pop	{r4, r5, r6, pc}
 a5e:	46c0      	nop			; (mov r8, r8)
 a60:	00001d70 	.word	0x00001d70
 a64:	00001dbc 	.word	0x00001dbc
 a68:	00001e00 	.word	0x00001e00

Disassembly of section .text.xo_check_is_day:

00000a6c <xo_check_is_day>:
        xo_day_timestamp_count -= 1536;
    }

}

bool xo_check_is_day() {
 a6c:	b508      	push	{r3, lr}
    update_system_time();
 a6e:	f7ff ff9f 	bl	9b0 <update_system_time>
    return xo_day_time >= XO_DAY_START && xo_day_time < XO_DAY_END;
 a72:	4a06      	ldr	r2, [pc, #24]	; (a8c <xo_check_is_day+0x20>)
 a74:	4906      	ldr	r1, [pc, #24]	; (a90 <xo_check_is_day+0x24>)
 a76:	6810      	ldr	r0, [r2, #0]
 a78:	2300      	movs	r3, #0
 a7a:	4288      	cmp	r0, r1
 a7c:	d903      	bls.n	a86 <xo_check_is_day+0x1a>
 a7e:	6812      	ldr	r2, [r2, #0]
 a80:	4904      	ldr	r1, [pc, #16]	; (a94 <xo_check_is_day+0x28>)
 a82:	4291      	cmp	r1, r2
 a84:	415b      	adcs	r3, r3
 a86:	2001      	movs	r0, #1
 a88:	4018      	ands	r0, r3
}
 a8a:	bd08      	pop	{r3, pc}
 a8c:	00001d90 	.word	0x00001d90
 a90:	2327ffff 	.word	0x2327ffff
 a94:	8597ffff 	.word	0x8597ffff

Disassembly of section .text.log2:

00000a98 <log2>:
        }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 a98:	b5f0      	push	{r4, r5, r6, r7, lr}
    if(input == 0) { return 0; }
 a9a:	1c02      	adds	r2, r0, #0
 a9c:	2300      	movs	r3, #0
        }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 a9e:	1c05      	adds	r5, r0, #0
 aa0:	b08d      	sub	sp, #52	; 0x34
 aa2:	1c0e      	adds	r6, r1, #0
    if(input == 0) { return 0; }
 aa4:	430a      	orrs	r2, r1
 aa6:	1c18      	adds	r0, r3, #0
 aa8:	429a      	cmp	r2, r3
 aaa:	d059      	beq.n	b60 <log2+0xc8>
    input_storage[1] = input >> 32;
    uint16_t out = 0;

    int16_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
    	temp_result[i] = input_storage[i] = 0;
 aac:	9304      	str	r3, [sp, #16]
 aae:	9300      	str	r3, [sp, #0]
 ab0:	9305      	str	r3, [sp, #20]
 ab2:	9301      	str	r3, [sp, #4]
 ab4:	9306      	str	r3, [sp, #24]
 ab6:	9302      	str	r3, [sp, #8]
 ab8:	9307      	str	r3, [sp, #28]
 aba:	9303      	str	r3, [sp, #12]
 abc:	243f      	movs	r4, #63	; 0x3f
    }
    for(i = 63; i >= 0; i--) {
        if(input & ((uint64_t) 1 << i)) {
 abe:	1c22      	adds	r2, r4, #0
 ac0:	1c28      	adds	r0, r5, #0
 ac2:	1c31      	adds	r1, r6, #0
 ac4:	f000 f850 	bl	b68 <____aeabi_llsr_from_thumb>
 ac8:	2201      	movs	r2, #1
 aca:	4010      	ands	r0, r2
 acc:	d00d      	beq.n	aea <log2+0x52>
            temp_result[0] = (1 << i) & 0xFFFFFFFF;
 ace:	1c13      	adds	r3, r2, #0
 ad0:	40a3      	lsls	r3, r4
            temp_result[1] = i >= 32? (1 << (i - 32)) : 0;
 ad2:	b227      	sxth	r7, r4
    for(i = 0; i < LONG_INT_LEN; i++) {
    	temp_result[i] = input_storage[i] = 0;
    }
    for(i = 63; i >= 0; i--) {
        if(input & ((uint64_t) 1 << i)) {
            temp_result[0] = (1 << i) & 0xFFFFFFFF;
 ad4:	9300      	str	r3, [sp, #0]
            temp_result[1] = i >= 32? (1 << (i - 32)) : 0;
 ad6:	2300      	movs	r3, #0
 ad8:	2f1f      	cmp	r7, #31
 ada:	dd02      	ble.n	ae2 <log2+0x4a>
 adc:	3c20      	subs	r4, #32
 ade:	1c13      	adds	r3, r2, #0
 ae0:	40a3      	lsls	r3, r4
 ae2:	9301      	str	r3, [sp, #4]
            out = 1 * (1 << LOG2_RES);
 ae4:	2520      	movs	r5, #32
 ae6:	2400      	movs	r4, #0
 ae8:	e003      	b.n	af2 <log2+0x5a>

    int16_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
    	temp_result[i] = input_storage[i] = 0;
    }
    for(i = 63; i >= 0; i--) {
 aea:	3c01      	subs	r4, #1
 aec:	d2e7      	bcs.n	abe <log2+0x26>
    if(input == 0) { return 0; }

    uint32_t temp_result[LONG_INT_LEN], input_storage[LONG_INT_LEN];
    input_storage[0] = input & 0xFFFFFFFF;
    input_storage[1] = input >> 32;
    uint16_t out = 0;
 aee:	1c05      	adds	r5, r0, #0
 af0:	e7f9      	b.n	ae6 <log2+0x4e>
            break;
        }
    }
    for(i = 0; i < LOG2_RES; i++) {
        uint32_t new_result[4];
        long_int_mult(temp_result, LOG_CONST_ARR[i], new_result);
 af2:	4a1c      	ldr	r2, [pc, #112]	; (b64 <log2+0xcc>)
        }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 af4:	0063      	lsls	r3, r4, #1
            break;
        }
    }
    for(i = 0; i < LOG2_RES; i++) {
        uint32_t new_result[4];
        long_int_mult(temp_result, LOG_CONST_ARR[i], new_result);
 af6:	af08      	add	r7, sp, #32
 af8:	5a99      	ldrh	r1, [r3, r2]
 afa:	4668      	mov	r0, sp
 afc:	1c3a      	adds	r2, r7, #0
 afe:	f7ff fbd7 	bl	2b0 <long_int_mult>
        long_int_mult(input_storage, (1 << 15), input_storage);
 b02:	ae04      	add	r6, sp, #16
 b04:	2180      	movs	r1, #128	; 0x80
 b06:	1c30      	adds	r0, r6, #0
 b08:	0209      	lsls	r1, r1, #8
 b0a:	1c32      	adds	r2, r6, #0
 b0c:	f7ff fbd0 	bl	2b0 <long_int_mult>
 b10:	2300      	movs	r3, #0
        }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 b12:	18fa      	adds	r2, r7, r3
}

static bool long_int_lte(const long_int lhs, const long_int rhs) {
    int8_t i;
    for(i = 3; i >= 0; i--) {
        if(lhs[i] < rhs[i]) {
 b14:	68d1      	ldr	r1, [r2, #12]
        }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 b16:	18f2      	adds	r2, r6, r3
}

static bool long_int_lte(const long_int lhs, const long_int rhs) {
    int8_t i;
    for(i = 3; i >= 0; i--) {
        if(lhs[i] < rhs[i]) {
 b18:	68d2      	ldr	r2, [r2, #12]
 b1a:	4291      	cmp	r1, r2
 b1c:	d305      	bcc.n	b2a <log2+0x92>
            return true;
        }
        else if(lhs[i] > rhs[i]) {
 b1e:	d818      	bhi.n	b52 <log2+0xba>
 b20:	3b04      	subs	r3, #4
    long_int_assign(res, temp_res);
}

static bool long_int_lte(const long_int lhs, const long_int rhs) {
    int8_t i;
    for(i = 3; i >= 0; i--) {
 b22:	1c1a      	adds	r2, r3, #0
 b24:	3210      	adds	r2, #16
 b26:	d1f4      	bne.n	b12 <log2+0x7a>
 b28:	e013      	b.n	b52 <log2+0xba>
typedef uint32_t* long_int;

static void long_int_assign(long_int dest, const long_int src) {
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
 b2a:	9b08      	ldr	r3, [sp, #32]
 b2c:	9a09      	ldr	r2, [sp, #36]	; 0x24
 b2e:	9300      	str	r3, [sp, #0]
 b30:	9b0a      	ldr	r3, [sp, #40]	; 0x28
 b32:	9201      	str	r2, [sp, #4]
 b34:	9a0b      	ldr	r2, [sp, #44]	; 0x2c
 b36:	9302      	str	r3, [sp, #8]
        }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 b38:	2304      	movs	r3, #4
typedef uint32_t* long_int;

static void long_int_assign(long_int dest, const long_int src) {
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
 b3a:	9203      	str	r2, [sp, #12]
        }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 b3c:	1b1b      	subs	r3, r3, r4
        long_int_mult(temp_result, LOG_CONST_ARR[i], new_result);
        long_int_mult(input_storage, (1 << 15), input_storage);

        if(long_int_lte(new_result, input_storage)) {
            long_int_assign(temp_result, new_result);
            out |= (1 << (LOG2_RES - 1 - i));
 b3e:	2201      	movs	r2, #1
 b40:	409a      	lsls	r2, r3
 b42:	4315      	orrs	r5, r2
 b44:	b2ad      	uxth	r5, r5
 b46:	3401      	adds	r4, #1
            temp_result[1] = i >= 32? (1 << (i - 32)) : 0;
            out = 1 * (1 << LOG2_RES);
            break;
        }
    }
    for(i = 0; i < LOG2_RES; i++) {
 b48:	2c05      	cmp	r4, #5
 b4a:	d1d2      	bne.n	af2 <log2+0x5a>
        else {
            long_int_mult(temp_result, (1 << 15), temp_result);
        }
    }

    return out & 0x7FF;
 b4c:	056d      	lsls	r5, r5, #21
 b4e:	0d68      	lsrs	r0, r5, #21
 b50:	e006      	b.n	b60 <log2+0xc8>
        if(long_int_lte(new_result, input_storage)) {
            long_int_assign(temp_result, new_result);
            out |= (1 << (LOG2_RES - 1 - i));
        }
        else {
            long_int_mult(temp_result, (1 << 15), temp_result);
 b52:	2180      	movs	r1, #128	; 0x80
 b54:	4668      	mov	r0, sp
 b56:	0209      	lsls	r1, r1, #8
 b58:	466a      	mov	r2, sp
 b5a:	f7ff fba9 	bl	2b0 <long_int_mult>
 b5e:	e7f2      	b.n	b46 <log2+0xae>
        }
    }

    return out & 0x7FF;
}
 b60:	b00d      	add	sp, #52	; 0x34
 b62:	bdf0      	pop	{r4, r5, r6, r7, pc}
 b64:	00001ce8 	.word	0x00001ce8

00000b68 <____aeabi_llsr_from_thumb>:
 b68:	4778      	bx	pc
 b6a:	46c0      	nop			; (mov r8, r8)
 b6c:	eafffd4d 	b	a8 <__aeabi_llsr>

Disassembly of section .text.compress_light:

00000b70 <compress_light>:
        mem_light_len += 3;
    }
}


uint8_t compress_light() {
 b70:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    uint16_t log_light = log2(lnt_sys_light) & 0x3FF;
 b72:	4b4a      	ldr	r3, [pc, #296]	; (c9c <compress_light+0x12c>)
 b74:	6818      	ldr	r0, [r3, #0]
 b76:	6859      	ldr	r1, [r3, #4]
 b78:	f7ff ff8e 	bl	a98 <log2>
    if(light_storage_remainder == 160) {
 b7c:	4b48      	ldr	r3, [pc, #288]	; (ca0 <compress_light+0x130>)
    }
}


uint8_t compress_light() {
    uint16_t log_light = log2(lnt_sys_light) & 0x3FF;
 b7e:	0586      	lsls	r6, r0, #22
    if(light_storage_remainder == 160) {
 b80:	781b      	ldrb	r3, [r3, #0]
    }
}


uint8_t compress_light() {
    uint16_t log_light = log2(lnt_sys_light) & 0x3FF;
 b82:	0db6      	lsrs	r6, r6, #22
    if(light_storage_remainder == 160) {
 b84:	2ba0      	cmp	r3, #160	; 0xa0
 b86:	d12a      	bne.n	bde <compress_light+0x6e>
        // start new light unit
        uint8_t i;
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
 b88:	4c46      	ldr	r4, [pc, #280]	; (ca4 <compress_light+0x134>)
}


uint8_t compress_light() {
    uint16_t log_light = log2(lnt_sys_light) & 0x3FF;
    if(light_storage_remainder == 160) {
 b8a:	2100      	movs	r1, #0
        // start new light unit
        uint8_t i;
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
 b8c:	2200      	movs	r2, #0
 b8e:	2300      	movs	r3, #0
 b90:	00c8      	lsls	r0, r1, #3
 b92:	1820      	adds	r0, r4, r0
 b94:	3101      	adds	r1, #1
 b96:	6002      	str	r2, [r0, #0]
 b98:	6043      	str	r3, [r0, #4]
uint8_t compress_light() {
    uint16_t log_light = log2(lnt_sys_light) & 0x3FF;
    if(light_storage_remainder == 160) {
        // start new light unit
        uint8_t i;
        for(i = 0; i < 6; i++) {
 b9a:	2906      	cmp	r1, #6
 b9c:	d1f8      	bne.n	b90 <compress_light+0x20>
            light_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
        light_left_shift_store(((CHIP_ID & 0x7) << 13) | ((light_packet_num & 0x3) << 11) | time_storage, 16);
 b9e:	4c42      	ldr	r4, [pc, #264]	; (ca8 <compress_light+0x138>)
        // start new light unit
        uint8_t i;
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
 ba0:	4b42      	ldr	r3, [pc, #264]	; (cac <compress_light+0x13c>)
        light_left_shift_store(((CHIP_ID & 0x7) << 13) | ((light_packet_num & 0x3) << 11) | time_storage, 16);
 ba2:	2203      	movs	r2, #3
        // start new light unit
        uint8_t i;
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
 ba4:	881b      	ldrh	r3, [r3, #0]
        light_left_shift_store(((CHIP_ID & 0x7) << 13) | ((light_packet_num & 0x3) << 11) | time_storage, 16);
 ba6:	7820      	ldrb	r0, [r4, #0]
        // start new light unit
        uint8_t i;
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
 ba8:	059b      	lsls	r3, r3, #22
        light_left_shift_store(((CHIP_ID & 0x7) << 13) | ((light_packet_num & 0x3) << 11) | time_storage, 16);
 baa:	4010      	ands	r0, r2
 bac:	0d9b      	lsrs	r3, r3, #22
 bae:	02c0      	lsls	r0, r0, #11
 bb0:	4318      	orrs	r0, r3
 bb2:	2110      	movs	r1, #16
 bb4:	f7ff fd34 	bl	620 <light_left_shift_store>
        light_packet_num++;
 bb8:	7823      	ldrb	r3, [r4, #0]

        // store initial ref data
        light_left_shift_store(log_light, 11);
 bba:	1c30      	adds	r0, r6, #0
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
        light_left_shift_store(((CHIP_ID & 0x7) << 13) | ((light_packet_num & 0x3) << 11) | time_storage, 16);
        light_packet_num++;
 bbc:	3301      	adds	r3, #1

        // store initial ref data
        light_left_shift_store(log_light, 11);
 bbe:	210b      	movs	r1, #11
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
        light_left_shift_store(((CHIP_ID & 0x7) << 13) | ((light_packet_num & 0x3) << 11) | time_storage, 16);
        light_packet_num++;
 bc0:	7023      	strb	r3, [r4, #0]

        // store initial ref data
        light_left_shift_store(log_light, 11);
 bc2:	f7ff fd2d 	bl	620 <light_left_shift_store>
        
        lnt_l1_len = 0;
 bc6:	4a3a      	ldr	r2, [pc, #232]	; (cb0 <compress_light+0x140>)
 bc8:	2300      	movs	r3, #0
 bca:	7013      	strb	r3, [r2, #0]
        lnt_l2_len = 0;
 bcc:	4a39      	ldr	r2, [pc, #228]	; (cb4 <compress_light+0x144>)
 bce:	7013      	strb	r3, [r2, #0]
        l1_cur_meas_time_mode = lnt_meas_time_mode;
 bd0:	4b39      	ldr	r3, [pc, #228]	; (cb8 <compress_light+0x148>)
 bd2:	781a      	ldrb	r2, [r3, #0]
 bd4:	4b39      	ldr	r3, [pc, #228]	; (cbc <compress_light+0x14c>)
 bd6:	701a      	strb	r2, [r3, #0]
        cur_len_mode = 0xFF;
 bd8:	22ff      	movs	r2, #255	; 0xff
 bda:	4b39      	ldr	r3, [pc, #228]	; (cc0 <compress_light+0x150>)
 bdc:	e059      	b.n	c92 <compress_light+0x122>
    }
    else {
        int16_t diff = log_light - last_log_light;
 bde:	4b39      	ldr	r3, [pc, #228]	; (cc4 <compress_light+0x154>)
 be0:	881f      	ldrh	r7, [r3, #0]
 be2:	1bf7      	subs	r7, r6, r7
 be4:	b2bf      	uxth	r7, r7
        uint8_t len = 0;
        uint8_t len_mode = 0;
        if(diff < 7 && diff > -8) { // 4 bit storage
 be6:	1dfb      	adds	r3, r7, #7
 be8:	b29b      	uxth	r3, r3
 bea:	2b0d      	cmp	r3, #13
 bec:	d804      	bhi.n	bf8 <compress_light+0x88>
            diff &= 0xF;
 bee:	230f      	movs	r3, #15
 bf0:	401f      	ands	r7, r3
            len = 4;
            len_mode = 0;
 bf2:	2400      	movs	r4, #0
        int16_t diff = log_light - last_log_light;
        uint8_t len = 0;
        uint8_t len_mode = 0;
        if(diff < 7 && diff > -8) { // 4 bit storage
            diff &= 0xF;
            len = 4;
 bf4:	2504      	movs	r5, #4
 bf6:	e017      	b.n	c28 <compress_light+0xb8>
            len_mode = 0;
        }
        else if(diff < 31 && diff > -32) {  // 6 bit storage
 bf8:	1c3b      	adds	r3, r7, #0
 bfa:	331f      	adds	r3, #31
 bfc:	b29b      	uxth	r3, r3
 bfe:	2b3d      	cmp	r3, #61	; 0x3d
 c00:	d804      	bhi.n	c0c <compress_light+0x9c>
            diff &= 0x3F;
 c02:	233f      	movs	r3, #63	; 0x3f
 c04:	401f      	ands	r7, r3
            len = 6;
            len_mode = 1;
 c06:	2401      	movs	r4, #1
            len = 4;
            len_mode = 0;
        }
        else if(diff < 31 && diff > -32) {  // 6 bit storage
            diff &= 0x3F;
            len = 6;
 c08:	2506      	movs	r5, #6
 c0a:	e00d      	b.n	c28 <compress_light+0xb8>
            len_mode = 1;
        }
        else if(diff < 255 && diff > -256) {    // 9 bit storage
 c0c:	1c3a      	adds	r2, r7, #0
 c0e:	32ff      	adds	r2, #255	; 0xff
 c10:	4b2d      	ldr	r3, [pc, #180]	; (cc8 <compress_light+0x158>)
 c12:	b292      	uxth	r2, r2
 c14:	429a      	cmp	r2, r3
 c16:	d804      	bhi.n	c22 <compress_light+0xb2>
            diff &= 0x1FF;
 c18:	05ff      	lsls	r7, r7, #23
 c1a:	0dff      	lsrs	r7, r7, #23
            len = 9;
            len_mode = 2;
 c1c:	2402      	movs	r4, #2
            len = 6;
            len_mode = 1;
        }
        else if(diff < 255 && diff > -256) {    // 9 bit storage
            diff &= 0x1FF;
            len = 9;
 c1e:	2509      	movs	r5, #9
 c20:	e002      	b.n	c28 <compress_light+0xb8>
            len_mode = 2;
        }
        else {  // just store raw data
            diff = log_light;
 c22:	1c37      	adds	r7, r6, #0
            len = 11;
            len_mode = 3;
 c24:	2403      	movs	r4, #3
            len = 9;
            len_mode = 2;
        }
        else {  // just store raw data
            diff = log_light;
            len = 11;
 c26:	250b      	movs	r5, #11
            len_mode = 3;
        }

        // check if need to commit L2 header
        if(cur_len_mode != 0xFF && len_mode != cur_len_mode) {
 c28:	4b25      	ldr	r3, [pc, #148]	; (cc0 <compress_light+0x150>)
 c2a:	781a      	ldrb	r2, [r3, #0]
 c2c:	2aff      	cmp	r2, #255	; 0xff
 c2e:	d008      	beq.n	c42 <compress_light+0xd2>
 c30:	781b      	ldrb	r3, [r3, #0]
 c32:	429c      	cmp	r4, r3
 c34:	d005      	beq.n	c42 <compress_light+0xd2>
    lnt_l1_len = 0;
    lnt_l2_len = 0;
}

static void store_l2_header() {
    if(lnt_l2_len == 0) {
 c36:	4b1f      	ldr	r3, [pc, #124]	; (cb4 <compress_light+0x144>)
 c38:	781b      	ldrb	r3, [r3, #0]
 c3a:	2b00      	cmp	r3, #0
 c3c:	d001      	beq.n	c42 <compress_light+0xd2>
 c3e:	f7ff fd69 	bl	714 <store_l2_header.part.3>

        // check if need to commit L2 header
        if(cur_len_mode != 0xFF && len_mode != cur_len_mode) {
            store_l2_header();
        }
        cur_len_mode = len_mode;
 c42:	4b1f      	ldr	r3, [pc, #124]	; (cc0 <compress_light+0x150>)

        // check if need to commit L1 header
        if(lnt_meas_time_mode != l1_cur_meas_time_mode) {
 c44:	4a1c      	ldr	r2, [pc, #112]	; (cb8 <compress_light+0x148>)

        // check if need to commit L2 header
        if(cur_len_mode != 0xFF && len_mode != cur_len_mode) {
            store_l2_header();
        }
        cur_len_mode = len_mode;
 c46:	701c      	strb	r4, [r3, #0]

        // check if need to commit L1 header
        if(lnt_meas_time_mode != l1_cur_meas_time_mode) {
 c48:	4b1c      	ldr	r3, [pc, #112]	; (cbc <compress_light+0x14c>)
 c4a:	7810      	ldrb	r0, [r2, #0]
 c4c:	7819      	ldrb	r1, [r3, #0]
 c4e:	4288      	cmp	r0, r1
 c50:	d005      	beq.n	c5e <compress_light+0xee>
    light_storage_remainder -= len;
    return 0;
}

static void store_l1_header() {
    if(lnt_l1_len == 0) {
 c52:	4b17      	ldr	r3, [pc, #92]	; (cb0 <compress_light+0x140>)
 c54:	781b      	ldrb	r3, [r3, #0]
 c56:	2b00      	cmp	r3, #0
 c58:	d001      	beq.n	c5e <compress_light+0xee>
 c5a:	f7ff fd45 	bl	6e8 <store_l1_header.part.2>

        // check if need to commit L1 header
        if(lnt_meas_time_mode != l1_cur_meas_time_mode) {
            store_l1_header();
        }
        l1_cur_meas_time_mode = lnt_meas_time_mode;
 c5e:	4a16      	ldr	r2, [pc, #88]	; (cb8 <compress_light+0x148>)
 c60:	7813      	ldrb	r3, [r2, #0]
 c62:	4a16      	ldr	r2, [pc, #88]	; (cbc <compress_light+0x14c>)
 c64:	7013      	strb	r3, [r2, #0]

        uint8_t needed_len = 2 + 3 + 2 + 6 - len_mode + len;  // reserve space for all the headers

        if(light_storage_remainder < needed_len) {
 c66:	4a0e      	ldr	r2, [pc, #56]	; (ca0 <compress_light+0x130>)
 c68:	7813      	ldrb	r3, [r2, #0]
        if(lnt_meas_time_mode != l1_cur_meas_time_mode) {
            store_l1_header();
        }
        l1_cur_meas_time_mode = lnt_meas_time_mode;

        uint8_t needed_len = 2 + 3 + 2 + 6 - len_mode + len;  // reserve space for all the headers
 c6a:	1c2a      	adds	r2, r5, #0
 c6c:	320d      	adds	r2, #13
 c6e:	1b14      	subs	r4, r2, r4

        if(light_storage_remainder < needed_len) {
 c70:	b2e4      	uxtb	r4, r4
 c72:	42a3      	cmp	r3, r4
 c74:	d206      	bcs.n	c84 <compress_light+0x114>
            // need to switch to new unit
            // store current and return 1
            // system will try again
            store_light();
 c76:	f7ff fd89 	bl	78c <store_light>

            light_storage_remainder = 160;           
 c7a:	4a09      	ldr	r2, [pc, #36]	; (ca0 <compress_light+0x130>)
 c7c:	23a0      	movs	r3, #160	; 0xa0
 c7e:	7013      	strb	r3, [r2, #0]
            return 1;
 c80:	2001      	movs	r0, #1
 c82:	e00a      	b.n	c9a <compress_light+0x12a>
        }
        light_left_shift_store(diff, len);
 c84:	b238      	sxth	r0, r7
 c86:	1c29      	adds	r1, r5, #0
 c88:	f7ff fcca 	bl	620 <light_left_shift_store>
        lnt_l2_len++;
 c8c:	4b09      	ldr	r3, [pc, #36]	; (cb4 <compress_light+0x144>)
 c8e:	781a      	ldrb	r2, [r3, #0]
 c90:	3201      	adds	r2, #1
 c92:	701a      	strb	r2, [r3, #0]
    }
    last_log_light = log_light;
 c94:	4b0b      	ldr	r3, [pc, #44]	; (cc4 <compress_light+0x154>)
    return 0;
 c96:	2000      	movs	r0, #0
            return 1;
        }
        light_left_shift_store(diff, len);
        lnt_l2_len++;
    }
    last_log_light = log_light;
 c98:	801e      	strh	r6, [r3, #0]
    return 0;
}
 c9a:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 c9c:	00001db0 	.word	0x00001db0
 ca0:	00001d3c 	.word	0x00001d3c
 ca4:	00001d58 	.word	0x00001d58
 ca8:	00001dff 	.word	0x00001dff
 cac:	00001d84 	.word	0x00001d84
 cb0:	00001dfe 	.word	0x00001dfe
 cb4:	00001de3 	.word	0x00001de3
 cb8:	00001daa 	.word	0x00001daa
 cbc:	00001dfc 	.word	0x00001dfc
 cc0:	00001d3e 	.word	0x00001d3e
 cc4:	00001df4 	.word	0x00001df4
 cc8:	000001fd 	.word	0x000001fd

Disassembly of section .text.crcEnc16:

00000ccc <crcEnc16>:

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 ccc:	4b1c      	ldr	r3, [pc, #112]	; (d40 <crcEnc16+0x74>)

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
{
 cce:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 cd0:	689a      	ldr	r2, [r3, #8]
 cd2:	685f      	ldr	r7, [r3, #4]
 cd4:	0412      	lsls	r2, r2, #16
 cd6:	0c3f      	lsrs	r7, r7, #16
 cd8:	18bf      	adds	r7, r7, r2
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 cda:	685a      	ldr	r2, [r3, #4]
 cdc:	6819      	ldr	r1, [r3, #0]
 cde:	0412      	lsls	r2, r2, #16
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 ce0:	681c      	ldr	r4, [r3, #0]
    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 ce2:	0c09      	lsrs	r1, r1, #16
 ce4:	1889      	adds	r1, r1, r2
    // intialization
    uint32_t i;

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
 ce6:	2200      	movs	r2, #0
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 ce8:	468c      	mov	ip, r1
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 cea:	0424      	lsls	r4, r4, #16

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 cec:	1c13      	adds	r3, r2, #0
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 cee:	b295      	uxth	r5, r2
 cf0:	b229      	sxth	r1, r5
            MSB = 0xffff;
        else
            MSB = 0x0000;
 cf2:	2000      	movs	r0, #0
    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 cf4:	4281      	cmp	r1, r0
 cf6:	da00      	bge.n	cfa <crcEnc16+0x2e>
            MSB = 0xffff;
 cf8:	4812      	ldr	r0, [pc, #72]	; (d44 <crcEnc16+0x78>)
        else
            MSB = 0x0000;

        if (i < 32)
 cfa:	2b1f      	cmp	r3, #31
 cfc:	d803      	bhi.n	d06 <crcEnc16+0x3a>
            input_bit = ((data2 << i) > 0x7fffffff);
 cfe:	1c39      	adds	r1, r7, #0
 d00:	4099      	lsls	r1, r3
 d02:	0fc9      	lsrs	r1, r1, #31
 d04:	e009      	b.n	d1a <crcEnc16+0x4e>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 d06:	1c19      	adds	r1, r3, #0
        else
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
 d08:	2b3f      	cmp	r3, #63	; 0x3f
 d0a:	d802      	bhi.n	d12 <crcEnc16+0x46>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 d0c:	3920      	subs	r1, #32
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
 d0e:	4666      	mov	r6, ip
 d10:	e001      	b.n	d16 <crcEnc16+0x4a>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 d12:	3940      	subs	r1, #64	; 0x40
        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;
 d14:	1c26      	adds	r6, r4, #0
 d16:	408e      	lsls	r6, r1
 d18:	0ff1      	lsrs	r1, r6, #31

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 d1a:	0bed      	lsrs	r5, r5, #15
 d1c:	4069      	eors	r1, r5
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 d1e:	0052      	lsls	r2, r2, #1
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 d20:	4d09      	ldr	r5, [pc, #36]	; (d48 <crcEnc16+0x7c>)
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 d22:	b292      	uxth	r2, r2
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 d24:	4015      	ands	r5, r2
 d26:	4042      	eors	r2, r0
 d28:	4808      	ldr	r0, [pc, #32]	; (d4c <crcEnc16+0x80>)
 d2a:	1949      	adds	r1, r1, r5
 d2c:	4002      	ands	r2, r0
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 d2e:	3301      	adds	r3, #1
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 d30:	430a      	orrs	r2, r1
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 d32:	2b60      	cmp	r3, #96	; 0x60
 d34:	d1db      	bne.n	cee <crcEnc16+0x22>
        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
    }

    static uint32_t msg_out[1];
    msg_out[0] = data0 + remainder;
 d36:	4806      	ldr	r0, [pc, #24]	; (d50 <crcEnc16+0x84>)
 d38:	1912      	adds	r2, r2, r4
 d3a:	6002      	str	r2, [r0, #0]
    //radio_data_arr[0] = data2;
    //radio_data_arr[1] = data1;
    //radio_data_arr[2] = data0;

    return msg_out;    
}
 d3c:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
 d3e:	46c0      	nop			; (mov r8, r8)
 d40:	00001d9c 	.word	0x00001d9c
 d44:	0000ffff 	.word	0x0000ffff
 d48:	00003ffd 	.word	0x00003ffd
 d4c:	ffffc002 	.word	0xffffc002
 d50:	00001de8 	.word	0x00001de8

Disassembly of section .text.mrr_send_radio_data:

00000d54 <mrr_send_radio_data>:

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
     d54:	b5f0      	push	{r4, r5, r6, r7, lr}
     d56:	b085      	sub	sp, #20
     d58:	9003      	str	r0, [sp, #12]
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
     d5a:	f7ff ffb7 	bl	ccc <crcEnc16>
    mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
     d5e:	4bb1      	ldr	r3, [pc, #708]	; (1024 <mrr_send_radio_data+0x2d0>)
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
     d60:	9001      	str	r0, [sp, #4]
    mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
     d62:	781f      	ldrb	r7, [r3, #0]
     d64:	2f00      	cmp	r7, #0
     d66:	d000      	beq.n	d6a <mrr_send_radio_data+0x16>
     d68:	e083      	b.n	e72 <mrr_send_radio_data+0x11e>

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
     d6a:	4daf      	ldr	r5, [pc, #700]	; (1028 <mrr_send_radio_data+0x2d4>)
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
        radio_on = 1;
     d6c:	2601      	movs	r6, #1
     d6e:	701e      	strb	r6, [r3, #0]

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
     d70:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     d72:	2002      	movs	r0, #2

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
     d74:	43b3      	bics	r3, r6
     d76:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     d78:	682a      	ldr	r2, [r5, #0]
     d7a:	1c39      	adds	r1, r7, #0
     d7c:	f7ff fa5b 	bl	236 <mbus_remote_register_write>

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
     d80:	4caa      	ldr	r4, [pc, #680]	; (102c <mrr_send_radio_data+0x2d8>)
     d82:	4bab      	ldr	r3, [pc, #684]	; (1030 <mrr_send_radio_data+0x2dc>)
     d84:	6822      	ldr	r2, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d86:	2002      	movs	r0, #2
    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
     d88:	4013      	ands	r3, r2
     d8a:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d8c:	6822      	ldr	r2, [r4, #0]
     d8e:	2103      	movs	r1, #3
     d90:	f7ff fa51 	bl	236 <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
     d94:	6822      	ldr	r2, [r4, #0]
     d96:	2380      	movs	r3, #128	; 0x80
     d98:	031b      	lsls	r3, r3, #12
     d9a:	4313      	orrs	r3, r2
     d9c:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d9e:	6822      	ldr	r2, [r4, #0]
     da0:	2103      	movs	r1, #3
     da2:	2002      	movs	r0, #2
     da4:	f7ff fa47 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
     da8:	2064      	movs	r0, #100	; 0x64
     daa:	f7ff f9bd 	bl	128 <delay>

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
     dae:	6822      	ldr	r2, [r4, #0]
     db0:	4ba0      	ldr	r3, [pc, #640]	; (1034 <mrr_send_radio_data+0x2e0>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     db2:	2002      	movs	r0, #2
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    delay(MBUS_DELAY);

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
     db4:	4013      	ands	r3, r2
     db6:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     db8:	6822      	ldr	r2, [r4, #0]
     dba:	2103      	movs	r1, #3
     dbc:	f7ff fa3b 	bl	236 <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
     dc0:	6822      	ldr	r2, [r4, #0]
     dc2:	2380      	movs	r3, #128	; 0x80
     dc4:	02db      	lsls	r3, r3, #11
     dc6:	4313      	orrs	r3, r2
     dc8:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     dca:	6822      	ldr	r2, [r4, #0]
     dcc:	2103      	movs	r1, #3
     dce:	2002      	movs	r0, #2
     dd0:	f7ff fa31 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
     dd4:	2064      	movs	r0, #100	; 0x64
     dd6:	f7ff f9a7 	bl	128 <delay>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     dda:	682b      	ldr	r3, [r5, #0]
     ddc:	227e      	movs	r2, #126	; 0x7e
     dde:	4393      	bics	r3, r2
     de0:	2420      	movs	r4, #32
     de2:	4323      	orrs	r3, r4
     de4:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     de6:	682a      	ldr	r2, [r5, #0]
     de8:	2002      	movs	r0, #2
     dea:	1c39      	adds	r1, r7, #0
     dec:	f7ff fa23 	bl	236 <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
     df0:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     df2:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
     df4:	4333      	orrs	r3, r6
     df6:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     df8:	682a      	ldr	r2, [r5, #0]
     dfa:	1c39      	adds	r1, r7, #0
     dfc:	f7ff fa1b 	bl	236 <mbus_remote_register_write>

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
     e00:	4d8d      	ldr	r5, [pc, #564]	; (1038 <mrr_send_radio_data+0x2e4>)
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     e02:	2104      	movs	r1, #4
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
     e04:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     e06:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
     e08:	4333      	orrs	r3, r6
     e0a:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     e0c:	682a      	ldr	r2, [r5, #0]
     e0e:	f7ff fa12 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
     e12:	2064      	movs	r0, #100	; 0x64
     e14:	f7ff f988 	bl	128 <delay>

    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
     e18:	682b      	ldr	r3, [r5, #0]
     e1a:	2208      	movs	r2, #8
     e1c:	4393      	bics	r3, r2
     e1e:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     e20:	682a      	ldr	r2, [r5, #0]
     e22:	2104      	movs	r1, #4
     e24:	2002      	movs	r0, #2
     e26:	f7ff fa06 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
     e2a:	2064      	movs	r0, #100	; 0x64
     e2c:	f7ff f97c 	bl	128 <delay>

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
     e30:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     e32:	2104      	movs	r1, #4
    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
    delay(MBUS_DELAY);

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
     e34:	431c      	orrs	r4, r3
     e36:	602c      	str	r4, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     e38:	682a      	ldr	r2, [r5, #0]
     e3a:	2002      	movs	r0, #2
     e3c:	f7ff f9fb 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY);
     e40:	2064      	movs	r0, #100	; 0x64
     e42:	f7ff f971 	bl	128 <delay>

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
     e46:	682b      	ldr	r3, [r5, #0]
     e48:	2210      	movs	r2, #16
     e4a:	4393      	bics	r3, r2
     e4c:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     e4e:	682a      	ldr	r2, [r5, #0]
     e50:	2002      	movs	r0, #2
     e52:	2104      	movs	r1, #4
     e54:	f7ff f9ef 	bl	236 <mbus_remote_register_write>

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
     e58:	4b78      	ldr	r3, [pc, #480]	; (103c <mrr_send_radio_data+0x2e8>)
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     e5a:	2002      	movs	r0, #2

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
     e5c:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     e5e:	2111      	movs	r1, #17

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
     e60:	43b2      	bics	r2, r6
     e62:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     e64:	681a      	ldr	r2, [r3, #0]
     e66:	f7ff f9e6 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*5); // Freq stab
     e6a:	20fa      	movs	r0, #250	; 0xfa
     e6c:	40b0      	lsls	r0, r6
     e6e:	f7ff f95b 	bl	128 <delay>
    if(!radio_on) {
        radio_on = 1;
	radio_power_on();
    }
    
    mbus_remote_register_write(MRR_ADDR,0xD, radio_data_arr[0] & 0xFFFFFF);
     e72:	4c73      	ldr	r4, [pc, #460]	; (1040 <mrr_send_radio_data+0x2ec>)
     e74:	2002      	movs	r0, #2
     e76:	6822      	ldr	r2, [r4, #0]
     e78:	210d      	movs	r1, #13
     e7a:	0212      	lsls	r2, r2, #8
     e7c:	0a12      	lsrs	r2, r2, #8
     e7e:	f7ff f9da 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xE, (radio_data_arr[1] << 8) | (radio_data_arr[0] >> 24));
     e82:	6863      	ldr	r3, [r4, #4]
     e84:	6822      	ldr	r2, [r4, #0]
     e86:	021b      	lsls	r3, r3, #8
     e88:	0e12      	lsrs	r2, r2, #24
     e8a:	431a      	orrs	r2, r3
     e8c:	2002      	movs	r0, #2
     e8e:	210e      	movs	r1, #14
     e90:	f7ff f9d1 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xF, (radio_data_arr[2] << 16 | radio_data_arr[1] >> 16));
     e94:	68a3      	ldr	r3, [r4, #8]
     e96:	6862      	ldr	r2, [r4, #4]
     e98:	041b      	lsls	r3, r3, #16
     e9a:	0c12      	lsrs	r2, r2, #16
     e9c:	431a      	orrs	r2, r3
     e9e:	2002      	movs	r0, #2
     ea0:	210f      	movs	r1, #15
     ea2:	f7ff f9c8 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x10, ((crc_data[0] & 0xFFFF) << 8 | radio_data_arr[2] >> 8));
     ea6:	9901      	ldr	r1, [sp, #4]
     ea8:	68a3      	ldr	r3, [r4, #8]
     eaa:	880a      	ldrh	r2, [r1, #0]
     eac:	0a1b      	lsrs	r3, r3, #8
     eae:	0212      	lsls	r2, r2, #8
     eb0:	431a      	orrs	r2, r3
     eb2:	2002      	movs	r0, #2
     eb4:	2110      	movs	r1, #16
     eb6:	f7ff f9be 	bl	236 <mbus_remote_register_write>

    if (!radio_ready){
     eba:	4b62      	ldr	r3, [pc, #392]	; (1044 <mrr_send_radio_data+0x2f0>)
     ebc:	781d      	ldrb	r5, [r3, #0]
     ebe:	2d00      	cmp	r5, #0
     ec0:	d127      	bne.n	f12 <mrr_send_radio_data+0x1be>
	radio_ready = 1;
     ec2:	2201      	movs	r2, #1
     ec4:	701a      	strb	r2, [r3, #0]

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
     ec6:	4b5d      	ldr	r3, [pc, #372]	; (103c <mrr_send_radio_data+0x2e8>)
     ec8:	2402      	movs	r4, #2
     eca:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     ecc:	2111      	movs	r1, #17

    if (!radio_ready){
	radio_ready = 1;

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
     ece:	4322      	orrs	r2, r4
     ed0:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     ed2:	681a      	ldr	r2, [r3, #0]
     ed4:	1c20      	adds	r0, r4, #0
     ed6:	f7ff f9ae 	bl	236 <mbus_remote_register_write>
	delay(MBUS_DELAY);
     eda:	2064      	movs	r0, #100	; 0x64
     edc:	f7ff f924 	bl	128 <delay>

	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
     ee0:	4b52      	ldr	r3, [pc, #328]	; (102c <mrr_send_radio_data+0x2d8>)
     ee2:	2280      	movs	r2, #128	; 0x80
     ee4:	6819      	ldr	r1, [r3, #0]
     ee6:	0352      	lsls	r2, r2, #13
     ee8:	430a      	orrs	r2, r1
     eea:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
     eec:	681a      	ldr	r2, [r3, #0]
     eee:	2103      	movs	r1, #3
     ef0:	1c20      	adds	r0, r4, #0
     ef2:	f7ff f9a0 	bl	236 <mbus_remote_register_write>
	delay(MBUS_DELAY);
     ef6:	2064      	movs	r0, #100	; 0x64
     ef8:	f7ff f916 	bl	128 <delay>

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     efc:	4b4a      	ldr	r3, [pc, #296]	; (1028 <mrr_send_radio_data+0x2d4>)
     efe:	217e      	movs	r1, #126	; 0x7e
     f00:	681a      	ldr	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     f02:	1c20      	adds	r0, r4, #0
	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
	delay(MBUS_DELAY);

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     f04:	438a      	bics	r2, r1
     f06:	4322      	orrs	r2, r4
     f08:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     f0a:	681a      	ldr	r2, [r3, #0]
     f0c:	1c29      	adds	r1, r5, #0
     f0e:	f7ff f992 	bl	236 <mbus_remote_register_write>

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
     f12:	4b4d      	ldr	r3, [pc, #308]	; (1048 <mrr_send_radio_data+0x2f4>)
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
     f14:	2101      	movs	r1, #1
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
     f16:	781a      	ldrb	r2, [r3, #0]
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
     f18:	9102      	str	r1, [sp, #8]
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
     f1a:	2a00      	cmp	r2, #0
     f1c:	d001      	beq.n	f22 <mrr_send_radio_data+0x1ce>
     f1e:	781b      	ldrb	r3, [r3, #0]
     f20:	9302      	str	r3, [sp, #8]

    mrr_cfo_val_fine = 0x2000;
     f22:	2380      	movs	r3, #128	; 0x80
     f24:	019b      	lsls	r3, r3, #6
     f26:	9301      	str	r3, [sp, #4]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    }

#ifdef USE_RAD
    uint8_t count = 0;
     f28:	2700      	movs	r7, #0
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    mrr_cfo_val_fine = 0x2000;

    while (count < num_packets){
     f2a:	e05f      	b.n	fec <mrr_send_radio_data+0x298>
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
     f2c:	4b47      	ldr	r3, [pc, #284]	; (104c <mrr_send_radio_data+0x2f8>)
     f2e:	2400      	movs	r4, #0
     f30:	601c      	str	r4, [r3, #0]
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     f32:	4b47      	ldr	r3, [pc, #284]	; (1050 <mrr_send_radio_data+0x2fc>)

	// mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
     f34:	9a01      	ldr	r2, [sp, #4]
    mrr_cfo_val_fine = 0x2000;

    while (count < num_packets){
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     f36:	601c      	str	r4, [r3, #0]

	// mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
     f38:	4b46      	ldr	r3, [pc, #280]	; (1054 <mrr_send_radio_data+0x300>)
     f3a:	213f      	movs	r1, #63	; 0x3f
     f3c:	6818      	ldr	r0, [r3, #0]
     f3e:	4011      	ands	r1, r2
     f40:	4a45      	ldr	r2, [pc, #276]	; (1058 <mrr_send_radio_data+0x304>)
     f42:	0289      	lsls	r1, r1, #10
     f44:	4002      	ands	r2, r0
     f46:	430a      	orrs	r2, r1
     f48:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
     f4a:	681a      	ldr	r2, [r3, #0]
     f4c:	2002      	movs	r0, #2
     f4e:	2101      	movs	r1, #1
     f50:	f7ff f971 	bl	236 <mbus_remote_register_write>
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
     f54:	4b41      	ldr	r3, [pc, #260]	; (105c <mrr_send_radio_data+0x308>)
    config_timer32(val, 1, 0, 0);
     f56:	20a0      	movs	r0, #160	; 0xa0
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
     f58:	701c      	strb	r4, [r3, #0]
    config_timer32(val, 1, 0, 0);
     f5a:	0300      	lsls	r0, r0, #12
     f5c:	2101      	movs	r1, #1
     f5e:	1c22      	adds	r2, r4, #0
     f60:	1c23      	adds	r3, r4, #0
     f62:	f7ff f8eb 	bl	13c <config_timer32>

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
     f66:	4e30      	ldr	r6, [pc, #192]	; (1028 <mrr_send_radio_data+0x2d4>)
     f68:	2101      	movs	r1, #1
     f6a:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     f6c:	2002      	movs	r0, #2

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
     f6e:	430b      	orrs	r3, r1
     f70:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     f72:	6832      	ldr	r2, [r6, #0]
     f74:	1c21      	adds	r1, r4, #0
     f76:	f7ff f95e 	bl	236 <mbus_remote_register_write>

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
     f7a:	4d30      	ldr	r5, [pc, #192]	; (103c <mrr_send_radio_data+0x2e8>)
     f7c:	2204      	movs	r2, #4
     f7e:	882b      	ldrh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     f80:	2111      	movs	r1, #17
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
     f82:	4313      	orrs	r3, r2
     f84:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     f86:	682a      	ldr	r2, [r5, #0]
     f88:	2002      	movs	r0, #2
     f8a:	f7ff f954 	bl	236 <mbus_remote_register_write>

    // Wait for radio response
    WFI();
     f8e:	f7ff f8d3 	bl	138 <WFI>
    config_timer32(val, 1, 0, 0);
}

static void stop_timer32_timeout_check(){
    // Turn off Timer32
    *TIMER32_GO = 0;
     f92:	4b33      	ldr	r3, [pc, #204]	; (1060 <mrr_send_radio_data+0x30c>)
     f94:	601c      	str	r4, [r3, #0]
    if (wfi_timeout_flag){
     f96:	4b31      	ldr	r3, [pc, #196]	; (105c <mrr_send_radio_data+0x308>)
     f98:	7819      	ldrb	r1, [r3, #0]
     f9a:	42a1      	cmp	r1, r4
     f9c:	d007      	beq.n	fae <mrr_send_radio_data+0x25a>
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
     f9e:	2180      	movs	r1, #128	; 0x80
     fa0:	04c9      	lsls	r1, r1, #19
     fa2:	20af      	movs	r0, #175	; 0xaf

static void stop_timer32_timeout_check(){
    // Turn off Timer32
    *TIMER32_GO = 0;
    if (wfi_timeout_flag){
        wfi_timeout_flag = 0;
     fa4:	701c      	strb	r4, [r3, #0]
    operation_sleep();
}

static void sys_err(uint32_t code)
{
    mbus_write_message32(0xAF, code);
     fa6:	f7ff f905 	bl	1b4 <mbus_write_message32>
    operation_sleep_notimer();
     faa:	f7ff fae5 	bl	578 <operation_sleep_notimer>
    // Wait for radio response
    WFI();
    stop_timer32_timeout_check();

    // Turn off Current Limter
    mrrv7_r00.MRR_CL_EN = 0;
     fae:	6833      	ldr	r3, [r6, #0]
     fb0:	2201      	movs	r2, #1
     fb2:	4393      	bics	r3, r2
     fb4:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     fb6:	6832      	ldr	r2, [r6, #0]
     fb8:	2002      	movs	r0, #2
     fba:	f7ff f93c 	bl	236 <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
     fbe:	882b      	ldrh	r3, [r5, #0]
     fc0:	2104      	movs	r1, #4
     fc2:	438b      	bics	r3, r1
     fc4:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     fc6:	682a      	ldr	r2, [r5, #0]
     fc8:	2002      	movs	r0, #2
     fca:	2111      	movs	r1, #17
     fcc:	f7ff f933 	bl	236 <mbus_remote_register_write>

	// mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
     fd0:	3701      	adds	r7, #1
	if (count < num_packets){
     fd2:	9a02      	ldr	r2, [sp, #8]

	// mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
     fd4:	b2ff      	uxtb	r7, r7
	if (count < num_packets){
     fd6:	4297      	cmp	r7, r2
     fd8:	d202      	bcs.n	fe0 <mrr_send_radio_data+0x28c>
		delay(RADIO_PACKET_DELAY);
     fda:	4822      	ldr	r0, [pc, #136]	; (1064 <mrr_send_radio_data+0x310>)
     fdc:	f7ff f8a4 	bl	128 <delay>
	}
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
     fe0:	4b21      	ldr	r3, [pc, #132]	; (1068 <mrr_send_radio_data+0x314>)
     fe2:	9901      	ldr	r1, [sp, #4]
     fe4:	781b      	ldrb	r3, [r3, #0]
     fe6:	18cb      	adds	r3, r1, r3
     fe8:	b29b      	uxth	r3, r3
     fea:	9301      	str	r3, [sp, #4]
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    mrr_cfo_val_fine = 0x2000;

    while (count < num_packets){
     fec:	9a02      	ldr	r2, [sp, #8]
     fee:	4297      	cmp	r7, r2
     ff0:	d19c      	bne.n	f2c <mrr_send_radio_data+0x1d8>
		delay(RADIO_PACKET_DELAY);
	}
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
    }

    radio_packet_count++;
     ff2:	4b1e      	ldr	r3, [pc, #120]	; (106c <mrr_send_radio_data+0x318>)
     ff4:	681a      	ldr	r2, [r3, #0]
     ff6:	3201      	adds	r2, #1
     ff8:	601a      	str	r2, [r3, #0]
#endif

    if (last_packet){
     ffa:	9b03      	ldr	r3, [sp, #12]
     ffc:	2b00      	cmp	r3, #0
     ffe:	d005      	beq.n	100c <mrr_send_radio_data+0x2b8>
	radio_ready = 0;
    1000:	4b10      	ldr	r3, [pc, #64]	; (1044 <mrr_send_radio_data+0x2f0>)
    1002:	2200      	movs	r2, #0
    1004:	701a      	strb	r2, [r3, #0]
	radio_power_off();
    1006:	f7ff f987 	bl	318 <radio_power_off>
    100a:	e009      	b.n	1020 <mrr_send_radio_data+0x2cc>
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
    100c:	4b0b      	ldr	r3, [pc, #44]	; (103c <mrr_send_radio_data+0x2e8>)
    100e:	2104      	movs	r1, #4
    1010:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1012:	2002      	movs	r0, #2

    if (last_packet){
	radio_ready = 0;
	radio_power_off();
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
    1014:	438a      	bics	r2, r1
    1016:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1018:	681a      	ldr	r2, [r3, #0]
    101a:	2111      	movs	r1, #17
    101c:	f7ff f90b 	bl	236 <mbus_remote_register_write>
    }
}
    1020:	b005      	add	sp, #20
    1022:	bdf0      	pop	{r4, r5, r6, r7, pc}
    1024:	00001de2 	.word	0x00001de2
    1028:	00001d44 	.word	0x00001d44
    102c:	00001d48 	.word	0x00001d48
    1030:	fffbffff 	.word	0xfffbffff
    1034:	fff7ffff 	.word	0xfff7ffff
    1038:	00001d4c 	.word	0x00001d4c
    103c:	00001d50 	.word	0x00001d50
    1040:	00001d9c 	.word	0x00001d9c
    1044:	00001d7e 	.word	0x00001d7e
    1048:	00001d82 	.word	0x00001d82
    104c:	a0001200 	.word	0xa0001200
    1050:	a000007c 	.word	0xa000007c
    1054:	00001df0 	.word	0x00001df0
    1058:	ffff03ff 	.word	0xffff03ff
    105c:	00001dfd 	.word	0x00001dfd
    1060:	a0001100 	.word	0xa0001100
    1064:	000032c8 	.word	0x000032c8
    1068:	00001dcc 	.word	0x00001dcc
    106c:	00001dc8 	.word	0x00001dc8

Disassembly of section .text.set_goc_cmd:

00001070 <set_goc_cmd>:

/**********************************************
 * Interrupt handlers
 **********************************************/

void set_goc_cmd() {
    1070:	b508      	push	{r3, lr}
    goc_component = (*GOC_DATA_IRQ >> 24) & 0xFF;
    1072:	238c      	movs	r3, #140	; 0x8c
    1074:	6819      	ldr	r1, [r3, #0]
    1076:	4a0c      	ldr	r2, [pc, #48]	; (10a8 <set_goc_cmd+0x38>)
    1078:	0e09      	lsrs	r1, r1, #24
    107a:	7011      	strb	r1, [r2, #0]
    goc_func_id = (*GOC_DATA_IRQ >> 16) & 0xFF;
    107c:	6819      	ldr	r1, [r3, #0]
    107e:	4a0b      	ldr	r2, [pc, #44]	; (10ac <set_goc_cmd+0x3c>)
    1080:	0c09      	lsrs	r1, r1, #16
    1082:	7011      	strb	r1, [r2, #0]
    goc_data = *GOC_DATA_IRQ & 0xFFFF;
    1084:	681a      	ldr	r2, [r3, #0]
    1086:	4b0a      	ldr	r3, [pc, #40]	; (10b0 <set_goc_cmd+0x40>)
    1088:	801a      	strh	r2, [r3, #0]
    goc_state = 0;
    108a:	4b0a      	ldr	r3, [pc, #40]	; (10b4 <set_goc_cmd+0x44>)
    108c:	2200      	movs	r2, #0
    108e:	701a      	strb	r2, [r3, #0]
    update_system_time();
    1090:	f7ff fc8e 	bl	9b0 <update_system_time>
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	xot_last_timer_list[i] = xo_sys_time;
    1094:	4a08      	ldr	r2, [pc, #32]	; (10b8 <set_goc_cmd+0x48>)
    1096:	4b09      	ldr	r3, [pc, #36]	; (10bc <set_goc_cmd+0x4c>)
    1098:	6811      	ldr	r1, [r2, #0]
    109a:	6019      	str	r1, [r3, #0]
    109c:	6811      	ldr	r1, [r2, #0]
    109e:	6059      	str	r1, [r3, #4]
    10a0:	6812      	ldr	r2, [r2, #0]
    10a2:	609a      	str	r2, [r3, #8]
    }
}
    10a4:	bd08      	pop	{r3, pc}
    10a6:	46c0      	nop			; (mov r8, r8)
    10a8:	00001d86 	.word	0x00001d86
    10ac:	00001d8c 	.word	0x00001d8c
    10b0:	00001d96 	.word	0x00001d96
    10b4:	00001db8 	.word	0x00001db8
    10b8:	00001e00 	.word	0x00001e00
    10bc:	00001d70 	.word	0x00001d70

Disassembly of section .text.handler_ext_int_wakeup:

000010c0 <handler_ext_int_wakeup>:
void handler_ext_int_reg1       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP
    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
    10c0:	4b01      	ldr	r3, [pc, #4]	; (10c8 <handler_ext_int_wakeup+0x8>)
    10c2:	2201      	movs	r2, #1
    10c4:	601a      	str	r2, [r3, #0]
}
    10c6:	4770      	bx	lr
    10c8:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_gocep:

000010cc <handler_ext_int_gocep>:

void handler_ext_int_gocep( void ) { // GOCEP
    10cc:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
    10ce:	4b04      	ldr	r3, [pc, #16]	; (10e0 <handler_ext_int_gocep+0x14>)
    10d0:	2204      	movs	r2, #4
    10d2:	601a      	str	r2, [r3, #0]
    set_goc_cmd();
    10d4:	f7ff ffcc 	bl	1070 <set_goc_cmd>
    reset_timers_list();
    10d8:	f7ff fc9e 	bl	a18 <reset_timers_list>
}
    10dc:	bd08      	pop	{r3, pc}
    10de:	46c0      	nop			; (mov r8, r8)
    10e0:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_timer32:

000010e4 <handler_ext_int_timer32>:

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
    10e4:	4b04      	ldr	r3, [pc, #16]	; (10f8 <handler_ext_int_timer32+0x14>)
    10e6:	2208      	movs	r2, #8
    10e8:	601a      	str	r2, [r3, #0]
    *TIMER32_STAT = 0x0;
    10ea:	4b04      	ldr	r3, [pc, #16]	; (10fc <handler_ext_int_timer32+0x18>)
    10ec:	2200      	movs	r2, #0
    10ee:	601a      	str	r2, [r3, #0]
    
    wfi_timeout_flag = 1;
    10f0:	4b03      	ldr	r3, [pc, #12]	; (1100 <handler_ext_int_timer32+0x1c>)
    10f2:	2201      	movs	r2, #1
    10f4:	701a      	strb	r2, [r3, #0]
}
    10f6:	4770      	bx	lr
    10f8:	e000e280 	.word	0xe000e280
    10fc:	a0001110 	.word	0xa0001110
    1100:	00001dfd 	.word	0x00001dfd

Disassembly of section .text.handler_ext_int_xot:

00001104 <handler_ext_int_xot>:

void handler_ext_int_xot( void ) { // TIMER32
    1104:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_XOT);
    1106:	2280      	movs	r2, #128	; 0x80
    1108:	4b02      	ldr	r3, [pc, #8]	; (1114 <handler_ext_int_xot+0x10>)
    110a:	0312      	lsls	r2, r2, #12
    110c:	601a      	str	r2, [r3, #0]
    update_system_time();
    110e:	f7ff fc4f 	bl	9b0 <update_system_time>
}
    1112:	bd08      	pop	{r3, pc}
    1114:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg0:

00001118 <handler_ext_int_reg0>:

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
    1118:	4b02      	ldr	r3, [pc, #8]	; (1124 <handler_ext_int_reg0+0xc>)
    111a:	2280      	movs	r2, #128	; 0x80
    111c:	0052      	lsls	r2, r2, #1
    111e:	601a      	str	r2, [r3, #0]
}
    1120:	4770      	bx	lr
    1122:	46c0      	nop			; (mov r8, r8)
    1124:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg1:

00001128 <handler_ext_int_reg1>:

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
    1128:	4b02      	ldr	r3, [pc, #8]	; (1134 <handler_ext_int_reg1+0xc>)
    112a:	2280      	movs	r2, #128	; 0x80
    112c:	0092      	lsls	r2, r2, #2
    112e:	601a      	str	r2, [r3, #0]
}
    1130:	4770      	bx	lr
    1132:	46c0      	nop			; (mov r8, r8)
    1134:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg2:

00001138 <handler_ext_int_reg2>:

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
    1138:	4b02      	ldr	r3, [pc, #8]	; (1144 <handler_ext_int_reg2+0xc>)
    113a:	2280      	movs	r2, #128	; 0x80
    113c:	00d2      	lsls	r2, r2, #3
    113e:	601a      	str	r2, [r3, #0]
}
    1140:	4770      	bx	lr
    1142:	46c0      	nop			; (mov r8, r8)
    1144:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg3:

00001148 <handler_ext_int_reg3>:

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
    1148:	4b02      	ldr	r3, [pc, #8]	; (1154 <handler_ext_int_reg3+0xc>)
    114a:	2280      	movs	r2, #128	; 0x80
    114c:	0112      	lsls	r2, r2, #4
    114e:	601a      	str	r2, [r3, #0]
}
    1150:	4770      	bx	lr
    1152:	46c0      	nop			; (mov r8, r8)
    1154:	e000e280 	.word	0xe000e280

Disassembly of section .text.startup.main:

00001158 <main>:

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1158:	b5f0      	push	{r4, r5, r6, r7, lr}
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
    115a:	4bfb      	ldr	r3, [pc, #1004]	; (1548 <main+0x3f0>)
    115c:	4afb      	ldr	r2, [pc, #1004]	; (154c <main+0x3f4>)
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
    115e:	4cfc      	ldr	r4, [pc, #1008]	; (1550 <main+0x3f8>)
 * MAIN function starts here
 **********************************************/

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
    1160:	601a      	str	r2, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
    1162:	6823      	ldr	r3, [r4, #0]
    1164:	4dfb      	ldr	r5, [pc, #1004]	; (1554 <main+0x3fc>)

/**********************************************
 * MAIN function starts here
 **********************************************/

int main() {
    1166:	b085      	sub	sp, #20
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
    1168:	42ab      	cmp	r3, r5
    116a:	d100      	bne.n	116e <main+0x16>
    116c:	e283      	b.n	1676 <main+0x51e>
 * Initialization functions
 **********************************************/

static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);
    116e:	2101      	movs	r1, #1
    1170:	20ba      	movs	r0, #186	; 0xba
    1172:	f7ff f81f 	bl	1b4 <mbus_write_message32>

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    1176:	4bf8      	ldr	r3, [pc, #992]	; (1558 <main+0x400>)
    1178:	2100      	movs	r1, #0
    117a:	6019      	str	r1, [r3, #0]
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    117c:	4bf7      	ldr	r3, [pc, #988]	; (155c <main+0x404>)
    config_timer32(0, 0, 0, 0);
    117e:	1c0a      	adds	r2, r1, #0
static void operation_init( void ) {
    // BREAKPOINT 0x01
    mbus_write_message32(0xBA, 0x01);

    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    1180:	6019      	str	r1, [r3, #0]
    config_timer32(0, 0, 0, 0);
    1182:	1c08      	adds	r0, r1, #0
    1184:	1c0b      	adds	r3, r1, #0
    1186:	f7fe ffd9 	bl	13c <config_timer32>

    // Enumeration
    enumerated = ENUMID;

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
    118a:	2006      	movs	r0, #6
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    config_timer32(0, 0, 0, 0);

    // Enumeration
    enumerated = ENUMID;
    118c:	6025      	str	r5, [r4, #0]

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
    118e:	f7ff f831 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
    1192:	2064      	movs	r0, #100	; 0x64
    1194:	f7fe ffc8 	bl	128 <delay>
#endif
#ifdef USE_MRR
    mbus_enumerate(MRR_ADDR);
    1198:	2002      	movs	r0, #2
    119a:	f7ff f82b 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
    119e:	2064      	movs	r0, #100	; 0x64
    11a0:	f7fe ffc2 	bl	128 <delay>
#endif
#ifdef USE_LNT
    mbus_enumerate(LNT_ADDR);
    11a4:	2003      	movs	r0, #3
    11a6:	f7ff f825 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
    11aa:	2064      	movs	r0, #100	; 0x64
    11ac:	f7fe ffbc 	bl	128 <delay>
#endif
#ifdef USE_SNT
    mbus_enumerate(SNT_ADDR);
    11b0:	2004      	movs	r0, #4
    11b2:	f7ff f81f 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
    11b6:	2064      	movs	r0, #100	; 0x64
    11b8:	f7fe ffb6 	bl	128 <delay>
#endif
#ifdef USE_PMU
    mbus_enumerate(PMU_ADDR);
    11bc:	2005      	movs	r0, #5
    11be:	f7ff f819 	bl	1f4 <mbus_enumerate>
    delay(MBUS_DELAY);
    11c2:	2064      	movs	r0, #100	; 0x64
    11c4:	f7fe ffb0 	bl	128 <delay>
#endif

    // Default CPU halt function
    set_halt_until_mbus_tx();
    11c8:	f7fe ffe8 	bl	19c <set_halt_until_mbus_tx>
    }
    delay(MBUS_DELAY);
}

static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    11cc:	2000      	movs	r0, #0
    11ce:	f7ff f955 	bl	47c <pmu_setting_temp_based>
    set_halt_until_mbus_tx();
}

static void pmu_set_adc_period(uint32_t val) {
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    11d2:	203c      	movs	r0, #60	; 0x3c
    11d4:	49e2      	ldr	r1, [pc, #904]	; (1560 <main+0x408>)
    11d6:	f7ff f907 	bl	3e8 <pmu_reg_write>
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon

    // Register 0x36: PMU_EN_TICK_REPEAT_VBAT_ADJUST
    pmu_reg_write(0x36, val);
    11da:	2036      	movs	r0, #54	; 0x36
    11dc:	2101      	movs	r1, #1
    11de:	f7ff f903 	bl	3e8 <pmu_reg_write>

    // Register 0x33: PMU_EN_TICK_ADC_RESET
    pmu_reg_write(0x33, 2);
    11e2:	2033      	movs	r0, #51	; 0x33
    11e4:	2102      	movs	r1, #2
    11e6:	f7ff f8ff 	bl	3e8 <pmu_reg_write>

    // Register 0x34: PMU_ENTICK_ADC_CLK
    pmu_reg_write(0x34, 2);
    11ea:	2034      	movs	r0, #52	; 0x34
    11ec:	2102      	movs	r1, #2
    11ee:	f7ff f8fb 	bl	3e8 <pmu_reg_write>

    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    11f2:	203c      	movs	r0, #60	; 0x3c
    11f4:	49da      	ldr	r1, [pc, #872]	; (1560 <main+0x408>)
    11f6:	f7ff f8f7 	bl	3e8 <pmu_reg_write>
    }
}

static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
    11fa:	2186      	movs	r1, #134	; 0x86
    11fc:	200e      	movs	r0, #14
    11fe:	00c9      	lsls	r1, r1, #3
    1200:	f7ff f8f2 	bl	3e8 <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
    1204:	2045      	movs	r0, #69	; 0x45
    1206:	2148      	movs	r1, #72	; 0x48
    1208:	f7ff f8ee 	bl	3e8 <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
    120c:	203a      	movs	r0, #58	; 0x3a
    120e:	49d5      	ldr	r1, [pc, #852]	; (1564 <main+0x40c>)
    1210:	f7ff f8ea 	bl	3e8 <pmu_reg_write>
}

static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    1214:	203c      	movs	r0, #60	; 0x3c
    1216:	49d4      	ldr	r1, [pc, #848]	; (1568 <main+0x410>)
    1218:	f7ff f8e6 	bl	3e8 <pmu_reg_write>
#ifdef USE_PMU
    pmu_init();
#endif

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    121c:	4bd3      	ldr	r3, [pc, #844]	; (156c <main+0x414>)
    121e:	2640      	movs	r6, #64	; 0x40
    1220:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    1222:	2480      	movs	r4, #128	; 0x80
#ifdef USE_PMU
    pmu_init();
#endif

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    1224:	43b2      	bics	r2, r6
    1226:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    1228:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
    122a:	2004      	movs	r0, #4
    pmu_init();
#endif

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    122c:	43a2      	bics	r2, r4
    122e:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
    1230:	681a      	ldr	r2, [r3, #0]
    1232:	2101      	movs	r1, #1
    1234:	f7fe ffff 	bl	236 <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    1238:	4bcd      	ldr	r3, [pc, #820]	; (1570 <main+0x418>)
    123a:	27ff      	movs	r7, #255	; 0xff
    123c:	881a      	ldrh	r2, [r3, #0]
    123e:	2180      	movs	r1, #128	; 0x80
    1240:	403a      	ands	r2, r7
    1242:	0149      	lsls	r1, r1, #5
    1244:	430a      	orrs	r2, r1
    1246:	801a      	strh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    1248:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
    124a:	2004      	movs	r0, #4
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    124c:	43ba      	bics	r2, r7
    124e:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
    1250:	681a      	ldr	r2, [r3, #0]
    1252:	2107      	movs	r1, #7
    1254:	f7fe ffef 	bl	236 <mbus_remote_register_write>

    // snt_clk_init();
    operation_temp_run();
    1258:	f7ff faee 	bl	838 <operation_temp_run>
static void lnt_init() {
    //////// TIMER OPERATION //////////
    // make variables local to save space
    lntv1a_r01_t lntv1a_r01 = LNTv1A_R01_DEFAULT;
    lntv1a_r02_t lntv1a_r02 = LNTv1A_R02_DEFAULT;
    lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
    125c:	4bc5      	ldr	r3, [pc, #788]	; (1574 <main+0x41c>)
    125e:	240a      	movs	r4, #10
    1260:	401c      	ands	r4, r3
    1262:	9403      	str	r4, [sp, #12]
    lntv1a_r05_t lntv1a_r05 = LNTv1A_R05_DEFAULT;
    lntv1a_r06_t lntv1a_r06 = LNTv1A_R06_DEFAULT;
    lntv1a_r17_t lntv1a_r17 = LNTv1A_R17_DEFAULT;
    lntv1a_r20_t lntv1a_r20 = LNTv1A_R20_DEFAULT;
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    1264:	2301      	movs	r3, #1
    1266:	2402      	movs	r4, #2
    1268:	2780      	movs	r7, #128	; 0x80
    126a:	4323      	orrs	r3, r4
    126c:	033f      	lsls	r7, r7, #12
    126e:	2180      	movs	r1, #128	; 0x80
    1270:	431f      	orrs	r7, r3
    1272:	0389      	lsls	r1, r1, #14
    1274:	2280      	movs	r2, #128	; 0x80
    1276:	430f      	orrs	r7, r1
    1278:	03d2      	lsls	r2, r2, #15
    127a:	2380      	movs	r3, #128	; 0x80
    127c:	4317      	orrs	r7, r2
    127e:	041b      	lsls	r3, r3, #16
    lntv1a_r22_t lntv1a_r22 = LNTv1A_R22_DEFAULT;
    1280:	2104      	movs	r1, #4
    1282:	2208      	movs	r2, #8
    lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
    lntv1a_r05_t lntv1a_r05 = LNTv1A_R05_DEFAULT;
    lntv1a_r06_t lntv1a_r06 = LNTv1A_R06_DEFAULT;
    lntv1a_r17_t lntv1a_r17 = LNTv1A_R17_DEFAULT;
    lntv1a_r20_t lntv1a_r20 = LNTv1A_R20_DEFAULT;
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    1284:	431f      	orrs	r7, r3
    lntv1a_r22_t lntv1a_r22 = LNTv1A_R22_DEFAULT;
    1286:	430a      	orrs	r2, r1
    1288:	2310      	movs	r3, #16
    128a:	2520      	movs	r5, #32
    128c:	431a      	orrs	r2, r3
    128e:	432a      	orrs	r2, r5
    lntv1a_r40_t lntv1a_r40 = LNTv1A_R40_DEFAULT;
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    1290:	2180      	movs	r1, #128	; 0x80
    1292:	4bb9      	ldr	r3, [pc, #740]	; (1578 <main+0x420>)
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    lntv1a_r22_t lntv1a_r22 = LNTv1A_R22_DEFAULT;
    lntv1a_r40_t lntv1a_r40 = LNTv1A_R40_DEFAULT;
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    1294:	4332      	orrs	r2, r6
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    1296:	0389      	lsls	r1, r1, #14
    1298:	430a      	orrs	r2, r1
    129a:	431a      	orrs	r2, r3
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    129c:	2122      	movs	r1, #34	; 0x22
    129e:	2003      	movs	r0, #3
    12a0:	f7fe ffc9 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    12a4:	20fa      	movs	r0, #250	; 0xfa
    12a6:	40a0      	lsls	r0, r4
    12a8:	f7fe ff3e 	bl	128 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    12ac:	4bb3      	ldr	r3, [pc, #716]	; (157c <main+0x424>)
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    12ae:	2121      	movs	r1, #33	; 0x21
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    12b0:	431f      	orrs	r7, r3
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    12b2:	1c3a      	adds	r2, r7, #0
    12b4:	2003      	movs	r0, #3
    12b6:	f7fe ffbe 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    12ba:	20fa      	movs	r0, #250	; 0xfa
    12bc:	40a0      	lsls	r0, r4
    12be:	f7fe ff33 	bl	128 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    12c2:	22c0      	movs	r2, #192	; 0xc0
    12c4:	1c31      	adds	r1, r6, #0
    12c6:	03d2      	lsls	r2, r2, #15
    12c8:	2003      	movs	r0, #3
    12ca:	f7fe ffb4 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    12ce:	20fa      	movs	r0, #250	; 0xfa
    12d0:	40a0      	lsls	r0, r4
    12d2:	f7fe ff29 	bl	128 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    12d6:	4baa      	ldr	r3, [pc, #680]	; (1580 <main+0x428>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    12d8:	2121      	movs	r1, #33	; 0x21
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    12da:	401f      	ands	r7, r3
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    12dc:	1c3a      	adds	r2, r7, #0
    12de:	2003      	movs	r0, #3
    12e0:	f7fe ffa9 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    12e4:	20fa      	movs	r0, #250	; 0xfa
    12e6:	40a0      	lsls	r0, r4
    12e8:	f7fe ff1e 	bl	128 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    12ec:	1c29      	adds	r1, r5, #0
    12ee:	2208      	movs	r2, #8
    12f0:	2003      	movs	r0, #3
    12f2:	f7fe ffa0 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    12f6:	20fa      	movs	r0, #250	; 0xfa
    12f8:	40a0      	lsls	r0, r4
    12fa:	f7fe ff15 	bl	128 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    12fe:	1c29      	adds	r1, r5, #0
    1300:	221e      	movs	r2, #30
    1302:	2003      	movs	r0, #3
    1304:	f7fe ff97 	bl	236 <mbus_remote_register_write>
    delay(2000); 
    1308:	20fa      	movs	r0, #250	; 0xfa
    130a:	00c0      	lsls	r0, r0, #3
    130c:	f7fe ff0c 	bl	128 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    1310:	1c29      	adds	r1, r5, #0
    1312:	221f      	movs	r2, #31
    1314:	2003      	movs	r0, #3
    1316:	f7fe ff8e 	bl	236 <mbus_remote_register_write>
    delay(10); 
    131a:	200a      	movs	r0, #10
    131c:	f7fe ff04 	bl	128 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
    1320:	2280      	movs	r2, #128	; 0x80
    1322:	0392      	lsls	r2, r2, #14
    1324:	433a      	orrs	r2, r7
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    1326:	2121      	movs	r1, #33	; 0x21
    1328:	2003      	movs	r0, #3
    132a:	f7fe ff84 	bl	236 <mbus_remote_register_write>
    delay(100000); 
    132e:	4895      	ldr	r0, [pc, #596]	; (1584 <main+0x42c>)
    1330:	f7fe fefa 	bl	128 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    1334:	1c29      	adds	r1, r5, #0
    1336:	2217      	movs	r2, #23
    1338:	2003      	movs	r0, #3
    133a:	f7fe ff7c 	bl	236 <mbus_remote_register_write>
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
    133e:	2701      	movs	r7, #1
    delay(100000); 
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    delay(100);
    1340:	2064      	movs	r0, #100	; 0x64
    1342:	f7fe fef1 	bl	128 <delay>
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
    lntv1a_r17.FDIV_CTRL_FREQ = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
    1346:	1c3a      	adds	r2, r7, #0
    1348:	2117      	movs	r1, #23
    134a:	2003      	movs	r0, #3
    delay(100);
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
    134c:	9702      	str	r7, [sp, #8]
    lntv1a_r17.FDIV_CTRL_FREQ = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
    134e:	f7fe ff72 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1352:	20fa      	movs	r0, #250	; 0xfa
    1354:	40a0      	lsls	r0, r4
    1356:	f7fe fee7 	bl	128 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    135a:	4a8b      	ldr	r2, [pc, #556]	; (1588 <main+0x430>)
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    135c:	9902      	ldr	r1, [sp, #8]
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    135e:	4322      	orrs	r2, r4
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    1360:	2003      	movs	r0, #3
    1362:	f7fe ff68 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1366:	20fa      	movs	r0, #250	; 0xfa
    1368:	40a0      	lsls	r0, r4
    136a:	f7fe fedd 	bl	128 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    136e:	4a87      	ldr	r2, [pc, #540]	; (158c <main+0x434>)
    1370:	2180      	movs	r1, #128	; 0x80
    1372:	430a      	orrs	r2, r1
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    1374:	2003      	movs	r0, #3
    1376:	1c21      	adds	r1, r4, #0
    1378:	f7fe ff5d 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    137c:	20fa      	movs	r0, #250	; 0xfa
    137e:	40a0      	lsls	r0, r4
    1380:	f7fe fed2 	bl	128 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    1384:	22c0      	movs	r2, #192	; 0xc0
    1386:	2310      	movs	r3, #16
    1388:	0292      	lsls	r2, r2, #10
    138a:	431a      	orrs	r2, r3
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    138c:	2003      	movs	r0, #3
    138e:	2105      	movs	r1, #5
    1390:	f7fe ff51 	bl	236 <mbus_remote_register_write>
    
    // Monitor AFEOUT
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    1394:	2106      	movs	r1, #6
    1396:	2200      	movs	r2, #0
    1398:	2003      	movs	r0, #3
    139a:	f7fe ff4c 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    139e:	20fa      	movs	r0, #250	; 0xfa
    13a0:	40a0      	lsls	r0, r4
    13a2:	f7fe fec1 	bl	128 <delay>
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    13a6:	4b7a      	ldr	r3, [pc, #488]	; (1590 <main+0x438>)
    13a8:	497a      	ldr	r1, [pc, #488]	; (1594 <main+0x43c>)
    13aa:	681a      	ldr	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    13ac:	2003      	movs	r0, #3
    lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    delay(MBUS_DELAY*10);
    
    // Change Counting Time 
    lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    13ae:	430a      	orrs	r2, r1
    13b0:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    13b2:	681a      	ldr	r2, [r3, #0]
    13b4:	1c01      	adds	r1, r0, #0
    13b6:	f7fe ff3e 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    13ba:	20fa      	movs	r0, #250	; 0xfa
    13bc:	40a0      	lsls	r0, r4
    13be:	f7fe feb3 	bl	128 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    13c2:	2104      	movs	r1, #4
    13c4:	9a03      	ldr	r2, [sp, #12]
    13c6:	2003      	movs	r0, #3
    13c8:	f7fe ff35 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    13cc:	20fa      	movs	r0, #250	; 0xfa
    13ce:	40a0      	lsls	r0, r4
    13d0:	f7fe feaa 	bl	128 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    13d4:	4d70      	ldr	r5, [pc, #448]	; (1598 <main+0x440>)
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    13d6:	2100      	movs	r1, #0
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    13d8:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    13da:	2003      	movs	r0, #3
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    13dc:	43bb      	bics	r3, r7
    13de:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    13e0:	682a      	ldr	r2, [r5, #0]
    13e2:	f7fe ff28 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    13e6:	20fa      	movs	r0, #250	; 0xfa
    13e8:	40a0      	lsls	r0, r4
    13ea:	f7fe fe9d 	bl	128 <delay>
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    13ee:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    13f0:	2100      	movs	r1, #0
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    13f2:	43a3      	bics	r3, r4
    13f4:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    13f6:	682a      	ldr	r2, [r5, #0]
    13f8:	2003      	movs	r0, #3
    13fa:	f7fe ff1c 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    13fe:	20fa      	movs	r0, #250	; 0xfa
    1400:	40a0      	lsls	r0, r4
    // MRR Settings --------------------------------------
    // using local variables to save space
    mrrv7_r02_t mrrv7_r02 = MRRv7_R02_DEFAULT;
    mrrv7_r07_t mrrv7_r07 = MRRv7_R07_DEFAULT;
    mrrv7_r14_t mrrv7_r14 = MRRv7_R14_DEFAULT;
    mrrv7_r15_t mrrv7_r15 = MRRv7_R15_DEFAULT;
    1402:	2780      	movs	r7, #128	; 0x80
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    1404:	f7fe fe90 	bl	128 <delay>
    // MRR Settings --------------------------------------
    // using local variables to save space
    mrrv7_r02_t mrrv7_r02 = MRRv7_R02_DEFAULT;
    mrrv7_r07_t mrrv7_r07 = MRRv7_R07_DEFAULT;
    mrrv7_r14_t mrrv7_r14 = MRRv7_R14_DEFAULT;
    mrrv7_r15_t mrrv7_r15 = MRRv7_R15_DEFAULT;
    1408:	043f      	lsls	r7, r7, #16
    mrrv7_r1F_t mrrv7_r1F = MRRv7_R1F_DEFAULT;

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    140a:	4d64      	ldr	r5, [pc, #400]	; (159c <main+0x444>)
    // MRR Settings --------------------------------------
    // using local variables to save space
    mrrv7_r02_t mrrv7_r02 = MRRv7_R02_DEFAULT;
    mrrv7_r07_t mrrv7_r07 = MRRv7_R07_DEFAULT;
    mrrv7_r14_t mrrv7_r14 = MRRv7_R14_DEFAULT;
    mrrv7_r15_t mrrv7_r15 = MRRv7_R15_DEFAULT;
    140c:	9703      	str	r7, [sp, #12]
    mrrv7_r1F_t mrrv7_r1F = MRRv7_R1F_DEFAULT;

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    140e:	682a      	ldr	r2, [r5, #0]
    1410:	4b63      	ldr	r3, [pc, #396]	; (15a0 <main+0x448>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1412:	1c20      	adds	r0, r4, #0
    mrrv7_r14_t mrrv7_r14 = MRRv7_R14_DEFAULT;
    mrrv7_r15_t mrrv7_r15 = MRRv7_R15_DEFAULT;
    mrrv7_r1F_t mrrv7_r1F = MRRv7_R1F_DEFAULT;

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    1414:	4013      	ands	r3, r2
    1416:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1418:	682a      	ldr	r2, [r5, #0]
    141a:	2103      	movs	r1, #3
    141c:	f7fe ff0b 	bl	236 <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    1420:	682a      	ldr	r2, [r5, #0]
    1422:	2380      	movs	r3, #128	; 0x80
    1424:	02db      	lsls	r3, r3, #11
    1426:	4313      	orrs	r3, r2
    1428:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    142a:	682a      	ldr	r2, [r5, #0]
    142c:	1c20      	adds	r0, r4, #0
    142e:	2103      	movs	r1, #3
    1430:	f7fe ff01 	bl	236 <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    1434:	4e5b      	ldr	r6, [pc, #364]	; (15a4 <main+0x44c>)
    1436:	227e      	movs	r2, #126	; 0x7e
    1438:	6833      	ldr	r3, [r6, #0]
    143a:	2110      	movs	r1, #16
    143c:	4393      	bics	r3, r2
    143e:	430b      	orrs	r3, r1
    1440:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1442:	6832      	ldr	r2, [r6, #0]
    1444:	1c20      	adds	r0, r4, #0
    1446:	2100      	movs	r1, #0
    1448:	f7fe fef5 	bl	236 <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    144c:	6833      	ldr	r3, [r6, #0]
    144e:	9f02      	ldr	r7, [sp, #8]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1450:	1c20      	adds	r0, r4, #0
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    1452:	433b      	orrs	r3, r7
    1454:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1456:	6832      	ldr	r2, [r6, #0]
    1458:	2100      	movs	r1, #0
    145a:	f7fe feec 	bl	236 <mbus_remote_register_write>

    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    145e:	4852      	ldr	r0, [pc, #328]	; (15a8 <main+0x450>)
    1460:	f7fe fe62 	bl	128 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    1464:	2103      	movs	r1, #3
    1466:	220c      	movs	r2, #12
    1468:	430a      	orrs	r2, r1
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    146a:	1c20      	adds	r0, r4, #0
    146c:	211f      	movs	r1, #31
    146e:	f7fe fee2 	bl	236 <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1472:	4b4e      	ldr	r3, [pc, #312]	; (15ac <main+0x454>)
    1474:	270c      	movs	r7, #12
    1476:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    1478:	494d      	ldr	r1, [pc, #308]	; (15b0 <main+0x458>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    147a:	0a92      	lsrs	r2, r2, #10
    147c:	0292      	lsls	r2, r2, #10
    147e:	433a      	orrs	r2, r7
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    1480:	4f4c      	ldr	r7, [pc, #304]	; (15b4 <main+0x45c>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1482:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    1484:	683a      	ldr	r2, [r7, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    1486:	1c20      	adds	r0, r4, #0
}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    1488:	0bd2      	lsrs	r2, r2, #15
    148a:	03d2      	lsls	r2, r2, #15
    148c:	430a      	orrs	r2, r1
    148e:	603a      	str	r2, [r7, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    1490:	6819      	ldr	r1, [r3, #0]
    1492:	4a49      	ldr	r2, [pc, #292]	; (15b8 <main+0x460>)
    1494:	400a      	ands	r2, r1
    1496:	21c8      	movs	r1, #200	; 0xc8
    1498:	01c9      	lsls	r1, r1, #7
    149a:	430a      	orrs	r2, r1
    149c:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    149e:	681a      	ldr	r2, [r3, #0]
    14a0:	2112      	movs	r1, #18
    14a2:	f7fe fec8 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    14a6:	1c20      	adds	r0, r4, #0
    14a8:	683a      	ldr	r2, [r7, #0]
    14aa:	2113      	movs	r1, #19
    14ac:	f7fe fec3 	bl	236 <mbus_remote_register_write>
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    14b0:	4b42      	ldr	r3, [pc, #264]	; (15bc <main+0x464>)
    mrr_freq_hopping_step = 4; // determining center freq

    mrr_cfo_val_fine_min = 0x0000;
    14b2:	4a43      	ldr	r2, [pc, #268]	; (15c0 <main+0x468>)
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    14b4:	701c      	strb	r4, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
    14b6:	4b43      	ldr	r3, [pc, #268]	; (15c4 <main+0x46c>)
    14b8:	2104      	movs	r1, #4
    14ba:	7019      	strb	r1, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
    14bc:	2300      	movs	r3, #0
    14be:	8013      	strh	r3, [r2, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    14c0:	2280      	movs	r2, #128	; 0x80
    14c2:	1c20      	adds	r0, r4, #0
    14c4:	2106      	movs	r1, #6
    14c6:	0152      	lsls	r2, r2, #5
    14c8:	f7fe feb5 	bl	236 <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
    14cc:	2280      	movs	r2, #128	; 0x80
    14ce:	1c20      	adds	r0, r4, #0
    14d0:	2108      	movs	r1, #8
    14d2:	03d2      	lsls	r2, r2, #15
    14d4:	f7fe feaf 	bl	236 <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    14d8:	2280      	movs	r2, #128	; 0x80
    14da:	2110      	movs	r1, #16
    14dc:	0112      	lsls	r2, r2, #4
    14de:	430a      	orrs	r2, r1
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    14e0:	1c20      	adds	r0, r4, #0
    14e2:	2107      	movs	r1, #7
    14e4:	f7fe fea7 	bl	236 <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    14e8:	6832      	ldr	r2, [r6, #0]
    14ea:	4b37      	ldr	r3, [pc, #220]	; (15c8 <main+0x470>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    14ec:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    14ee:	4013      	ands	r3, r2
    14f0:	22f8      	movs	r2, #248	; 0xf8
    14f2:	0112      	lsls	r2, r2, #4
    14f4:	4313      	orrs	r3, r2
    14f6:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    14f8:	6832      	ldr	r2, [r6, #0]
    14fa:	2100      	movs	r1, #0
    14fc:	f7fe fe9b 	bl	236 <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x01f; //ANT CAP 10b unary 830.5 MHz
    1500:	4b32      	ldr	r3, [pc, #200]	; (15cc <main+0x474>)
    1502:	211f      	movs	r1, #31
    1504:	681a      	ldr	r2, [r3, #0]
    // mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    1506:	263f      	movs	r6, #63	; 0x3f
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x01f;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x01f; //ANT CAP 10b unary 830.5 MHz
    1508:	0a92      	lsrs	r2, r2, #10
    150a:	0292      	lsls	r2, r2, #10
    150c:	430a      	orrs	r2, r1
    150e:	601a      	str	r2, [r3, #0]
    // mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    1510:	4a2b      	ldr	r2, [pc, #172]	; (15c0 <main+0x468>)
    1512:	8811      	ldrh	r1, [r2, #0]
    1514:	6818      	ldr	r0, [r3, #0]
    1516:	4a2e      	ldr	r2, [pc, #184]	; (15d0 <main+0x478>)
    1518:	4031      	ands	r1, r6
    151a:	0289      	lsls	r1, r1, #10
    151c:	4002      	ands	r2, r0
    151e:	430a      	orrs	r2, r1
    1520:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    1522:	681a      	ldr	r2, [r3, #0]
    1524:	1c20      	adds	r0, r4, #0
    1526:	9902      	ldr	r1, [sp, #8]
    1528:	f7fe fe85 	bl	236 <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    152c:	1c20      	adds	r0, r4, #0
    152e:	1c21      	adds	r1, r4, #0
    1530:	4a28      	ldr	r2, [pc, #160]	; (15d4 <main+0x47c>)
    1532:	f7fe fe80 	bl	236 <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    1536:	682a      	ldr	r2, [r5, #0]
    1538:	4b27      	ldr	r3, [pc, #156]	; (15d8 <main+0x480>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    153a:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    153c:	4013      	ands	r3, r2
    153e:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1540:	682a      	ldr	r2, [r5, #0]
    1542:	2103      	movs	r1, #3
    1544:	e04a      	b.n	15dc <main+0x484>
    1546:	46c0      	nop			; (mov r8, r8)
    1548:	e000e100 	.word	0xe000e100
    154c:	00080f0d 	.word	0x00080f0d
    1550:	00001d88 	.word	0x00001d88
    1554:	deadbeef 	.word	0xdeadbeef
    1558:	a0001200 	.word	0xa0001200
    155c:	a000007c 	.word	0xa000007c
    1560:	0017c7fd 	.word	0x0017c7fd
    1564:	00103800 	.word	0x00103800
    1568:	0017c7ff 	.word	0x0017c7ff
    156c:	00001d24 	.word	0x00001d24
    1570:	00001d2c 	.word	0x00001d2c
    1574:	ff000fff 	.word	0xff000fff
    1578:	001ffe80 	.word	0x001ffe80
    157c:	000080fc 	.word	0x000080fc
    1580:	ffdfffff 	.word	0xffdfffff
    1584:	000186a0 	.word	0x000186a0
    1588:	00003770 	.word	0x00003770
    158c:	0003ce67 	.word	0x0003ce67
    1590:	00001d1c 	.word	0x00001d1c
    1594:	00ffffff 	.word	0x00ffffff
    1598:	00001d40 	.word	0x00001d40
    159c:	00001d48 	.word	0x00001d48
    15a0:	fff7ffff 	.word	0xfff7ffff
    15a4:	00001d44 	.word	0x00001d44
    15a8:	00004e20 	.word	0x00004e20
    15ac:	00001d28 	.word	0x00001d28
    15b0:	00000451 	.word	0x00000451
    15b4:	00001d38 	.word	0x00001d38
    15b8:	fff003ff 	.word	0xfff003ff
    15bc:	00001d82 	.word	0x00001d82
    15c0:	00001d7c 	.word	0x00001d7c
    15c4:	00001dcc 	.word	0x00001dcc
    15c8:	fffe007f 	.word	0xfffe007f
    15cc:	00001df0 	.word	0x00001df0
    15d0:	ffff03ff 	.word	0xffff03ff
    15d4:	00039fff 	.word	0x00039fff
    15d8:	ffffbfff 	.word	0xffffbfff
    15dc:	f7fe fe2b 	bl<und>	236 <mbus_remote_register_write>	; unpredictable branch in IT block


    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    15e0:	9d03      	ldr<und>	r5, [sp, #12]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    15e2:	1c20      	add<und>	r0, r4, #0
    15e4:	2114      	movs	r1, #20
    15e6:	2200      	movs	r2, #0
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    15e8:	43b5      	bics	r5, r6
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    15ea:	f7fe fe24 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
    15ee:	1c20      	adds	r0, r4, #0
    15f0:	2115      	movs	r1, #21
    15f2:	1c2a      	adds	r2, r5, #0
    15f4:	f7fe fe1f 	bl	236 <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    15f8:	1c20      	adds	r0, r4, #0
    15fa:	2109      	movs	r1, #9
    15fc:	2200      	movs	r2, #0
    15fe:	f7fe fe1a 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    1602:	1c20      	adds	r0, r4, #0
    1604:	210a      	movs	r1, #10
    1606:	2200      	movs	r2, #0
    1608:	f7fe fe15 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    160c:	1c20      	adds	r0, r4, #0
    160e:	210b      	movs	r1, #11
    1610:	2200      	movs	r2, #0
    1612:	f7fe fe10 	bl	236 <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    1616:	1c20      	adds	r0, r4, #0
    1618:	210c      	movs	r1, #12
    161a:	4adf      	ldr	r2, [pc, #892]	; (1998 <main+0x840>)
    161c:	f7fe fe0b 	bl	236 <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    1620:	4bde      	ldr	r3, [pc, #888]	; (199c <main+0x844>)
    1622:	21f8      	movs	r1, #248	; 0xf8
    1624:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1626:	1c20      	adds	r0, r4, #0
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    1628:	438a      	bics	r2, r1
    162a:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    162c:	881a      	ldrh	r2, [r3, #0]
    162e:	21ff      	movs	r1, #255	; 0xff
    1630:	400a      	ands	r2, r1
    1632:	49db      	ldr	r1, [pc, #876]	; (19a0 <main+0x848>)
    1634:	430a      	orrs	r2, r1
    1636:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    1638:	681a      	ldr	r2, [r3, #0]
    163a:	2111      	movs	r1, #17
    163c:	f7fe fdfb 	bl	236 <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    1640:	683a      	ldr	r2, [r7, #0]
    1642:	4bd8      	ldr	r3, [pc, #864]	; (19a4 <main+0x84c>)
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1644:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    1646:	4013      	ands	r3, r2
    1648:	22c0      	movs	r2, #192	; 0xc0
    164a:	03d2      	lsls	r2, r2, #15
    164c:	4313      	orrs	r3, r2
    164e:	603b      	str	r3, [r7, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    1650:	683a      	ldr	r2, [r7, #0]
    1652:	2113      	movs	r1, #19
    1654:	f7fe fdef 	bl	236 <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
    1658:	1c20      	adds	r0, r4, #0
    165a:	211e      	movs	r1, #30
    165c:	4ad2      	ldr	r2, [pc, #840]	; (19a8 <main+0x850>)
    165e:	f7fe fdea 	bl	236 <mbus_remote_register_write>

    // Additional delay for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    1662:	48d2      	ldr	r0, [pc, #840]	; (19ac <main+0x854>)
    1664:	f7fe fd60 	bl	128 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    1668:	4bd1      	ldr	r3, [pc, #836]	; (19b0 <main+0x858>)
    166a:	2400      	movs	r4, #0
    166c:	701c      	strb	r4, [r3, #0]
    radio_ready = 0;
    166e:	4bd1      	ldr	r3, [pc, #836]	; (19b4 <main+0x85c>)
    1670:	701c      	strb	r4, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3 |
                  1 << IRQ_XOT);

    if(enumerated != ENUMID) {
        operation_init();
        operation_sleep_notimer();
    1672:	f7fe ff81 	bl	578 <operation_sleep_notimer>

    // original wakeup sequence
    pmu_setting_temp_based(1);
    update_system_time();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    1676:	4dd0      	ldr	r5, [pc, #832]	; (19b8 <main+0x860>)
        operation_init();
        operation_sleep_notimer();
    }

    // original wakeup sequence
    pmu_setting_temp_based(1);
    1678:	2001      	movs	r0, #1
    167a:	f7fe feff 	bl	47c <pmu_setting_temp_based>
    update_system_time();

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    167e:	248c      	movs	r4, #140	; 0x8c
        operation_sleep_notimer();
    }

    // original wakeup sequence
    pmu_setting_temp_based(1);
    update_system_time();
    1680:	f7ff f996 	bl	9b0 <update_system_time>

    mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    1684:	6829      	ldr	r1, [r5, #0]
    1686:	20ee      	movs	r0, #238	; 0xee
    1688:	f7fe fd94 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xEE, *GOC_DATA_IRQ);
    168c:	6821      	ldr	r1, [r4, #0]
    168e:	20ee      	movs	r0, #238	; 0xee
    1690:	f7fe fd90 	bl	1b4 <mbus_write_message32>

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
    1694:	682b      	ldr	r3, [r5, #0]
    1696:	07df      	lsls	r7, r3, #31
    1698:	d507      	bpl.n	16aa <main+0x552>
        if(!(*GOC_DATA_IRQ)) {
    169a:	6823      	ldr	r3, [r4, #0]
    169c:	2b00      	cmp	r3, #0
    169e:	d100      	bne.n	16a2 <main+0x54a>
    16a0:	e2c9      	b.n	1c36 <main+0xade>
            operation_sleep(); // Need to protect against spurious wakeups
        }
        set_goc_cmd();
    16a2:	f7ff fce5 	bl	1070 <set_goc_cmd>
        reset_timers_list();
    16a6:	f7ff f9b7 	bl	a18 <reset_timers_list>
    }

    sntv4_r17.WUP_ENABLE = 0;
    16aa:	4bc4      	ldr	r3, [pc, #784]	; (19bc <main+0x864>)
    16ac:	4ac4      	ldr	r2, [pc, #784]	; (19c0 <main+0x868>)
    16ae:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
    16b0:	2004      	movs	r0, #4
        }
        set_goc_cmd();
        reset_timers_list();
    }

    sntv4_r17.WUP_ENABLE = 0;
    16b2:	400a      	ands	r2, r1
    16b4:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
    16b6:	681a      	ldr	r2, [r3, #0]
    16b8:	2117      	movs	r1, #23
    16ba:	f7fe fdbc 	bl	236 <mbus_remote_register_write>

    mbus_write_message32(0xC0, xo_day_time >> 15);
    16be:	4bc1      	ldr	r3, [pc, #772]	; (19c4 <main+0x86c>)
    16c0:	20c0      	movs	r0, #192	; 0xc0
    16c2:	6819      	ldr	r1, [r3, #0]
    // delay(MBUS_DELAY*10);
    
    set_halt_until_mbus_trx();
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    set_halt_until_mbus_tx();
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0)) >> lnt_counter_base;
    16c4:	2400      	movs	r4, #0
    }

    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    mbus_write_message32(0xC0, xo_day_time >> 15);
    16c6:	0bc9      	lsrs	r1, r1, #15
    16c8:	f7fe fd74 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xC1, xo_sys_time >> 15);
    16cc:	4bbe      	ldr	r3, [pc, #760]	; (19c8 <main+0x870>)
    16ce:	20c1      	movs	r0, #193	; 0xc1
    16d0:	6819      	ldr	r1, [r3, #0]
    16d2:	0bc9      	lsrs	r1, r1, #15
    16d4:	f7fe fd6e 	bl	1b4 <mbus_write_message32>
    // // Change Counting Time 
    // lntv1a_r03.TIME_COUNTING = 0x000; // Default : 0x258
    // mbus_remote_register_write(LNT_ADDR,0x03,lntv1a_r03.as_int);
    // delay(MBUS_DELAY*10);
    
    set_halt_until_mbus_trx();
    16d8:	f7fe fd66 	bl	1a8 <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    16dc:	2003      	movs	r0, #3
    16de:	2110      	movs	r1, #16
    16e0:	2200      	movs	r2, #0
    16e2:	2301      	movs	r3, #1
    16e4:	f7fe fd96 	bl	214 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
    16e8:	f7fe fd58 	bl	19c <set_halt_until_mbus_tx>
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0)) >> lnt_counter_base;
    16ec:	4bb7      	ldr	r3, [pc, #732]	; (19cc <main+0x874>)
    16ee:	4ab8      	ldr	r2, [pc, #736]	; (19d0 <main+0x878>)
    16f0:	6818      	ldr	r0, [r3, #0]
    16f2:	23a0      	movs	r3, #160	; 0xa0
    16f4:	061b      	lsls	r3, r3, #24
    16f6:	681b      	ldr	r3, [r3, #0]
    16f8:	0600      	lsls	r0, r0, #24
    16fa:	7811      	ldrb	r1, [r2, #0]
    16fc:	4318      	orrs	r0, r3
    16fe:	4db5      	ldr	r5, [pc, #724]	; (19d4 <main+0x87c>)
    1700:	1c02      	adds	r2, r0, #0
    1702:	40ca      	lsrs	r2, r1
    1704:	1c23      	adds	r3, r4, #0
    1706:	602a      	str	r2, [r5, #0]
    1708:	606b      	str	r3, [r5, #4]
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    170a:	20e0      	movs	r0, #224	; 0xe0
    170c:	682a      	ldr	r2, [r5, #0]
    170e:	686b      	ldr	r3, [r5, #4]
    1710:	1c19      	adds	r1, r3, #0
    1712:	f7fe fd4f 	bl	1b4 <mbus_write_message32>
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);
    1716:	682a      	ldr	r2, [r5, #0]
    1718:	686b      	ldr	r3, [r5, #4]
    171a:	20e1      	movs	r0, #225	; 0xe1
    171c:	1c11      	adds	r1, r2, #0
    171e:	f7fe fd49 	bl	1b4 <mbus_write_message32>

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    1722:	4bad      	ldr	r3, [pc, #692]	; (19d8 <main+0x880>)
    1724:	2110      	movs	r1, #16
    1726:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1728:	2003      	movs	r0, #3
    lnt_sys_light = (((*REG1 & 0xFFFFFF) << 24) | (*REG0)) >> lnt_counter_base;
    mbus_write_message32(0xE0, lnt_sys_light >> 32);
    mbus_write_message32(0xE1, lnt_sys_light & 0xFFFFFFFF);

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
    172a:	438a      	bics	r2, r1
    172c:	701a      	strb	r2, [r3, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    172e:	781a      	ldrb	r2, [r3, #0]
    1730:	2140      	movs	r1, #64	; 0x40
    1732:	438a      	bics	r2, r1
    1734:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1736:	681a      	ldr	r2, [r3, #0]
    1738:	1c21      	adds	r1, r4, #0
    173a:	f7fe fd7c 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    173e:	48a7      	ldr	r0, [pc, #668]	; (19dc <main+0x884>)
    1740:	f7fe fcf2 	bl	128 <delay>
    mbus_write_message32(0xC0, xo_day_time >> 15);
    mbus_write_message32(0xC1, xo_sys_time >> 15);

    lnt_stop();

    operation_temp_run();
    1744:	f7ff f878 	bl	838 <operation_temp_run>
    // pmu_adc_read_latest();

    sys_run_continuous = 0;
    1748:	4ba5      	ldr	r3, [pc, #660]	; (19e0 <main+0x888>)
    174a:	701c      	strb	r4, [r3, #0]
    do {
        if(goc_component == 0x00) {
    174c:	4ba5      	ldr	r3, [pc, #660]	; (19e4 <main+0x88c>)
    174e:	781c      	ldrb	r4, [r3, #0]
    1750:	2c00      	cmp	r4, #0
    1752:	d117      	bne.n	1784 <main+0x62c>
            if(goc_func_id == 0x01) {
    1754:	4aa4      	ldr	r2, [pc, #656]	; (19e8 <main+0x890>)
    1756:	7813      	ldrb	r3, [r2, #0]
    1758:	2b01      	cmp	r3, #1
    175a:	d108      	bne.n	176e <main+0x616>
                if(sys_run_continuous) {
    175c:	4ba0      	ldr	r3, [pc, #640]	; (19e0 <main+0x888>)
    175e:	7819      	ldrb	r1, [r3, #0]
                    // start_xo_cout();
                }
                else {
                    // stop_xo_cout();
                }
                sys_run_continuous = !sys_run_continuous;
    1760:	7819      	ldrb	r1, [r3, #0]
    1762:	4248      	negs	r0, r1
    1764:	4141      	adcs	r1, r0
    1766:	7019      	strb	r1, [r3, #0]
                goc_func_id = 0xFF;
    1768:	23ff      	movs	r3, #255	; 0xff
    176a:	7013      	strb	r3, [r2, #0]
    176c:	e1dd      	b.n	1b2a <main+0x9d2>
            }
            else if(goc_func_id == 0x02) {
    176e:	2b02      	cmp	r3, #2
    1770:	d000      	beq.n	1774 <main+0x61c>
    1772:	e1da      	b.n	1b2a <main+0x9d2>
                // enter time in minutes
                xo_day_time = (goc_data * 60) << 15;
    1774:	4b9d      	ldr	r3, [pc, #628]	; (19ec <main+0x894>)
    1776:	223c      	movs	r2, #60	; 0x3c
    1778:	881b      	ldrh	r3, [r3, #0]
    177a:	435a      	muls	r2, r3
    177c:	4b91      	ldr	r3, [pc, #580]	; (19c4 <main+0x86c>)
    177e:	03d2      	lsls	r2, r2, #15
    1780:	601a      	str	r2, [r3, #0]
    1782:	e1d2      	b.n	1b2a <main+0x9d2>
            }
        }
        else if(goc_component == 0x01) {
    1784:	2c01      	cmp	r4, #1
    1786:	d140      	bne.n	180a <main+0x6b2>
            goc_state = 0;
    1788:	4b99      	ldr	r3, [pc, #612]	; (19f0 <main+0x898>)
    178a:	2600      	movs	r6, #0
            pmu_setting_temp_based(1);
    178c:	1c20      	adds	r0, r4, #0
                // enter time in minutes
                xo_day_time = (goc_data * 60) << 15;
            }
        }
        else if(goc_component == 0x01) {
            goc_state = 0;
    178e:	701e      	strb	r6, [r3, #0]
            pmu_setting_temp_based(1);
    1790:	f7fe fe74 	bl	47c <pmu_setting_temp_based>
            reset_radio_data_arr();
    1794:	f7fe fdb8 	bl	308 <reset_radio_data_arr>
            radio_data_arr[0] = snt_sys_temp_code & 0xFFFFFFF;
    1798:	4b96      	ldr	r3, [pc, #600]	; (19f4 <main+0x89c>)
    179a:	4d97      	ldr	r5, [pc, #604]	; (19f8 <main+0x8a0>)
    179c:	681b      	ldr	r3, [r3, #0]
    179e:	011b      	lsls	r3, r3, #4
    17a0:	091b      	lsrs	r3, r3, #4
    17a2:	602b      	str	r3, [r5, #0]
            update_system_time();
    17a4:	f7ff f904 	bl	9b0 <update_system_time>
            radio_data_arr[1] = (xo_sys_time >> 15) << 16 | (xo_day_time >> 15);
    17a8:	4b87      	ldr	r3, [pc, #540]	; (19c8 <main+0x870>)
    17aa:	4a86      	ldr	r2, [pc, #536]	; (19c4 <main+0x86c>)
    17ac:	681b      	ldr	r3, [r3, #0]
    17ae:	6812      	ldr	r2, [r2, #0]
    17b0:	0bdb      	lsrs	r3, r3, #15
    17b2:	0bd2      	lsrs	r2, r2, #15
    17b4:	041b      	lsls	r3, r3, #16
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
    17b6:	4f91      	ldr	r7, [pc, #580]	; (19fc <main+0x8a4>)
            goc_state = 0;
            pmu_setting_temp_based(1);
            reset_radio_data_arr();
            radio_data_arr[0] = snt_sys_temp_code & 0xFFFFFFF;
            update_system_time();
            radio_data_arr[1] = (xo_sys_time >> 15) << 16 | (xo_day_time >> 15);
    17b8:	4313      	orrs	r3, r2
    17ba:	606b      	str	r3, [r5, #4]
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
    17bc:	883b      	ldrh	r3, [r7, #0]
    17be:	21ff      	movs	r1, #255	; 0xff
    17c0:	400b      	ands	r3, r1
    17c2:	2240      	movs	r2, #64	; 0x40
    17c4:	4313      	orrs	r3, r2
            mrr_send_radio_data(0);
    17c6:	1c30      	adds	r0, r6, #0
            pmu_setting_temp_based(1);
            reset_radio_data_arr();
            radio_data_arr[0] = snt_sys_temp_code & 0xFFFFFFF;
            update_system_time();
            radio_data_arr[1] = (xo_sys_time >> 15) << 16 | (xo_day_time >> 15);
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
    17c8:	60ab      	str	r3, [r5, #8]
            mrr_send_radio_data(0);
    17ca:	f7ff fac3 	bl	d54 <mrr_send_radio_data>
            radio_data_arr[0] = lnt_sys_light & 0xFFFFFFFF;
    17ce:	4981      	ldr	r1, [pc, #516]	; (19d4 <main+0x87c>)
            radio_data_arr[1] = lnt_sys_light >> 32;
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
            mrr_send_radio_data(1);
    17d0:	1c20      	adds	r0, r4, #0
            radio_data_arr[0] = snt_sys_temp_code & 0xFFFFFFF;
            update_system_time();
            radio_data_arr[1] = (xo_sys_time >> 15) << 16 | (xo_day_time >> 15);
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
            mrr_send_radio_data(0);
            radio_data_arr[0] = lnt_sys_light & 0xFFFFFFFF;
    17d2:	680a      	ldr	r2, [r1, #0]
    17d4:	684b      	ldr	r3, [r1, #4]
    17d6:	602a      	str	r2, [r5, #0]
            radio_data_arr[1] = lnt_sys_light >> 32;
    17d8:	680a      	ldr	r2, [r1, #0]
    17da:	684b      	ldr	r3, [r1, #4]
    17dc:	606b      	str	r3, [r5, #4]
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
    17de:	883b      	ldrh	r3, [r7, #0]
    17e0:	21ff      	movs	r1, #255	; 0xff
    17e2:	400b      	ands	r3, r1
    17e4:	2240      	movs	r2, #64	; 0x40
    17e6:	4313      	orrs	r3, r2
    17e8:	60ab      	str	r3, [r5, #8]
            mrr_send_radio_data(1);
    17ea:	f7ff fab3 	bl	d54 <mrr_send_radio_data>
            pmu_setting_temp_based(0);
    17ee:	1c30      	adds	r0, r6, #0
    17f0:	f7fe fe44 	bl	47c <pmu_setting_temp_based>

            op_counter++;
    17f4:	883b      	ldrh	r3, [r7, #0]

            set_next_time(STORE_LNT, LNT_MEAS_TIME);
    17f6:	21e1      	movs	r1, #225	; 0xe1
            radio_data_arr[1] = lnt_sys_light >> 32;
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
            mrr_send_radio_data(1);
            pmu_setting_temp_based(0);

            op_counter++;
    17f8:	3301      	adds	r3, #1

            set_next_time(STORE_LNT, LNT_MEAS_TIME);
    17fa:	1c20      	adds	r0, r4, #0
    17fc:	0349      	lsls	r1, r1, #13
            radio_data_arr[1] = lnt_sys_light >> 32;
            radio_data_arr[2] = (CHIP_ID << 8) | (0x04 << 4) | (op_counter & 0xFF); // adding packet prefix
            mrr_send_radio_data(1);
            pmu_setting_temp_based(0);

            op_counter++;
    17fe:	803b      	strh	r3, [r7, #0]

            set_next_time(STORE_LNT, LNT_MEAS_TIME);
    1800:	f7ff f916 	bl	a30 <set_next_time>
            lnt_meas_time_mode = 0;
    1804:	4b7e      	ldr	r3, [pc, #504]	; (1a00 <main+0x8a8>)
    1806:	701e      	strb	r6, [r3, #0]
    1808:	e18f      	b.n	1b2a <main+0x9d2>
        }
        else if(goc_component == 0x04) {
    180a:	2c04      	cmp	r4, #4
    180c:	d000      	beq.n	1810 <main+0x6b8>
    180e:	e18c      	b.n	1b2a <main+0x9d2>
            if(goc_func_id == 0x01) {
    1810:	4b75      	ldr	r3, [pc, #468]	; (19e8 <main+0x890>)
    1812:	7818      	ldrb	r0, [r3, #0]
    1814:	2801      	cmp	r0, #1
    1816:	d000      	beq.n	181a <main+0x6c2>
    1818:	e187      	b.n	1b2a <main+0x9d2>
                if(goc_state == 0) {
    181a:	4a75      	ldr	r2, [pc, #468]	; (19f0 <main+0x898>)
    181c:	7813      	ldrb	r3, [r2, #0]
    181e:	2b00      	cmp	r3, #0
    1820:	d128      	bne.n	1874 <main+0x71c>
                    goc_state = 1;
    1822:	7010      	strb	r0, [r2, #0]
                    op_counter = 0;
    1824:	4a75      	ldr	r2, [pc, #468]	; (19fc <main+0x8a4>)

                    xo_day_time = (goc_data * 60) >> 15;
    1826:	213c      	movs	r1, #60	; 0x3c
        }
        else if(goc_component == 0x04) {
            if(goc_func_id == 0x01) {
                if(goc_state == 0) {
                    goc_state = 1;
                    op_counter = 0;
    1828:	8013      	strh	r3, [r2, #0]

                    xo_day_time = (goc_data * 60) >> 15;
    182a:	4a70      	ldr	r2, [pc, #448]	; (19ec <main+0x894>)
                    
                    // start operation in 8 minutes
                    xot_timer_list[STORE_SNT] = xo_sys_time + SNT_TEMP_UPDATE_TIME;
    182c:	24e1      	movs	r4, #225	; 0xe1
            if(goc_func_id == 0x01) {
                if(goc_state == 0) {
                    goc_state = 1;
                    op_counter = 0;

                    xo_day_time = (goc_data * 60) >> 15;
    182e:	8812      	ldrh	r2, [r2, #0]
                    
                    // start operation in 8 minutes
                    xot_timer_list[STORE_SNT] = xo_sys_time + SNT_TEMP_UPDATE_TIME;
    1830:	0424      	lsls	r4, r4, #16
            if(goc_func_id == 0x01) {
                if(goc_state == 0) {
                    goc_state = 1;
                    op_counter = 0;

                    xo_day_time = (goc_data * 60) >> 15;
    1832:	434a      	muls	r2, r1
    1834:	4963      	ldr	r1, [pc, #396]	; (19c4 <main+0x86c>)
    1836:	13d2      	asrs	r2, r2, #15
    1838:	600a      	str	r2, [r1, #0]
                    
                    // start operation in 8 minutes
                    xot_timer_list[STORE_SNT] = xo_sys_time + SNT_TEMP_UPDATE_TIME;
    183a:	4a63      	ldr	r2, [pc, #396]	; (19c8 <main+0x870>)
                    xot_timer_list[STORE_LNT] = xo_sys_time + LNT_INTERVAL[2];
    183c:	27e1      	movs	r7, #225	; 0xe1
                    op_counter = 0;

                    xo_day_time = (goc_data * 60) >> 15;
                    
                    // start operation in 8 minutes
                    xot_timer_list[STORE_SNT] = xo_sys_time + SNT_TEMP_UPDATE_TIME;
    183e:	6816      	ldr	r6, [r2, #0]
                    xot_timer_list[STORE_LNT] = xo_sys_time + LNT_INTERVAL[2];
    1840:	043f      	lsls	r7, r7, #16
                    op_counter = 0;

                    xo_day_time = (goc_data * 60) >> 15;
                    
                    // start operation in 8 minutes
                    xot_timer_list[STORE_SNT] = xo_sys_time + SNT_TEMP_UPDATE_TIME;
    1842:	1936      	adds	r6, r6, r4
    1844:	4c6f      	ldr	r4, [pc, #444]	; (1a04 <main+0x8ac>)
                    xot_timer_list[STORE_LNT] = xo_sys_time + LNT_INTERVAL[2];
                    lnt_meas_time_mode = 0;

                    snt_counter = 3;
    1846:	2503      	movs	r5, #3
                    op_counter = 0;

                    xo_day_time = (goc_data * 60) >> 15;
                    
                    // start operation in 8 minutes
                    xot_timer_list[STORE_SNT] = xo_sys_time + SNT_TEMP_UPDATE_TIME;
    1848:	6026      	str	r6, [r4, #0]
                    xot_timer_list[STORE_LNT] = xo_sys_time + LNT_INTERVAL[2];
    184a:	6816      	ldr	r6, [r2, #0]
    184c:	19f6      	adds	r6, r6, r7
    184e:	6066      	str	r6, [r4, #4]
                    lnt_meas_time_mode = 0;
    1850:	4c6b      	ldr	r4, [pc, #428]	; (1a00 <main+0x8a8>)
    1852:	7023      	strb	r3, [r4, #0]

                    snt_counter = 3;
    1854:	4c6c      	ldr	r4, [pc, #432]	; (1a08 <main+0x8b0>)
    1856:	7025      	strb	r5, [r4, #0]
                    radio_beacon_counter = 0;
    1858:	4c6c      	ldr	r4, [pc, #432]	; (1a0c <main+0x8b4>)
    185a:	7023      	strb	r3, [r4, #0]
                    radio_counter = 0;
    185c:	4c6c      	ldr	r4, [pc, #432]	; (1a10 <main+0x8b8>)
    185e:	7023      	strb	r3, [r4, #0]

                    radio_data_arr[0] = xo_day_time;
    1860:	6809      	ldr	r1, [r1, #0]
    1862:	4b65      	ldr	r3, [pc, #404]	; (19f8 <main+0x8a0>)
    1864:	6019      	str	r1, [r3, #0]
                    radio_data_arr[1] = xo_sys_time;
    1866:	6812      	ldr	r2, [r2, #0]
    1868:	605a      	str	r2, [r3, #4]
                    radio_data_arr[2] = 0x04 << 4;
    186a:	2240      	movs	r2, #64	; 0x40
    186c:	609a      	str	r2, [r3, #8]
                    mrr_send_radio_data(1);
    186e:	f7ff fa71 	bl	d54 <mrr_send_radio_data>
    1872:	e15a      	b.n	1b2a <main+0x9d2>
                }
                else if(goc_state == 1) {
    1874:	2b01      	cmp	r3, #1
    1876:	d000      	beq.n	187a <main+0x722>
    1878:	e0d4      	b.n	1a24 <main+0x8cc>
                    if(op_counter >= SNT_OP_MAX_COUNT) {
    187a:	4b60      	ldr	r3, [pc, #384]	; (19fc <main+0x8a4>)
    187c:	8819      	ldrh	r1, [r3, #0]
    187e:	290c      	cmp	r1, #12
    1880:	d915      	bls.n	18ae <main+0x756>
                        goc_state = 2;
    1882:	2302      	movs	r3, #2
    1884:	7013      	strb	r3, [r2, #0]
                        reset_timers_list();
    1886:	f7ff f8c7 	bl	a18 <reset_timers_list>

    return out & 0x7FF;
}

static void store_temp() {
    if(temp_storage_remainder <= 80) {
    188a:	4b62      	ldr	r3, [pc, #392]	; (1a14 <main+0x8bc>)
    188c:	781b      	ldrb	r3, [r3, #0]
    188e:	2b50      	cmp	r3, #80	; 0x50
    1890:	d801      	bhi.n	1896 <main+0x73e>
    1892:	f7fe ff5b 	bl	74c <store_temp.part.4>
                else if(goc_state == 1) {
                    if(op_counter >= SNT_OP_MAX_COUNT) {
                        goc_state = 2;
                        reset_timers_list();
                        store_temp();       // store everything in temp_code_storage
                        store_light();
    1896:	f7fe ff79 	bl	78c <store_light>
                        update_system_time();
    189a:	f7ff f889 	bl	9b0 <update_system_time>
                        xot_timer_list[SEND_RAD] = xo_sys_time + MRR_SIGNAL_PERIOD;
    189e:	4b4a      	ldr	r3, [pc, #296]	; (19c8 <main+0x870>)
    18a0:	2196      	movs	r1, #150	; 0x96
    18a2:	681a      	ldr	r2, [r3, #0]
    18a4:	0409      	lsls	r1, r1, #16
    18a6:	4b57      	ldr	r3, [pc, #348]	; (1a04 <main+0x8ac>)
    18a8:	1852      	adds	r2, r2, r1
    18aa:	609a      	str	r2, [r3, #8]
    18ac:	e13d      	b.n	1b2a <main+0x9d2>
                    }

                    else {
                        if(xot_timer_list[STORE_SNT] == 0xFFFFFFFF) {
    18ae:	4a55      	ldr	r2, [pc, #340]	; (1a04 <main+0x8ac>)
    18b0:	6812      	ldr	r2, [r2, #0]
    18b2:	3201      	adds	r2, #1
    18b4:	d154      	bne.n	1960 <main+0x808>
                            op_counter++;
    18b6:	881a      	ldrh	r2, [r3, #0]
                            pmu_setting_temp_based(0);
    18b8:	2000      	movs	r0, #0
                        xot_timer_list[SEND_RAD] = xo_sys_time + MRR_SIGNAL_PERIOD;
                    }

                    else {
                        if(xot_timer_list[STORE_SNT] == 0xFFFFFFFF) {
                            op_counter++;
    18ba:	3201      	adds	r2, #1
    18bc:	801a      	strh	r2, [r3, #0]
                            pmu_setting_temp_based(0);
    18be:	f7fe fddd 	bl	47c <pmu_setting_temp_based>

                            if(++snt_counter >= 3) {
    18c2:	4b51      	ldr	r3, [pc, #324]	; (1a08 <main+0x8b0>)
    18c4:	781a      	ldrb	r2, [r3, #0]
    18c6:	3201      	adds	r2, #1
    18c8:	b2d2      	uxtb	r2, r2
    18ca:	701a      	strb	r2, [r3, #0]
    18cc:	2a02      	cmp	r2, #2
    18ce:	d93c      	bls.n	194a <main+0x7f2>
                                snt_counter = 0;
    18d0:	2200      	movs	r2, #0
    18d2:	701a      	strb	r2, [r3, #0]
    return 0;
}

static void compress_temp() {
    
    if(temp_storage_remainder == 80) {
    18d4:	4b4f      	ldr	r3, [pc, #316]	; (1a14 <main+0x8bc>)
    18d6:	781b      	ldrb	r3, [r3, #0]
    18d8:	2b50      	cmp	r3, #80	; 0x50
    18da:	d11d      	bne.n	1918 <main+0x7c0>
        uint8_t i;
        for(i = 0; i < 3; i++) {
            temp_code_storage[i] = 0;
    18dc:	494e      	ldr	r1, [pc, #312]	; (1a18 <main+0x8c0>)
    18de:	2200      	movs	r2, #0
    18e0:	2300      	movs	r3, #0
    18e2:	600a      	str	r2, [r1, #0]
    18e4:	604b      	str	r3, [r1, #4]
    18e6:	608a      	str	r2, [r1, #8]
    18e8:	60cb      	str	r3, [r1, #12]
    18ea:	610a      	str	r2, [r1, #16]
    18ec:	614b      	str	r3, [r1, #20]
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
        temp_shift_left_store(((CHIP_ID & 0x7) << 13) | ((temp_packet_num & 0x3) << 11) | time_storage, 16);
    18ee:	4a4b      	ldr	r2, [pc, #300]	; (1a1c <main+0x8c4>)
    if(temp_storage_remainder == 80) {
        uint8_t i;
        for(i = 0; i < 3; i++) {
            temp_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
    18f0:	4b4b      	ldr	r3, [pc, #300]	; (1a20 <main+0x8c8>)
    18f2:	881b      	ldrh	r3, [r3, #0]
        temp_shift_left_store(((CHIP_ID & 0x7) << 13) | ((temp_packet_num & 0x3) << 11) | time_storage, 16);
    18f4:	7810      	ldrb	r0, [r2, #0]
        mem_temp_len += 3;
    }
}

static uint8_t temp_shift_left_store(uint32_t data, uint8_t len) {
    if(temp_storage_remainder < len) {
    18f6:	4a47      	ldr	r2, [pc, #284]	; (1a14 <main+0x8bc>)
    18f8:	7812      	ldrb	r2, [r2, #0]
    18fa:	2a0f      	cmp	r2, #15
    18fc:	d908      	bls.n	1910 <main+0x7b8>
        uint8_t i;
        for(i = 0; i < 3; i++) {
            temp_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
        temp_shift_left_store(((CHIP_ID & 0x7) << 13) | ((temp_packet_num & 0x3) << 11) | time_storage, 16);
    18fe:	2203      	movs	r2, #3
    1900:	4010      	ands	r0, r2
    if(temp_storage_remainder == 80) {
        uint8_t i;
        for(i = 0; i < 3; i++) {
            temp_code_storage[i] = 0;
        }
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
    1902:	059b      	lsls	r3, r3, #22
        temp_shift_left_store(((CHIP_ID & 0x7) << 13) | ((temp_packet_num & 0x3) << 11) | time_storage, 16);
    1904:	02c0      	lsls	r0, r0, #11
    1906:	0d9b      	lsrs	r3, r3, #22
    1908:	4318      	orrs	r0, r3
    190a:	2110      	movs	r1, #16
    190c:	f7fe fe44 	bl	598 <temp_shift_left_store.part.0>
        temp_packet_num++;
    1910:	4b42      	ldr	r3, [pc, #264]	; (1a1c <main+0x8c4>)
    1912:	781a      	ldrb	r2, [r3, #0]
    1914:	3201      	adds	r2, #1
    1916:	701a      	strb	r2, [r3, #0]
    }

    uint8_t log_temp = (log2(snt_sys_temp_code) & 0b1111100000) >> 5; // Take only the decimal value
    1918:	4b36      	ldr	r3, [pc, #216]	; (19f4 <main+0x89c>)
    191a:	2100      	movs	r1, #0
    191c:	6818      	ldr	r0, [r3, #0]
    191e:	f7ff f8bb 	bl	a98 <log2>
        mem_temp_len += 3;
    }
}

static uint8_t temp_shift_left_store(uint32_t data, uint8_t len) {
    if(temp_storage_remainder < len) {
    1922:	4c3c      	ldr	r4, [pc, #240]	; (1a14 <main+0x8bc>)
    1924:	7823      	ldrb	r3, [r4, #0]
    1926:	2b04      	cmp	r3, #4
    1928:	d904      	bls.n	1934 <main+0x7dc>
        uint16_t time_storage = xo_day_timestamp_count & 0x3FF;
        temp_shift_left_store(((CHIP_ID & 0x7) << 13) | ((temp_packet_num & 0x3) << 11) | time_storage, 16);
        temp_packet_num++;
    }

    uint8_t log_temp = (log2(snt_sys_temp_code) & 0b1111100000) >> 5; // Take only the decimal value
    192a:	0580      	lsls	r0, r0, #22
    192c:	0ec0      	lsrs	r0, r0, #27
    192e:	2105      	movs	r1, #5
    1930:	f7fe fe32 	bl	598 <temp_shift_left_store.part.0>

    temp_shift_left_store(log_temp, 5);
    if(temp_storage_remainder < 5) {
    1934:	7823      	ldrb	r3, [r4, #0]
    1936:	2b04      	cmp	r3, #4
    1938:	d807      	bhi.n	194a <main+0x7f2>

    return out & 0x7FF;
}

static void store_temp() {
    if(temp_storage_remainder <= 80) {
    193a:	7823      	ldrb	r3, [r4, #0]
    193c:	2b50      	cmp	r3, #80	; 0x50
    193e:	d801      	bhi.n	1944 <main+0x7ec>
    1940:	f7fe ff04 	bl	74c <store_temp.part.4>
    uint8_t log_temp = (log2(snt_sys_temp_code) & 0b1111100000) >> 5; // Take only the decimal value

    temp_shift_left_store(log_temp, 5);
    if(temp_storage_remainder < 5) {
        store_temp();
        temp_storage_remainder = 80;
    1944:	4b33      	ldr	r3, [pc, #204]	; (1a14 <main+0x8bc>)
    1946:	2250      	movs	r2, #80	; 0x50
    1948:	701a      	strb	r2, [r3, #0]
                            if(++snt_counter >= 3) {
                                snt_counter = 0;
                                compress_temp();
                            }

                            set_next_time(STORE_SNT, SNT_TEMP_UPDATE_TIME);
    194a:	21e1      	movs	r1, #225	; 0xe1
    194c:	2000      	movs	r0, #0
    194e:	0409      	lsls	r1, r1, #16
    1950:	f7ff f86e 	bl	a30 <set_next_time>
                            mbus_write_message32(0xEA, xot_timer_list[STORE_SNT] >> 15);
    1954:	4b2b      	ldr	r3, [pc, #172]	; (1a04 <main+0x8ac>)
    1956:	20ea      	movs	r0, #234	; 0xea
    1958:	6819      	ldr	r1, [r3, #0]
    195a:	0bc9      	lsrs	r1, r1, #15
    195c:	f7fe fc2a 	bl	1b4 <mbus_write_message32>
                        }

                        if(xot_timer_list[STORE_LNT] == 0xFFFFFFFF) {
    1960:	4b28      	ldr	r3, [pc, #160]	; (1a04 <main+0x8ac>)
    1962:	685b      	ldr	r3, [r3, #4]
    1964:	3301      	adds	r3, #1
    1966:	d000      	beq.n	196a <main+0x812>
    1968:	e0df      	b.n	1b2a <main+0x9d2>
                            // TODO: compress this
                            if(compress_light() != 0) {
    196a:	f7ff f901 	bl	b70 <compress_light>
    196e:	2800      	cmp	r0, #0
    1970:	d001      	beq.n	1976 <main+0x81e>
                                compress_light();
    1972:	f7ff f8fd 	bl	b70 <compress_light>
    mbus_write_message32(0xCE, (end_time - xo_sys_time) >> 15);
}

static uint16_t update_light_interval() {
#ifdef LNT_MANUAL_PERIOD
    if(xo_day_time <= XO_DAY_START) {
    1976:	4b13      	ldr	r3, [pc, #76]	; (19c4 <main+0x86c>)
                            // TODO: compress this
                            if(compress_light() != 0) {
                                compress_light();
                            }

                            set_next_time(STORE_LNT, update_light_interval());
    1978:	2180      	movs	r1, #128	; 0x80
    mbus_write_message32(0xCE, (end_time - xo_sys_time) >> 15);
}

static uint16_t update_light_interval() {
#ifdef LNT_MANUAL_PERIOD
    if(xo_day_time <= XO_DAY_START) {
    197a:	681b      	ldr	r3, [r3, #0]
    
    }

    lnt_meas_time_mode = 0;
    197c:	4b20      	ldr	r3, [pc, #128]	; (1a00 <main+0x8a8>)
    197e:	2200      	movs	r2, #0
                            // TODO: compress this
                            if(compress_light() != 0) {
                                compress_light();
                            }

                            set_next_time(STORE_LNT, update_light_interval());
    1980:	2001      	movs	r0, #1
    1982:	0189      	lsls	r1, r1, #6
#ifdef LNT_MANUAL_PERIOD
    if(xo_day_time <= XO_DAY_START) {
    
    }

    lnt_meas_time_mode = 0;
    1984:	701a      	strb	r2, [r3, #0]
                            // TODO: compress this
                            if(compress_light() != 0) {
                                compress_light();
                            }

                            set_next_time(STORE_LNT, update_light_interval());
    1986:	f7ff f853 	bl	a30 <set_next_time>
                            mbus_write_message32(0xEB, xot_timer_list[STORE_LNT] >> 15);
    198a:	4b1e      	ldr	r3, [pc, #120]	; (1a04 <main+0x8ac>)
    198c:	20eb      	movs	r0, #235	; 0xeb
    198e:	6859      	ldr	r1, [r3, #4]
    1990:	0bc9      	lsrs	r1, r1, #15
    1992:	f7fe fc0f 	bl	1b4 <mbus_write_message32>
    1996:	e0c8      	b.n	1b2a <main+0x9d2>
    1998:	007ac800 	.word	0x007ac800
    199c:	00001d50 	.word	0x00001d50
    19a0:	ffffc000 	.word	0xffffc000
    19a4:	ff1fffff 	.word	0xff1fffff
    19a8:	00001002 	.word	0x00001002
    19ac:	00004e20 	.word	0x00004e20
    19b0:	00001de2 	.word	0x00001de2
    19b4:	00001d7e 	.word	0x00001d7e
    19b8:	a000a008 	.word	0xa000a008
    19bc:	00001d34 	.word	0x00001d34
    19c0:	ff7fffff 	.word	0xff7fffff
    19c4:	00001d90 	.word	0x00001d90
    19c8:	00001e00 	.word	0x00001e00
    19cc:	a0000004 	.word	0xa0000004
    19d0:	00001de4 	.word	0x00001de4
    19d4:	00001db0 	.word	0x00001db0
    19d8:	00001d40 	.word	0x00001d40
    19dc:	00002710 	.word	0x00002710
    19e0:	00001da9 	.word	0x00001da9
    19e4:	00001d86 	.word	0x00001d86
    19e8:	00001d8c 	.word	0x00001d8c
    19ec:	00001d96 	.word	0x00001d96
    19f0:	00001db8 	.word	0x00001db8
    19f4:	00001d30 	.word	0x00001d30
    19f8:	00001d9c 	.word	0x00001d9c
    19fc:	00001de0 	.word	0x00001de0
    1a00:	00001daa 	.word	0x00001daa
    1a04:	00001dbc 	.word	0x00001dbc
    1a08:	00001d98 	.word	0x00001d98
    1a0c:	00001da8 	.word	0x00001da8
    1a10:	00001d94 	.word	0x00001d94
    1a14:	00001d3d 	.word	0x00001d3d
    1a18:	00001dd0 	.word	0x00001dd0
    1a1c:	00001e04 	.word	0x00001e04
    1a20:	00001d84 	.word	0x00001d84
                        }
                    }
                }
                else if(goc_state == 2) {
    1a24:	2b02      	cmp	r3, #2
    1a26:	d000      	beq.n	1a2a <main+0x8d2>
    1a28:	e07f      	b.n	1b2a <main+0x9d2>
                    if(xot_timer_list[SEND_RAD] = 0xFFFFFFFF) {
    1a2a:	4b84      	ldr	r3, [pc, #528]	; (1c3c <main+0xae4>)
    1a2c:	2201      	movs	r2, #1
    1a2e:	4252      	negs	r2, r2
    1a30:	609a      	str	r2, [r3, #8]
                        pmu_setting_temp_based(1);
    1a32:	f7fe fd23 	bl	47c <pmu_setting_temp_based>

                        if(xo_check_is_day()) {
    1a36:	f7ff f819 	bl	a6c <xo_check_is_day>
    1a3a:	2800      	cmp	r0, #0
    1a3c:	d070      	beq.n	1b20 <main+0x9c8>
                            // send beacon
                            reset_radio_data_arr();
    1a3e:	f7fe fc63 	bl	308 <reset_radio_data_arr>
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    1a42:	4a7f      	ldr	r2, [pc, #508]	; (1c40 <main+0xae8>)
    1a44:	4b7f      	ldr	r3, [pc, #508]	; (1c44 <main+0xaec>)
                            radio_data_arr[1] = snt_sys_temp_code;
                            radio_data_arr[2] = 0x4 << 4;

                            mrr_send_radio_data(0);
    1a46:	2000      	movs	r0, #0
                        pmu_setting_temp_based(1);

                        if(xo_check_is_day()) {
                            // send beacon
                            reset_radio_data_arr();
                            radio_data_arr[0] = (0xDD << 24) | ((radio_counter & 0xFF) << 16) | (read_data_batadc & 0xFFFF);
    1a48:	781b      	ldrb	r3, [r3, #0]
    1a4a:	8811      	ldrh	r1, [r2, #0]
    1a4c:	22dd      	movs	r2, #221	; 0xdd
    1a4e:	0612      	lsls	r2, r2, #24
    1a50:	430a      	orrs	r2, r1
    1a52:	041b      	lsls	r3, r3, #16
    1a54:	431a      	orrs	r2, r3
    1a56:	4b7c      	ldr	r3, [pc, #496]	; (1c48 <main+0xaf0>)
    1a58:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = snt_sys_temp_code;
    1a5a:	4a7c      	ldr	r2, [pc, #496]	; (1c4c <main+0xaf4>)
    1a5c:	6812      	ldr	r2, [r2, #0]
    1a5e:	605a      	str	r2, [r3, #4]
                            radio_data_arr[2] = 0x4 << 4;
    1a60:	2240      	movs	r2, #64	; 0x40
    1a62:	609a      	str	r2, [r3, #8]

                            mrr_send_radio_data(0);
    1a64:	f7ff f976 	bl	d54 <mrr_send_radio_data>

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
    1a68:	4b79      	ldr	r3, [pc, #484]	; (1c50 <main+0xaf8>)
    1a6a:	781a      	ldrb	r2, [r3, #0]
    1a6c:	3201      	adds	r2, #1
    1a6e:	b2d2      	uxtb	r2, r2
    1a70:	701a      	strb	r2, [r3, #0]
    1a72:	2a05      	cmp	r2, #5
    1a74:	d80f      	bhi.n	1a96 <main+0x93e>
                                    mrr_send_radio_data(0);
                                }

                            }

                            radio_data_arr[0] = radio_counter;
    1a76:	4c73      	ldr	r4, [pc, #460]	; (1c44 <main+0xaec>)
    1a78:	4b73      	ldr	r3, [pc, #460]	; (1c48 <main+0xaf0>)
    1a7a:	7822      	ldrb	r2, [r4, #0]
                            radio_data_arr[1] = radio_beacon_counter;
                            radio_data_arr[2] = 0x4 << 4;

                            mrr_send_radio_data(1);
    1a7c:	2001      	movs	r0, #1
                                    mrr_send_radio_data(0);
                                }

                            }

                            radio_data_arr[0] = radio_counter;
    1a7e:	601a      	str	r2, [r3, #0]
                            radio_data_arr[1] = radio_beacon_counter;
    1a80:	4a73      	ldr	r2, [pc, #460]	; (1c50 <main+0xaf8>)
    1a82:	7812      	ldrb	r2, [r2, #0]
    1a84:	605a      	str	r2, [r3, #4]
                            radio_data_arr[2] = 0x4 << 4;
    1a86:	2240      	movs	r2, #64	; 0x40
    1a88:	609a      	str	r2, [r3, #8]

                            mrr_send_radio_data(1);
    1a8a:	f7ff f963 	bl	d54 <mrr_send_radio_data>

                            radio_counter++;
    1a8e:	7823      	ldrb	r3, [r4, #0]
    1a90:	3301      	adds	r3, #1
    1a92:	7023      	strb	r3, [r4, #0]
    1a94:	e044      	b.n	1b20 <main+0x9c8>

                            mrr_send_radio_data(0);

                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
    1a96:	2400      	movs	r4, #0
    1a98:	701c      	strb	r4, [r3, #0]
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
    1a9a:	4b6e      	ldr	r3, [pc, #440]	; (1c54 <main+0xafc>)
    1a9c:	20b0      	movs	r0, #176	; 0xb0
    1a9e:	8819      	ldrh	r1, [r3, #0]
    1aa0:	f7fe fb88 	bl	1b4 <mbus_write_message32>
				for(i = 0; i < mem_temp_len; i += 2) {
    1aa4:	e016      	b.n	1ad4 <main+0x97c>
                                    reset_radio_data_arr();
    1aa6:	f7fe fc2f 	bl	308 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    1aaa:	f7fe fb7d 	bl	1a8 <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
    1aae:	4b6a      	ldr	r3, [pc, #424]	; (1c58 <main+0xb00>)
    1ab0:	4d65      	ldr	r5, [pc, #404]	; (1c48 <main+0xaf0>)
    1ab2:	8819      	ldrh	r1, [r3, #0]
    1ab4:	2201      	movs	r2, #1
    1ab6:	1909      	adds	r1, r1, r4
    1ab8:	9200      	str	r2, [sp, #0]
    1aba:	2006      	movs	r0, #6
    1abc:	1c2b      	adds	r3, r5, #0
    1abe:	f7fe fbe1 	bl	284 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    1ac2:	f7fe fb6b 	bl	19c <set_halt_until_mbus_tx>
				    radio_data_arr[2] &= 0x0000FFFF;
    1ac6:	68ab      	ldr	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1ac8:	2000      	movs	r0, #0
				for(i = 0; i < mem_temp_len; i += 2) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_addr + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] &= 0x0000FFFF;
    1aca:	b29b      	uxth	r3, r3
    1acc:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1ace:	f7ff f941 	bl	d54 <mrr_send_radio_data>
                            // send data
                            if(++radio_beacon_counter >= 6) { // FIXME: change to 6
                                radio_beacon_counter = 0;
                                int i;
				mbus_write_message32(0xB0, mem_light_len);
				for(i = 0; i < mem_temp_len; i += 2) {
    1ad2:	3402      	adds	r4, #2
    1ad4:	4b61      	ldr	r3, [pc, #388]	; (1c5c <main+0xb04>)
    1ad6:	881a      	ldrh	r2, [r3, #0]
    1ad8:	4294      	cmp	r4, r2
    1ada:	dbe4      	blt.n	1aa6 <main+0x94e>
				    radio_data_arr[2] &= 0x0000FFFF;

                                    mrr_send_radio_data(0);
				}

				mbus_write_message32(0xB1, mem_temp_len);
    1adc:	8819      	ldrh	r1, [r3, #0]
    1ade:	20b1      	movs	r0, #177	; 0xb1
    1ae0:	f7fe fb68 	bl	1b4 <mbus_write_message32>
                                for(i = 0; i < mem_temp_len; i += 3) {
    1ae4:	2400      	movs	r4, #0
    1ae6:	e016      	b.n	1b16 <main+0x9be>
                                    reset_radio_data_arr();
    1ae8:	f7fe fc0e 	bl	308 <reset_radio_data_arr>
                                    set_halt_until_mbus_trx();
    1aec:	f7fe fb5c 	bl	1a8 <set_halt_until_mbus_trx>
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_len + i), PRE_ADDR, radio_data_arr, 1);
    1af0:	8829      	ldrh	r1, [r5, #0]
    1af2:	4d55      	ldr	r5, [pc, #340]	; (1c48 <main+0xaf0>)
    1af4:	2201      	movs	r2, #1
    1af6:	1909      	adds	r1, r1, r4
    1af8:	9200      	str	r2, [sp, #0]
    1afa:	2006      	movs	r0, #6
    1afc:	1c2b      	adds	r3, r5, #0
    1afe:	f7fe fbc1 	bl	284 <mbus_copy_mem_from_remote_to_any_bulk>
                                    set_halt_until_mbus_tx();
    1b02:	f7fe fb4b 	bl	19c <set_halt_until_mbus_tx>
				    radio_data_arr[2] |= 0x4 << 4;
    1b06:	68ab      	ldr	r3, [r5, #8]
    1b08:	2240      	movs	r2, #64	; 0x40
    1b0a:	4313      	orrs	r3, r2

                                    mrr_send_radio_data(0);
    1b0c:	2000      	movs	r0, #0
                                for(i = 0; i < mem_temp_len; i += 3) {
                                    reset_radio_data_arr();
                                    set_halt_until_mbus_trx();
                                    mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (mem_temp_len + i), PRE_ADDR, radio_data_arr, 1);
                                    set_halt_until_mbus_tx();
				    radio_data_arr[2] |= 0x4 << 4;
    1b0e:	60ab      	str	r3, [r5, #8]

                                    mrr_send_radio_data(0);
    1b10:	f7ff f920 	bl	d54 <mrr_send_radio_data>

                                    mrr_send_radio_data(0);
				}

				mbus_write_message32(0xB1, mem_temp_len);
                                for(i = 0; i < mem_temp_len; i += 3) {
    1b14:	3403      	adds	r4, #3
    1b16:	4d51      	ldr	r5, [pc, #324]	; (1c5c <main+0xb04>)
    1b18:	882b      	ldrh	r3, [r5, #0]
    1b1a:	429c      	cmp	r4, r3
    1b1c:	dbe4      	blt.n	1ae8 <main+0x990>
    1b1e:	e7aa      	b.n	1a76 <main+0x91e>
                            mrr_send_radio_data(1);

                            radio_counter++;
                        }

                        set_next_time(SEND_RAD, 600 << 15); // FIXME: set to 600
    1b20:	2196      	movs	r1, #150	; 0x96
    1b22:	2002      	movs	r0, #2
    1b24:	0449      	lsls	r1, r1, #17
    1b26:	f7fe ff83 	bl	a30 <set_next_time>
                    }
                }
            }
        }
    } while(sys_run_continuous);
    1b2a:	4b4d      	ldr	r3, [pc, #308]	; (1c60 <main+0xb08>)
    1b2c:	781b      	ldrb	r3, [r3, #0]
    1b2e:	2b00      	cmp	r3, #0
    1b30:	d000      	beq.n	1b34 <main+0x9dc>
    1b32:	e60b      	b.n	174c <main+0x5f4>

    // if time to next LNT_STORE time is less than 450 seconds, use that time,
    // else, use 450 seconds
    uint32_t end_time = 0;
    if(xot_timer_list[SEND_RAD] != 0 && xot_timer_list[SEND_RAD] != 0xFFFFFFFF) {
    1b34:	4b41      	ldr	r3, [pc, #260]	; (1c3c <main+0xae4>)
    1b36:	689a      	ldr	r2, [r3, #8]
    1b38:	1c19      	adds	r1, r3, #0
    1b3a:	2a00      	cmp	r2, #0
    1b3c:	d004      	beq.n	1b48 <main+0x9f0>
    1b3e:	689a      	ldr	r2, [r3, #8]
    1b40:	3201      	adds	r2, #1
    1b42:	d001      	beq.n	1b48 <main+0x9f0>
        end_time = xot_timer_list[SEND_RAD];
    1b44:	689d      	ldr	r5, [r3, #8]
    1b46:	e011      	b.n	1b6c <main+0xa14>
    }
    else {
        if(xot_timer_list[STORE_LNT] - xot_last_timer_list[STORE_LNT] < SNT_TEMP_UPDATE_TIME) {
    1b48:	4a46      	ldr	r2, [pc, #280]	; (1c64 <main+0xb0c>)
    1b4a:	684c      	ldr	r4, [r1, #4]
    1b4c:	4846      	ldr	r0, [pc, #280]	; (1c68 <main+0xb10>)
    1b4e:	6853      	ldr	r3, [r2, #4]
    1b50:	1ae4      	subs	r4, r4, r3
    1b52:	4b46      	ldr	r3, [pc, #280]	; (1c6c <main+0xb14>)
    1b54:	4284      	cmp	r4, r0
    1b56:	d803      	bhi.n	1b60 <main+0xa08>
            end_time = xot_timer_list[STORE_LNT];
            lnt_counter_base = lnt_meas_time_mode;
    1b58:	4a45      	ldr	r2, [pc, #276]	; (1c70 <main+0xb18>)
    if(xot_timer_list[SEND_RAD] != 0 && xot_timer_list[SEND_RAD] != 0xFFFFFFFF) {
        end_time = xot_timer_list[SEND_RAD];
    }
    else {
        if(xot_timer_list[STORE_LNT] - xot_last_timer_list[STORE_LNT] < SNT_TEMP_UPDATE_TIME) {
            end_time = xot_timer_list[STORE_LNT];
    1b5a:	684d      	ldr	r5, [r1, #4]
            lnt_counter_base = lnt_meas_time_mode;
    1b5c:	7812      	ldrb	r2, [r2, #0]
    1b5e:	e004      	b.n	1b6a <main+0xa12>
        }
        else {
            end_time = xot_last_timer_list[STORE_LNT] + SNT_TEMP_UPDATE_TIME;
    1b60:	6855      	ldr	r5, [r2, #4]
    1b62:	22e1      	movs	r2, #225	; 0xe1
    1b64:	0412      	lsls	r2, r2, #16
    1b66:	18ad      	adds	r5, r5, r2
            lnt_counter_base = 8;
    1b68:	2208      	movs	r2, #8
    1b6a:	701a      	strb	r2, [r3, #0]
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        if(xot_timer_list[i] != 0 && xot_timer_list[i] <= end_time) {
            xot_last_timer_list[i] = 0xFFFFFFFF;
    1b6c:	2001      	movs	r0, #1
        }
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        if(xot_timer_list[i] != 0 && xot_timer_list[i] <= end_time) {
    1b6e:	4933      	ldr	r1, [pc, #204]	; (1c3c <main+0xae4>)
            xot_last_timer_list[i] = 0xFFFFFFFF;
    1b70:	4c3c      	ldr	r4, [pc, #240]	; (1c64 <main+0xb0c>)

                                    mrr_send_radio_data(0);
				}

				mbus_write_message32(0xB1, mem_temp_len);
                                for(i = 0; i < mem_temp_len; i += 3) {
    1b72:	2300      	movs	r3, #0
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        if(xot_timer_list[i] != 0 && xot_timer_list[i] <= end_time) {
            xot_last_timer_list[i] = 0xFFFFFFFF;
    1b74:	4240      	negs	r0, r0
        }
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        if(xot_timer_list[i] != 0 && xot_timer_list[i] <= end_time) {
    1b76:	009a      	lsls	r2, r3, #2
    1b78:	5856      	ldr	r6, [r2, r1]
    1b7a:	2e00      	cmp	r6, #0
    1b7c:	d004      	beq.n	1b88 <main+0xa30>
    1b7e:	5856      	ldr	r6, [r2, r1]
    1b80:	42ae      	cmp	r6, r5
    1b82:	d801      	bhi.n	1b88 <main+0xa30>
            xot_last_timer_list[i] = 0xFFFFFFFF;
    1b84:	5110      	str	r0, [r2, r4]
            xot_timer_list[i] = 0xFFFFFFFF;
    1b86:	5050      	str	r0, [r2, r1]
    1b88:	3301      	adds	r3, #1
            lnt_counter_base = 8;
        }
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1b8a:	2b03      	cmp	r3, #3
    1b8c:	d1f3      	bne.n	1b76 <main+0xa1e>
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*100);
}

static void set_lnt_timer(uint32_t end_time) {
    update_system_time();
    1b8e:	f7fe ff0f 	bl	9b0 <update_system_time>
    if(end_time <= xo_sys_time) {
    1b92:	4e38      	ldr	r6, [pc, #224]	; (1c74 <main+0xb1c>)
    1b94:	6833      	ldr	r3, [r6, #0]
    1b96:	429d      	cmp	r5, r3
    1b98:	d803      	bhi.n	1ba2 <main+0xa4a>
        end_time = xo_sys_time + (3 << 15);        // add 3 seconds as buffer
    1b9a:	6835      	ldr	r5, [r6, #0]
    1b9c:	23c0      	movs	r3, #192	; 0xc0
    1b9e:	025b      	lsls	r3, r3, #9
    1ba0:	18ed      	adds	r5, r5, r3
    }

    // always start lnt meas
    uint32_t val = (end_time - xo_sys_time) >> 7; // FIXME: change this frequency
    lntv1a_r03.TIME_COUNTING = val;
    1ba2:	4b35      	ldr	r3, [pc, #212]	; (1c78 <main+0xb20>)
    if(end_time <= xo_sys_time) {
        end_time = xo_sys_time + (3 << 15);        // add 3 seconds as buffer
    }

    // always start lnt meas
    uint32_t val = (end_time - xo_sys_time) >> 7; // FIXME: change this frequency
    1ba4:	6831      	ldr	r1, [r6, #0]
    lntv1a_r03.TIME_COUNTING = val;
    1ba6:	681a      	ldr	r2, [r3, #0]
    if(end_time <= xo_sys_time) {
        end_time = xo_sys_time + (3 << 15);        // add 3 seconds as buffer
    }

    // always start lnt meas
    uint32_t val = (end_time - xo_sys_time) >> 7; // FIXME: change this frequency
    1ba8:	1a69      	subs	r1, r5, r1
    lntv1a_r03.TIME_COUNTING = val;
    1baa:	0049      	lsls	r1, r1, #1
    1bac:	0e12      	lsrs	r2, r2, #24
    1bae:	0a09      	lsrs	r1, r1, #8
    1bb0:	0612      	lsls	r2, r2, #24
    1bb2:	430a      	orrs	r2, r1
    1bb4:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1bb6:	2003      	movs	r0, #3
    1bb8:	681a      	ldr	r2, [r3, #0]
    1bba:	1c01      	adds	r1, r0, #0
    1bbc:	f7fe fb3b 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1bc0:	4c2e      	ldr	r4, [pc, #184]	; (1c7c <main+0xb24>)
    1bc2:	2208      	movs	r2, #8
    1bc4:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1bc6:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1bc8:	4393      	bics	r3, r2
    1bca:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    1bcc:	7823      	ldrb	r3, [r4, #0]
    1bce:	2204      	movs	r2, #4
    1bd0:	4313      	orrs	r3, r2
    1bd2:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1bd4:	6822      	ldr	r2, [r4, #0]
    1bd6:	2003      	movs	r0, #3
    1bd8:	f7fe fb2d 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1bdc:	20fa      	movs	r0, #250	; 0xfa
    1bde:	0080      	lsls	r0, r0, #2
    1be0:	f7fe faa2 	bl	128 <delay>
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    1be4:	7823      	ldrb	r3, [r4, #0]
    1be6:	2210      	movs	r2, #16
    1be8:	4313      	orrs	r3, r2
    1bea:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1bec:	7823      	ldrb	r3, [r4, #0]
    1bee:	2740      	movs	r7, #64	; 0x40
    1bf0:	43bb      	bics	r3, r7
    1bf2:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1bf4:	7823      	ldrb	r3, [r4, #0]
    1bf6:	2220      	movs	r2, #32
    1bf8:	4393      	bics	r3, r2
    1bfa:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1bfc:	6822      	ldr	r2, [r4, #0]
    1bfe:	2100      	movs	r1, #0
    1c00:	2003      	movs	r0, #3
    1c02:	f7fe fb18 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1c06:	20fa      	movs	r0, #250	; 0xfa
    1c08:	0080      	lsls	r0, r0, #2
    1c0a:	f7fe fa8d 	bl	128 <delay>

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1c0e:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1c10:	2100      	movs	r1, #0
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1c12:	431f      	orrs	r7, r3
    1c14:	7027      	strb	r7, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1c16:	6822      	ldr	r2, [r4, #0]
    1c18:	2003      	movs	r0, #3
    1c1a:	f7fe fb0c 	bl	236 <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1c1e:	4818      	ldr	r0, [pc, #96]	; (1c80 <main+0xb28>)
    1c20:	f7fe fa82 	bl	128 <delay>
    // always start lnt meas
    uint32_t val = (end_time - xo_sys_time) >> 7; // FIXME: change this frequency
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    lnt_start();
    mbus_write_message32(0xCE, (end_time - xo_sys_time) >> 15);
    1c24:	6831      	ldr	r1, [r6, #0]
    1c26:	20ce      	movs	r0, #206	; 0xce
    1c28:	1a6d      	subs	r5, r5, r1
    1c2a:	0be9      	lsrs	r1, r5, #15
    1c2c:	f7fe fac2 	bl	1b4 <mbus_write_message32>
        }
    }

    set_lnt_timer(end_time);

    pmu_setting_temp_based(2);
    1c30:	2002      	movs	r0, #2
    1c32:	f7fe fc23 	bl	47c <pmu_setting_temp_based>

    operation_sleep();
    1c36:	f7fe fc8f 	bl	558 <operation_sleep>
    1c3a:	46c0      	nop			; (mov r8, r8)
    1c3c:	00001dbc 	.word	0x00001dbc
    1c40:	00001d9a 	.word	0x00001d9a
    1c44:	00001d94 	.word	0x00001d94
    1c48:	00001d9c 	.word	0x00001d9c
    1c4c:	00001d30 	.word	0x00001d30
    1c50:	00001da8 	.word	0x00001da8
    1c54:	00001dec 	.word	0x00001dec
    1c58:	00001d18 	.word	0x00001d18
    1c5c:	00001dfa 	.word	0x00001dfa
    1c60:	00001da9 	.word	0x00001da9
    1c64:	00001d70 	.word	0x00001d70
    1c68:	00e0ffff 	.word	0x00e0ffff
    1c6c:	00001de4 	.word	0x00001de4
    1c70:	00001daa 	.word	0x00001daa
    1c74:	00001e00 	.word	0x00001e00
    1c78:	00001d1c 	.word	0x00001d1c
    1c7c:	00001d40 	.word	0x00001d40
    1c80:	00002710 	.word	0x00002710
