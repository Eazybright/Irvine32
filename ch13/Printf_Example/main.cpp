// main.cpp

// Older versions of the Visual C++ compiler required you
// insert a statement at the beginning of main() that
// declared and assigned a floating-point variable in order
// to load the floating-point library.

#include <stdio.h>
#include <string>
#include <strstream>
using namespace std;

extern "C" void asmMain( );
extern "C" void printSingle( float d, int precision );

void printSingle( float d, int precision )
{
	strstream temp;
	temp << "%." << precision << "f" << '\0';
	printf(temp.str( ), d );
}


int main( )
{
	asmMain( );
	return 0;
}