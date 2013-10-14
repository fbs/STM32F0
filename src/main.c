#include "stm32f0xx.h"
#include "stm32f0xx_conf.h"

#define BSRR_VAL 0x0300

GPIO_InitTypeDef        GPIO_InitStructure;

void delay (__IO uint32_t n)
{
  while (n-- > 0);
}

extern void Delay (__IO uint32_t n);

int main(void)
{
  /* GPIOC Periph clock enable */
  RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOC, ENABLE);

  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9 | GPIO_Pin_8;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
  GPIO_Init(GPIOC, &GPIO_InitStructure);

  while (1)
    {
      GPIO_ResetBits(GPIOC, GPIO_Pin_8);
      GPIO_SetBits(GPIOC, GPIO_Pin_9);
      delay(0xFFFFF);
      GPIO_SetBits(GPIOC, GPIO_Pin_8);
      GPIO_ResetBits(GPIOC, GPIO_Pin_9);
      delay(0xFFFFF);
    }

}
