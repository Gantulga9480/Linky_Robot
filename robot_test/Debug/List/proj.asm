
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
	.DEF _cmd=R5
	.DEF _datalen=R6
	.DEF _datalen_msb=R7
	.DEF _i=R8
	.DEF _i_msb=R9
	.DEF _motorSpeed=R10
	.DEF _motorSpeed_msb=R11
	.DEF _rx_wr_index=R4
	.DEF _rx_rd_index=R13
	.DEF _rx_counter=R12

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
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2C:
	.DB  0x63,0x2,0x0,0x0,0x0,0x63,0x1,0x0
	.DB  0x0,0x0,0x63,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
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
;Project :
;Version :
;Date    : 3/5/2021
;Author  :
;Company :
;Comments:
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
	ST   -Y,R27
	ST   -Y,R26
;	*led -> Y+0
	RCALL SUBOPT_0x0
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x1
	BRNE _0x6
	IN   R1,23
	RCALL SUBOPT_0x2
	OUT  0x17,R30
	RJMP _0x5
_0x6:
	RCALL SUBOPT_0x3
	BRNE _0x7
	IN   R1,20
	RCALL SUBOPT_0x2
	OUT  0x14,R30
	RJMP _0x5
_0x7:
	RCALL SUBOPT_0x4
	BRNE _0x5
	IN   R1,17
	RCALL SUBOPT_0x2
	OUT  0x11,R30
_0x5:
	RCALL SUBOPT_0x0
	ADIW R26,3
	LDI  R30,LOW(1)
	ST   X,R30
	RJMP _0x2060001
; .FEND
_led_on:
; .FSTART _led_on
	RCALL SUBOPT_0x5
;	*led -> Y+0
	BREQ _0xA
	RCALL SUBOPT_0x6
	LDD  R30,Z+4
	CPI  R30,0
	BREQ _0xB
_0xA:
	RJMP _0x9
_0xB:
	RCALL SUBOPT_0x1
	BRNE _0xF
	RCALL SUBOPT_0x7
	RJMP _0xE
_0xF:
	RCALL SUBOPT_0x3
	BRNE _0x10
	RCALL SUBOPT_0x8
	RJMP _0xE
_0x10:
	RCALL SUBOPT_0x4
	BRNE _0xE
	RCALL SUBOPT_0x9
_0xE:
	RCALL SUBOPT_0x0
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
_0x9:
	RJMP _0x2060001
; .FEND
_led_off:
; .FSTART _led_off
	RCALL SUBOPT_0x5
;	*led -> Y+0
	BREQ _0x13
	RCALL SUBOPT_0x6
	LDD  R30,Z+4
	CPI  R30,0
	BRNE _0x14
_0x13:
	RJMP _0x12
_0x14:
	RCALL SUBOPT_0x1
	BRNE _0x18
	RCALL SUBOPT_0x7
	RJMP _0x17
_0x18:
	RCALL SUBOPT_0x3
	BRNE _0x19
	RCALL SUBOPT_0x8
	RJMP _0x17
_0x19:
	RCALL SUBOPT_0x4
	BRNE _0x17
	RCALL SUBOPT_0x9
_0x17:
	RCALL SUBOPT_0x0
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
_0x12:
_0x2060001:
	ADIW R28,2
	RET
; .FEND
;
;#define EMPTY 48
;#define LED_CMD 49
;#define MOTOR_CMD 50
;#define SENSOR_CMD 's'
;// Declare your global variables here
;LED leds[6];
;void get_data();
;void sensor_report();
;void led_control();
;void motor_control();
;unsigned char cmd;
;unsigned short datalen;
;unsigned short ledData[2];
;unsigned short motorData[4];
;int i;
;short motorSpeed;
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
; 0000 0047 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0048 char status,data;
; 0000 0049 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 004A data=UDR;
	IN   R16,12
