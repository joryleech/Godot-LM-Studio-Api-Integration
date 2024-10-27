# Godot LM Studio Api Integration Godot

This plugin integraties LM Studio's Server APIs allowing easy node based access to AI Tools within your Godot projects.

# Installation
* If you do not have a Lm Studio server available download it [here](https://lmstudio.ai/).
* [Documentation on running a server in LM Studio](https://lmstudio.ai/docs/basics/server)

* Download or Clone the Repo
* Copy the contents of the /addons folder to your projects res://addons folder.
* Enable `GodotLMStudioApiIntegration` in Project > Project Settings > Plugins
* To select your server you can either set a global url value in the settings or set the value on each request node
    * *To set the global api root:* in Project > Project Settings > General click `Advanced Settings` to turn it on, then find the sidebar tab labeled `Addons > LM Studio Api`. Edit `API Root` to the url of your server.
    * Note: Godot may require a restart to see this setting, after plugin has been enabled.

# TODO List
* Finish Documentation

# Contribution
Feel free to fork this repository, submit issues, and contribute improvements or additional features.

# License

The gem is available as open source under the terms of the  [MIT License](https://github.com/joryleech/Godot-LM-Studio-Api-Integration/blob/main/LICENSE).
