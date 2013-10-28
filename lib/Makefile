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
CFLAGS  += -ffunction-sections -fdata-sections # keep functions & data in seperate sections so they can be removed
CFLAGS	+= $(INCLUDE)
CFLAGS  += -D "USE_STDPERIPH_DRIVER"

PERIPH_SRC = $(wildcard $(PERIPH)/src/*.c)
PERIPH_INC = $(PERIPH)/inc/
PERIPH_OBJS = $(PERIPH_SRC:.c=.o)

periph: periph-lib periph-doc clean-periph

periph-lib: $(PERIPH_OBJS) $(PERIPH_INC)
	$(AR) r $(PERIPH_LIB) $(PERIPH_OBJS)

periph-doc:
	make -C $(PERIPH)/src

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

clean-periph:
	rm -rf $(PERIPH_OBJS)

clean-periph-doc:
	rm -rf ../doc/StdPeriph.pdf

clean-periph-all: clean-periph clean-periph-doc
	rm -rf $(PERIPH_LIB)
