#pragma once
#include <stdint.h>

// Export poly() function
extern "C" int _cdecl poly(int, int);   // _cdecl calling convention
extern "C" void _cdecl multiple_k_asm(uint16_t, uint16_t, uint16_t*);   // _cdecl calling convention#pragma once
