
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 8/000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _number_of_enters=R4
	.DEF _number_of_enters_msb=R5
	.DEF _number_of_exits=R6
	.DEF _number_of_exits_msb=R7
	.DEF _capacity=R9
	.DEF _reserved=R8
	.DEF _second=R10
	.DEF _second_msb=R11
	.DEF _minute=R12
	.DEF _minute_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0002

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0xA,0x32,0x0
	.DB  0x3B,0x0

_0x3:
	.DB  0xA
_0x4:
	.DB  0x17
_0x5:
	.DB  0x1D
_0x6:
	.DB  0xC
_0x7:
	.DB  0x7A,0x5
_0x0:
	.DB  0x45,0x6D,0x70,0x74,0x79,0x0,0x46,0x75
	.DB  0x6C,0x6C,0x0,0x73,0x61,0x76,0x69,0x6E
	.DB  0x67,0x20,0x64,0x61,0x74,0x61,0x0,0x43
	.DB  0x3D,0x25,0x64,0x20,0x25,0x64,0x2F,0x25
	.DB  0x64,0x2F,0x25,0x64,0x0,0x25,0x64,0x3A
	.DB  0x25,0x64,0x3A,0x25,0x64,0x20,0x20,0x52
	.DB  0x3D,0x25,0x64,0x20,0x0,0x54,0x69,0x6D
	.DB  0x65,0x20,0x53,0x65,0x74,0x74,0x69,0x6E
	.DB  0x67,0x20,0x3E,0x3E,0x0,0x49,0x4E,0x26
	.DB  0x4F,0x55,0x54,0x20,0x53,0x65,0x61,0x72
	.DB  0x63,0x68,0x20,0x3E,0x3E,0x0,0x52,0x65
	.DB  0x73,0x65,0x72,0x76,0x65,0x5F,0x50,0x61
	.DB  0x72,0x6B,0x20,0x3E,0x3E,0x0,0x53,0x65
	.DB  0x74,0x20,0x64,0x61,0x74,0x65,0x20,0x3E
	.DB  0x3E,0x0,0x53,0x65,0x74,0x20,0x6D,0x69
	.DB  0x6E,0x3D,0x25,0x64,0x20,0x20,0x3E,0x0
	.DB  0x53,0x65,0x74,0x20,0x68,0x6F,0x75,0x72
	.DB  0x3D,0x25,0x64,0x20,0x20,0x3E,0x0,0x69
	.DB  0x6E,0x3D,0x25,0x64,0x20,0x6F,0x75,0x74
	.DB  0x3D,0x25,0x64,0x0,0x52,0x65,0x73,0x65
	.DB  0x72,0x76,0x65,0x64,0x3D,0x25,0x64,0x0
	.DB  0x53,0x65,0x74,0x20,0x6D,0x6F,0x6E,0x74
	.DB  0x68,0x3D,0x25,0x64,0x20,0x20,0x3E,0x0
	.DB  0x53,0x65,0x74,0x20,0x64,0x61,0x79,0x3D
	.DB  0x25,0x64,0x20,0x20,0x3E,0x0,0x53,0x65
	.DB  0x74,0x20,0x79,0x65,0x61,0x72,0x3D,0x25
	.DB  0x64,0x20,0x20,0x3E,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _hour
	.DW  _0x4*2

	.DW  0x01
	.DW  _day
	.DW  _0x5*2

	.DW  0x01
	.DW  _month
	.DW  _0x6*2

	.DW  0x02
	.DW  _year
	.DW  _0x7*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h> // delay_ms functions
;#include <stdio.h> // sprintf function
;#include <alcd.h>  // lcd related functions
;#define xtal 8000000
;
;// prototyping functions
;char menu(void);
;char in_out_search(void);
;char set_time(void);
;char reserve_park(void);
;char set_date(void);
;
;// parking related variables
;unsigned int number_of_enters = 0, number_of_exits = 0;
;eeprom unsigned int enter_array[32] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  ...
;eeprom unsigned int exit_array[32] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ...
;eeprom char day_index = -1;
;unsigned char const init_capacity = 10;

	.DSEG
