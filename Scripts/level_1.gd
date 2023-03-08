class_name Level extends Node2D

var noise_text = NoiseTexture2D.new()
var water_noise_text: NoiseTexture2D = NoiseTexture2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	noise_text.seamless = true
	noise_text.noise = FastNoiseLite.new()
	noise_text.noise.seed = randi_range(0, 1000000)
	await noise_text.changed
	
	water_noise_text.seamless = true
	water_noise_text.noise = FastNoiseLite.new()
	water_noise_text.noise.seed = randi_range(0, 1000000)
	water_noise_text.in_3d_space = true
