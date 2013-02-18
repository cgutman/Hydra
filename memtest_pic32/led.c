
#include <plib.h>

void init(void)
{
	// Configure system for max performance at 80 MHz
//	SYSTEMConfigPerformance(80000000);

	// Make LED pins output
	PORTSetPinsDigitalOut(IOPORT_D, BIT_0 | BIT_1 | BIT_2);

	// Make 2nd switch pin input
	PORTSetPinsDigitalIn(IOPORT_D, BIT_6 | BIT_7 | BIT_13);

	// Clear LED pins
	PORTClearBits(IOPORT_D, BIT_0 | BIT_1 | BIT_2);
}

void clearRed(void)
{
	//PORTClearBits(IOPORT_D, BIT_0);
}

void clearYellow(void)
{
	//PORTClearBits(IOPORT_D, BIT_1);
}

void clearGreen(void)
{
	//PORTClearBits(IOPORT_D, BIT_2);
}

void red(void)
{
	if (PORTReadBits(IOPORT_D, BIT_6) != BIT_6)
		PORTSetBits(IOPORT_D, BIT_0);
	else
		PORTClearBits(IOPORT_D, BIT_0);
}

void yellow(void)
{
	if (PORTReadBits(IOPORT_D, BIT_7) != BIT_7)
		PORTSetBits(IOPORT_D, BIT_1);
	else
		PORTClearBits(IOPORT_D, BIT_1);
}

void green(void)
{
	if (PORTReadBits(IOPORT_D, BIT_13) != BIT_13)
		PORTSetBits(IOPORT_D, BIT_2);
	else
		PORTClearBits(IOPORT_D, BIT_2);
}