#define LEFT_INFRA
#define RIGHT_INFRA
#define LEFT_TRIGGER
#define RIGHT_TRIGGER
#define LEFT_LINE
#define RIGHT_LINE
#define LEFT_MIN 500
#define LEFT_MAX 800
#define RIGHT_MIN 500
#define RIGHT_MAX 800

#include "lib/mct_fct.c"
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "lib/turbo_robo.c"

void seq_1(void);
void seq_2(void);
void seq_3(void);

int main()
{
    int i;
    int j;
    int k;

    init_out();
    init_in();
    init_timer();
    init_in_ana();
    sei();
    while((get_in_pin(7)));

    while(1)
    {
        fct_forward(1000, 5);
#ifdef LEFT_LINE
        while ((left_line <= LEFT_MAX) && (left_line >= LEFT_MIN))
        {
            sensor_fct = 1;
            fct_turn_left(200, 4);
            fct_backward(1000, 4);
            fct_turn_left(500, 4);
            sensor_fct = 0;
        }
#endif
#ifdef RIGHT_LINE
        while ((right_line <= RIGHT_MAX) && (right_line >= RIGHT_MIN))
        {
            sensor_fct = 1;
            fct_turn_right(200, 4);
            fct_backward(1000, 4);
            fct_turn_right(500, 4);
            sensor_fct = 0;
        }
#endif
#ifdef LEFT_INFRA
        if (!left_infra)
        {
            sensor_fct = 1;
            fct_backward(50, 5);
            fct_turn_right(700, 5);
            sensor_fct = 0;
        }
#endif
#ifdef RIGHT_INFRA
        if (!right_infra)
        {
            sensor_fct = 1;
            fct_backward(50, 5);
            fct_turn_left(700, 5);
            sensor_fct = 0;
        }
#endif
#ifdef LEFT_TRIGGER
        if (left_trigger)
        {
            sensor_fct = 1;
            fct_backward(50, 5);
            fct_turn_right(700, 5);
            sensor_fct = 0;
        }
#endif
#ifdef RIGHT_TRIGGER
        if (right_trigger)
        {
            sensor_fct = 1;
            fct_backward(50, 5);
            fct_turn_left(700, 5);
            sensor_fct = 0;
        }
#endif
    }
}

void seq_1(void)
{
}

void seq_2(void)
{
}

void seq_3(void)
{
}

