@tool
extends Button

var actions_property: ActionsProperty

var editor_save: Array[Dictionary]
var option_symbol: Grumblex.Symbol
var option: String:
    get:
        return option_symbol.value
    set(value):
        option_symbol.value = value

@export var show_action_str: bool = true:
    set(value):
        show_action_str = value
        if Engine.is_editor_hint():
            var key_str = actions_property.get_action_key_str(option_symbol.value)
            text = generate_button_string(
                option_symbol.value, 
                seperator_str, 
                key_str
            )

@export var show_seperator: bool = true:
    set(value):
        show_seperator = value
        if Engine.is_editor_hint():
            var key_str = actions_property.get_action_key_str(option_symbol.value)
            text = generate_button_string(
                option_symbol.value, 
                seperator_str, 
                key_str
            )

@export var show_wait_str: bool = true:
    set(value):
        show_wait_str = value
        if Engine.is_editor_hint():
            var key_str = actions_property.get_action_key_str(option_symbol.value)
            text = generate_button_string(
                option_symbol.value, 
                seperator_str, 
                key_str
            )

@export var show_button_str: bool = true:
    set(value):
        show_button_str = value
        if Engine.is_editor_hint():
            var key_str = actions_property.get_action_key_str(option_symbol.value)
            text = generate_button_string(
                option_symbol.value, 
                seperator_str, 
                key_str
            )

@export var wait_notify_str: String = "...":
    set(value):
        wait_notify_str = value
        if Engine.is_editor_hint():
            var key_str = actions_property.get_action_key_str(option_symbol.value)
            text = generate_button_string(
                option_symbol.value, 
                seperator_str, 
                key_str
            )

@export var seperator_str: String = "|":
    set(value):
        seperator_str = value
        if Engine.is_editor_hint():
            var key_str = actions_property.get_action_key_str(option_symbol.value)
            text = generate_button_string(
                option_symbol.value, 
                seperator_str, 
                key_str
            )


func _init():

    toggle_mode = true
    toggled.connect(_on_toggled)

    option_symbol = Grumblex.Symbol.new(&"option")
    option_symbol.updated.connect(_on_option_updated)
    actions_property = ActionsProperty.new()

    if Engine.is_editor_hint():
        var key_str = actions_property.get_action_key_str(editor_save[0].value)
        text = generate_button_string(
            option, 
            seperator_str, 
            key_str
        )



func _on_option_updated(_symbol, value):
    print("Button; signal recieved: " + value)
    text = (
        generate_button_string(
            value, 
            seperator_str, 
            actions_property.get_action_key_str(value)
        )
    )

func _ready():
    
    set_process_unhandled_key_input(false)


func _get_property_list():

    var actions_str = ActionsProperty.ActionString.new()
    var hint_string: String = actions_str.value
    var prop_type: int = TYPE_STRING
    var prop_hint: int = PROPERTY_HINT_ENUM
    var properties = []
    
    properties.append({
		"name": option_symbol.symbol,
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
                option, 
                seperator_str, 
                ""
            )
            + wait_notify_str
        )

func _unhandled_key_input(event):
    
    show_button_str = true
    actions_property.remap_key(option, event)
    editor_save = [{
        "symbol": option_symbol.symbol,
        "value": option
        }]
    
    set_pressed(false)
    text = (
        generate_button_string(
            option, 
            seperator_str, 
            actions_property.get_action_key_str(option)
        )
    )

    print(str(event))

