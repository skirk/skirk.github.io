---
layout: post
title: "Relaxing weekend by relaxing voronoi"
date: 2016-03-13 22:26
comments: true
tags: [cpp]
---

After a week of full throttle coding, a nice way to relax is to code bit more, obviously.
Therefore I dedicated most of my Saturday and Sunday to crack on with some voronoi goodness, with a goal to get [Lloyd's algorithm](https://en.wikipedia.org/wiki/Lloyd%27s_algorithm) up and running. 

Due to laziness I couldn't be bothered to implement voronoi diagram build algorithms, 
so I chose [boost polygon library](http://www.boost.org/doc/libs/1_60_0/libs/polygon/doc/index.htm) as my weapon of choice. It has decent documentation and It's adaptable to use other math libraries through a template trait system. I took advantage of the adaptability and plugged-in the glm. This could be handy if I decide to go for OpenGL rendering in the future. However, this time around I used [libgd](http://libgd.github.io/) for rendering. It's super simple to use and I'll be sticking to this small little library if I need some quick graphics done. 

Back to Lloyd's algorithm: the boost polygon library creates Voronoi diagrams based on set of points and segments. It's all fun and games until I realized some of the voronoi edges are infinite which makes them pretty nasty to render. [Cohen-Sutherland algorithm](https://en.wikipedia.org/wiki/Cohen%E2%80%93Sutherland_algorithm) to the rescue. It's fairly straight forward to clip the edges against a bounding box and discard any edges that are not inside the bounds. 

After the cell edges are clipped it's time to calculated centroid for the cell. I decided again to go for and existing implementation and yet again I used boost. [Boost geometry](http://www.boost.org/doc/libs/1_60_0/libs/geometry/doc/html/index.html) had functionality for calculating centroids for polygons and point sets, so it was just a matter of passing the cell edges edges into a polygon and Bob's your uncle.

Here's the result of my small weekend exercise:

![hello](/assets/output.gif)
