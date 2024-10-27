@tool
extends Resource
class_name LMStudioConfig

const SETTINGS_PATH: String = "addons/lm_studio_api/"
const API_ROOT_SETTINGS_PATH: String = "api_key"

var outgoing_message_json_indent : String = "\t"
@export var api_root : String = ""

func get_api_root():
	if(api_root && !api_root.is_empty()):
		return api_root
	elif(ProjectSettings.has_setting(get_api_root_value())):
		return ProjectSettings.get_setting(get_api_root_value())
	else:
		assert("[LmStudioApi] API Root not found. Please set the plugin settings or add a config to your request")
		

func get_api_root_value() -> String:
	return SETTINGS_PATH+API_ROOT_SETTINGS_PATH


#DEFAULT SETTINGS 
#Godot 4.3 has issues resolving localhost, delaying all requests ~30 seconds.
#Godot Team please resolve, until then access via domain or IP address.
const DEFAULT_API_ROOT_VALUE = "http://127.0.0.1:1234"
func generate_default_settings():
	if (!ProjectSettings.has_setting(get_api_root_value())):
		ProjectSettings.set_setting(get_api_root_value(), DEFAULT_API_ROOT_VALUE)
		
