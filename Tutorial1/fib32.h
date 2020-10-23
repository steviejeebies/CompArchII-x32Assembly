#pragma once

//
// fib32.h
// example of mixing C++ and IA32 assembly language
//

//
// NB: "extern C" to avoid procedure name mangling by compiler
//

extern "C" int bias;
extern "C" int _cdecl fib_IA32a(int);   // _cdecl calling convention
extern "C" int _cdecl fib_IA32b(int);   // _cdecl calling convention
extern "C" int _cdecl array_proc(int array[], int);

// eof
