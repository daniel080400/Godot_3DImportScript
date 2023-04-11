tool
extends EditorScenePostImport

# texture compression quality, 1.0 means the best
const COMPRESS_QUALITY = 0.7

var materials : Array # Store all materials in imported scene


# Called by the editor when a scene has this script set as the import script in the import tab.
func post_import(scene):
	iterate(scene)
	do_texture_compression()
	materials.clear()
	
	return scene # Return the modified root node when you're done.

func iterate(node):
	if node == null:
		return
		
	# Get all materials in meshes
	if node is MeshInstance:
		var _materials = get_mesh_materials(node)
		for mat in _materials:
			if materials.find(mat) == -1:
				materials.append(mat)
	
	for child in node.get_children():
		iterate(child)


func get_mesh_materials(node : MeshInstance) -> Array:
	var _materials : Array
	
	# Get all materials and store into array
	for n in node.mesh.get_surface_count():
		var material = node.mesh.surface_get_material(n) as SpatialMaterial
		_materials.append(material)
	
	
	return _materials


func do_texture_compression():
	# Compress textures in all materials
	print("got " + str(materials.size()) + " materials, compressing textures...")
	
	for m in materials:
		var material = m as SpatialMaterial
		# Compress albedo texture (use srgb)
		if material.albedo_texture:
			material.albedo_texture = compress_texture(material.albedo_texture, true)
		
		# Compress metalic texture
		if material.metallic_texture:
			material.metallic_texture = compress_texture(material.metallic_texture)
			
		
		# Compress roughess texture
		if material.roughness_texture:
			material.roughness_texture = compress_texture(material.roughness_texture)
			
		
		# Compress normal texture
		if material.normal_texture:
			material.normal_texture = compress_texture(material.normal_texture, false, true)
			
		
		# Compress emission texture
		if material.emission_texture:
			material.emission_texture = compress_texture(material.emission_texture, true)
		
		# Compress AO texture
		if material.ao_texture:
			material.ao_texture = compress_texture(material.ao_texture)
		
		continue
	
	return



func compress_texture(texture : ImageTexture, srgb = false, nrm = false):
	var _image = texture.get_data() # create a image copy
	var _texture = texture
	
	# Generate mipmaps
	_image.decompress()
	_image.generate_mipmaps()
	
	# Compress image to DXT1, DXT5
	if srgb:
		_image.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_SRGB, COMPRESS_QUALITY)
	elif nrm:
		_image.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_NORMAL, COMPRESS_QUALITY)
	else:
		_image.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_GENERIC, COMPRESS_QUALITY)
		
	
	# Create ImageTexture
	_texture.storage = ImageTexture.STORAGE_COMPRESS_LOSSY
	_texture.lossy_quality = COMPRESS_QUALITY
	_texture.create_from_image(_image)

	
	return _texture
