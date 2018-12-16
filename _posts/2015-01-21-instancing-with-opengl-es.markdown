---
layout: post
title: "Instancing on OpenGL ES 2"
date: 2015-01-21 04:49
comments: true
categories: 
---
About an year ago I was messing away with my Raspberry Pi learning the ins and outs of the platform. For me Raspberry Pi is a platform that shouts for certain level of DIY attitude, which in my mind means: the more hackery involved, the better. Where's the fun otherwise?

I wanted to do some real-time graphics meaning I need a context to draw on. The usual solutions on Linux are QT or SDL, but those involve installing loads of libraries, like X-windowing system, which I don't really need. Turns out Rasperry Pi has some demo applications that use OpenGL to draw without any of that windowing crap. Hardware acceleration, check! A real ghetto solution, check! [This](https://benosteen.wordpress.com/2012/04/27/using-opengl-es-2-0-on-the-raspberry-pi-without-x-windows/) fellow goes through how to get things up and running.

I wanted to draw hundreds of cubes with varying transformations, and to do that efficiently requires instancing. With full blown OpenGL framework it's pretty easy to do instanced drawing with built-in functions, but the mobile version that raspberry uses, OpenGL ES2, doesn't have support for the function calls. Recently published ES3 supports those calls, but unfortunately that's no good for me. Instancing can however be "faked."

My solution for instancing is to copy a desired number of objects into a buffer, and for each vertex per object, copy the transform matrix into the buffer as well. This approach quickly hogs up memory but it's way faster than doing individual draw calls for each object. Per vertex the data passed to GPU therefore includes the position values, normal values and a transform matrix. However if only drawing cubes, we can re-use the position values for the normal. 

Attributes for vertex shader would therefore be like:

``` glsl
attribute mat4 model;
attribute vec3 vPosition;
attribute vec3 vNormal;
```

and to enable the attributes:
``` cpp
//position                                                                  
glEnableVertexAttribArray(locationpos);                                     
glVertexAttribPointer(locationpos, 3, GL_FLOAT, GL_FALSE,numOfAttrs*sizeof(GLfloat), 0); 

//normal                                     
glEnableVertexAttribArray(locationnorm);      
glVertexAttribPointer(locationnorm,3, GL_FLOAT, GL_FALSE,numOfAttrs*sizeof(GLfloat), 
		      3*sizeof(GLfloat));

//model matrix                                           
glEnableVertexAttribArray(location);                    
glVertexAttribPointer(location,   4, GL_FLOAT, GL_FALSE, numOfAttrs*sizeof(GLfloat), 
		      6*sizeof(GLfloat));
glEnableVertexAttribArray(location+1);                 
glVertexAttribPointer(location+1, 4, GL_FLOAT, GL_FALSE, numOfAttrs*sizeof(GLfloat), 
		      10*sizeof(GLfloat));
glEnableVertexAttribArray(location+2);                
glVertexAttribPointer(location+2, 4, GL_FLOAT, GL_FALSE, numOfAttrs*sizeof(GLfloat), 
		      14*sizeof(GLfloat));
glEnableVertexAttribArray(location+3);               
glVertexAttribPointer(location+3, 4, GL_FLOAT, GL_FALSE, numOfAttrs*sizeof(GLfloat), 
		      18*sizeof(GLfloat));
glDrawElements(GL_TRIANGLES, sizeof(cube)*amount, GL_UNSIGNED_SHORT, 0); 
```

View and Projection matrices can be passed in as uniforms as those are universal to the scene. 

Here's a video of a parametric lsystem(again?) using this this sort of instancing:

<video width="640" height="360" controls>
<source src="/assets/raspberry.webm" type="video/webm">
Your browser does not support the video tag.
</video> 

The drawback of not using a windowing system is that mouse events etc. are more or less ruled out so I'm using extremely simple scene management system:

```cpp
// start time , lookat, from
static shot shotlist[] = {
    {0.0f, vec3(0.0f, 20.0, 0.0f), vec3(10.0f, 30.0f, 0.0f) },
    {6.0f, vec3(0.0f, 70.0f, 0.0f), vec3(10.0f, 0.0f, 10.0f) },
    {12.0f,vec3(0.0f, 40.0f, 10.0f), vec3(20.0f, 70.0f, 0.0f) }
};
```
Why complicate things,eh?

