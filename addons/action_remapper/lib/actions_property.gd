@tool
extends RefCounted
class_name ActionsProperty


func _init() -> void:
    
    InputMap.load_from_project_settings()
        

class ActionString:
    var value: String:
        get:
            return compile_actions_str()

    func _init() -> void:
        InputMap.load_from_project_settings()

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

func get_action_key_str(action_str_name: String) -> String:
    var action_key_str: String = ""
    var input_events: Array[InputEvent] = InputMap.action_get_events(action_str_name)
    if input_events:
        action_key_str = input_events[0].as_text()
        action_key_str = action_key_str.replace("(Physical)", "")
    return action_key_str


func remap_key(option_string: String, event:InputEvent) -> void:
    
    InputMap.action_erase_events(option_string)
    InputMap.action_add_event(option_string, event)