; 0000 004B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x1B
; 0000 004C    {
; 0000 004D    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 004E #if RX_BUFFER_SIZE == 256
; 0000 004F    // special case for receiver buffer size=256
; 0000 0050    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0051 #else
; 0000 0052    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x1C
	CLR  R4
; 0000 0053    if (++rx_counter == RX_BUFFER_SIZE)
_0x1C:
	INC  R12
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x1D
; 0000 0054       {
; 0000 0055       rx_counter=0;
	CLR  R12
; 0000 0056       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0057       }
; 0000 0058 #endif
; 0000 0059    }
_0x1D:
; 0000 005A }
_0x1B:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0061 {
_getchar:
; .FSTART _getchar
; 0000 0062 char data;
; 0000 0063 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x1E:
	TST  R12
	BREQ _0x1E
; 0000 0064 data=rx_buffer[rx_rd_index++];
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0065 #if RX_BUFFER_SIZE != 256
; 0000 0066 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x21
	CLR  R13
; 0000 0067 #endif
; 0000 0068 #asm("cli")
_0x21:
	cli
; 0000 0069 --rx_counter;
	DEC  R12
; 0000 006A #asm("sei")
	sei
; 0000 006B return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 006C }
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
; 0000 0082 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0083 if (tx_counter)
	RCALL SUBOPT_0xA
	CPI  R30,0
	BREQ _0x22
; 0000 0084    {
; 0000 0085    --tx_counter;
	RCALL SUBOPT_0xA
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 0086    UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	RCALL SUBOPT_0xB
	LD   R30,Z
	OUT  0xC,R30
; 0000 0087 #if TX_BUFFER_SIZE != 256
; 0000 0088    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x23
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 0089 #endif
; 0000 008A    }
_0x23:
; 0000 008B }
_0x22:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0092 {
_putchar:
; .FSTART _putchar
; 0000 0093 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x24:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0x24
; 0000 0094 #asm("cli")
	cli
; 0000 0095 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	RCALL SUBOPT_0xA
	CPI  R30,0
	BRNE _0x28
	SBIC 0xB,5
	RJMP _0x27
_0x28:
; 0000 0096    {
; 0000 0097    tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	RCALL SUBOPT_0xB
	LD   R26,Y
	STD  Z+0,R26
; 0000 0098 #if TX_BUFFER_SIZE != 256
; 0000 0099    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x2A
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 009A #endif
; 0000 009B    ++tx_counter;
_0x2A:
	RCALL SUBOPT_0xA
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 009C    }
; 0000 009D else
	RJMP _0x2B
_0x27:
; 0000 009E    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 009F #asm("sei")
_0x2B:
	sei
; 0000 00A0 }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void main(void)
; 0000 00A8 {
_main:
; .FSTART _main
; 0000 00A9 // Declare your local variables here
; 0000 00AA LED l1 = {'c', 0};
; 0000 00AB LED l2 = {'c', 1};
; 0000 00AC LED l3 = {'c', 2};
; 0000 00AD // LED l4 = {'c', 3};
; 0000 00AE // LED l5 = {'c', 4};
; 0000 00AF // LED l6 = {'c', 5};
; 0000 00B0 led_init(&l1);
	SBIW R28,15
	LDI  R24,15
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2C*2)
	LDI  R31,HIGH(_0x2C*2)
	RCALL __INITLOCB
;	l1 -> Y+10
;	l2 -> Y+5
;	l3 -> Y+0
	MOVW R26,R28
	ADIW R26,10
	RCALL _led_init
; 0000 00B1 led_init(&l2);
	MOVW R26,R28
	ADIW R26,5
	RCALL _led_init
; 0000 00B2 led_init(&l3);
	MOVW R26,R28
	RCALL _led_init
; 0000 00B3 //led_init(&l4);
; 0000 00B4 //led_init(&l5);
; 0000 00B5 //led_init(&l6);
; 0000 00B6 leds[0] = l1;
	MOVW R30,R28
	ADIW R30,10
	LDI  R26,LOW(_leds)
	LDI  R27,HIGH(_leds)
	LDI  R24,5
	RCALL __COPYMML
; 0000 00B7 leds[1] = l2;
	__POINTW2MN _leds,5
	MOVW R30,R28
	ADIW R30,5
	LDI  R24,5
	RCALL __COPYMML
