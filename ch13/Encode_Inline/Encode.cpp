// ENCODE.CPP - Copy and encrypt a file.

// Updated 6/28/05

#include <iostream>
#include <fstream>
#include "translat.h"

using namespace std;

void main( int argcount, char * args[] ) 
{  
	// Read input and output files from the command line.
	if( argcount < 3 ) {
		cout << "Usage: encode infile outfile" << endl;
		return;
	}

  const int BUFSIZE = 2000;
  char buffer[BUFSIZE];
  unsigned int count;				// character count
  
  unsigned char encryptCode;
  cout << "Encryption code [0-255]? ";
  cin >> encryptCode;

  ifstream infile( args[1], ios::binary );
  ofstream outfile( args[2], ios::binary );

  cout << "Reading " << args[1] << " and creating " 
		<< args[2] << endl;

  while (!infile.eof() )
  {
    infile.read(buffer, BUFSIZE );
    count = infile.gcount();

    __asm {
       lea esi,buffer
       mov ecx,count
       mov al, encryptCode
    L1:
       xor [esi],al
       inc  esi
       Loop L1
   } // asm
    
    outfile.write(buffer, count);
  }

}
