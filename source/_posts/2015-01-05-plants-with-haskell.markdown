---
layout: post
title: "Plants with Haskell"
date: 2015-01-05 23:23
comments: true
categories: 
---

To fill the void in my life I decided to look into new programming language. From afar haskell seemed like a funky language so off I went! As an exercise I picked up something I conceptually simple: L-systems. 

My first take was more or less as I would have approached the problem with imperative languages. It's quite nice and neat to produce the lsystem string. 
``` haskell
-- Different types of nodes
data LNode = Draw | TLeft | TRight | Push | Pop | PHolder
-- Rules for creating new strings
become PHolder = [Draw, TLeft ,Push, Push, PHolder, 
		  Pop, TRight, PHolder, Pop, TRight, 
		  Draw, Push, TRight, Draw, PHolder,
                  Pop, TLeft,PHolder]
become Draw = [Draw, Draw]
become n = [n]

recurse :: [LNode] -> Int -> [LNode]
recurse ns i 
	| i > 0 = recurse (concatMap become ns) (i-1)
	| otherwise = ns
```
To draw the tree:

``` haskell 
foreach (recurse [PHolder] 6) $ \ x ->
	do drawNode x

-- Drawing function for each node
drawNode Draw  = do
	  C.rectangle (-0.06) 0 0.12 0.25
  	C.translate 0 0.25
drawNode TLeft  = C.transform $  rotate2d (-pi/8)
drawNode TRight  = C.transform $ rotate2d  (pi/8)
drawNode Pop =  C.restore
drawNode Push =  C.save
drawNode PHolder = C.rectangle 0 0 0 0

```
A result of this:
{% photo /images/post/basicbush.jpg /images/post/thumb/basicbushthumb.jpg %} 

Even though the code is fairly neat, the code bugged me because it looked almost like C code. That's not acceptable! This is functional programming afterall. In the next approach I did a bit research and found an [article](http://fhtr.blogspot.fi/2008/12/drawing-tree-with-haskell-and-cairo.html) (Man, that dude has pretty code, check it out!) that had something I wanted to do. So I took creative license and modified some of the stuff to create an tDOL-system {% cite botanic %}

``` haskell
trunk n angle 
		|  n < 0  = []
		|  n <= 1 = [(wtgf n, map (rotateP angle) [(0,0), (0,tgf n)])]
		|  otherwise  = (thickness, points) : evolve
			where
				points = map (rotateP angle) [(0,0), (0, igf n)]
				thickness = wigf (n-1)
				[_,(x,y)] = points
				evolve = map (mapWidthLine (translateP x y)) (left ++ right ++ apex)
				left  = branch (n-1) (angle -pi/4)
				right = branch (n-1) (angle +pi/4)
				apex  = trunk  (n-1) angle 

	branch n angle 
		|  n < 0  = []
		|  n <= aa  = [(wbgf n, map (rotateP angle) [(0,0), (0, bgf n)])]
  		| otherwise =  trunk (n-aa) angle
```

Here's the result of the animated simulation of a um.. tree?
{% img /images/post/opttree.gif %} 

## References

{% bibliography --cited %}
