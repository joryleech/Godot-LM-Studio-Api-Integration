extends LmStudioApi.Request
const CompletionMessage = preload('res://addons/lm_studio_api/lib/completions/completion_message.gd')
@export var model : String = ""
var messages : Array[CompletionMessage]
@export var automatically_add_messages = true
@export var maximum_message_stored : int = 0

##Advanced Settings
@export var temperature : float = 0.7
@export var max_tokens : int = 0
@export var presence_penalty : float = 0
@export var frequency_penalty : float = 0
@export var seed : int = 0
func _init():
	self.api_endpoint = '/v1/chat/completions'

func generate_body() -> String:
	var body_dictionary : Dictionary = {
		"model": model,
		"messages": messages.map(func(message : CompletionMessage): return message.to_dictionary()),
		"temperature": temperature
	}
	if(max_tokens):
		body_dictionary["max_tokens"] = max_tokens
	if(presence_penalty):
		body_dictionary["presence_penalty"] = presence_penalty
	if(frequency_penalty):
		body_dictionary["frequency_penalty"] = presence_penalty
	if(seed):
		body_dictionary['seed'] = seed
		
	var json_body : String = JSON.stringify(body_dictionary, config.outgoing_message_json_indent)
	return json_body

func raw_add_message(message : CompletionMessage):
	messages.append(message)
	
func add_message(content : String, role : CompletionMessage.CompletionMessageRole = CompletionMessage.CompletionMessageRole.User):
	raw_add_message(
		CompletionMessage.new(content, role)
	)

func clear_messages():
	messages = []

func _on_success(response):
	if(automatically_add_messages):
		var returned_message : Dictionary = response['choices'][0]['message']
		var convertedMessage = CompletionMessage.new(
			returned_message['content'],
			CompletionMessage.CompletionMessageRole.Assistant
		)
		messages.append(convertedMessage)
	emit_signal('on_success', response) 
