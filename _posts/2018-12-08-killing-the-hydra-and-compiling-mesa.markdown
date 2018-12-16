---
layout: post
title: "Killing the hydra (and compiling mesa)"
date: 2018-12-08 21:43
comments: true
tags: [mesa, linux]
---

Recently I took on the task to explore the graphics stack on linux. This post is about getting mesa up and running. As a kinetic learner the most fun kind of  exploration for me is to get my hands dirty by start changing and breaking things. In order to break stuff, the stuff needs to work first. 

### The mission statement
As one of my goals is to explore the graphics stack in it's entirety I thought it's best to get the whole shebang to run on a virtual machine (_vm_). This will allow to observe the system as a whole from the host machine. Also, there might be solutions for the running graphics stack on the dev machine, for example running two X sessions on the same machine. However to me it seemed like a bad idea so I decided for entirely different system for hacking around. 

### Practicalities 
I use qemu for hosting the _vm_. The responsibilities in this setup for the _vm_ are to a) build the graphics stack b) run the graphics stack. I built bunch of bash scripts to bring up a virtual machine up with series of predefined packages and tools. Tools at this stage mostly include things like gcc and cmake and the like. The awesome _deboostrap_ is doing the heavy lifting of this step.

Before firing up a real _vm_ we have can use _chroot_ for the initial build of mesa and it's dependencies. In theory this is faster than doing it within a _vm_. However, I have not done any serious benchmarking. Overall I thought it wouldn't take me too long to get through the build step but what I expected to be perhaps dozen of libraries exploded into 43 libraries. Anyway, after this step we have a root folder filled up with all the build tools and the libraries and we can bang it up into a _vm_ ready image using _virt-make-fs_ function. 

For a good measure let's also compile the kernel from source because why not?

After a lot of code compiling we can finally bring all the pieces together and run our 
_vm_ with the kernel and the image. The current setup is not happy with 32bit colours so I run X server with 

``` bash
$X -fbbpp 16 &
``` 
After that we can run the familiar _glxgears_ and _glxinfo_ to prove the setup works:

``` bash
$DISPLAY=:0 glxgears
$DISPLAY=:0 glxinfo
``` 

<video width="300" height="300" autoplay loop>
<source src="/assets/glxgears.webm" type="video/webm">
Your browser does not support the video tag.
</video> 

![glxinfo](/assets/glxinfo.png)

And here we have the whole graphics stack compiled from source.
See below for the code. If you decide to give it a spin and find some issues, please let me know!

### The code

[The virtual machine setup](https://gitlab.com/skirk/mesa-machine/blob/master/create_vm.sh)


[Mesa and it's dependencies](https://gitlab.com/skirk/mesa-dependencies/blob/master/CMakeLists.txt)
