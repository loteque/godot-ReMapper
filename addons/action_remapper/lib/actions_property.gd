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


class KeyBoard:


    signal updated()
    var set_allowed: bool = false
    var key: String = "":
        get:
            if key == "":
                push_warning("key is empty String")
            return key
        set(value):
            if !set_allowed:
                push_warning("'set' not allowed; use 'set_key_from_inputmap()'")
            else:
                key = value
                updated.emit()


    func set_key_from_inputmap(action_str: String):
        set_allowed = true
        var _key = ""
        var input_events: Array[InputEvent] = InputMap.action_get_events(action_str)
        if input_events:
            _key = input_events[0].as_text()
            _key = _key.replace("(Physical)", "")
        key = _key

    static func get_key_from_inputmap(action_str: String) -> String:
        var _key = ""
        var input_events: Array[InputEvent] = InputMap.action_get_events(action_str)
        if input_events:
            _key = input_events[0].as_text()
            _key = _key.replace("(Physical)", "")              
        return _key

    func remap_key(action_str: String, event:InputEvent) -> String:
        InputMap.action_erase_events(action_str)
        InputMap.action_add_event(action_str, event)
        set_key_from_inputmap(action_str)
        return key