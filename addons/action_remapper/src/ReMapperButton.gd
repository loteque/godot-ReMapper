@tool
extends Button

var kb = ActionsProperty.KeyBoard

var action_symbol: Grumblex.Symbol
var action: String:
    get:
        return action_symbol.value
    set(value):
        action_symbol.value = value

@export var show_action_str: bool = true:
    set(value):
        show_action_str = value
        if Engine.is_editor_hint():
            var key = kb.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var show_seperator: bool = true:
    set(value):
        show_seperator = value
        if Engine.is_editor_hint():
            var key = kb.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var show_wait_str: bool = true:
    set(value):
        show_wait_str = value
        if Engine.is_editor_hint():
            var key = kb.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var show_button_str: bool = true:
    set(value):
        show_button_str = value
        if Engine.is_editor_hint():
            var key = kb.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var wait_notify_str: String = "...":
    set(value):
        wait_notify_str = value
        if Engine.is_editor_hint():
            var key = kb.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var seperator_str: String = "|":
    set(value):
        seperator_str = value
        if Engine.is_editor_hint():
            var key = kb.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )


func _init():

    toggle_mode = true
    toggled.connect(_on_toggled)

    action_symbol = Grumblex.Symbol.new(&"action")
    action_symbol.updated.connect(_on_action_updated)

    kb = ActionsProperty.KeyBoard.new()
    kb.set_key_from_inputmap(action)


func _ready():
    
    set_process_unhandled_key_input(false)


func _on_action_updated(_symbol, value):
    
    print("Button; signal recieved: " + value)
    kb.set_key_from_inputmap(value)
    var key = kb.key
    
    text = (
        generate_button_string(
            value, 
            seperator_str, 
            key
        )
    )


func _get_property_list():
    
    var actions_str = ActionsProperty.ActionString.new()
    var hint_string: String = actions_str.value
    var prop_type: int = TYPE_STRING
    var prop_hint: int = PROPERTY_HINT_ENUM
    var properties = []
    
    properties.append({
		"name": action_symbol.symbol,
		"type": prop_type,
		"hint": prop_hint,
		"hint_string": hint_string
	})

    return properties

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
                action, 
                seperator_str, 
                ""
            )
            + wait_notify_str
        )

func _unhandled_key_input(event):
    show_button_str = true
    var key = kb.remap_key(action, event)
    # await kb.updated

    set_pressed(false)
    text = (
        generate_button_string(
            action, 
            seperator_str, 
            key
        )
    )
