---
layout: post
title: "Concurrency & Parallelism -  locks "
date: 2014-12-03 16:51
comments: true
categories: C&P, concurrency, parallelism
---

On my path to nirvana, I decided to detour to learn threading and concurrency. In this Concurrency & Parallelism series I'll go through some fundamental concepts that is involved. Most of the information (that will be ) presented in the series is new information for me. Therefore, the act of writing will work as my parser which formats the information in sensible manner. Hopefully this will be useful for someone else as well.

## Basic Synchronization

The usual solution to conduct interprocess synchronization is to use lock-based solutions such as _mutexes_ where certain shared data elements are locked in mutually exclusive manner. The shared variable modifiable by multitude of threads is _locked_ until a thread stops modifying the data. When finished the data is _unlocked_.

 Another synchronization primitive is a _semaphore_. The semaphore is an integer value  which either grants or denies access to a shared variable. The semaphore is initiated with an absolute value, usually 0. When a process or a thread comes across a semaphore, a subtraction of 1 is taken from the value. If the value is negative, the process waits until a kernel grants it an access over the semaphore. Meanwhile a process waits for a unlock, another process has to add one to the semaphore to grant access for the waiting process. 

Generally, mutexes are preferred over semaphores, because they enforce better code structure. Only single thread can lock and unlock mutex, whereas one thread can decrement semaphore and another increment {% cite Kerrisk %}. Mutex and semaphore are collectively called _locks_. Using locks for synchronization has several problems: 

One of them is _deadlock_, which is fairly easy to come across. The below image demonstrates 3 time steps, in which deadlock is achieved with two concurrent threads. Both of these threads will remain blocked indefinitely. 

{%img  /images/deadlock.svg %}

A kernel scheduler can also interrupt thread execution, in a case where an higher-priority process starts executing on a thread instead. This is called _priority inversion_. 

Lastly, _convoying_ of processes occur, in which a _convoy_ of processes queue at a sequence of locks {% cite lockfree %}.

In the posts to come, I will look into lock-free synchronization.   
 
## References

{% bibliography --cited %}