;signed char capacity = init_capacity, reserved = 0;
;bit is_full = 0, is_empty = 1;
;
;// date related variables
;unsigned int second = 50, minute = 59, hour = 23, day = 29, month = 12, year = 1402;
;
;// define timer interrupt: clock and date logic
;interrupt[TIM2_OVF] void timer2_ovf_isr(void)
; 0000 001C {

	.CSEG
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 001D 
; 0000 001E   // logic of second, minute, hour
; 0000 001F   if (second == 59)
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x8
; 0000 0020   {
; 0000 0021     second = 0;
	CLR  R10
	CLR  R11
; 0000 0022     if (minute == 59)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x9
; 0000 0023     {
; 0000 0024       minute = 0;
	CLR  R12
	CLR  R13
; 0000 0025       if (hour == 23)
	CALL SUBOPT_0x0
	SBIW R26,23
	BRNE _0xA
; 0000 0026       {
; 0000 0027         hour = 0;
	LDI  R30,LOW(0)
	STS  _hour,R30
	STS  _hour+1,R30
; 0000 0028         day++;
	LDI  R26,LOW(_day)
	LDI  R27,HIGH(_day)
	RJMP _0xD5
; 0000 0029       }
; 0000 002A       else
_0xA:
; 0000 002B         hour++;
	LDI  R26,LOW(_hour)
	LDI  R27,HIGH(_hour)
_0xD5:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 002C     }
; 0000 002D     else
	RJMP _0xC
_0x9:
; 0000 002E       minute++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 002F   }
_0xC:
; 0000 0030   else
	RJMP _0xD
_0x8:
; 0000 0031     second++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0032 
; 0000 0033   // logic of day, month
; 0000 0034   if (month <= 6)
_0xD:
	CALL SUBOPT_0x1
	SBIW R26,7
	BRSH _0xE
; 0000 0035   {
; 0000 0036     if (day > 31)
	CALL SUBOPT_0x2
	SBIW R26,32
	BRLO _0xF
; 0000 0037     {
; 0000 0038       day = 1;
	CALL SUBOPT_0x3
; 0000 0039       month++;
; 0000 003A     }
; 0000 003B   }
_0xF:
; 0000 003C   else
	RJMP _0x10
_0xE:
; 0000 003D   {
; 0000 003E     if (month == 12)
	CALL SUBOPT_0x1
	SBIW R26,12
	BRNE _0x11
; 0000 003F     {
; 0000 0040       if (day > 29)
	CALL SUBOPT_0x2
	SBIW R26,30
	BRLO _0x12
; 0000 0041       {
; 0000 0042         day = 1;
	CALL SUBOPT_0x3
; 0000 0043         month++;
; 0000 0044       }
; 0000 0045     }
_0x12:
; 0000 0046     else
	RJMP _0x13
_0x11:
; 0000 0047     {
; 0000 0048       if (day > 30)
	CALL SUBOPT_0x2
	SBIW R26,31
	BRLO _0x14
; 0000 0049       {
; 0000 004A         day = 1;
	CALL SUBOPT_0x3
; 0000 004B         month++;
; 0000 004C       }
; 0000 004D     }
_0x14:
_0x13:
; 0000 004E   }
_0x10:
; 0000 004F 
; 0000 0050   // logic of year
; 0000 0051   if (month > 12)
	CALL SUBOPT_0x1
	SBIW R26,13
	BRLO _0x15
; 0000 0052   {
; 0000 0053     month = 1;
	CALL SUBOPT_0x4
; 0000 0054     year++;
	CALL SUBOPT_0x5
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0055   }
; 0000 0056 }
_0x15:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// define interrupt 0: for exiting cars
;interrupt[EXT_INT0] void ext_int0_isr(void)
; 0000 005A {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x6
; 0000 005B   if (is_empty == 1)
	SBRS R2,1
	RJMP _0x16
; 0000 005C   {
; 0000 005D     lcd_clear();
	CALL _lcd_clear
; 0000 005E     lcd_putsf("Empty");
	__POINTW2FN _0x0,0
	CALL SUBOPT_0x7
; 0000 005F     delay_ms(500);
; 0000 0060   }
; 0000 0061   else
	RJMP _0x17
_0x16:
; 0000 0062   {
; 0000 0063 
; 0000 0064     capacity++;
	INC  R9
; 0000 0065     number_of_exits++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
; 0000 0066 
; 0000 0067     // check if the parking is empty
; 0000 0068     if ((capacity + reserved) >= init_capacity)
	CALL SUBOPT_0x8
	BRLT _0x18
; 0000 0069     {
; 0000 006A       capacity = init_capacity - reserved;
	LDI  R30,LOW(10)
	SUB  R30,R8
	MOV  R9,R30
; 0000 006B       is_empty = 1;
	SET
	RJMP _0xD6
; 0000 006C     }
; 0000 006D     else
_0x18:
; 0000 006E     {
; 0000 006F       is_empty = 0;
	CLT
_0xD6:
	BLD  R2,1
; 0000 0070     }
; 0000 0071 
; 0000 0072     // checking if the parking is full
; 0000 0073     if (capacity <= 0)
	LDI  R30,LOW(0)
	CP   R30,R9
	BRLT _0x1A
; 0000 0074     {
; 0000 0075       capacity = 0;
	CLR  R9
; 0000 0076       is_full = 1;
	SET
	RJMP _0xD7
; 0000 0077     }
; 0000 0078     else
_0x1A:
; 0000 0079     {
; 0000 007A       is_full = 0;
	CLT
_0xD7:
	BLD  R2,0
; 0000 007B     }
; 0000 007C   }
_0x17:
; 0000 007D }
	RJMP _0xDB
; .FEND
;
;// define interrupt 1: for entering cars
;interrupt[EXT_INT1] void ext_int1_isr(void)
; 0000 0081 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x6
; 0000 0082   if (is_full == 1)
	SBRS R2,0
	RJMP _0x1C
; 0000 0083   {
; 0000 0084     lcd_clear();
	CALL _lcd_clear
; 0000 0085     lcd_putsf("Full");
	__POINTW2FN _0x0,6
	CALL SUBOPT_0x7
; 0000 0086     delay_ms(500);
; 0000 0087   }
; 0000 0088   else
	RJMP _0x1D
