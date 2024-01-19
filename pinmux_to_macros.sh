#!/bin/bash

: "
Steps to run:
1. copy contents of pinmux rows from PinMux_Index.xlsx
into 'input' file.
example: cat input | head -10
gpio0_0  seuart_rx_a     uart0_rx_a      lpi2s_sdi_a     spi0_ss0_a      lpi2c_scl_a  ana_s0   ble_dbg0
gpio0_1  seuart_tx_a     uart0_tx_a      lpi2s_sdo_a     spi0_ss1_a      lpi2c_sda_a  ana_s1   ble_dbg1

2. run pinmux_to_macros.sh script
example: sh pinmux_to_macros.sh
The output looks like below:
#define PIN_P0_0                        0
#define PIN_P0_0__GPIO          PINMUX_PIN(PIN_P0_0, 0)
#define PIN_P0_0__SEUART_RX_A           PINMUX_PIN(PIN_P0_0, 1)
#define PIN_P0_0__UART0_RX_A            PINMUX_PIN(PIN_P0_0, 2)
#define PIN_P0_0__LPI2S_SDI_A           PINMUX_PIN(PIN_P0_0, 3)
#define PIN_P0_0__SPI0_SS0_A            PINMUX_PIN(PIN_P0_0, 4)
#define PIN_P0_0__LPI2C_SCL_A           PINMUX_PIN(PIN_P0_0, 5)
#define PIN_P0_0__ANA_S0                PINMUX_PIN(PIN_P0_0, 6)
#define PIN_P0_0__BLE_DBG0              PINMUX_PIN(PIN_P0_0, 7)

#define PIN_P0_1                        1
#define PIN_P0_1__GPIO          PINMUX_PIN(PIN_P0_1, 0)
#define PIN_P0_1__SEUART_TX_A           PINMUX_PIN(PIN_P0_1, 1)
#define PIN_P0_1__UART0_TX_A            PINMUX_PIN(PIN_P0_1, 2)
#define PIN_P0_1__LPI2S_SDO_A           PINMUX_PIN(PIN_P0_1, 3)
#define PIN_P0_1__SPI0_SS1_A            PINMUX_PIN(PIN_P0_1, 4)
#define PIN_P0_1__LPI2C_SDA_A           PINMUX_PIN(PIN_P0_1, 5)
#define PIN_P0_1__ANA_S1                PINMUX_PIN(PIN_P0_1, 6)
#define PIN_P0_1__BLE_DBG1              PINMUX_PIN(PIN_P0_1, 7)
"
total_lines=$(cat input | wc -l)
line=1
pin_offset=0

for line in `seq $total_lines` ; do
	i=0
	for iter in `cat input | head -$line | tail -1` ; do
		if [ $i -eq 0 ] ; then
			pin_num=$(echo $iter | sed "s:gpio\([0-9]*_[0-9]\).*:\1:g")
			echo -e "#define\tPIN_P${pin_num}\t\t\t${pin_offset}"
		fi
		echo $iter  | tr [a-z] [A-Z] | sed "s:\t:\n:g" | sed "/^$/d" | sed "s: *$::g" | sed "s:^ *:#define\tPIN_P${pin_num}__:g"  |  sed  "s:GPIO.*:GPIO:g" | sed "s:$:\t\tPINMUX_PIN(PIN_P${pin_num}, $i):g"
		i=`expr $i + 1`
	done
	line=`expr $line + 1`
	pin_offset=`expr $pin_offset + 1`
	echo -ne "\n"
done
