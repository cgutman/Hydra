
#include <plib.h>

void init(void)
{
	// Configure system for max performance at 80 MHz
	SYSTEMConfigPerformance(80000000);

	// Make LED pins output
	PORTSetPinsDigitalOut(IOPORT_D, BIT_0 | BIT_1 | BIT_2);

	// Clear LED pins
	PORTClearBits(IOPORT_D, BIT_0 | BIT_1 | BIT_2);
}

void clearRed(void)
{
	PORTClearBits(IOPORT_D, BIT_0);
}

void clearYellow(void)
{
	PORTClearBits(IOPORT_D, BIT_1);
}

void clearGreen(void)
{
	PORTClearBits(IOPORT_D, BIT_2);
}

void red(void)
{
	PORTSetBits(IOPORT_D, BIT_0);
}

void yellow(void)
{
	PORTSetBits(IOPORT_D, BIT_1);
}

void green(void)
{
	PORTSetBits(IOPORT_D, BIT_2);
}