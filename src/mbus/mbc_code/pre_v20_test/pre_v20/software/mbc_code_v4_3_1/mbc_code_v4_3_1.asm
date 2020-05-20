
mbc_code_v4_3_1/mbc_code_v4_3_1.elf:     file format elf32-littlearm


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
  40:	0000103d 	.word	0x0000103d
  44:	00000000 	.word	0x00000000
  48:	00001049 	.word	0x00001049
  4c:	00001055 	.word	0x00001055
	...
  60:	00001089 	.word	0x00001089
  64:	00001099 	.word	0x00001099
  68:	000010a9 	.word	0x000010a9
  6c:	000010b9 	.word	0x000010b9
	...
  8c:	00001075 	.word	0x00001075

00000090 <hang>:
  90:	e7fe      	b.n	90 <hang>
	...

000000a0 <_start>:
  a0:	f001 f866 	bl	1170 <main>
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

Disassembly of section .text.set_halt_until_mbus_tx:

000000f0 <set_halt_until_mbus_tx>:
// MBUS IRQ SETTING
//**************************************************
void set_halt_until_reg(uint32_t reg_id) { *SREG_CONF_HALT = reg_id; }
void set_halt_until_mem_wr(void) { *SREG_CONF_HALT = HALT_UNTIL_MEM_WR; }
void set_halt_until_mbus_rx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_RX; }
void set_halt_until_mbus_tx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_TX; }
  f0:	4b01      	ldr	r3, [pc, #4]	; (f8 <set_halt_until_mbus_tx+0x8>)
  f2:	2209      	movs	r2, #9
  f4:	601a      	str	r2, [r3, #0]
  f6:	4770      	bx	lr
  f8:	a000a000 	.word	0xa000a000

Disassembly of section .text.set_halt_until_mbus_trx:

000000fc <set_halt_until_mbus_trx>:
void set_halt_until_mbus_trx(void) { *SREG_CONF_HALT = HALT_UNTIL_MBUS_TRX; }
  fc:	4b01      	ldr	r3, [pc, #4]	; (104 <set_halt_until_mbus_trx+0x8>)
  fe:	220c      	movs	r2, #12
 100:	601a      	str	r2, [r3, #0]
 102:	4770      	bx	lr
 104:	a000a000 	.word	0xa000a000

Disassembly of section .text.mbus_write_message:

00000108 <mbus_write_message>:
}

uint32_t mbus_write_message(uint8_t addr, uint32_t data[], unsigned len) {
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;
 108:	2300      	movs	r3, #0
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
    return 1;
}

uint32_t mbus_write_message(uint8_t addr, uint32_t data[], unsigned len) {
 10a:	b500      	push	{lr}
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;
 10c:	429a      	cmp	r2, r3
 10e:	d00a      	beq.n	126 <mbus_write_message+0x1e>

	*MBUS_CMD0 = (addr << 24) | (len-1);
 110:	4b06      	ldr	r3, [pc, #24]	; (12c <mbus_write_message+0x24>)
 112:	3a01      	subs	r2, #1
 114:	0600      	lsls	r0, r0, #24
 116:	4302      	orrs	r2, r0
 118:	601a      	str	r2, [r3, #0]
	*MBUS_CMD1 = (uint32_t) data;
 11a:	4b05      	ldr	r3, [pc, #20]	; (130 <mbus_write_message+0x28>)
	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x2 << 4);
 11c:	2223      	movs	r2, #35	; 0x23
	// Goal: Use the "Memory Stream Write" to put unconstrained 32-bit data
	//       onto the bus.
	if (len == 0) return 0;

	*MBUS_CMD0 = (addr << 24) | (len-1);
	*MBUS_CMD1 = (uint32_t) data;
 11e:	6019      	str	r1, [r3, #0]
	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x2 << 4);
 120:	4b04      	ldr	r3, [pc, #16]	; (134 <mbus_write_message+0x2c>)
 122:	601a      	str	r2, [r3, #0]
 124:	2301      	movs	r3, #1

    return 1;
}
 126:	1c18      	adds	r0, r3, #0
 128:	bd00      	pop	{pc}
 12a:	46c0      	nop			; (mov r8, r8)
 12c:	a0002000 	.word	0xa0002000
 130:	a0002004 	.word	0xa0002004
 134:	a000200c 	.word	0xa000200c

Disassembly of section .text.mbus_enumerate:

00000138 <mbus_enumerate>:

void mbus_enumerate(unsigned new_prefix) {
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
 138:	0603      	lsls	r3, r0, #24
 13a:	2080      	movs	r0, #128	; 0x80
 13c:	0580      	lsls	r0, r0, #22
 13e:	4318      	orrs	r0, r3
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
 140:	4b01      	ldr	r3, [pc, #4]	; (148 <mbus_enumerate+0x10>)
 142:	6018      	str	r0, [r3, #0]
    return 1;
}

void mbus_enumerate(unsigned new_prefix) {
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
}
 144:	4770      	bx	lr
 146:	46c0      	nop			; (mov r8, r8)
 148:	a0003000 	.word	0xa0003000

Disassembly of section .text.mbus_sleep_all:

0000014c <mbus_sleep_all>:
	return 1;
}

uint32_t mbus_write_message32(uint8_t addr, uint32_t data) {
    uint32_t mbus_addr = 0xA0003000 | (addr << 4);
    *((volatile uint32_t *) mbus_addr) = data;
 14c:	4b01      	ldr	r3, [pc, #4]	; (154 <mbus_sleep_all+0x8>)
 14e:	2200      	movs	r2, #0
 150:	601a      	str	r2, [r3, #0]
    mbus_write_message32(MBUS_DISC_AND_ENUM, ((MBUS_ENUMERATE_CMD << 28) | (new_prefix << 24)));
}

void mbus_sleep_all(void) {
    mbus_write_message32(MBUS_POWER, MBUS_ALL_SLEEP << 28);
}
 152:	4770      	bx	lr
 154:	a0003010 	.word	0xa0003010

Disassembly of section .text.mbus_copy_registers_from_remote_to_local:

00000158 <mbus_copy_registers_from_remote_to_local>:
void mbus_copy_registers_from_remote_to_local(
		uint8_t remote_prefix,
		uint8_t remote_reg_start,
		uint8_t local_reg_start,
		uint8_t length_minus_one
		) {
 158:	b507      	push	{r0, r1, r2, lr}
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
        (remote_reg_start << 24) |
 15a:	0609      	lsls	r1, r1, #24
 15c:	430a      	orrs	r2, r1
		(length_minus_one << 16) |
		(mbus_get_short_prefix() << 12) |
 15e:	2180      	movs	r1, #128	; 0x80
 160:	0149      	lsls	r1, r1, #5
 162:	430a      	orrs	r2, r1
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
        (remote_reg_start << 24) |
		(length_minus_one << 16) |
 164:	041b      	lsls	r3, r3, #16
		(mbus_get_short_prefix() << 12) |
		(MPQ_REG_WRITE << 8) | // Write regs *to* _this_ node
 166:	431a      	orrs	r2, r3
		uint8_t length_minus_one
		) {
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
	uint32_t data = 
 168:	9201      	str	r2, [sp, #4]
		uint8_t local_reg_start,
		uint8_t length_minus_one
		) {
	// Put a register read command on the bus instructed to write this node

	uint8_t address = ((remote_prefix & 0xf) << 4) | MPQ_REG_READ;
 16a:	0100      	lsls	r0, r0, #4
 16c:	2201      	movs	r2, #1
 16e:	4310      	orrs	r0, r2
		(length_minus_one << 16) |
		(mbus_get_short_prefix() << 12) |
		(MPQ_REG_WRITE << 8) | // Write regs *to* _this_ node
		(local_reg_start << 0);

	mbus_write_message(address, &data, 1);
 170:	b2c0      	uxtb	r0, r0
 172:	a901      	add	r1, sp, #4
 174:	f7ff ffc8 	bl	108 <mbus_write_message>
}
 178:	bd07      	pop	{r0, r1, r2, pc}

Disassembly of section .text.mbus_remote_register_write:

0000017a <mbus_remote_register_write>:

void mbus_remote_register_write(
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
 17a:	b507      	push	{r0, r1, r2, lr}
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 17c:	0212      	lsls	r2, r2, #8
 17e:	0a12      	lsrs	r2, r2, #8
 180:	0609      	lsls	r1, r1, #24
 182:	4311      	orrs	r1, r2
		uint8_t prefix,
		uint8_t dst_reg_addr,
		uint32_t dst_reg_val
		) {
	// assert (prefix < 16 && > 0);
	uint8_t address = ((prefix & 0xf) << 4) | MPQ_REG_WRITE;
 184:	0100      	lsls	r0, r0, #4
	uint32_t data = (dst_reg_addr << 24) | (dst_reg_val & 0xffffff);
 186:	9101      	str	r1, [sp, #4]
	mbus_write_message(address, &data, 1);
 188:	b2c0      	uxtb	r0, r0
 18a:	a901      	add	r1, sp, #4
 18c:	2201      	movs	r2, #1
 18e:	f7ff ffbb 	bl	108 <mbus_write_message>
}
 192:	bd07      	pop	{r0, r1, r2, pc}

Disassembly of section .text.mbus_copy_mem_from_local_to_remote_bulk:

00000194 <mbus_copy_mem_from_local_to_remote_bulk>:
void mbus_copy_mem_from_local_to_remote_bulk(
		uint8_t   remote_prefix,
		uint32_t* remote_memory_address,
		uint32_t* local_address,
		uint32_t  length_in_words_minus_one
		) {
 194:	b510      	push	{r4, lr}
	*MBUS_CMD0 = ( ((uint32_t) remote_prefix) << 28 ) | (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF);
 196:	2480      	movs	r4, #128	; 0x80
 198:	04a4      	lsls	r4, r4, #18
 19a:	0700      	lsls	r0, r0, #28
 19c:	031b      	lsls	r3, r3, #12
 19e:	4320      	orrs	r0, r4
 1a0:	0b1b      	lsrs	r3, r3, #12
 1a2:	4318      	orrs	r0, r3
 1a4:	4b04      	ldr	r3, [pc, #16]	; (1b8 <mbus_copy_mem_from_local_to_remote_bulk+0x24>)
 1a6:	6018      	str	r0, [r3, #0]
	*MBUS_CMD1 = (uint32_t) local_address;
 1a8:	4b04      	ldr	r3, [pc, #16]	; (1bc <mbus_copy_mem_from_local_to_remote_bulk+0x28>)
 1aa:	601a      	str	r2, [r3, #0]
	*MBUS_CMD2 = (uint32_t) remote_memory_address;
 1ac:	4b04      	ldr	r3, [pc, #16]	; (1c0 <mbus_copy_mem_from_local_to_remote_bulk+0x2c>)

	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x3 << 4);
 1ae:	2233      	movs	r2, #51	; 0x33
		uint32_t* local_address,
		uint32_t  length_in_words_minus_one
		) {
	*MBUS_CMD0 = ( ((uint32_t) remote_prefix) << 28 ) | (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF);
	*MBUS_CMD1 = (uint32_t) local_address;
	*MBUS_CMD2 = (uint32_t) remote_memory_address;
 1b0:	6019      	str	r1, [r3, #0]

	*MBUS_FUID_LEN = MPQ_MEM_READ | (0x3 << 4);
 1b2:	4b04      	ldr	r3, [pc, #16]	; (1c4 <mbus_copy_mem_from_local_to_remote_bulk+0x30>)
 1b4:	601a      	str	r2, [r3, #0]
}
 1b6:	bd10      	pop	{r4, pc}
 1b8:	a0002000 	.word	0xa0002000
 1bc:	a0002004 	.word	0xa0002004
 1c0:	a0002008 	.word	0xa0002008
 1c4:	a000200c 	.word	0xa000200c

Disassembly of section .text.mbus_copy_mem_from_remote_to_any_bulk:

000001c8 <mbus_copy_mem_from_remote_to_any_bulk>:
		uint8_t   source_prefix,
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
 1c8:	b530      	push	{r4, r5, lr}
 1ca:	b085      	sub	sp, #20
	uint32_t payload[3] = {
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
 1cc:	9d08      	ldr	r5, [sp, #32]
 1ce:	2480      	movs	r4, #128	; 0x80
 1d0:	04a4      	lsls	r4, r4, #18
 1d2:	0712      	lsls	r2, r2, #28
 1d4:	4322      	orrs	r2, r4
 1d6:	032c      	lsls	r4, r5, #12
 1d8:	0b24      	lsrs	r4, r4, #12
 1da:	4322      	orrs	r2, r4
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 1dc:	9201      	str	r2, [sp, #4]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 1de:	0100      	lsls	r0, r0, #4
 1e0:	2203      	movs	r2, #3
 1e2:	4310      	orrs	r0, r2
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 1e4:	9102      	str	r1, [sp, #8]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 1e6:	b2c0      	uxtb	r0, r0
 1e8:	a901      	add	r1, sp, #4
		uint32_t* source_memory_address,
		uint8_t   destination_prefix,
		uint32_t* destination_memory_address,
		uint32_t  length_in_words_minus_one
		) {
	uint32_t payload[3] = {
 1ea:	9303      	str	r3, [sp, #12]
		( ((uint32_t) destination_prefix) << 28 )| (MPQ_MEM_BULK_WRITE << 24) | (length_in_words_minus_one & 0xFFFFF),
		(uint32_t) source_memory_address,
		(uint32_t) destination_memory_address,
	};
	mbus_write_message(((source_prefix << 4 ) | MPQ_MEM_READ), payload, 3);
 1ec:	f7ff ff8c 	bl	108 <mbus_write_message>
}
 1f0:	b005      	add	sp, #20
 1f2:	bd30      	pop	{r4, r5, pc}

Disassembly of section .text.unlikely.update_light_interval:

000001f4 <update_light_interval>:
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    lnt_start();
}

static uint16_t update_light_interval() {
 1f4:	b530      	push	{r4, r5, lr}
#ifdef LNT_MANUAL_PERIOD
    uint8_t i;
    for(i = 0; i < 11; i++) {
    	if(xo_day_time_in_sec >= LNT_TIME_THRESH[i]
 1f6:	4a0e      	ldr	r2, [pc, #56]	; (230 <update_light_interval+0x3c>)
 1f8:	490e      	ldr	r1, [pc, #56]	; (234 <update_light_interval+0x40>)
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    lnt_start();
}

static uint16_t update_light_interval() {
 1fa:	2300      	movs	r3, #0
 1fc:	0098      	lsls	r0, r3, #2
#ifdef LNT_MANUAL_PERIOD
    uint8_t i;
    for(i = 0; i < 11; i++) {
    	if(xo_day_time_in_sec >= LNT_TIME_THRESH[i]
 1fe:	6814      	ldr	r4, [r2, #0]
 200:	5845      	ldr	r5, [r0, r1]
 202:	42ac      	cmp	r4, r5
 204:	d308      	bcc.n	218 <update_light_interval+0x24>
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    lnt_start();
}

static uint16_t update_light_interval() {
 206:	1808      	adds	r0, r1, r0
#ifdef LNT_MANUAL_PERIOD
    uint8_t i;
    for(i = 0; i < 11; i++) {
    	if(xo_day_time_in_sec >= LNT_TIME_THRESH[i]
		&& xo_day_time_in_sec < LNT_TIME_THRESH[i + 1]) {
 208:	6814      	ldr	r4, [r2, #0]
 20a:	6840      	ldr	r0, [r0, #4]
 20c:	4284      	cmp	r4, r0
 20e:	d203      	bcs.n	218 <update_light_interval+0x24>
	    lnt_meas_time_mode = LNT_INTERVAL_IDX[i];
 210:	4a09      	ldr	r2, [pc, #36]	; (238 <update_light_interval+0x44>)
 212:	5cd2      	ldrb	r2, [r2, r3]
 214:	4b09      	ldr	r3, [pc, #36]	; (23c <update_light_interval+0x48>)
 216:	e004      	b.n	222 <update_light_interval+0x2e>
 218:	3301      	adds	r3, #1
}

static uint16_t update_light_interval() {
#ifdef LNT_MANUAL_PERIOD
    uint8_t i;
    for(i = 0; i < 11; i++) {
 21a:	2b0b      	cmp	r3, #11
 21c:	d1ee      	bne.n	1fc <update_light_interval+0x8>
		&& xo_day_time_in_sec < LNT_TIME_THRESH[i + 1]) {
	    lnt_meas_time_mode = LNT_INTERVAL_IDX[i];
	    return LNT_INTERVAL[lnt_meas_time_mode];
	}
    }
    lnt_meas_time_mode = 3;
 21e:	4b07      	ldr	r3, [pc, #28]	; (23c <update_light_interval+0x48>)
 220:	2203      	movs	r2, #3
 222:	701a      	strb	r2, [r3, #0]
    return LNT_INTERVAL[lnt_meas_time_mode];
 224:	781a      	ldrb	r2, [r3, #0]
 226:	4b06      	ldr	r3, [pc, #24]	; (240 <update_light_interval+0x4c>)
 228:	0052      	lsls	r2, r2, #1
 22a:	5ad0      	ldrh	r0, [r2, r3]
    /// mbus_write_message32(0xDF, LNT_INTERVAL[lnt_cur_level]);
    lnt_meas_time_mode = lnt_cur_level;
    return LNT_INTERVAL[lnt_cur_level];
#endif

}
 22c:	bd30      	pop	{r4, r5, pc}
 22e:	46c0      	nop			; (mov r8, r8)
 230:	00001e8c 	.word	0x00001e8c
 234:	00001d2c 	.word	0x00001d2c
 238:	00001d5c 	.word	0x00001d5c
 23c:	00001e55 	.word	0x00001e55
 240:	00001d68 	.word	0x00001d68

Disassembly of section .text.radio_power_off:

00000244 <radio_power_off>:
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    delay(MBUS_DELAY*5); // Freq stab

}

static void radio_power_off() {
 244:	b5f8      	push	{r3, r4, r5, r6, r7, lr}

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 246:	4c2c      	ldr	r4, [pc, #176]	; (2f8 <radio_power_off+0xb4>)
 248:	2601      	movs	r6, #1
 24a:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 24c:	2002      	movs	r0, #2

    // Enable PMU ADC
    //pmu_adc_enable();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
 24e:	43b3      	bics	r3, r6
 250:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 252:	6822      	ldr	r2, [r4, #0]
 254:	2100      	movs	r1, #0
 256:	f7ff ff90 	bl	17a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
 25a:	6823      	ldr	r3, [r4, #0]
 25c:	227e      	movs	r2, #126	; 0x7e
 25e:	4393      	bics	r3, r2
 260:	2220      	movs	r2, #32
 262:	4313      	orrs	r3, r2
 264:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 266:	6822      	ldr	r2, [r4, #0]
 268:	2002      	movs	r0, #2
 26a:	2100      	movs	r1, #0
 26c:	f7ff ff85 	bl	17a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 270:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 272:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
 274:	4333      	orrs	r3, r6
 276:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
 278:	6822      	ldr	r2, [r4, #0]
 27a:	2100      	movs	r1, #0
 27c:	f7ff ff7d 	bl	17a <mbus_remote_register_write>

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 280:	4b1e      	ldr	r3, [pc, #120]	; (2fc <radio_power_off+0xb8>)
 282:	4a1f      	ldr	r2, [pc, #124]	; (300 <radio_power_off+0xbc>)
 284:	6819      	ldr	r1, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 286:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
 288:	400a      	ands	r2, r1
 28a:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
 28c:	681a      	ldr	r2, [r3, #0]
 28e:	2103      	movs	r1, #3
 290:	f7ff ff73 	bl	17a <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 294:	4b1b      	ldr	r3, [pc, #108]	; (304 <radio_power_off+0xc0>)
 296:	2704      	movs	r7, #4
 298:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 29a:	2502      	movs	r5, #2

    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
 29c:	43ba      	bics	r2, r7
 29e:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 2a0:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 2a2:	1c28      	adds	r0, r5, #0
    // Turn off everything
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
 2a4:	43aa      	bics	r2, r5
 2a6:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 2a8:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 2aa:	2111      	movs	r1, #17
    mrrv7_r03.MRR_TRX_ISOLATEN = 0;     //set ISOLATEN 0
    mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);

    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
 2ac:	4332      	orrs	r2, r6
 2ae:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
 2b0:	681a      	ldr	r2, [r3, #0]
 2b2:	f7ff ff62 	bl	17a <mbus_remote_register_write>

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 2b6:	4c14      	ldr	r4, [pc, #80]	; (308 <radio_power_off+0xc4>)
 2b8:	2208      	movs	r2, #8
 2ba:	6823      	ldr	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 2bc:	1c28      	adds	r0, r5, #0
    mrrv7_r11.MRR_RAD_FSM_EN = 0;  //Stop BB
    mrrv7_r11.MRR_RAD_FSM_RSTN = 0;  //RST BB
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 1;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);

    mrrv7_r04.RO_RESET = 1;  //Release Reset TIMER
 2be:	4313      	orrs	r3, r2
 2c0:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
 2c2:	6823      	ldr	r3, [r4, #0]
 2c4:	2220      	movs	r2, #32
 2c6:	4393      	bics	r3, r2
 2c8:	6023      	str	r3, [r4, #0]
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
 2ca:	6823      	ldr	r3, [r4, #0]
 2cc:	2210      	movs	r2, #16
 2ce:	4313      	orrs	r3, r2
 2d0:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 2d2:	1c39      	adds	r1, r7, #0
 2d4:	6822      	ldr	r2, [r4, #0]
 2d6:	f7ff ff50 	bl	17a <mbus_remote_register_write>

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 2da:	6823      	ldr	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 2dc:	1c28      	adds	r0, r5, #0
    mrrv7_r04.RO_EN_CLK = 0; //Enable CLK TIMER
    mrrv7_r04.RO_ISOLATE_CLK = 1; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Enable timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 0;  //Use V1P2 for TIMER
 2de:	43b3      	bics	r3, r6
 2e0:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
 2e2:	6822      	ldr	r2, [r4, #0]
 2e4:	1c39      	adds	r1, r7, #0
 2e6:	f7ff ff48 	bl	17a <mbus_remote_register_write>

    radio_on = 0;
 2ea:	4a08      	ldr	r2, [pc, #32]	; (30c <radio_power_off+0xc8>)
 2ec:	2300      	movs	r3, #0
 2ee:	7013      	strb	r3, [r2, #0]
    radio_ready = 0;
 2f0:	4a07      	ldr	r2, [pc, #28]	; (310 <radio_power_off+0xcc>)
 2f2:	7013      	strb	r3, [r2, #0]

}
 2f4:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 2f6:	46c0      	nop			; (mov r8, r8)
 2f8:	00001e20 	.word	0x00001e20
 2fc:	00001e1c 	.word	0x00001e1c
 300:	ffefffff 	.word	0xffefffff
 304:	00001df4 	.word	0x00001df4
 308:	00001e18 	.word	0x00001e18
 30c:	00001e72 	.word	0x00001e72
 310:	00001e3e 	.word	0x00001e3e

Disassembly of section .text.pmu_reg_write:

00000314 <pmu_reg_write>:


/**********************************************
 * PMU functions (PMUv11)
 **********************************************/
static void pmu_reg_write(uint32_t reg_addr, uint32_t reg_data) {
 314:	b538      	push	{r3, r4, r5, lr}
 316:	1c05      	adds	r5, r0, #0
 318:	1c0c      	adds	r4, r1, #0
    set_halt_until_mbus_trx();
 31a:	f7ff feef 	bl	fc <set_halt_until_mbus_trx>
    mbus_remote_register_write(PMU_ADDR, reg_addr, reg_data);
 31e:	b2e9      	uxtb	r1, r5
 320:	2005      	movs	r0, #5
 322:	1c22      	adds	r2, r4, #0
 324:	f7ff ff29 	bl	17a <mbus_remote_register_write>
    set_halt_until_mbus_tx();
 328:	f7ff fee2 	bl	f0 <set_halt_until_mbus_tx>
}
 32c:	bd38      	pop	{r3, r4, r5, pc}

Disassembly of section .text.pmu_set_sleep_clk:

0000032e <pmu_set_sleep_clk>:
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint32_t setting) {
 32e:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 330:	0e05      	lsrs	r5, r0, #24
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 332:	27c0      	movs	r7, #192	; 0xc0
                 (r <<  9) |    // frequency multiplier r
 334:	026d      	lsls	r5, r5, #9
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 336:	023f      	lsls	r7, r7, #8
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 338:	26ff      	movs	r6, #255	; 0xff
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
 33a:	432f      	orrs	r7, r5
                 (r <<  9) |    // frequency multiplier r
 33c:	9500      	str	r5, [sp, #0]
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 33e:	0c05      	lsrs	r5, r0, #16
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 340:	4035      	ands	r5, r6
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 342:	016d      	lsls	r5, r5, #5
 344:	9501      	str	r5, [sp, #4]

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 346:	9901      	ldr	r1, [sp, #4]
}

static void pmu_set_sleep_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 348:	0a05      	lsrs	r5, r0, #8
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 34a:	4035      	ands	r5, r6

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 34c:	4329      	orrs	r1, r5
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}

static void pmu_set_sleep_clk(uint32_t setting) {
 34e:	1c04      	adds	r4, r0, #0
    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 350:	4339      	orrs	r1, r7
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 352:	4034      	ands	r4, r6
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
    uint8_t l_1p2 = setting & 0xFF;

    // Register 0x17: V3P6 SLEEP
    pmu_reg_write(0x17,         // PMU_EN_UPCONVERTER_TRIM_V3_SLEEP
 354:	2017      	movs	r0, #23
 356:	f7ff ffdd 	bl	314 <pmu_reg_write>
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 35a:	0161      	lsls	r1, r4, #5
                ((0 << 19) |    // enable pdm even during periodic reset
                 (0 << 18) |    // enable pfm even when Vref is not used as ref
                 (0 << 17) |    // enable pfm
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedack loop
                 (r <<  9) |    // frequency multiplier r
 35c:	4329      	orrs	r1, r5
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 35e:	4339      	orrs	r1, r7
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x15: V1P2 sleep
    pmu_reg_write(0x15,         // PMU_EN_SAR_TRIM_V3_SLEEP
 360:	2015      	movs	r0, #21
 362:	f7ff ffd7 	bl	314 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 366:	9900      	ldr	r1, [sp, #0]
 368:	9b01      	ldr	r3, [sp, #4]
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 36a:	2019      	movs	r0, #25
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 36c:	4319      	orrs	r1, r3
                 (l <<  5) |    // frequency multiplier l (actually l+1)
 36e:	4329      	orrs	r1, r5
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x19: V0P6 SLEEP
    pmu_reg_write(0x19,         // PMU_EN_DOWNCONVERTER_TRIM_V3_SLEEP
 370:	f7ff ffd0 	bl	314 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)
}
 374:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.pmu_set_sar_conversion_ratio:

00000376 <pmu_set_sar_conversion_ratio>:

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
 376:	b510      	push	{r4, lr}
 378:	1c04      	adds	r4, r0, #0
    uint8_t i;
    for(i = 0; i < 2; i++) {
	    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 37a:	1c21      	adds	r1, r4, #0
 37c:	2005      	movs	r0, #5
 37e:	f7ff ffc9 	bl	314 <pmu_reg_write>
		     (0 << 12) |    // let vdd_clk always connect to vbat
		     (i << 11) |    // enable override setting [10] (1'h0)
		     (0 << 10) |    // have the converter have the periodic reset (1'h0)
		     (i <<  9) |    // enable override setting [8:0] (1'h0)
		     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
		     (i <<  7) |    // enable override setting [6:0] (1'h0)
 382:	21aa      	movs	r1, #170	; 0xaa
 384:	0189      	lsls	r1, r1, #6
 386:	4321      	orrs	r1, r4
}

static void pmu_set_sar_conversion_ratio(uint8_t ratio) {
    uint8_t i;
    for(i = 0; i < 2; i++) {
	    pmu_reg_write(0x05,         // PMU_EN_SAR_RATIO_OVERRIDE; default: 12'h000
 388:	2005      	movs	r0, #5
 38a:	f7ff ffc3 	bl	314 <pmu_reg_write>
		     (i <<  9) |    // enable override setting [8:0] (1'h0)
		     (0 <<  8) |    // switch input / output power rails for upconversion (1'h0)
		     (i <<  7) |    // enable override setting [6:0] (1'h0)
		     (ratio)));  // binary converter's conversion ratio (7'h00)
    }
}
 38e:	bd10      	pop	{r4, pc}

Disassembly of section .text.pmu_set_active_clk:

00000390 <pmu_set_active_clk>:
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
 390:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 392:	0e05      	lsrs	r5, r0, #24
 394:	26ff      	movs	r6, #255	; 0xff
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 396:	026d      	lsls	r5, r5, #9
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 398:	1c07      	adds	r7, r0, #0
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 39a:	9500      	str	r5, [sp, #0]
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 39c:	1c2a      	adds	r2, r5, #0
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 39e:	4037      	ands	r7, r6
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
    uint8_t base = (setting >> 8) & 0xFF;
 3a0:	0a05      	lsrs	r5, r0, #8
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 3a2:	23c0      	movs	r3, #192	; 0xc0
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 3a4:	4035      	ands	r5, r6
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 3a6:	021b      	lsls	r3, r3, #8
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 3a8:	017f      	lsls	r7, r7, #5
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 3aa:	431a      	orrs	r2, r3
                 (r <<  9) |    // frequency multiplier r
 3ac:	432f      	orrs	r7, r5
                 (1 << 18) |    // state_vdd_0p6_turned_on
                 (0 << 19) |    // state_vbat_read
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
 3ae:	1c04      	adds	r4, r0, #0
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
 3b0:	4317      	orrs	r7, r2
                 (1 << 20)));   // state_state_horizon
}

static void pmu_set_active_clk(uint32_t setting) {
    uint8_t r = (setting >> 24) & 0xFF;
    uint8_t l = (setting >> 16) & 0xFF;
 3b2:	0c24      	lsrs	r4, r4, #16

    // mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 3b4:	1c39      	adds	r1, r7, #0
 3b6:	2016      	movs	r0, #22
    pmu_setting_temp_based(2);

    operation_sleep();

    while(1);
}
 3b8:	4026      	ands	r6, r4
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
                ((0 << 19) |    // enable PFM even during periodic reset
                 (0 << 18) |    // enable PFM even when Vref is not used as ref
                 (0 << 17) |    // enable PFM
                 (3 << 14) |    // comparator clock division ratio
                 (0 << 13) |    // enable main feedback loop
 3ba:	9201      	str	r2, [sp, #4]
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 3bc:	0176      	lsls	r6, r6, #5

    // mbus_write_message32(0xDE, setting);

    // The first register write to PMU needs to be repeated
    // Register 0x16: V1P2 ACTIVE
    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 3be:	f7ff ffa9 	bl	314 <pmu_reg_write>
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    pmu_reg_write(0x16,         // PMU_EN_SAR_TRIM_V3_ACTIVE
 3c2:	1c39      	adds	r1, r7, #0
 3c4:	2016      	movs	r0, #22
 3c6:	f7ff ffa5 	bl	314 <pmu_reg_write>
    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
 3ca:	9b01      	ldr	r3, [sp, #4]

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
                ((3 << 14) |    // desired vout/vin ratio; default: 0
                 (0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 3cc:	1c31      	adds	r1, r6, #0
 3ce:	4329      	orrs	r1, r5
                 (l <<  5) |    // frequency multiplier l
 3d0:	4319      	orrs	r1, r3
                 (r <<  9) |    // frequency multiplier r
                 (l_1p2 << 5) | // frequency multiplier l (actually l+1)
                 (base)));      // floor frequency base (0-63)

    // Register 0x18: V3P6 ACTIVE
    pmu_reg_write(0x18,         // PMU_EN_UPCONVERTER_TRIM_V3_ACTIVE
 3d2:	2018      	movs	r0, #24
 3d4:	f7ff ff9e 	bl	314 <pmu_reg_write>
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 3d8:	9a00      	ldr	r2, [sp, #0]
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 3da:	201a      	movs	r0, #26
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
 3dc:	4316      	orrs	r6, r2
                 (l <<  5) |    // frequency multiplier l
 3de:	1c31      	adds	r1, r6, #0
 3e0:	4329      	orrs	r1, r5
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)

    // Register 0x1A: V0P6 ACTIVE
    pmu_reg_write(0x1A,         // PMU_EN_DOWNCONVERTER_TRIM_V3_ACTIVE
 3e2:	f7ff ff97 	bl	314 <pmu_reg_write>
                ((0 << 13) |    // enable main feedback loop
                 (r <<  9) |    // frequency multiplier r
                 (l <<  5) |    // frequency multiplier l
                 (base)));      // floor frequency base (0-63)
}
 3e6:	bdf7      	pop	{r0, r1, r2, r4, r5, r6, r7, pc}

Disassembly of section .text.pmu_setting_temp_based:

000003e8 <pmu_setting_temp_based>:
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 3e8:	4a15      	ldr	r2, [pc, #84]	; (440 <pmu_setting_temp_based+0x58>)
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 3ea:	4916      	ldr	r1, [pc, #88]	; (444 <pmu_setting_temp_based+0x5c>)
 3ec:	b570      	push	{r4, r5, r6, lr}
 3ee:	2300      	movs	r3, #0
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
 3f0:	2406      	movs	r4, #6
}

// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
 3f2:	18cd      	adds	r5, r1, r3
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 3f4:	6816      	ldr	r6, [r2, #0]
 3f6:	696d      	ldr	r5, [r5, #20]
 3f8:	42ae      	cmp	r6, r5
 3fa:	d31a      	bcc.n	432 <pmu_setting_temp_based+0x4a>
 3fc:	b264      	sxtb	r4, r4
            if(mode == 0) {
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 3fe:	00a2      	lsls	r2, r4, #2
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
            if(mode == 0) {
 400:	2800      	cmp	r0, #0
 402:	d105      	bne.n	410 <pmu_setting_temp_based+0x28>
	        pmu_set_active_clk(PMU_ACTIVE_SETTINGS[i]);
 404:	4b10      	ldr	r3, [pc, #64]	; (448 <pmu_setting_temp_based+0x60>)
 406:	58d0      	ldr	r0, [r2, r3]
 408:	f7ff ffc2 	bl	390 <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_ACTIVE_SAR_SETTINGS[i]);
 40c:	4b0f      	ldr	r3, [pc, #60]	; (44c <pmu_setting_temp_based+0x64>)
 40e:	e00c      	b.n	42a <pmu_setting_temp_based+0x42>
            }
            else if(mode == 2) {
 410:	2802      	cmp	r0, #2
 412:	d105      	bne.n	420 <pmu_setting_temp_based+0x38>
                pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[i]);
 414:	4b0e      	ldr	r3, [pc, #56]	; (450 <pmu_setting_temp_based+0x68>)
 416:	58d0      	ldr	r0, [r2, r3]
 418:	f7ff ff89 	bl	32e <pmu_set_sleep_clk>
                pmu_set_sar_conversion_ratio(PMU_SLEEP_SAR_SETTINGS[i]);
 41c:	4b0d      	ldr	r3, [pc, #52]	; (454 <pmu_setting_temp_based+0x6c>)
 41e:	e004      	b.n	42a <pmu_setting_temp_based+0x42>
            }
            else {
	        pmu_set_active_clk(PMU_RADIO_SETTINGS[i]);
 420:	4b0d      	ldr	r3, [pc, #52]	; (458 <pmu_setting_temp_based+0x70>)
 422:	58d0      	ldr	r0, [r2, r3]
 424:	f7ff ffb4 	bl	390 <pmu_set_active_clk>
                pmu_set_sar_conversion_ratio(PMU_RADIO_SAR_SETTINGS[i]);
 428:	4b0c      	ldr	r3, [pc, #48]	; (45c <pmu_setting_temp_based+0x74>)
 42a:	5d18      	ldrb	r0, [r3, r4]
 42c:	f7ff ffa3 	bl	376 <pmu_set_sar_conversion_ratio>
 430:	e005      	b.n	43e <pmu_setting_temp_based+0x56>
// 0 : normal active
// 1 : radio active
// 2 : sleep
static void pmu_setting_temp_based(uint8_t mode) {
    int8_t i;
    for(i = PMU_SETTINGS_LEN; i >= 0; i--) {
 432:	3c01      	subs	r4, #1
 434:	b2e4      	uxtb	r4, r4
 436:	3b04      	subs	r3, #4
	    // mbus_write_message32(0xB3, 0xFFFFFFFF);
        if(i == 0 || snt_sys_temp_code >= PMU_TEMP_THRESH[i - 1]) {
 438:	2c00      	cmp	r4, #0
 43a:	d1da      	bne.n	3f2 <pmu_setting_temp_based+0xa>
 43c:	e7de      	b.n	3fc <pmu_setting_temp_based+0x14>
            }
            break;
        }
    }
    return;
}
 43e:	bd70      	pop	{r4, r5, r6, pc}
 440:	00001e10 	.word	0x00001e10
 444:	00001d98 	.word	0x00001d98
 448:	00001dc4 	.word	0x00001dc4
 44c:	00001de0 	.word	0x00001de0
 450:	00001d10 	.word	0x00001d10
 454:	00001db0 	.word	0x00001db0
 458:	00001d7c 	.word	0x00001d7c
 45c:	00001d70 	.word	0x00001d70

Disassembly of section .text.operation_sleep:

00000460 <operation_sleep>:

/**********************************************
 * End of program sleep operation
 **********************************************/

static void operation_sleep( void ) {
 460:	b508      	push	{r3, lr}
    // Reset GOC_DATA_IRQ
    *GOC_DATA_IRQ = 0;
 462:	2200      	movs	r2, #0
 464:	238c      	movs	r3, #140	; 0x8c
 466:	601a      	str	r2, [r3, #0]

#ifdef USE_MRR
    if(radio_on) {
 468:	4b04      	ldr	r3, [pc, #16]	; (47c <operation_sleep+0x1c>)
 46a:	781b      	ldrb	r3, [r3, #0]
 46c:	4293      	cmp	r3, r2
 46e:	d001      	beq.n	474 <operation_sleep+0x14>
    	radio_power_off();
 470:	f7ff fee8 	bl	244 <radio_power_off>
    }
#endif

    mbus_sleep_all();
 474:	f7ff fe6a 	bl	14c <mbus_sleep_all>
 478:	e7fe      	b.n	478 <operation_sleep+0x18>
 47a:	46c0      	nop			; (mov r8, r8)
 47c:	00001e72 	.word	0x00001e72

Disassembly of section .text.unlikely.store_temp.part.0:

00000480 <store_temp.part.0>:
}

uint16_t light_last_ref_time = 0;
uint16_t temp_last_ref_time = 0;

static void store_temp() {
 480:	b538      	push	{r3, r4, r5, lr}
    if(temp_storage_remainder < TEMP_MAX_REMAINDER) {
	// print_temp_compress();
        temp_code_storage[2] = /*(0 << 15) |*/ (temp_packet_num << 12) | (CHIP_ID << 8) | ((temp_last_ref_time >> 3) & 0xFF);
 482:	4b0f      	ldr	r3, [pc, #60]	; (4c0 <store_temp.part.0+0x40>)
 484:	4d0f      	ldr	r5, [pc, #60]	; (4c4 <store_temp.part.0+0x44>)
 486:	881b      	ldrh	r3, [r3, #0]
 488:	782a      	ldrb	r2, [r5, #0]
 48a:	08d9      	lsrs	r1, r3, #3
 48c:	0312      	lsls	r2, r2, #12
 48e:	b2c9      	uxtb	r1, r1
 490:	4311      	orrs	r1, r2
 492:	4a0d      	ldr	r2, [pc, #52]	; (4c8 <store_temp.part.0+0x48>)
        temp_code_storage[1] |= (temp_last_ref_time & 0x7) << 29;
 494:	075b      	lsls	r3, r3, #29
uint16_t temp_last_ref_time = 0;

static void store_temp() {
    if(temp_storage_remainder < TEMP_MAX_REMAINDER) {
	// print_temp_compress();
        temp_code_storage[2] = /*(0 << 15) |*/ (temp_packet_num << 12) | (CHIP_ID << 8) | ((temp_last_ref_time >> 3) & 0xFF);
 496:	6091      	str	r1, [r2, #8]
        temp_code_storage[1] |= (temp_last_ref_time & 0x7) << 29;
 498:	6851      	ldr	r1, [r2, #4]
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (MEM_TEMP_ADDR + mem_temp_len), (uint32_t*) temp_code_storage, 2);
 49a:	4c0c      	ldr	r4, [pc, #48]	; (4cc <store_temp.part.0+0x4c>)

static void store_temp() {
    if(temp_storage_remainder < TEMP_MAX_REMAINDER) {
	// print_temp_compress();
        temp_code_storage[2] = /*(0 << 15) |*/ (temp_packet_num << 12) | (CHIP_ID << 8) | ((temp_last_ref_time >> 3) & 0xFF);
        temp_code_storage[1] |= (temp_last_ref_time & 0x7) << 29;
 49c:	430b      	orrs	r3, r1
 49e:	6053      	str	r3, [r2, #4]
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (MEM_TEMP_ADDR + mem_temp_len), (uint32_t*) temp_code_storage, 2);
 4a0:	8821      	ldrh	r1, [r4, #0]
 4a2:	4b0b      	ldr	r3, [pc, #44]	; (4d0 <store_temp.part.0+0x50>)
 4a4:	2006      	movs	r0, #6
 4a6:	18c9      	adds	r1, r1, r3
 4a8:	2302      	movs	r3, #2
 4aa:	f7ff fe73 	bl	194 <mbus_copy_mem_from_local_to_remote_bulk>
        temp_packet_num = (temp_packet_num + 1) & 7;
 4ae:	782b      	ldrb	r3, [r5, #0]
 4b0:	2207      	movs	r2, #7
 4b2:	3301      	adds	r3, #1
 4b4:	4013      	ands	r3, r2
 4b6:	702b      	strb	r3, [r5, #0]
        mem_temp_len += 12; // 3 * 4 B
 4b8:	8823      	ldrh	r3, [r4, #0]
 4ba:	330c      	adds	r3, #12
 4bc:	8023      	strh	r3, [r4, #0]

	// print_temp_compress();
    }
}
 4be:	bd38      	pop	{r3, r4, r5, pc}
 4c0:	00001e9e 	.word	0x00001e9e
 4c4:	00001e73 	.word	0x00001e73
 4c8:	00001e60 	.word	0x00001e60
 4cc:	00001e84 	.word	0x00001e84
 4d0:	000036b0 	.word	0x000036b0

Disassembly of section .text.operation_temp_run:

000004d4 <operation_temp_run>:
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void operation_temp_run() {
 4d4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    if(snt_state == SNT_IDLE) {
 4d6:	4c4e      	ldr	r4, [pc, #312]	; (610 <operation_temp_run+0x13c>)
 4d8:	7821      	ldrb	r1, [r4, #0]
 4da:	2900      	cmp	r1, #0
 4dc:	d10c      	bne.n	4f8 <operation_temp_run+0x24>
    sntv4_r01.TSNS_RESETn = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void snt_ldo_vref_on() {
    sntv4_r00.LDO_EN_VREF = 1;
 4de:	4b4d      	ldr	r3, [pc, #308]	; (614 <operation_temp_run+0x140>)
 4e0:	2004      	movs	r0, #4
 4e2:	881a      	ldrh	r2, [r3, #0]
 4e4:	4302      	orrs	r2, r0
 4e6:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 4e8:	681a      	ldr	r2, [r3, #0]
 4ea:	f7ff fe46 	bl	17a <mbus_remote_register_write>
    if(snt_state == SNT_IDLE) {

        // Turn on snt ldo vref; requires ~30 ms to settle
        // TODo: figure out delay time
        snt_ldo_vref_on();
        delay(MBUS_DELAY);
 4ee:	2064      	movs	r0, #100	; 0x64
 4f0:	f7ff fdd9 	bl	a6 <delay>

        snt_state = SNT_TEMP_LDO;
 4f4:	2301      	movs	r3, #1
 4f6:	7023      	strb	r3, [r4, #0]

    }
    if(snt_state == SNT_TEMP_LDO) {
 4f8:	4f45      	ldr	r7, [pc, #276]	; (610 <operation_temp_run+0x13c>)
 4fa:	783d      	ldrb	r5, [r7, #0]
 4fc:	2d01      	cmp	r5, #1
 4fe:	d12e      	bne.n	55e <operation_temp_run+0x8a>
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 500:	4b44      	ldr	r3, [pc, #272]	; (614 <operation_temp_run+0x140>)
 502:	2602      	movs	r6, #2
 504:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 506:	2004      	movs	r0, #4
    sntv4_r00.LDO_EN_VREF = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
 508:	4332      	orrs	r2, r6
 50a:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 1;
 50c:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 50e:	2100      	movs	r1, #0
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_on() {
    sntv4_r00.LDO_EN_IREF = 1;
    sntv4_r00.LDO_EN_LDO  = 1;
 510:	432a      	orrs	r2, r5
 512:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 514:	681a      	ldr	r2, [r3, #0]
 516:	f7ff fe30 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 51a:	4c3f      	ldr	r4, [pc, #252]	; (618 <operation_temp_run+0x144>)
 51c:	2208      	movs	r2, #8
 51e:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 520:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void temp_sensor_power_on() {
    // Un-powergate digital block
    sntv4_r01.TSNS_SEL_LDO = 1;
 522:	4313      	orrs	r3, r2
 524:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 526:	6822      	ldr	r2, [r4, #0]
 528:	1c29      	adds	r1, r5, #0
 52a:	f7ff fe26 	bl	17a <mbus_remote_register_write>
    // Un-powergate analog block
    sntv4_r01.TSNS_EN_SENSOR_LDO = 1;
 52e:	8823      	ldrh	r3, [r4, #0]
 530:	2220      	movs	r2, #32
 532:	4313      	orrs	r3, r2
 534:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 536:	6822      	ldr	r2, [r4, #0]
 538:	1c29      	adds	r1, r5, #0
 53a:	2004      	movs	r0, #4
 53c:	f7ff fe1d 	bl	17a <mbus_remote_register_write>

    delay(MBUS_DELAY);
 540:	2064      	movs	r0, #100	; 0x64
 542:	f7ff fdb0 	bl	a6 <delay>

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 546:	8823      	ldrh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 548:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    delay(MBUS_DELAY);

    // Release isolation
    sntv4_r01.TSNS_ISOLATE = 0;
 54a:	43b3      	bics	r3, r6
 54c:	8023      	strh	r3, [r4, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 54e:	6822      	ldr	r2, [r4, #0]
 550:	1c29      	adds	r1, r5, #0
 552:	f7ff fe12 	bl	17a <mbus_remote_register_write>
        // Power on snt ldo
        snt_ldo_power_on();

        // Power on temp sensor
        temp_sensor_power_on();
        delay(MBUS_DELAY);
 556:	2064      	movs	r0, #100	; 0x64
 558:	f7ff fda5 	bl	a6 <delay>

        snt_state = SNT_TEMP_START;
 55c:	703e      	strb	r6, [r7, #0]
    }
    if(snt_state == SNT_TEMP_START) {
 55e:	4d2c      	ldr	r5, [pc, #176]	; (610 <operation_temp_run+0x13c>)
 560:	782b      	ldrb	r3, [r5, #0]
 562:	2b02      	cmp	r3, #2
 564:	d11d      	bne.n	5a2 <operation_temp_run+0xce>
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 566:	4b2d      	ldr	r3, [pc, #180]	; (61c <operation_temp_run+0x148>)
 568:	2400      	movs	r4, #0
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 56a:	20a0      	movs	r0, #160	; 0xa0

        snt_state = SNT_TEMP_START;
    }
    if(snt_state == SNT_TEMP_START) {
        // Use TIMER32 as a timeout counter
        wfi_timeout_flag = 0;
 56c:	701c      	strb	r4, [r3, #0]
        config_timer32(TIMER32_VAL, 1, 0, 0); // 1/10 of MBUS watchdog timer default
 56e:	0300      	lsls	r0, r0, #12
 570:	2101      	movs	r1, #1
 572:	1c22      	adds	r2, r4, #0
 574:	1c23      	adds	r3, r4, #0
 576:	f7ff fda1 	bl	bc <config_timer32>
/**********************************************
 * Temp sensor functions (SNTv4)
 **********************************************/

static void temp_sensor_start() {
    sntv4_r01.TSNS_RESETn = 1;
 57a:	4827      	ldr	r0, [pc, #156]	; (618 <operation_temp_run+0x144>)
 57c:	2101      	movs	r1, #1
 57e:	8803      	ldrh	r3, [r0, #0]
 580:	430b      	orrs	r3, r1
 582:	8003      	strh	r3, [r0, #0]
    sntv4_r01.TSNS_EN_IRQ = 1;
 584:	8802      	ldrh	r2, [r0, #0]
 586:	2380      	movs	r3, #128	; 0x80
 588:	408b      	lsls	r3, r1
 58a:	4313      	orrs	r3, r2
 58c:	8003      	strh	r3, [r0, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 58e:	6802      	ldr	r2, [r0, #0]
 590:	2004      	movs	r0, #4
 592:	f7ff fdf2 	bl	17a <mbus_remote_register_write>
        
        // Start temp sensor
        temp_sensor_start();

        // Wait for temp sensor output or TIMER32
	WFI();
 596:	f7ff fd8e 	bl	b6 <WFI>

        // Turn off timer32
        *TIMER32_GO = 0;
 59a:	4b21      	ldr	r3, [pc, #132]	; (620 <operation_temp_run+0x14c>)
 59c:	601c      	str	r4, [r3, #0]

        snt_state = SNT_TEMP_READ;
 59e:	2303      	movs	r3, #3
 5a0:	702b      	strb	r3, [r5, #0]
    }
    if(snt_state == SNT_TEMP_READ) {
 5a2:	4a1b      	ldr	r2, [pc, #108]	; (610 <operation_temp_run+0x13c>)
 5a4:	7813      	ldrb	r3, [r2, #0]
 5a6:	2b03      	cmp	r3, #3
 5a8:	d131      	bne.n	60e <operation_temp_run+0x13a>
        if(wfi_timeout_flag) {
 5aa:	4b1c      	ldr	r3, [pc, #112]	; (61c <operation_temp_run+0x148>)
 5ac:	781d      	ldrb	r5, [r3, #0]
 5ae:	1e2e      	subs	r6, r5, #0
 5b0:	d001      	beq.n	5b6 <operation_temp_run+0xe2>
// }

static void sys_err(uint32_t code)
{
    // mbus_write_message32(0xAF, code);
    operation_sleep();
 5b2:	f7ff ff55 	bl	460 <operation_sleep>
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 5b6:	23a0      	movs	r3, #160	; 0xa0
 5b8:	061b      	lsls	r3, r3, #24
 5ba:	681a      	ldr	r2, [r3, #0]
 5bc:	4b19      	ldr	r3, [pc, #100]	; (624 <operation_temp_run+0x150>)
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5be:	2401      	movs	r4, #1
        if(wfi_timeout_flag) {
            // if timeout, set error msg
            sys_err(0x01000000);
        }
        else {
            snt_sys_temp_code = *REG0;
 5c0:	601a      	str	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5c2:	4b15      	ldr	r3, [pc, #84]	; (618 <operation_temp_run+0x144>)
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5c4:	2108      	movs	r1, #8
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5c6:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 5c8:	2702      	movs	r7, #2
    sntv4_r01.TSNS_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
 5ca:	43a2      	bics	r2, r4
 5cc:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5ce:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5d0:	2004      	movs	r0, #4
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
}

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
 5d2:	438a      	bics	r2, r1
 5d4:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
 5d6:	881a      	ldrh	r2, [r3, #0]
 5d8:	2120      	movs	r1, #32
 5da:	438a      	bics	r2, r1
 5dc:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_ISOLATE       = 1;
 5de:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5e0:	1c21      	adds	r1, r4, #0

static void temp_sensor_power_off() {
    sntv4_r01.TSNS_RESETn        = 0;
    sntv4_r01.TSNS_SEL_LDO       = 0;
    sntv4_r01.TSNS_EN_SENSOR_LDO = 0;
    sntv4_r01.TSNS_ISOLATE       = 1;
 5e2:	433a      	orrs	r2, r7
 5e4:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
 5e6:	681a      	ldr	r2, [r3, #0]
 5e8:	f7ff fdc7 	bl	17a <mbus_remote_register_write>
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 5ec:	4b09      	ldr	r3, [pc, #36]	; (614 <operation_temp_run+0x140>)
 5ee:	2004      	movs	r0, #4
 5f0:	881a      	ldrh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
    sntv4_r00.LDO_EN_LDO  = 0;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 5f2:	1c31      	adds	r1, r6, #0
    sntv4_r00.LDO_EN_LDO  = 1;
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
}

static void snt_ldo_power_off() {
    sntv4_r00.LDO_EN_VREF = 0;
 5f4:	4382      	bics	r2, r0
 5f6:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_IREF = 0;
 5f8:	881a      	ldrh	r2, [r3, #0]
 5fa:	43ba      	bics	r2, r7
 5fc:	801a      	strh	r2, [r3, #0]
    sntv4_r00.LDO_EN_LDO  = 0;
 5fe:	881a      	ldrh	r2, [r3, #0]
 600:	43a2      	bics	r2, r4
 602:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 0, sntv4_r00.as_int);
 604:	681a      	ldr	r2, [r3, #0]
 606:	f7ff fdb8 	bl	17a <mbus_remote_register_write>
            
            // turn off temp sensor and ldo
            temp_sensor_power_off();
            snt_ldo_power_off();

            snt_state = SNT_IDLE;
 60a:	4b01      	ldr	r3, [pc, #4]	; (610 <operation_temp_run+0x13c>)
 60c:	701d      	strb	r5, [r3, #0]
        }
    }
}
 60e:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 610:	00001e90 	.word	0x00001e90
 614:	00001e04 	.word	0x00001e04
 618:	00001e08 	.word	0x00001e08
 61c:	00001e9c 	.word	0x00001e9c
 620:	a0001100 	.word	0xa0001100
 624:	00001e10 	.word	0x00001e10

Disassembly of section .text.update_system_time:

00000628 <update_system_time>:
}

#define XO_MAX_DAY_TIME_IN_SEC 131034
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
 628:	b538      	push	{r3, r4, r5, lr}
    uint32_t val = xo_sys_time_in_sec;
 62a:	4b18      	ldr	r3, [pc, #96]	; (68c <update_system_time+0x64>)
	sys_err(0x04000000);
    }
}

static uint32_t get_timer_cnt() {
    if(enumerated != ENUMID) { return 0; }
 62c:	2400      	movs	r4, #0

#define XO_MAX_DAY_TIME_IN_SEC 131034
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
 62e:	681d      	ldr	r5, [r3, #0]
	sys_err(0x04000000);
    }
}

static uint32_t get_timer_cnt() {
    if(enumerated != ENUMID) { return 0; }
 630:	4b17      	ldr	r3, [pc, #92]	; (690 <update_system_time+0x68>)
 632:	681a      	ldr	r2, [r3, #0]
 634:	4b17      	ldr	r3, [pc, #92]	; (694 <update_system_time+0x6c>)
 636:	429a      	cmp	r2, r3
 638:	d112      	bne.n	660 <update_system_time+0x38>
    set_halt_until_mbus_trx();
 63a:	f7ff fd5f 	bl	fc <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(SNT_ADDR, 0x1B, 0x0, 1);
 63e:	1c22      	adds	r2, r4, #0
 640:	2301      	movs	r3, #1
 642:	2004      	movs	r0, #4
 644:	211b      	movs	r1, #27
 646:	f7ff fd87 	bl	158 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
 64a:	f7ff fd51 	bl	f0 <set_halt_until_mbus_tx>

    return (*REG0 << 24) | (*REG1 & 0xFFFFFF);
 64e:	23a0      	movs	r3, #160	; 0xa0
 650:	4a11      	ldr	r2, [pc, #68]	; (698 <update_system_time+0x70>)
 652:	061b      	lsls	r3, r3, #24
 654:	681b      	ldr	r3, [r3, #0]
 656:	6814      	ldr	r4, [r2, #0]
 658:	061b      	lsls	r3, r3, #24
 65a:	0224      	lsls	r4, r4, #8
 65c:	0a24      	lsrs	r4, r4, #8
 65e:	431c      	orrs	r4, r3
#define XO_MAX_DAY_TIME_IN_SEC 131034
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
    xo_sys_time = get_timer_cnt();
 660:	4b0e      	ldr	r3, [pc, #56]	; (69c <update_system_time+0x74>)
    xo_sys_time_in_sec = xo_sys_time >> XO_TO_SEC_SHIFT;
 662:	4a0a      	ldr	r2, [pc, #40]	; (68c <update_system_time+0x64>)
#define XO_MAX_DAY_TIME_IN_SEC 131034
#define XO_TO_SEC_SHIFT 10

void update_system_time() {
    uint32_t val = xo_sys_time_in_sec;
    xo_sys_time = get_timer_cnt();
 664:	601c      	str	r4, [r3, #0]
    xo_sys_time_in_sec = xo_sys_time >> XO_TO_SEC_SHIFT;
 666:	681b      	ldr	r3, [r3, #0]
 668:	0a9b      	lsrs	r3, r3, #10
 66a:	6013      	str	r3, [r2, #0]
    xo_day_time_in_sec += xo_sys_time_in_sec - val;
 66c:	4b0c      	ldr	r3, [pc, #48]	; (6a0 <update_system_time+0x78>)
 66e:	6819      	ldr	r1, [r3, #0]
 670:	6812      	ldr	r2, [r2, #0]
 672:	1852      	adds	r2, r2, r1
 674:	1b55      	subs	r5, r2, r5
 676:	601d      	str	r5, [r3, #0]

    if(xo_day_time_in_sec >= XO_MAX_DAY_TIME_IN_SEC) {
 678:	6819      	ldr	r1, [r3, #0]
 67a:	4a0a      	ldr	r2, [pc, #40]	; (6a4 <update_system_time+0x7c>)
 67c:	4291      	cmp	r1, r2
 67e:	d903      	bls.n	688 <update_system_time+0x60>
        xo_day_time_in_sec -= XO_MAX_DAY_TIME_IN_SEC;
 680:	681a      	ldr	r2, [r3, #0]
 682:	4909      	ldr	r1, [pc, #36]	; (6a8 <update_system_time+0x80>)
 684:	1852      	adds	r2, r2, r1
 686:	601a      	str	r2, [r3, #0]
    }

    // mbus_write_message32(0xC2, xo_sys_time);
    // mbus_write_message32(0xC1, xo_sys_time_in_sec);
    // mbus_write_message32(0xC0, xo_day_time_in_sec);
}
 688:	bd38      	pop	{r3, r4, r5, pc}
 68a:	46c0      	nop			; (mov r8, r8)
 68c:	00001e88 	.word	0x00001e88
 690:	00001e40 	.word	0x00001e40
 694:	deadbeef 	.word	0xdeadbeef
 698:	a0000004 	.word	0xa0000004
 69c:	00001e98 	.word	0x00001e98
 6a0:	00001e8c 	.word	0x00001e8c
 6a4:	0001ffd9 	.word	0x0001ffd9
 6a8:	fffe0026 	.word	0xfffe0026

Disassembly of section .text.unlikely.set_next_time:

000006ac <set_next_time>:
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
    }
}

static void set_next_time(uint8_t idx, uint32_t step) {
 6ac:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
 6ae:	1c05      	adds	r5, r0, #0
 6b0:	1c0c      	adds	r4, r1, #0
    update_system_time();
 6b2:	f7ff ffb9 	bl	628 <update_system_time>
    xot_timer_list[idx] = xot_last_timer_list[idx];
 6b6:	4a0c      	ldr	r2, [pc, #48]	; (6e8 <set_next_time+0x3c>)
 6b8:	00a8      	lsls	r0, r5, #2
 6ba:	5881      	ldr	r1, [r0, r2]
 6bc:	4b0b      	ldr	r3, [pc, #44]	; (6ec <set_next_time+0x40>)
    uint32_t diff;
    do {
	// mbus_write_message32(0xD3, xot_timer_list[idx]);
        xot_timer_list[idx] += step;
        diff = xot_timer_list[idx] - xo_sys_time_in_sec;
 6be:	4f0c      	ldr	r7, [pc, #48]	; (6f0 <set_next_time+0x44>)
    }
}

static void set_next_time(uint8_t idx, uint32_t step) {
    update_system_time();
    xot_timer_list[idx] = xot_last_timer_list[idx];
 6c0:	50c1      	str	r1, [r0, r3]
    uint32_t diff;
    do {
	// mbus_write_message32(0xD3, xot_timer_list[idx]);
        xot_timer_list[idx] += step;
        diff = xot_timer_list[idx] - xo_sys_time_in_sec;
    } while((!(diff > 10 && diff < (step << 4))) 
 6c2:	0125      	lsls	r5, r4, #4
	    || xot_timer_list[idx] == xot_last_timer_list[idx]);    
 6c4:	4694      	mov	ip, r2
    update_system_time();
    xot_timer_list[idx] = xot_last_timer_list[idx];
    uint32_t diff;
    do {
	// mbus_write_message32(0xD3, xot_timer_list[idx]);
        xot_timer_list[idx] += step;
 6c6:	58c2      	ldr	r2, [r0, r3]
 6c8:	1912      	adds	r2, r2, r4
 6ca:	50c2      	str	r2, [r0, r3]
        diff = xot_timer_list[idx] - xo_sys_time_in_sec;
 6cc:	58c1      	ldr	r1, [r0, r3]
 6ce:	683a      	ldr	r2, [r7, #0]
 6d0:	1a8a      	subs	r2, r1, r2
    } while((!(diff > 10 && diff < (step << 4))) 
	    || xot_timer_list[idx] == xot_last_timer_list[idx]);    
 6d2:	2a0a      	cmp	r2, #10
 6d4:	d9f7      	bls.n	6c6 <set_next_time+0x1a>
    uint32_t diff;
    do {
	// mbus_write_message32(0xD3, xot_timer_list[idx]);
        xot_timer_list[idx] += step;
        diff = xot_timer_list[idx] - xo_sys_time_in_sec;
    } while((!(diff > 10 && diff < (step << 4))) 
 6d6:	42aa      	cmp	r2, r5
 6d8:	d2f5      	bcs.n	6c6 <set_next_time+0x1a>
	    || xot_timer_list[idx] == xot_last_timer_list[idx]);    
 6da:	4662      	mov	r2, ip
 6dc:	58c6      	ldr	r6, [r0, r3]
 6de:	5881      	ldr	r1, [r0, r2]
 6e0:	428e      	cmp	r6, r1
 6e2:	d0f0      	beq.n	6c6 <set_next_time+0x1a>
    // give some margin of error and prevent overflow
    // also make sure that the target values are not repeated
}
 6e4:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 6e6:	46c0      	nop			; (mov r8, r8)
 6e8:	00001eac 	.word	0x00001eac
 6ec:	00001ebc 	.word	0x00001ebc
 6f0:	00001e88 	.word	0x00001e88

Disassembly of section .text.xo_check_is_day:

000006f4 <xo_check_is_day>:
    // mbus_write_message32(0xC2, xo_sys_time);
    // mbus_write_message32(0xC1, xo_sys_time_in_sec);
    // mbus_write_message32(0xC0, xo_day_time_in_sec);
}

bool xo_check_is_day() {
 6f4:	b508      	push	{r3, lr}
    update_system_time();
 6f6:	f7ff ff97 	bl	628 <update_system_time>
    return xo_day_time_in_sec >= XO_DAY_START && xo_day_time_in_sec < XO_DAY_END;
 6fa:	4a06      	ldr	r2, [pc, #24]	; (714 <xo_check_is_day+0x20>)
 6fc:	4906      	ldr	r1, [pc, #24]	; (718 <xo_check_is_day+0x24>)
 6fe:	6810      	ldr	r0, [r2, #0]
 700:	2300      	movs	r3, #0
 702:	4288      	cmp	r0, r1
 704:	d903      	bls.n	70e <xo_check_is_day+0x1a>
 706:	6812      	ldr	r2, [r2, #0]
 708:	4904      	ldr	r1, [pc, #16]	; (71c <xo_check_is_day+0x28>)
 70a:	4291      	cmp	r1, r2
 70c:	415b      	adcs	r3, r3
 70e:	2001      	movs	r0, #1
 710:	4018      	ands	r0, r3
}
 712:	bd08      	pop	{r3, pc}
 714:	00001e8c 	.word	0x00001e8c
 718:	00009557 	.word	0x00009557
 71c:	0001955c 	.word	0x0001955c

Disassembly of section .text.right_shift:

00000720 <right_shift>:
 **********************************************/

#define LONG_INT_LEN 4
#define LOG2_RES 5

uint64_t right_shift(uint64_t input, int8_t shift) {
 720:	b510      	push	{r4, lr}
    int8_t i;
    if(shift >= 0) {
 722:	2300      	movs	r3, #0
 724:	2a00      	cmp	r2, #0
 726:	db0a      	blt.n	73e <right_shift+0x1e>
 728:	e005      	b.n	736 <right_shift+0x16>
    	for(i = 0; i < shift; i++) {
	    input = input >> 1;
 72a:	07cc      	lsls	r4, r1, #31
 72c:	0840      	lsrs	r0, r0, #1
#define LOG2_RES 5

uint64_t right_shift(uint64_t input, int8_t shift) {
    int8_t i;
    if(shift >= 0) {
    	for(i = 0; i < shift; i++) {
 72e:	3301      	adds	r3, #1
	    input = input >> 1;
 730:	4320      	orrs	r0, r4
 732:	0849      	lsrs	r1, r1, #1
#define LOG2_RES 5

uint64_t right_shift(uint64_t input, int8_t shift) {
    int8_t i;
    if(shift >= 0) {
    	for(i = 0; i < shift; i++) {
 734:	b2db      	uxtb	r3, r3
 736:	b25c      	sxtb	r4, r3
 738:	4294      	cmp	r4, r2
 73a:	d1f6      	bne.n	72a <right_shift+0xa>
 73c:	e008      	b.n	750 <right_shift+0x30>
	    input = input >> 1;
	}
    }
    else {
    	for(i = 0; i > shift; i--) {
 73e:	3b01      	subs	r3, #1
	    input = input << 1;
 740:	0fc4      	lsrs	r4, r0, #31
 742:	0049      	lsls	r1, r1, #1
    	for(i = 0; i < shift; i++) {
	    input = input >> 1;
	}
    }
    else {
    	for(i = 0; i > shift; i--) {
 744:	b2db      	uxtb	r3, r3
	    input = input << 1;
 746:	4321      	orrs	r1, r4
    	for(i = 0; i < shift; i++) {
	    input = input >> 1;
	}
    }
    else {
    	for(i = 0; i > shift; i--) {
 748:	b25c      	sxtb	r4, r3
	    input = input << 1;
 74a:	0040      	lsls	r0, r0, #1
    	for(i = 0; i < shift; i++) {
	    input = input >> 1;
	}
    }
    else {
    	for(i = 0; i > shift; i--) {
 74c:	4294      	cmp	r4, r2
 74e:	d1f6      	bne.n	73e <right_shift+0x1e>
	    input = input << 1;
	}
    }
    return input;
}
 750:	bd10      	pop	{r4, pc}

Disassembly of section .text.lnt_stop:

00000754 <lnt_stop>:
    delay(MBUS_DELAY*100);
}

static void lnt_stop() {
    // // Change Counting Time 
    mbus_remote_register_write(LNT_ADDR,0x03,0xFFFFFF);
 754:	2003      	movs	r0, #3
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*100);
}

static void lnt_stop() {
 756:	b510      	push	{r4, lr}
    // // Change Counting Time 
    mbus_remote_register_write(LNT_ADDR,0x03,0xFFFFFF);
 758:	1c01      	adds	r1, r0, #0
 75a:	4a18      	ldr	r2, [pc, #96]	; (7bc <lnt_stop+0x68>)
 75c:	f7ff fd0d 	bl	17a <mbus_remote_register_write>
    
    set_halt_until_mbus_trx();
 760:	f7ff fccc 	bl	fc <set_halt_until_mbus_trx>
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
 764:	2003      	movs	r0, #3
 766:	2110      	movs	r1, #16
 768:	2200      	movs	r2, #0
 76a:	2301      	movs	r3, #1
 76c:	f7ff fcf4 	bl	158 <mbus_copy_registers_from_remote_to_local>
    set_halt_until_mbus_tx();
 770:	f7ff fcbe 	bl	f0 <set_halt_until_mbus_tx>
    lnt_sys_light = right_shift(((*REG1 & 0xFFFFFF) << 24) | (*REG0), lnt_counter_base); // >> lnt_counter_base;
 774:	4b12      	ldr	r3, [pc, #72]	; (7c0 <lnt_stop+0x6c>)
 776:	4a13      	ldr	r2, [pc, #76]	; (7c4 <lnt_stop+0x70>)
 778:	6818      	ldr	r0, [r3, #0]
 77a:	23a0      	movs	r3, #160	; 0xa0
 77c:	061b      	lsls	r3, r3, #24
 77e:	681b      	ldr	r3, [r3, #0]
 780:	7812      	ldrb	r2, [r2, #0]
 782:	2400      	movs	r4, #0
 784:	0600      	lsls	r0, r0, #24
 786:	4318      	orrs	r0, r3
 788:	b252      	sxtb	r2, r2
 78a:	1c21      	adds	r1, r4, #0
 78c:	f7ff ffc8 	bl	720 <right_shift>
 790:	4b0d      	ldr	r3, [pc, #52]	; (7c8 <lnt_stop+0x74>)
 792:	6018      	str	r0, [r3, #0]
 794:	6059      	str	r1, [r3, #4]

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
 796:	4b0d      	ldr	r3, [pc, #52]	; (7cc <lnt_stop+0x78>)
 798:	2110      	movs	r1, #16
 79a:	781a      	ldrb	r2, [r3, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
 79c:	2003      	movs	r0, #3
    mbus_copy_registers_from_remote_to_local(LNT_ADDR, 0x10, 0x00, 1);
    set_halt_until_mbus_tx();
    lnt_sys_light = right_shift(((*REG1 & 0xFFFFFF) << 24) | (*REG0), lnt_counter_base); // >> lnt_counter_base;

    // // Stop FSM: Counter Idle -> Counter Counting 
    lntv1a_r00.DBE_ENABLE = 0x0; // Default : 0x0
 79e:	438a      	bics	r2, r1
 7a0:	701a      	strb	r2, [r3, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0;
 7a2:	781a      	ldrb	r2, [r3, #0]
 7a4:	2140      	movs	r1, #64	; 0x40
 7a6:	438a      	bics	r2, r1
 7a8:	701a      	strb	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
 7aa:	681a      	ldr	r2, [r3, #0]
 7ac:	1c21      	adds	r1, r4, #0
 7ae:	f7ff fce4 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
 7b2:	4807      	ldr	r0, [pc, #28]	; (7d0 <lnt_stop+0x7c>)
 7b4:	f7ff fc77 	bl	a6 <delay>
}
 7b8:	bd10      	pop	{r4, pc}
 7ba:	46c0      	nop			; (mov r8, r8)
 7bc:	00ffffff 	.word	0x00ffffff
 7c0:	a0000004 	.word	0xa0000004
 7c4:	00001ea6 	.word	0x00001ea6
 7c8:	00001e78 	.word	0x00001e78
 7cc:	00001dec 	.word	0x00001dec
 7d0:	00002710 	.word	0x00002710

Disassembly of section .text.light_left_shift_store:

000007d4 <light_left_shift_store>:
//     for(i = 0; i < 6; i++) {
// 	mbus_write_message32(0xD0 + i, light_code_storage[i]);
//     }
// }

static void light_left_shift_store(uint32_t data, uint8_t len) {
 7d4:	b5f0      	push	{r4, r5, r6, r7, lr}
    // data &= ((1 << len) - 1);
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);
 7d6:	424f      	negs	r7, r1
//     for(i = 0; i < 6; i++) {
// 	mbus_write_message32(0xD0 + i, light_code_storage[i]);
//     }
// }

static void light_left_shift_store(uint32_t data, uint8_t len) {
 7d8:	b085      	sub	sp, #20
    // data &= ((1 << len) - 1);
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);
 7da:	b27f      	sxtb	r7, r7
//     for(i = 0; i < 6; i++) {
// 	mbus_write_message32(0xD0 + i, light_code_storage[i]);
//     }
// }

static void light_left_shift_store(uint32_t data, uint8_t len) {
 7dc:	1c04      	adds	r4, r0, #0
 7de:	9100      	str	r1, [sp, #0]
    // data &= ((1 << len) - 1);
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);
 7e0:	1c3a      	adds	r2, r7, #0
 7e2:	2001      	movs	r0, #1
 7e4:	2100      	movs	r1, #0
 7e6:	f7ff ff9b 	bl	720 <right_shift>
    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
 7ea:	9900      	ldr	r1, [sp, #0]

static void light_left_shift_store(uint32_t data, uint8_t len) {
    // data &= ((1 << len) - 1);
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);
 7ec:	3801      	subs	r0, #1
    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
 7ee:	2320      	movs	r3, #32

static void light_left_shift_store(uint32_t data, uint8_t len) {
    // data &= ((1 << len) - 1);
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);
 7f0:	4004      	ands	r4, r0
    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
 7f2:	1a5b      	subs	r3, r3, r1

static void light_left_shift_store(uint32_t data, uint8_t len) {
    // data &= ((1 << len) - 1);
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);
 7f4:	9401      	str	r4, [sp, #4]
    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
 7f6:	b25b      	sxtb	r3, r3

    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
 7f8:	4c14      	ldr	r4, [pc, #80]	; (84c <light_left_shift_store+0x78>)

static void light_left_shift_store(uint32_t data, uint8_t len) {
    // data &= ((1 << len) - 1);
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);
 7fa:	2505      	movs	r5, #5
    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
 7fc:	9303      	str	r3, [sp, #12]

    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
 7fe:	00ae      	lsls	r6, r5, #2
 800:	5930      	ldr	r0, [r6, r4]
 802:	1c3a      	adds	r2, r7, #0
 804:	2100      	movs	r1, #0
 806:	f7ff ff8b 	bl	720 <right_shift>
 80a:	5130      	str	r0, [r6, r4]
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
 80c:	5932      	ldr	r2, [r6, r4]
//     for(i = 0; i < 6; i++) {
// 	mbus_write_message32(0xD0 + i, light_code_storage[i]);
//     }
// }

static void light_left_shift_store(uint32_t data, uint8_t len) {
 80e:	3d01      	subs	r5, #1
    int8_t i;
    for(i = 5; i >= 1; i--) {
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
 810:	00ab      	lsls	r3, r5, #2
 812:	5918      	ldr	r0, [r3, r4]
 814:	9202      	str	r2, [sp, #8]
 816:	2100      	movs	r1, #0
 818:	9a03      	ldr	r2, [sp, #12]
 81a:	f7ff ff81 	bl	720 <right_shift>
 81e:	9b02      	ldr	r3, [sp, #8]
 820:	4318      	orrs	r0, r3
 822:	5130      	str	r0, [r6, r4]
    // mbus_write_message32(0xA6, data);
    // mbus_write_message32(0xA7, len);
    data &= (right_shift(1, -len) - 1);

    int8_t i;
    for(i = 5; i >= 1; i--) {
 824:	2d00      	cmp	r5, #0
 826:	d1ea      	bne.n	7fe <light_left_shift_store+0x2a>
        // light_code_storage[i] = light_code_storage[i] << len;
        // light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - len));
        light_code_storage[i] = right_shift(light_code_storage[i], -len);
        light_code_storage[i] |= right_shift(light_code_storage[i - 1], (32 - len));
    }
    light_code_storage[0] = right_shift(light_code_storage[i], -len);
 828:	6820      	ldr	r0, [r4, #0]
 82a:	1c3a      	adds	r2, r7, #0
 82c:	1c29      	adds	r1, r5, #0
 82e:	f7ff ff77 	bl	720 <right_shift>
 832:	6020      	str	r0, [r4, #0]
    light_code_storage[0] |= data;
 834:	6823      	ldr	r3, [r4, #0]
 836:	9901      	ldr	r1, [sp, #4]
 838:	430b      	orrs	r3, r1
 83a:	6023      	str	r3, [r4, #0]

    light_storage_remainder -= len;
 83c:	4b04      	ldr	r3, [pc, #16]	; (850 <light_left_shift_store+0x7c>)
 83e:	9900      	ldr	r1, [sp, #0]
 840:	781a      	ldrb	r2, [r3, #0]
 842:	1a52      	subs	r2, r2, r1
 844:	701a      	strb	r2, [r3, #0]
    // print_light_compress();
}
 846:	b005      	add	sp, #20
 848:	bdf0      	pop	{r4, r5, r6, r7, pc}
 84a:	46c0      	nop			; (mov r8, r8)
 84c:	00001e24 	.word	0x00001e24
 850:	00001de9 	.word	0x00001de9

Disassembly of section .text.store_l2_header:

00000854 <store_l2_header>:
    light_left_shift_store(l1_cur_meas_time_mode, 2);
    lnt_l1_len = 0;
    lnt_l2_len = 0;
}

static void store_l2_header() {
 854:	b538      	push	{r3, r4, r5, lr}
    if(lnt_l2_len == 0) {
 856:	4c0b      	ldr	r4, [pc, #44]	; (884 <store_l2_header+0x30>)
 858:	7823      	ldrb	r3, [r4, #0]
 85a:	2b00      	cmp	r3, #0
 85c:	d011      	beq.n	882 <store_l2_header+0x2e>
        return;
    }
    light_left_shift_store(lnt_l2_len, 6 - cur_len_mode);
 85e:	4d0a      	ldr	r5, [pc, #40]	; (888 <store_l2_header+0x34>)
 860:	7820      	ldrb	r0, [r4, #0]
 862:	782b      	ldrb	r3, [r5, #0]
 864:	2106      	movs	r1, #6
 866:	1ac9      	subs	r1, r1, r3
 868:	b2c9      	uxtb	r1, r1
 86a:	f7ff ffb3 	bl	7d4 <light_left_shift_store>
    light_left_shift_store(cur_len_mode, 2);
 86e:	7828      	ldrb	r0, [r5, #0]
 870:	2102      	movs	r1, #2
 872:	f7ff ffaf 	bl	7d4 <light_left_shift_store>
    lnt_l1_len++;
 876:	4b05      	ldr	r3, [pc, #20]	; (88c <store_l2_header+0x38>)
 878:	781a      	ldrb	r2, [r3, #0]
 87a:	3201      	adds	r2, #1
 87c:	701a      	strb	r2, [r3, #0]
    lnt_l2_len = 0;
 87e:	2300      	movs	r3, #0
 880:	7023      	strb	r3, [r4, #0]
}
 882:	bd38      	pop	{r3, r4, r5, pc}
 884:	00001e87 	.word	0x00001e87
 888:	00001de7 	.word	0x00001de7
 88c:	00001ec8 	.word	0x00001ec8

Disassembly of section .text.store_l1_header.part.5:

00000890 <store_l1_header.part.5>:

    light_storage_remainder -= len;
    // print_light_compress();
}

static void store_l1_header() {
 890:	b510      	push	{r4, lr}
    if(lnt_l1_len == 0) {
        return;
    }
    light_left_shift_store(lnt_l1_len, 3);
 892:	4c07      	ldr	r4, [pc, #28]	; (8b0 <store_l1_header.part.5+0x20>)
 894:	2103      	movs	r1, #3
 896:	7820      	ldrb	r0, [r4, #0]
 898:	f7ff ff9c 	bl	7d4 <light_left_shift_store>
    light_left_shift_store(l1_cur_meas_time_mode, 2);
 89c:	4b05      	ldr	r3, [pc, #20]	; (8b4 <store_l1_header.part.5+0x24>)
 89e:	2102      	movs	r1, #2
 8a0:	7818      	ldrb	r0, [r3, #0]
 8a2:	f7ff ff97 	bl	7d4 <light_left_shift_store>
    lnt_l1_len = 0;
    lnt_l2_len = 0;
 8a6:	4a04      	ldr	r2, [pc, #16]	; (8b8 <store_l1_header.part.5+0x28>)
    if(lnt_l1_len == 0) {
        return;
    }
    light_left_shift_store(lnt_l1_len, 3);
    light_left_shift_store(l1_cur_meas_time_mode, 2);
    lnt_l1_len = 0;
 8a8:	2300      	movs	r3, #0
 8aa:	7023      	strb	r3, [r4, #0]
    lnt_l2_len = 0;
 8ac:	7013      	strb	r3, [r2, #0]
}
 8ae:	bd10      	pop	{r4, pc}
 8b0:	00001ec8 	.word	0x00001ec8
 8b4:	00001e86 	.word	0x00001e86
 8b8:	00001e87 	.word	0x00001e87

Disassembly of section .text.store_light.part.6:

000008bc <store_light.part.6>:
    lnt_l1_len++;
    lnt_l2_len = 0;
}


static void store_light() {
 8bc:	b570      	push	{r4, r5, r6, lr}
    if(light_storage_remainder < LIGHT_MAX_REMAINDER) {
        store_l2_header();
 8be:	f7ff ffc9 	bl	854 <store_l2_header>
    light_storage_remainder -= len;
    // print_light_compress();
}

static void store_l1_header() {
    if(lnt_l1_len == 0) {
 8c2:	4b26      	ldr	r3, [pc, #152]	; (95c <store_light.part.6+0xa0>)
 8c4:	781b      	ldrb	r3, [r3, #0]
 8c6:	2b00      	cmp	r3, #0
 8c8:	d001      	beq.n	8ce <store_light.part.6+0x12>
 8ca:	f7ff ffe1 	bl	890 <store_l1_header.part.5>
static void store_light() {
    if(light_storage_remainder < LIGHT_MAX_REMAINDER) {
        store_l2_header();
        store_l1_header();

        light_left_shift_store(last_log_light, 11); // final ref data
 8ce:	4b24      	ldr	r3, [pc, #144]	; (960 <store_light.part.6+0xa4>)
 8d0:	210b      	movs	r1, #11
 8d2:	8818      	ldrh	r0, [r3, #0]
 8d4:	f7ff ff7e 	bl	7d4 <light_left_shift_store>
	// TODO: check if need 12 bits
        light_left_shift_store(light_last_ref_time, 11); // final timestamp
 8d8:	4b22      	ldr	r3, [pc, #136]	; (964 <store_light.part.6+0xa8>)
 8da:	210b      	movs	r1, #11
 8dc:	8818      	ldrh	r0, [r3, #0]
 8de:	f7ff ff79 	bl	7d4 <light_left_shift_store>

        // shift upper half
        int8_t i;
        for(i = 5; i >= 3; i--) {
            light_code_storage[i] = light_code_storage[i] << 24;
 8e2:	4c21      	ldr	r4, [pc, #132]	; (968 <store_light.part.6+0xac>)
        store_l2_header();
        store_l1_header();

        light_left_shift_store(last_log_light, 11); // final ref data
	// TODO: check if need 12 bits
        light_left_shift_store(light_last_ref_time, 11); // final timestamp
 8e4:	2505      	movs	r5, #5

        // shift upper half
        int8_t i;
        for(i = 5; i >= 3; i--) {
            light_code_storage[i] = light_code_storage[i] << 24;
 8e6:	00ab      	lsls	r3, r5, #2
 8e8:	591a      	ldr	r2, [r3, r4]
    lnt_l1_len++;
    lnt_l2_len = 0;
}


static void store_light() {
 8ea:	3d01      	subs	r5, #1
        light_left_shift_store(light_last_ref_time, 11); // final timestamp

        // shift upper half
        int8_t i;
        for(i = 5; i >= 3; i--) {
            light_code_storage[i] = light_code_storage[i] << 24;
 8ec:	0612      	lsls	r2, r2, #24
 8ee:	511a      	str	r2, [r3, r4]
            light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - 24));
 8f0:	00aa      	lsls	r2, r5, #2
 8f2:	5919      	ldr	r1, [r3, r4]
 8f4:	5912      	ldr	r2, [r2, r4]
 8f6:	0a12      	lsrs	r2, r2, #8
 8f8:	430a      	orrs	r2, r1
 8fa:	511a      	str	r2, [r3, r4]
	// TODO: check if need 12 bits
        light_left_shift_store(light_last_ref_time, 11); // final timestamp

        // shift upper half
        int8_t i;
        for(i = 5; i >= 3; i--) {
 8fc:	2d02      	cmp	r5, #2
 8fe:	d1f2      	bne.n	8e6 <store_light.part.6+0x2a>
            light_code_storage[i] = light_code_storage[i] << 24;
            light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - 24));
        }
        light_code_storage[2] &= 0xFF;
 900:	68a3      	ldr	r3, [r4, #8]
	// print_light_compress();

        light_code_storage[5] |= ((1 << 15) | (light_packet_num << 12) | (CHIP_ID << 8));
 902:	2180      	movs	r1, #128	; 0x80
        int8_t i;
        for(i = 5; i >= 3; i--) {
            light_code_storage[i] = light_code_storage[i] << 24;
            light_code_storage[i] |= (light_code_storage[i - 1] >> (32 - 24));
        }
        light_code_storage[2] &= 0xFF;
 904:	b2db      	uxtb	r3, r3
 906:	60a3      	str	r3, [r4, #8]
	// print_light_compress();

        light_code_storage[5] |= ((1 << 15) | (light_packet_num << 12) | (CHIP_ID << 8));
 908:	4b18      	ldr	r3, [pc, #96]	; (96c <store_light.part.6+0xb0>)
 90a:	6962      	ldr	r2, [r4, #20]
 90c:	7818      	ldrb	r0, [r3, #0]
 90e:	0209      	lsls	r1, r1, #8
 910:	430a      	orrs	r2, r1
 912:	0300      	lsls	r0, r0, #12
 914:	4302      	orrs	r2, r0
 916:	6162      	str	r2, [r4, #20]
        light_packet_num = (light_packet_num + 1) & 7;
 918:	7818      	ldrb	r0, [r3, #0]
 91a:	2207      	movs	r2, #7
 91c:	3001      	adds	r0, #1
 91e:	4010      	ands	r0, r2
 920:	7018      	strb	r0, [r3, #0]
        light_code_storage[2] |= ((1 << 15) | (light_packet_num << 12) | (CHIP_ID << 8));
 922:	68a6      	ldr	r6, [r4, #8]
 924:	7818      	ldrb	r0, [r3, #0]
 926:	4331      	orrs	r1, r6
 928:	0300      	lsls	r0, r0, #12
 92a:	4301      	orrs	r1, r0
 92c:	60a1      	str	r1, [r4, #8]
        light_packet_num = (light_packet_num + 1) & 7;
 92e:	7819      	ldrb	r1, [r3, #0]

	// print_light_compress();

        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (MEM_LIGHT_ADDR + mem_light_len), light_code_storage + 3, 2);
 930:	4e0f      	ldr	r6, [pc, #60]	; (970 <store_light.part.6+0xb4>)
	// print_light_compress();

        light_code_storage[5] |= ((1 << 15) | (light_packet_num << 12) | (CHIP_ID << 8));
        light_packet_num = (light_packet_num + 1) & 7;
        light_code_storage[2] |= ((1 << 15) | (light_packet_num << 12) | (CHIP_ID << 8));
        light_packet_num = (light_packet_num + 1) & 7;
 932:	3101      	adds	r1, #1
 934:	400a      	ands	r2, r1
 936:	701a      	strb	r2, [r3, #0]

	// print_light_compress();

        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (MEM_LIGHT_ADDR + mem_light_len), light_code_storage + 3, 2);
 938:	1c22      	adds	r2, r4, #0
 93a:	8831      	ldrh	r1, [r6, #0]
 93c:	1c2b      	adds	r3, r5, #0
 93e:	320c      	adds	r2, #12
 940:	2006      	movs	r0, #6
 942:	f7ff fc27 	bl	194 <mbus_copy_mem_from_local_to_remote_bulk>
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (MEM_LIGHT_ADDR + 12 + mem_light_len), light_code_storage, 2);
 946:	8831      	ldrh	r1, [r6, #0]
 948:	1c2b      	adds	r3, r5, #0
 94a:	310c      	adds	r1, #12
 94c:	2006      	movs	r0, #6
 94e:	1c22      	adds	r2, r4, #0
 950:	f7ff fc20 	bl	194 <mbus_copy_mem_from_local_to_remote_bulk>
        mem_light_len += 24; // 6 * 4 B
 954:	8833      	ldrh	r3, [r6, #0]
 956:	3318      	adds	r3, #24
 958:	8033      	strh	r3, [r6, #0]
    }
}
 95a:	bd70      	pop	{r4, r5, r6, pc}
 95c:	00001ec8 	.word	0x00001ec8
 960:	00001e96 	.word	0x00001e96
 964:	00001eb8 	.word	0x00001eb8
 968:	00001e24 	.word	0x00001e24
 96c:	00001ea5 	.word	0x00001ea5
 970:	00001e92 	.word	0x00001e92

Disassembly of section .text.mult:

00000974 <mult>:
	}
    }
    return input;
}

uint64_t mult(uint32_t lhs, uint16_t rhs) {
 974:	b570      	push	{r4, r5, r6, lr}
    uint32_t res1 = 0, res2 = 0;
    res1 = (lhs >> 16) * rhs;
    res2 = (lhs & 0xFFFF) * rhs;
 976:	b285      	uxth	r5, r0
    return input;
}

uint64_t mult(uint32_t lhs, uint16_t rhs) {
    uint32_t res1 = 0, res2 = 0;
    res1 = (lhs >> 16) * rhs;
 978:	0c00      	lsrs	r0, r0, #16
    res2 = (lhs & 0xFFFF) * rhs;
    return right_shift(res1, -16) + res2;
 97a:	1c02      	adds	r2, r0, #0
}

uint64_t mult(uint32_t lhs, uint16_t rhs) {
    uint32_t res1 = 0, res2 = 0;
    res1 = (lhs >> 16) * rhs;
    res2 = (lhs & 0xFFFF) * rhs;
 97c:	434d      	muls	r5, r1
    return right_shift(res1, -16) + res2;
 97e:	434a      	muls	r2, r1
 980:	2300      	movs	r3, #0
 982:	2410      	movs	r4, #16
	    input = input >> 1;
	}
    }
    else {
    	for(i = 0; i > shift; i--) {
	    input = input << 1;
 984:	0fd0      	lsrs	r0, r2, #31
 986:	3c01      	subs	r4, #1
 988:	0059      	lsls	r1, r3, #1
 98a:	0056      	lsls	r6, r2, #1
 98c:	1c03      	adds	r3, r0, #0
 98e:	b2e4      	uxtb	r4, r4
 990:	1c32      	adds	r2, r6, #0
 992:	430b      	orrs	r3, r1
    	for(i = 0; i < shift; i++) {
	    input = input >> 1;
	}
    }
    else {
    	for(i = 0; i > shift; i--) {
 994:	2c00      	cmp	r4, #0
 996:	d1f5      	bne.n	984 <mult+0x10>

uint64_t mult(uint32_t lhs, uint16_t rhs) {
    uint32_t res1 = 0, res2 = 0;
    res1 = (lhs >> 16) * rhs;
    res2 = (lhs & 0xFFFF) * rhs;
    return right_shift(res1, -16) + res2;
 998:	1c28      	adds	r0, r5, #0
 99a:	1c21      	adds	r1, r4, #0
 99c:	1812      	adds	r2, r2, r0
 99e:	414b      	adcs	r3, r1
}
 9a0:	1c10      	adds	r0, r2, #0
 9a2:	1c19      	adds	r1, r3, #0
 9a4:	bd70      	pop	{r4, r5, r6, pc}

Disassembly of section .text.long_int_mult:

000009a6 <long_int_mult>:
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
    }
}

static void long_int_mult(const long_int lhs, const uint16_t rhs, long_int res) {
 9a6:	b5f0      	push	{r4, r5, r6, r7, lr}
 9a8:	2400      	movs	r4, #0
 9aa:	b089      	sub	sp, #36	; 0x24
 9ac:	1c06      	adds	r6, r0, #0
 9ae:	9103      	str	r1, [sp, #12]
 9b0:	1c15      	adds	r5, r2, #0
    uint32_t carry_in = 0;
 9b2:	1c27      	adds	r7, r4, #0
    uint32_t temp_res[LONG_INT_LEN];
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        uint64_t temp = mult(lhs[i], rhs) + carry_in;
 9b4:	5930      	ldr	r0, [r6, r4]
 9b6:	9903      	ldr	r1, [sp, #12]
 9b8:	f7ff ffdc 	bl	974 <mult>
 9bc:	2200      	movs	r2, #0
 9be:	9700      	str	r7, [sp, #0]
 9c0:	9201      	str	r2, [sp, #4]
 9c2:	9a00      	ldr	r2, [sp, #0]
 9c4:	9b01      	ldr	r3, [sp, #4]
 9c6:	1880      	adds	r0, r0, r2
 9c8:	4159      	adcs	r1, r3
        carry_in = temp >> 32;
        temp_res[i] = temp & 0xFFFFFFFF;
 9ca:	2310      	movs	r3, #16
 9cc:	191b      	adds	r3, r3, r4
 9ce:	466a      	mov	r2, sp
 9d0:	3404      	adds	r4, #4
    uint32_t carry_in = 0;
    uint32_t temp_res[LONG_INT_LEN];
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        uint64_t temp = mult(lhs[i], rhs) + carry_in;
        carry_in = temp >> 32;
 9d2:	1c0f      	adds	r7, r1, #0
        temp_res[i] = temp & 0xFFFFFFFF;
 9d4:	5098      	str	r0, [r3, r2]

static void long_int_mult(const long_int lhs, const uint16_t rhs, long_int res) {
    uint32_t carry_in = 0;
    uint32_t temp_res[LONG_INT_LEN];
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
 9d6:	2c10      	cmp	r4, #16
 9d8:	d1ec      	bne.n	9b4 <long_int_mult+0xe>
typedef uint32_t* long_int;

static void long_int_assign(long_int dest, const long_int src) {
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
 9da:	9b04      	ldr	r3, [sp, #16]
 9dc:	9a05      	ldr	r2, [sp, #20]
 9de:	602b      	str	r3, [r5, #0]
 9e0:	606a      	str	r2, [r5, #4]
 9e2:	9b06      	ldr	r3, [sp, #24]
 9e4:	9a07      	ldr	r2, [sp, #28]
 9e6:	60ab      	str	r3, [r5, #8]
 9e8:	60ea      	str	r2, [r5, #12]
        uint64_t temp = mult(lhs[i], rhs) + carry_in;
        carry_in = temp >> 32;
        temp_res[i] = temp & 0xFFFFFFFF;
    }
    long_int_assign(res, temp_res);
}
 9ea:	b009      	add	sp, #36	; 0x24
 9ec:	bdf0      	pop	{r4, r5, r6, r7, pc}

Disassembly of section .text.log2:

000009f0 <log2>:
        // }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 9f0:	b5f0      	push	{r4, r5, r6, r7, lr}
    // mbus_write_message32(0xE7, input & 0xFFFFFFFF);
    // mbus_write_message32(0xE8, input >> 32);

    if(input == 0) { return 0; }
 9f2:	1c02      	adds	r2, r0, #0
 9f4:	2300      	movs	r3, #0
        // }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 9f6:	1c05      	adds	r5, r0, #0
 9f8:	b08d      	sub	sp, #52	; 0x34
 9fa:	1c0e      	adds	r6, r1, #0
    // mbus_write_message32(0xE7, input & 0xFFFFFFFF);
    // mbus_write_message32(0xE8, input >> 32);

    if(input == 0) { return 0; }
 9fc:	430a      	orrs	r2, r1
 9fe:	1c18      	adds	r0, r3, #0
 a00:	429a      	cmp	r2, r3
 a02:	d060      	beq.n	ac6 <log2+0xd6>

    uint32_t temp_result[LONG_INT_LEN], input_storage[LONG_INT_LEN];
    int8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
    	temp_result[i] = input_storage[i] = 0;
 a04:	9300      	str	r3, [sp, #0]
 a06:	9301      	str	r3, [sp, #4]
 a08:	9306      	str	r3, [sp, #24]
 a0a:	9302      	str	r3, [sp, #8]
 a0c:	9307      	str	r3, [sp, #28]
 a0e:	9303      	str	r3, [sp, #12]
    }

    input_storage[0] = input & 0xFFFFFFFF;
 a10:	9504      	str	r5, [sp, #16]
    input_storage[1] = input >> 32;
 a12:	9105      	str	r1, [sp, #20]
    uint16_t out = 0;

    for(i = 47; i >= 0; i--) {
 a14:	242f      	movs	r4, #47	; 0x2f
        if(right_shift(input, i) & 0b1) {
 a16:	b267      	sxtb	r7, r4
 a18:	1c28      	adds	r0, r5, #0
 a1a:	1c31      	adds	r1, r6, #0
 a1c:	1c3a      	adds	r2, r7, #0
 a1e:	f7ff fe7f 	bl	720 <right_shift>
 a22:	2301      	movs	r3, #1
 a24:	4018      	ands	r0, r3
 a26:	d00b      	beq.n	a40 <log2+0x50>
            uint64_t temp = right_shift(1, -i);
 a28:	4264      	negs	r4, r4
 a2a:	b262      	sxtb	r2, r4
 a2c:	2001      	movs	r0, #1
 a2e:	2100      	movs	r1, #0
 a30:	f7ff fe76 	bl	720 <right_shift>
            temp_result[0] = temp & 0xFFFFFFFF;
            temp_result[1] = temp >> 32;
            out = i << LOG2_RES;
 a34:	017f      	lsls	r7, r7, #5
    uint16_t out = 0;

    for(i = 47; i >= 0; i--) {
        if(right_shift(input, i) & 0b1) {
            uint64_t temp = right_shift(1, -i);
            temp_result[0] = temp & 0xFFFFFFFF;
 a36:	9000      	str	r0, [sp, #0]
            temp_result[1] = temp >> 32;
 a38:	9101      	str	r1, [sp, #4]
            out = i << LOG2_RES;
 a3a:	b2bf      	uxth	r7, r7
    	temp_result[i] = input_storage[i] = 0;
    }

    input_storage[0] = input & 0xFFFFFFFF;
    input_storage[1] = input >> 32;
    uint16_t out = 0;
 a3c:	2400      	movs	r4, #0
 a3e:	e006      	b.n	a4e <log2+0x5e>

    for(i = 47; i >= 0; i--) {
 a40:	3c01      	subs	r4, #1
 a42:	b2e4      	uxtb	r4, r4
 a44:	b263      	sxtb	r3, r4
 a46:	3301      	adds	r3, #1
 a48:	d1e5      	bne.n	a16 <log2+0x26>
    	temp_result[i] = input_storage[i] = 0;
    }

    input_storage[0] = input & 0xFFFFFFFF;
    input_storage[1] = input >> 32;
    uint16_t out = 0;
 a4a:	1c07      	adds	r7, r0, #0
 a4c:	e7f6      	b.n	a3c <log2+0x4c>
            break;
        }
    }
    for(i = 0; i < LOG2_RES; i++) {
        uint32_t new_result[4];
        long_int_mult(temp_result, LOG_CONST_ARR[i], new_result);
 a4e:	4a1f      	ldr	r2, [pc, #124]	; (acc <log2+0xdc>)
        // }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 a50:	0063      	lsls	r3, r4, #1
            break;
        }
    }
    for(i = 0; i < LOG2_RES; i++) {
        uint32_t new_result[4];
        long_int_mult(temp_result, LOG_CONST_ARR[i], new_result);
 a52:	5a99      	ldrh	r1, [r3, r2]
 a54:	4668      	mov	r0, sp
 a56:	aa08      	add	r2, sp, #32
 a58:	f7ff ffa5 	bl	9a6 <long_int_mult>
        long_int_mult(input_storage, (1 << 15), input_storage);
 a5c:	a804      	add	r0, sp, #16
 a5e:	2180      	movs	r1, #128	; 0x80
 a60:	0209      	lsls	r1, r1, #8
 a62:	1c02      	adds	r2, r0, #0
 a64:	f7ff ff9f 	bl	9a6 <long_int_mult>
}

static bool long_int_lte(const long_int lhs, const long_int rhs) {
    int8_t i;
    for(i = 3; i >= 0; i--) {
	if(lhs[i] != rhs[i]) {
 a68:	990b      	ldr	r1, [sp, #44]	; 0x2c
 a6a:	9b07      	ldr	r3, [sp, #28]
 a6c:	4299      	cmp	r1, r3
 a6e:	d10c      	bne.n	a8a <log2+0x9a>
 a70:	9a0a      	ldr	r2, [sp, #40]	; 0x28
 a72:	9b06      	ldr	r3, [sp, #24]
 a74:	429a      	cmp	r2, r3
 a76:	d109      	bne.n	a8c <log2+0x9c>
 a78:	9a09      	ldr	r2, [sp, #36]	; 0x24
 a7a:	9b05      	ldr	r3, [sp, #20]
 a7c:	429a      	cmp	r2, r3
 a7e:	d105      	bne.n	a8c <log2+0x9c>
 a80:	9a08      	ldr	r2, [sp, #32]
 a82:	9b04      	ldr	r3, [sp, #16]
 a84:	429a      	cmp	r2, r3
 a86:	d013      	beq.n	ab0 <log2+0xc0>
 a88:	e000      	b.n	a8c <log2+0x9c>
 a8a:	1c0a      	adds	r2, r1, #0
    for(i = 0; i < LOG2_RES; i++) {
        uint32_t new_result[4];
        long_int_mult(temp_result, LOG_CONST_ARR[i], new_result);
        long_int_mult(input_storage, (1 << 15), input_storage);

        if(long_int_lte(new_result, input_storage)) {
 a8c:	429a      	cmp	r2, r3
 a8e:	d20f      	bcs.n	ab0 <log2+0xc0>
typedef uint32_t* long_int;

static void long_int_assign(long_int dest, const long_int src) {
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
 a90:	9b08      	ldr	r3, [sp, #32]
        // }
    }
    return false;
}

uint16_t log2(uint64_t input) {
 a92:	1f22      	subs	r2, r4, #4
typedef uint32_t* long_int;

static void long_int_assign(long_int dest, const long_int src) {
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
 a94:	9300      	str	r3, [sp, #0]
 a96:	9b09      	ldr	r3, [sp, #36]	; 0x24
 a98:	9103      	str	r1, [sp, #12]
 a9a:	9301      	str	r3, [sp, #4]
 a9c:	9b0a      	ldr	r3, [sp, #40]	; 0x28
        long_int_mult(input_storage, (1 << 15), input_storage);

        if(long_int_lte(new_result, input_storage)) {
            long_int_assign(temp_result, new_result);
            // out |= (1 << (LOG2_RES - 1 - i));
	    out |= right_shift(1, -(LOG2_RES - 1 - i));
 a9e:	b252      	sxtb	r2, r2
 aa0:	2001      	movs	r0, #1
 aa2:	2100      	movs	r1, #0
typedef uint32_t* long_int;

static void long_int_assign(long_int dest, const long_int src) {
    uint8_t i;
    for(i = 0; i < LONG_INT_LEN; i++) {
        dest[i] = src[i];
 aa4:	9302      	str	r3, [sp, #8]
        long_int_mult(input_storage, (1 << 15), input_storage);

        if(long_int_lte(new_result, input_storage)) {
            long_int_assign(temp_result, new_result);
            // out |= (1 << (LOG2_RES - 1 - i));
	    out |= right_shift(1, -(LOG2_RES - 1 - i));
 aa6:	f7ff fe3b 	bl	720 <right_shift>
 aaa:	4307      	orrs	r7, r0
 aac:	b2bf      	uxth	r7, r7
 aae:	e005      	b.n	abc <log2+0xcc>
        }
        else {
            long_int_mult(temp_result, (1 << 15), temp_result);
 ab0:	2180      	movs	r1, #128	; 0x80
 ab2:	4668      	mov	r0, sp
 ab4:	0209      	lsls	r1, r1, #8
 ab6:	466a      	mov	r2, sp
 ab8:	f7ff ff75 	bl	9a6 <long_int_mult>
 abc:	3401      	adds	r4, #1
            temp_result[1] = temp >> 32;
            out = i << LOG2_RES;
            break;
        }
    }
    for(i = 0; i < LOG2_RES; i++) {
 abe:	2c05      	cmp	r4, #5
 ac0:	d1c5      	bne.n	a4e <log2+0x5e>
        }

    }

    // mbus_write_message32(0xE9, out & 0x7FF);
    return out & 0x7FF;
 ac2:	057f      	lsls	r7, r7, #21
 ac4:	0d78      	lsrs	r0, r7, #21
}
 ac6:	b00d      	add	sp, #52	; 0x34
 ac8:	bdf0      	pop	{r4, r5, r6, r7, pc}
 aca:	46c0      	nop			; (mov r8, r8)
 acc:	00001db8 	.word	0x00001db8

Disassembly of section .text.compress_light:

00000ad0 <compress_light>:
        mbus_copy_mem_from_local_to_remote_bulk(MEM_ADDR, (uint32_t*) (MEM_LIGHT_ADDR + 12 + mem_light_len), light_code_storage, 2);
        mem_light_len += 24; // 6 * 4 B
    }
}

uint8_t compress_light() {
 ad0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    uint16_t log_light = log2(lnt_sys_light + 1) & 0x3FF;   // remember to subtract 1 when parsing
 ad2:	4b55      	ldr	r3, [pc, #340]	; (c28 <compress_light+0x158>)
 ad4:	6818      	ldr	r0, [r3, #0]
 ad6:	6859      	ldr	r1, [r3, #4]
 ad8:	2201      	movs	r2, #1
 ada:	2300      	movs	r3, #0
 adc:	1880      	adds	r0, r0, r2
 ade:	4159      	adcs	r1, r3
 ae0:	f7ff ff86 	bl	9f0 <log2>
    // mbus_write_message32(0xA5, log_light);
    if(light_storage_remainder == LIGHT_MAX_REMAINDER) {
 ae4:	4951      	ldr	r1, [pc, #324]	; (c2c <compress_light+0x15c>)
        mem_light_len += 24; // 6 * 4 B
    }
}

uint8_t compress_light() {
    uint16_t log_light = log2(lnt_sys_light + 1) & 0x3FF;   // remember to subtract 1 when parsing
 ae6:	0585      	lsls	r5, r0, #22
    // mbus_write_message32(0xA5, log_light);
    if(light_storage_remainder == LIGHT_MAX_REMAINDER) {
 ae8:	780b      	ldrb	r3, [r1, #0]
        mem_light_len += 24; // 6 * 4 B
    }
}

uint8_t compress_light() {
    uint16_t log_light = log2(lnt_sys_light + 1) & 0x3FF;   // remember to subtract 1 when parsing
 aea:	0dad      	lsrs	r5, r5, #22
    // mbus_write_message32(0xA5, log_light);
    if(light_storage_remainder == LIGHT_MAX_REMAINDER) {
 aec:	2b7b      	cmp	r3, #123	; 0x7b
 aee:	d118      	bne.n	b22 <compress_light+0x52>
        uint8_t i;
        for(i = 0; i < 6; i++) {
            light_code_storage[i] = 0;
 af0:	4a4f      	ldr	r2, [pc, #316]	; (c30 <compress_light+0x160>)
 af2:	2300      	movs	r3, #0
 af4:	6013      	str	r3, [r2, #0]
 af6:	6053      	str	r3, [r2, #4]
 af8:	6093      	str	r3, [r2, #8]
 afa:	60d3      	str	r3, [r2, #12]
 afc:	6113      	str	r3, [r2, #16]
 afe:	6153      	str	r3, [r2, #20]
        }
        lnt_l1_len = 0;
 b00:	4a4c      	ldr	r2, [pc, #304]	; (c34 <compress_light+0x164>)
 b02:	7013      	strb	r3, [r2, #0]
        lnt_l2_len = 0;
 b04:	4a4c      	ldr	r2, [pc, #304]	; (c38 <compress_light+0x168>)
 b06:	7013      	strb	r3, [r2, #0]
        l1_cur_meas_time_mode = lnt_meas_time_mode;
 b08:	4a4c      	ldr	r2, [pc, #304]	; (c3c <compress_light+0x16c>)
 b0a:	7810      	ldrb	r0, [r2, #0]
 b0c:	4a4c      	ldr	r2, [pc, #304]	; (c40 <compress_light+0x170>)
 b0e:	7010      	strb	r0, [r2, #0]
        cur_len_mode = 0xFF;
 b10:	4a4c      	ldr	r2, [pc, #304]	; (c44 <compress_light+0x174>)
 b12:	20ff      	movs	r0, #255	; 0xff
 b14:	7010      	strb	r0, [r2, #0]
	// subtract signal bit
	light_storage_remainder--;
 b16:	780a      	ldrb	r2, [r1, #0]
 b18:	3a01      	subs	r2, #1
 b1a:	700a      	strb	r2, [r1, #0]
	reduce_len_counter = 0;
 b1c:	4a4a      	ldr	r2, [pc, #296]	; (c48 <compress_light+0x178>)
 b1e:	7013      	strb	r3, [r2, #0]
 b20:	e07e      	b.n	c20 <compress_light+0x150>
    }
    else {
	static const uint8_t len[4] = {4, 6, 9, 11};
        int16_t diff = last_log_light - log_light;
 b22:	4b4a      	ldr	r3, [pc, #296]	; (c4c <compress_light+0x17c>)
        uint8_t len_mode = 0;
	// mbus_write_message32(0xA4, diff);
        if(diff <= 7 && diff >= -8) { // 4 bit storage
            len_mode = 0;
 b24:	2400      	movs	r4, #0
	light_storage_remainder--;
	reduce_len_counter = 0;
    }
    else {
	static const uint8_t len[4] = {4, 6, 9, 11};
        int16_t diff = last_log_light - log_light;
 b26:	881b      	ldrh	r3, [r3, #0]
 b28:	1b5b      	subs	r3, r3, r5
 b2a:	b29b      	uxth	r3, r3
        uint8_t len_mode = 0;
	// mbus_write_message32(0xA4, diff);
        if(diff <= 7 && diff >= -8) { // 4 bit storage
 b2c:	1c1a      	adds	r2, r3, #0
 b2e:	3208      	adds	r2, #8
 b30:	b292      	uxth	r2, r2
	light_storage_remainder--;
	reduce_len_counter = 0;
    }
    else {
	static const uint8_t len[4] = {4, 6, 9, 11};
        int16_t diff = last_log_light - log_light;
 b32:	1c1e      	adds	r6, r3, #0
        uint8_t len_mode = 0;
	// mbus_write_message32(0xA4, diff);
        if(diff <= 7 && diff >= -8) { // 4 bit storage
 b34:	2a0f      	cmp	r2, #15
 b36:	d90e      	bls.n	b56 <compress_light+0x86>
            len_mode = 0;
        }
        else if(diff <= 31 && diff >= -32) {  // 6 bit storage
 b38:	1c1a      	adds	r2, r3, #0
 b3a:	3220      	adds	r2, #32
 b3c:	b292      	uxth	r2, r2
            len_mode = 1;
 b3e:	2401      	movs	r4, #1
        uint8_t len_mode = 0;
	// mbus_write_message32(0xA4, diff);
        if(diff <= 7 && diff >= -8) { // 4 bit storage
            len_mode = 0;
        }
        else if(diff <= 31 && diff >= -32) {  // 6 bit storage
 b40:	2a3f      	cmp	r2, #63	; 0x3f
 b42:	d908      	bls.n	b56 <compress_light+0x86>
            len_mode = 1;
        }
        else if(diff <= 255 && diff >= -256) {    // 9 bit storage
 b44:	3301      	adds	r3, #1
 b46:	33ff      	adds	r3, #255	; 0xff
 b48:	4a41      	ldr	r2, [pc, #260]	; (c50 <compress_light+0x180>)
 b4a:	b29b      	uxth	r3, r3
            len_mode = 2;
 b4c:	2402      	movs	r4, #2
            len_mode = 0;
        }
        else if(diff <= 31 && diff >= -32) {  // 6 bit storage
            len_mode = 1;
        }
        else if(diff <= 255 && diff >= -256) {    // 9 bit storage
 b4e:	4293      	cmp	r3, r2
 b50:	d901      	bls.n	b56 <compress_light+0x86>
            len_mode = 2;
        }
        else {  // just store raw data
            diff = log_light;
 b52:	1c2e      	adds	r6, r5, #0
            len_mode = 3;
 b54:	2403      	movs	r4, #3
        }

	// Maybe not needed
        // diff = diff & (right_shift(1, -len) - 1);

        if(cur_len_mode != 0xFF) {
 b56:	4b3b      	ldr	r3, [pc, #236]	; (c44 <compress_light+0x174>)
 b58:	781a      	ldrb	r2, [r3, #0]
 b5a:	2aff      	cmp	r2, #255	; 0xff
 b5c:	d025      	beq.n	baa <compress_light+0xda>
            if(len_mode < cur_len_mode) {
 b5e:	781a      	ldrb	r2, [r3, #0]
 b60:	4b39      	ldr	r3, [pc, #228]	; (c48 <compress_light+0x178>)
 b62:	4294      	cmp	r4, r2
 b64:	d202      	bcs.n	b6c <compress_light+0x9c>
                reduce_len_counter++;
 b66:	781a      	ldrb	r2, [r3, #0]
 b68:	3201      	adds	r2, #1
 b6a:	e000      	b.n	b6e <compress_light+0x9e>
            }
	    else {
                reduce_len_counter = 0;
 b6c:	2200      	movs	r2, #0
 b6e:	701a      	strb	r2, [r3, #0]
	    }

            // check if need to commit L2 header
            if(len_mode > cur_len_mode 
 b70:	4b34      	ldr	r3, [pc, #208]	; (c44 <compress_light+0x174>)
 b72:	781a      	ldrb	r2, [r3, #0]
 b74:	4294      	cmp	r4, r2
 b76:	d815      	bhi.n	ba4 <compress_light+0xd4>
		|| reduce_len_counter >= 3 
 b78:	4a33      	ldr	r2, [pc, #204]	; (c48 <compress_light+0x178>)
 b7a:	7812      	ldrb	r2, [r2, #0]
 b7c:	2a02      	cmp	r2, #2
 b7e:	d811      	bhi.n	ba4 <compress_light+0xd4>
		// || lnt_l2_len >= ((1 << (6 - cur_len_mode)) - 1)) {
		|| lnt_l2_len >= (right_shift(1, -6 + cur_len_mode) - 1)) {
 b80:	4a2d      	ldr	r2, [pc, #180]	; (c38 <compress_light+0x168>)
 b82:	2001      	movs	r0, #1
 b84:	2100      	movs	r1, #0
 b86:	7817      	ldrb	r7, [r2, #0]
 b88:	781a      	ldrb	r2, [r3, #0]
 b8a:	3a06      	subs	r2, #6
 b8c:	b252      	sxtb	r2, r2
 b8e:	f7ff fdc7 	bl	720 <right_shift>
 b92:	2201      	movs	r2, #1
 b94:	4252      	negs	r2, r2
 b96:	17d3      	asrs	r3, r2, #31
 b98:	1812      	adds	r2, r2, r0
 b9a:	414b      	adcs	r3, r1
 b9c:	2b00      	cmp	r3, #0
 b9e:	d105      	bne.n	bac <compress_light+0xdc>
 ba0:	42ba      	cmp	r2, r7
 ba2:	d803      	bhi.n	bac <compress_light+0xdc>
                store_l2_header();
 ba4:	f7ff fe56 	bl	854 <store_l2_header>
		cur_len_mode = len_mode;
 ba8:	4b26      	ldr	r3, [pc, #152]	; (c44 <compress_light+0x174>)
            }
        }
	else {
            cur_len_mode = len_mode;
 baa:	701c      	strb	r4, [r3, #0]
	}

        // check if need to commit L1 header
        if(lnt_meas_time_mode != l1_cur_meas_time_mode || lnt_l1_len >= ((1 << 3) - 1)) {
 bac:	4b23      	ldr	r3, [pc, #140]	; (c3c <compress_light+0x16c>)
 bae:	4c21      	ldr	r4, [pc, #132]	; (c34 <compress_light+0x164>)
 bb0:	781a      	ldrb	r2, [r3, #0]
 bb2:	4b23      	ldr	r3, [pc, #140]	; (c40 <compress_light+0x170>)
 bb4:	781b      	ldrb	r3, [r3, #0]
 bb6:	429a      	cmp	r2, r3
 bb8:	d102      	bne.n	bc0 <compress_light+0xf0>
 bba:	7823      	ldrb	r3, [r4, #0]
 bbc:	2b06      	cmp	r3, #6
 bbe:	d906      	bls.n	bce <compress_light+0xfe>
	    store_l2_header();
 bc0:	f7ff fe48 	bl	854 <store_l2_header>
    light_storage_remainder -= len;
    // print_light_compress();
}

static void store_l1_header() {
    if(lnt_l1_len == 0) {
 bc4:	7823      	ldrb	r3, [r4, #0]
 bc6:	2b00      	cmp	r3, #0
 bc8:	d001      	beq.n	bce <compress_light+0xfe>
 bca:	f7ff fe61 	bl	890 <store_l1_header.part.5>
        // check if need to commit L1 header
        if(lnt_meas_time_mode != l1_cur_meas_time_mode || lnt_l1_len >= ((1 << 3) - 1)) {
	    store_l2_header();
            store_l1_header();
        }
        l1_cur_meas_time_mode = lnt_meas_time_mode;
 bce:	4b1b      	ldr	r3, [pc, #108]	; (c3c <compress_light+0x16c>)

        uint8_t needed_len = 2 + 3 + 2 + 6 - cur_len_mode + len[cur_len_mode];
 bd0:	210d      	movs	r1, #13
        // check if need to commit L1 header
        if(lnt_meas_time_mode != l1_cur_meas_time_mode || lnt_l1_len >= ((1 << 3) - 1)) {
	    store_l2_header();
            store_l1_header();
        }
        l1_cur_meas_time_mode = lnt_meas_time_mode;
 bd2:	781a      	ldrb	r2, [r3, #0]
 bd4:	4b1a      	ldr	r3, [pc, #104]	; (c40 <compress_light+0x170>)

        uint8_t needed_len = 2 + 3 + 2 + 6 - cur_len_mode + len[cur_len_mode];

        if(light_storage_remainder < needed_len) {
 bd6:	4c15      	ldr	r4, [pc, #84]	; (c2c <compress_light+0x15c>)
        // check if need to commit L1 header
        if(lnt_meas_time_mode != l1_cur_meas_time_mode || lnt_l1_len >= ((1 << 3) - 1)) {
	    store_l2_header();
            store_l1_header();
        }
        l1_cur_meas_time_mode = lnt_meas_time_mode;
 bd8:	701a      	strb	r2, [r3, #0]

        uint8_t needed_len = 2 + 3 + 2 + 6 - cur_len_mode + len[cur_len_mode];
 bda:	4b1a      	ldr	r3, [pc, #104]	; (c44 <compress_light+0x174>)
 bdc:	781f      	ldrb	r7, [r3, #0]
 bde:	781a      	ldrb	r2, [r3, #0]

        if(light_storage_remainder < needed_len) {
 be0:	7820      	ldrb	r0, [r4, #0]
	    store_l2_header();
            store_l1_header();
        }
        l1_cur_meas_time_mode = lnt_meas_time_mode;

        uint8_t needed_len = 2 + 3 + 2 + 6 - cur_len_mode + len[cur_len_mode];
 be2:	1a89      	subs	r1, r1, r2
 be4:	4a1b      	ldr	r2, [pc, #108]	; (c54 <compress_light+0x184>)
 be6:	5dd7      	ldrb	r7, [r2, r7]
 be8:	19c9      	adds	r1, r1, r7

        if(light_storage_remainder < needed_len) {
 bea:	b2c9      	uxtb	r1, r1
 bec:	4288      	cmp	r0, r1
 bee:	d208      	bcs.n	c02 <compress_light+0x132>
    lnt_l2_len = 0;
}


static void store_light() {
    if(light_storage_remainder < LIGHT_MAX_REMAINDER) {
 bf0:	7823      	ldrb	r3, [r4, #0]
 bf2:	2b7a      	cmp	r3, #122	; 0x7a
 bf4:	d801      	bhi.n	bfa <compress_light+0x12a>
 bf6:	f7ff fe61 	bl	8bc <store_light.part.6>

        uint8_t needed_len = 2 + 3 + 2 + 6 - cur_len_mode + len[cur_len_mode];

        if(light_storage_remainder < needed_len) {
            store_light();
            light_storage_remainder = LIGHT_MAX_REMAINDER;
 bfa:	237b      	movs	r3, #123	; 0x7b
 bfc:	7023      	strb	r3, [r4, #0]
            return 1;
 bfe:	2001      	movs	r0, #1
 c00:	e011      	b.n	c26 <compress_light+0x156>
        }

	light_last_ref_time = (xo_day_time_in_sec >> 6) & 0x7FF;
 c02:	4915      	ldr	r1, [pc, #84]	; (c58 <compress_light+0x188>)
 c04:	6808      	ldr	r0, [r1, #0]
 c06:	4915      	ldr	r1, [pc, #84]	; (c5c <compress_light+0x18c>)
        light_left_shift_store(diff, len[cur_len_mode]);
 c08:	781b      	ldrb	r3, [r3, #0]
            store_light();
            light_storage_remainder = LIGHT_MAX_REMAINDER;
            return 1;
        }

	light_last_ref_time = (xo_day_time_in_sec >> 6) & 0x7FF;
 c0a:	03c0      	lsls	r0, r0, #15
 c0c:	0d40      	lsrs	r0, r0, #21
 c0e:	8008      	strh	r0, [r1, #0]
        light_left_shift_store(diff, len[cur_len_mode]);
 c10:	5cd1      	ldrb	r1, [r2, r3]
 c12:	b230      	sxth	r0, r6
 c14:	f7ff fdde 	bl	7d4 <light_left_shift_store>
        lnt_l2_len++;
 c18:	4b07      	ldr	r3, [pc, #28]	; (c38 <compress_light+0x168>)
 c1a:	781a      	ldrb	r2, [r3, #0]
 c1c:	3201      	adds	r2, #1
 c1e:	701a      	strb	r2, [r3, #0]
    }
    last_log_light = log_light;
 c20:	4b0a      	ldr	r3, [pc, #40]	; (c4c <compress_light+0x17c>)
    return 0;
 c22:	2000      	movs	r0, #0

	light_last_ref_time = (xo_day_time_in_sec >> 6) & 0x7FF;
        light_left_shift_store(diff, len[cur_len_mode]);
        lnt_l2_len++;
    }
    last_log_light = log_light;
 c24:	801d      	strh	r5, [r3, #0]
    return 0;
}
 c26:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
 c28:	00001e78 	.word	0x00001e78
 c2c:	00001de9 	.word	0x00001de9
 c30:	00001e24 	.word	0x00001e24
 c34:	00001ec8 	.word	0x00001ec8
 c38:	00001e87 	.word	0x00001e87
 c3c:	00001e55 	.word	0x00001e55
 c40:	00001e86 	.word	0x00001e86
 c44:	00001de7 	.word	0x00001de7
 c48:	00001e94 	.word	0x00001e94
 c4c:	00001e96 	.word	0x00001e96
 c50:	000001ff 	.word	0x000001ff
 c54:	00001d77 	.word	0x00001d77
 c58:	00001e8c 	.word	0x00001e8c
 c5c:	00001eb8 	.word	0x00001eb8

Disassembly of section .text.crcEnc16:

00000c60 <crcEnc16>:

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 c60:	4b1d      	ldr	r3, [pc, #116]	; (cd8 <crcEnc16+0x78>)

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
{
 c62:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
 c64:	689a      	ldr	r2, [r3, #8]
 c66:	685f      	ldr	r7, [r3, #4]
 c68:	0412      	lsls	r2, r2, #16
 c6a:	0c3f      	lsrs	r7, r7, #16
 c6c:	18bf      	adds	r7, r7, r2
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 c6e:	685a      	ldr	r2, [r3, #4]
 c70:	6819      	ldr	r1, [r3, #0]
 c72:	0412      	lsls	r2, r2, #16
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 c74:	681c      	ldr	r4, [r3, #0]
    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 c76:	0c09      	lsrs	r1, r1, #16
 c78:	1889      	adds	r1, r1, r2
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 c7a:	2300      	movs	r3, #0
    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
    uint16_t remainder_shift = 0x0000;
    uint32_t data2 = (radio_data_arr[2] << CRC_LEN) + (radio_data_arr[1] >> CRC_LEN);
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
 c7c:	468c      	mov	ip, r1
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;
 c7e:	0424      	lsls	r4, r4, #16
    // intialization
    uint8_t i;

    uint16_t poly = 0xc002;
    uint16_t poly_not = ~poly;
    uint16_t remainder = 0x0000;
 c80:	1c1a      	adds	r2, r3, #0
    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 c82:	b295      	uxth	r5, r2
 c84:	b229      	sxth	r1, r5
            MSB = 0xffff;
        else
            MSB = 0x0000;
 c86:	2000      	movs	r0, #0
    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
    {
        uint16_t MSB;
        if (remainder > 0x7fff)
 c88:	4281      	cmp	r1, r0
 c8a:	da00      	bge.n	c8e <crcEnc16+0x2e>
            MSB = 0xffff;
 c8c:	4813      	ldr	r0, [pc, #76]	; (cdc <crcEnc16+0x7c>)
 c8e:	b2d9      	uxtb	r1, r3
        else
            MSB = 0x0000;

        if (i < 32)
 c90:	291f      	cmp	r1, #31
 c92:	d803      	bhi.n	c9c <crcEnc16+0x3c>
            input_bit = ((data2 << i) > 0x7fffffff);
 c94:	1c39      	adds	r1, r7, #0
 c96:	4099      	lsls	r1, r3
 c98:	0fc9      	lsrs	r1, r1, #31
 c9a:	e00a      	b.n	cb2 <crcEnc16+0x52>
        else if (i < 64)
 c9c:	293f      	cmp	r1, #63	; 0x3f
 c9e:	d803      	bhi.n	ca8 <crcEnc16+0x48>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 ca0:	1c19      	adds	r1, r3, #0
 ca2:	3920      	subs	r1, #32
            MSB = 0x0000;

        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
 ca4:	4666      	mov	r6, ip
 ca6:	e002      	b.n	cae <crcEnc16+0x4e>
 **********************************************/

#define DATA_LEN 96
#define CRC_LEN 16

uint32_t* crcEnc16()
 ca8:	1c19      	adds	r1, r3, #0
 caa:	3940      	subs	r1, #64	; 0x40
        if (i < 32)
            input_bit = ((data2 << i) > 0x7fffffff);
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;
 cac:	1c26      	adds	r6, r4, #0
 cae:	408e      	lsls	r6, r1
 cb0:	0ff1      	lsrs	r1, r6, #31

        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 cb2:	0bed      	lsrs	r5, r5, #15
 cb4:	4069      	eors	r1, r5
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 cb6:	0052      	lsls	r2, r2, #1
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 cb8:	4d09      	ldr	r5, [pc, #36]	; (ce0 <crcEnc16+0x80>)
        else if (i < 64)
            input_bit = (data1 << (i-32)) > 0x7fffffff;
        else
            input_bit = (data0 << (i-64)) > 0x7fffffff;

        remainder_shift = remainder << 1;
 cba:	b292      	uxth	r2, r2
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
 cbc:	4015      	ands	r5, r2
 cbe:	4042      	eors	r2, r0
 cc0:	4808      	ldr	r0, [pc, #32]	; (ce4 <crcEnc16+0x84>)
 cc2:	1949      	adds	r1, r1, r5
 cc4:	4002      	ands	r2, r0
 cc6:	3301      	adds	r3, #1
 cc8:	430a      	orrs	r2, r1
    uint32_t data1 = (radio_data_arr[1] << CRC_LEN) + (radio_data_arr[0] >> CRC_LEN);
    uint32_t data0 = radio_data_arr[0] << CRC_LEN;

    // LFSR
    uint16_t input_bit;
    for (i = 0; i < DATA_LEN; i++)
 cca:	2b60      	cmp	r3, #96	; 0x60
 ccc:	d1d9      	bne.n	c82 <crcEnc16+0x22>
        remainder_shift = remainder << 1;
        remainder = (poly&((remainder_shift)^MSB))|((poly_not)&(remainder_shift)) + (input_bit^(remainder > 0x7fff));
    }

    static uint32_t msg_out[1];
    msg_out[0] = data0 + remainder;
 cce:	4806      	ldr	r0, [pc, #24]	; (ce8 <crcEnc16+0x88>)
 cd0:	1912      	adds	r2, r2, r4
 cd2:	6002      	str	r2, [r0, #0]
    //radio_data_arr[0] = data2;
    //radio_data_arr[1] = data1;
    //radio_data_arr[2] = data0;

    return msg_out;    
}
 cd4:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
 cd6:	46c0      	nop			; (mov r8, r8)
 cd8:	00001e48 	.word	0x00001e48
 cdc:	0000ffff 	.word	0x0000ffff
 ce0:	00003ffd 	.word	0x00003ffd
 ce4:	ffffc002 	.word	0xffffc002
 ce8:	00001e80 	.word	0x00001e80

Disassembly of section .text.mrr_send_radio_data:

00000cec <mrr_send_radio_data>:

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
}

static void mrr_send_radio_data(uint8_t last_packet) {
     cec:	b5f0      	push	{r4, r5, r6, r7, lr}
     cee:	b085      	sub	sp, #20
     cf0:	9003      	str	r0, [sp, #12]
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
     cf2:	f7ff ffb5 	bl	c60 <crcEnc16>
    // mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
     cf6:	4bae      	ldr	r3, [pc, #696]	; (fb0 <mrr_send_radio_data+0x2c4>)
    mbus_write_message32(0xAA, 0x00000000);
    mbus_write_message32(0xAA, 0xAAAAAAAA);
#endif

    // CRC16 Encoding 
    uint32_t* crc_data = crcEnc16();
     cf8:	9001      	str	r0, [sp, #4]
    // mbus_write_message32(0xBB, 0xBBBBBBBB);
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
     cfa:	781f      	ldrb	r7, [r3, #0]
     cfc:	2f00      	cmp	r7, #0
     cfe:	d000      	beq.n	d02 <mrr_send_radio_data+0x16>
     d00:	e083      	b.n	e0a <mrr_send_radio_data+0x11e>

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
     d02:	4dac      	ldr	r5, [pc, #688]	; (fb4 <mrr_send_radio_data+0x2c8>)
#endif

    // TODO: add temp and voltage restrictions

    if(!radio_on) {
        radio_on = 1;
     d04:	2601      	movs	r6, #1
     d06:	701e      	strb	r6, [r3, #0]

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
     d08:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     d0a:	2002      	movs	r0, #2

    // Need to speed up sleep pmu clock
    //pmu_set_sleep_radio();

    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
     d0c:	43b3      	bics	r3, r6
     d0e:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     d10:	682a      	ldr	r2, [r5, #0]
     d12:	1c39      	adds	r1, r7, #0
     d14:	f7ff fa31 	bl	17a <mbus_remote_register_write>

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
     d18:	4ca7      	ldr	r4, [pc, #668]	; (fb8 <mrr_send_radio_data+0x2cc>)
     d1a:	4ba8      	ldr	r3, [pc, #672]	; (fbc <mrr_send_radio_data+0x2d0>)
     d1c:	6822      	ldr	r2, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d1e:	2002      	movs	r0, #2
    // Turn off Current Limter Briefly
    mrrv7_r00.MRR_CL_EN = 0;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Set decap to parallel
    mrrv7_r03.MRR_DCP_S_OW = 0;  //TX_Decap S (forced charge decaps)
     d20:	4013      	ands	r3, r2
     d22:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d24:	6822      	ldr	r2, [r4, #0]
     d26:	2103      	movs	r1, #3
     d28:	f7ff fa27 	bl	17a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
     d2c:	6822      	ldr	r2, [r4, #0]
     d2e:	2380      	movs	r3, #128	; 0x80
     d30:	031b      	lsls	r3, r3, #12
     d32:	4313      	orrs	r3, r2
     d34:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d36:	6822      	ldr	r2, [r4, #0]
     d38:	2103      	movs	r1, #3
     d3a:	2002      	movs	r0, #2
     d3c:	f7ff fa1d 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY);
     d40:	2064      	movs	r0, #100	; 0x64
     d42:	f7ff f9b0 	bl	a6 <delay>

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
     d46:	6822      	ldr	r2, [r4, #0]
     d48:	4b9d      	ldr	r3, [pc, #628]	; (fc0 <mrr_send_radio_data+0x2d4>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d4a:	2002      	movs	r0, #2
    mrrv7_r03.MRR_DCP_P_OW = 1;  //RX_Decap P 
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    delay(MBUS_DELAY);

    // Set decap to series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
     d4c:	4013      	ands	r3, r2
     d4e:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d50:	6822      	ldr	r2, [r4, #0]
     d52:	2103      	movs	r1, #3
     d54:	f7ff fa11 	bl	17a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
     d58:	6822      	ldr	r2, [r4, #0]
     d5a:	2380      	movs	r3, #128	; 0x80
     d5c:	02db      	lsls	r3, r3, #11
     d5e:	4313      	orrs	r3, r2
     d60:	6023      	str	r3, [r4, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
     d62:	6822      	ldr	r2, [r4, #0]
     d64:	2103      	movs	r1, #3
     d66:	2002      	movs	r0, #2
     d68:	f7ff fa07 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY);
     d6c:	2064      	movs	r0, #100	; 0x64
     d6e:	f7ff f99a 	bl	a6 <delay>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     d72:	682b      	ldr	r3, [r5, #0]
     d74:	227e      	movs	r2, #126	; 0x7e
     d76:	4393      	bics	r3, r2
     d78:	2420      	movs	r4, #32
     d7a:	4323      	orrs	r3, r4
     d7c:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     d7e:	682a      	ldr	r2, [r5, #0]
     d80:	2002      	movs	r0, #2
     d82:	1c39      	adds	r1, r7, #0
     d84:	f7ff f9f9 	bl	17a <mbus_remote_register_write>

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
     d88:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     d8a:	2002      	movs	r0, #2
    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 16; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
     d8c:	4333      	orrs	r3, r6
     d8e:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     d90:	682a      	ldr	r2, [r5, #0]
     d92:	1c39      	adds	r1, r7, #0
     d94:	f7ff f9f1 	bl	17a <mbus_remote_register_write>

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
     d98:	4d8a      	ldr	r5, [pc, #552]	; (fc4 <mrr_send_radio_data+0x2d8>)
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     d9a:	2104      	movs	r1, #4
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
     d9c:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     d9e:	2002      	movs	r0, #2
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Release timer power-gate
    mrrv7_r04.RO_EN_RO_V1P2 = 1;  //Use V1P2 for TIMER
     da0:	4333      	orrs	r3, r6
     da2:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     da4:	682a      	ldr	r2, [r5, #0]
     da6:	f7ff f9e8 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY);
     daa:	2064      	movs	r0, #100	; 0x64
     dac:	f7ff f97b 	bl	a6 <delay>

    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
     db0:	682b      	ldr	r3, [r5, #0]
     db2:	2208      	movs	r2, #8
     db4:	4393      	bics	r3, r2
     db6:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     db8:	682a      	ldr	r2, [r5, #0]
     dba:	2104      	movs	r1, #4
     dbc:	2002      	movs	r0, #2
     dbe:	f7ff f9dc 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY);
     dc2:	2064      	movs	r0, #100	; 0x64
     dc4:	f7ff f96f 	bl	a6 <delay>

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
     dc8:	682b      	ldr	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     dca:	2104      	movs	r1, #4
    // Turn on timer
    mrrv7_r04.RO_RESET = 0;  //Release Reset TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
    delay(MBUS_DELAY);

    mrrv7_r04.RO_EN_CLK = 1; //Enable CLK TIMER
     dcc:	431c      	orrs	r4, r3
     dce:	602c      	str	r4, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     dd0:	682a      	ldr	r2, [r5, #0]
     dd2:	2002      	movs	r0, #2
     dd4:	f7ff f9d1 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY);
     dd8:	2064      	movs	r0, #100	; 0x64
     dda:	f7ff f964 	bl	a6 <delay>

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
     dde:	682b      	ldr	r3, [r5, #0]
     de0:	2210      	movs	r2, #16
     de2:	4393      	bics	r3, r2
     de4:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);
     de6:	682a      	ldr	r2, [r5, #0]
     de8:	2002      	movs	r0, #2
     dea:	2104      	movs	r1, #4
     dec:	f7ff f9c5 	bl	17a <mbus_remote_register_write>

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
     df0:	4b75      	ldr	r3, [pc, #468]	; (fc8 <mrr_send_radio_data+0x2dc>)
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     df2:	2002      	movs	r0, #2

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
     df4:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     df6:	2111      	movs	r1, #17

    mrrv7_r04.RO_ISOLATE_CLK = 0; //Set Isolate CLK to 0 TIMER
    mbus_remote_register_write(MRR_ADDR,0x04,mrrv7_r04.as_int);

    // Release FSM Sleep
    mrrv7_r11.MRR_RAD_FSM_SLEEP = 0;  // Power on BB
     df8:	43b2      	bics	r2, r6
     dfa:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     dfc:	681a      	ldr	r2, [r3, #0]
     dfe:	f7ff f9bc 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*5); // Freq stab
     e02:	20fa      	movs	r0, #250	; 0xfa
     e04:	40b0      	lsls	r0, r6
     e06:	f7ff f94e 	bl	a6 <delay>
    if(!radio_on) {
        radio_on = 1;
	radio_power_on();
    }
    
    mbus_remote_register_write(MRR_ADDR,0xD, radio_data_arr[0]);
     e0a:	4c70      	ldr	r4, [pc, #448]	; (fcc <mrr_send_radio_data+0x2e0>)
     e0c:	2002      	movs	r0, #2
     e0e:	6822      	ldr	r2, [r4, #0]
     e10:	210d      	movs	r1, #13
     e12:	f7ff f9b2 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xE, (radio_data_arr[1] << 8) | (radio_data_arr[0] >> 24));
     e16:	6863      	ldr	r3, [r4, #4]
     e18:	6822      	ldr	r2, [r4, #0]
     e1a:	021b      	lsls	r3, r3, #8
     e1c:	0e12      	lsrs	r2, r2, #24
     e1e:	431a      	orrs	r2, r3
     e20:	2002      	movs	r0, #2
     e22:	210e      	movs	r1, #14
     e24:	f7ff f9a9 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0xF, (radio_data_arr[2] << 16) | (radio_data_arr[1] >> 16));
     e28:	68a3      	ldr	r3, [r4, #8]
     e2a:	6862      	ldr	r2, [r4, #4]
     e2c:	041b      	lsls	r3, r3, #16
     e2e:	0c12      	lsrs	r2, r2, #16
     e30:	431a      	orrs	r2, r3
     e32:	2002      	movs	r0, #2
     e34:	210f      	movs	r1, #15
     e36:	f7ff f9a0 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x10, (crc_data[0]) << 8 | (radio_data_arr[2] >> 8));
     e3a:	9901      	ldr	r1, [sp, #4]
     e3c:	68a3      	ldr	r3, [r4, #8]
     e3e:	680a      	ldr	r2, [r1, #0]
     e40:	0a1b      	lsrs	r3, r3, #8
     e42:	0212      	lsls	r2, r2, #8
     e44:	431a      	orrs	r2, r3
     e46:	2002      	movs	r0, #2
     e48:	2110      	movs	r1, #16
     e4a:	f7ff f996 	bl	17a <mbus_remote_register_write>
    // mbus_remote_register_write(MRR_ADDR,0xD, radio_data_arr[0] & 0xFFFFFF);
    // mbus_remote_register_write(MRR_ADDR,0xE, (radio_data_arr[1] << 8) | ((radio_data_arr[0] >> 24) & 0xFF));
    // mbus_remote_register_write(MRR_ADDR,0xF, (radio_data_arr[2] << 16) | ((radio_data_arr[1] >> 16) & 0xFFFF));
    // mbus_remote_register_write(MRR_ADDR,0x10, ((crc_data[0] & 0xFFFF) << 8 | (radio_data_arr[2] >> 8) & 0xFF));

    if (!radio_ready){
     e4e:	4b60      	ldr	r3, [pc, #384]	; (fd0 <mrr_send_radio_data+0x2e4>)
     e50:	781d      	ldrb	r5, [r3, #0]
     e52:	2d00      	cmp	r5, #0
     e54:	d127      	bne.n	ea6 <mrr_send_radio_data+0x1ba>
	radio_ready = 1;
     e56:	2201      	movs	r2, #1
     e58:	701a      	strb	r2, [r3, #0]

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
     e5a:	4b5b      	ldr	r3, [pc, #364]	; (fc8 <mrr_send_radio_data+0x2dc>)
     e5c:	2402      	movs	r4, #2
     e5e:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     e60:	2111      	movs	r1, #17

    if (!radio_ready){
	radio_ready = 1;

	// Release FSM Reset
	mrrv7_r11.MRR_RAD_FSM_RSTN = 1;  //UNRST BB
     e62:	4322      	orrs	r2, r4
     e64:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     e66:	681a      	ldr	r2, [r3, #0]
     e68:	1c20      	adds	r0, r4, #0
     e6a:	f7ff f986 	bl	17a <mbus_remote_register_write>
	delay(MBUS_DELAY);
     e6e:	2064      	movs	r0, #100	; 0x64
     e70:	f7ff f919 	bl	a6 <delay>

	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
     e74:	4b50      	ldr	r3, [pc, #320]	; (fb8 <mrr_send_radio_data+0x2cc>)
     e76:	2280      	movs	r2, #128	; 0x80
     e78:	6819      	ldr	r1, [r3, #0]
     e7a:	0352      	lsls	r2, r2, #13
     e7c:	430a      	orrs	r2, r1
     e7e:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
     e80:	681a      	ldr	r2, [r3, #0]
     e82:	2103      	movs	r1, #3
     e84:	1c20      	adds	r0, r4, #0
     e86:	f7ff f978 	bl	17a <mbus_remote_register_write>
	delay(MBUS_DELAY);
     e8a:	2064      	movs	r0, #100	; 0x64
     e8c:	f7ff f90b 	bl	a6 <delay>

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     e90:	4b48      	ldr	r3, [pc, #288]	; (fb4 <mrr_send_radio_data+0x2c8>)
     e92:	217e      	movs	r1, #126	; 0x7e
     e94:	681a      	ldr	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     e96:	1c20      	adds	r0, r4, #0
	mrrv7_r03.MRR_TRX_ISOLATEN = 1;     //set ISOLATEN 1, let state machine control
	mbus_remote_register_write(MRR_ADDR,0x03,mrrv7_r03.as_int);
	delay(MBUS_DELAY);

	// Current Limter set-up 
	mrrv7_r00.MRR_CL_CTRL = 1; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
     e98:	438a      	bics	r2, r1
     e9a:	4322      	orrs	r2, r4
     e9c:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     e9e:	681a      	ldr	r2, [r3, #0]
     ea0:	1c29      	adds	r1, r5, #0
     ea2:	f7ff f96a 	bl	17a <mbus_remote_register_write>

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
     ea6:	4b4b      	ldr	r3, [pc, #300]	; (fd4 <mrr_send_radio_data+0x2e8>)
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
     ea8:	2101      	movs	r1, #1
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
     eaa:	781a      	ldrb	r2, [r3, #0]
    }

#ifdef USE_RAD
    uint8_t count = 0;
    uint16_t mrr_cfo_val_fine = 0;
    uint8_t num_packets = 1;
     eac:	9102      	str	r1, [sp, #8]
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;
     eae:	2a00      	cmp	r2, #0
     eb0:	d001      	beq.n	eb6 <mrr_send_radio_data+0x1ca>
     eb2:	781b      	ldrb	r3, [r3, #0]
     eb4:	9302      	str	r3, [sp, #8]

    mrr_cfo_val_fine = 0x0000;
     eb6:	2700      	movs	r7, #0
	mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    }

#ifdef USE_RAD
    uint8_t count = 0;
     eb8:	9701      	str	r7, [sp, #4]
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
     eba:	e05c      	b.n	f76 <mrr_send_radio_data+0x28a>
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
     ebc:	4b46      	ldr	r3, [pc, #280]	; (fd8 <mrr_send_radio_data+0x2ec>)
     ebe:	2400      	movs	r4, #0
     ec0:	601c      	str	r4, [r3, #0]
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     ec2:	4b46      	ldr	r3, [pc, #280]	; (fdc <mrr_send_radio_data+0x2f0>)

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
     ec4:	223f      	movs	r2, #63	; 0x3f
    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
	// may be able to remove 2 lines below, GC 1/6/20
	*TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
	*REG_MBUS_WD = 0; // Disables Mbus watchdog timer
     ec6:	601c      	str	r4, [r3, #0]

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
     ec8:	4b45      	ldr	r3, [pc, #276]	; (fe0 <mrr_send_radio_data+0x2f4>)
     eca:	4946      	ldr	r1, [pc, #280]	; (fe4 <mrr_send_radio_data+0x2f8>)
     ecc:	681d      	ldr	r5, [r3, #0]
     ece:	403a      	ands	r2, r7
     ed0:	0410      	lsls	r0, r2, #16
     ed2:	4029      	ands	r1, r5
     ed4:	4301      	orrs	r1, r0
     ed6:	6019      	str	r1, [r3, #0]
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
     ed8:	6818      	ldr	r0, [r3, #0]
     eda:	0291      	lsls	r1, r2, #10
     edc:	4a42      	ldr	r2, [pc, #264]	; (fe8 <mrr_send_radio_data+0x2fc>)
     ede:	4002      	ands	r2, r0
     ee0:	430a      	orrs	r2, r1
     ee2:	601a      	str	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
     ee4:	681a      	ldr	r2, [r3, #0]
     ee6:	2002      	movs	r0, #2
     ee8:	2101      	movs	r1, #1
     eea:	f7ff f946 	bl	17a <mbus_remote_register_write>
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
     eee:	4a3f      	ldr	r2, [pc, #252]	; (fec <mrr_send_radio_data+0x300>)
    config_timer32(val, 1, 0, 0);
     ef0:	20a0      	movs	r0, #160	; 0xa0
 * Timeout Functions
 **********************************************/

static void set_timer32_timeout(uint32_t val){
    // Use Timer32 as timeout counter
    wfi_timeout_flag = 0;
     ef2:	7014      	strb	r4, [r2, #0]
    config_timer32(val, 1, 0, 0);
     ef4:	0300      	lsls	r0, r0, #12
     ef6:	2101      	movs	r1, #1
     ef8:	1c22      	adds	r2, r4, #0
     efa:	1c23      	adds	r3, r4, #0
     efc:	f7ff f8de 	bl	bc <config_timer32>

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
     f00:	4e2c      	ldr	r6, [pc, #176]	; (fb4 <mrr_send_radio_data+0x2c8>)
     f02:	2101      	movs	r1, #1
     f04:	6833      	ldr	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     f06:	2002      	movs	r0, #2

    // Use timer32 as timeout counter
    set_timer32_timeout(TIMER32_VAL);

    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
     f08:	430b      	orrs	r3, r1
     f0a:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     f0c:	6832      	ldr	r2, [r6, #0]
     f0e:	1c21      	adds	r1, r4, #0
     f10:	f7ff f933 	bl	17a <mbus_remote_register_write>

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
     f14:	4d2c      	ldr	r5, [pc, #176]	; (fc8 <mrr_send_radio_data+0x2dc>)
     f16:	2204      	movs	r2, #4
     f18:	882b      	ldrh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     f1a:	2111      	movs	r1, #17
    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);

    // Fire off data
    mrrv7_r11.MRR_RAD_FSM_EN = 1;  //Start BB
     f1c:	4313      	orrs	r3, r2
     f1e:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     f20:	682a      	ldr	r2, [r5, #0]
     f22:	2002      	movs	r0, #2
     f24:	f7ff f929 	bl	17a <mbus_remote_register_write>

    // Wait for radio response
    WFI();
     f28:	f7ff f8c5 	bl	b6 <WFI>
    config_timer32(val, 1, 0, 0);
}

static void stop_timer32_timeout_check(){
    // Turn off Timer32
    *TIMER32_GO = 0;
     f2c:	4b30      	ldr	r3, [pc, #192]	; (ff0 <mrr_send_radio_data+0x304>)
     f2e:	601c      	str	r4, [r3, #0]
    if (wfi_timeout_flag){
     f30:	4b2e      	ldr	r3, [pc, #184]	; (fec <mrr_send_radio_data+0x300>)
     f32:	7819      	ldrb	r1, [r3, #0]
     f34:	42a1      	cmp	r1, r4
     f36:	d002      	beq.n	f3e <mrr_send_radio_data+0x252>
        wfi_timeout_flag = 0;
     f38:	701c      	strb	r4, [r3, #0]
// }

static void sys_err(uint32_t code)
{
    // mbus_write_message32(0xAF, code);
    operation_sleep();
     f3a:	f7ff fa91 	bl	460 <operation_sleep>
    // Wait for radio response
    WFI();
    stop_timer32_timeout_check();

    // Turn off Current Limter
    mrrv7_r00.MRR_CL_EN = 0;
     f3e:	6833      	ldr	r3, [r6, #0]
     f40:	2201      	movs	r2, #1
     f42:	4393      	bics	r3, r2
     f44:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
     f46:	6832      	ldr	r2, [r6, #0]
     f48:	2002      	movs	r0, #2
     f4a:	f7ff f916 	bl	17a <mbus_remote_register_write>

    mrrv7_r11.MRR_RAD_FSM_EN = 0;
     f4e:	882b      	ldrh	r3, [r5, #0]
     f50:	2104      	movs	r1, #4
     f52:	438b      	bics	r3, r1
     f54:	802b      	strh	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     f56:	682a      	ldr	r2, [r5, #0]
     f58:	2002      	movs	r0, #2
     f5a:	2111      	movs	r1, #17
     f5c:	f7ff f90d 	bl	17a <mbus_remote_register_write>

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
     f60:	9b01      	ldr	r3, [sp, #4]
	delay(RADIO_PACKET_DELAY);
     f62:	4824      	ldr	r0, [pc, #144]	; (ff4 <mrr_send_radio_data+0x308>)

	mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine; 
	mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine;
	mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
	send_radio_data_mrr_sub1();
	count++;
     f64:	3301      	adds	r3, #1
     f66:	b2db      	uxtb	r3, r3
     f68:	9301      	str	r3, [sp, #4]
	delay(RADIO_PACKET_DELAY);
     f6a:	f7ff f89c 	bl	a6 <delay>
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
     f6e:	4b22      	ldr	r3, [pc, #136]	; (ff8 <mrr_send_radio_data+0x30c>)
     f70:	781b      	ldrb	r3, [r3, #0]
     f72:	18ff      	adds	r7, r7, r3
     f74:	b2bf      	uxth	r7, r7
    uint8_t num_packets = 1;
    if (mrr_freq_hopping) num_packets = mrr_freq_hopping;

    mrr_cfo_val_fine = 0x0000;

    while (count < num_packets){
     f76:	9a01      	ldr	r2, [sp, #4]
     f78:	9b02      	ldr	r3, [sp, #8]
     f7a:	429a      	cmp	r2, r3
     f7c:	d19e      	bne.n	ebc <mrr_send_radio_data+0x1d0>
	count++;
	delay(RADIO_PACKET_DELAY);
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
    }

    radio_packet_count++;
     f7e:	4b1f      	ldr	r3, [pc, #124]	; (ffc <mrr_send_radio_data+0x310>)
#endif
    if (last_packet){
     f80:	9903      	ldr	r1, [sp, #12]
	count++;
	delay(RADIO_PACKET_DELAY);
	mrr_cfo_val_fine = mrr_cfo_val_fine + mrr_freq_hopping_step; // 1: 0.8MHz, 2: 1.6MHz step
    }

    radio_packet_count++;
     f82:	681a      	ldr	r2, [r3, #0]
     f84:	3201      	adds	r2, #1
     f86:	601a      	str	r2, [r3, #0]
#endif
    if (last_packet){
     f88:	2900      	cmp	r1, #0
     f8a:	d005      	beq.n	f98 <mrr_send_radio_data+0x2ac>
	radio_ready = 0;
     f8c:	4b10      	ldr	r3, [pc, #64]	; (fd0 <mrr_send_radio_data+0x2e4>)
     f8e:	2200      	movs	r2, #0
     f90:	701a      	strb	r2, [r3, #0]
	radio_power_off();
     f92:	f7ff f957 	bl	244 <radio_power_off>
     f96:	e009      	b.n	fac <mrr_send_radio_data+0x2c0>
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
     f98:	4b0b      	ldr	r3, [pc, #44]	; (fc8 <mrr_send_radio_data+0x2dc>)
     f9a:	2104      	movs	r1, #4
     f9c:	881a      	ldrh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     f9e:	2002      	movs	r0, #2
#endif
    if (last_packet){
	radio_ready = 0;
	radio_power_off();
    }else{
	mrrv7_r11.MRR_RAD_FSM_EN = 0;
     fa0:	438a      	bics	r2, r1
     fa2:	801a      	strh	r2, [r3, #0]
	mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
     fa4:	681a      	ldr	r2, [r3, #0]
     fa6:	2111      	movs	r1, #17
     fa8:	f7ff f8e7 	bl	17a <mbus_remote_register_write>
    }
}
     fac:	b005      	add	sp, #20
     fae:	bdf0      	pop	{r4, r5, r6, r7, pc}
     fb0:	00001e72 	.word	0x00001e72
     fb4:	00001e20 	.word	0x00001e20
     fb8:	00001e1c 	.word	0x00001e1c
     fbc:	fffbffff 	.word	0xfffbffff
     fc0:	fff7ffff 	.word	0xfff7ffff
     fc4:	00001e18 	.word	0x00001e18
     fc8:	00001df4 	.word	0x00001df4
     fcc:	00001e48 	.word	0x00001e48
     fd0:	00001e3e 	.word	0x00001e3e
     fd4:	00001e3f 	.word	0x00001e3f
     fd8:	a0001200 	.word	0xa0001200
     fdc:	a000007c 	.word	0xa000007c
     fe0:	00001ecc 	.word	0x00001ecc
     fe4:	ffc0ffff 	.word	0xffc0ffff
     fe8:	ffff03ff 	.word	0xffff03ff
     fec:	00001e9c 	.word	0x00001e9c
     ff0:	a0001100 	.word	0xa0001100
     ff4:	000036b0 	.word	0x000036b0
     ff8:	00001e5c 	.word	0x00001e5c
     ffc:	00001e58 	.word	0x00001e58

Disassembly of section .text.set_goc_cmd:

00001000 <set_goc_cmd>:

/**********************************************
 * Interrupt handlers
 **********************************************/

void set_goc_cmd() {
    1000:	b508      	push	{r3, lr}
    // disable timer
    lnt_stop();
    1002:	f7ff fba7 	bl	754 <lnt_stop>

    // goc_component = (*GOC_DATA_IRQ >> 24) & 0xFF;
    // goc_func_id = (*GOC_DATA_IRQ >> 16) & 0xFF;
    // goc_data = *GOC_DATA_IRQ & 0xFFFF;
    goc_data_full = *GOC_DATA_IRQ;
    1006:	238c      	movs	r3, #140	; 0x8c
    1008:	681a      	ldr	r2, [r3, #0]
    100a:	4b08      	ldr	r3, [pc, #32]	; (102c <set_goc_cmd+0x2c>)
    100c:	601a      	str	r2, [r3, #0]
    goc_state = 0;
    100e:	4b08      	ldr	r3, [pc, #32]	; (1030 <set_goc_cmd+0x30>)
    1010:	2200      	movs	r2, #0
    1012:	701a      	strb	r2, [r3, #0]
    update_system_time();
    1014:	f7ff fb08 	bl	628 <update_system_time>
    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	xot_last_timer_list[i] = xo_sys_time_in_sec;
    1018:	4a06      	ldr	r2, [pc, #24]	; (1034 <set_goc_cmd+0x34>)
    101a:	4b07      	ldr	r3, [pc, #28]	; (1038 <set_goc_cmd+0x38>)
    101c:	6811      	ldr	r1, [r2, #0]
    101e:	6019      	str	r1, [r3, #0]
    1020:	6811      	ldr	r1, [r2, #0]
    1022:	6059      	str	r1, [r3, #4]
    1024:	6812      	ldr	r2, [r2, #0]
    1026:	609a      	str	r2, [r3, #8]
    }
}
    1028:	bd08      	pop	{r3, pc}
    102a:	46c0      	nop			; (mov r8, r8)
    102c:	00001e6c 	.word	0x00001e6c
    1030:	00001e56 	.word	0x00001e56
    1034:	00001e88 	.word	0x00001e88
    1038:	00001eac 	.word	0x00001eac

Disassembly of section .text.handler_ext_int_wakeup:

0000103c <handler_ext_int_wakeup>:
void handler_ext_int_reg1       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg2       (void) __attribute__ ((interrupt ("IRQ")));
void handler_ext_int_reg3       (void) __attribute__ ((interrupt ("IRQ")));

void handler_ext_int_wakeup( void ) { // WAKEUP
    *NVIC_ICPR = (0x1 << IRQ_WAKEUP);
    103c:	4b01      	ldr	r3, [pc, #4]	; (1044 <handler_ext_int_wakeup+0x8>)
    103e:	2201      	movs	r2, #1
    1040:	601a      	str	r2, [r3, #0]
}
    1042:	4770      	bx	lr
    1044:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_gocep:

00001048 <handler_ext_int_gocep>:

void handler_ext_int_gocep( void ) { // GOCEP
    *NVIC_ICPR = (0x1 << IRQ_GOCEP);
    1048:	4b01      	ldr	r3, [pc, #4]	; (1050 <handler_ext_int_gocep+0x8>)
    104a:	2204      	movs	r2, #4
    104c:	601a      	str	r2, [r3, #0]
}
    104e:	4770      	bx	lr
    1050:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_timer32:

00001054 <handler_ext_int_timer32>:

void handler_ext_int_timer32( void ) { // TIMER32
    *NVIC_ICPR = (0x1 << IRQ_TIMER32);
    1054:	4b04      	ldr	r3, [pc, #16]	; (1068 <handler_ext_int_timer32+0x14>)
    1056:	2208      	movs	r2, #8
    1058:	601a      	str	r2, [r3, #0]
    *TIMER32_STAT = 0x0;
    105a:	4b04      	ldr	r3, [pc, #16]	; (106c <handler_ext_int_timer32+0x18>)
    105c:	2200      	movs	r2, #0
    105e:	601a      	str	r2, [r3, #0]
    
    wfi_timeout_flag = 1;
    1060:	4b03      	ldr	r3, [pc, #12]	; (1070 <handler_ext_int_timer32+0x1c>)
    1062:	2201      	movs	r2, #1
    1064:	701a      	strb	r2, [r3, #0]
}
    1066:	4770      	bx	lr
    1068:	e000e280 	.word	0xe000e280
    106c:	a0001110 	.word	0xa0001110
    1070:	00001e9c 	.word	0x00001e9c

Disassembly of section .text.handler_ext_int_xot:

00001074 <handler_ext_int_xot>:

void handler_ext_int_xot( void ) { // TIMER32
    1074:	b508      	push	{r3, lr}
    *NVIC_ICPR = (0x1 << IRQ_XOT);
    1076:	2280      	movs	r2, #128	; 0x80
    1078:	4b02      	ldr	r3, [pc, #8]	; (1084 <handler_ext_int_xot+0x10>)
    107a:	0312      	lsls	r2, r2, #12
    107c:	601a      	str	r2, [r3, #0]
    update_system_time();
    107e:	f7ff fad3 	bl	628 <update_system_time>
}
    1082:	bd08      	pop	{r3, pc}
    1084:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg0:

00001088 <handler_ext_int_reg0>:

void handler_ext_int_reg0( void ) { // REG0
    *NVIC_ICPR = (0x1 << IRQ_REG0);
    1088:	4b02      	ldr	r3, [pc, #8]	; (1094 <handler_ext_int_reg0+0xc>)
    108a:	2280      	movs	r2, #128	; 0x80
    108c:	0052      	lsls	r2, r2, #1
    108e:	601a      	str	r2, [r3, #0]
}
    1090:	4770      	bx	lr
    1092:	46c0      	nop			; (mov r8, r8)
    1094:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg1:

00001098 <handler_ext_int_reg1>:

void handler_ext_int_reg1( void ) { // REG1
    *NVIC_ICPR = (0x1 << IRQ_REG1);
    1098:	4b02      	ldr	r3, [pc, #8]	; (10a4 <handler_ext_int_reg1+0xc>)
    109a:	2280      	movs	r2, #128	; 0x80
    109c:	0092      	lsls	r2, r2, #2
    109e:	601a      	str	r2, [r3, #0]
}
    10a0:	4770      	bx	lr
    10a2:	46c0      	nop			; (mov r8, r8)
    10a4:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg2:

000010a8 <handler_ext_int_reg2>:

void handler_ext_int_reg2( void ) { // REG2
    *NVIC_ICPR = (0x1 << IRQ_REG2);
    10a8:	4b02      	ldr	r3, [pc, #8]	; (10b4 <handler_ext_int_reg2+0xc>)
    10aa:	2280      	movs	r2, #128	; 0x80
    10ac:	00d2      	lsls	r2, r2, #3
    10ae:	601a      	str	r2, [r3, #0]
}
    10b0:	4770      	bx	lr
    10b2:	46c0      	nop			; (mov r8, r8)
    10b4:	e000e280 	.word	0xe000e280

Disassembly of section .text.handler_ext_int_reg3:

000010b8 <handler_ext_int_reg3>:

void handler_ext_int_reg3( void ) { // REG3
    *NVIC_ICPR = (0x1 << IRQ_REG3);
    10b8:	4b02      	ldr	r3, [pc, #8]	; (10c4 <handler_ext_int_reg3+0xc>)
    10ba:	2280      	movs	r2, #128	; 0x80
    10bc:	0112      	lsls	r2, r2, #4
    10be:	601a      	str	r2, [r3, #0]
}
    10c0:	4770      	bx	lr
    10c2:	46c0      	nop			; (mov r8, r8)
    10c4:	e000e280 	.word	0xe000e280

Disassembly of section .text.radio_full_data:

000010c8 <radio_full_data>:

/**********************************************
 * MAIN function starts here
 **********************************************/

void radio_full_data() {
    10c8:	b573      	push	{r0, r1, r4, r5, r6, lr}
    uint16_t i;
    // mbus_write_message32(0xB0, mem_light_len);
    for(i = 0; i < mem_light_len; i += 12) {
    10ca:	2500      	movs	r5, #0
    10cc:	4b1e      	ldr	r3, [pc, #120]	; (1148 <radio_full_data+0x80>)
    10ce:	2400      	movs	r4, #0
    10d0:	881b      	ldrh	r3, [r3, #0]
    10d2:	429d      	cmp	r5, r3
    10d4:	d215      	bcs.n	1102 <radio_full_data+0x3a>
 * MRR functions (MRRv7)
 **********************************************/

static void reset_radio_data_arr() {
    uint8_t i;
    for(i = 0; i < 3; i++) { radio_data_arr[i] = 0; }
    10d6:	4e1d      	ldr	r6, [pc, #116]	; (114c <radio_full_data+0x84>)
    10d8:	6034      	str	r4, [r6, #0]
    10da:	6074      	str	r4, [r6, #4]
    10dc:	60b4      	str	r4, [r6, #8]
void radio_full_data() {
    uint16_t i;
    // mbus_write_message32(0xB0, mem_light_len);
    for(i = 0; i < mem_light_len; i += 12) {
	reset_radio_data_arr();
	set_halt_until_mbus_trx();
    10de:	f7ff f80d 	bl	fc <set_halt_until_mbus_trx>
	mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (MEM_LIGHT_ADDR + i), PRE_ADDR, radio_data_arr, 2);
    10e2:	2302      	movs	r3, #2
    10e4:	1c29      	adds	r1, r5, #0
    10e6:	2006      	movs	r0, #6
    10e8:	2201      	movs	r2, #1
    10ea:	9300      	str	r3, [sp, #0]
    10ec:	1c33      	adds	r3, r6, #0
    10ee:	f7ff f86b 	bl	1c8 <mbus_copy_mem_from_remote_to_any_bulk>
 **********************************************/

void radio_full_data() {
    uint16_t i;
    // mbus_write_message32(0xB0, mem_light_len);
    for(i = 0; i < mem_light_len; i += 12) {
    10f2:	350c      	adds	r5, #12
	reset_radio_data_arr();
	set_halt_until_mbus_trx();
	mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (MEM_LIGHT_ADDR + i), PRE_ADDR, radio_data_arr, 2);
	set_halt_until_mbus_tx();
    10f4:	f7fe fffc 	bl	f0 <set_halt_until_mbus_tx>
	// radio_data_arr[2] &= 0x0000FFFF;

	mrr_send_radio_data(0);
    10f8:	1c20      	adds	r0, r4, #0
    10fa:	f7ff fdf7 	bl	cec <mrr_send_radio_data>
 **********************************************/

void radio_full_data() {
    uint16_t i;
    // mbus_write_message32(0xB0, mem_light_len);
    for(i = 0; i < mem_light_len; i += 12) {
    10fe:	b2ad      	uxth	r5, r5
    1100:	e7e4      	b.n	10cc <radio_full_data+0x4>

	mrr_send_radio_data(0);
    }

    // mbus_write_message32(0xB1, mem_temp_len);
    for(i = 0; i < mem_temp_len; i += 12) {
    1102:	4e13      	ldr	r6, [pc, #76]	; (1150 <radio_full_data+0x88>)
    1104:	8833      	ldrh	r3, [r6, #0]
    1106:	429c      	cmp	r4, r3
    1108:	d21c      	bcs.n	1144 <radio_full_data+0x7c>
 * MRR functions (MRRv7)
 **********************************************/

static void reset_radio_data_arr() {
    uint8_t i;
    for(i = 0; i < 3; i++) { radio_data_arr[i] = 0; }
    110a:	4d10      	ldr	r5, [pc, #64]	; (114c <radio_full_data+0x84>)
    110c:	2300      	movs	r3, #0
    110e:	602b      	str	r3, [r5, #0]
    1110:	606b      	str	r3, [r5, #4]
    1112:	60ab      	str	r3, [r5, #8]
    }

    // mbus_write_message32(0xB1, mem_temp_len);
    for(i = 0; i < mem_temp_len; i += 12) {
	reset_radio_data_arr();
	set_halt_until_mbus_trx();
    1114:	f7fe fff2 	bl	fc <set_halt_until_mbus_trx>
	mbus_copy_mem_from_remote_to_any_bulk(MEM_ADDR, (uint32_t*) (MEM_TEMP_ADDR + i), PRE_ADDR, radio_data_arr, 2);
    1118:	4b0e      	ldr	r3, [pc, #56]	; (1154 <radio_full_data+0x8c>)
    111a:	2006      	movs	r0, #6
    111c:	18e1      	adds	r1, r4, r3
    111e:	2302      	movs	r3, #2
    1120:	2201      	movs	r2, #1
    1122:	9300      	str	r3, [sp, #0]
    1124:	1c2b      	adds	r3, r5, #0
    1126:	f7ff f84f 	bl	1c8 <mbus_copy_mem_from_remote_to_any_bulk>
	set_halt_until_mbus_tx();
    112a:	f7fe ffe1 	bl	f0 <set_halt_until_mbus_tx>
	// radio_data_arr[2] &= 0x0000FFFF;

	mrr_send_radio_data((i + 12 >= mem_temp_len));
    112e:	8833      	ldrh	r3, [r6, #0]
    1130:	340c      	adds	r4, #12
    1132:	17e0      	asrs	r0, r4, #31
    1134:	0fda      	lsrs	r2, r3, #31
    1136:	429c      	cmp	r4, r3
    1138:	4150      	adcs	r0, r2
    113a:	b2c0      	uxtb	r0, r0
    113c:	f7ff fdd6 	bl	cec <mrr_send_radio_data>

	mrr_send_radio_data(0);
    }

    // mbus_write_message32(0xB1, mem_temp_len);
    for(i = 0; i < mem_temp_len; i += 12) {
    1140:	b2a4      	uxth	r4, r4
    1142:	e7de      	b.n	1102 <radio_full_data+0x3a>
	set_halt_until_mbus_tx();
	// radio_data_arr[2] &= 0x0000FFFF;

	mrr_send_radio_data((i + 12 >= mem_temp_len));
    }
}
    1144:	bd73      	pop	{r0, r1, r4, r5, r6, pc}
    1146:	46c0      	nop			; (mov r8, r8)
    1148:	00001e92 	.word	0x00001e92
    114c:	00001e48 	.word	0x00001e48
    1150:	00001e84 	.word	0x00001e84
    1154:	000036b0 	.word	0x000036b0

Disassembly of section .text.send_beacon:

00001158 <send_beacon>:
    }
    return 1;
#endif
}

void send_beacon() {
    1158:	b508      	push	{r3, lr}
    pmu_setting_temp_based(1);
    115a:	2001      	movs	r0, #1
    115c:	f7ff f944 	bl	3e8 <pmu_setting_temp_based>
    mrr_send_radio_data(1);
    1160:	2001      	movs	r0, #1
    1162:	f7ff fdc3 	bl	cec <mrr_send_radio_data>
    pmu_setting_temp_based(0);
    1166:	2000      	movs	r0, #0
    1168:	f7ff f93e 	bl	3e8 <pmu_setting_temp_based>
}
    116c:	bd08      	pop	{r3, pc}

Disassembly of section .text.startup.main:

00001170 <main>:

int main() {
    1170:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
    1172:	4bfa      	ldr	r3, [pc, #1000]	; (155c <main+0x3ec>)
    1174:	4afa      	ldr	r2, [pc, #1000]	; (1560 <main+0x3f0>)
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3);

    if(enumerated != ENUMID) {
    1176:	4cfb      	ldr	r4, [pc, #1004]	; (1564 <main+0x3f4>)
    pmu_setting_temp_based(0);
}

int main() {
    // Only enable relevant interrupts (PREv18)
    *NVIC_ISER = (1 << IRQ_WAKEUP | 1 << IRQ_GOCEP | 1 << IRQ_TIMER32 | 
    1178:	601a      	str	r2, [r3, #0]
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3);

    if(enumerated != ENUMID) {
    117a:	6823      	ldr	r3, [r4, #0]
    117c:	4dfa      	ldr	r5, [pc, #1000]	; (1568 <main+0x3f8>)
    117e:	42ab      	cmp	r3, r5
    1180:	d100      	bne.n	1184 <main+0x14>
    1182:	e2d8      	b.n	1736 <main+0x5c6>
static void operation_init( void ) {
    // BREAKPOINT 0x01
    // mbus_write_message32(0xBA, 0x01);

    // FIXME: turn WD back on?
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    1184:	4bf9      	ldr	r3, [pc, #996]	; (156c <main+0x3fc>)
    1186:	2700      	movs	r7, #0
    1188:	601f      	str	r7, [r3, #0]
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    118a:	4bf9      	ldr	r3, [pc, #996]	; (1570 <main+0x400>)
    config_timer32(0, 0, 0, 0);
    118c:	1c39      	adds	r1, r7, #0
    118e:	1c3a      	adds	r2, r7, #0
    // BREAKPOINT 0x01
    // mbus_write_message32(0xBA, 0x01);

    // FIXME: turn WD back on?
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    1190:	601f      	str	r7, [r3, #0]
    config_timer32(0, 0, 0, 0);
    1192:	1c38      	adds	r0, r7, #0
    1194:	1c3b      	adds	r3, r7, #0
    1196:	f7fe ff91 	bl	bc <config_timer32>

    // Enumeration
    enumerated = ENUMID;

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
    119a:	2006      	movs	r0, #6
    *TIMERWD_GO = 0x0; // Turn off CPU watchdog timer
    *REG_MBUS_WD = 0; // Disables Mbus watchdog timer
    config_timer32(0, 0, 0, 0);

    // Enumeration
    enumerated = ENUMID;
    119c:	6025      	str	r5, [r4, #0]

#ifdef USE_MEM
    mbus_enumerate(MEM_ADDR);
    119e:	f7fe ffcb 	bl	138 <mbus_enumerate>
    delay(MBUS_DELAY);
    11a2:	2064      	movs	r0, #100	; 0x64
    11a4:	f7fe ff7f 	bl	a6 <delay>
#endif
#ifdef USE_MRR
    mbus_enumerate(MRR_ADDR);
    11a8:	2002      	movs	r0, #2
    11aa:	f7fe ffc5 	bl	138 <mbus_enumerate>
    delay(MBUS_DELAY);
    11ae:	2064      	movs	r0, #100	; 0x64
    11b0:	f7fe ff79 	bl	a6 <delay>
#endif
#ifdef USE_LNT
    mbus_enumerate(LNT_ADDR);
    11b4:	2003      	movs	r0, #3
    11b6:	f7fe ffbf 	bl	138 <mbus_enumerate>
    delay(MBUS_DELAY);
    11ba:	2064      	movs	r0, #100	; 0x64
    11bc:	f7fe ff73 	bl	a6 <delay>
#endif
#ifdef USE_SNT
    mbus_enumerate(SNT_ADDR);
    11c0:	2004      	movs	r0, #4
    11c2:	f7fe ffb9 	bl	138 <mbus_enumerate>
    delay(MBUS_DELAY);
    11c6:	2064      	movs	r0, #100	; 0x64
    11c8:	f7fe ff6d 	bl	a6 <delay>
#endif
#ifdef USE_PMU
    mbus_enumerate(PMU_ADDR);
    11cc:	2005      	movs	r0, #5
    11ce:	f7fe ffb3 	bl	138 <mbus_enumerate>
    delay(MBUS_DELAY);
    11d2:	2064      	movs	r0, #100	; 0x64
    11d4:	f7fe ff67 	bl	a6 <delay>
#endif

    // Default CPU halt function
    set_halt_until_mbus_tx();
    11d8:	f7fe ff8a 	bl	f0 <set_halt_until_mbus_tx>
    // BREAKPOINT 0x02
    // mbus_write_message32(0xBA, 0x02);
    // mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    11dc:	4be5      	ldr	r3, [pc, #916]	; (1574 <main+0x404>)
    11de:	2140      	movs	r1, #64	; 0x40
    11e0:	881a      	ldrh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    11e2:	2580      	movs	r5, #128	; 0x80
    // BREAKPOINT 0x02
    // mbus_write_message32(0xBA, 0x02);
    // mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    11e4:	438a      	bics	r2, r1
    11e6:	801a      	strh	r2, [r3, #0]
    sntv4_r01.TSNS_CONT_MODE  = 0;
    11e8:	881a      	ldrh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
    11ea:	2004      	movs	r0, #4
    // mbus_write_message32(0xBA, 0x02);
    // mbus_write_message32(0xED, PMU_ACTIVE_SETTINGS[0]);

#ifdef USE_SNT
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    11ec:	43aa      	bics	r2, r5
    11ee:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);
    11f0:	681a      	ldr	r2, [r3, #0]
    11f2:	2101      	movs	r1, #1
    11f4:	f7fe ffc1 	bl	17a <mbus_remote_register_write>

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    11f8:	4bdf      	ldr	r3, [pc, #892]	; (1578 <main+0x408>)
    11fa:	26ff      	movs	r6, #255	; 0xff
    11fc:	881a      	ldrh	r2, [r3, #0]
    11fe:	2180      	movs	r1, #128	; 0x80
    1200:	4032      	ands	r2, r6
    1202:	0149      	lsls	r1, r1, #5
    1204:	430a      	orrs	r2, r1
    1206:	801a      	strh	r2, [r3, #0]
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    1208:	881a      	ldrh	r2, [r3, #0]
    }
}

static inline void snt_clk_init() { 
    
    sntv4_r08_t sntv4_r08 = SNTv4_R08_DEFAULT;
    120a:	2402      	movs	r4, #2
    sntv4_r01.TSNS_BURST_MODE = 0;
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    120c:	43b2      	bics	r2, r6
    120e:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
    1210:	681a      	ldr	r2, [r3, #0]
    1212:	2004      	movs	r0, #4
    1214:	2107      	movs	r1, #7
}

static inline void snt_clk_init() { 
    
    sntv4_r08_t sntv4_r08 = SNTv4_R08_DEFAULT;
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
    1216:	2601      	movs	r6, #1
    sntv4_r01.TSNS_CONT_MODE  = 0;
    mbus_remote_register_write(SNT_ADDR, 1, sntv4_r01.as_int);

    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);
    1218:	f7fe ffaf 	bl	17a <mbus_remote_register_write>
}

static inline void snt_clk_init() { 
    
    sntv4_r08_t sntv4_r08 = SNTv4_R08_DEFAULT;
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
    121c:	4326      	orrs	r6, r4
    121e:	22fc      	movs	r2, #252	; 0xfc
    1220:	2380      	movs	r3, #128	; 0x80
    1222:	4316      	orrs	r6, r2
    1224:	021b      	lsls	r3, r3, #8
    1226:	2580      	movs	r5, #128	; 0x80
    1228:	431e      	orrs	r6, r3
    122a:	032d      	lsls	r5, r5, #12
    sntv4_r17_t sntv4_r17 = SNTv4_R17_DEFAULT;
    122c:	2280      	movs	r2, #128	; 0x80
}

static inline void snt_clk_init() { 
    
    sntv4_r08_t sntv4_r08 = SNTv4_R08_DEFAULT;
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
    122e:	432e      	orrs	r6, r5
    sntv4_r17_t sntv4_r17 = SNTv4_R17_DEFAULT;
    1230:	0152      	lsls	r2, r2, #5
    1232:	2307      	movs	r3, #7
    1234:	2580      	movs	r5, #128	; 0x80
    1236:	4313      	orrs	r3, r2
    1238:	03ad      	lsls	r5, r5, #14
}

static inline void snt_clk_init() { 
    
    sntv4_r08_t sntv4_r08 = SNTv4_R08_DEFAULT;
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
    123a:	2180      	movs	r1, #128	; 0x80
    sntv4_r17_t sntv4_r17 = SNTv4_R17_DEFAULT;
    123c:	432b      	orrs	r3, r5
}

static inline void snt_clk_init() { 
    
    sntv4_r08_t sntv4_r08 = SNTv4_R08_DEFAULT;
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
    123e:	03c9      	lsls	r1, r1, #15
    1240:	430e      	orrs	r6, r1
    sntv4_r17_t sntv4_r17 = SNTv4_R17_DEFAULT;
    1242:	4319      	orrs	r1, r3
    // sntv4_r1A_t sntv4_r1A = SNTv4_R1A_DEFAULT;

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    1244:	1c3a      	adds	r2, r7, #0

static inline void snt_clk_init() { 
    
    sntv4_r08_t sntv4_r08 = SNTv4_R08_DEFAULT;
    sntv4_r09_t sntv4_r09 = SNTv4_R09_DEFAULT;
    sntv4_r17_t sntv4_r17 = SNTv4_R17_DEFAULT;
    1246:	9101      	str	r1, [sp, #4]
    // sntv4_r1A_t sntv4_r1A = SNTv4_R1A_DEFAULT;

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    1248:	2004      	movs	r0, #4
    124a:	2108      	movs	r1, #8
    124c:	f7fe ff95 	bl	17a <mbus_remote_register_write>

    delay(10000);
    1250:	48ca      	ldr	r0, [pc, #808]	; (157c <main+0x40c>)
    1252:	f7fe ff28 	bl	a6 <delay>

    sntv4_r09.TMR_SELF_EN = 0;
    1256:	49ca      	ldr	r1, [pc, #808]	; (1580 <main+0x410>)
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
    1258:	2004      	movs	r0, #4
    sntv4_r08.TMR_ISOLATE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);

    delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
    125a:	400e      	ands	r6, r1
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
    125c:	1c32      	adds	r2, r6, #0
    125e:	2109      	movs	r1, #9
    1260:	f7fe ff8b 	bl	17a <mbus_remote_register_write>
    // sntv4_r19_t sntv4_r19 = SNTv4_R19_DEFAULT;
    // sntv4_r1A_t sntv4_r1A = SNTv4_R1A_DEFAULT;

    // start SNT clock
    sntv4_r08.TMR_SLEEP = 0;
    sntv4_r08.TMR_ISOLATE = 0;
    1264:	1c3d      	adds	r5, r7, #0
    delay(10000);

    sntv4_r09.TMR_SELF_EN = 0;
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);

    sntv4_r08.TMR_EN_OSC = 1;
    1266:	2208      	movs	r2, #8
    1268:	4315      	orrs	r5, r2
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    126a:	1c11      	adds	r1, r2, #0
    126c:	2004      	movs	r0, #4
    126e:	1c2a      	adds	r2, r5, #0
    1270:	f7fe ff83 	bl	17a <mbus_remote_register_write>
    delay(10000);
    1274:	48c1      	ldr	r0, [pc, #772]	; (157c <main+0x40c>)
    1276:	f7fe ff16 	bl	a6 <delay>

    sntv4_r08.TMR_RESETB = 1;
    127a:	2310      	movs	r3, #16
    127c:	431d      	orrs	r5, r3
    sntv4_r08.TMR_RESETB_DIV = 1;
    127e:	2104      	movs	r1, #4
    1280:	430d      	orrs	r5, r1
    sntv4_r08.TMR_RESETB_DCDC = 1;
    1282:	4325      	orrs	r5, r4
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    1284:	1c2a      	adds	r2, r5, #0
    1286:	1c08      	adds	r0, r1, #0
    1288:	2108      	movs	r1, #8
    128a:	f7fe ff76 	bl	17a <mbus_remote_register_write>
    delay(10000);	// need to wait for clock to stabilize
    128e:	48bb      	ldr	r0, [pc, #748]	; (157c <main+0x40c>)
    1290:	f7fe ff09 	bl	a6 <delay>

    sntv4_r08.TMR_EN_SELF_CLK = 1;
    1294:	2201      	movs	r2, #1
    sntv4_r09.TMR_SELF_EN = 1;
    1296:	2380      	movs	r3, #128	; 0x80
    1298:	039b      	lsls	r3, r3, #14
    sntv4_r08.TMR_RESETB_DIV = 1;
    sntv4_r08.TMR_RESETB_DCDC = 1;
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    delay(10000);	// need to wait for clock to stabilize

    sntv4_r08.TMR_EN_SELF_CLK = 1;
    129a:	4315      	orrs	r5, r2
    sntv4_r09.TMR_SELF_EN = 1;
    129c:	431e      	orrs	r6, r3
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    129e:	1c2a      	adds	r2, r5, #0
    12a0:	2004      	movs	r0, #4
    12a2:	2108      	movs	r1, #8
    12a4:	f7fe ff69 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x9, sntv4_r09.as_int);
    12a8:	1c32      	adds	r2, r6, #0
    12aa:	2109      	movs	r1, #9
    12ac:	2004      	movs	r0, #4
    12ae:	f7fe ff64 	bl	17a <mbus_remote_register_write>
    delay(100000);
    12b2:	48b4      	ldr	r0, [pc, #720]	; (1584 <main+0x414>)
    12b4:	f7fe fef7 	bl	a6 <delay>

    sntv4_r08.TMR_EN_OSC = 0;
    12b8:	2608      	movs	r6, #8
    12ba:	1c2a      	adds	r2, r5, #0
    12bc:	43b2      	bics	r2, r6
    mbus_remote_register_write(SNT_ADDR, 0x8, sntv4_r08.as_int);
    12be:	1c31      	adds	r1, r6, #0
    12c0:	2004      	movs	r0, #4
    12c2:	f7fe ff5a 	bl	17a <mbus_remote_register_write>
    delay(10000);
    12c6:	48ad      	ldr	r0, [pc, #692]	; (157c <main+0x40c>)
    12c8:	f7fe feed 	bl	a6 <delay>

    // sntv4_r19.WUP_THRESHOLD_EXT = 0;
    // sntv4_r1A.WUP_THRESHOLD = 0;
    mbus_remote_register_write(SNT_ADDR, 0x19, 0);
    12cc:	2004      	movs	r0, #4
    12ce:	2119      	movs	r1, #25
    12d0:	1c3a      	adds	r2, r7, #0
    12d2:	f7fe ff52 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(SNT_ADDR, 0x1A, 0);
    12d6:	2004      	movs	r0, #4
    12d8:	211a      	movs	r1, #26
    12da:	1c3a      	adds	r2, r7, #0
    12dc:	f7fe ff4d 	bl	17a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
    12e0:	2004      	movs	r0, #4
    12e2:	2117      	movs	r1, #23
    12e4:	9a01      	ldr	r2, [sp, #4]
    12e6:	f7fe ff48 	bl	17a <mbus_remote_register_write>

    sntv4_r17.WUP_ENABLE = 1;
    12ea:	2680      	movs	r6, #128	; 0x80
    12ec:	9a01      	ldr	r2, [sp, #4]
    12ee:	0436      	lsls	r6, r6, #16
    sntv4_r17.WUP_CLK_SEL = 0;
    sntv4_r17.WUP_LC_IRQ_EN = 0;
    12f0:	4ba5      	ldr	r3, [pc, #660]	; (1588 <main+0x418>)
    mbus_remote_register_write(SNT_ADDR, 0x1A, 0);

    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    12f2:	4332      	orrs	r2, r6
    sntv4_r17.WUP_CLK_SEL = 0;
    sntv4_r17.WUP_LC_IRQ_EN = 0;
    sntv4_r17.WUP_AUTO_RESET = 0;
    12f4:	49a2      	ldr	r1, [pc, #648]	; (1580 <main+0x410>)
    sntv4_r17.WUP_ENABLE = 0;
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);

    sntv4_r17.WUP_ENABLE = 1;
    sntv4_r17.WUP_CLK_SEL = 0;
    sntv4_r17.WUP_LC_IRQ_EN = 0;
    12f6:	401a      	ands	r2, r3
    sntv4_r17.WUP_AUTO_RESET = 0;
    12f8:	400a      	ands	r2, r1
    mbus_remote_register_write(SNT_ADDR, 0x17, sntv4_r17.as_int);
    12fa:	2004      	movs	r0, #4
    12fc:	2117      	movs	r1, #23
    12fe:	f7fe ff3c 	bl	17a <mbus_remote_register_write>
    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    snt_clk_init();
    snt_state = SNT_IDLE;
    1302:	4ba2      	ldr	r3, [pc, #648]	; (158c <main+0x41c>)
static void lnt_init() {
    //////// TIMER OPERATION //////////
    // make variables local to save space
    lntv1a_r01_t lntv1a_r01 = LNTv1A_R01_DEFAULT;
    lntv1a_r02_t lntv1a_r02 = LNTv1A_R02_DEFAULT;
    lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
    1304:	250a      	movs	r5, #10
    sntv4_r07.TSNS_INT_RPLY_SHORT_ADDR = 0x10;
    sntv4_r07.TSNS_INT_RPLY_REG_ADDR   = 0x00;
    mbus_remote_register_write(SNT_ADDR, 7, sntv4_r07.as_int);

    snt_clk_init();
    snt_state = SNT_IDLE;
    1306:	701f      	strb	r7, [r3, #0]
    operation_temp_run();
    1308:	f7ff f8e4 	bl	4d4 <operation_temp_run>
static void lnt_init() {
    //////// TIMER OPERATION //////////
    // make variables local to save space
    lntv1a_r01_t lntv1a_r01 = LNTv1A_R01_DEFAULT;
    lntv1a_r02_t lntv1a_r02 = LNTv1A_R02_DEFAULT;
    lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
    130c:	4ba0      	ldr	r3, [pc, #640]	; (1590 <main+0x420>)
    lntv1a_r05_t lntv1a_r05 = LNTv1A_R05_DEFAULT;
    // lntv1a_r06_t lntv1a_r06 = LNTv1A_R06_DEFAULT;
    lntv1a_r17_t lntv1a_r17 = LNTv1A_R17_DEFAULT;
    lntv1a_r20_t lntv1a_r20 = LNTv1A_R20_DEFAULT;
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    130e:	2180      	movs	r1, #128	; 0x80
static void lnt_init() {
    //////// TIMER OPERATION //////////
    // make variables local to save space
    lntv1a_r01_t lntv1a_r01 = LNTv1A_R01_DEFAULT;
    lntv1a_r02_t lntv1a_r02 = LNTv1A_R02_DEFAULT;
    lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
    1310:	401d      	ands	r5, r3
    1312:	9501      	str	r5, [sp, #4]
    lntv1a_r05_t lntv1a_r05 = LNTv1A_R05_DEFAULT;
    // lntv1a_r06_t lntv1a_r06 = LNTv1A_R06_DEFAULT;
    lntv1a_r17_t lntv1a_r17 = LNTv1A_R17_DEFAULT;
    lntv1a_r20_t lntv1a_r20 = LNTv1A_R20_DEFAULT;
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    1314:	2501      	movs	r5, #1
    1316:	0309      	lsls	r1, r1, #12
    1318:	4325      	orrs	r5, r4
    131a:	2280      	movs	r2, #128	; 0x80
    131c:	430d      	orrs	r5, r1
    131e:	0392      	lsls	r2, r2, #14
    1320:	2380      	movs	r3, #128	; 0x80
    1322:	4315      	orrs	r5, r2
    1324:	03db      	lsls	r3, r3, #15
    lntv1a_r22_t lntv1a_r22 = LNTv1A_R22_DEFAULT;
    1326:	2104      	movs	r1, #4
    1328:	2208      	movs	r2, #8
    lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
    lntv1a_r05_t lntv1a_r05 = LNTv1A_R05_DEFAULT;
    // lntv1a_r06_t lntv1a_r06 = LNTv1A_R06_DEFAULT;
    lntv1a_r17_t lntv1a_r17 = LNTv1A_R17_DEFAULT;
    lntv1a_r20_t lntv1a_r20 = LNTv1A_R20_DEFAULT;
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    132a:	431d      	orrs	r5, r3
    lntv1a_r22_t lntv1a_r22 = LNTv1A_R22_DEFAULT;
    132c:	430a      	orrs	r2, r1
    132e:	2310      	movs	r3, #16
    1330:	431a      	orrs	r2, r3
    1332:	2120      	movs	r1, #32
    1334:	430a      	orrs	r2, r1
    lntv1a_r40_t lntv1a_r40 = LNTv1A_R40_DEFAULT;
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    1336:	2340      	movs	r3, #64	; 0x40
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    1338:	2180      	movs	r1, #128	; 0x80
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    lntv1a_r22_t lntv1a_r22 = LNTv1A_R22_DEFAULT;
    lntv1a_r40_t lntv1a_r40 = LNTv1A_R40_DEFAULT;
    
    // TIMER TUNING  
    lntv1a_r22.TMR_S = 0x1; // Default: 0x4
    133a:	431a      	orrs	r2, r3
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    133c:	0389      	lsls	r1, r1, #14
    133e:	4b95      	ldr	r3, [pc, #596]	; (1594 <main+0x424>)
    1340:	430a      	orrs	r2, r1
    1342:	431a      	orrs	r2, r3
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    1344:	2122      	movs	r1, #34	; 0x22
    1346:	2003      	movs	r0, #3
    1348:	f7fe ff17 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    134c:	20fa      	movs	r0, #250	; 0xfa
    134e:	40a0      	lsls	r0, r4
    1350:	f7fe fea9 	bl	a6 <delay>
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    1354:	2280      	movs	r2, #128	; 0x80
    lntv1a_r04_t lntv1a_r04 = LNTv1A_R04_DEFAULT;
    lntv1a_r05_t lntv1a_r05 = LNTv1A_R05_DEFAULT;
    // lntv1a_r06_t lntv1a_r06 = LNTv1A_R06_DEFAULT;
    lntv1a_r17_t lntv1a_r17 = LNTv1A_R17_DEFAULT;
    lntv1a_r20_t lntv1a_r20 = LNTv1A_R20_DEFAULT;
    lntv1a_r21_t lntv1a_r21 = LNTv1A_R21_DEFAULT;
    1356:	4335      	orrs	r5, r6
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    1358:	0212      	lsls	r2, r2, #8
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    135a:	23fc      	movs	r3, #252	; 0xfc
    lntv1a_r22.TMR_DIFF_CON = 0x3FFD; // Default: 0x3FFB
    lntv1a_r22.TMR_POLY_CON = 0x1; // Default: 0x1
    mbus_remote_register_write(LNT_ADDR,0x22,lntv1a_r22.as_int);
    delay(MBUS_DELAY*10);
    
    lntv1a_r21.TMR_SEL_CAP = 0x80; // Default : 8'h8
    135c:	4315      	orrs	r5, r2
    lntv1a_r21.TMR_SEL_DCAP = 0x3F; // Default : 6'h4
    135e:	431d      	orrs	r5, r3
    lntv1a_r21.TMR_EN_TUNE1 = 0x1; // Default : 1'h1
    lntv1a_r21.TMR_EN_TUNE2 = 0x1; // Default : 1'h1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    1360:	1c2a      	adds	r2, r5, #0
    1362:	2121      	movs	r1, #33	; 0x21
    1364:	2003      	movs	r0, #3
    1366:	f7fe ff08 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    136a:	20fa      	movs	r0, #250	; 0xfa
    136c:	40a0      	lsls	r0, r4
    136e:	f7fe fe9a 	bl	a6 <delay>
    
    // Enable Frequency Monitoring 
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    1372:	22c0      	movs	r2, #192	; 0xc0
    1374:	2140      	movs	r1, #64	; 0x40
    1376:	03d2      	lsls	r2, r2, #15
    1378:	2003      	movs	r0, #3
    137a:	f7fe fefe 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    137e:	20fa      	movs	r0, #250	; 0xfa
    1380:	40a0      	lsls	r0, r4
    1382:	f7fe fe90 	bl	a6 <delay>
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    1386:	497e      	ldr	r1, [pc, #504]	; (1580 <main+0x410>)
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    1388:	2003      	movs	r0, #3
    lntv1a_r40.WUP_ENABLE_CLK_SLP_OUT = 0x0; 
    mbus_remote_register_write(LNT_ADDR,0x40,lntv1a_r40.as_int);
    delay(MBUS_DELAY*10);
    
    // TIMER SELF_EN Disable 
    lntv1a_r21.TMR_SELF_EN = 0x0; // Default : 0x1
    138a:	400d      	ands	r5, r1
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    138c:	1c2a      	adds	r2, r5, #0
    138e:	2121      	movs	r1, #33	; 0x21
    1390:	f7fe fef3 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1394:	20fa      	movs	r0, #250	; 0xfa
    1396:	40a0      	lsls	r0, r4
    1398:	f7fe fe85 	bl	a6 <delay>
    
    // EN_OSC 
    lntv1a_r20.TMR_EN_OSC = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    139c:	2120      	movs	r1, #32
    139e:	2208      	movs	r2, #8
    13a0:	2003      	movs	r0, #3
    13a2:	f7fe feea 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    13a6:	20fa      	movs	r0, #250	; 0xfa
    13a8:	40a0      	lsls	r0, r4
    13aa:	f7fe fe7c 	bl	a6 <delay>
    
    // Release Reset 
    lntv1a_r20.TMR_RESETB = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DIV = 0x1; // Default : 0x0
    lntv1a_r20.TMR_RESETB_DCDC = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    13ae:	2120      	movs	r1, #32
    13b0:	221e      	movs	r2, #30
    13b2:	2003      	movs	r0, #3
    13b4:	f7fe fee1 	bl	17a <mbus_remote_register_write>
    delay(2000); 
    13b8:	20fa      	movs	r0, #250	; 0xfa
    13ba:	00c0      	lsls	r0, r0, #3
    13bc:	f7fe fe73 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_SELF_CLK = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    13c0:	2120      	movs	r1, #32
    13c2:	221f      	movs	r2, #31
    13c4:	2003      	movs	r0, #3
    13c6:	f7fe fed8 	bl	17a <mbus_remote_register_write>
    delay(10); 
    13ca:	200a      	movs	r0, #10
    13cc:	f7fe fe6b 	bl	a6 <delay>
    
    // TIMER SELF_EN 
    lntv1a_r21.TMR_SELF_EN = 0x1; // Default : 0x0
    13d0:	2280      	movs	r2, #128	; 0x80
    13d2:	0392      	lsls	r2, r2, #14
    13d4:	432a      	orrs	r2, r5
    mbus_remote_register_write(LNT_ADDR,0x21,lntv1a_r21.as_int);
    13d6:	2121      	movs	r1, #33	; 0x21
    13d8:	2003      	movs	r0, #3
    13da:	f7fe fece 	bl	17a <mbus_remote_register_write>
    delay(100000); 
    13de:	4869      	ldr	r0, [pc, #420]	; (1584 <main+0x414>)
    13e0:	f7fe fe61 	bl	a6 <delay>
    
    // TIMER EN_SEL_CLK Reset 
    lntv1a_r20.TMR_EN_OSC = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x20,lntv1a_r20.as_int);
    13e4:	2120      	movs	r1, #32
    13e6:	2217      	movs	r2, #23
    13e8:	2003      	movs	r0, #3
    13ea:	f7fe fec6 	bl	17a <mbus_remote_register_write>
    delay(100);
    13ee:	2064      	movs	r0, #100	; 0x64
    13f0:	f7fe fe59 	bl	a6 <delay>
    
    //////// CLOCK DIVIDER OPERATION //////////
    
    // Run FDIV
    lntv1a_r17.FDIV_RESETN = 0x1; // Default : 0x0
    lntv1a_r17.FDIV_CTRL_FREQ = 0x8; // Default : 0x0
    13f4:	231e      	movs	r3, #30
    13f6:	2201      	movs	r2, #1
    13f8:	439a      	bics	r2, r3
    13fa:	2510      	movs	r5, #16
    13fc:	432a      	orrs	r2, r5
    mbus_remote_register_write(LNT_ADDR,0x17,lntv1a_r17.as_int);
    13fe:	2117      	movs	r1, #23
    1400:	2003      	movs	r0, #3
    1402:	f7fe feba 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1406:	20fa      	movs	r0, #250	; 0xfa
    1408:	40a0      	lsls	r0, r4
    140a:	f7fe fe4c 	bl	a6 <delay>
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    140e:	4a62      	ldr	r2, [pc, #392]	; (1598 <main+0x428>)
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    1410:	2101      	movs	r1, #1
    
    //////// LNT SETTING //////////
    
    // Bias Current
    lntv1a_r01.CTRL_IBIAS_VBIAS = 0x7; // Default : 0x7
    lntv1a_r01.CTRL_IBIAS_I = 0x2; // Default : 0x8
    1412:	4322      	orrs	r2, r4
    lntv1a_r01.CTRL_VOFS_CANCEL = 0x1; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x01,lntv1a_r01.as_int);
    1414:	2003      	movs	r0, #3
    1416:	f7fe feb0 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    141a:	20fa      	movs	r0, #250	; 0xfa
    141c:	40a0      	lsls	r0, r4
    141e:	f7fe fe42 	bl	a6 <delay>
    	 
    // Vbase regulation voltage
    lntv1a_r02.CTRL_VREF_PV_V = 0x1; // Default : 0x2
    1422:	4a5e      	ldr	r2, [pc, #376]	; (159c <main+0x42c>)
    1424:	2180      	movs	r1, #128	; 0x80
    1426:	430a      	orrs	r2, r1
    mbus_remote_register_write(LNT_ADDR,0x02,lntv1a_r02.as_int);
    1428:	2003      	movs	r0, #3
    142a:	1c21      	adds	r1, r4, #0
    142c:	f7fe fea5 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1430:	20fa      	movs	r0, #250	; 0xfa
    1432:	40a0      	lsls	r0, r4
    1434:	f7fe fe37 	bl	a6 <delay>
    	
    // Set LNT Threshold
    lntv1a_r05.THRESHOLD_HIGH = 0x30; // Default : 12'd40
    lntv1a_r05.THRESHOLD_LOW = 0x10; // Default : 12'd20
    1438:	22c0      	movs	r2, #192	; 0xc0
    143a:	0292      	lsls	r2, r2, #10
    143c:	432a      	orrs	r2, r5
    mbus_remote_register_write(LNT_ADDR,0x05,lntv1a_r05.as_int);
    143e:	2003      	movs	r0, #3
    1440:	2105      	movs	r1, #5
    1442:	f7fe fe9a 	bl	17a <mbus_remote_register_write>
    
    // Monitor AFEOUT
    // lntv1a_r06.OBSEN_AFEOUT = 0x0; // Default : 0x0
    // mbus_remote_register_write(LNT_ADDR,0x06,lntv1a_r06.as_int);
    mbus_remote_register_write(LNT_ADDR,0x06,0);
    1446:	2106      	movs	r1, #6
    1448:	1c3a      	adds	r2, r7, #0
    144a:	2003      	movs	r0, #3
    144c:	f7fe fe95 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1450:	20fa      	movs	r0, #250	; 0xfa
    1452:	40a0      	lsls	r0, r4
    1454:	f7fe fe27 	bl	a6 <delay>
    
    // Change Counting Time 
    // lntv1a_r03.TIME_COUNTING = 0xFFFFFF; // Default : 0x258
    mbus_remote_register_write(LNT_ADDR,0x03,0xFFFFFF);
    1458:	2003      	movs	r0, #3
    145a:	1c01      	adds	r1, r0, #0
    145c:	4a50      	ldr	r2, [pc, #320]	; (15a0 <main+0x430>)
    145e:	f7fe fe8c 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1462:	20fa      	movs	r0, #250	; 0xfa
    1464:	40a0      	lsls	r0, r4
    1466:	f7fe fe1e 	bl	a6 <delay>
    
    // Change Monitoring & Hold Time 
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    146a:	2104      	movs	r1, #4
    146c:	9a01      	ldr	r2, [sp, #4]
    146e:	2003      	movs	r0, #3
    1470:	f7fe fe83 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1474:	20fa      	movs	r0, #250	; 0xfa
    1476:	40a0      	lsls	r0, r4
    1478:	f7fe fe15 	bl	a6 <delay>
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    147c:	4d49      	ldr	r5, [pc, #292]	; (15a4 <main+0x434>)
    147e:	2201      	movs	r2, #1
    1480:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1482:	1c39      	adds	r1, r7, #0
    lntv1a_r04.TIME_MONITORING = 0x00A; // Default : 0x010
    mbus_remote_register_write(LNT_ADDR,0x04,lntv1a_r04.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_PG 
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    1484:	4393      	bics	r3, r2
    1486:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1488:	682a      	ldr	r2, [r5, #0]
    148a:	2003      	movs	r0, #3
    148c:	f7fe fe75 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1490:	20fa      	movs	r0, #250	; 0xfa
    1492:	40a0      	lsls	r0, r4
    1494:	f7fe fe07 	bl	a6 <delay>
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    1498:	782b      	ldrb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    149a:	1c39      	adds	r1, r7, #0
    lntv1a_r00.LDC_PG = 0x0; // Default : 0x1
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);
    
    // Release LDC_ISOLATE
    lntv1a_r00.LDC_ISOLATE = 0x0; // Default : 0x1
    149c:	43a3      	bics	r3, r4
    149e:	702b      	strb	r3, [r5, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    14a0:	682a      	ldr	r2, [r5, #0]
    14a2:	2003      	movs	r0, #3
    14a4:	f7fe fe69 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    14a8:	20fa      	movs	r0, #250	; 0xfa
    14aa:	40a0      	lsls	r0, r4
    14ac:	f7fe fdfb 	bl	a6 <delay>
    mrrv7_r14_t mrrv7_r14 = MRRv7_R14_DEFAULT;
    mrrv7_r15_t mrrv7_r15 = MRRv7_R15_DEFAULT;
    mrrv7_r1F_t mrrv7_r1F = MRRv7_R1F_DEFAULT;

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    14b0:	4d3d      	ldr	r5, [pc, #244]	; (15a8 <main+0x438>)
    // MRR Settings --------------------------------------
    // using local variables to save space
    mrrv7_r02_t mrrv7_r02 = MRRv7_R02_DEFAULT;
    mrrv7_r07_t mrrv7_r07 = MRRv7_R07_DEFAULT;
    mrrv7_r14_t mrrv7_r14 = MRRv7_R14_DEFAULT;
    mrrv7_r15_t mrrv7_r15 = MRRv7_R15_DEFAULT;
    14b2:	9601      	str	r6, [sp, #4]
    mrrv7_r1F_t mrrv7_r1F = MRRv7_R1F_DEFAULT;

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    14b4:	682a      	ldr	r2, [r5, #0]
    14b6:	4b3d      	ldr	r3, [pc, #244]	; (15ac <main+0x43c>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    14b8:	1c20      	adds	r0, r4, #0
    mrrv7_r14_t mrrv7_r14 = MRRv7_R14_DEFAULT;
    mrrv7_r15_t mrrv7_r15 = MRRv7_R15_DEFAULT;
    mrrv7_r1F_t mrrv7_r1F = MRRv7_R1F_DEFAULT;

    // Decap in series
    mrrv7_r03.MRR_DCP_P_OW = 0;  //RX_Decap P 
    14ba:	4013      	ands	r3, r2
    14bc:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    14be:	682a      	ldr	r2, [r5, #0]
    14c0:	2103      	movs	r1, #3
    14c2:	f7fe fe5a 	bl	17a <mbus_remote_register_write>
    mrrv7_r03.MRR_DCP_S_OW = 1;  //TX_Decap S (forced charge decaps)
    14c6:	682a      	ldr	r2, [r5, #0]
    14c8:	2380      	movs	r3, #128	; 0x80
    14ca:	02db      	lsls	r3, r3, #11
    14cc:	4313      	orrs	r3, r2
    14ce:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    14d0:	682a      	ldr	r2, [r5, #0]
    14d2:	1c20      	adds	r0, r4, #0
    14d4:	2103      	movs	r1, #3
    14d6:	f7fe fe50 	bl	17a <mbus_remote_register_write>

    // Current Limter set-up 
    mrrv7_r00.MRR_CL_CTRL = 8; //Set CL 1: unlimited, 8: 30uA, 16: 3uA
    14da:	4e35      	ldr	r6, [pc, #212]	; (15b0 <main+0x440>)
    14dc:	227e      	movs	r2, #126	; 0x7e
    14de:	6833      	ldr	r3, [r6, #0]
    14e0:	2110      	movs	r1, #16
    14e2:	4393      	bics	r3, r2
    14e4:	430b      	orrs	r3, r1
    14e6:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    14e8:	6832      	ldr	r2, [r6, #0]
    14ea:	1c20      	adds	r0, r4, #0
    14ec:	1c39      	adds	r1, r7, #0
    14ee:	f7fe fe44 	bl	17a <mbus_remote_register_write>


    // Turn on Current Limter
    mrrv7_r00.MRR_CL_EN = 1;  //Enable CL
    14f2:	6833      	ldr	r3, [r6, #0]
    14f4:	2201      	movs	r2, #1
    14f6:	4313      	orrs	r3, r2
    14f8:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    14fa:	6832      	ldr	r2, [r6, #0]
    14fc:	1c39      	adds	r1, r7, #0
    14fe:	1c20      	adds	r0, r4, #0
    1500:	f7fe fe3b 	bl	17a <mbus_remote_register_write>

    // Wait for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000*3; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    1504:	482b      	ldr	r0, [pc, #172]	; (15b4 <main+0x444>)
    1506:	f7fe fdce 	bl	a6 <delay>

    mrrv7_r1F.LC_CLK_RING = 0x3;  // ~ 150 kHz
    mrrv7_r1F.LC_CLK_DIV = 0x3;  // ~ 150 kHz
    150a:	2303      	movs	r3, #3
    150c:	220c      	movs	r2, #12
    150e:	431a      	orrs	r2, r3
    mbus_remote_register_write(MRR_ADDR,0x1F,mrrv7_r1F.as_int);
    1510:	1c20      	adds	r0, r4, #0
    1512:	211f      	movs	r1, #31
    1514:	f7fe fe31 	bl	17a <mbus_remote_register_write>

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1518:	4b27      	ldr	r3, [pc, #156]	; (15b8 <main+0x448>)
    151a:	210c      	movs	r1, #12
    151c:	681a      	ldr	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    151e:	1c20      	adds	r0, r4, #0

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1520:	0a92      	lsrs	r2, r2, #10
    1522:	0292      	lsls	r2, r2, #10
    1524:	430a      	orrs	r2, r1
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    1526:	4925      	ldr	r1, [pc, #148]	; (15bc <main+0x44c>)

}

static void mrr_configure_pulse_width_long() {

    mrrv7_r12.MRR_RAD_FSM_TX_PW_LEN = 12; //50us PW
    1528:	601a      	str	r2, [r3, #0]
    mrrv7_r13.MRR_RAD_FSM_TX_C_LEN = 1105;
    152a:	680a      	ldr	r2, [r1, #0]
    152c:	4924      	ldr	r1, [pc, #144]	; (15c0 <main+0x450>)
    152e:	0bd2      	lsrs	r2, r2, #15
    1530:	03d2      	lsls	r2, r2, #15
    1532:	430a      	orrs	r2, r1
    1534:	4921      	ldr	r1, [pc, #132]	; (15bc <main+0x44c>)
    1536:	600a      	str	r2, [r1, #0]
    mrrv7_r12.MRR_RAD_FSM_TX_PS_LEN = 25; // PW=PS   
    1538:	6819      	ldr	r1, [r3, #0]
    153a:	4a22      	ldr	r2, [pc, #136]	; (15c4 <main+0x454>)
    153c:	400a      	ands	r2, r1
    153e:	21c8      	movs	r1, #200	; 0xc8
    1540:	01c9      	lsls	r1, r1, #7
    1542:	430a      	orrs	r2, r1
    1544:	601a      	str	r2, [r3, #0]

    mbus_remote_register_write(MRR_ADDR,0x12,mrrv7_r12.as_int);
    1546:	681a      	ldr	r2, [r3, #0]
    1548:	2112      	movs	r1, #18
    154a:	f7fe fe16 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    154e:	4b1b      	ldr	r3, [pc, #108]	; (15bc <main+0x44c>)
    1550:	1c20      	adds	r0, r4, #0
    1552:	681a      	ldr	r2, [r3, #0]
    1554:	2113      	movs	r1, #19
    1556:	f7fe fe10 	bl	17a <mbus_remote_register_write>
    155a:	e035      	b.n	15c8 <main+0x458>
    155c:	e000e100 	.word	0xe000e100
    1560:	00000f0d 	.word	0x00000f0d
    1564:	00001e40 	.word	0x00001e40
    1568:	deadbeef 	.word	0xdeadbeef
    156c:	a0001200 	.word	0xa0001200
    1570:	a000007c 	.word	0xa000007c
    1574:	00001e08 	.word	0x00001e08
    1578:	00001e0c 	.word	0x00001e0c
    157c:	00002710 	.word	0x00002710
    1580:	ffdfffff 	.word	0xffdfffff
    1584:	000186a0 	.word	0x000186a0
    1588:	ffbfffff 	.word	0xffbfffff
    158c:	00001e90 	.word	0x00001e90
    1590:	ff000fff 	.word	0xff000fff
    1594:	001ffe80 	.word	0x001ffe80
    1598:	00003770 	.word	0x00003770
    159c:	0003ce67 	.word	0x0003ce67
    15a0:	00ffffff 	.word	0x00ffffff
    15a4:	00001dec 	.word	0x00001dec
    15a8:	00001e1c 	.word	0x00001e1c
    15ac:	fff7ffff 	.word	0xfff7ffff
    15b0:	00001e20 	.word	0x00001e20
    15b4:	00004e20 	.word	0x00004e20
    15b8:	00001df8 	.word	0x00001df8
    15bc:	00001dfc 	.word	0x00001dfc
    15c0:	00000451 	.word	0x00000451
    15c4:	fff003ff 	.word	0xfff003ff
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    15c8:	4bd5      	ldr	r3, [pc, #852]	; (1920 <main+0x7b0>)
    mrr_freq_hopping_step = 4; // determining center freq

    mrr_cfo_val_fine_min = 0x0000;
    15ca:	4ad6      	ldr	r2, [pc, #856]	; (1924 <main+0x7b4>)
    //mrr_configure_pulse_width_short();
    mrr_configure_pulse_width_long();

    //mrr_freq_hopping = 5;
    //mrr_freq_hopping_step = 4;
    mrr_freq_hopping = 2;
    15cc:	701c      	strb	r4, [r3, #0]
    mrr_freq_hopping_step = 4; // determining center freq
    15ce:	4bd6      	ldr	r3, [pc, #856]	; (1928 <main+0x7b8>)
    15d0:	2104      	movs	r1, #4
    15d2:	7019      	strb	r1, [r3, #0]

    mrr_cfo_val_fine_min = 0x0000;
    15d4:	8017      	strh	r7, [r2, #0]

    // RO setup (SFO)
    // Adjust Diffusion R
    mbus_remote_register_write(MRR_ADDR,0x06,0x1000); // RO_PDIFF
    15d6:	2280      	movs	r2, #128	; 0x80
    15d8:	1c20      	adds	r0, r4, #0
    15da:	2106      	movs	r1, #6
    15dc:	0152      	lsls	r2, r2, #5
    15de:	f7fe fdcc 	bl	17a <mbus_remote_register_write>

    // Adjust Poly R
    mbus_remote_register_write(MRR_ADDR,0x08,0x400000); // RO_POLY
    15e2:	2280      	movs	r2, #128	; 0x80
    15e4:	1c20      	adds	r0, r4, #0
    15e6:	2108      	movs	r1, #8
    15e8:	03d2      	lsls	r2, r2, #15
    15ea:	f7fe fdc6 	bl	17a <mbus_remote_register_write>

    // Adjust C
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    15ee:	2280      	movs	r2, #128	; 0x80
    15f0:	2310      	movs	r3, #16
    15f2:	0112      	lsls	r2, r2, #4
    15f4:	431a      	orrs	r2, r3
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);
    15f6:	1c20      	adds	r0, r4, #0
    15f8:	2107      	movs	r1, #7
    15fa:	f7fe fdbe 	bl	17a <mbus_remote_register_write>

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack	// TODO: make them the same variable
    15fe:	6832      	ldr	r2, [r6, #0]
    1600:	4bca      	ldr	r3, [pc, #808]	; (192c <main+0x7bc>)
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    1602:	1c20      	adds	r0, r4, #0
    mrrv7_r07.RO_MOM = 0x10;
    mrrv7_r07.RO_MIM = 0x10;
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack	// TODO: make them the same variable
    1604:	4013      	ands	r3, r2
    1606:	22e0      	movs	r2, #224	; 0xe0
    1608:	40a2      	lsls	r2, r4
    160a:	4313      	orrs	r3, r2
    160c:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    160e:	6832      	ldr	r2, [r6, #0]
    1610:	1c39      	adds	r1, r7, #0
    1612:	f7fe fdb2 	bl	17a <mbus_remote_register_write>
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    1616:	4bc6      	ldr	r3, [pc, #792]	; (1930 <main+0x7c0>)
    1618:	2607      	movs	r6, #7
    161a:	681a      	ldr	r2, [r3, #0]
    161c:	0a92      	lsrs	r2, r2, #10
    161e:	0292      	lsls	r2, r2, #10
    1620:	4332      	orrs	r2, r6
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    1622:	4ec0      	ldr	r6, [pc, #768]	; (1924 <main+0x7b4>)
    mbus_remote_register_write(MRR_ADDR,0x07,mrrv7_r07.as_int);

    // TX Setup Carrier Freq
    mrrv7_r00.MRR_TRX_CAP_ANTP_TUNE_COARSE = 0x007;  //ANT CAP 10b unary 830.5 MHz // FIXME: adjust per stack	// TODO: make them the same variable
    mbus_remote_register_write(MRR_ADDR,0x00,mrrv7_r00.as_int);
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_COARSE = 0x007; //ANT CAP 10b unary 830.5 MHz
    1624:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTP_TUNE_FINE = mrr_cfo_val_fine_min;  //ANT CAP 14b unary 830.5 MHz
    1626:	8831      	ldrh	r1, [r6, #0]
    1628:	4ac2      	ldr	r2, [pc, #776]	; (1934 <main+0x7c4>)
    162a:	6818      	ldr	r0, [r3, #0]
    162c:	263f      	movs	r6, #63	; 0x3f
    162e:	4031      	ands	r1, r6
    1630:	0409      	lsls	r1, r1, #16
    1632:	4002      	ands	r2, r0
    1634:	430a      	orrs	r2, r1
    1636:	601a      	str	r2, [r3, #0]
    mrrv7_r01.MRR_TRX_CAP_ANTN_TUNE_FINE = mrr_cfo_val_fine_min; //ANT CAP 14b unary 830.5 MHz
    1638:	4aba      	ldr	r2, [pc, #744]	; (1924 <main+0x7b4>)
    163a:	8811      	ldrh	r1, [r2, #0]
    163c:	6818      	ldr	r0, [r3, #0]
    163e:	4abe      	ldr	r2, [pc, #760]	; (1938 <main+0x7c8>)
    1640:	4031      	ands	r1, r6
    1642:	0289      	lsls	r1, r1, #10
    1644:	4002      	ands	r2, r0
    1646:	430a      	orrs	r2, r1
    1648:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    164a:	681a      	ldr	r2, [r3, #0]
    164c:	1c20      	adds	r0, r4, #0
    164e:	2101      	movs	r1, #1
    1650:	f7fe fd93 	bl	17a <mbus_remote_register_write>
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);
    1654:	1c20      	adds	r0, r4, #0
    1656:	1c21      	adds	r1, r4, #0
    1658:	4ab8      	ldr	r2, [pc, #736]	; (193c <main+0x7cc>)
    165a:	f7fe fd8e 	bl	17a <mbus_remote_register_write>

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    165e:	682a      	ldr	r2, [r5, #0]
    1660:	4bb7      	ldr	r3, [pc, #732]	; (1940 <main+0x7d0>)
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1662:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,0x01,mrrv7_r01.as_int);
    mrrv7_r02.MRR_TX_BIAS_TUNE = 0x1FFF;  //Set TX BIAS TUNE 13b // Max 0x1FFF
    mbus_remote_register_write(MRR_ADDR,0x02,mrrv7_r02.as_int);

    // Turn off RX mode
    mrrv7_r03.MRR_TRX_MODE_EN = 0; //Set TRX mode
    1664:	4013      	ands	r3, r2
    1666:	602b      	str	r3, [r5, #0]
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);
    1668:	682a      	ldr	r2, [r5, #0]
    166a:	2103      	movs	r1, #3
    166c:	f7fe fd85 	bl	17a <mbus_remote_register_write>

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    1670:	9d01      	ldr	r5, [sp, #4]
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    1672:	1c20      	adds	r0, r4, #0
    mbus_remote_register_write(MRR_ADDR,3,mrrv7_r03.as_int);

    mrrv7_r14.MRR_RAD_FSM_TX_POWERON_LEN = 0; //3bits
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_BITS = 0x00;  //Set RX header
    mrrv7_r15.MRR_RAD_FSM_RX_HDR_TH = 0x00;    //Set RX header threshold
    mrrv7_r15.MRR_RAD_FSM_RX_DATA_BITS = 0x00; //Set RX data 1b
    1674:	43b5      	bics	r5, r6
    mbus_remote_register_write(MRR_ADDR,0x14,mrrv7_r14.as_int);
    1676:	2114      	movs	r1, #20
    1678:	1c3a      	adds	r2, r7, #0
    167a:	f7fe fd7e 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x15,mrrv7_r15.as_int);
    167e:	1c2a      	adds	r2, r5, #0
    1680:	1c20      	adds	r0, r4, #0
    1682:	2115      	movs	r1, #21
    1684:	f7fe fd79 	bl	17a <mbus_remote_register_write>

    // RAD_FSM set-up 
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    1688:	1c20      	adds	r0, r4, #0
    168a:	2109      	movs	r1, #9
    168c:	1c3a      	adds	r2, r7, #0
    168e:	f7fe fd74 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    1692:	1c20      	adds	r0, r4, #0
    1694:	210a      	movs	r1, #10
    1696:	1c3a      	adds	r2, r7, #0
    1698:	f7fe fd6f 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    169c:	1c20      	adds	r0, r4, #0
    169e:	210b      	movs	r1, #11
    16a0:	1c3a      	adds	r2, r7, #0
    16a2:	f7fe fd6a 	bl	17a <mbus_remote_register_write>
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    16a6:	1c20      	adds	r0, r4, #0
    16a8:	210c      	movs	r1, #12
    16aa:	4aa6      	ldr	r2, [pc, #664]	; (1944 <main+0x7d4>)
    16ac:	f7fe fd65 	bl	17a <mbus_remote_register_write>
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    16b0:	4ba5      	ldr	r3, [pc, #660]	; (1948 <main+0x7d8>)
    16b2:	21f8      	movs	r1, #248	; 0xf8
    16b4:	881a      	ldrh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    16b6:	25ff      	movs	r5, #255	; 0xff
    // Using first 48 bits of data as header
    mbus_remote_register_write(MRR_ADDR,0x09,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0A,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0B,0x0);
    mbus_remote_register_write(MRR_ADDR,0x0C,0x7AC800);
    mrrv7_r11.MRR_RAD_FSM_TX_H_LEN = 0; //31-31b header (max)
    16b8:	438a      	bics	r2, r1
    16ba:	801a      	strh	r2, [r3, #0]
    mrrv7_r11.MRR_RAD_FSM_TX_D_LEN = RADIO_DATA_LENGTH; //0-skip tx data
    16bc:	881a      	ldrh	r2, [r3, #0]
    16be:	49a3      	ldr	r1, [pc, #652]	; (194c <main+0x7dc>)
    16c0:	402a      	ands	r2, r5
    16c2:	430a      	orrs	r2, r1
    16c4:	801a      	strh	r2, [r3, #0]
    mbus_remote_register_write(MRR_ADDR,0x11,mrrv7_r11.as_int);
    16c6:	681a      	ldr	r2, [r3, #0]
    16c8:	1c20      	adds	r0, r4, #0
    16ca:	2111      	movs	r1, #17
    16cc:	f7fe fd55 	bl	17a <mbus_remote_register_write>

    mrrv7_r13.MRR_RAD_FSM_TX_MODE = 3; //code rate 0:4 1:3 2:2 3:1(baseline) 4:1/2 5:1/3 6:1/4
    16d0:	4e9f      	ldr	r6, [pc, #636]	; (1950 <main+0x7e0>)
    16d2:	4ba0      	ldr	r3, [pc, #640]	; (1954 <main+0x7e4>)
    16d4:	6832      	ldr	r2, [r6, #0]
    16d6:	21c0      	movs	r1, #192	; 0xc0
    16d8:	4013      	ands	r3, r2
    16da:	03c9      	lsls	r1, r1, #15
    16dc:	430b      	orrs	r3, r1
    16de:	6033      	str	r3, [r6, #0]
    mbus_remote_register_write(MRR_ADDR,0x13,mrrv7_r13.as_int);
    16e0:	6832      	ldr	r2, [r6, #0]
    16e2:	1c20      	adds	r0, r4, #0
    16e4:	2113      	movs	r1, #19
    16e6:	f7fe fd48 	bl	17a <mbus_remote_register_write>

    // Mbus return address
    mbus_remote_register_write(MRR_ADDR,0x1E,0x1002);
    16ea:	4a9b      	ldr	r2, [pc, #620]	; (1958 <main+0x7e8>)
    16ec:	211e      	movs	r1, #30
    16ee:	1c20      	adds	r0, r4, #0
    16f0:	f7fe fd43 	bl	17a <mbus_remote_register_write>

    // Additional delay for charging decap
    // config_timerwd(TIMERWD_VAL);
    // *REG_MBUS_WD = 1500000; // default: 1500000
    delay(MBUS_DELAY*200); // Wait for decap to charge
    16f4:	4899      	ldr	r0, [pc, #612]	; (195c <main+0x7ec>)
    16f6:	f7fe fcd6 	bl	a6 <delay>
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    16fa:	4b99      	ldr	r3, [pc, #612]	; (1960 <main+0x7f0>)
    pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[2]);
    pmu_set_sar_conversion_ratio(PMU_SLEEP_SAR_SETTINGS[2]);
}

static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    16fc:	1c38      	adds	r0, r7, #0
    lnt_init();
#endif

#ifdef USE_MRR
    mrr_init();
    radio_on = 0;
    16fe:	701f      	strb	r7, [r3, #0]
    radio_ready = 0;
    1700:	4b98      	ldr	r3, [pc, #608]	; (1964 <main+0x7f4>)
    1702:	701f      	strb	r7, [r3, #0]
    pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[2]);
    pmu_set_sar_conversion_ratio(PMU_SLEEP_SAR_SETTINGS[2]);
}

static void pmu_set_clk_init() {
    pmu_setting_temp_based(0);
    1704:	f7fe fe70 	bl	3e8 <pmu_setting_temp_based>
    read_data_batadc = *REG0 & 0xFF;	// TODO: check if only need low 8 bits
}

static void pmu_enable_4V_harvesting() {
    // Updated for PMUv9
    pmu_reg_write(0x0E,         // PMU_EN_VOLTAGE_CLAMP_TRIM
    1708:	2186      	movs	r1, #134	; 0x86
    170a:	200e      	movs	r0, #14
    170c:	00c9      	lsls	r1, r1, #3
    170e:	f7fe fe01 	bl	314 <pmu_reg_write>
    pmu_set_clk_init();
    pmu_enable_4V_harvesting();

    // New for PMUv9
    // VBAT_READ_TRIM Register
    pmu_reg_write(0x45,         // FIXME: this register is reserved in PMUv10
    1712:	2045      	movs	r0, #69	; 0x45
    1714:	2148      	movs	r1, #72	; 0x48
    1716:	f7fe fdfd 	bl	314 <pmu_reg_write>
                 (0x48 << 0))); // sampling multiplication factor N; vbat_read out = vbat/1p2*N

    // Disable PMU ADC measurement in active mode
    // PMU_CONTROLLER_STALL_ACTIVE
    // Updated for PMUv9
    pmu_reg_write(0x3A,         // PMU_EN_CONTROLLER_STALL_ACTIVE
    171a:	203a      	movs	r0, #58	; 0x3a
    171c:	4992      	ldr	r1, [pc, #584]	; (1968 <main+0x7f8>)
    171e:	f7fe fdf9 	bl	314 <pmu_reg_write>
}

static void pmu_adc_reset_setting() {
    // PMU ADC will be automatically reset when system wakes up
    // Updated for PMUv9
    pmu_reg_write(0x3C,         // PMU_EN_CONTROLLER_DESIRED_STATE_ACTIVE
    1722:	203c      	movs	r0, #60	; 0x3c
    1724:	4991      	ldr	r1, [pc, #580]	; (196c <main+0x7fc>)
    1726:	f7fe fdf5 	bl	314 <pmu_reg_write>

static void pmu_adc_enable() {
    // PMU ADC will be automatically reset when system wakes up
    // PMU_CONTROLLER_DESIRED_STATE sleep
    // Updated for PMUv9
    pmu_reg_write(0x3B,         // PMU_EN_CONTROLLER_DESIRED_STATE_SLEEP
    172a:	203b      	movs	r0, #59	; 0x3b
    172c:	4990      	ldr	r1, [pc, #576]	; (1970 <main+0x800>)
    172e:	f7fe fdf1 	bl	314 <pmu_reg_write>
		  1 << IRQ_REG0 | 1 << IRQ_REG1 | 1 << IRQ_REG2 | 1 << IRQ_REG3);

    if(enumerated != ENUMID) {
        operation_init();
	// set pmu sleep setting
	pmu_setting_temp_based(2);
    1732:	1c20      	adds	r0, r4, #0
    1734:	e2b2      	b.n	1c9c <main+0xb2c>
	operation_sleep();
        // operation_sleep_notimer();
    }
    pmu_setting_temp_based(0);
    1736:	2000      	movs	r0, #0
    1738:	f7fe fe56 	bl	3e8 <pmu_setting_temp_based>

    update_system_time();
    173c:	f7fe ff74 	bl	628 <update_system_time>
#define MPLIER_SHIFT 6
uint8_t lnt_snt_mplier = 0x52;
uint32_t projected_end_time = 0;

static void update_lnt_timer() {
    if(xo_sys_time > projected_end_time + TIMER_MARGIN 
    1740:	4b8c      	ldr	r3, [pc, #560]	; (1974 <main+0x804>)
    1742:	4a8d      	ldr	r2, [pc, #564]	; (1978 <main+0x808>)
    1744:	681b      	ldr	r3, [r3, #0]
    1746:	6810      	ldr	r0, [r2, #0]
    1748:	1c59      	adds	r1, r3, #1
    174a:	31ff      	adds	r1, #255	; 0xff
    174c:	4288      	cmp	r0, r1
    174e:	d909      	bls.n	1764 <main+0x5f4>
	&& xo_sys_time_in_sec - (projected_end_time >> XO_TO_SEC_SHIFT) < 256) {
    1750:	498a      	ldr	r1, [pc, #552]	; (197c <main+0x80c>)
    1752:	6808      	ldr	r0, [r1, #0]
    1754:	0a99      	lsrs	r1, r3, #10
    1756:	1a41      	subs	r1, r0, r1
    1758:	29ff      	cmp	r1, #255	; 0xff
    175a:	d803      	bhi.n	1764 <main+0x5f4>
        lnt_snt_mplier--;
    175c:	4b88      	ldr	r3, [pc, #544]	; (1980 <main+0x810>)
    175e:	781a      	ldrb	r2, [r3, #0]
    1760:	3a01      	subs	r2, #1
    1762:	e00d      	b.n	1780 <main+0x610>
    }
    else if(xo_sys_time < projected_end_time - TIMER_MARGIN 
    1764:	6811      	ldr	r1, [r2, #0]
    1766:	1e5a      	subs	r2, r3, #1
    1768:	3aff      	subs	r2, #255	; 0xff
    176a:	4291      	cmp	r1, r2
    176c:	d209      	bcs.n	1782 <main+0x612>
		&& (projected_end_time >> XO_TO_SEC_SHIFT) - xo_sys_time_in_sec < 256) {
    176e:	4a83      	ldr	r2, [pc, #524]	; (197c <main+0x80c>)
    1770:	0a9b      	lsrs	r3, r3, #10
    1772:	6812      	ldr	r2, [r2, #0]
    1774:	1a9b      	subs	r3, r3, r2
    1776:	2bff      	cmp	r3, #255	; 0xff
    1778:	d803      	bhi.n	1782 <main+0x612>
        lnt_snt_mplier++;
    177a:	4b81      	ldr	r3, [pc, #516]	; (1980 <main+0x810>)
    177c:	781a      	ldrb	r2, [r3, #0]
    177e:	3201      	adds	r2, #1
    1780:	701a      	strb	r2, [r3, #0]

    // mbus_write_message32(0xEE, *SREG_WAKEUP_SOURCE);
    // mbus_write_message32(0xEE, *GOC_DATA_IRQ);

    // check wakeup is due to GOC
    if(*SREG_WAKEUP_SOURCE & 1) {
    1782:	4b80      	ldr	r3, [pc, #512]	; (1984 <main+0x814>)
    1784:	681b      	ldr	r3, [r3, #0]
    1786:	07da      	lsls	r2, r3, #31
    1788:	d508      	bpl.n	179c <main+0x62c>
        // if(!(*GOC_DATA_IRQ)) {
        //     operation_sleep(); // Need to protect against spurious wakeups
        // }
        set_goc_cmd();
    178a:	f7ff fc39 	bl	1000 <set_goc_cmd>

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
    uint8_t i;
    update_system_time();
    178e:	f7fe ff4b 	bl	628 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
    1792:	4b7d      	ldr	r3, [pc, #500]	; (1988 <main+0x818>)
    1794:	2200      	movs	r2, #0
    1796:	601a      	str	r2, [r3, #0]
    1798:	605a      	str	r2, [r3, #4]
    179a:	609a      	str	r2, [r3, #8]
        // }
        set_goc_cmd();
        reset_timers_list();
    }

    lnt_stop();
    179c:	f7fe ffda 	bl	754 <lnt_stop>

    operation_temp_run();
    17a0:	f7fe fe98 	bl	4d4 <operation_temp_run>
}

static void pmu_adc_read_latest() {
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    17a4:	2000      	movs	r0, #0
    17a6:	2103      	movs	r1, #3
    17a8:	f7fe fdb4 	bl	314 <pmu_reg_write>
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFF;	// TODO: check if only need low 8 bits
    17ac:	23a0      	movs	r3, #160	; 0xa0
    17ae:	061b      	lsls	r3, r3, #24
    17b0:	681b      	ldr	r3, [r3, #0]
    17b2:	4e76      	ldr	r6, [pc, #472]	; (198c <main+0x81c>)
    17b4:	b2db      	uxtb	r3, r3
    //     set_next_time(STORE_LNT, 706); // 56.25*2 sec

    // }
    // else if(goc_component == 0x04) {
    
    if(!(goc_data_full & 0x80000000)) {
    17b6:	4a76      	ldr	r2, [pc, #472]	; (1990 <main+0x820>)
static void pmu_adc_read_latest() {
    // Grab latest pmu adc readings 
    // PMU register read is handled differently
    pmu_reg_write(0x00, 0x03);
    // Updated for pmuv9
    read_data_batadc = *REG0 & 0xFF;	// TODO: check if only need low 8 bits
    17b8:	8033      	strh	r3, [r6, #0]
    // mrr_send_enable = 1;
    // if(snt_sys_temp_code < PMU_TEMP_THRESH[1] 
    //     || (read_data_batadc & 0xFF) > MRR_VOLT_THRESH) {
    //     mrr_send_enable = 0;
    // }
    mrr_send_enable = set_send_enable();
    17ba:	4d76      	ldr	r5, [pc, #472]	; (1994 <main+0x824>)
    //     set_next_time(STORE_LNT, 706); // 56.25*2 sec

    // }
    // else if(goc_component == 0x04) {
    
    if(!(goc_data_full & 0x80000000)) {
    17bc:	6813      	ldr	r3, [r2, #0]
    // mrr_send_enable = 1;
    // if(snt_sys_temp_code < PMU_TEMP_THRESH[1] 
    //     || (read_data_batadc & 0xFF) > MRR_VOLT_THRESH) {
    //     mrr_send_enable = 0;
    // }
    mrr_send_enable = set_send_enable();
    17be:	2401      	movs	r4, #1
    17c0:	702c      	strb	r4, [r5, #0]
    //     set_next_time(STORE_LNT, 706); // 56.25*2 sec

    // }
    // else if(goc_component == 0x04) {
    
    if(!(goc_data_full & 0x80000000)) {
    17c2:	2b00      	cmp	r3, #0
    17c4:	db2f      	blt.n	1826 <main+0x6b6>
	uint8_t cmd = goc_data_full & 0x3;
    17c6:	6815      	ldr	r5, [r2, #0]
    17c8:	2303      	movs	r3, #3
    17ca:	401d      	ands	r5, r3
	if(cmd == 2) {
    17cc:	2d02      	cmp	r5, #2
    17ce:	d100      	bne.n	17d2 <main+0x662>
    17d0:	e7fe      	b.n	17d0 <main+0x660>
	    while(1);	// trigger WD timer
	}
	pmu_setting_temp_based(1);
    17d2:	1c20      	adds	r0, r4, #0
    17d4:	f7fe fe08 	bl	3e8 <pmu_setting_temp_based>
	if(cmd == 1) {
    17d8:	2d01      	cmp	r5, #1
    17da:	d102      	bne.n	17e2 <main+0x672>
	    // if force radio out, don't check voltage
	    radio_full_data();
    17dc:	f7ff fc74 	bl	10c8 <radio_full_data>
    17e0:	e016      	b.n	1810 <main+0x6a0>
	}
	else {
	    radio_data_arr[2] = CHIP_ID << 8;
    17e2:	4b6d      	ldr	r3, [pc, #436]	; (1998 <main+0x828>)
    17e4:	2200      	movs	r2, #0
    17e6:	609a      	str	r2, [r3, #8]
	    radio_data_arr[1] = (mem_light_len << 24) | (mem_temp_len << 16) | xo_sys_time_in_sec;
    17e8:	496c      	ldr	r1, [pc, #432]	; (199c <main+0x82c>)
    17ea:	4a6d      	ldr	r2, [pc, #436]	; (19a0 <main+0x830>)
    17ec:	8812      	ldrh	r2, [r2, #0]
    17ee:	8808      	ldrh	r0, [r1, #0]
    17f0:	4962      	ldr	r1, [pc, #392]	; (197c <main+0x80c>)
    17f2:	0400      	lsls	r0, r0, #16
    17f4:	6809      	ldr	r1, [r1, #0]
    17f6:	0612      	lsls	r2, r2, #24
    17f8:	4302      	orrs	r2, r0
    17fa:	430a      	orrs	r2, r1
    17fc:	605a      	str	r2, [r3, #4]
	    radio_data_arr[0] = (snt_sys_temp_code << 12) | read_data_batadc;
    17fe:	4a69      	ldr	r2, [pc, #420]	; (19a4 <main+0x834>)
	    mrr_send_radio_data(1);
    1800:	1c20      	adds	r0, r4, #0
	    radio_full_data();
	}
	else {
	    radio_data_arr[2] = CHIP_ID << 8;
	    radio_data_arr[1] = (mem_light_len << 24) | (mem_temp_len << 16) | xo_sys_time_in_sec;
	    radio_data_arr[0] = (snt_sys_temp_code << 12) | read_data_batadc;
    1802:	6812      	ldr	r2, [r2, #0]
    1804:	8831      	ldrh	r1, [r6, #0]
    1806:	0312      	lsls	r2, r2, #12
    1808:	430a      	orrs	r2, r1
    180a:	601a      	str	r2, [r3, #0]
	    mrr_send_radio_data(1);
    180c:	f7ff fa6e 	bl	cec <mrr_send_radio_data>
	}
	pmu_setting_temp_based(0);
    1810:	2000      	movs	r0, #0
    1812:	f7fe fde9 	bl	3e8 <pmu_setting_temp_based>
    return;
}

// safe sleep mode
static void pmu_set_sleep_low() {
    pmu_set_sleep_clk(PMU_SLEEP_SETTINGS[2]);
    1816:	4864      	ldr	r0, [pc, #400]	; (19a8 <main+0x838>)
    1818:	f7fe fd89 	bl	32e <pmu_set_sleep_clk>
    pmu_set_sar_conversion_ratio(PMU_SLEEP_SAR_SETTINGS[2]);
    181c:	2032      	movs	r0, #50	; 0x32
    181e:	f7fe fdaa 	bl	376 <pmu_set_sar_conversion_ratio>
	}
	pmu_setting_temp_based(0);

	// safe sleep mode // manually set_temp_to_some_value
	pmu_set_sleep_low();
	operation_sleep();
    1822:	f7fe fe1d 	bl	460 <operation_sleep>
#define STATE_RADIO 2
#define STATE_START 3
#define STATE_WAIT 4
#define STATE_VERIFY 5

        if(goc_state == STATE_INIT) {
    1826:	4b61      	ldr	r3, [pc, #388]	; (19ac <main+0x83c>)
    1828:	7819      	ldrb	r1, [r3, #0]
    182a:	2900      	cmp	r1, #0
    182c:	d140      	bne.n	18b0 <main+0x740>
            goc_state = STATE_VERIFY;
    182e:	2005      	movs	r0, #5
    1830:	7018      	strb	r0, [r3, #0]
            op_counter = 0;
    1832:	485f      	ldr	r0, [pc, #380]	; (19b0 <main+0x840>)

	    uint16_t cur_day_time_in_min = (goc_data_full >> 20) & 0x7FF;
	    // mbus_write_message32(0xD4, cur_day_time_in_min);
            xo_day_time_in_sec = (cur_day_time_in_min * 60 * 1553) >> XO_TO_SEC_SHIFT;
    1834:	4d5f      	ldr	r5, [pc, #380]	; (19b4 <main+0x844>)
#define STATE_WAIT 4
#define STATE_VERIFY 5

        if(goc_state == STATE_INIT) {
            goc_state = STATE_VERIFY;
            op_counter = 0;
    1836:	8001      	strh	r1, [r0, #0]

	    uint16_t cur_day_time_in_min = (goc_data_full >> 20) & 0x7FF;
    1838:	6810      	ldr	r0, [r2, #0]
    183a:	0040      	lsls	r0, r0, #1
    183c:	0d40      	lsrs	r0, r0, #21
	    // mbus_write_message32(0xD4, cur_day_time_in_min);
            xo_day_time_in_sec = (cur_day_time_in_min * 60 * 1553) >> XO_TO_SEC_SHIFT;
    183e:	4368      	muls	r0, r5
    1840:	4d5d      	ldr	r5, [pc, #372]	; (19b8 <main+0x848>)
    1842:	1280      	asrs	r0, r0, #10
    1844:	6028      	str	r0, [r5, #0]
	    // mbus_write_message32(0xD5, xo_day_time_in_sec);

	    start_hour_in_sec = (((goc_data_full >> 15) & 0x1F) * 3600 * 1553) >> XO_TO_SEC_SHIFT;
    1846:	6816      	ldr	r6, [r2, #0]
    1848:	485c      	ldr	r0, [pc, #368]	; (19bc <main+0x84c>)
    184a:	0336      	lsls	r6, r6, #12
    184c:	0ef6      	lsrs	r6, r6, #27
    184e:	4346      	muls	r6, r0
    1850:	485b      	ldr	r0, [pc, #364]	; (19c0 <main+0x850>)
    1852:	0ab6      	lsrs	r6, r6, #10
    1854:	6006      	str	r6, [r0, #0]
	    // mbus_write_message32(0xD7, start_hour_in_sec);
	    snt_op_max_count = (goc_data_full >> 8) & 0x7F;
    1856:	6817      	ldr	r7, [r2, #0]
    1858:	4e5a      	ldr	r6, [pc, #360]	; (19c4 <main+0x854>)
    185a:	047f      	lsls	r7, r7, #17
    185c:	0e7f      	lsrs	r7, r7, #25
    185e:	7037      	strb	r7, [r6, #0]
	    radio_beacon_counter = (goc_data_full >> 5) & 0x7;
    1860:	6817      	ldr	r7, [r2, #0]
    1862:	4e59      	ldr	r6, [pc, #356]	; (19c8 <main+0x858>)
    1864:	063f      	lsls	r7, r7, #24
    1866:	0f7f      	lsrs	r7, r7, #29
    1868:	7037      	strb	r7, [r6, #0]
	    radio_after_done = (goc_data_full >> 4) & 1;
    186a:	6812      	ldr	r2, [r2, #0]
    186c:	0912      	lsrs	r2, r2, #4
    186e:	4014      	ands	r4, r2
    1870:	4a56      	ldr	r2, [pc, #344]	; (19cc <main+0x85c>)
    1872:	7014      	strb	r4, [r2, #0]
            
	    // Use radio timer to override LNT and SNT timers
            start_hour_in_sec = xo_sys_time_in_sec + start_hour_in_sec - xo_day_time_in_sec;
    1874:	4a41      	ldr	r2, [pc, #260]	; (197c <main+0x80c>)
    1876:	6814      	ldr	r4, [r2, #0]
    1878:	6806      	ldr	r6, [r0, #0]
    187a:	682d      	ldr	r5, [r5, #0]
    187c:	1934      	adds	r4, r6, r4
    187e:	1b64      	subs	r4, r4, r5
    1880:	6004      	str	r4, [r0, #0]
	    xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 172;
    1882:	6814      	ldr	r4, [r2, #0]
    1884:	4840      	ldr	r0, [pc, #256]	; (1988 <main+0x818>)
    1886:	34ac      	adds	r4, #172	; 0xac
    1888:	6084      	str	r4, [r0, #8]
	    // mbus_write_message32(0xD7, xot_timer_list[SEND_RAD]);

	    mem_temp_len = 0;
    188a:	4c44      	ldr	r4, [pc, #272]	; (199c <main+0x82c>)
    188c:	8021      	strh	r1, [r4, #0]
	    mem_light_len = 0;
    188e:	4c44      	ldr	r4, [pc, #272]	; (19a0 <main+0x830>)
    1890:	8021      	strh	r1, [r4, #0]
	    light_packet_num = 0;
    1892:	4c4f      	ldr	r4, [pc, #316]	; (19d0 <main+0x860>)
    1894:	7021      	strb	r1, [r4, #0]
	    temp_packet_num = 0;
    1896:	4c4f      	ldr	r4, [pc, #316]	; (19d4 <main+0x864>)
    1898:	7021      	strb	r1, [r4, #0]
	    // will start on the hour, so set snt_counter = 0
            snt_counter = 0;
    189a:	4c4f      	ldr	r4, [pc, #316]	; (19d8 <main+0x868>)
            radio_counter = 0;

            radio_data_arr[0] = xot_timer_list[SEND_RAD];
    189c:	4b3e      	ldr	r3, [pc, #248]	; (1998 <main+0x828>)
	    mem_temp_len = 0;
	    mem_light_len = 0;
	    light_packet_num = 0;
	    temp_packet_num = 0;
	    // will start on the hour, so set snt_counter = 0
            snt_counter = 0;
    189e:	7021      	strb	r1, [r4, #0]
            radio_counter = 0;
    18a0:	4c4e      	ldr	r4, [pc, #312]	; (19dc <main+0x86c>)
    18a2:	7021      	strb	r1, [r4, #0]

            radio_data_arr[0] = xot_timer_list[SEND_RAD];
    18a4:	6880      	ldr	r0, [r0, #8]
    18a6:	6018      	str	r0, [r3, #0]
            radio_data_arr[1] = xo_sys_time_in_sec;
    18a8:	6812      	ldr	r2, [r2, #0]
    18aa:	605a      	str	r2, [r3, #4]
            radio_data_arr[2] = CHIP_ID << 8;
    18ac:	6099      	str	r1, [r3, #8]
    18ae:	e01d      	b.n	18ec <main+0x77c>
	    send_beacon();
	}
	else if(goc_state == STATE_VERIFY) {
    18b0:	781a      	ldrb	r2, [r3, #0]
    18b2:	2a05      	cmp	r2, #5
    18b4:	d11d      	bne.n	18f2 <main+0x782>
	    if(++op_counter < 4) {
    18b6:	493e      	ldr	r1, [pc, #248]	; (19b0 <main+0x840>)
    18b8:	4a33      	ldr	r2, [pc, #204]	; (1988 <main+0x818>)
    18ba:	8808      	ldrh	r0, [r1, #0]
    18bc:	3001      	adds	r0, #1
    18be:	b280      	uxth	r0, r0
    18c0:	8008      	strh	r0, [r1, #0]
    18c2:	2803      	cmp	r0, #3
    18c4:	d803      	bhi.n	18ce <main+0x75e>
		xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + 172;
    18c6:	4b2d      	ldr	r3, [pc, #180]	; (197c <main+0x80c>)
    18c8:	681b      	ldr	r3, [r3, #0]
    18ca:	33ac      	adds	r3, #172	; 0xac
    18cc:	e005      	b.n	18da <main+0x76a>
	    }
	    else {
		goc_state = STATE_START;
    18ce:	2003      	movs	r0, #3
    18d0:	7018      	strb	r0, [r3, #0]
	    	op_counter = 0;
    18d2:	2300      	movs	r3, #0
    18d4:	800b      	strh	r3, [r1, #0]
		xot_timer_list[SEND_RAD] = start_hour_in_sec;
    18d6:	4b3a      	ldr	r3, [pc, #232]	; (19c0 <main+0x850>)
    18d8:	681b      	ldr	r3, [r3, #0]
    18da:	6093      	str	r3, [r2, #8]
	    }

            radio_data_arr[0] = xot_timer_list[SEND_RAD];
    18dc:	6892      	ldr	r2, [r2, #8]
    18de:	4b2e      	ldr	r3, [pc, #184]	; (1998 <main+0x828>)
    18e0:	601a      	str	r2, [r3, #0]
	    radio_data_arr[1] = xo_sys_time_in_sec;
    18e2:	4a26      	ldr	r2, [pc, #152]	; (197c <main+0x80c>)
    18e4:	6812      	ldr	r2, [r2, #0]
    18e6:	605a      	str	r2, [r3, #4]
	    radio_data_arr[2] = CHIP_ID << 8;
    18e8:	2200      	movs	r2, #0
    18ea:	609a      	str	r2, [r3, #8]
	    send_beacon();
    18ec:	f7ff fc34 	bl	1158 <send_beacon>
    18f0:	e14f      	b.n	1b92 <main+0xa22>
	}
	else if(goc_state == STATE_START) {
    18f2:	781a      	ldrb	r2, [r3, #0]
    18f4:	2a03      	cmp	r2, #3
    18f6:	d175      	bne.n	19e4 <main+0x874>
	    goc_state = STATE_COLLECT;
    18f8:	701c      	strb	r4, [r3, #0]
            xot_last_timer_list[STORE_LNT] = xot_last_timer_list[SEND_RAD];
    18fa:	4b39      	ldr	r3, [pc, #228]	; (19e0 <main+0x870>)
    18fc:	689a      	ldr	r2, [r3, #8]
    18fe:	605a      	str	r2, [r3, #4]
            xot_last_timer_list[STORE_SNT] = xot_last_timer_list[SEND_RAD];
    1900:	689a      	ldr	r2, [r3, #8]
    1902:	601a      	str	r2, [r3, #0]
            // xot_timer_list[STORE_LNT] = xo_sys_time_in_sec + update_light_interval();
            // xot_timer_list[STORE_SNT] = xo_sys_time_in_sec + LNT_INTERVAL[2];
	    set_next_time(STORE_LNT, update_light_interval());
    1904:	f7fe fc76 	bl	1f4 <update_light_interval>
    1908:	1c01      	adds	r1, r0, #0
    190a:	1c20      	adds	r0, r4, #0
    190c:	f7fe fece 	bl	6ac <set_next_time>
	    set_next_time(STORE_SNT, LNT_INTERVAL[2]);
    1910:	21ac      	movs	r1, #172	; 0xac
    1912:	2000      	movs	r0, #0
    1914:	0089      	lsls	r1, r1, #2
    1916:	f7fe fec9 	bl	6ac <set_next_time>
            xot_timer_list[SEND_RAD] = 0;
    191a:	2200      	movs	r2, #0
    191c:	e08c      	b.n	1a38 <main+0x8c8>
    191e:	46c0      	nop			; (mov r8, r8)
    1920:	00001e3f 	.word	0x00001e3f
    1924:	00001e3c 	.word	0x00001e3c
    1928:	00001e5c 	.word	0x00001e5c
    192c:	fffe007f 	.word	0xfffe007f
    1930:	00001ecc 	.word	0x00001ecc
    1934:	ffc0ffff 	.word	0xffc0ffff
    1938:	ffff03ff 	.word	0xffff03ff
    193c:	00039fff 	.word	0x00039fff
    1940:	ffffbfff 	.word	0xffffbfff
    1944:	007ac800 	.word	0x007ac800
    1948:	00001df4 	.word	0x00001df4
    194c:	ffffc000 	.word	0xffffc000
    1950:	00001dfc 	.word	0x00001dfc
    1954:	ff1fffff 	.word	0xff1fffff
    1958:	00001002 	.word	0x00001002
    195c:	00004e20 	.word	0x00004e20
    1960:	00001e72 	.word	0x00001e72
    1964:	00001e3e 	.word	0x00001e3e
    1968:	00103800 	.word	0x00103800
    196c:	0017c7ff 	.word	0x0017c7ff
    1970:	0017efff 	.word	0x0017efff
    1974:	00001ea0 	.word	0x00001ea0
    1978:	00001e98 	.word	0x00001e98
    197c:	00001e88 	.word	0x00001e88
    1980:	00001e14 	.word	0x00001e14
    1984:	a000a008 	.word	0xa000a008
    1988:	00001ebc 	.word	0x00001ebc
    198c:	00001e46 	.word	0x00001e46
    1990:	00001e6c 	.word	0x00001e6c
    1994:	00001de8 	.word	0x00001de8
    1998:	00001e48 	.word	0x00001e48
    199c:	00001e84 	.word	0x00001e84
    19a0:	00001e92 	.word	0x00001e92
    19a4:	00001e10 	.word	0x00001e10
    19a8:	0f020104 	.word	0x0f020104
    19ac:	00001e56 	.word	0x00001e56
    19b0:	00001e70 	.word	0x00001e70
    19b4:	00016bfc 	.word	0x00016bfc
    19b8:	00001e8c 	.word	0x00001e8c
    19bc:	00554f10 	.word	0x00554f10
    19c0:	00001ea8 	.word	0x00001ea8
    19c4:	00001e15 	.word	0x00001e15
    19c8:	00001e54 	.word	0x00001e54
    19cc:	00001e44 	.word	0x00001e44
    19d0:	00001ea5 	.word	0x00001ea5
    19d4:	00001e73 	.word	0x00001e73
    19d8:	00001ea4 	.word	0x00001ea4
    19dc:	00001e45 	.word	0x00001e45
    19e0:	00001eac 	.word	0x00001eac
	}
        else if(goc_state == STATE_COLLECT) {
    19e4:	781a      	ldrb	r2, [r3, #0]
    19e6:	4eaf      	ldr	r6, [pc, #700]	; (1ca4 <main+0xb34>)
    19e8:	2a01      	cmp	r2, #1
    19ea:	d000      	beq.n	19ee <main+0x87e>
    19ec:	e090      	b.n	1b10 <main+0x9a0>

            if(op_counter >= snt_op_max_count) {
    19ee:	49ae      	ldr	r1, [pc, #696]	; (1ca8 <main+0xb38>)
    19f0:	4aae      	ldr	r2, [pc, #696]	; (1cac <main+0xb3c>)
    19f2:	8808      	ldrh	r0, [r1, #0]
    19f4:	7812      	ldrb	r2, [r2, #0]
    19f6:	4290      	cmp	r0, r2
    19f8:	d321      	bcc.n	1a3e <main+0x8ce>
		if(radio_after_done) {
    19fa:	4aad      	ldr	r2, [pc, #692]	; (1cb0 <main+0xb40>)
    19fc:	7812      	ldrb	r2, [r2, #0]
    19fe:	2a00      	cmp	r2, #0
    1a00:	d100      	bne.n	1a04 <main+0x894>
    1a02:	e708      	b.n	1816 <main+0x6a6>
                    goc_state = STATE_RADIO;
    1a04:	2202      	movs	r2, #2
    1a06:	701a      	strb	r2, [r3, #0]

// 0 : not in use
// 0xFFFFFFFF : time's up
static void reset_timers_list() {
    uint8_t i;
    update_system_time();
    1a08:	f7fe fe0e 	bl	628 <update_system_time>
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
        xot_timer_list[i] = 0;
    1a0c:	2300      	movs	r3, #0
    1a0e:	6033      	str	r3, [r6, #0]
    1a10:	6073      	str	r3, [r6, #4]
    1a12:	60b3      	str	r3, [r6, #8]

uint16_t light_last_ref_time = 0;
uint16_t temp_last_ref_time = 0;

static void store_temp() {
    if(temp_storage_remainder < TEMP_MAX_REMAINDER) {
    1a14:	4ba7      	ldr	r3, [pc, #668]	; (1cb4 <main+0xb44>)
    1a16:	781b      	ldrb	r3, [r3, #0]
    1a18:	2b38      	cmp	r3, #56	; 0x38
    1a1a:	d801      	bhi.n	1a20 <main+0x8b0>
    1a1c:	f7fe fd30 	bl	480 <store_temp.part.0>
    lnt_l2_len = 0;
}


static void store_light() {
    if(light_storage_remainder < LIGHT_MAX_REMAINDER) {
    1a20:	4ba5      	ldr	r3, [pc, #660]	; (1cb8 <main+0xb48>)
    1a22:	781b      	ldrb	r3, [r3, #0]
    1a24:	2b7a      	cmp	r3, #122	; 0x7a
    1a26:	d801      	bhi.n	1a2c <main+0x8bc>
    1a28:	f7fe ff48 	bl	8bc <store_light.part.6>
	            operation_sleep();
		}
                reset_timers_list();
                store_temp();       // store everything in temp_code_storage
                store_light();
                update_system_time();
    1a2c:	f7fe fdfc 	bl	628 <update_system_time>
                xot_timer_list[SEND_RAD] = xo_sys_time_in_sec + MRR_SIGNAL_PERIOD;
    1a30:	4ba2      	ldr	r3, [pc, #648]	; (1cbc <main+0xb4c>)
    1a32:	681a      	ldr	r2, [r3, #0]
    1a34:	4ba2      	ldr	r3, [pc, #648]	; (1cc0 <main+0xb50>)
    1a36:	18d2      	adds	r2, r2, r3
    1a38:	4b9a      	ldr	r3, [pc, #616]	; (1ca4 <main+0xb34>)
    1a3a:	609a      	str	r2, [r3, #8]
    1a3c:	e0a9      	b.n	1b92 <main+0xa22>
            }
    	    // mbus_write_message32(0xAA, xot_timer_list[STORE_LNT]);
	    else {
	        // op_counter++;		// FIXME: remove this
	        if(xot_timer_list[STORE_SNT] == 0xFFFFFFFF) {
    1a3e:	6833      	ldr	r3, [r6, #0]
    1a40:	3301      	adds	r3, #1
    1a42:	d156      	bne.n	1af2 <main+0x982>

                    if(++snt_counter >= 4) {
    1a44:	4a9f      	ldr	r2, [pc, #636]	; (1cc4 <main+0xb54>)
    1a46:	7813      	ldrb	r3, [r2, #0]
    1a48:	3301      	adds	r3, #1
    1a4a:	b2db      	uxtb	r3, r3
    1a4c:	7013      	strb	r3, [r2, #0]
    1a4e:	2b03      	cmp	r3, #3
    1a50:	d94a      	bls.n	1ae8 <main+0x978>
                        op_counter++; 		// FIXME: add this back in
    1a52:	880b      	ldrh	r3, [r1, #0]
    1a54:	3301      	adds	r3, #1
    1a56:	800b      	strh	r3, [r1, #0]
                        snt_counter = 0;
    1a58:	2300      	movs	r3, #0
    1a5a:	7013      	strb	r3, [r2, #0]

#define TEMP_RES 7

static void compress_temp() {
    
    if(temp_storage_remainder == TEMP_MAX_REMAINDER) {
    1a5c:	4a95      	ldr	r2, [pc, #596]	; (1cb4 <main+0xb44>)
    1a5e:	7812      	ldrb	r2, [r2, #0]
    1a60:	2a39      	cmp	r2, #57	; 0x39
    1a62:	d102      	bne.n	1a6a <main+0x8fa>
        temp_code_storage[1] = 0;
    1a64:	4a98      	ldr	r2, [pc, #608]	; (1cc8 <main+0xb58>)
    1a66:	6053      	str	r3, [r2, #4]
        temp_code_storage[0] = 0;
    1a68:	6013      	str	r3, [r2, #0]
    }

    // Take 3 bits above decimal point and 4 bits under
    uint8_t log_temp = log2(snt_sys_temp_code) >> (8 - TEMP_RES); 
    1a6a:	4b98      	ldr	r3, [pc, #608]	; (1ccc <main+0xb5c>)
    1a6c:	2100      	movs	r1, #0
    1a6e:	6818      	ldr	r0, [r3, #0]
    1a70:	f7fe ffbe 	bl	9f0 <log2>

static void temp_shift_left_store(uint32_t data, uint8_t len) {
    // mbus_write_message32(0xB6, data);
    // mbus_write_message32(0xB7, len);
    // data &= ((1 << len) - 1);
    data &= right_shift(1, -len) - 1;
    1a74:	2207      	movs	r2, #7
        temp_code_storage[1] = 0;
        temp_code_storage[0] = 0;
    }

    // Take 3 bits above decimal point and 4 bits under
    uint8_t log_temp = log2(snt_sys_temp_code) >> (8 - TEMP_RES); 
    1a76:	1c04      	adds	r4, r0, #0

static void temp_shift_left_store(uint32_t data, uint8_t len) {
    // mbus_write_message32(0xB6, data);
    // mbus_write_message32(0xB7, len);
    // data &= ((1 << len) - 1);
    data &= right_shift(1, -len) - 1;
    1a78:	4252      	negs	r2, r2
    1a7a:	2001      	movs	r0, #1
    1a7c:	2100      	movs	r1, #0
    1a7e:	f7fe fe4f 	bl	720 <right_shift>
        temp_code_storage[1] = 0;
        temp_code_storage[0] = 0;
    }

    // Take 3 bits above decimal point and 4 bits under
    uint8_t log_temp = log2(snt_sys_temp_code) >> (8 - TEMP_RES); 
    1a82:	0864      	lsrs	r4, r4, #1
    // mbus_write_message32(0xB5, log_temp);

    temp_shift_left_store(log_temp, TEMP_RES);
    1a84:	b2e4      	uxtb	r4, r4

static void temp_shift_left_store(uint32_t data, uint8_t len) {
    // mbus_write_message32(0xB6, data);
    // mbus_write_message32(0xB7, len);
    // data &= ((1 << len) - 1);
    data &= right_shift(1, -len) - 1;
    1a86:	1e45      	subs	r5, r0, #1
    1a88:	4025      	ands	r5, r4

    // temp_code_storage[1] = temp_code_storage[1] << len;
    // temp_code_storage[1] |= (temp_code_storage[0] >> (32 - len));
    // temp_code_storage[0] = temp_code_storage[0] << len;
    temp_code_storage[1] = right_shift(temp_code_storage[1], -len);
    1a8a:	4c8f      	ldr	r4, [pc, #572]	; (1cc8 <main+0xb58>)
    1a8c:	2207      	movs	r2, #7
    1a8e:	6860      	ldr	r0, [r4, #4]
    1a90:	4252      	negs	r2, r2
    1a92:	2100      	movs	r1, #0
    1a94:	f7fe fe44 	bl	720 <right_shift>
    1a98:	6060      	str	r0, [r4, #4]
    temp_code_storage[1] |= right_shift(temp_code_storage[0], (32 - len));
    1a9a:	6866      	ldr	r6, [r4, #4]
    1a9c:	2219      	movs	r2, #25
    1a9e:	6820      	ldr	r0, [r4, #0]
    1aa0:	2100      	movs	r1, #0
    1aa2:	f7fe fe3d 	bl	720 <right_shift>
    1aa6:	4306      	orrs	r6, r0
    1aa8:	6066      	str	r6, [r4, #4]
    temp_code_storage[0] = right_shift(temp_code_storage[0], -len);
    1aaa:	2207      	movs	r2, #7
    1aac:	6820      	ldr	r0, [r4, #0]
    1aae:	4252      	negs	r2, r2
    1ab0:	2100      	movs	r1, #0
    1ab2:	f7fe fe35 	bl	720 <right_shift>
    1ab6:	6020      	str	r0, [r4, #0]
    temp_code_storage[0] |= data;
    1ab8:	6823      	ldr	r3, [r4, #0]
    1aba:	431d      	orrs	r5, r3
    temp_storage_remainder -= len;
    1abc:	4b7d      	ldr	r3, [pc, #500]	; (1cb4 <main+0xb44>)
    // temp_code_storage[1] |= (temp_code_storage[0] >> (32 - len));
    // temp_code_storage[0] = temp_code_storage[0] << len;
    temp_code_storage[1] = right_shift(temp_code_storage[1], -len);
    temp_code_storage[1] |= right_shift(temp_code_storage[0], (32 - len));
    temp_code_storage[0] = right_shift(temp_code_storage[0], -len);
    temp_code_storage[0] |= data;
    1abe:	6025      	str	r5, [r4, #0]
    temp_storage_remainder -= len;
    1ac0:	781a      	ldrb	r2, [r3, #0]
    1ac2:	1c1c      	adds	r4, r3, #0
    1ac4:	3a07      	subs	r2, #7
    1ac6:	701a      	strb	r2, [r3, #0]
    // Take 3 bits above decimal point and 4 bits under
    uint8_t log_temp = log2(snt_sys_temp_code) >> (8 - TEMP_RES); 
    // mbus_write_message32(0xB5, log_temp);

    temp_shift_left_store(log_temp, TEMP_RES);
    temp_last_ref_time = (xo_day_time_in_sec >> 6) & 0x7FF;
    1ac8:	4a81      	ldr	r2, [pc, #516]	; (1cd0 <main+0xb60>)
    1aca:	6811      	ldr	r1, [r2, #0]
    1acc:	4a81      	ldr	r2, [pc, #516]	; (1cd4 <main+0xb64>)
    1ace:	03c9      	lsls	r1, r1, #15
    1ad0:	0d49      	lsrs	r1, r1, #21
    1ad2:	8011      	strh	r1, [r2, #0]
    if(temp_storage_remainder < TEMP_RES) {
    1ad4:	781a      	ldrb	r2, [r3, #0]
    1ad6:	2a06      	cmp	r2, #6
    1ad8:	d806      	bhi.n	1ae8 <main+0x978>

uint16_t light_last_ref_time = 0;
uint16_t temp_last_ref_time = 0;

static void store_temp() {
    if(temp_storage_remainder < TEMP_MAX_REMAINDER) {
    1ada:	781b      	ldrb	r3, [r3, #0]
    1adc:	2b38      	cmp	r3, #56	; 0x38
    1ade:	d801      	bhi.n	1ae4 <main+0x974>
    1ae0:	f7fe fcce 	bl	480 <store_temp.part.0>

    temp_shift_left_store(log_temp, TEMP_RES);
    temp_last_ref_time = (xo_day_time_in_sec >> 6) & 0x7FF;
    if(temp_storage_remainder < TEMP_RES) {
        store_temp();
        temp_storage_remainder = TEMP_MAX_REMAINDER;
    1ae4:	2339      	movs	r3, #57	; 0x39
    1ae6:	7023      	strb	r3, [r4, #0]
                        snt_counter = 0;
                        compress_temp();
                    }

                    // set_next_time(STORE_SNT, SNT_TEMP_UPDATE_TIME);
                    set_next_time(STORE_SNT, LNT_INTERVAL[2]);
    1ae8:	21ac      	movs	r1, #172	; 0xac
    1aea:	2000      	movs	r0, #0
    1aec:	0089      	lsls	r1, r1, #2
    1aee:	f7fe fddd 	bl	6ac <set_next_time>
                    // mbus_write_message32(0xEA, xot_timer_list[STORE_SNT]);
                }

                if(xot_timer_list[STORE_LNT] == 0xFFFFFFFF) {
    1af2:	4b6c      	ldr	r3, [pc, #432]	; (1ca4 <main+0xb34>)
    1af4:	685b      	ldr	r3, [r3, #4]
    1af6:	3301      	adds	r3, #1
    1af8:	d14b      	bne.n	1b92 <main+0xa22>
                    if(compress_light() != 0) {
    1afa:	f7fe ffe9 	bl	ad0 <compress_light>
    1afe:	2800      	cmp	r0, #0
    1b00:	d001      	beq.n	1b06 <main+0x996>
                        compress_light();
    1b02:	f7fe ffe5 	bl	ad0 <compress_light>
                    }

    	            uint16_t interval = update_light_interval();
    1b06:	f7fe fb75 	bl	1f4 <update_light_interval>
    1b0a:	1c01      	adds	r1, r0, #0
	            set_next_time(STORE_LNT, interval);
    1b0c:	2001      	movs	r0, #1
    1b0e:	e03e      	b.n	1b8e <main+0xa1e>
    	            // mbus_write_message32(0xEB, xot_timer_list[STORE_LNT]);
                }
	    }

        }
        else if(goc_state == STATE_RADIO) {
    1b10:	781b      	ldrb	r3, [r3, #0]
    1b12:	2b02      	cmp	r3, #2
    1b14:	d13d      	bne.n	1b92 <main+0xa22>
            if(xot_timer_list[SEND_RAD] == 0xFFFFFFFF) {
    1b16:	68b3      	ldr	r3, [r6, #8]
    1b18:	3301      	adds	r3, #1
    1b1a:	d13a      	bne.n	1b92 <main+0xa22>

                if(xo_check_is_day() && mrr_send_enable) {
    1b1c:	f7fe fdea 	bl	6f4 <xo_check_is_day>
    1b20:	2800      	cmp	r0, #0
    1b22:	d032      	beq.n	1b8a <main+0xa1a>
    1b24:	782b      	ldrb	r3, [r5, #0]
    1b26:	2b00      	cmp	r3, #0
    1b28:	d02f      	beq.n	1b8a <main+0xa1a>
                    pmu_setting_temp_based(1);
    1b2a:	1c20      	adds	r0, r4, #0
    1b2c:	f7fe fc5c 	bl	3e8 <pmu_setting_temp_based>
                    // send data
                    if(++radio_beacon_counter >= 6) { // FIXME: change to 6
    1b30:	4b69      	ldr	r3, [pc, #420]	; (1cd8 <main+0xb68>)
    1b32:	2200      	movs	r2, #0
    1b34:	7819      	ldrb	r1, [r3, #0]
    1b36:	3101      	adds	r1, #1
    1b38:	b2c9      	uxtb	r1, r1
    1b3a:	7019      	strb	r1, [r3, #0]
    1b3c:	2905      	cmp	r1, #5
    1b3e:	d903      	bls.n	1b48 <main+0x9d8>
                        radio_beacon_counter = 0;
    1b40:	701a      	strb	r2, [r3, #0]

			radio_full_data();
    1b42:	f7ff fac1 	bl	10c8 <radio_full_data>
    1b46:	e019      	b.n	1b7c <main+0xa0c>
                    }
		    else {
                        // send beacon
			// If bottom bits are all 1s, then it must be beacon
			radio_data_arr[2] = CHIP_ID << 8;
    1b48:	4b64      	ldr	r3, [pc, #400]	; (1cdc <main+0xb6c>)
			radio_data_arr[1] = (read_data_batadc << 24) | snt_sys_temp_code;
    1b4a:	4960      	ldr	r1, [pc, #384]	; (1ccc <main+0xb5c>)
			radio_full_data();
                    }
		    else {
                        // send beacon
			// If bottom bits are all 1s, then it must be beacon
			radio_data_arr[2] = CHIP_ID << 8;
    1b4c:	609a      	str	r2, [r3, #8]
			radio_data_arr[1] = (read_data_batadc << 24) | snt_sys_temp_code;
    1b4e:	4a64      	ldr	r2, [pc, #400]	; (1ce0 <main+0xb70>)
    1b50:	8812      	ldrh	r2, [r2, #0]
    1b52:	6809      	ldr	r1, [r1, #0]
    1b54:	0612      	lsls	r2, r2, #24
    1b56:	430a      	orrs	r2, r1
    1b58:	605a      	str	r2, [r3, #4]
			radio_data_arr[0] = (radio_beacon_counter << 28) | (radio_counter << 20) | (xo_day_time_in_sec << 11) | 0x7FF;
    1b5a:	4a5f      	ldr	r2, [pc, #380]	; (1cd8 <main+0xb68>)
    1b5c:	7814      	ldrb	r4, [r2, #0]
    1b5e:	4a61      	ldr	r2, [pc, #388]	; (1ce4 <main+0xb74>)
    1b60:	7810      	ldrb	r0, [r2, #0]
    1b62:	4a5b      	ldr	r2, [pc, #364]	; (1cd0 <main+0xb60>)
    1b64:	0500      	lsls	r0, r0, #20
    1b66:	6811      	ldr	r1, [r2, #0]
    1b68:	4a5f      	ldr	r2, [pc, #380]	; (1ce8 <main+0xb78>)
    1b6a:	02c9      	lsls	r1, r1, #11
    1b6c:	4311      	orrs	r1, r2
    1b6e:	0722      	lsls	r2, r4, #28
    1b70:	4302      	orrs	r2, r0
    1b72:	430a      	orrs	r2, r1

                        mrr_send_radio_data(1);
    1b74:	2001      	movs	r0, #1
		    else {
                        // send beacon
			// If bottom bits are all 1s, then it must be beacon
			radio_data_arr[2] = CHIP_ID << 8;
			radio_data_arr[1] = (read_data_batadc << 24) | snt_sys_temp_code;
			radio_data_arr[0] = (radio_beacon_counter << 28) | (radio_counter << 20) | (xo_day_time_in_sec << 11) | 0x7FF;
    1b76:	601a      	str	r2, [r3, #0]

                        mrr_send_radio_data(1);
    1b78:	f7ff f8b8 	bl	cec <mrr_send_radio_data>
		    }
                    pmu_setting_temp_based(0);
    1b7c:	2000      	movs	r0, #0
    1b7e:	f7fe fc33 	bl	3e8 <pmu_setting_temp_based>


                    radio_counter++;
    1b82:	4b58      	ldr	r3, [pc, #352]	; (1ce4 <main+0xb74>)
    1b84:	781a      	ldrb	r2, [r3, #0]
    1b86:	3201      	adds	r2, #1
    1b88:	701a      	strb	r2, [r3, #0]
                }

                set_next_time(SEND_RAD, MRR_SIGNAL_PERIOD);
    1b8a:	494d      	ldr	r1, [pc, #308]	; (1cc0 <main+0xb50>)
    1b8c:	2002      	movs	r0, #2
    1b8e:	f7fe fd8d 	bl	6ac <set_next_time>

    // mbus_write_message32(0xE0, xot_timer_list[STORE_LNT]);
    // mbus_write_message32(0xE1, xot_timer_list[STORE_SNT]);
    // mbus_write_message32(0xE2, xot_timer_list[SEND_RAD]); // if time to next LNT_STORE time is less than 450 seconds, use that time,
    // else, use 450 seconds
    update_system_time();
    1b92:	f7fe fd49 	bl	628 <update_system_time>
    uint32_t end_time = 0;
    if(xot_timer_list[SEND_RAD] != 0 && xot_timer_list[SEND_RAD] != 0xFFFFFFFF) {
    1b96:	4b43      	ldr	r3, [pc, #268]	; (1ca4 <main+0xb34>)
    1b98:	689a      	ldr	r2, [r3, #8]
    1b9a:	1c19      	adds	r1, r3, #0
    1b9c:	2a00      	cmp	r2, #0
    1b9e:	d004      	beq.n	1baa <main+0xa3a>
    1ba0:	689a      	ldr	r2, [r3, #8]
    1ba2:	3201      	adds	r2, #1
    1ba4:	d001      	beq.n	1baa <main+0xa3a>
        end_time = xot_timer_list[SEND_RAD];
    1ba6:	689b      	ldr	r3, [r3, #8]
    1ba8:	e012      	b.n	1bd0 <main+0xa60>
    }
    else {
        // if(xot_timer_list[STORE_LNT] != 0 
	//    && xot_timer_list[STORE_LNT] - xot_last_timer_list[STORE_LNT] < LNT_INTERVAL[2]) {
	if(lnt_meas_time_mode < 2) {
    1baa:	4a50      	ldr	r2, [pc, #320]	; (1cec <main+0xb7c>)
    1bac:	7813      	ldrb	r3, [r2, #0]
    1bae:	2b01      	cmp	r3, #1
    1bb0:	d802      	bhi.n	1bb8 <main+0xa48>
            end_time = xot_timer_list[STORE_LNT];
    1bb2:	684b      	ldr	r3, [r1, #4]
            lnt_counter_base = lnt_meas_time_mode;
    1bb4:	7811      	ldrb	r1, [r2, #0]
    1bb6:	e009      	b.n	1bcc <main+0xa5c>
        }
        else {
	    end_time = xot_last_timer_list[STORE_LNT];
    1bb8:	4b4d      	ldr	r3, [pc, #308]	; (1cf0 <main+0xb80>)
	    do {
	        // mbus_write_message32(0xBB, end_time);
                end_time += LNT_INTERVAL[2];
	    } while(end_time <= xo_sys_time_in_sec);
    1bba:	4940      	ldr	r1, [pc, #256]	; (1cbc <main+0xb4c>)
	if(lnt_meas_time_mode < 2) {
            end_time = xot_timer_list[STORE_LNT];
            lnt_counter_base = lnt_meas_time_mode;
        }
        else {
	    end_time = xot_last_timer_list[STORE_LNT];
    1bbc:	685b      	ldr	r3, [r3, #4]
	    do {
	        // mbus_write_message32(0xBB, end_time);
                end_time += LNT_INTERVAL[2];
    1bbe:	25ac      	movs	r5, #172	; 0xac
    1bc0:	00ad      	lsls	r5, r5, #2
	    } while(end_time <= xo_sys_time_in_sec);
    1bc2:	680a      	ldr	r2, [r1, #0]
        }
        else {
	    end_time = xot_last_timer_list[STORE_LNT];
	    do {
	        // mbus_write_message32(0xBB, end_time);
                end_time += LNT_INTERVAL[2];
    1bc4:	195b      	adds	r3, r3, r5
	    } while(end_time <= xo_sys_time_in_sec);
    1bc6:	4293      	cmp	r3, r2
    1bc8:	d9f9      	bls.n	1bbe <main+0xa4e>
            lnt_counter_base = 3;
    1bca:	2103      	movs	r1, #3
    1bcc:	4a49      	ldr	r2, [pc, #292]	; (1cf4 <main+0xb84>)
    1bce:	7011      	strb	r1, [r2, #0]
	// mbus_write_message32(0xEF, lnt_counter_base);
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	uint32_t diff = xot_timer_list[i] - xo_sys_time_in_sec;
    1bd0:	4834      	ldr	r0, [pc, #208]	; (1ca4 <main+0xb34>)
    1bd2:	4c3a      	ldr	r4, [pc, #232]	; (1cbc <main+0xb4c>)
    pmu_setting_temp_based(1);
    mrr_send_radio_data(1);
    pmu_setting_temp_based(0);
}

int main() {
    1bd4:	2100      	movs	r1, #0
	// mbus_write_message32(0xEF, lnt_counter_base);
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	uint32_t diff = xot_timer_list[i] - xo_sys_time_in_sec;
    1bd6:	008a      	lsls	r2, r1, #2
    1bd8:	5816      	ldr	r6, [r2, r0]
    1bda:	6827      	ldr	r7, [r4, #0]
    1bdc:	46b4      	mov	ip, r6
	// mbus_write_message32(0xB0 + i, diff);
        if(xot_timer_list[i] != 0 && diff <= end_time - xo_sys_time_in_sec) {
    1bde:	5816      	ldr	r6, [r2, r0]
    1be0:	2e00      	cmp	r6, #0
    1be2:	d00b      	beq.n	1bfc <main+0xa8c>
    1be4:	6826      	ldr	r6, [r4, #0]
	// mbus_write_message32(0xEF, lnt_counter_base);
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
	uint32_t diff = xot_timer_list[i] - xo_sys_time_in_sec;
    1be6:	4665      	mov	r5, ip
    1be8:	1bef      	subs	r7, r5, r7
	// mbus_write_message32(0xB0 + i, diff);
        if(xot_timer_list[i] != 0 && diff <= end_time - xo_sys_time_in_sec) {
    1bea:	1b9e      	subs	r6, r3, r6
    1bec:	42b7      	cmp	r7, r6
    1bee:	d805      	bhi.n	1bfc <main+0xa8c>
            xot_last_timer_list[i] = xot_timer_list[i];
    1bf0:	5816      	ldr	r6, [r2, r0]
    1bf2:	4d3f      	ldr	r5, [pc, #252]	; (1cf0 <main+0xb80>)
    1bf4:	5156      	str	r6, [r2, r5]
            xot_timer_list[i] = 0xFFFFFFFF;
    1bf6:	2601      	movs	r6, #1
    1bf8:	4276      	negs	r6, r6
    1bfa:	5016      	str	r6, [r2, r0]
    1bfc:	3101      	adds	r1, #1
        }
	// mbus_write_message32(0xEF, lnt_counter_base);
    }

    uint8_t i;
    for(i = 0; i < XOT_TIMER_LIST_LEN; i++) {
    1bfe:	2903      	cmp	r1, #3
    1c00:	d1e9      	bne.n	1bd6 <main+0xa66>
    // mbus_write_message32(0xE4, lnt_snt_mplier);
}

static void set_lnt_timer(uint32_t end_time) {
    // mbus_write_message32(0xCE, end_time);
    projected_end_time = end_time << XO_TO_SEC_SHIFT;
    1c02:	493d      	ldr	r1, [pc, #244]	; (1cf8 <main+0xb88>)
    1c04:	029a      	lsls	r2, r3, #10
    1c06:	600a      	str	r2, [r1, #0]

    if(end_time <= xo_sys_time_in_sec) {
    1c08:	492c      	ldr	r1, [pc, #176]	; (1cbc <main+0xb4c>)
    1c0a:	6808      	ldr	r0, [r1, #0]
    1c0c:	4283      	cmp	r3, r0
    1c0e:	d800      	bhi.n	1c12 <main+0xaa2>
        // sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
	end_time = xo_sys_time_in_sec + 20;
    1c10:	680b      	ldr	r3, [r1, #0]
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1c12:	4b3a      	ldr	r3, [pc, #232]	; (1cfc <main+0xb8c>)
    uint32_t val = temp >> (MPLIER_SHIFT + XO_TO_SEC_SHIFT - 2);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1c14:	2003      	movs	r0, #3
    if(end_time <= xo_sys_time_in_sec) {
        // sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
	end_time = xo_sys_time_in_sec + 20;
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1c16:	6819      	ldr	r1, [r3, #0]
    1c18:	4b39      	ldr	r3, [pc, #228]	; (1d00 <main+0xb90>)
    1c1a:	1a52      	subs	r2, r2, r1
    1c1c:	7819      	ldrb	r1, [r3, #0]
    uint32_t val = temp >> (MPLIER_SHIFT + XO_TO_SEC_SHIFT - 2);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    1c1e:	4b39      	ldr	r3, [pc, #228]	; (1d04 <main+0xb94>)
    if(end_time <= xo_sys_time_in_sec) {
        // sys_err(0x0);	// FIXME: remove this error message. Would rather have timing off than crash
	end_time = xo_sys_time_in_sec + 20;
    }

    uint64_t temp = (projected_end_time - xo_sys_time) * lnt_snt_mplier;
    1c20:	4351      	muls	r1, r2
    uint32_t val = temp >> (MPLIER_SHIFT + XO_TO_SEC_SHIFT - 2);
    // uint32_t val = (end_time - xo_sys_time_in_sec) * 4;
    lntv1a_r03.TIME_COUNTING = val;
    1c22:	681a      	ldr	r2, [r3, #0]
    1c24:	0b89      	lsrs	r1, r1, #14
    1c26:	0e12      	lsrs	r2, r2, #24
    1c28:	0612      	lsls	r2, r2, #24
    1c2a:	430a      	orrs	r2, r1
    1c2c:	601a      	str	r2, [r3, #0]
    mbus_remote_register_write(LNT_ADDR, 0x03, lntv1a_r03.as_int);
    1c2e:	681a      	ldr	r2, [r3, #0]
    1c30:	1c01      	adds	r1, r0, #0
    1c32:	f7fe faa2 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1c36:	4c34      	ldr	r4, [pc, #208]	; (1d08 <main+0xb98>)
    1c38:	2208      	movs	r2, #8
    1c3a:	7823      	ldrb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1c3c:	2100      	movs	r1, #0
    delay(MBUS_DELAY*10);
}

static void lnt_start() {
    // Release Reset 
    lntv1a_r00.RESET_AFE = 0x0; // Defhttps://www.dropbox.com/s/yh15ux4h8141vu4/ISSCC2019-Digest.pdf?dl=0ault : 0x1
    1c3e:	4393      	bics	r3, r2
    1c40:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.RESETN_DBE = 0x1; // Default : 0x0
    1c42:	7823      	ldrb	r3, [r4, #0]
    1c44:	2204      	movs	r2, #4
    1c46:	4313      	orrs	r3, r2
    1c48:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1c4a:	6822      	ldr	r2, [r4, #0]
    1c4c:	2003      	movs	r0, #3
    1c4e:	f7fe fa94 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1c52:	20fa      	movs	r0, #250	; 0xfa
    1c54:	0080      	lsls	r0, r0, #2
    1c56:	f7fe fa26 	bl	a6 <delay>
    
    // LNT Start
    lntv1a_r00.DBE_ENABLE = 0x1; // Default : 0x0
    1c5a:	7823      	ldrb	r3, [r4, #0]
    1c5c:	2210      	movs	r2, #16
    1c5e:	4313      	orrs	r3, r2
    1c60:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    1c62:	7823      	ldrb	r3, [r4, #0]
    1c64:	2540      	movs	r5, #64	; 0x40
    1c66:	43ab      	bics	r3, r5
    1c68:	7023      	strb	r3, [r4, #0]
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    1c6a:	7823      	ldrb	r3, [r4, #0]
    1c6c:	2220      	movs	r2, #32
    1c6e:	4393      	bics	r3, r2
    1c70:	7023      	strb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1c72:	6822      	ldr	r2, [r4, #0]
    1c74:	2100      	movs	r1, #0
    1c76:	2003      	movs	r0, #3
    1c78:	f7fe fa7f 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*10);
    1c7c:	20fa      	movs	r0, #250	; 0xfa
    1c7e:	0080      	lsls	r0, r0, #2
    1c80:	f7fe fa11 	bl	a6 <delay>

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1c84:	7823      	ldrb	r3, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1c86:	2003      	movs	r0, #3
    lntv1a_r00.WAKEUP_WHEN_DONE = 0x0; // Default : 0x0
    lntv1a_r00.MODE_CONTINUOUS = 0x0; // Default : 0x0
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    delay(MBUS_DELAY*10);

    lntv1a_r00.WAKEUP_WHEN_DONE = 0x1; // Default : 0x0
    1c88:	431d      	orrs	r5, r3
    1c8a:	7025      	strb	r5, [r4, #0]
    mbus_remote_register_write(LNT_ADDR,0x00,lntv1a_r00.as_int);
    1c8c:	6822      	ldr	r2, [r4, #0]
    1c8e:	2100      	movs	r1, #0
    1c90:	f7fe fa73 	bl	17a <mbus_remote_register_write>
    delay(MBUS_DELAY*100);
    1c94:	481d      	ldr	r0, [pc, #116]	; (1d0c <main+0xb9c>)
    1c96:	f7fe fa06 	bl	a6 <delay>
        }
    }

    set_lnt_timer(end_time);

    pmu_setting_temp_based(2);
    1c9a:	2002      	movs	r0, #2
    1c9c:	f7fe fba4 	bl	3e8 <pmu_setting_temp_based>
    1ca0:	e5bf      	b.n	1822 <main+0x6b2>
    1ca2:	46c0      	nop			; (mov r8, r8)
    1ca4:	00001ebc 	.word	0x00001ebc
    1ca8:	00001e70 	.word	0x00001e70
    1cac:	00001e15 	.word	0x00001e15
    1cb0:	00001e44 	.word	0x00001e44
    1cb4:	00001e00 	.word	0x00001e00
    1cb8:	00001de9 	.word	0x00001de9
    1cbc:	00001e88 	.word	0x00001e88
    1cc0:	0000038e 	.word	0x0000038e
    1cc4:	00001ea4 	.word	0x00001ea4
    1cc8:	00001e60 	.word	0x00001e60
    1ccc:	00001e10 	.word	0x00001e10
    1cd0:	00001e8c 	.word	0x00001e8c
    1cd4:	00001e9e 	.word	0x00001e9e
    1cd8:	00001e54 	.word	0x00001e54
    1cdc:	00001e48 	.word	0x00001e48
    1ce0:	00001e46 	.word	0x00001e46
    1ce4:	00001e45 	.word	0x00001e45
    1ce8:	000007ff 	.word	0x000007ff
    1cec:	00001e55 	.word	0x00001e55
    1cf0:	00001eac 	.word	0x00001eac
    1cf4:	00001ea6 	.word	0x00001ea6
    1cf8:	00001ea0 	.word	0x00001ea0
    1cfc:	00001e98 	.word	0x00001e98
    1d00:	00001e14 	.word	0x00001e14
    1d04:	00001df0 	.word	0x00001df0
    1d08:	00001dec 	.word	0x00001dec
    1d0c:	00002710 	.word	0x00002710
