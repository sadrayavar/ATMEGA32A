#include <mega32a.h>
#include <delay.h> // delay_ms functions
#include <stdio.h> // sprintf function
#include <alcd.h>  // lcd related functions
#define xtal 8'000'000

// prototyping functions
char menu(void);
char in_out_search(void);
char set_time(void);
char reserve_park(void);
char set_date(void);

unsigned int number_of_enters = 0, number_of_exits = 0;
int enter_array[31] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int exit_array[31] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned char day_index = 0;
unsigned char const init_capacity = 10;
signed char capacity = init_capacity, reserved = 0;
bit is_full = 0, is_empty = 1;
unsigned int second = 50, minute = 59, hour = 23, day = 29, month = 12, year = 1402;

// define timer interrupt: clock and date logic
interrupt[TIM2_OVF] void timer2_ovf_isr(void)
{

    // logic of second, minute, hour
    if (second == 59)
    {
        second = 0;
        if (minute == 59)
        {
            minute = 0;
            if (hour == 23)
            {
                hour = 0;
                day++;
            }
            else
                hour++;
        }
        else
            minute++;
    }
    else
        second++;

    // logic of day, month
    if (month <= 6)
    {
        if (day > 31)
        {
            day = 1;
            month++;
        }
    }
    else
    {
        if (month == 12)
        {
            if (day > 29)
            {
                day = 1;
                month++;
            }
        }
        else
        {
            if (day > 30)
            {
                day = 1;
                month++;
            }
        }
    }

    // logic of year
    if (month > 12)
    {
        month = 1;
        year++;
    }
}

// define interrupt 0: for exiting cars
interrupt[EXT_INT0] void ext_int0_isr(void)
{
    if (is_empty == 1)
    {
        lcd_clear();
        lcd_putsf("Empty");
        delay_ms(500);
    }
    else
    {

        capacity++;
        number_of_exits++;

        // check if the parking is empty
        if ((capacity + reserved) >= init_capacity)
        {
            capacity = init_capacity - reserved;
            is_empty = 1;
        }
        else
        {
            is_empty = 0;
        }

        // checking if the parking is full
        if (capacity <= 0)
        {
            capacity = 0;
            is_full = 1;
        }
        else
        {
            is_full = 0;
        }
    }
}

// define interrupt 1: for entering cars
interrupt[EXT_INT1] void ext_int1_isr(void)
{
    if (is_full == 1)
    {
        lcd_clear();
        lcd_putsf("Full");
        delay_ms(500);
    }
    else
    {

        capacity--;
        number_of_enters++;

        // checking if the parking is full
        if ((capacity) <= 0)
        {
            capacity = 0;
            is_full = 1;
        }
        else
        {
            is_full = 0;
        }

        // check if the parking is empty
        if ((capacity + reserved) >= init_capacity)
        {
            capacity = init_capacity - reserved;
            is_empty = 1;
        }
        else
        {
            is_empty = 0;
        }
    }
}

void main(void)
{
    char line[17], line2[17];

    GICR |= 0xC0;
    MCUCR = 0x0B;
    MCUCSR = 0x00;
    GIFR = 0xC0;

    // initilize lcd
    lcd_init(16);
    lcd_clear();
    lcd_gotoxy(0, 1);
    delay_ms(300);

    ASSR = 0x08; // timer2
    TCCR2 = 0x05;
    TCNT2 = 0x00;
    OCR2 = 0x00;
    TIMSK = 0x40;

    PORTA = 0b00011111;

#asm("sei")
    capacity = capacity - reserved;

    while (1)
    {
        if (PINA .2 == 0)
        {
            while (PINA .2 == 0)
                ;
            menu();
        }

        // save the enter and exits at the end of the day
        if (hour == 0 & minute == 0 & second == 0)
        {
            // save the data
            enter_array[day_index] = number_of_enters;
            exit_array[day_index] = number_of_exits;

            if (day_index >= 31) // shift the data if array is full
            {
                char i = 0;
                while (i < 31)
                {
                    enter_array[i] = enter_array[i + 1];
                    exit_array[i] = exit_array[i + 1];
                    i++;
                }
            }
            else // increment array index
                day_index++;

            while (hour == 0 & minute == 0 & second == 0)
            {
                lcd_clear();
                lcd_putsf("saving data");
            }
        }

        sprintf(line, "C=%d %d/%d/%d", capacity, year, month, day);
        sprintf(line2, "%d:%d:%d  R=%d ", hour, minute, second, reserved);
        lcd_clear();
        lcd_puts(line);
        lcd_gotoxy(0, 1);
        lcd_puts(line2);
        delay_ms(25);
    }
}

