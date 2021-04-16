#include "LED.h"
#include <mega8.h>

void led_init(LED *led)
{
	led->is_on = false;
	switch(led->pin_d)
	{
		case PB: DDRB |= 1 << led->pin; break;
		case PC: DDRC |= 1 << led->pin; break;
		case PD: DDRD |= 1 << led->pin; break;
	}
	led->is_init = true;
}
void led_on(LED *led)
{
	if(led->is_init && !led->is_on)
	{
		switch(led->pin_d)
		{
			case PB: PORTB ^= 1 << led->pin; break;
			case PC: PORTC ^= 1 << led->pin; break;
			case PD: PORTD ^= 1 << led->pin; break;
		}
		led->is_on = true;
	}
}

void led_off(LED *led)
{
	if(led->is_init && led->is_on)
	{
		switch(led->pin_d)
		{
			case PB: PORTB ^= 1 << led->pin; break;
			case PC: PORTC ^= 1 << led->pin; break;
			case PD: PORTD ^= 1 << led->pin; break;
		}
		led->is_on = false;
	}
}