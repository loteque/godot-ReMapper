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

    static func compile_actions_str():

        var actions_str = ""

        var delimiter: String = ","

        var actions_array = InputMap.get_actions()
        actions_array.reverse()

        for action in actions_array:
            var actions_partial: String = action + delimiter
            actions_str = actions_str + actions_partial

        actions_str = actions_str.left(actions_str.length() - 1)
        return actions_str


class Device:
    signal updated()
    var set_allowed: bool = false
    var input: String = "":
        get:
            if input == "":
                push_warning("input is empty String")
            return input
        set(value):
            if !set_allowed:
                push_warning("'set' not allowed; use 'set_input_from_inputmap()'")
            else:
                input = value
                updated.emit()


    func set_input_from_inputmap(action_str: String):
        set_allowed = true
        var _input = ""
        var input_events: Array[InputEvent] = InputMap.action_get_events(action_str)
        if input_events:
            _input = input_events[0].as_text()
            _input = _input.replace("(Physical)", "")
        input = _input

    static func get_input_from_inputmap(action_str: String) -> String:
        var _input = ""
        var input_events: Array[InputEvent] = InputMap.action_get_events(action_str)
        if input_events:
            _input = input_events[0].as_text()
            _input = _input.replace("(Physical)", "")              
        return _input

    func remap_input(action_str: String, event:InputEvent) -> String:
        InputMap.action_erase_events(action_str)
        InputMap.action_add_event(action_str, event)
        set_input_from_inputmap(action_str)
        return input