/// Functions 4 menu and...
char menu(void)
{
    char choice = 0;
    while (1)
    {
        // iterate through menu items
        if (choice == 0)
        {
            lcd_clear();
            lcd_putsf("Time Setting >>");
        }
        if (choice == 1)
        {
            lcd_clear();
            lcd_putsf("IN&OUT Search >>");
        }
        if (choice == 2)
        {
            lcd_clear();
            lcd_putsf("Reserve_Park >>");
        }
        if (choice == 3)
        {
            lcd_clear();
            lcd_putsf("Set date >>");
        }
        if (PINA .3 == 0) // next item
        {
            while (PINA .3 == 0)
                ;
            choice++;
            if (choice >= 4)
                choice = 0;
        }

        if (PINA .4 == 0) // close menu
        {                 // Back
            while (PINA .4 == 0)
                ;
            return 0;
        }

        // choose time_setting
        if (PINA .2 == 0 & choice == 0)
        {
            while (PINA .2 == 0)
                ;
            set_time();
        }

        // choose in_out_search
        if (PINA .2 == 0 & choice == 1)
        {
            while (PINA .2 == 0)
                ;
            in_out_search();
        }

        // choose reserve
        if (PINA .2 == 0 & choice == 2)
        {
            while (PINA .2 == 0)
                ;
            reserve_park();
        }

        // choose set date
        if (PINA .2 == 0 & choice == 3)
        {
            while (PINA .2 == 0)
                ;
            set_date();
        }

        delay_ms(25);
    }
}

// Time setting
char set_time(void)
{
    bit choice = 0;
    char line[17];
    while (1)
    {
        if (choice == 0)
        {
            sprintf(line, "Set min=%d  >", minute);
            lcd_clear();
            lcd_puts(line);
        }

        if (choice == 1)
        {
            sprintf(line, "Set hour=%d  >", hour);
            lcd_clear();
            lcd_puts(line);
        }

        if (PINA .1 == 0 & choice == 0)
        { // UP     min
            while (PINA .1 == 0)
                ;
            minute++;
            if (minute > 59)
                minute = 0;
        }

        if (PINA .0 == 0 & choice == 0)
        { // DOWN    min
            while (PINA .0 == 0)
                ;
            if (minute == 0)
                minute = 59;
            else
                minute--;
        }

        if (PINA .1 == 0 & choice == 1)
        { // UP    hour
            while (PINA .1 == 0)
                ;
            hour++;
            if (hour > 23)
                hour = 0;
        }

        if (PINA .0 == 0 & choice == 1)
        { // DOWN    hour
            while (PINA .0 == 0)
                ;
            if (hour == 0)
                hour = 23;
            else
                hour--;
        }

        if (PINA .3 == 0)
        { // NEXT
            while (PINA .3 == 0)
                ;
            choice = !choice;
        }

        if (PINA .4 == 0)
        { // Back
            while (PINA .4 == 0)
                ;
            return 0;
        }

        delay_ms(25);
    }
}

