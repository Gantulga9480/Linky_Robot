/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 3/5/2021
Author  :
Company :
Comments:


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include "LED.h"

#define EMPTY 48
#define LED_CMD 49
#define MOTOR_CMD 50
#define SENSOR_CMD 's'
// Declare your global variables here
LED leds[6];
void get_data();
void sensor_report();
void led_control();
void motor_control();
unsigned char cmd;
unsigned short datalen;
unsigned short ledData[2];
unsigned short motorData[4];
int i;
short motorSpeed;

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

void main(void)
{
// Declare your local variables here
LED l1 = {'c', 0};
LED l2 = {'c', 1};
LED l3 = {'c', 2};
// LED l4 = {'c', 3};
// LED l5 = {'c', 4};
// LED l6 = {'c', 5};
led_init(&l1);
led_init(&l2);
led_init(&l3);
//led_init(&l4);
//led_init(&l5);
//led_init(&l6);
leds[0] = l1;
leds[1] = l2;
leds[2] = l3;
//leds[3] = l4;
//leds[4] = l5;
//leds[5] = l6;

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
// DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
// DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
// PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Ph. correct PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 32.64 ms
// Output Pulse(s):
// OC1A Period: 32.64 ms Width: 0 us
// OC1B Period: 32.64 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")

while (1)
   {
	  sensor_report();
      get_data();
      if(cmd == LED_CMD)
      {
    	led_control();
      }
      else if(cmd == MOTOR_CMD)
      {
        motor_control();
      }
      cmd = EMPTY;
   }
}
void led_control()
{
	if(ledData[1] == 1)
	{
		led_on(&leds[ledData[0]-1]);
	}
	else
	{
		led_off(&leds[ledData[0]-1]);
	}
}

void motor_control()
{
	motorSpeed = 0;
	for(i = 2; i < datalen; i++)
	{
		if(i == 2)
		{
			motorSpeed = motorSpeed + motorData[i] * 100;
		}
		else if(i == 3)
		{
			motorSpeed = motorSpeed + motorData[i] * 10;
		}
		else if(i == 4)
		{
			motorSpeed = motorSpeed + motorData[i];
		}
	}
	if(motorData[0] == 1)
	{
		if(motorData[1] == 0) PORTB |= 1 << PORTB0;
		else if(motorData[1] == 1) PORTB &= ~(1 << PORTB0);

		if(motorSpeed == 0)
		{
			if(motorData[1] == 1) OCR1AL = 0;
			else if(motorData[1] == 0) OCR1AL = 0xFA;
		}
		else if(motorSpeed == 100)
		{
			if(motorData[1] == 1) OCR1AL = 0x64;
			else if(motorData[1] == 0) OCR1AL = 0x96;
		}
		else if(motorSpeed == 150)
		{
			if(motorData[1] == 1) OCR1AL = 0x96;
			else if(motorData[1] == 0) OCR1AL = 0x64;
		}
		else if(motorSpeed == 200)
		{
			if(motorData[1] == 1) OCR1AL = 0xC8;
			else if(motorData[1] == 0) OCR1AL = 0x32;
		}
		else if(motorSpeed == 250)
		{
			if(motorData[1] == 1) OCR1AL = 0xFA;
			else if(motorData[1] == 0) OCR1AL = 0;
		}
	}
	else if(motorData[0] == 2)
	{
		if(motorData[1] == 0) PORTB |= 1 << PORTB3;
		else if(motorData[1] == 1) PORTB &= ~(1 << PORTB3);

		if(motorSpeed == 0)
		{
			if(motorData[1] == 1) OCR1BL = 0;
			else if(motorData[1] == 0) OCR1BL = 0xFA;
		}
		else if(motorSpeed == 100)
		{
			if(motorData[1] == 1) OCR1BL = 0x64;
			else if(motorData[1] == 0) OCR1BL = 0x96;
		}
		else if(motorSpeed == 150)
		{
			if(motorData[1] == 1) OCR1BL = 0x96;
			else if(motorData[1] == 0) OCR1BL = 0x64;
		}
		else if(motorSpeed == 200)
		{
			if(motorData[1] == 1) OCR1BL = 0xC8;
			else if(motorData[1] == 0) OCR1BL = 0x32;
		}
		else if(motorSpeed == 250)
		{
			if(motorData[1] == 1) OCR1BL = 0xFA;
			else if(motorData[1] == 0) OCR1BL = 0;
		}
	}
}

void get_data()
{
    cmd = getchar();
    datalen = (short)getchar() - EMPTY;
    for(i = 0; i < datalen; i++)
    {
        if(cmd == LED_CMD)
        {
            ledData[i] = (short)getchar() - EMPTY;
        }
        else if(cmd == MOTOR_CMD)
        {
            motorData[i] = (short)getchar() - EMPTY;
        }
    }
}

void sensor_report()
{
	if(~PINC & (1 << PINC3))
	{
		putchar(SENSOR_CMD);
		putchar('1');
		putchar('1');
	} else {
			putchar(SENSOR_CMD);
		  	putchar('1');
		  	putchar('0');}
	if(~PINC & (1 << PINC4))
	{
		putchar(SENSOR_CMD);
		putchar('2');
		putchar('1');
	} else {putchar(SENSOR_CMD);
			putchar('2');
			putchar('0');}
	if(~PINC & (1 << PINC5))
	{
		putchar(SENSOR_CMD);
		putchar('3');
		putchar('1');
	} else {putchar(SENSOR_CMD);
			putchar('3');
			putchar('0');}
	putchar(101);
}