; 0000 00B8 leds[2] = l3;
	__POINTW2MN _leds,10
	MOVW R30,R28
	LDI  R24,5
	RCALL __COPYMML
; 0000 00B9 //leds[3] = l4;
; 0000 00BA //leds[4] = l5;
; 0000 00BB //leds[5] = l6;
; 0000 00BC 
; 0000 00BD // Input/Output Ports initialization
; 0000 00BE // Port B initialization
; 0000 00BF // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 00C0 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 00C1 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 00C2 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00C3 
; 0000 00C4 // Port C initialization
; 0000 00C5 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C6 // DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
; 0000 00C7 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C8 PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(56)
	OUT  0x15,R30
; 0000 00C9 
; 0000 00CA // Port D initialization
; 0000 00CB // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CC // DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
; 0000 00CD // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00CE // PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
; 0000 00CF 
; 0000 00D0 
; 0000 00D1 // Timer/Counter 0 initialization
; 0000 00D2 // Clock source: System Clock
; 0000 00D3 // Clock value: Timer 0 Stopped
; 0000 00D4 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00D5 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00D6 
; 0000 00D7 // Timer/Counter 1 initialization
; 0000 00D8 // Clock source: System Clock
; 0000 00D9 // Clock value: 15.625 kHz
; 0000 00DA // Mode: Ph. correct PWM top=0x00FF
; 0000 00DB // OC1A output: Non-Inverted PWM
; 0000 00DC // OC1B output: Non-Inverted PWM
; 0000 00DD // Noise Canceler: Off
; 0000 00DE // Input Capture on Falling Edge
; 0000 00DF // Timer Period: 32.64 ms
; 0000 00E0 // Output Pulse(s):
; 0000 00E1 // OC1A Period: 32.64 ms Width: 0 us
; 0000 00E2 // OC1B Period: 32.64 ms Width: 0 us
; 0000 00E3 // Timer1 Overflow Interrupt: Off
; 0000 00E4 // Input Capture Interrupt: Off
; 0000 00E5 // Compare A Match Interrupt: Off
; 0000 00E6 // Compare B Match Interrupt: Off
; 0000 00E7 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 00E8 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 00E9 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00EA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00EB ICR1H=0x00;
	OUT  0x27,R30
; 0000 00EC ICR1L=0x00;
	OUT  0x26,R30
; 0000 00ED OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00EE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00EF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F1 
; 0000 00F2 // Timer/Counter 2 initialization
; 0000 00F3 // Clock source: System Clock
; 0000 00F4 // Clock value: Timer2 Stopped
; 0000 00F5 // Mode: Normal top=0xFF
; 0000 00F6 // OC2 output: Disconnected
; 0000 00F7 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00F8 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00F9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00FA OCR2=0x00;
	OUT  0x23,R30
; 0000 00FB 
; 0000 00FC // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00FD TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00FE 
; 0000 00FF // External Interrupt(s) initialization
; 0000 0100 // INT0: Off
; 0000 0101 // INT1: Off
; 0000 0102 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0103 
; 0000 0104 // USART initialization
; 0000 0105 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0106 // USART Receiver: On
; 0000 0107 // USART Transmitter: On
; 0000 0108 // USART Mode: Asynchronous
; 0000 0109 // USART Baud Rate: 9600
; 0000 010A UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 010B UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 010C UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 010D UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 010E UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 010F 
; 0000 0110 // Analog Comparator initialization
; 0000 0111 // Analog Comparator: Off
; 0000 0112 // The Analog Comparator's positive input is
; 0000 0113 // connected to the AIN0 pin
; 0000 0114 // The Analog Comparator's negative input is
; 0000 0115 // connected to the AIN1 pin
; 0000 0116 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0117 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0118 
; 0000 0119 // ADC initialization
; 0000 011A // ADC disabled
; 0000 011B ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 011C 
; 0000 011D // SPI initialization
; 0000 011E // SPI disabled
; 0000 011F SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0120 
; 0000 0121 // TWI initialization
; 0000 0122 // TWI disabled
; 0000 0123 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0124 
; 0000 0125 // Global enable interrupts
; 0000 0126 #asm("sei")
	sei
