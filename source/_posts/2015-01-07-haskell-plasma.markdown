---
layout: post
title: "haskell plasma!"
date: 2015-01-07 03:24
comments: true
categories: 
---

On my Haskell journey and I decided to tackle plasma effect (explained [here](http://www.bidouille.org/prog/plasma))

``` haskell
	-- Create color for a Cell
	makecolor x y t = (r, g, b)
		where
		r = (cos (v*pi*0.9) / 2 + 0.7) 
		g = (sin (v*pi) / 2 + 0.3)
		b = 0.3
		v = sin( sqrt(100*(cx^2+cy^2)+1) + t)
		cx = x + 0.5*sin(t/5) -0.5
		cy = y + 0.5*cos(t/3) -0.5

	-- Draw one Cell or "pixel"
	drawCell w h t (x,y) = do
		color $ makecolor (x/w) (y/h) t
		C.rectangle x y (w/50) (h/50)
		C.fill 
``` 

Thanks to list comprehensions, the draw call is super simple:

``` haskell
	-- w h: width and height of canvas, t:time
	mapM (drawCell w h t) [(x , y) | x <- [0,(w/50) .. w], y <- [0,(h/50) .. h ]]

``` 
In essence the program is a poor mans fragment shader. The resulting animation is below: 

<video width="400" height="400" controls>
<source src="/images/post/test.webm" type="video/webm">
Your browser does not support the video tag.
</video> 
