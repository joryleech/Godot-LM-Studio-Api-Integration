@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "LmStudioApi"
const AUTOLOAD_PATH: String = "res://addons/lm_studio_api/lm_studio_api.gd"

const lm_studio_node_name: String = "LmStudioApi"
const lm_studio_node_path: String = "res://addons/lm_studio_api/lib/request.gd"
const lm_studio_node_icon = preload("res://addons/lm_studio_api/icons/icon.png")


const lm_studio_completions_node_name: String = "LMStudioCompletions"
const lm_studio_completions_node_path: String = "res://addons/lm_studio_api/lib/completions.gd"
const lm_studio_completions_node_icon = preload("res://addons/lm_studio_api/icons/icon.png")

const lm_studio_models_node_name: String = "LMStudioModels"
const lm_studio_models_node_path: String = "res://addons/lm_studio_api/lib/models.gd"
const lm_studio_models_node_icon = preload("res://addons/lm_studio_api/icons/icon.png")

const lm_studio_embeddings_node_name: String = "LmStudioEmbeddings"
const lm_studio_embeddings_node_path: String = "res://addons/lm_studio_api/lib/embeddings.gd"
const lm_studio_embeddings_node_icon = preload("res://addons/lm_studio_api/icons/icon.png")

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)
	add_custom_type(lm_studio_node_name, "Node", preload(lm_studio_node_path), lm_studio_node_icon)
	add_custom_type(lm_studio_completions_node_name, "Node", preload(lm_studio_completions_node_path), lm_studio_completions_node_icon)
	add_custom_type(lm_studio_models_node_name, "Node", preload(lm_studio_models_node_path), lm_studio_models_node_icon)
	add_custom_type(lm_studio_embeddings_node_name, "Node", preload(lm_studio_embeddings_node_path), lm_studio_embeddings_node_icon)
	

func _exit_tree():
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)
	remove_custom_type(lm_studio_node_name)
	remove_custom_type(lm_studio_completions_node_name)
	remove_custom_type(lm_studio_models_node_name)
	remove_custom_type(lm_studio_embeddings_node_name)