; 0000 0127 
; 0000 0128 while (1)
_0x2D:
; 0000 0129    {
; 0000 012A       // Place your code here
; 0000 012B 	  // putchar(49);
; 0000 012C 	  // putchar(50);
; 0000 012D 	  // putchar(51);
; 0000 012E 	  sensor_report();
	RCALL _sensor_report
; 0000 012F       get_data();
	RCALL _get_data
; 0000 0130       if(cmd == LED_CMD)
	LDI  R30,LOW(49)
	CP   R30,R5
	BRNE _0x30
; 0000 0131       {
; 0000 0132     	led_control();
	RCALL _led_control
; 0000 0133       }
; 0000 0134       else if(cmd == MOTOR_CMD)
	RJMP _0x31
_0x30:
	LDI  R30,LOW(50)
	CP   R30,R5
	BRNE _0x32
; 0000 0135       {
; 0000 0136         motor_control();
	RCALL _motor_control
; 0000 0137       }
; 0000 0138       cmd = EMPTY;
_0x32:
_0x31:
	LDI  R30,LOW(48)
	MOV  R5,R30
; 0000 0139    }
	RJMP _0x2D
; 0000 013A }
_0x33:
	RJMP _0x33
; .FEND
;void led_control()
; 0000 013C {
_led_control:
; .FSTART _led_control
; 0000 013D 	if(ledData[1] == 1)
	__GETW1MN _ledData,2
	RCALL SUBOPT_0xC
	BRNE _0x34
; 0000 013E 	{
; 0000 013F 		led_on(&leds[ledData[0]-1]);
	RCALL SUBOPT_0xD
	RCALL _led_on
; 0000 0140 	}
; 0000 0141 	else
	RJMP _0x35
_0x34:
; 0000 0142 	{
; 0000 0143 		led_off(&leds[ledData[0]-1]);
	RCALL SUBOPT_0xD
	RCALL _led_off
; 0000 0144 	}
_0x35:
; 0000 0145 }
	RET
