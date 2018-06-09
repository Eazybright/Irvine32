// main.cpp - Testing the IndexOf function.

#include <iostream>
#include <time.h>
#include "indexof.h"
using namespace std;

int main()  {
	// Fill an array with pseudorandom integers.
	const unsigned ARRAY_SIZE = 100000; 
	const unsigned LOOP_SIZE = 30000;
	char* boolstr[] = {"false","true"};

	long array[ARRAY_SIZE]; 
	for(unsigned i = 0; i < ARRAY_SIZE; i++) {
     array[i] = rand() % 50000;
	}
	
	long searchVal;
	time_t startTime, endTime;
	cout << "Enter an integer value to find: ";
	cin >> searchVal;
	cout << "Please wait...\n";

	// Test the Assembly language function.
	time( &startTime );
	long index = 0;

	for( unsigned n = 0; n < LOOP_SIZE; n++)
		 index = IndexOf( searchVal, array, ARRAY_SIZE );

	bool found = index != -1;

	time( &endTime );
	cout << "Elapsed ASM time: " << long(endTime - startTime) 
		  << " seconds. Found = " << boolstr[found] << endl;

	return 0;
}