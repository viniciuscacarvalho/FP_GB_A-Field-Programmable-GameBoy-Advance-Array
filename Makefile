# Usage:
#   mingw32-make FILE=your_testbench      (no extension needed)

FILE ?= test_tb
BASE := $(basename $(FILE))

TARGET := $(BASE).vvp
VCD    := $(BASE).vcd

# Detect source file (.sv or .v)
SRC := $(firstword $(wildcard $(BASE).sv $(BASE).v))

.PHONY: all compile run wave clean

all: wave

# Compile directly passing the dumpfile/dumpvars inline via macros
$(TARGET): $(SRC)
	iverilog -g2012 -s __auto_dump__ -s $(BASE) \
		-D DUMP_FILE=\"$(VCD)\" \
		-o $@ $(SRC)

compile: $(TARGET)

$(VCD): $(TARGET)
	vvp $(TARGET)

run: $(VCD)

wave: run
	gtkwave $(VCD)

clean:
	-cmd /c del /f /q *.vvp *.vcd *_dump.v 2>nul