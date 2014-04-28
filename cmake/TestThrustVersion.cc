
#include <iostream>
#include <thrust/version.h>

int main ()
{

  std::cout << "THRUST_MAJOR_VERSION "    << THRUST_MAJOR_VERSION    << std::endl;
  std::cout << "THRUST_MINOR_VERSION "    << THRUST_MINOR_VERSION    << std::endl;
  std::cout << "THRUST_SUBMINOR_VERSION " << THRUST_SUBMINOR_VERSION << std::endl;

  return 1;
}
