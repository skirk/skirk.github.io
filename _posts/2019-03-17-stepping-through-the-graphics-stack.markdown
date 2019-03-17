---
layout: post
title: "llvmpipe teardown"
date: 2019-03-17 21:43
comments: true
tags: [mesa, openGL]
---

Recently I've been studying the mesa stack and to get a bit more tangible feel of the code base I decided to turn my observations into a blog post.
The driver I'll be specifically studying is __llvmpipe__, and in this post I'll be explaining some of its higher level concepts.

As a reminder, here's a high level abstractions of a graphics pipeline as seen in many graphics and openGL books. 
This graph is more or less replicated from the excellent [Real-Time Rendering](http://www.realtimerendering.com/).

![Graphics_pipeline](/assets/graphics-pipeline.png)

All of this is somehow implemented in the mesa stack and llvmpipe, let's find out how. I'll explain the general architecture first and map the pipeline we all know into the architecture.

# Architecture

To map this pipeline into the driver, we should get a better understanding how the drivers are implemented within Mesa.
Since we study __llvmpipe__, we can focus into __gallium__ flavour of drivers. Gallium is essentially API and hardware agnostic set of interfaces and helpers for writing drivers. 
A functional driver has to implement some of these interfaces. The two main interfaces to implement are __screen__ and __context__.  

All hardware needs to provide some way to allocate or deallocate memory. Also things like hardware capabilities are important to know. These tasks are done via the screen interface.

In case of openGL, __context__ provides state setting functions and an interface for drawing. 

Gallium also provides some auxiliary modules. For example a graphics API implementations tend to deal with vertex processing more 
or less the same way. It makes sense to provide some common interface for these tasks. The __draw module__  provides exactly that. It is heavily used in llvmpipe. 

![driver_diagram](/assets/driver-diagram.png)

Let's now remind ourselves how images are rendered in openGL. To create an image, the application has to first create some geometry and apply some shaders. In most applications there are two types of shaders, vertex and fragment.

When the application submits geometry to the openGL for drawing it is transformed by a mesa driver a into vertex buffer (__vbuf__). The __vertex shader__ operates on the vbuf applying any kind of transformations or projections required.
Once the vbuf is through the vertex shader stage it will go through clipping and screen mapping.

At this point llvmpipe transforms the clipped vbuf into a __scene__. A scene in llvmpipe is a container for processed triangles, lines and dots. The process these primitives go through is called __binning__. To get started with binning
the final framebuffer is split into blocks, for example 4x4 pixels of size. The primitives are then analysed against these blocks to determine which will be passed to the rasterizer for final fragment shading.

In the analysis a bounding box is calculated for a each triangle. For each block in the bounding box, we determine whether the block is entirely inside the triangle, entirely outside or partially inside the triangle. Each triangle is defined by three plane equations so we can sample the 2D space to see which pixels are inside the triangle and which are outside.

{:refdef: style="text-align: center;"}
![animooted](/assets/llvmpipe.gif)
{: refdef}

Depending on the result, llvmpipe assigns a different fragment calculation for that block. For example only partially covered blocks will have different parameters for a fragment shader.
When the scene is ready, llvmpipes __rasterizer__ executes each bin in each block and the framebuffer is ready for display. 

![pipeline_diagram](/assets/llvmpipe-pipeline.png)

# Summary 

Our mission statement was to figure out how the graphics pipeline translates to llvmpipe driver and now with a better understanding of the architecture we 
can map the pipeline to the modules who are responsible for that step in llvmpipe.

The graph below shows the general connection between pipeline elements and the llvmpipe modules.
The draw module provides some helper interfaces which llvmpipe implements, on top of that the llvmpipe has it's own concepts of scene and rasterizer which are not shared between 
other drivers.

![llvmpipe_map](/assets/llvmpipe-map.png)

In this post we went through a  high-level tear down of llvmpipe. I hope this has been as helpful to you as to me. Thanks for reading.


---- 
Some further reading:

[Real-Time Rendering](http://www.realtimerendering.com/).

[Triangle Scan Conversion using 2D Homogeneous Coordinates](https://www.cs.cmu.edu/afs/cs/academic/class/15869-f11/www/readings/olano97_homogeneous.pdf)

[Advanced Rasterization](https://web.archive.org/web/20180129085015/http://forum.devmaster.net/t/advanced-rasterization/6145)

