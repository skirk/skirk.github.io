---
layout: post
title: "Live code editing on Linux"
date: 2015-02-03 02:11
comments: true
categories: Cpp
---

Meanwhile waiting for nirvana, I've spent some time watching [the handmade hero](https://handmadehero.org/). The video series go through game development from start to finish, without using external libraries etc.

 One post particurarly struck me: a video about live code editing. The idea is to dynamically load libraries during runtime without closing windows or states. In practice, one can edit code, compile, and instantly see results without restarting the application. 

The videoblog does it on windows so I decided to translate the idea to Linux. In my demo application I have two things being updated every now and then: shaders and the demo code. I use [inotify](http://man7.org/linux/man-pages/man7/inotify.7.html) to check changes on these files and when one occurs the application reloads the file.

In essence, a directory is being watched for changes. In this case, the event IN_CLOSE_WRITE is of interest:

``` cpp
        inotifyFd = inotify_init1(IN_NONBLOCK);                                 
        if (inotifyFd == -1) {                                                  
                perror("Couldn't init inotify");                                
                exit(EXIT_FAILURE)                                              
        }                                                                       
        wd = inotify_add_watch(inotifyFd, "obj/", IN_CLOSE_WRITE);              
        if (wd == -1) {                                                         
                perror("Couldn't inotify_add_watch");                           
                exit(EXIT_FAILURE)                                              
        }                                                                       
```

Whenever inotify gets IN_CLOSE_WRITE events, a check is made whether the file is the shared library containing the demo code. However, a thing to note about a compilation process is that the target file is opened and closed multiple times. Hence, even though a IN_CLOSE_WRITE has been emitted, it doesn't mean the compilation is finished.

One solution is to keep trying to load the file until succeeded. In this simple example this works as compilation time is far less than a second.

``` cpp
	if (!strcmp(ievent->name, "libdemo.so")){
                demo_app demo_temp;                        
                closeDemo(demo);                           
                while (loadDemo(&demo_temp, demopath) < 0); 
                demo = demo_temp;                       
                (*demo.initf)(&mem);                    
        }   
```

The same thing can be done for shaders. In this project, instead of initiating shader compilation in the demo I use external shader compiler. This way I can compile straight from my text editor so I don't have to activate the demo window to send the compilation command. Furthermore, I let the Make utility to track the changes in shader sources. 

``` make
obj/shader.bin:  shader/vertex.vert shader/fragment.frag shader/geometry.glsl   
        ./shadercompiler -v shader/vertex.vert -f shader/fragment.frag -o obj/shader.bin
```

The video below showcases these ideas:

<iframe width="800" height="500" src="https://www.youtube.com/embed/PED2py0oABY" frameborder="0" allowfullscreen></iframe>