// IN&OUT Search
char in_out_search(void)
{
    char line[17], line2[17];
    int temp_year = year, temp_month = month, temp_day = day;
    int temp_day_index = day_index;

    while (1)
    {
        // UP
        if (PINA .1 == 0)
        {
            while (PINA .1 == 0)
                ;
            if (temp_day_index == 30)
            {
                lcd_clear();
                lcd_puts("Out of index.");
                delay_ms(300);
            }
            else
            {
                temp_day++;
                temp_day_index++;

                // logic of day, month
                if (temp_month <= 6)
                {
                    if (temp_day > 31)
                    {
                        temp_day = 1;
                        temp_month++;
                    }
                }
                else
                {
                    if (temp_month == 12)
                    {
                        if (temp_day > 29)
                        {
                            temp_day = 1;
                            temp_month++;
                        }
                    }
                    else
                    {
                        if (temp_day > 30)
                        {
                            temp_day = 1;
                            temp_month++;
                        }
                    }
                }

                // logic of year
                if (temp_month > 12)
                {
                    temp_month = 1;
                    temp_year++;
                }
            }
        }

        // DOWN
        if (PINA .0 == 0)
        {
            while (PINA .0 == 0)
                ;

            if (temp_day_index == 0)
            {
                lcd_clear();
                lcd_puts("Out of index.");
                delay_ms(300);
            }
            else
            {
                temp_day_index--;
                if (temp_day == 1)
                {
                    if (temp_month == 1)
                    {
                        temp_month = 12;
                        temp_year--;
                    }
                    else
                        temp_month--;

                    if (1 <= temp_month && temp_month <= 6)
                        temp_day = 31;
                    if (7 <= temp_month && temp_month <= 11)
                        temp_day = 30;
                    if (temp_month == 12)
                        temp_day = 29;
                }
                else
                    temp_day--;
            }
        }

        sprintf(line, "%d/%d/%d", temp_year, temp_month, temp_day);
        sprintf(line2, "in=%d out=%d %d %d", enter_array[temp_day_index], exit_array[temp_day_index]);

        lcd_clear();
        lcd_puts(line);
        lcd_gotoxy(0, 1);
        lcd_puts(line2);

        // Back
        if (PINA .4 == 0)
        {
            while (PINA .4 == 0)
                ;
            return 0;
        }
        delay_ms(25);
    }
}

// reserve_park
char reserve_park(void)
{
    char line[17];

    while (1)
    {
        sprintf(line, "Reserved=%d", reserved);
        lcd_clear();
        lcd_puts(line);

        if (PINA .1 == 0)
        {
            while (PINA .1 == 0)
                ;
            reserved++;
            capacity--;
        }

        if (reserved >= init_capacity)
        {
            reserved = init_capacity - 1;
        }

        if (PINA .0 == 0)
        {
            while (PINA .0 == 0)
                ;
            reserved--;
            capacity++;
        }

        if (reserved <= 0)
        {
            reserved = 0;
        }

        if (PINA .4 == 0)
        { // Back
            while (PINA .4 == 0)
                ;
            return 0;
        }
        delay_ms(25);
    }
}

//// data setting
char set_date(void)
{
    char choice = 0;
    char line[17];
    while (1)
    {
        if (choice == 1)
        {
            sprintf(line, "Set month=%d  >", month);
            lcd_clear();
            lcd_puts(line);
        }

        if (choice == 0)
        {
            sprintf(line, "Set day=%d  >", day);
            lcd_clear();
            lcd_puts(line);
        }

        if (choice == 2)
        {
            sprintf(line, "Set year=%d  >", year);
            lcd_clear();
            lcd_puts(line);
        }

        if (PINA .1 == 0 & choice == 1)
        { // UP     month
            while (PINA .1 == 0)
                ;
            month++;
            if (month > 12)
                month = 1;
        }

        if (PINA .0 == 0 & choice == 1)
        { // DOWN    month
            while (PINA .0 == 0)
                ;
            month--;
            if (month < 1)
                month = 12;
        }

        if (PINA .1 == 0 & choice == 0)
        { // UP    day
            while (PINA .1 == 0)
                ;
            day++;
            day_index = day;
            if (day > 31)
                day = 1;
        }

        if (PINA .0 == 0 & choice == 0)
        { // DOWN    day
            while (PINA .0 == 0)
                ;
            day--;
            day_index = day;
            if (day < 1)
                day = 31;
        }

        if (PINA .0 == 0 & choice == 2)
        { // DOWN    year
            while (PINA .0 == 0)
                ;
            year--;
            if (year < 1)
                year = 1300;
        }

        if (PINA .1 == 0 & choice == 2)
        { // UP    year
            while (PINA .1 == 0)
                ;
            year++;
            // if(year>1404)
            // year=0;
        }

        if (PINA .3 == 0)
        { // NEXT
            while (PINA .3 == 0)
                ;
            choice++;
            if (choice >= 3)
                choice = 0;
        }

        if (PINA .4 == 0)
        { // Back
            while (PINA .4 == 0)
                ;
            return 0;
        }

        delay_ms(25);
    }
}
