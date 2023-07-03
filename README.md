# pinmux_index_to_defines
Convert rows of pinmux index into pinmux defines that can be used in Zephyr and Linux

Steps to convert pinmux indes into defines.
1. Copy the pinmux index rows from the PinMux spreadsheet into a file named 'temp'.
2. Execute pinmux_to_macros.sh bash script. Optionally, redirect the prints to a file pinctrl_defines.h.
   * sh pinmux_to_macros.sh
   * sh pinmux_to_macros.sh > pinctrl_defines.h
