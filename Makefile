# Target / project Name

NAME			= blink

# Startup files

OPENOCD_CFG		= stm32f0.cfg
LDSCRIPT		= stm32f0.ld
STARTUP			= startup_stm32f0xx.s
BUILDDIR		= build
OUTFILE			= $(BUILDDIR)/$(NAME)

# Target files

OUTPREFIX		= $(BUILDDIR)/$(NAME)
HEXFILE			= $(OUTPREFIX).hex
ELFFILE			= $(OUTPREFIX).elf
BINFILE			= $(OUTPREFIX).bin
MAPFILE			= $(OUTPREFIX).map

# Lib locations

PERIPH			= lib/StdPeriph
CMSIS			= lib/CMSIS

# Include locations

INCLUDE			= -Iinc
INCLUDE			+= -I$(PERIPH)/inc
INCLUDE			+= -I$(CMSIS)/Include
INCLUDE			+= -I$(CMSIS)/Device/ST/STM32F0xx/Include 

# GCC Tools

ARM_PREFIX		= arm-none-eabi
CC				= $(ARM_PREFIX)-gcc
LD				= $(ARM_PREFIX)-gcc
OBJCPY			= $(ARM_PREFIX)-objcopy
SIZE			= $(ARM_PREFIX)-size
GDB				= $(ARM_PREFIX)-gdb
GDBTUI			= $(ARM_PREFIX)-gdbtui

# Other Tools

OPENOCD			= openocd

# MCU Related flags

MCUFLAGS		= -mlittle-endian -mcpu=cortex-m0
MCUFLAGS		+= -mthumb -mfloat-abi=soft

# Optimization flags

OPTIMIZE		= -Os

# ASMFlags

AFLAGS			+= $(INCLUDE) $(MCUFLAGS)

# CFlags

CFLAGS			+= -std=c99
CFLAGS			+= -Wall -Wextra -Warray-bounds
CFLAGS			+= -ffunction-sections -fdata-sections # Remove unused functions
CFLAGS			+= $(INCLUDE) $(MCUFLAGS)

# LDFlags

LDFLAGS			+= -T$(LDSCRIPT) 
LDFLAGS			+= -Wl,--gc-sections,-Map=$(MAPFILE) # Remove unused functions
LDFLAGS			+= -nostartfiles

# Libs need to be at the end

LDLIBS			+= -Llib -lstm32f0_periph

# Terminal Colors

vpath %.c src/
vpath %.s src/

############### Debugging ############
#
# Use `make DEBUG=1` to enable debugging
#
######################################

DEBUG ?= 1

ifeq ($(DEBUG), 1)
	CFLAGS		+= -O0 -ggdb
	AFLAGS		+= -O0 -ggdb
	DEFS		+= -DDEBUG
else
	CFLAGS		+= $(OPTIMIZE)
	AFLAGS		+= $(OPTIMIZE)
endif

############### Colors ##############
#
# Use `make COLORS=0` to disable colors
#
#####################################

COLOR ?= 1

ifeq ($(COLOR), 1)
NO_COLOR		= \x1b[0m
GREEN_COLOR		= \x1b[32;01m
YELLOW_COLOR	= \x1b[33;01m
RED_COLOR		= \x1b[31;01m
BLUE_COLOR		= \x1b[34;01m
CYAN_COLOR		= \x1b[36;01m
endif


#
# Source Files
#

#### Dont touch ########
CSRC			= system_stm32f0xx.c stm32f0xx_it.c
ASRC			= $(STARTUP)
#######################
#
# Add sources here
# CSRC : C Source files
# ASRC : ASM Source files
#######################

CSRC			+= main.c
ASRC			+= delay.s

###### C Defs

DEFS			= -D "USE_STDPERIPH_DRIVER"
DEFS			+=

#####


AOBJS			+= $(patsubst %, $(BUILDDIR)/%,$(ASRC:.s=.o))
COBJS			= $(patsubst %, $(BUILDDIR)/%,$(CSRC:.c=.o))


all: setup build size

setup:
	@mkdir -p $(BUILDDIR)

build: setup $(COBJS) $(AOBJS)
	@echo -e '$(CYAN_COLOR)LINKING:\t$(BLUE_COLOR)$(COBJS)$(AOBJS)$(NO_COLOR)'
	$(LD) $(CFLAGS) $(LDFLAGS) -o $(ELFFILE) $(COBJS) $(AOBJS) $(LDLIBS)
	@$(OBJCPY) -O ihex $(ELFFILE) $(HEXFILE)
	@$(OBJCPY) -O binary $(ELFFILE) $(BINFILE)

clean:
	rm -rf $(BUILDDIR)

flash: build
	$(OPENOCD) -f $(OPENOCD_CFG) -c "stm_flash $(BINFILE)"

erase:
	$(OPENOCD) -f $(OPENOCD_CFG) -c "stm_erase"

debug: _startopenocd _gdb _killopenocd

size: build
	@echo -e '$(CYAN_COLOR)SIZE:\t\t$(BLUE_COLOR)$(ELFFILE)$(NO_COLOR)'
	@$(SIZE) $(ELFFILE)

_startopenocd: $(BIN)
	openocd -f $(OPENOCD_CFG) -c "halt" 1>/dev/null 2>/dev/null &

_killopenocd:
	@echo "shutdown" | nc localhost 4444 1>/dev/null 2>/dev/null

_gdb:
	$(GDB) --eval-command="target remote localhost:3333" $(ELF)


########### Compile / Assemble

$(COBJS): $(BUILDDIR)/%.o : %.c
	@echo -e '$(CYAN_COLOR)COMPILING:\t$(BLUE_COLOR)$<$(NO_COLOR)'	
	$(CC) $(CFLAGS) $(DEFS) -c $< -o $@

$(AOBJS): $(BUILDDIR)/%.o : %.s
	@echo -e '$(CYAN_COLOR)ASSEMBLING:\t$(BLUE_COLOR)$<$(NO_COLOR)'
	$(CC) $(AFLAGS) $(DEFS) -c $< -o $@

