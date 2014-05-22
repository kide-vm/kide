@ this is the gpio library as assmebler. Just as an idea of all the things needed. The c is at the end.
	.arch armv6
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 18, 4
	.file	"gpio.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.local	gGpioMap
	.comm	gGpioMap,4,4
	.local	pcbRev
	.comm	pcbRev,4,4
	.section	.rodata
	.align	2
.LC2:
	.ascii	"/dev/mem\000"
	.align	2
.LC3:
	.ascii	"gpio.c\000"
	.align	2
.LC4:
	.ascii	"open() failed. /dev/mem. errno %s.\000"
	.align	2
.LC5:
	.ascii	"mmap() failed. errno: %s.\000"
	.align	2
.LC6:
	.ascii	"close() failed. errno: %s.\000"
	.align	2
.LC7:
	.ascii	"/proc/cpuinfo\000"
	.align	2
.LC8:
	.ascii	"r\000"
	.align	2
.LC9:
	.ascii	"Revision\000"
	.align	2
.LC10:
	.ascii	"did not find revision in cpuinfo.\000"
	.align	2
.LC11:
	.ascii	"can't open /proc/cpuinfo. errno: %s.\000"
	.text
	.align	2
	.global	gpioSetup
	.type	gpioSetup, %function
gpioSetup:
.LFB0:
	.file 1 "gpio.c"
	.loc 1 45 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {r4, fp, lr}
.LCFI0:
	.cfi_def_cfa_offset 12
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	.cfi_offset 4, -12
	add	fp, sp, #8
