---
layout: post
title: "Fixing mp3 metadata on Linux"
date: 2015-02-16 01:59
comments: true
tags: [linux]
---

Over the years my image and music collections have iteratively become more and more of a mess. The main culprit is metadata rot. In essence I often listen to obscure demoscene/game music that I collect from various sources. Some of them come with no metadata whatsoever. Some of them have it completely garbled, and so on. Hence, few hours to spare I took the role of Toxic Avenger and got to work.

First, the tools I ended up using:

* [mediainfo](http://mediaarea.net/en/MediaInfo): An useful tool to print metadata of a file
* Robert Woodcocks id3(from debian repo): handy small tool to edit mp3 metadata
* [easytag](https://wiki.gnome.org/Apps/EasyTAG): a metadata editor with a clean GUI


Obviously going through tens or hundreds of files by hand is error prone and pain in the butt.  Therefore, some sorting could help to fix the data. It came to be that I had quite a few files using a pattern: 
```
./artist - album/demo - song.mp3
```

Fixing those guys is easy:

``` bash
 #!/bin/bash                                                                     
                                                                                 
for f in ./music/*
do
	filename=$(basename "$f") 
	filename="${filename%.*}" # cut extension (.mp3)

	artist=$(echo "$filename" | cut -f 1 -d -)
	album= $(echo "$filename" | cut -f 2 -d -)
	song=  $(echo "$filename" | cut -f 3 -d -)

	# write metadata, -t = songname, -a = artist, -A = album
	id3 -t "$song" -a "$ucartist"  -A "$album" "$f"
done
```

In some cases the problem arose from the tags itself:

* _TPE1_ - The "Lead artist/Lead performer/Soloist/Performing group" is used for the main artist.

* _TSOP_ - The "Performer sort order" frame defines a string which should be used instead of the performer (TPE2) for sorting purposes.

Some files had both defined with different labels and my music player would mix the two. Therefore, I had two playlist entries for the same artist. Not good.
_id3_ is good for most of the cases but it can only write to TPE1. I had to get another hammer. 

Easytag provided enough features for me to fix these issues. It can also modify bunch of files at once. Worked like a charm. I can heartily recommend.

After a long while my music library looks nice and clean again. Till the next rot!

