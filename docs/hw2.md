# A first-level heading
## A second-level heading
### A third-level heading
**This is bold text**  
*This is italicized text*  
~~This is strikethrough text~~ 
**This is bold and *Italicized* Text**  
***Bold and italicized*** 
this is a <sub>subscript</sub> text 
this is a <sup>superscript</sup> text 
<rainbow>beepboop</rainbow> 

Text that is not a quote 
> Text that is a quote 
neat code block: 
```C
if(duty == 'R'){
		    transmission_UART_buf[4] = GarageState;
		    tx_UART_index = 0;
		    rx_UART = 0;
		    //UCA1IE |= UCTXCPTIE; //enable tx interrupt
		    UCB0IE &= ~UCTXIE0; // I2C Tx interrupt dissable
		    UCA1TXBUF = transmission_UART_buf[0];
		    __delay_cycles(2000);
            UCA1TXBUF = transmission_UART_buf[1];
            __delay_cycles(2000);
            UCA1TXBUF = transmission_UART_buf[2];
            __delay_cycles(2000);
            UCA1TXBUF = transmission_UART_buf[3];
            __delay_cycles(2000);
            UCA1TXBUF = transmission_UART_buf[4];
            __delay_cycles(2000);
            UCA1IE &= ~UCTXCPTIE; //Dissable tx interrupt
            UCB0IE |= UCTXIE0; // I2C Tx interrupt enable
		    rx_UART = 1;
		    duty = 'N';
		}
```

check out [google](google.com)
![happy emoji image](https://ps.w.org/emoji-toolbar/assets/icon-256x256.png?rev=2580091)

here is a cool list:
- Beep
* Boop
+ bloop

here it is in order:
1. beep
2. boop
3. bloop

look at this table:
| First header | Second Header|
| -------------| ------------ |
| Content 1,1  | Content 1,2  |
| Content 2,1  | Content 2,2  
