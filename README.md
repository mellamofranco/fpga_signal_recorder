#Signal Recorder Nexys-4 Artix-7 FPGA

VHDL vode for recorder that recieves a signal of 200 (8bit) values by UART serial and stores them inside nexys 
7 nexys 4 artix-7 FPGA and outpust to pinouts at output sample rate of 500 HZ/50 kHz.

To install must upload code to FPGA using xilinx vivdado using PinoutNexys4.xdc file for pinout config. 

Use usb cable or define new pins for UART comunication to send signal samples. 

Use AD7302 digital analog conversor to change digital output signal to analog. 
