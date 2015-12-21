#define LEFT_INFRA
#define RIGHT_INFRA
#define LEFT_TRIGGER
#define RIGHT_TRIGGER

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
        fct_forward(1000, 10);
#ifdef LEFT_INFRA
        if (!left_infra)
        {
            sensor_fct = 1;
            fct_backward(500, 10);
            fct_turn_left(300, 10);
            sensor_fct = 0;
        }
#endif
#ifdef RIGHT_INFRA
        if (!right_infra)
        {
            sensor_fct = 1;
            fct_backward(500, 10);
            fct_turn_right(300, 10);
            sensor_fct = 0;
        }
#endif
#ifdef LEFT_TRIGGER
        if (left_trigger)
        {
            sensor_fct = 1;
            fct_backward(500, 10);
            fct_turn_left(300, 10);
            sensor_fct = 0;
        }
#endif
#ifdef RIGHT_TRIGGER
        if (right_trigger)
        {
            sensor_fct = 1;
            fct_backward(500, 10);
            fct_turn_right(300, 10);
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

