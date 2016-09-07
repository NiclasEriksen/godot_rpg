## Tile map importer plugin for [Tiled](http://www.mapeditor.org/)

Import tile maps from [Tiled](http://www.mapeditor.org/)

### Cureent support features

* All properties of layer
* Custom properties for map and layers
* All kind of tileset
* Formats:
  - TMX
    - CSV
    - XML
    - *Base64* [rawpacker](https://github.com/jrimclean/rawpacker) module is required
  - JSON
    - CSV
    - *Base64* [rawpacker](https://github.com/jrimclean/rawpacker) module is required

* Orientations:
  - orthogonal
  - isometric

This plugin import textures, tilesets and maps as resources into Godot.

Maps are saved as scenes(Node2D) contain layers(TileMap).

Custom properties were writen into scripts of Map scenes or layers.
