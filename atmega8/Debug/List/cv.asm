
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2C:
	.DB  0x63,0x5,0x0,0x0,0x0,0x63,0x4,0x0
	.DB  0x0,0x0,0x63,0x3,0x0,0x0,0x0,0x63
	.DB  0x2,0x0,0x0,0x0,0x63,0x1,0x0,0x0
	.DB  0x0,0x63,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Linky_Robot
;Version : 0.0.1
;Date    : 2/26/2021
;Author  : Gantulga
;Company : MUST
;Comments:
;GGWP
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
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
;#include "LED.h"

	.CSEG
_led_init:
; .FSTART _led_init
	RCALL SUBOPT_0x0
;	*led -> Y+0
	RCALL SUBOPT_0x1
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x2
	BRNE _0x6
	IN   R1,23
	RCALL SUBOPT_0x3
	OUT  0x17,R30
	RJMP _0x5
_0x6:
	RCALL SUBOPT_0x4
	BRNE _0x7
	IN   R1,20
	RCALL SUBOPT_0x3
	OUT  0x14,R30
	RJMP _0x5
_0x7:
	RCALL SUBOPT_0x5
	BRNE _0x5
	IN   R1,17
	RCALL SUBOPT_0x3
	OUT  0x11,R30
_0x5:
	RCALL SUBOPT_0x1
	ADIW R26,3
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x2060001
; .FEND
_led_on:
; .FSTART _led_on
	RCALL SUBOPT_0x6
;	*led -> Y+0
	BREQ _0xA
	RCALL SUBOPT_0x7
	LDD  R30,Z+4
	CPI  R30,0
	BREQ _0xB
_0xA:
	RJMP _0x9
_0xB:
	RCALL SUBOPT_0x2
	BRNE _0xF
	RCALL SUBOPT_0x8
	RJMP _0xE
_0xF:
	RCALL SUBOPT_0x4
	BRNE _0x10
	RCALL SUBOPT_0x9
	RJMP _0xE
_0x10:
	RCALL SUBOPT_0x5
	BRNE _0xE
	RCALL SUBOPT_0xA
_0xE:
	RCALL SUBOPT_0x1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
_0x9:
	RJMP _0x2060001
; .FEND
_led_off:
; .FSTART _led_off
	RCALL SUBOPT_0x6
;	*led -> Y+0
	BREQ _0x13
	RCALL SUBOPT_0x7
	LDD  R30,Z+4
	CPI  R30,0
	BRNE _0x14
_0x13:
	RJMP _0x12
_0x14:
	RCALL SUBOPT_0x2
	BRNE _0x18
	RCALL SUBOPT_0x8
	RJMP _0x17
_0x18:
	RCALL SUBOPT_0x4
	BRNE _0x19
	RCALL SUBOPT_0x9
	RJMP _0x17
_0x19:
	RCALL SUBOPT_0x5
	BRNE _0x17
	RCALL SUBOPT_0xA
_0x17:
	RCALL SUBOPT_0x1
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
_0x12:
_0x2060001:
	ADIW R28,2
	RET
; .FEND
;
;// Declare your global variables here
;
;void get_data(unsigned char *data);
;unsigned char resData[2];
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 003C {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	RCALL SUBOPT_0xB
; 0000 003D char status,data;
; 0000 003E status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 003F data=UDR;
	IN   R16,12
; 0000 0040 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x1B
; 0000 0041    {
; 0000 0042    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0043 #if RX_BUFFER_SIZE == 256
; 0000 0044    // special case for receiver buffer size=256
; 0000 0045    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0046 #else
; 0000 0047    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x1C
	CLR  R5
; 0000 0048    if (++rx_counter == RX_BUFFER_SIZE)
_0x1C:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x1D
; 0000 0049       {
; 0000 004A       rx_counter=0;
	CLR  R7
; 0000 004B       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 004C       }
; 0000 004D #endif
; 0000 004E    }
_0x1D:
; 0000 004F }
_0x1B:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x4C
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0056 {
_getchar:
; .FSTART _getchar
; 0000 0057 char data;
; 0000 0058 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x1E:
	TST  R7
	BREQ _0x1E
; 0000 0059 data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 005A #if RX_BUFFER_SIZE != 256
; 0000 005B if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x21
	CLR  R4
; 0000 005C #endif
; 0000 005D #asm("cli")
_0x21:
	cli
; 0000 005E --rx_counter;
	DEC  R7
; 0000 005F #asm("sei")
	sei
; 0000 0060 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0061 }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0077 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	RCALL SUBOPT_0xB
; 0000 0078 if (tx_counter)
	TST  R8
	BREQ _0x22
