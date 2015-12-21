//====================================//
//==			LCD Board			==//
//==								==//
//==		C Code by Alex.			==//
//====================================//

#define CLR_S2 2
#define CLR_S3 3
#define CLR_IN 2
#define ULTRA_ENABLE_OUT 1
#define ULTRA_ECHO_IN 1
#define F_CPU 14745600
#define __OPTIMIZE__

#include "lib/mct_fct.c"
#include "lib/lcd_sr.c"
#include <avr/interrupt.h>
#include <avr/signal.h>
#include <util/delay.h>


unsigned int left_line = 0;
unsigned int right_line = 0;
unsigned int battery_state_pre = 0;

unsigned char ad_pin = 0;				//switching between pin 0 (AD in 1) and pin 1 (AD in 2)	 and pin 3 (AD in 3)		

unsigned int battery_state = 0;

unsigned char sensor_fct = 0;
unsigned char brght_left[5] = {'t','e','s','t'}; 
unsigned char brght_right[5] = {'t','e','s','t'};
unsigned char battery[5] = {'t','e','s','t'};
unsigned char dist[5] = {0,0,0,0};
//unsigned char red[5] = {0,0,0,0};
//unsigned char green[5] = {0,0,0,0};
//unsigned char blue[5] = {0,0,0,0};


unsigned char i_left, i_right = 0;

SIGNAL (SIG_ADC)
{
	switch (ad_pin)
	{
		case 0:
			right_line = ADCL;
			right_line |= (ADCH<<8);	
			ad_pin = 1;
			ADMUX = 0x41;
			break;
		case 1:
			left_line = ADCL;
			left_line |= (ADCH<<8);
			ad_pin = 2;
			ADMUX = 0x42;
			break;
		case 2:
			battery_state_pre = ADCL;
			battery_state_pre |= (ADCH<<8);
			ad_pin = 0;
			ADMUX = 0x40;
			break;
		default:
			break;
	}
}

void init_timer(void)
{
	TCNT2 = 0x00;
	TCCR2 = 0x04;
	
	TCNT0 = 0x00;
	TCCR0 = 0x02;
	
	TIMSK |= 0x41;
}

int main(void)
{
	unsigned int u_seconds = 100; 
	unsigned int i = 100;
//	unsigned int clr_red = 100;
//	unsigned int clr_blue = 100;
//	unsigned int clr_green = 100;
	
	init_out();
	init_in();
//    init_timer();
	init_in_ana();
	lcd_init();
	sei();
	
	lcd_setpos(1, 1);
	lcd_string("Left Bright:  ");
	lcd_setpos(2, 1);
	lcd_string("Right Bright: ");
	lcd_setpos(3, 1);
	lcd_string("Battery State: ");
	lcd_setpos(4,1);
	lcd_string("Distance: 10m");
	
	while(1)
	{
		brght_left[0] = (left_line / 1000) +48;
		brght_left[1] = ((left_line - (left_line / 1000)*1000) / 100) +48;
		brght_left[2] = ((left_line - (left_line / 100)*100) / 10) +48;
		brght_left[3] = ((left_line - (left_line / 10)*10)) +48;
		brght_right[0] = (right_line / 1000) +48;
		brght_right[1] = ((right_line - (right_line / 1000)*1000) / 100) +48;
		brght_right[2] = ((right_line - (right_line / 100)*100) / 10) +48;
		brght_right[3] = ((right_line - (right_line / 10)*10)) +48;
		battery_state = battery_state_pre*1.65;
		battery[0] = (battery_state/1000) +48;
		battery[1] = ((battery_state - (battery_state / 1000)*1000) / 100) +48;
		battery[2] = '.';
		battery[3] = ((battery_state - (battery_state / 100)*100) / 10) +48;
		dist[0] = (u_seconds / 1000) +48;
		dist[1] = ((u_seconds - (u_seconds / 1000)*1000) / 100) +48;
		dist[2] = ((u_seconds - (u_seconds / 100)*100) / 10) +48;
		dist[3] = ((u_seconds - (u_seconds / 10)*10)) +48;
		lcd_setpos(1, 15);
		lcd_string(brght_left);
		lcd_setpos(2, 15);
		lcd_string(brght_right);
		lcd_setpos(3, 16);
		lcd_string(battery);
		lcd_setpos(4, 11);
		lcd_string(dist);
		lcd_setpos(4, 16);
		lcd_string("cm");
		
/*		lcd_setpos(4, 1);
		lcd_string('b');
		lcd_setpos(4, 2);
		lcd_string(blue);
		
		lcd_setpos(4, 7);
		lcd_string('r');
		lcd_setpos(4, 8);
		lcd_string(red);
		
		lcd_setpos(4, 13);
		lcd_string('g');
		lcd_setpos(4, 14);
		lcd_string(green);	*/	
// ================= Ultrasonic ====================
		u_seconds = 0;
		set_out_pin(ULTRA_ENABLE_OUT);
		_delay_us(10);
		reset_out_pin(ULTRA_ENABLE_OUT);
		for (i = 0; i <= 3000; i++)
		{
			_delay_us(1);
			if (get_in_pin(ULTRA_ECHO_IN))
			{
				u_seconds++;
			}
		}
		u_seconds = u_seconds;
/*
// ================= Color Sensor ==================
		clr_red = 0;
		clr_blue = 0;
		clr_green = 0;
// =============== Red =============================
		reset_pin_out(CLR_S2);
		reset_pin_out(CLR_S3);
		for (i = 0; i <= 3000; i++)
		{
			if (get_in_pin(CLR_IN))
			{
				clr_red++;
			}
		}
// =============== blue ============================
		reset_pin_out(CLR_S2);
		set_pin_out(CLR_S3);
		for (i = 0; i <= 3000; i++)
		{
			if (get_in_pin(CLR_IN))
			{
				clr_blue++;
			}
		}
// =============== green ===========================
		set_pin_out(CLR_S2);
		set_pin_out(CLR_S3);
		for (i = 0; i <= 3000; i++)
		{
			if (get_in_pin(CLR_IN))
			{
				clr_green++;
			}
		}*/
	}
}


