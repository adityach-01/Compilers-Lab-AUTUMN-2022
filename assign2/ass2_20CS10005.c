/*
Name : Aditya Choudhary
Roll no : 20CS10005
Compilers Lab Assignment 2
*/

#include "myl.h"
#define BUFF 20
#define BUFF_F 30

int printStr(char *s){
    // len is the length of the string
    int len = 0;
    for(int i = 0; s[i] != '\0'; i++){
        len++;
    }

    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(s),"d"(len)
    );

    // As it does not print the '\0' charcter, which is included in the length of the string, we use len and not len+1
    return len;
}

int printInt(int n){
    char buff[BUFF];
    char zero = '0';
    int len = 0;  // len indicates the index available for n new value entry
    if(n == 0){
        buff[len] = zero;
        len++;
    }

    else{
        if(n < 0){
            buff[len++] = '-';
            n = -n;
        }

        // now loading the digits of n into the buffer
        while(n){
            int x = n%10;
            buff[len++] = (char)(zero+x);
            n = n/10;
        }

        // now since the digits are in reverse, we are reversing the digits except the sign bit
        int j = 0;
        if(buff[0] == '-') j = 1;
        // starting digit = j
        // ending digit = len-1
        int k = len-1;
        while(j < k){
            // swap j and k, then increment j and decrement k
            char temp = buff[j];
            buff[j] = buff[k];
            buff[k] = temp;
            j++;
            k--;
        }
    }

    buff[len] = '\0';
    len++;

    // now calling printStr to print the number stored in the buffer
    printStr(buff);

    return len;
}

int readInt(int *n){
    // read the integer as a string and pass onto the address of the integer to the pointer in the function argument
    char buff[BUFF];
    int len;
    __asm__ __volatile__(
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(len)
        :"S"(buff),"d"(BUFF)
    );

    int index = 0;  // contains the location of the last digit
    for(int i = 0; i < BUFF; i++){
        // every string is terminated by newline character while taking input
        if((int)(buff[i]) == 10){
            index = i-1;
            break;
        }
    }
    if(len <= 0) return ERR;  // empty string entered

    int j = 0;
    int isnegative = 0;

    // checking the sanity of the string entered, starting with the index 0 character
    if((buff[0] != '+') && (buff[0] != '-') && (buff[0] < '0' || buff[0] > '9'))    return ERR;


    if(buff[0] == '-' || buff[0] == '+'){
        j = 1;
        if(buff[0] == '-') isnegative = 1;
    }

    // converting the string entered into an integer 
    int x = 0;              // this is the final integer
    int power = 1;
    char zero = '0';
    while(index >= j){
        int chk = (int)(buff[index]-zero);
        if(chk < 0 || chk > 9) return ERR;

        x += chk*power;
        power *= 10;
        index--;
    }
    if(isnegative == 1) x = -x;
    *n = x;             // storing the integer in the address pointed by the pointer

    return OK;
}

int readFlt(float *f){
    // read the floating point number as a string and pass onto the address of the float to the pointer in the function argument
    char buff[BUFF_F];
    __asm__ __volatile__(
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff),"d"(BUFF)
    );

    int index = 0;     // last valid index of the string, or the next index where the string ends
    int decimal = -1;   // index of the decimal in the floating point number, number may or may not contain decimal point

    // using the newspace character to identify the end of the string entered
    for(int i = 0; i< BUFF_F; i++){
        if(buff[i] == '.') decimal = i;
        if((int)(buff[i]) == 10){
            index = i;
            break;
        }
    }

    int j = 0;
    int isnegative = 0;

    // sanity checking of the first character
    if((buff[0] != '+') && (buff[0] != '-') && (buff[0] < '0' || buff[0] > '9') && (buff[0] != '.'))    return ERR;


    if(buff[0] == '-' || buff[0] == '+' || buff[0] == '.'){
        j = 1;
        if(buff[0] == '-') isnegative = 1;
        if(buff[1] == '.') j = 2;
    }

    float intpart = 0;
    float decpart = 0;
    float x = 0;

    if(decimal == -1){
        decpart = 0.0;
        decimal = index;
    }

    // int part of the floating point number is between j and decimal-1, also checking the sanity of the digits entered

    int cnt = decimal-1;
    float power = 1.0;
    char zero = '0';
    while(cnt >= j){
        int x = (int)(buff[cnt]-zero);
        if(x < 0 || x > 9) return ERR;

        float f = (float)(x);
        intpart += f*power;
        power *= 10.0;
        cnt--;
    }

    // decimal part lies between decimal+1 and index-1, calculating the decimal part of the number

    // this condition checks if the number has a decimal point
    if(decimal != index){

        int cnt = decimal+1;
        float power = 0.1;

        while(cnt <= (index-1)){
            int x = (int)(buff[cnt]-zero);

            if(x < 0 || x > 9) return ERR;
            
            float f = (float)(x);
            decpart += f*power;
            power /= 10.0;
            cnt++;
        }
    }

    x = intpart + decpart;
    if(isnegative == 1) x = -x;
    *f = x;

    return OK;
}

int printFlt(float f){
    char buff[BUFF_F];
    char zero = '0';
    int len = 0;
    int j = 0;
    if(f < 0){
        buff[len++] = '-';
        j = 1;
        f = -f;
    }

    int x = (int)f;
    float dec = f - (float)(x);

    if(x == 0){
        buff[len++] = '0';
    }

    // put x in the buffer array
    while(x){
        int p = x%10;
        buff[len++] = (char)(p+zero);
        x = x/10;
    }
    
    // adding decimal point in the string
    buff[len] = '.';
    int decimal = len;    // contains the location of the decimal point in the character array
    len++;

    // adding numbers after decimal in the array
    // adding 6 numbers after decimal as defaut precision 
    for (int i = 0; i < 6; i++)
    {
        dec = dec*10.0;
        int x = (int)dec;
        x = x%10;
        buff[len++] = (char)(x+zero);
    }
    
    buff[len++] = '\0';

    // reversing the integer part as the digits are in reverse order
    // integer lies from j to decimal-1;
    int k = decimal-1;
    while(j<k){
        // swapping j and k in  the string, increasing j and decreasing k
        char temp = buff[j];
        buff[j] = buff[k];
        buff[k] = temp;
        j++;
        k--;
    }

    printStr(buff);

    return len;
}
