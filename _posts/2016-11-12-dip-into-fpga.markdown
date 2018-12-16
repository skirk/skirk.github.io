---
layout: post
title: "A dip into FPGAs"
date: 2016-11-12 20:04
comments: true
categories: FPGA, Tinkering
---

Electronic circuits have always sparked my interest. However, my understanding of the topic has been minimal. When fronted with some free weekends I therefore decided to finally get a feeling what digital circuitry is all about. 

First step on my digital design journey was to get the kit. After several hours of research I settled on a [Nexys 4 DDR](https://reference.digilentinc.com/reference/programmable-logic/nexys-4-ddr/start). The FPGA board includes bells and whistles so a beginner can go great lengths without having to extend the board with any peripherals.

Secondly I needed some easily approachable information about to FPGA so I got myself some books. [Chu's excellent FPGA book](https://books.google.co.uk/books?id=mwUV7ZK9l9gC) ended up being my main reference. Another book investment I did was [Art of Electronics](https://artofelectronics.net/) which turned out to be mostly unrelated to my project. An extremely impressive book nevertheless.

After some evenings of reading I decided on a project: **A PC controllable digital alarm.** As a newbie I had no context how long such project would take and it turned out to be quite an undertaking in the end.

Initially I set out to implement all functionality in the digital circuitry. As things went along I started to realize I require several registers and some memory to store the alarm state. Implementing all that in the circuitry would have required an complex design of multiplexers and registers so I figured there ought to be a better way. I decided to introduce a softcore microcontroller into the project.

The logic for the alarm is fairly trivial so [PicoBlaze (aka KCPSM6)](https://www.xilinx.com/products/intellectual-property/picoblaze.html) seemed like a good fit. The instructions for the microcontroller are loaded into a Read-only memory from  which PicoBlaze reads the instructions as the clock ticks.

Another major part of the design is the PC-to-board communication. This is implement using UART circuit. In order to send data to the board, the PC uses serial communication over serial port which is processed by UART receiver. The received  data can be stored into registers or some random-access memory.

In the digital alarm clock design, the serial communication is used to set the alarm and the time. These command messages are then parsed by the PicoBlaze microcontoller which then either sets the time or stores the Alarm time into RAM memory.

Simplified view of the implemented design of the clock can be seen below. The _rx_ signal is the serial communication from the PC and clk is internal clock signal produced by a circuit on the board. The _AN_ array selects which of the 7-segment displays are on and the _SSEG_ array is used to determine which character to display. The _LED_ signal array turns on the led when alarm is being hit.

![blockdiagram](/assets/blockdiagram.png)

The microcontroller is responsible for most of the logic: parsing commands and managing the memory, multiplexing the 7-segment led displays, incrementing timer and checking whether alarm should be turned on. 

If current time of the digital alarm is same as the set alarm, the leds of the board are turned on. A small demo of the board can be seen below:

<iframe width="560" height="315" src="https://www.youtube.com/embed/XT1x2FgiiyY" frameborder="0" allowfullscreen></iframe>

Special thanks to people at ##fpga @ irc.freenode.net!

