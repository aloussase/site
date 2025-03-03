---
title: Porting Riak's Vector Clocks from Erlang to Gleam
---

In this post we go over a partial port I made of Riak's vector clocks to Gleam.
We start with a short explanation of what vector clocks are and what they're
used for. Then, we follow with some Gleam code that implements a stripped down
version of Riak's vector clocks.

The code from this post is available in GitHub:
https://github.com/aloussase/gleam-vector-clocks/blob/main/src/vector_clocks.gleam.

<span></span><!--more-->

## What are vector clocks?

From Wikipedia:

> A vector clock is a data structure used for determining the partial ordering of events in a distributed system and detecting causality violations.

That sums it up pretty well. We use vector clocks to establish a _partial
order_ of events in a distributed system. I put emphasis on _partial order_
since this entails a different set of guarantees than a system with [total
order broadcast](https://en.wikipedia.org/wiki/Atomic_broadcast). In a system
where events are partially ordered, it is possible that we can't tell whether
event A happens before event B. This means that we need some way of solving
conflicts when two events occur concurrently.

One way of solving this types of conflicts is last-write wins. When using this
strategy, the vector clock data structure is enhanced with a timestamp of when
the event ocurred. Then, if there is a conflict, the event with the latest
timestamp wins. This is what Riak does by default.

On the other hand, it might be more appropriate to let the client application
decide how to solve the conflicts, since the application has more domain
knowledge about the events. This is what Amazon's Dynamo system does.

## How do vector clocks works?

Ok, so now that we know what vector clocks are and what they're used for, let's
dive a little bit deeper into how they work. Have a look at the following image
from Wikipedia:

![](https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Vector_Clock.svg/420px-Vector_Clock.svg.png)

At the most basic level, a point, or _dot_, in a vector clock consists of the
ID of the node that generated the event and a counter. The counter is
incremented everytime a node receives or sends a new message.

In order to see if a vector clock A happens before, or _descends from_, vector
clock B we do the following:

1. For all nodes in A
2. See if the counter for that node is less than or equal to the counter for
   the corresponding node in B
3. If it is, move on to the next node
4. If it isn't, then A does not descend from B

## Implementing vector clocks in Gleam

TODO

## Conclusion

TODO
