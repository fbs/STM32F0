CC		= arm-none-eabi-gcc
AR		= arm-none-eabi-ar

PERIPH = StdPeriph
CMSIS = CMSIS

PERIPH_LIB = libstm32f0_periph.a

INCLUDE  = -I.
INCLUDE += -Iinc
INCLUDE += -I$(PERIPH)/inc
INCLUDE += -I$(CMSIS)/Include
INCLUDE += -I$(CMSIS)/Device/ST/STM32F0xx/Include 

CFLAGS  = -g -O2 -Wall 
CFLAGS	+= -mlittle-endian -mthumb -mcpu=cortex-m0 -mthumb-interwork
CFLAGS	+=  -march=armv6s-m
CFLAGS	+= -ffreestanding -nostdlib
CFLAGS	+= $(INCLUDE)
CFLAGS  += -D "USE_STDPERIPH_DRIVER"

PERIPH_SRC = $(wildcard $(PERIPH)/src/*.c)
PERIPH_INC = $(PERIPH)/inc/
PERIPH_OBJS = $(PERIPH_SRC:.c=.o)

periph: $(PERIPH_OBJS) $(PERIPH_INC)
	$(AR) r $(PERIPH_LIB) $(PERIPH_OBJS)

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

clean-periph:
	rm -rf $(PERIPH_OBJS)

clean-periph-all: clean-periph
	rm -rf $(PERIPH_LIB)
