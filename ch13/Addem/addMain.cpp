// Addem Main Program      (AddMain.cpp) 

#include <iostream>
using namespace std;

extern "C" int addem(int p1, int p2, int p3);

int main()
{
  int total = addem( 10, 15, 25 );
  cout << "Total = " << total << endl;

  return 0;
}


