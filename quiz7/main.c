#include <msp430.h>
#include "msp430g2553.h"

int sw2 = 0;
int sema = 0;

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD; //stop watchdog timer
    P1DIR = 0x00; //port 1 all inputs
    P1DIR |= (BIT0 | BIT6); //set P1.0 and P1.6 as outputs (LED1, LED2)
    P1REN |= BIT3; //activate resister on P1.3
    P1OUT |= BIT3; //make it pull up because SW2 is active low

    for (;;) {
        sw2 = P1IN; //read values from P1
        sw2 &= BIT3; //mask out only BIT3 where SW2 is connected

        if (sw2 == BIT3) { //if SW2 is high

            switch(sema) {
            case 0:
                P1OUT &= ~BIT6;
                P1OUT ^= BIT0;
                break;
            case 1:
                P1OUT ^= BIT6;
                P1OUT &= ~BIT0;
                break;
            case 2:
                P1OUT &= ~BIT0;
                P1OUT &= ~BIT6;
                __delay_cycles(200000);
                P1OUT ^= BIT0;
                P1OUT ^= BIT6;
                break;
            case 3:
                P1OUT &= ~BIT0;
                P1OUT ^= BIT6;
                __delay_cycles(200000);
                P1OUT &= ~BIT6;
                P1OUT ^= BIT0;
            default:
                break;
            }
            __delay_cycles(200000);
        }
        else { //else (SW2 is low)
            P1OUT |= BIT0;
            P1OUT |= BIT6;
            sema++;
            if ( sema > 3 )
                sema = 0;

            __delay_cycles(500000);
        }
    }
}
