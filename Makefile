# Target / project Name

NAME		= blink

# Startup files

OPENOCD_CFG	= stm32f0.cfg
LDSCRIPT	= stm32f0.ld
STARTUP		= startup_stm32f0xx.s

# Include locations
PERIPH = lib/StdPeriph
CMSIS = lib/CMSIS

INCLUDE = -Iinc
INCLUDE += -I$(PERIPH)/inc
INCLUDE += -I$(CMSIS)/Include
INCLUDE += -I$(CMSIS)/Device/ST/STM32F0xx/Include 

# GCC Tools

ARM_PREFIX	= arm-none-eabi
CC			= $(ARM_PREFIX)-gcc
LD			= $(ARM_PREFIX)-gcc
OBJCPY		= $(ARM_PREFIX)-objcopy
SIZE		= $(ARM_PREFIX)-size
GDB			= $(ARM_PREFIX)-gdb
OPENOCD		= openocd

# MCU Related flags

MCUFLAGS	= -mlittle-endian -mcpu=cortex-m0 -march-armv6-m
MCUFLAGS	= -mthumb -mfloat-abi=soft

# Optimization flags

OPTIMIZE	= -Os

# CFlags

CFLAGS		= -std=c99
CFLAGS		+= -Wall -Wextra -Warray-bounds
CFLAGS		+= -ffunction-sections -fdata-sections # Remove unused functions
CFLAGS		+= $(INCLUDE) $(MCUFLAGS)

# LDFlags

LDFLAGS		= -T$(LDSCRIPT) 
LDFLAGS		+= -Llib -lstm32f0_periph
LDFLAGS		+= -Wl,--gc-sections,-Map=$(NAME).map # Remove unused functions
LDFLAGS		+= -nostartfiles -static

vpath %.c src/
vpath %.s src/

#
# Source Files
#

#### Dont touch ########
CSRC = system_stm32f0xx.c
ASRC = $(STARTUP)
#######################
#
# Add sources here
# CSRC : C Source files
# ASRC : ASM Source files
#######################

CSRC +=	main.c
#SRC +=	gpio.c

#ASRC += 

OBJS	= $(CSRC:.c=.o) $(ASRC:.s=.o)

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	CFLAGS += -O0 -ggdb
else
	CFLAGS += $(OPTIMIZE)
endif



all: build

build: $(OBJS)
	$(LD)  $(LDFLAGS) -o $(NAME).elf $(OBJS)
	$(OBJCPY) -O ihex $(NAME).elf $(NAME).hex

clean:
	rm -f $(OBJS) *.hex *.elf *.bin *.map

.c.o:
	$(CC) $(CFLAGS) $(DEFS) -c $< -o $@

.s.o:
	$(CC) $(CFLAGS) $(DEFS) -c $< -o $@


