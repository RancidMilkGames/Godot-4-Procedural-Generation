# Godot 4 Procedural Generation
This project is an experiment in procedural generation in Godot 4. There are a few examples, both in 2D and 3D. Currently, on the endless 2D world performance is terrible. I think I've pinpointed it to the rendering of all the tiles. There's a system in place to disable anything running on tiles and their visibility when out of view, but that doesn't seem to be enough. Anyway, if you're fine with a small map, just comment out the endless gen code and it should run fine.

## Samples
* 2D Endless World with isometric tiles
* 2D square tiles
* 3D terrain using the surface array tool

https://user-images.githubusercontent.com/115530728/223854281-161d993e-36bb-46c5-9671-a584c0fb15ba.mp4