; 0000 0079    {
; 0000 007A    --tx_counter;
	DEC  R8
; 0000 007B    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 007C #if TX_BUFFER_SIZE != 256
; 0000 007D    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x23
	CLR  R9
; 0000 007E #endif
; 0000 007F    }
_0x23:
; 0000 0080 }
_0x22:
_0x4C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0087 {
; 0000 0088 while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
; 0000 0089 #asm("cli")
; 0000 008A if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
; 0000 008B    {
; 0000 008C    tx_buffer[tx_wr_index++]=c;
; 0000 008D #if TX_BUFFER_SIZE != 256
; 0000 008E    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
; 0000 008F #endif
; 0000 0090    ++tx_counter;
; 0000 0091    }
; 0000 0092 else
; 0000 0093    UDR=c;
; 0000 0094 #asm("sei")
; 0000 0095 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void main(void)
; 0000 009D {
_main:
; .FSTART _main
; 0000 009E // Declare your local variables here
; 0000 009F LED l1 = {'c', 0};
; 0000 00A0 LED l2 = {'c', 1};
; 0000 00A1 LED l3 = {'c', 2};
; 0000 00A2 LED l4 = {'c', 3};
; 0000 00A3 LED l5 = {'c', 4};
; 0000 00A4 LED l6 = {'c', 5};
; 0000 00A5 
; 0000 00A6 led_init(&l1);
	SBIW R28,30
	LDI  R24,30
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2C*2)
	LDI  R31,HIGH(_0x2C*2)
	RCALL __INITLOCB
;	l1 -> Y+25
;	l2 -> Y+20
;	l3 -> Y+15
;	l4 -> Y+10
;	l5 -> Y+5
;	l6 -> Y+0
	MOVW R26,R28
	ADIW R26,25
	RCALL _led_init
; 0000 00A7 led_init(&l2);
	MOVW R26,R28
	ADIW R26,20
	RCALL _led_init
; 0000 00A8 led_init(&l3);
	MOVW R26,R28
	ADIW R26,15
	RCALL _led_init
; 0000 00A9 led_init(&l4);
	MOVW R26,R28
	ADIW R26,10
	RCALL _led_init
; 0000 00AA led_init(&l5);
	MOVW R26,R28
	ADIW R26,5
	RCALL _led_init
; 0000 00AB led_init(&l6);
	MOVW R26,R28
	RCALL _led_init
; 0000 00AC 
; 0000 00AD // Input/Output Ports initialization
; 0000 00AE // Port B initialization
; 0000 00AF // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B0 //DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
; 0000 00B1 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B2 //PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
; 0000 00B3 
; 0000 00B4 // Port C initialization
; 0000 00B5 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 00B6 //DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
; 0000 00B7 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 00B8 //PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
; 0000 00B9 
; 0000 00BA // Port D initialization
; 0000 00BB // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00BC //DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
; 0000 00BD // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00BE //PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
; 0000 00BF 
; 0000 00C0 // Timer/Counter 0 initialization
; 0000 00C1 // Clock source: System Clock
; 0000 00C2 // Clock value: Timer 0 Stopped
; 0000 00C3 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00C4 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00C5 
; 0000 00C6 // Timer/Counter 1 initialization
; 0000 00C7 // Clock source: System Clock
; 0000 00C8 // Clock value: Timer1 Stopped
; 0000 00C9 // Mode: Normal top=0xFFFF
; 0000 00CA // OC1A output: Disconnected
; 0000 00CB // OC1B output: Disconnected
; 0000 00CC // Noise Canceler: Off
; 0000 00CD // Input Capture on Falling Edge
; 0000 00CE // Timer1 Overflow Interrupt: Off
; 0000 00CF // Input Capture Interrupt: Off
; 0000 00D0 // Compare A Match Interrupt: Off
; 0000 00D1 // Compare B Match Interrupt: Off
; 0000 00D2 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00D3 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00D4 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00D5 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00D6 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00D7 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00D8 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00D9 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00DA OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00DB OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00DC 
; 0000 00DD // Timer/Counter 2 initialization
; 0000 00DE // Clock source: System Clock
; 0000 00DF // Clock value: Timer2 Stopped
; 0000 00E0 // Mode: Normal top=0xFF
; 0000 00E1 // OC2 output: Disconnected
; 0000 00E2 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00E3 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00E4 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00E5 OCR2=0x00;
	OUT  0x23,R30
; 0000 00E6 
; 0000 00E7 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E8 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00E9 
; 0000 00EA // External Interrupt(s) initialization
; 0000 00EB // INT0: Off
; 0000 00EC // INT1: Off
; 0000 00ED MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00EE 
; 0000 00EF // USART initialization
; 0000 00F0 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00F1 // USART Receiver: On
; 0000 00F2 // USART Transmitter: On
; 0000 00F3 // USART Mode: Asynchronous
; 0000 00F4 // USART Baud Rate: 9600
; 0000 00F5 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00F6 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 00F7 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00F8 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00F9 UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 00FA 
; 0000 00FB // Analog Comparator initialization
; 0000 00FC // Analog Comparator: Off
; 0000 00FD // The Analog Comparator's positive input is
; 0000 00FE // connected to the AIN0 pin
; 0000 00FF // The Analog Comparator's negative input is
; 0000 0100 // connected to the AIN1 pin
; 0000 0101 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0102 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0103 
; 0000 0104 // ADC initialization
; 0000 0105 // ADC disabled
; 0000 0106 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0107 
; 0000 0108 // SPI initialization
; 0000 0109 // SPI disabled
; 0000 010A SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 010B 
; 0000 010C // TWI initialization
; 0000 010D // TWI disabled
; 0000 010E TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 010F 
; 0000 0110 // Global enable interrupts
; 0000 0111 #asm("sei")
	sei
; 0000 0112 
; 0000 0113 while(1)
_0x2D:
; 0000 0114 {
; 0000 0115     get_data(resData);
	LDI  R26,LOW(_resData)
	LDI  R27,HIGH(_resData)
	RCALL _get_data
; 0000 0116     if(resData[0] == 49)
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x31)
	BRNE _0x30
; 0000 0117     { // 1
; 0000 0118         if(resData[1] == 49)
	RCALL SUBOPT_0xD
	BRNE _0x31
; 0000 0119         {
; 0000 011A             led_on(&l1);
	MOVW R26,R28
	ADIW R26,25
	RCALL _led_on
; 0000 011B         }
; 0000 011C         else
	RJMP _0x32
_0x31:
; 0000 011D         {
; 0000 011E             led_off(&l1);
	MOVW R26,R28
	ADIW R26,25
	RCALL _led_off
; 0000 011F         }
_0x32:
; 0000 0120     }
; 0000 0121     else if(resData[0] == 50)
	RJMP _0x33
_0x30:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x32)
	BRNE _0x34
