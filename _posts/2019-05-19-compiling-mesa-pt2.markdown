---
layout: post
title: "Compiling mesa pt.2"
date: 2019-03-17 21:43
comments: true
tags: [mesa, VM, containers, linux]
---

In the [previous post]({% post_url 2018-12-08-killing-the-hydra-and-compiling-mesa%}) about compiling mesa, I described my solution for compiling the whole linux graphics stack. In short, a cmake based solution to compile necessary binaries for running X11 on a Virtual Machine (VM). However the main issue with this approach is that modifying the code an seeing the results involve pushing code to hosted git server and then pulling it in within a chroot. Essentially the solution is good for building a static graphics stack that can be observed in a VM but for developing the stack you need a pipeline that allows faster turnaround to see the results.

To fix the issues, I ended up going on a much bigger journey that I anticipated. I split the environment into build machine container implemented in [systemd-nspawn](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html) and the target VM(qemu) machine that eventually runs the X11/mesa. I wanted my tools and the code to reside on the host, so no ssh-ing or other remoting to the build container.
In the end my solution looks like the graph below:

![Build Diagram](/assets/mesa-diagram.png)

I share two folders from the host to the container and one to the qemu. The container has access to the code folder and a another folder where the build artifacts will goto. This artifact folder that contains all binaries (after the build step) for X11 and mesa are shared to the target VM too. The target machine runs Xorg from the shared folder.

Some additinional niceties are that Within vim I can set _makeprg_ setting to call a shell script which initiates the cmake build system within the container. The nice thing is I'll get the printout from to built directly into my vim so I can navigate errors using the quickfix list as similary to a local build. 

All in all I'm pretty happy with the setup:

# Pros
+ I can use my favourite tools for the dev
+ Well defined and controlled build environment
+ Target machine runs it's own xorg instance

# Cons

+ Requires _a lot_ of setup, hopefully the maintenance will be less tedious
+ Due to VM the target machine is slow, as for now this is not a huge problem as I don't do intense graphics.