_0x1C:
; 0000 0089   {
; 0000 008A 
; 0000 008B     capacity--;
	DEC  R9
; 0000 008C     number_of_enters++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
; 0000 008D 
; 0000 008E     // checking if the parking is full
; 0000 008F     if ((capacity) <= 0)
	LDI  R30,LOW(0)
	CP   R30,R9
	BRLT _0x1E
; 0000 0090     {
; 0000 0091       capacity = 0;
	CLR  R9
; 0000 0092       is_full = 1;
	SET
	RJMP _0xD8
; 0000 0093     }
; 0000 0094     else
_0x1E:
; 0000 0095     {
; 0000 0096       is_full = 0;
	CLT
_0xD8:
	BLD  R2,0
; 0000 0097     }
; 0000 0098 
; 0000 0099     // check if the parking is empty
; 0000 009A     if ((capacity + reserved) >= init_capacity)
	CALL SUBOPT_0x8
	BRLT _0x20
; 0000 009B     {
; 0000 009C       capacity = init_capacity - reserved;
	LDI  R30,LOW(10)
	SUB  R30,R8
	MOV  R9,R30
; 0000 009D       is_empty = 1;
	SET
	RJMP _0xD9
; 0000 009E     }
; 0000 009F     else
_0x20:
; 0000 00A0     {
; 0000 00A1       is_empty = 0;
	CLT
_0xD9:
	BLD  R2,1
; 0000 00A2     }
; 0000 00A3   }
_0x1D:
; 0000 00A4 }
_0xDB:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 00A7 {
_main:
; .FSTART _main
; 0000 00A8   char line[17], line2[17];
; 0000 00A9 
; 0000 00AA   GICR |= 0xC0;
	SBIW R28,34
;	line -> Y+17
;	line2 -> Y+0
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 00AB   MCUCR = 0x0B;
	LDI  R30,LOW(11)
	OUT  0x35,R30
; 0000 00AC   MCUCSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00AD   GIFR = 0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 00AE 
; 0000 00AF   // initilize lcd
; 0000 00B0   lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00B1   lcd_clear();
	CALL _lcd_clear
; 0000 00B2   lcd_gotoxy(0, 1);
	CALL SUBOPT_0x9
; 0000 00B3   delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 00B4 
; 0000 00B5   ASSR = 0x08; // timer2
	LDI  R30,LOW(8)
	OUT  0x22,R30
; 0000 00B6   TCCR2 = 0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 00B7   TCNT2 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00B8   OCR2 = 0x00;
	OUT  0x23,R30
; 0000 00B9   TIMSK = 0x40;
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 00BA 
; 0000 00BB   PORTA = 0b00011111;
	LDI  R30,LOW(31)
	OUT  0x1B,R30
; 0000 00BC 
; 0000 00BD   // day = day_index; // day_index in epprom
; 0000 00BE 
; 0000 00BF #asm("sei")
	sei
; 0000 00C0   capacity = capacity - reserved;
	SUB  R9,R8
; 0000 00C1 
; 0000 00C2   while (1)
_0x22:
; 0000 00C3   {
; 0000 00C4 
; 0000 00C5     if (PINA .2 == 0)
	SBIC 0x19,2
	RJMP _0x25
; 0000 00C6     {
; 0000 00C7       while (PINA .2 == 0)
_0x26:
	SBIS 0x19,2
; 0000 00C8         ;
	RJMP _0x26
; 0000 00C9       menu();
	RCALL _menu
; 0000 00CA     }
; 0000 00CB 
; 0000 00CC     // save the enter and exits at the end of the day
; 0000 00CD     if (hour == 0 & minute == 0 & second == 0)
_0x25:
	CALL SUBOPT_0xA
	BRNE PC+2
	RJMP _0x29
; 0000 00CE     {
; 0000 00CF       if (day_index >= 31) // shift the data if array is full
	CALL SUBOPT_0xB
	CPI  R30,LOW(0x1F)
	BRLO _0x2A
; 0000 00D0       {
; 0000 00D1         char i = 0;
; 0000 00D2         while (i < 31)
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	line -> Y+18
;	line2 -> Y+1
;	i -> Y+0
_0x2B:
	LD   R26,Y
	CPI  R26,LOW(0x1F)
	BRSH _0x2D
; 0000 00D3         {
; 0000 00D4           enter_array[i] = enter_array[i + 1];
	LD   R30,Y
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	__ADDW2MN _enter_array,2
	CALL SUBOPT_0xE
; 0000 00D5           exit_array[i] = exit_array[i + 1];
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
	__ADDW2MN _exit_array,2
	CALL SUBOPT_0xE
; 0000 00D6           i++;
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 00D7         }
	RJMP _0x2B
_0x2D:
; 0000 00D8       }
	ADIW R28,1
; 0000 00D9       else // increment array index
	RJMP _0x2E
_0x2A:
; 0000 00DA         day_index++;
	CALL SUBOPT_0xB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 00DB 
; 0000 00DC       // save the data
; 0000 00DD       enter_array[day_index] = number_of_enters;
_0x2E:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R4
	CALL __EEPROMWRW
; 0000 00DE       exit_array[day_index] = number_of_exits;
	CALL SUBOPT_0xB
	CALL SUBOPT_0xF
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R6
	CALL __EEPROMWRW
; 0000 00DF 
; 0000 00E0       while (hour == 0 & minute == 0 & second == 0)
_0x2F:
	CALL SUBOPT_0xA
	BREQ _0x31
; 0000 00E1       {
; 0000 00E2         lcd_clear();
	CALL _lcd_clear
; 0000 00E3         lcd_putsf("saving data");
	__POINTW2FN _0x0,11
	CALL _lcd_putsf
; 0000 00E4       }
	RJMP _0x2F
_0x31:
; 0000 00E5     }
; 0000 00E6 
; 0000 00E7     sprintf(line, "C=%d %d/%d/%d", capacity, year, month, day);
_0x29:
	MOVW R30,R28
	ADIW R30,17
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,23
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R9
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00E8     sprintf(line2, "%d:%d:%d  R=%d ", hour, minute, second, reserved);
	CALL SUBOPT_0x14
	__POINTW1FN _0x0,37
	CALL SUBOPT_0x15
	MOVW R30,R12
	CALL SUBOPT_0x16
	MOVW R30,R10
	CALL SUBOPT_0x16
	MOV  R30,R8
	CALL SUBOPT_0x10
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00E9     lcd_clear();
	CALL _lcd_clear
; 0000 00EA     lcd_puts(line);
	MOVW R26,R28
	ADIW R26,17
	CALL _lcd_puts
; 0000 00EB     lcd_gotoxy(0, 1);
	CALL SUBOPT_0x9
; 0000 00EC     lcd_puts(line2);
	CALL SUBOPT_0x17
; 0000 00ED     delay_ms(25);
	CALL SUBOPT_0x18
; 0000 00EE   }
	RJMP _0x22
; 0000 00EF }
_0x32:
	RJMP _0x32
