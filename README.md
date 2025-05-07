# DE1_VHDL_proj

## Team members
Fridrich Oliver 

Ondrušková Ema 

Reinhard Květoslav

Vysloužil Miroslav 

## Abstract
This project implements a digital scoreboard system on the DE1 FPGA development board using VHDL. It features real-time score tracking for two teams, a countdown timer, and seven-segment display output. Key modules include Score.vhd and Score_B.vhd for team scores, timer.vhd for time management, bin2seg.vhd and seg_mult.vhd for display encoding, debounce.vhd for input stabilization, and clock_en.vhd for clock control. The top_level.vhd file integrates all components into a cohesive system, with a corresponding top_level.bit bitstream file for FPGA programming. This design provides a practical example of digital system development using VHDL on FPGA platforms.

## Location

Work_In_Prog/Final

https://github.com/xreinh01/DE1_VHDL_proj/tree/main/Work_In_Prog/Final

### The main contributions of the project are:

...
...
...

## Control scheme for a Nexys A7 50T

![NEXYS BOARD CONTROLS.drawio](https://github.com/xreinh01/DE1_VHDL_proj/blob/main/NEXYS%20BOARD%20CONTROLS.drawio.png)

Up and Right buttons are used for adding points for each team. The center button is used to reset the clock. Down button is used to load the timer from engaged switches. The switches are used for binary input that will convert to minutes and seconds showing length of each match.


## Hardware description of demo application
toplevel: 
![Screenshot 2025-04-24 124212](https://github.com/user-attachments/assets/b99dc00b-bd77-415d-b49b-3ec6b8acddd6)
