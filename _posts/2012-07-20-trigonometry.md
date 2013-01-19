---
layout: post
title: Trigonometry is the shit
---

The thing I’ve been struggling with for a couple of weeks on and off is getting the touch behavior of the hands on the “clock” and as it turns out i finally made good use of my trigonometry from school. But even with that cache of knowledge it was still a bit of a uphill struggle, from basic understanding on how touch behavior works in IOS( hint: it is more sophisticated and refined than one thinks) to frames, bounds, position and anchorpoint, oh my.

And last night i figured out the last vexing behavior, the hand was following my touch, but not in a circle, more like a oval shape, as i turns out, calculating center position is kinda important and was the culprit. But now, now it tracks.

On place that proved a real help was [http://www.raywenderlich.com/9864/how-to-create-a-rotating-wheel-control-with-uikit](http://www.raywenderlich.com/9864/how-to-create-a-rotating-wheel-control-with-uikit)