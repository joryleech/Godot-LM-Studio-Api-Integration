@tool
extends Node

const Request = preload("res://addons/lm_studio_api/lib/request.gd")
const Completions = preload("res://addons/lm_studio_api/lib/completions.gd")
const Embeddings = preload("res://addons/lm_studio_api/lib/embeddings.gd")
const Models = preload("res://addons/lm_studio_api/lib/models.gd")
const Config = preload("res://addons/lm_studio_api/lib/config.gd")

func _init():
	#Generate initial configs, a little hacky
	Config.new().generate_default_settings()