; .FEND
;
;/// Functions 4 menu and...
;char menu(void)
; 0000 00F3 {
_menu:
; .FSTART _menu
; 0000 00F4   char choice = 0;
; 0000 00F5   while (1)
	ST   -Y,R17
;	choice -> R17
	LDI  R17,0
_0x33:
; 0000 00F6   {
; 0000 00F7     // iterate through menu items
; 0000 00F8     if (choice == 0)
	CPI  R17,0
	BRNE _0x36
; 0000 00F9     {
; 0000 00FA       lcd_clear();
	CALL _lcd_clear
; 0000 00FB       lcd_putsf("Time Setting >>");
	__POINTW2FN _0x0,53
	CALL _lcd_putsf
; 0000 00FC     }
; 0000 00FD     if (choice == 1)
_0x36:
	CPI  R17,1
	BRNE _0x37
; 0000 00FE     {
; 0000 00FF       lcd_clear();
	CALL _lcd_clear
; 0000 0100       lcd_putsf("IN&OUT Search >>");
	__POINTW2FN _0x0,69
	CALL _lcd_putsf
; 0000 0101     }
; 0000 0102     if (choice == 2)
_0x37:
	CPI  R17,2
	BRNE _0x38
; 0000 0103     {
; 0000 0104       lcd_clear();
	CALL _lcd_clear
; 0000 0105       lcd_putsf("Reserve_Park >>");
	__POINTW2FN _0x0,86
	CALL _lcd_putsf
; 0000 0106     }
; 0000 0107     if (choice == 3)
_0x38:
	CPI  R17,3
	BRNE _0x39
; 0000 0108     {
; 0000 0109       lcd_clear();
	CALL _lcd_clear
; 0000 010A       lcd_putsf("Set date >>");
	__POINTW2FN _0x0,102
	CALL _lcd_putsf
; 0000 010B     }
; 0000 010C     if (PINA .3 == 0) // next item
_0x39:
	SBIC 0x19,3
	RJMP _0x3A
; 0000 010D     {
; 0000 010E       while (PINA .3 == 0)
_0x3B:
	SBIS 0x19,3
; 0000 010F         ;
	RJMP _0x3B
; 0000 0110       choice++;
	SUBI R17,-1
; 0000 0111       if (choice >= 4)
	CPI  R17,4
	BRLO _0x3E
; 0000 0112         choice = 0;
	LDI  R17,LOW(0)
; 0000 0113     }
_0x3E:
; 0000 0114 
; 0000 0115     if (PINA .4 == 0) // close menu
_0x3A:
	SBIC 0x19,4
	RJMP _0x3F
; 0000 0116     {                 // Back
; 0000 0117       while (PINA .4 == 0)
_0x40:
	SBIS 0x19,4
; 0000 0118         ;
	RJMP _0x40
; 0000 0119       return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080008
; 0000 011A     }
; 0000 011B 
; 0000 011C     // choose time_setting
; 0000 011D     if (PINA .2 == 0 & choice == 0)
_0x3F:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	BREQ _0x43
; 0000 011E     {
; 0000 011F       while (PINA .2 == 0)
_0x44:
	SBIS 0x19,2
; 0000 0120         ;
	RJMP _0x44
; 0000 0121       set_time();
	RCALL _set_time
; 0000 0122     }
; 0000 0123 
; 0000 0124     // choose in_out_search
; 0000 0125     if (PINA .2 == 0 & choice == 1)
_0x43:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	BREQ _0x47
; 0000 0126     {
; 0000 0127       while (PINA .2 == 0)
_0x48:
	SBIS 0x19,2
; 0000 0128         ;
	RJMP _0x48
; 0000 0129       in_out_search();
	RCALL _in_out_search
; 0000 012A     }
; 0000 012B 
; 0000 012C     // choose reserve
; 0000 012D     if (PINA .2 == 0 & choice == 2)
_0x47:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	BREQ _0x4B
; 0000 012E     {
; 0000 012F       while (PINA .2 == 0)
_0x4C:
	SBIS 0x19,2
; 0000 0130         ;
	RJMP _0x4C
; 0000 0131       reserve_park();
	RCALL _reserve_park
; 0000 0132     }
; 0000 0133 
; 0000 0134     // choose set date
; 0000 0135     if (PINA .2 == 0 & choice == 3)
_0x4B:
	CALL SUBOPT_0x19
	LDI  R30,LOW(3)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x4F
; 0000 0136     {
; 0000 0137       while (PINA .2 == 0)
_0x50:
	SBIS 0x19,2
; 0000 0138         ;
	RJMP _0x50
; 0000 0139       set_date();
	RCALL _set_date
; 0000 013A     }
; 0000 013B 
; 0000 013C     delay_ms(25);
_0x4F:
	CALL SUBOPT_0x18
; 0000 013D   }
	RJMP _0x33
; 0000 013E }
_0x2080008:
	LD   R17,Y+
	RET
