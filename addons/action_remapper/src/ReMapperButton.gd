@tool
extends Button

# button configuration
@export var show_action_str: bool = true:
    set(value):
        show_action_str = value
        if Engine.is_editor_hint():
            text = generate_button_string(
                _action_option_str, 
                seperator_str, 
                get_action_key_str(_action_option_str)
            )

@export var show_seperator: bool = true:
    set(value):
        show_seperator = value
        if Engine.is_editor_hint():
            text = generate_button_string(
                _action_option_str, 
                seperator_str, 
                get_action_key_str(_action_option_str)
            )

@export var show_wait_str: bool = true:
    set(value):
        show_wait_str = value
        if Engine.is_editor_hint():
            text = generate_button_string(
                _action_option_str, 
                seperator_str, 
                get_action_key_str(_action_option_str)
            )

@export var show_button_str: bool = true:
    set(value):
        show_button_str = value
        if Engine.is_editor_hint():
            text = generate_button_string(
                _action_option_str, 
                seperator_str, 
                get_action_key_str(_action_option_str)
            )

@export var wait_notify_str: String = "...":
    set(value):
        wait_notify_str = value
        if Engine.is_editor_hint():
            text = generate_button_string(
                _action_option_str, 
                seperator_str, 
                get_action_key_str(_action_option_str)
            )

@export var seperator_str: String = "|":
    set(value):
        seperator_str = value
        if Engine.is_editor_hint():
            text = generate_button_string(
                _action_option_str, 
                seperator_str, 
                get_action_key_str(_action_option_str)
            )


# action key stuff
var _action_option_str: String:
    set(value):
        _action_option_str = value
        if Engine.is_editor_hint():
            text = generate_button_string(
                _action_option_str, 
                seperator_str, 
                get_action_key_str(_action_option_str)
            )
        else:
            option_updated.emit("_action_option_str", _action_option_str)
        notify_property_list_changed()

## Emmited when an action option is updated.
## Emmitied with args for an option name String 
## and an option value Variant.
signal option_updated(option_str: String, option_value: Variant)


func compile_actions_str():

    var actions_str = ""

    var delimiter: String = ","

    var actions_array = InputMap.get_actions()
    actions_array.reverse()

    for action in actions_array:
        var actions_partial: String = action + delimiter
        actions_str = actions_str + actions_partial

    actions_str = actions_str.left(actions_str.length() - 1)
    return actions_str

func _init():
    
    # action key stuff
    InputMap.load_from_project_settings()
    
    # button stuff
    toggle_mode = true
    toggled.connect(_on_toggled)


func _ready():
    
    # button stuff
    set_process_unhandled_key_input(false)


# action key stuff
func _get_property_list():
    var actions_str = compile_actions_str()
    var properties: Array[Dictionary]
	
    properties.append({
		"name": "_action_option_str",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": actions_str
	})

    return properties


func get_action_key_str(action_str_name: String) -> String:
    var action_key_str: String = ""
    var input_events: Array[InputEvent] = InputMap.action_get_events(action_str_name)
    if input_events:
        action_key_str = input_events[0].as_text()
        action_key_str = action_key_str.replace("(Physical)", "")
    return action_key_str

# Button Stuff
func generate_button_string(action: String, seperator: String, key: String) -> String:
    action = action.capitalize()
    var button_string_array: Array[String] = [action, seperator, key]
    var button_string:String = ""
    
    if !show_action_str:
        button_string_array[0] = ""
    
    if !show_seperator: 
        button_string_array[1] = ""
    
    if !show_button_str:
        button_string_array[2] = ""
    
    button_string =  ( 
        button_string_array[0] 
        + button_string_array[1] 
        + " " 
        + button_string_array[2]
    )

    return button_string


func _on_toggled(toggled_on):
    
    set_process_unhandled_key_input(toggled_on)
    
    if toggled_on:
        show_button_str = false
        text = (
            generate_button_string(
                _action_option_str, 
                seperator_str, 
                ""
            )
            + wait_notify_str
        )

func _unhandled_key_input(event):
    
    show_button_str = true
    remap_key(event)
    set_pressed(false)
    text = (
        generate_button_string(
            _action_option_str, 
            seperator_str, 
            get_action_key_str(_action_option_str)
        )
    )

    print(str(event))

func remap_key(event):
    
    InputMap.action_erase_events(_action_option_str)
    InputMap.action_add_event(_action_option_str, event)