.LCFI1:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #44
	.loc 1 46 0
	mov	r3, #0
	str	r3, [fp, #-20]
	.loc 1 47 0
	mov	r3, #1
	str	r3, [fp, #-16]
	.loc 1 49 0
	ldr	r0, .L13
	mov	r1, #2
	bl	open
	str	r0, [fp, #-20]
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bge	.L2
	.loc 1 51 0
	ldr	r3, .L13+4
	ldr	r4, [r3, #0]
	bl	__errno_location
	mov	r3, r0
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	strerror
	mov	r3, r0
	str	r3, [sp, #0]
	mov	r0, r4
	ldr	r1, .L13+8
	mov	r2, #51
	ldr	r3, .L13+12
	bl	dbgPrint
	.loc 1 52 0
	mov	r3, #5
	str	r3, [fp, #-16]
	b	.L3
.L2:
	.loc 1 55 0
	ldr	r3, [fp, #-20]
	str	r3, [sp, #0]
	ldr	r3, .L13+16
	str	r3, [sp, #4]
	mov	r0, #0
	mov	r1, #156
	mov	r2, #3
	mov	r3, #1
	bl	mmap
	mov	r2, r0
	ldr	r3, .L13+20
	str	r2, [r3, #0]
	ldr	r3, .L13+20
	ldr	r3, [r3, #0]
	cmn	r3, #1
	bne	.L4
	.loc 1 62 0
	ldr	r3, .L13+4
	ldr	r4, [r3, #0]
	bl	__errno_location
	mov	r3, r0
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	strerror
	mov	r3, r0
	str	r3, [sp, #0]
	mov	r0, r4
	ldr	r1, .L13+8
	mov	r2, #62
	ldr	r3, .L13+24
	bl	dbgPrint
	.loc 1 63 0
	mov	r3, #5
	str	r3, [fp, #-16]
	b	.L3
.L4:
	.loc 1 67 0
	ldr	r0, [fp, #-20]
	bl	close
	mov	r3, r0
	cmp	r3, #0
	beq	.L5
	.loc 1 69 0
	ldr	r3, .L13+4
	ldr	r4, [r3, #0]
	bl	__errno_location
	mov	r3, r0
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	strerror
	mov	r3, r0
	str	r3, [sp, #0]
	mov	r0, r4
	ldr	r1, .L13+8
	mov	r2, #69
	ldr	r3, .L13+28
	bl	dbgPrint
	.loc 1 70 0
	mov	r3, #5
	str	r3, [fp, #-16]
	b	.L3
.L5:
.LBB2:
	.loc 1 75 0
	ldr	r2, .L13+32
	ldr	r3, .L13+36
	mov	r0, r2
	mov	r1, r3
	bl	fopen
	str	r0, [fp, #-24]
	.loc 1 76 0
	ldr	r3, [fp, #-24]
	cmp	r3, #0
	beq	.L6
.LBB3:
	.loc 1 78 0
	mov	r3, #0
	str	r3, [fp, #-40]
	.loc 1 82 0
	b	.L7
.L9:
	.loc 1 84 0
	ldr	r3, [fp, #-40]
	mov	r0, r3
	ldr	r1, .L13+40
	bl	strstr
	mov	r2, r0
	ldr	r3, [fp, #-40]
	cmp	r2, r3
	bne	.L7
.LBB4:
	.loc 1 86 0
	ldr	r3, [fp, #-40]
	mov	r0, r3
	mov	r1, #58
	bl	strchr
	str	r0, [fp, #-32]
	.loc 1 87 0
	ldr	r3, [fp, #-32]
	cmp	r3, #0
	beq	.L7
.LBB5:
	.loc 1 89 0
	ldr	r3, [fp, #-32]
	add	r3, r3, #1
	mov	r0, r3
	mov	r1, #0
	mov	r2, #16
	bl	strtol
	str	r0, [fp, #-36]
	.loc 1 91 0
	ldr	r3, [fp, #-36]
	cmp	r3, #3
	bgt	.L8
	.loc 1 93 0
	ldr	r3, .L13+44
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L7
.L8:
	.loc 1 98 0
	ldr	r3, .L13+44
	mov	r2, #2
	str	r2, [r3, #0]
.L7:
.LBE5:
.LBE4:
	.loc 1 82 0 discriminator 1
	sub	r2, fp, #40
	sub	r3, fp, #44
	mov	r0, r2
	mov	r1, r3
	ldr	r2, [fp, #-24]
	bl	getline
	str	r0, [fp, #-28]
	ldr	r3, [fp, #-28]
	cmp	r3, #0
	bge	.L9
	.loc 1 103 0
	ldr	r3, .L13+44
	ldr	r3, [r3, #0]
	cmp	r3, #0
	beq	.L10
	.loc 1 105 0
	mov	r3, #0
	str	r3, [fp, #-16]
	b	.L11
.L10:
	.loc 1 109 0
	ldr	r3, .L13+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L13+8
	mov	r2, #109
	ldr	r3, .L13+48
	bl	dbgPrint
	.loc 1 110 0
	mov	r3, #5
	str	r3, [fp, #-16]
.L11:
	.loc 1 113 0
	ldr	r3, [fp, #-40]
	cmp	r3, #0
	beq	.L12
	.loc 1 115 0
	ldr	r3, [fp, #-40]
	mov	r0, r3
	bl	free
.L12:
	.loc 1 117 0
	ldr	r0, [fp, #-24]
	bl	fclose
	b	.L3
.L6:
.LBE3:
	.loc 1 121 0
	ldr	r3, .L13+4
	ldr	r4, [r3, #0]
	bl	__errno_location
	mov	r3, r0
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	strerror
	mov	r3, r0
	str	r3, [sp, #0]
	mov	r0, r4
	ldr	r1, .L13+8
	mov	r2, #121
	ldr	r3, .L13+52
	bl	dbgPrint
	.loc 1 122 0
	mov	r3, #5
	str	r3, [fp, #-16]
.L3:
.LBE2:
	.loc 1 126 0
	ldr	r3, [fp, #-16]
	.loc 1 127 0
	mov	r0, r3
	sub	sp, fp, #8
	ldmfd	sp!, {r4, fp, pc}
.L14:
	.align	2
.L13:
	.word	.LC2
	.word	stderr
	.word	.LC3
	.word	.LC4
	.word	538968064
	.word	gGpioMap
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LC9
	.word	pcbRev
	.word	.LC10
	.word	.LC11
	.cfi_endproc
.LFE0:
	.size	gpioSetup, .-gpioSetup
	.section	.rodata
	.align	2
.LC12:
	.ascii	"gGpioMap was NULL. Ensure gpioSetup() was called su"
	.ascii	"ccessfully.\000"
	.align	2
.LC13:
	.ascii	"mummap() failed. errno %s.\000"
	.text
	.align	2
	.global	gpioCleanup
	.type	gpioCleanup, %function
gpioCleanup:
.LFB1:
	.loc 1 135 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {r4, fp, lr}
.LCFI2:
	.cfi_def_cfa_offset 12
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	.cfi_offset 4, -12
	add	fp, sp, #8
.LCFI3:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #20
	.loc 1 136 0
	mov	r3, #1
	str	r3, [fp, #-16]
	.loc 1 138 0
	ldr	r3, .L19
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L16
	.loc 1 140 0
	ldr	r3, .L19+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L19+8
	mov	r2, #140
	ldr	r3, .L19+12
	bl	dbgPrint
	.loc 1 141 0
	mov	r3, #4
	str	r3, [fp, #-16]
	b	.L17
.L16:
	.loc 1 144 0
	ldr	r3, .L19
	ldr	r3, [r3, #0]
	mov	r0, r3
	mov	r1, #156
	bl	munmap
	mov	r3, r0
	cmp	r3, #0
	beq	.L18
	.loc 1 146 0
	ldr	r3, .L19+4
	ldr	r4, [r3, #0]
	bl	__errno_location
	mov	r3, r0
	ldr	r3, [r3, #0]
	mov	r0, r3
	bl	strerror
	mov	r3, r0
	str	r3, [sp, #0]
	mov	r0, r4
	ldr	r1, .L19+8
	mov	r2, #146
	ldr	r3, .L19+16
	bl	dbgPrint
	.loc 1 147 0
	mov	r3, #5
	str	r3, [fp, #-16]
	b	.L17
.L18:
	.loc 1 152 0
	ldr	r3, .L19
	mov	r2, #0
	str	r2, [r3, #0]
	.loc 1 153 0
	mov	r3, #0
	str	r3, [fp, #-16]
.L17:
	.loc 1 155 0
	ldr	r3, [fp, #-16]
	.loc 1 156 0
	mov	r0, r3
	sub	sp, fp, #8
	ldmfd	sp!, {r4, fp, pc}
.L20:
	.align	2
.L19:
	.word	gGpioMap
	.word	stderr
	.word	.LC3
	.word	.LC12
	.word	.LC13
	.cfi_endproc
.LFE1:
	.size	gpioCleanup, .-gpioCleanup
	.section	.rodata
	.align	2
.LC14:
	.ascii	"gGpioMap was NULL. Ensure gpioSetup() called succes"
	.ascii	"sfully.\000"
	.align	2
.LC15:
	.ascii	"eFunction was out of range. %d\000"
	.align	2
.LC16:
	.ascii	"gpioValidatePin() failed. Ensure pin %d is valid.\000"
	.text
	.align	2
	.global	gpioSetFunction
	.type	gpioSetFunction, %function
gpioSetFunction:
.LFB2:
	.loc 1 165 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
.LCFI4:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	add	fp, sp, #4
.LCFI5:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	.loc 1 166 0
	mov	r3, #1
	str	r3, [fp, #-8]
	.loc 1 168 0
	ldr	r3, .L26
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L22
	.loc 1 170 0
	ldr	r3, .L26+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L26+8
	mov	r2, #170
	ldr	r3, .L26+12
	bl	dbgPrint
	.loc 1 171 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L23
.L22:
	.loc 1 174 0
	ldr	r3, [fp, #-20]
	cmp	r3, #7
	bls	.L24
	.loc 1 176 0
	ldr	r3, .L26+4
	ldr	r3, [r3, #0]
	ldr	r2, [fp, #-20]
	str	r2, [sp, #0]
	mov	r0, r3
	ldr	r1, .L26+8
	mov	r2, #176
	ldr	r3, .L26+16
	bl	dbgPrint
	.loc 1 177 0
	mov	r3, #3
	str	r3, [fp, #-8]
	b	.L23
.L24:
	.loc 1 180 0
	ldr	r0, [fp, #-16]
	bl	gpioValidatePin
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	beq	.L25
	.loc 1 182 0
	ldr	r3, .L26+4
	ldr	r3, [r3, #0]
	ldr	r2, [fp, #-16]
	str	r2, [sp, #0]
	mov	r0, r3
	ldr	r1, .L26+8
	mov	r2, #182
	ldr	r3, .L26+20
	bl	dbgPrint
	b	.L23
.L25:
	.loc 1 189 0
	ldr	r3, .L26
	ldr	r1, [r3, #0]
	ldr	r3, [fp, #-16]
	ldr	r2, .L26+24
	smull	r0, r2, r2, r3
	mov	r2, r2, asr #2
	mov	r3, r3, asr #31
	rsb	r3, r3, r2
	mov	r2, r3
	mov	r2, r2, asl #2
	add	r0, r1, r2
	ldr	r2, .L26
	ldr	r2, [r2, #0]
	mov	r3, r3, asl #2
	add	r3, r2, r3
	ldr	ip, [r3, #0]
	ldr	r1, [fp, #-16]
	ldr	r3, .L26+24
	smull	r2, r3, r3, r1
	mov	r2, r3, asr #2
	mov	r3, r1, asr #31
	rsb	r2, r3, r2
	mov	r3, r2
	mov	r3, r3, asl #2
	add	r3, r3, r2
	mov	r3, r3, asl #1
	rsb	r2, r3, r1
	mov	r3, r2
	mov	r3, r3, asl #1
	add	r3, r3, r2
	mov	r2, #7
	mov	r3, r2, asl r3
	mvn	r3, r3
	and	r3, ip, r3
	str	r3, [r0, #0]
	.loc 1 192 0
	ldr	r3, .L26
	ldr	r1, [r3, #0]
	ldr	r3, [fp, #-16]
	ldr	r2, .L26+24
	smull	r0, r2, r2, r3
	mov	r2, r2, asr #2
	mov	r3, r3, asr #31
	rsb	r3, r3, r2
	mov	r2, r3
	mov	r2, r2, asl #2
	add	r0, r1, r2
	ldr	r2, .L26
	ldr	r2, [r2, #0]
	mov	r3, r3, asl #2
	add	r3, r2, r3
	ldr	ip, [r3, #0]
	ldr	r1, [fp, #-16]
	ldr	r3, .L26+24
	smull	r2, r3, r3, r1
	mov	r2, r3, asr #2
	mov	r3, r1, asr #31
	rsb	r2, r3, r2
	mov	r3, r2
	mov	r3, r3, asl #2
	add	r3, r3, r2
	mov	r3, r3, asl #1
	rsb	r2, r3, r1
	mov	r3, r2
	mov	r3, r3, asl #1
	add	r3, r3, r2
	ldr	r2, [fp, #-20]
	mov	r3, r2, asl r3
	orr	r3, ip, r3
	str	r3, [r0, #0]
	.loc 1 194 0
	mov	r3, #0
	str	r3, [fp, #-8]
.L23:
	.loc 1 197 0
	ldr	r3, [fp, #-8]
	.loc 1 198 0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L27:
	.align	2
.L26:
	.word	gGpioMap
	.word	stderr
	.word	.LC3
	.word	.LC14
	.word	.LC15
	.word	.LC16
	.word	1717986919
	.cfi_endproc
.LFE2:
	.size	gpioSetFunction, .-gpioSetFunction
	.section	.rodata
	.align	2
.LC17:
	.ascii	"state %d should have been %d or %d\000"
	.text
	.align	2
	.global	gpioSetPin
	.type	gpioSetPin, %function
gpioSetPin:
.LFB3:
	.loc 1 209 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
.LCFI6:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	add	fp, sp, #4
.LCFI7:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #32
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	.loc 1 210 0
	mov	r3, #1
	str	r3, [fp, #-8]
	.loc 1 212 0
	ldr	r3, .L34
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L29
	.loc 1 214 0
	ldr	r3, .L34+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L34+8
	mov	r2, #214
	ldr	r3, .L34+12
	bl	dbgPrint
	.loc 1 215 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L30
.L29:
	.loc 1 218 0
	ldr	r0, [fp, #-16]
	bl	gpioValidatePin
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	beq	.L31
	.loc 1 220 0
	ldr	r3, .L34+4
	ldr	r3, [r3, #0]
	ldr	r2, [fp, #-16]
	str	r2, [sp, #0]
	mov	r0, r3
	ldr	r1, .L34+8
	mov	r2, #220
	ldr	r3, .L34+16
	bl	dbgPrint
	b	.L30
.L31:
	.loc 1 223 0
	ldr	r3, [fp, #-20]
	cmp	r3, #1
	bne	.L32
	.loc 1 227 0
	ldr	r3, .L34
	ldr	r3, [r3, #0]
	add	r3, r3, #28
	mov	r1, #1
	ldr	r2, [fp, #-16]
	mov	r2, r1, asl r2
	str	r2, [r3, #0]
	.loc 1 228 0
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L30
.L32:
	.loc 1 231 0
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bne	.L33
	.loc 1 235 0
	ldr	r3, .L34
	ldr	r3, [r3, #0]
	add	r3, r3, #40
	mov	r1, #1
	ldr	r2, [fp, #-16]
	mov	r2, r1, asl r2
	str	r2, [r3, #0]
	.loc 1 236 0
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L30
.L33:
	.loc 1 241 0
	ldr	r3, .L34+4
	ldr	r3, [r3, #0]
	ldr	r2, [fp, #-20]
	str	r2, [sp, #0]
	mov	r2, #0
	str	r2, [sp, #4]
	mov	r2, #1
	str	r2, [sp, #8]
	mov	r0, r3
	ldr	r1, .L34+8
	mov	r2, #241
	ldr	r3, .L34+20
	bl	dbgPrint
	.loc 1 242 0
	mov	r3, #3
	str	r3, [fp, #-8]
.L30:
	.loc 1 245 0
	ldr	r3, [fp, #-8]
	.loc 1 246 0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L35:
	.align	2
.L34:
	.word	gGpioMap
	.word	stderr
	.word	.LC3
	.word	.LC12
	.word	.LC16
	.word	.LC17
	.cfi_endproc
.LFE3:
	.size	gpioSetPin, .-gpioSetPin
	.section	.rodata
	.align	2
.LC18:
	.ascii	"Parameter state was NULL.\000"
	.align	2
.LC19:
	.ascii	"gpioValidatePin() failed. Pin %d isn't valid.\000"
	.text
	.align	2
	.global	gpioReadPin
	.type	gpioReadPin, %function
gpioReadPin:
.LFB4:
	.loc 1 256 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
.LCFI8:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	add	fp, sp, #4
.LCFI9:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	.loc 1 257 0
	mov	r3, #1
	str	r3, [fp, #-8]
	.loc 1 259 0
	ldr	r3, .L43
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L37
	.loc 1 261 0
	ldr	r3, .L43+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L43+8
	ldr	r2, .L43+12
	ldr	r3, .L43+16
	bl	dbgPrint
	.loc 1 262 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L38
.L37:
	.loc 1 265 0
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bne	.L39
	.loc 1 267 0
	ldr	r3, .L43+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L43+8
	ldr	r2, .L43+20
	ldr	r3, .L43+24
	bl	dbgPrint
	.loc 1 268 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L38
.L39:
	.loc 1 271 0
	ldr	r0, [fp, #-16]
	bl	gpioValidatePin
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	beq	.L40
	.loc 1 273 0
	ldr	r3, .L43+4
	ldr	r3, [r3, #0]
	ldr	r2, [fp, #-16]
	str	r2, [sp, #0]
	mov	r0, r3
	ldr	r1, .L43+8
	ldr	r2, .L43+28
	ldr	r3, .L43+32
	bl	dbgPrint
	b	.L38
.L40:
	.loc 1 279 0
	ldr	r3, .L43
	ldr	r3, [r3, #0]
	add	r3, r3, #52
	ldr	r2, [r3, #0]
	mov	r1, #1
	ldr	r3, [fp, #-16]
	mov	r3, r1, asl r3
	and	r3, r2, r3
	cmp	r3, #0
	beq	.L41
	.loc 1 281 0
	ldr	r3, [fp, #-20]
	mov	r2, #1
	str	r2, [r3, #0]
	b	.L42
.L41:
	.loc 1 286 0
	ldr	r3, [fp, #-20]
	mov	r2, #0
	str	r2, [r3, #0]
.L42:
	.loc 1 289 0
	mov	r3, #0
	str	r3, [fp, #-8]
.L38:
	.loc 1 292 0
	ldr	r3, [fp, #-8]
	.loc 1 293 0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L44:
	.align	2
.L43:
	.word	gGpioMap
	.word	stderr
	.word	.LC3
	.word	261
	.word	.LC12
	.word	267
	.word	.LC18
	.word	273
	.word	.LC19
	.cfi_endproc
.LFE4:
	.size	gpioReadPin, .-gpioReadPin
	.section	.rodata
	.align	2
.LC20:
	.ascii	"resistorOption value: %d was out of range.\000"
	.text
	.align	2
	.global	gpioSetPullResistor
	.type	gpioSetPullResistor, %function
gpioSetPullResistor:
.LFB5:
	.loc 1 303 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
.LCFI10:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	add	fp, sp, #4
.LCFI11:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #32
	str	r0, [fp, #-24]
	str	r1, [fp, #-28]
	.loc 1 304 0
	mov	r3, #1
	str	r3, [fp, #-8]
	.loc 1 307 0
	ldr	r3, .L50
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L46
	.loc 1 309 0
	ldr	r3, .L50+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L50+8
	ldr	r2, .L50+12
	ldr	r3, .L50+16
	bl	dbgPrint
	.loc 1 310 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L47
.L46:
	.loc 1 313 0
	ldr	r0, [fp, #-24]
	bl	gpioValidatePin
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	beq	.L48
	.loc 1 315 0
	ldr	r3, .L50+4
	ldr	r3, [r3, #0]
	ldr	r2, [fp, #-24]
	str	r2, [sp, #0]
	mov	r0, r3
	ldr	r1, .L50+8
	ldr	r2, .L50+20
	ldr	r3, .L50+24
	bl	dbgPrint
	b	.L47
.L48:
	.loc 1 318 0
	ldr	r3, [fp, #-28]
	cmp	r3, #2
	bls	.L49
	.loc 1 320 0
	ldr	r3, .L50+4
	ldr	r3, [r3, #0]
	ldr	r2, [fp, #-28]
	str	r2, [sp, #0]
	mov	r0, r3
	ldr	r1, .L50+8
	mov	r2, #320
	ldr	r3, .L50+28
	bl	dbgPrint
	.loc 1 321 0
	mov	r3, #3
	str	r3, [fp, #-8]
	b	.L47
.L49:
	.loc 1 326 0
	mov	r3, #0
	str	r3, [fp, #-16]
	.loc 1 327 0
	mov	r3, #1000
	str	r3, [fp, #-12]
	.loc 1 330 0
	ldr	r3, .L50
	ldr	r3, [r3, #0]
	add	r3, r3, #148
	ldr	r2, [fp, #-28]
	str	r2, [r3, #0]
	.loc 1 332 0
	sub	r3, fp, #16
	mov	r0, r3
	mov	r1, #0
	bl	nanosleep
	.loc 1 334 0
	ldr	r3, .L50
	ldr	r3, [r3, #0]
	add	r3, r3, #152
	mov	r1, #1
	ldr	r2, [fp, #-24]
	mov	r2, r1, asl r2
	str	r2, [r3, #0]
	.loc 1 336 0
	sub	r3, fp, #16
	mov	r0, r3
	mov	r1, #0
	bl	nanosleep
	.loc 1 337 0
	ldr	r3, .L50
	ldr	r3, [r3, #0]
	add	r3, r3, #148
	mov	r2, #0
	str	r2, [r3, #0]
	.loc 1 338 0
	ldr	r3, .L50
	ldr	r3, [r3, #0]
	add	r3, r3, #152
	mov	r2, #0
	str	r2, [r3, #0]
	.loc 1 340 0
	mov	r3, #0
	str	r3, [fp, #-8]
.L47:
	.loc 1 344 0
	ldr	r3, [fp, #-8]
	.loc 1 345 0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L51:
	.align	2
.L50:
	.word	gGpioMap
	.word	stderr
	.word	.LC3
	.word	309
	.word	.LC12
	.word	315
	.word	.LC19
	.word	.LC20
	.cfi_endproc
.LFE5:
	.size	gpioSetPullResistor, .-gpioSetPullResistor
	.section	.rodata
	.align	2
.LC21:
	.ascii	"Parameter gpioNumberScl is NULL.\000"
	.align	2
.LC22:
	.ascii	"Parameter gpioNumberSda is NULL.\000"
	.text
	.align	2
	.global	gpioGetI2cPins
	.type	gpioGetI2cPins, %function
gpioGetI2cPins:
.LFB6:
	.loc 1 357 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
.LCFI12:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	add	fp, sp, #4
.LCFI13:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	.loc 1 358 0
	mov	r3, #1
	str	r3, [fp, #-8]
	.loc 1 360 0
	ldr	r3, .L58
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L53
	.loc 1 362 0
	ldr	r3, .L58+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L58+8
	ldr	r2, .L58+12
	ldr	r3, .L58+16
	bl	dbgPrint
	.loc 1 363 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L54
.L53:
	.loc 1 366 0
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bne	.L55
	.loc 1 368 0
	ldr	r3, .L58+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L58+8
	mov	r2, #368
	ldr	r3, .L58+20
	bl	dbgPrint
	.loc 1 369 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L54
.L55:
	.loc 1 372 0
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bne	.L56
	.loc 1 374 0
	ldr	r3, .L58+4
	ldr	r3, [r3, #0]
	mov	r0, r3
	ldr	r1, .L58+8
	ldr	r2, .L58+24
	ldr	r3, .L58+28
	bl	dbgPrint
	.loc 1 375 0
	mov	r3, #4
	str	r3, [fp, #-8]
	b	.L54
.L56:
	.loc 1 378 0
	ldr	r3, .L58+32
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L57
	.loc 1 380 0
	ldr	r3, [fp, #-16]
	mov	r2, #1
	str	r2, [r3, #0]
	.loc 1 381 0
	ldr	r3, [fp, #-20]
	mov	r2, #0
	str	r2, [r3, #0]
	.loc 1 382 0
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L54
.L57:
	.loc 1 385 0
	ldr	r3, .L58+32
	ldr	r3, [r3, #0]
	cmp	r3, #2
	bne	.L54
	.loc 1 387 0
	ldr	r3, [fp, #-16]
	mov	r2, #3
	str	r2, [r3, #0]
	.loc 1 388 0
	ldr	r3, [fp, #-20]
	mov	r2, #2
	str	r2, [r3, #0]
	.loc 1 389 0
	mov	r3, #0
	str	r3, [fp, #-8]
.L54:
	.loc 1 392 0
	ldr	r3, [fp, #-8]
	.loc 1 393 0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L59:
	.align	2
.L58:
	.word	gGpioMap
	.word	stderr
	.word	.LC3
	.word	362
	.word	.LC12
	.word	.LC21
	.word	374
	.word	.LC22
	.word	pcbRev
	.cfi_endproc
.LFE6:
	.size	gpioGetI2cPins, .-gpioGetI2cPins
	.section	.rodata
	.align	2
.LC23:
	.ascii	"InvalidError\000"
	.text
	.align	2
	.global	gpioErrToString
	.type	gpioErrToString, %function
gpioErrToString:
.LFB7:
	.loc 1 406 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
.LCFI14:
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0
.LCFI15:
	.cfi_def_cfa_register 11
	sub	sp, sp, #12
	str	r0, [fp, #-8]
	.loc 1 409 0
	ldr	r3, [fp, #-8]
	cmp	r3, #11
	bls	.L61
	.loc 1 411 0
	ldr	r3, .L63
	b	.L62
.L61:
	.loc 1 416 0
	ldr	r3, .L63+4
	ldr	r2, [fp, #-8]
	ldr	r3, [r3, r2, asl #2]
.L62:
	.loc 1 418 0
	mov	r0, r3
	add	sp, fp, #0
	ldmfd	sp!, {fp}
	bx	lr
.L64:
	.align	2
.L63:
	.word	.LC23
	.word	errorString.3344
	.cfi_endproc
.LFE7:
	.size	gpioErrToString, .-gpioErrToString
	.section	.rodata
	.align	2
.LC24:
	.ascii	"[%s:%d] \000"
	.align	2
.LC25:
	.ascii	"\012\000"
	.text
	.align	2
	.global	dbgPrint
	.type	dbgPrint, %function
dbgPrint:
.LFB8:
	.loc 1 440 0
	.cfi_startproc
	@ args = 4, pretend = 4, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 1
	str	r3, [sp, #-4]!
.LCFI16:
	.cfi_def_cfa_offset 4
	.cfi_offset 3, -4
	stmfd	sp!, {fp, lr}
.LCFI17:
	.cfi_def_cfa_offset 12
	.cfi_offset 14, -8
	.cfi_offset 11, -12
	add	fp, sp, #4
.LCFI18:
	.cfi_def_cfa 11, 8
	sub	sp, sp, #36
	str	r0, [fp, #-28]
	str	r1, [fp, #-32]
	str	r2, [fp, #-36]
	.loc 1 442 0
	mov	r3, #0
	str	r3, [fp, #-12]
	.loc 1 443 0
	mov	r3, #0
	str	r3, [fp, #-16]
	.loc 1 445 0
	ldr	r3, [fp, #-28]
	cmp	r3, #0
	beq	.L66
	.loc 1 447 0
	ldr	r3, .L71
	ldr	r0, [fp, #-28]
	mov	r1, r3
	ldr	r2, [fp, #-32]
	ldr	r3, [fp, #-36]
	bl	fprintf
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bge	.L67
	.loc 1 449 0
	ldr	r3, [fp, #-16]
	b	.L68
.L67:
	.loc 1 451 0
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	str	r3, [fp, #-12]
	.loc 1 453 0
	add	r3, fp, #8
	str	r3, [fp, #-20]
	.loc 1 454 0
	ldr	r0, [fp, #-28]
	ldr	r1, [fp, #4]
	ldr	r2, [fp, #-20]
	bl	vfprintf
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bge	.L69
	.loc 1 456 0
	ldr	r3, [fp, #-16]
	b	.L68
.L69:
	.loc 1 458 0
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	str	r3, [fp, #-12]
	.loc 1 461 0
	ldr	r3, .L71+4
	ldr	r0, [fp, #-28]
	mov	r1, r3
	bl	fprintf
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bge	.L70
	.loc 1 463 0
	ldr	r3, [fp, #-16]
	b	.L68
.L70:
	.loc 1 465 0
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	str	r3, [fp, #-12]
.L66:
	.loc 1 468 0
	ldr	r3, [fp, #-12]
.L68:
	.loc 1 469 0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, lr}
	add	sp, sp, #4
	bx	lr
.L72:
	.align	2
.L71:
	.word	.LC24
	.word	.LC25
	.cfi_endproc
.LFE8:
	.size	dbgPrint, .-dbgPrint
	.section	.rodata
	.align	2
.LC0:
	.word	0
	.word	1
	.word	4
	.word	7
	.word	8
	.word	9
	.word	10
	.word	11
	.word	14
	.word	15
	.word	17
	.word	18
	.word	21
	.word	22
	.word	23
	.word	24
	.word	25
	.align	2
.LC1:
	.word	2
	.word	3
	.word	4
	.word	7
	.word	8
	.word	9
	.word	10
	.word	11
	.word	14
	.word	15
	.word	17
	.word	18
	.word	22
	.word	23
	.word	24
	.word	25
	.word	27
	.text
	.align	2
	.type	gpioValidatePin, %function
gpioValidatePin:
.LFB9:
	.loc 1 481 0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
.LCFI19:
	.cfi_def_cfa_offset 8
	.cfi_offset 14, -4
	.cfi_offset 11, -8
	add	fp, sp, #4
.LCFI20:
	.cfi_def_cfa 11, 4
	sub	sp, sp, #88
	str	r0, [fp, #-88]
	.loc 1 482 0
	mov	r3, #2
	str	r3, [fp, #-8]
	.loc 1 483 0
	mov	r3, #0
	str	r3, [fp, #-12]
	.loc 1 490 0
	ldr	r3, .L81
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L74
	.loc 1 492 0
	ldr	r3, .L81+4
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L75
	.loc 1 494 0
	mov	r3, #3
	str	r3, [fp, #-8]
	b	.L74
.L75:
	.loc 1 497 0
	ldr	r3, .L81+4
	ldr	r3, [r3, #0]
	cmp	r3, #1
	bne	.L76
.LBB6:
	.loc 1 499 0
	ldr	r3, .L81+8
	sub	r1, fp, #80
	mov	r2, r3
	mov	r3, #68
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	memcpy
	.loc 1 500 0
	ldr	r2, .L81+12
	sub	r3, fp, #80
	mov	r1, r2
	mov	r2, r3
	mov	r3, #68
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	memcpy
	.loc 1 501 0
	ldr	r3, .L81
	mov	r2, #17
	str	r2, [r3, #0]
	b	.L74
.L76:
.LBE6:
	.loc 1 503 0
	ldr	r3, .L81+4
	ldr	r3, [r3, #0]
	cmp	r3, #2
	bne	.L74
.LBB7:
	.loc 1 505 0
	ldr	r3, .L81+16
	sub	r1, fp, #80
	mov	r2, r3
	mov	r3, #68
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	memcpy
	.loc 1 506 0
	ldr	r2, .L81+12
	sub	r3, fp, #80
	mov	r1, r2
	mov	r2, r3
	mov	r3, #68
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	memcpy
	.loc 1 507 0
	ldr	r3, .L81
	mov	r2, #17
	str	r2, [r3, #0]
.L74:
.LBE7:
	.loc 1 511 0
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L77
.L80:
	.loc 1 513 0
	ldr	r2, [fp, #-88]
	ldr	r3, .L81+12
	ldr	r1, [fp, #-12]
	ldr	r3, [r3, r1, asl #2]
	cmp	r2, r3
	bne	.L78
	.loc 1 515 0
	mov	r3, #0
	str	r3, [fp, #-8]
	.loc 1 516 0
	b	.L79
.L78:
	.loc 1 511 0
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L77:
	.loc 1 511 0 is_stmt 0 discriminator 1
	ldr	r2, [fp, #-12]
	ldr	r3, .L81
	ldr	r3, [r3, #0]
	cmp	r2, r3
	bcc	.L80
.L79:
	.loc 1 520 0 is_stmt 1
	ldr	r3, [fp, #-8]
	.loc 1 521 0
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L82:
	.align	2
.L81:
	.word	pinCnt.3360
	.word	pcbRev
	.word	.LC0
	.word	validPins.3359
	.word	.LC1
	.cfi_endproc
.LFE9:
	.size	gpioValidatePin, .-gpioValidatePin
	.local	pinCnt.3360
	.comm	pinCnt.3360,4,4
	.local	validPins.3359
	.comm	validPins.3359,68,4
	.section	.rodata
	.align	2
.LC26:
	.ascii	"OK\000"
	.align	2
.LC27:
	.ascii	"ERROR_DEFAULT\000"
	.align	2
.LC28:
	.ascii	"ERROR_INVALID_PIN_NUMBER\000"
	.align	2
.LC29:
	.ascii	"ERROR_RANGE\000"
	.align	2
.LC30:
	.ascii	"ERROR_NULL\000"
	.align	2
.LC31:
	.ascii	"ERROR_EXTERNAL\000"
	.align	2
.LC32:
	.ascii	"ERROR_NOT_INITIALISED\000"
	.align	2
.LC33:
	.ascii	"ERROR_ALREADY_INITIALISED\000"
	.align	2
.LC34:
	.ascii	"ERROR_I2C_NACK\000"
	.align	2
.LC35:
	.ascii	"ERROR_I2C\000"
	.align	2
.LC36:
	.ascii	"ERROR_I2C_CLK_TIMEOUT\000"
	.align	2
.LC37:
	.ascii	"ERROR_INVALID_BSC\000"
	.data
	.align	2
	.type	errorString.3344, %object
	.size	errorString.3344, 48
errorString.3344:
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC33
	.word	.LC34
	.word	.LC35
	.word	.LC36
	.word	.LC37
	.text
.Letext0:
	.file 2 "/usr/lib/gcc/arm-linux-gnueabihf/4.6/include/stddef.h"
	.file 3 "/usr/include/arm-linux-gnueabihf/bits/types.h"
	.file 4 "/usr/include/stdio.h"
	.file 5 "/usr/include/libio.h"
	.file 6 "/usr/lib/gcc/arm-linux-gnueabihf/4.6/include/stdarg.h"
	.file 7 "<built-in>"
	.file 8 "/usr/include/stdint.h"
	.file 9 "../include/rpiGpio.h"
	.file 10 "/usr/include/time.h"
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0x8d5
	.2byte	0x2
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF128
	.byte	0x1
	.4byte	.LASF129
	.4byte	.LASF130
	.4byte	.Ltext0
	.4byte	.Letext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.4byte	.LASF8
	.byte	0x2
	.byte	0xd4
	.4byte	0x30
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF0
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF1
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.4byte	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.4byte	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.4byte	.LASF5
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.4byte	.LASF7
	.uleb128 0x2
	.4byte	.LASF9
	.byte	0x3
	.byte	0x38
	.4byte	0x61
	.uleb128 0x2
	.4byte	.LASF10
	.byte	0x3
	.byte	0x8d
	.4byte	0x85
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.4byte	.LASF11
	.uleb128 0x2
	.4byte	.LASF12
	.byte	0x3
	.byte	0x8e
	.4byte	0x6f
	.uleb128 0x2
	.4byte	.LASF13
	.byte	0x3
	.byte	0x95
	.4byte	0x85
	.uleb128 0x5
	.byte	0x4
	.uleb128 0x2
	.4byte	.LASF14
	.byte	0x3
	.byte	0xb4
	.4byte	0x5a
	.uleb128 0x6
	.byte	0x4
	.4byte	0xb5
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF15
	.uleb128 0x2
	.4byte	.LASF16
	.byte	0x4
	.byte	0x31
	.4byte	0xc7
	.uleb128 0x7
	.4byte	.LASF47
	.byte	0x98
	.byte	0x5
	.2byte	0x10f
	.4byte	0x288
	.uleb128 0x8
	.4byte	.LASF17
	.byte	0x5
	.2byte	0x110
	.4byte	0x5a
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x8
	.4byte	.LASF18
	.byte	0x5
	.2byte	0x115
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0x8
	.4byte	.LASF19
	.byte	0x5
	.2byte	0x116
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0x8
	.4byte	.LASF20
	.byte	0x5
	.2byte	0x117
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0x8
	.4byte	.LASF21
	.byte	0x5
	.2byte	0x118
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x10
	.uleb128 0x8
	.4byte	.LASF22
	.byte	0x5
	.2byte	0x119
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x14
	.uleb128 0x8
	.4byte	.LASF23
	.byte	0x5
	.2byte	0x11a
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x18
	.uleb128 0x8
	.4byte	.LASF24
	.byte	0x5
	.2byte	0x11b
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x1c
	.uleb128 0x8
	.4byte	.LASF25
	.byte	0x5
	.2byte	0x11c
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x20
	.uleb128 0x8
	.4byte	.LASF26
	.byte	0x5
	.2byte	0x11e
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x24
	.uleb128 0x8
	.4byte	.LASF27
	.byte	0x5
	.2byte	0x11f
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x28
	.uleb128 0x8
	.4byte	.LASF28
	.byte	0x5
	.2byte	0x120
	.4byte	0xaf
	.byte	0x2
	.byte	0x23
	.uleb128 0x2c
	.uleb128 0x8
	.4byte	.LASF29
	.byte	0x5
	.2byte	0x122
	.4byte	0x2eb
	.byte	0x2
	.byte	0x23
	.uleb128 0x30
	.uleb128 0x8
	.4byte	.LASF30
	.byte	0x5
	.2byte	0x124
	.4byte	0x2f1
	.byte	0x2
	.byte	0x23
	.uleb128 0x34
	.uleb128 0x8
	.4byte	.LASF31
	.byte	0x5
	.2byte	0x126
	.4byte	0x5a
	.byte	0x2
	.byte	0x23
	.uleb128 0x38
	.uleb128 0x8
	.4byte	.LASF32
	.byte	0x5
	.2byte	0x12a
	.4byte	0x5a
	.byte	0x2
	.byte	0x23
	.uleb128 0x3c
	.uleb128 0x8
	.4byte	.LASF33
	.byte	0x5
	.2byte	0x12c
	.4byte	0x7a
	.byte	0x2
	.byte	0x23
	.uleb128 0x40
	.uleb128 0x8
	.4byte	.LASF34
	.byte	0x5
	.2byte	0x130
	.4byte	0x3e
	.byte	0x2
	.byte	0x23
	.uleb128 0x44
	.uleb128 0x8
	.4byte	.LASF35
	.byte	0x5
	.2byte	0x131
	.4byte	0x4c
	.byte	0x2
	.byte	0x23
	.uleb128 0x46
	.uleb128 0x8
	.4byte	.LASF36
	.byte	0x5
	.2byte	0x132
	.4byte	0x2f7
	.byte	0x2
	.byte	0x23
	.uleb128 0x47
	.uleb128 0x8
	.4byte	.LASF37
	.byte	0x5
	.2byte	0x136
	.4byte	0x307
	.byte	0x2
	.byte	0x23
	.uleb128 0x48
	.uleb128 0x8
	.4byte	.LASF38
	.byte	0x5
	.2byte	0x13f
	.4byte	0x8c
	.byte	0x2
	.byte	0x23
	.uleb128 0x50
	.uleb128 0x8
	.4byte	.LASF39
	.byte	0x5
	.2byte	0x148
	.4byte	0xa2
	.byte	0x2
	.byte	0x23
	.uleb128 0x58
	.uleb128 0x8
	.4byte	.LASF40
	.byte	0x5
	.2byte	0x149
	.4byte	0xa2
	.byte	0x2
	.byte	0x23
	.uleb128 0x5c
	.uleb128 0x8
	.4byte	.LASF41
	.byte	0x5
	.2byte	0x14a
	.4byte	0xa2
	.byte	0x2
	.byte	0x23
	.uleb128 0x60
	.uleb128 0x8
	.4byte	.LASF42
	.byte	0x5
	.2byte	0x14b
	.4byte	0xa2
	.byte	0x2
	.byte	0x23
	.uleb128 0x64
	.uleb128 0x8
	.4byte	.LASF43
	.byte	0x5
	.2byte	0x14c
	.4byte	0x25
	.byte	0x2
	.byte	0x23
	.uleb128 0x68
	.uleb128 0x8
	.4byte	.LASF44
	.byte	0x5
	.2byte	0x14e
	.4byte	0x5a
	.byte	0x2
	.byte	0x23
	.uleb128 0x6c
	.uleb128 0x8
	.4byte	.LASF45
	.byte	0x5
	.2byte	0x150
	.4byte	0x30d
	.byte	0x2
	.byte	0x23
	.uleb128 0x70
	.byte	0
	.uleb128 0x2
	.4byte	.LASF46
	.byte	0x6
	.byte	0x28
	.4byte	0x293
	.uleb128 0x9
	.4byte	.LASF48
	.byte	0x4
	.byte	0x7
	.byte	0
	.4byte	0x2ad
	.uleb128 0xa
	.4byte	.LASF131
	.4byte	0xa2
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.byte	0x1
	.byte	0
	.uleb128 0xb
	.4byte	.LASF132
	.byte	0x5
	.byte	0xb4
	.uleb128 0x9
	.4byte	.LASF49
	.byte	0xc
	.byte	0x5
	.byte	0xba
	.4byte	0x2eb
	.uleb128 0xc
	.4byte	.LASF50
	.byte	0x5
	.byte	0xbb
	.4byte	0x2eb
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xc
	.4byte	.LASF51
	.byte	0x5
	.byte	0xbc
	.4byte	0x2f1
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0xc
	.4byte	.LASF52
	.byte	0x5
	.byte	0xc0
	.4byte	0x5a
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x2b4
	.uleb128 0x6
	.byte	0x4
	.4byte	0xc7
	.uleb128 0xd
	.4byte	0xb5
	.4byte	0x307
	.uleb128 0xe
	.4byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x2ad
	.uleb128 0xd
	.4byte	0xb5
	.4byte	0x31d
	.uleb128 0xe
	.4byte	0x30
	.byte	0x27
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x323
	.uleb128 0xf
	.4byte	0xb5
	.uleb128 0x2
	.4byte	.LASF53
	.byte	0x4
	.byte	0x50
	.4byte	0x288
	.uleb128 0x2
	.4byte	.LASF54
	.byte	0x4
	.byte	0x67
	.4byte	0xa4
	.uleb128 0x2
	.4byte	.LASF55
	.byte	0x8
	.byte	0x34
	.4byte	0x30
	.uleb128 0x10
	.byte	0x4
	.byte	0x9
	.byte	0x3f
	.4byte	0x39f
	.uleb128 0x11
	.ascii	"OK\000"
	.sleb128 0
	.uleb128 0x12
	.4byte	.LASF56
	.sleb128 1
	.uleb128 0x12
	.4byte	.LASF57
	.sleb128 2
	.uleb128 0x12
	.4byte	.LASF58
	.sleb128 3
	.uleb128 0x12
	.4byte	.LASF59
	.sleb128 4
	.uleb128 0x12
	.4byte	.LASF60
	.sleb128 5
	.uleb128 0x12
	.4byte	.LASF61
	.sleb128 6
	.uleb128 0x12
	.4byte	.LASF62
	.sleb128 7
	.uleb128 0x12
	.4byte	.LASF63
	.sleb128 8
	.uleb128 0x12
	.4byte	.LASF64
	.sleb128 9
	.uleb128 0x12
	.4byte	.LASF65
	.sleb128 10
	.uleb128 0x12
	.4byte	.LASF66
	.sleb128 11
	.uleb128 0x12
	.4byte	.LASF67
	.sleb128 12
	.byte	0
	.uleb128 0x2
	.4byte	.LASF68
	.byte	0x9
	.byte	0x42
	.4byte	0x349
	.uleb128 0x10
	.byte	0x4
	.byte	0x9
	.byte	0x45
	.4byte	0x3bf
	.uleb128 0x11
	.ascii	"low\000"
	.sleb128 0
	.uleb128 0x12
	.4byte	.LASF69
	.sleb128 1
	.byte	0
	.uleb128 0x2
	.4byte	.LASF70
	.byte	0x9
	.byte	0x48
	.4byte	0x3aa
	.uleb128 0x10
	.byte	0x4
	.byte	0x9
	.byte	0x4b
	.4byte	0x3e5
	.uleb128 0x12
	.4byte	.LASF71
	.sleb128 0
	.uleb128 0x12
	.4byte	.LASF72
	.sleb128 1
	.uleb128 0x12
	.4byte	.LASF73
	.sleb128 2
	.byte	0
	.uleb128 0x2
	.4byte	.LASF74
	.byte	0x9
	.byte	0x4f
	.4byte	0x3ca
	.uleb128 0x10
	.byte	0x4
	.byte	0x9
	.byte	0x55
	.4byte	0x435
	.uleb128 0x12
	.4byte	.LASF75
	.sleb128 0
	.uleb128 0x12
	.4byte	.LASF76
	.sleb128 1
	.uleb128 0x12
	.4byte	.LASF77
	.sleb128 4
	.uleb128 0x12
	.4byte	.LASF78
	.sleb128 5
	.uleb128 0x12
	.4byte	.LASF79
	.sleb128 6
	.uleb128 0x12
	.4byte	.LASF80
	.sleb128 7
	.uleb128 0x12
	.4byte	.LASF81
	.sleb128 3
	.uleb128 0x12
	.4byte	.LASF82
	.sleb128 2
	.uleb128 0x12
	.4byte	.LASF83
	.sleb128 0
	.uleb128 0x12
	.4byte	.LASF84
	.sleb128 7
	.byte	0
	.uleb128 0x2
	.4byte	.LASF85
	.byte	0x9
	.byte	0x60
	.4byte	0x3f0
	.uleb128 0x10
	.byte	0x4
	.byte	0x9
	.byte	0x8f
	.4byte	0x45b
	.uleb128 0x12
	.4byte	.LASF86
	.sleb128 0
	.uleb128 0x12
	.4byte	.LASF87
	.sleb128 1
	.uleb128 0x12
	.4byte	.LASF88
	.sleb128 2
	.byte	0
	.uleb128 0x2
	.4byte	.LASF89
	.byte	0x9
	.byte	0x93
	.4byte	0x440
	.uleb128 0x6
	.byte	0x4
	.4byte	0x5a
	.uleb128 0x9
	.4byte	.LASF90
	.byte	0x8
	.byte	0xa
	.byte	0x78
	.4byte	0x495
	.uleb128 0xc
	.4byte	.LASF91
	.byte	0xa
	.byte	0x7a
	.4byte	0x97
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xc
	.4byte	.LASF92
	.byte	0xa
	.byte	0x7b
	.4byte	0x85
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.byte	0
	.uleb128 0x13
	.byte	0x1
	.4byte	.LASF98
	.byte	0x1
	.byte	0x2c
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB0
	.4byte	.LFE0
	.4byte	.LLST0
	.4byte	0x54b
	.uleb128 0x14
	.4byte	.LASF93
	.byte	0x1
	.byte	0x2e
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x15
	.ascii	"rtn\000"
	.byte	0x1
	.byte	0x2f
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x16
	.4byte	.LBB2
	.4byte	.LBE2
	.uleb128 0x14
	.4byte	.LASF94
	.byte	0x1
	.byte	0x4b
	.4byte	0x54b
	.byte	0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x16
	.4byte	.LBB3
	.4byte	.LBE3
	.uleb128 0x14
	.4byte	.LASF95
	.byte	0x1
	.byte	0x4e
	.4byte	0xaf
	.byte	0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x14
	.4byte	.LASF96
	.byte	0x1
	.byte	0x4f
	.4byte	0x333
	.byte	0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x15
	.ascii	"foo\000"
	.byte	0x1
	.byte	0x50
	.4byte	0x25
	.byte	0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x16
	.4byte	.LBB4
	.4byte	.LBE4
	.uleb128 0x15
	.ascii	"rev\000"
	.byte	0x1
	.byte	0x56
	.4byte	0xaf
	.byte	0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x16
	.4byte	.LBB5
	.4byte	.LBE5
	.uleb128 0x14
	.4byte	.LASF97
	.byte	0x1
	.byte	0x59
	.4byte	0x85
	.byte	0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0xbc
	.uleb128 0x13
	.byte	0x1
	.4byte	.LASF99
	.byte	0x1
	.byte	0x86
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB1
	.4byte	.LFE1
	.4byte	.LLST1
	.4byte	0x57d
	.uleb128 0x15
	.ascii	"rtn\000"
	.byte	0x1
	.byte	0x88
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x13
	.byte	0x1
	.4byte	.LASF100
	.byte	0x1
	.byte	0xa4
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB2
	.4byte	.LFE2
	.4byte	.LLST2
	.4byte	0x5c5
	.uleb128 0x17
	.4byte	.LASF101
	.byte	0x1
	.byte	0xa4
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x17
	.4byte	.LASF102
	.byte	0x1
	.byte	0xa4
	.4byte	0x435
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x15
	.ascii	"rtn\000"
	.byte	0x1
	.byte	0xa6
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x13
	.byte	0x1
	.4byte	.LASF103
	.byte	0x1
	.byte	0xd0
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB3
	.4byte	.LFE3
	.4byte	.LLST3
	.4byte	0x60d
	.uleb128 0x17
	.4byte	.LASF101
	.byte	0x1
	.byte	0xd0
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x17
	.4byte	.LASF104
	.byte	0x1
	.byte	0xd0
	.4byte	0x3bf
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x15
	.ascii	"rtn\000"
	.byte	0x1
	.byte	0xd2
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x13
	.byte	0x1
	.4byte	.LASF105
	.byte	0x1
	.byte	0xff
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB4
	.4byte	.LFE4
	.4byte	.LLST4
	.4byte	0x656
	.uleb128 0x17
	.4byte	.LASF101
	.byte	0x1
	.byte	0xff
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x17
	.4byte	.LASF104
	.byte	0x1
	.byte	0xff
	.4byte	0x656
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x18
	.ascii	"rtn\000"
	.byte	0x1
	.2byte	0x101
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.4byte	0x3bf
	.uleb128 0x19
	.byte	0x1
	.4byte	.LASF106
	.byte	0x1
	.2byte	0x12e
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB5
	.4byte	.LFE5
	.4byte	.LLST5
	.4byte	0x6b7
	.uleb128 0x1a
	.4byte	.LASF101
	.byte	0x1
	.2byte	0x12e
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x1a
	.4byte	.LASF107
	.byte	0x1
	.2byte	0x12e
	.4byte	0x3e5
	.byte	0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x18
	.ascii	"rtn\000"
	.byte	0x1
	.2byte	0x130
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x1b
	.4byte	.LASF108
	.byte	0x1
	.2byte	0x131
	.4byte	0x46c
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x19
	.byte	0x1
	.4byte	.LASF109
	.byte	0x1
	.2byte	0x164
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB6
	.4byte	.LFE6
	.4byte	.LLST6
	.4byte	0x703
	.uleb128 0x1a
	.4byte	.LASF110
	.byte	0x1
	.2byte	0x164
	.4byte	0x466
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x1a
	.4byte	.LASF111
	.byte	0x1
	.2byte	0x164
	.4byte	0x466
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x18
	.ascii	"rtn\000"
	.byte	0x1
	.2byte	0x166
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x19
	.byte	0x1
	.4byte	.LASF112
	.byte	0x1
	.2byte	0x195
	.byte	0x1
	.4byte	0x31d
	.4byte	.LFB7
	.4byte	.LFE7
	.4byte	.LLST7
	.4byte	0x743
	.uleb128 0x1a
	.4byte	.LASF113
	.byte	0x1
	.2byte	0x195
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x1b
	.4byte	.LASF114
	.byte	0x1
	.2byte	0x197
	.4byte	0x743
	.byte	0x5
	.byte	0x3
	.4byte	errorString.3344
	.byte	0
	.uleb128 0xd
	.4byte	0x31d
	.4byte	0x753
	.uleb128 0xe
	.4byte	0x30
	.byte	0xb
	.byte	0
	.uleb128 0x19
	.byte	0x1
	.4byte	.LASF115
	.byte	0x1
	.2byte	0x1b7
	.byte	0x1
	.4byte	0x5a
	.4byte	.LFB8
	.4byte	.LFE8
	.4byte	.LLST8
	.4byte	0x7dc
	.uleb128 0x1a
	.4byte	.LASF116
	.byte	0x1
	.2byte	0x1b7
	.4byte	0x54b
	.byte	0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x1a
	.4byte	.LASF117
	.byte	0x1
	.2byte	0x1b7
	.4byte	0x31d
	.byte	0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x1a
	.4byte	.LASF95
	.byte	0x1
	.2byte	0x1b7
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x1a
	.4byte	.LASF118
	.byte	0x1
	.2byte	0x1b7
	.4byte	0x31d
	.byte	0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x1c
	.uleb128 0x1b
	.4byte	.LASF119
	.byte	0x1
	.2byte	0x1b9
	.4byte	0x328
	.byte	0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x18
	.ascii	"rtn\000"
	.byte	0x1
	.2byte	0x1ba
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x1b
	.4byte	.LASF120
	.byte	0x1
	.2byte	0x1bb
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x1d
	.4byte	.LASF133
	.byte	0x1
	.2byte	0x1e0
	.byte	0x1
	.4byte	0x39f
	.4byte	.LFB9
	.4byte	.LFE9
	.4byte	.LLST9
	.4byte	0x884
	.uleb128 0x1a
	.4byte	.LASF101
	.byte	0x1
	.2byte	0x1e0
	.4byte	0x5a
	.byte	0x3
	.byte	0x91
	.sleb128 -92
	.uleb128 0x18
	.ascii	"rtn\000"
	.byte	0x1
	.2byte	0x1e2
	.4byte	0x39f
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x1b
	.4byte	.LASF121
	.byte	0x1
	.2byte	0x1e3
	.4byte	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x1b
	.4byte	.LASF122
	.byte	0x1
	.2byte	0x1e7
	.4byte	0x884
	.byte	0x5
	.byte	0x3
	.4byte	validPins.3359
	.uleb128 0x1b
	.4byte	.LASF123
	.byte	0x1
	.2byte	0x1e8
	.4byte	0x33e
	.byte	0x5
	.byte	0x3
	.4byte	pinCnt.3360
	.uleb128 0x1e
	.4byte	.LBB6
	.4byte	.LBE6
	.4byte	0x869
	.uleb128 0x1b
	.4byte	.LASF124
	.byte	0x1
	.2byte	0x1f3
	.4byte	0x894
	.byte	0x3
	.byte	0x91
	.sleb128 -84
	.byte	0
	.uleb128 0x16
	.4byte	.LBB7
	.4byte	.LBE7
	.uleb128 0x1b
	.4byte	.LASF125
	.byte	0x1
	.2byte	0x1f9
	.4byte	0x899
	.byte	0x3
	.byte	0x91
	.sleb128 -84
	.byte	0
	.byte	0
	.uleb128 0xd
	.4byte	0x33e
	.4byte	0x894
	.uleb128 0xe
	.4byte	0x30
	.byte	0x10
	.byte	0
	.uleb128 0xf
	.4byte	0x884
	.uleb128 0xf
	.4byte	0x884
	.uleb128 0x14
	.4byte	.LASF126
	.byte	0x1
	.byte	0x23
	.4byte	0x8af
	.byte	0x5
	.byte	0x3
	.4byte	gGpioMap
	.uleb128 0x6
	.byte	0x4
	.4byte	0x8b5
	.uleb128 0x1f
	.4byte	0x33e
	.uleb128 0x14
	.4byte	.LASF127
	.byte	0x1
	.byte	0x26
	.4byte	0x45b
	.byte	0x5
	.byte	0x3
	.4byte	pcbRev
	.uleb128 0x20
	.4byte	.LASF134
	.byte	0x4
	.byte	0xa7
	.4byte	0x2f1
	.byte	0x1
	.byte	0x1
	.byte	0
	.section	.debug_abbrev,"",%progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.uleb128 0x34
	.uleb128 0xc
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x4
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",%progbits
.Ldebug_loc0:
.LLST0:
	.4byte	.LFB0-.Ltext0
	.4byte	.LCFI0-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI0-.Ltext0
	.4byte	.LCFI1-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 12
	.4byte	.LCFI1-.Ltext0
	.4byte	.LFE0-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST1:
	.4byte	.LFB1-.Ltext0
	.4byte	.LCFI2-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI2-.Ltext0
	.4byte	.LCFI3-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 12
	.4byte	.LCFI3-.Ltext0
	.4byte	.LFE1-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST2:
	.4byte	.LFB2-.Ltext0
	.4byte	.LCFI4-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI4-.Ltext0
	.4byte	.LCFI5-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI5-.Ltext0
	.4byte	.LFE2-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST3:
	.4byte	.LFB3-.Ltext0
	.4byte	.LCFI6-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI6-.Ltext0
	.4byte	.LCFI7-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI7-.Ltext0
	.4byte	.LFE3-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST4:
	.4byte	.LFB4-.Ltext0
	.4byte	.LCFI8-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI8-.Ltext0
	.4byte	.LCFI9-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI9-.Ltext0
	.4byte	.LFE4-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST5:
	.4byte	.LFB5-.Ltext0
	.4byte	.LCFI10-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI10-.Ltext0
	.4byte	.LCFI11-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI11-.Ltext0
	.4byte	.LFE5-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST6:
	.4byte	.LFB6-.Ltext0
	.4byte	.LCFI12-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI12-.Ltext0
	.4byte	.LCFI13-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI13-.Ltext0
	.4byte	.LFE6-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST7:
	.4byte	.LFB7-.Ltext0
	.4byte	.LCFI14-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI14-.Ltext0
	.4byte	.LCFI15-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 4
	.4byte	.LCFI15-.Ltext0
	.4byte	.LFE7-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
.LLST8:
	.4byte	.LFB8-.Ltext0
	.4byte	.LCFI16-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI16-.Ltext0
	.4byte	.LCFI17-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 4
	.4byte	.LCFI17-.Ltext0
	.4byte	.LCFI18-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 12
	.4byte	.LCFI18-.Ltext0
	.4byte	.LFE8-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 8
	.4byte	0
	.4byte	0
.LLST9:
	.4byte	.LFB9-.Ltext0
	.4byte	.LCFI19-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI19-.Ltext0
	.4byte	.LCFI20-.Ltext0
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	.LCFI20-.Ltext0
	.4byte	.LFE9-.Ltext0
	.2byte	0x2
	.byte	0x7b
	.sleb128 4
	.4byte	0
	.4byte	0
	.section	.debug_aranges,"",%progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF109:
	.ascii	"gpioGetI2cPins\000"
.LASF36:
	.ascii	"_shortbuf\000"
.LASF77:
	.ascii	"alt0\000"
.LASF132:
	.ascii	"_IO_lock_t\000"
.LASF79:
	.ascii	"alt2\000"
.LASF80:
	.ascii	"alt3\000"
.LASF81:
	.ascii	"alt4\000"
.LASF82:
	.ascii	"alt5\000"
.LASF75:
	.ascii	"input\000"
.LASF134:
	.ascii	"stderr\000"
.LASF118:
	.ascii	"format\000"
.LASF25:
	.ascii	"_IO_buf_end\000"
.LASF108:
	.ascii	"sleepTime\000"
.LASF23:
	.ascii	"_IO_write_end\000"
.LASF0:
	.ascii	"unsigned int\000"
.LASF55:
	.ascii	"uint32_t\000"
.LASF123:
	.ascii	"pinCnt\000"
.LASF133:
	.ascii	"gpioValidatePin\000"
.LASF17:
	.ascii	"_flags\000"
.LASF29:
	.ascii	"_markers\000"
.LASF65:
	.ascii	"ERROR_I2C_CLK_TIMEOUT\000"
.LASF113:
	.ascii	"error\000"
.LASF78:
	.ascii	"alt1\000"
.LASF122:
	.ascii	"validPins\000"
.LASF105:
	.ascii	"gpioReadPin\000"
.LASF98:
	.ascii	"gpioSetup\000"
.LASF120:
	.ascii	"tempRtn\000"
.LASF97:
	.ascii	"revision\000"
.LASF119:
	.ascii	"arguments\000"
.LASF52:
	.ascii	"_pos\000"
.LASF28:
	.ascii	"_IO_save_end\000"
.LASF121:
	.ascii	"index\000"
.LASF7:
	.ascii	"long long unsigned int\000"
.LASF117:
	.ascii	"file\000"
.LASF69:
	.ascii	"high\000"
.LASF27:
	.ascii	"_IO_backup_base\000"
.LASF38:
	.ascii	"_offset\000"
.LASF59:
	.ascii	"ERROR_NULL\000"
.LASF31:
	.ascii	"_fileno\000"
.LASF46:
	.ascii	"__gnuc_va_list\000"
.LASF67:
	.ascii	"ERROR_MAX\000"
.LASF92:
	.ascii	"tv_nsec\000"
.LASF8:
	.ascii	"size_t\000"
.LASF76:
	.ascii	"output\000"
.LASF20:
	.ascii	"_IO_read_base\000"
.LASF83:
	.ascii	"eFunctionMin\000"
.LASF50:
	.ascii	"_next\000"
.LASF100:
	.ascii	"gpioSetFunction\000"
.LASF58:
	.ascii	"ERROR_RANGE\000"
.LASF90:
	.ascii	"timespec\000"
.LASF15:
	.ascii	"char\000"
.LASF44:
	.ascii	"_mode\000"
.LASF49:
	.ascii	"_IO_marker\000"
.LASF18:
	.ascii	"_IO_read_ptr\000"
.LASF56:
	.ascii	"ERROR_DEFAULT\000"
.LASF54:
	.ascii	"ssize_t\000"
.LASF73:
	.ascii	"pullup\000"
.LASF53:
	.ascii	"va_list\000"
.LASF21:
	.ascii	"_IO_write_base\000"
.LASF66:
	.ascii	"ERROR_INVALID_BSC\000"
.LASF6:
	.ascii	"long long int\000"
.LASF114:
	.ascii	"errorString\000"
.LASF26:
	.ascii	"_IO_save_base\000"
.LASF103:
	.ascii	"gpioSetPin\000"
.LASF63:
	.ascii	"ERROR_I2C_NACK\000"
.LASF131:
	.ascii	"__ap\000"
.LASF9:
	.ascii	"__quad_t\000"
.LASF129:
	.ascii	"gpio.c\000"
.LASF112:
	.ascii	"gpioErrToString\000"
.LASF68:
	.ascii	"errStatus\000"
.LASF39:
	.ascii	"__pad1\000"
.LASF40:
	.ascii	"__pad2\000"
.LASF41:
	.ascii	"__pad3\000"
.LASF42:
	.ascii	"__pad4\000"
.LASF43:
	.ascii	"__pad5\000"
.LASF124:
	.ascii	"validPinsForRev1\000"
.LASF107:
	.ascii	"resistorOption\000"
.LASF35:
	.ascii	"_vtable_offset\000"
.LASF127:
	.ascii	"pcbRev\000"
.LASF125:
	.ascii	"validPinsForRev2\000"
.LASF62:
	.ascii	"ERROR_ALREADY_INITIALISED\000"
.LASF115:
	.ascii	"dbgPrint\000"
.LASF130:
	.ascii	"/home/pi/RaspberryPi-GPIO/src\000"
.LASF93:
	.ascii	"mem_fd\000"
.LASF19:
	.ascii	"_IO_read_end\000"
.LASF5:
	.ascii	"short int\000"
.LASF11:
	.ascii	"long int\000"
.LASF57:
	.ascii	"ERROR_INVALID_PIN_NUMBER\000"
.LASF85:
	.ascii	"eFunction\000"
.LASF64:
	.ascii	"ERROR_I2C\000"
.LASF96:
	.ascii	"linelen\000"
.LASF72:
	.ascii	"pulldown\000"
.LASF14:
	.ascii	"__ssize_t\000"
.LASF126:
	.ascii	"gGpioMap\000"
.LASF94:
	.ascii	"cpuinfo\000"
.LASF61:
	.ascii	"ERROR_NOT_INITIALISED\000"
.LASF71:
	.ascii	"pullDisable\000"
.LASF110:
	.ascii	"gpioNumberScl\000"
.LASF48:
	.ascii	"__va_list\000"
.LASF37:
	.ascii	"_lock\000"
.LASF91:
	.ascii	"tv_sec\000"
.LASF3:
	.ascii	"long unsigned int\000"
.LASF70:
	.ascii	"eState\000"
.LASF33:
	.ascii	"_old_offset\000"
.LASF101:
	.ascii	"gpioNumber\000"
.LASF47:
	.ascii	"_IO_FILE\000"
.LASF128:
	.ascii	"GNU C 4.6.3\000"
.LASF111:
	.ascii	"gpioNumberSda\000"
.LASF1:
	.ascii	"unsigned char\000"
.LASF84:
	.ascii	"eFunctionMax\000"
.LASF102:
	.ascii	"function\000"
.LASF51:
	.ascii	"_sbuf\000"
.LASF95:
	.ascii	"line\000"
.LASF22:
	.ascii	"_IO_write_ptr\000"
.LASF74:
	.ascii	"eResistor\000"
.LASF99:
	.ascii	"gpioCleanup\000"
.LASF13:
	.ascii	"__time_t\000"
.LASF104:
	.ascii	"state\000"
.LASF87:
	.ascii	"pcbRev1\000"
.LASF88:
	.ascii	"pcbRev2\000"
.LASF10:
	.ascii	"__off_t\000"
.LASF106:
	.ascii	"gpioSetPullResistor\000"
.LASF4:
	.ascii	"signed char\000"
.LASF2:
	.ascii	"short unsigned int\000"
.LASF89:
	.ascii	"tPcbRev\000"
.LASF86:
	.ascii	"pcbRevError\000"
.LASF30:
	.ascii	"_chain\000"
.LASF16:
	.ascii	"FILE\000"
.LASF32:
	.ascii	"_flags2\000"
.LASF60:
	.ascii	"ERROR_EXTERNAL\000"
.LASF34:
	.ascii	"_cur_column\000"
.LASF12:
	.ascii	"__off64_t\000"
.LASF45:
	.ascii	"_unused2\000"
.LASF24:
	.ascii	"_IO_buf_base\000"
.LASF116:
	.ascii	"stream\000"
	.ident	"GCC: (Debian 4.6.3-14+rpi1) 4.6.3"
	.section	.note.GNU-stack,"",%progbits


  /**
   * @file
   *  @brief Contains source for the GPIO functionality.
   *
   *  This is is part of https://github.com/alanbarr/RaspberryPi-GPIO
   *  a C library for basic control of the Raspberry Pi's GPIO pins.
   *  Copyright (C) Alan Barr 2012
   *
   *  This code was loosely based on the example code
   *  provided by Dom and Gert found at:
   *      http://elinux.org/RPi_Low-level_peripherals
   *
   *  This program is free software: you can redistribute it and/or modify
   *  it under the terms of the GNU General Public License as published by
   *  the Free Software Foundation, either version 3 of the License, or
   *  (at your option) any later version.
   *
   *  This program is distributed in the hope that it will be useful,
   *  but WITHOUT ANY WARRANTY; without even the implied warranty of
   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   *  GNU General Public License for more details.
   *
   *  You should have received a copy of the GNU General Public License
   *  along with this program. If not, see <http://www.gnu.org/licenses/>.
   *
   */

  #include "gpio.h"

  /* Local / internal prototypes */
  static errStatus gpioValidatePin(int gpioNumber);

  /**** Globals ****/
  /** @brief Pointer which will be mmap'd to the GPIO memory in /dev/mem */
  static volatile uint32_t * gGpioMap = NULL;

  /** @brief PCB revision that executable is being run on */
  static tPcbRev pcbRev = pcbRevError;

  /**
   * @brief   Maps the memory used for GPIO access. This function must be called
   *          prior to any of the other GPIO calls.
   * @return  An error from #errStatus. */
  errStatus gpioSetup(void)
  {
      int mem_fd = 0;
      errStatus rtn = ERROR_DEFAULT;

      if ((mem_fd = open("/dev/mem", O_RDWR)) < 0)
      {
          dbgPrint(DBG_INFO, "open() failed. /dev/mem. errno %s.", strerror(errno));
          rtn = ERROR_EXTERNAL;
      }

      else if ((gGpioMap = (volatile uint32_t *)mmap(NULL,
                                                     GPIO_MAP_SIZE,
                                                     PROT_READ|PROT_WRITE,
                                                     MAP_SHARED,
                                                     mem_fd,
                                                     GPIO_BASE)) == MAP_FAILED)
      {
          dbgPrint(DBG_INFO, "mmap() failed. errno: %s.", strerror(errno));
          rtn = ERROR_EXTERNAL;
      }

      /* Close the fd, we have now mapped it */
      else if (close(mem_fd) != OK)
      {
          dbgPrint(DBG_INFO, "close() failed. errno: %s.", strerror(errno));
          rtn = ERROR_EXTERNAL;
      }

      else
      {
          FILE* cpuinfo = fopen("/proc/cpuinfo", "r");
          if (cpuinfo)
          {
              char* line = NULL;
              ssize_t linelen;
              size_t foo;

              while (((linelen = getline(&line, &foo, cpuinfo)) >= 0))
              {
                  if (strstr(line, "Revision") == line)
                  {
                      char* rev = strstr(line, ":");
                      if (rev)
                      {
                          long revision = strtol(rev + 1, NULL, 16);

                          if (revision <= 3)
                          {
                              pcbRev = pcbRev1;
                          }
                        
                          else
                          {
                              pcbRev = pcbRev2;
                          }
                      }
                  }
              } /* while */
              if (pcbRev != pcbRevError)
              {
                  rtn = OK;
              }
              else
              {
                  dbgPrint(DBG_INFO, "did not find revision in cpuinfo.");
                  rtn = ERROR_EXTERNAL;
              }

              if (line)
              {
                  free(line);
              }
              fclose(cpuinfo);
          }
          else
          {
              dbgPrint(DBG_INFO, "can't open /proc/cpuinfo. errno: %s.", strerror(errno));
              rtn = ERROR_EXTERNAL;
          }
      }

      return rtn;
  }


  /**
   * @brief   Unmaps the memory used for the gpio pins. This function should be
   *          called when finished with the GPIO pins.
   * @return  An error from #errStatus. */
  errStatus gpioCleanup(void)
  {
      errStatus rtn = ERROR_DEFAULT;

      if (gGpioMap == NULL)
      {
          dbgPrint(DBG_INFO, "gGpioMap was NULL. Ensure gpioSetup() was called successfully.");
          rtn = ERROR_NULL;
      }

      else if (munmap((void *)gGpioMap, GPIO_MAP_SIZE) != OK)
      {
          dbgPrint(DBG_INFO, "mummap() failed. errno %s.", strerror(errno));
          rtn = ERROR_EXTERNAL;
      }

      else
      {
          gGpioMap = NULL;
          rtn = OK;
      }
      return rtn;
  }


  /**
   * @brief               Sets the functionality of the desired pin.
   * @param gpioNumber    The gpio pin number to change.
   * @param function      The desired functionality for the pin.
   * @return              An error from #errStatus. */
  errStatus gpioSetFunction(int gpioNumber, eFunction function)
  {
      errStatus rtn = ERROR_DEFAULT;

      if (gGpioMap == NULL)
      {
          dbgPrint(DBG_INFO, "gGpioMap was NULL. Ensure gpioSetup() called successfully.");
          rtn = ERROR_NULL;
      }

      else if (function < eFunctionMin || function > eFunctionMax)
      {
          dbgPrint(DBG_INFO, "eFunction was out of range. %d", function);
          rtn = ERROR_RANGE;
      }

      else if ((rtn = gpioValidatePin(gpioNumber)) != OK)
      {
          dbgPrint(DBG_INFO, "gpioValidatePin() failed. Ensure pin %d is valid.", gpioNumber);
      }

      else
      {
          /* Clear what ever function bits currently exist - this puts the pin
           * into input mode.*/
          *(gGpioMap + (gpioNumber / 10)) &= ~(GPFSEL_BITS << ((gpioNumber % 10) * 3));

          /* Set the three pins for the pin to the desired value */
          *(gGpioMap + (gpioNumber / 10)) |=  (function << ((gpioNumber % 10) * 3));

          rtn = OK;
      }

      return rtn;
  }


  /**
   * @brief               Sets a pin to high or low.
   * @details             The pin should be configured as an ouput with
   *                      gpioSetFunction() prior to this.
   * @param gpioNumber    The pin to set.
   * @param state         The desired state of the pin.
   * @return              An error from #errStatus.*/
  errStatus gpioSetPin(int gpioNumber, eState state)
  {
      errStatus rtn = ERROR_DEFAULT;

      if (gGpioMap == NULL)
      {
         dbgPrint(DBG_INFO, "gGpioMap was NULL. Ensure gpioSetup() was called successfully.");
         rtn = ERROR_NULL;
      }

      else if ((rtn = gpioValidatePin(gpioNumber)) != OK)
      {
         dbgPrint(DBG_INFO, "gpioValidatePin() failed. Ensure pin %d is valid.", gpioNumber);
      }

      else if (state == high)
      {
          /* The offsets are all in bytes. Divide by sizeof uint32_t to allow
           * pointer addition. */
          GPIO_GPSET0 = 0x1 << gpioNumber;
          rtn = OK;
      }

      else if (state == low)
      {
          /* The offsets are all in bytes. Divide by sizeof uint32_t to allow
           * pointer addition. */
          GPIO_GPCLR0 = 0x1 << gpioNumber;
          rtn = OK;
      }

      else
      {
         dbgPrint(DBG_INFO,"state %d should have been %d or %d", state, low, high);
         rtn = ERROR_RANGE;
      }

      return rtn;
  }


  /**
   * @brief               Reads the current state of a gpio pin.
   * @param gpioNumber    The number of the GPIO pin to read.
   * @param[out] state    Pointer to the variable in which the GPIO pin state is
   *                      returned.
   * @return              An error from #errStatus. */
  errStatus gpioReadPin(int gpioNumber, eState * state)
  {
      errStatus rtn = ERROR_DEFAULT;

      if (gGpioMap == NULL)
      {
          dbgPrint(DBG_INFO, "gGpioMap was NULL. Ensure gpioSetup() was called successfully.");
          rtn = ERROR_NULL;
      }

      else if (state == NULL)
      {
          dbgPrint(DBG_INFO, "Parameter state was NULL.");
          rtn = ERROR_NULL;
      }

      else if ((rtn = gpioValidatePin(gpioNumber)) != OK)
      {
          dbgPrint(DBG_INFO, "gpioValidatePin() failed. Pin %d isn't valid.", gpioNumber);
      }

      else
      {
          /* Check if the appropriate bit is high */
          if (GPIO_GPLEV0 & (0x1 << gpioNumber))
          {
              *state = high;
          }

          else
          {
              *state = low;
          }

          rtn = OK;
      }

      return rtn;
  }

  /**
   * @brief                Allows configuration of the internal resistor at a GPIO pin.
   * @details              The GPIO pins on the BCM2835 have the option of configuring a
   *                       pullup, pulldown or no resistor at the pin.
   * @param gpioNumber     The GPIO pin to configure.
   * @param resistorOption The available resistor options.
   * @return               An error from #errStatus. */
  errStatus gpioSetPullResistor(int gpioNumber, eResistor resistorOption)
  {
      errStatus rtn = ERROR_DEFAULT;
      struct timespec sleepTime;

      if (gGpioMap == NULL)
      {
         dbgPrint(DBG_INFO, "gGpioMap was NULL. Ensure gpioSetup() was called successfully.");
         rtn = ERROR_NULL;
      }

      else if ((rtn = gpioValidatePin(gpioNumber)) != OK)
      {
         dbgPrint(DBG_INFO, "gpioValidatePin() failed. Pin %d isn't valid.", gpioNumber);
      }

      else if (resistorOption < pullDisable || resistorOption > pullup)
      {
         dbgPrint(DBG_INFO, "resistorOption value: %d was out of range.", resistorOption);
         rtn = ERROR_RANGE;
      }

      else
      {
          sleepTime.tv_sec  = 0;
          sleepTime.tv_nsec = 1000 * RESISTOR_SLEEP_US;

          /* Set the GPPUD register with the desired resistor type */
          GPIO_GPPUD = resistorOption;
          /* Wait for control signal to be set up */
          nanosleep(&sleepTime, NULL);
          /* Clock the control signal for desired resistor */
          GPIO_GPPUDCLK0 = (0x1 << gpioNumber);
          /* Hold to set */
          nanosleep(&sleepTime, NULL);
          GPIO_GPPUD = 0;
          GPIO_GPPUDCLK0 = 0;

          rtn = OK;
      }


      return rtn;
  }

  /**
   * @brief                       Get the correct I2C pins.
   * @details                     The different revisions of the PI have their I2C
   *                              ports on different GPIO
   *                              pins which require different BSC modules.
   * @param[out] gpioNumberScl    Integer to be populated with scl gpio number.
   * @param[out] gpioNumberSda    Integer to be populated with sda gpio number.
   * @todo TODO                   Does this need to be public or internal only?
   * @return                      An error from #errStatus. */
  errStatus gpioGetI2cPins(int * gpioNumberScl, int * gpioNumberSda)
  {
      errStatus rtn = ERROR_DEFAULT;

      if (gGpioMap == NULL)
      {
          dbgPrint(DBG_INFO, "gGpioMap was NULL. Ensure gpioSetup() was called successfully.");
          rtn = ERROR_NULL;
      }

      else if (gpioNumberScl == NULL)
      {
          dbgPrint(DBG_INFO, "Parameter gpioNumberScl is NULL.");
          rtn = ERROR_NULL;
      }
    
      else if (gpioNumberSda == NULL)
      {
          dbgPrint(DBG_INFO, "Parameter gpioNumberSda is NULL.");
          rtn = ERROR_NULL;
      }

      else if (pcbRev == pcbRev1)
      {
          *gpioNumberScl = REV1_SCL;
          *gpioNumberSda = REV1_SDA;
          rtn = OK;
      }

      else if (pcbRev == pcbRev2)
      {
          *gpioNumberScl = REV2_SCL;
          *gpioNumberSda = REV2_SDA;
          rtn = OK;
      }

      return rtn;
  }


  #undef  ERROR
  /** Redefining to replace macro with x as a string, i.e. "x". For use in
    * gpioErrToString() */
  #define ERROR(x) #x,

  /**
   * @brief       Debug function which converts an error from errStatus to a string.
   * @param error Error from #errStatus.
   * @return      String representation of errStatus parameter error. */
  const char * gpioErrToString(errStatus error)
  {
      static const char * errorString[] = { ERRORS };

      if (error < 0 || error >= ERROR_MAX)
      {
          return "InvalidError";
      }

      else
      {
          return errorString[error];
      }
  }


  /**
   * @brief            Debug function wrapper for fprintf().
   * @details          Allows file and line information to be added easier
   *                   to output strings. #DBG_INFO is a macro which is useful
   *                   to call as the "first" parameter to this function. Note
   *                   this function will add on a newline to the end of a format
   *                   string so one is generally not required in \p format.
   * @param[in] stream Output stream for strings, e.g. stderr, stdout.
   * @param[in] file   Name of file to be printed. Should be retrieved with __FILE__.
   * @param line       Line number to print. Should be retrieved with __LINE__.
   * @param[in] format Formatted string in the format which printf() would accept.
   * @param ...        Additional arguments - to fill in placeholders in parameter
   *                   \p format.
   * @return           This function uses the printf() family functions and the
   *                   returned integer is what is returned from these calls: If
   *                   successful the number or characters printed is returned,
   *                   if unsuccessful a negative value.
   */
  int dbgPrint(FILE * stream, const char * file, int line, const char * format, ...)
  {
      va_list arguments;
      int rtn = 0;
      int tempRtn = 0;

      if (stream != NULL)
      {
          if ((tempRtn = fprintf(stream,"[%s:%d] ", file, line)) < 0)
          {
              return tempRtn;
          }
          rtn += tempRtn;

          va_start(arguments, format);
          if ((tempRtn = vfprintf(stream, format, arguments)) < 0)
          {
              return tempRtn;
          }
          rtn += tempRtn;
          va_end(arguments);

          if ((tempRtn = fprintf(stream,"\n")) < 0)
          {
              return tempRtn;
          }
          rtn += tempRtn;

      }
      return rtn;
  }

  /****************************** Internal Functions ******************************/

  /**
   * @brief               Internal function which Validates that the pin
   *                      \p gpioNumber is valid for the Raspberry Pi.
   * @details             The first time this function is called it will perform
   *                      some basic initalisation on internal variables.
   * @param gpioNumber    The pin number to check.
   * @return              An error from #errStatus. */
  static errStatus gpioValidatePin(int gpioNumber)
  {
      errStatus rtn = ERROR_INVALID_PIN_NUMBER;
      int index = 0;
      /* TODO REV1 and REV2 have the same pincount. REV2 technically has more if 
       * P5 is supported. If there is a REV3 the size of this array will need to
       * be addressed. */
      static uint32_t validPins[REV2_PINCNT] = {0};
      static uint32_t pinCnt = 0;

      if (pinCnt == 0)
      {
          if (pcbRev == pcbRevError)
          {
              rtn = ERROR_RANGE;
          }

          else if (pcbRev == pcbRev1)
          {
              const uint32_t validPinsForRev1[REV1_PINCNT] = REV1_PINS;
              memcpy(validPins, validPinsForRev1, sizeof(validPinsForRev1));
              pinCnt = REV1_PINCNT;
          }
          else if (pcbRev == pcbRev2)
          {
              const uint32_t validPinsForRev2[REV2_PINCNT] = REV2_PINS;
              memcpy(validPins, validPinsForRev2, sizeof(validPinsForRev2));
              pinCnt = REV2_PINCNT;
          }
      }

      for (index = 0; index < pinCnt; index++)
      {
          if (gpioNumber == validPins[index])
          {
              rtn = OK;
              break;
          }
      }

      return rtn;
  }


