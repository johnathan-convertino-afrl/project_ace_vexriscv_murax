//#include "stddefs.h"
#include <stdint.h>

#include "murax.h"

void print(const char*str)
{
  while(*str){
    uart_write(UART,*str);
    str++;
  }
}
void println(const char*str)
{
  print(str);
  uart_write(UART,'\n');
}

void delay(uint32_t loops)
{
  for(int i=0;i<loops;i++)
  {
    int tmp = GPIO_A->OUTPUT;
  }
}

void main() {
    char data = 32;

    println("WELCOME TO THE RISCV HELLO WORLD UART PROGRAM!!");

    GPIO_A->OUTPUT_ENABLE = 0x0000FFFF;
    GPIO_A->OUTPUT = 0x0000FFFF;

    delay(90000000);

    for(;;)
    {
      uart_write(UART, data);
      data++;

      if(data == 127)
      {
        uart_write(UART, '\n');
        uart_write(UART, '\r');
        data = 32;
      }

      GPIO_A->OUTPUT = GPIO_A->INPUT;

      delay(200000);
    }
}

void irqCallback()
{
}
