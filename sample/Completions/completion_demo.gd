extends Node


func _on_recieve_completion_response(response : Dictionary):
	_update_messages()

@onready var message_text_input : TextEdit = $HBoxContainer/MessagePanel/VBoxContainer/TextEdit
@onready var system_text_input : TextEdit = $HBoxContainer/SystemPanel/VBoxContainer/TextEdit
@onready var lm_studio_completion : LmStudioApi.Completions = $LMStudioCompletions
func _on_submit_response():
	var message = message_text_input.text
	message_text_input.text = ""
	
	if(lm_studio_completion.messages.size() < 1):
		lm_studio_completion.add_message("", lm_studio_completion.CompletionMessage.CompletionMessageRole.System)
	var system_message_text = system_text_input.text
	#Keep System Message
	lm_studio_completion.messages[0].content = system_message_text
	lm_studio_completion.add_message(message, lm_studio_completion.CompletionMessage.CompletionMessageRole.User)
	_update_messages()
	lm_studio_completion.request()


@onready var message_log : RichTextLabel = $RichTextLabel
func _update_messages():
	message_log.text = "\n".join(lm_studio_completion.messages.filter(_filter_non_system_messages).map(render_message))

func render_message(message : LmStudioApi.Completions.CompletionMessage) -> String:
	return "[b]{user}: [/b]{message}".format({
		"user": message.get_role_name(),
		"message": message.content
	})

func _filter_non_system_messages(message : LmStudioApi.Completions.CompletionMessage):
	return message.role != message.CompletionMessageRole.System

func _input(event):
	if message_text_input.has_focus():
		if event is InputEventKey and event.is_pressed():
			if (event as InputEventKey).keycode == KEY_ENTER:
				_on_submit_response()
				message_text_input.set_deferred("text", "")
