extends Label

func set_text_to_response(response : Dictionary):
	text = JSON.stringify(response, "    ")
