#include "centrale_dcc.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xgpio.h"

int main(int argc, char* argv[]) {


    XGpio sw, led, bouton;
    XGpio_Initialize(&sw,  XPAR_LED_SWITCH_DEVICE_ID);
    XGpio_Initialize(&led,  XPAR_LED_SWITCH_DEVICE_ID);
    XGpio_Initialize(&bouton,  XPAR_BOUTONS_DEVICE_ID);
    XGpio_SetDataDirection(&sw, 2, 1);
    XGpio_SetDataDirection(&bouton, 1, 1);
    XGpio_SetDataDirection(&led, 1, 0);
    int mask_addr = 0b00000000000000000000000111111110;
    int mask_valid =0b00000000000000000000000000000001;
    unsigned char addr = 0;

    int a;
    int b;
    int rb = 0;
    int rb2 = 1;
    int validAddr = 0;
    while (1) {
        a = XGpio_DiscreteRead(&sw, 2);
        b = XGpio_DiscreteRead(&bouton, 1);

        if (rb == 1 && b == 0) {
            for (int i = 0; i < 100000; ++i);
        	rb2 = 1;
        }

        if (b == 4 && rb2 == 1) { // Button left decrements addr
        	--addr;
        	rb = 1;
        	rb2 = 0;
        }
        else if (b == 8 && rb2 == 1) { // Button right increments addr
        	++addr;
        	rb = 1;
        	rb2 = 0;
        }

        validAddr = addr;
        validAddr = validAddr << 1;

        validAddr = validAddr | (b & mask_valid);


        CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_CMDDCC_BASEADDR, CENTRALE_DCC_cmdDcc_SLV_REG1_OFFSET, a & 0x1);
        CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_CMDDCC_BASEADDR, CENTRALE_DCC_cmdDcc_SLV_REG2_OFFSET, (a & 0x2)>>1);
        CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_CMDDCC_BASEADDR, CENTRALE_DCC_cmdDcc_SLV_REG3_OFFSET, (a & 0x4)>>2);
        XGpio_DiscreteWrite(&led, 1, addr);
        CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_CMDDCC_BASEADDR, CENTRALE_DCC_cmdDcc_SLV_REG0_OFFSET, validAddr);
    }
    return 0;
}