; .FEND
;
;// Time setting
;char set_time(void)
; 0000 0142 {
_set_time:
; .FSTART _set_time
	PUSH R15
; 0000 0143   bit choice = 0;
; 0000 0144   char line[17];
; 0000 0145   while (1)
	SBIW R28,17
;	choice -> R15.0
;	line -> Y+0
	CLR  R15
_0x53:
; 0000 0146   {
; 0000 0147     if (choice == 0)
	SBRC R15,0
	RJMP _0x56
; 0000 0148     {
; 0000 0149       sprintf(line, "Set min=%d  >", minute);
	CALL SUBOPT_0x14
	__POINTW1FN _0x0,114
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1D
; 0000 014A       lcd_clear();
; 0000 014B       lcd_puts(line);
; 0000 014C     }
; 0000 014D 
; 0000 014E     if (choice == 1)
_0x56:
	SBRS R15,0
	RJMP _0x57
; 0000 014F     {
; 0000 0150       sprintf(line, "Set hour=%d  >", hour);
	CALL SUBOPT_0x14
	__POINTW1FN _0x0,128
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1D
; 0000 0151       lcd_clear();
; 0000 0152       lcd_puts(line);
; 0000 0153     }
; 0000 0154 
; 0000 0155     if (PINA .1 == 0 & choice == 0)
_0x57:
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1A
	BREQ _0x58
; 0000 0156     { // UP     min
; 0000 0157       while (PINA .1 == 0)
_0x59:
	SBIS 0x19,1
; 0000 0158         ;
	RJMP _0x59
; 0000 0159       minute++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 015A       if (minute > 59)
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CP   R30,R12
	CPC  R31,R13
	BRSH _0x5C
; 0000 015B         minute = 0;
	CLR  R12
	CLR  R13
; 0000 015C     }
_0x5C:
; 0000 015D 
; 0000 015E     if (PINA .0 == 0 & choice == 0)
_0x58:
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1A
	BREQ _0x5D
; 0000 015F     { // DOWN    min
; 0000 0160       while (PINA .0 == 0)
_0x5E:
	SBIS 0x19,0
; 0000 0161         ;
	RJMP _0x5E
; 0000 0162       if (minute == 0)
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x61
; 0000 0163         minute = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	RJMP _0xDA
; 0000 0164       else
_0x61:
; 0000 0165         minute--;
	MOVW R30,R12
	SBIW R30,1
_0xDA:
	MOVW R12,R30
; 0000 0166     }
; 0000 0167 
; 0000 0168     if (PINA .1 == 0 & choice == 1)
_0x5D:
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1B
	BREQ _0x63
; 0000 0169     { // UP    hour
; 0000 016A       while (PINA .1 == 0)
_0x64:
	SBIS 0x19,1
; 0000 016B         ;
	RJMP _0x64
; 0000 016C       hour++;
	LDI  R26,LOW(_hour)
	LDI  R27,HIGH(_hour)
	CALL SUBOPT_0x20
; 0000 016D       if (hour > 23)
	CALL SUBOPT_0x0
	SBIW R26,24
	BRLO _0x67
; 0000 016E         hour = 0;
	LDI  R30,LOW(0)
	STS  _hour,R30
	STS  _hour+1,R30
; 0000 016F     }
_0x67:
; 0000 0170 
; 0000 0171     if (PINA .0 == 0 & choice == 1)
_0x63:
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1B
	BREQ _0x68
; 0000 0172     { // DOWN    hour
; 0000 0173       while (PINA .0 == 0)
_0x69:
	SBIS 0x19,0
; 0000 0174         ;
	RJMP _0x69
; 0000 0175       if (hour == 0)
	LDS  R30,_hour
	LDS  R31,_hour+1
	SBIW R30,0
	BRNE _0x6C
; 0000 0176         hour = 23;
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	STS  _hour,R30
	STS  _hour+1,R31
; 0000 0177       else
	RJMP _0x6D
_0x6C:
; 0000 0178         hour--;
	LDI  R26,LOW(_hour)
	LDI  R27,HIGH(_hour)
	CALL SUBOPT_0x21
; 0000 0179     }
_0x6D:
; 0000 017A 
; 0000 017B     if (PINA .3 == 0)
_0x68:
	SBIC 0x19,3
	RJMP _0x6E
; 0000 017C     { // NEXT
; 0000 017D       while (PINA .3 == 0)
_0x6F:
	SBIS 0x19,3
; 0000 017E         ;
	RJMP _0x6F
; 0000 017F       choice = !choice;
	LDI  R30,LOW(1)
	EOR  R15,R30
; 0000 0180     }
; 0000 0181 
; 0000 0182     if (PINA .4 == 0)
_0x6E:
	SBIC 0x19,4
	RJMP _0x72
; 0000 0183     { // Back
; 0000 0184       while (PINA .4 == 0)
_0x73:
	SBIS 0x19,4
; 0000 0185         ;
	RJMP _0x73
; 0000 0186       return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080007
; 0000 0187     }
; 0000 0188 
; 0000 0189     delay_ms(25);
_0x72:
	CALL SUBOPT_0x18
; 0000 018A   }
	RJMP _0x53
; 0000 018B }
_0x2080007:
	ADIW R28,17
	POP  R15
	RET
