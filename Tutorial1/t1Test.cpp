//
// t1Test.cpp
//

#include "stdafx.h"         // pre-compiled headers
#include "t1.h"
#include <iostream>         // std::cout
#include "fib32.h"          // header file for fib32.asm
#include <chrono>

//
// fib: C++
//
int fib(int n) {
	int fi, fj, t;

	if (n <= 1)
		return n;

	fi = 0;
	fj = 1;
	while (n > 1) {
		t = fj;
		fj = fi + fj;
		fi = t;
		n--;
	}
	return fj;
}

//
// fib: C/C++ and inline IA32 assembly language
//
int fib_IA32(int n) {
	_asm {      mov eax, n          }   // mov n into eax
	_asm {      cmp eax, 1          }   // if (n <= 0)
	_asm {      jle L3              }   // return n
	_asm {      xor ecx, ecx        }   // fi = 0
	_asm {      mov edx, 1          }   // fj = 1
	_asm {L1:   cmp eax, 1          }   // while (n > 1)
	_asm {      jle L2              }   //
	_asm {      mov ebx, ecx        }   // ebx = fi
	_asm {      add ebx, edx        }   // ebx = fi + fj
	_asm {      mov ecx, edx        }   // fi = fj
	_asm {      mov edx, ebx        }   // fj = ebx
	_asm {      dec eax             }   // n--
	_asm {      jmp L1              }   //
	_asm {L2:   mov eax, edx        }   // eax = fj
	_asm {L3:                       }   //
}

//
//Array sum through inline assembly
//
int array_proc_inline(int array[], int n)
{
	_asm {
		mov esi, array	// address of input_array
		mov ecx, n		// input_array size
		mov eax, 0		// clearing the accumulator
		L1 : add eax, [esi]
			 add esi, 4
			 loop L1
	}
}

//
// Multiple_k
//
void multiple_k(uint16_t N, uint16_t K, uint16_t* array)
{
	for (uint16_t i = 0; i < N; ++i)
	{
		if ((i + 1) % K == 0)
		{
			array[i] = 1;
		}
		else
		{
			array[i] = 0;
		}
	}
}

//
// check
//
void check(const char *s, int v, int expected) {
	std::cout << s << " = " << v;
	if (v == expected) {
		std::cout << " OK";
	}
	else {
		std::cout << " ERROR: should be " << expected;
	}
	std::cout << "\n";
}

int main() {
	 //Evaluating the procedures
	
	 //t1
	
	 //Polynomial evaluation
	auto begin = std::chrono::high_resolution_clock::now();
	check("poly(2)", poly(2), 7);
	check("poly(3)", poly(3), 13);
	check("poly(-1)", poly(-1), 1);
	check("poly(-2)", poly(-2), 3);
	auto end = std::chrono::high_resolution_clock::now();
	auto elapsed = std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin);
	printf("POLY FUNCTION Time measured: %.5f seconds.\n", elapsed.count() * 1e-9);

	// Factorial evaluation
	check("factorial(5)", factorial(5), 120);
	check("factorial(4)", factorial(4), 24);
	check("factorial(10)", factorial(7), 5040);
	check("factorial(6)", factorial(6), 720);

	// Multiple_k evluation
	uint16_t K1 = 3;
	const uint16_t N1 = 10;
	uint16_t array_N1[N1];
	uint16_t array_N2[N1];
	std::cout << "Array of multiples by Assembly: \n";
	multiple_k_asm(N1, K1, array_N1);
	for (uint16_t i = 0; i < N1; ++i)
		std::cout << array_N1[i] << " ";

	std::cout << "\n";

	std::cout << "Array of multiples by C++: \n";
	multiple_k(N1, K1, array_N2);
	for (uint16_t i = 0; i < N1; ++i)
		std::cout << array_N2[i] << " ";

	std::cout << "\n";

	uint16_t K2 = 7;
	const uint16_t N2 = 50;
	uint16_t array_N3[N2];
	uint16_t array_N4[N2];
	std::cout << "Array of multiples by Assembly: \n";
	multiple_k_asm(N2, K2, array_N3);
	for (uint16_t i = 0; i < N2; ++i)
		std::cout << array_N3[i] << " ";
	
	std::cout << "\n";

	std::cout << "Array of multiples by C++: \n";
	multiple_k(N2, K2, array_N4);
	for (uint16_t i = 0; i < N2; ++i)
		std::cout << array_N4[i] << " ";

	std::cout << "\n";

	//
	// fib: C++
	//
	std::cout << "Fibonnaci using C++:\n";
	for (int i = -1; i < 20; i++)
		std::cout << fib(i) << " ";
	std::cout << "\n";

	//
	// fib: mixed C++ and assmbly language
	//
	std::cout << "Fibonnaci using inline assembly:\n";
	for (int i = -1; i < 20; i++)
		std::cout << fib_IA32(i) << " ";
	std::cout << "\n";

	//
	// fib: IA32 assembly language  unoptimised (DEBUG version)
	//
	std::cout << "Fibonnaci using unoptimised assembly:\n";
	for (int i = -1; i < 20; i++)
		std::cout << fib_IA32a(i) << " ";
	std::cout << "\n";

	//
	// fib: IA32 assembly language optimised (RELEASE version)
	//
	std::cout << "Fibonnaci using optimised assembly:\n";
	for (int i = -1; i < 20; i++)
		std::cout << fib_IA32b(i) << " ";
	std::cout << "\n";

	// Sum of array through assembly
	int array[5] = { 1,2,3,4,5 };
	int array_size = 5;
	std::cout << "Array: ";
	for (int i = 0; i<array_size; i++)
		std::cout << array[i] << " ";

	std::cout << "\n";

	std::cout << "Sum: " << array_proc(array, array_size) << "\n";
	std::cout << "Sum with inline assembly: " << array_proc_inline(array, array_size) << "\n";
	std::cout << "Sum with bias: " << array_proc(array, array_size) + bias << "\n";
	

	//getchar();

	return 0;
}