; 0000 0122     { // 2
; 0000 0123         if(resData[1] == 49)
	RCALL SUBOPT_0xD
	BRNE _0x35
; 0000 0124         {
; 0000 0125             led_on(&l2);
	MOVW R26,R28
	ADIW R26,20
	RCALL _led_on
; 0000 0126         }
; 0000 0127         else
	RJMP _0x36
_0x35:
; 0000 0128         {
; 0000 0129             led_off(&l2);
	MOVW R26,R28
	ADIW R26,20
	RCALL _led_off
; 0000 012A         }
_0x36:
; 0000 012B     }
; 0000 012C     else if(resData[0] == 51)
	RJMP _0x37
_0x34:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x33)
	BRNE _0x38
; 0000 012D     { // 3
; 0000 012E         if(resData[1] == 49)
	RCALL SUBOPT_0xD
	BRNE _0x39
; 0000 012F         {
; 0000 0130             led_on(&l3);
	MOVW R26,R28
	ADIW R26,15
	RCALL _led_on
; 0000 0131         }
; 0000 0132         else
	RJMP _0x3A
_0x39:
; 0000 0133         {
; 0000 0134             led_off(&l3);
	MOVW R26,R28
	ADIW R26,15
	RCALL _led_off
; 0000 0135         }
_0x3A:
; 0000 0136     }
; 0000 0137     else if(resData[0] == 52)
	RJMP _0x3B
