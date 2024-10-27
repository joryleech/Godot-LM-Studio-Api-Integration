
# Godot LM Studio Api Integration Godot

This plugin integraties LM Studio's Server APIs allowing easy node based access to AI Tools within your Godot projects.

## Table of Contents
1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Example](#example)
5. [General Notes](#general-notes)
6. [Contribution](#contribution)
7. [License](#license)

## Features
- **Node Based Requests**: Load the `LMStudioCompletions`, `LMStudioEmbeddings`, or `LMStudioModels` into your scene tree and easily call your API
- **Signals Based Response**: Recieve success, raw, and error messages from all responses with easy to use signals
- **Language Model Completions**: Send prompts to AI language models and receive text completions.
- **Model Management**: Easily manage different models available through the LM Studio API.
- **Embeddings Generation**: Generate vector representations of text inputs using language models.

# Installation
* If you do not have a Lm Studio server available download it [here](https://lmstudio.ai/).
* [Documentation on running a server in LM Studio](https://lmstudio.ai/docs/basics/server)

* Download or Clone the Repo
* Copy the contents of the /addons folder to your projects res://addons folder.
* Enable `GodotLMStudioApiIntegration` in Project > Project Settings > Plugins
* To select your server you can either set a global url value in the settings or set the value on each request node
    * *To set the global api root:* in Project > Project Settings > General click `Advanced Settings` to turn it on, then find the sidebar tab labeled `Addons > LM Studio Api`. Edit `API Root` to the url of your server.
    * Note: Godot may require a restart to see this setting, after plugin has been enabled.

# Usage
This addon includes 3 request nodes to include in your projects 
* *Completions* - Chat based AI autocompletion
* *Models* - Returns all available LLM models loaded in LM Studio
* *Embeddings* - Returns a list of embeddings to use in a Vector DB based off of the input

To use these nodes, either instantiate them in the scene tree via the `Add Node` menu
or instantiate them in code as follows
```gdscript
#Completion Node
var completion_node : LMStudioApi.Completions = LMStudioApi.Completions.new()

#Models Node
var models_node : LMStudioApi.Models = LMStudioApi.Models.new()

#Embeddings Node
var embeddings_node : LMStudioApi.Embeddings = LMStudioApi.Embeddings.new()

#Then add them to your scene tree 
add_child(completions_node)
```

## Requests
All of the API nodes extend from a `Requests` Node
All of them have the following properties 
**Properties:** 
* **debug**: Provides additional logging.
* **headers**: Allows the user to provide additional headers to the request that arent automatically computed
* **config**: A configuration object, allowing the user to override global API configurations like API ROOT
* **run_on_ready**: If true, the request will run as soon as the node is ready, without requiring the `request` function.
* **timeout**: The timeout value of the request. If this many seconds pass without the requests completion, the request stops and fails.
* **one_shot**: If true the node will destroy itself after the request and following signals complete. 

**Signals:**
* **on_success(response: Dictionary)** - When the API call is successful this signal provides the JSON response of the server as a dictionary
* **on_request_completed(result, response_code, headers, body, response)** - When the API call completes, regardless of the status, this signal fires the raw response.
* **on_failure(code : int, response : Dictionary)**: When the API call fails, this signal provides the error code and any response provided by the server as JSON as a dictionary.

Once the properties have been set, run the request as following
```gdscript
var models_node : LMStudioApi.Models = LMStudioApi.Models.new()

#Dont forget to connect signals if youd like to use the APIs response.
#The request function DOES NOT return the value of the API response.
models_node.on_success.connect(this._on_models_success)

#Begin the request
models_node.request()
```
## Completions
The `Completions` node specifically is designed to interact with the LM Studio API for generating text completions based on input messages.

### Properties

* **model** (optional): Specifies the model ID to use for generating completions. If not specified, LM Studio will use the first loaded model.
* **messages**: An array of message objects representing conversation history.
  - Each message instanciates `LMStudioApi.Completions.CompletionMessage` the object with the following properties:
    - `content`: The actual text content of the message.
    - `role`: The role associated with the message by ENUM with the following options
        - `CompletionMessageRole.System`
        - `CompletionMessageRole.Assistant`
        - `CompletionMessageRole.User`
* **automatically_add_messages**: If true, all chat message (from both the Assistant and You) will be stored automatically, and passed back to the API to maintain complete conversations. If this is false you will be required to manage the chat messages your self.


### Advanced Settings

If 0, these values will default to the settings provided to the LM Studio Server

* **temperature**: Controls randomness; higher values result in more varied outputs (default: `0.7`).
* **max_tokens**: Specifies the maximum length of the generated text, measured in tokens (default: `0`, which means no limit).
* **presence_penalty**: Modifies token reuse during generation to encourage or discourage diversity (default: `0`).
* **frequency_penalty**: Encourages or discourages the use of frequently occurring tokens (default: `0`).
* **seed**: A random seed for reproducibility.

```gdscript
extends Node

func _ready():
	# Create and configure a new instance of the Completions node.
	var lm_studio_completions : LmStudioCompletions = preload("res://addons/lm_studio_api/lib/completions.gd").new()
	lm_studio_completions.model = "your_model_name"
	lm_studio_completions.automatically_add_messages = true
	
	# Connect signals for handling responses.
	lm_studio_completions.on_success.connect(_on_completion_success)
	lm_studio_completions.on_request_completed.connect(_on_request_completed)
	lm_studio_completions.on_failure.connect(_on_completion_failure)
	
func send_message(message : String):
	# Add messages to start a conversation.
	lm_studio_completions.add_message(message, CompletionMessage.CompletionMessageRole.User)
	lm_studio_completions.request()
	
func _on_completion_success(response : Dictionary):
	print("Completion received: ", response['choices'][0]['message']['content'])
	
func _on_request_completed(result, response_code, headers, body, response):
	print(f"Request completed with result {result} and code {response_code}")

func _on_completion_failure(code : int, response : Dictionary):
	print("Failed to get completion. Error code:", code)
```

# Example
The repo provides a sample project with all available API requests. To use, clone or download the repo and open the project in Godot 4.x
![Completion Demo](https://github.com/user-attachments/assets/c52a11c0-1449-47a1-976b-2004c84469dc)
![Models demo](https://github.com/user-attachments/assets/a72a781f-a6c7-4ea8-8e36-0c10281f3016)
![Embeddings demo](https://github.com/user-attachments/assets/097bfad3-ee6d-45e2-b5e1-a78293a4e84d)

# General Notes

**Localhost doesn't work in GODOT 4.x**:
If you are using a local LM Studio server, use your local IP address. Godot 4.x has a bug where, localhost attempts to resolve as IPv6 first, taking up to 30 seconds before the request will start.

**LM Studio Embeddings API endpoint doesn't always load models**:
Sometimes Embeddings will return the error "No Models Loaded" even when models are loaded and functional for other endpoints. I do not know a workaround to this at this time.

# Contribution
Feel free to fork this repository, submit issues, and contribute improvements or additional features.

# License

The gem is available as open source under the terms of the  [MIT License](https://github.com/joryleech/Godot-LM-Studio-Api-Integration/blob/main/LICENSE).
