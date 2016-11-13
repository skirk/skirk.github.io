---
layout: post
title: "Messing around with cairo &amp; haskell"
date: 2015-01-16 02:57
comments: true
categories: Haskell
---

Haskell again, this time I wanted create some actual data structures and draw them. I didn't really have any idea what I'm aiming to do so this is purely creative programming exercise in order to learn a bit more about Haskell. 

The data layout I used is simple tree structure where each node has a label and have arbitrary number of branches. Such as following:

``` haskell
stringTree =
Node "Call"  [
	Node "Me"  [
		Node  "Ishmael."[]
		Node  "And so"  []         
		Node  "forth."  []         
	]                                    
]                                            
```                                    	 
Then for renderer we have to create some data so time for some recursion:
``` haskell
renderData angle col (Node label branches) = (label, angle, col, points):subbranches 
  where
    -- calculate two points depending on length of the label. 5.7 length of a letter
    points = map ( rotateP angle )[( 0,0 ), ( 5.7 * (fromIntegral $ length label),0)]
    [_, (x,y)] = points
    -- calcAngle calculates angle and colorF the color according to given function 
    subbranchdata = zip branches [0 .. ] >>= (\ x -> do
      renderData ( calcAngle angle ( snd x ) ( length branches-1 ) )
                 ( colorF ( +0.05 ) col ) 
                 $ fst x
    -- translate subbranches
    subbranches = map (map4th (translateP x y)) subbranches
``` 

That's more or less the main part. 
Next the draw calls:

```haskell
let rdata = renderData 0 ( Color 0 0.5 0.05 1 )  $ appendTree stringTree  
-- render lines
mapM_ (\ branch -> do
    color $ thd4 $ branch;
    C.fill;
    strokeLine $ fth4 branch
      ) $ rdata
-- render text
drawBranch rdata
```
Perhaps at some point I will evolve this into animation of sorts but for now it's an exercise for haskell and a amusement for few hours.

{% gallery %}
/images/post/withouttext.jpg[/images/post/thumb/withoutextthumb.jpg]:Lines only 
/images/post/textonly.jpg[/images/post/thumb/textonlythumb.jpg]: Text only 
/images/post/withtext.jpg[/images/post/thumb/withtextthumb.jpg]: Lines and text
/images/post/skills.jpg[/images/post/thumb/skillsthumb.jpg]: Skill tree 
{% endgallery %}