_0x38:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x34)
	BRNE _0x3C
; 0000 0138     { // 4
; 0000 0139         if(resData[1] == 49)
	RCALL SUBOPT_0xD
	BRNE _0x3D
; 0000 013A         {
; 0000 013B             led_on(&l4);
	MOVW R26,R28
	ADIW R26,10
	RCALL _led_on
; 0000 013C         }
; 0000 013D         else
	RJMP _0x3E
_0x3D:
; 0000 013E         {
; 0000 013F             led_off(&l4);
	MOVW R26,R28
	ADIW R26,10
	RCALL _led_off
; 0000 0140         }
_0x3E:
; 0000 0141     }
; 0000 0142     else if(resData[0] == 53)
	RJMP _0x3F
_0x3C:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x35)
	BRNE _0x40
; 0000 0143     { // 5
; 0000 0144         if(resData[1] == 49)
	RCALL SUBOPT_0xD
	BRNE _0x41
; 0000 0145         {
; 0000 0146             led_on(&l5);
	MOVW R26,R28
	ADIW R26,5
	RCALL _led_on
; 0000 0147         }
; 0000 0148         else
	RJMP _0x42
_0x41:
; 0000 0149         {
; 0000 014A             led_off(&l5);
	MOVW R26,R28
	ADIW R26,5
	RCALL _led_off
; 0000 014B         }
_0x42:
; 0000 014C     }
; 0000 014D     else if(resData[0] == 54)
	RJMP _0x43
_0x40:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x36)
	BRNE _0x44
; 0000 014E     { // 6
; 0000 014F         if(resData[1] == 49)
	RCALL SUBOPT_0xD
	BRNE _0x45
; 0000 0150         {
; 0000 0151             led_on(&l6);
	MOVW R26,R28
	RCALL _led_on
; 0000 0152         }
; 0000 0153         else
	RJMP _0x46
_0x45:
; 0000 0154         {
; 0000 0155             led_off(&l6);
	MOVW R26,R28
	RCALL _led_off
; 0000 0156         }
_0x46:
; 0000 0157     }
; 0000 0158     else {}
_0x44:
_0x43:
_0x3F:
_0x3B:
_0x37:
_0x33:
; 0000 0159 }
	RJMP _0x2D
; 0000 015A }
_0x48:
	RJMP _0x48
; .FEND
;
;void get_data(unsigned char *data)
; 0000 015D {
_get_data:
; .FSTART _get_data
; 0000 015E     int i;
; 0000 015F     for(i = 0; i < 2; i++)
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR2
;	*data -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x4A:
	__CPWRN 16,17,2
	BRGE _0x4B
; 0000 0160     {
; 0000 0161         data[i] = getchar();
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0162     }
	__ADDWRN 16,17,1
	RJMP _0x4A
_0x4B:
; 0000 0163 }
	RCALL __LOADLOCR2
	ADIW R28,4
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

	.CSEG

	.CSEG

	.DSEG
_resData:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	RCALL SUBOPT_0x1
	LD   R30,X
	LDI  R31,0
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x0
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+3
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	IN   R1,24
	RCALL SUBOPT_0x7
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	EOR  R30,R1
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	IN   R1,21
	RCALL SUBOPT_0x7
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	EOR  R30,R1
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	IN   R1,18
	RCALL SUBOPT_0x7
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	EOR  R30,R1
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R26,_resData
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	__GETB2MN _resData,1
	CPI  R26,LOW(0x31)
	RET


	.CSEG
__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
