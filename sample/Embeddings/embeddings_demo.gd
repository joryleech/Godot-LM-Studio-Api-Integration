extends Node

@onready var message_text_input : TextEdit = $HBoxContainer/MessagePanel/VBoxContainer/TextEdit
@onready var lm_studio_embeddings : LmStudioApi.Embeddings = $LmStudioEmbeddings
func _on_submit_response():
	var input = message_text_input.text
	message_text_input.text = ""
	lm_studio_embeddings.input = input
	lm_studio_embeddings.request()


@onready var message_log : RichTextLabel = $RichTextLabel

func _input(event):
	if message_text_input.has_focus():
		if event is InputEventKey and event.is_pressed():
			if (event as InputEventKey).keycode == KEY_ENTER:
				_on_submit_response()
				message_text_input.set_deferred("text", "")


func _on_recieve_embeddings_response(response: Dictionary) -> void:
	message_log.text = JSON.stringify(response)


func _on_lm_studio_embeddings_on_failure(code: int, response: Dictionary) -> void:
	if !response:
		response = {"code": code }
	message_log.text = JSON.stringify(response)
