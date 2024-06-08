@tool
extends Button

var actions_array: Array[StringName]
var actions_str: String = ""

signal action_option_updated(action_str: String)

var action_option_str: String:
	set(value):
		action_option_str = value
		action_option_updated.emit(action_option_str)
		notify_property_list_changed()


func compile_actions_str():

	actions_str = ""

	var delimiter: String = ","

	InputMap.load_from_project_settings()
	var actions_array = InputMap.get_actions()
	actions_array.reverse()

	for action in actions_array:
		var actions_partial: String = action + delimiter
		actions_str = actions_str + actions_partial

	actions_str = actions_str.left(actions_str.length() - 1)

func _get_property_list():

	var properties: Array[Dictionary]
	
	properties.append({
		"name": "action_option_str",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": actions_str
	})

	return properties

func _init():
	pressed.connect(_on_pressed)
	action_option_updated.connect(_on_action_option_updated)
	compile_actions_str()


func _on_action_option_updated(action):
	print("signal recieved; updated action_option " + action)
	text = action

func _on_pressed():
	print(text)

		

	

