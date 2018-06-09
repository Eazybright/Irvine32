// ArraySum.c

int arraySum( int array[], int count )
{
	int i;
	int sum = 0;

	for(i = 0; i < count; i++)
	  sum += array[i];
	
	return sum;
}


void main()
{
	int array[10] = {1,2,3,4,5,6,7,8,9,10};

	int sum = arraySum( array, 50 );

}