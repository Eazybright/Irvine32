// arraysum.cpp
// Last update: 06/01/2006


void main()
{
	int array[] = {10,60,20,33,72,89,45,65,72,18};
	int sample = 50;
	int ArraySize = sizeof array / sizeof sample;
	int index = 0;
	int sum = 0;

	while( index < ArraySize )
	{
	if( array[index] > sample )
		sum += array[index];
	index++;
	}

}