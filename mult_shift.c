#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(int argv, char **argc){
    unsigned char x = atoi(argc[1]);
    unsigned char y = atoi(argc[2]);
    int s = 0;

    unsigned char count = 0;
    unsigned char y_ = y;
    unsigned char carry = 0;

    while(y_ != 0){
        carry = y_ % 2;
        y_ = y_ >> 1;
        if (carry){
            s = s + (x << count);
        }
        count ++;
    }
    printf("%d\n", s);
}