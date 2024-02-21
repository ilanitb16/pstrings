# AssemblyProject
This repo documents an implementation of P-String and realated functions in Assembly language as part of Computer Structure course I took at Bar-Ilan university.

## Background
P-String is a way to save string as an array of chars where the first byte represents the length of the string:

```ruby
typedef struct {
    char size;
    char string[255];
} Pstring;
```
In this repo I've implemented a P-String smilar to those in string.h library, but using assembly language.

### P-String in the Stack
The pstring "hello" will be stored in the stack as:

![image](https://github.com/ilanitb16/pstrings/assets/97344492/3d938e0d-54e8-43d1-bd38-99ac7a628245)


## Files
run_main.s -- program's entry.
pstring.s -- implementations of library functions.
func_select.s -- implementation of a function that call other functions.

## Program's Structure
run_main() gets two strings and two lengths from the user, build two pstrings and send them to run_func() in func_select.s. run_func uses a jump-table (switch-case) to determine what function from pstring.s to use.

## Notes
The code is heavily commented.
IDE: Visual Studio Code.
Useful document in resources directory: CS107 Handy one-page of x64-86.
