#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char A;
unsigned char MEM[0xFF];

void LDA(unsigned char i);
void STA(unsigned char i);
void ADD(unsigned char i);
void SUB(unsigned char i);

int main(int argv, char **argc){
    MEM[0x80] = atoi(argc[1]); // X
    MEM[0x81] = atoi(argc[2]); // Y
    MEM[0x82] = 0; // S
    MEM[0x83] = 0; // counter
    MEM[0x84] = 0; // cte zero
    MEM[0x85] = 1; // cte one
    
    LDA(0x81);
    STA(0x83);
    while(A != 0){
        SUB(0x85);
        STA(0x83);

        LDA(0x82);
        ADD(0x80);
        STA(0x82);
        
        LDA(0x83);
    }
    printf("%d\n", MEM[0x82]);
}
void LDA(unsigned char i){
    A = MEM[i];
}
void STA(unsigned char i){
    MEM[i] = A;
}
void ADD(unsigned char i){
    A = A + MEM[i];
}
void SUB(unsigned char i){
    A = A - MEM[i];
}