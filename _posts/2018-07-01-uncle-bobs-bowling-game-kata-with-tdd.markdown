---
layout: post
title: "Uncle Bob's Bowling Game Kata with TDD"
date: 2018-07-01 21:20
comments: true
categories: TDD
---

As a small exercise I thought it would be nice to get my hands dirty with
some Test Driven Development exercises. It's a way of development I haven't really 
done before so I picked up a [Udemy course](https://www.udemy.com/beginning-test-driven-development-in-c/learn/v4/overview)
on the topic. (There were some summer sales and since I haven't done a Udemy course before I thought to give it a shot too).

The course quickly goes through TDD methodology and some more practical aspects of using Googletest framework for creating tests. Finally the course ends to an assignment of implementing [Uncle Bob's BowlingGameKata](http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata). 

I followed the course on my own way using Unix as an IDE rather than the proposed IDEs like Visual Studio/Clion etc.  My trusty old Debian setup did well and it was straightforward to use CMake to build the tests and CTest to run them. You can see [here](https://github.com/skirk/BobsBowlingTDD) the implementation.

As an future exercise to myself I'd like to start applying the TDD methodology in my day job as well as it's a nice way to breakdown complex problems.
