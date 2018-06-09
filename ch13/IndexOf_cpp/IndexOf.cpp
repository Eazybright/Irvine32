// IndexOf.cpp

// Implements a linear search of an array of
// long integers.

#include "indexof.h"

long IndexOf( long searchVal, long array[], unsigned count )
{
	for(unsigned i = 0; i < count; i++) {
		if( array[i] == searchVal )
			return i;
	}
  return -1;
}