; .FEND
;
;void motor_control()
; 0000 0148 {
_motor_control:
; .FSTART _motor_control
; 0000 0149 	motorSpeed = 0;
	CLR  R10
	CLR  R11
; 0000 014A 	for(i = 2; i < datalen; i++)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
_0x37:
	__CPWRR 8,9,6,7
	BRSH _0x38
; 0000 014B 	{
; 0000 014C 		if(i == 2)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x39
; 0000 014D 		{
; 0000 014E 			motorSpeed = motorSpeed + motorData[i] * 100;
	RCALL SUBOPT_0xE
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12U
	RJMP _0x83
; 0000 014F 		}
; 0000 0150 		else if(i == 3)
_0x39:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x3B
; 0000 0151 		{
; 0000 0152 			motorSpeed = motorSpeed + motorData[i] * 10;
	RCALL SUBOPT_0xE
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	RJMP _0x83
; 0000 0153 		}
; 0000 0154 		else if(i == 4)
_0x3B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x3D
; 0000 0155 		{
; 0000 0156 			motorSpeed = motorSpeed + motorData[i];
	RCALL SUBOPT_0xE
_0x83:
	__ADDWRR 10,11,30,31
; 0000 0157 		}
; 0000 0158 	}
_0x3D:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x37
_0x38:
; 0000 0159 	if(motorData[0] == 1)
	RCALL SUBOPT_0xF
	SBIW R26,1
	BREQ PC+2
	RJMP _0x3E
; 0000 015A 	{
; 0000 015B 		if(motorData[1] == 0) PORTB |= 1 << PORTB0;
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x3F
	SBI  0x18,0
; 0000 015C 		else if(motorData[1] == 1) PORTB &= ~(1 << PORTB0);
	RJMP _0x40
_0x3F:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x41
	CBI  0x18,0
; 0000 015D 
; 0000 015E 		if(motorSpeed == 0)
_0x41:
_0x40:
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x42
; 0000 015F 		{
; 0000 0160 			if(motorData[1] == 1) OCR1AL = 0;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x43
	LDI  R30,LOW(0)
	RJMP _0x84
; 0000 0161 			else if(motorData[1] == 0) OCR1AL = 0xFA;
_0x43:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x45
	LDI  R30,LOW(250)
_0x84:
	OUT  0x2A,R30
; 0000 0162 		}
_0x45:
; 0000 0163 		else if(motorSpeed == 100)
	RJMP _0x46
_0x42:
	RCALL SUBOPT_0x11
	BRNE _0x47
; 0000 0164 		{
; 0000 0165 			if(motorData[1] == 1) OCR1AL = 0x64;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x48
	LDI  R30,LOW(100)
	RJMP _0x85
; 0000 0166 			else if(motorData[1] == 0) OCR1AL = 0x96;
_0x48:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x4A
	LDI  R30,LOW(150)
_0x85:
	OUT  0x2A,R30
; 0000 0167 		}
_0x4A:
; 0000 0168 		else if(motorSpeed == 150)
	RJMP _0x4B
_0x47:
	RCALL SUBOPT_0x12
	BRNE _0x4C
; 0000 0169 		{
; 0000 016A 			if(motorData[1] == 1) OCR1AL = 0x96;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x4D
	LDI  R30,LOW(150)
	RJMP _0x86
; 0000 016B 			else if(motorData[1] == 0) OCR1AL = 0x64;
_0x4D:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x4F
	LDI  R30,LOW(100)
_0x86:
	OUT  0x2A,R30
; 0000 016C 		}
_0x4F:
; 0000 016D 		else if(motorSpeed == 200)
	RJMP _0x50
_0x4C:
	RCALL SUBOPT_0x13
	BRNE _0x51
; 0000 016E 		{
; 0000 016F 			if(motorData[1] == 1) OCR1AL = 0xC8;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x52
	LDI  R30,LOW(200)
	RJMP _0x87
; 0000 0170 			else if(motorData[1] == 0) OCR1AL = 0x32;
_0x52:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x54
	LDI  R30,LOW(50)
_0x87:
	OUT  0x2A,R30
; 0000 0171 		}
_0x54:
; 0000 0172 		else if(motorSpeed == 250)
	RJMP _0x55
_0x51:
	RCALL SUBOPT_0x14
	BRNE _0x56
; 0000 0173 		{
; 0000 0174 			if(motorData[1] == 1) OCR1AL = 0xFA;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x57
	LDI  R30,LOW(250)
	RJMP _0x88
; 0000 0175 			else if(motorData[1] == 0) OCR1AL = 0;
_0x57:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x59
	LDI  R30,LOW(0)
_0x88:
	OUT  0x2A,R30
; 0000 0176 		}
_0x59:
; 0000 0177 	}
_0x56:
_0x55:
_0x50:
_0x4B:
_0x46:
; 0000 0178 	else if(motorData[0] == 2)
	RJMP _0x5A
_0x3E:
	RCALL SUBOPT_0xF
	SBIW R26,2
	BREQ PC+2
	RJMP _0x5B
; 0000 0179 	{
; 0000 017A 		if(motorData[1] == 0) PORTB |= 1 << PORTB3;
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x5C
	SBI  0x18,3
; 0000 017B 		else if(motorData[1] == 1) PORTB &= ~(1 << PORTB3);
	RJMP _0x5D
_0x5C:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x5E
	CBI  0x18,3
; 0000 017C 
; 0000 017D 		if(motorSpeed == 0)
_0x5E:
_0x5D:
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x5F
; 0000 017E 		{
; 0000 017F 			if(motorData[1] == 1) OCR1BL = 0;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x60
	LDI  R30,LOW(0)
	RJMP _0x89
; 0000 0180 			else if(motorData[1] == 0) OCR1BL = 0xFA;
_0x60:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x62
	LDI  R30,LOW(250)
_0x89:
	OUT  0x28,R30
; 0000 0181 		}
_0x62:
; 0000 0182 		else if(motorSpeed == 100)
	RJMP _0x63
_0x5F:
	RCALL SUBOPT_0x11
	BRNE _0x64
; 0000 0183 		{
; 0000 0184 			if(motorData[1] == 1) OCR1BL = 0x64;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x65
	LDI  R30,LOW(100)
	RJMP _0x8A
; 0000 0185 			else if(motorData[1] == 0) OCR1BL = 0x96;
_0x65:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x67
	LDI  R30,LOW(150)
_0x8A:
	OUT  0x28,R30
; 0000 0186 		}
_0x67:
; 0000 0187 		else if(motorSpeed == 150)
	RJMP _0x68
_0x64:
	RCALL SUBOPT_0x12
	BRNE _0x69
; 0000 0188 		{
; 0000 0189 			if(motorData[1] == 1) OCR1BL = 0x96;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x6A
	LDI  R30,LOW(150)
	RJMP _0x8B
; 0000 018A 			else if(motorData[1] == 0) OCR1BL = 0x64;
_0x6A:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x6C
	LDI  R30,LOW(100)
_0x8B:
	OUT  0x28,R30
; 0000 018B 		}
_0x6C:
; 0000 018C 		else if(motorSpeed == 200)
	RJMP _0x6D
_0x69:
	RCALL SUBOPT_0x13
	BRNE _0x6E
; 0000 018D 		{
; 0000 018E 			if(motorData[1] == 1) OCR1BL = 0xC8;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x6F
	LDI  R30,LOW(200)
	RJMP _0x8C
; 0000 018F 			else if(motorData[1] == 0) OCR1BL = 0x32;
_0x6F:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x71
	LDI  R30,LOW(50)
_0x8C:
	OUT  0x28,R30
; 0000 0190 		}
_0x71:
; 0000 0191 		else if(motorSpeed == 250)
	RJMP _0x72
_0x6E:
	RCALL SUBOPT_0x14
	BRNE _0x73
; 0000 0192 		{
; 0000 0193 			if(motorData[1] == 1) OCR1BL = 0xFA;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	BRNE _0x74
	LDI  R30,LOW(250)
	RJMP _0x8D
; 0000 0194 			else if(motorData[1] == 0) OCR1BL = 0;
_0x74:
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x76
	LDI  R30,LOW(0)
_0x8D:
	OUT  0x28,R30
; 0000 0195 		}
_0x76:
; 0000 0196 	}
_0x73:
_0x72:
_0x6D:
_0x68:
_0x63:
; 0000 0197 }
_0x5B:
_0x5A:
	RET
