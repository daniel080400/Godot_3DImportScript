# Godot_3DImportScript
On top of default 3d model importing, compresses all embedded texture into S3TC (DXT1, DXT5) format to save disk space.

# Why?
By default, Godot 3 imports 3d models' textures with uncompressed fomat (RGBA8), which results in unreasonable large file space.

# How to use
1. In Godot Editor, go to Project > Project Settings > Import Defaults
2. For Importer, select "Scene"
3. Set "Custom Script" to the path to gd_3d_import_script
4. Now every 3d model you import will have their texture compressed

![gd_import_script_instruction](https://user-images.githubusercontent.com/26960237/231169376-481e30b2-98dc-47bb-a2b7-f2a5609dd585.png)
