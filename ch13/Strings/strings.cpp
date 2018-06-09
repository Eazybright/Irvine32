// strings.cpp

// The strings example was designed to show how C++ creates
// stack space for a local variable (a string).

#include <string.h>

extern "C" void MakeString()
{
	char firstName[20];
	strcpy(firstName,"tim");
}

void main()
{
	MakeString();
}