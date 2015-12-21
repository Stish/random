#define LEFT_LINE
#define RIGHT_LINE
#define LEFT_MIN 0
#define LEFT_MAX 300
#define RIGHT_MIN 0
#define RIGHT_MAX 300

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
        fct_forward(1000, 2);
#ifdef LEFT_LINE
        while ((left_line <= LEFT_MAX) && (left_line >= LEFT_MIN))
        {
            sensor_fct = 1;
            fct_turn_left(50, 3);
            sensor_fct = 0;
        }
#endif
#ifdef RIGHT_LINE
        while ((right_line <= RIGHT_MAX) && (right_line >= RIGHT_MIN))
        {
            sensor_fct = 1;
            fct_turn_right(50, 3);
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

