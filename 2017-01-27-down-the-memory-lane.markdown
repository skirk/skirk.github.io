---
layout: post
title: "Down the Memory Lane"
date: 2017-04-03 21:12
comments: true
categories: 
---

"How do computers really work?" - is a question often asked. This has been 
fascination of mine for several years and I've even picked a book or two about 
 it. In hardware journalism the main stage is often given to the
CPU as that can be seen as the heart of the machine. It's arguably one of the 
sexier pieces of computer kit. Memory is equally important part of a machine
hence this article is dedicated to sum up some readings I've been doing lately
about memory, specifically the DRAM.

## The nitty-gritty bits

In the heart of a DRAM memory module is a storage cell which consists of a capacitor and a transistor. 
The capacitor holds some electrons whose state determines whether the bit is on or off.
To avoid leakage in the capacitor it is periodically refreshed, otherwise the data is lost.
In order to fetch or write the data of the storage cell, the word line is raised for long enough time to charge or drain the capacitor.

A single bit of memory is not quite enough so cells are organized into a matrix called _memory array_. In such organization a row and column addresses are needed to access a piece of data. It's a lot of work to decode and turn on electrical signals to get a single bit. Wouldn't it be nice to get something useful at once like a whole number!

{% img right /images/post/memarraycell.png 900 1100 Memory Array %} 

A solution to this is to add more memory arrays, like a stack. For example, if we had 4 memory arrays, a single memory command would give access to 4 bits of memory.



