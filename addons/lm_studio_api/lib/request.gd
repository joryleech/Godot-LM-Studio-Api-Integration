extends Node

@export var one_shot : bool = false
var method : int = HTTPClient.METHOD_POST

var api_endpoint : String =""

signal on_success(response : Dictionary)
signal on_request_completed(result, response_code, headers, body, response) #Passthrough
signal on_failure(code : int, response : Dictionary)

@export var debug = false
@export var headers : PackedStringArray = []

@export var config : LmStudioApi.Config = LmStudioApi.Config.new()
@onready var http_request : HTTPRequest = HTTPRequest.new()
@export var run_on_ready : bool = false
@export var timeout : float = 0.0

func _ready():
	add_child(http_request)
	http_request.use_threads = true
	http_request.request_completed.connect(self._request_completed)
	if(run_on_ready):
		request()

func generate_headers() -> PackedStringArray:
	var pregenerated_headers : PackedStringArray = [
		"Content-Type: application/json",
		"Accept: application/json"
	]
	pregenerated_headers.append_array(headers)
	return pregenerated_headers

func generate_url():
	return config.get_api_root()+api_endpoint
	
func generate_body() -> String:
	return ""
	
func request():
	var error = http_request.request(
		generate_url(),
		generate_headers(),
		method, 
		generate_body()
	)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		

func _request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	if(debug):
		print(body.get_string_from_utf8())
	var response = json.get_data()
	emit_signal("on_request_completed", result,response_code,headers,body, response)
	if(response_code == 200):
		_on_success(response)
	else:
		emit_signal('on_failure', response_code, response)
	if(can_node_die()):
		self.queue_free()

func can_node_die():
	return one_shot
	
func _on_success(response):
	emit_signal('on_success', response)
