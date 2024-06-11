@tool
extends Button

var dev = ActionsProperty.Device


var action_symbol: Grumblex.Symbol
var action: String:
    get:
        return action_symbol.value
    set(value):
        action_symbol.value = value

signal panel_option_updated(option_value, input)

@export var show_action_str: bool = true:
    set(value):
        show_action_str = value
        if Engine.is_editor_hint():
            var key = dev.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var show_seperator: bool = true:
    set(value):
        show_seperator = value
        if Engine.is_editor_hint():
            var key = dev.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var show_wait_str: bool = true:
    set(value):
        show_wait_str = value
        if Engine.is_editor_hint():
            var key = dev.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var show_button_str: bool = true:
    set(value):
        show_button_str = value
        if Engine.is_editor_hint():
            var key = dev.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var wait_notify_str: String = "...":
    set(value):
        wait_notify_str = value
        if Engine.is_editor_hint():
            var key = dev.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )

@export var seperator_str: String = "|":
    set(value):
        seperator_str = value
        if Engine.is_editor_hint():
            var key = dev.key
            text = generate_button_string(
                action, 
                seperator_str, 
                key
            )


func _init():

    panel_option_updated.connect(_on_panel_value_updated)

    toggle_mode = true
    toggled.connect(_on_toggled)

    action_symbol = Grumblex.Symbol.new(&"action")
    action_symbol.updated.connect(_on_action_updated)

    dev = ActionsProperty.Device.new()
    dev.set_input_from_inputmap(action)

func _ready():
    
    set_process_unhandled_input(false)


func _on_action_updated(_symbol, value):
    
    print("Button; signal recieved: " + value)
    dev.set_input_from_inputmap(value)
    var input = dev.input
    
    text = (
        generate_button_string(
            value, 
            seperator_str, 
            input
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

func generate_button_string(action: String, seperator: String, input: String) -> String:
    
    action = action.capitalize()
    var button_string_array: Array[String] = [action, seperator, input]
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


func set_button_text(action: String, seperator: String, input: String):

    text = generate_button_string(
        action, 
        seperator_str, 
        input
    )


func _on_panel_value_updated(option_value, input):
    set_button_text(action, seperator_str, input)

func _on_toggled(toggled_on):
    
    set_process_unhandled_key_input(toggled_on)
    set_process_unhandled_input(toggled_on)

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


func _unhandled_input(event):
    
    var remamp_and_update_button = func():
        
        var button = dev.remap_input(action, event)

        text = (
            generate_button_string(
                action, 
                seperator_str, 
                button
            )
        )
    
    set_pressed(false)

    show_button_str = true

    if event is InputEventMouseButton:
        remamp_and_update_button.call()
    
    if event is InputEventKey:
        remamp_and_update_button.call()

    if event is InputEventJoypadButton:
        remamp_and_update_button.call()

