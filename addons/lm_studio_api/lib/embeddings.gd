extends LmStudioApi.Request

@export var model : String = ''
@export var input : String = ''

func _init():
	self.api_endpoint = '/v1/embeddings '

func generate_body() -> String:
	var body_dictionary : Dictionary = {
		"model": model,
		"input": input
	}
	var json_body : String = JSON.stringify(body_dictionary, config.outgoing_message_json_indent)
	return json_body
