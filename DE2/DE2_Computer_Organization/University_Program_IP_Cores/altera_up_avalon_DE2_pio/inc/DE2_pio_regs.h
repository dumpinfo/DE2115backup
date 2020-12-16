/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

#ifndef __DE2_PIO_REGS_H__
#define __DE2_PIO_REGS_H__

#include <io.h>

#define IOADDR_DE2_PIO_DATA(base)           __IO_CALC_ADDRESS_NATIVE(base, 0)
#define IORD_DE2_PIO_DATA(base)             IORD(base, 0) 
#define IOWR_DE2_PIO_DATA(base, data)       IOWR(base, 0, data)

#define IOADDR_DE2_PIO_DIRECTION(base)      __IO_CALC_ADDRESS_NATIVE(base, 1)
#define IORD_DE2_PIO_DIRECTION(base)        IORD(base, 1) 
#define IOWR_DE2_PIO_DIRECTION(base, data)  IOWR(base, 1, data)

#define IOADDR_DE2_PIO_IRQ_MASK(base)       __IO_CALC_ADDRESS_NATIVE(base, 2)
#define IORD_DE2_PIO_IRQ_MASK(base)         IORD(base, 2) 
#define IOWR_DE2_PIO_IRQ_MASK(base, data)   IOWR(base, 2, data)

#define IOADDR_DE2_PIO_EDGE_CAP(base)       __IO_CALC_ADDRESS_NATIVE(base, 3)
#define IORD_DE2_PIO_EDGE_CAP(base)         IORD(base, 3) 
#define IOWR_DE2_PIO_EDGE_CAP(base, data)   IOWR(base, 3, data)

#endif /* __DE2_PIO_REGS_H__ */