; .FEND
;
;void get_data()
; 0000 019A {
_get_data:
; .FSTART _get_data
; 0000 019B     cmd = getchar();
	RCALL _getchar
	MOV  R5,R30
; 0000 019C     datalen = (short)getchar() - EMPTY;
	RCALL SUBOPT_0x15
	MOVW R6,R30
; 0000 019D     for(i = 0; i < datalen; i++)
	CLR  R8
	CLR  R9
_0x78:
	__CPWRR 8,9,6,7
	BRSH _0x79
; 0000 019E     {
; 0000 019F         if(cmd == LED_CMD)
	LDI  R30,LOW(49)
	CP   R30,R5
	BRNE _0x7A
; 0000 01A0         {
; 0000 01A1             ledData[i] = (short)getchar() - EMPTY;
	MOVW R30,R8
	LDI  R26,LOW(_ledData)
	LDI  R27,HIGH(_ledData)
	RCALL SUBOPT_0x16
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x15
	POP  R26
	POP  R27
	RJMP _0x8E
; 0000 01A2         }
; 0000 01A3         else if(cmd == MOTOR_CMD)
_0x7A:
	LDI  R30,LOW(50)
	CP   R30,R5
	BRNE _0x7C
; 0000 01A4         {
; 0000 01A5             motorData[i] = (short)getchar() - EMPTY;
	MOVW R30,R8
	LDI  R26,LOW(_motorData)
	LDI  R27,HIGH(_motorData)
	RCALL SUBOPT_0x16
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x15
	POP  R26
	POP  R27
_0x8E:
	ST   X+,R30
	ST   X,R31
; 0000 01A6         }
; 0000 01A7     }
_0x7C:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x78
_0x79:
; 0000 01A8 }
	RET
