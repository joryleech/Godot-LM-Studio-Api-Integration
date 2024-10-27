extends LmStudioApi.Request

func _init():
	self.api_endpoint = '/v1/models'
	self.method = HTTPClient.METHOD_GET
	
