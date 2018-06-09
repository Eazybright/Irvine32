// main.cpp

// Demonstrates function calls between a C++ program
// and an external assembly language module.
// Last update: 6/24/2005

#include <iostream>
#include <iomanip>
using namespace std;

extern "C" {
	// external ASM procedures:
	void DisplayTable();
	void SetTextOutColor( unsigned color );

	// local C++ functions:
	int askForInteger();
	void showInt( int value, int width );
}

// program entry point
int main()
{
	SetTextOutColor( 0x1E );	// yellow on blue
	DisplayTable();				// call ASM procedure
	return 0;
}

// Prompt the user for an integer. 

int askForInteger()
{
	int n;
	cout << "Enter an integer between 1 and 90,000: ";
	cin >> n;
	return n;
}

// Display a signed integer with a specified width.

void showInt( int value, int width )
{
	cout << setw(width) << value;
}