; .FEND
;
;void sensor_report()
; 0000 01AB {
_sensor_report:
; .FSTART _sensor_report
; 0000 01AC 	if(~PINC & (1 << PINC3))
	IN   R30,0x13
	COM  R30
	ANDI R30,LOW(0x8)
	BREQ _0x7D
; 0000 01AD 	{
; 0000 01AE 		putchar(SENSOR_CMD);
	RCALL SUBOPT_0x17
; 0000 01AF 		putchar('1');
; 0000 01B0 		putchar('1');
	LDI  R26,LOW(49)
	RJMP _0x8F
; 0000 01B1 	} else {
_0x7D:
; 0000 01B2 			putchar(SENSOR_CMD);
	RCALL SUBOPT_0x17
; 0000 01B3 		  	putchar('1');
; 0000 01B4 		  	putchar('0');}
	LDI  R26,LOW(48)
_0x8F:
	RCALL _putchar
; 0000 01B5 	if(~PINC & (1 << PINC4))
	IN   R30,0x13
	COM  R30
	ANDI R30,LOW(0x10)
	BREQ _0x7F
; 0000 01B6 	{
; 0000 01B7 		putchar(SENSOR_CMD);
	RCALL SUBOPT_0x18
; 0000 01B8 		putchar('2');
; 0000 01B9 		putchar('1');
	LDI  R26,LOW(49)
	RJMP _0x90
; 0000 01BA 	} else {putchar(SENSOR_CMD);
_0x7F:
	RCALL SUBOPT_0x18
; 0000 01BB 			putchar('2');
; 0000 01BC 			putchar('0');}
	LDI  R26,LOW(48)
_0x90:
	RCALL _putchar
; 0000 01BD 	if(~PINC & (1 << PINC5))
	IN   R30,0x13
	COM  R30
	ANDI R30,LOW(0x20)
	BREQ _0x81
; 0000 01BE 	{
; 0000 01BF 		putchar(SENSOR_CMD);
	RCALL SUBOPT_0x19
; 0000 01C0 		putchar('3');
; 0000 01C1 		putchar('1');
	LDI  R26,LOW(49)
	RJMP _0x91
; 0000 01C2 	} else {putchar(SENSOR_CMD);
_0x81:
	RCALL SUBOPT_0x19
; 0000 01C3 			putchar('3');
; 0000 01C4 			putchar('0');}
	LDI  R26,LOW(48)
_0x91:
	RCALL _putchar
; 0000 01C5 	putchar(101);
	LDI  R26,LOW(101)
	RCALL _putchar
; 0000 01C6 }
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
_leds:
	.BYTE 0x1E
_ledData:
	.BYTE 0x4
_motorData:
	.BYTE 0x8
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	RCALL SUBOPT_0x0
	LD   R30,X
	LDI  R31,0
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R27
	ST   -Y,R26
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+3
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	IN   R1,24
	RCALL SUBOPT_0x6
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	EOR  R30,R1
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	IN   R1,21
	RCALL SUBOPT_0x6
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	EOR  R30,R1
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	IN   R1,18
	RCALL SUBOPT_0x6
	LDD  R30,Z+1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	EOR  R30,R1
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDS  R30,_tx_counter
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xC:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDS  R30,_ledData
	LDS  R31,_ledData+1
	SBIW R30,1
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL __MULW12U
	SUBI R30,LOW(-_leds)
	SBCI R31,HIGH(-_leds)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	MOVW R30,R8
	LDI  R26,LOW(_motorData)
	LDI  R27,HIGH(_motorData)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R26,_motorData
	LDS  R27,_motorData+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x10:
	__GETW1MN _motorData,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL _getchar
	LDI  R31,0
	SBIW R30,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(115)
	RCALL _putchar
	LDI  R26,LOW(49)
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(115)
	RCALL _putchar
	LDI  R26,LOW(50)
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(115)
	RCALL _putchar
	LDI  R26,LOW(51)
	RJMP _putchar


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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
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
