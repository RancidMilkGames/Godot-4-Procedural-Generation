# Godot 4 Procedural Generation
This project is an experiment in 2D procedural generation in Godot 4. Right now it generates an endless world of proc gen terrain. Currently performance is terrible. I think I've pinpointed it to the rendering of all the tiles. There's a system in place to disable anything running on tiles and their visibility when out of view, but that doesn't seem to be enough. Anyway, if you're fine with a small map, just comment out the endless gen code and it should run fine.


https://user-images.githubusercontent.com/115530728/223854281-161d993e-36bb-46c5-9671-a584c0fb15ba.mp4

