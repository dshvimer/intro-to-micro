//***********************************************************************
//******** CDA3331 Intro to Micro class, updated on October 21, 2016
//******** Dr. Bassem Alhalabi, FAU EE512, Boca Raton, Florida
//******** Contributors: Pablo Pastran 2015,
//******** Skeleton Program for Lab 4, in C
//******** Run this program as is to make sure you have correct hardware connections
//******** Explore the program and see the effect of Switches on pins P2.3-5
//******** Lab5 Grade --> Make the appropriate changes to the program per lab manual

#include <msp430.h> 

int main(void) {
    WDTCTL = WDTPW | WDTHOLD;    // Stop watchdog timer

    int pattern=0, led_pattern=0, temp=0;

    P1OUT = 0b00000000;     // mov.b    #00000000b,&P1OUT
    P1DIR = 0b11111111;     // mov.b    #11111111b,&P1DIR
    P2DIR = 0b00000000;     // mov.b    #00000000b,&P2DIR

    while (1)
    {
        pattern = P2IN;       //mov.b    &P2IN, R5
        if ((pattern & BIT0) == 0)   //checking P2.0 for read mode
        {
            led_pattern = pattern & (BIT3 | BIT4 | BIT5);
            P1OUT = led_pattern;
        }
        else   // display rotation mode
        {
            if (pattern & BIT1)
            {
                temp = led_pattern & BIT7;
                temp >>= 7;
                led_pattern <<= 1;
                led_pattern |= temp;
            }
            else
            {
                temp = led_pattern & BIT0;
                temp <<= 7;
                led_pattern >>= 1;
                led_pattern |= temp;
            }
            //you need to modify the toggle line below with pattern rotation based on the value of P2.1
            //led_pattern ^= 0xFF;                                     //toggle pattern
            led_pattern &= 0xFF;                                     //mask any excessive bits
            P1OUT = led_pattern;                                     //pattern out - display it

            //you need to replace the simple delay line below with slow/fast delay based on P2.2
            if (pattern & BIT2)
            {
                __delay_cycles( 800000);                                //slow
            }
            else
            {
                __delay_cycles( 400000);
            }
         }
    }
}
