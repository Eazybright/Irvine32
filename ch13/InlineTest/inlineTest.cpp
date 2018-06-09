// test1.cpp - Test Inline Operators

#pragma warning (disable:4101)
// disable warning about unreferenced local variables

#include <iostream>

int main()
{
	std::cout << "(this program generates no output)\n\n";

struct Package {
  long originZip;        // 4
  long destinationZip;   // 4
  float shippingPrice;   // 4
};
  
   char myChar;
   bool myBool;
   short myShort;
   int  myInt;
   long myLong;
   float myFloat;
   double myDouble;
   Package myPackage;

   long double myLongDouble;
   long myLongArray[10];

__asm {
   mov  eax,myPackage.destinationZip;

   mov  eax,LENGTH myInt;         // 1
   mov  eax,LENGTH myLongArray;   // 10

   mov  eax,TYPE myChar;        // 1
   mov  eax,TYPE myBool;        // 1
   mov  eax,TYPE myShort;       // 2
   mov  eax,TYPE myInt;         // 4
   mov  eax,TYPE myLong;        // 4
   mov  eax,TYPE myFloat;       // 4
   mov  eax,TYPE myDouble;      // 8
   mov  eax,TYPE myPackage;     // 12
   mov  eax,TYPE myLongDouble;  // 8
   mov  eax,TYPE myLongArray;   // 4

   mov  eax,SIZE myLong;        // 4
   mov  eax,SIZE myPackage;     // 12
   mov  eax,SIZE myLongArray;   // 40
}

  return 0;
}