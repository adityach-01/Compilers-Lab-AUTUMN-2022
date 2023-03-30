/*
Name : Aditya Choudhary
Roll no : 20CS10005
Compilers Lab Assignment 2
*/

#include "myl.h"

int main()
{
    printStr("************TESTING BEGINS************\n");

    printStr("******* Testing the printStr function *******\n");

    printStr("\nString #1 : ");
    char* str1 = "Wow";
    int lenStr1 = printStr(str1);
    printStr("\nNo. of characters printed : ");
    printInt(lenStr1);

    printStr("\n\nString #2 : ");
    char* str2 = "This string has length : 27";
    int lenStr2 = printStr(str2);
    printStr("\nNo. of characters printed : ");
    printInt(lenStr2);

    printStr("\n\n******** Testing the readInt & printInt function ********\n");

    printStr("\nEnter Integer #1 : ");
    int n1;
    int flag1 = readInt(&n1);
    if(flag1 == ERR)
        printStr("Not a valid Integer");
    else {
        printStr("Integer entered : ");
        printInt(n1);
    }

    printStr("\n\nEnter Integer #2 : ");
    int n2;
    int flag2 = readInt(&n2);
    if(flag2 == ERR)
        printStr("Not a valid Integer");
    else {
        printStr("Integer entered : ");
        printInt(n2);
    }

    printStr("\n\n******** Testing the readFlt & printFlt function ********\n");
    
    printStr("\nEnter Float #1 : ");
    float f1;
    int flag3 = readFlt(&f1);
    if(flag3 == ERR)
        printStr("Not a valid Float");
    else {
        printStr("Float entered : ");
        printFlt(f1);
    }

    printStr("\n\nEnter Float #2 : ");
    float f2;
    int flag4 = readFlt(&f2);
    if(flag4 == ERR)
        printStr("Not a valid Float");
    else {
        printStr("Float entered : ");
        printFlt(f2);
    }
    printStr("\n\n");
}