; .FEND
;
;/// IN&OUT Search
;char in_out_search(void)
; 0000 018F {
_in_out_search:
; .FSTART _in_out_search
	PUSH R15
; 0000 0190   char line[17], line2[17];
; 0000 0191   int temp_year = year, temp_month = month, temp_day = day;
; 0000 0192   bit bit_m = 0;
; 0000 0193 
; 0000 0194   while (1)
	SBIW R28,34
	CALL __SAVELOCR6
;	line -> Y+23
;	line2 -> Y+6
;	temp_year -> R16,R17
;	temp_month -> R18,R19
;	temp_day -> R20,R21
;	bit_m -> R15.0
	CLR  R15
	__GETWRMN 16,17,0,_year
	__GETWRMN 18,19,0,_month
	__GETWRMN 20,21,0,_day
_0x76:
; 0000 0195   {
; 0000 0196     // UP
; 0000 0197     if (PINA .1 == 0)
	SBIC 0x19,1
	RJMP _0x79
; 0000 0198     {
; 0000 0199       while (PINA .1 == 0)
_0x7A:
	SBIS 0x19,1
; 0000 019A         ;
	RJMP _0x7A
; 0000 019B       temp_day++;
	__ADDWRN 20,21,1
; 0000 019C 
; 0000 019D       // logic of day, month
; 0000 019E       if (temp_month <= 6)
	__CPWRN 18,19,7
	BRGE _0x7D
; 0000 019F       {
; 0000 01A0         if (temp_day > 31)
	__CPWRN 20,21,32
	BRLT _0x7E
; 0000 01A1         {
; 0000 01A2           temp_day = 1;
	CALL SUBOPT_0x22
; 0000 01A3           temp_month++;
; 0000 01A4         }
; 0000 01A5       }
_0x7E:
; 0000 01A6       else
	RJMP _0x7F
_0x7D:
; 0000 01A7       {
; 0000 01A8         if (temp_month == 12)
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x80
; 0000 01A9         {
; 0000 01AA           if (temp_day > 29)
	__CPWRN 20,21,30
	BRLT _0x81
; 0000 01AB           {
; 0000 01AC             temp_day = 1;
	CALL SUBOPT_0x22
; 0000 01AD             temp_month++;
; 0000 01AE           }
; 0000 01AF         }
_0x81:
; 0000 01B0         else
	RJMP _0x82
_0x80:
; 0000 01B1         {
; 0000 01B2           if (temp_day > 30)
	__CPWRN 20,21,31
	BRLT _0x83
; 0000 01B3           {
; 0000 01B4             temp_day = 1;
	CALL SUBOPT_0x22
; 0000 01B5             temp_month++;
; 0000 01B6           }
; 0000 01B7         }
_0x83:
_0x82:
; 0000 01B8       }
_0x7F:
; 0000 01B9 
; 0000 01BA       // logic of year
; 0000 01BB       if (temp_month > 12)
	__CPWRN 18,19,13
	BRLT _0x84
; 0000 01BC       {
; 0000 01BD         temp_month = 1;
	__GETWRN 18,19,1
; 0000 01BE         temp_year++;
	__ADDWRN 16,17,1
; 0000 01BF       }
; 0000 01C0     }
_0x84:
; 0000 01C1 
; 0000 01C2     // DOWN
; 0000 01C3     if (PINA .0 == 0)
_0x79:
	SBIC 0x19,0
	RJMP _0x85
; 0000 01C4     {
; 0000 01C5       while (PINA .0 == 0)
_0x86:
	SBIS 0x19,0
; 0000 01C6         ;
	RJMP _0x86
; 0000 01C7 
; 0000 01C8       if (temp_day == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x89
; 0000 01C9       {
; 0000 01CA         if (temp_month == 1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x8A
; 0000 01CB         {
; 0000 01CC           temp_month = 12;
	__GETWRN 18,19,12
; 0000 01CD           temp_year--;
	__SUBWRN 16,17,1
; 0000 01CE         }
; 0000 01CF         else
	RJMP _0x8B
_0x8A:
; 0000 01D0           temp_month--;
	__SUBWRN 18,19,1
; 0000 01D1 
; 0000 01D2         if (1 <= temp_month && temp_month <= 6)
_0x8B:
	__CPWRN 18,19,1
	BRLT _0x8D
	__CPWRN 18,19,7
	BRLT _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
; 0000 01D3           temp_day = 31;
	__GETWRN 20,21,31
; 0000 01D4         if (7 <= temp_month && temp_month <= 11)
_0x8C:
	__CPWRN 18,19,7
	BRLT _0x90
	__CPWRN 18,19,12
	BRLT _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 01D5           temp_day = 30;
	__GETWRN 20,21,30
; 0000 01D6         if (temp_month == 12)
_0x8F:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x92
; 0000 01D7           temp_day = 29;
	__GETWRN 20,21,29
; 0000 01D8       }
_0x92:
; 0000 01D9       else
	RJMP _0x93
_0x89:
; 0000 01DA         temp_day--;
	__SUBWRN 20,21,1
; 0000 01DB     }
_0x93:
; 0000 01DC 
; 0000 01DD     sprintf(line, "%d/%d/%d", temp_year, temp_month, temp_day);
_0x85:
	MOVW R30,R28
	ADIW R30,23
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,28
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0x23
	MOVW R30,R18
	CALL SUBOPT_0x23
	MOVW R30,R20
	CALL SUBOPT_0x23
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01DE     sprintf(line2, "in=%d out=%d", enter_array[day_index], exit_array[day_index]);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,143
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0x24
	CALL SUBOPT_0xB
	CALL SUBOPT_0xF
	CALL SUBOPT_0x24
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 01DF 
; 0000 01E0     lcd_clear();
	CALL _lcd_clear
; 0000 01E1     lcd_puts(line);
	MOVW R26,R28
	ADIW R26,23
	CALL _lcd_puts
; 0000 01E2     lcd_gotoxy(0, 1);
	CALL SUBOPT_0x9
; 0000 01E3     lcd_puts(line2);
	MOVW R26,R28
	ADIW R26,6
	CALL _lcd_puts
; 0000 01E4 
; 0000 01E5     // Back
; 0000 01E6     if (PINA .4 == 0)
	SBIC 0x19,4
	RJMP _0x94
; 0000 01E7     {
; 0000 01E8       while (PINA .4 == 0)
_0x95:
	SBIS 0x19,4
; 0000 01E9         ;
	RJMP _0x95
; 0000 01EA       return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01EB     }
; 0000 01EC     delay_ms(25);
_0x94:
	CALL SUBOPT_0x18
; 0000 01ED   }
	RJMP _0x76
; 0000 01EE }
_0x2080006:
	CALL __LOADLOCR6
	ADIW R28,40
	POP  R15
	RET
; .FEND
;
;// reserve_park
;char reserve_park(void)
; 0000 01F2 {
_reserve_park:
; .FSTART _reserve_park
; 0000 01F3   char line[17];
; 0000 01F4 
; 0000 01F5   while (1)
	SBIW R28,17
;	line -> Y+0
_0x98:
; 0000 01F6   {
; 0000 01F7     sprintf(line, "Reserved=%d", reserved);
	CALL SUBOPT_0x14
	__POINTW1FN _0x0,156
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R8
	CALL SUBOPT_0x10
	CALL SUBOPT_0x1D
; 0000 01F8     lcd_clear();
; 0000 01F9     lcd_puts(line);
; 0000 01FA 
; 0000 01FB     if (PINA .1 == 0)
	SBIC 0x19,1
	RJMP _0x9B
; 0000 01FC     {
; 0000 01FD       while (PINA .1 == 0)
_0x9C:
	SBIS 0x19,1
; 0000 01FE         ;
	RJMP _0x9C
; 0000 01FF       reserved++;
	INC  R8
; 0000 0200       capacity--;
	DEC  R9
; 0000 0201     }
; 0000 0202 
; 0000 0203     if (reserved >= init_capacity)
_0x9B:
	MOV  R26,R8
	LDI  R30,LOW(10)
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x9F
; 0000 0204     {
; 0000 0205       reserved = init_capacity - 1;
	LDI  R30,LOW(9)
	MOV  R8,R30
; 0000 0206     }
; 0000 0207 
; 0000 0208     if (PINA .0 == 0)
_0x9F:
	SBIC 0x19,0
	RJMP _0xA0
; 0000 0209     {
; 0000 020A       while (PINA .0 == 0)
_0xA1:
	SBIS 0x19,0
; 0000 020B         ;
	RJMP _0xA1
; 0000 020C       reserved--;
	DEC  R8
; 0000 020D       capacity++;
	INC  R9
; 0000 020E     }
; 0000 020F 
; 0000 0210     if (reserved <= 0)
_0xA0:
	LDI  R30,LOW(0)
	CP   R30,R8
	BRLT _0xA4
; 0000 0211     {
; 0000 0212       reserved = 0;
	CLR  R8
; 0000 0213     }
; 0000 0214 
; 0000 0215     if (PINA .4 == 0)
_0xA4:
	SBIC 0x19,4
	RJMP _0xA5
; 0000 0216     { // Back
; 0000 0217       while (PINA .4 == 0)
_0xA6:
	SBIS 0x19,4
; 0000 0218         ;
	RJMP _0xA6
; 0000 0219       return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080005
; 0000 021A     }
; 0000 021B     delay_ms(25);
_0xA5:
	CALL SUBOPT_0x18
; 0000 021C   }
	RJMP _0x98
; 0000 021D }
_0x2080005:
	ADIW R28,17
	RET
; .FEND
;
;//// data setting
;char set_date(void)
; 0000 0221 {
_set_date:
; .FSTART _set_date
; 0000 0222   char choice = 0;
; 0000 0223   char line[17];
; 0000 0224   while (1)
	SBIW R28,17
	ST   -Y,R17
;	choice -> R17
;	line -> Y+1
	LDI  R17,0
_0xA9:
; 0000 0225   {
; 0000 0226     if (choice == 1)
	CPI  R17,1
	BRNE _0xAC
; 0000 0227     {
; 0000 0228       sprintf(line, "Set month=%d  >", month);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,168
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x26
; 0000 0229       lcd_clear();
; 0000 022A       lcd_puts(line);
; 0000 022B     }
; 0000 022C 
; 0000 022D     if (choice == 0)
_0xAC:
	CPI  R17,0
	BRNE _0xAD
; 0000 022E     {
; 0000 022F       sprintf(line, "Set day=%d  >", day);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,184
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x13
	CALL SUBOPT_0x26
; 0000 0230       lcd_clear();
; 0000 0231       lcd_puts(line);
; 0000 0232     }
; 0000 0233 
; 0000 0234     if (choice == 2)
_0xAD:
	CPI  R17,2
	BRNE _0xAE
; 0000 0235     {
; 0000 0236       sprintf(line, "Set year=%d  >", year);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,198
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x26
; 0000 0237       lcd_clear();
; 0000 0238       lcd_puts(line);
; 0000 0239     }
; 0000 023A 
; 0000 023B     if (PINA .1 == 0 & choice == 1)
_0xAE:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1B
	BREQ _0xAF
; 0000 023C     { // UP     month
; 0000 023D       while (PINA .1 == 0)
_0xB0:
	SBIS 0x19,1
; 0000 023E         ;
	RJMP _0xB0
; 0000 023F       month++;
	LDI  R26,LOW(_month)
	LDI  R27,HIGH(_month)
	CALL SUBOPT_0x20
; 0000 0240       if (month > 12)
	CALL SUBOPT_0x1
	SBIW R26,13
	BRLO _0xB3
; 0000 0241         month = 1;
	CALL SUBOPT_0x4
; 0000 0242     }
_0xB3:
; 0000 0243 
; 0000 0244     if (PINA .0 == 0 & choice == 1)
_0xAF:
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1B
	BREQ _0xB4
; 0000 0245     { // DOWN    month
; 0000 0246       while (PINA .0 == 0)
_0xB5:
	SBIS 0x19,0
; 0000 0247         ;
	RJMP _0xB5
; 0000 0248       month--;
	LDI  R26,LOW(_month)
	LDI  R27,HIGH(_month)
	CALL SUBOPT_0x21
; 0000 0249       if (month < 1)
	CALL SUBOPT_0x1
	SBIW R26,1
	BRSH _0xB8
; 0000 024A         month = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	STS  _month,R30
	STS  _month+1,R31
; 0000 024B     }
_0xB8:
; 0000 024C 
; 0000 024D     if (PINA .1 == 0 & choice == 0)
_0xB4:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1A
	BREQ _0xB9
; 0000 024E     { // UP    day
; 0000 024F       while (PINA .1 == 0)
_0xBA:
	SBIS 0x19,1
; 0000 0250         ;
	RJMP _0xBA
; 0000 0251       day++;
	LDI  R26,LOW(_day)
	LDI  R27,HIGH(_day)
	CALL SUBOPT_0x20
; 0000 0252       day_index = day;
	CALL SUBOPT_0x29
; 0000 0253       if (day > 31)
	SBIW R26,32
	BRLO _0xBD
; 0000 0254         day = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _day,R30
	STS  _day+1,R31
; 0000 0255     }
_0xBD:
; 0000 0256 
; 0000 0257     if (PINA .0 == 0 & choice == 0)
_0xB9:
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1A
	BREQ _0xBE
; 0000 0258     { // DOWN    day
; 0000 0259       while (PINA .0 == 0)
_0xBF:
	SBIS 0x19,0
; 0000 025A         ;
	RJMP _0xBF
; 0000 025B       day--;
	LDI  R26,LOW(_day)
	LDI  R27,HIGH(_day)
	CALL SUBOPT_0x21
; 0000 025C       day_index = day;
	CALL SUBOPT_0x29
; 0000 025D       if (day < 1)
	SBIW R26,1
	BRSH _0xC2
; 0000 025E         day = 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	STS  _day,R30
	STS  _day+1,R31
; 0000 025F     }
_0xC2:
; 0000 0260 
; 0000 0261     if (PINA .0 == 0 & choice == 2)
_0xBE:
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1C
	BREQ _0xC3
; 0000 0262     { // DOWN    year
; 0000 0263       while (PINA .0 == 0)
_0xC4:
	SBIS 0x19,0
; 0000 0264         ;
	RJMP _0xC4
; 0000 0265       year--;
	CALL SUBOPT_0x5
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0266       if (year < 1)
	LDS  R26,_year
	LDS  R27,_year+1
	SBIW R26,1
	BRSH _0xC7
; 0000 0267         year = 1300;
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	STS  _year,R30
	STS  _year+1,R31
; 0000 0268     }
_0xC7:
; 0000 0269 
; 0000 026A     if (PINA .1 == 0 & choice == 2)
_0xC3:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1C
	BREQ _0xC8
; 0000 026B     { // UP    year
; 0000 026C       while (PINA .1 == 0)
_0xC9:
	SBIS 0x19,1
; 0000 026D         ;
	RJMP _0xC9
; 0000 026E       year++;
	CALL SUBOPT_0x5
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 026F       // if(year>1404)
; 0000 0270       // year=0;
; 0000 0271     }
; 0000 0272 
; 0000 0273     if (PINA .3 == 0)
_0xC8:
	SBIC 0x19,3
	RJMP _0xCC
; 0000 0274     { // NEXT
; 0000 0275       while (PINA .3 == 0)
_0xCD:
	SBIS 0x19,3
; 0000 0276         ;
	RJMP _0xCD
; 0000 0277       choice++;
	SUBI R17,-1
; 0000 0278       if (choice >= 3)
	CPI  R17,3
	BRLO _0xD0
; 0000 0279         choice = 0;
	LDI  R17,LOW(0)
; 0000 027A     }
_0xD0:
; 0000 027B 
; 0000 027C     if (PINA .4 == 0)
_0xCC:
	SBIC 0x19,4
	RJMP _0xD1
; 0000 027D     { // Back
; 0000 027E       while (PINA .4 == 0)
_0xD2:
	SBIS 0x19,4
; 0000 027F         ;
	RJMP _0xD2
; 0000 0280       return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080004
; 0000 0281     }
; 0000 0282 
; 0000 0283     delay_ms(25);
_0xD1:
	CALL SUBOPT_0x18
; 0000 0284   }
	RJMP _0xA9
; 0000 0285 }
_0x2080004:
	LDD  R17,Y+0
	ADIW R28,18
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x20
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x20
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x2A
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x2A
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x2B
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2C
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x2A
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x2C
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2C
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x2F
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x2F
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x18,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x18,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x18,4
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,4
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x18,5
	RJMP _0x2020009
_0x2020008:
	CBI  0x18,5
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x18,6
	RJMP _0x202000B
_0x202000A:
	CBI  0x18,6
_0x202000B:
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x30
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x30
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	RJMP _0x2080002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x17,3
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x31
	CALL SUBOPT_0x31
	CALL SUBOPT_0x31
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.ESEG
_enter_array:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_exit_array:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_day_index:
	.DB  0xFF

	.DSEG
_hour:
	.BYTE 0x2
_day:
	.BYTE 0x2
_month:
	.BYTE 0x2
_year:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDS  R26,_hour
	LDS  R27,_hour+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDS  R26,_month
	LDS  R27,_month+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDS  R26,_day
	LDS  R27,_day+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _day,R30
	STS  _day+1,R31
	LDI  R26,LOW(_month)
	LDI  R27,HIGH(_month)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _month,R30
	STS  _month+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_year)
	LDI  R27,HIGH(_year)
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL _lcd_putsf
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	MOV  R26,R9
	LDI  R27,0
	SBRC R26,7
	SER  R27
	MOV  R30,R8
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x0
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	MOVW R26,R12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R0,R30
	MOVW R26,R10
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_day_index)
	LDI  R27,HIGH(_day_index)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_enter_array)
	LDI  R27,HIGH(_enter_array)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LD   R26,Y
	CLR  R27
	LSL  R26
	ROL  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	CALL __EEPROMRDW
	MOVW R26,R0
	CALL __EEPROMWRW
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_exit_array)
	LDI  R27,HIGH(_exit_array)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	CALL __CBD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R30,_year
	LDS  R31,_year+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDS  R30,_month
	LDS  R31,_month+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R30,_day
	LDS  R31,_day+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_hour
	LDS  R31,_hour+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	MOVW R26,R28
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(25)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x19:
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(2)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	CALL _lcd_clear
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R15,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDI  R26,0
	SBIC 0x19,0
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R15,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__GETWRN 20,21,1
	__ADDWRN 18,19,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x26:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	CALL _lcd_clear
	MOVW R26,R28
	ADIW R26,1
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	LDI  R26,0
	SBIC 0x19,0
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LDS  R30,_day
	LDI  R26,LOW(_day_index)
	LDI  R27,HIGH(_day_index)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
